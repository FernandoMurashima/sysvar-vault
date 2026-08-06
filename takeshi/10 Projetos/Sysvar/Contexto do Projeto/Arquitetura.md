---
type: reference
status: active
project: Sysvar
source: "C:/SysvarProjeto"
created: 2026-08-03
updated: 2026-08-06
tags:
  - sysvar
  - arquitetura
  - segurança
  - operacional
  - auditoria
  - multiempresa
  - homologado
---

# Arquitetura

## Objetivo

A arquitetura do SISVAR foi projetada para suportar um ERP SaaS voltado ao varejo e à indústria de moda.

Seus principais objetivos são:

- segurança;
- isolamento entre empresas;
- isolamento por estabelecimento;
- modularização;
- escalabilidade;
- rastreabilidade;
- integridade transacional;
- evolução contínua;
- compatibilidade com MySQL;
- manutenção simplificada.

Toda nova funcionalidade deve reutilizar as infraestruturas centrais já existentes.

---

# Princípios Arquiteturais

O SISVAR segue os seguintes princípios:

- backend como autoridade final;
- frontend como camada de apresentação;
- default deny;
- permissões efetivas;
- isolamento multiempresa obrigatório;
- isolamento por estabelecimento quando aplicável;
- módulos contratados;
- operações críticas transacionais;
- serviços centrais;
- auditoria centralizada;
- dados sensíveis protegidos;
- migrations obrigatórias;
- testes proporcionais ao risco;
- documentação versionada;
- decisões arquiteturais registradas por ADR.

Ocultar botão, menu, campo ou rota no frontend não substitui a validação no backend.

---

# Camadas Principais

A arquitetura é dividida em:

1. Frontend.
2. Backend.
3. Banco de dados.
4. Infraestruturas transversais.
5. Módulos de negócio.
6. Documentação.

---

# Frontend

Tecnologia principal:

```text
Angular 17 Standalone