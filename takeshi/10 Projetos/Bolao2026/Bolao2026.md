---
type: project
status: active
project: Bolao2026
source: C:/bolao2026
created: 2026-08-10
updated: 2026-08-10
tags:
  - projeto
  - bolao2026
  - django
  - angular
  - docker
  - viper-ii
  - cloudflare
  - mysql
  - nginx
  - migracao
  - kinghost
---

# Bolao2026

## O que é

O **Bolao2026** é uma aplicação web utilizada para gerenciamento de bolão de futebol.

A aplicação possui:

- backend em Django;
- frontend em Angular;
- banco de dados MySQL;
- autenticação de usuários;
- cadastro de jogos;
- cadastro de times;
- cadastro de jogadores;
- registro de palpites;
- resultados;
- pontuação;
- administração através do Django Admin;
- publicação pela internet através de Cloudflare Tunnel;
- execução em containers Docker no servidor Viper-II.

---

# Ambiente atual de produção

O Bolao2026 foi migrado da VPS da KingHost para o notebook servidor:

**Servidor:** `Viper-II`  
**Usuário:** `fernando-murashima`  
**IP local:** `192.168.15.80`

Diretórios principais da aplicação:

```text
/srv/projects/copa/backend
/srv/projects/copa/frontend
```

Containers da aplicação:

```text
bolao-backend
bolao-frontend
```

Componentes utilizados:

```text
Docker
MySQL
Nginx Proxy Manager
Cloudflare Tunnel
```

Rede Docker:

```text
infra
```

Banco de dados:

```text
bolao2026
```

Domínios:

```text
fernandomurashima.com.br
www.fernandomurashima.com.br
```

---

# Arquitetura atual

```text
Internet
   ↓
Cloudflare DNS
   ↓
Cloudflare Tunnel
   ↓
Viper-II
   ↓
Nginx Proxy Manager
   ↓
bolao-frontend
   │
   ├── Arquivos Angular
   │
   ├── /api/
   │      ↓
   │   bolao-backend
   │
   └── /admin/
          ↓
      bolao-backend
          ↓
        MySQL
          ↓
      bolao2026
```

O Cloudflare Tunnel recebe as requisições para:

```text
fernandomurashima.com.br
www.fernandomurashima.com.br
```

e encaminha para:

```text
http://localhost:80
```

O Nginx Proxy Manager recebe as requisições na porta 80 do servidor.

De acordo com o hostname, encaminha as requisições do Bolao2026 para:

```text
bolao-frontend:80
```

O container `bolao-frontend` executa Nginx e serve o build Angular.

As requisições para:

```text
/api/
```

e:

```text
/admin/
```

são encaminhadas pelo Nginx do frontend para:

```text
bolao-backend:8001
```

O container `bolao-backend` executa Django através do Gunicorn.

O backend acessa o banco MySQL pela rede Docker utilizando:

```text
Host: mysql
Porta: 3306
Banco: bolao2026
```

---

# Backend

Diretório no servidor:

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

Porta do Gunicorn:

```text
8001
```

O Gunicorn utiliza:

```text
3 workers
```

Principais tecnologias:

```text
Python 3.11
Django 4.2.11
Django REST Framework 3.14.0
Gunicorn
MySQL
```

Principais dependências registradas em `requirements.txt`:

```text
Django==4.2.11
djangorestframework==3.14.0
django-cors-headers==4.4.0
django-filter==24.1
django-extensions==3.2.3
drf-yasg==1.21.7
Markdown==3.5.2
reportlab==4.2.5
mysqlclient==2.2.4
python-decouple==3.8
celery==5.3.6
redis==5.0.1
asgiref==3.8.1
sqlparse==0.5.3
pytz==2025.2
tzdata==2025.2
```

O Gunicorn é instalado durante o build da imagem Docker.

Dockerfile:

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

O arquivo está localizado em:

```text
/srv/projects/copa/backend/Dockerfile
```

---

# Frontend

Diretório no servidor:

```text
/srv/projects/copa/frontend
```

Build Angular utilizado em produção:

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

Rede:

```text
infra
```

Porta interna:

```text
80
```

Dockerfile:

```dockerfile
FROM nginx:alpine

COPY nginx.conf /etc/nginx/conf.d/default.conf

COPY browser/ /usr/share/nginx/html/
```

Arquivo:

```text
/srv/projects/copa/frontend/Dockerfile
```

