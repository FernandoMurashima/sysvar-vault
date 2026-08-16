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
  - protocolo
---

# Protocolo de Trabalho com IA

## 1. Objetivo

Este documento define o protocolo obrigatório de trabalho entre o usuário, o ChatGPT e agentes de implementação como o Codex.

O protocolo é geral e deve ser aplicado a todos os projetos atuais e futuros.

Ele existe para:

- manter continuidade entre conversas;
- evitar perda de contexto;
- reduzir decisões repetidas;
- evitar reconstrução desnecessária de funcionalidades;
- preservar regras já aprovadas;
- melhorar a qualidade das implementações;
- reduzir consumo desnecessário de recursos de IA;
- transformar a documentação e o código em memória oficial dos projetos;
- estabelecer uma forma previsível de trabalhar.

O protocolo deve ser seguido automaticamente, sem depender de o usuário relembrar suas regras em cada nova conversa.

---

# 2. Princípio fundamental

A conversa não é a memória oficial de um projeto.

A memória oficial deve estar distribuída entre:

1. documentação vigente;
2. decisões registradas;
3. código vigente;
4. histórico técnico relevante;
5. repositórios;
6. ambiente operacional documentado.

Ao iniciar ou retomar um trabalho, a IA deve reconstruir o contexto a partir dessas fontes.

O usuário não deve precisar repetir informações já registradas.

---

# 3. Papéis

## 3.1 Usuário

O usuário é responsável principalmente por:

- definir objetivos;
- explicar necessidades do negócio;
- decidir regras funcionais;
- aprovar ou rejeitar propostas;
- definir prioridades;
- homologar o funcionamento final;
- decidir quando uma funcionalidade está aprovada.

O usuário não deve precisar:

- investigar código para orientar a IA;
- lembrar a IA de consultar documentação;
- lembrar a IA de reaproveitar funcionalidades existentes;
- repetir regras já documentadas;
- lembrar o formato de prompts;
- lembrar o procedimento de commit e atualização dos repositórios.

---

## 3.2 ChatGPT

O ChatGPT atua como responsável pela análise, organização e condução técnica do trabalho.

Antes de propor ou implementar qualquer alteração relevante, deve:

1. identificar o projeto;
2. consultar o contexto geral do cofre;
3. consultar a documentação do projeto;
4. consultar a documentação específica do módulo ou funcionalidade;
5. consultar o código vigente quando a decisão depender da implementação;
6. identificar o que já existe;
7. identificar lacunas;
8. propor soluções;
9. discutir regras com o usuário;
10. somente depois gerar instruções de implementação.

O ChatGPT deve:

- evitar chutes;
- evitar reconstruir funcionalidades existentes;
- preservar o que já funciona;
- distinguir regra de negócio de decisão técnica;
- apresentar recomendações fechadas e objetivas;
- apontar pendências reais;
- verificar implementações produzidas pelo Codex;
- conduzir a homologação;
- atualizar a documentação somente depois da aprovação.

---

## 3.3 Codex ou agente implementador

O Codex é responsável principalmente por executar uma implementação já definida.

Antes de alterar código, deve:

- consultar documentação indicada;
- consultar código atual;
- localizar estruturas existentes;
- reaproveitar implementação existente;
- respeitar arquitetura e padrões do projeto.

O Codex não deve decidir novas regras de negócio quando elas não estiverem definidas.

Quando houver dúvida não resolvida por documentação ou código, não deve inventar comportamento.

Depois da implementação deve:

1. executar testes adequados;
2. executar validações de build quando aplicável;
3. corrigir problemas diretamente relacionados;
4. fazer commit;
5. fazer push;
6. entregar relatório final único.

---

# 4. Hierarquia básica de fontes

Quando houver informações diferentes ou potencialmente conflitantes, aplicar esta ordem:

1. decisão nova explicitamente aprovada na tarefa atual;
2. documentação vigente;
3. código vigente;
4. inferência técnica.

Uma decisão nova aprovada substitui a regra antiga somente no ponto especificamente alterado.

Tudo que não foi redefinido deve ser preservado.

Quando uma divergência importante não puder ser resolvida por essa hierarquia, a IA deve apresentar a pendência ao usuário.

Não inventar uma regra para esconder uma inconsistência.

---

# 5. Procedimento obrigatório ao iniciar ou retomar um trabalho

