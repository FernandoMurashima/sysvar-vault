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
  - riscos
---

# Riscos e Cuidados

## Segurança

- Não duplicar senhas, tokens e segredos em notas do Obsidian.
- O backend tem valores padrão sensíveis para admin/token quando variáveis não são definidas; conferir produção antes de deploy.
- Tokens são HMAC simples com expiração; mudanças de auth precisam preservar acesso admin/cliente.
- Downloads por query token exigem cuidado com logs e compartilhamento de URLs.

## Upload e arquivos

- Upload de fotos tem validação duplicada no frontend e backend.
- Upload de ZIP usa chunks; mudanças precisam preservar retomada, conflito de chunks divergentes e limpeza de temporários.
- Volumes de uploads, ZIPs e temporários não podem ser apagados por engano.
- `ensureFreeDisk` é uma defesa importante para ZIPs grandes.

## Banco e migrações

- Schema é criado/ajustado no startup do backend e também há migration SQL.
- Alterações de estados devem considerar `publication_status`, `zip_jobs.status`, `uploads.status` e UI.
- Remoções de pasta/foto apagam registros e arquivos associados.

## UX

- `pendingUploadGuard` protege saída durante uploads pendentes.
- Fila de upload tem pausa, retomada, cancelamento, retry e resumo.
- Estados de erro precisam ser claros para admin e cliente.

## Produção

- `/api` precisa ser roteado para `webfoto-api`.
- Frontend e backend são containers separados.
- Antes de deploy, rodar validações locais e checagens públicas descritas em [[Atualização da Produção]].

## Regressões prováveis

- Upload grande interrompido.
- Publicação antes do ZIP ficar pronto.
- Cliente acessando pasta errada.
- Download quebrado por token, range request ou arquivo ausente.
- Mudança de contrato entre `PhotoAccessService` e `server/server.js`.

## Última atualização

2026-07-29

## Limitações do contexto

Esta nota aponta riscos prováveis, não uma auditoria de segurança completa.
