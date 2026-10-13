---
type: project
status: active
project: Sysvar
source: "FernandoMurashima/sysvarhub-backend + FernandoMurashima/sysvarhub-frontend + FernandoMurashima/sysvarbackend + FernandoMurashima/sysvarfrontend"
created: 2026-10-12
updated: 2026-10-13
tags:
  - sysvar
  - hub
  - planejamento
  - fechamento
  - prompts
  - homologacao
---

# Planejamento — Fechamento do Sysvar Hub

## Objetivo

Organizar o fechamento funcional do Sysvar Hub em tarefas pequenas, objetivas e rastreáveis, evitando prompts grandes para o Codex.

Este documento detalha os itens do Hub registrados em [[Planejamento, Pendências e Homologação]] e deve ser atualizado à medida que cada bloco for implementado, revisado, homologado e aprovado.

## Regras desta etapa

- um prompt deve ter um objetivo principal;
- preferir um único repositório por prompt;
- tempo esperado por prompt: aproximadamente 5 a 15 minutos;
- se o escopo ameaçar ultrapassar cerca de 20 minutos, dividir antes de enviar;
- durante implementação, executar somente testes diretamente relevantes;
- homologação funcional final deve ser feita pela interface sempre que possível;
- não reabrir Devolução ou Vale-Troca sem defeito novo;
- Cashback e Promoções devem ser investigados antes de nova implementação, porque há registros anteriores de implementação/aprovação;
- homologação real da NFC-e com SEFAZ/A1 válido fica fora deste fechamento;
- TEF/Pinpad fica fora deste fechamento e será tratado futuramente.

## Resultado esperado

Ao concluir este plano, o Sysvar Hub poderá ser considerado funcionalmente fechado no escopo atual, restando fora do fechamento apenas:

- homologação externa real da NFC-e/SEFAZ;
- TEF/Pinpad;
- evoluções futuras explicitamente aprovadas.

---

# Visão geral

Quantidade máxima prevista:

**10 prompts**

Quantidade provável:

**8 prompts**, caso Cashback e Promoções já estejam completos e exijam somente homologação.

~~~text
Recebimento de Loja
→ Cashback
→ Promoções
→ Versionamento
→ Compatibilidade
→ Atualização
→ Backup
→ Restauração
→ Homologação final integrada
~~~

A homologação final integrada não é um prompt de implementação. Ela será conduzida como bateria funcional pelo usuário. Erros encontrados nessa etapa geram prompts cirúrgicos separados.

---

# Bloco 1 — Recebimento de Loja

## Prompt 1 — Central: contrato do Recebimento de Loja

Status: IMPLEMENTADO — RECEBIMENTO ONLINE E OFFLINE HOMOLOGADOS EM 13/10/2026

Raciocínio recomendado: **Alto**

Objetivo:

- analisar o fluxo de recebimento já existente na Central;
- reaproveitar o que já existe;
- disponibilizar ao Hub somente o contrato necessário para identificar mercadorias/NF-e destinadas à Loja;
- receber posteriormente o resultado do recebimento realizado no Hub;
- preservar regras atuais de estoque, fiscal e distribuição;
- não criar tela;
- não implementar lógica duplicada no Hub se a Central já for autoridade da informação.

Escopo preferencial:

- Central Backend.

Resultado esperado:

Contrato mínimo e seguro Central ↔ Hub para suportar o recebimento local.

Homologação após o prompt:

- validar contrato e dados disponibilizados;
- não avançar para frontend antes de revisar o commit.

---

## Prompt 2 — Hub Backend: domínio local do Recebimento de Loja

Status: IMPLEMENTADO — RECEBIMENTO ONLINE E OFFLINE HOMOLOGADOS EM 13/10/2026

Raciocínio recomendado: **Alto**

Objetivo:

