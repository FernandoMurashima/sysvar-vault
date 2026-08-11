---
type: documentation
status: completed
project: Bolao2026
category: migracao
created: 2026-08-10
updated: 2026-08-10
tags:
  - bolao2026
  - migracao
  - kinghost
  - viper-ii
  - docker
  - mysql
  - cloudflare
---

# Migracao KingHost para Viper-II

## Objetivo

Esta nota registra o procedimento completo utilizado para migrar o **Bolao2026** da VPS KingHost para o notebook servidor `Viper-II`.

A migração foi realizada de forma controlada, mantendo a infraestrutura antiga funcionando até que o novo ambiente estivesse completamente validado.

O princípio utilizado foi:

```text
Migrar
↓
Testar internamente
↓
Publicar
↓
Testar externamente
↓
Desligar serviço antigo
↓
Testar novamente
```

---

# Ambiente antigo — KingHost

Servidor:

```text
VPS KingHost
```

IP público:

```text
177.153.38.27
```

Hostname:

```text
murashimavps
```

Usuário:

```text
deploy
```

Projeto:

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

Ambiente virtual:

```text
/home/deploy/venvs/copa_env
```

Banco:

```text
bolao2026
```

Serviço Django:

```text
copa.service
```

Gunicorn:

```text
127.0.0.1:8001
```

Nginx:

```text
instalado diretamente na VPS
```

Domínios:

```text
fernandomurashima.com.br
www.fernandomurashima.com.br
```

---

# Serviço antigo do backend

O serviço systemd utilizado era:

```text
copa.service
```

Configuração principal:

```text
Description=Copa 2026 Django service

User=deploy

Group=www-data

WorkingDirectory=/home/deploy/copa/backend

Environment=PATH=/home/deploy/venvs/copa_env/bin

ExecStart=/home/deploy/venvs/copa_env/bin/gunicorn \
  --workers 3 \
  --bind 127.0.0.1:8001 \
  bolao2026.wsgi:application
```

---

# Nginx antigo

O Nginx da VPS atendia:

```text
fernandomurashima.com.br
www.fernandomurashima.com.br
```

O frontend era servido diretamente de:

```text
/home/deploy/copa/frontend/browser
```

As rotas:

```text
/api/
```

e:

```text
/admin/
```

eram encaminhadas para:

```text
127.0.0.1:8001
```

O HTTPS era fornecido através de Certbot/Let's Encrypt.

---

# Preparação da migração

Antes de qualquer mudança de DNS ou desligamento da KingHost, foi realizado um levantamento completo da aplicação.

Foram identificados:

```text
serviço Django
diretório backend
diretório frontend
banco MySQL
domínios
configuração Nginx
configuração Django
dependências Python
```

---

# Banco identificado

Configuração utilizada na KingHost:

```text
ENGINE:
django.db.backends.mysql

NAME:
bolao2026

USER:
bolao_user

HOST:
localhost

PORT:
3306
```

A senha não deve ser registrada nesta documentação.

---

# Dependências do backend

Arquivo:

```text
/home/deploy/copa/backend/requirements.txt
```

Principais dependências:

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
```

Gunicorn não estava no `requirements.txt`, pois existia no ambiente virtual da VPS.

Na nova infraestrutura passou a ser instalado no Dockerfile.

---

# Backup do banco

Foi criado um dump atualizado do banco de produção.

Arquivo na KingHost:

```text
/home/deploy/bolao2026_migracao_20260810.sql
```

O dump foi criado com:

```text
--single-transaction
--routines
--triggers
--events
--no-tablespaces
```

Estrutura do comando:

```bash
mysqldump \
  --single-transaction \
  --routines \
  --triggers \
  --events \
  --no-tablespaces \
  bolao2026 \
  > /home/deploy/bolao2026_migracao_20260810.sql
