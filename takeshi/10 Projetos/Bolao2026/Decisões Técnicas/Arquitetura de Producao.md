---
type: decision
status: active
project: Bolao2026
category: arquitetura
created: 2026-08-10
updated: 2026-08-10
tags:
  - bolao2026
  - arquitetura
  - docker
  - cloudflare
  - nginx
  - mysql
  - producao
---

# Arquitetura de Producao

## Objetivo

Esta nota registra as principais decisões técnicas adotadas para a arquitetura de produção do **Bolao2026** no servidor `Viper-II`.

A arquitetura anterior utilizava uma VPS da KingHost com serviços instalados diretamente no sistema operacional.

Após a migração, a aplicação passou a utilizar containers Docker, proxy reverso centralizado e publicação externa através de Cloudflare Tunnel.

---

# Arquitetura escolhida

A arquitetura final adotada foi:

```text
Internet
   ↓
Cloudflare DNS
   ↓
Cloudflare Tunnel
   ↓
Servidor Viper-II
   ↓
Nginx Proxy Manager
   ↓
bolao-frontend
   │
   ├── Angular
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

---

# Decisão 1 — Utilizar Docker

## Decisão

O Bolao2026 passou a executar em containers Docker.

Containers principais:

```text
bolao-backend
bolao-frontend
mysql
```

Rede Docker:

```text
infra
```

## Motivo

O uso de Docker permite:

```text
isolamento dos serviços
padronização do ambiente
facilidade de manutenção
facilidade de recriação dos serviços
redução de dependências instaladas diretamente no Ubuntu
melhor organização da infraestrutura
```

## Resultado

O backend e o frontend deixaram de depender diretamente de bibliotecas e serviços instalados no sistema operacional do servidor.

---

# Decisão 2 — Backend em container próprio

## Decisão

O Django executa em container próprio:

```text
bolao-backend
```

Imagem:

```text
bolao-backend:latest
```

## Runtime

```text
Python 3.11
Django 4.2.11
Gunicorn
```

Porta interna:

```text
8001
```

## Gunicorn

Configuração atual:

```text
3 workers
bind 0.0.0.0:8001
```

## Motivo

Separar o backend permite reconstruí-lo independentemente do frontend.

Uma alteração no Django não exige reconstrução do frontend.

---

# Decisão 3 — Frontend em container Nginx

## Decisão

O build Angular é servido por um container Nginx:

```text
bolao-frontend
```

Imagem:

```text
bolao-frontend:latest
```

Porta interna:

```text
80
```

## Motivo

O frontend Angular, depois de compilado, é composto por arquivos estáticos.

Não existe necessidade de executar Node.js em produção apenas para servir esses arquivos.

O Nginx é utilizado para:

```text
servir os arquivos Angular
tratar fallback de rotas SPA
encaminhar /api/ para o backend
encaminhar /admin/ para o backend
```

---

# Decisão 4 — Backend não exposto diretamente

## Decisão

O container `bolao-backend` não publica a porta `8001` diretamente no host.

Ele é acessível apenas através da rede Docker:

```text
infra
```

O frontend acessa:

```text
http://bolao-backend:8001
```

## Motivo

Isso reduz exposição desnecessária do backend.

O acesso externo deve passar pela cadeia:

```text
Cloudflare
→ Tunnel
→ Nginx Proxy Manager
→ bolao-frontend
→ bolao-backend
```

---

# Decisão 5 — Utilizar a rede Docker infra

## Decisão

Os containers envolvidos na infraestrutura utilizam a rede:

```text
infra
```

## Motivo

A rede permite comunicação entre containers utilizando nomes DNS internos.

Exemplos:

```text
bolao-frontend
bolao-backend
mysql
```

Assim, o Django não precisa conhecer o IP interno do MySQL.

Ele utiliza:

```text
HOST = mysql
```

Da mesma forma, o frontend utiliza:

```text
proxy_pass http://bolao-backend:8001;
```

---

# Decisão 6 — MySQL compartilhado como serviço de infraestrutura

## Decisão

O Bolao2026 utiliza o container MySQL já existente no Viper-II.

Container:

```text
mysql
```

Imagem:

```text
mysql:8.0
```

Banco exclusivo da aplicação:

```text
bolao2026
```

## Motivo

Não existe necessidade de manter um container MySQL separado exclusivamente para cada aplicação neste servidor.

Cada aplicação utiliza seu próprio banco lógico dentro da instância MySQL.

## Separação

O Bolao2026 utiliza:

```text
Database: bolao2026
User: bolao_user
```

A senha não deve ser armazenada nesta documentação.

---

# Decisão 7 — Nginx Proxy Manager como proxy reverso central

## Decisão

O Nginx Proxy Manager recebe as requisições HTTP que chegam ao servidor.

Para o Bolao2026:

```text
fernandomurashima.com.br
www.fernandomurashima.com.br
```

são encaminhados para:

```text
bolao-frontend:80
```

## Motivo

Isso permite manter vários sistemas no mesmo servidor utilizando os mesmos ports públicos:

```text
80
443
```

O encaminhamento é feito de acordo com o hostname.

Exemplo:

```text
maymurashima.com.br
        ↓
