---
type: technical-map
status: active
project: Sysvar
source: "FernandoMurashima/sysvarbackend/produto + FernandoMurashima/sysvarfrontend"
created: 2026-09-30
updated: 2026-09-30
tags:
  - sysvar
  - produtos
  - estado-atual
---

# Estado Atual - Produtos

## Data de referência

30/09/2026.

## Autoridade técnica

Backend Central: `sysvarbackend/produto/`.

Frontend: features de Produtos no `sysvarfrontend`.

## Escopo vigente

O app `produto` concentra:

- NCM e configuração de EAN;
- grades, tamanhos, cores, materiais, coleções e unidades;
- grupos e subgrupos;
- tabelas de preço;
- Produto e ProdutoDetalhe/SKU;
- Produto × Fornecedor;
- imagens;
- preços por produto;
- promoções;
- packs e itens de pack;
- além das estruturas técnicas de Produção e Estoque documentadas separadamente.

## Fronteira importante

Produção e Estoque usam o mesmo app backend `produto/`. Isso não transforma todos esses conceitos em um único módulo funcional no menu; significa apenas que compartilham a mesma autoridade técnica no backend atual.

## Documentação granular

O vault já possui documentação específica para Produto Venda, Produto Uso/Consumo, Insumos, Cadastros Auxiliares e integrações de produto. Esses documentos continuam sendo a referência detalhada de cada assunto quando compatíveis com o código vigente.

## Integrações

Produtos é dependência central de:

- Compras;
- Estoque;
- Produção;
- Distribuição;
- Vendas/PDV;
- Fiscal;
- Hub/catalogo.

## Regra documental

Não duplicar em uma nota geral os detalhes já mantidos nos mapas técnicos específicos. Para fronteiras de Produção e Estoque, consultar [[Estado Atual - Produção e Estoque]].