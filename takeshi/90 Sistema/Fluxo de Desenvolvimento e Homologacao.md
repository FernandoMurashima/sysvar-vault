---
type: system
status: active
project: ""
source: ""
created: 2026-08-16
updated: 2026-08-27
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

Antes de modificar qualquer documento:

~~~text
CONSULTAR REPOSITÓRIO
↓
LER DOCUMENTAÇÃO VIGENTE
↓
COMPARAR COM A FUNCIONALIDADE HOMOLOGADA
↓
IDENTIFICAR DIVERGÊNCIAS REAIS
↓
SELECIONAR DOCUMENTOS AFETADOS
↓
ALTERAR SOMENTE O NECESSÁRIO
~~~

O ChatGPT é responsável por localizar os documentos que precisam de atualização.

O usuário não precisa:

- mostrar arquivos;
- copiar conteúdo;
- identificar todos os documentos relacionados;
- lembrar quais documentos centrais precisam ser sincronizados.

Podem ser atualizados, conforme o impacto real:

- mapa técnico;
- workflow;
- modelo de domínio;
- riscos e cuidados;
- arquitetura;
- visão geral;
- nota principal do projeto;
- homologação;
- runbooks;
- documentos específicos do módulo.

Não atualizar todos automaticamente.

Regra:

~~~text
SÓ ALTERAR DOCUMENTO QUE POSSUI DIVERGÊNCIA REAL
~~~

---

# 21. Atualização do repositório de documentação

Para documentos existentes, o padrão é fornecer um DIF executável em PowerShell.

Antes de gerar o DIF, o ChatGPT deve consultar diretamente o conteúdo vigente no repositório.

Fluxo obrigatório:

~~~text
git fetch origin
↓
restaurar arquivos-alvo de origin/main
↓
ler conteúdo atual
↓
validar estrutura e marcadores
↓
aplicar alteração seletiva
↓
gravar UTF-8 sem BOM
↓
git diff --check
↓
git diff dos arquivos-alvo
↓
git add somente dos arquivos-alvo
↓
commit
↓
push
↓
git status
~~~

Não utilizar por padrão:

~~~powershell
git add .
~~~

O commit deve conter somente os arquivos pertencentes à atualização documental atual.

Arquivos locais não relacionados e arquivos não rastreados devem permanecer fora do commit.

## 21.1 Consulta obrigatória antes do DIF

O ChatGPT deve consultar o conteúdo atual do repositório antes de preparar a alteração.

Não preparar DIF com base apenas em:

- memória da conversa;
- conteúdo histórico;
- cópia antiga;
- suposição sobre a estrutura atual.

A alteração deve partir do estado vigente.

## 21.2 Alteração seletiva

Preferir alteração por:

- seção;
- título;
- marcador;
- bloco delimitado;
- trecho pequeno e verificável.

Evitar substituir o documento inteiro quando a maior parte continuar correta.

Substituição integral é aceitável quando o documento estiver estruturalmente obsoleto em grande parte.

## 21.3 Falha durante o DIF

Se uma validação necessária falhar:

~~~text
PARAR
↓
NÃO CONTINUAR
↓
NÃO COMMITAR
↓
NÃO FAZER PUSH
~~~

O ChatGPT deve consultar novamente o arquivo vigente e preparar um DIF corrigido.

O usuário não deve precisar reconstruir ou mostrar manualmente o conteúdo do arquivo quando ele estiver acessível no repositório.

## 21.4 Codificação

Arquivos Markdown devem ser gravados em:

~~~text
UTF-8 sem BOM
~~~

Padrão:

~~~powershell
$utf8SemBom = New-Object System.Text.UTF8Encoding($false)

[System.IO.File]::WriteAllText(
    (Resolve-Path $path),
    $content,
    $utf8SemBom
)
~~~

## 21.5 Confirmação após execução

Depois que o usuário executar o DIF, o ChatGPT deve consultar novamente o repositório remoto.

Não presumir que:

- o script terminou;
- o commit ocorreu;
- o push ocorreu;
- o conteúdo final ficou correto.

A conclusão depende da confirmação do estado atual do repositório.

## 21.6 Varredura final

Depois que os documentos necessários estiverem atualizados, realizar uma única varredura final da documentação relacionada.

Procurar somente divergências reais:

- regra antiga ainda apresentada como atual;
- fluxo incompatível;
- relacionamento obsoleto;
- nomenclatura antiga;
- documento central não sincronizado;
- homologação incompatível;
- duplicidade;
- metadado diretamente afetado.

A varredura final não deve gerar uma sequência indefinida de novos ajustes.

Quando não houver divergência relevante:

~~~text
DOCUMENTAÇÃO ENCERRADA
~~~

e parar.

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