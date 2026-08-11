---
type: documentation
status: active
project: Bolao2026
category: infraestrutura
created: 2026-08-10
updated: 2026-08-10
tags:
  - bolao2026
  - infraestrutura
  - docker
  - containers
  - viper-ii
---

# Docker

## Objetivo

Esta nota documenta a utilização do Docker no ambiente de produção do **Bolao2026** no servidor `Viper-II`.

O Bolao2026 utiliza Docker para executar de forma isolada:

```text
backend Django
frontend Angular
MySQL
Nginx Proxy Manager
Redis
Portainer
Uptime Kuma
WebFoto
```

O objetivo é manter os serviços separados, facilitar atualização, reduzir dependências instaladas diretamente no Ubuntu e permitir recriação controlada dos containers.

---

# Ambiente Docker

Servidor:

```text
Viper-II
```

Usuário:

```text
fernando-murashima
```

Docker:

```text
Docker 29.7.2
```

Docker Compose:

```text
Docker Compose v5.4.0
```

O usuário pertence ao grupo:

```text
docker
```

Portanto os comandos Docker podem ser executados normalmente sem `sudo`.

---

# Verificar versão do Docker

```bash
docker --version
```

Verificar Docker Compose:

```bash
docker compose version
```

---

# Rede Docker principal

A infraestrutura utiliza a rede:

```text
infra
```

Essa rede permite que os containers se comuniquem usando seus próprios nomes.

Exemplo:

```text
bolao-frontend
        ↓
bolao-backend
        ↓
mysql
```

O frontend pode acessar o backend através de:

```text
http://bolao-backend:8001
```

O backend pode acessar o MySQL através de:

```text
mysql:3306
```

---

# Verificar redes Docker

```bash
docker network ls
```

Verificar especificamente a rede `infra`:

```bash
docker network inspect infra
```

---

# Containers relacionados ao Bolao2026

## Backend

Container:

```text
bolao-backend
```

Imagem:

```text
bolao-backend:latest
```

Rede:

```text
infra
```

Política de restart:

```text
always
```

Porta interna:

```text
8001
```

A porta 8001 não é publicada diretamente no host.

O backend é acessível pela rede Docker.

---

## Frontend

Container:

```text
bolao-frontend
```

Imagem:

```text
bolao-frontend:latest
```

Rede:

```text
infra
```

Política de restart:

```text
always
```

Porta interna:

```text
80
```

A porta não é publicada diretamente no host.

O acesso ocorre através do Nginx Proxy Manager.

---

# Container MySQL

Container:

```text
mysql
```

Imagem:

```text
mysql:8.0
```

Rede:

```text
infra
```

Portas internas:

```text
3306
33060
```

Banco utilizado pelo Bolao2026:

```text
bolao2026
```

---

# Container Nginx Proxy Manager

Container:

```text
nginx-proxy-manager
```

Imagem:

```text
jc21/nginx-proxy-manager:latest
```

Rede:

```text
infra
```

Portas publicadas no servidor:

```text
80
81
443
```

Função:

```text
Proxy reverso
Roteamento por hostname
Interface administrativa
```

Interface:

```text
http://192.168.15.80:81
```

---

# Container Redis

Container:

```text
redis
```

Imagem:

```text
redis:7
```

Rede:

```text
infra
```

Porta interna:

```text
6379
```

O Redis faz parte da infraestrutura geral do servidor.

O Bolao2026 possui dependências Python para Redis e Celery, embora o uso efetivo dessas funcionalidades dependa da aplicação.

---

# Portainer

Container:

```text
portainer
```

Imagem:

```text
portainer/portainer-ce:latest
```

Interface:

```text
https://192.168.15.80:9443
```

O Portainer permite administração visual de:

```text
containers
images
volumes
networks
logs
```

---

# Uptime Kuma

Container:

```text
uptime-kuma
```

Imagem:

```text
louislam/uptime-kuma:latest
```

O Uptime Kuma é utilizado para monitoramento da infraestrutura.

---

# Verificar containers em execução

```bash
docker ps
```

Para visualizar apenas o Bolao2026:

```bash
docker ps | grep bolao
```

Esperado:

```text
bolao-backend
bolao-frontend
```

---

# Ver todos os containers

Incluindo containers parados:

```bash
docker ps -a
```

---

# Ver imagens Docker

```bash
docker images
```

Filtrar backend:

```bash
docker images | grep bolao-backend
```

Filtrar frontend:

```bash
docker images | grep bolao-frontend
```

---

# Backend Dockerfile

Diretório:

```text
/srv/projects/copa/backend
```

Arquivo:

```text
/srv/projects/copa/backend/Dockerfile
```

Conteúdo utilizado:

```dockerfile
FROM python:3.11-slim

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app

RUN apt-get update && apt-get install -y \
    default-libmysqlclient-dev \
    build-essential \
    pkg-config \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt \
    && pip install --no-cache-dir gunicorn

COPY . .

CMD ["gunicorn", "--workers", "3", "--bind", "0.0.0.0:8001", "bolao2026.wsgi:application"]
```

---

# Construção da imagem do backend