- implementar/completar a persistência local necessária;
- sincronizar recebimentos disponíveis;
- consultar uma entrega/NF-e;
- registrar conferência;
- efetivar entrada no estoque local;
- gerar evento de sincronização de retorno;
- garantir idempotência;
- preservar funcionamento offline.

Escopo preferencial:

- Hub Backend.

Resultado esperado:

Recebimento funcional no backend local sem depender da interface.

Homologação após o prompt:

- validar endpoints/contratos necessários;
- validar persistência e efeito em estoque;
- validar operação offline no nível técnico necessário.

---

## Prompt 3 — Hub Frontend: tela Recebimento de Loja

Status: IMPLEMENTADO — RECEBIMENTO ONLINE E OFFLINE HOMOLOGADOS EM 13/10/2026

Raciocínio recomendado: **Médio**

Objetivo:

- retirar o quadro independente de Vale-Troca da navegação;
- adicionar o quadro Recebimento de Loja;
- implementar fluxo:
  - listar recebimentos;
  - selecionar;
  - consultar;
  - conferir;
  - Tudo recebido;
  - Zerar;
  - Lançar no estoque;
- usar os dados reais do backend;
- não alterar a lógica interna de Vale-Troca usada por Devolução e Venda.

Escopo preferencial:

- Hub Frontend.

Resultado esperado:

Fluxo completo de Recebimento de Loja pela interface.

Homologação após o prompt:

- executar bateria funcional do recebimento pela interface;
- somente após aprovação marcar P5/P10 como concluídos.

---

## Registro de homologação — Recebimento de Loja — 13/10/2026

**Ambiente:** Hub da Loja Barra / Sysvar Central. **Resultado:** fluxos online (sem divergência e com divergência) e offline (com reconexão e transmissão automática) aprovados. Bloco de Recebimento de Loja homologado no escopo testado.

### Sem divergência

- Pedido `PV26000001`, NF-e 1, 12/10/2026, Loja Barra.
- Quantidade esperada e recebida: **180 peças**.
- Hub apresentou `RECEBIDO` e mensagem de conferência confirmada pela Central, com processamento local concluído.
- Conferência do estoque na Central aprovada no ciclo de 12/10.

### Com divergência

- Distribuição `DI26000002`, pedido `PV26000004`, NF-e **4**, 13/10/2026, Fábrica → Loja Barra.
- Referência `27-01-01004`, cor **Jeans**, tamanhos 34/36/38/40/42/44; enviado: **20/40/60/60/40/20**, total **240 peças**.
- Conferência feita no Hub: **18/40/60/60/40/20**, total **238 peças**; faltaram **2 peças no tamanho 34**.
- Observação informada na conferência: “Contado veio faltando duas! observacao no canhoto da nota”.
- Ao clicar `Lançar no estoque`, o Hub passou a mostrar `RECEBIDO`, com confirmação da Central e processamento local concluído, sem necessidade de confirmação manual adicional observada nesse teste.
- Saldo anterior na Central da Loja Barra, referência `27-01-01004`: Jeans **20 em cada tamanho**, total **120**; Azul **20 em cada tamanho**, total **120**.
- Saldo posterior conferido na Central, Jeans tamanhos 34/36/38/40/42/44: **38/60/80/80/60/40**, total **358 peças**; Azul permaneceu com **120 peças**; total da referência na Barra **478 peças**.
- **Resultado aprovado:** somente as 238 peças efetivamente conferidas ingressaram no saldo exibido pela Central; as 2 faltantes não foram adicionadas ao estoque da Barra.
- Este teste não valida, por si só, tratamento fiscal/contábil definitivo das peças faltantes. O comportamento offline foi homologado separadamente, conforme registro abaixo.

### Homologação offline — Loja Barra — 13/10/2026

**Status: APROVADO pelo usuário.**

