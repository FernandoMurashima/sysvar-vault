---
type: technical-map
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
  - homologado
---

# Mapa Técnico - Compras - Pedido de Compra

## 1. Identificação

- **Projeto:** [[Sysvar]]
- **Módulo:** Compras
- **Funcionalidade:** Pedido de Compra
- **Tipos contemplados:** Revenda, Uso/Consumo e Insumo
- **Escopo documentado:** Fase 1 — Pedido de Compra unificado
- **Situação:** IMPLEMENTADO E HOMOLOGADO
- **Homologação manual:** aprovada pelo usuário
- **Data da homologação:** 16/08/2026

### Documentos relacionados

- [[Sysvar]]
- [[Homologação - Compras - Pedido de Compra]]
- [[Workflows - Compras - Pedido de Compra]]
- [[Modelo de Domínio - Compras - Pedido de Compra]]
- [[Riscos e Cuidados - Compras - Pedido de Compra]]

---

# 2. Objetivo Técnico

Pedido de Compra representa a estrutura central do processo de aquisição do [[Sysvar]].

A funcionalidade foi unificada para que exista uma única entrada funcional:

**Pedido de Compra**

O usuário não escolhe manualmente o tipo do pedido.

O tipo é determinado automaticamente pelo primeiro produto incluído.

O Pedido de Compra contempla:

1. Revenda;
2. Uso/Consumo;
3. Insumo.

Os códigos internos utilizados são:

~~~text
tipo = '1' → Revenda
tipo = '2' → Uso/Consumo
tipo = '4' → Insumo
tipo = ''  → Não definido
~~~

O tipo:

~~~text
tipo_produto = '3' → Fabricação Própria
~~~

não participa do processo de Compras.

Fabricação Própria pertence ao fluxo de Produção.

---

# 3. Princípio de unificação

Antes da unificação existiam fluxos visuais separados para diferentes tipos de compra.

O padrão homologado é:

~~~text
Pedido de Compra
      ↓
Primeiro item
      ↓
Tipo definido automaticamente
      ↓
Demais itens devem ser do mesmo tipo
~~~

A interface não deve apresentar ao usuário uma escolha manual entre:

- Pedido de Revenda;
- Pedido de Uso/Consumo;
- Pedido de Insumo.

Existe apenas:

**Pedido de Compra**

---

# 4. Backend

A funcionalidade está concentrada principalmente no app Django:

`compras`

Arquivos centrais:

- `compras/models.py`
- `compras/serializers.py`
- `compras/views.py`
- `compras/urls.py`
- `compras/tests.py`

Integrações relevantes:

- `produto`
- `cadastros`
- `financeiro`
- `fiscal`
- `auditoria`
- `accounts`

O backend é a autoridade definitiva para:

- tipo do pedido;
- compatibilidade dos itens;
- isolamento multiempresa;
- situação do pedido;
- cálculo dos totais;
- validação dos produtos;
- regras de edição;
- regras de exclusão;
- parcelas planejadas;
- aprovação;
- integração financeira;
- recebimentos;
- auditoria.

---

# 5. Frontend

A funcionalidade unificada está concentrada em:

`src/app/features/pedidos-compra`

Arquivos principais:

- `pedidos-compra.component.ts`
- `pedidos-compra.component.html`
- `pedidos-compra.component.css`

A rota principal é:

~~~text
/compras/pedidos
~~~

Rotas antigas relacionadas aos fluxos separados redirecionam para a funcionalidade unificada.

A interface utiliza o nome:

**Pedido de Compra**

---

# 6. Rota unificada

A rota principal:

~~~text
compras/pedidos
~~~

carrega:

~~~text
PedidosCompraComponent
~~~

Rotas antigas de compatibilidade são redirecionadas para a rota unificada.

A arquitetura não deve voltar a criar telas independentes de Pedido de Compra por tipo de produto.

---

