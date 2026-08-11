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
  - nginx
  - nginx-proxy-manager
  - proxy
  - viper-ii
---

# Nginx Proxy Manager

## Objetivo

Esta nota documenta o uso do **Nginx Proxy Manager** no ambiente de produção do Bolao2026 no servidor `Viper-II`.

O Nginx Proxy Manager atua como proxy reverso central do servidor.

Ele recebe as requisições entregues pelo Cloudflare Tunnel e, de acordo com o domínio solicitado, encaminha o tráfego para o container correto.

No caso do Bolao2026:

```text
fernandomurashima.com.br
www.fernandomurashima.com.br
```

são encaminhados para:

```text
bolao-frontend:80
```

---

# Ambiente

Servidor:

```text
Viper-II
```

IP local:

```text
192.168.15.80
```

Container:

```text
nginx-proxy-manager
```

Imagem:

```text
jc21/nginx-proxy-manager:latest
```

Rede Docker:

```text
infra
```

---

# Portas publicadas

O Nginx Proxy Manager publica no host:

```text
80
81
443
```

Funções:

```text
80  → HTTP
81  → painel administrativo
443 → HTTPS
```

---

# Interface administrativa

A interface administrativa pode ser acessada pela rede local:

```text
http://192.168.15.80:81
```

O acesso exige autenticação administrativa.

As credenciais não devem ser registradas nesta documentação.

---

# Função dentro da arquitetura

Fluxo do Bolao2026:

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
bolao-frontend:80
```

O Nginx Proxy Manager não precisa conhecer diretamente:

```text
bolao-backend
mysql
```

Ele encaminha somente para o frontend.

O próprio frontend é responsável por encaminhar:

```text
/api/
```

e:

```text
/admin/
```

para o backend.

---

# Proxy Host do Bolao2026

Foi criado um Proxy Host com a seguinte configuração:

```text
Domain Names:
fernandomurashima.com.br
www.fernandomurashima.com.br
```

Scheme:

```text
http
```

Forward Hostname / IP:

```text
bolao-frontend
```

Forward Port:

```text
80
```

---

# Opções habilitadas

Foram habilitadas:

```text
Block Common Exploits
Websockets Support
```

Essas opções permanecem ativas no Proxy Host do Bolao2026.

---

# SSL no Nginx Proxy Manager

Não foi necessário configurar certificado SSL específico no Nginx Proxy Manager para o Bolao2026.

O HTTPS público é fornecido pela Cloudflare.

Fluxo:

```text
Usuário
   ↓ HTTPS
Cloudflare
   ↓ Cloudflare Tunnel
Viper-II
   ↓ HTTP interno
Nginx Proxy Manager
```

Assim, entre o Cloudflare Tunnel e o NPM é utilizado:

```text
http://localhost:80
```

---

# Por que o destino é bolao-frontend

O frontend é o ponto de entrada da aplicação.

O container:

```text
bolao-frontend
```

serve:

```text
HTML
JavaScript
CSS
imagens
fontes
```

e também encaminha:

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

Portanto, o NPM precisa encaminhar apenas para:

```text
bolao-frontend:80
```

---

# Comunicação pela rede Docker

O container:

```text
nginx-proxy-manager
```

e o container:

```text
bolao-frontend
```

estão conectados à rede:

```text
infra
```

Por isso, o NPM consegue utilizar diretamente o nome:

```text
bolao-frontend
```

como hostname.

Não é necessário utilizar IP interno do container.

---

# Vantagem de utilizar nome Docker

O IP interno de um container pode mudar quando ele é recriado.

O nome:

```text
bolao-frontend
```

permanece estável.

Portanto, a configuração correta no NPM é:

```text
Forward Hostname:
bolao-frontend
```

e não um endereço como:

```text
172.x.x.x
```

---

# Teste local do Proxy Host

Depois da configuração, foi realizado teste diretamente no Viper-II.

Comando:

```bash
curl -I \
  -H "Host: fernandomurashima.com.br" \
  http://127.0.0.1/
```

Resultado:

```text
HTTP/1.1 200 OK
```

O cabeçalho mostrou:

```text
Server: openresty
```

confirmando passagem pelo Nginx Proxy Manager.

---

# Teste do Django Admin pelo NPM

Comando:

```bash
curl -I \
  -H "Host: fernandomurashima.com.br" \
  http://127.0.0.1/admin/
```

Resultado:

```text
HTTP/1.1 302 Found
```

Redirecionamento:

```text
/admin/login/?next=/admin/
```

Isso confirmou o fluxo:

```text
NPM
 ↓
bolao-frontend
 ↓
