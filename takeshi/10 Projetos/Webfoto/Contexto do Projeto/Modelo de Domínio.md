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
  - dominio
---

# Modelo de Domínio

## Conceitos

- Álbum/Pasta: conjunto de fotos entregue a um cliente.
- Foto: arquivo individual validado e armazenado no backend.
- Usuário cliente: credencial vinculada a uma pasta específica.
- Administrador: usuário operacional que gerencia pastas, fotos, clientes e publicação.
- Sessão de upload: agrupamento de fotos enviadas pelo admin.
- ZIP job: preparação de arquivo ZIP para download.
- Upload chunked: envio de ZIP pronto em partes de 20 MB por padrão.

## Estados importantes

- `publication_status`: `rascunho`, `processando`, `pronto`, `publicado`, `arquivado`.
- `zip_jobs.status`: `aguardando_upload`, `enviando`, `upload_concluido`, `aguardando_zip`, `gerando_zip`, `pronto`, `erro`, `cancelado`, `expirado`.
- Upload de fotos na UI: `aguardando`, `enviando`, `concluido`, `erro`, `cancelado`.

## Regras

- Cliente só acessa a pasta vinculada ao próprio usuário.
- Admin precisa estar autenticado para criar pastas, subir fotos/ZIP, gerar ZIP, publicar, despublicar e excluir.
- Álbum só deve ser publicado quando existir ZIP pronto.
- Upload de fotos aceita `jpg`, `jpeg`, `png`, `webp`.
- Tamanho máximo de foto no frontend é 60 MB; backend usa `MAX_PHOTO_SIZE`.
- Upload de ZIP pronto valida extensão, tamanho total, quantidade de chunks e integridade por tamanho/hash.
- Chunks duplicados com mesmo hash são aceitos como retomada; duplicados divergentes retornam conflito.

## Invariantes

- `photo_files.folder_id` pertence a `photo_folders`.
- `photo_users.folder_id` vincula cliente a pasta.
- `active_zip_job_id` aponta para ZIP pronto usado pela pasta.
- Arquivos temporários de upload devem ser removidos após conclusão, cancelamento ou expiração.

## Última atualização

2026-07-29

## Limitações do contexto

Os estados foram inferidos do frontend, backend e migration. Confirmar banco real antes de mudar nomes de estados ou regras de publicação.