```

---

# Problema encontrado no dump

Uma tentativa inicial apresentou erro relacionado ao privilégio:

```text
PROCESS
```

A solução foi utilizar:

```text
--no-tablespaces
```

Depois disso o dump foi criado com sucesso.

---

# Compactação do projeto

Foi criado o arquivo:

```text
/home/deploy/copa_migracao_20260810.tar.gz
```

Comando:

```bash
tar czf /home/deploy/copa_migracao_20260810.tar.gz \
  -C /home/deploy \
  copa
```

---

# Tentativa de transferência KingHost → Viper-II

Inicialmente foi considerada transferência direta da KingHost para:

```text
192.168.15.80
```

Isso não funcionaria porque:

```text
192.168.15.80
```

é um endereço privado da rede local e não pode ser acessado diretamente pela VPS na internet.

---

# Estratégia de transferência adotada

A transferência foi invertida.

O Viper-II acessou a KingHost através do IP público:

```text
177.153.38.27
```

e puxou os arquivos.

Arquivos recebidos no Viper-II:

```text
/tmp/copa_migracao_20260810.tar.gz
/tmp/bolao2026_migracao_20260810.sql
```

Essa abordagem eliminou a necessidade de expor SSH do Viper-II publicamente.

---

# Preparação do diretório no Viper-II

Foi criado:

```bash
sudo mkdir -p /srv/projects
```

O projeto foi extraído:

```bash
sudo tar xzf /tmp/copa_migracao_20260810.tar.gz \
  -C /srv/projects
```

Permissões ajustadas:

```bash
sudo chown -R \
  fernando-murashima:fernando-murashima \
  /srv/projects/copa
```

Resultado:

```text
/srv/projects/copa/backend
/srv/projects/copa/frontend
```

---

# Diretório não utilizado

Também existia:

```text
/srv/projects/copa/backend_corrompido_20260623_203943
```

Esse diretório não foi utilizado na nova infraestrutura.

---

# Preparação do banco no Viper-II

O MySQL já existia no servidor como container Docker:

```text
mysql
```

Imagem:

```text
mysql:8.0
```

Foi criado o banco:

```text
bolao2026
```

com:

```text
utf8mb4
utf8mb4_unicode_ci
```

Estrutura conceitual:

```sql
CREATE DATABASE IF NOT EXISTS bolao2026
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;
```

---

# Criação do usuário do banco

Foi criado:

```text
bolao_user
```

com permissão sobre:

```text
bolao2026.*
```

Estrutura:

```sql
CREATE USER IF NOT EXISTS 'bolao_user'@'%'
IDENTIFIED BY 'SENHA_NAO_DOCUMENTADA';

GRANT ALL PRIVILEGES
ON bolao2026.*
TO 'bolao_user'@'%';

FLUSH PRIVILEGES;
```

---

# Restauração do banco

Foi executado:

```bash
docker exec -i mysql mysql \
  -uroot \
  -p'SENHA_ROOT' \
  bolao2026 \
  < /tmp/bolao2026_migracao_20260810.sql
```

A senha real não deve ser armazenada na documentação.

---

# Validação do banco

Foi utilizado:

```bash
docker exec mysql mysql \
  -uroot \
  -p'SENHA_ROOT' \
  -e "USE bolao2026; SHOW TABLES;"
```

Tabelas confirmadas:

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

# Ajuste do Django para Docker

Na KingHost:

```text
HOST = localhost
```

No Docker:

```text
HOST = mysql
```

Arquivo:

```text
/srv/projects/copa/backend/bolao2026/settings.py
```

Alteração:

```python
"HOST": "mysql",
```

Motivo:

Dentro do container backend, `localhost` seria o próprio container Django.

O hostname Docker correto do banco é:

```text
mysql
```

---

# Criação do Dockerfile do backend

Arquivo:

```text
/srv/projects/copa/backend/Dockerfile
```

Conteúdo:

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

# Build do backend

```bash
cd /srv/projects/copa/backend
```

```bash
docker build -t bolao-backend .
```

Imagem criada:

```text
bolao-backend:latest
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

Container:

```text
bolao-backend
```

