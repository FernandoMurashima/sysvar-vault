---
type: domain-model
status: approved
project: Sysvar
group: Compras
module: Entrada de NF-e
phase: Fase 1
created: 2026-08-18
updated: 2026-08-27
tags:
  - sysvar
  - compras
  - entrada-nfe
  - nota-fiscal
  - forma-pagamento-fiscal
  - recusa-entrada
  - divergencia
  - conferencia
  - conciliacao
  - produto-fornecedor
  - xml
  - recebimento
  - estoque
  - financeiro
  - custos
  - revenda
  - uso-consumo
  - insumo
  - auditoria
  - multiempresa
  - dominio
  - homologado
---

# Modelo de Domínio - Compras - Entrada de NF-e

## 1. Identificação

- **Projeto:** [[Sysvar]]
- **Módulo:** Compras
- **Funcionalidade:** Entrada de NF-e
- **Tipos contemplados:** Revenda, Uso/Consumo e Insumo
- **Situação:** IMPLEMENTADO E HOMOLOGADO
- **Data da homologação:** 27/08/2026

### Documentos relacionados

- [[Sysvar]]
- [[Mapa Técnico - Compras - Pedido de Compra]]
- [[Modelo de Domínio - Compras - Pedido de Compra]]
- [[Workflows - Compras - Pedido de Compra]]
- [[Mapa Técnico - Compras - Entrada de NF-e]]
- [[Workflows - Compras - Entrada de NF-e]]
- [[Riscos e Cuidados - Compras - Entrada de NF-e]]
- [[Homologação - Compras - Entrada de NF-e]]

---

# 2. Objetivo do Modelo de Domínio

O domínio de Entrada de NF-e representa o recebimento fiscal e operacional de produtos no Sysvar.

A entrada pode ocorrer:

- vinculada a Pedido de Compra;
- sem Pedido de Compra.

No fluxo atual, o XML da NF-e é a principal fonte da verdade fiscal do documento recebido.

A Entrada de NF-e integra:

- XML;
- identificação fiscal;
- fornecedor;
- Produto × Fornecedor;
- conversão de unidade;
- conciliação;
- conferência física;
- divergências;
- Pedido de Compra, quando houver;
- estoque;
- custos;
- financeiro;
- recebimento;
- cancelamento;
- recusa de importação provisória;
- auditoria.

A Nota Fiscal de Entrada preserva:

- identidade fiscal;
- chave de acesso;
- dados fiscais recebidos;
- histórico;
- rastreabilidade;
- efeitos operacionais;
- cancelamento;
- auditoria.

---

# 3. Agregado principal

A raiz do agregado é:

`NotaFiscalEntrada`

Estrutura diretamente subordinada:

`NotaFiscalEntradaItem`

Estruturas externas e relacionadas:

- Empresa
- Loja
- Fornecedor
- Produto
- Produto × Fornecedor
- PedidoCompra, quando houver
- PedidoCompraItem, quando houver
- PedidoCompraEntrega, quando houver
- Cor
- Pack
- SKU
- Estoque
- ProdutoUsoConsumoEstoque
- movimentações de estoque
- conciliação
- conferência física
- divergências
- cobrança fiscal
- forma de pagamento fiscal
- Pagar
- PagarItem
- Auditoria

Representação conceitual:

~~~text
NotaFiscalEntrada
├── NotaFiscalEntradaItem
│   └── PedidoCompraItem
├── PedidoCompra
│   ├── Empresa
│   ├── Loja
│   └── Fornecedor
└── Integrações
    ├── Estoque
    ├── Custos
    ├── Financeiro
    ├── Recebimento
    └── Auditoria
~~~

---

# 4. Entidade NotaFiscalEntrada

Entidade principal:

`fiscal.models.NotaFiscalEntrada`

Responsabilidade:

representar o documento fiscal de entrada e controlar seu ciclo operacional.

Campos principais:

- `pedido_compra`
- `modelo`
- `serie`
- `numero`
- `chave_acesso`
- `dt_emissao`
- `dt_entrada`
- `status`
- `valor_produtos`
- `valor_desconto`
- `valor_frete`
- `valor_total`
- `observacoes`
- `criado_por`
- timestamps

---

# 5. Identidade técnica

A identidade técnica principal da entidade é:

`NotaFiscalEntrada.id`

Esse ID deve permanecer estável durante todo o ciclo da nota.

Ele é utilizado também para garantir rastreabilidade técnica de movimentações de estoque.

Movimento de entrada:

