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
  - mapa-tecnico
---

# Mapa Técnico

## Inventário

- Arquivos relevantes no inventário: 60.
- Diretórios ignorados: `node_modules`, `dist`, `.angular`, `.git`, `.vscode`, `.codex`, `.agents`, caches e volumes temporários.
- Arquivos binários e assets pesados ignorados.

## Comando de inventário

```powershell
C:\Users\ferna\.cache\codex-runtimes\codex-primary-runtime\dependencies\python\python.exe C:\Users\ferna\.codex\skills\project-context-pack\scripts\inventory_project.py --project-root C:\webfoto --format markdown
```

## Arquivos-chave

- `package.json`: scripts Angular e dependências principais.
- `angular.json`: configuração de build Angular.
- `src/app/app.routes.ts`: mapa de rotas públicas e área de fotos.
- `src/app/services/photo-access.service.ts`: contrato TypeScript com a API.
- `src/app/pages/area-fotos/area-fotos.component.ts`: fluxo principal de admin, cliente, upload e ZIP.
- `src/app/guards/pending-upload.guard.ts`: proteção contra saída durante upload pendente.
- `server/server.js`: API, schema, autenticação, upload, ZIP, streaming e cleanup.
- `server/migrations/2026-07-26_zip_prepared_flow.sql`: migração de fluxo de ZIP/upload.
- `DEPLOY_BACKEND.md`: notas de deploy do backend.

## Rotas Angular

- `/`
- `/sobre`
- `/trabalhos`
- `/orcamento`
- `/area-fotos`
- `/contato`
- `/trabalhos/aniversarios`
- `/trabalhos/cha-revelacao`
- `/trabalhos/batizado`

## Endpoints principais

- Admin: login, estado, pastas, usuários, upload de fotos, upload de ZIP em chunks, status de ZIP, publicar/despublicar.
- Cliente: login, pasta vinculada, criação/status/download de ZIP.
- Arquivos: download protegido de foto e ZIP.
- Health: `GET /api/health`.

## Onde mexer por tipo de feature

- Nova página pública: `src/app/pages`, `src/app/app.routes.ts`, layout se precisar navegação.
- Mudança na área de fotos: `AreaFotosComponent` e `PhotoAccessService`.
- Mudança de API: `server/server.js` e interfaces em `PhotoAccessService`.
- Mudança de dados: `ensureSchema` em `server/server.js` e nova migration.
- Deploy: [[Atualização da Produção]] e `DEPLOY_BACKEND.md`.

## Última atualização

2026-07-29

## Limitações do contexto

O backend está concentrado em um único arquivo grande; qualquer feature de API deve localizar funções específicas antes de editar.
