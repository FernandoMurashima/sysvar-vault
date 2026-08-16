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
  - desenvolvimento
  - homologacao
---

# Fluxo de Desenvolvimento e Homologação

## 1. Objetivo

Este documento define o fluxo padrão de desenvolvimento, correção, revisão, homologação e documentação para projetos desenvolvidos com apoio de IA.

O objetivo é evitar:

- implementação antes da definição funcional;
- retrabalho;
- perda de contexto;
- alterações desnecessárias;
- regressões;
- homologações desorganizadas;
- documentação prematura;
- uso excessivo de recursos de IA.

---

# 2. Visão geral do fluxo

O fluxo padrão é:

ANALISAR  
→ DEFINIR  
→ FECHAR REGRAS  
→ IMPLEMENTAR  
→ REVISAR  
→ CORRIGIR  
→ HOMOLOGAR  
→ APROVAR  
→ DOCUMENTAR

Cada etapa possui uma finalidade específica.

Não pular etapas sem motivo.

---

# 3. Etapa 1 — Análise

Antes de propor qualquer solução relevante:

1. identificar o projeto;
2. consultar a documentação geral;
3. consultar a documentação específica;
4. consultar o código atual;
5. identificar integrações;
6. identificar estruturas existentes;
7. identificar o que já funciona;
8. identificar lacunas reais.

O objetivo desta etapa é entender o estado atual.

Não implementar ainda.

---

# 4. Etapa 2 — Definição funcional

Depois da análise, o ChatGPT deve apresentar recomendações objetivas.

Preferir uma lista fechada e numerada.

Cada item deve representar:

- regra;
- comportamento;
- decisão;
- exceção;
- integração;
- fluxo;
- padrão visual;

quando aplicável.

O usuário pode:

- aprovar;
- rejeitar;
- alterar;
- pedir explicação;
- acrescentar regra.

Depois de aprovado, o item deve ser considerado fechado.

---

# 5. Não reabrir decisões aprovadas

Uma decisão funcional aprovada não deve ser reaberta sem motivo concreto.

Motivos aceitáveis:

- defeito identificado;
- conflito com outra regra;
- nova dependência;
- novo requisito;
- risco relevante não considerado.

Não reabrir apenas porque existe outra solução possível.

---

# 6. Etapa 3 — Fechamento funcional

Antes de gerar prompt de implementação, revisar se ainda existe dúvida relevante.

Confirmar:

- objetivo;
- entradas;
- saídas;
- estados;
- validações;
- permissões;
- integrações;
- exceções;
- comportamento visual;
- critérios de aceite.

Somente depois disso preparar a implementação.

---

# 7. Etapa 4 — Preparação do prompt

O prompt para Codex deve seguir:

[[Padrao de Prompts para Codex]]

O prompt deve:

- mandar consultar documentação;
- mandar consultar código;
- mandar reaproveitar;
- fechar escopo;
- indicar o que não fazer;
- indicar validações;
- exigir commit;
- exigir push;
- exigir relatório final.

Não enviar prompt incompleto.

---

# 8. Etapa 5 — Implementação

O Codex deve implementar conforme o escopo aprovado.

A prioridade é:

REAPROVEITAR  
→ REFATORAR  
→ ESTENDER  
→ CRIAR

A implementação deve preservar:

- regras não alteradas;
- integrações;
- arquitetura;
- segurança;
- multiempresa, quando aplicável;
- padrões visuais;
- comportamento homologado.

---

# 9. Testes durante a implementação

Testes devem ser proporcionais ao escopo.

Para pequenas correções:

- testes direcionados;
- check;
- build relevante.

Para implementações maiores:

- testes do módulo;
- integração necessária;
- build;
- validações específicas.

Não executar suites enormes sem necessidade.

---

# 10. Etapa 6 — Relatório do Codex

Ao concluir, o Codex deve entregar um relatório único.

O relatório deve informar, conforme aplicável:

- resumo do que fez;
- documentação consultada;
- código reaproveitado;
- arquivos alterados;
- migrations;
- testes;
- builds;
- commits;
- push;
- pendências.

O relatório não encerra automaticamente a tarefa.

---

# 11. Etapa 7 — Revisão técnica pelo ChatGPT

Depois do relatório:

1. conferir o commit;
2. verificar os arquivos realmente alterados;
3. comparar com o prompt;
4. identificar escopo não atendido;
5. identificar alteração indevida;
6. verificar se backend e frontend ficaram coerentes;
7. verificar se houve regressão potencial.

Não confiar apenas no texto do relatório.

---

# 12. Resultado da revisão

A revisão pode produzir três situações:

## Situação A — Implementação correta

Seguir para homologação.

## Situação B — Implementação parcial

Criar correção específica para o que faltou.

## Situação C — Implementação incorreta

Corrigir somente os pontos objetivos identificados.

Evitar recomeçar o módulo inteiro sem necessidade.

---

# 13. Etapa 8 — Correções

Depois da implementação inicial, usar prompts menores.

Cada prompt de correção deve tratar preferencialmente:

- um problema;
- um grupo pequeno de problemas relacionados;
- uma área visual específica;
- uma validação específica;
- uma regressão localizada.

Não repetir o prompt original inteiro.

---

# 14. Correções visuais

Quando a funcionalidade estiver correta e o problema for apenas visual:

- não alterar regra de negócio;
- não alterar backend sem necessidade;
- usar screenshot do usuário;
- corrigir layout;
- preservar comportamento;
- validar build.

