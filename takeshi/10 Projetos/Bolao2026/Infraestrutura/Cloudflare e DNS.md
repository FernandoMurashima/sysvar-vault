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
  - cloudflare
  - dns
  - tunnel
  - registro-br
---

# Cloudflare e DNS

## Objetivo

Esta nota documenta a configuração de DNS e publicação externa do **Bolao2026** através da Cloudflare.

O domínio:

```text
fernandomurashima.com.br
```

continua registrado no Registro.br, mas a zona DNS passou a ser administrada pela Cloudflare.

O acesso externo ao servidor Viper-II é realizado através do Cloudflare Tunnel.

---

# Domínios utilizados

Domínio principal:

```text
fernandomurashima.com.br
```

Domínio alternativo:

```text
www.fernandomurashima.com.br
```

Ambos apontam para a mesma aplicação.

---

# Registro do domínio

O domínio continua registrado no:

```text
Registro.br
```

O Registro.br permanece responsável pelo registro e renovação do domínio.

A zona DNS não é mais administrada diretamente pelo Registro.br.

---

# DNS anterior

Antes da migração, o domínio utilizava:

```text
a.sec.dns.br
c.sec.dns.br
```

como servidores DNS autoritativos.

Os registros existentes eram:

```text
A  fernandomurashima.com.br      177.153.38.27
A  www.fernandomurashima.com.br  177.153.38.27
```

O endereço:

```text
177.153.38.27
```

era o IP público da VPS KingHost.

---

# Verificação de registros antes da migração

Antes da troca de DNS, foram verificados os registros existentes.

Consulta MX:

```powershell
nslookup -type=mx fernandomurashima.com.br
```

Não foi identificado registro MX configurado.

Consulta TXT:

```powershell
nslookup -type=txt fernandomurashima.com.br
```

Não foi identificado registro TXT no domínio principal.

Consulta DMARC:

```powershell
nslookup -type=txt _dmarc.fernandomurashima.com.br
```

Resultado:

```text
Non-existent domain
```

Portanto, no momento da migração, a zona possuía apenas os dois registros A utilizados para o site.

---

# Adição do domínio à Cloudflare

O domínio:

```text
fernandomurashima.com.br
```

foi adicionado à conta Cloudflare.

Foi utilizado:

```text
Plano Free
```

A importação automática de registros DNS foi habilitada.

A Cloudflare importou os dois registros existentes da KingHost.

---

# Nameservers atribuídos pela Cloudflare

A Cloudflare atribuiu:

```text
kevin.ns.cloudflare.com
rayne.ns.cloudflare.com
```

Esses servidores passaram a ser os DNS autoritativos do domínio.

---

# Alteração no Registro.br

No Registro.br, os servidores antigos:

```text
a.sec.dns.br
c.sec.dns.br
```

foram substituídos por:

```text
kevin.ns.cloudflare.com
rayne.ns.cloudflare.com
```

Não foi ativado DNSSEC durante essa etapa.

---

# Propagação dos nameservers

A propagação foi acompanhada utilizando o Google DNS:

```powershell
nslookup -type=ns fernandomurashima.com.br 8.8.8.8
```

e o DNS da Cloudflare:

```powershell
nslookup -type=ns fernandomurashima.com.br 1.1.1.1
```

Durante a propagação ainda apareciam:

```text
a.sec.dns.br
c.sec.dns.br
```

Depois da propagação, o resultado passou para:

```text
kevin.ns.cloudflare.com
rayne.ns.cloudflare.com
```

---

# Verificação autoritativa

Também foi realizada consulta diretamente ao nameserver da Cloudflare:

```powershell
nslookup fernandomurashima.com.br kevin.ns.cloudflare.com
```

e:

```powershell
nslookup www.fernandomurashima.com.br kevin.ns.cloudflare.com
```

Essas consultas confirmaram que a Cloudflare já estava respondendo autoritativamente pelo domínio.

---

# Cloudflare Tunnel

O servidor Viper-II utiliza Cloudflare Tunnel.

Tunnel:

```text
takeshivip
```

O cloudflared executa no Ubuntu como serviço systemd.

Verificação:

```bash
sudo systemctl status cloudflared --no-pager
```

---

# Funcionamento do Tunnel

O Cloudflare Tunnel cria uma conexão de saída do Viper-II para a Cloudflare.

Fluxo:

```text
Viper-II
   ↓ conexão de saída
Cloudflare
```

Isso evita necessidade de:

```text
IP público fixo
Port forwarding
Exposição direta das portas 80 e 443
```

---

# Publicação do www

Primeiro foi publicada:

```text
www.fernandomurashima.com.br
```

Configuração:

```text
Subdomain:
www

Domain:
fernandomurashima.com.br

Path:
vazio

Service URL:
http://localhost:80
```

A Cloudflare criou automaticamente o registro DNS necessário para o Tunnel.

---

# Publicação do domínio principal

Depois foi publicado:

```text
fernandomurashima.com.br
```

