---
type: documentation
status: active
project: Bolao2026
category: operacao
created: 2026-08-10
updated: 2026-08-10
tags:
  - bolao2026
  - operacao
  - docker
  - monitoramento
  - manutencao
---

# Operacao do Bolao

## Objetivo

Esta nota reúne os principais procedimentos operacionais do **Bolao2026** no servidor `Viper-II`.

Ela deve ser utilizada para:

```text
verificar se o sistema está funcionando
consultar containers
consultar logs
reiniciar serviços
testar frontend
testar backend
testar banco
testar Cloudflare Tunnel
diagnosticar indisponibilidade
validar o sistema após reboot
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

Projeto:

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

# Componentes principais

```text
bolao-frontend
bolao-backend
mysql
nginx-proxy-manager
cloudflared
```

Rede Docker:

```text
infra
```

Domínio:

```text
fernandomurashima.com.br
www.fernandomurashima.com.br
```

---

# Fluxo completo

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

# Acesso ao servidor

A partir de outro computador da rede local:

```powershell
ssh fernando-murashima@192.168.15.80
```

Depois de entrar, os comandos desta nota podem ser executados diretamente no Viper-II.

---

# Verificação rápida do sistema

O primeiro comando a executar normalmente é:

```bash
docker ps
```

Para visualizar somente os containers do Bolao2026:

```bash
docker ps | grep bolao
```

Esperado:

```text
bolao-backend
bolao-frontend
```

Também devem estar ativos:

```text
mysql
nginx-proxy-manager
```

---

# Verificação rápida completa

Executar:

```bash
docker ps
```

Depois:

```bash
sudo systemctl status cloudflared --no-pager
```

Depois:

```bash
curl -I \
  -H "Host: fernandomurashima.com.br" \
  http://127.0.0.1/
```

Resultado esperado:

```text
HTTP/1.1 200 OK
```

Depois testar externamente:

```text
https://fernandomurashima.com.br
```

---

# Verificar backend

Container:

```text
bolao-backend
```

Status:

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

Interromper acompanhamento dos logs:

```text
Ctrl+C
```

---

# Verificar frontend

Container:

```text
bolao-frontend
```

Status:

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

# Verificar MySQL

Container:

```text
mysql
```

Status:

```bash
docker ps | grep mysql
```

Logs:

```bash
docker logs mysql --tail 100
```

---

# Acessar MySQL

```bash
docker exec -it mysql mysql -uroot -p
```

Informar a senha quando solicitada.

Depois:

```sql
USE bolao2026;
```

Listar tabelas:

```sql
SHOW TABLES;
```

Sair:

```sql
exit;
```

---

# Testar Django

Executar:

```bash
docker exec bolao-backend python manage.py check
```

Se estiver tudo correto, o Django deve concluir sem apresentar erro crítico.

---

# Verificar migrations

```bash
docker exec bolao-backend python manage.py showmigrations
```

Verificar migrations pendentes:

```bash
docker exec bolao-backend python manage.py migrate --check
```

Aplicar migrations:

```bash
docker exec bolao-backend python manage.py migrate
```

---

# Testar backend diretamente

O backend não possui porta publicada no host.

Ele deve ser testado pela rede Docker:

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

Redirecionamento:

```text
/admin/login/?next=/admin/
```

---

# Testar frontend diretamente

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

# Testar frontend → backend

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

# Testar Nginx Proxy Manager

No próprio Viper-II:

```bash
curl -I \
  -H "Host: fernandomurashima.com.br" \
  http://127.0.0.1/
```

Esperado:

```text
HTTP/1.1 200 OK
```

Isso confirma:

```text
Nginx Proxy Manager
        ↓
bolao-frontend
```

---

# Testar Admin pelo NPM

```bash
curl -I \
  -H "Host: fernandomurashima.com.br" \
  http://127.0.0.1/admin/