# 7. Model PedidoCompra

Model principal:

`compras.models.PedidoCompra`

Tabela:

`compras_pedido_compra`

Campos estruturais principais incluem:

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

# 8. Tipo do Pedido

O campo:

`PedidoCompra.tipo`

é controlado pelo sistema.

Valores:

~~~text
''  = Não definido
'1' = Revenda
'2' = Uso/Consumo
'4' = Insumo
~~~

O serializer principal trata `tipo` como campo protegido.

O usuário não deve editar diretamente esse valor.

---

# 9. Definição automática do tipo

Um Pedido novo pode existir inicialmente com:

~~~text
tipo = ''
~~~

Quando o primeiro item é incluído:

~~~text
pedido.tipo = produto.tipo_produto
~~~

A partir desse momento, o pedido passa a aceitar somente produtos daquele mesmo tipo.

Exemplo:

~~~text
Pedido vazio
   ↓
Primeiro produto = tipo 1
   ↓
Pedido.tipo = 1
   ↓
Somente produtos tipo 1 podem ser incluídos
~~~

---

# 10. Proibição de mistura de tipos

Um Pedido de Compra não pode conter produtos de tipos diferentes.

Exemplos inválidos:

~~~text
Revenda + Uso/Consumo
Revenda + Insumo
Uso/Consumo + Insumo
~~~

O backend deve rejeitar a inclusão quando:

~~~text
produto.tipo_produto != pedido.tipo
~~~

após o tipo já estar definido.

Essa regra não deve depender apenas do frontend.

---

# 11. Remoção do último item

Quando o último item de um pedido em aberto é removido, o pedido deve voltar ao estado sem tipo definido:

~~~text
tipo = ''
~~~

Isso permite que um Pedido de Compra ainda vazio seja reutilizado para qualquer um dos tipos válidos.

Essa regra só faz sentido enquanto o pedido permanece em aberto.

---

# 12. Produtos permitidos

O processo de Compras aceita somente:

~~~text
Produto.tipo_produto = '1'
Produto.tipo_produto = '2'
Produto.tipo_produto = '4'
~~~

Correspondência:

- `1` → Revenda;
- `2` → Uso/Consumo;
- `4` → Insumo.

Produto tipo `3` deve ser rejeitado.

---

# 13. Fabricação Própria

Produto de Fabricação Própria:

~~~text
tipo_produto = '3'
~~~

não participa do Pedido de Compra.

A origem operacional desse produto está ligada ao processo de Produção.

Não criar exceção no Pedido de Compra para adquirir produto tipo `3`.

---

# 14. Status do Pedido

Os estados oficiais são:

~~~text
AB = Aberto
AP = Aprovado
AT = Atendido
CA = Cancelado
~~~

Fluxo principal:

~~~text
AB
 ↓ aprovação
AP
 ↓ recebimento integral
AT
~~~

Cancelamento leva o pedido para:

~~~text
CA
~~~

conforme regras operacionais aplicáveis.

---

# 15. Pedido Aberto — AB

`AB` é o único estado normal de edição estrutural.

Enquanto estiver em aberto podem ocorrer:

- alteração de cabeçalho;
- inclusão de itens;
- alteração de itens;
- exclusão de itens;
- definição da forma de pagamento;
- definição do prazo;
- alteração de frete;
- alteração de desconto geral;
- exclusão do Pedido.

---

# 16. Proteção de itens por status

O serializer de itens exige:

~~~text
pedido.status == 'AB'
~~~

Somente pedidos em aberto permitem alteração de itens.

Depois da aprovação, a composição do pedido deixa de ser livremente editável.

---

# 17. Exclusão do Pedido

Pedido de Compra só pode ser excluído quando:

~~~text
status = 'AB'
~~~

Pedidos:

- AP;
- AT;
- CA;

não podem ser apagados pelo fluxo normal.

Isso preserva histórico e integrações.

---