bolao-backend
```

---

# Cabeçalho de identificação

Durante os testes, o Nginx Proxy Manager retornou:

```text
X-Served-By
```

com o hostname solicitado.

Exemplo:

```text
X-Served-By: fernandomurashima.com.br
```

Esse cabeçalho ajudou a confirmar que a requisição estava chegando ao Viper-II.

---

# Teste público após Cloudflare

Depois da ativação do Cloudflare Tunnel, o teste:

```powershell
curl.exe -I https://fernandomurashima.com.br
```

retornou:

```text
Server: cloudflare
x-served-by: fernandomurashima.com.br
```

Isso confirmou o caminho:

```text
Cloudflare
   ↓
Tunnel
   ↓
Nginx Proxy Manager
   ↓
bolao-frontend
```

---

# Configuração do frontend relacionada ao NPM

O NPM envia todo o tráfego do domínio para:

```text
bolao-frontend:80
```

Dentro do frontend, o Nginx possui regras específicas.

API:

```nginx
location /api/ {
    proxy_pass http://bolao-backend:8001;
}
```

Admin:

```nginx
location /admin/ {
    proxy_pass http://bolao-backend:8001;
}
```

Frontend Angular:

```nginx
location / {
    try_files $uri $uri/ /index.html;
}
```

---

# Fluxo de uma requisição comum

Exemplo:

```text
https://fernandomurashima.com.br
```

Fluxo:

```text
Browser
   ↓
Cloudflare
   ↓
Cloudflare Tunnel
   ↓
NPM
   ↓
bolao-frontend
   ↓
index.html
```

---

# Fluxo de uma chamada API

Exemplo:

```text
https://fernandomurashima.com.br/api/alguma-rota/
```

Fluxo:

```text
Browser
   ↓
Cloudflare
   ↓
Cloudflare Tunnel
   ↓
NPM
   ↓
bolao-frontend
   ↓
Nginx frontend
   ↓
bolao-backend:8001
   ↓
Django
   ↓
MySQL
```

---

# Fluxo do Django Admin

Exemplo:

```text
https://fernandomurashima.com.br/admin/
```

Fluxo:

```text
Browser
   ↓
Cloudflare
   ↓
Cloudflare Tunnel
   ↓
NPM
   ↓
bolao-frontend
   ↓
bolao-backend
   ↓
Django Admin
```

---

# Verificar se NPM está em execução

No Viper-II:

```bash
docker ps | grep nginx-proxy-manager
```

---

# Ver logs do NPM

```bash
docker logs nginx-proxy-manager --tail 100
```

Em tempo real:

```bash
docker logs -f nginx-proxy-manager
```

---

# Reiniciar o NPM

Se realmente necessário:

```bash
docker restart nginx-proxy-manager
```

ATENÇÃO:

O Nginx Proxy Manager atende outras aplicações do servidor.

Reiniciá-lo pode causar indisponibilidade temporária em:

```text
Bolao2026
WebFoto
outros domínios configurados
```

Portanto, não reiniciar sem necessidade.

---

# Testar comunicação NPM → frontend

Primeiro confirmar:

```bash
docker ps | grep bolao-frontend
```

Depois:

```bash
docker network inspect infra
```

Os containers:

```text
nginx-proxy-manager
bolao-frontend
```

devem aparecer conectados.

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

Se esse teste funcionar mas o teste via `127.0.0.1` falhar, o problema tende a estar no Nginx Proxy Manager.

---

# Testar NPM diretamente

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

# Erro 502 Bad Gateway

Um erro:

```text
502 Bad Gateway
```

no NPM normalmente indica que ele não conseguiu alcançar o destino.

Verificar:

```bash
docker ps | grep bolao-frontend
```

Depois:

```bash
docker network inspect infra
```

Confirmar no Proxy Host:

```text
Forward Hostname:
bolao-frontend

Forward Port:
80
```

---

# Erro de domínio incorreto

Se outro site abrir no lugar do Bolao2026, verificar os Domain Names do Proxy Host.

Devem existir:

```text
fernandomurashima.com.br
www.fernandomurashima.com.br
```

Não deve existir conflito com outro Proxy Host utilizando os mesmos domínios.

---

# Proxy Host Offline

Se o NPM mostrar o Proxy Host como offline, verificar:

```text
bolao-frontend ativo
rede infra
hostname correto
porta 80
```

Comandos:

```bash
docker ps | grep bolao-frontend
```

```bash
docker network inspect infra
```

---

# Atualizações do Bolao2026

Em uma atualização normal do:

```text
backend
```

ou:

```text
frontend
```

não é necessário alterar o Nginx Proxy Manager.

O Proxy Host permanece:

```text
fernandomurashima.com.br
www.fernandomurashima.com.br
        ↓
