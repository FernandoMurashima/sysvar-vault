---
name: atualizar-sysvar-central-viper-ii
description: Orienta passo a passo a atualização do Sysvar Central no Ubuntu Viper-II, usando Git apenas para o backend, build Angular no notebook Windows, SCP para frontend e reconstrução dos dois containers Docker. Use quando o usuário pedir atualizar, publicar ou sincronizar a versão da Central no Ubuntu. Banco de dados somente em etapa separada, explícita e autorizada.
---

# Atualizar Sysvar Central no Viper-II

## Objetivo e comportamento

Guiar o operador com **um passo por vez**, contendo somente comandos daquele passo e a verificação; aguardar o retorno antes de avançar. Responder em português brasileiro, direto, sem textos longos ou perguntas já respondidas pela documentação. Diferenciar claramente comandos do **PowerShell Windows** e do **Bash Ubuntu**. Não executar comandos no servidor sem o pedido e autorização do usuário; não presumir que Git, build, container ou migration concluíram sem ler a saída.

**Escopo: Sysvar CENTRAL, NÃO Sysvar Hub.** O Hub roda nos computadores das lojas. O Ubuntu Viper-II hospeda Central Django e Angular em containers Docker e um MySQL compartilhado com outros serviços: **não tocar nos sistemas Bolão, Webfoto, Redis, Portainer, Nginx Proxy Manager ou no volume do MySQL**.

## Fonte de verdade — consultar toda vez

1. Cofre: `FernandoMurashima/sysvar-vault` (branch `main`), arquivo `takeshi/10 Projetos/Sysvar/Operacao/Atualizacao do Sysvar no Viper-II.md` (procedimento oficial, atualizado em 2026-08-11).
2. Cofre: `takeshi/90 Sistema/Mapa de Consulta por Projeto.md` (locais e repositórios atuais).
3. Skill `sysvar-contexto` existente, se acessível; ler documentação pertinente, sem pedir caminhos que já constam aqui.
4. Repositório Central Backend: `FernandoMurashima/sysvarbackend`, `AGENTS.md` e `Dockerfile` atuais.
5. Repositório Central Frontend: `FernandoMurashima/sysvarfrontend`, `sysvar/angular.json` e `sysvar/package.json` atuais.

Se não puder abrir fonte vigente, dizer qual está indisponível; não inventar procedimentos. O runbook é autoridade para o deploy. Decisões explícitas do usuário nesta conversa prevalecem onde não infringirem requisitos de segurança.

## Topologia oficial

| Camada | Desenvolvimento Windows | Viper-II Ubuntu | Docker |
|---|---|---|---|
| Backend Central | `C:\SysvarProjeto\Backend` (Git `sysvarbackend/main`) | `/srv/projects/sysvar/backend` (Git) | `sysvar-backend`, imagem `sysvar-backend:latest` |
| Frontend Central | `C:\SysvarProjeto\Frontend\sysvar` (Git `sysvarfrontend/main`) | `/srv/projects/sysvar/frontend` (**arquivos compilados, sem Git**) | `sysvar-frontend`, imagem `sysvar-frontend:latest` |
| Banco Central | — | MySQL no container `mysql`, base `varejo_db` no runbook | **preservar até ordem explícita de reconstrução** |

- SSH: `fernando-murashima@192.168.1.135` (IP atualizado conforme confirmação do operador em 2026-10-16).
- Rede Docker: `infra`; política de restart `always`.
- Domínio: `https://sysvar.com.br`; host interno HTTP `sysvar.com.br`.
- Frontend de produção: compilado no **Windows** com `ng build`; saída `dist\sysvar\browser\*`, enviada por **SCP**, não por `git pull` no Ubuntu.
- `backend/.env` do Ubuntu: conservar no local, sem ler, exibir, enviar, substituir ou versionar seus segredos.
- Nunca copiar o diretório do projeto Angular inteiro para `/srv/projects/sysvar/frontend`; copiar apenas o conteúdo de `dist/sysvar/browser`.

## Roteiro — comandos por etapa; não mostrar tudo de uma vez

### 0. Pré-checagens, sem mutação

Bash Viper-II:

```bash
cd /srv/projects/sysvar/backend
git status -sb
git remote -v
git log -1 --oneline
docker ps --format 'table {{.Names}}\t{{.Status}}'
docker network inspect infra --format '{{.Name}}'
```

Confirmar working tree sem alterações não autorizadas; `origin` aponta para `FernandoMurashima/sysvarbackend`. Se houver arquivos modificados, **parar**, não executar `git reset --hard`, `git clean -fd`, nem `git stash` sem autorização. Identificar estado das imagens e configuração existentes se necessário, sem expor credenciais. Verificar que `sysvar-backend`, `sysvar-frontend` e `mysql` executam. Não pedir `git status` no diretório do Frontend do Ubuntu (ele não é repositório).

### 1. Backend — Git no Ubuntu

Somente após pré-checagem aprovada:

```bash
cd /srv/projects/sysvar/backend
git fetch origin main
git log --oneline --max-count=5 HEAD..origin/main
git pull --ff-only origin main
git log -1 --oneline
```

Se houver conflito ou erro, **parar**; não alterar Git à força. Verificar se build e dependências se mantêm coerentes.

### 2. Backend — Docker no Ubuntu

```bash
cd /srv/projects/sysvar/backend
docker build -t sysvar-backend:latest .
```

Esperar sucesso completo. Antes de remover o container antigo, obter confirmação do usuário sobre a janela de indisponibilidade. O comando abaixo reproduz o procedimento documentado e mantém `.env`, nome, restart e rede; confirmar com `docker inspect` se há montagens ou parâmetros adicionais antes de substituir:

```bash
docker rm -f sysvar-backend
docker run -d \
  --name sysvar-backend \
  --restart always \
  --network infra \
  --env-file .env \
  sysvar-backend:latest
```

Verificações:

```bash
docker exec sysvar-backend python manage.py check
docker logs sysvar-backend --tail 50
docker ps --filter name=sysvar-backend
```

**Migrations:** O runbook oficial inclui `docker exec sysvar-backend python manage.py migrate`. Porém o `AGENTS.md` do backend exige autorização explícita para migrations em produção. Na operação atual, o usuário decidiu **reconstruir o banco somente após atualizar Backend e Frontend**. Portanto, **não executar `migrate` agora automaticamente**. Se a aplicação depender de schema novo, informar risco e planejar a migração/reconstrução antes de liberar uso; pedir autorização. Mesmo se a tela subir, não declarar homologação sem dados e schema compatíveis.

### 3. Frontend — build no Windows

No PowerShell do notebook de desenvolvimento:

```powershell
cd C:\SysvarProjeto\Frontend\sysvar
ng build
Test-Path .\dist\sysvar\browser\index.html
```

Se `ng` não estiver no PATH, confirmar as dependências e usar `npx.cmd ng build` quando apropriado. Só prosseguir com build bem-sucedido e `True`. **Não executar Git no `/srv/projects/sysvar/frontend` do Ubuntu.**

### 4. Frontend — SCP a partir do Windows

O runbook oficial limpa apenas artefatos Angular conhecidos no destino e transfere o build. Antes da limpeza confirmar o caminho e se `/srv/projects/sysvar/frontend` é exclusivo do Sysvar. No PowerShell:

```powershell
ssh fernando-murashima@192.168.1.135 "rm -rf /srv/projects/sysvar/frontend/assets /srv/projects/sysvar/frontend/index.html /srv/projects/sysvar/frontend/main-*.js /srv/projects/sysvar/frontend/polyfills-*.js /srv/projects/sysvar/frontend/styles-*.css /srv/projects/sysvar/frontend/favicon.ico"
scp -r C:\SysvarProjeto\Frontend\sysvar\dist\sysvar\browser\* fernando-murashima@192.168.1.135:/srv/projects/sysvar/frontend/
```

Confirmar sucesso do `scp` antes da reconstrução. Se nomes dos artefatos mudaram ou o destino contém material não previsto, interromper e revisar antes de apagar. Nunca usar `rm -rf /srv/projects/sysvar/frontend` nem apagar outros projetos.

### 5. Frontend — Docker no Ubuntu

```bash
cd /srv/projects/sysvar/frontend
docker build -t sysvar-frontend:latest .
```

Esperar sucesso. Antes de substituir, confirmar que `docker inspect sysvar-frontend` não aponta para mounts ou parâmetros adicionais não previstos. Após confirmação:

```bash
docker rm -f sysvar-frontend
docker run -d \
  --name sysvar-frontend \
  --restart always \
  --network infra \
  sysvar-frontend:latest
```

### 6. Teste do deploy

Bash Ubuntu:

```bash
docker ps --format 'table {{.Names}}\t{{.Status}}'
docker logs sysvar-backend --tail 50
docker logs sysvar-frontend --tail 50
curl -I -H 'Host: sysvar.com.br' http://127.0.0.1/
curl -I -H 'Host: sysvar.com.br' http://127.0.0.1/admin/
```

PowerShell Windows:

```powershell
curl.exe -I https://sysvar.com.br
```

Conferir login, menus, consultas, cadastros, API e funcionalidade alterada. Quando migrations estiverem pendentes, reportar *deploy de código concluído, operação funcional ainda pendente de banco*, sem declarar Central homologada.

### 7. Reconstrução do banco — FASE FINAL E SEPARADA

O usuário determinou para este ciclo: **reconstruir o banco ao final da atualização da aplicação**, nunca no começo. Antes de qualquer ação destrutiva:

1. Inspecionar documentação oficial específica de instalação/reconstrução e conferir container MySQL e identificação exata da base **somente leitura**.
2. Identificar `varejo_db` e confirmar que os demais bancos/serviços no container `mysql` não serão afetados.
3. Solicitar confirmação explícita da reconstrução de **base de teste** e do destino. Não assumir autorização prévia genérica para executar `DROP DATABASE`/apagar volume; confirmar no momento.
4. Só após aprovação apresentar o roteiro documentado de recriação, migrations e seeds. Se esse roteiro não estiver documentado, não inventar comandos perigosos; buscar a fonte ou solicitar informação estritamente essencial.
5. Nunca executar `docker volume rm`, `docker system prune`, `DROP DATABASE` em outras bases, nem eliminar dados de Bolão, Webfoto ou de terceiros. Não copiar nem divulgar passwords e dumps.

### 8. Encerramento

Dar resposta curta com commit do backend aplicado, confirmação de build Angular enviado, containers, checagens, migrations (executadas ou adiadas), e reconstrução do banco (pendente ou homologada); não confundir implantação técnica com backup/recuperação do **Hub**.

## Regras essenciais

- Um passo por vez; depois de cada comando, aguardar a saída do usuário.
- Não solicitar informações já documentadas (especialmente o motivo de o frontend Ubuntu não ter `.git`).
- Uma falha interrompe a sequência: diagnosticar antes de continuar.
- Não executar `docker compose down`, `docker system prune`, `docker volume prune`, reiniciar o MySQL, atualizar pacotes do Ubuntu ou Docker como parte do deploy de aplicação.
- A decisão de reconstruir a base **ao final** é específica deste ciclo; em outros ciclos confirmar antes de executar qualquer tarefa destrutiva.