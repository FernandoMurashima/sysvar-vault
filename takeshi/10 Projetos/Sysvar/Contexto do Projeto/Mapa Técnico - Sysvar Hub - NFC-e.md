---
type: technical-map
status: active
project: Sysvar
created: 2026-09-20
updated: 2026-09-20
tags:
  - sysvar
  - hub
  - pdv
  - nfce
  - fiscal
---

# Mapa Técnico — Sysvar Hub — NFC-e

## Objetivo

Registrar a arquitetura aprovada da NFC-e no Sysvar Hub, o estado das implementações e as pendências reais antes da homologação externa com a SEFAZ.

## Arquitetura aprovada

~~~text
Terminal PDV
→ finaliza a operação comercial no Hub

Sysvar Hub
→ mantém configuração fiscal local
→ controla série e numeração
→ gera chave de acesso
→ gera XML NFC-e modelo 65
→ assina XML
→ gera QR Code
→ persiste NFCeHub
→ opera contingência
→ disponibiliza DANFE ao Terminal
→ mantém fila durável de sincronização
→ sincroniza venda/documento/status com o Central
→ possui provider A1 e camada de transporte SEFAZ real configurável

Sysvar Central
→ autoridade dos cadastros e parâmetros fiscais
→ envia configuração fiscal e mapas tPag
→ recebe NFC-e/XML/status/eventos do Hub
~~~

Regra estrutural: **1 Loja → 1 Hub → N Terminais**. O Terminal não controla número fiscal, certificado ou comunicação com a SEFAZ.

## Contratos Central → Hub

Implementações aprovadas no Central:

- `873b097fe6a42dc5717bb4940291cd5cdfb6a5cd` — configuração fiscal da Loja no bootstrap;
- `4687d2b8a68796aa3609d663d1abb7efe449ae22` — mapas fiscais das formas de pagamento (`tPag`).

O catálogo local também mantém snapshot fiscal do produto utilizado pela venda.

## Fase 1 — Núcleo fiscal local — APROVADA

Commits principais do Hub backend:

- `3773101ebc660d29b1018811ceb377b81b5144a0` — núcleo local inicial;
- `bc49f649996cf2820f803629882bd8d748560738` — correções de XMLDSIG, QR Code 3.00 e tributação suportada.

Concluído:

- `ConfiguracaoFiscalHub`;
- `FormaPagamentoFiscalMapHub`;
- `NFCeHub` 1:1 com `VendaHub`;
- snapshot fiscal imutável no item vendido;
- numeração local transacional e monotônica;
- idempotência por venda;
- chave de acesso de 44 dígitos;
- XML NFC-e 4.00;
- assinatura XMLDSIG enveloped;
- QR Code 3.00 online;
- `infNFeSupl`;
- persistência de XML e payload do QR;
- tributação suportada para os cenários atualmente representáveis;
- troco e desconto de item no XML;
- certificado temporário somente para desenvolvimento/teste.

Limitação conhecida: desconto geral ainda não possui rateio fiscal homologado e permanece bloqueado por erro de domínio controlado.

## Fase 2A — Finalização, contingência e fronteira transacional — APROVADA

Commits principais do Hub backend:

- `d050385107aa23d56cf77b1121121957b659e1b3` — integração inicial da NFC-e à finalização;
- `2c34bb707d1198697e04eb1f8a2f837110e071e3` — separação entre transação comercial e processamento fiscal.

Concluído:

- pré-validação fiscal antes da finalização comercial;
- venda sem NFC-e preserva o comportamento anterior;
- venda com NFC-e reserva número e cria documento de forma durável;
- venda, estoque, evento e reserva fiscal são confirmados antes do processamento externo;
- processamento fiscal ocorre fora da `transaction.atomic()` comercial;
- retry não duplica venda, estoque, evento, número ou NFC-e;
- rejeição fiscal pós-commit não reabre a venda;
- erro pós-reserva mantém número consumido e documento rastreável;
- `PENDENTE_TRANSMISSAO` permanece recuperável após reinício;
- contingência usa `tpEmis=9`, chave/DV coerentes, `dhCont`, `xJust` e QR Code 3.00 offline;
- adapter de desenvolvimento não cria autorização fiscal real nem protocolo falso.