- O recebimento de mercadoria foi executado no Hub da Loja Barra enquanto estava offline.
- Após restabelecimento da conexão, o Hub realizou a transmissão **automaticamente**, sem ação manual adicional.
- A Central aceitou o recebimento.
- O usuário confirmou o procedimento como homologado.
- Regra operacional aprovada: a conferência feita offline é persistida localmente e transmitida automaticamente após reconexão, sem intervenção do operador.
- Não foram informados nesta homologação número da NF-e, quantidades ou uma nova consulta detalhada de saldo; não atribuir valores do teste anterior a este.
- A robustez diante de falhas prolongadas, tentativas repetidas ou cenários extremos de conflito continua coberta pela bateria integrada de retry/idempotência, sem necessidade de reabrir o teste funcional aprovado.

### Pendência técnica — sincronização de novas entregas Central → Hub

- Depois da autorização da NF-e 4, o documento inicialmente **não aparecia** no Recebimento de Loja; a tela de Pendências também não mostrava ocorrência.
- **Após sincronização manual**, a NF-e 4 apareceu como `PENDENTE`, disponível para conferência, com 6 SKUs e 240 peças.
- **Diagnóstico ainda não fechado:** verificar se o mecanismo periódico de obtenção automática da Central já existe, sua frequência, gatilhos e motivo de a entrega não ter surgido no intervalo observado. Não concluir que inexiste sincronização automática apenas por esse teste.
- **Diretriz proposta, sujeita à análise do código:** priorizar atualização automática Central → Hub, mantendo sincronização manual como recurso operacional; não implementar alteração antes de diagnosticar.
- **Não bloqueante para o teste seguinte:** manter registrada e tratar em tarefa técnica específica.

### Próximo passo

**Recebimento offline com reconexão HOMOLOGADO em 13/10/2026.** Avançar na sequência oficial para investigação de Cashback; não repetir o fluxo aprovado sem defeito novo. Manter pendente a investigação específica da atualização automática das novas entregas Central → Hub.

---

# Bloco 2 — Cashback

## Verificação prévia obrigatória

Antes de gerar novo prompt, ChatGPT deve analisar documentação e código atuais.

Há documentação anterior registrando Cashback como implementado/aprovado, enquanto o documento principal mais recente o mantém como pendente.

A investigação deve responder:

- snapshot da configuração existe?
- geração local existe?
- uso offline seguro existe?
- estorno/cancelamento existe?
- sincronização Hub → Central existe?
- idempotência existe?
- qual é exatamente a lacuna atual, se houver?

## Prompt 4 — Cashback: correção da lacuna encontrada

Status histórico: CONDICIONAL — investigação realizada e lacunas implementadas em prompts menores. Ver registro de execução de 13/10/2026 abaixo.

Raciocínio recomendado: **Alto**

Executar somente se a investigação confirmar lacuna real.

Objetivo:

- corrigir exclusivamente o ponto faltante;
- não reimplementar Cashback completo;
- preservar tudo que já estiver homologado;
- manter política segura para saldo offline entre lojas.

Escopo:

- definido após investigação;
- preferir um repositório por prompt;
- se a lacuna atravessar Central e Hub de forma relevante, dividir este prompt em dois.

Se nenhuma lacuna for encontrada:

- não enviar Prompt 4;
- seguir diretamente para homologação do Cashback;
- atualizar documentação após aprovação.

---

## Registro de execução — Cashback — 13/10/2026

**Situação:** implementação de integração revisada em código; a homologação funcional integrada não foi executada. A revisão do Prompt 6A identificou dependência entre o valor do Vale-Troca provisório do Hub e o valor líquido consolidado na Central.

### Implementações verificadas

