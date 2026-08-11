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
  - frontend
  - deploy
  - angular
  - docker
  - scp
---

# Atualizacao Frontend

## Objetivo

Este procedimento deve ser utilizado sempre que houver alteração no frontend do **Bolao2026** no notebook de desenvolvimento e for necessário publicar essa alteração no servidor de produção `Viper-II`.

O fluxo utilizado é:

```text
Notebook de desenvolvimento
        ↓
ng build
        ↓
build Angular
        ↓
SCP
        ↓
Viper-II
        ↓
/srv/projects/copa/frontend/browser
        ↓
docker build
        ↓
recriação do bolao-frontend
        ↓
validação
```

---

# Ambiente de desenvolvimento

Diretório do frontend:

```text
C:\bolao2026\frontend
```

O build é realizado no notebook de desenvolvimento.

O servidor Viper-II não é utilizado para compilar o Angular.

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

Diretório do frontend no servidor:

```text
/srv/projects/copa/frontend
```

Diretório do build:

```text
/srv/projects/copa/frontend/browser
```

Imagem Docker:

```text
bolao-frontend:latest
```

Container:

```text
bolao-frontend
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

cd C:\bolao2026\frontend

ng build


# ============================================================
# LIMPAR BUILD ANTIGO NO VIPER-II
# ============================================================

ssh fernando-murashima@192.168.15.80 "rm -rf /srv/projects/copa/frontend/browser/*"


# ============================================================
# COPIAR NOVO BUILD PARA O VIPER-II
# ============================================================

scp -r C:\bolao2026\frontend\dist\bolao2026\browser\* fernando-murashima@192.168.15.80:/srv/projects/copa/frontend/browser/


# ============================================================
# ENTRAR NO SERVIDOR VIPER-II
# ============================================================

ssh fernando-murashima@192.168.15.80


# ============================================================
# JÁ DENTRO DO VIPER-II
# ============================================================

cd /srv/projects/copa/frontend

docker build -t bolao-frontend:latest .

docker rm -f bolao-frontend

docker run -d \
  --name bolao-frontend \
  --restart always \
  --network infra \
  bolao-frontend:latest

docker ps | grep bolao

curl -I \
  -H "Host: fernandomurashima.com.br" \
  http://127.0.0.1/
```

---

# Explicação resumida do procedimento

## 1. Entrar no frontend local

```powershell
cd C:\bolao2026\frontend
```

---

## 2. Gerar o build Angular

```powershell
ng build
```

Esse comando gera os arquivos finais do frontend.

O diretório esperado é:

```text
C:\bolao2026\frontend\dist\bolao2026\browser
```

---

# Verificar se o build foi gerado

No PowerShell:

```powershell
Get-ChildItem C:\bolao2026\frontend\dist\bolao2026\browser
```

Devem existir arquivos como:

```text
index.html
main*.js
chunk*.js
styles*.css
assets
```

A estrutura pode variar conforme a versão do Angular.

---

# Limpar o build antigo no Viper-II

Antes de copiar o novo build:

```powershell
ssh fernando-murashima@192.168.15.80 "rm -rf /srv/projects/copa/frontend/browser/*"
```

Esse comando remove somente os arquivos antigos do build Angular.

Ele não remove:

```text
Dockerfile
nginx.conf
backend
banco
container MySQL
Cloudflare
Nginx Proxy Manager
```

---

# Copiar o novo build

```powershell
scp -r C:\bolao2026\frontend\dist\bolao2026\browser\* fernando-murashima@192.168.15.80:/srv/projects/copa/frontend/browser/
```

O destino será:

```text
/srv/projects/copa/frontend/browser
```

---

# Por que utilizar SCP

O frontend enviado para produção é o build final do Angular.

Não é necessário copiar todo o projeto de desenvolvimento.

O servidor recebe apenas:

```text
HTML
JavaScript
CSS
assets
fontes
imagens
```

Isso evita necessidade de manter Node.js e Angular CLI para build no servidor de produção.

---

# Entrar no Viper-II

```powershell
ssh fernando-murashima@192.168.15.80
```

---

# Entrar na pasta do frontend

```bash
cd /srv/projects/copa/frontend
```

---

# Verificar arquivos recebidos

Opcionalmente:

```bash
ls -lah /srv/projects/copa/frontend/browser | head -30
```

Confirmar principalmente:

```text
index.html
arquivos .js
arquivos .css
```

---

# Construir a nova imagem Docker

```bash
docker build -t bolao-frontend:latest .
```

Esse comando utiliza:

```text
/srv/projects/copa/frontend/Dockerfile
```

e copia:

```text
browser/
```

para dentro da nova imagem.

---

# Dockerfile utilizado

```dockerfile
FROM nginx:alpine

COPY nginx.conf /etc/nginx/conf.d/default.conf

COPY browser/ /usr/share/nginx/html/
```

---

# Regra importante do deploy

Primeiro executar:

```bash
docker build -t bolao-frontend:latest .
```

Somente depois de o build Docker terminar com sucesso executar:

```bash
docker rm -f bolao-frontend
```