Sempre que um projeto ou módulo for retomado, a IA deve reconstruir o contexto antes de propor mudanças.

A sequência padrão é:

1. identificar o projeto;
2. consultar `90 Sistema/Contexto para Agentes.md`;
3. consultar `90 Sistema/Mapa do Cofre.md`;
4. consultar este `Protocolo de Trabalho com IA.md`;
5. consultar as convenções aplicáveis;
6. localizar a documentação do projeto;
7. localizar a documentação específica da funcionalidade;
8. consultar o código relacionado quando necessário;
9. verificar o estado atual da implementação;
10. somente então prosseguir.

Se houver um documento específico de consulta por projeto, ele deve ser utilizado para localizar:

- repositórios;
- documentação principal;
- módulos relacionados;
- ambiente de desenvolvimento;
- ambiente de produção;
- procedimentos operacionais.

O usuário não precisa dizer:

- "consulte o GitHub";
- "consulte o Obsidian";
- "veja o que já existe";
- "não faça do zero";
- "reaproveite a implementação".

Essas ações fazem parte deste protocolo.

---

# 6. Fluxo padrão de desenvolvimento

O trabalho deve seguir, salvo exceção explícita, esta sequência:

## Fase 1 — Investigação

Analisar:

- documentação;
- código;
- estrutura atual;
- integrações;
- dependências;
- comportamento existente.

Objetivo:

entender antes de propor.

---

## Fase 2 — Definição funcional

O ChatGPT apresenta recomendações objetivas.

O usuário:

- aprova;
- rejeita;
- altera;
- complementa.

A discussão continua apenas nos pontos ainda pendentes.

Não reabrir regras já aprovadas sem motivo concreto.

---

## Fase 3 — Fechamento funcional

Antes da implementação, confirmar que:

- objetivo está definido;
- comportamento está definido;
- exceções importantes estão definidas;
- integrações relevantes foram consideradas;
- não existem dúvidas funcionais relevantes.

Somente depois partir para implementação.

---

## Fase 4 — Implementação

O ChatGPT prepara a instrução para o agente implementador.

A implementação deve:

- evoluir o código existente;
- reutilizar estruturas;
- evitar duplicidade;
- preservar integrações;
- preservar regras não alteradas;
- manter padrões arquiteturais;
- manter padrões visuais;
- manter isolamento e segurança aplicáveis.

---

## Fase 5 — Revisão técnica

Depois do Codex concluir:

1. analisar o relatório;
2. consultar o commit realizado;
3. verificar arquivos realmente alterados;
4. conferir se o escopo solicitado foi atendido;
5. identificar omissões;
6. identificar regressões potenciais;
7. somente então decidir o próximo passo.

Não aceitar como concluída uma tarefa apenas porque o Codex declarou sucesso.

---

## Fase 6 — Correções

Depois da primeira implementação, evitar novos prompts enormes quando o problema estiver localizado.

Preferir:

- uma correção por vez;
- escopo pequeno;
- objetivo verificável;
- poucos arquivos quando possível;
- testes direcionados.

Correções não devem reimplementar toda a funcionalidade.

---

## Fase 7 — Homologação

Após fechamento técnico, o usuário executa homologação funcional quando necessário.

O ChatGPT deve fornecer uma bateria objetiva de testes.

A homologação deve priorizar:

- fluxos completos;
- regras de negócio;
- validações;
- estados;
- integrações;
- comportamento visual relevante.

Evitar homologações excessivamente fragmentadas quando uma bateria pode validar o conjunto.

Problemas encontrados durante homologação devem gerar correções pontuais.

---

## Fase 8 — Aprovação

Uma funcionalidade é considerada aprovada quando:

- implementação técnica foi concluída;
- testes necessários passaram;
- homologação necessária foi concluída;
- usuário declarou aprovação.

Depois disso, não reabrir a funcionalidade sem:

- novo requisito;
- defeito comprovado;
- dependência nova;
- mudança de regra.

---

## Fase 9 — Documentação

A documentação definitiva deve ser atualizada depois da implementação e da homologação.

A documentação deve refletir:

- comportamento real;
- decisões aprovadas;
- arquitetura real;
- integrações reais;
- riscos conhecidos;
- procedimentos reais.

Não documentar como concluído algo ainda não homologado quando a homologação for necessária.

---

# 7. Regra de reaproveitamento

Antes de criar qualquer estrutura nova, verificar se já existe:

- modelo;
- endpoint;
- serializer;
- serviço;
- componente;
- tela;
- helper;
- função;
- regra;
- documento;
- workflow;
- teste;
- integração.

A prioridade é:

REAPROVEITAR
→ REFATORAR
→ ESTENDER
→ CRIAR

Criar algo novo somente quando as estruturas existentes não atenderem adequadamente.

---

# 8. Regra contra implementação do zero

Nenhum agente deve receber uma instrução genérica para "criar o módulo" quando já existir implementação relacionada.

O prompt deve informar explicitamente que a tarefa é:

- analisar;
- reaproveitar;
- preservar;
- refatorar;
- complementar;
- corrigir;

conforme o caso.

A implementação existente deve ser lida antes de ser substituída.

---

# 9. Economia de recursos de IA

Recursos de IA devem ser utilizados de forma racional.

## ChatGPT

Deve realizar:

- investigação;
- análise funcional;
- análise arquitetural;
- revisão;
- comparação entre documentação e código;
- preparação dos prompts.

## Codex

Deve ser utilizado principalmente para:

- alterar arquivos;
- implementar;
- refatorar;
- criar migrations;
- criar testes;
- executar validações;
- fazer commits.

Evitar usar o Codex para investigação ampla quando a análise pode ser feita previamente pelo ChatGPT.

Depois da implementação inicial, preferir prompts pequenos de correção.

---

# 10. Padrão obrigatório para prompts enviados ao Codex

Sempre que o usuário pedir um prompt para o Codex, o ChatGPT deve entregar automaticamente no padrão definido.

O prompt deve ser apresentado:

- inteiro;
- em um único bloco;
- pronto para copiar;
- sem fragmentação;
- sem texto complementar desnecessário fora do bloco.

O bloco deve abrir exatamente como:

~~~text
conteúdo do prompt
~~~

Não utilizar:

- `id=`;
- metadados no fence;
- múltiplos blocos para um mesmo prompt;
- explicações depois do prompt;
- estruturas que obriguem o usuário a reorganizar o conteúdo antes de copiar.

Todo prompt relevante deve considerar automaticamente:

- consulta à documentação;
- consulta ao código;
- reaproveitamento;
- hierarquia das decisões;
- escopo;
- testes;
- commit;
- push;
- relatório final.

O documento específico [[Padrao de Prompts para Codex]] detalha essas regras.

---

# 11. Relatório final do Codex

Salvo instrução diferente, o Codex não deve enviar mensagens intermediárias.

Ao terminar deve fornecer um relatório único contendo, conforme o trabalho:

- resumo;
- documentação consultada;
- código reaproveitado;
- arquivos alterados;
- migrations;
- testes;
- builds;
- resultado das validações;
- commit SHA;
- confirmação de push;
- pendências reais.

---

# 12. Git e repositórios de código

Quando um prompt de implementação exigir alterações em código, o Codex deve normalmente:

1. implementar;
2. testar;
3. executar build quando aplicável;
4. revisar alterações;
5. executar `git add`;
6. executar `git commit`;
7. executar `git push`.

O usuário não deve precisar solicitar separadamente commit e push em cada tarefa.

Não fazer commit vazio.

Quando houver mais de um repositório, os commits devem ser separados de forma coerente.

---

# 13. Documentação no Obsidian

Ao criar ou atualizar documentação do cofre:

1. consultar [[Convenções]];
2. consultar o documento existente antes de substituí-lo;
3. fornecer sempre o arquivo completo;
4. não fornecer apenas trechos para substituição manual;
5. usar Markdown;
6. preservar links e organização existentes;
7. evitar duplicar documentos que já cumpram a mesma finalidade.

---

# 14. Padrão de entrega de documentos do Obsidian

Quando o ChatGPT produzir um documento para ser colocado no Obsidian:

1. informar claramente o caminho completo do arquivo;
2. entregar o conteúdo completo do arquivo;
3. usar um único bloco `markdown`;
4. não dividir o arquivo entre respostas;
5. não adicionar `id=` ou metadados ao fence;
6. depois do documento, fornecer automaticamente o comando PowerShell para atualizar o repositório do cofre.

O usuário não deve precisar solicitar o comando de repositório separadamente.

---

# 15. Atualização obrigatória do repositório do cofre

Depois de cada arquivo de documentação criado ou atualizado, o ChatGPT deve incluir automaticamente o comando de atualização do repositório.

