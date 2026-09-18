---
type: reference
status: active
project: Sysvar
source: "FernandoMurashima/sysvarbackend@108197240e07b679321d1335b62712954a3337b8"
created: 2026-09-18
updated: 2026-09-18
tags:
  - sysvar
  - sysvar-hub
  - pdv
  - despesas
  - financeiro
  - integracao
---

# Mapa Técnico - Sysvar Hub - Tipos de Despesa PDV

## Objetivo

Documentar o snapshot de tipos de despesa do PDV disponibilizado pelo Sysvar Central para o [[Sysvar Hub]].

Esse catálogo permite que operações locais de caixa utilizem tipos de despesa definidos centralmente.

## Endpoint

~~~text
GET /api/hub/tipos-despesa-pdv/
Authorization: Hub <TOKEN>
~~~

## Escopo

A Empresa e a Loja são sempre derivadas do Hub autenticado.

Query string com `empresa_id` ou `loja_id` não pode alterar o escopo.

## Fonte de dados

O endpoint usa:

~~~text
TipoDespesaPdv
→ Nat_Lancamento
~~~

São retornados somente tipos ativos da Empresa do Hub.

## Contrato

Metadados do snapshot:

- `tipos_despesa_pdv_versao = 1`;
- `gerado_em`;
- Hub;
- Empresa;
- Loja;
- lista `tipos_despesa_pdv`.

Cada tipo contém:

- id;
- código;
- descrição;
- exige documento;
- ativo;
- natureza.

## Natureza de lançamento

A natureza associada expõe o conjunto funcional necessário ao PDV, incluindo:

- id;
- código;
- descrição;
- categoria principal;
- subcategoria;
- tipo;
- status;
- tipo de natureza;
- natureza da operação;
- categoria gerencial;
- movimenta financeiro;
- entra DRE.

## Dados não expostos

O contrato não deve carregar estruturas contábeis ou segredos sem necessidade operacional, como:

- plano contábil completo;
- conta contábil interna;
- token;
- password;
- secret;
- hash.

## Ordenação

A resposta possui ordenação determinística por descrição, código e identificador.

## Uso funcional

O snapshot serve como referência central para operações locais como despesas/sangrias que precisem classificar o movimento de caixa de forma coerente com a natureza financeira configurada no Sysvar.

A existência do snapshot não autoriza o Hub a criar uma nova natureza corporativa.

## Autoridade

O Sysvar Central continua sendo autoridade de:

- `TipoDespesaPdv`;
- `Nat_Lancamento`;
- regras financeiras relacionadas.

O Hub consome cópia operacional.

## Commit de referência

- `108197240e07b679321d1335b62712954a3337b8` — `feat: expoe tipos de despesa ao Sysvar Hub`.

## Relacionados

- [[Sysvar Hub]]
- [[Mapa Técnico - Sysvar Hub - Vendedores]]
- [[Mapa Técnico - Sysvar Hub - Sincronização Hub para Central]]
- [[Riscos e Cuidados - Sysvar Hub - Idempotência e Retry]]
