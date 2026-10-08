---
type: technical-map
status: active
project: Sysvar
source: "FernandoMurashima/sysvarbackend/financeiro + FernandoMurashima/sysvarbackend/fiscal + FernandoMurashima/sysvarbackend/hub + FernandoMurashima/sysvarfrontend"
created: 2026-09-30
updated: 2026-10-08
tags:
  - sysvar
  - financeiro
  - formas-pagamento
  - receber
  - sysvar-hub
  - estado-atual
---

# Estado Atual - Financeiro

## Data de referência

08/10/2026.

Esta nota descreve o estado vigente após a reestruturação de Formas de Pagamento, condições, taxas e geração de recebíveis das vendas do Sysvar Hub.

A homologação correspondente está registrada em [[Homologação - Financeiro - Formas de Pagamento e Recebíveis do Hub]].

## Autoridade técnica

Backend Central:

- `sysvarbackend/financeiro/` — cadastros e domínio financeiro;
- `sysvarbackend/fiscal/views/venda_pdv.py` — materialização financeira da venda;
- `sysvarbackend/hub/` — contratos e sincronização Central ↔ Hub.

Frontend Central:

- features financeiras em `sysvarfrontend`.

## Forma de Pagamento

`FormaPagamento` representa o meio comercial de pagamento.

Tipos vigentes:

- DINHEIRO;
- PIX;
- DEBITO;
- CREDITO;
- BOLETO;
- TRANSFERENCIA;
- OUTRO.

A Base DEV oficial usa quatro formas operacionais:

- `DIN` — Dinheiro;
- `PIX` — PIX;
- `DEB` — Cartão de débito;
- `CRE` — Cartão de crédito.

Não existem formas comerciais distintas para crédito 1x, 2x, 3x etc.

## Prazo de Pagamento

`PrazoPagamento` e `PrazoPagamentoParcela` definem o cronograma da condição:

- quantidade de parcelas;
- dias de vencimento;
- percentuais de distribuição.

Prazo é cadastro independente da Forma de Pagamento.

## FormaPagamentoCondicao

`FormaPagamentoCondicao` é a autoridade da compatibilidade entre Forma de Pagamento e Prazo de Pagamento.

Ela define:

- empresa;
- forma de pagamento;
- prazo permitido;
- taxa percentual;
- taxa fixa;
- ativo.

A exigência de seleção de condição depende de:

`FormaPagamento.permite_parcelamento`

e não do tipo técnico `CREDITO`.

Isso permite a mesma arquitetura para crédito, débito, PIX ou futuros meios que precisem trabalhar com condições.

### Autoridade de taxas

A autoridade operacional das taxas é exclusivamente:

`FormaPagamentoCondicao.taxa_percentual`
`FormaPagamentoCondicao.taxa_fixa`

A taxa não deve ser mantida em dois lugares.

## Adquirentes

`Adquirente` continua existindo.

`CondicaoAdquirente` continua podendo relacionar:

- empresa;
- adquirente;
- forma de pagamento;
- prazo de pagamento;
- ativo.

Os campos antigos de taxa de `CondicaoAdquirente` permanecem fisicamente por compatibilidade, mas são legados e não são autoridade operacional.

Na API e no Django Admin, essas taxas não funcionam como segundo ponto de configuração.

No Frontend Central, a tela **Condições de Adquirente** configura somente:

- Adquirente;
- Forma;
- Prazo;
- Status.

As taxas são configuradas somente em **Formas de Pagamento → Condições de parcelamento**.

## Conta bancária

Conta bancária não pertence à definição da Forma de Pagamento nem da condição comercial.

`FormaPagamento.conta_liquidacao` permanece como campo legado de compatibilidade, mas não é exigido para gerar o recebível parcelado.

A conta deve ser tratada no fluxo de baixa/liquidação.

## Integração Central → Hub

`GET /api/hub/formas-pagamento/` envia ao Hub, entre outros dados:

- `permite_parcelamento`;
- condições ativas de `FormaPagamentoCondicao`;
- prazo;
- número de parcelas;
- cronograma;
- taxa percentual;
- taxa fixa.

As condições de parcelamento são a fonte operacional para o Hub.

## Pagamento no Hub

No PDV do Sysvar Hub:

- F9 é o fluxo principal de pagamento;
- a forma é escolhida no modal de pagamentos;
- formas sem condição seguem diretamente;
- formas com `permite_parcelamento=true` mostram somente as condições permitidas;
- o operador vê o número de parcelas, não a estrutura interna do prazo;
- o pagamento guarda snapshot da condição utilizada.

A condição escolhida é persistida com identificação de Forma, Prazo, taxas e parcelas.

## Snapshot financeiro da venda

Para uma venda Hub condicionada, o snapshot enviado ao Central preserva:

- `forma_pagamento_condicao_id`;
- `prazo_pagamento_id`;
- código e descrição do prazo;
- número de parcelas;
- taxa percentual;
- taxa fixa;
- parcelas e dias.

Depois que a venda existe, alterações futuras na configuração não alteram o histórico financeiro daquela operação.

## Contas a Receber de vendas

### Pagamento imediato sem condição

Pagamento sem condição continua gerando:

- 1 `Receber`;
- 1 `ReceberItem`;
- item com status `BAIXADO`;
- valor e data de baixa preenchidos.

A presença de campos financeiros default no payload do Hub não transforma um pagamento sem `forma_pagamento_condicao_id` em pagamento parcelado.

### Pagamento com condição

Pagamento com condição gera:

- 1 `Receber`;
- N `ReceberItem`, conforme o snapshot;
- itens com status `PREVISTO`;
- vencimentos pelos dias do snapshot;
- valor bruto por parcela;
- taxa utilizada;
- valor da taxa;
- valor líquido previsto.

Parcelas previstas não geram baixa nem `MovimentacaoFinanceira` automática.

Adquirente e `CondicaoAdquirente` são opcionais.

### Documento comercial

O título financeiro originado da venda herda a identidade comercial da venda:

- `Receber.Titulo = VendaPdv.documento`;
- `Receber.Documento = VendaPdv.documento`.

Para venda, o padrão é `VE...`.

Não criar uma numeração financeira paralela `RE...` para esse caso.

### Fallback sem snapshot

Em fluxo compatível sem snapshot, quando houver Forma + Prazo, a taxa é obtida de `FormaPagamentoCondicao`.

Não existe fallback operacional para as taxas legadas de `CondicaoAdquirente`.

## Arredondamento de taxas

A taxa percentual parcelada é calculada sobre o total financeiro e distribuída pelas parcelas.

Eventual diferença de centavos decorrente do arredondamento é absorvida deterministicamente na última parcela, preservando o total exato da taxa.

## Benefícios

Cashback e Vale-Troca não são meios financeiros bancários.

Em venda mista, somente a parcela efetivamente financeira compõe `Receber` e `ReceberItem`.

## tPag da NFC-e

O `tPag` permanece derivado do tipo da Forma de Pagamento:

- DINHEIRO → `01`;
- CREDITO → `03`;
- DEBITO → `04`;
- PIX → `17`.

A quantidade de parcelas não altera o `tPag`.

## Base DEV oficial

Condições oficiais homologadas:

- DEB + AV → 1x, taxa 0%;
- CRE + 30D → 1x, taxa 2,00%;
- CRE + 30-60 → 2x, taxa 2,50%;
- CRE + 30-60-90 → 3x, taxa 2,50%.

DIN e PIX não possuem condição ativa na Base DEV oficial.

O prazo geral 30-60-90-120 continua cadastrado, mas não é condição permitida de CRE nessa massa oficial.

## Campos legados preservados

Continuam no schema por compatibilidade e não devem ser removidos isoladamente:

- `FormaPagamento.prazo_pagamento`;
- `FormaPagamento.conta_liquidacao`;
- `FormaPagamento.prazo_credito_dias`;
- taxas antigas de `CondicaoAdquirente`.

Limpeza destrutiva desses campos exige revisão própria de consumidores legados.

## Estado de homologação

O fluxo foi aprovado em 08/10/2026 após:

- regressão dirigida no Hub Backend;
- regressão dirigida no Central Backend;
- validação de sincronização Central → Hub;
- validação visual do F9;
- vendas parceladas pelo Hub;
- conferência das parcelas em Contas a Receber;
- aprovação funcional do usuário.

Não reabrir esta regra sem defeito comprovado ou novo requisito.

## Relacionados

- [[Sysvar Hub]]
- [[Base de Desenvolvimento]]
- [[Checkpoint - Sysvar Hub]]
- [[Homologação - Financeiro - Formas de Pagamento e Recebíveis do Hub]]