- Hub Backend: Cashback dedicado e separação LOCAL/offline versus CENTRAL/online; reserva oficial, vínculo por operação e sincronização. HEAD `fc8a8b2ad25cc8a2870708ce1c5e2ae2401ff694`.
- Hub Frontend: opções LOCAL e CENTRAL distintas e proteção contra consulta de saldo antiga; HEAD `0e2d82a09c6b81180098eb2e9a4bb90d7bf463cf`.
- Central Backend: cálculo da geração para vendas Hub, reserva oficial de Cashback, bloqueio de saldo, consumo transacional, idempotência e compatibilidade com Cashback offline. HEAD `82bd6ab824851b7be2a50698d8a37064fdbdcacc`.
- Prompt 6A da Central: restituição proporcional do Cashback utilizado durante a devolução, abatimento no Vale-Troca e vínculo do estorno à devolução; migration `financeiro/0037_cashbackmovimento_devolucao.py`; sete testes direcionados relatados como OK; commit `82bd6ab824851b7be2a50698d8a37064fdbdcacc`.
- Opção A aprovada pelo usuário: em devolução de R$ 100,00 de venda paga com R$ 30,00 em Cashback e R$ 70,00 em PIX, restituir R$ 30,00 ao Cashback e emitir Vale-Troca de R$ 70,00. Ajustar proporcionalmente em devoluções parciais.

### Pendências técnicas e de homologação

1. **Prioridade na retomada:** o Hub cria Vale-Troca provisório pelo valor bruto da devolução, mas a Central agora pode emitir Vale-Troca líquido (ou nenhum Vale se todo o valor for Cashback). Em `core/services/sync.py:_canonicalizar_devolucao_confirmada`, o Hub altera identificação e status do Vale sem reconciliar `valor_original`/`saldo` ou retirar o provisório quando não existir Vale oficial. Analisar e corrigir em tarefa pequena do Hub Backend antes de homologar devolução com Cashback, preservando as regras offline já aprovadas e o histórico de consumo.
2. Prompt 6B **não iniciado**: estornar proporcionalmente o Cashback **gerado** por itens devolvidos, evitando duplicação, respeitando usos posteriores do saldo e devoluções acumuladas.
3. Prompt 7 **não iniciado**: completar o lado Hub de devolução/estorno do Cashback e a reconciliação, observando a dependência do item 1.
4. Homologação operacional na Loja Barra pendente: Cashback LOCAL offline, CENTRAL com reserva, venda mista, devolução parcial/integral, reconexão e ausência de créditos duplicados. Não afirmar homologação somente pelos testes automatizados.
5. Recebimento de Loja permanece homologado. Investigar separadamente o atraso observado para novas entregas aparecerem automaticamente no Hub após autorização na Central.

### Pausa e retomada

**Ponto de parada em 13/10/2026:** Prompt 6A implementado e commit conferido; pendência de conciliação do Vale-Troca detectada durante a revisão. Não iniciar Prompt 6B/7 ou testes de devolução com Cashback até definir a correção dessa divergência. Retomar em 14/10/2026 pela análise dessa dependência, depois Prompt 6B, Prompt 7 e homologação integrada. Não abrir novas implementações na noite de 13/10/2026.

**Conferência de repositórios:** os cinco `main` remotos foram consultados. Os commits de Cashback nos três repositórios de código envolvidos não modificaram documentação. A situação das cópias locais somente pode ser confirmada com `git fetch`, `git status` e comparação de HEAD/origin/main no computador do usuário; não presumir igualdade local sem executar a conferência.


---

# Bloco 3 — Promoções

## Verificação prévia obrigatória

Antes de gerar novo prompt, verificar no código atual:

- sincronização Central → Hub;
- escopos de promoção;
- vigência;
- prioridade;
- preço/desconto aplicado;
- atualização de quantidade;
- snapshot da promoção na Venda;
- expiração;
- comportamento offline;
- integração com Cashback quando `acumula_cashback` for aplicável.

## Prompt 5 — Promoções: correção da lacuna encontrada

Status: CONDICIONAL

Raciocínio recomendado: **Médio**

Executar somente se a investigação apontar algo incompleto ou incorreto.

Objetivo:

- corrigir apenas a lacuna encontrada;
- não reconstruir o motor de Promoções;
- preservar regras existentes e homologadas.

