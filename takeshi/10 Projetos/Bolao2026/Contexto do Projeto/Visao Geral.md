---
type: documentation
status: active
project: Bolao2026
category: contexto
created: 2026-08-10
updated: 2026-08-10
tags:
  - bolao2026
  - contexto
  - django
  - angular
  - producao
---

# Visao Geral

## Objetivo do projeto

O **Bolao2026** é uma aplicação web destinada ao gerenciamento de bolão de futebol.

O sistema permite centralizar o cadastro das informações da competição, usuários, jogos, palpites, resultados e pontuação.

A aplicação possui frontend web, backend com API e banco de dados relacional.

---

# Tecnologias utilizadas

## Backend

O backend utiliza:

```text
Python
Django 4.2.11
Django REST Framework 3.14.0
Gunicorn
MySQL
```

Principais extensões utilizadas:

```text
django-cors-headers
django-filter
django-extensions
drf-yasg
mysqlclient
python-decouple
celery
redis
```

---

# Frontend

O frontend é desenvolvido em:

```text
Angular
```

Em produção, o frontend é compilado no notebook de desenvolvimento utilizando:

```powershell
ng build
```

O conteúdo gerado é transferido para o servidor Viper-II e servido por Nginx dentro do container:

```text
bolao-frontend
```

---

# Banco de dados

O sistema utiliza MySQL.

Banco de produção:

```text
bolao2026
```

O MySQL executa em container Docker no servidor Viper-II.

Container:

```text
mysql
```

Imagem:

```text
mysql:8.0
```

---

# Domínios

Domínio principal:

```text
fernandomurashima.com.br
```

Domínio alternativo:

```text
www.fernandomurashima.com.br
```

Ambos são publicados através da Cloudflare.

---

# Ambiente de desenvolvimento

O projeto é desenvolvido em notebook Windows.

Diretório principal:

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

---

# Ambiente de produção

Servidor:

```text
Viper-II
```

Usuário:

```text
fernando-murashima
```

IP local:

```text
192.168.15.80
```

Sistema operacional:

```text
Ubuntu
```

O projeto está armazenado em:

```text
/srv/projects/copa
```

Backend:

```text
/srv/projects/copa/backend
```

Frontend:

```text
/srv/projects/copa/frontend
```

---

# Containers da aplicação

Backend:

```text
bolao-backend
```

Frontend:

```text
bolao-frontend
```

Banco:

```text
mysql
```

Os containers utilizam a rede Docker:

```text
infra
```

---

# Publicação do sistema

O acesso externo utiliza Cloudflare Tunnel.

Fluxo:

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
   ↓
bolao-backend
   ↓
MySQL
```

---

# Responsabilidade de cada componente

## Cloudflare DNS

Responsável pela resolução pública dos domínios:

```text
fernandomurashima.com.br
www.fernandomurashima.com.br
```

---

## Cloudflare Tunnel

Responsável por criar a conexão segura entre a Cloudflare e o servidor Viper-II.

O servidor não precisa ficar exposto diretamente à internet.

---

## Nginx Proxy Manager

Responsável por identificar o hostname solicitado e encaminhar a requisição para o container correto.

Para o Bolao2026:

```text
fernandomurashima.com.br
        ↓
bolao-frontend:80
```

---

## bolao-frontend

Responsável por servir o build Angular.

Também encaminha:

```text
/api/
```

e:

```text
/admin/
```

para:

```text
bolao-backend:8001
```

---

## bolao-backend

Responsável pela aplicação Django.

Executa através do Gunicorn na porta:

```text
8001
```

---

## MySQL

Responsável pelo armazenamento dos dados.

Banco:

```text
bolao2026
```

---

# Funcionalidades existentes na base

Entre as estruturas existentes no banco estão:

```text
Usuários
Times
Jogadores
Torneios
Fases
Jogos
Eventos de partidas
Palpites
Palpites extras
Resultados extras
Tokens de autenticação
Sessões Django
```

As tabelas principais incluem:

```text
accounts_user
copa_team
copa_player
copa_tournament
copa_stage
copa_match
copa_matchevent
copa_bet
copa_extrabet
copa_extraresult
```

---

# Histórico de hospedagem

Antes da migração, o sistema estava hospedado na VPS da KingHost.

Servidor antigo:

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

Projeto antigo:

```text
/home/deploy/copa
```

Serviço responsável pelo backend:

```text
copa.service
```

O backend utilizava Gunicorn diretamente no sistema operacional da VPS.

O frontend era servido pelo Nginx instalado na VPS.

O MySQL também executava diretamente na infraestrutura da KingHost.

---

# Migração para o Viper-II

Em 10/08/2026 o Bolao2026 foi migrado da KingHost para o servidor Viper-II.

Foram migrados:

```text
Backend
Frontend
Banco MySQL
Publicação do domínio
Proxy reverso
DNS
Acesso HTTPS
```

A arquitetura foi alterada para utilização de containers Docker.

---

# Situação após a migração

O Bolao2026 não depende mais da KingHost para operar.

O serviço antigo:

```text
copa.service
```

foi parado.

Depois disso, o sistema continuou funcionando normalmente através do Viper-II.

A aplicação foi validada externamente utilizando conexão 4G/5G.

---

# Fluxo de desenvolvimento e produção

## Backend

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
bolao-backend
```

---

## Frontend

```text
Notebook de desenvolvimento
        ↓
ng build
        ↓
SCP
        ↓
Viper-II
        ↓
docker build
        ↓
bolao-frontend
```

---

# Princípios adotados

A infraestrutura atual foi organizada considerando:

```text
Separação entre aplicação e banco
Uso de Docker
Rede interna entre containers
Acesso externo sem abertura direta de portas públicas
Proxy reverso centralizado
DNS administrado pela Cloudflare
Deploy controlado
Possibilidade de rollback
```

---

# Estado atual

```text
Projeto: Bolao2026
Status: Produção
Servidor: Viper-II
IP local: 192.168.15.80
Backend: bolao-backend
Frontend: bolao-frontend
Banco: bolao2026
Banco Server: mysql
Rede Docker: infra
Domínio: fernandomurashima.com.br
DNS: Cloudflare
Acesso externo: Cloudflare Tunnel
Proxy: Nginx Proxy Manager
```

---

# Documentos relacionados

- [[Bolao2026]]
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