~~~text
NFE:<id>:ENTRADA
~~~

Movimento de cancelamento:

~~~text
NFE:<id>:CANCEL
~~~

O número comercial da NF não deve ser usado sozinho para determinar identidade técnica.

---

# 6. Identidade documental

A identidade documental homologada considera:

~~~text
Empresa
+ Fornecedor
+ Modelo
+ Série
+ Número
~~~

O Pedido de Compra não compõe essa identidade.

Isso significa que uma mesma combinação documental não pode ser registrada novamente apenas porque foi associada a outro Pedido.

---

# 7. Chave de acesso

`chave_acesso` representa a identidade fiscal principal da NF-e importada.

No lançamento manual, pode permanecer ausente quando o fluxo permitir.

Quando informada ou importada:

- deve possuir 44 dígitos;
- deve possuir formato fiscal válido;
- deve respeitar a validação da chave;
- deve ser única dentro das regras de isolamento da aplicação.

Estados relevantes:

~~~text
NF AB válida
→ chave ocupada

NF FE
→ chave ocupada

NF CA após efetivação
→ chave continua ocupada

Importação provisória recusada
→ chave liberada
~~~

Cancelar uma NF efetivada não libera sua chave.

Recusar uma importação XML provisória elegível libera a chave e permite nova importação do mesmo XML.

---

# 8. Relação com PedidoCompra

Relacionamento:

`NotaFiscalEntrada.pedido_compra`

O vínculo com Pedido de Compra é opcional.

Fluxos válidos:

~~~text
NF-e com Pedido
NF-e sem Pedido
~~~

Quando houver Pedido, ele participa das validações de:

- Empresa;
- Loja;
- Fornecedor;
- itens;
- quantidade;
- saldo restante;
- preço aprovado;
- recebimentos anteriores.

Representação:

~~~text
NotaFiscalEntrada
        │
        ├── PedidoCompra, quando houver
        │      ├── Empresa
        │      ├── Loja
        │      └── Fornecedor
        │
        └── Entrada sem Pedido
               ├── Empresa
               ├── Fornecedor
               └── destino operacional
~~~

O Pedido não compõe a identidade fiscal da NF-e.

---

# 9. Empresa

Toda NotaFiscalEntrada pertence a uma Empresa.

A Empresa é a fronteira obrigatória do tenant, exista ou não Pedido de Compra.

A NF não pode:

- utilizar Pedido de outra Empresa;
- utilizar Fornecedor de outra Empresa;
- utilizar Produto ou vínculo Produto × Fornecedor de outro tenant;
- expor seus dados a usuário de outra Empresa;
- contaminar estoque;
- contaminar financeiro;
- contaminar conciliação;
- contaminar conferência;
- contaminar cancelamento ou recusa de outra Empresa.

---

# 10. Loja

A Loja representa o destino operacional da entrada.

Quando houver Pedido, deve ser compatível com a Loja definida nele.

Quando não houver Pedido, deve ser determinada dentro do contexto autorizado da Empresa.

Ela participa principalmente de:

- destino do estoque;
- configuração de estoque negativo;
- segregação operacional da entrada.

A Loja deve pertencer à mesma Empresa da NotaFiscalEntrada.

---

# 11. Fornecedor

O Fornecedor pertence ao contexto fiscal da NF-e.

No fluxo XML, sua identificação decorre dos dados fiscais do emitente.

Quando houver Pedido de Compra, o Fornecedor da NF deve ser compatível com o Fornecedor do Pedido.

No lançamento manual, ele continua participando da identidade documental composta por:

~~~text
Empresa
+ Fornecedor
+ Modelo
+ Série
+ Número
~~~

No fluxo XML, a chave de acesso é a identidade fiscal principal do documento.

---

# 12. Entidade NotaFiscalEntradaItem

Entidade:

`NotaFiscalEntradaItem`

Responsabilidade:

representar um item fiscal recebido dentro de determinada NotaFiscalEntrada.

O item pode existir:

- conciliado com item de Pedido;
- sem Pedido de Compra;
- conciliado diretamente com Produto interno.

No fluxo XML devem ser preservados, conforme disponíveis:

- código do Produto no Fornecedor;
- descrição fiscal;
- GTIN/EAN;
- unidade comercial;
- quantidade fiscal;
- preço fiscal;
- total fiscal.

O cadastro interno não deve sobrescrever a verdade fiscal do XML.

---

# 13. Relação com PedidoCompraItem