O Nginx do frontend serve diretamente o conteúdo do Angular e também atua como proxy para o backend.

Configuração principal:

```nginx
server {
    listen 80;
    server_name _;

    root /usr/share/nginx/html;
    index index.html;

    client_max_body_size 70M;

    location /api/ {
        proxy_pass http://bolao-backend:8001;
        proxy_http_version 1.1;

        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;

        proxy_buffering off;
        proxy_request_buffering off;
    }

    location /admin/ {
        proxy_pass http://bolao-backend:8001;
        proxy_http_version 1.1;

        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    location /static/ {
        proxy_pass http://bolao-backend:8001;
        proxy_set_header Host $host;
    }

    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot)$ {
        expires 30d;
        add_header Cache-Control "public, immutable";
        try_files $uri =404;
    }

    location / {
        try_files $uri $uri/ /index.html;
        add_header Cache-Control "no-cache";
    }
}
```

Arquivo:

```text
/srv/projects/copa/frontend/nginx.conf
```

---

# Banco de dados

Banco:

```text
bolao2026
```

Container:

```text
mysql
```

Imagem:

```text
mysql:8.0
```

Rede Docker:

```text
infra
```

O banco foi migrado da VPS KingHost através de dump lógico do MySQL.

Foi utilizado `mysqldump` com:

```text
--single-transaction
--routines
--triggers
--events
--no-tablespaces
```

Arquivo utilizado na migração:

```text
bolao2026_migracao_20260810.sql
```

Algumas das tabelas existentes:

```text
accounts_robinho
accounts_user
accounts_user_groups
accounts_user_user_permissions
auth_group
auth_group_permissions
auth_permission
authtoken_token
copa_bet
copa_extrabet
copa_extraresult
copa_match
copa_matchevent
copa_player
copa_stage
copa_team
copa_tournament
django_admin_log
django_content_type
django_migrations
django_session
```

---

# Configuração do Django para o banco

Na KingHost, o Django acessava o MySQL através de:

```text
HOST = localhost
```

Depois da migração para Docker, o acesso passou a utilizar:

```text
HOST = mysql
```

Isso permite que o backend localize o container MySQL através da rede Docker `infra`.

Configuração conceitual:

```python
DATABASES = {
    "default": {
        "ENGINE": "django.db.backends.mysql",
        "NAME": "bolao2026",
        "USER": "bolao_user",
        "HOST": "mysql",
        "PORT": "3306",
        "OPTIONS": {
            "charset": "utf8mb4",
            "init_command": "SET sql_mode='STRICT_TRANS_TABLES'",
        },
    }
}
```

As credenciais não devem ser registradas nesta documentação.

---

# Nginx Proxy Manager

O Nginx Proxy Manager está executando no servidor Viper-II.

Container:

```text
nginx-proxy-manager
```

Proxy Host criado:

```text
Domain Names:
fernandomurashima.com.br
www.fernandomurashima.com.br

Scheme:
http

Forward Hostname / IP:
bolao-frontend

Forward Port:
80
```

Opções habilitadas:

```text
Block Common Exploits
Websockets Support
```

O SSL público não é gerenciado pelo Nginx Proxy Manager.

O HTTPS é fornecido pela Cloudflare.

---

# Cloudflare

O domínio:

```text
fernandomurashima.com.br
```

passou a utilizar os servidores DNS da Cloudflare.

Nameservers atuais:

```text
kevin.ns.cloudflare.com
rayne.ns.cloudflare.com
```

Nameservers anteriores:

```text
a.sec.dns.br
c.sec.dns.br
```

O domínio permanece registrado no Registro.br.

A Cloudflare passou a ser responsável pela zona DNS.

---

# Cloudflare Tunnel

Tunnel utilizado:

```text
takeshivip
```

O cloudflared está instalado diretamente no Viper-II e executa como serviço systemd.

Foram criadas duas Published Applications.

Primeira:

```text
Hostname:
fernandomurashima.com.br

Service URL:
http://localhost:80
```

Segunda:

```text
Hostname:
www.fernandomurashima.com.br

Service URL:
http://localhost:80
```

A Cloudflare criou automaticamente registros CNAME apontando os hostnames para o túnel.

Fluxo:

```text
fernandomurashima.com.br
        ↓
Cloudflare
        ↓
Cloudflare Tunnel
        ↓
localhost:80
        ↓
Nginx Proxy Manager
```

