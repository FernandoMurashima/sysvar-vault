---
type: checkpoint
status: active
project: Sysvar
created: 2026-09-20
updated: 2026-10-08
tags:
  - sysvar
  - hub
  - pdv
  - checkpoint
  - retomada
---

# Checkpoint — Sysvar Hub

## Checkpoint atual — 08/10/2026

A reestruturação de **Formas de Pagamento, condições, taxas e geração de Receber das vendas do Sysvar Hub foi concluída, testada, homologada e aprovada**.

Não retomar esse bloco como pendência aberta. Só reabrir mediante novo requisito ou defeito comprovado.

### Regra funcional fechada

A estrutura aprovada é:

~~~text
FormaPagamento
+
FormaPagamentoCondicao
+
PrazoPagamento / PrazoPagamentoParcela
~~~

Regras principais:

- Forma de Pagamento representa o meio comercial;
- Prazo representa o cronograma;
- FormaPagamentoCondicao define os prazos permitidos para a forma;
- a condição também é a autoridade de taxa percentual e taxa fixa;
- a exigência de condição depende de `permite_parcelamento`, não de `tipo == CREDITO`;
- CondicaoAdquirente continua como vínculo/referência, mas não é autoridade de taxa;
- conta bancária não é obrigatória para gerar recebível previsto e pertence ao fluxo de baixa/liquidação.

### Base DEV oficial

Formas:

- `DIN` — sem condição;
- `PIX` — sem condição;
- `DEB` — permite condição;
- `CRE` — permite condição.

Condições:

- DEB + AV → 1x, taxa 0%;
- CRE + 30D → 1x, taxa 2,00%;
- CRE + 30-60 → 2x, taxa 2,50%;
- CRE + 30-60-90 → 3x, taxa 2,50%.

O prazo 30-60-90-120 continua no cadastro geral, mas não é condição ativa de CRE na Base DEV oficial.

Adquirente e CondicaoAdquirente não são seedados na Base DEV oficial e são removidos pelo rebuild antes das entidades protegidas relacionadas.

### Sysvar Hub / F9

O F9 é o fluxo principal de pagamentos.

Estado aprovado:

- formas vêm da sincronização do Hub;
- formas sem condição seguem diretamente;
- formas condicionadas exibem somente as condições permitidas;
- CRE mostra 1x, 2x e 3x;
- o operador escolhe apenas o número de parcelas;
- o pagamento salva snapshot da condição utilizada;
- o snapshot segue no `VENDA_FINALIZADA`.

O fluxo visual duplicado de pagamento foi removido.

### Contas a Receber

Venda sem condição:

- gera 1 ReceberItem;
- status BAIXADO;
- baixa e data preenchidas.

Venda com condição:

- gera N ReceberItem;
- status PREVISTO;
- vencimentos conforme snapshot;
- taxas conforme snapshot;
- valor líquido previsto;
- sem baixa/movimentação bancária automática;
- adquirente opcional.

Documento do Receber de venda:

~~~text
Receber.Titulo = VendaPdv.documento
Receber.Documento = VendaPdv.documento
~~~

Padrão comercial:

`VE...`

Não criar `RE...` para o título originado de venda.

### Benefícios

Cashback e Vale-Troca não geram recebível financeiro próprio.

Venda mista gera Receber somente para a parcela efetivamente financeira.

### NFC-e / tPag

Permanece por tipo da forma:

- DINHEIRO → 01;
- CREDITO → 03;
- DEBITO → 04;
- PIX → 17.

Parcelamento não altera tPag.

TEF/Pinpad continua fora deste fechamento.

### Regressões finais

Hub Backend:

`fc12ffb6b5f9410a941f0374eef03f4aa2940e6c`

Central Backend:

`15219aa2564e170c39274c97f8549653cba02093`

As regressões confirmaram:

- DIN;
- PIX;
- DEB AV 1x;
- CRE 1x/2x/3x;
- snapshot histórico;
- fallback sem snapshot;
- arredondamento;
- benefícios;
- tPag;
- idempotência.

### Homologação manual final — 08/10/2026

Foi executada sincronização do Hub da Loja Barra pelo sistema.

No PDV:

- F9 exibiu as formas sincronizadas;
- CRE exibiu exatamente 1x, 2x e 3x;
- vendas parceladas foram realizadas;
- as parcelas correspondentes foram conferidas em Contas a Receber.

