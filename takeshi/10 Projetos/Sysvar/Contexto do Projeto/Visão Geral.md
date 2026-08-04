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
  - negocio
---

# Visão Geral

## Negócio

O Sysvar é um ERP de varejo/moda com foco em operação multiempresa e multilojas. Ele cobre cadastros, produtos, compras, fiscal, estoque, produção, distribuição, PDV, financeiro, auditoria e dashboards.

## Usuários

- Administrador: configura empresas, lojas, usuários, permissões e parâmetros.
- Operador de loja/caixa: usa PDV, recebimento, devoluções e rotinas locais.
- Comprador/estoquista: atua em compras, entrada fiscal, estoque, inventário e movimentações.
- Produção/distribuição: gerencia ficha técnica, ordens, perfis, distribuição e trânsito.
- Financeiro/contábil: gerencia pagar, receber, caixas, bancos, movimentações, lançamentos e DRE.
- Gestor: acompanha dashboards e relatórios.

## Capacidades atuais

- Backend Django 4.2 + DRF com apps por domínio técnico.
- Frontend Angular 17 com rotas por feature e shell autenticado.
- Banco MySQL.
- Documentação existente em `docs` com levantamento, arquitetura, backend, fluxos, entidades e processos.
- Controle de acesso por usuário, tipo, módulo, empresa/loja e permissões por campo.

## Fonte do projeto

- Código: `C:\SysvarProjeto`
- Levantamento base: `docs\levantamento`
- Arquitetura modular: `docs\arquitetura`
- Documentação backend: `docs\backend`

## Última atualização

2026-08-03

## Limitações do contexto

Este pacote resume inventário estático e documentação existente. O projeto é grande; antes de implementar feature, abrir os arquivos do domínio afetado.