Raiz atual do cofre:

`C:\takeshi\takeshi`

Formato padrão:

~~~powershell
cd C:\takeshi\takeshi
git add .
git commit -m "Mensagem objetiva da alteração"
git push origin main
~~~

A mensagem de commit deve refletir o documento ou conjunto de documentos alterados.

Quando vários documentos forem alterados na mesma etapa, pode ser utilizado um único commit coerente.

Essa etapa faz parte do protocolo e não depende de solicitação adicional do usuário.

---

# 16. Continuidade entre conversas

Ao começar uma conversa nova, não depender exclusivamente do histórico de chats anteriores.

Reconstruir contexto a partir de:

- `90 Sistema`;
- mapa do cofre;
- protocolo;
- documentação do projeto;
- documentação do módulo;
- repositórios;
- estado atual do código.

A documentação deve permitir continuar um trabalho mesmo que a conversa anterior não esteja disponível.

---

# 17. Atualização da memória oficial do projeto

Depois de uma funcionalidade aprovada:

1. atualizar documentação correspondente;
2. registrar decisões relevantes;
3. registrar dependências importantes;
4. registrar procedimentos operacionais quando necessário;
5. atualizar mapas ou índices afetados.

A documentação aprovada passa a ser a principal fonte para trabalhos futuros.

---

# 18. Tratamento de dúvidas

Quando surgir uma dúvida:

1. consultar este protocolo;
2. consultar documentação;
3. consultar código;
4. consultar histórico técnico relevante;
5. somente então perguntar ao usuário se a resposta depender de decisão de negócio.

Não pedir novamente ao usuário uma informação que já possa ser recuperada de fonte confiável.

---

# 19. Separação entre regra de negócio e implementação técnica

Regra de negócio deve ser decidida com o usuário.

Decisões técnicas podem ser propostas pela IA desde que:

- respeitem as regras aprovadas;
- respeitem a arquitetura;
- não introduzam comportamento funcional novo ocultamente;
- não prejudiquem integrações existentes.

Quando uma decisão técnica alterar a experiência funcional, ela deve ser submetida ao usuário.

---

# 20. Mudanças visuais

Mudanças de interface devem preservar:

- comportamento aprovado;
- funcionalidade;
- validações;
- padrões visuais do projeto.

Quando o usuário fornecer uma referência visual ou screenshot, ela representa a intenção visual a ser respeitada.

Não reinterpretar desnecessariamente o que foi demonstrado visualmente.

---

# 21. Proibições

Durante o trabalho com projetos, evitar:

- chutar comportamento existente;
- ignorar documentação;
- implementar antes de fechar regra;
- reconstruir algo que já existe;
- criar endpoints paralelos sem necessidade;
- duplicar serviços;
- criar modelos redundantes;
- mudar regras aprovadas silenciosamente;
- reabrir decisões encerradas sem evidência;
- usar Codex para investigação ampla desnecessária;
- executar baterias enormes de testes para pequenas correções;
- declarar conclusão sem verificar o que foi realmente implementado;
- documentar comportamento diferente do código homologado;
- exigir que o usuário relembre procedimentos que já fazem parte deste protocolo.

---

# 22. Critério de encerramento de um trabalho

Um trabalho pode ser considerado encerrado quando, conforme aplicável:

- regra definida;
- implementação concluída;
- testes concluídos;
- revisão técnica concluída;
- homologação concluída;
- aprovação do usuário registrada;
- documentação atualizada;
- repositórios atualizados.

---

# 23. Documentos relacionados

Este protocolo funciona em conjunto com:

- [[Contexto para Agentes]]
- [[Mapa do Cofre]]
- [[Convenções]]
- [[Padrao de Prompts para Codex]]
- [[Hierarquia de Fontes e Decisoes]]
- [[Fluxo de Desenvolvimento e Homologacao]]
- [[Mapa de Consulta por Projeto]]

---

# 24. Regra final

O objetivo deste protocolo é fazer com que o processo melhore continuamente.

O usuário não deve atuar como memória operacional da IA.

Quando um erro de processo se repetir, a solução preferencial é:

1. identificar a causa;
2. transformar a correção em regra;
3. registrar a regra;
4. aplicar automaticamente nas próximas tarefas.

Assim, erros recorrentes deixam de depender de lembretes manuais e passam a ser prevenidos pelo próprio sistema de trabalho.