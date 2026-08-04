---
type: reference
status: active
project: Sysvar
source: "C:/SysvarProjeto"
created: 2026-08-03
updated: 2026-08-03
tags:
  - sysvar
  - contexto
  - riscos
---

# Riscos e Cuidados

## Segurança e dados sensíveis

- Não ler nem duplicar `.env` em notas do Obsidian.
- Permissões por módulo/campo são parte sensível do sistema.
- Mudanças de autenticação podem quebrar frontend, guards, API e isolamento multiempresa.

## Multiempresa e estabelecimentos

- Sempre verificar empresa, loja e compatibilidade operacional antes de listar, criar ou alterar dados.
- O conceito funcional de estabelecimento ainda precisa formalização transversal em várias telas/endpoints.
- Filtros por loja podem não equivaler ao conceito de unidade operacional.

## Acoplamento entre domínios

- PDV, fiscal, estoque, financeiro e contábil têm efeitos encadeados.
- Distribuição toca estoque, fiscal, pedidos, trânsito e recebimento.
- Produção toca ficha técnica, consumo de insumos, estoque e produto acabado.
- Financeiro e dashboard dependem da consistência dos lançamentos gerados por outros domínios.

## Migrações e banco

- Projeto usa Django migrations e MySQL.
- Antes de criar migration, validar modelo de negócio, dados existentes e efeitos em serializers/viewsets.
- Backups existem no projeto, mas não devem ser tratados como fonte viva sem validação.

## Frontend

- Rotas têm dados de role/módulo de empresa.
- Componentes de feature são grandes; mudanças precisam preservar UX existente e contratos de services.
- PDV/offline e filas locais exigem testes de persistência, reconexão e sincronização.

## Produção

- Rodar checks do backend e build do frontend antes de deploy.
- Não executar migrations ou comandos de carga sem confirmação explícita.
- Documentar decisões funcionais que mudem módulos, permissões ou estabelecimento.

## Última atualização

2026-08-03

## Limitações do contexto

Esta nota é um mapa de risco inicial, não auditoria completa. Para feature de alto impacto, usar `$grill-me` antes do plano.
