---
type: homologation
status: approved
project: Sysvar
group: Financeiro
module: Formas de Pagamento e Recebíveis do Hub
phase: Reestruturação Financeiro / Hub
created: 2026-10-08
updated: 2026-10-08
tags:
  - sysvar
  - financeiro
  - formas-pagamento
  - sysvar-hub
  - pdv
  - receber
  - homologacao
  - aprovado
---

# Homologação - Financeiro - Formas de Pagamento e Recebíveis do Hub

## 1. Identificação

**Projeto:** [[Sysvar]]  
**Módulos:** Financeiro / Fiscal / Sysvar Hub  
**Funcionalidade:** Formas de Pagamento, condições, taxas e geração de Receber a partir da VendaHub  
**Situação:** HOMOLOGADO  
**Data de conclusão:** 08/10/2026  
**Resultado:** APROVADO

## 2. Objetivo

Registrar o fechamento funcional e técnico da reestruturação de Formas de Pagamento e condições utilizada pelo PDV do Sysvar Hub e seus reflexos em Contas a Receber.

## 3. Regra funcional aprovada

A estrutura final é:

~~~text
FormaPagamento
+
FormaPagamentoCondicao
+
PrazoPagamento / PrazoPagamentoParcela
~~~

`FormaPagamento` representa o meio comercial.

`PrazoPagamento` representa cronograma e quantidade de parcelas.

`FormaPagamentoCondicao` define quais prazos são permitidos para a forma e é a autoridade de taxa percentual e taxa fixa.

A condição é exigida quando:

`FormaPagamento.permite_parcelamento = true`

A regra não depende de `tipo == CREDITO`.

## 4. Formas oficiais da Base DEV

- `DIN` — Dinheiro — sem parcelamento;
- `PIX` — PIX — sem parcelamento;
- `DEB` — Cartão de débito — permite condição;
- `CRE` — Cartão de crédito — permite condição.

Não utilizar formas separadas como CCR, CC2, CC3 ou CC4.

## 5. Condições oficiais homologadas

| Forma | Prazo | Parcelas | Dias | Taxa % | Taxa fixa |
|---|---|---:|---|---:|---:|
| DEB | AV | 1 | 0 | 0,0000% | 0,00 |
| CRE | 30D | 1 | 30 | 2,0000% | 0,00 |
| CRE | 30-60 | 2 | 30/60 | 2,5000% | 0,00 |
| CRE | 30-60-90 | 3 | 30/60/90 | 2,5000% | 0,00 |

O prazo geral `30-60-90-120` permanece cadastrado, mas não é condição ativa de CRE na Base DEV oficial.

## 6. Autoridade de taxas

A autoridade única é:

- `FormaPagamentoCondicao.taxa_percentual`;
- `FormaPagamentoCondicao.taxa_fixa`.

`CondicaoAdquirente` não é fonte operacional de taxa.

Seus campos de taxa permanecem no schema somente por compatibilidade histórica e são tratados como legados.

## 7. Adquirentes

`Adquirente` e `CondicaoAdquirente` continuam existindo para vínculo e referência.

A condição de adquirente pode identificar:

- adquirente;
- forma;
- prazo;
- status.

Ela não deve redefinir a taxa da operação.

Adquirente é opcional para a venda condicionada e para a criação do recebível.

## 8. Conta bancária

Conta bancária não faz parte da autoridade da Forma de Pagamento.

Não é obrigatória para gerar ReceberItem previsto.

A escolha da conta pertence ao fluxo de baixa/liquidação.

## 9. Sysvar Hub - sincronização

O Central envia ao Hub:

- formas;
- `permite_parcelamento`;
- prazos gerais;
- condições permitidas;
- número de parcelas;
- dias;
- taxas;
- parcelas do prazo.

O Hub mantém cópia operacional local e inativa condições ausentes em sincronizações posteriores sem apagar histórico.

## 10. F9 no PDV

F9 é o fluxo principal de pagamentos.

Comportamento homologado:

- formas sem condição seguem diretamente;
- formas condicionadas mostram somente as condições permitidas;
- CRE apresenta 1x, 2x e 3x;
- a escolha visual é por número de parcelas;
- o operador não precisa conhecer código interno, dias ou taxa;
- o pagamento guarda snapshot da condição selecionada.

O fluxo lateral duplicado de pagamento foi removido, preservando a finalização da venda.

## 11. Snapshot financeiro

O pagamento condicionado preserva no evento da venda:

- condição;
- prazo;
- código e descrição do prazo;
- número de parcelas;
- taxa percentual;
- taxa fixa;
- cronograma de parcelas.

Alterações futuras na configuração não retroagem para vendas já realizadas.

## 12. Receber - pagamento imediato

Pagamento sem condição gera:

- 1 Receber;
- 1 ReceberItem;
- status `BAIXADO`;
- valor de baixa;
- data de baixa.

O retry do mesmo evento não duplica venda, financeiro nem estoque.

## 13. Receber - pagamento condicionado

Pagamento com condição gera:

- 1 Receber;
- N ReceberItem;
- status `PREVISTO`;
- vencimentos conforme snapshot;
- bruto por parcela;
- taxa;
- valor da taxa;
- líquido previsto.

Não ocorre baixa automática nem movimentação bancária de liquidação para parcelas previstas.

## 14. Identidade comercial do título

