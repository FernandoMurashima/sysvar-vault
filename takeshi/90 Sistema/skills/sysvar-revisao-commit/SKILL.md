---
name: sysvar-revisao-commit
description: Revisão técnica independente de um commit do Codex no Sysvar, comparando o diff real com as regras aprovadas, a documentação do módulo e os Riscos e Cuidados. Use quando o usuário colar um relatório final do Codex, informar um SHA ou pedir para revisar uma implementação.
---

# Revisão de Commit — Sysvar

Corresponde à **Fase 5 — Revisão técnica** do Protocolo de Trabalho com IA. O revisor é independente de quem escreveu o prompt: compare o código com **as regras e a documentação**, não só com o que o prompt pediu. O objetivo é achar o que foi esquecido.

## Entradas

- SHA(s) e repositório (Central Backend/Frontend, Hub Backend/Frontend).
- Relatório final do Codex.
- Prompt enviado ao Codex e regras aprovadas na tarefa, se houver.

Se faltar SHA ou repositório, pergunte uma vez. O prompt é opcional.

## Passo 1 — Obter o diff real

Não confie no relatório. Leia o código.

```text
git fetch origin
git show --stat <sha>
git show <sha>
git branch -r --contains <sha>     # confirma que o push aconteceu
```

Para vários commits: `git log --oneline <base>..<sha>`. Sem shell no repositório, use o clone do GitHub ou peça ao usuário a saída de `git show <sha>`.

Abra também os arquivos inteiros que o diff altera quando o trecho isolado não basta para julgar.

## Passo 2 — Contexto do módulo

Aplique a skill **sysvar-contexto** (passos 1 a 4) para os módulos tocados pelo diff. Leia com prioridade `Riscos e Cuidados`, `Workflows` e `Homologação` do submódulo.

## Passo 3 — Verificações

Verifique cada item. **Relate só o que falhar.**

- **A. Escopo** — alterou apenas o pedido? Arquivos fora do escopo, refatoração não pedida, mudança visual ampla em correção pequena.
- **B. Regras de negócio** — cada regra aprovada e documentada foi implementada? Alguma regra foi inventada, alterada em silêncio ou removida?
- **C. Reaproveitamento** — criou model, endpoint, serializer, service, componente ou helper paralelo a um existente? Procure nomes e responsabilidades semelhantes no código.
- **D. Backend como autoridade** — validação, cálculo ou permissão crítica só no frontend.
- **E. Multiempresa** — querysets, serializers e endpoints novos ou alterados filtram por tenant/empresa/loja? Dados de uma empresa podem vazar para outra?
- **F. Hub ↔ Central** — idempotência e retry de envios; contratos de integração; o frontend do Hub não chama a Central diretamente; credenciais do Hub não chegam ao navegador; Operador, Terminal e Caixa continuam separados.
- **G. Migrations** — existem quando o model mudou; tratam dados existentes (defaults, nulos); sem perda de dados.
- **H. Testes** — cobrem a regra alterada, inclusive o caso negativo. Procure mascaramento: `skip`, teste comentado, assert enfraquecido, regra alterada para o teste passar. Quando possível, rode os testes direcionados:
  - Central: `cd Backend; .\venv\Scripts\python.exe manage.py test <app>`
  - Frontends: `npx.cmd tsc -p tsconfig.app.json --noEmit` e `npx.cmd ng build --configuration development`
- **I. Riscos e Cuidados** — cada risco do documento do módulo relacionado ao diff foi respeitado.
- **J. Relatório × realidade** — os arquivos listados batem com o diff; SHA e push conferem; pendências reais não foram omitidas.
- **K. Segredos e arquivos indevidos** — `.env`, tokens, XML de cliente, dumps, logs ou filas SQLite no commit.

## Passo 4 — Relatório de revisão

**Veredito:** Aprovado para homologação · Aprovado com ressalvas · Requer correção

**Problemas**, do mais grave ao menos grave. Para cada um:
- gravidade (Bloqueante / Importante / Menor);
- `arquivo:linha`;
- o que está errado;
- regra ou documento violado (com o nome da nota);
- cenário concreto em que falha (entrada → resultado errado).

**Pontos para homologação manual:** cenários que os testes não cobrem e o usuário deve testar na tela.

**Prompt de correção:** se o veredito for "Requer correção", entregue um prompt por correção, na ordem de prioridade, no formato do `Padrao de Prompts para Codex` (seção 24): bloco `text` único, sem `id=`, com problema, comportamento esperado, escopo, o que não fazer, validação, commit/push e relatório final.

## Regras

- Não listar o que está correto nem confirmar regras que já funcionam.
- Não declarar aprovado sem ter visto o diff.
- Dúvida de negócio não é defeito: registre como pergunta ao usuário.
- Divergência entre o código e uma nota antiga não é automaticamente erro do código; aplique a hierarquia de fontes.