Isso evita tirar o frontend atual do ar caso a nova imagem tenha algum problema de construção.

---

# Remover o container frontend antigo

```bash
docker rm -f bolao-frontend
```

Esse comando remove o container antigo.

Ele não remove:

```text
backend
MySQL
banco bolao2026
Nginx Proxy Manager
Cloudflare Tunnel
DNS
```

---

# Criar o novo frontend

```bash
docker run -d \
  --name bolao-frontend \
  --restart always \
  --network infra \
  bolao-frontend:latest
```

O nome deve permanecer:

```text
bolao-frontend
```

A rede deve permanecer:

```text
infra
```

Isso é importante porque o Nginx Proxy Manager encaminha para:

```text
bolao-frontend:80
```

---

# Verificar containers

```bash
docker ps | grep bolao
```

Esperado:

```text
bolao-backend
bolao-frontend
```

---

# Verificar logs do frontend

```bash
docker logs bolao-frontend --tail 50
```

Em tempo real:

```bash
docker logs -f bolao-frontend
```

Sair:

```text
Ctrl+C
```

---

# Testar o frontend diretamente

```bash
docker run --rm \
  --network infra \
  curlimages/curl:latest \
  -I \
  -H "Host: fernandomurashima.com.br" \
  http://bolao-frontend/
```

Esperado:

```text
HTTP/1.1 200 OK
```

---

# Testar comunicação com backend

```bash
docker run --rm \
  --network infra \
  curlimages/curl:latest \
  -I \
  -H "Host: fernandomurashima.com.br" \
  http://bolao-frontend/admin/
```

Esperado:

```text
HTTP/1.1 302 Found
```

Isso confirma:

```text
bolao-frontend
        ↓
bolao-backend
```

---

# Testar através do Nginx Proxy Manager

No Viper-II:

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

No Windows:

```powershell
curl.exe -I https://fernandomurashima.com.br
```

Esperado:

```text
HTTP/1.1 200 OK
Server: cloudflare
```

---

# Teste no navegador

Abrir:

```text
https://fernandomurashima.com.br
```

Verificar:

```text
tela inicial
login
menus
rotas Angular
carregamento da API
funcionalidade alterada
```

---

# Cache do navegador

Após atualização do frontend, pode ocorrer de o navegador ainda utilizar arquivos antigos em cache.

Se isso acontecer, tentar:

```text
Ctrl+F5
```

ou abrir uma janela anônima.

Se necessário, limpar o cache do navegador.

---

# Cache da Cloudflare

O frontend utiliza cabeçalhos de cache para arquivos estáticos.

Arquivos como:

```text
.js
.css
imagens
fontes
```

podem ser cacheados.

Arquivos Angular normalmente possuem hash no nome, portanto um novo build gera novos nomes quando o conteúdo muda.

O `index.html` deve permanecer sem cache prolongado.

---

# Não copiar por cima sem limpar

É recomendável remover primeiro:

```text
/srv/projects/copa/frontend/browser/*
```

antes do novo SCP.

Motivo:

Um novo build pode deixar de gerar arquivos que existiam na versão anterior.

Se simplesmente copiar por cima, arquivos antigos poderiam permanecer no servidor.

---

# Se ng build falhar

Não continue o deploy.

Resolver primeiro o erro no notebook de desenvolvimento.

Não limpar o frontend do servidor antes de existir um build válido.

---

# Regra de segurança

A ordem correta é:

```text
ng build
↓
confirmar que o build existe
↓
limpar browser remoto
↓
SCP
↓
docker build
↓
SOMENTE SE O DOCKER BUILD FUNCIONAR
remover container antigo
↓
subir novo container
```

---

# Se SCP falhar

Não prossiga com o Docker build até confirmar que todos os arquivos foram transferidos.

Verificar no Viper-II:

```bash
ls -lah /srv/projects/copa/frontend/browser
```

---

# Se o SCP for interrompido depois da limpeza

O diretório remoto pode ficar incompleto.

Basta repetir:

```powershell
scp -r C:\bolao2026\frontend\dist\bolao2026\browser\* fernando-murashima@192.168.15.80:/srv/projects/copa/frontend/browser/
```

e confirmar os arquivos antes de reconstruir a imagem.

---

# Se o docker build falhar

Não remova o container atual se ele ainda estiver funcionando.

Resolver primeiro a causa.

Executar novamente:

```bash
docker build -t bolao-frontend:latest .
```

Somente quando terminar com sucesso:

```bash
docker rm -f bolao-frontend
```

---

# Se o frontend não subir

Ver:

```bash
docker ps -a | grep bolao-frontend
```

Depois:

```bash
docker logs bolao-frontend --tail 100
```

---

# Se aparecer 502 Bad Gateway

Verificar:

```bash
docker ps | grep bolao-frontend
```

Depois:

```bash
docker network inspect infra
```

Confirmar que:

```text
nginx-proxy-manager
bolao-frontend
```

estão na rede `infra`.

---

# Se o frontend abre, mas API falha

O problema provavelmente não está no build Angular em si.

Verificar:

```bash
docker ps | grep bolao-backend
```

Depois:

```bash
docker logs bolao-backend --tail 100
```

Testar:

```bash
docker run --rm \
  --network infra \
  curlimages/curl:latest \
  -I \
  -H "Host: fernandomurashima.com.br" \
  http://bolao-backend:8001/admin/
```

---

# Se uma rota Angular retorna 404

Verificar o `nginx.conf`.

A regra necessária é:

```nginx
location / {
    try_files $uri $uri/ /index.html;
    add_header Cache-Control "no-cache";
}
```

Isso permite que o Angular trate as rotas client-side.

---

# Configuração do proxy para API

O frontend utiliza:

```nginx
location /api/ {
    proxy_pass http://bolao-backend:8001;
}
```

---

# Configuração do Django Admin

```nginx
location /admin/ {
    proxy_pass http://bolao-backend:8001;
}
```

---

# Static do Django

```nginx
location /static/ {
    proxy_pass http://bolao-backend:8001;
}
```

---

# Atualização somente do frontend

Quando apenas o frontend mudar, não é necessário:

```text
git pull do backend
docker build do backend
manage.py migrate
reiniciar MySQL
alterar Cloudflare
alterar DNS
alterar NPM
```

Executar apenas o procedimento desta nota.

---

# Atualização frontend + backend

Se ambos foram alterados, a ordem recomendada é:

```text
1. atualizar backend
2. executar migrations
3. validar backend
4. gerar build frontend
5. enviar frontend
6. reconstruir frontend
7. validar aplicação completa
```

---

# Não editar frontend dentro do container

Não alterar manualmente:

```text
/usr/share/nginx/html
```

dentro do container.

A fonte oficial deve permanecer:

```text
C:\bolao2026\frontend
```

O servidor recebe sempre um novo build.

---

# Build no notebook de desenvolvimento

O processo correto é:

```text
Alterar Angular
        ↓
testar localmente
        ↓
ng build
        ↓
SCP
        ↓
Viper-II
```

---

# Reinício simples sem atualização

Se não houver novo código e for necessário apenas reiniciar o frontend:

```bash
docker restart bolao-frontend
```

Não é necessário rebuild.

---

# Conferir imagem

```bash
docker images | grep bolao-frontend
```

---

# Ver recursos do frontend

```bash
docker stats bolao-frontend
```

---

# Checklist antes do deploy

```text
[ ] alteração testada localmente
[ ] ng build concluído
[ ] diretório dist\bolao2026\browser existente
[ ] arquivos do build conferidos
```

---

# Checklist da transferência

```text
[ ] build antigo remoto removido
[ ] SCP concluído
[ ] arquivos conferidos no Viper-II
```

---

# Checklist no Viper-II

```text
[ ] docker build concluído
[ ] container antigo removido
[ ] novo container criado
[ ] bolao-frontend UP
[ ] bolao-backend continua UP
[ ] teste local 200
[ ] domínio externo funcionando
[ ] alteração visual/funcional conferida
```

---

# Procedimento rápido

Para uso cotidiano:

```powershell
# ===== DESENVOLVIMENTO =====

cd C:\bolao2026\frontend

ng build

ssh fernando-murashima@192.168.15.80 "rm -rf /srv/projects/copa/frontend/browser/*"

scp -r C:\bolao2026\frontend\dist\bolao2026\browser\* fernando-murashima@192.168.15.80:/srv/projects/copa/frontend/browser/

ssh fernando-murashima@192.168.15.80
```

Depois, no Viper-II:

```bash
cd /srv/projects/copa/frontend

docker build -t bolao-frontend:latest .

docker rm -f bolao-frontend

docker run -d \
  --name bolao-frontend \
  --restart always \
  --network infra \
  bolao-frontend:latest

docker ps | grep bolao

curl -I \
  -H "Host: fernandomurashima.com.br" \
  http://127.0.0.1/
```

---

# Fluxo final

```text
C:\bolao2026\frontend
        ↓
ng build
        ↓
dist\bolao2026\browser
        ↓
SCP
        ↓
/srv/projects/copa/frontend/browser
        ↓
docker build
        ↓
bolao-frontend:latest
        ↓
bolao-frontend
        ↓
Nginx Proxy Manager
        ↓
Cloudflare
        ↓
usuário
```

---

# Estado esperado após atualização

```text
Frontend:
bolao-frontend

Status:
Up

Imagem:
bolao-frontend:latest

Rede:
infra

Backend:
bolao-backend
permanece ativo

Banco:
inalterado

Cloudflare:
inalterada

DNS:
inalterado

NPM:
inalterado

Domínio:
fernandomurashima.com.br

Status final:
PRODUÇÃO OPERACIONAL
```

---

# Documentos relacionados

- [[Bolao2026]]
- [[Operação/Operacao do Bolao]]
- [[Operação/Atualizacao Backend]]
- [[Infraestrutura/Docker]]
- [[Infraestrutura/Nginx Proxy Manager]]
- [[Infraestrutura/Cloudflare e DNS]]
- [[Decisões Técnicas/Arquitetura de Producao]]