## Fase 2B — DANFE e impressão no PDV — APROVADA

Backend:

- `c6d54258fc8cca96d50dc5562a54e4401296382f` — serviço DANFE e endpoint local.

Frontend:

- `3bec3711ddef36bf56d60f6ab8b3640ba8964442` — integração inicial do DANFE no PDV;
- `1460fbfb5e2d9f6c6d1c0fd8b356f84d8cc16b11` — alinhamento final do contrato frontend com o backend real.

Concluído:

- DANFE montado a partir do XML persistido, sem recalcular tributação nem consultar catálogo atual;
- endpoint `GET /api/terminal/venda/<venda_uuid>/danfe-nfce/` isolado pelo Hub do Terminal;
- Via Consumidor e Via do Estabelecimento;
- QR visual gerado localmente a partir do payload fiscal persistido;
- estado fiscal preservado na resposta de finalização do PDV;
- modal/tela de venda finalizada;
- carregamento automático do DANFE consumidor;
- impressão térmica via `window.print()`;
- impressão isolada por CSS em modo de impressão;
- suporte visual a contingência;
- DANFE não imprimível quando rejeitado, em erro ou pendente normal;
- contrato TypeScript alinhado ao JSON real do backend;
- testes focados e build Angular aprovados.

## Fase 3A — Recepção da NFC-e no Central — APROVADA

Commit principal do Central:

- `d4f63091c2aae4c488f8c862e4fdc165c8a142e6` — recepção e persistência da NFC-e enviada pelo Hub.

Concluído:

- novo evento `NFCE_ATUALIZADA` reaproveitando `POST /api/hub/sync/push/`;
- não foi criado protocolo paralelo de sincronização;
- `HubNFCeMapeamento` vincula `hub + nfce_uuid` ao registro `fiscal.NFCe` do Central;
- NFC-e somente é aceita depois que a venda correspondente já foi sincronizada;
- atualização usa `versao_evento` monotônica e não depende do relógio das máquinas;
- evento obsoleto é ignorado sem regressão do documento;
- retry e idempotência continuam baseados em `HubEventoRecebido`, `evento_uuid`, `chave_idempotencia` e `payload_hash`;
- Central passa a armazenar estados `GERADA`, `PENDENTE_TRANSMISSAO`, `ERRO_GERACAO` e demais estados do Hub sem promover documento para `AUTORIZADA` artificialmente;
- XML assinado, QR payload, chave, protocolo real quando existir, retorno e dados de contingência podem ser persistidos;
- `fiscal.NFCe` passa a possuir vínculo explícito com Loja;
- unicidade fiscal corrigida para `loja + ambiente + modelo + série + número`, permitindo a mesma série/número em Lojas diferentes;
- fluxo legado continua preenchendo a Loja pela Venda quando a NFC-e for criada internamente;
- testes do app `hub` aprovados após a alteração.

Observação não bloqueante: o `NFCeSerializer` expõe a nova FK `loja` como campo gravável no endpoint CRUD legado. O fluxo interno antigo continua funcionando pelo `save()` do modelo, e a arquitetura oficial da NFC-e do Hub não depende desse POST genérico. Se o CRUD legado voltar a ser utilizado para criação direta, revisar esse contrato antes de tratá-lo como fluxo suportado.

## Fase 3B — Hub → Central / fila durável — APROVADA

Commits principais do Hub backend:

- `78be9337fb3614b72bcab8dfb93aac2d98c7c604` — fila durável, envio Hub → Central e infraestrutura fiscal ampliada;
- `b7bcf8630a36a759705659c83c3ba73024816a5d` — correções finais de idempotência, fronteira transacional e modo de desenvolvimento.

Concluído:

- `EventoSyncHub` como outbox local persistente;
- eventos `VENDA_FINALIZADA` e `NFCE_ATUALIZADA` persistidos antes da dependência de rede;
- ordem lógica Venda → NFC-e preservada;
- versionamento monotônico da NFC-e via `sync_versao`;
- chave idempotente por versão no formato `NFCE:<uuid>:V:<versao>`;
- mesma chave não pode ter payload sobrescrito;
- evento já sincronizado não volta para `PENDENTE` por reenfileiramento equivalente;
- lote de sincronização reutiliza `POST /api/hub/sync/push/`;
- `PROCESSADO` e `DUPLICADO` confirmam sincronização;
- `CONFLITO` é terminal para aquele evento;
- erro de rede/retaguarda permanece recuperável com retry/backoff;
- seleção/marcação `PROCESSANDO` ocorre dentro de `transaction.atomic()`, com HTTP fora da transação;
- flush integrado ao heartbeat e comando manual `sincronizar_eventos_hub`;
- venda comercial e operação offline não dependem da disponibilidade do Central.

## Fase 3C — Infraestrutura para SEFAZ real / A1 — APROVADA PARA O DESENVOLVIMENTO ATUAL

Commits principais do Hub backend:

- `78be9337fb3614b72bcab8dfb93aac2d98c7c604` — provider A1, adapter configurável, retransmissão e persistência ampliada;
- `b7bcf8630a36a759705659c83c3ba73024816a5d` — transporte real injetável/mockável e correção para impedir autorização fiscal falsa em desenvolvimento.

Concluído:

- `NFCeMaterialProviderA1` lê `.pfx/.p12` por configuração externa;
- senha do A1 não é persistida nem enviada ao Central;
- validação de arquivo, senha, chave privada, certificado e validade temporal;
- seleção separada entre material `DESENVOLVIMENTO` e `A1`;
- modo de desenvolvimento nunca transforma simulação em `AUTORIZADA`, não cria protocolo fictício e não usa código fiscal `100` falso;
- `SefazNFCeClientReal` separado do adapter de desenvolvimento;
- endpoint de autorização configurável externamente, sem URL oficial hardcoded;
- transporte HTTPS/mTLS preparado com certificado cliente A1 e arquivos PEM temporários removidos em `finally`;
- transporte injetável/mockável, permitindo testar autorização, rejeição, timeout e indisponibilidade sem chamada real;
- persistência preparada para protocolo, código/mensagem, data de autorização e XML autorizado;
- rejeição não desfaz venda comercial nem reutiliza numeração;
- timeout/indisponibilidade preservam contingência `tpEmis=9`;
- `retransmitir_nfces_pendentes()` trabalha sobre o mesmo documento/número;
- comando `processar_nfces_pendentes` disponível;
- interfaces de cancelamento/inutilização existem sem sucesso fictício;
- testes focados, `django check` e `makemigrations --check` aprovados.

## Regra de segurança operacional

Uma venda comercial já confirmada não deve ser reaberta por falha fiscal posterior.

Estados como `REJEITADA`, `ERRO_GERACAO` e `PENDENTE_TRANSMISSAO` representam problema fiscal pós-venda e devem permanecer rastreáveis, sem duplicar a operação comercial.

## Estado da NFC-e no desenvolvimento atual

A implementação prevista sem certificado real está **encerrada**.

Não existe nova fase interna obrigatória de desenvolvimento da NFC-e antes de avançar o roadmap do Hub. A próxima atividade fiscal desta frente somente ocorre quando houver condições reais de homologação externa.

## Pendências externas para homologação fiscal definitiva

Estas pendências **não bloqueiam o avanço atual do Sysvar Hub**:

- homologação real na SEFAZ com certificado A1 ICP-Brasil válido;
- configurar e validar endpoints oficiais aplicáveis por UF/ambiente;
- validar protocolo/transporte efetivamente exigido pelo serviço da SEFAZ da UF no momento da homologação;
- validar autorização, rejeição, contingência, DANFE e eventos com respostas oficiais;
- validar cancelamento/inutilização somente quando aplicáveis e com serviço oficial;
- revisar exigências vigentes da Reforma Tributária/IBS/CBS antes da homologação externa;
- nunca considerar o adapter de desenvolvimento como autorização fiscal real.

## Relacionados

- [[Planejamento]]
- [[Sysvar Hub]]
- [[Pendências e Melhorias]]
