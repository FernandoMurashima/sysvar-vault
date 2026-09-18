# Metodologia de Trabalho

## 1. Objetivo

Este documento define a metodologia padrão de trabalho utilizada no desenvolvimento e na documentação dos projetos Sysvar.

Ele deve ser utilizado como referência sempre que houver dúvida sobre:

- como iniciar ou retomar um trabalho;
- quem analisa;
- quem decide;
- quem implementa código;
- como os prompts para o Codex devem ser produzidos;
- como a implementação deve ser revisada;
- como a documentação deve ser atualizada;
- qual é o fluxo entre GitHub, Obsidian e ambiente de desenvolvimento.

Quando for dado o comando:

> **“Recupere nossa metodologia de trabalho no arquivo do repositório.”**

o documento **`Metodologia de Trabalho.md`** deve ser consultado antes de continuar o trabalho.

---

# 2. Princípio geral

O trabalho é dividido em duas atividades diferentes:

1. **Desenvolvimento de software**
2. **Documentação**

Cada uma possui um fluxo próprio.

---

# 3. Metodologia de desenvolvimento

## 3.1 Papéis

### Usuário

O usuário:

- apresenta a necessidade;
- participa da análise;
- define regras de negócio;
- questiona e ajusta propostas;
- aprova o que será implementado;
- executa ou acompanha a homologação;
- determina quando uma etapa está encerrada.

### ChatGPT

O ChatGPT atua como **analista técnico e funcional**.

É responsabilidade do ChatGPT:

- consultar documentação quando necessário;
- consultar o código e os repositórios;
- entender o que já existe;
- identificar erros, melhorias e ausências;
- analisar a necessidade junto com o usuário;
- propor soluções;
- discutir alternativas;
- fechar com o usuário exatamente o que será feito;
- preparar o prompt de implementação;
- revisar o trabalho realizado pelo Codex;
- consultar o commit e o código alterado;
- conduzir os testes e a homologação.

O ChatGPT **não implementa diretamente alterações de código dos projetos**.

### Codex

O Codex é o **agente implementador**.

Ele recebe uma tarefa já analisada e definida.

É responsabilidade do Codex:

- consultar o código atual;
- consultar a documentação indicada;
- preservar o que já funciona;
- implementar somente o escopo definido;
- criar ou alterar testes;
- executar validações;
- executar builds quando necessários;
- fazer commit;
- fazer push;
- entregar um único relatório final.

O Codex não deve criar novas regras de negócio por conta própria.

---

# 4. Fluxo de desenvolvimento

O fluxo padrão é:

```text
NECESSIDADE
↓
ANÁLISE DO CHATGPT
↓
ANÁLISE E DISCUSSÃO COM O USUÁRIO
↓
CONSULTA AO CÓDIGO / DOCUMENTAÇÃO
↓
DEFINIÇÃO DO QUE SERÁ FEITO
↓
APROVAÇÃO DO USUÁRIO
↓
PROMPT PARA O CODEX
↓
IMPLEMENTAÇÃO PELO CODEX
↓
TESTES / BUILD / COMMIT / PUSH
↓
RELATÓRIO FINAL DO CODEX
↓
REVISÃO DO CHATGPT NO REPOSITÓRIO
↓
HOMOLOGAÇÃO
↓
CORREÇÕES, SE NECESSÁRIAS
↓
APROVAÇÃO
↓
DOCUMENTAÇÃO
```

---

# 5. Regra de análise antes da implementação

Não enviar diretamente uma ideia para o Codex.

Antes da implementação:

1. entender a necessidade;
2. consultar o estado atual;
3. verificar o que já existe;
4. identificar o que realmente precisa mudar;
5. discutir com o usuário;
6. fechar regras;
7. somente então preparar o prompt.

A implementação não deve substituir a análise.

---

# 6. Regra de reaproveitamento

Antes de criar qualquer estrutura nova, verificar se já existe algo que possa ser:

```text
REAPROVEITADO
→ AJUSTADO
→ ESTENDIDO
→ REFATORADO
→ somente depois CRIADO
```

Não construir funcionalidades paralelas sem necessidade.

---

# 7. Prompt para o Codex

O prompt é preparado pelo ChatGPT depois que a tarefa estiver definida.

O prompt deve:

- ser completo;
- estar em um único bloco;
- identificar projeto e repositório;
- informar branch;
- informar commit-base quando relevante;
- explicar o estado atual;
- definir o objetivo;
- definir o escopo;
- registrar o que deve ser preservado;
- registrar o que não deve ser feito;
- definir testes;
- definir builds;
- exigir commit;
- exigir push;
- exigir relatório final.

O nível de detalhe deve ser proporcional à tarefa.

Correções pequenas devem receber prompts pequenos.

Implementações grandes podem receber prompts mais completos.

---

# 8. Mensagens do Codex

O Codex não deve enviar mensagens intermediárias de acompanhamento.

O padrão é:

```text
EXECUTAR A TAREFA COMPLETA
↓
TESTAR
↓
VALIDAR
↓
COMMIT
↓
PUSH
↓
ENTREGAR UM ÚNICO RELATÓRIO FINAL
```

Salvo quando houver bloqueio real que impossibilite continuar, o Codex deve trabalhar até concluir a tarefa.

O prompt deve conter explicitamente:

> **Não envie mensagens intermediárias. Execute a tarefa e entregue somente o relatório final solicitado.**

---

# 9. Exemplo de prompt para o Codex

```text
PROJETO
Sysvar

DIRETÓRIO
[caminho local]

REPOSITÓRIO
FernandoMurashima/[repositorio]

BRANCH
main

BASE COMMIT
[SHA atual, quando aplicável]


============================================================
PADRÃO DE EXECUÇÃO DO CODEX
============================================================

1. Trabalhe somente no repositório informado.

2. Antes de alterar qualquer arquivo:
   - confirme git status;
   - confirme a branch;
   - confirme o HEAD atual.

3. Consulte primeiro:
   - documentação relacionada;
   - código atual;
   - testes existentes;
   - integrações relacionadas.

4. Reaproveite a implementação existente.

5. Não construa do zero algo que já exista.

6. Não altere regras de negócio fora do escopo.

7. Preserve funcionalidades já homologadas.

8. Faça somente as alterações necessárias para esta tarefa.

9. Execute todos os testes e builds definidos.

10. Ao final:
    - revise o diff;
    - faça commit;
    - faça push.

11. Não envie mensagens intermediárias.
    Execute toda a tarefa e entregue somente o relatório final solicitado.


============================================================
OBJETIVO
============================================================

[Descrever exatamente o que deve ser feito.]


============================================================
ESTADO ATUAL
============================================================

[Descrever o que já existe e o que deve ser preservado.]


============================================================
ESCOPO
============================================================

1. [Alteração 1]
2. [Alteração 2]
3. [Alteração 3]


============================================================
NÃO FAZER
============================================================

- não alterar funcionalidades fora do escopo;
- não criar estruturas paralelas desnecessárias;
- não remover comportamento já homologado;
- não inventar regra de negócio.


============================================================
VALIDAÇÕES
============================================================

Executar:

[comandos de testes]

[comandos de build]

Corrigir qualquer falha causada pelas alterações desta tarefa.


============================================================
GIT
============================================================

Depois das validações:

- revisar git status;
- revisar git diff;
- fazer commit;
- fazer push para a branch definida.

Mensagem de commit:

[mensagem sugerida]


============================================================
RELATÓRIO FINAL
============================================================

Entregue somente um relatório final contendo:

1. estado inicial;
2. arquivos alterados;
3. implementação realizada;
4. testes executados;
5. builds executados;
6. migrations, quando houver;
7. commit SHA completo;
8. push realizado;
9. git status final;
10. pendências reais.

Não envie mensagens intermediárias.
```

Este é um modelo-base. O prompt real deve ser adaptado à tarefa.

---

# 10. Depois que o Codex concluir

O relatório do Codex não encerra automaticamente uma tarefa.

O ChatGPT deve:

1. consultar o commit no GitHub;
2. verificar os arquivos realmente alterados;
3. comparar o resultado com o que foi solicitado;
4. identificar possíveis erros ou omissões;
5. aprovar tecnicamente ou solicitar correção;
6. conduzir os testes de homologação necessários.

Não aceitar uma implementação apenas porque o Codex informou que os testes passaram.

---

# 11. Correções

Quando um problema for encontrado depois da implementação:

- analisar o problema real;
- evitar reconstruir a funcionalidade inteira;
- produzir uma correção localizada;
- gerar novo prompt somente para o problema;
- validar novamente.

Evitar transformar pequenos defeitos em grandes refatorações.

---

