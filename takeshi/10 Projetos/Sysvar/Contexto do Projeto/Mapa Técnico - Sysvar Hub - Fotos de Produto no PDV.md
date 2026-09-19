---
type: reference
status: active
project: Sysvar
source: "FernandoMurashima/sysvarhub-backend + FernandoMurashima/sysvarhub-frontend"
created: 2026-09-19
updated: 2026-09-19
tags:
  - sysvar
  - sysvar-hub
  - pdv
  - fotos
  - catalogo
  - offline
  - pendencia
---

# Mapa Técnico - Sysvar Hub - Fotos de Produto no PDV

## Status

**PENDENTE**

## Objetivo

Disponibilizar as fotos dos produtos no PDV do Sysvar Hub sem quebrar a premissa de operação local/offline da Loja.

A foto é uma capacidade operacional do catálogo/PDV e não uma etapa separada que altere a ordem principal de desenvolvimento do Hub.

## Estado atual confirmado

No contrato atual do Catálogo Operacional V1, imagem/foto ficou fora do escopo inicial.

No frontend atual do PDV Hub, a área **PRODUTO SELECIONADO** já existe, mas ainda exibe `assets/logosysvar.png` como imagem fixa de placeholder.

O modelo `PdvProdutoConsulta` também ainda não possui campo de foto/imagem.

Portanto, a exibição real da foto do produto no PDV do Hub ainda não está implementada.

## Pendência

Definir e implementar o fluxo completo da foto entre Sysvar Central e Sysvar Hub.

Revisar no mínimo:

- fonte oficial da foto no Sysvar Central;
- vínculo correto da foto com Produto/Referência/SKU, conforme a regra existente no Sysvar;
- contrato Central → Hub para informar a foto ou sua identidade;
- estratégia de armazenamento/cache local para funcionamento offline;
- atualização da foto quando a imagem mudar no Central;
- comportamento quando o produto não possuir foto;
- fallback visual seguro;
- limite de tamanho e impacto no armazenamento local;
- limpeza/inativação de imagens que deixarem de ser utilizadas;
- exibição da foto na área **PRODUTO SELECIONADO** do PDV;
- possibilidade futura de uso em consulta/listagem sem prejudicar desempenho;
- funcionamento com a internet desligada;
- atualização após nova sincronização.

## Regra arquitetural

O Sysvar Central continua sendo a autoridade da informação do produto e da associação da foto.

O Hub deve manter somente a cópia operacional necessária para a Loja funcionar localmente.

A venda não pode ser bloqueada pela ausência ou falha de carregamento de uma foto.

Não definir neste documento, antes da análise técnica, se a solução final será URL, arquivo sincronizado, cache por hash/versão ou outra estratégia. Essa decisão deve ser tomada depois da análise dos repositórios e da estrutura atual de imagens do Sysvar.

## Homologação futura

Quando implementado, validar:

1. produto com foto no Central aparece com a foto correta no PDV Hub;
2. produto sem foto usa fallback sem erro;
3. foto permanece disponível com a internet desligada;
4. troca da foto no Central é refletida no Hub após sincronização;
5. foto de um produto não aparece em outro produto/SKU indevidamente;
6. indisponibilidade de foto não impede busca, bipagem, carrinho ou venda;
7. desempenho do catálogo e do PDV permanece adequado.

## Relação com o planejamento

Esta pendência pertence à **Etapa 1 — Loja / Sysvar Hub**, integrada principalmente a:

- Sincronização Central → Hub;
- catálogo local;
- operação do PDV totalmente offline;
- homologação completa do Hub.

Ela não altera a sequência principal definida em [[Planejamento]].

## Relacionados

- [[Planejamento]]
- [[Sysvar Hub]]
- [[Pendências e Melhorias]]
