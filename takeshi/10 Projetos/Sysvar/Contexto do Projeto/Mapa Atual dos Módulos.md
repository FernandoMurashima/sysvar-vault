---
type: technical-map
status: active
project: Sysvar
source: "FernandoMurashima/sysvarbackend + FernandoMurashima/sysvarfrontend + FernandoMurashima/sysvarhub-backend + FernandoMurashima/sysvarhub-frontend"
created: 2026-09-30
updated: 2026-09-30
tags:
  - sysvar
  - arquitetura
  - modulos
  - estado-atual
---

# Mapa Atual dos Módulos

Este documento registra a divisão técnica vigente do Sysvar em 30/09/2026. A organização visual do menu não define, por si só, a divisão dos apps backend.

## Repositórios ativos

- Central Backend: `FernandoMurashima/sysvarbackend`
- Central Frontend: `FernandoMurashima/sysvarfrontend`
- Hub Backend: `FernandoMurashima/sysvarhub-backend`
- Hub Frontend: `FernandoMurashima/sysvarhub-frontend`
- documentação: `FernandoMurashima/sysvar-vault`

## Plataforma e SaaS

Autoridade principal: `accounts/` e estruturas corporativas de `cadastros/`. Inclui autenticação, sessões, perfis, permissões, Empresa, Loja, contratos, licenciamento e isolamento multiempresa.

## Cadastros

Autoridade principal: `cadastros/`. Inclui Clientes, Fornecedores, Funcionários, Lojas, Cargos, Centros de Custo, Naturezas de Lançamento e Plano Contábil, além das estruturas corporativas.

## Produtos

Autoridade principal: `produto/`. Inclui Produto Venda, Uso/Consumo, Insumos, SKUs, EAN, grades, tamanhos, cores, coleções, materiais, packs, preços, promoções, imagens e Produto × Fornecedor.

## Estoque

Não existe app backend independente `estoque`. A autoridade técnica atual está em `produto/`, com rotas para estoque, movimentações, inventário e estoques/movimentações de Uso/Consumo.

Ver [[Estado Atual - Produção e Estoque]].

## Compras

Autoridade principal: `compras/`, com integração fiscal de entrada em `fiscal/`. Inclui Requisições, Cotação, Pedido de Compra, Ordem de Serviço, necessidades de compra, recebimento físico e integração com Entrada de NF-e.

## Produção

Não existe app backend independente `producao`. A autoridade técnica atual está em `produto/`, por meio de Ficha Técnica, itens de ficha, Ordem de Produção, itens/grade e vínculos de facção. As rotas ficam sob `/api/produto/`.

Ver [[Estado Atual - Produção e Estoque]].

## Distribuição

Autoridade principal: `distribuicao/`. Expõe perfis de distribuição, itens de perfil, distribuições, pedidos de venda e trânsitos.

Ver [[Estado Atual - Distribuição]].

## Financeiro

Autoridade principal: `financeiro/`. Abrange Formas e Prazos de Pagamento, Adquirentes, Configuração Financeira, Tipos de Despesa PDV, Caixa, Contas Bancárias, Movimentações, Lançamentos Contábeis, Pagar, Receber, antecipações, Cashback e Vale-Troca.

Ver [[Estado Atual - Financeiro]].

## Fiscal

Autoridade principal: `fiscal/`. Abrange CFOP, tributos, regras tributárias, Entrada de NF-e, recebimentos fiscais, NF-e de saída, Venda PDV canônica, Devolução, NFC-e e NF-e de devolução.

Ver [[Estado Atual - Fiscal e Vendas]].

## Vendas / PDV

Na Central, Venda/PDV canônica pertence ao domínio `fiscal/`, com `VendaPdv`, itens, pagamentos, devoluções e documentos fiscais. Na loja, a operação ocorre no Sysvar Hub e é sincronizada com a Central.

Regra conceitual:

```text
Hub = operação local da loja
Central fiscal = registro canônico consolidado de venda e fiscal
```

Ver [[Estado Atual - Fiscal e Vendas]] e [[Estado Atual - Sysvar Hub]].

## Sysvar Hub

Na Central, `hub/` responde por ativação, bootstrap, catálogo, administração, sincronização e APIs online usadas pela loja. Na loja, `sysvarhub-backend` e `sysvarhub-frontend` executam a operação local.

Ver [[Estado Atual - Sysvar Hub]].

## Auditoria

Autoridade principal: `auditoria/`. Centraliza contexto, middleware, sanitização, serviços, sinais e consulta dos registros de auditoria.

## Dashboard

Autoridade principal: `dashboard/` e frontend correspondente. O Dashboard agrega dados; não é fonte de verdade paralela aos módulos operacionais.

## Local Agent

Autoridade principal: `local_agent/` dentro do Central Backend. O componente possui README técnico próprio e documentação específica no vault.

## Regra de autoridade

Quando item de menu e app backend tiverem nomes diferentes, seguir o código real:

```text
Menu Produção → backend produto/
Menu Estoque  → backend produto/
Menu Vendas   → backend fiscal/ + Hub operacional
```

Este mapa deve ser atualizado quando mudar app responsável, repositório, fronteira Central/Hub, rota-base ou autoridade dos dados.