bolao-frontend:80
```

Mesmo quando o container frontend é recriado, ele mantém o mesmo nome:

```text
bolao-frontend
```

e volta a ser localizado pela rede Docker.

---

# Importante ao recriar o frontend

O novo container deve ser criado sempre com:

```bash
--name bolao-frontend
```

e:

```bash
--network infra
```

Exemplo:

```bash
docker run -d \
  --name bolao-frontend \
  --restart always \
  --network infra \
  bolao-frontend:latest
```

Se o nome mudar, o NPM não encontrará o frontend.

---

# Importante ao recriar a rede

A rede:

```text
infra
```

é compartilhada por vários serviços.

Não remover essa rede sem verificar todas as dependências.

---

# Volumes do Nginx Proxy Manager

A infraestrutura utiliza os volumes:

```text
npm_data
npm_letsencrypt
```

Esses volumes armazenam configurações persistentes do NPM.

Não devem ser removidos durante manutenção normal.

---

# Persistência das configurações

As configurações dos Proxy Hosts não estão somente dentro do container descartável.

Elas são persistidas nos volumes do NPM.

Isso permite recriar o container sem perder as configurações, desde que os volumes corretos sejam mantidos.

---

# Backup

A política geral de backup do servidor deve incluir as configurações persistentes do Nginx Proxy Manager.

Volumes importantes:

```text
npm_data
npm_letsencrypt
```

Além disso, a configuração lógica dos Proxy Hosts deve permanecer documentada no Obsidian.

---

# Configuração do Bolao2026 registrada

```text
DOMÍNIOS
fernandomurashima.com.br
www.fernandomurashima.com.br

SCHEME
http

DESTINO
bolao-frontend

PORTA
80

BLOCK COMMON EXPLOITS
ativado

WEBSOCKETS SUPPORT
ativado

SSL NO NPM
não utilizado para publicação pública

HTTPS
Cloudflare
```

---

# Relação com o Cloudflare Tunnel

O Cloudflare Tunnel não aponta diretamente para:

```text
bolao-frontend
```

Ele aponta para:

```text
http://localhost:80
```

Isso significa que todas as aplicações publicadas pelo mesmo Tunnel chegam primeiro ao Nginx Proxy Manager.

O NPM decide o destino pelo hostname.

Exemplo:

```text
maymurashima.com.br
        ↓
NPM
        ↓
WebFoto

fernandomurashima.com.br
        ↓
NPM
        ↓
Bolao2026
```

---

# Motivo dessa arquitetura

Esse desenho permite utilizar um único Tunnel para múltiplas aplicações.

Fluxo genérico:

```text
Cloudflare Tunnel
        ↓
NPM
        ↓
hostname A → aplicação A
hostname B → aplicação B
hostname C → aplicação C
```

Isso simplifica a administração da infraestrutura.

---

# Diagnóstico completo

Caso o Bolao2026 não abra, verificar:

```text
1. Cloudflare
2. Cloudflare Tunnel
3. Nginx Proxy Manager
4. bolao-frontend
5. bolao-backend
6. MySQL
```

No NPM, executar inicialmente:

```bash
docker ps | grep nginx-proxy-manager
```

Depois:

```bash
docker logs nginx-proxy-manager --tail 100
```

Depois:

```bash
curl -I \
  -H "Host: fernandomurashima.com.br" \
  http://127.0.0.1/
```

---

# Estado atual

```text
Servidor: Viper-II
Container: nginx-proxy-manager
Imagem: jc21/nginx-proxy-manager:latest
Rede: infra

Portas:
80
81
443

Painel:
http://192.168.15.80:81

Bolao2026:
fernandomurashima.com.br
www.fernandomurashima.com.br

Destino:
bolao-frontend:80

Block Common Exploits:
ativado

Websockets:
ativado

HTTPS público:
Cloudflare

Status:
operacional
```

---

# Documentos relacionados

- [[Bolao2026]]
- [[Contexto do Projeto/Visao Geral]]
- [[Decisões Técnicas/Arquitetura de Producao]]
- [[Infraestrutura/Servidor Viper-II]]
- [[Infraestrutura/Docker]]
- [[Infraestrutura/Banco de Dados]]
- [[Infraestrutura/Cloudflare e DNS]]
- [[Migração KingHost/Migracao KingHost para Viper-II]]
- [[Operação/Operacao do Bolao]]
- [[Operação/Atualizacao Backend]]
- [[Operação/Atualizacao Frontend]]