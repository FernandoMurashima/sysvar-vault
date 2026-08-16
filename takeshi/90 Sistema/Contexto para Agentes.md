---
type: system
status: active
project: ""
source: ""
created: 2026-08-16
updated: 2026-08-16
tags:
  - sistema
  - ia
  - projetos
  - contexto
---

# Mapa de Consulta por Projeto

## 1. Objetivo

Este documento define como localizar o contexto necessário antes de iniciar ou retomar trabalho em cada projeto.

Ele funciona como ponte entre:

- protocolo geral de trabalho;
- documentação específica;
- repositórios de código;
- ambientes;
- procedimentos operacionais.

O objetivo é impedir que uma nova conversa dependa da memória do chat ou de o usuário repetir onde estão os arquivos.

---

# 2. Regra obrigatória

Antes de trabalhar em um projeto existente:

1. localizar o projeto neste mapa;
2. consultar sua documentação de entrada;
3. consultar os documentos específicos da tarefa;
4. consultar os repositórios relacionados;
5. identificar o estado atual;
6. somente depois analisar, propor ou implementar.

O usuário não precisa repetir esses caminhos a cada retomada.

---

# 3. Ordem geral de consulta

Para qualquer projeto:

1. [[Contexto para Agentes]]
2. [[Mapa do Cofre]]
3. [[Protocolo de Trabalho com IA]]
4. este mapa;
5. nota principal do projeto;
6. contexto técnico do projeto;
7. documentação específica do módulo;
8. código atual;
9. commits relevantes, quando necessário;
10. runbooks, quando a tarefa envolver operação ou produção.

---

# 4. Informações que cada projeto deve possuir

Cada projeto ativo deve ter neste documento, quando aplicável:

- nome;
- pasta no Obsidian;
- nota principal;
- contexto do projeto;
- repositório ou repositórios;
- branch principal;
- caminho local;
- documentação central;
- ambientes;
- runbooks;
- dependências importantes;
- ordem recomendada de leitura.

---

# 5. Projeto — Sysvar

## Localização no Obsidian

Pasta principal:

`10 Projetos/Sysvar`

Nota principal:

[[Sysvar]]

Antes de trabalhar em qualquer módulo do Sysvar, consultar também a documentação correspondente dentro da pasta do projeto.

---

## Repositórios

### Backend

Repositório:

`FernandoMurashima/sysvarbackend`

Branch principal:

`main`

Caminho local:

`C:\SysvarProjeto\Backend`

---

### Frontend

Repositório:

`FernandoMurashima/sysvarfrontend`

Branch principal:

`main`

Caminho local:

`C:\SysvarProjeto\Frontend\sysvar`

---

### Documentação

Repositório:

`FernandoMurashima/sysvar-vault`

Branch principal:

`main`

Caminho local do cofre:

`C:\takeshi\takeshi`

Documentação do projeto:

`10 Projetos/Sysvar`

---

## Documentos centrais do Sysvar

Quando aplicáveis à tarefa, consultar:

- Visão Geral;
- Arquitetura;
- Mapa Técnico;
- Modelo de Domínio;
- Workflows;
- Riscos e Cuidados;
- homologações;
- documentação específica do módulo;
- runbooks operacionais.

Não é necessário abrir todos os documentos em toda tarefa.

Consultar somente os relevantes ao escopo.

---

## Consulta de código

Antes de propor alteração em funcionalidade já existente:

1. identificar backend envolvido;
2. identificar frontend envolvido;
3. localizar integrações;
4. verificar testes existentes;
5. verificar migrations quando relevantes;
6. verificar código atualmente em `main`.

Não trabalhar apenas com descrição histórica da funcionalidade.

---

## Integrações entre módulos

Quando uma alteração atravessar módulos, consultar também os módulos relacionados.

Exemplos:

Compras pode envolver:

- Produtos;
- Financeiro;
- Fiscal;
- Estoque;
- Auditoria.

Vendas pode envolver:

- Produtos;
- Estoque;
- Financeiro;
- Fiscal;
- Clientes.

Produção pode envolver:

- Produtos;
- Insumos;
- Ficha Técnica;
- Estoque;
- Distribuição.

Esses exemplos servem para orientar investigação.

A relação definitiva deve ser confirmada pela documentação e pelo código atuais.

