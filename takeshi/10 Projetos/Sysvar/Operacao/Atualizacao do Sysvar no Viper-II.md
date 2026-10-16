---
type: procedure
status: active
project: Sysvar
category: operacao
created: 2026-08-11
updated: 2026-10-16
tags:
  - sysvar
  - deploy
  - backend
  - frontend
  - viper-ii
  - docker
  - github
  - angular
---

# Atualizacao do Sysvar no Viper-II

# ATUALIZACAO AUTOMATIZADA (OPCIONAL)

Scripts versionados no cofre:
- `scripts/sysvar-central/atualizar-central.ps1` (executado no Windows).
- `scripts/sysvar-central/deploy-viper-ii.sh` (auxiliar enviado por SSH).

No PowerShell do notebook, com o cofre local atualizado:

```powershell
& "C:\Takeshi\scripts\sysvar-central\atualizar-central.ps1"
```

Apenas apos a verificacao ser aprovada e na janela de manutencao:

```powershell
& "C:\Takeshi\scripts\sysvar-central\atualizar-central.ps1" -Aplicar
```

O script usa `192.168.1.135`, confere os Git locais, compila o Angular, atualiza o Backend Git no Ubuntu, cria as imagens Docker, substitui apenas os dois containers da Central e tenta restaurar imagens anteriores se o deploy falhar. Pode solicitar senha SSH mais de uma vez.

**Nao executa migrations, nao recria banco e nao altera o container MySQL.** Recriacao da base permanece etapa final, separada e autorizada. Antes da primeira implantacao real, testar o modo de verificacao.

# BACKEND

## NO NOTEBOOK DE DESENVOLVIMENTO - WINDOWS

```powershell
cd C:\SysvarProjeto\Backend

git add .
git commit -m "Atualiza Backend Sysvar"
git push origin main
```

## ENTRAR NO VIPER-II

```powershell
ssh fernando-murashima@192.168.1.135
```

## JÁ DENTRO DO VIPER-II

```bash
cd /srv/projects/sysvar/backend

git pull origin main

docker build -t sysvar-backend:latest .

docker rm -f sysvar-backend

docker run -d \
  --name sysvar-backend \
  --restart always \
  --network infra \
  --env-file .env \
  sysvar-backend:latest

docker exec sysvar-backend python manage.py migrate

docker exec sysvar-backend python manage.py check

docker logs sysvar-backend --tail 50

docker ps | grep sysvar
```

# FRONTEND

## NO NOTEBOOK DE DESENVOLVIMENTO - WINDOWS

```powershell
cd C:\SysvarProjeto\Frontend\sysvar

ng build

ssh fernando-murashima@192.168.1.135 "rm -rf /srv/projects/sysvar/frontend/assets /srv/projects/sysvar/frontend/index.html /srv/projects/sysvar/frontend/main-*.js /srv/projects/sysvar/frontend/polyfills-*.js /srv/projects/sysvar/frontend/styles-*.css /srv/projects/sysvar/frontend/favicon.ico"

scp -r C:\SysvarProjeto\Frontend\sysvar\dist\sysvar\browser\* fernando-murashima@192.168.1.135:/srv/projects/sysvar/frontend/

ssh fernando-murashima@192.168.1.135
```

## JÁ DENTRO DO VIPER-II

```bash
cd /srv/projects/sysvar/frontend

docker build -t sysvar-frontend:latest .

docker rm -f sysvar-frontend

docker run -d \
  --name sysvar-frontend \
  --restart always \
  --network infra \
  sysvar-frontend:latest

docker ps | grep sysvar

curl -I \
  -H "Host: sysvar.com.br" \
  http://127.0.0.1/
```

# TESTE FINAL

```bash
curl -I \
  -H "Host: sysvar.com.br" \
  http://127.0.0.1/admin/
```

No notebook de desenvolvimento:

```powershell
curl.exe -I https://sysvar.com.br
```

Acessar no navegador:

```text
https://sysvar.com.br
```

Validar:

```text
login
menus
consultas
cadastros
API
dados
funcionalidade alterada
```

# FLUXO

```text
BACKEND

C:\SysvarProjeto\Backend
        ↓
git push
        ↓
GitHub
FernandoMurashima/sysvarbackend
        ↓
git pull no Viper-II
        ↓
docker build
        ↓
sysvar-backend
        ↓
migrate
```

```text
FRONTEND

C:\SysvarProjeto\Frontend\sysvar
        ↓
ng build
        ↓
dist\sysvar\browser
        ↓
scp
        ↓
/srv/projects/sysvar/frontend
        ↓
docker build
        ↓
sysvar-frontend
```

# ENDERECOS

```text
Servidor:
Viper-II

IP:
192.168.1.135

Backend:
 /srv/projects/sysvar/backend

Frontend:
 /srv/projects/sysvar/frontend

Backend container:
sysvar-backend

Frontend container:
sysvar-frontend

Backend image:
sysvar-backend:latest

Frontend image:
sysvar-frontend:latest

Rede Docker:
infra

Banco:
varejo_db

Domínio:
https://sysvar.com.br
https://www.sysvar.com.br
```

[[Sysvar]]