```bash
cd /srv/projects/copa/backend
```

Depois:

```bash
docker build -t bolao-backend:latest .
```

---

# Criação do container backend

```bash
docker run -d \
  --name bolao-backend \
  --restart always \
  --network infra \
  bolao-backend:latest
```

---

# Verificar backend

```bash
docker ps | grep bolao-backend
```

Logs:

```bash
docker logs bolao-backend --tail 50
```

Logs em tempo real:

```bash
docker logs -f bolao-backend
```

---

# Executar comando dentro do backend

Formato:

```bash
docker exec bolao-backend <comando>
```

Exemplo de migrations:

```bash
docker exec bolao-backend python manage.py migrate
```

Exemplo de Django check:

```bash
docker exec bolao-backend python manage.py check
```

---

# Frontend Dockerfile

Diretório:

```text
/srv/projects/copa/frontend
```

Arquivo:

```text
/srv/projects/copa/frontend/Dockerfile
```

Conteúdo:

```dockerfile
FROM nginx:alpine

COPY nginx.conf /etc/nginx/conf.d/default.conf

COPY browser/ /usr/share/nginx/html/
```

---

# Construção da imagem do frontend

```bash
cd /srv/projects/copa/frontend
```

Depois:

```bash
docker build -t bolao-frontend:latest .
```

---

# Criação do container frontend

```bash
docker run -d \
  --name bolao-frontend \
  --restart always \
  --network infra \
  bolao-frontend:latest
```

---

# Verificar frontend

```bash
docker ps | grep bolao-frontend
```

Logs:

```bash
docker logs bolao-frontend --tail 50
```

Logs em tempo real:

```bash
docker logs -f bolao-frontend
```

---

# Reiniciar containers

Backend:

```bash
docker restart bolao-backend
```

Frontend:

```bash
docker restart bolao-frontend
```

MySQL:

```bash
docker restart mysql
```

Nginx Proxy Manager:

```bash
docker restart nginx-proxy-manager
```

A reinicialização do MySQL ou do Nginx Proxy Manager pode afetar outras aplicações hospedadas no servidor.

---

# Parar containers

Backend:

```bash
docker stop bolao-backend
```

Frontend:

```bash
docker stop bolao-frontend
```

---

# Iniciar containers parados

Backend:

```bash
docker start bolao-backend
```

Frontend:

```bash
docker start bolao-frontend
```

---

# Remover containers

A remoção de um container não remove automaticamente a imagem utilizada para criá-lo.

Backend:

```bash
docker rm -f bolao-backend
```

Frontend:

```bash
docker rm -f bolao-frontend
```

Esses comandos são utilizados durante atualização da aplicação antes da criação dos novos containers.

---

# Atualização do backend

Resumo:

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
```

O procedimento completo está em:

```text
[[Operação/Atualizacao Backend]]
```

---

# Atualização do frontend

Após o novo build ser enviado para:

```text
/srv/projects/copa/frontend/browser
```

executar:

```bash
cd /srv/projects/copa/frontend

docker build -t bolao-frontend:latest .

docker rm -f bolao-frontend

docker run -d \
  --name bolao-frontend \
  --restart always \
  --network infra \
  bolao-frontend:latest
```

Procedimento completo:

```text
[[Operação/Atualizacao Frontend]]
```

---

# Testar comunicação frontend → backend

```bash
docker run --rm --network infra curlimages/curl:latest -I \
  -H "Host: fernandomurashima.com.br" \
  http://bolao-frontend/admin/
```

Esperado:

```text
HTTP/1.1 302 Found
```

---

# Testar backend diretamente

```bash
docker run --rm --network infra curlimages/curl:latest -I \
  -H "Host: fernandomurashima.com.br" \
  http://bolao-backend:8001/admin/
```

Esperado:

```text
HTTP/1.1 302 Found
```

---

# Testar frontend diretamente

```bash
docker run --rm --network infra curlimages/curl:latest -I \
  -H "Host: fernandomurashima.com.br" \
  http://bolao-frontend/
