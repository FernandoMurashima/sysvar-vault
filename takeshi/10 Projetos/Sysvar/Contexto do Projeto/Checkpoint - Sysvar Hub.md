---
type: checkpoint
status: active
project: Sysvar
created: 2026-09-20
updated: 2026-10-07
tags:
  - sysvar
  - hub
  - pdv
  - checkpoint
  - retomada
---

# Checkpoint — Sysvar Hub

## Checkpoint atual — 07/10/2026

A retomada deve começar pelo desenvolvimento das **Formas de Pagamento e Prazos de Pagamento no Sysvar Hub**, exatamente no ponto em que a regra funcional ainda não foi fechada.

### Ambiente DEV reconstruído e validado

A reconstrução limpa do ambiente DEV foi concluída.

Estado confirmado:

- Base DEV da Central recriada fisicamente e reconstruída com migrations + `sysvar_dev_base --rebuild`;
- Base DEV terminou como **VÁLIDA**;
- `sysvarhub_db` recriado do zero e migrations aplicadas;
- Central DEV em execução;
- Hub DEV em execução a partir de `C:\SysvarHub`;
- Sysvar Local Agent reinstalado e ativado apontando para `http://localhost:8001`;
- pasta `C:\SysvarXML` cadastrada e ativa;
- serviço `SysvarLocalAgent` validado com heartbeat;
- Hub da Loja Barra ativado e sincronizado;
- terminal `PDV-01` configurado;
- terminal pareado.

O procedimento corrigido está em [[Procedimento de instalação limpa do Sysvar]].

### Correções importantes consolidadas no runbook

- Hub DEV e Hub instalado são ambientes distintos e não devem ser misturados;
- não desinstalar o Hub instalado nem remover `C:\SysvarHub` durante a rotina DEV;
- o banco `varejo_db` deve ser recriado fisicamente antes das migrations;
- depois das migrations, usar `sysvar_dev_base --rebuild`, não `--create`;
- o `config.json` do Local Agent DEV deve existir antes do instalador e apontar para `http://localhost:8001`.

### Estado atual de Formas de Pagamento e Prazos

A separação estrutural entre **Forma de Pagamento** e **Prazo de Pagamento** já foi implementada.

Na Base DEV atual, a forma comercial de crédito é única:

- `CRE` — Cartão de crédito;
- tipo técnico `CREDITO`;
- sem prazo fixo vinculado à Forma de Pagamento.

Os prazos são sincronizados separadamente para o Hub.

No Hub, uma venda em crédito exige um prazo selecionado e o backend já consegue transportar o prazo e suas parcelas.

### Teste realizado em 07/10/2026

Foi concluída com sucesso uma venda de **R$ 279,90** no Hub usando **Cartão de Crédito**.

Resultado:

- venda finalizada;
- NFC-e de homologação gerada;
- pagamento identificado como Cartão de Crédito;
- integração fiscal do tipo `CREDITO` funcionando.

Este teste **não homologa ainda a regra financeira de prazo/parcelamento**.

### Pendência funcional que deve ser resolvida antes de continuar a homologação

Ainda não está definida a regra de negócio que determina **quais Prazos de Pagamento podem ser usados por uma determinada Forma de Pagamento**, especialmente para Cartão de Crédito.

O frontend do Hub atualmente lista prazos ativos de forma ampla. Isso não representa uma regra funcional aprovada de compatibilidade entre forma e prazo.

Portanto, ao retomar:

1. analisar o modelo atual de Forma de Pagamento e Prazo na Central;
2. definir com o usuário como será configurada a compatibilidade entre forma e prazo;
3. somente depois ajustar Central/Hub conforme a decisão;
4. homologar crédito à vista e parcelado;
5. então validar geração de Receber, parcelas, vencimentos e valores.

Não usar a tela de Contas a Receber como prova de homologação dessa regra antes de a relação Forma × Prazo estar definida.

### Commits diretamente relacionados ao ponto de retomada

Central Backend:

`d88aaf61fa7565f6af05dfb024231f04d81794d6`

- Base DEV corrigida;
- forma única `CRE`;
- prazos separados no bootstrap.

Hub Backend:

`79f5f0959b2c0e3e1a8ce85f75d50d083e600aba`

- Prazo de Pagamento separado da Forma no Hub;
- prazo obrigatório para crédito;
- snapshots e sincronização de parcelas.

Hub Backend:

`6751acd76121f5a25deb539a93e8b8340fcfab7d`

- ajuste dos testes NFC-e para crédito com prazo.

Hub Frontend:

`831d73c7e854e3196983c7fb9196aff510b13a32`

- Cartão separado entre débito e crédito;
- seletor de prazo para crédito;
- envio do prazo ao backend.

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
