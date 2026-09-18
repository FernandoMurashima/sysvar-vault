---
type: reference
status: active
project: Sysvar
source: "FernandoMurashima/sysvarbackend@ba024a85797f08d3378174ae95e37e9a1a7cc381"
created: 2026-09-18
updated: 2026-09-18
tags:
  - sysvar
  - sysvar-hub
  - sincronizacao
  - vendas
  - caixa
  - offline
---

# Mapa Técnico - Sysvar Hub - Sincronização Hub para Central

## Objetivo

Documentar a recepção, no Sysvar Central, das operações geradas localmente pelo [[Sysvar Hub]].

Este fluxo é a direção:

~~~text
Sysvar Hub
→ Internet/API
→ Sysvar Central
~~~

## Endpoint

~~~text
POST /api/hub/sync/push/
Authorization: Hub <TOKEN>
~~~

O contrato atual usa `versao = 1`.

Uma chamada aceita no máximo 50 eventos.

## Envelope de evento

Cada evento deve possuir:

- `evento_uuid`;
- `chave_idempotencia`;
- `tipo`;
- `payload`.

O payload precisa ser objeto JSON.

## Tipos suportados

A versão atual suporta:

~~~text
CLIENTE_LOCAL
VENDA_FINALIZADA
MOVIMENTO_CAIXA
SESSAO_CAIXA_FECHADA
FECHAMENTO_DIA
~~~

## HubEventoRecebido

Cada evento recebido é registrado com:

- Hub;
- UUID do evento;
- chave de idempotência;
- tipo;
- hash do payload;
- payload;
- status;
- mensagem de erro;
- datas de recebimento/processamento.

Estados operacionais:

~~~text
RECEBIDO
PROCESSADO
DUPLICADO
ERRO
CONFLITO
~~~

## Cliente local

Evento `CLIENTE_LOCAL` permite reconciliar cliente criado no Hub com o cadastro central.

Mapeamento:

~~~text
HubClienteMapeamento
Hub + cliente_uuid local
→ Cliente central
~~~

A reconciliação pode usar:

1. mapeamento já existente;
2. `retaguarda_id` válido da mesma Empresa;
3. documento normalizado na mesma Empresa;
4. criação de novo Cliente central quando necessário.

## Venda finalizada

Evento `VENDA_FINALIZADA` materializa uma `VendaPdv` no Sysvar Central.

Mapeamento:

~~~text
HubVendaMapeamento
Hub + venda_uuid local
→ VendaPdv central
~~~

A venda é associada à Empresa e Loja do Hub autenticado.

O processamento valida entidades referenciadas contra esse escopo.

São reaproveitados serviços já existentes do `VendaPdvViewSet` para registrar:

- itens;
- pagamentos;
- financeiro;
- CMV;
- impostos da venda;
- comissão.

O Hub não escolhe outra Empresa/Loja no payload.

## Produto e SKU

A venda valida `produto_retaguarda_id` e `sku_retaguarda_id` dentro da Empresa do Hub.

Quando EAN é informado, ele precisa corresponder ao SKU central indicado.

## Caixa

O caixa informado precisa:

- existir;
- pertencer à Empresa do Hub;
- pertencer à Loja do Hub;
- estar ativo;
- ser caixa de Loja.

## Movimento de caixa

Evento `MOVIMENTO_CAIXA` cria/atualiza `HubMovimentoCaixaRecebido` de forma rastreável.

Pode registrar:

- tipo;
- caixa;
- operador;
- terminal;
- valor;
- histórico;
- documento;
- tipo de despesa;
- data/hora;
- snapshot do payload.

## Sessão de caixa fechada

Evento `SESSAO_CAIXA_FECHADA` registra `HubSessaoCaixaRecebida` com a fotografia da sessão local encerrada.

Dados incluem, quando enviados:

- caixa;
- operador;
- terminal;
- abertura;
- fechamento;
- valor de abertura;
- esperado;
- contado;
- diferença;
- situação;
- observação.

## Fechamento do dia

Evento `FECHAMENTO_DIA` registra `HubFechamentoDiaRecebido`.

A data operacional é obrigatória e precisa ser válida.

O registro preserva:

- total do sistema;
- total conferido;
- diferença;
- situação;
- formas de pagamento;
- terminal;
- operador;
- snapshot.

## Escopo multi-tenant

Todos os eventos são processados a partir de:

~~~text
request.sysvar_hub
→ Loja
→ Empresa
~~~

O payload não pode deslocar a operação para outra Empresa ou Loja.

## Mapeamentos e reenvio

UUIDs locais permanecem como identidade de sincronização.

O Central mantém mapeamentos para devolver ao Hub os identificadores centrais quando aplicável e impedir criação duplicada.

## Transação

O processamento de cada evento utiliza transações atômicas.

Falha funcional no payload não deve deixar uma venda, cliente ou movimento parcialmente gravado como sucesso.

## Limites atuais

O endpoint recebe eventos e os processa de forma síncrona nesta versão.

Não documentar como existente uma fila assíncrona/Celery no Central para esse endpoint sem nova implementação.

## Commit de referência

- `ba024a85797f08d3378174ae95e37e9a1a7cc381` — `feat: recebe operações sincronizadas do Sysvar Hub`.

Correção subsequente:

- `d8a4597bc478b594040a27a0f0fa4c574c6c289c` — `fix: corrige retry da sincronizacao do Hub`.

## Relacionados

- [[Sysvar Hub]]
- [[Mapa Técnico - Sysvar Hub - Vendedores]]
- [[Mapa Técnico - Sysvar Hub - Tipos de Despesa PDV]]
- [[Riscos e Cuidados - Sysvar Hub - Idempotência e Retry]]
