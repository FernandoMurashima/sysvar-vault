---
type: reference
status: active
project: Webfoto
source: "C:/webfoto"
created: 2026-07-29
updated: 2026-07-29
tags:
  - webfoto
  - contexto
  - workflows
---

# Workflows

## Login admin

1. Admin informa login e senha na área de fotos.
2. Frontend chama `POST /api/admin/login`.
3. Backend valida contra variáveis de ambiente.
4. Frontend salva token em `localStorage` como `mayara-admin-token`.
5. Frontend chama `GET /api/admin/state`.

## Login cliente

1. Cliente informa login e senha.
2. Frontend chama `POST /api/client/login`.
3. Backend valida usuário em `photo_users`.
4. Token de cliente é salvo como `mayara-client-token`.
5. Cliente recebe apenas a pasta vinculada.

## Upload de fotos

1. Admin escolhe uma pasta.
2. Frontend valida extensão/tipo/tamanho e cria fila.
3. Frontend cria sessão em `POST /api/admin/folders/:folderId/upload-sessions`.
4. Fila envia fotos com concorrência 4 para `POST /api/admin/folders/:folderId/photos/upload`.
5. Backend grava arquivo e linha em `photo_files`.
6. Sessão e pasta são atualizadas; pasta pode ir para `processando`.

## Upload de ZIP pronto

1. Admin escolhe pasta e arquivo `.zip`.
2. Frontend calcula chunks e chama `POST /api/admin/uploads/iniciar`.
3. Backend cria registro em `uploads` e diretório temporário.
4. Frontend envia chunks para `POST /api/admin/uploads/:uploadId/chunks/:chunkNumber`.
5. Backend valida tamanho e hash por chunk.
6. Frontend finaliza em `POST /api/admin/uploads/:uploadId/finalizar`.
7. Backend junta chunks, calcula SHA-256, cria `zip_jobs` pronto e atualiza a pasta.

## Geração de ZIP a partir de fotos

1. Admin ou cliente solicita ZIP.
2. Backend cria `zip_jobs`.
3. `buildZipJob` usa `archiver` para montar o arquivo.
4. Progresso é gravado em `zip_jobs`.
5. Quando pronto, pasta recebe `active_zip_job_id` e `zip_ready_at`.

## Publicação

1. Admin seleciona pasta.
2. Frontend verifica status do ZIP.
3. Admin publica via `POST /api/admin/folders/:folderId/publish`.
4. Backend exige ZIP pronto e marca `publication_status = publicado`.

## Download cliente

1. Cliente autenticado acessa sua pasta.
2. Cliente solicita ZIP ou foto.
3. Backend valida token e vínculo da pasta.
4. Download de ZIP usa streaming com suporte a range.

## Deploy

O runbook principal está em [[Atualização da Produção]]. A API roda como container `webfoto-api`, o frontend como `webfoto`, e o proxy deve encaminhar `/api` para o backend.

## Última atualização

2026-07-29

## Limitações do contexto

Fluxos foram mapeados estaticamente. Testar manualmente antes de alterar fila, retomada de upload ou publicação.