O vínculo com PedidoCompraItem é obrigatório somente quando a NF-e estiver vinculada a Pedido.

Nesse caso:

~~~text
NotaFiscalEntrada.pedido_compra
=
NotaFiscalEntradaItem.pedido_item.pedido
~~~

Não é permitida combinação entre itens de Pedidos diferentes.

Quando não houver Pedido:

~~~text
Item XML
↓
Produto × Fornecedor
↓
Produto interno
~~~

A ausência de Pedido não elimina a necessidade de conciliação antes da efetivação.

---

# 14. XML, Produto × Fornecedor e conciliação

No fluxo XML, o documento recebido é a fonte da verdade fiscal.

Regra:

~~~text
XML
→ verdade fiscal

Cadastro interno
→ interpretação operacional
~~~

Os dados fiscais originais não devem ser sobrescritos silenciosamente.

## Produto × Fornecedor

O domínio mantém associação permanente entre:

~~~text
Fornecedor
+
Código externo
→
Produto interno
~~~

O mesmo código externo pode representar Produtos diferentes para Fornecedores diferentes.

O vínculo pode manter:

- Produto interno;
- unidade utilizada pelo Fornecedor;
- fator de conversão;
- situação do vínculo.

O relacionamento é reutilizado em importações futuras.

## Conversão de unidade

A unidade comercial do XML pode ser diferente da unidade interna.

Exemplo:

~~~text
1 PCT = 100 UN

XML:
100 PCT

Estoque:
10.000 UN
~~~

A quantidade fiscal original permanece preservada.

## Conciliação

Conciliação relaciona o item fiscal ao Produto interno correto.

~~~text
Item XML
↓
Produto × Fornecedor existente?
├── sim → utilizar vínculo
└── não → resolver conciliação
               ↓
         vínculo pode ser salvo
~~~

Item XML sem Produto conciliado bloqueia a efetivação.

## Conferência física

A conferência registra a quantidade efetivamente recebida.

Ela não altera a quantidade fiscal constante no XML.

Quando houver diferença:

~~~text
quantidade fiscal
!=
quantidade conferida
→ divergência
~~~

A divergência deve ser registrada e tratada.

## Lançamento manual

O mecanismo de checkbox `OK` pertence ao lançamento manual anteriormente homologado e permanece válido enquanto esse fluxo for aplicável.

Nesse caso:

~~~text
Checkbox desmarcado
→ item ainda não persistido

Checkbox marcado
→ item persistido
~~~

---

# 15. Quantidade recebida

Campo:

`qtd_recebida`

Representa a quantidade daquele item recebida na NF atual.

A quantidade deve respeitar:

- valor não negativo;
- saldo disponível;
- recebimentos anteriores;
- regras de Pack, quando aplicáveis.

---

# 16. Quantidades do domínio de recebimento

Para cada item, o sistema trabalha conceitualmente com:

- quantidade pedida;
- quantidade recebida em outras NFs válidas;
- saldo pendente;
- quantidade desta NF.

Representação:

~~~text
Quantidade pedida
- quantidade recebida anteriormente
= saldo pendente
~~~

Quando houver Pedido, a quantidade fiscal pode ser importada e conferida mesmo acima do saldo restante, pois o sistema preserva a verdade recebida.

Porém:

~~~text
quantidade NF > saldo restante do Pedido
→ alerta
→ efetivação bloqueada
~~~

A validação definitiva ocorre novamente no backend.

---

# 17. Recebimento parcial

Uma NF não precisa atender integralmente o Pedido.

Exemplo:

~~~text
Pedido = 100

NF 1 = 60
NF 2 = 40
~~~

O domínio permite várias NFs vinculadas ao mesmo Pedido.

---

# 18. Status da NotaFiscalEntrada

Estados operacionais:

~~~text
AB = Aberta
FE = Fechada / efetivada
CA = Cancelada
~~~

## AB

Representa entrada ainda não efetivada.

Pode permanecer nesse estado durante:

- importação;
- conciliação;
- conferência;
- análise de divergências;
- preparação para efetivação.

## FE

Representa NF efetivada.

Seus efeitos passam a integrar, conforme o caso:

- estoque;
- custos;
- financeiro;
- recebimento do Pedido.

## CA

Representa NF efetivada e posteriormente cancelada.

A entidade permanece persistida para histórico e rastreabilidade.

## Estado operacional e finalidade fiscal

~~~text
status operacional
!=
finalidade fiscal
~~~

Um XML pode permanecer AB e possuir finalidade fiscal que impeça sua efetivação no fluxo normal.

