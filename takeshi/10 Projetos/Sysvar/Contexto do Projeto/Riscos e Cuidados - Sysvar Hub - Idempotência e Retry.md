---
type: reference
status: active
project: Sysvar
source: "FernandoMurashima/sysvarbackend@d8a4597bc478b594040a27a0f0fa4c574c6c289c"
created: 2026-09-18
updated: 2026-09-18
tags:
  - sysvar
  - sysvar-hub
  - sincronizacao
  - idempotencia
  - retry
  - riscos
---

# Riscos e Cuidados - Sysvar Hub - Idempotência e Retry

## Objetivo

Registrar as regras que protegem a sincronização [[Mapa Técnico - Sysvar Hub - Sincronização Hub para Central]] contra duplicidade, concorrência e reprocessamento incorreto.

## Identidades idempotentes

Cada evento possui dois identificadores:

- `evento_uuid`;
- `chave_idempotencia`.

No banco existem restrições únicas por Hub para ambos.

Regra:

~~~text
Hub + evento_uuid
→ único

Hub + chave_idempotencia
→ única
~~~

## Hash do payload

O payload é normalizado em JSON determinístico e recebe SHA-256.

O hash é usado para distinguir:

- repetição legítima do mesmo evento;
- reutilização indevida da identidade com conteúdo diferente.

## Reenvio de evento processado

Quando o mesmo evento já foi `PROCESSADO` e chega novamente com os mesmos identificadores e o mesmo payload:

~~~text
resultado = DUPLICADO
~~~

O processamento de negócio não deve ser repetido.

Quando existir mapeamento, ele pode ser devolvido ao Hub para reconciliação.

## Conflito de payload

Se a mesma identidade idempotente for reutilizada com payload diferente:

~~~text
resultado = CONFLITO
~~~

O evento original processado não deve ser rebaixado nem alterado para conflito.

O registro anterior continua representando o que efetivamente foi processado.

## Conflito de identificadores

Também é conflito quando:

- o mesmo `evento_uuid` chega com outra chave;
- a mesma chave chega com outro `evento_uuid`.

Esses casos não devem ser tratados como retry comum.

## Retry de evento com ERRO

Um evento registrado com status `ERRO` pode ser reprocessado quando chega novamente com:

- mesmo Hub;
- mesmo `evento_uuid`;
- mesma chave;
- mesmo hash de payload.

Isso permite corrigir uma causa transitória ou dependência ausente e reenviar o mesmo evento sem gerar uma segunda identidade.

Se o retry tiver sucesso:

~~~text
ERRO
↓
PROCESSADO
~~~

A mensagem de erro anterior é limpa.

## Concorrência

A busca do evento existente usa bloqueio transacional.

Na tentativa de criar novo registro, uma corrida concorrente pode provocar `IntegrityError` pela restrição única.

Nesse caso o processador consulta o registro vencedor e aplica as mesmas regras de duplicado/conflito/retry.

Não criar segundo evento para contornar a restrição.

## Atomicidade

O registro do evento e o processamento do payload utilizam transações.

Uma exceção de processamento deve:

- preservar o evento como `ERRO`;
- guardar mensagem curta de diagnóstico;
- não marcar como processado;
- não deixar efeitos parciais fora da transação de negócio.

## Datas e horas

Datas/horas fornecidas pelo Hub devem ser validadas.

Não utilizar automaticamente `agora` quando uma data informada é inválida.

Para fechamento do dia, `data_operacional` é obrigatória e precisa ser uma data válida.

Esse cuidado evita transformar payload defeituoso em dado aparentemente correto.

## Status e comportamento esperado

### PROCESSADO

Evento aceito e operação aplicada.

### DUPLICADO

Evento já processado com a mesma identidade e conteúdo.

### ERRO

Evento conhecido, mas não aplicado com sucesso. Pode admitir retry coerente.

### CONFLITO

Identidade idempotente foi reutilizada de forma incompatível. Não fazer retry cego.

## Riscos a evitar

- gerar novo UUID a cada retry do mesmo evento;
- mudar chave de idempotência para forçar passagem;
- aceitar mesmo UUID com payload diferente;
- transformar conflito em duplicado silencioso;
- reprocessar venda já materializada;
- sobrescrever o status do evento original processado;
- usar fallback de data inválida;
- ignorar corrida de concorrência;
- gravar efeitos parciais antes de retornar erro.

## Operação do Hub

Quando receber `DUPLICADO`, o Hub deve considerar que o evento já foi conhecido pelo Central e reconciliar o mapeamento retornado quando aplicável.

Quando receber `ERRO`, o Hub pode reter o evento para retry conforme sua política local.

Quando receber `CONFLITO`, o evento exige diagnóstico; não deve entrar em loop infinito de reenvio automático sem correção da identidade/payload.

## Testes de regressão relevantes

A correção de retry adicionou cobertura para:

- conflito sem alterar evento original;
- mesmo UUID com chave diferente;
- mesma chave com UUID diferente;
- retry de evento em erro;
- concorrência na criação;
- datas inválidas;
- data operacional obrigatória.

## Commit de referência

- `d8a4597bc478b594040a27a0f0fa4c574c6c289c` — `fix: corrige retry da sincronizacao do Hub`.

Base funcional:

- `ba024a85797f08d3378174ae95e37e9a1a7cc381` — recepção de operações sincronizadas.

## Relacionados

- [[Sysvar Hub]]
- [[Mapa Técnico - Sysvar Hub - Sincronização Hub para Central]]
- [[Mapa Técnico - Sysvar Hub - Vendedores]]
- [[Mapa Técnico - Sysvar Hub - Tipos de Despesa PDV]]