# 18. Model PedidoCompraItem

Model:

`compras.models.PedidoCompraItem`

Tabela:

`compras_pedido_compra_item`

Campos centrais:

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

A estrutura é compartilhada pelos três tipos de Pedido de Compra.

As regras aplicadas aos campos dependem do tipo do produto.

---

# 19. Item de Revenda

Para Pedido de Revenda:

~~~text
tipo = '1'
~~~

são utilizados:

- Produto;
- Cor;
- Pack;
- Número de Packs;
- Quantidade calculada;
- Preço Unitário;
- Desconto;
- Total;
- Observações.

São obrigatórios para a composição estrutural:

- Produto;
- Cor;
- Pack;
- `n_packs >= 1`.

---

# 20. Quantidade de Revenda

A quantidade de Revenda não é digitada livremente.

Ela deriva do Pack.

Regra:

~~~text
Quantidade =
Número de Packs
×
Soma das quantidades dos itens do Pack
~~~

O cálculo é executado no backend.

Exemplo:

~~~text
Pack:
PP = 1
P  = 1
M  = 2
G  = 1
GG = 1

Total do Pack = 6

Número de Packs = 10

Quantidade = 60
~~~

---

# 21. Quantidade decimal em Revenda

Pedido de Revenda não aceita quantidade fracionária.

A quantidade final representa peças resultantes da estrutura do Pack.

O backend rejeita quantidade decimal incompatível.

---

# 22. Item de Uso/Consumo

Para:

~~~text
tipo = '2'
~~~

o fluxo utiliza:

- Produto;
- Unidade;
- Quantidade;
- Preço Unitário;
- Desconto;
- Total;
- Observações.

Não utiliza:

- Cor;
- Pack;
- número de Packs.

---

# 23. Item de Insumo

Para:

~~~text
tipo = '4'
~~~

o comportamento de quantidade segue a mesma mecânica operacional de Uso/Consumo.

São utilizados:

- Produto;
- Unidade;
- Quantidade;
- Preço Unitário;
- Desconto;
- Total;
- Observações.

Não utiliza Pack.

Apesar da mecânica semelhante, Insumo permanece um tipo próprio de Pedido.

---

# 24. Quantidade e Unidade

Para Uso/Consumo e Insumo:

~~~text
qtd > 0
~~~

A aceitação de casas decimais depende da Unidade do Produto.

Quando:

~~~text
unidade.permite_decimal = false
~~~

o backend não permite quantidade decimal.

Quando a Unidade permite decimal, a quantidade pode utilizar a precisão suportada pelo model.

---

# 25. Total do item

O total de um item segue:

~~~text
bruto = qtd × preco_unit
total_item = bruto - desconto_valor
~~~

Para Revenda, `qtd` é recalculada a partir do Pack antes do cálculo financeiro.

---

# 26. Reprocessamento dos totais

Depois da criação ou alteração dos itens, o Pedido recalcula seus totais.

Campos:

- `total_itens`
- `total_desconto`
- `frete`
- `total_pedido`

Regra principal:

~~~text
total_pedido =
total_itens
- total_desconto
+ frete
~~~

O total final não pode ficar negativo.

---

# 27. Desconto no item

Cada item pode possuir:

`desconto_valor`

O desconto do item é incorporado ao:

`total_item`

Não confundir esse campo com:

`PedidoCompra.total_desconto`

que representa desconto geral do Pedido.

---

# 28. Desconto geral

O Pedido suporta desconto geral:

`total_desconto`

A utilização é opcional.

O valor deve ser:

~~~text
>= 0
~~~

O desconto não pode produzir total final negativo.

---

# 29. Frete

O Pedido suporta:

`frete`

O preenchimento é opcional.

O valor deve ser:

~~~text
>= 0
~~~

O frete pode ser informado no Pedido quando conhecido.

Na operação real, também pode ser conhecido somente em momento posterior, especialmente no recebimento.