Se nenhuma lacuna for encontrada:

- não enviar Prompt 5;
- homologar Promoções diretamente;
- atualizar documentação após aprovação.

---

# Bloco 4 — Atualização e versionamento

## Prompt 6 — Identidade de versão do Hub

Status: PENDENTE

Raciocínio recomendado: **Médio**

Objetivo:

- definir versão do Hub Backend;
- definir versão compatível do Hub Frontend;
- expor versão instalada de forma verificável;
- reaproveitar infraestrutura existente de build/instalação;
- não implementar atualização automática ainda.

Escopo preferencial:

- começar pelo repositório que já concentra instalação/versionamento;
- dividir se backend e frontend exigirem alterações independentes relevantes.

Resultado esperado:

Cada instalação sabe claramente qual versão está executando.

---

## Prompt 7 — Compatibilidade Central ↔ Hub

Status: PENDENTE

Raciocínio recomendado: **Médio**

Objetivo:

- definir regra objetiva de compatibilidade entre Central e Hub;
- impedir operação/atualização incompatível quando necessário;
- fornecer diagnóstico claro;
- evitar bloqueio desnecessário quando versões forem compatíveis;
- não implementar o processo completo de atualização ainda.

Resultado esperado:

Contrato de compatibilidade versionado e verificável.

---

## Prompt 8 — Processo de atualização do Hub

Status: PENDENTE

Raciocínio recomendado: **Alto**

Objetivo:

- implementar atualização de uma instalação existente;
- preservar configuração local;
- preservar banco;
- preservar filas/eventos pendentes;
- preservar documentos/XML locais;
- preservar identidade do Hub;
- atualizar frontend/backend de forma coerente;
- impedir atualização incompatível;
- prever falha/retorno seguro.

Resultado esperado:

Atualização real de uma versão para outra sem reinstalação limpa e sem perda operacional.

Homologação:

- executar atualização real em ambiente controlado;
- validar dados antes/depois;
- validar serviços;
- validar Hub/PDV após atualização.

---

# Bloco 5 — Backup e restauração

## Prompt 9 — Backup do Hub

Status: PENDENTE

Raciocínio recomendado: **Médio**

Objetivo:

- identificar o que precisa ser preservado;
- criar procedimento/rotina de backup;
- incluir banco local;
- incluir configuração necessária;
- preservar filas/eventos;
- preservar documentos/XML quando aplicável;
- não copiar segredos de forma insegura;
- validar integridade mínima do backup.

Resultado esperado:

Backup reproduzível e operacional do Hub instalado.

---

## Prompt 10 — Restauração do Hub

Status: PENDENTE

Raciocínio recomendado: **Alto**

Objetivo:

- restaurar instalação a partir do backup;
- validar compatibilidade do backup;
- recuperar banco/configuração/filas/documentos;
- evitar restauração parcial silenciosa;
- preservar identidade e consistência;
- validar serviços após recuperação.

Resultado esperado:

Procedimento de restauração testável e seguro.

Homologação:

- produzir backup;
- alterar ou isolar ambiente;
- restaurar;
- confirmar dados e funcionamento;
- confirmar sincronização pendente quando houver.

---

# Bloco 6 — Homologação final integrada do Hub

Status: PENDENTE

Esta etapa não começa com prompt de implementação.

A bateria final deve validar pela interface e pelo comportamento real, conforme aplicável:

- ativação;
- Hub vinculado à Loja;
- Terminal pareado;
- Operador;
- Caixa;
- catálogo;
- estoque;
- Fotos de Produto;
- cliente;
- vendedor;
- carrinho;
- venda;
- pagamentos;
- Consulta de Vendas F12;
- Recebimento de Loja;
- Cashback;
- Promoções;
- Devolução como regressão;
- Vale-Troca como regressão;
- sincronização Central → Hub;
- sincronização Hub → Central;
- internet desligada;
- reconexão;
- retry;
- idempotência;
- ausência de duplicidades;
- reinício do Hub quando aplicável;
- atualização/versionamento;
- backup/restauração.

