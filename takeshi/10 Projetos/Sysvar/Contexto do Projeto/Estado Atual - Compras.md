---
type: technical-map
status: active
project: Sysvar
source: "FernandoMurashima/sysvarbackend/compras + FernandoMurashima/sysvarbackend/fiscal + FernandoMurashima/sysvarfrontend"
created: 2026-09-30
updated: 2026-09-30
tags:
  - sysvar
  - compras
  - estado-atual
---

# Estado Atual - Compras

## Data de referência

30/09/2026.

## Autoridade técnica

Backend Central principal: `sysvarbackend/compras/`.

Entrada fiscal e recebimentos relacionados atravessam também `sysvarbackend/fiscal/`.

Frontend: features de Compras no `sysvarfrontend`.

## Rotas vigentes

O app de Compras expõe atualmente:

- cotações, fornecedores, itens e propostas de cotação;
- pedidos de compra;
- itens, entregas e parcelas de pedido;
- ordens de serviço e materiais;
- requisições, itens e histórico;
- categorias, setores, matriz de responsabilidade e finalidades ligados às requisições.

## Entrada de NF-e

Entrada de NF-e não é responsabilidade exclusiva de `compras/`. O fluxo real integra:

- Compras;
- Fiscal;
- Produtos/Estoque;
- Financeiro;
- Fornecedor.

O vault já possui documentação granular de Pedido de Compra, Requisições, Cotação, Ordem de Serviço, Recebimento de Mercadoria e Entrada de NF-e. Esses documentos continuam sendo a referência detalhada quando compatíveis com o código vigente.

## Regra documental

Não tratar Pedido de Compra, recebimento físico e Nota Fiscal de Entrada como a mesma entidade. Eles participam do mesmo fluxo, mas possuem responsabilidades próprias.

Para qualquer mudança de Entrada de NF-e, revisar também `fiscal/` e os impactos de estoque/financeiro antes de atualizar a documentação.