Tratar funcionalidade e design como problemas diferentes.

---

# 15. Etapa 9 — Homologação manual

Depois do fechamento técnico, realizar homologação manual quando a funcionalidade exigir.

O ChatGPT deve fornecer uma bateria objetiva.

A bateria deve validar o fluxo completo, evitando testes excessivamente fragmentados.

Exemplo:

- criação;
- edição;
- validação;
- mudança de status;
- integração;
- consulta;
- cancelamento;
- comportamento visual.

---

# 16. Homologação em bloco

Quando uma funcionalidade possuir vários cenários relacionados, preferir uma bateria completa em bloco.

Evitar:

teste 1  
→ parar  
→ teste 2  
→ parar  
→ teste 3

quando o usuário puder validar o conjunto de uma vez.

Isso reduz tempo e interrupções.

---

# 17. Registro dos resultados

Durante homologação:

- itens aprovados ficam fechados;
- problemas encontrados viram pendências;
- pendências devem ser tratadas separadamente;
- não repetir testes já aprovados sem necessidade.

---

# 18. Problema encontrado na homologação

Quando o usuário encontrar um problema:

1. registrar o comportamento observado;
2. analisar a causa;
3. consultar código quando necessário;
4. preparar correção pequena;
5. implementar;
6. validar;
7. repetir somente o teste afetado e, se necessário, os relacionados.

Não reiniciar toda a homologação sem motivo.

---

# 19. Etapa 10 — Aprovação

A funcionalidade é considerada aprovada quando o usuário declara aprovação após a homologação necessária.

Exemplos:

- aprovado;
- tudo ok;
- funcionalidade validada;
- pedido aprovado;
- módulo aprovado.

Após aprovação:

- considerar a funcionalidade fechada;
- não continuar sugerindo mudanças sem novo motivo;
- partir para documentação ou próximo escopo.

---

# 20. Etapa 11 — Documentação

A documentação definitiva deve acontecer depois da aprovação.

Atualizar:

- regra funcional;
- mapa técnico;
- workflow;
- modelo de domínio;
- riscos;
- runbooks;
- homologação;

conforme o projeto exigir.

Não documentar como concluída uma funcionalidade ainda em correção.

---

# 21. Atualização do repositório de documentação

Depois de cada documento criado ou atualizado, o ChatGPT deve fornecer automaticamente o comando PowerShell para atualizar o repositório do cofre.

Padrão:

~~~powershell
cd C:\takeshi\takeshi
git add .
git commit -m "Mensagem objetiva"
git push origin main
~~~

O usuário não deve precisar pedir esse comando.

---

# 22. Encerramento de um módulo

Um módulo pode ser considerado encerrado quando, conforme aplicável:

- regras fechadas;
- implementação concluída;
- testes concluídos;
- revisão técnica concluída;
- homologação concluída;
- aprovação registrada;
- documentação atualizada;
- repositórios atualizados.

---

# 23. Retomada futura

Quando o módulo for retomado no futuro:

1. consultar protocolo;
2. consultar documentação atual;
3. consultar código atual;
4. verificar homologações;
5. identificar novos requisitos;
6. preservar o que já foi aprovado.

Não recomeçar a análise como se o módulo fosse novo.

---

# 24. Fluxo resumido

## Desenvolvimento novo

ANÁLISE  
→ DEFINIÇÃO FUNCIONAL  
→ APROVAÇÃO DAS REGRAS  
→ PROMPT  
→ CODEX  
→ REVISÃO  
→ HOMOLOGAÇÃO  
→ APROVAÇÃO  
→ DOCUMENTAÇÃO

## Correção

PROBLEMA  
→ ANÁLISE  
→ PROMPT PEQUENO  
→ CORREÇÃO  
→ VALIDAÇÃO  
→ HOMOLOGAÇÃO DO PONTO AFETADO

## Ajuste visual

SCREENSHOT  
→ IDENTIFICAÇÃO DO PROBLEMA  
→ CORREÇÃO VISUAL  
→ BUILD  
→ HOMOLOGAÇÃO VISUAL

---

# 25. Regra de economia

Evitar:

- investigação ampla pelo Codex;
- prompts repetitivos;
- suites completas para pequenas mudanças;
- reanálise de regras fechadas;
- documentação antes da aprovação;
- homologação repetitiva.

Priorizar:

- análise prévia;
- prompts específicos;
- testes direcionados;
- correções pequenas;
- documentação consolidada ao final.

---

# 26. Responsabilidade de continuidade

O ChatGPT deve conduzir o fluxo.

O usuário não deve precisar lembrar:

- qual etapa vem depois;
- que é preciso consultar código;
- que é preciso revisar o commit;
- que é preciso homologar;
- que é preciso documentar;
- que é preciso atualizar o repositório.

Essas ações fazem parte deste fluxo.

---

# 27. Documentos relacionados

- [[Protocolo de Trabalho com IA]]
- [[Padrao de Prompts para Codex]]
- [[Hierarquia de Fontes e Decisoes]]
- [[Mapa de Consulta por Projeto]]
- [[Contexto para Agentes]]
- [[Mapa do Cofre]]
- [[Convenções]]

---

# 28. Regra final

O processo deve ser previsível.

Antes de implementar:

ENTENDER.

Antes de decidir:

CONSULTAR.

Depois de implementar:

REVISAR.

Antes de documentar:

HOMOLOGAR.

Depois de aprovar:

REGISTRAR.