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
  - contexto
  - continuidade
---

# Contexto para Agentes

## Objetivo

Este documento é a porta de entrada mínima para qualquer agente ou nova conversa que trabalhe com os projetos do cofre.

A conversa não é a memória oficial. O contexto deve ser reconstruído a partir da documentação e do código vigentes.

## Ordem obrigatória de entrada

1. [[Contexto para Agentes]]
2. [[Mapa do Cofre]]
3. [[Protocolo de Trabalho com IA]]
4. [[Mapa de Consulta por Projeto]]
5. [[Convenções]] quando houver criação ou alteração documental
6. nota principal do projeto
7. documentação específica da tarefa
8. código atual relacionado
9. commits relevantes, quando necessário
10. runbooks, quando houver operação ou produção

## Regras de trabalho

- Não depender da memória de chats anteriores como fonte oficial.
- Não pedir ao usuário caminhos, repositórios ou documentos que já estejam registrados no cofre.
- Não assumir que documentação histórica ainda representa o código atual.
- Quando documentação e código divergirem, aplicar [[Hierarquia de Fontes e Decisoes]].
- Antes de alterar documentação, ler o conteúdo vigente e consultar [[Convenções]].
- Antes de desenvolvimento ou homologação, consultar [[Fluxo de Desenvolvimento e Homologacao]].
- Antes de gerar instruções para Codex, consultar [[Padrao de Prompts para Codex]].
- Segredos, senhas, tokens e chaves não devem ser copiados para notas.

## Fonte oficial por tipo de informação

- Regras e contexto do projeto: documentação vigente no `sysvar-vault`.
- Implementação efetiva: código atual dos repositórios envolvidos.
- Operação e produção: runbooks vigentes do projeto.
- Decisões técnicas permanentes: notas de decisão do projeto.
- Histórico: checkpoints, commits e materiais arquivados.

## Sysvar

Entrada principal:

- [[Sysvar]]
- [[Mapa de Consulta por Projeto]]

Repositórios ativos do produto:

- `FernandoMurashima/sysvarbackend`
- `FernandoMurashima/sysvarfrontend`
- `FernandoMurashima/sysvarhub-backend`
- `FernandoMurashima/sysvarhub-frontend`

Documentação central:

- `FernandoMurashima/sysvar-vault`
- pasta `10 Projetos/Sysvar`

O Hub faz parte do projeto Sysvar e deve ser considerado quando a tarefa envolver loja, PDV, operação local, sincronização, pareamento, caixa, vendas, devoluções, vale-troca ou contingência.

## Regra de continuidade

Uma retomada correta deve seguir:

```text
LOCALIZAR O PROJETO
→ LER O CONTEXTO VIGENTE
→ LER A DOCUMENTAÇÃO ESPECÍFICA
→ CONFERIR O CÓDIGO ATUAL
→ IDENTIFICAR O ESTADO REAL
→ TRABALHAR
```

O objetivo é permitir que uma nova conversa continue o trabalho sem exigir que o usuário reconstrua manualmente o contexto já documentado.

## Documentos relacionados

- [[Mapa do Cofre]]
- [[Protocolo de Trabalho com IA]]
- [[Mapa de Consulta por Projeto]]
- [[Convenções]]
- [[Hierarquia de Fontes e Decisoes]]
- [[Fluxo de Desenvolvimento e Homologacao]]
- [[Padrao de Prompts para Codex]]