Exemplo homologado:

~~~text
finNFe = 4
→ devolução
→ importação permitida
→ efetivação normal bloqueada
~~~

---

# 19. Transição AB → FE

Transição de fechamento:

~~~text
AB
↓
validações
↓
estoque
↓
custos
↓
financeiro
↓
recebimento
↓
FE
~~~

A operação deve ser atômica.

---

# 20. Transição FE → CA

Transição de cancelamento:

~~~text
FE
↓
validações
↓
estorno de estoque
↓
recalculo de custos
↓
reversão/recalculo financeiro
↓
recalculo do recebimento
↓
CA
~~~

Também deve ser atômica.

---

# 21. Exclusão física, cancelamento e recusa

DELETE direto de NotaFiscalEntrada é bloqueado no fluxo operacional normal.

Para NF efetivada, o desfazimento ocorre por:

**Cancelar NF**

O cancelamento preserva:

- documento;
- itens;
- chave;
- histórico;
- identidade;
- rastreabilidade.

Para uma importação XML ainda provisória e elegível existe:

**Recusar entrada**

Fluxo:

~~~text
XML importado
↓
NF AB
↓
sem efeitos operacionais incompatíveis
↓
Recusar entrada
↓
registro provisório removido
↓
chave liberada
~~~

Recusar entrada:

- não movimenta estoque;
- não gera financeiro;
- não atualiza Pedido;
- não cria NF cancelada;
- permite nova importação do mesmo XML;
- deve ser atômica;
- deve respeitar multiempresa.

Regra:

~~~text
Recusar entrada
!=
Cancelar NF
~~~

---

# 22. Valor bruto do item

Regra:

~~~text
valor_bruto =
qtd_recebida × preco_unit_nf
~~~

---

# 23. Desconto do item

`desconto_item` deve satisfazer:

~~~text
desconto_item >= 0
~~~

e:

~~~text
desconto_item <= valor_bruto
~~~

É permitido:

~~~text
desconto_item = valor_bruto
~~~

---

# 24. Total do item

Regra:

~~~text
total_item =
valor_bruto - desconto_item
~~~

Invariante:

~~~text
total_item >= 0
~~~

O backend é responsável por proteger essa regra.

---

# 25. Totais da NF

A NotaFiscalEntrada mantém:

- valor dos produtos;
- desconto;
- frete;
- total final.

Representação vigente:

~~~text
valor_total =
valor_produtos
- valor_desconto
+ valor_frete
~~~

Invariante:

~~~text
valor_total >= 0
~~~

---

# 26. Datas

Campos:

- `dt_emissao`
- `dt_entrada`

Invariante:

~~~text
dt_entrada >= dt_emissao
~~~

---

# 27. Tipo de compra

Tipos suportados:

~~~text
1 = Revenda
2 = Uso/Consumo
4 = Insumo
~~~

Quando houver Pedido, seu tipo participa das validações.

Quando não houver Pedido, o tratamento operacional decorre dos Produtos internos conciliados e das regras do domínio.

Fabricação Própria não participa do fluxo normal de Compras.

---

# 28. Revenda

No tipo Revenda, o domínio envolve:

- Produto;
- Cor;
- Pack;
- tamanho;
- SKU.

A quantidade recebida deve ser compatível com a composição do Pack.

No fechamento, a entrada é distribuída pelos SKUs correspondentes.

---

# 29. SKU

Para Revenda, o estoque efetivo é controlado por SKU.

O SKU representa a combinação específica de características do produto, incluindo tamanho e cor conforme o modelo vigente.

A movimentação deve atingir exatamente os SKUs correspondentes aos itens recebidos.

---

# 30. Pack

O Pack determina a distribuição das unidades de Revenda.

A quantidade recebida precisa resultar em distribuição válida.

O cancelamento deve estornar exatamente a mesma composição de SKUs anteriormente movimentada.

---

# 31. Uso/Consumo

Uso/Consumo utiliza quantidade direta.

O domínio não depende de Pack.

Produto:

~~~text
tipo_produto = 2
~~~

utiliza o estoque dedicado de Uso/Consumo.

A regra depende do tipo do Produto, não da origem da compra.

~~~text
Pedido gerado por Cotação
ou
Pedido manual
ou
NF sem Pedido
↓
Produto tipo 2
↓
estoque dedicado de Uso/Consumo
~~~

Quando houver Pedido, a entrada também atualiza seu recebimento.

---

# 32. Insumo

Insumo também utiliza quantidade direta.