O usuário declarou o fluxo aprovado.

Referência completa:

[[Homologação - Financeiro - Formas de Pagamento e Recebíveis do Hub]]

### Próxima retomada após a pausa

Ao retomar o projeto:

1. **não reabrir Formas de Pagamento/parcelamento/taxas** sem erro concreto;
2. voltar às pendências de padronização documental e consulta de vendas;
3. revisar a exibição/pesquisa do documento comercial `VE...` na Consulta de Vendas do Central;
4. revisar a Consulta de Vendas/F12 no Hub;
5. depois executar a auditoria final da padronização de numeração de documentos.

A homologação externa real da NFC-e com SEFAZ/certificado permanece uma etapa fiscal futura específica.

---

## Checkpoint anterior — 20/09/2026

### Onde paramos

Sessão encerrada em **20/09/2026**.

Bloco técnico concluído e aprovado:

- Devolução;
- Cashback;
- Vale-Troca;
- Promoções.

A NFC-e também está encerrada no desenvolvimento atual, permanecendo apenas a homologação externa real com SEFAZ/certificado para etapa futura específica.

## Últimos commits aprovados

### Sysvar Central Backend

`2ffab8d217d2f0d21f72ae207a42af8f01b3dc2c`

Última correção aprovada:

- exclusão de Cashback e Vale-Troca dos recebíveis financeiros;
- venda 100% paga com benefício não cria `Receber`;
- venda mista cria `Receber` somente com a parcela efetivamente financeira.

### Sysvar Hub Backend

`25a0c649a1c1a3842114e8a17b4ad41b21f55bb0`

Última correção aprovada:

- Vale-Troca exige cupom/documento identificado;
- não existe consumo automático de outro vale.

### Sysvar Hub Frontend

`7c0221137555f3ec201136ffc9ba002a79362d5f`

Estado aprovado:

- devolução por Venda/Cupom;
- visualização de Cashback Central x saldo offline utilizável;
- seleção de Vale-Troca local utilizável;
- vales de retaguarda exibidos sem permitir consumo offline inseguro;
- promoção exibida no PDV.

## Estado funcional aprovado

### Devolução

- busca da venda por documento/cupom;
- devolução total ou parcial;
- controle de quantidade disponível;
- retorno ao estoque local;
- geração de Vale-Troca;
- sincronização com o Central;
- materialização real da devolução no Central;
- idempotência de retry.

### Cashback

- configuração Central → Hub;
- geração local;
- uso local seguro apenas sobre saldo sob controle do próprio Hub;
- saldo da retaguarda separado e informativo;
- limite percentual;
- valor mínimo;
- não gera troco;
- sincronização com o Central;
- não gera recebível financeiro indevido.

### Vale-Troca

- geração pela devolução;
- uso total ou parcial;
- documento obrigatório;
- reconciliação Hub ↔ Central pelo mesmo documento;
- proteção contra consumo offline de saldo remoto não garantido;
- sincronização e idempotência.

### Promoções

- sincronização Central → Hub;
- escopos TODOS, PRODUTO, COLECAO, GRUPO e SUBGRUPO;
- vigência e prioridade;
- recálculo ao alterar quantidade;
- snapshot da promoção aplicado na venda;
- respeito a `acumula_cashback`.

## Próximo trabalho

**Atualização e versionamento do Sysvar Hub.**

Objetivos previstos:

- definir versão do Hub;
- definir versão compatível do frontend local;
- definir estratégia de atualização;
- preservar configuração local;
- preservar banco/dados locais;
- preservar filas e eventos pendentes;
- validar compatibilidade Central ↔ Hub;
- impedir atualização incompatível ou que deixe a operação local inconsistente.

## Ordem adotada daqui para frente

1. Atualização e versionamento;
2. Backup e restauração;
3. TEF / Pinpad;
4. Homologação completa do Sysvar Hub.

TEF / Pinpad foi deliberadamente adiado e **não é o próximo item**.

## Regra para retomada

Ao continuar o trabalho, começar por:

**Atualização e versionamento do Sysvar Hub**, consultando primeiro o código atual dos repositórios do Hub e reaproveitando qualquer estrutura de instalação, serviço, empacotamento ou versionamento já existente antes de criar algo novo.

Não reabrir Devolução, Cashback, Vale-Troca, Promoções ou NFC-e sem erro concreto observado ou durante a homologação final integrada.
