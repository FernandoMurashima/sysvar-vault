---
type: technical-map
status: active
project: Sysvar
source: "FernandoMurashima/sysvarbackend/fiscal + FernandoMurashima/sysvarbackend/hub + FernandoMurashima/sysvarhub-backend + FernandoMurashima/sysvarhub-frontend"
created: 2026-09-30
updated: 2026-09-30
tags:
  - sysvar
  - fiscal
  - vendas
  - pdv
  - estado-atual
---

# Estado Atual - Fiscal e Vendas

## Data de referência

30/09/2026.

## Autoridade técnica na Central

O domínio fiscal e o registro canônico de vendas PDV estão em:

`sysvarbackend/fiscal/`

O app está organizado em `models/`, `serializers/`, `services/` e `views/`.

## Fiscal

Rotas vigentes incluem:

- CFOP;
- Tributos;
- Regras Tributárias;
- configurações de XML de fornecedor;
- agentes locais;
- Notas de Entrada e itens;
- XMLs recebidos de fornecedor;
- Recebimentos de Mercadoria;
- Notas de Saída e itens;
- Vendas PDV;
- Devoluções de Venda;
- NFC-e.

A Entrada de NF-e integra Fiscal, Compras, Estoque e Financeiro.

## Venda PDV canônica

Entidades centrais vigentes:

- `VendaPdv`;
- `VendaPdvItem`;
- `VendaPdvPagamento`.

`VendaPdv` relaciona Empresa, Loja, Caixa, Cliente e Vendedor e mantém documento, status, valores e datas da venda.

Os itens guardam, além do produto/SKU e valores, dados de custo/CMV e dados tributários necessários ao registro fiscal.

## Devolução

Entidades centrais:

- `VendaDevolucao`;
- `VendaDevolucaoItem`;
- `NFeDevolucao`.

A devolução referencia a venda original e mantém crédito do cliente, itens devolvidos e documento próprio. O fluxo atual também possui NF-e de devolução com série, número, ambiente, status, chave, protocolo e XML.

A integração online de devolução do Hub utiliza endpoints autenticados do app Central `hub/` para localizar vendas/clientes e finalizar a operação na Central.

## NFC-e

`NFCe` pertence ao domínio fiscal Central e é vinculada à venda. Mantém Loja, ambiente, modelo 65, série, número, status, chave, protocolo, tipo de emissão, QR Code e XML, entre outros dados fiscais.

A numeração fiscal continua própria do documento fiscal e não deve ser confundida com documento comercial da venda.

## Hub e PDV da loja

O PDV operacional da loja está no Sysvar Hub:

- `sysvarhub-backend` executa persistência e serviços locais;
- `sysvarhub-frontend` fornece a aplicação operacional;
- `sysvarbackend/hub/` expõe as APIs Central ↔ Hub.

A venda pode nascer operacionalmente no Hub, mas a Central mantém o registro consolidado/canônico após sincronização.

## APIs Central ↔ Hub relacionadas

O app Central `hub/` possui, entre outras, APIs de:

- catálogo e imagens;
- clientes;
- devoluções online;
- formas de pagamento;
- Vale-Troca online;
- operadores;
- vendedores;
- sincronização e push;
- administração remota.

## Vale-Troca

A autoridade financeira do Vale-Troca oficial é a Central. No fluxo online, o Hub consulta, lista, reserva e consome por APIs autenticadas, sem transformar o espelho local em fonte de verdade do saldo oficial.

## Numeração comercial versus fiscal

Identificadores técnicos de Hub, UUIDs e chaves de sincronização não substituem documentos comerciais apresentados ao usuário.

NFC-e, NF-e de entrada, NF-e de saída e NF-e de devolução mantêm numerações fiscais próprias.

Mudanças planejadas para documentos comerciais que ainda não estejam implementadas em `main` devem permanecer registradas como planejamento, não como estado atual.

## Regra documental

Para Venda/PDV ou Fiscal, consultar em conjunto:

1. esta nota;
2. `fiscal/` na Central;
3. [[Estado Atual - Sysvar Hub]] quando houver loja/PDV;
4. `hub/` na Central para contrato de integração;
5. Financeiro e Estoque quando o fluxo gerar reflexos nesses domínios.
