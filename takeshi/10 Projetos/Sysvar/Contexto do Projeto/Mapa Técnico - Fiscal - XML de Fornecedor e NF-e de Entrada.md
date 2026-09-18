---
type: reference
status: active
project: Sysvar
source: "FernandoMurashima/sysvarbackend + FernandoMurashima/sysvarfrontend"
created: 2026-09-18
updated: 2026-09-18
tags:
  - sysvar
  - fiscal
  - nfe
  - xml
  - fornecedor
  - entrada
---

# Mapa Técnico - Fiscal - XML de Fornecedor e NF-e de Entrada

## Objetivo

Registrar o fluxo vigente de XML de fornecedor detectado, classificação de tratamento e materialização da NF-e de entrada no [[Sysvar]].

## Origem do XML

O XML pode ser detectado automaticamente pelo [[Mapa Técnico - Integrações - Local Agent]].

O agente lê o arquivo no ambiente local e envia metadados ao Sysvar.

Entidade central de detecção:

~~~text
XmlFornecedorRecebido
~~~

## Configuração de pastas

As pastas monitoradas são administradas pelo Sysvar por Empresa/Loja e disponibilizadas ao Local Agent.

A configuração não deve gerar múltiplas estruturas contraditórias para a mesma finalidade.

## Proteção contra duplicidade

A chave de acesso e a identidade fiscal do documento são usadas para impedir importações duplicadas indevidas.

A proteção considera o ciclo de vida do documento: recusa/cancelamento operacional válido não deve manter bloqueio incorreto de uma chave quando a regra vigente permitir novo tratamento.

## Dados estruturados do XML

O XML detectado passou a materializar dados fiscais estruturados necessários ao tratamento posterior.

A estrutura suporta quantidades do XML com até quatro casas decimais quando o documento fiscal assim trouxer.

Os dados estruturados são usados para:

- identificação do fornecedor;
- itens;
- quantidades;
- valores;
- vínculos com Pedido;
- conferência;
- efetivação fiscal.

## Classificação de tratamento

O XML detectado recebe classificação de tratamento antes da efetivação.

O objetivo é permitir distinguir cenários como:

- entrada vinculada a Pedido;
- documento que deve seguir tratamento fiscal sem estoque;
- documento que exige encaminhamento para o fluxo físico de recebimento.

A classificação não deve inventar movimentação física quando o cenário é somente fiscal.

## Materialização da NF-e

A partir do XML detectado, o sistema pode materializar a estrutura de `NotaFiscalEntrada` e seus itens/vínculos.

O frontend possui ação de encaminhamento do XML detectado para o tratamento fiscal correspondente.

## Efetivação fiscal sem estoque

O fluxo foi ajustado para permitir efetivação fiscal quando o documento não deve movimentar estoque.

Regra importante:

~~~text
EFETIVAÇÃO FISCAL
não implica obrigatoriamente
ENTRADA FÍSICA NO ESTOQUE
~~~

Essa separação é necessária para documentos que precisam existir fiscal/financeiramente sem representar mercadoria recebida no estoque de revenda.

## Vínculos do XML detectado

A API expõe os vínculos relevantes do XML detectado para que o frontend saiba se o documento já possui:

- Nota Fiscal de Entrada;
- recebimento físico;
- Pedido(s) relacionados;
- tratamento já aplicado.

A interface deve derivar ações desses vínculos e não apenas de flags visuais locais.

## Cancelamento

O cancelamento foi refinado para separar responsabilidades fiscais e operacionais e, na interface, evitar múltiplas ações redundantes para o mesmo objetivo do usuário.

Não confundir:

- cancelar/abandonar um processo provisório de entrada;
- cancelar documento fiscal já efetivado/autorizado quando a regra fiscal aplicável exigir operação própria;
- cancelar recebimento físico.

São conceitos relacionados, porém distintos.

## Tela de XML/NF-e detectada

Rota principal:

~~~text
/estoque/nfe-detectadas
~~~

A tela serve como painel dos XMLs encontrados e seus tratamentos/vínculos.

## Navegação

A navegação foi reorganizada para separar:

- documento detectado;
- tratamento fiscal;
- recebimento físico;
- consulta das estruturas materializadas.

## Integrações

O fluxo cruza:

- Fiscal;
- Compras;
- Estoque;
- Financeiro;
- Fornecedores;
- Auditoria.

## Regras críticas

- não processar a mesma NF-e como nova silenciosamente;
- não confundir detecção de XML com entrada física;
- não exigir movimentação de estoque para todo tratamento fiscal;
- não perder vínculos após materialização;
- não permitir que cancelamento físico apague histórico fiscal;
- não inventar dados ausentes do XML;
- manter Empresa/Loja/Fornecedor coerentes.

## Commits de referência

Backend:

- `5d50c53a` — XML fornecedor recebido;
- `a1126e59` — permissões Fiscal/Compras;
- `f0eb8543` / `b1699653` — configuração de pasta;
- `b31ffe75` — proteção contra duplicidade;
- `a67fad04` — classificação de tratamento;
- `9df63cce` — dados fiscais estruturados;
- `b0dc9db7` — quantidades com quatro casas;
- `b545f8d8` — materialização fiscal;
- `fa501d54` — efetivação de XML detectado;
- `d959c101` — cancelamento fiscal sem estoque;
- `c02858e7` — tratamento exposto na Nota de Entrada;
- `33ef57c9` — vínculos do XML detectado;
- `da907eae` / `b4f8bf93` — refinamento do cancelamento.

Frontend:

- `a27fa1b4` — painel de NF-e detectada;
- `bee5c650` — seleção de tratamento;
- `c781154a` — encaminhamento fiscal;
- `c6dc8f6b` — efetivação fiscal sem estoque;
- `ac5a44f4` — navegação de NF-e;
- `a3b971c2` — ações da tela;
- `bc56fbb9` / `4fe75ada` — refinamento visual do cancelamento;
- `b00f8afd` — reflexo financeiro de NF-e cancelada.

## Relacionados

- [[Mapa Técnico - Compras - Entrada de NF-e]]
- [[Modelo de Domínio - Compras - Entrada de NF-e]]
- [[Workflows - Compras - Entrada de NF-e]]
- [[Riscos e Cuidados - Compras - Entrada de NF-e]]
- [[Mapa Técnico - Compras - Recebimento de Mercadoria]]
- [[Mapa Técnico - Integrações - Local Agent]]