Rede:

```text
infra
```

---

# Validação dos logs do backend

```bash
docker logs bolao-backend --tail 50
```

Foi confirmado:

```text
Starting gunicorn
Listening at: http://0.0.0.0:8001
Using worker: sync
3 workers iniciados
```

---

# Primeiro teste interno

Inicialmente foi executado:

```bash
docker run --rm \
  --network infra \
  curlimages/curl:latest \
  -I \
  http://bolao-backend:8001/admin/
```

Resultado:

```text
400 Bad Request
```

Isso não significava falha do backend.

O Django rejeitou o hostname:

```text
bolao-backend
```

porque não estava em:

```text
ALLOWED_HOSTS
```

---

# Teste correto utilizando Host real

Foi realizado:

```bash
docker run --rm \
  --network infra \
  curlimages/curl:latest \
  -I \
  -H "Host: fernandomurashima.com.br" \
  http://bolao-backend:8001/admin/
```

Resultado:

```text
HTTP/1.1 302 Found
```

Redirecionamento:

```text
/admin/login/?next=/admin/
```

Isso confirmou o funcionamento correto do backend.

---

# Preparação do frontend

O frontend migrado continha apenas o build pronto.

Diretório:

```text
/srv/projects/copa/frontend/browser
```

Não existiam nessa pasta migrada:

```text
package.json
Dockerfile
nginx.conf
```

Foi decidido servir diretamente o build existente através de um container Nginx.

---

# Criação do nginx.conf do frontend

Arquivo:

```text
/srv/projects/copa/frontend/nginx.conf
```

Conteúdo principal:

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

---

# Dockerfile do frontend

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

# Build do frontend

```bash
cd /srv/projects/copa/frontend
```

```bash
docker build -t bolao-frontend .
```

Imagem:

```text
bolao-frontend:latest
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

# Validação do frontend

Foi realizado:

```bash
docker run --rm \
  --network infra \
  curlimages/curl:latest \
  -I \
  -H "Host: fernandomurashima.com.br" \
  http://bolao-frontend/
```

Resultado:

```text
HTTP/1.1 200 OK
```

---

# Validação frontend → backend

Admin:

```bash
docker run --rm \
  --network infra \
  curlimages/curl:latest \
  -I \
  -H "Host: fernandomurashima.com.br" \
  http://bolao-frontend/admin/
```

Resultado:

```text
HTTP/1.1 302 Found
```

Isso confirmou:

```text
bolao-frontend
        ↓
bolao-backend
```

---

# Configuração do Nginx Proxy Manager

Foi acessado:

```text
http://192.168.15.80:81
```

Foi criado Proxy Host:

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

Opções:

```text
Block Common Exploits
Websockets Support
```

---

# Validação NPM → frontend

No Viper-II:

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

# Análise do DNS antes da migração

Nameservers anteriores:

```text
a.sec.dns.br
c.sec.dns.br
```

Registros:

```text
A fernandomurashima.com.br
  → 177.153.38.27

A www.fernandomurashima.com.br
  → 177.153.38.27
```

Não existiam registros:

```text
MX
TXT
DMARC
```

---

# Adição à Cloudflare

O domínio foi adicionado à Cloudflare utilizando:

```text
Plano Free
```

A importação automática trouxe os dois registros A existentes.

---

# Nameservers Cloudflare

Foram atribuídos:

```text
kevin.ns.cloudflare.com
rayne.ns.cloudflare.com
```

---

# Alteração no Registro.br

No Registro.br:

```text
a.sec.dns.br
c.sec.dns.br
```

foram substituídos por:

```text
kevin.ns.cloudflare.com
rayne.ns.cloudflare.com
```

---

# Acompanhamento da propagação

Google DNS:

```powershell
nslookup -type=ns fernandomurashima.com.br 8.8.8.8
```

Cloudflare DNS:

```powershell
nslookup -type=ns fernandomurashima.com.br 1.1.1.1
```

Durante a propagação apareciam os servidores antigos.

Depois:

```text
kevin.ns.cloudflare.com
rayne.ns.cloudflare.com
```

passaram a ser retornados.

---

# Publicação no Cloudflare Tunnel

Tunnel utilizado:

```text
takeshivip
```

Primeiro foi migrado:

```text
www.fernandomurashima.com.br
```

Procedimento:

```text
1. remover registro A antigo do www
2. abrir Networking → Tunnels
3. abrir takeshivip
4. Routes
5. Add route
6. Published application
```

Configuração:

```text
Subdomain:
www

