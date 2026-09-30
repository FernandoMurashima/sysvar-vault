---
type: reference
status: active
project: Sysvar
source: "FernandoMurashima/sysvarbackend + FernandoMurashima/sysvarfrontend + FernandoMurashima/sysvarhub-backend + FernandoMurashima/sysvarhub-frontend"
created: 2026-09-30
updated: 2026-09-30
tags:
  - sysvar
  - sysvar-hub
  - estado-atual
  - pdv
  - sincronizacao
  - loja
---

# Estado Atual — Sysvar Hub

## Data de referência

30/09/2026.

Esta nota representa o estado corrente do Sysvar Hub na data acima. A nota [[Sysvar Hub]] permanece como contexto arquitetural e histórico das etapas anteriores.

---

# Papel atual

O Sysvar Hub é a camada operacional local da loja.

Estrutura vigente:

```text
Sysvar Central
    ↕ Internet / APIs de Hub
Sysvar Hub da Loja
    ↕ LAN
Terminais / PDVs
```

Princípios preservados:

- uma loja opera por meio de um Hub local;
- terminais não acessam diretamente o banco MySQL do Hub;
- Terminal, Operador e Caixa são conceitos distintos;
- credencial do Hub e credencial do Terminal são separadas;
- o navegador não recebe a credencial da Central usada pelo Hub;
- a Central permanece autoridade dos cadastros e dados corporativos consolidados.

---

# Repositórios ativos

## Central Backend

`FernandoMurashima/sysvarbackend`

## Central Frontend

`FernandoMurashima/sysvarfrontend`

## Hub Backend

`FernandoMurashima/sysvarhub-backend`

## Hub Frontend

`FernandoMurashima/sysvarhub-frontend`

Todos utilizam `main` como branch principal.

---

# Estado operacional do Hub

O Hub Backend possui atualmente, entre outros componentes:

- ativação do Hub;
- bootstrap e sincronização inicial;
- heartbeat;
- administração remota de terminais;
- identidade persistente do terminal;
- tratamento de revogação de credenciais;
- worker/fila operacional de sincronização;
- estado local de caixas e sessões;
- operação de venda local;
- sincronização de venda Hub → Central;
- integração fiscal relacionada ao PDV;
- devolução/troca online orquestrada pela Central;
- Vale-Troca online com autoridade da Central.

O Hub Frontend possui atualmente:

- Home operacional;
- autenticação de operador no nível do Hub;
- PDV;
- preservação/reconciliação da venda ativa;
- Consulta de Vendas;
- Devolução / Troca;
- Vale-Troca;
- Pendências de Sincronização;
- acompanhamento da conectividade com a Central;
- pareamento e recuperação da identidade do terminal.

---

# Sincronização e configuração inicial

A configuração do terminal depende de a sincronização inicial do Hub ter sido concluída.

A Central não deve liberar configuração operacional de terminal antes de o Hub possuir a carga inicial necessária.

A ordem conceitual é:

```text
ATIVAÇÃO DO HUB
→ SINCRONIZAÇÃO INICIAL
→ DISPONIBILIZAÇÃO DO ESTADO LOCAL
→ CONFIGURAÇÃO/PAREAMENTO DO TERMINAL
→ OPERAÇÃO
```

Comandos antigos ou pendentes não devem reativar silenciosamente identidade de terminal já desvinculada ou revogada.

---

# Operador

A autenticação pessoal do operador acontece no Hub e é separada da identidade do terminal.

Regras atuais:

- Home pode existir sem operador autenticado;
- módulos protegidos exigem sessão do operador;
- login do operador não abre caixa automaticamente;
- sair do PDV não deve, por si só, encerrar caixa nem cancelar venda ativa;
- endpoints operacionais protegidos devem receber a sessão do operador conforme o escopo definido no frontend/backend.

---

# Venda e PDV

A venda ativa pertence operacionalmente ao Hub local.

Ao retornar ao PDV, o frontend deve reconciliar a tela com o estado persistido da venda ainda aberta no Hub.

A sincronização com a Central deve preservar identidade técnica, idempotência e vínculo com os documentos oficiais retornados pela retaguarda.

Identificadores técnicos locais não substituem documentos comerciais oficiais apresentados ao operador.

---

# Devolução / Troca

Em 30/09/2026 o fluxo deixou de ser apenas estrutura futura.

O estado atual inclui:

- endpoints online na Central para operação do Hub;
- orquestração da devolução pelo Hub Backend;
- tela própria no Hub Frontend;
- escopo de operador aplicado às chamadas protegidas;
- espelhamento do resultado fiscal da devolução;
- emissão/registro de NF-e de entrada de devolução na Central conforme o fluxo implementado.

Documentação técnica acoplada ao código:

- Central Backend: `docs/fiscal-devolucao-entrada.md`
- Hub Backend: `docs/devolucao-troca-online.md`

---

# Vale-Troca

Em 30/09/2026 o Vale-Troca online está integrado entre Central e Hub.

Princípios atuais:

- Central é autoridade do Vale oficial e de seu saldo;
- Hub consulta/lista o Vale pela integração autenticada com a Central;
- venda exige cliente identificado para uso do Vale oficial;
- reservas evitam uso simultâneo do mesmo saldo;
- consumo oficial é consolidado na Central;
- o frontend do Hub não chama diretamente endpoints web/JWT da Central para esse fluxo;
- offline não existe fallback silencioso para saldo oficial da Central.

Documentação técnica acoplada ao código:

- Central Backend: `docs/vale-troca-online.md`
- Hub Backend: `docs/vale-troca-online.md`

---

# Fiscal no Hub

O Hub participa da coleta e envio dos dados operacionais do PDV, mas a documentação fiscal deve respeitar a separação entre:

- documento comercial;
- identidade técnica local;
- numeração fiscal oficial;
- integração Hub ↔ Central.

NF-e/NFC-e mantêm sua autoridade e numeração fiscal próprias.

Decisões futuras de padronização de documentos comerciais devem ser tratadas em planejamento próprio e não misturadas nesta nota de estado operacional.

---

# Documentação histórica

As notas anteriores do Hub contêm decisões úteis tomadas durante a construção incremental.

Quando um trecho antigo disser, por exemplo, que uma funcionalidade "ainda não faz parte" ou "será implementada futuramente", interpretar de acordo com a data explícita da seção.

Para saber o estado vigente, consultar nesta ordem:

1. esta nota;
2. documentação técnica específica do fluxo;
3. código atual em `main`;
4. commits recentes relevantes;
5. checkpoints históricos somente para reconstrução de contexto.

---

# Relações

- [[Sysvar]]
- [[Sysvar Hub]]
- [[Checkpoint - Sysvar Hub]]
- [[Diagnóstico da Documentação - 2026-09-30]]
