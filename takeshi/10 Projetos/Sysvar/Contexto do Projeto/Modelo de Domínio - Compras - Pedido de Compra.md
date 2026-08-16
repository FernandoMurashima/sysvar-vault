---
type: domain-model
status: approved
project: Sysvar
group: Compras
module: Pedido de Compra
phase: Fase 1
created: 2026-08-16
updated: 2026-08-16
tags:
  - sysvar
  - compras
  - pedido-de-compra
  - revenda
  - uso-consumo
  - insumo
  - financeiro
  - fiscal
  - recebimento
  - auditoria
  - multiempresa
  - dominio
  - homologado
---

# Modelo de Domínio - Compras - Pedido de Compra

## 1. Identificação

- **Projeto:** [[Sysvar]]
- **Módulo:** Compras
- **Funcionalidade:** Pedido de Compra
- **Tipos contemplados:** Revenda, Uso/Consumo e Insumo
- **Escopo:** Fase 1 — Pedido de Compra unificado
- **Situação:** IMPLEMENTADO E HOMOLOGADO
- **Data da homologação:** 16/08/2026

### Documentos relacionados

- [[Sysvar]]
- [[Mapa Técnico - Compras - Pedido de Compra]]
- [[Workflows - Compras - Pedido de Compra]]
- [[Riscos e Cuidados - Compras - Pedido de Compra]]
- [[Homologação - Compras - Pedido de Compra]]

---

# 2. Objetivo do Modelo de Domínio

O domínio de Pedido de Compra representa a intenção formal de aquisição de produtos por uma Empresa do [[Sysvar]].

Seu objetivo é estruturar:

- quem compra;
- de quem compra;
- para qual Loja;
- quais produtos serão adquiridos;
- em quais quantidades;
- por quais valores;
- em quais condições de pagamento;
- qual o estado do Pedido;
- como ocorre sua aprovação;
- como se relaciona com Financeiro;
- como se relaciona com Fiscal;
- como seu atendimento é acompanhado.

O Pedido de Compra não representa, por si só:

- entrada física de estoque;
- Nota Fiscal;
- pagamento;
- baixa financeira.

Esses eventos pertencem aos respectivos módulos integrados.

---

# 3. Agregado principal

A raiz do agregado é:

`PedidoCompra`

Estruturas diretamente relacionadas:

- `PedidoCompraItem`
- `PedidoCompraParcela`
- `PedidoCompraEntrega`

Estruturas externas integradas:

- Empresa
- Loja
- Fornecedor
- Produto
- Cor
- Pack
- FormaPagamento
- PrazoPagamento
- Nat_Lancamento
- Pagar
- PagarItem
- Nota Fiscal de Entrada
- Auditoria

Representação conceitual:

~~~text
PedidoCompra
├── PedidoCompraItem
│   └── PedidoCompraEntrega
├── PedidoCompraParcela
├── Empresa
├── Loja
├── Fornecedor
└── Integrações
    ├── Produto
    ├── Financeiro
    ├── Fiscal
    └── Auditoria
~~~

---

# 4. Entidade PedidoCompra

Entidade principal:

`compras.models.PedidoCompra`

Tabela:

`compras_pedido_compra`

Responsabilidade:

representar o cabeçalho e o estado geral da compra.

Campos principais:

- `empresa`
- `tipo`
- `loja`
- `fornecedor`
- `emissao`
- `previsao_entrega`
- `forma_pagamento`
- `prazo_pagamento`
- `status`
- `total_itens`
- `total_desconto`
- `frete`
- `total_pedido`
- `observacoes`
- `data_cadastro`

---

# 5. Identidade do Pedido

A identidade técnica é:

`PedidoCompra.id`

O Pedido deve ser tratado como entidade persistente própria.

Mesmo após aprovação, recebimento ou cancelamento, sua identidade deve ser preservada para histórico e integrações.

---

# 6. Empresa

Relacionamento:

`PedidoCompra.empresa`

A Empresa representa o tenant ao qual o Pedido pertence.

Toda operação deve respeitar esse vínculo.

O Pedido não pode utilizar relacionamentos incompatíveis com sua Empresa.

Isso inclui, conforme aplicável:

- Loja;
- Fornecedor;
- Natureza;
- Forma de Pagamento;
- Prazo;
- Produtos;
- Financeiro;
- Recebimentos.

---

# 7. Loja

Relacionamento:

`PedidoCompra.loja`

A Loja identifica o estabelecimento relacionado à compra.

Ela também participa da determinação da Empresa do Pedido.

A Loja deve pertencer ao contexto empresarial permitido ao usuário.

---

# 8. Fornecedor

Relacionamento:

`PedidoCompra.fornecedor`

Fornecedor representa a origem comercial da aquisição.

Para criação e edição em estado AB, devem ser respeitadas validações como:

- fornecedor ativo;
- fornecedor não bloqueado;
- compatibilidade de Empresa.

Fornecedor inválido não deve ser aceito apenas porque o frontend o enviou.

---

# 9. Tipo do Pedido

Campo:

`PedidoCompra.tipo`

Estados possíveis:

~~~text
''  = Não definido
'1' = Revenda
'2' = Uso/Consumo
'4' = Insumo
~~~

O tipo não é escolhido diretamente pelo usuário.

Ele é derivado do primeiro item incluído.

---

# 10. Tipo não definido

Um Pedido recém-criado pode existir com:

~~~text
tipo = ''
~~~

Esse estado significa:

**Pedido ainda sem definição de natureza de compra.**

Ele deve existir somente enquanto não houver item que determine seu tipo.

---

# 11. Definição pelo primeiro item

Quando o primeiro `PedidoCompraItem` é criado:

~~~text
PedidoCompra.tipo = Produto.tipo_produto
~~~

desde que o produto pertença aos tipos permitidos para Compras.

A partir desse momento, o Pedido passa a possuir uma identidade funcional de tipo.

---

# 12. Homogeneidade dos itens

Todos os itens do mesmo Pedido devem possuir o mesmo tipo de produto.

Invariante:

~~~text
para todo item do Pedido:
item.produto.tipo_produto == pedido.tipo
~~~

Não são válidas combinações como:

- Revenda + Uso/Consumo;
- Revenda + Insumo;
- Uso/Consumo + Insumo.

---

# 13. Tipos permitidos em Compras

Produtos permitidos:

~~~text
1 = Revenda
2 = Uso/Consumo
4 = Insumo
~~~

Produto:

~~~text
3 = Fabricação Própria
~~~

não participa do domínio de Pedido de Compra.

Sua origem pertence ao processo de Produção.

---

# 14. Estado do Pedido

Campo:

`PedidoCompra.status`

Estados:

~~~text
AB = Aberto
AP = Aprovado
AT = Atendido
CA = Cancelado
~~~

Esses estados representam o ciclo de vida do Pedido.

---

# 15. Estado AB — Aberto

AB representa Pedido ainda editável.

Permite, dentro das regras vigentes:

- alterar cabeçalho;
- incluir itens;
- alterar itens;
- excluir itens;
- definir Forma de Pagamento;
- definir Prazo;
- alterar frete;
- alterar desconto geral;
- excluir o Pedido.

AB é o único estado normal de manutenção estrutural.

---

# 16. Estado AP — Aprovado

AP representa Pedido formalmente aprovado.

Consequências:

- composição do Pedido deixa de ser livremente editável;
- integração financeira já foi gerada;
- Pedido passa a aguardar atendimento/recebimento.

AP pode permanecer mesmo com recebimento parcial.

---

# 17. Estado AT — Atendido

AT representa Pedido integralmente recebido.

O estado deve refletir atendimento total do Pedido.

Ele não deve ser usado apenas porque houve alguma entrada parcial.

---

# 18. Estado CA — Cancelado

CA representa Pedido cancelado.

O cancelamento preserva histórico.

Não deve ser tratado como exclusão física.

---

# 19. Entidade PedidoCompraItem

Entidade:

`compras.models.PedidoCompraItem`

Tabela:

`compras_pedido_compra_item`

Responsabilidade:

representar cada linha de aquisição do Pedido.

Campos principais:

- `pedido`
- `produto`
- `cor`
- `pack`
- `n_packs`
- `descricao_livre`
- `qtd`
- `preco_unit`
- `desconto_valor`
- `total_item`
- `observacoes`

---

# 20. Produto no item

Relacionamento:

`PedidoCompraItem.produto`

Produto é obrigatório para o fluxo homologado.

O Produto determina:

- participação ou não em Compras;
- tipo do Pedido;
- regras de quantidade;
- Unidade;
- comportamento de Revenda versus Uso/Consumo/Insumo.

---

# 21. Item de Revenda

Quando:

~~~text
pedido.tipo = '1'
~~~

o item utiliza:

- Produto;
- Cor;
- Pack;
- número de Packs;
- quantidade calculada;
- preço unitário;
- desconto;
- total;
- observação.

---

# 22. Cor em Revenda

Relacionamento:

`PedidoCompraItem.cor`

Cor é necessária no fluxo de Revenda.

Ela identifica a variação comercial relacionada ao Pack e ao recebimento.

Não é utilizada como elemento operacional obrigatório em Uso/Consumo ou Insumo.

---

# 23. Pack em Revenda

Relacionamento:

`PedidoCompraItem.pack`

Pack representa a composição de quantidades por grade/tamanho utilizada na aquisição de produto de Revenda.

O Pack permite transformar:

~~~text
número de Packs