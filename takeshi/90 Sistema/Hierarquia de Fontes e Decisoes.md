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
  - decisoes
  - fontes
---

# Hierarquia de Fontes e Decisões

## 1. Objetivo

Este documento define como resolver dúvidas, conflitos e divergências entre:

- decisões atuais;
- documentação;
- código;
- histórico;
- inferência técnica.

A finalidade é evitar:

- chutes;
- reabertura desnecessária de decisões;
- uso de informação antiga como se fosse vigente;
- alteração silenciosa de regra de negócio;
- implementação baseada em memória incompleta.

---

# 2. Hierarquia principal

Quando houver divergência entre fontes, usar esta ordem:

1. decisão nova explicitamente aprovada na tarefa atual;
2. documentação vigente;
3. código vigente;
4. inferência técnica.

Essa ordem deve ser aplicada automaticamente.

---

# 3. Decisão nova aprovada

Uma decisão nova aprovada pelo usuário durante o trabalho atual tem prioridade sobre uma regra anterior que trate do mesmo ponto.

Exemplo:

documentação antiga:
“tipo 2 pode conter Uso/Consumo e Insumo”

decisão nova aprovada:
“Uso/Consumo e Insumo nunca podem coexistir no mesmo pedido”

Resultado:

a decisão nova substitui a regra antiga apenas nesse ponto.

Não assumir que toda a documentação relacionada está automaticamente invalidada.

---

# 4. Preservação do que não foi alterado

Quando uma nova decisão modificar apenas parte de um comportamento:

- alterar somente o ponto redefinido;
- preservar as demais regras vigentes;
- não aproveitar a mudança para redesenhar outros comportamentos.

Regra:

NOVA DECISÃO ALTERA O NECESSÁRIO
+
RESTANTE CONTINUA VIGENTE

---

# 5. Documentação vigente

A documentação é a principal memória funcional e técnica dos projetos.

Ela deve ser usada para recuperar:

- regras de negócio;
- decisões anteriores;
- arquitetura;
- integrações;
- fluxos;
- padrões visuais;
- procedimentos operacionais;
- riscos conhecidos.

Antes de alterar uma funcionalidade já existente, consultar sua documentação quando disponível.

---

# 6. Código vigente

O código representa a implementação real em execução ou em desenvolvimento.

Deve ser consultado para entender:

- estruturas existentes;
- comportamento real;
- integrações;
- validações;
- endpoints;
- serviços;
- modelos;
- componentes;
- testes.

Código não deve ser interpretado automaticamente como regra de negócio correta.

Pode existir:

- código legado;
- comportamento ainda não homologado;
- implementação provisória;
- defeito.

Quando código e documentação divergirem, investigar antes de decidir.

---

# 7. Documentação e código em conflito

Quando documentação e código divergirem:

1. identificar se existe decisão nova aprovada;
2. verificar a data e o contexto da documentação;
3. verificar se o código é mais recente;
4. procurar documentação de homologação ou decisão posterior;
5. verificar commits relevantes quando necessário.

Não escolher automaticamente o código só porque é mais recente.

Não escolher automaticamente a documentação só porque está escrita.

A divergência deve ser resolvida com evidência.

---

# 8. Homologação tem peso especial

Quando uma funcionalidade tiver sido homologada pelo usuário, essa informação deve ser considerada forte evidência de comportamento aprovado.

Se houver registro claro de homologação:

- preservar o comportamento homologado;
- não reabrir sem novo requisito ou defeito comprovado.

Quando necessário, atualizar a documentação para refletir a homologação.

---

# 9. Inferência técnica

Inferência técnica só deve ser usada quando:

- decisão atual não responder;
- documentação não responder;
- código não responder;
- comportamento puder ser definido tecnicamente sem alterar regra de negócio.

Exemplos:

- nome de helper interno;
- organização de componente;
- pequena decisão de refatoração;
- forma de estruturar teste;
- escolha de método equivalente dentro do padrão do projeto.

Inferência não deve criar regra funcional nova.

---

# 10. Dúvida funcional

Quando a dúvida alterar:

- comportamento do usuário;
- regra de negócio;
- cálculo;
- estado;
- permissão;
- integração;
- emissão fiscal;
- movimento financeiro;
- movimento de estoque;
- experiência funcional relevante;

e não houver resposta nas fontes, perguntar ao usuário.

Não decidir silenciosamente.

---

# 11. Dúvida técnica

Quando a dúvida for estritamente técnica e não alterar regra funcional, a IA pode propor e escolher a solução mais coerente.

A decisão deve respeitar:

- arquitetura vigente;
- padrões existentes;
- segurança;
- manutenção;
- simplicidade;
- reaproveitamento.

