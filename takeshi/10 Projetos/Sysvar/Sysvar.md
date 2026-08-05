---
type: project
status: active
project: Sysvar
source: "C:/SysvarProjeto"
created: 2026-08-03
updated: 2026-08-05
tags:
  - projeto
  - sysvar
  - homologado
  - operacional
  - auditoria
---

# Sysvar

## O que é

O Sysvar é um ERP SaaS para o varejo e a indústria de moda, desenvolvido com backend Django REST Framework, frontend Angular 17 e banco de dados MySQL.

O sistema foi concebido para atender empresas com uma ou múltiplas lojas, estoque central, produção própria, facções, distribuição, compras, vendas, financeiro, fiscal, contabilidade, auditoria e BI.

---

# Objetivo

Centralizar toda a operação da empresa em uma única plataforma, mantendo:

- isolamento entre empresas;
- controle por estabelecimentos;
- segurança baseada em perfis e permissões;
- auditoria completa;
- arquitetura preparada para crescimento modular.

---

# Áreas principais

- Operacional
  - Empresas
  - Contratos
  - Estabelecimentos
  - Usuários
  - Perfis
  - Permissões
  - Auditoria

- Cadastros

- Produtos

- Compras

- Fiscal

- Estoque

- Distribuição

- Produção

- Vendas / PDV

- Financeiro

- Relatórios

- Dashboards

---

# Fonte do projeto

Código-fonte

`C:\SysvarProjeto`

Backend

`C:\SysvarProjeto\Backend`

Frontend

`C:\SysvarProjeto\Frontend\sysvar`

Documentação

`C:\SysvarProjeto\docs`

Vault Obsidian

`C:\takeshi\takeshi`

---

# Situação Atual

## Infraestrutura

Status:

✅ Implementada

Inclui:

- autenticação;
- isolamento multiempresa;
- isolamento por estabelecimento;
- contratos;
- módulos contratados;
- usuário master;
- perfis;
- permissões efetivas;
- overrides;
- heartbeat;
- tokens;
- sessões;
- timeout;
- device_id;
- Auditoria Central.

---

## Licenciamento

Status:

✅ Homologado manualmente

O SISVAR utiliza exclusivamente:

**Sessões simultâneas**

Não utiliza quantidade de usuários cadastrados.

Regras homologadas:

- criar usuário não consome licença;
- ativar usuário não consome licença;
- login consome licença;
- logout libera licença;
- timeout libera licença;
- encerramento manual libera licença;
- suspensão da empresa libera todas as vagas;
- superusuário da plataforma não consome licença de nenhuma empresa;
- usuários diferentes podem utilizar o mesmo dispositivo;
- o mesmo usuário no mesmo dispositivo substitui apenas sua própria sessão.

---

## Auditoria Central

Status:

✅ Implementada

✅ Testada

✅ Homologada

A Auditoria registra eventos relacionados a:

- autenticação;
- logout;
- sessões;
- contratos;
- usuários;
- permissões;
- estabelecimentos;
- perfis;
- módulos;
- bloqueios;
- suspensão;
- reativação;
- administração de sessões.

Todos os eventos críticos utilizam Auditoria obrigatória.

---

## Grupo Operacional

Status:

✅ Concluído

Itens homologados:

- Empresas;
- Contratos;
- Suspensão;
- Reativação;
- Estabelecimentos;
- Usuários;
- Perfis;
- Permissões;
- Overrides;
- Sessões;
- Administração de sessões;
- Licenciamento;
- Auditoria.

---

## Administração de Sessões

Status:

✅ Implementada

É possível:

- visualizar sessões por empresa;
- visualizar sessões por usuário;
- identificar navegador;
- identificar dispositivo;
- identificar sistema operacional;
- visualizar IP;
- visualizar última atividade;
- visualizar status;
- encerrar sessão individual;
- encerrar todas as sessões.

O contador de sessões e a listagem utilizam a mesma regra central de validação.

---

## Homologações Manuais

Concluídas:

- isolamento entre empresas;
- contratos;
- módulos;
- licenciamento;
- login;
- logout;
- bloqueio por limite;
- liberação de vaga;
- contador de sessões;
- administração de sessões;
- superusuário sem consumo de licença;
- Auditoria Central.

---

# Próxima Etapa

Próximo grupo da barra lateral:

**Cadastros**

A revisão seguirá exatamente o processo utilizado no grupo Operacional:

1. análise funcional;
2. revisão arquitetural;
3. revisão backend;
4. revisão frontend;
5. revisão de layout;
6. revisão de permissões;
7. revisão de auditoria;
8. implementação;
9. testes automatizados;
10. homologação manual;
11. atualização do Obsidian.

---

# Repositórios

Backend

FernandoMurashima/sysvarbackend

Frontend

FernandoMurashima/sysvarfrontend

Vault

FernandoMurashima/sysvar-vault

---

# Notas relacionadas

- [[10 Projetos/Sysvar/Contexto do Projeto/Visão Geral|Visão Geral]]
- [[10 Projetos/Sysvar/Contexto do Projeto/Arquitetura|Arquitetura]]
- [[10 Projetos/Sysvar/Contexto do Projeto/Modelo de Domínio|Modelo de Domínio]]
- [[10 Projetos/Sysvar/Contexto do Projeto/Workflows|Workflows]]
- [[10 Projetos/Sysvar/Contexto do Projeto/Mapa Técnico|Mapa Técnico]]
- [[10 Projetos/Sysvar/Contexto do Projeto/Riscos e Cuidados|Riscos e Cuidados]]
- [[10 Projetos/Sysvar/Decisões Técnicas/ADR-001 - Licenciamento por Sessões Simultâneas|ADR-001 - Licenciamento por Sessões Simultâneas]]
- [[10 Projetos/Sysvar/Decisões Técnicas/ADR-002 - Princípios Arquiteturais do SISVAR|ADR-002 - Princípios Arquiteturais do SISVAR]]
- [[10 Projetos/Sysvar/Decisões Técnicas/ADR-003 - Auditoria Central do SISVAR|ADR-003 - Auditoria Central do SISVAR]]