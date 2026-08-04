---
type: project
status: active
project: Sysvar
source: "C:/SysvarProjeto"
created: 2026-08-03
updated: 2026-08-03
tags:
  - projeto
  - sysvar
---

# Sysvar

## O que é

O Sysvar é um sistema ERP/varejo composto por backend Django REST Framework, frontend Angular 17 e banco MySQL.

## Áreas principais

- Administração, usuários, empresas, lojas e permissões.
- Cadastros gerais.
- Produtos, SKUs, grades, cores, coleções, packs e tabela de preço.
- Compras, fiscal, estoque, produção e distribuição.
- PDV, vendas, devoluções, cashback e vale-troca.
- Financeiro, contas, caixas, movimentações, lançamentos contábeis e DRE.
- Dashboards e auditoria.

## Fonte do projeto

- Código-fonte: `C:\SysvarProjeto`
- Backend: `C:\SysvarProjeto\Backend`
- Frontend: `C:\SysvarProjeto\Frontend\sysvar`
- Documentação existente: `C:\SysvarProjeto\docs`

## Situação atual

- Autenticação multiempresa: implementada e em validação.
- Isolamento entre empresas: validado manualmente.
- Contratos e módulos contratados: implementados.
- Perfis e permissões: implementados e em validação.
- Licenciamento por usuário cadastrado: descartado.
- Licenciamento por sessões simultâneas: em implementação.
- Auditoria central: próxima etapa.

## Notas relacionadas

- [[10 Projetos/Sysvar/Contexto do Projeto/Visão Geral|Visão Geral]]
- [[10 Projetos/Sysvar/Contexto do Projeto/Arquitetura|Arquitetura]]
- [[10 Projetos/Sysvar/Contexto do Projeto/Modelo de Domínio|Modelo de Domínio]]
- [[10 Projetos/Sysvar/Contexto do Projeto/Workflows|Workflows]]
- [[10 Projetos/Sysvar/Contexto do Projeto/Mapa Técnico|Mapa Técnico]]
- [[10 Projetos/Sysvar/Contexto do Projeto/Riscos e Cuidados|Riscos e Cuidados]]
- [[10 Projetos/Sysvar/Decisões Técnicas/ADR-001 - Licenciamento por Sessões Simultâneas|ADR-001 - Licenciamento por Sessões Simultâneas]]