# 12. Homologação

A homologação é conduzida pelo ChatGPT com execução do usuário quando necessária.

Quando o teste for manual:

- trabalhar de forma objetiva;
- passar uma etapa por vez quando o diagnóstico exigir;
- aguardar o resultado;
- não antecipar diversos passos;
- registrar erros reais encontrados.

Quando uma bateria de testes for mais eficiente, ela pode ser executada em conjunto.

---

# 13. Metodologia de documentação

A documentação utiliza um fluxo diferente do desenvolvimento de código.

Para documentação, o ChatGPT pode **alterar diretamente o repositório do cofre**.

O fluxo passa a ser:

```text
FUNCIONALIDADE / DECISÃO
↓
CONSULTA AO REPOSITÓRIO DO COFRE
↓
ANÁLISE DA DOCUMENTAÇÃO ATUAL
↓
DISCUSSÃO COM O USUÁRIO, QUANDO NECESSÁRIA
↓
DEFINIÇÃO DO CONTEÚDO
↓
ALTERAÇÃO DIRETA PELO CHATGPT NO REPOSITÓRIO
↓
COMMIT NO REPOSITÓRIO
↓
ATUALIZAÇÃO DO COFRE LOCAL / OBSIDIAN
```

---

# 14. Fonte principal da documentação

O repositório:

```text
FernandoMurashima/sysvar-vault
```

é a fonte versionada da documentação.

O Obsidian no ambiente de desenvolvimento é a cópia local utilizada para consulta e trabalho.

A direção normal de atualização será:

```text
REPOSITÓRIO
↓
AMBIENTE DE DESENVOLVIMENTO
↓
OBSIDIAN
```

Não utilizar como fluxo padrão:

```text
OBSIDIAN LOCAL
↓
ALTERAÇÃO MANUAL
↓
REPOSITÓRIO
```

salvo quando o usuário determinar explicitamente o contrário.

---

# 15. Procedimento para alteração de documentação

Antes de alterar documentação, o ChatGPT deve:

1. consultar o `sysvar-vault`;
2. localizar os documentos relacionados;
3. ler a versão atual;
4. verificar o que ficou desatualizado;
5. evitar duplicações;
6. preservar informações ainda válidas;
7. alterar somente o necessário;
8. fazer commit da documentação.

Quando houver uma decisão nova que altere documentação anterior, atualizar a documentação vigente em vez de criar versões contraditórias.

---

# 16. Validação de documentação nova

Quando o usuário solicitar explicitamente a criação ou reformulação de um documento e quiser revisá-lo antes:

```text
CHATGPT PREPARA O CONTEÚDO
↓
USUÁRIO REVISA
↓
USUÁRIO APROVA
↓
CHATGPT ALTERA DIRETAMENTE O REPOSITÓRIO
↓
USUÁRIO ATUALIZA O COFRE LOCAL
```

Este é o fluxo utilizado para a criação deste próprio documento.

---

# 17. Atualização do ambiente de desenvolvimento

Depois que o ChatGPT alterar e confirmar a documentação no repositório, o usuário atualiza a cópia local do cofre.

O repositório remoto deve ser considerado a referência para essa atualização.

A atualização local não deve recriar manualmente alterações que já estão no GitHub.

---

# 18. Regra para retomada de trabalho

Quando houver troca de conversa, interrupção longa ou perda de contexto, utilizar:

> **“Recupere nossa metodologia de trabalho no arquivo do repositório.”**

Ao receber esse comando, o ChatGPT deve:

1. consultar `Metodologia de Trabalho.md`;
2. recuperar o fluxo definido neste documento;
3. identificar o projeto em andamento;
4. consultar a documentação necessária;
5. consultar o repositório relacionado;
6. continuar utilizando esta metodologia.

---

# 19. Regra fundamental

Para **desenvolvimento**:

```text
USUÁRIO + CHATGPT ANALISAM
↓
USUÁRIO DECIDE
↓
CHATGPT PREPARA O PROMPT
↓
CODEX IMPLEMENTA
↓
CHATGPT REVISA
↓
USUÁRIO HOMOLOGA
```

Para **documentação**:

```text
USUÁRIO + CHATGPT DEFINEM
↓
CHATGPT ALTERA O REPOSITÓRIO
↓
USUÁRIO ATUALIZA O OBSIDIAN LOCAL
```

Esses dois fluxos não devem ser confundidos.
