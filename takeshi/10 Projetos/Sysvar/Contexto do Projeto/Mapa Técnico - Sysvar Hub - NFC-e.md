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
→ futuramente transmite à SEFAZ real
→ futuramente sincroniza documento/eventos com o Central

Sysvar Central
→ autoridade dos cadastros e parâmetros fiscais
→ envia configuração fiscal e mapas tPag
→ futuramente recebe NFC-e/XML/status/eventos do Hub
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

## Regra de segurança operacional

Uma venda comercial já confirmada não deve ser reaberta por falha fiscal posterior.

Estados como `REJEITADA`, `ERRO_GERACAO` e `PENDENTE_TRANSMISSAO` representam problema fiscal pós-venda e devem permanecer rastreáveis, sem duplicar a operação comercial.

## Fase 3 — PRÓXIMA

Próximo escopo:

- sincronização NFC-e Hub → Central;
- XML, chave, série, número, status, protocolo e eventos fiscais;
- idempotência e retry no Central;
- proteção contra duplicidade;
- adapter SEFAZ real por UF/ambiente;
- armazenamento/leitura protegida do certificado A1;
- política de retransmissão dos documentos pendentes/contingência;
- autorização real, rejeições reais e protocolo real;
- cancelamento/inutilização quando aplicáveis;
- homologação externa com empresa real e credenciais válidas.

## Pendências obrigatórias antes do fechamento fiscal definitivo

- homologação real na SEFAZ com certificado A1 ICP-Brasil válido;
- validar URLs e comportamento por UF/ambiente;
- validar autorização, rejeição, contingência, DANFE e eventos com resposta oficial;
- revisar exigências vigentes da Reforma Tributária/IBS/CBS antes da homologação externa;
- nunca considerar o adapter de desenvolvimento como autorização fiscal real.

## Relacionados

- [[Planejamento]]
- [[Sysvar Hub]]
- [[Pendências e Melhorias]]