WebFoto

fernandomurashima.com.br
        ↓
Bolao2026
```

---

# Decisão 8 — HTTPS fora do Nginx Proxy Manager

## Decisão

O HTTPS público do Bolao2026 é fornecido pela Cloudflare.

Não foi configurado certificado SSL específico no Nginx Proxy Manager para o domínio do Bolão.

## Motivo

O tráfego público chega através do Cloudflare Tunnel.

Fluxo:

```text
Usuário
   ↓ HTTPS
Cloudflare
   ↓ Tunnel
Servidor
   ↓ HTTP interno
Nginx Proxy Manager
```

Assim, o certificado público é tratado pela Cloudflare.

---

# Decisão 9 — Utilizar Cloudflare Tunnel

## Decisão

O servidor não é publicado através de redirecionamento de portas no roteador.

O acesso externo é realizado através do Cloudflare Tunnel.

Tunnel:

```text
takeshivip
```

Hostnames publicados:

```text
fernandomurashima.com.br
www.fernandomurashima.com.br
```

Destino:

```text
http://localhost:80
```

## Motivo

O ambiente residencial pode possuir limitações como:

```text
CGNAT
bloqueio de portas
IP público dinâmico
restrições do provedor
```

O Cloudflare Tunnel cria uma conexão de saída do servidor para a Cloudflare.

Assim, não é necessário receber conexões diretamente da internet.

---

# Decisão 10 — Cloudflare responsável pelo DNS

## Decisão

O domínio continua registrado no Registro.br, mas os servidores DNS autoritativos passaram para a Cloudflare.

Nameservers:

```text
kevin.ns.cloudflare.com
rayne.ns.cloudflare.com
```

## Motivo

Isso permite integração direta com Cloudflare Tunnel e administração dos registros DNS no mesmo ambiente.

---

# Decisão 11 — Registro.br apenas como registrador

## Decisão

O domínio:

```text
fernandomurashima.com.br
```

continua registrado no Registro.br.

O Registro.br não mantém mais a zona DNS do domínio.

Sua função atual é:

```text
registro do domínio
delegação dos nameservers
```

A zona DNS é administrada pela Cloudflare.

---

# Decisão 12 — Backend atualizado através do GitHub

## Decisão

O backend de produção é atualizado através do repositório Git.

Fluxo:

```text
Notebook de desenvolvimento
        ↓
git push
        ↓
GitHub
        ↓
git pull
        ↓