Fora da bateria de fechamento atual:

- homologação real da NFC-e com SEFAZ/A1;
- TEF/Pinpad.

Problemas encontrados:

- cada erro deve gerar investigação;
- depois, se necessário, um prompt pequeno e cirúrgico;
- não criar um prompt geral de “corrigir homologação inteira”.

---

# Ordem de execução

~~~text
PROMPT 1
Central — contrato Recebimento
↓
REVISAR

PROMPT 2
Hub Backend — Recebimento
↓
REVISAR

PROMPT 3
Hub Frontend — Recebimento
↓
HOMOLOGAR RECEBIMENTO

INVESTIGAR CASHBACK
↓
PROMPT 4 somente se necessário
↓
HOMOLOGAR CASHBACK

INVESTIGAR PROMOÇÕES
↓
PROMPT 5 somente se necessário
↓
HOMOLOGAR PROMOÇÕES

PROMPT 6
Versionamento
↓
PROMPT 7
Compatibilidade
↓
PROMPT 8
Atualização
↓
HOMOLOGAR ATUALIZAÇÃO

PROMPT 9
Backup
↓
PROMPT 10
Restauração
↓
HOMOLOGAR RECUPERAÇÃO

HOMOLOGAÇÃO FINAL INTEGRADA DO HUB
↓
APROVAÇÃO
↓
DOCUMENTAÇÃO
↓
HUB FUNCIONALMENTE FECHADO
~~~

---

# Controle de execução

| Item | Status |
|---|---|
| Prompt 1 — Central / contrato Recebimento | IMPLEMENTADO — HOMOLOGADO ONLINE E OFFLINE |
| Prompt 2 — Hub Backend / Recebimento | IMPLEMENTADO — HOMOLOGADO ONLINE E OFFLINE |
| Prompt 3 — Hub Frontend / Recebimento | IMPLEMENTADO — HOMOLOGADO ONLINE E OFFLINE |
| Investigação Cashback | CONCLUÍDA — lacunas confirmadas em 13/10/2026 |
| Prompt 4 — Cashback | IMPLEMENTADO EM PARTES; Central e Hub integrados, ainda sem homologação funcional |
| Prompt 6A — restituição do Cashback utilizado (Central) | IMPLEMENTADO — COM DEPENDÊNCIA DE RECONCILIAÇÃO NO HUB |
| Prompt 6B — estorno do Cashback gerado | PENDENTE |
| Prompt 7 — reconciliação de devolução/Cashback no Hub | PENDENTE |
| Homologação Cashback | PENDENTE — requer correção do vale provisório / Central |
| Investigação Promoções | PENDENTE |
| Prompt 5 — Promoções | CONDICIONAL |
| Homologação Promoções | PENDENTE |
| Prompt 6 — Versionamento | PENDENTE |
| Prompt 7 — Compatibilidade | PENDENTE |
| Prompt 8 — Atualização | PENDENTE |
| Prompt 9 — Backup | PENDENTE |
| Prompt 10 — Restauração | PENDENTE |
| Homologação final integrada | PENDENTE |
| Fechamento documental do Hub | PENDENTE |

---

# Critério de fechamento

O Hub será considerado funcionalmente fechado quando:

- Recebimento de Loja estiver implementado e homologado;
- Cashback estiver confirmado/homologado;
- Promoções estiverem confirmadas/homologadas;
- versionamento e compatibilidade estiverem definidos;
- atualização estiver implementada e homologada;
- backup estiver implementado;
- restauração estiver testada;
- homologação final integrada for aprovada;
- documentação final estiver atualizada.

Pendências explicitamente externas ao fechamento:

- homologação real NFC-e/SEFAZ;
- TEF/Pinpad.
