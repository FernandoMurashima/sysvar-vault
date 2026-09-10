---
type: project-tracking
status: active
project: Sysvar
created: 2026-09-10
updated: 2026-09-10
tags:
  - sysvar
  - pendencias
  - melhorias
  - homologacao
  - revenda
  - compras
  - distribuicao
  - fiscal
  - estoque
---

# Pendências e Melhorias — Sysvar

## Objetivo deste documento

Centralizar pendências, melhorias de acabamento e pontos de revisão identificados durante homologações do Sysvar, para evitar perda de contexto entre etapas de desenvolvimento.

Este documento não representa falhas bloqueantes do fluxo já homologado. Quando um item for resolvido, deve ser marcado como concluído e, quando aplicável, registrar o commit correspondente.

---

# Fluxo de Revenda — Homologação concluída em 10/09/2026

## Status

~~~text
FLUXO OPERACIONAL COMPLETO
HOMOLOGADO DE PONTA A PONTA
PENDÊNCIAS RESTANTES: ACABAMENTO, ESCALA E REVISÃO FISCAL
~~~

## Processo validado

~~~text
Pedido de Compra
↓
Aprovação
↓
NF-e de entrada / XML
↓
Local Agent
↓
Recebimento na Fábrica / Almoxarifado
↓
Conferência física
↓
Efetivação do estoque
↓
Custos por SKU
↓
Distribuição
↓
Pedido de Venda de Distribuição por loja
↓
NF-e de saída
↓
Autorização
↓
Mercadoria em trânsito
↓
Recebimento na loja
↓
Entrada no estoque da loja
↓
Movimentação de estoque
~~~

## Massa utilizada na homologação

- 5 Pedidos de Compra de mercadoria de revenda;
- 5 fornecedores;
- 5 XMLs de NF-e de entrada;
- destino inicial: Fábrica;
- 17.580 peças recebidas;
- 990 SKUs;
- distribuição para 3 lojas;
- Loja Barra: 6.264 peças;
- Loja Tijuca: 5.830 peças;
- Loja Centro: 5.486 peças;
- custo total da distribuição: R$ 1.497.442,00;
- valor total de venda com fator de 20%: R$ 1.796.930,40;
- 3 Pedidos de Venda de Distribuição gerados;
- 3 NF-e de saída geradas e autorizadas;
- recebimento da Loja Barra validado com usuário Gerente da própria loja;
- isolamento por loja confirmado no recebimento;
- estoque e movimentação da loja confirmados após o recebimento.

Observação: a distribuição utilizada foi propositalmente muito grande para um cenário operacional normal. Isso ajudou a revelar pontos de UX e escala que provavelmente não apareceriam em uma distribuição pequena.

---

# Correções concluídas durante esta homologação

## Paginação completa da Distribuição

Status: CONCLUÍDO

Corrigido o carregamento incompleto causado por `page_size` fixo nas telas de:

- Distribuição;
- Pedidos de Venda de Distribuição;
- Mercadoria em Trânsito / Recebimento de Loja.

A paginação passou a percorrer `next` até o fim antes de calcular totais, indicadores, agrupamentos e paginação local.

Commit frontend:

`bd7997c Corrige paginacao completa na distribuicao`

## Saldo e valores por SKU na matriz

Status: CONCLUÍDO

- saldo igual a zero passou a ser preservado corretamente;
- Custo un. e Venda un. foram retirados do resumo geral;
- Custo un. e Venda un. passaram a ser exibidos por SKU;
- venda unitária segue `custo_unitario × (1 + fator_preco)`.

Commit frontend:

`d800ea0 Corrige saldo e valores por SKU na distribuicao`

## Persistência de custo no recebimento

Status: CONCLUÍDO

O novo fluxo de Recebimento de Mercadoria efetivava quantidade em estoque, mas não gravava corretamente custo no SKU.

Foi corrigida a persistência de:

- custo_original;
- custo_ultima_compra;
- custo_medio;
- custo_unitario na movimentação;
- custo_total na movimentação;
- custo_medio_apos.

Também foi criado o comando idempotente:

`python manage.py reparar_custos_recebimentos_mercadoria`

Reparação executada na base da homologação:

- 5 recebimentos analisados;
- 990 SKUs corrigidos;
- 990 movimentações corrigidas;
- 1 distribuição RASC/CALC atualizada;
- 990 itens da distribuição atualizados.

Commit backend:

`666178b Corrige custos no recebimento de mercadoria`

---

# Pendências e Melhorias

## P1 — Revisão fiscal completa da NF-e de saída

Status: PENDENTE

Antes de considerar a emissão fiscal pronta para produção real, fazer um pente fino utilizando o leiaute e regras oficiais vigentes da NF-e modelo 55.

Revisar no mínimo:

- campos obrigatórios;
- campos condicionais;
- identificação do emitente;
- destinatário;
- natureza da operação;
- CFOP;
- NCM;
- tributação por item;
- totais tributários;
- transporte;
- volumes;
- quantidade de volumes;
- espécie, peso, identificação e demais dados de volume quando aplicáveis;
- frete;
- chave de acesso;
- protocolo de autorização;
- ambiente de homologação/produção;
- XML gerado;
- consistência entre os dados persistidos e o XML enviado.

Não assumir obrigatoriedade universal de grupos condicionais. Conferir cada regra diretamente na especificação oficial aplicável no momento da revisão.

## P2 — Faturamento com seleção múltipla e autorização em lote

Status: PENDENTE

Hoje a tela de Faturamento possui checkbox visual, mas internamente trabalha com apenas uma NF-e selecionada por vez.

Necessidade:

- permitir selecionar várias NF-e;
- clicar uma única vez em Enviar / Autorizar;
- processar todas as NF-e selecionadas;
- apresentar resultado individual por documento;
- impedir cliques repetidos durante o processamento.

Evolução futura possível:

- agente/serviço automático que processe a fila de NF-e sem depender de ação manual.

A consulta/detalhamento individual da NF-e deve continuar separada da seleção múltipla para faturamento.

## P3 — Feedback visual em operações demoradas

Status: PENDENTE

Durante a homologação com 990 SKUs e 17.580 peças, algumas operações demoraram e a tela aparentou estar parada.

Aplicar indicador de processamento e bloqueio temporário de ações em operações como:

- Carregar para matriz;
- Confirmar distribuição;
- Gerar pedidos;
- Gerar NF-e;
- Enviar / Autorizar NF-e em lote quando implementado.

Exemplos de mensagens:

- `Carregando estoque. Aguarde...`
- `Confirmando distribuição. Aguarde...`
- `Gerando pedidos. Aguarde...`
- `Gerando NF-e. Aguarde...`
- `Autorizando NF-e. Aguarde...`

Objetivo principal: evitar dúvida do usuário e impedir reenvio por clique repetido.

## P4 — Compactar a matriz de Distribuição para uma linha por SKU

Status: PENDENTE

Hoje a identificação do item ocupa mais de uma linha, aumentando excessivamente a altura da matriz.

Objetivo futuro:

~~~text
SKU | Descrição | Código de barras | Cor | Tam. | Custo un. | Venda un. | Disp. | Loja 1 | Loja 2 | ... | Total | Saldo
~~~

Cada SKU deve ocupar uma única linha física.

Preservar:

- lojas dinâmicas;
- edição das quantidades;
- custo por SKU;
- venda por SKU;
- disponível;
- total;
- saldo;
- scroll horizontal;
- comportamento da matriz já homologado.

## P5 — Recebimento em Loja com tela própria de consulta da NF-e

Status: PENDENTE

Hoje a seleção de uma nota expande uma grade extensa de itens na mesma tela de listagem. Em notas grandes isso torna a tela longa e pouco prática.

Fluxo desejado:

~~~text
Lista de notas para recebimento
↓
Selecionar nota
↓
Consultar
↓
Tela própria da NF-e / Recebimento
~~~

Na tela própria, exibir:

### Cabeçalho

- NF-e;
- origem;
- loja destino;
- emissão/saída;
- status;
- chave de acesso;
- protocolo.

### Resumo da NF-e

- valor dos produtos;
- descontos;
- frete;
- valor total;
- quantidade de itens/SKUs;
- quantidade total de peças;
- volumes e dados de transporte quando existirem de forma válida;
- natureza da operação;
- resumo tributário.

### Itens / Conferência

- referência;
- descrição;
- cor;
- tamanho;
- EAN;
- enviado;
- recebido;
- valor unitário;
- total.

Ações:

- Tudo recebido;
- Zerar;
- Lançar no estoque.

Não apresentar valores fiscais inventados. Os dados do resumo devem vir do documento fiscal e do XML válido.

## P6 — Consulta por Referência: permitir consulta por coleção sem referência específica

Status: PENDENTE PARA DECISÃO/IMPLEMENTAÇÃO

Comportamento atual validado:

- Consulta por Referência exige referência/EAN para montar a grade;
- Loja, Coleção e Saldo apenas restringem a referência consultada;
- Consulta por Coleção é a modalidade que traz várias referências.

Melhoria proposta:

- Referência preenchida → consultar somente aquela referência;
- Referência vazia + Coleção preenchida → trazer todas as referências da coleção;
- Referência vazia + Coleção vazia → não carregar o estoque inteiro automaticamente.

Manter diferença de apresentação entre Consulta por Referência e Consulta por Coleção.

## P7 — Limitar carga da Movimentação de Estoque

Status: PENDENTE

A Movimentação de Estoque não deve carregar indiscriminadamente todo o histórico da empresa/loja à medida que a base crescer.

Revisar e garantir:

- usuário de loja vê somente movimentações das lojas permitidas;
- filtro por Loja quando o perfil permitir múltiplas lojas;
- filtro por Referência/EAN;
- Data inicial;
- Data final;
- filtro por tipo/origem quando aplicável;
- período padrão reduzido, evitando consulta de todo o histórico sem intenção explícita;
- paginação/carga compatível com grandes volumes.

Objetivo: impedir degradação progressiva da tela quando o histórico de estoque crescer.

## P8 — Formatação inteira na Conferência Física de mercadoria de revenda

Status: PENDENTE

Na conferência de mercadoria de revenda, quantidades de peças estavam sendo exibidas com 3 ou 4 casas decimais em diversos pontos.

Para mercadoria tratada como peça inteira, apresentar sem casas decimais:

- Qtd Pedido;
- Qtd NF-e;
- Qtd Física;
- NF-e x Pedido;
- Físico x NF-e;
- Físico x Pedido;
- Esperado;
- Recebido;
- Diferença;
- Última leitura da bipagem.

Preferir correção de apresentação/entrada sem alterar desnecessariamente os tipos decimais do banco utilizados por outros fluxos.

---

# Regras para manutenção deste documento

1. Toda melhoria identificada durante homologação que não for resolvida imediatamente deve ser incluída aqui.
2. Não reabrir fluxo homologado apenas porque existe uma melhoria de acabamento.
3. Quando uma pendência for resolvida:
   - alterar `Status: PENDENTE` para `Status: CONCLUÍDO`;
   - registrar o commit;
   - resumir a solução aplicada.
4. Se a pendência evoluir para decisão arquitetural relevante, criar ADR específico e deixar aqui o link para o ADR.
5. Se a pendência exigir homologação funcional própria, criar documento em `Homologações` e referenciá-lo aqui.

---

# Próxima leitura recomendada

Ao retomar melhorias do fluxo de revenda, consultar primeiro este documento e depois os documentos técnicos/homologações específicos de:

- Compras;
- Entrada de NF-e;
- Estoque;
- Distribuição;
- Fiscal;
- Recebimento em Loja.