O campo não deve ser transformado em obrigatoriedade do Pedido.

---

# 30. Fornecedor

Pedido de Compra possui relacionamento obrigatório com:

`Fornecedor`

Na criação, o backend protege contra uso de fornecedor:

- inativo;
- bloqueado;
- de empresa incompatível.

A proteção também deve respeitar a Empresa do Pedido.

---

# 31. Loja

Pedido de Compra possui relacionamento com:

`Loja`

A Loja participa da definição do contexto empresarial do Pedido.

A Loja informada deve pertencer à Empresa permitida para o usuário.

Não confiar apenas no filtro do frontend.

---

# 32. Empresa

PedidoCompra possui relacionamento explícito:

`empresa`

A Empresa deve permanecer coerente com:

- usuário;
- Loja;
- Fornecedor;
- Natureza;
- Forma de Pagamento;
- Prazo;
- demais relacionamentos empresariais.

---

# 33. Isolamento Multiempresa

O `PedidoCompraViewSet` filtra os pedidos pela Empresa do usuário.

Usuário comum não deve acessar pedidos de outra Empresa.

O isolamento deve ser mantido em:

- consulta;
- criação;
- alteração;
- aprovação;
- formas de pagamento;
- prazos;
- natureza financeira;
- recebimentos;
- integrações.

O frontend não é a autoridade de segurança multiempresa.

---

# 34. Forma de Pagamento

A Forma de Pagamento não é simplesmente gravada pelo serializer comum do Pedido.

Existe ação específica para definição da forma.

A ação:

~~~text
set-forma-pagamento
~~~

é responsável por:

- localizar a Forma;
- validar Empresa;
- validar situação ativa;
- definir Prazo;
- gerar ou regenerar parcelas planejadas;
- registrar auditoria.

---

# 35. Prazo de Pagamento

Pedido de Compra pode possuir relacionamento com:

`PrazoPagamento`

O prazo pode:

- ser informado explicitamente;
- vir associado à Forma de Pagamento.

A configuração das parcelas pode utilizar:

- `PrazoPagamentoParcela`;
- `FormaPagamentoParcela`.

---

# 36. Model PedidoCompraParcela

Model:

`compras.models.PedidoCompraParcela`

Tabela:

`compras_pedido_compra_parcela`

Responsabilidade:

representar o planejamento financeiro do Pedido antes ou durante sua integração com Contas a Pagar.

Campos principais:

- `pedido`
- `parcela_n`
- `vencimento`
- `valor`
- `percentual`
- `origem`
- `status`
- `pagar_item_id`
- `data_cadastro`

---

# 37. Status das parcelas

Estados estruturais:

~~~text
PLAN   = Planejada
GERADA = Gerada em Financeiro
CANC   = Cancelada
~~~

Enquanto o Pedido está sendo preparado, as parcelas são planejadas.

Na aprovação, essas informações participam da geração financeira.

---

# 38. Sincronização das parcelas

Quando a Forma de Pagamento é aplicada, as parcelas planejadas são geradas novamente com base:

- no total atual do Pedido;
- na Forma;
- no Prazo;
- nos dias configurados;
- nos percentuais configurados.

Quando o total do Pedido é alterado enquanto ainda é permitido, o planejamento deve permanecer coerente.

---

# 39. Consistência financeira

Antes da aprovação, o Pedido deve possuir planejamento financeiro válido.

A interface apresenta:

- Total do Pedido;
- Total das Parcelas;
- Diferença;
- Situação.

A situação só deve ser considerada consistente quando existem parcelas válidas e a diferença é zero dentro da precisão financeira utilizada.

---

# 40. Modal Forma de Pagamento

A Forma de Pagamento é tratada em sobretela/modal.

O modal concentra:

- Forma;
- Prazo;
- Situação;
- Parcelas;
- vencimentos;
- valores;
- Total do Pedido;
- Total das Parcelas;
- Diferença.

