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
  - viper-ii
  - ubuntu
  - docker
  - servidor
---

# Servidor Viper-II

## Identificação

O servidor atual de produção do Bolao2026 é o notebook:

```text
Viper-II
```

Usuário principal:

```text
fernando-murashima
```

IP local:

```text
192.168.15.80
```

Sistema operacional:

```text
Ubuntu 26.04 LTS
```

O equipamento substituiu a VPS da KingHost como ambiente de produção do Bolao2026.

---

# Função do servidor

O Viper-II funciona como servidor local permanente para aplicações web e serviços de infraestrutura.

No Bolao2026, ele é responsável por:

```text
Docker
Backend Django
Frontend Angular
MySQL
Nginx Proxy Manager
Cloudflare Tunnel
Monitoramento
```

---

# Estrutura principal de diretórios

A infraestrutura utiliza principalmente:

```text
/srv/projects
/srv/docker
/srv/backups
/srv/logs
```

Projeto Bolao2026:

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

Build frontend:

```text
/srv/projects/copa/frontend/browser
```

---

# Docker

Docker instalado no servidor:

```text
Docker 29.7.2
```

Docker Compose:

```text
Docker Compose v5.4.0
```

O usuário:

```text
fernando-murashima
```

pertence ao grupo:

```text
docker
```

permitindo executar comandos Docker sem necessidade de `sudo`.

---

# Rede Docker

Rede principal utilizada pelos serviços:

```text
infra
```

Essa rede permite comunicação por nome entre os containers.

Exemplos:

```text
bolao-frontend
bolao-backend
mysql
nginx-proxy-manager
redis
portainer
uptime-kuma
```

---

# Containers existentes

No momento da migração do Bolao2026, o servidor possuía os seguintes containers principais:

```text
bolao-backend
bolao-frontend
webfoto
webfoto-api
mysql
redis
nginx-proxy-manager
portainer
uptime-kuma
```

---

# Containers do Bolao2026

Backend:

```text
bolao-backend
```

Imagem:

```text
bolao-backend:latest
```

Frontend:

```text
bolao-frontend
```

Imagem:

```text
bolao-frontend:latest
```

Ambos utilizam:

```text
--restart always
```

e a rede:

```text
infra
```

---

# MySQL

Container:

```text
mysql
```

Imagem:

```text
mysql:8.0
```

Banco utilizado pelo Bolao2026:

```text
bolao2026
```

O backend acessa o banco através de:

```text
Host: mysql
Porta: 3306
```

---

# Redis

O servidor possui também:

```text
redis
```

Imagem:

```text
redis:7
```

O Redis faz parte da infraestrutura geral e pode ser utilizado por aplicações que necessitem cache, filas ou tarefas assíncronas.

---

# Nginx Proxy Manager

Container:

```text
nginx-proxy-manager
```

Portas publicadas no host:

```text
80
81
443
```

Interface administrativa:

```text
http://192.168.15.80:81
```

O Nginx Proxy Manager recebe o tráfego entregue pelo Cloudflare Tunnel.

Para o Bolao2026, encaminha:

```text
fernandomurashima.com.br
www.fernandomurashima.com.br
```

para:

```text
bolao-frontend:80
```

---

# Portainer

Container:

```text
portainer
```

Interface:

```text
https://192.168.15.80:9443
```

O Portainer permite administração visual dos containers, volumes, redes e imagens Docker.

---

# Uptime Kuma

Container:

```text
uptime-kuma
```

Utilizado para monitoramento dos serviços do servidor.

O Bolao2026 deverá permanecer incluído na estratégia de monitoramento do Viper-II.

---

# Cloudflare Tunnel

O `cloudflared` não executa em container.

Ele está instalado diretamente no Ubuntu como serviço systemd.

Serviço:

```text
cloudflared
```

Verificação:

```bash
sudo systemctl status cloudflared --no-pager
```

O serviço está configurado para iniciar automaticamente junto com o sistema.

Tunnel:

```text
takeshivip
```

O Tunnel possui rotas públicas para diferentes aplicações hospedadas no servidor.

Para o Bolao2026:

```text
fernandomurashima.com.br
www.fernandomurashima.com.br
```

Destino:

```text
http://localhost:80
```

---

# Fluxo de rede

```text
Internet
   ↓
Cloudflare
   ↓
Cloudflare Tunnel
   ↓
localhost:80
   ↓
Nginx Proxy Manager
   ↓
Rede Docker infra
   ↓
bolao-frontend
   ↓
bolao-backend
   ↓
mysql
```

---

# Ausência de exposição direta

O Bolao2026 não depende de encaminhamento de porta pública no roteador.

O acesso externo é realizado pelo Cloudflare Tunnel.

Isso significa que a aplicação não depende de:

```text
IP público fixo
Port forwarding no roteador
Abertura direta da porta 80
Abertura direta da porta 443
```

O Tunnel cria conexão de saída do Viper-II para a Cloudflare.

---

# Configuração para funcionamento com a tampa fechada

Como o Viper-II é um notebook utilizado como servidor, foi configurado para continuar funcionando mesmo com a tampa fechada.

Arquivo:

```text
/etc/systemd/logind.conf
```

Configurações:

```text
HandleLidSwitch=ignore
HandleLidSwitchExternalPower=ignore
HandleLidSwitchDocked=ignore
```

Isso evita que o equipamento suspenda automaticamente ao fechar a tampa.

---

# Reinicialização do servidor

Após reinicialização do Viper-II, verificar:

```bash
docker ps
```

