---
type: project
status: active
project: Sysvar
source: "C:/SysvarProjeto"
created: 2026-08-03
updated: 2026-08-04
tags:
  - projeto
  - sysvar
---

# Sysvar

## O que é

O Sysvar é um ERP para o varejo de moda desenvolvido em Django REST Framework, Angular 17 e MySQL.

O sistema foi concebido para operar em ambiente SaaS, suportando múltiplas empresas, múltiplas lojas por empresa, módulos contratáveis, controle de acesso por perfis e licenciamento por sessões simultâneas.

Seu desenvolvimento segue arquitetura modular, permitindo evolução contínua sem comprometer os módulos já consolidados.

---

# Objetivos do projeto

O objetivo do Sysvar é fornecer uma plataforma única para administrar todas as operações de uma empresa do ramo de moda, contemplando desde o cadastro de produtos até o controle financeiro, fiscal, produção, distribuição, vendas e indicadores gerenciais.

O projeto prioriza:

- simplicidade operacional;
- segurança;
- isolamento entre empresas;
- escalabilidade;
- padronização de interface;
- auditoria completa das operações;
- documentação técnica continuamente atualizada.

---

# Áreas principais

O sistema atualmente contempla os seguintes grandes módulos:

- Administração
- Empresas
- Lojas
- Usuários
- Perfis e Permissões
- Cadastros Gerais
- Produtos
- Compras
- Fiscal
- Estoque
- Produção
- Distribuição
- PDV
- Vendas
- Financeiro
- Contabilidade
- Dashboards
- Auditoria

---

# Arquitetura funcional

A arquitetura do Sysvar está baseada em quatro pilares principais:

## Segurança

Controle por:

- empresa;
- contrato;
- módulos contratados;
- perfis;
- permissões efetivas;
- sessões simultâneas.

## Multiempresa

Cada empresa possui isolamento completo de seus dados.

Nenhum usuário pode visualizar informações pertencentes a outra empresa, independentemente de manipulação de URL, parâmetros ou chamadas diretas à API.

## Modularização

Cada funcionalidade pertence a um módulo funcional independente.

Os módulos contratados determinam automaticamente quais menus, telas, rotas e endpoints estarão disponíveis para aquela empresa.

## Escalabilidade

Toda a arquitetura foi concebida para permitir crescimento contínuo do sistema sem necessidade de grandes refatorações estruturais.

---

# Situação atual

## Concluído

- Autenticação multiempresa.
- Isolamento completo entre empresas.
- Contratos por empresa.
- Controle de módulos contratados.
- Usuário Master.
- Perfis de acesso.
- Permissões efetivas.
- Licenciamento por sessões simultâneas.
- Controle de acesso do frontend baseado nas permissões efetivas.
- Bloqueio automático de módulos não contratados.
- Validação centralizada de autenticação.

## Validado

Os seguintes cenários já foram testados com sucesso:

- isolamento entre empresas;
- criação de empresa;
- criação do usuário master;
- criação de usuários;
- perfis;
- permissões;
- login;
- logout;
- sessões simultâneas;
- bloqueio por limite de licenças;
- reutilização da mesma sessão no mesmo dispositivo;
- liberação automática da licença ao encerrar a sessão.

---

# Modelo de licenciamento

O Sysvar utiliza licenciamento por sessões simultâneas.

As licenças NÃO são consumidas pela quantidade de usuários cadastrados.

Uma empresa pode possuir qualquer quantidade de usuários.

O consumo ocorre somente quando existe uma sessão ativa.

Regras atuais:

- criar usuário não consome licença;
- ativar usuário não consome licença;
- login cria uma sessão;
- logout libera imediatamente a licença;
- timeout libera a licença;
- inativação do usuário encerra suas sessões;
- novo login no mesmo dispositivo reutiliza a sessão existente;
- login acima do limite contratado é bloqueado.

---

# Próximas etapas

As próximas implementações previstas são:

1. Auditoria central.
2. Entrada de Nota Fiscal.
3. Produção.
4. Distribuição.
5. PDV Offline.
6. Dashboards gerenciais.
7. Relatórios.
8. Otimizações de performance.
9. Revisão geral dos módulos.

---

# Fonte do projeto

Código-fonte:

- `C:\SysvarProjeto`

Backend:

- `C:\SysvarProjeto\Backend`

Frontend:

- `C:\SysvarProjeto\Frontend\sysvar`

Documentação existente:

- `C:\SysvarProjeto\docs`

Vault Obsidian:

- `C:\takeshi\takeshi`

---

# Notas relacionadas

- [[10 Projetos/Sysvar/Contexto do Projeto/Visão Geral|Visão Geral]]
- [[10 Projetos/Sysvar/Contexto do Projeto/Arquitetura|Arquitetura]]
- [[10 Projetos/Sysvar/Contexto do Projeto/Modelo de Domínio|Modelo de Domínio]]
- [[10 Projetos/Sysvar/Contexto do Projeto/Workflows|Workflows]]
- [[10 Projetos/Sysvar/Contexto do Projeto/Mapa Técnico|Mapa Técnico]]
- [[10 Projetos/Sysvar/Contexto do Projeto/Riscos e Cuidados|Riscos e Cuidados]]
- [[10 Projetos/Sysvar/Decisões Técnicas/ADR-001 - Licenciamento por Sessões Simultâneas|ADR-001 - Licenciamento por Sessões Simultâneas]]