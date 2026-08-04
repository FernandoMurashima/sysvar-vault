---
type: reference
status: active
project: Sysvar
source: "C:/SysvarProjeto"
created: 2026-08-03
updated: 2026-08-03
tags:
  - sysvar
  - contexto
  - arquitetura
---

# Arquitetura

## Visão C4 leve

- Sistema: ERP Sysvar para varejo/moda.
- Containers lógicos: frontend Angular, backend Django REST Framework, banco MySQL.
- Backend: apps Django em `Backend`, projeto principal em `Backend\Varejo`.
- Frontend: aplicação Angular em `Frontend\sysvar`.
- Documentação: `docs` contém mapas de levantamento, arquitetura e backend.

## Backend

Apps principais:

- `accounts`: autenticação, usuários, permissões por módulo/campo.
- `auditoria`: logs, middleware e signals de auditoria.
- `cadastros`: empresas, lojas, clientes, fornecedores, funcionários, natureza de lançamento e plano contábil.
- `produto`: produtos, SKUs, grades, materiais, estoque, inventário, ficha técnica, OP, promoções e packs.
- `compras`: pedidos, itens, entregas e parcelas.
- `fiscal`: CFOP, tributos, regras, NF-e, NFC-e, PDV e devoluções.
- `financeiro`: pagar, receber, caixas, bancos, movimentações, formas/prazos, cashback, vale-troca, contabilidade e antecipações.
- `distribuicao`: perfis, distribuições, pedidos, trânsito e recebimento.
- `dashboard`: indicadores executivos, produtos, vendas, estoque e financeiro.

## Frontend

- Rotas Angular em `Frontend\sysvar\src\app`.
- Features em `Frontend\sysvar\src\app\features`.
- Services de domínio em `Frontend\sysvar\src\app\core\services`.
- Layout shell e componentes compartilhados em `layout` e `shared`.

## Integrações internas

- Frontend chama a API Django por services Angular.
- DRF routers expõem módulos em `/api/<dominio>/`.
- Dashboard consome dados consolidados de vários apps.
- Fiscal, financeiro, estoque, produto e distribuição têm forte acoplamento funcional.

## Última atualização

2026-08-03

## Limitações do contexto

A arquitetura funcional proposta nos docs ainda não implica movimentação física de código. Respeitar o estado atual antes de refatorar módulos.
