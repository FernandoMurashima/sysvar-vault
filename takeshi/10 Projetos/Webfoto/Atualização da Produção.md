---
type: runbook
status: active
project: Webfoto
source: "40 Arquivo/Fontes/atualizacao-producao-webfoto.txt"
created: 2026-07-26
updated: 2026-07-29
tags:
  - webfoto
  - producao
  - runbook
---

# Atualização da Produção

## Objetivo

Este documento descreve o procedimento para atualizar o ambiente de produção do [[Webfoto]].

## Documento original

Fonte arquivada: [[atualizacao-producao-webfoto.txt]]

Observação: o arquivo original contém variáveis sensíveis de ambiente. Não duplicar segredos em notas derivadas; consultar a fonte local apenas quando for necessário executar o procedimento.

## Etapa 1 - Preparação do ambiente local 

Antes de enviar qualquer alteração para produção, é necessário verificar se o ambiente local está consistente. 

### Objetivos desta etapa

- Entrar na pasta do projeto. 
- Confirmar que não existem alterações pendentes. 
- Validar o backend. 
- Gerar o build do frontend.

### Comandos base

```powershell
cd C:\webfoto
git status --short
node --check .\server\server.js
ng build
```

## Etapa 2 - Envio de artefatos

- Limpar a pasta temporária do frontend no servidor.
- Copiar o build do frontend para `/home/fmurashima/webfoto-dist/`.
- Copiar `server.js` e `package.json` para `/home/fmurashima/webfoto-backend/`.
- Garantir a pasta `migrations` no backend remoto.
- Copiar a migration `2026-07-26_zip_prepared_flow.sql`.

## Etapa 3 - Atualização no servidor

- Entrar em `/home/fmurashima/webfoto-backend`.
- Atualizar os arquivos públicos dentro do container `webfoto`.
- Reiniciar o container do frontend.
- Buildar a imagem `webfoto-api`.
- Remover o container antigo da API.
- Subir o novo container da API com as variáveis de ambiente necessárias.

## Etapa 4 - Validação

```bash
docker exec webfoto-api wget -qO- http://127.0.0.1:3000/api/health
docker exec webfoto wget -qO- http://webfoto-api:3000/api/health
curl -I https://www.maymurashima.com.br/api/health
curl -I https://www.maymurashima.com.br/area-fotos
curl -s https://www.maymurashima.com.br/ | grep -Eo 'main-[A-Z0-9]+\.js|styles-[A-Z0-9]+\.css' | sort -u
docker logs --tail 80 webfoto-api
```

## Próximas melhorias

- Separar variáveis sensíveis em um cofre de segredos fora do Obsidian.
- Criar checklist executável por etapa antes de cada deploy.
- Registrar data, versão e resultado de cada atualização em uma nota de log.