Configuração:

```text
Subdomain:
vazio

Domain:
fernandomurashima.com.br

Path:
vazio

Service URL:
http://localhost:80
```

---

# Registros A antigos

Antes de criar cada Published Application, foi necessário remover o registro A correspondente.

Motivo:

A Cloudflare não permite criar uma rota de Tunnel para um hostname que já possua registro A, AAAA ou CNAME conflitante.

A migração foi feita de forma controlada:

```text
1. remover registro antigo
2. criar Published Application
3. Cloudflare cria registro do Tunnel
```

---

# DNS após a migração

Depois da publicação pelo Tunnel, os domínios deixaram de apontar diretamente para:

```text
177.153.38.27
```

e passaram a ser atendidos através da infraestrutura da Cloudflare.

A Cloudflare criou apontamentos para o hostname interno do Tunnel, conceitualmente:

```text
<UUID-do-tunnel>.cfargotunnel.com
```

---

# CNAME Flattening

Para o domínio raiz:

```text
fernandomurashima.com.br
```

a Cloudflare utiliza CNAME flattening.

Por isso uma consulta DNS pode retornar endereços IP da própria Cloudflare em vez de mostrar diretamente um CNAME.

Isso é comportamento esperado.

---

# Verificação DNS após migração

Consulta pública:

```powershell
nslookup fernandomurashima.com.br 1.1.1.1
```

e:

```powershell
nslookup www.fernandomurashima.com.br 1.1.1.1
```

Os resultados passaram a apontar para endereços pertencentes à Cloudflare.

O IP antigo da KingHost deixou de ser necessário para o funcionamento do domínio.

---

# Cache DNS local

Durante a migração, o Windows ainda utilizava informações antigas em cache.

Foi utilizado:

```powershell
ipconfig /flushdns
```

para limpar o cache local.

Depois disso, o teste passou a alcançar a infraestrutura nova.

---

# Teste HTTPS

Foi utilizado:

```powershell
curl.exe -I https://fernandomurashima.com.br
```

O resultado mostrou:

```text
Server: cloudflare
```

e:

```text
x-served-by: fernandomurashima.com.br
```

Esse resultado confirmou:

```text
Cloudflare
   ↓
Tunnel
   ↓
Viper-II
   ↓
Nginx Proxy Manager
```

---

# Teste do www

Também foi utilizado:

```powershell
curl.exe -I https://www.fernandomurashima.com.br
```

Resultado:

```text
Server: cloudflare
```

e:

```text
x-served-by: www.fernandomurashima.com.br
```

---

# HTTPS

O certificado HTTPS público é fornecido pela Cloudflare.

O acesso externo é:

```text
HTTPS
```

O tráfego entregue internamente pelo Tunnel utiliza:

```text
HTTP
```

para:

```text
http://localhost:80
```

---

# Relação Cloudflare → Nginx Proxy Manager

As duas Published Applications utilizam:

```text
http://localhost:80
```

Isso significa que o Tunnel entrega o tráfego para a porta 80 do Viper-II.

A porta 80 é atendida pelo:

```text
nginx-proxy-manager
```

O NPM identifica o hostname solicitado e envia para:

```text
bolao-frontend:80
```

---

# Arquitetura completa

```text
Usuário
   ↓
HTTPS
   ↓
Cloudflare Edge
   ↓
Cloudflare DNS
   ↓
Cloudflare Tunnel
   ↓
Viper-II
   ↓
localhost:80
   ↓
Nginx Proxy Manager
   ↓
bolao-frontend:80
   ↓
bolao-backend:8001
   ↓
mysql:3306
```

---

# Motivo de utilizar Cloudflare Tunnel

O ambiente residencial não deve depender de acesso direto vindo da internet.

Possíveis limitações:

```text
CGNAT
IP público dinâmico
restrições de portas
firewall do provedor
mudanças de IP
```

O Tunnel elimina essa dependência para publicação das aplicações.

---

# Um Tunnel para várias aplicações

O Tunnel:

```text
takeshivip
```

pode publicar múltiplos domínios.

Exemplo atual:

```text
maymurashima.com.br
www.maymurashima.com.br

fernandomurashima.com.br
www.fernandomurashima.com.br
```

Todos podem ser encaminhados para:

```text
http://localhost:80
```

O Nginx Proxy Manager decide a aplicação correta de acordo com o hostname.

---

# Atualização normal do Bolao2026

Uma atualização de backend ou frontend não exige alteração em:

```text
Cloudflare DNS
Cloudflare Tunnel
Registro.br
Nameservers
Published Applications
```

O domínio continua apontando para a mesma infraestrutura.

---

# Quando mexer na Cloudflare

Somente será necessário alterar essa configuração em situações como:

```text
novo domínio
novo subdomínio
mudança de Tunnel
mudança de porta de entrada
remoção da aplicação
alteração estrutural da infraestrutura
```

---

# Verificar status do cloudflared

No Viper-II:

```bash
sudo systemctl status cloudflared --no-pager
```

Esperado:

```text
active (running)
```

---

# Reiniciar cloudflared

Se necessário:

```bash
sudo systemctl restart cloudflared
```

Depois verificar:

```bash
sudo systemctl status cloudflared --no-pager
```

---

# Atenção ao reiniciar cloudflared

O mesmo Tunnel atende outras aplicações.

Reiniciar o serviço pode causar indisponibilidade temporária em todos os domínios publicados pelo Tunnel.

---

# Teste de DNS

Google:

```powershell
nslookup fernandomurashima.com.br 8.8.8.8
```

Cloudflare:

```powershell
nslookup fernandomurashima.com.br 1.1.1.1
```

---

# Teste de nameservers

```powershell
nslookup -type=ns fernandomurashima.com.br 8.8.8.8
```

Esperado:

```text
kevin.ns.cloudflare.com
rayne.ns.cloudflare.com
```

---

# Teste autoritativo

```powershell
nslookup fernandomurashima.com.br kevin.ns.cloudflare.com
```

---

# Diagnóstico se o domínio não abrir

Verificar nesta ordem:

```text
1. domínio ativo na Cloudflare
2. nameservers corretos
3. Published Application existente
4. Tunnel healthy
5. cloudflared ativo no Viper-II
6. Nginx Proxy Manager ativo
7. bolao-frontend ativo
8. bolao-backend ativo
```

---

# Comandos iniciais de diagnóstico no Viper-II

```bash
sudo systemctl status cloudflared --no-pager
```

```bash
docker ps
```

```bash
curl -I \
  -H "Host: fernandomurashima.com.br" \
  http://127.0.0.1/
```

---

# Diagnóstico de DNS antigo em cache

Se o domínio parecer acessar infraestrutura antiga:

```powershell
ipconfig /flushdns
```

Depois:

```powershell
nslookup fernandomurashima.com.br 1.1.1.1
```

e:

```powershell
curl.exe -I https://fernandomurashima.com.br
```

---

# Identificação de acesso ao Viper-II

Um retorno como:

```text
Server: cloudflare
x-served-by: fernandomurashima.com.br
```

é evidência de que a requisição percorreu a Cloudflare e chegou ao Nginx Proxy Manager do Viper-II.

---

# KingHost após migração

Depois que o Tunnel passou a atender os domínios, o acesso público deixou de depender de:

```text
177.153.38.27
```

O serviço:

```text
copa.service
```

foi posteriormente parado na KingHost.

O domínio continuou funcionando, confirmando a independência da VPS antiga.

---

# Segurança

O token do Cloudflare Tunnel é informação sensível.

Não registrar na documentação:

```text
token do Tunnel
credenciais da conta Cloudflare
chaves de API
senhas
```

Caso um token tenha sido exposto em terminal, histórico ou conversa, deverá ser rotacionado na etapa de revisão de segurança.

---

# DNSSEC

Durante a migração não foi ativado DNSSEC no Registro.br.

Qualquer ativação futura deverá ser feita de forma planejada entre Cloudflare e Registro.br.

Não ativar isoladamente sem configurar corretamente a cadeia de confiança.

---

# E-mail

No momento da migração não foram encontrados registros:

```text
MX
TXT
DMARC
```

na zona do domínio.

Portanto, não havia serviço de e-mail dependente dessa zona para ser preservado durante a troca.

Caso e-mail seja configurado futuramente, registrar nesta documentação:

```text
MX
SPF
DKIM
DMARC
```

antes de qualquer nova migração DNS.

---

# Estado atual

```text
Domínio:
fernandomurashima.com.br

WWW:
www.fernandomurashima.com.br

Registrador:
Registro.br

DNS:
Cloudflare

Nameservers:
kevin.ns.cloudflare.com
rayne.ns.cloudflare.com

Cloudflare Tunnel:
takeshivip

Published Applications:
fernandomurashima.com.br
www.fernandomurashima.com.br

Service URL:
http://localhost:80

HTTPS:
Cloudflare

Destino interno:
Nginx Proxy Manager

Servidor:
Viper-II

Status:
operacional
```

---

# Regra operacional

Para atualização normal do sistema:

```text
NÃO alterar DNS
NÃO alterar nameservers
NÃO alterar Tunnel
NÃO alterar Published Applications
```

Atualizar somente os componentes da aplicação necessários.

---

# Documentos relacionados

- [[Bolao2026]]
- [[Contexto do Projeto/Visao Geral]]
- [[Decisões Técnicas/Arquitetura de Producao]]
- [[Infraestrutura/Servidor Viper-II]]
- [[Infraestrutura/Docker]]
- [[Infraestrutura/Banco de Dados]]
- [[Infraestrutura/Nginx Proxy Manager]]
- [[Migração KingHost/Migracao KingHost para Viper-II]]
- [[Operação/Operacao do Bolao]]
- [[Operação/Atualizacao Backend]]
- [[Operação/Atualizacao Frontend]]