Enquanto o Pedido estiver AB, permite configuração.

Depois, passa a servir principalmente para consulta.

---

# 41. Natureza financeira

A Natureza de Lançamento não pertence ao cabeçalho principal de criação do Pedido.

Ela é solicitada no momento da aprovação.

O fluxo de aprovação recebe:

~~~text
idnatureza
~~~

A Natureza deve:

- existir;
- ser válida;
- respeitar a Empresa do Pedido.

---

# 42. Aprovação

A ação de aprovação executa a transição:

~~~text
AB → AP
~~~

Antes da aprovação, o backend valida, entre outros pontos:

- Pedido está AB;
- existe pelo menos um item;
- tipo está definido;
- todos os itens possuem o mesmo tipo;
- tipo é 1, 2 ou 4;
- Forma de Pagamento está definida;
- Natureza foi informada;
- Natureza é válida;
- totais são consistentes;
- total do Pedido é maior que zero;
- parcelas planejadas existem;
- planejamento financeiro é válido.

---

# 43. Integração com Financeiro

A aprovação integra o Pedido de Compra ao módulo Financeiro.

São utilizadas estruturas existentes de:

- `Pagar`;
- `PagarItem`;
- Forma de Pagamento;
- Natureza de Lançamento.

A aprovação gera o compromisso financeiro correspondente ao Pedido.

Não criar um financeiro paralelo dentro de Compras.

---

# 44. PedidoCompraParcela versus PagarItem

`PedidoCompraParcela` representa o planejamento do Pedido.

`PagarItem` representa a parcela efetivamente integrada ao Contas a Pagar.

Essas estruturas possuem responsabilidades diferentes.

Não fundir os conceitos.

---

# 45. Recebimentos

Existe estrutura de recebimento relacionada aos itens do Pedido.

Model:

`PedidoCompraEntrega`

Tabela:

`compras_pedido_compra_entrega`

Campos centrais:

- `item`
- `qtd_prevista`
- `data_prevista`
- `qtd_recebida`
- `data_recebida`
- `status`
- `observacao`

---

# 46. Status de entrega

Os estados estruturais existentes incluem:

~~~text
PREV = Prevista
PARC = Parcial
RECB = Recebida
ATR  = Atrasada
~~~

Esses estados representam a situação das entregas associadas aos itens.

---

# 47. Recebimento operacional

A tela de Pedido de Compra não é a responsável pela entrada operacional definitiva da mercadoria.

O recebimento real permanece integrado ao fluxo Fiscal de Nota Fiscal de Entrada.

Pedido de Compra consulta os recebimentos relacionados.

Não criar entrada de estoque manual paralela diretamente na tela do Pedido.

---

# 48. Modal de Recebimentos

A interface de Pedido de Compra possui sobretela de Recebimentos.

Ela é destinada principalmente à consulta.

Deve permitir visualizar o que ocorreu no recebimento sem transformar o Pedido em uma segunda tela de entrada fiscal.

---

# 49. Recebimento parcial

Quando uma Nota Fiscal ou processo de recebimento atende somente parte do Pedido:

~~~text
Pedido permanece AP
~~~

O Pedido não deve ser marcado como Atendido enquanto ainda houver quantidade pendente.

---

# 50. Recebimento total

Quando todas as quantidades previstas estiverem recebidas:

~~~text
AP → AT
~~~

A mudança para:

`AT = Atendido`

deve representar atendimento integral do Pedido.

---

# 51. Cancelamento de Nota Fiscal

Quando uma Nota Fiscal de Entrada relacionada for cancelada, o estado de recebimento do Pedido deve ser recalculado pelo fluxo fiscal existente.

Isso pode fazer um Pedido anteriormente atendido deixar de estar integralmente recebido.

Não manter `AT` apenas porque já havia sido alcançado anteriormente.

---