---

## Ambiente de produção

Antes de executar procedimento de produção:

1. localizar o runbook vigente;
2. seguir exatamente o procedimento documentado;
3. validar cada etapa;
4. não improvisar comandos de deploy quando já existir runbook.

Documentos operacionais ficam dentro da estrutura do projeto.

---

## Ordem recomendada para retomada do Sysvar

1. [[Protocolo de Trabalho com IA]]
2. [[Sysvar]]
3. documentação central necessária;
4. documentação do módulo;
5. código backend/frontend relacionado;
6. commits recentes relevantes;
7. somente depois iniciar análise.

---

# 6. Projeto — Webfoto

## Localização no Obsidian

Pasta principal:

`10 Projetos/Webfoto`

Nota principal:

[[Webfoto]]

Consultar o contexto técnico existente dentro da pasta do projeto antes de alterações.

---

## Regra de retomada

Antes de trabalhar no Webfoto:

1. abrir [[Webfoto]];
2. consultar o contexto do projeto;
3. localizar documentação específica da funcionalidade;
4. identificar os repositórios e caminhos vigentes registrados no projeto;
5. consultar código atual;
6. verificar ambiente envolvido;
7. somente depois propor alteração.

Não presumir que informações de infraestrutura ou código registradas em conversas antigas continuam atuais.

---

# 7. Inclusão de novo projeto

Quando um novo projeto se tornar ativo:

1. criar sua estrutura em `10 Projetos`;
2. criar nota principal;
3. criar contexto do projeto;
4. registrar repositórios;
5. registrar caminhos locais;
6. registrar ambientes;
7. registrar documentação central;
8. adicionar entrada neste mapa.

A entrada deve ser suficiente para que uma nova conversa consiga localizar o contexto sem depender do usuário.

---

# 8. Mudança de repositório ou caminho

Quando houver mudança de:

- repositório;
- branch;
- pasta local;
- servidor;
- domínio;
- processo de deploy;
- documentação de entrada;

atualizar este mapa depois que a mudança estiver confirmada.

Não manter caminhos obsoletos como referência principal.

---

# 9. Projetos encerrados

Quando um projeto for arquivado:

1. atualizar seu status;
2. mover documentação conforme [[Convenções]];
3. retirar da lista de projetos ativos deste mapa;
4. preservar informações necessárias para recuperação histórica.

---

# 10. Consulta mínima versus consulta ampla

Não é necessário ler toda a documentação de um projeto a cada tarefa.

Usar o princípio:

CONTEXTO GERAL
→ DOCUMENTAÇÃO ESPECÍFICA
→ CÓDIGO ESPECÍFICO

Evitar leitura ampla sem necessidade.

---

# 11. Quando consultar outro projeto

Não misturar contexto de projetos diferentes automaticamente.

Consultar outro projeto somente quando:

- houver integração;
- houver componente compartilhado;
- houver infraestrutura comum;
- houver padrão explicitamente reutilizado.

---

# 12. Responsabilidade do ChatGPT

Ao retomar um projeto, o ChatGPT deve usar este mapa automaticamente.

Não esperar o usuário dizer:

- onde está o backend;
- onde está o frontend;
- onde está o vault;
- qual documentação consultar;
- qual é a branch;
- que deve verificar o código atual.

Quando a informação estiver registrada aqui, ela deve ser reutilizada.

---

# 13. Responsabilidade de atualização

Quando durante o trabalho for identificado que este mapa contém informação:

- ausente;
- incorreta;
- antiga;

corrigir depois que a nova informação estiver confirmada.

Não alterar com base em hipótese.

---

# 14. Documentos relacionados

- [[Protocolo de Trabalho com IA]]
- [[Padrao de Prompts para Codex]]
- [[Hierarquia de Fontes e Decisoes]]
- [[Fluxo de Desenvolvimento e Homologacao]]
- [[Contexto para Agentes]]
- [[Mapa do Cofre]]
- [[Convenções]]

---

# 15. Regra final

Ao iniciar ou retomar um projeto:

LOCALIZAR
→ CONSULTAR
→ CONFIRMAR ESTADO ATUAL
→ TRABALHAR

Nunca depender de o usuário reconstruir manualmente o contexto já documentado.