```

Esperado:

```text
HTTP/1.1 302 Found
```

---

# Testar acesso externo

No Windows:

```powershell
curl.exe -I https://fernandomurashima.com.br
```

Esperado:

```text
HTTP/1.1 200 OK
Server: cloudflare
```

Também:

```powershell
curl.exe -I https://www.fernandomurashima.com.br
```

---

# Teste funcional externo

Além do `curl`, realizar teste real no navegador.

Verificar:

```text
abertura da aplicação
login
consulta dos dados
jogos
palpites
resultados
```

Para validação completa da internet externa, utilizar celular com:

```text
Wi-Fi desligado
4G/5G ativo
```

---

# Verificar Cloudflare Tunnel

Serviço:

```bash
sudo systemctl status cloudflared --no-pager
```

Esperado:

```text
active (running)
```

---

# Reiniciar Cloudflare Tunnel

Somente se necessário:

```bash
sudo systemctl restart cloudflared
```

Depois:

```bash
sudo systemctl status cloudflared --no-pager
```

ATENÇÃO:

O mesmo Tunnel atende outras aplicações do servidor.

Reiniciar o cloudflared pode causar pequena interrupção em mais de um sistema.

---

# Verificar Nginx Proxy Manager

```bash
docker ps | grep nginx-proxy-manager
```

Logs:

```bash
docker logs nginx-proxy-manager --tail 100
```

---

# Reiniciar Nginx Proxy Manager

Somente quando necessário:

```bash
docker restart nginx-proxy-manager
```

ATENÇÃO:

O NPM atende outras aplicações do Viper-II.

---

# Reiniciar backend

```bash
docker restart bolao-backend
```

Depois verificar:

```bash
docker logs bolao-backend --tail 50
```

---

# Reiniciar frontend

```bash
docker restart bolao-frontend
```

Depois:

```bash
docker logs bolao-frontend --tail 50
```

---

# Reiniciar MySQL

Somente se realmente necessário:

```bash
docker restart mysql
```

ATENÇÃO:

O MySQL é compartilhado por outras aplicações.

Esse comando pode causar indisponibilidade temporária em mais de um sistema.

---

# Ordem recomendada de diagnóstico

Se:

```text
https://fernandomurashima.com.br
```

não abrir, verificar nesta ordem:

```text
1. Internet do Viper-II
2. cloudflared
3. Nginx Proxy Manager
4. bolao-frontend
5. bolao-backend
6. mysql
7. DNS da Cloudflare
```

---

# Diagnóstico — site completamente fora do ar

Executar:

```bash
docker ps
```

Depois:

```bash
sudo systemctl status cloudflared --no-pager
```

Depois:

```bash
curl -I \
  -H "Host: fernandomurashima.com.br" \
  http://127.0.0.1/
```

Se o `curl` local funcionar mas o domínio externo não, investigar:

```text
Cloudflare
Tunnel
DNS
Internet
```

---

# Diagnóstico — erro 502

Se aparecer:

```text
502 Bad Gateway
```

verificar:

```bash
docker ps | grep bolao-frontend
```

e:

```bash
docker network inspect infra
```

Depois verificar logs do NPM:

```bash
docker logs nginx-proxy-manager --tail 100
```

---

# Diagnóstico — frontend abre, mas API não funciona

Se a tela Angular abrir, mas chamadas da API falharem:

```bash
docker ps | grep bolao-backend
```

Depois:

```bash
docker logs bolao-backend --tail 100
```

Depois:

```bash
docker run --rm \
  --network infra \
  curlimages/curl:latest \
  -I \
  -H "Host: fernandomurashima.com.br" \
  http://bolao-backend:8001/admin/
```

---

# Diagnóstico — backend não conecta ao MySQL

Verificar:

```bash
docker ps | grep mysql
```

Depois:

```bash
docker network inspect infra
```

Devem estar na rede:

```text
bolao-backend
mysql
```

Configuração esperada:

```text
HOST = mysql
PORT = 3306
```

---

# Diagnóstico — erro de banco

Logs:

```bash
docker logs bolao-backend --tail 100
```

Possíveis erros:

```text
Access denied
Unknown database
Can't connect to MySQL server
OperationalError
```

---

# Diagnóstico — problema de migrations

Executar:

```bash
docker exec bolao-backend python manage.py migrate --check
```

Se necessário:

```bash
docker exec bolao-backend python manage.py migrate
```

---

# Diagnóstico — container não inicia

Ver todos:

```bash
docker ps -a
```

Depois:

```bash
docker logs bolao-backend --tail 100
```

ou:

```bash
docker logs bolao-frontend --tail 100
```

---

# Diagnóstico — container reiniciando

Ver:

```bash
docker ps
```

Se o status mostrar reinícios contínuos:

```bash
docker logs NOME_DO_CONTAINER --tail 100
```

Exemplo:

```bash
docker logs bolao-backend --tail 100
```

---

# Diagnóstico — domínio resolve endereço antigo

No Windows:

```powershell
nslookup fernandomurashima.com.br 1.1.1.1
```

Depois:

```powershell
nslookup fernandomurashima.com.br 8.8.8.8
```

Se o computador estiver usando cache antigo:

```powershell
ipconfig /flushdns
```

---

# Verificar nameservers

```powershell
nslookup -type=ns fernandomurashima.com.br 8.8.8.8
```

Esperado:

```text
kevin.ns.cloudflare.com
rayne.ns.cloudflare.com
```

---

# Acesso ao Nginx Proxy Manager

Na rede local:

```text
http://192.168.15.80:81
```

Proxy Host esperado:

```text
fernandomurashima.com.br
www.fernandomurashima.com.br
        ↓