---

# Infraestrutura anterior na KingHost

VPS:

```text
IP: 177.153.38.27
Hostname: murashimavps
Usuário: deploy
```

O Bolao2026 utilizava:

```text
/home/deploy/copa
```

Backend:

```text
/home/deploy/copa/backend
```

Frontend:

```text
/home/deploy/copa/frontend/browser
```

Ambiente virtual Python:

```text
/home/deploy/venvs/copa_env
```

Serviço systemd:

```text
copa.service
```

O serviço executava:

```text
gunicorn
```

em:

```text
127.0.0.1:8001
```

O Nginx da VPS recebia:

```text
fernandomurashima.com.br
www.fernandomurashima.com.br
```

e encaminhava `/api/` e `/admin/` para o Gunicorn.

O frontend era servido diretamente pelo Nginx da VPS.

O HTTPS era fornecido anteriormente pelo Certbot/Let's Encrypt instalado na KingHost.

---

# Processo de migração KingHost para Viper-II

## 1. Identificação da aplicação

Foi identificado na KingHost:

```text
copa.service
```

como serviço responsável pelo backend do Bolao2026.

Foi identificado também o projeto:

```text
/home/deploy/copa
```

---

## 2. Identificação do banco

Banco:

```text
bolao2026
```

O Django utilizava MySQL local na VPS.

---

## 3. Criação do dump atualizado

Foi criado um dump atualizado antes da migração.

Arquivo:

```text
/home/deploy/bolao2026_migracao_20260810.sql
```

Foi utilizado:

```bash
mysqldump \
  --single-transaction \
  --routines \
  --triggers \
  --events \
  --no-tablespaces
```

---

## 4. Compactação do projeto

Foi criado:

```text
/home/deploy/copa_migracao_20260810.tar.gz
```

contendo o projeto da aplicação.

---

## 5. Transferência para o Viper-II

Como a KingHost não conseguia acessar diretamente o IP privado:

```text
192.168.15.80
```

a transferência foi realizada no sentido inverso.

O Viper-II realizou o download dos arquivos da VPS KingHost.

Arquivos recebidos:

```text
/tmp/copa_migracao_20260810.tar.gz
/tmp/bolao2026_migracao_20260810.sql
```

---

## 6. Extração do projeto

Foi criado o diretório:

```bash
sudo mkdir -p /srv/projects
```

O projeto foi extraído com:

```bash
sudo tar xzf /tmp/copa_migracao_20260810.tar.gz -C /srv/projects
```

As permissões foram ajustadas:

```bash
sudo chown -R fernando-murashima:fernando-murashima /srv/projects/copa
```

Resultado:

```text
/srv/projects/copa/backend
/srv/projects/copa/frontend
```

Também existia uma pasta antiga:

```text
backend_corrompido_20260623_203943
```

que não foi utilizada.

---

# Migração do banco

Foi criado o banco:

```text
bolao2026
```

no MySQL existente no Viper-II.

Foi criado o usuário da aplicação e concedido acesso ao banco.

Depois o dump foi restaurado:

```bash
docker exec -i mysql mysql -uroot -p'SENHA_ROOT' bolao2026 < /tmp/bolao2026_migracao_20260810.sql
```

A senha real não deve ser armazenada na documentação.

A restauração foi confirmada através de:

```bash
docker exec mysql mysql -uroot -p'SENHA_ROOT' -e "USE bolao2026; SHOW TABLES;"
```

---

# Containerização do backend

Foi criado:

```text
/srv/projects/copa/backend/Dockerfile
```

A imagem foi construída:

```bash
cd /srv/projects/copa/backend

docker build -t bolao-backend .
```

A imagem resultante:

```text
bolao-backend:latest
```

O container foi criado:

```bash
docker run -d \
  --name bolao-backend \
  --restart always \
  --network infra \
  bolao-backend:latest
```

---

# Validação do backend

O backend foi validado diretamente pela rede Docker.

Teste:

```bash
docker run --rm --network infra curlimages/curl:latest -I \
  -H "Host: fernandomurashima.com.br" \
  http://bolao-backend:8001/admin/
```

Resultado esperado:

```text
HTTP/1.1 302 Found
Location: /admin/login/?next=/admin/
```

Isso confirmou funcionamento do Django e do Gunicorn.

---

# Containerização do frontend

