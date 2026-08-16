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
  - codex
  - prompts
---

# Padrão de Prompts para Codex

## 1. Objetivo

Este documento define o padrão obrigatório para prompts enviados ao Codex ou a outro agente responsável por implementação de código.

O objetivo é:

- reduzir ambiguidades;
- evitar reconstruções desnecessárias;
- preservar funcionalidades existentes;
- orientar corretamente a consulta à documentação;
- reduzir consumo desnecessário de recursos;
- facilitar revisão;
- tornar a implementação previsível;
- garantir testes, commit e push;
- evitar que o usuário tenha que corrigir repetidamente o formato dos prompts.

Este padrão deve ser aplicado automaticamente pelo ChatGPT sempre que o usuário solicitar um prompt para implementação.

---

# 2. Formato obrigatório de entrega

Todo prompt destinado ao Codex deve ser entregue:

- inteiro;
- em um único bloco;
- com linguagem direta;
- pronto para copiar e colar;
- sem fragmentação;
- sem explicações extras depois do bloco.

O fence deve ser:

~~~text
conteúdo do prompt
~~~

Não utilizar:

- `id=`;
- metadata no fence;
- múltiplos blocos para um único prompt;
- JSON desnecessário;
- texto disperso antes e depois do prompt;
- partes do prompt fora do bloco.

O usuário não deve precisar reorganizar o conteúdo antes de enviar ao Codex.

---

# 3. Quando gerar um prompt

Não gerar prompt de implementação antes de fechar as regras necessárias.

Antes do prompt, devem estar definidos, conforme o caso:

- objetivo;
- comportamento esperado;
- regras de negócio;
- exceções importantes;
- integrações;
- estados;
- permissões;
- comportamento visual;
- critérios de aceite.

Quando ainda houver decisões funcionais relevantes abertas, continuar a discussão antes de enviar o Codex para implementação.

---

# 4. Consulta obrigatória antes da implementação

Todo prompt relevante deve instruir o Codex a consultar, antes de alterar arquivos:

1. documentação do projeto;
2. documentação específica do módulo;
3. código atual;
4. integrações relacionadas;
5. padrões arquiteturais;
6. padrões visuais, quando aplicável;
7. testes existentes;
8. histórico técnico necessário.

Não enviar Codex para desenvolver com base apenas na descrição atual se já houver implementação ou documentação relacionada.

---

# 5. Regra de reaproveitamento

Todo prompt deve deixar explícito que o Codex deve primeiro verificar o que já existe.

A sequência preferencial é:

REAPROVEITAR
→ REFATORAR
→ ESTENDER
→ CRIAR

Antes de criar:

- model;
- endpoint;
- serializer;
- service;
- componente;
- helper;
- tela;
- migration;
- teste;
- integração;

verificar estruturas existentes.

Não criar solução paralela quando a existente puder ser evoluída.

---

# 6. Regra contra construção do zero

Quando já existir código relacionado, o prompt deve dizer explicitamente:

- não construir do zero;
- estudar a implementação atual;
- preservar o que funciona;
- alterar apenas o necessário;
- reaproveitar lógica existente;
- eliminar duplicidade somente quando seguro.

Não usar instruções genéricas como:

"Crie o módulo X"

quando já houver implementação parcial ou equivalente.

Preferir:

"Analise e evolua a implementação atual do módulo X."

---

# 7. Hierarquia dentro do prompt

Sempre que houver possibilidade de divergência entre fontes, o prompt deve registrar a hierarquia:

1. decisão nova aprovada nesta tarefa;
2. documentação vigente;
3. código atual;
4. inferência técnica.

Tudo que não tiver sido redefinido deve ser preservado.

Se houver conflito não resolvível, o Codex não deve inventar regra de negócio.

---

# 8. Escopo fechado

Todo prompt deve deixar claro:

- o que deve ser feito;
- o que não deve ser feito;
- quais módulos podem ser alterados;
- quais módulos devem apenas ser consultados;
- quais funcionalidades devem ser preservadas.

Quando a tarefa for pequena, o escopo também deve ser pequeno.

Não transformar correção localizada em refatoração ampla.

---

# 9. Estrutura recomendada de um prompt de implementação

Quando a tarefa justificar um prompt completo, usar preferencialmente esta organização:

## 9.1 Identificação

Informar:

- tarefa;
- projeto;
- repositórios;
- branch;
- contexto relevante.

---

## 9.2 Estado atual

Registrar:

- o que já existe;
- o que já foi aprovado;
- commits relevantes, quando úteis;
- limitações conhecidas;
- comportamento que deve permanecer.

---

## 9.3 Protocolo obrigatório

Determinar:

- consulta à documentação;
- consulta ao código;
- reaproveitamento;
- não construção do zero;
- não invenção de regra;
- hierarquia das fontes.

---

## 9.4 Objetivo

Descrever claramente o resultado esperado.

Evitar objetivos vagos.

---

## 9.5 Regras funcionais

Enumerar somente as regras necessárias para a implementação.

Não repetir desnecessariamente toda a documentação do projeto.

---

## 9.6 Regras técnicas

Indicar, quando necessário:

- arquivos principais;
- models;
- endpoints;
- services;
- componentes;
- integrações;
- migrations;
- validações;
- permissões.

Essas referências devem orientar, não substituir a análise do código atual.

---

## 9.7 O que não fazer

Registrar explicitamente proibições relevantes.

Exemplos:

- não criar serviço paralelo;
- não duplicar endpoint;
- não alterar regra financeira;
- não modificar outro módulo;
- não redesenhar interface inteira;
- não remover código útil antes de reaproveitá-lo.

---

## 9.8 Validação

Informar quais validações devem ser executadas.

Exemplos:

Backend:

~~~text
python manage.py check
python manage.py test modulo
~~~

Frontend:

~~~text
npx.cmd tsc -p tsconfig.app.json --noEmit
npx.cmd ng build --configuration development
~~~

Usar apenas testes adequados ao escopo.

---

## 9.9 Commit e push

O prompt deve instruir automaticamente:

1. `git add`;
2. `git commit`;
3. `git push`.

Não depender de pedido separado do usuário.

Não fazer commit vazio.

---

## 9.10 Relatório final

Solicitar um único relatório final com:

- resumo;
- documentação consultada;
- código reaproveitado;
- arquivos alterados;
- migrations;
- testes;
- builds;
- commits;
- push;
- pendências reais.

---

# 10. Prompts de implementação inicial

Quando uma funcionalidade grande já estiver funcionalmente fechada, o prompt inicial pode ser abrangente.

Mesmo assim, deve:

- limitar o escopo;
- indicar integrações;
- evitar reescrever módulos inteiros;
- exigir reaproveitamento;
- ter critérios de aceite claros.

Prompts grandes são aceitáveis quando correspondem a uma implementação realmente ampla.

---

# 11. Prompts de correção

Depois da implementação inicial, preferir prompts pequenos.

Uma correção deve normalmente conter:

- problema observado;
- comportamento esperado;
- arquivos ou área relacionada;
- limites;
- validação específica;
- commit/push;
- relatório final.

Evitar repetir todo o módulo em cada correção.

A correção deve ser:

- localizada;
- verificável;
- econômica;
- objetiva.

---

# 12. Correções visuais

Quando o problema for visual:

- usar screenshots e descrição do usuário como referência;
- preservar regra de negócio;
- evitar alteração backend sem necessidade;
- indicar exatamente o que deve mudar;
- indicar exatamente o que deve permanecer.

Não transformar ajuste de layout em redesign funcional.

---

# 13. Testes proporcionais ao escopo

O prompt deve exigir testes compatíveis com o tamanho da alteração.

Pequena correção:

- teste direcionado;
- build relevante;
- check mínimo.

Marco importante de implementação:

- testes específicos do módulo;
- checks;
- build;
- integrações relevantes.

Evitar suites enormes sem necessidade.

---

# 14. Não aceitar ausência de testes por falta de estrutura anterior

Se uma regra importante precisa de teste e o módulo não possuir estrutura de testes:

- criar estrutura adequada;
- seguir o padrão dos outros módulos;
- não usar a ausência anterior como justificativa para não testar.

---

# 15. Não mascarar falhas

O prompt deve proibir:

- comentar teste para passar;
- reduzir assertiva importante;
- alterar regra aprovada para satisfazer teste;
- usar skip sem necessidade;
- ocultar pendência real.

Se o teste encontrar defeito real, corrigir o defeito.

---

# 16. Uso de documentação no prompt

O prompt deve indicar os documentos relevantes conhecidos.

Quando não souber exatamente quais documentos existem, instruir o Codex a:

1. consultar o mapa/contexto do projeto;
2. localizar documentação relacionada;
3. ler antes de implementar.

Não inventar nomes de documentos inexistentes.

---

# 17. Uso de commits anteriores