Viper-II
```

Depois:

```text
docker build
docker rm
docker run
manage.py migrate
```

## Motivo

O backend contém código-fonte e migrations.

Git é apropriado para versionamento e distribuição dessas alterações.

---

# Decisão 13 — Frontend enviado por SCP

## Decisão

O frontend não é compilado no servidor de produção.

O build é realizado no notebook de desenvolvimento:

```powershell
ng build
```

Depois o diretório:

```text
dist\bolao2026\browser
```

é enviado ao servidor através de SCP.

Destino:

```text
/srv/projects/copa/frontend/browser
```

## Motivo

O servidor de produção não precisa possuir todo o ambiente Node.js/Angular necessário ao desenvolvimento.

Ele recebe somente os arquivos finais de produção.

---

# Decisão 14 — Build Docker após cada atualização

## Backend

Após atualizar os arquivos:

```bash
docker build -t bolao-backend:latest .
```

Depois o container é recriado.

## Frontend

Após receber o novo build Angular:

```bash
docker build -t bolao-frontend:latest .
```

Depois o container é recriado.

## Motivo

As imagens contêm uma cópia dos arquivos existentes no momento do build.

Alterar arquivos em:

```text
/srv/projects/copa/backend
```

ou:

```text
/srv/projects/copa/frontend/browser
```

não altera automaticamente o conteúdo dos containers já executando.

---

# Decisão 15 — Containers com restart automático

Os containers do Bolao2026 são criados com:

```text
--restart always
```

## Motivo

Após uma reinicialização do Viper-II, o Docker deve iniciar os containers novamente sem intervenção manual.

---

# Decisão 16 — Não migrar o ambiente virtual da KingHost

## Ambiente antigo

Na KingHost existia:

```text
/home/deploy/venvs/copa_env
```

## Decisão

Esse ambiente virtual não foi utilizado na nova infraestrutura.

As dependências são instaladas dentro da imagem Docker usando:

```text
requirements.txt
```

## Motivo

Copiar um ambiente virtual entre máquinas pode trazer:

```text
bibliotecas compiladas para outro ambiente
dependências antigas
arquivos desnecessários
problemas de compatibilidade
```

A imagem Docker foi construída do zero.

---

# Decisão 17 — Não utilizar o backend corrompido

No projeto migrado existia:

```text
backend_corrompido_20260623_203943
```

Esse diretório não foi utilizado.

Foi usado somente:

```text
/srv/projects/copa/backend
```

---

# Decisão 18 — Migração de banco por dump lógico

## Decisão

O banco foi migrado utilizando:

```text
mysqldump
```

em vez de copiar diretamente arquivos internos do MySQL.

## Motivo

O dump lógico reduz riscos relacionados a:

```text
versão do MySQL
estado dos arquivos InnoDB
permissões
arquivos de sistema
corrupção
```

A restauração foi realizada no MySQL já existente no Viper-II.

---

# Decisão 19 — Não desligar a KingHost antes da validação

## Estratégia

Durante a migração, a KingHost permaneceu funcionando.

A sequência utilizada foi:

```text
1. Migrar aplicação
2. Migrar banco
3. Configurar Docker
4. Configurar proxy
5. Configurar Cloudflare
6. Testar internamente
7. Testar externamente
8. Testar em 4G/5G
9. Somente então parar copa.service
```

## Motivo

Isso manteve um caminho de rollback durante toda a migração.

---

# Decisão 20 — Testar após desligar o serviço antigo

Depois da migração, o serviço:

```text
copa.service
```

foi parado na KingHost.

Em seguida o sistema foi testado novamente usando 4G/5G.

O funcionamento normal após o desligamento confirmou que não existia dependência residual da KingHost.

---

# Decisão 21 — Não apagar imediatamente os arquivos antigos

Os arquivos antigos permanecem na KingHost durante o período de transição.

Diretório:

```text
/home/deploy/copa
```

## Motivo

Enquanto a VPS não for definitivamente encerrada, esses arquivos funcionam como contingência histórica.

Depois da conclusão da migração geral da KingHost, podem ser removidos junto com a desativação da VPS.

---

# Decisão 22 — Credenciais fora da documentação

Senhas e tokens não devem ser registrados em notas do Obsidian.

Não registrar:

```text
senha root MySQL
senha bolao_user
SECRET_KEY Django
token Cloudflare Tunnel
senhas administrativas
tokens de API
```

## Motivo

A documentação pode ser sincronizada ou copiada para outros dispositivos.

Informações operacionais podem ser registradas; segredos devem permanecer em mecanismo específico para credenciais.

---

# Pontos futuros de melhoria

A arquitetura atual está funcional, mas alguns pontos podem ser melhorados futuramente.

## Docker Compose

Criar um arquivo como:

```text
/srv/docker/stacks/bolao.yml
```

permitiria administrar os containers através de:

```bash
docker compose build
docker compose up -d
```

em vez de recriar os containers manualmente.

---

## Variáveis de ambiente

Atualmente existem configurações sensíveis no projeto Django.

O ideal futuramente é utilizar variáveis de ambiente ou arquivo `.env` não versionado.

Exemplo conceitual:

```text
DB_NAME
DB_USER
DB_PASSWORD
DB_HOST
SECRET_KEY
```

---

## Backup automatizado

O banco:

```text
bolao2026
```

deve participar da rotina automatizada de backup do Viper-II.

O backup deverá possuir:

```text
execução automática
retenção
cópia externa
validação
```

---

## Monitoramento

O Bolao2026 deve ser incluído no Uptime Kuma.

Monitorar pelo menos:

```text
https://fernandomurashima.com.br
bolao-frontend
bolao-backend
MySQL
Cloudflare Tunnel
```

---

# Resumo das decisões

```text
Hospedagem:
Viper-II

Aplicação:
Docker

Backend:
Django + Gunicorn

Frontend:
Angular + Nginx

Banco:
MySQL 8

Rede:
Docker infra

Proxy reverso:
Nginx Proxy Manager

DNS:
Cloudflare

HTTPS:
Cloudflare

Acesso externo:
Cloudflare Tunnel

Backend deploy:
GitHub → git pull → Docker build

Frontend deploy:
ng build → SCP → Docker build

Rollback durante migração:
KingHost mantida ativa até validação

Credenciais:
não armazenar na documentação
```

---

# Documentos relacionados

- [[Bolao2026]]
- [[Contexto do Projeto/Visao Geral]]
- [[Infraestrutura/Servidor Viper-II]]
- [[Infraestrutura/Docker]]
- [[Infraestrutura/Banco de Dados]]
- [[Infraestrutura/Nginx Proxy Manager]]
- [[Infraestrutura/Cloudflare e DNS]]
- [[Migração KingHost/Migracao KingHost para Viper-II]]
- [[Operação/Operacao do Bolao]]
- [[Operação/Atualizacao Backend]]
- [[Operação/Atualizacao Frontend]]