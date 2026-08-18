---
type: domain-model
status: approved
project: Sysvar
group: Compras
module: Entrada de NF-e
phase: Fase 1
created: 2026-08-18
updated: 2026-08-18
tags:
  - sysvar
  - compras
  - entrada-nfe
  - nota-fiscal
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
- **Data da homologação:** 18/08/2026

### Documentos relacionados

- [[Sysvar]]
- [[Mapa Técnico - Compras - Pedido de Compra]]
- [[Modelo de Domínio - Compras - Pedido de Compra]]
- [[Workflows - Compras - Pedido de Compra]]
- [[Mapa Técnico - Compras - Entrada de NF-e]]
- [[Workflows - Compras - Entrada de NF-e]]
- [[Homologação - Compras - Entrada de NF-e]]

---

# 2. Objetivo do Modelo de Domínio

O domínio de Entrada de NF-e representa o recebimento efetivo de produtos vinculados a um Pedido de Compra aprovado.

A Entrada de NF-e transforma a intenção de compra registrada no Pedido em eventos efetivos de:

- recebimento;
- estoque;
- custo;
- financeiro.

A Nota Fiscal de Entrada também preserva:

- identidade documental;
- histórico;
- rastreabilidade;
- cancelamento;
- auditoria.

---

# 3. Agregado principal

A raiz do agregado é:

`NotaFiscalEntrada`

Estrutura diretamente subordinada:

`NotaFiscalEntradaItem`

Estruturas externas relacionadas:

- PedidoCompra
- PedidoCompraItem
- PedidoCompraEntrega
- Empresa
- Loja
- Fornecedor
- Produto
- Cor
- Pack
- SKU
- Estoque
- EstoqueMovimentacao
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

`chave_acesso` representa a chave fiscal da NF-e quando informada.

Regras:

- pode estar ausente no lançamento manual;
- quando informada, deve possuir 44 dígitos;
- deve ser numérica;
- deve possuir dígito verificador válido;
- deve ser única.

A chave permanece associada ao documento mesmo após cancelamento.

---

# 8. Relação com PedidoCompra

Relacionamento:

`NotaFiscalEntrada.pedido_compra`

O Pedido é a origem funcional da entrada.

A NF não duplica dados de:

- Empresa;
- Loja;
- Fornecedor;

quando essas informações já podem ser determinadas de forma segura pelo Pedido.

Representação:

~~~text
NotaFiscalEntrada
        ↓
PedidoCompra
   ├── Empresa
   ├── Loja
   └── Fornecedor
~~~

---

# 9. Empresa

A Empresa da NF é derivada do Pedido de Compra.

Toda consulta e operação devem respeitar o tenant.

A NF não pode:

- utilizar Pedido de outra empresa;
- expor seus dados a usuário de outra empresa;
- relacionar itens de outro tenant;
- contaminar estoque ou financeiro de outra empresa.

---

# 10. Loja

A Loja utilizada no recebimento é a Loja vinculada ao Pedido.

Ela participa principalmente de:

- destino do estoque;
- configuração de estoque negativo;
- segregação operacional da entrada.

A Loja deve pertencer à mesma Empresa do Pedido.

---

# 11. Fornecedor

O Fornecedor é obtido a partir do Pedido de Compra.

Ele participa da identidade documental:

~~~text
Empresa
+ Fornecedor
+ Modelo
+ Série
+ Número
~~~

Não existe necessidade funcional de duplicar o Fornecedor diretamente na NF enquanto o relacionamento com o Pedido permanecer obrigatório e confiável.

---

# 12. Entidade NotaFiscalEntradaItem

Entidade:

`NotaFiscalEntradaItem`

Responsabilidade:

representar a quantidade efetivamente recebida de um item do Pedido dentro de uma determinada NF.

Relacionamentos principais:

- `nota`
- `pedido_item`

Campos principais:

- `qtd_recebida`
- `preco_unit_nf`
- `desconto_item`
- `total_item`

---

# 13. Relação com PedidoCompraItem

Todo item da NF deve apontar para um item do mesmo Pedido associado à NotaFiscalEntrada.

Regra estrutural:

~~~text
NotaFiscalEntrada.pedido_compra
=
NotaFiscalEntradaItem.pedido_item.pedido
~~~

Não é permitida combinação entre itens de Pedidos diferentes.

---

# 14. Confirmação do item

No frontend, a existência efetiva de `NotaFiscalEntradaItem` é representada pelo checkbox:

**OK**

~~~text
Checkbox desmarcado
→ ainda não existe item persistido na NF

Checkbox marcado
→ item está persistido na NF
~~~

O checkbox não representa apenas estado visual.

Ele reflete o estado real persistido.

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

A quantidade da NF atual não pode ultrapassar esse saldo.

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

Estados:

~~~text
AB = Aberta
FE = Fechada
CA = Cancelada
~~~

## AB

Estado de preparação.

Permite alteração conforme as regras vigentes.

## FE

Representa NF efetivada.

Seus efeitos passam a integrar estoque, custos, financeiro e recebimento.

## CA

Representa documento cancelado.

A entidade permanece persistida para histórico.

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

# 21. Exclusão física

`NotaFiscalEntrada` não deve ser excluída fisicamente pelo fluxo operacional.

DELETE direto é bloqueado.

O cancelamento preserva:

- documento;
- itens;
- histórico;
- identidade;
- rastreabilidade.

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

O tipo da operação é determinado pelo Pedido.

Tipos suportados:

~~~text
1 = Revenda
2 = Uso/Consumo
4 = Insumo
~~~

A Entrada de NF-e não define um tipo independente do Pedido.

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

A entrada afeta:

- estoque do Produto;
- custos do Produto;
- financeiro;
- recebimento do Pedido.

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

O Pedido aprovado pode possuir previsão financeira.

A NF realiza a parcela correspondente ao recebimento efetivo.

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
PedidoCompra
PedidoCompraItem
Loja
Estoque
Financeiro
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
NF pertence a um Pedido da mesma Empresa
~~~

~~~text
Item da NF pertence ao mesmo Pedido da NF
~~~

~~~text
Empresa + Fornecedor + Modelo + Série + Número
não pode duplicar documento
~~~

~~~text
Chave informada
= 44 dígitos + DV válido + única
~~~

~~~text
dt_entrada >= dt_emissao
~~~

~~~text
qtd_recebida >= 0
~~~

~~~text
qtd_recebida <= saldo disponível
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
DELETE físico
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

Identidade documental:
Empresa + Fornecedor + Modelo + Série + Número

Confirmação visual do item:
checkbox OK
~~~

---

# 55. Regra de preservação

Este documento representa o modelo de domínio homologado da Entrada de NF-e.

Alterações futuras devem preservar suas invariantes e relacionamentos, exceto quando uma nova decisão funcional aprovada substituir explicitamente uma regra existente.