Foi criado:

```text
/srv/projects/copa/frontend/nginx.conf
```

e:

```text
/srv/projects/copa/frontend/Dockerfile
```

A imagem foi construída:

```bash
cd /srv/projects/copa/frontend

docker build -t bolao-frontend .
```

Foi criado o container:

```bash
docker run -d \
  --name bolao-frontend \
  --restart always \
  --network infra \
  bolao-frontend:latest
```

---

# Validação do frontend

Teste realizado:

```bash
docker run --rm --network infra curlimages/curl:latest -I \
  -H "Host: fernandomurashima.com.br" \
  http://bolao-frontend/
```

Resultado:

```text
HTTP/1.1 200 OK
```

Teste do Admin passando pelo frontend:

```bash
docker run --rm --network infra curlimages/curl:latest -I \
  -H "Host: fernandomurashima.com.br" \
  http://bolao-frontend/admin/
```

Resultado:

```text
HTTP/1.1 302 Found
```

---

# Configuração do Nginx Proxy Manager

Foi criado um Proxy Host no NPM.

Configuração:

```text
Domain Names:
fernandomurashima.com.br
www.fernandomurashima.com.br

Scheme:
http

Forward Hostname / IP:
bolao-frontend

Forward Port:
80
```

Depois foi validado diretamente pelo servidor:

```bash
curl -I \
  -H "Host: fernandomurashima.com.br" \
  http://127.0.0.1/
```

Resultado:

```text
HTTP/1.1 200 OK
```

Admin:

```bash
curl -I \
  -H "Host: fernandomurashima.com.br" \
  http://127.0.0.1/admin/
```

Resultado:

```text
HTTP/1.1 302 Found
```

---

# Migração DNS

Antes da migração, o domínio utilizava os nameservers:

```text
a.sec.dns.br
c.sec.dns.br
```

Os registros existentes eram somente:

```text
A  fernandomurashima.com.br      177.153.38.27
A  www.fernandomurashima.com.br  177.153.38.27
```

Não existiam registros:

```text
MX
TXT
DMARC
```

O domínio foi adicionado à Cloudflare.

Nameservers atribuídos:

```text
kevin.ns.cloudflare.com
rayne.ns.cloudflare.com
```

Esses nameservers foram configurados no Registro.br.

A propagação foi acompanhada com:

```powershell
nslookup -type=ns fernandomurashima.com.br 8.8.8.8
```

e:

```powershell
nslookup -type=ns fernandomurashima.com.br 1.1.1.1
```

Depois da propagação:

```text
kevin.ns.cloudflare.com
rayne.ns.cloudflare.com
```

passaram a ser retornados.

---

# Publicação pelo Cloudflare Tunnel

Os registros A antigos foram removidos de forma controlada.

Primeiro foi publicado:

```text
www.fernandomurashima.com.br
```

Depois:

```text
fernandomurashima.com.br
```

A Cloudflare criou automaticamente CNAMEs apontando para:

```text
<UUID-do-tunnel>.cfargotunnel.com
```

O Service URL configurado para ambos foi:

```text
http://localhost:80
```

---

# Teste público

Foi utilizado:

```powershell
ipconfig /flushdns
```

Depois:

```powershell
curl.exe -I https://fernandomurashima.com.br
```

Resultado confirmou:

```text
Server: cloudflare
x-served-by: fernandomurashima.com.br
```

Também foi testado:

```powershell
curl.exe -I https://www.fernandomurashima.com.br
```

Resultado:

```text
Server: cloudflare
x-served-by: www.fernandomurashima.com.br
```

Isso confirmou que o tráfego estava chegando ao Viper-II.

---

# Validação em 4G/5G

Foi realizado teste externo através de celular.

Procedimento:

```text
Wi-Fi desligado
4G/5G ativo
Acesso a https://fernandomurashima.com.br
Login no sistema
Consulta dos dados
```

O sistema funcionou corretamente.

---

# Desativação do Bolao2026 na KingHost

Após confirmação externa, foi conectado à KingHost.

Comando:

```bash
sudo systemctl status copa.service --no-pager
```

O serviço ainda estava:

```text
Active: active (running)
```

Foi então parado:

```bash
sudo systemctl stop copa.service
```

Resultado:

```text
Active: inactive (dead)
```

Após desligar o serviço na KingHost, o Bolao2026 foi novamente testado externamente em 4G/5G.

