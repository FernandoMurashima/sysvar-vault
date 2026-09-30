---
type: reference
status: active
project: Sysvar
source: "FernandoMurashima/sysvar-vault + FernandoMurashima/sysvarbackend + FernandoMurashima/sysvarfrontend + FernandoMurashima/sysvarhub-backend + FernandoMurashima/sysvarhub-frontend"
created: 2026-09-30
updated: 2026-09-30
tags:
  - sysvar
  - documentacao
  - auditoria
  - governanca
---

# Diagnóstico da Documentação — 2026-09-30

## Objetivo

Registrar a revisão estrutural da documentação vigente do Projeto Sysvar e definir a separação oficial entre documentação central do projeto e documentação acoplada aos repositórios de código.

Esta revisão é independente do planejamento de padronização de numeração dos documentos comerciais.

---

# Fontes revisadas

- `FernandoMurashima/sysvar-vault`
- `FernandoMurashima/sysvarbackend`
- `FernandoMurashima/sysvarfrontend`
- `FernandoMurashima/sysvarhub-backend`
- `FernandoMurashima/sysvarhub-frontend`
- READMEs dos repositórios
- diretórios `docs` existentes
- estrutura `90 Sistema`
- documentação principal em `10 Projetos/Sysvar`
- commits recentes dos quatro repositórios ativos do Sysvar

---

# Diagnóstico geral

A documentação do Sysvar já possui uma base organizada no `sysvar-vault`, com convenções, protocolo de trabalho, mapa do cofre, contexto do projeto, decisões, homologações e operação.

O principal problema encontrado não é ausência total de documentação, mas **defasagem e dispersão** entre:

- documentação central no vault;
- READMEs antigos dos repositórios;
- documentos técnicos em `docs`;
- checkpoints históricos;
- código atual que evoluiu mais rápido que algumas notas centrais.

Também foi encontrada uma duplicação estrutural real em `90 Sistema`: `Contexto para Agentes.md` e `Mapa de Consulta por Projeto.md` possuíam exatamente o mesmo conteúdo e o mesmo blob, inclusive com o título `Mapa de Consulta por Projeto` dentro dos dois arquivos.

Essa duplicação foi corrigida em 2026-09-30.

---

# Situação por repositório

## Central Backend — `sysvarbackend`

### Antes da revisão

O `README.md` descrevia genericamente um ERP em inglês e listava apenas alguns módulos antigos. Não representava o papel atual da Central nem sua integração com o Hub.

O diretório `docs` continha documentação técnica específica, atualmente incluindo:

- `fiscal-devolucao-entrada.md`
- `vale-troca-online.md`

### Decisão

- README deve ser curto e técnico.
- Regras funcionais transversais e arquitetura do produto não devem ser duplicadas nele.
- `docs/` pode manter documentos fortemente acoplados ao código do backend.
- Documentação oficial do projeto permanece no `sysvar-vault`.

O README foi atualizado em 2026-09-30.

---

## Central Frontend — `sysvarfrontend`

### Antes da revisão

O `README.md` também era genérico, em inglês, e não representava a estrutura real do frontend atual nem a separação Central × Hub.

### Decisão

- README curto, técnico e específico do repositório.
- Registrar que a aplicação Angular está em `sysvar/`.
- Não duplicar regras funcionais ou arquitetura transversal.
- Referenciar o `sysvar-vault` como documentação central.

O README foi atualizado em 2026-09-30.

---

## Hub Backend — `sysvarhub-backend`

### Antes da revisão

O repositório possuía `docs/`, mas não possuía `README.md` na raiz.

Documentos técnicos existentes incluem:

- `devolucao-troca-online.md`
- `vale-troca-online.md`

### Decisão

Foi criado um README técnico explicando:

- papel do Hub;
- fronteira Central × Hub × Terminais;
- componentes principais;
- integração;
- local da documentação oficial.

`docs/` continua reservado a documentação técnica diretamente ligada à implementação local.

---

## Hub Frontend — `sysvarhub-frontend`

### Antes da revisão

O README era mais recente que os READMEs da Central, mas ainda continha linguagem de etapa inicial tratando módulos como preparados para evolução futura, enquanto o código atual já possui evolução funcional posterior, incluindo operação de devolução/troca e vale-troca.

### Decisão

O README foi atualizado para representar o Hub como aplicação operacional da loja e separar claramente:

- Operador;
- Terminal;
- Caixa;
- PDV;
- Backend Hub;
- comunicação com a Central.

---

# Situação do `sysvar-vault`

## Estrutura válida

A organização principal continua válida:

- `90 Sistema` — regras de funcionamento do cofre e trabalho com IA;
- `10 Projetos/Sysvar` — contexto, decisões, homologações, operação e acompanhamento do Sysvar.

As convenções YAML continuam sendo o padrão para novas notas.

## Problemas encontrados

### 1. Duplicação em `90 Sistema`

`Contexto para Agentes.md` era cópia de `Mapa de Consulta por Projeto.md`.

Correção aplicada:

- `Contexto para Agentes.md` agora é a porta de entrada mínima para agentes;
- `Mapa de Consulta por Projeto.md` agora é o mapa efetivo de projetos e repositórios.

### 2. Mapa de repositórios incompleto

O mapa registrava apenas Central Backend e Central Frontend como repositórios do Sysvar.

Correção aplicada:

Foram incluídos:

- `FernandoMurashima/sysvarhub-backend`
- `FernandoMurashima/sysvarhub-frontend`

### 3. Documentação do Hub defasada por evolução rápida

A nota `Contexto do Projeto/Sysvar Hub.md` possui grande quantidade de contexto histórico válido, mas vários trechos datados de 11 a 20 de setembro descrevem etapas como futuras ou iniciais que já evoluíram no código até 30 de setembro.

Ela não deve ser apagada, pois contém decisões e histórico importantes.

Regra daqui para frente:

- seções explicitamente datadas continuam como histórico;
- estado atual deve ser mantido em seção claramente identificada;
- novos documentos específicos devem ser criados somente quando houver um assunto estável que mereça nota própria;
- não transformar checkpoints antigos em falsa descrição do estado atual.

### 4. `Sysvar.md` é amplo e não deve virar log diário

A nota principal deve continuar como visão geral do produto e ponto de navegação.

Mudanças operacionais diárias e detalhes de implementação não devem ser despejados nela.

### 5. `Planejamento.md` e `Pendências e Melhorias.md` precisam permanecer distintos

- `Planejamento.md`: etapas planejadas e direção de trabalho.
- `Pendências e Melhorias.md`: somente itens que exigem ação real.

Não usar nenhum dos dois como histórico completo de commits.

---

# Estrutura oficial daqui para frente

## `sysvar-vault`

Deve concentrar:

- visão geral do produto;
- arquitetura transversal;
- contexto dos módulos;
- decisões técnicas duradouras;
- regras funcionais aprovadas;
- mapas técnicos reutilizáveis;
- riscos e cuidados;
- homologações;
- planejamento;
- pendências reais;
- runbooks de operação;
- checkpoints quando necessários para continuidade.

## Repositórios de código

Devem concentrar:

### README

- finalidade do repositório;
- stack;
- estrutura básica;
- comandos de entrada relevantes;
- fronteiras arquiteturais essenciais;
- link/referência para documentação central.

### `docs/`

Somente documentação que faça sentido versionada junto do código, por exemplo:

- contrato técnico de uma integração específica;
- decisão de implementação estritamente local;
- comportamento técnico necessário para manter aquele repositório;
- procedimento técnico diretamente ligado àquela aplicação.

Não copiar para `docs/` documentos centrais inteiros do vault.

---

# Regra de autoridade documental

Quando houver conflito:

1. decisão nova explicitamente aprovada;
2. documentação vigente e não histórica;
3. código vigente;
4. histórico e checkpoints;
5. inferência.

Se uma nota antiga contradizer claramente o código atual e estiver escrita como estado presente, ela deve ser revisada.

Se estiver explicitamente datada como histórico, pode permanecer.

---

# Padrão para manutenção futura

Ao concluir uma funcionalidade relevante:

1. identificar documentos realmente afetados;
2. consultar o código final em `main`;
3. atualizar somente a documentação necessária;
4. atualizar `updated` no YAML das notas modificadas;
5. evitar duplicação entre vault, README e `docs`;
6. manter README curto;
7. preservar histórico quando ele estiver claramente marcado como histórico;
8. registrar decisões duradouras no vault, não apenas em commits.

---

# Resultado desta revisão

Alterações aplicadas em 2026-09-30:

- corrigido `90 Sistema/Contexto para Agentes.md`;
- atualizado `90 Sistema/Mapa de Consulta por Projeto.md`;
- atualizado README do Central Backend;
- atualizado README do Central Frontend;
- criado README do Hub Backend;
- atualizado README do Hub Frontend;
- criado este diagnóstico oficial de documentação.

A revisão funcional detalhada de notas antigas deve sempre comparar cada nota com o código do módulo correspondente antes de reescrever conteúdo histórico.
