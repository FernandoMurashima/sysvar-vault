---
type: reference
status: active
project: Sysvar
source: "FernandoMurashima/sysvarbackend + FernandoMurashima/sysvarfrontend"
created: 2026-09-18
updated: 2026-09-18
tags:
  - sysvar
  - estoque
  - inventario
  - contagem
  - auditoria
---

# Mapa Técnico - Estoque - Inventário

## Objetivo

Documentar o fluxo operacional vigente de inventário de estoque do [[Sysvar]].

O inventário compara o saldo físico contado com o saldo existente no sistema por Loja e, após validação, pode gerar ajustes rastreáveis no estoque.

## Conceitos principais

- `InventarioEstoque`: cabeçalho do inventário por Loja.
- `InventarioEstoqueItem`: fotografia e contagem por SKU/EAN.
- `Estoque`: saldo físico efetivo do SKU por Loja.
- `EstoqueMovimentacao`: trilha de alteração de saldo gerada no fechamento quando existe diferença.

O saldo original do inventário é uma fotografia e não deve ser reescrito durante a contagem.

## Estados operacionais

Fluxo vigente:

~~~text
ABERTO
↓
contagem / revisão
↓
VALIDADO
↓
finalização
↓
FECHADO
~~~

Inventário `FECHADO` é somente consulta.

## Criação

Ao criar um inventário, o sistema gera os itens iniciais a partir do estoque da Loja e registra auditoria do evento.

A geração adicional de itens só é permitida enquanto o inventário estiver aberto.

## Formas de contagem

A contagem pode ocorrer por:

1. lançamento manual;
2. leitura de EAN/código de barras;
3. importação textual TXT/CSV.

A leitura por EAN suporta contagem incremental e lançamento de quantidade.

EAN válido ainda ausente no inventário pode ser incorporado sem duplicar item.

## Importação de contagem

A implementação vigente usa linhas no formato:

~~~text
EAN,quantidade
~~~

Exemplo:

~~~text
7891234567890,5
7891234567891,2
~~~

O fluxo possui duas etapas:

~~~text
PREVIEW
↓
VALIDAÇÃO
↓
APLICAÇÃO
~~~

Endpoints implementados no backend:

~~~text
POST /api/produto/inventario-estoque/<id>/importar-preview/
POST /api/produto/inventario-estoque/<id>/importar-aplicar/
~~~

O preview não altera o banco.

Ele identifica, entre outros casos:

- linhas válidas;
- linhas inválidas;
- EAN inexistente;
- EAN pertencente a outra Empresa;
- quantidade inválida;
- quantidade negativa;
- estrutura de linha inválida;
- duplicidades.

Duplicidades válidas do mesmo EAN são consolidadas pela quantidade antes da aplicação.

A aplicação altera somente a contagem do inventário. Ela não movimenta estoque imediatamente.

## Pesquisa e filtros

A tela operacional permite pesquisa e filtros sobre os itens do inventário, preservando a separação por Empresa e Loja permitida ao usuário.

## Revisão e indicadores

O inventário calcula indicadores de conferência como:

- pendentes;
- corretos;
- sobras;
- faltas;
- divergências.

A validação não deve permitir fechamento com contagens pendentes.

## Finalização

A finalização do inventário é transacional.

Para cada SKU divergente:

- o estoque físico da Loja é ajustado para a quantidade contada;
- é criada `EstoqueMovimentacao` do tipo ajuste;
- a origem é Inventário;
- o documento segue o identificador `INV-<id>`;
- são preservados saldo anterior e saldo posterior.

Quando não existe diferença, não é criada movimentação desnecessária.

Exemplo:

~~~text
Sistema: 10
Contado: 6
Diferença: -4

→ estoque final = 6
→ movimento de ajuste = -4
~~~

O fechamento é atômico. Falha durante a geração da movimentação não pode deixar estoque parcialmente ajustado.

Segunda tentativa sobre inventário já fechado é bloqueada, evitando duplicidade de movimentos.

## Auditoria

Eventos relevantes são registrados na auditoria, incluindo:

- criação do inventário;
- geração de itens;
- alteração de contagem;
- validação;
- fechamento.

## Frontend

Rota principal:

~~~text
/estoque/inventario
~~~

A interface possui suporte a:

- operação de contagem;
- leitura por pistola/EAN;
- importação de contagem;
- revisão e indicadores;
- finalização;
- exportação XLSX;
- consulta de inventários fechados.

## Regras de segurança

- respeitar Empresa do usuário;
- respeitar Lojas permitidas;
- não aceitar EAN de outra Empresa;
- não alterar saldo físico durante preview/importação;
- não permitir mutações em inventário fechado;
- não duplicar movimentos no fechamento.

## Commits de referência

Backend:

- `7f48d105` — Corrige escopo operacional do inventário.
- `7f2fcf59` — Pesquisa e filtros.
- `c9240060` — Leitura de EAN.
- `551bf023` — Importação de contagem.
- `7e02b299` — Revisão e indicadores.
- `fdd8c738` — Fechamento operacional.

Frontend:

- `9625d030` — Tela operacional.
- `c9e8cfc1` — Leitura por pistola.
- `a1f5fd65` — Importação.
- `3b87d858` — Revisão e indicadores.
- `b05cf13c` — Finalização.
- `e632c8a1` — Exportação XLSX.

## Relacionados

- [[Sysvar]]
- [[Arquitetura]]
- [[Mapa Técnico]]
- [[Modelo de Domínio]]
- [[Riscos e Cuidados]]