Pode trabalhar com quantidade decimal conforme a Unidade suportada.

A entrada afeta:

- estoque;
- custo do Produto;
- financeiro;
- recebimento.

---

# 33. Estoque

O fechamento gera movimentação de entrada.

Identificador:

~~~text
NFE:<id>:ENTRADA
~~~

Esse vínculo garante idempotência e evita colisões entre documentos com mesmo número comercial.

---

# 34. Estorno de estoque

O cancelamento gera:

~~~text
NFE:<id>:CANCEL
~~~

A movimentação deve corresponder somente à NF cancelada.

Não pode afetar:

- outra NF;
- outro Fornecedor;
- outra Série;
- outra Empresa.

---

# 35. Estoque negativo

O cancelamento deve respeitar a configuração da Loja.

Se a saída necessária ao estorno produzir saldo negativo e a Loja não permitir:

~~~text
cancelamento bloqueado
~~~

Nenhum outro efeito da operação deve permanecer aplicado.

---

# 36. Custos de Revenda

Em Revenda, os custos são associados aos SKUs.

Campos de custo vigentes incluem conceitos como:

- custo original;
- última compra;
- custo médio.

As entradas válidas participam da composição desses valores.

---

# 37. Custos de Uso/Consumo e Insumo

Nesses tipos, os custos são associados ao Produto.

O cancelamento deve retirar o efeito da NF cancelada sem destruir o efeito de entradas posteriores válidas.

---

# 38. Recalculo de custos

A recomposição utiliza o histórico disponível de NFs fechadas válidas.

Conceitualmente:

~~~text
Custos atuais
=
efeitos das NFs válidas
sem considerar NFs CA
~~~

Não deve ser utilizado simples rollback cego para um valor antigo quando existirem entradas posteriores.

---

# 39. Financeiro

A Entrada de NF-e integra com:

- Pagar;
- PagarItem.

Quando houver Pedido, ele pode possuir planejamento financeiro anterior.

O XML também pode possuir informações próprias de:

- cobrança;
- duplicatas;
- pagamentos;
- forma de pagamento fiscal.

Esses dados representam a verdade fiscal recebida e não devem ser substituídos silenciosamente pelas condições comerciais planejadas no Pedido.

A efetivação da NF produz os efeitos financeiros conforme as regras vigentes do documento recebido.

---

# 40. NF parcial e financeiro

Em recebimento parcial:

~~~text
Previsão do Pedido
      ↓
NF parcial
      ↓
parte efetivada
+
saldo ainda previsto
~~~

O domínio precisa suportar várias NFs realizando gradualmente o valor do Pedido.

---

# 41. Vínculo financeiro da NF

Os registros financeiros associados à NF devem ser identificáveis sem afetar títulos de outras NFs.

O cancelamento deve operar somente sobre os efeitos correspondentes ao documento cancelado.

---

# 42. Financeiro baixado

Quando já existe baixa financeira que impeça reversão automática segura:

~~~text
cancelamento da NF
→ bloqueado
~~~

Não deve ocorrer reversão financeira silenciosa.

---

# 43. PedidoCompraEntrega

O recebimento do Pedido é refletido em estruturas de entrega/recebimento vinculadas aos itens.

O cálculo considera somente NFs válidas e fechadas.

---

# 44. Status do Pedido

O estado do Pedido é derivado do atendimento real.

Conceitualmente:

~~~text
saldo pendente > 0
→ AP
~~~

~~~text
todos os itens atendidos
→ AT
~~~

Cancelar uma NF pode provocar:

~~~text
AT → AP
~~~

---

# 45. Múltiplas NFs

Relação:

~~~text
PedidoCompra
├── NotaFiscalEntrada 1
├── NotaFiscalEntrada 2
└── NotaFiscalEntrada N
~~~

Cada NF deve possuir efeitos independentes.

Cancelar uma delas não cancela as demais.

---

# 46. Atomicidade

Fechamento e cancelamento atravessam vários agregados e módulos.

A regra estrutural é:

~~~text
SUCESSO COMPLETO
OU
ROLLBACK COMPLETO
~~~

Não deve existir estado parcialmente efetivado entre:

- Nota Fiscal;
- Pedido;
- estoque;
- custos;
- financeiro.

---

# 47. Auditoria

Eventos relevantes da Nota Fiscal são registrados conforme o padrão de auditoria do Sysvar.

O registro de sucesso deve representar uma transação efetivamente concluída.

---

# 48. Paginação e consulta