Quando a tarefa continuar implementação já realizada, registrar no prompt:

- commits relevantes;
- o que eles já implementaram;
- que não devem ser revertidos.

Isso reduz retrabalho e regressões.

---

# 18. Backend e frontend

Quando a tarefa envolver ambos, separar claramente:

## Backend

Definir:

- responsabilidades;
- validações definitivas;
- models/endpoints;
- testes.

## Frontend

Definir:

- apresentação;
- comportamento;
- consumo de API;
- validações de UX;
- build.

Não deixar regra crítica apenas no frontend quando precisa ser protegida pelo backend.

---

# 19. Fonte definitiva de regras críticas

Quando houver cálculos, permissões ou validações importantes:

- backend deve ser a fonte definitiva;
- frontend pode antecipar validação e apresentar preview;
- frontend não deve substituir proteção do backend.

---

# 20. Regra de não improvisação

Se o Codex encontrar uma dúvida:

1. consultar prompt;
2. consultar documentação;
3. consultar código;
4. consultar integração relacionada.

Se ainda houver dúvida de negócio:

- não inventar;
- preservar comportamento existente quando seguro;
- registrar no relatório final.

---

# 21. Mensagens intermediárias

Salvo necessidade explícita, o prompt deve determinar:

- não enviar mensagens intermediárias;
- concluir a execução;
- entregar relatório final único.

Isso reduz interrupções e consumo desnecessário.

---

# 22. Commit

A mensagem de commit deve ser:

- objetiva;
- relacionada à tarefa;
- sem texto genérico.

Exemplos:

~~~text
Unifica fluxo de Pedido de Compra
Corrige layout do Pedido de Compra
Adiciona testes do módulo financeiro
Ajusta validação de fornecedores
~~~

---

# 23. Push

Depois do commit:

~~~text
git push origin main
~~~

ou branch definida pela tarefa.

O relatório final deve confirmar o push.

---

# 24. Prompt padrão mínimo para correção

Para correções pequenas, usar como referência:

~~~text
TAREFA — [PROJETO / MÓDULO / CORREÇÃO]

Antes de alterar:
- consulte a documentação relacionada;
- consulte o código atual;
- reaproveite o que já existe;
- não construa do zero;
- não altere regra de negócio fora deste escopo.

PROBLEMA

[descrever objetivamente]

COMPORTAMENTO ESPERADO

[descrever resultado]

ESCOPO

[arquivos, telas, módulos ou regras afetadas]

NÃO FAZER

[limites]

VALIDAÇÃO

[comandos/testes]

COMMIT E PUSH

git add .
git commit -m "[mensagem]"
git push origin main

RELATÓRIO FINAL

Entregue somente um relatório final contendo:
- resumo;
- arquivos alterados;
- testes;
- commit SHA;
- push;
- pendências reais.
~~~

Esse modelo é referência, não obrigação de copiar texto desnecessário.

---

# 25. Prompt padrão para implementação maior

Implementações maiores devem conter, conforme aplicável:

- contexto;
- protocolo;
- estado atual;
- objetivo;
- regras;
- integrações;
- backend;
- frontend;
- visual;
- testes;
- critérios de aceite;
- commit/push;
- relatório final.

A extensão deve ser proporcional à complexidade.

---

# 26. Critério de qualidade do prompt

Antes de entregar um prompt ao usuário, o ChatGPT deve verificar:

- está em um único bloco `text`?
- está sem `id=`?
- está completo?
- está pronto para copiar?
- código e documentação devem ser consultados?
- reaproveitamento está explícito?
- escopo está fechado?
- o que não fazer está claro?
- validação está definida?
- commit e push estão incluídos?
- relatório final está definido?

Se algum desses pontos for necessário e estiver ausente, corrigir antes de entregar.

---

# 27. Regra final

O usuário não deve precisar lembrar ao ChatGPT:

- "manda em um bloco só";
- "não coloque id";
- "consulta a documentação";
- "consulta o código";
- "não faça do zero";
- "faz commit";
- "faz push";
- "pede relatório final".

Essas regras fazem parte deste padrão e devem ser aplicadas automaticamente.

---

# 28. Documentos relacionados

- [[Protocolo de Trabalho com IA]]
- [[Hierarquia de Fontes e Decisoes]]
- [[Fluxo de Desenvolvimento e Homologacao]]
- [[Mapa de Consulta por Projeto]]
- [[Contexto para Agentes]]
- [[Convenções]]