O sistema continuou funcionando.

Isso confirmou que o Bolao2026 estava completamente independente da KingHost.

O serviço pode permanecer desabilitado enquanto a VPS ainda existir como contingência histórica.

Os arquivos antigos não devem ser apagados até a conclusão definitiva da migração de toda a infraestrutura.

---

# Situação atual

A migração do Bolao2026 para o Viper-II foi concluída com sucesso em:

```text
10/08/2026
```

O sistema está atualmente hospedado no:

```text
Viper-II
192.168.15.80
```

Fluxo final:

```text
Internet
   ↓
Cloudflare
   ↓
Cloudflare Tunnel
   ↓
Viper-II
   ↓
Nginx Proxy Manager
   ↓
bolao-frontend
   ↓
bolao-backend
   ↓
MySQL
   ↓
bolao2026
```

---

# Estrutura da documentação no Obsidian

```text
10 Projetos
└── Bolao2026
    ├── Contexto do Projeto
    ├── Decisões Técnicas
    ├── Infraestrutura
    ├── Operação
    ├── Migração KingHost
    └── Bolao2026
```

Links previstos:

- [[Contexto do Projeto/Visao Geral]]
- [[Decisões Técnicas/Arquitetura de Producao]]
- [[Infraestrutura/Servidor Viper-II]]
- [[Infraestrutura/Docker]]
- [[Infraestrutura/Banco de Dados]]
- [[Infraestrutura/Nginx Proxy Manager]]
- [[Infraestrutura/Cloudflare e DNS]]
- [[Migração KingHost/Migracao KingHost para Viper-II]]
- [[Operação/Operacao do Bolao]]
- [[Operação/Atualizacao Backend]]
- [[Operação/Atualizacao Frontend]]

---

# Ambiente de desenvolvimento

Projeto no notebook de desenvolvimento:

```text
C:\bolao2026
```

Backend:

```text
C:\bolao2026\backend
```

Frontend:

```text
C:\bolao2026\frontend
```

A atualização de produção segue dois processos diferentes.

Backend:

```text
Notebook de desenvolvimento
        ↓
GitHub
        ↓
git pull no Viper-II
        ↓
Docker build
        ↓
Recriação do container
```

Frontend:

```text
Notebook de desenvolvimento
        ↓
ng build
        ↓
SCP
        ↓
Viper-II
        ↓
Docker build
        ↓
Recriação do container
```

---

# PROCEDIMENTO DE ATUALIZAÇÃO DO BACKEND

Quando houver alteração no backend do Bolao2026, executar os comandos abaixo.

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

Fluxo:

```text
C:\bolao2026\backend
        ↓
git add / commit / push
        ↓
GitHub
        ↓
Viper-II
        ↓
git pull
        ↓
docker build
        ↓
remove bolao-backend antigo
        ↓
cria bolao-backend novo
        ↓
manage.py migrate
        ↓
logs
        ↓
teste
```

---

# PROCEDIMENTO DE ATUALIZAÇÃO DO FRONTEND

Quando houver alteração no frontend do Bolao2026, executar os comandos abaixo.

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

Fluxo:

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
remove bolao-frontend antigo
        ↓
cria bolao-frontend novo
        ↓
teste
```

---

# Quando atualizar somente o backend

Executar apenas:

```text
PROCEDIMENTO DE ATUALIZAÇÃO DO BACKEND
```

Não é necessário rebuild do frontend.

---

# Quando atualizar somente o frontend

Executar apenas:

```text
PROCEDIMENTO DE ATUALIZAÇÃO DO FRONTEND
```

Não é necessário rebuild do backend.

---

# Quando atualizar backend e frontend

Executar nesta ordem:

```text
1. Backend
2. Migrations
3. Validação do backend
4. Frontend
5. Validação geral
```

---

# Componentes que não precisam ser alterados em atualização normal

Uma atualização normal do Bolao2026 não exige alterações em:

```text
Cloudflare
Cloudflare DNS
Cloudflare Tunnel
Registro.br
Nginx Proxy Manager
MySQL
Redis
Portainer
Uptime Kuma
```

A infraestrutura permanece configurada.

---

# Verificação após atualização

Confirmar containers:

```bash
docker ps | grep bolao
```

Logs do backend:

```bash
docker logs bolao-backend --tail 50
```

Teste interno:

```bash
curl -I \
  -H "Host: fernandomurashima.com.br" \
  http://127.0.0.1/