# 52. Integração com Fiscal

Pedido de Compra deve permanecer integrado ao módulo Fiscal.

A Nota Fiscal de Entrada é responsável pelo recebimento documental e operacional da compra.

A arquitetura deve evitar:

- duplicação de entrada;
- estoque paralelo;
- recebimento fictício;
- divergência entre Pedido e Nota Fiscal.

---

# 53. Auditoria

Operações relevantes utilizam a Auditoria Central do [[Sysvar]].

A categoria utilizada pelo fluxo é relacionada a Compras.

Eventos relevantes incluem, conforme operação:

- definição de Forma de Pagamento;
- regeneração de parcelas;
- aprovação;
- alterações relevantes;
- transições operacionais.

Não criar sistema de auditoria separado para Pedido de Compra.

---

# 54. Permissões

A API utiliza:

`HasModuleRole`

Módulo requerido:

~~~text
compras
~~~

Perfis atualmente autorizados no fluxo incluem:

- Admin;
- Diretor;
- Gerente;
- AssistentePagar.

As permissões definitivas permanecem controladas pelo backend.

---

# 55. Tela principal

A tela principal deve permanecer limpa.

Ela concentra:

- título;
- filtros;
- indicadores;
- listagem;
- seleção;
- ações principais.

Estruturas subordinadas não devem ocupar permanentemente a tela principal.

---

# 56. Lista de Pedidos

A listagem unificada permite visualizar pedidos independentemente do tipo.

Filtros podem incluir:

- Tipo;
- Status;
- Loja;
- Fornecedor;
- critérios adicionais suportados pela interface.

O filtro de Tipo não representa escolha manual de tipo durante a criação.

Ele serve somente para consulta.

---

# 57. Indicadores e resumos

A interface apresenta resumos do Pedido, incluindo informações como:

- quantidade;
- Forma de Pagamento;
- situação de recebimento;
- Total de Itens;
- Desconto Geral;
- Frete;
- Total do Pedido.

O padrão homologado privilegia apresentação compacta.

---

# 58. Sobretela de Itens

Itens do Pedido são administrados em modal/sobretela.

O layout muda conforme o tipo já definido.

Estados visuais principais:

- pedido ainda sem tipo;
- Revenda;
- Uso/Consumo ou Insumo.

Quando o Pedido ainda não possui itens, a sobretela deve abrir corretamente mesmo antes da definição do tipo.

---

# 59. Layout inicial

Pedido sem tipo utiliza layout inicial explícito.

A interface não deve depender de interação prévia com busca de produto para organizar os campos.

O layout deve estar correto desde a primeira abertura.

---

# 60. Layout de Revenda

Depois que o Pedido é identificado como Revenda, a sobretela apresenta os campos específicos necessários para:

- Produto;
- Cor;
- Pack;
- quantidade de Packs;
- quantidade calculada;
- preço;
- desconto;
- total;
- observação.

---

# 61. Layout de Uso/Consumo e Insumo

Para tipos 2 e 4, a interface apresenta a estrutura adequada a quantidade direta:

- Produto;
- Unidade;
- Quantidade;
- Preço;
- Desconto;
- Total;
- Observação.

Não apresentar Pack como elemento operacional desses tipos.

---

# 62. Padrão de seleção e ações

A funcionalidade deve seguir o padrão visual aprovado do [[Sysvar]]:

- seleção de uma linha;
- linha selecionada destacada;
- barra de ações;
- ações relacionadas ao registro selecionado;
- detalhes subordinados em modal/sobretela.

Não adotar coluna genérica de três pontos como padrão principal das estruturas auxiliares do Pedido.

---

# 63. Forma de Pagamento como estrutura subordinada

Forma de Pagamento deve permanecer fora do cabeçalho principal expandido.

A sobretela concentra sua configuração e consulta.

Isso reduz poluição visual e separa:

~~~text
Cabeçalho operacional