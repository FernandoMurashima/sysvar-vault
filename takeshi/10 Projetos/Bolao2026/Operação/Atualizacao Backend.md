---
type: procedure
status: active
project: Bolao2026
category: operacao
created: 2026-08-10
updated: 2026-08-10
tags:
  - bolao2026
  - operacao
  - backend
  - deploy
  - django
  - docker
  - github
---

# Atualizacao Backend

## Objetivo

Este procedimento deve ser utilizado sempre que houver alteração no backend do **Bolao2026** no notebook de desenvolvimento e for necessário publicar essa alteração no servidor de produção `Viper-II`.

O fluxo utilizado é:

```text
Notebook de desenvolvimento
        ↓
GitHub
        ↓
Viper-II
        ↓
git pull
        ↓
docker build
        ↓
recriação do bolao-backend
        ↓
Django migrate
        ↓
validação
```

---

# Ambiente de desenvolvimento

Diretório do backend no notebook de desenvolvimento:

```text
C:\bolao2026\backend
```

---

# Ambiente de produção

Servidor:

```text
Viper-II
```

IP local:

```text
192.168.15.80
```

Usuário:

```text
fernando-murashima
```

Diretório do backend no servidor:

```text
/srv/projects/copa/backend
```

Imagem Docker:

```text
bolao-backend:latest
```

Container:

```text
bolao-backend
```

Rede Docker:

```text
infra
```

---

# Procedimento completo

Executar os comandos abaixo exatamente nesta ordem.

```powershell
# ============================================================
# NO NOTEBOOK DE DESENVOLVIMENTO - WINDOWS
# ============================================================

cd C:\bolao2026\backend

git add .

git commit -m "Atualiza backend Bolao"

git push origin main


# ============================================================
# ENTRAR NO SERVIDOR VIPER-II
# ============================================================

ssh fernando-murashima@192.168.15.80


# ============================================================
# JÁ DENTRO DO VIPER-II
# ============================================================

cd /srv/projects/copa/backend

git pull origin main

docker build -t bolao-backend:latest .

docker rm -f bolao-backend

docker run -d \
  --name bolao-backend \
  --restart always \
  --network infra \
  bolao-backend:latest

docker exec bolao-backend python manage.py migrate

docker logs bolao-backend --tail 50

docker ps | grep bolao
```

---

# Explicação resumida de cada etapa

## 1. Entrar no backend local

```powershell
cd C:\bolao2026\backend
```

---

## 2. Preparar alterações para o Git

```powershell
git add .
```

---

## 3. Criar commit

```powershell
git commit -m "Atualiza backend Bolao"
```

A mensagem pode ser alterada para algo mais específico.

Exemplo:

```powershell
git commit -m "Corrige pontuacao dos palpites"
```

---

## 4. Enviar para o GitHub

```powershell
git push origin main
```

A partir desse momento, a versão nova está disponível no repositório.

---

# Entrar no servidor

```powershell
ssh fernando-murashima@192.168.15.80
```

---

# Atualizar o código no Viper-II

Entrar na pasta:

```bash
cd /srv/projects/copa/backend
```

Atualizar:

```bash
git pull origin main
```

Esse comando baixa para o Viper-II as alterações enviadas anteriormente pelo notebook de desenvolvimento.

---

# Construir a nova imagem

```bash
docker build -t bolao-backend:latest .
```

Esse comando utiliza:

```text
/srv/projects/copa/backend/Dockerfile
```

e gera uma nova imagem:

```text
bolao-backend:latest
```

---

# Remover o container antigo

```bash
docker rm -f bolao-backend
```

Esse comando remove apenas o container backend atual.

Ele não remove:

```text
banco MySQL
frontend
Cloudflare
Nginx Proxy Manager
dados do banco
```

---

# Criar o novo container

```bash
docker run -d \
  --name bolao-backend \
  --restart always \
  --network infra \
  bolao-backend:latest
```

O nome deve permanecer:

```text
bolao-backend
```

A rede deve permanecer:

```text
infra
```

Isso é necessário para que o frontend consiga acessar:

```text
http://bolao-backend:8001
```

e para que o backend consiga acessar:

```text
mysql
```

---

# Aplicar migrations

Depois que o novo container subir:

```bash
docker exec bolao-backend python manage.py migrate
```

Esse comando deve ser executado mesmo que não tenha certeza se existem migrations novas.

Se não houver migrations pendentes, o Django apenas informará que não existe nada a aplicar.

---

# Verificar logs

```bash
docker logs bolao-backend --tail 50
```

O esperado é encontrar algo semelhante a:

```text
Starting gunicorn
Listening at: http://0.0.0.0:8001
Using worker: sync
Booting worker
```

---

# Confirmar container

```bash
docker ps | grep bolao
```

Devem aparecer:

```text
bolao-backend
bolao-frontend
```

---

# Validação do backend

Depois do deploy, executar:

```bash
docker run --rm \
  --network infra \
  curlimages/curl:latest \
  -I \
  -H "Host: fernandomurashima.com.br" \
  http://bolao-backend:8001/admin/
```

Esperado:

```text
HTTP/1.1 302 Found
```

---

# Validação do sistema completo

Executar no Viper-II:

```bash
curl -I \
  -H "Host: fernandomurashima.com.br" \
  http://127.0.0.1/
```

Esperado:

```text
HTTP/1.1 200 OK
```

---

# Teste público

No navegador:

```text
https://fernandomurashima.com.br
```

ou no Windows:

```powershell
curl.exe -I https://fernandomurashima.com.br
```

---

# Teste funcional

Depois de uma alteração importante no backend, validar:

```text
login
consulta de jogos
palpites
resultados
funcionalidade alterada
dados retornados pela API
```

---

# Quando existem alterações em models.py

No notebook de desenvolvimento, antes do commit, deve existir a migration correspondente.

Fluxo correto:

```text
alterar models.py
        ↓
python manage.py makemigrations
        ↓
testar localmente
        ↓
git add
        ↓
git commit
        ↓
git push
```

No Viper-II:

```text
git pull
        ↓
docker build
        ↓
recriar container
        ↓
python manage.py migrate
```

---

# Verificar migrations antes do deploy

Opcionalmente no ambiente de desenvolvimento:

```powershell
python manage.py showmigrations
```

Depois:

```powershell
python manage.py migrate
```

para validar localmente antes de enviar.

---

# Verificar migrations no Viper-II

```bash
docker exec bolao-backend python manage.py showmigrations
```

---

# Verificar migrations pendentes

```bash
docker exec bolao-backend python manage.py migrate --check
```

---

# Django check

Depois do deploy:

```bash
docker exec bolao-backend python manage.py check
```

---

# Se o git pull apresentar conflito

Não continuar automaticamente com o deploy.

Primeiro verificar:

```bash
git status
```

Não utilizar:

```bash
git reset --hard
```

sem entender o que será descartado.

O diretório de produção deve normalmente acompanhar o repositório sem alterações manuais.

---

# Se git pull disser Already up to date

Isso significa que o Viper-II já possui o último commit disponível no GitHub.

Verificar se o `git push` realmente foi realizado no notebook de desenvolvimento.

---

# Se git commit disser nothing to commit

Isso normalmente significa que não existem alterações locais não commitadas.

Verificar:

```powershell
git status
```

---

# Se o docker build falhar

Não remover o container atual antes de resolver o erro.

A ordem correta é:

```text
git pull
↓
docker build
↓ SOMENTE SE O BUILD FUNCIONAR
docker rm -f bolao-backend
```

Se o build falhar, o container antigo continua atendendo a aplicação.

---

# Regra importante de segurança do deploy

Sempre executar:

```bash
docker build -t bolao-backend:latest .
```

antes de:

```bash
docker rm -f bolao-backend
```

Nunca remover primeiro o container e só depois descobrir que a nova imagem não consegue ser construída.

---

# Se o novo container não subir

Ver:

```bash
docker ps -a | grep bolao-backend
```

Depois:

```bash
docker logs bolao-backend --tail 100
```

Possíveis causas:

```text
erro Python
dependency ausente
erro no settings.py
erro de banco
migration
erro no código
```

---

# Se houver erro de conexão com MySQL

