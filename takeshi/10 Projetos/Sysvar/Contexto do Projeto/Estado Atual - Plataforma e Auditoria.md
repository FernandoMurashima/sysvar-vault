---
type: technical-map
status: active
project: Sysvar
source: "FernandoMurashima/sysvarbackend/accounts + FernandoMurashima/sysvarbackend/auditoria + FernandoMurashima/sysvarfrontend"
created: 2026-09-30
updated: 2026-09-30
tags:
  - sysvar
  - accounts
  - saas
  - auditoria
  - estado-atual
---

# Estado Atual - Plataforma e Auditoria

## Data de referência

30/09/2026.

# Plataforma, acesso e licenciamento

## Autoridade técnica

Backend Central: `sysvarbackend/accounts/`, complementado pelas entidades corporativas em `cadastros/`.

## Estruturas e rotas vigentes

O app `accounts` expõe:

- usuários;
- módulos do sistema;
- contratos de empresa;
- módulos por empresa;
- perfis de acesso;
- sessões de usuário;
- login por token;
- logout;
- alteração obrigatória de senha.

Essas estruturas sustentam autenticação, autorização, sessão, licenciamento e controle de acesso por empresa.

A arquitetura multiempresa documentada no vault continua sendo a referência transversal, sempre confirmada contra o código atual.

---

# Auditoria

## Autoridade técnica

Backend Central: `sysvarbackend/auditoria/`.

O app fornece endpoint de consulta de logs e mantém estruturas de contexto, middleware, serviços, sinais e sanitização para auditoria das operações.

Auditoria é transversal e não deve ser documentada como regra isolada de um único módulo.

## Regra de integração

Quando um módulo criar ou alterar operações auditáveis, preservar o padrão central de auditoria em vez de criar logging paralelo como substituto.

---

# Dashboard

O Dashboard é agregador de informações de outros domínios. Ele não deve se tornar autoridade alternativa para dados de Cadastros, Produtos, Compras, Financeiro, Fiscal, Estoque ou Distribuição.

---

# Regra documental

Para alterações de acesso, multiempresa, sessão ou permissão, consultar a documentação Multi-Empresa/SaaS e o código `accounts/` e `cadastros/`.

Para auditoria, consultar os documentos específicos já existentes e o código `auditoria/`.