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
  - arquitetura
---

# Arquitetura

## Visão C4 leve

- Sistema: Webfoto, site público e área de entrega de fotos.
- Containers: frontend Angular 17, backend Node/Express 5, banco MySQL, volumes Docker para uploads, ZIPs e temporários.
- Componentes frontend principais: rotas Angular, `AreaFotosComponent`, `PhotoAccessService`, `pendingUploadGuard`.
- Componentes backend principais: `server/server.js`, schema bootstrap, rotas REST, geração de ZIP, upload chunked, stream de downloads.

## Frontend

- Entry point: `src/main.ts`.
- Configuração: `src/app/app.config.ts`.
- Rotas: `src/app/app.routes.ts`.
- Serviço de API: `src/app/services/photo-access.service.ts`.
- Área de fotos: `src/app/pages/area-fotos/area-fotos.component.ts`, `.html`, `.css`.

## Backend

- Entry point: `server/server.js`.
- Framework: Express.
- Upload de fotos: `multer` com validação de tipo e tamanho.
- Upload de ZIP: chunks binários enviados para `/api/admin/uploads/:uploadId/chunks/:chunkNumber`.
- ZIP de fotos: `archiver`, jobs assíncronos e streaming de download.
- Auth: tokens HMAC com expiração de 12 horas.

## Banco

Tabelas principais:

- `photo_folders`: álbuns/pastas e status de publicação.
- `photo_files`: fotos ligadas a uma pasta.
- `photo_users`: clientes e vínculo com pasta.
- `upload_sessions`: sessões de upload de fotos.
- `zip_jobs`: preparação e disponibilidade de ZIPs.
- `uploads` e `upload_chunks`: upload de ZIP pronto em partes.

## Infraestrutura

- Frontend publicado no container `webfoto`.
- API publicada no container `webfoto-api`.
- `/api` deve ser roteado para a API; o restante do domínio vai para o frontend.
- Volumes usados: `webfoto_uploads`, `webfoto_zips`, `webfoto_upload_temp`.

## Última atualização

2026-07-29

## Limitações do contexto

Não há inspeção dinâmica de containers ou banco de produção. Validar ambiente real antes de mexer em deploy, volumes, proxy ou variáveis.
