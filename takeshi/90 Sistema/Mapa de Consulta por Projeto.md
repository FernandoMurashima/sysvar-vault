---
type: system
status: active
project: ""
source: ""
created: 2026-08-16
updated: 2026-09-30
tags:
  - sistema
  - ia
  - projetos
  - contexto
---

# Mapa de Consulta por Projeto

## Objetivo

Este documento localiza as fontes oficiais necessárias antes de iniciar ou retomar trabalho em cada projeto.

A ordem geral é:

1. [[Contexto para Agentes]]
2. [[Mapa do Cofre]]
3. [[Protocolo de Trabalho com IA]]
4. este mapa
5. nota principal do projeto
6. documentação específica
7. código atual
8. commits relevantes, quando necessário
9. runbooks, quando houver operação ou produção

---

# Projeto — Sysvar

## Documentação central

Repositório:

`FernandoMurashima/sysvar-vault`

Branch:

`main`

Caminho local do cofre:

`C:\takeshi\takeshi`

Pasta do projeto:

`10 Projetos/Sysvar`

Nota principal:

[[Sysvar]]

## Repositórios ativos

### Central Backend

- repositório: `FernandoMurashima/sysvarbackend`
- branch: `main`
- caminho local: `C:\SysvarProjeto\Backend`

### Central Frontend

- repositório: `FernandoMurashima/sysvarfrontend`
- branch: `main`
- caminho local: `C:\SysvarProjeto\Frontend\sysvar`

### Hub Backend

- repositório: `FernandoMurashima/sysvarhub-backend`
- branch: `main`
- caminho local de desenvolvimento: `C:\SysvarHub\Backend`

### Hub Frontend

- repositório: `FernandoMurashima/sysvarhub-frontend`
- branch: `main`
- caminho local de desenvolvimento: `C:\SysvarHub\Frontend`

## Regra de consulta por escopo

### Central

Consultar Central Backend e Central Frontend quando a tarefa envolver:

- retaguarda administrativa;
- cadastros mestres;
- compras;
- estoque corporativo;
- financeiro;
- fiscal;
- produção;
- distribuição;
- administração de lojas, caixas, usuários, Hub e terminais.

### Hub

Consultar Hub Backend e Hub Frontend, além da Central relacionada, quando a tarefa envolver:

- operação da loja;
- PDV;
- caixa local;
- operador;
- pareamento de terminal;
- sincronização Central ↔ Hub;
- contingência;
- venda local;
- consulta de vendas;
- devolução/troca;
- vale-troca;
- emissão fiscal disparada pela operação local.

O Sysvar Hub não é um projeto separado do Sysvar. É a camada operacional local da loja e possui repositórios próprios.

## Documentos do projeto

A documentação funcional e arquitetural do Sysvar fica no `sysvar-vault`, principalmente em:

- `Contexto do Projeto`;
- `Decisões Técnicas`;
- `Homologações`;
- `Operacao`;
- `Sysvar.md`;
- `Planejamento.md`;
- `Pendências e Melhorias.md`.

Os diretórios `docs` dos repositórios de código devem guardar documentação estritamente ligada à implementação daquele repositório, quando isso facilitar manutenção junto do código.

Não duplicar no README ou em `docs` a documentação central completa do projeto.

## Ordem recomendada para uma tarefa Sysvar

1. abrir [[Sysvar]];
2. localizar a documentação específica do módulo;
3. identificar quais dos quatro repositórios participam do fluxo;
4. consultar o código atual em `main`;
5. consultar commits recentes quando houver mudança em andamento;
6. analisar divergências entre documentação e implementação;
7. somente depois propor ou executar alteração.

## Integrações entre módulos

Quando uma mudança atravessar módulos, consultar também as dependências relacionadas.

Exemplos:

- Compras pode envolver Produtos, Estoque, Financeiro, Fiscal e Auditoria.
- Vendas pode envolver Produtos, Estoque, Financeiro, Fiscal, Clientes e Hub.
- Produção pode envolver Produtos, Insumos, Ficha Técnica, Estoque e Distribuição.
- Hub pode envolver Vendas, Financeiro, Fiscal, Clientes, Usuários, Caixa e Sincronização.

A relação definitiva deve ser confirmada pelo código e pela documentação atuais.

---

# Projeto — Webfoto

Pasta principal:

`10 Projetos/Webfoto`

Nota principal:

[[Webfoto]]

Antes de alterações:

1. abrir [[Webfoto]];
2. consultar o contexto técnico do projeto;
3. localizar documentação específica;
4. identificar repositórios e caminhos vigentes registrados no projeto;
5. consultar o código atual;
6. verificar o ambiente envolvido.

Não presumir que infraestrutura ou caminhos de conversas antigas continuam atuais.

---

# Inclusão ou mudança de projeto

Quando houver novo projeto ativo ou mudança confirmada de repositório, branch, caminho, servidor, domínio ou documentação de entrada, atualizar este mapa.

Não manter informação obsoleta como referência principal.

---

# Regra final

```text
LOCALIZAR
→ CONSULTAR
→ CONFIRMAR O ESTADO ATUAL
→ TRABALHAR
```

O usuário não deve precisar reconstruir manualmente caminhos e fontes já registrados aqui.

## Documentos relacionados

- [[Contexto para Agentes]]
- [[Mapa do Cofre]]
- [[Protocolo de Trabalho com IA]]
- [[Convenções]]
- [[Hierarquia de Fontes e Decisoes]]
- [[Fluxo de Desenvolvimento e Homologacao]]
- [[Padrao de Prompts para Codex]]
