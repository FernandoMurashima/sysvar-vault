---
type: technical-map
status: active
project: Sysvar
source: "FernandoMurashima/sysvarbackend/cadastros + FernandoMurashima/sysvarfrontend"
created: 2026-09-30
updated: 2026-09-30
tags:
  - sysvar
  - cadastros
  - estado-atual
---

# Estado Atual - Cadastros

## Data de referência

30/09/2026.

## Autoridade técnica

Backend Central: `sysvarbackend/cadastros/`.

Frontend: features de Cadastros no `sysvarfrontend`.

## Rotas principais vigentes

- `empresas`;
- `lojas`;
- `cargos`;
- `clientes`;
- `fornecedores`;
- `funcionarios`;
- `nat_lancamento`;
- `plano-contabil`.

O domínio também participa de estruturas corporativas usadas por outros módulos, especialmente Empresa e Loja.

## Documentação granular

O vault já possui mapas técnicos, modelos de domínio, workflows, riscos e homologações para vários cadastros, incluindo Clientes, Fornecedores, Funcionários, Lojas e Plano Contábil.

Esses documentos permanecem como referência específica. Esta nota existe para registrar a fronteira técnica atual e evitar duplicação dos documentos granulares.

## Integrações

Cadastros é dependência transversal de Produtos, Compras, Financeiro, Fiscal, Distribuição, Hub e Auditoria.

## Regra documental

Quando existir documentação específica do cadastro, consultá-la antes desta nota. Confirmar sempre o estado final no código atual quando a nota específica for histórica ou anterior à implementação vigente.