```

Esperado:

```text
HTTP/1.1 200 OK
```

Teste do Admin:

```bash
curl -I \
  -H "Host: fernandomurashima.com.br" \
  http://127.0.0.1/admin/
```

Esperado:

```text
HTTP/1.1 302 Found
```

Teste público:

```text
https://fernandomurashima.com.br
```

e:

```text
https://www.fernandomurashima.com.br
```

Depois de atualização importante, realizar:

```text
Login
Consulta de jogos
Consulta de palpites
Consulta de resultados
Verificação dos dados atuais
```

---

# Comandos úteis de operação

## Ver containers do Bolao

```bash
docker ps | grep bolao
```

## Logs do backend

```bash
docker logs bolao-backend --tail 50
```

## Acompanhar logs em tempo real

```bash
docker logs -f bolao-backend
```

## Logs do frontend

```bash
docker logs bolao-frontend --tail 50
```

## Reiniciar backend

```bash
docker restart bolao-backend
```

## Reiniciar frontend

```bash
docker restart bolao-frontend
```

## Ver rede Docker

```bash
docker network inspect infra
```

## Ver banco

```bash
docker exec mysql mysql -uroot -p
```

Depois:

```sql
USE bolao2026;
SHOW TABLES;
```

---

# Reinicialização do servidor

Os containers foram configurados com:

```text
--restart always
```

Portanto, após reinicialização do Viper-II, Docker deve iniciar automaticamente os containers.

Também o serviço cloudflared foi instalado como serviço systemd.

Após reiniciar o servidor, verificar:

```bash
docker ps
```

e:

```bash
sudo systemctl status cloudflared --no-pager
```

Depois testar:

```text
https://fernandomurashima.com.br
```

---

# Segurança

As seguintes informações não devem ser registradas diretamente na documentação:

```text
Senhas MySQL
Senhas de usuários do sistema
Tokens Cloudflare
SECRET_KEY Django
Tokens de API
Credenciais administrativas
```

Durante a migração algumas credenciais foram utilizadas diretamente em comandos.

Após a conclusão da migração completa da infraestrutura deverá ser realizada uma etapa específica de segurança para troca de credenciais.

Itens a revisar:

```text
Senha root do MySQL
Senha do usuário bolao_user
SECRET_KEY Django
Token do Cloudflare Tunnel
Credenciais administrativas
Tokens eventualmente expostos durante configuração
```

---

# Backup

O banco `bolao2026` deve participar da política de backup do servidor Viper-II.

O backup deverá contemplar pelo menos:

```text
Banco MySQL bolao2026
Projeto backend
Configuração frontend
Dockerfiles
nginx.conf
Configuração de infraestrutura
```

O banco deve possuir backup automático com retenção e cópia externa.

Esse procedimento será documentado na etapa geral de backup do servidor Viper-II.

---

# Rollback

Enquanto a VPS KingHost ainda existir, os arquivos antigos do Bolao2026 devem permanecer armazenados.

O antigo projeto está em:

```text
/home/deploy/copa
```

O serviço antigo:

```text
copa.service
```

foi parado depois da migração.

Não apagar o projeto antigo até a conclusão definitiva de toda a migração da KingHost.

---

# Conclusão

A migração do Bolao2026 da VPS KingHost para o notebook servidor Viper-II foi concluída com sucesso.

O sistema deixou de depender da VPS para:

```text
Backend
Frontend
Banco de dados
Publicação HTTP
HTTPS
Proxy reverso
```

A aplicação passou a utilizar:

```text
Docker
MySQL
Nginx Proxy Manager
Cloudflare DNS
Cloudflare Tunnel
```

A validação final foi realizada através de conexão externa 4G/5G.

Após o desligamento do serviço `copa.service` na KingHost, o sistema continuou funcionando normalmente, confirmando que a migração estava concluída.

Estado final:

```text
Bolao2026
Produção: Viper-II
IP local: 192.168.15.80
Domínio: fernandomurashima.com.br
Backend: bolao-backend
Frontend: bolao-frontend
Banco: bolao2026
Rede Docker: infra
Proxy: Nginx Proxy Manager
Acesso externo: Cloudflare Tunnel
Status: PRODUÇÃO OPERACIONAL
```

[[Contexto para Agentes]]
[[Mapa do Cofre]]