Domain:
fernandomurashima.com.br

Service URL:
http://localhost:80
```

---

# Publicação do domínio principal

Depois foi removido o registro A antigo de:

```text
fernandomurashima.com.br
```

Foi criada Published Application:

```text
Subdomain:
vazio

Domain:
fernandomurashima.com.br

Service URL:
http://localhost:80
```

---

# Teste DNS autoritativo

Foi utilizado:

```powershell
nslookup fernandomurashima.com.br kevin.ns.cloudflare.com
```

e:

```powershell
nslookup www.fernandomurashima.com.br kevin.ns.cloudflare.com
```

A resposta mostrou endereços da Cloudflare.

---

# Problema de cache DNS local

Depois da migração, um primeiro teste ainda chegou à KingHost.

O indício foi:

```text
Server: nginx/1.18.0 (Ubuntu)
```

Esse era o Nginx antigo da VPS.

Foi identificado cache DNS local.

Solução:

```powershell
ipconfig /flushdns
```

---

# Confirmação de acesso ao Viper-II

Depois da limpeza do cache:

```powershell
curl.exe -I https://fernandomurashima.com.br
```

Resultado:

```text
Server: cloudflare
x-served-by: fernandomurashima.com.br
```

Também:

```powershell
curl.exe -I https://www.fernandomurashima.com.br
```

Resultado:

```text
Server: cloudflare
x-served-by: www.fernandomurashima.com.br
```

Isso confirmou que o tráfego chegava ao novo servidor.

---

# Validação externa em 4G/5G

Foi utilizado celular com:

```text
Wi-Fi desligado
4G/5G ativo
```

Foi acessado:

```text
https://fernandomurashima.com.br
```

Foram validados:

```text
abertura da aplicação
login
dados
funcionamento geral
```

Resultado:

```text
SUCESSO
```

---

# Desligamento do serviço antigo

Somente depois de toda a validação foi acessada a KingHost.

Verificação:

```bash
sudo systemctl status copa.service --no-pager
```

O serviço estava:

```text
Active: active (running)
```

Foi então executado:

```bash
sudo systemctl stop copa.service
```

Resultado:

```text
Active: inactive (dead)
```

---

# Teste após desligar a KingHost

Depois de parar:

```text
copa.service
```

foi realizado novo teste externo em 4G/5G.

O Bolao2026 continuou funcionando normalmente.

Essa foi a confirmação definitiva de que a aplicação já estava sendo servida exclusivamente pelo Viper-II.

---

# Desabilitação do serviço antigo

Depois da confirmação, o serviço antigo pode permanecer desabilitado no boot:

```bash
sudo systemctl disable copa.service
```

Verificação:

```bash
sudo systemctl is-enabled copa.service
```

Esperado:

```text
disabled
```

---

# Arquivos antigos

Enquanto a VPS KingHost ainda existir, os arquivos antigos devem permanecer armazenados:

```text
/home/deploy/copa
```

Não é necessário manter o serviço rodando.

Os arquivos servem temporariamente como contingência histórica.

---

# O que não foi migrado da KingHost

Não foi reutilizado:

```text
ambiente virtual Python antigo
Certbot antigo
Nginx antigo
serviço systemd antigo
backend_corrompido
```

Esses componentes foram substituídos pela nova arquitetura.

---

# Arquitetura anterior

```text
Internet
   ↓
IP público KingHost
   ↓
