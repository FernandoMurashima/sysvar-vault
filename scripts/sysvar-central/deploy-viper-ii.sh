#!/usr/bin/env bash
# Deploy exclusivamente do Sysvar Central. NAO altera MySQL nem migrations.
set -Eeuo pipefail

ID="${1:-}"
TMP="${2:-}"
if [[ ! "$ID" =~ ^[0-9]{14}$ || "$TMP" != "/tmp/sysvar-central-$ID" ]]; then
  echo 'Identificador de implantacao invalido.' >&2
  exit 2
fi

BACKEND='/srv/projects/sysvar/backend'
FRONTEND='/srv/projects/sysvar/frontend'
ARQUIVO="$TMP/frontend.tgz"
BACKUP="$TMP/frontend-anterior.tgz"
BACK_IMAGE="sysvar-backend:anterior-$ID"
FRONT_IMAGE="sysvar-frontend:anterior-$ID"
BACK_NOVA="sysvar-backend:candidata-$ID"
FRONT_NOVA="sysvar-frontend:candidata-$ID"
frontend_modificado=0
imagens_trocadas=0
publicacao_completa=0

restaurar_artefatos_frontend() {
  [[ $frontend_modificado -eq 1 && -f "$BACKUP" ]] || return 0
  rm -rf -- "$FRONTEND/assets"
  find "$FRONTEND" -maxdepth 1 -type f \( -name 'index.html' -o -name '*.js' -o -name '*.css' -o -name '*.ico' -o -name '*.webmanifest' \) -delete
  tar -xzf "$BACKUP" -C "$FRONTEND"
}

rollback() {
  local status=$?
  trap - ERR
  set +e
  if (( status != 0 )); then
    echo "Falha no deploy (codigo $status). Iniciando restauracao..." >&2
    if (( imagens_trocadas == 1 )); then
      docker tag "$BACK_IMAGE" sysvar-backend:latest
      docker tag "$FRONT_IMAGE" sysvar-frontend:latest
      docker rm -f sysvar-backend sysvar-frontend >/dev/null 2>&1
      (cd "$BACKEND" && docker run -d --name sysvar-backend --restart always --network infra --env-file .env sysvar-backend:latest)
      docker run -d --name sysvar-frontend --restart always --network infra sysvar-frontend:latest
    fi
    restaurar_artefatos_frontend
    echo 'Confira os containers e os logs antes de tentar novamente.' >&2
  fi
  exit "$status"
}
trap rollback ERR

[[ -f "$ARQUIVO" ]] || { echo 'Pacote Angular nao encontrado.' >&2; exit 1; }
[[ -f "$BACKEND/.env" && -f "$FRONTEND/Dockerfile" ]] || { echo 'Configuracao de deploy ausente.' >&2; exit 1; }

# Não sobrescrever configuracoes especiais que nao constem do procedimento oficial.
for nome in sysvar-backend sysvar-frontend; do
  atual="$(docker inspect -f '{{len .Mounts}}|{{len .HostConfig.PortBindings}}|{{.HostConfig.NetworkMode}}|{{.HostConfig.RestartPolicy.Name}}' "$nome")"
  [[ "$atual" == '0|0|infra|always' ]] || { echo "Configuracao nao prevista: $nome ($atual)" >&2; exit 1; }
done
docker inspect mysql >/dev/null
[[ "$(git -C "$BACKEND" branch --show-current)" == 'main' ]] || { echo 'Branch remota nao e main.' >&2; exit 1; }
[[ -z "$(git -C "$BACKEND" status --porcelain)" ]] || { echo 'Alteracoes locais no Backend Ubuntu; abortado.' >&2; exit 1; }
[[ "$(git -C "$BACKEND" remote get-url origin)" == *'FernandoMurashima/sysvarbackend.git' ]] || { echo 'Git remoto diferente do previsto.' >&2; exit 1; }
tar -tzf "$ARQUIVO" | grep -E '^\./index\.html$' >/dev/null || { echo 'Pacote Angular invalido.' >&2; exit 1; }

printf 'Atualizando Backend via Git...\n'
git -C "$BACKEND" fetch origin main
git -C "$BACKEND" merge-base --is-ancestor HEAD origin/main || { echo 'Backend divergente do GitHub; abortado.' >&2; exit 1; }
git -C "$BACKEND" pull --ff-only origin main

printf 'Compilando imagem candidata do Backend...\n'
docker build -t "$BACK_NOVA" "$BACKEND"

printf 'Guardando artefatos antigos do Frontend...\n'
tar -czf "$BACKUP" -C "$FRONTEND" .
frontend_modificado=1
rm -rf -- "$FRONTEND/assets"
find "$FRONTEND" -maxdepth 1 -type f \( -name 'index.html' -o -name '*.js' -o -name '*.css' -o -name '*.ico' -o -name '*.webmanifest' \) -delete
tar -xzf "$ARQUIVO" -C "$FRONTEND"
[[ -f "$FRONTEND/index.html" ]] || { echo 'Frontend nao extraido corretamente.' >&2; false; }

printf 'Compilando imagem candidata do Frontend...\n'
docker build -t "$FRONT_NOVA" "$FRONTEND"

printf 'Salvando imagens em execucao para rollback...\n'
docker tag "$(docker inspect -f '{{.Image}}' sysvar-backend)" "$BACK_IMAGE"
docker tag "$(docker inspect -f '{{.Image}}' sysvar-frontend)" "$FRONT_IMAGE"
imagens_trocadas=1
docker tag "$BACK_NOVA" sysvar-backend:latest
docker tag "$FRONT_NOVA" sysvar-frontend:latest

printf 'Substituindo containers Sysvar Central...\n'
docker rm -f sysvar-backend
(cd "$BACKEND" && docker run -d --name sysvar-backend --restart always --network infra --env-file .env sysvar-backend:latest)
docker exec sysvar-backend python manage.py check

docker rm -f sysvar-frontend
docker run -d --name sysvar-frontend --restart always --network infra sysvar-frontend:latest

# Verificacoes basicas sem migrations e sem operacoes no banco.
[[ "$(docker inspect -f '{{.State.Running}}' sysvar-backend)" == 'true' ]]
[[ "$(docker inspect -f '{{.State.Running}}' sysvar-frontend)" == 'true' ]]
curl -fsSI --max-time 15 -H 'Host: sysvar.com.br' http://127.0.0.1/ >/dev/null

echo 'Central atualizada. Banco nao alterado. Verificar migracoes pendentes antes de homologar.'
git -C "$BACKEND" log -1 --format='Backend commit: %h %s'
docker ps --filter name=sysvar --format 'table {{.Names}}\t{{.Status}}'
publicacao_completa=1
trap - ERR