bolao-frontend:80
```

---

# Acesso ao Portainer

```text
https://192.168.15.80:9443
```

O Portainer pode ser usado para visualizar:

```text
status dos containers
logs
imagens
rede infra
volumes
```

---

# Uptime Kuma

O Uptime Kuma faz parte da infraestrutura de monitoramento.

Container:

```text
uptime-kuma
```

O Bolao2026 deve possuir monitor para:

```text
https://fernandomurashima.com.br
```

Sempre que possível, monitorar também os principais componentes internos.

---

# Verificar recursos do servidor

Uso de memória:

```bash
free -h
```

Uso de disco:

```bash
df -h
```

Processos:

```bash
top
```

ou:

```bash
htop
```

se disponível.

---

# Ver uso dos containers

```bash
docker stats
```

Sair:

```text
Ctrl+C
```

Esse comando ajuda a identificar consumo excessivo de:

```text
CPU
memória
rede
```

---

# Ver espaço utilizado pelo Docker

```bash
docker system df
```

Não realizar limpeza automática apenas porque existem imagens antigas.

Primeiro analisar.

---

# Cuidado com limpeza Docker

Não executar indiscriminadamente:

```bash
docker system prune -a
```

e principalmente não remover volumes sem análise.

O volume crítico do banco é:

```text
mysql_data
```

---

# Após reinicialização do Viper-II

Executar:

```bash
docker ps
```

Depois:

```bash
sudo systemctl status cloudflared --no-pager
```

Confirmar:

```text
bolao-backend
bolao-frontend
mysql
nginx-proxy-manager
```

Depois:

```bash
curl -I \
  -H "Host: fernandomurashima.com.br" \
  http://127.0.0.1/
```

Depois acessar:

```text
https://fernandomurashima.com.br
```

---

# Se o servidor foi desligado por falta de energia

Após retornar:

```text
1. confirmar conexão de rede
2. confirmar IP local 192.168.15.80
3. docker ps
4. verificar cloudflared
5. testar domínio
```

Ver IP:

```bash
ip addr
```

ou:

```bash
hostname -I
```

---

# Verificar Docker ativo

```bash
systemctl status docker --no-pager
```

Se necessário:

```bash
sudo systemctl start docker
```

---

# Reiniciar Docker

Somente se houver problema real no daemon:

```bash
sudo systemctl restart docker
```

ATENÇÃO:

Isso pode interromper temporariamente todos os containers do servidor.

---

# Rotina recomendada de verificação

Periodicamente verificar:

```text
site externo
containers
espaço em disco
logs
backup
Uptime Kuma
atualizações do Ubuntu
```

Comandos básicos:

```bash
docker ps
df -h
free -h
docker system df
```

---

# Rotina após atualização do backend

Depois de atualizar:

```bash
docker logs bolao-backend --tail 50
```

Depois:

```bash
docker exec bolao-backend python manage.py migrate --check
```

Depois:

```text
https://fernandomurashima.com.br
```

---

# Rotina após atualização do frontend

Depois de atualizar:

```bash
docker ps | grep bolao-frontend
```

Depois:

```bash
curl -I \
  -H "Host: fernandomurashima.com.br" \
  http://127.0.0.1/
```

Depois testar no navegador.

---

# Backup

O banco:

```text
bolao2026
```

deve possuir backup automático.

A política geral de backup do Viper-II deverá ser documentada separadamente.

Além do banco, preservar:

```text
Dockerfiles
nginx.conf
configuração de infraestrutura
documentação
```

---

# Segurança

Nunca registrar ou compartilhar em procedimentos comuns:

```text
senha root MySQL
senha bolao_user
token Cloudflare Tunnel
SECRET_KEY Django
senhas administrativas
```

Caso seja necessário usar uma senha em terminal, evitar mantê-la no histórico sempre que possível.

---

# Componentes que não devem ser alterados em deploy normal

Não alterar durante atualização comum:

```text
Cloudflare
DNS
nameservers
Tunnel
Nginx Proxy Manager
MySQL
rede infra
```

Atualizar apenas:

```text
backend
frontend
```

conforme necessário.

---

# Checklist rápido de saúde

```text
[ ] Viper-II ligado
[ ] Internet funcionando
[ ] Docker ativo
[ ] mysql ativo
[ ] bolao-backend ativo
[ ] bolao-frontend ativo
[ ] nginx-proxy-manager ativo
[ ] cloudflared ativo
[ ] domínio abrindo
[ ] login funcionando
[ ] dados carregando
```

---

# Comandos rápidos

## Containers

```bash
docker ps
```

## Bolao

```bash
docker ps | grep bolao
```

## Backend logs

```bash
docker logs bolao-backend --tail 50
```

## Frontend logs

```bash
docker logs bolao-frontend --tail 50
```

## MySQL logs

```bash
docker logs mysql --tail 50
```

## NPM logs

```bash
docker logs nginx-proxy-manager --tail 50
```

## Tunnel

```bash
sudo systemctl status cloudflared --no-pager
```

## Teste local

```bash
curl -I \
  -H "Host: fernandomurashima.com.br" \
  http://127.0.0.1/
```

## Teste externo

```powershell
curl.exe -I https://fernandomurashima.com.br
```

---

# Estado operacional esperado

```text
Servidor:
Viper-II

IP:
192.168.15.80

Backend:
bolao-backend
UP

Frontend:
bolao-frontend
UP

Banco:
mysql
UP

Proxy:
nginx-proxy-manager
UP

Tunnel:
cloudflared
active

Domínio:
fernandomurashima.com.br
ONLINE

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
- [[Migração KingHost/Migracao KingHost para Viper-II]]
- [[Operação/Atualizacao Backend]]
- [[Operação/Atualizacao Frontend]]