Nginx Ubuntu
   ├── Angular
   └── Gunicorn
         ↓
       Django
         ↓
       MySQL
```

---

# Arquitetura nova

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
```

---

# Benefícios da nova arquitetura

```text
independência da VPS KingHost
uso de Docker
serviços isolados
proxy centralizado
DNS centralizado na Cloudflare
HTTPS gerenciado pela Cloudflare
acesso sem port forwarding
facilidade de recriação de containers
melhor controle da infraestrutura
```

---

# Pontos de atenção

A migração da aplicação foi concluída, porém a KingHost ainda pode permanecer ativa enquanto outros sistemas não forem migrados.

Não cancelar a VPS antes de concluir:

```text
migração dos demais sistemas
backup final
revisão de segurança
validação de serviços
```

---

# Segurança pós-migração

Após conclusão de toda a migração da KingHost, realizar revisão de:

```text
senha root MySQL
senha bolao_user
SECRET_KEY Django
token Cloudflare Tunnel
credenciais administrativas
credenciais utilizadas durante a migração
```

Segredos expostos durante procedimentos técnicos devem ser rotacionados.

---

# Backup pós-migração

O banco:

```text
bolao2026
```

deve fazer parte da política de backup automático do Viper-II.

Também preservar:

```text
/srv/projects/copa/backend
/srv/projects/copa/frontend/Dockerfile
/srv/projects/copa/frontend/nginx.conf
```

---

# Procedimento de rollback histórico

Enquanto a KingHost ainda estiver disponível, existe a possibilidade teórica de retorno temporário.

Isso exigiria:

```text
1. atualizar novamente o banco da KingHost
2. iniciar copa.service
3. reconfigurar DNS
4. aguardar propagação
```

Esse procedimento não deve ser utilizado sem planejamento porque os dados da produção já passam a evoluir no Viper-II após a migração.

Portanto, o backup é mais importante do que depender da VPS antiga como rollback.

---

# Checklist final da migração

```text
[x] Projeto identificado na KingHost
[x] Serviço Django identificado
[x] Nginx identificado
[x] Banco identificado
[x] Dump atualizado criado
[x] Projeto compactado
[x] Arquivos transferidos
[x] Projeto extraído no Viper-II
[x] Banco criado
[x] Banco restaurado
[x] Backend Docker criado
[x] Backend validado
[x] Frontend Docker criado
[x] Frontend validado
[x] NPM configurado
[x] NPM validado
[x] Domínio adicionado à Cloudflare
[x] Nameservers alterados
[x] Propagação validada
[x] Tunnel configurado
[x] Domínio principal publicado
[x] WWW publicado
[x] HTTPS validado
[x] Teste externo realizado
[x] Teste em 4G/5G realizado
[x] copa.service parado na KingHost
[x] Aplicação testada novamente
[x] Independência da KingHost confirmada
```

---

# Estado final

```text
Migração:
CONCLUÍDA

Data:
10/08/2026

Origem:
KingHost
177.153.38.27

Destino:
Viper-II
192.168.15.80

Backend:
bolao-backend

Frontend:
bolao-frontend

Banco:
bolao2026

Proxy:
Nginx Proxy Manager

DNS:
Cloudflare

Tunnel:
takeshivip

Domínio:
fernandomurashima.com.br
www.fernandomurashima.com.br

KingHost copa.service:
parado

Status:
PRODUÇÃO OPERACIONAL
```

---

# Documentos relacionados

- [[Bolao2026]]
- [[Contexto do Projeto/Visao Geral]]
- [[Decisões Técnicas/Arquitetura de Producao]]
- [[Infraestrutura/Servidor Viper-II]]
- [[Infraestrutura/Docker]]
- [[Infraestrutura/Banco de Dados]]
- [[Infraestrutura/Nginx Proxy Manager]]
- [[Infraestrutura/Cloudflare e DNS]]
- [[Operação/Operacao do Bolao]]
- [[Operação/Atualizacao Backend]]
- [[Operação/Atualizacao Frontend]]