---

# 12. Histórico de conversa

O histórico de conversa pode ajudar na reconstrução do contexto, mas não deve ser a única fonte oficial.

Quando uma decisão importante existir apenas na conversa:

1. usá-la para concluir a tarefa atual;
2. depois registrá-la na documentação apropriada.

O objetivo é reduzir dependência de memória de chat.

---

# 13. Commits e histórico Git

Consultar commits quando necessário para:

- descobrir quando uma regra mudou;
- identificar implementação recente;
- comparar estado anterior e atual;
- verificar o que o Codex realmente alterou;
- confirmar se uma correção foi aplicada.

Commit não substitui documentação, mas pode resolver ambiguidades técnicas.

---

# 14. Testes automatizados

Testes são evidência do comportamento esperado pelo código.

Devem ser considerados ao avaliar mudanças.

Porém:

- teste antigo pode representar regra antiga;
- teste incorreto pode existir;
- teste não substitui decisão de negócio.

Quando nova regra aprovada contradizer teste antigo:

- atualizar implementação;
- atualizar teste;
- atualizar documentação.

---

# 15. Interface e screenshots aprovados

Quando o usuário fornecer screenshot ou referência visual e declarar que aquele padrão é o desejado:

- tratar como referência de layout;
- preservar intenção visual;
- evitar reinterpretar desnecessariamente.

A referência visual não substitui regra funcional, mas orienta apresentação e UX.

---

# 16. Fontes por nível de autoridade

## Nível 1 — Autoridade funcional atual

- decisão nova aprovada;
- homologação explícita do usuário.

## Nível 2 — Memória oficial

- documentação vigente;
- decisões documentadas;
- workflows;
- modelos de domínio;
- runbooks.

## Nível 3 — Implementação

- código;
- serializers;
- endpoints;
- serviços;
- componentes;
- migrations;
- testes.

## Nível 4 — Evidência histórica

- commits;
- logs;
- relatórios de implementação;
- conversas anteriores.

## Nível 5 — Inferência

- interpretação técnica;
- melhor prática;
- hipótese.

Quanto menor o nível, menor deve ser a confiança para criar comportamento funcional novo.

---

# 17. Regra contra memória presumida

A IA não deve afirmar:

“isso já funciona assim”

apenas por lembrar de conversa anterior.

Quando a afirmação for importante para uma implementação:

- verificar documentação;
- verificar código;
- verificar homologação registrada.

---

# 18. Regra contra reabertura desnecessária

Não reabrir uma decisão já aprovada apenas porque existe outra possibilidade técnica.

Reabrir somente quando houver:

- defeito;
- conflito real;
- dependência nova;
- mudança de requisito;
- risco importante ainda não considerado.

---

# 19. Regra de conflitos não resolvidos

Quando duas fontes relevantes conflitarem e não for possível determinar qual é vigente:

1. não esconder a divergência;
2. não escolher aleatoriamente;
3. apresentar a diferença;
4. indicar impacto;
5. solicitar decisão somente se ela for realmente necessária.

---

# 20. Atualização após nova decisão

Depois que uma nova decisão for:

- implementada;
- testada;
- homologada;

atualizar a documentação correspondente.

Assim, a próxima tarefa passa a encontrar a regra correta diretamente na memória oficial.

---

# 21. Exemplo prático de resolução

Situação:

- documentação diz A;
- código atual faz B;
- usuário acabou de aprovar C.

Aplicação:

1. C passa a ser regra vigente;
2. implementar C;
3. preservar demais regras não afetadas;
4. testar;
5. homologar;
6. atualizar documentação;
7. código e documentação passam a refletir C.

---

# 22. Regra para o Codex

Prompts para Codex devem incluir, quando relevante, esta hierarquia:

1. este prompt e decisões novas nele registradas;
2. documentação vigente;
3. código atual;
4. inferência técnica.

O Codex não deve inventar regra de negócio quando essas fontes não responderem.

---

# 23. Regra para o ChatGPT

Antes de apresentar solução para uma funcionalidade existente, o ChatGPT deve procurar responder:

- já existe decisão documentada?
- já existe código?
- já foi homologado?
- a proposta altera algo vigente?
- existe conflito entre fontes?

Somente depois apresentar recomendação.

---

# 24. Regra final

A finalidade desta hierarquia é garantir que o trabalho evolua sem perder conhecimento anterior.

Quando houver dúvida:

CONSULTAR
→ COMPARAR
→ RESOLVER
→ IMPLEMENTAR
→ HOMOLOGAR
→ DOCUMENTAR

Nunca:

LEMBRAR PARCIALMENTE
→ CHUTAR
→ IMPLEMENTAR