Verificar:

```bash
docker ps | grep mysql
```

Depois:

```bash
docker network inspect infra
```

Devem aparecer:

```text
bolao-backend
mysql
```

No Django:

```text
HOST = mysql
```

---

# Se houver erro após migrate

Verificar:

```bash
docker logs bolao-backend --tail 100
```

Depois:

```bash
docker exec bolao-backend python manage.py showmigrations
```

---

# Rollback simples de código

Caso a nova versão apresente problema e seja necessário retornar o código, o rollback deve ser feito preferencialmente pelo Git.

No ambiente de desenvolvimento:

```text
corrigir ou reverter o commit
↓
git push
↓
novo deploy
```

Evitar alterar manualmente arquivos dentro do container.

---

# Não editar arquivos dentro do container

Não utilizar o container como ambiente de desenvolvimento.

A fonte oficial deve permanecer:

```text
C:\bolao2026\backend
```

e:

```text
GitHub
```

O Viper-II recebe a versão versionada pelo Git.

---

# O que não precisa ser alterado

Durante uma atualização normal do backend, não mexer em:

```text
frontend
DNS
Cloudflare
Cloudflare Tunnel
Nginx Proxy Manager
MySQL
Registro.br
```

---

# Banco não é recriado

O processo:

```bash
docker rm -f bolao-backend
```

não remove o banco de dados.

O MySQL está em outro container.

Banco:

```text
bolao2026
```

permanece intacto.

---

# Reinício manual sem atualização

Se não houver mudança de código e for necessário apenas reiniciar o backend:

```bash
docker restart bolao-backend
```

Não é necessário:

```text
git pull
docker build
docker rm
docker run
```

---

# Logs em tempo real após deploy

```bash
docker logs -f bolao-backend
```

Para sair:

```text
Ctrl+C
```

---

# Ver recursos do container

```bash
docker stats bolao-backend
```

---

# Conferir imagem criada

```bash
docker images | grep bolao-backend
```

---

# Checklist antes do deploy

```text
[ ] alteração testada no desenvolvimento
[ ] migrations criadas, se necessárias
[ ] git status revisado
[ ] commit realizado
[ ] push realizado
```

---

# Checklist no Viper-II

```text
[ ] git pull executado
[ ] docker build concluído com sucesso
[ ] container antigo removido
[ ] novo container criado
[ ] migrate executado
[ ] logs verificados
[ ] container UP
[ ] teste HTTP realizado
[ ] aplicação testada no navegador
```

---

# Procedimento rápido

Para uso cotidiano, este é o bloco principal:

```powershell
# ===== DESENVOLVIMENTO =====

cd C:\bolao2026\backend

git add .
git commit -m "Atualiza backend Bolao"
git push origin main

ssh fernando-murashima@192.168.15.80
```

Depois, no Viper-II:

```bash
cd /srv/projects/copa/backend

git pull origin main

docker build -t bolao-backend:latest .

docker rm -f bolao-backend

docker run -d \
  --name bolao-backend \
  --restart always \
  --network infra \
  bolao-backend:latest

docker exec bolao-backend python manage.py migrate

docker logs bolao-backend --tail 50

docker ps | grep bolao
```

---

# Fluxo final

```text
C:\bolao2026\backend
        ↓
Git
        ↓
GitHub
        ↓
/srv/projects/copa/backend
        ↓
Docker build
        ↓
bolao-backend:latest
        ↓
bolao-backend
        ↓
Django migrate
        ↓
validação
```

---

# Estado esperado após atualização

```text
Backend:
bolao-backend

Status:
Up

Imagem:
bolao-backend:latest

Rede:
infra

Banco:
mysql / bolao2026

Domínio:
fernandomurashima.com.br

Frontend:
permanece inalterado

Status final:
PRODUÇÃO OPERACIONAL
```

---

# Documentos relacionados

- [[Bolao2026]]
- [[Operação/Operacao do Bolao]]
- [[Operação/Atualizacao Frontend]]
- [[Infraestrutura/Docker]]
- [[Infraestrutura/Banco de Dados]]
- [[Decisões Técnicas/Arquitetura de Producao]]