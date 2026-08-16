---
type: system
status: active
project: ""
source: ""
created: 2026-07-29
updated: 2026-08-16
tags:
  - sistema
  - mapa
---

# Mapa do Cofre

Este cofre é o segundo cérebro de projetos e código em `C:\takeshi\takeshi`.

## Estrutura

- `00 Inbox`: capturas novas, materiais ainda não processados e notas temporárias.
- `10 Projetos`: projetos ativos com entregáveis claros, decisões, runbooks e logs.
- `20 Areas`: responsabilidades contínuas sem fim definido.
- `30 Recursos`: referências, estudos, conceitos, exemplos e documentação reaproveitável.
- `40 Arquivo`: materiais encerrados, fontes originais e histórico.
- `90 Sistema`: convenções, mapas, protocolos, templates e instruções para agentes.

---

# Ordem de entrada para agentes

Ao iniciar ou retomar trabalho no cofre:

1. [[Contexto para Agentes]]
2. [[Mapa do Cofre]]
3. [[Protocolo de Trabalho com IA]]
4. [[Mapa de Consulta por Projeto]] quando houver projeto envolvido
5. [[Convenções]] quando houver criação ou alteração de documentação
6. documentação específica do projeto ou módulo
7. código atual relacionado

Quando houver conflito entre informações, consultar:

[[Hierarquia de Fontes e Decisoes]]

Quando houver desenvolvimento, correção ou homologação, consultar:

[[Fluxo de Desenvolvimento e Homologacao]]

Antes de gerar prompt para Codex, consultar:

[[Padrao de Prompts para Codex]]

---

# Projetos ativos

- [[Webfoto]]
- [[Sysvar]]

Os caminhos, repositórios e referências de entrada dos projetos devem ser consultados em:

[[Mapa de Consulta por Projeto]]

---

# Notas de sistema

## Contexto e navegação

- [[Contexto para Agentes]]
- [[Mapa do Cofre]]
- [[Mapa de Consulta por Projeto]]

## Governança de trabalho com IA

- [[Protocolo de Trabalho com IA]]
- [[Padrao de Prompts para Codex]]
- [[Hierarquia de Fontes e Decisoes]]
- [[Fluxo de Desenvolvimento e Homologacao]]

## Organização do cofre

- [[Convenções]]
- [[Fila de Ingestão]]

---

# Função de 90 Sistema

A pasta `90 Sistema` contém as regras de funcionamento do próprio cofre.

Ela deve concentrar:

- mapas;
- convenções;
- protocolos;
- instruções para agentes;
- padrões de trabalho;
- templates;
- mecanismos de continuidade entre projetos e conversas.

Documentação funcional específica de um projeto não deve ser armazenada aqui.

Ela deve permanecer em `10 Projetos`.

---

# Relação entre sistema e projetos

Os documentos de `90 Sistema` definem como o trabalho deve ser realizado.

Os documentos de `10 Projetos` definem o contexto, regras, arquitetura, decisões e operação de cada projeto.

Assim:

`90 Sistema`
→ define COMO trabalhar

`10 Projetos`
→ define EM QUE estamos trabalhando

---

# Regra de continuidade

Uma nova conversa ou agente não deve depender de reconstrução manual do contexto pelo usuário.

A sequência esperada é:

MAPA DO COFRE  
→ PROTOCOLO  
→ MAPA DO PROJETO  
→ DOCUMENTAÇÃO ESPECÍFICA  
→ CÓDIGO ATUAL

O objetivo é permitir continuidade de trabalho a partir do próprio cofre.

---

# Atualização deste mapa

Este documento deve ser atualizado quando houver:

- nova pasta estrutural;
- novo projeto ativo;
- novo documento central de sistema;
- mudança relevante na organização do cofre;
- novo protocolo obrigatório.

Não é necessário atualizar este mapa para cada documento comum criado dentro de um projeto.