---
type: reference
status: active
project: Sysvar
source: "FernandoMurashima/sysvarbackend + FernandoMurashima/sysvarfrontend"
created: 2026-09-18
updated: 2026-09-18
tags:
  - sysvar
  - compras
  - estoque
  - recebimento
  - conferencia
  - nfe
---

# Mapa Técnico - Compras - Recebimento de Mercadoria

## Objetivo

Documentar o fluxo físico de recebimento de mercadoria de revenda no [[Sysvar]].

Este fluxo foi separado da simples importação fiscal da NF-e.

Conceito:

~~~text
NF-e / XML
→ documento fiscal

Recebimento de Mercadoria
→ ocorrência física de conferência e entrada no estoque
~~~

## Entidades principais

### RecebimentoMercadoriaEstoque

Representa o processo físico de recebimento.

Campos/conceitos principais:

- Empresa;
- Loja de destino;
- XML de fornecedor;
- Fornecedor;
- status;
- usuário criador;
- datas de criação/atualização.

Estados:

~~~text
ABERTO
EM_CONFERENCIA
CONCLUIDO
CANCELADO
~~~

### RecebimentoMercadoriaPedido

Relaciona o recebimento aos Pedidos de Compra envolvidos.

Um recebimento pode estar associado a mais de um Pedido quando o XML/mercadoria consolidar itens de pedidos diferentes.

## Proteção contra duplicidade

Enquanto um recebimento ligado ao mesmo XML estiver `ABERTO` ou `EM_CONFERENCIA`, existe proteção para impedir outro recebimento ativo equivalente na mesma Empresa.

## Conferência física

O recebimento possui conferência física própria.

A conferência trabalha com:

- SKU/EAN;
- quantidade do Pedido;
- quantidade da NF-e;
- quantidade física;
- diferenças entre essas três referências.

A quantidade faturada e a quantidade física não devem ser tratadas como o mesmo dado.

## Bipagem

A leitura por código de barras/EAN alimenta a quantidade física conferida.

O fluxo deve preservar o item correto por SKU e impedir mistura entre empresas ou documentos incompatíveis.

## Fechamento e termo

O encerramento gera termo de recebimento imutável para preservar a fotografia da conferência realizada.

Depois de concluído, o histórico não deve ser reescrito como se a conferência original tivesse sido outra.

## Entrada no estoque

A efetivação física lança estoque por EAN/SKU.

O lançamento foi consolidado para evitar duplicidade quando a mesma identificação aparece em estruturas intermediárias.

A movimentação de estoque deve registrar origem e documento do recebimento para manter rastreabilidade.

## Integração com Pedido de Compra

O recebimento físico atualiza o atendimento do Pedido.

O cálculo considera recebimentos anteriores válidos e ignora recebimentos cancelados.

Isso permite:

- recebimento parcial;
- recebimento total;
- mais de um recebimento para o mesmo Pedido ao longo do tempo;
- resumo consolidado do que já foi recebido.

## Resumo consolidado

O backend expõe resumo de recebimentos associado ao Pedido para que a interface consiga apresentar o histórico físico real, inclusive em cenário com múltiplos pedidos/recebimentos.

## Custos do SKU

No recebimento de mercadoria de revenda, a entrada de estoque também deve persistir os custos do SKU.

Campos corrigidos no fluxo:

- `custo_original`;
- `custo_ultima_compra`;
- `custo_medio`;
- custo unitário da movimentação;
- custo total da movimentação;
- custo médio após a movimentação.

Foi criado comando idempotente para reparação de recebimentos históricos quando necessário:

~~~text
python manage.py reparar_custos_recebimentos_mercadoria
~~~

## Frontend

Rota:

~~~text
/estoque/recebimentos-mercadoria
~~~

No menu principal, a operação de estoque central/almoxarifado é apresentada como:

~~~text
Recebimento de Almoxarifado
~~~

Isso deve ser diferenciado do recebimento na Loja, que possui fluxo próprio.

## Relação com NF-e

A efetivação fiscal e a efetivação física são relacionadas, mas não são a mesma operação.

Não assumir que:

~~~text
NF-e registrada
=
mercadoria fisicamente conferida
~~~

O sistema deve preservar a possibilidade de tratamento fiscal sem movimentação de estoque quando o cenário assim exigir.

## Regras críticas

- não lançar estoque duas vezes para o mesmo recebimento;
- não somar recebimento cancelado no saldo físico do Pedido;
- não alterar termo concluído;
- não confundir quantidade faturada com quantidade física;
- não perder vínculo com Pedido(s);
- não perder custo do SKU na entrada;
- manter isolamento por Empresa e Loja.

## Commits de referência

Backend:

- `adf55ba3` — fluxo base de recebimento;
- `98af4e5a` — conferência física;
- `9c55ce73` — quantidade faturada;
- `cb3a87a7` — termo imutável;
- `f10cbc64` — lançamento de estoque;
- `a809c186` — consolidação por EAN;
- `ba2689ad` — integração com atendimento do Pedido;
- `e43113d0` — proteção do ciclo físico;
- `fd980ef0` / `2d41e1d0` — saldo físico pendente e cancelamentos;
- `9f73124c` / `0aba52a6` — resumo consolidado;
- `666178b7` — custos no recebimento.

Frontend:

- `6ef1d9a8` — telas base;
- `b4520712` — conferência;
- `d4b9f4c0` — leitura por código de barras;
- `3cbe3e2f` — termo de fechamento;
- `132e22a7` — lançamento de estoque;
- `0953ff2d` / `2a7b8d16` — resumo e status físico.

## Relacionados

- [[Mapa Técnico - Compras - Pedido de Compra]]
- [[Mapa Técnico - Compras - Entrada de NF-e]]
- [[Mapa Técnico - Fiscal - XML de Fornecedor e NF-e de Entrada]]
- [[Mapa Técnico - Estoque - Consultas e Movimentações]]
