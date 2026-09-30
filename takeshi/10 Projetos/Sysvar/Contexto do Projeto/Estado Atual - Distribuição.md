---
type: technical-map
status: active
project: Sysvar
source: "FernandoMurashima/sysvarbackend/distribuicao + FernandoMurashima/sysvarfrontend"
created: 2026-09-30
updated: 2026-09-30
tags:
  - sysvar
  - distribuicao
  - estado-atual
---

# Estado Atual - Distribuição

## Data de referência

30/09/2026.

## Autoridade técnica

Backend Central:

`sysvarbackend/distribuicao/`

Frontend:

features de Distribuição do `sysvarfrontend`.

## Estruturas expostas

O módulo possui rotas para:

- `perfis`;
- `perfis-itens`;
- `distribuicoes`;
- `pedidos-venda`;
- `transitos`.

A lógica principal está distribuída entre `models.py`, `serializers.py`, `services.py` e `views.py` do app.

## Papel funcional

Distribuição organiza a movimentação planejada de produtos entre unidades e o atendimento das necessidades de loja, usando perfis/regras e fluxos próprios de distribuição e trânsito.

Pedido de Venda da Distribuição pertence a este domínio e não deve ser confundido com Venda PDV de loja, que pertence ao domínio fiscal/Hub.

## Integrações

O módulo depende principalmente de:

- Produtos/SKUs;
- Lojas;
- Estoque;
- perfis de distribuição;
- movimentos/trânsitos gerados pela operação.

Quando uma distribuição produzir movimento físico, o reflexo de estoque deve continuar rastreável pelas estruturas de estoque vigentes.

## Numeração

Qualquer planejamento de nova composição comercial para Distribuição ou Pedido de Venda da Distribuição é assunto separado da descrição do estado atual. Esta nota não antecipa padrões ainda não implementados em `main`.

## Regra documental

Para alterações neste domínio, consultar:

1. esta nota;
2. `distribuicao/models.py`;
3. `distribuicao/services.py`;
4. `distribuicao/urls.py`;
5. código frontend correspondente;
6. Estoque quando houver movimentação física.