```

Esperado:

```text
HTTP/1.1 200 OK
```

---

# Comunicação com o MySQL

O backend utiliza:

```text
mysql
```

como hostname.

Isso funciona porque ambos estão na rede:

```text
infra
```

Verificar containers conectados:

```bash
docker network inspect infra
```

---

# DNS interno Docker

O Docker oferece resolução interna de nomes dentro da mesma rede.

Assim:

```text
bolao-backend
```

resolve para o IP interno atual do container backend.

```text
mysql
```

resolve para o IP interno atual do container MySQL.

Não é necessário armazenar IPs internos dos containers na configuração da aplicação.

---

# Volumes

A infraestrutura utiliza volumes Docker persistentes.

Entre os volumes existentes no servidor estão:

```text
mysql_data
npm_data
npm_letsencrypt
portainer_data
redis_data
uptime_kuma_data
webfoto_upload_temp
webfoto_uploads
webfoto_zips
```

Para o Bolao2026, o volume mais crítico é:

```text
mysql_data
```

porque contém os dados persistentes do MySQL.

---

# Listar volumes

```bash
docker volume ls
```

---

# Inspecionar volume

```bash
docker volume inspect mysql_data
```

---

# Atenção com volumes

Não executar:

```bash
docker volume rm mysql_data
```

Esse comando pode causar perda dos bancos armazenados no MySQL.

Não executar limpeza agressiva de volumes sem análise prévia.

---

# Cuidado com Docker prune

Evitar comandos como:

```bash
docker system prune -a
```

sem verificar o que será removido.

Esse comando pode remover:

```text
containers parados
imagens não utilizadas
cache de build
redes não utilizadas
```

Com opções adicionais, também pode atingir volumes.

Antes de qualquer limpeza importante, garantir backup.

---

# Reinicialização do Viper-II

Como os containers foram criados com:

```text
--restart always
```

eles devem iniciar automaticamente depois do Docker subir.

Após reboot:

```bash
docker ps
```

Confirmar:

```text
bolao-backend
bolao-frontend
mysql
nginx-proxy-manager
```

---

# Diagnóstico rápido Docker

Caso o Bolao2026 apresente problema, executar primeiro:

```bash
docker ps
```

Depois:

```bash
docker logs bolao-frontend --tail 50
```

Depois:

```bash
docker logs bolao-backend --tail 50
```

Depois:

```bash
docker ps | grep mysql
```

E verificar a rede:

```bash
docker network inspect infra
```

---

# Container reiniciando continuamente

Verificar:

```bash
docker ps -a
```

Depois:

```bash
docker logs NOME_DO_CONTAINER --tail 100
```

Exemplo:

```bash
docker logs bolao-backend --tail 100
```

Problemas comuns:

```text
erro de conexão com MySQL
erro no settings.py
dependency ausente
migration pendente
erro de sintaxe
imagem construída com arquivos incorretos
```

---

# Backend não conecta ao banco

Verificar se MySQL está ativo:

```bash
docker ps | grep mysql
```

Verificar se ambos estão na rede:

```bash
docker network inspect infra
```

Configuração correta no Django:

```text
HOST = mysql
PORT = 3306
```

Não utilizar:

```text
localhost
```

dentro do container backend para acessar o MySQL.

Dentro do container, `localhost` significa o próprio container backend.

---

# Frontend não encontra backend

Verificar configuração:

```text
proxy_pass http://bolao-backend:8001;
```

Verificar backend:

```bash
docker ps | grep bolao-backend
```

Verificar rede:

```bash
docker network inspect infra
```

Teste direto:

```bash
docker run --rm --network infra curlimages/curl:latest -I \
  -H "Host: fernandomurashima.com.br" \
  http://bolao-backend:8001/admin/
```

---

# Nginx Proxy Manager não encontra frontend

Verificar:

```bash
docker ps | grep bolao-frontend
```

Verificar rede:

```bash
docker network inspect infra
```

Configuração esperada no NPM:

```text
Forward Hostname:
bolao-frontend

Forward Port:
80
```

---

# Estado Docker esperado

Containers relacionados diretamente ao funcionamento público do Bolao2026:

```text
mysql
bolao-backend
bolao-frontend
nginx-proxy-manager
```

Serviço externo ao Docker:

```text
cloudflared
```

---

# Melhoria futura — Docker Compose

Atualmente os containers do Bolao2026 foram criados manualmente através de `docker run`.

Uma melhoria futura é criar:

```text
/srv/docker/stacks/bolao.yml
```

para administrar:

```text
bolao-backend
bolao-frontend
```

através de Docker Compose.

Exemplo de operação futura:

```bash
docker compose build
docker compose up -d
```

Isso deverá ser feito somente depois de validar cuidadosamente a configuração atual.

---

# Regra operacional

Alterar arquivos no servidor não altera containers já existentes.

Sempre que o código incluído na imagem mudar:

```text
1. Atualizar arquivos
2. docker build
3. remover container antigo
4. criar novo container
5. testar
```

O banco de dados não deve ser recriado durante deploy normal.

---

# Estado atual

```text
Servidor: Viper-II
Docker: 29.7.2
Docker Compose: v5.4.0
Rede: infra

Backend:
  Imagem: bolao-backend:latest
  Container: bolao-backend
  Porta: 8001

Frontend:
  Imagem: bolao-frontend:latest
  Container: bolao-frontend
  Porta: 80

Banco:
  Container: mysql
  Imagem: mysql:8.0
  Banco: bolao2026

Proxy:
  Container: nginx-proxy-manager

Restart:
  always
```

---

# Documentos relacionados

- [[Bolao2026]]
- [[Contexto do Projeto/Visao Geral]]
- [[Decisões Técnicas/Arquitetura de Producao]]
- [[Infraestrutura/Servidor Viper-II]]
- [[Infraestrutura/Banco de Dados]]
- [[Infraestrutura/Nginx Proxy Manager]]
- [[Infraestrutura/Cloudflare e DNS]]
- [[Migração KingHost/Migracao KingHost para Viper-II]]
- [[Operação/Operacao do Bolao]]
- [[Operação/Atualizacao Backend]]
- [[Operação/Atualizacao Frontend]]