Os containers configurados com:

```text
--restart always
```

devem voltar automaticamente.

Verificar também:

```bash
sudo systemctl status cloudflared --no-pager
```

O esperado é:

```text
active (running)
```

---

# Verificação rápida do Bolao2026

Containers:

```bash
docker ps | grep bolao
```

Esperado:

```text
bolao-backend
bolao-frontend
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

Teste externo:

```text
https://fernandomurashima.com.br
```

---

# Verificação do backend

Logs:

```bash
docker logs bolao-backend --tail 50
```

Acompanhar em tempo real:

```bash
docker logs -f bolao-backend
```

---

# Verificação do frontend

Logs:

```bash
docker logs bolao-frontend --tail 50
```

---

# Verificação do MySQL

Container:

```bash
docker ps | grep mysql
```

Acesso administrativo:

```bash
docker exec -it mysql mysql -uroot -p
```

Dentro do MySQL:

```sql
USE bolao2026;
SHOW TABLES;
```

---

# Verificação da rede Docker

```bash
docker network inspect infra
```

O resultado deve mostrar os containers conectados à rede.

Entre eles:

```text
bolao-backend
bolao-frontend
mysql
nginx-proxy-manager
```

---

# Diretórios importantes do Bolao2026

Backend:

```text
/srv/projects/copa/backend
```

Frontend:

```text
/srv/projects/copa/frontend
```

Build frontend:

```text
/srv/projects/copa/frontend/browser
```

Dockerfile backend:

```text
/srv/projects/copa/backend/Dockerfile
```

Dockerfile frontend:

```text
/srv/projects/copa/frontend/Dockerfile
```

Nginx frontend:

```text
/srv/projects/copa/frontend/nginx.conf
```

---

# Arquivos temporários utilizados durante a migração

Durante a migração foram utilizados:

```text
/tmp/copa_migracao_20260810.tar.gz
/tmp/bolao2026_migracao_20260810.sql
```

Esses arquivos não fazem parte da operação normal da aplicação.

Podem ser removidos posteriormente, desde que existam backups adequados e a migração esteja definitivamente encerrada.

---

# Segurança

Credenciais não devem ser registradas nesta documentação.

Itens sensíveis existentes na infraestrutura incluem:

```text
senha root MySQL
senha bolao_user
token Cloudflare Tunnel
senhas administrativas
SECRET_KEY Django
```

Esses itens devem ser armazenados separadamente.

---

# Atualizações do sistema operacional

O servidor deve permanecer atualizado.

Comandos básicos:

```bash
sudo apt update
sudo apt upgrade
```

Atualizações devem ser feitas com cuidado para evitar indisponibilidade inesperada dos serviços.

Após atualizações críticas ou reboot, validar:

```bash
docker ps
sudo systemctl status cloudflared --no-pager
```

e acessar:

```text
https://fernandomurashima.com.br
```

---

# Cuidados operacionais

Não executar comandos como:

```bash
docker system prune -a
```

sem verificar previamente quais imagens, volumes e containers serão removidos.

Não apagar volumes Docker sem backup.

Especialmente:

```text
mysql_data
```

pois contém dados persistentes do MySQL.

---

# Persistência

Os containers podem ser recriados.

Os dados importantes devem permanecer fora da camada descartável dos containers.

No caso do MySQL, a persistência é realizada através do volume:

```text
mysql_data
```

A aplicação Bolao2026 pode ter seus containers recriados sem perder o banco, desde que o volume do MySQL permaneça intacto.

---

# Dependências para funcionamento do Bolao2026

O funcionamento completo depende de:

```text
Ubuntu operacional
Docker operacional
Rede Docker infra
mysql ativo
bolao-backend ativo
bolao-frontend ativo
nginx-proxy-manager ativo
cloudflared ativo
Cloudflare DNS operacional
Internet disponível no Viper-II
```

---

# Ordem lógica de diagnóstico

Caso o site não abra, verificar nesta ordem:

```text
1. Internet do Viper-II
2. cloudflared
3. nginx-proxy-manager
4. bolao-frontend
5. bolao-backend
6. mysql
7. DNS Cloudflare
```

Comandos iniciais:

```bash
docker ps

sudo systemctl status cloudflared --no-pager

docker logs bolao-frontend --tail 50

docker logs bolao-backend --tail 50
```

---

# Estado atual

```text
Servidor: Viper-II
Usuário: fernando-murashima
IP local: 192.168.15.80
Sistema: Ubuntu 26.04 LTS
Docker: 29.7.2
Docker Compose: v5.4.0
Rede Docker: infra
Projeto: /srv/projects/copa
Frontend: bolao-frontend
Backend: bolao-backend
Banco: bolao2026
MySQL: mysql:8.0
Proxy: nginx-proxy-manager
Tunnel: takeshivip
Domínio: fernandomurashima.com.br
Status: PRODUÇÃO OPERACIONAL
```

---

# Documentos relacionados

- [[Bolao2026]]
- [[Contexto do Projeto/Visao Geral]]
- [[Decisões Técnicas/Arquitetura de Producao]]
- [[Infraestrutura/Docker]]
- [[Infraestrutura/Banco de Dados]]
- [[Infraestrutura/Nginx Proxy Manager]]
- [[Infraestrutura/Cloudflare e DNS]]
- [[Migração KingHost/Migracao KingHost para Viper-II]]
- [[Operação/Operacao do Bolao]]
- [[Operação/Atualizacao Backend]]
- [[Operação/Atualizacao Frontend]]