O Receber originado de venda usa o mesmo documento comercial da VendaPdv:

~~~text
Receber.Titulo = VendaPdv.documento
Receber.Documento = VendaPdv.documento
~~~

Padrão de venda:

`VE...`

Não utilizar numeração paralela `RE...` para esse caso.

## 15. Fallback sem snapshot

Fluxos compatíveis sem snapshot podem resolver taxa por Forma + Prazo usando `FormaPagamentoCondicao`.

Não existe fallback para taxa legada de `CondicaoAdquirente`.

## 16. Benefícios

Cashback e Vale-Troca não geram recebível financeiro próprio.

Em pagamento misto, apenas a parte efetivamente financeira entra em Receber.

## 17. Arredondamento

A taxa percentual total é calculada sobre o valor financeiro e distribuída pelas parcelas.

Diferenças de centavos provocadas pelo arredondamento são absorvidas deterministicamente na última parcela.

## 18. NFC-e / tPag

O tPag permanece baseado no tipo da Forma de Pagamento:

- DINHEIRO → 01;
- CREDITO → 03;
- DEBITO → 04;
- PIX → 17.

Parcelamento não altera tPag.

## 19. Regressão automatizada

### Hub Backend

Commit final de regressão:

`fc12ffb6b5f9410a941f0374eef03f4aa2940e6c`

Cobertura confirmada:

- contrato oficial Central → Hub;
- DIN sem condição;
- PIX sem condição;
- DEB AV 1x;
- CRE 1x, 2x e 3x;
- snapshot histórico;
- payload `VENDA_FINALIZADA`;
- tPag por tipo.

### Central Backend

Commit final de regressão:

`15219aa2564e170c39274c97f8549653cba02093`

Cobertura confirmada:

- pagamento imediato baixado;
- DEB 1x previsto;
- CRE 1x, 2x e 3x;
- vencimentos;
- taxas e líquido previsto;
- snapshot histórico;
- fallback sem snapshot;
- adquirente opcional;
- conta bancária não obrigatória;
- benefícios;
- documento VE;
- idempotência;
- arredondamento de taxa.

## 20. Homologação manual

Em 08/10/2026 foi executada sincronização do Hub da Loja Barra pelo sistema.

No PDV:

- F9 carregou as formas sincronizadas;
- CRE exibiu exatamente 1x, 2x e 3x;
- vendas parceladas foram concluídas;
- parcelas correspondentes foram conferidas em Contas a Receber.

O usuário declarou o fluxo aprovado e encerrou a bateria manual.

Os cenários adicionais de DIN, PIX, DEB e tPag permanecem cobertos pelas regressões automatizadas dirigidas executadas antes da aprovação final.

## 21. Principais commits da implementação

Central Backend:

- `9ace003ea5732c86cd05e56a886908eeb19fc594` — FormaPagamentoCondicao e permite_parcelamento;
- `68c53ab464b7999939312f66023821818bbd16a9` — contrato Central → Hub;
- `e8682b5eebd5e0daf3d0cd3078765748ad82bddf` — recebíveis por snapshot da condição;
- `1b5dcf3e081f3d5192eaf9f9b62c4a75a31a44b4` — distinção entre pagamento condicionado e sem condição;
- `721c6f2843a46b7de31c25d85e280cf990baf4bc` — autoridade única de taxas;
- `aa368ff3113d569d8455362c6bc63e7d46768aaa` — seeds oficiais;
- `8d250a19ccd8b054e5cfd9fc08314ed86d95cde0` — rebuild limpa adquirentes/vínculos;
- `15219aa2564e170c39274c97f8549653cba02093` — regressão e arredondamento.

Central Frontend:

- `f7d3b9496d3d5ef2577af7188baf8019577dfecd` — condições na Forma de Pagamento;
- `29c01a855b05311ff9f75b1f1f4cbf5d745d471b` — retirada de campos legados da tela de Forma;
- `82403d081107409bfee8e2db719d6d32ec5eb114` — retirada de taxas da tela de Condições de Adquirente.

Hub Backend:

- `f64724ed6aae7dbed91ca292df5d0381266a813e` — persistência de condições;
- `524fa2b8d2d07360878c278350623ae853fd8f51` — condição exigida genericamente por permite_parcelamento;
- `fc12ffb6b5f9410a941f0374eef03f4aa2940e6c` — regressão final do Hub.

Hub Frontend:

- `2201ea73b1edf4376fd575dad70d22feb01126ad` — F9 com condições;
- `7d6be15fe7786b985455ad940909ae76b8f11cfa` — botões de parcelas;
- `0d6180489caf9e7661b95c0fe87e64c0f5d2b99f` e `096eeb1429482448cffa454aa4150e05c1f93c5f` — estado visual selecionado.

## 22. Estado final

~~~text
IMPLEMENTADO
TESTADO
HOMOLOGADO
APROVADO
~~~

Não reabrir a regra de Forma × Prazo × Taxa sem novo requisito ou defeito comprovado.

TEF/Pinpad permanece fora deste fechamento.

A homologação externa real da NFC-e com SEFAZ/certificado permanece uma etapa fiscal própria.

## Relacionados

- [[Estado Atual - Financeiro]]
- [[Sysvar Hub]]
- [[Checkpoint - Sysvar Hub]]
- [[Base de Desenvolvimento]]
