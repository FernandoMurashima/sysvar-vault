---
type: technical-map
status: active
project: Sysvar
source: "FernandoMurashima/sysvarbackend/financeiro + FernandoMurashima/sysvarfrontend"
created: 2026-09-30
updated: 2026-09-30
tags:
  - sysvar
  - financeiro
  - estado-atual
---

# Estado Atual - Financeiro

## Data de referência

30/09/2026.

Esta nota descreve a implementação vigente e não substitui planejamentos futuros ainda não implementados.

## Autoridade técnica

Backend Central:

`sysvarbackend/financeiro/`

Frontend:

features financeiras em `sysvarfrontend`.

## Cadastros e configurações vigentes

O código atual possui:

- `FormaPagamento`;
- `PrazoPagamento` e `PrazoPagamentoParcela`;
- `Adquirente`;
- `CondicaoAdquirente`;
- `ConfigFinanceira`;
- `TipoDespesaPdv`;
- `Caixa`;
- `ContaBancaria`.

### Forma de Pagamento

Tipos atuais:

- DINHEIRO;
- PIX;
- DEBITO;
- CREDITO;
- BOLETO;
- TRANSFERENCIA;
- OUTRO.

No estado atual do código, `FormaPagamento` ainda contém vínculos/campos como prazo de pagamento, conta de liquidação, geração de recebível, prazo de crédito e configuração TEF. Qualquer planejamento que proponha retirar ou mover esses campos deve ser tratado como futuro até que a implementação correspondente exista em `main`.

### Adquirentes

`CondicaoAdquirente` relaciona empresa, adquirente, forma de pagamento e prazo de pagamento, com taxa percentual e taxa fixa.

## Operação financeira

Rotas vigentes incluem:

- `caixas`;
- `contas-bancarias`;
- `movimentacoes`;
- `lancamentos-contabeis`;
- `pagar`, `pagar-item`, `pagar-rateio`;
- `receber`, `receber-item`, `receber-rateio`;
- `antecipacoes-recebiveis`.

O Financeiro recebe efeitos de Compras, Vendas/PDV, Caixa, recebimentos, comissões e demais origens previstas nos serviços atuais.

## Benefícios e crédito de cliente

O módulo também contém:

- `CashbackConfig`;
- `CashbackMovimento`;
- `ValeTroca`;
- `ValeTrocaMovimento`;
- reserva de Vale-Troca para operação online do Hub.

Vale-Troca oficial possui autoridade de saldo na Central quando utilizado no fluxo online do Hub.

## Integração com o Hub

A Central expõe ao Hub informações financeiras necessárias à operação local, incluindo formas de pagamento e tipos de despesa PDV. Vale-Troca online possui endpoints específicos no app Central `hub/`.

A sessão financeira de caixa no Hub é distinta da autenticação pessoal do operador.

## Contas a Receber de vendas

A geração e manutenção dos recebíveis de venda devem ser conferidas pelo comportamento atual de `fiscal`, `financeiro` e integração Hub. Alterações futuras de documento comercial de Receber não devem ser tratadas como implementadas antes da mudança efetiva no código.

## Contabilidade

`LancamentoContabil` e configurações/vínculos contábeis fazem parte do Financeiro atual. Movimentações e baixas podem gerar reflexos contábeis conforme os serviços implementados.

## Regra documental

Para análise do Financeiro, usar em conjunto:

1. esta nota de estado atual;
2. código `financeiro/`;
3. integrações de origem, principalmente `fiscal/`, `compras/` e `hub/`;
4. planejamentos somente para itens ainda futuros.

Não converter decisão de planejamento em descrição de estado atual sem confirmação no código.