A listagem é paginada no backend.

Estrutura padrão:

~~~text
count
next
previous
results
~~~

A listagem não depende de carregar todas as NFs no frontend.

---

# 49. Filtros

O domínio de consulta suporta filtros por:

- Pedido;
- Status;
- Número;
- Chave;
- Fornecedor;
- Loja;
- período de emissão;
- período de entrada;
- faixa de valor;
- pesquisa geral.

Todos permanecem subordinados ao tenant.

---

# 50. Indicadores

Indicadores da consulta representam o conjunto filtrado completo:

- total;
- abertas;
- fechadas;
- canceladas;
- valor total.

Não representam apenas os registros da página atual.

---

# 51. Multiempresa

A Empresa é uma fronteira obrigatória do domínio.

As seguintes estruturas não podem atravessar tenants:

~~~text
NotaFiscalEntrada
NotaFiscalEntradaItem
Fornecedor
Produto
Produto × Fornecedor
PedidoCompra
PedidoCompraItem
Loja
Estoque
Financeiro
Conciliação
Conferência
Divergência
~~~

Toda operação deve preservar essa fronteira.

---

# 52. Permissões

A funcionalidade pertence ao módulo:

~~~text
compras
~~~

A autorização efetiva utiliza módulo e nível de acesso.

~~~text
VIEW
→ leitura

EDIT
→ operações permitidas de escrita
~~~

Acesso ao módulo Fiscal não é requisito adicional.

---

# 53. Invariantes principais

O domínio deve preservar:

~~~text
NF pertence a uma Empresa
~~~

~~~text
Pedido de Compra
= opcional
~~~

~~~text
Quando houver Pedido:
Pedido pertence à mesma Empresa da NF
~~~

~~~text
Quando houver Pedido:
Item conciliado pertence ao mesmo Pedido da NF
~~~

~~~text
XML
= verdade fiscal preservada
~~~

~~~text
Item XML sem Produto conciliado
→ não efetiva
~~~

~~~text
Empresa + Fornecedor + Modelo + Série + Número
não pode duplicar documento manual
~~~

~~~text
Chave XML
= identidade fiscal principal
~~~

~~~text
NF cancelada após efetivação
→ chave permanece ocupada
~~~

~~~text
Importação provisória recusada
→ chave liberada
~~~

~~~text
quantidade NF > saldo do Pedido
→ pode importar/conferir
→ não pode efetivar
~~~

~~~text
Preço NF <= preço aprovado
→ permitido

Preço NF > preço aprovado
→ bloqueia efetivação
~~~

~~~text
Produto tipo 2
→ estoque dedicado de Uso/Consumo
~~~

~~~text
Recusar entrada
!=
Cancelar NF
~~~

~~~text
dt_entrada >= dt_emissao
~~~

~~~text
0 <= desconto_item <= valor_bruto
~~~

~~~text
total_item >= 0
~~~

~~~text
valor_total >= 0
~~~

~~~text
Movimento de entrada
= NFE:<id>:ENTRADA
~~~

~~~text
Movimento de cancelamento
= NFE:<id>:CANCEL
~~~

~~~text
DELETE físico operacional
= bloqueado
~~~

---

# 54. Estado final do domínio

~~~text
NotaFiscalEntrada
HOMOLOGADA

NotaFiscalEntradaItem
HOMOLOGADO

Pedido obrigatório:
NÃO

Entrada sem Pedido:
SIM

Importação XML:
SIM

Produto × Fornecedor:
SIM

Conciliação:
SIM

Conferência física:
SIM

Divergências:
SIM

Recusa de importação provisória:
SIM

Recebimento parcial:
SIM

Múltiplas NFs:
SIM

Revenda:
SIM

Uso/Consumo:
SIM

Insumo:
SIM

Estoque:
INTEGRADO

Custos:
INTEGRADOS

Financeiro:
INTEGRADO

Cancelamento:
TRANSACIONAL

Multiempresa:
PROTEGIDO

Identidade técnica:
NotaFiscalEntrada.id

Identidade documental manual:
Empresa + Fornecedor + Modelo + Série + Número

Identidade fiscal XML:
Chave de acesso

Fonte fiscal:
XML preservado

Confirmação visual manual:
checkbox OK
~~~

---

# 55. Regra de preservação

Este documento representa o modelo de domínio homologado da Entrada de NF-e.

Alterações futuras devem preservar suas invariantes e relacionamentos, exceto quando uma nova decisão funcional aprovada substituir explicitamente uma regra existente.
