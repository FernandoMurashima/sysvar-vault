---
type: reference
status: active
project: Sysvar
source: "FernandoMurashima/sysvarbackend + FernandoMurashima/sysvarfrontend"
created: 2026-09-18
updated: 2026-09-18
tags:
  - sysvar
  - estoque
  - consultas
  - movimentacoes
  - sku
---

# Mapa Técnico - Estoque - Consultas e Movimentações

## Objetivo

Registrar o estado vigente das consultas e movimentações de estoque do [[Sysvar]].

## Modalidades de consulta

O módulo possui, entre outras, as seguintes consultas operacionais:

- Consulta por Referência;
- Consulta por Referência Uso/Consumo;
- Consulta por Coleção/Estação;
- Movimentação por Referência;
- Movimentação Uso/Consumo;
- Movimentações gerais.

Rotas principais do frontend:

~~~text
/estoque/consulta-referencia
/estoque/consulta-referencia-uso-consumo
/estoque/consulta-colest
/estoque/consulta-movimentacao-referencia
/estoque/movimentacao-uso-consumo
/estoque/movimentacoes
~~~

## Escopo por Empresa e Loja

As consultas respeitam:

- Empresa do usuário;
- Lojas explicitamente permitidas ao perfil/usuário;
- filtro de Loja quando o usuário pode trabalhar com mais de uma unidade.

Sugestões de referência também são limitadas ao estoque compatível com a Loja selecionada.

## Consulta por Referência

A busca por referência/EAN exige seleção explícita do resultado.

Não converter automaticamente texto digitado para a primeira sugestão.

A visualização principal utiliza matriz:

~~~text
Loja × Cor × Tamanho
~~~

Para cada célula são apresentados:

- Físico;
- Reservado;
- Disponível.

Também existem totais por tamanho e total geral.

Filtros vigentes incluem:

- Referência/EAN;
- Loja;
- Saldo;
- Coleção.

A modalidade de Referência não utiliza Estação como filtro direto.

Endpoint específico criado para reduzir carga e desacoplar a tela de consultas genéricas:

~~~text
GET /api/produto/estoque/consulta-referencia/
~~~

## Consulta por Coleção/Estação

Os filtros são encadeados:

~~~text
Estação
↓
Coleção
↓
Referência
~~~

A seleção de um nível restringe as opções válidas do nível seguinte.

A matriz é organizada por Referência × Loja e mostra:

- Físico;
- Reservado;
- Disponível;
- totais por referência;
- totais por Loja;
- total geral.

Endpoint específico:

~~~text
GET /api/produto/estoque/consulta-colecao/
~~~

## Uso/Consumo

Produtos de Uso/Consumo inativos continuam aparecendo quando possuem saldo.

O backend expõe o estado de atividade e o frontend identifica visualmente o item inativo.

Isso evita esconder patrimônio físico apenas porque o cadastro foi inativado.

## Movimentação por Referência

Filtros implementados incluem:

- referência/EAN;
- Loja;
- tipo;
- data inicial;
- data final.

As movimentações expõem:

- quantidade;
- saldo anterior;
- saldo posterior;
- documento;
- origem estruturada;
- cor;
- tamanho;
- demais dados de identificação do SKU quando disponíveis.

## Origem estruturada

`EstoqueMovimentacao.origem` é utilizada para identificar a causa da movimentação de forma estruturada.

O frontend traduz códigos conhecidos para texto operacional e usa `-` quando a origem está vazia.

A origem não deve ser inferida apenas pelo sinal da quantidade.

## Performance

As telas deixaram de depender de cargas genéricas com `page_size=5000`.

Princípios vigentes:

- usar endpoints específicos por modo de consulta;
- reduzir volume retornado;
- filtrar antes de carregar;
- evitar trazer todo o estoque ou todo o histórico sem necessidade;
- preservar paginação quando aplicável.

## Atualização manual

As consultas possuem ação `Atualizar` para repetir a consulta com os filtros correntes sem depender de recarregar a aplicação.

## Exportação

As consultas que oferecem exportação usam XLSX real no frontend, preservando o recorte apresentado ao usuário.

## Regras importantes

- não misturar estoque de Lojas não permitidas;
- não esconder item inativo que ainda possui saldo;
- não usar a primeira sugestão de referência sem confirmação;
- não substituir saldo físico por disponível;
- não confundir reservado com saída física;
- não carregar histórico indiscriminadamente.

## Commits de referência

Backend:

- `71f729ae` — filtros de movimentação por referência;
- `65bdc505` e `b426b265` — origem das movimentações;
- `cf98616e` — cor e tamanho;
- `96756904` — inativos com saldo;
- `57d46314` — endpoints específicos;
- `83f0db3a` — referências por Loja;
- `0be150d0` — filtro de coleção.

Frontend:

- `c9550be3` — filtros de movimentação;
- `289f1d02` — saldos anterior/posterior;
- `c8e419cf` e `af926149` — origem;
- `14e24900` — cor e tamanho;
- `c195e167` — inativos com saldo;
- `04a2832f` — endpoints específicos;
- `e051566a` — XLSX;
- `ef6d539f` — referências por Loja;
- `be952166` — filtros por Referência.

## Relacionados

- [[Sysvar]]
- [[Mapa Técnico - Estoque - Inventário]]
- [[Arquitetura]]
- [[Riscos e Cuidados]]
