---
type: checkpoint
status: active
project: Sysvar
created: 2026-09-20
updated: 2026-09-20
tags:
  - sysvar
  - hub
  - pdv
  - checkpoint
  - retomada
---

# Checkpoint — Sysvar Hub

## Onde paramos

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
