---
type: homologation
status: approved
project: Sysvar
group: Compras
module: Pedido de Compra
phase: Fase 1
created: 2026-08-16
updated: 2026-08-27
tags:
  - sysvar
  - compras
  - pedido-de-compra
  - entrada-nfe
  - revenda
  - uso-consumo
  - insumo
  - financeiro
  - fiscal
  - recebimento
  - homologacao
  - multiempresa
  - aprovado
---

# Homologação - Compras - Pedido de Compra

## 1. Identificação

**Projeto:** [[Sysvar]]  
**Módulo:** Compras  
**Funcionalidade:** Pedido de Compra  
**Escopo:** Pedido de Compra unificado  
**Tipos contemplados:** Revenda, Uso/Consumo e Insumo  
**Situação:** HOMOLOGADO  
**Data de conclusão da homologação:** 16/08/2026  
**Resultado:** APROVADO

### Documentos relacionados

- [[Sysvar]]
- [[Mapa Técnico - Compras - Pedido de Compra]]
- [[Modelo de Domínio - Compras - Pedido de Compra]]
- [[Workflows - Compras - Pedido de Compra]]
- [[Riscos e Cuidados - Compras - Pedido de Compra]]
- [[Homologação - Compras - Entrada de NF-e]]
- [[Mapa Técnico - Compras - Entrada de NF-e]]
- [[Modelo de Domínio - Compras - Entrada de NF-e]]
- [[Workflows - Compras - Entrada de NF-e]]
- [[Riscos e Cuidados - Compras - Entrada de NF-e]]
- [[Homologação - Compras - Entrada de NF-e]]
- [[Mapa Técnico - Compras - Entrada de NF-e]]
- [[Modelo de Domínio - Compras - Entrada de NF-e]]
- [[Workflows - Compras - Entrada de NF-e]]
- [[Riscos e Cuidados - Compras - Entrada de NF-e]]

---

## 2. Objetivo

Este documento registra o resultado da homologação funcional e visual do Pedido de Compra unificado do [[Sysvar]].

A homologação confirmou a substituição dos fluxos separados de compra por uma única funcionalidade:

**Pedido de Compra**

A funcionalidade contempla:

- Revenda;
- Uso/Consumo;
- Insumo.

Fabricação Própria não participa de Compras.

---

# 3. Resultado geral

O Pedido de Compra foi considerado:

**APROVADO E HOMOLOGADO**

O fluxo homologado compreende:

~~~text
Criar Pedido
→ preencher cabeçalho
→ incluir primeiro item
→ tipo definido automaticamente
→ incluir itens do mesmo tipo
→ configurar Forma/Prazo
→ gerar parcelas
→ aprovar com Natureza
→ gerar Financeiro
→ acompanhar recebimentos
→ atendimento parcial mantém AP
→ atendimento integral leva a AT
~~~

---

# 4. Nomenclatura funcional aprovada

A nomenclatura oficial é:

**Pedido de Compra**

Não utilizar como funcionalidades independentes:

- Pedido de Revenda;
- Pedido de Uso/Consumo;
- Pedido de Insumo.

A diferenciação ocorre internamente conforme o tipo dos produtos.

---

# 5. Tipos homologados

Foram consolidados os seguintes tipos:

~~~text
tipo = '1' → Revenda
tipo = '2' → Uso/Consumo
tipo = '4' → Insumo
~~~

Pedido ainda sem itens utiliza:

~~~text
tipo = ''
~~~

Produto:

~~~text
tipo_produto = '3'
~~~

correspondente a Fabricação Própria, não participa do processo de Compras.

---

# 6. Definição automática do tipo

Foi aprovado que o usuário não escolha manualmente o tipo do Pedido.

O primeiro item determina automaticamente o tipo.

Fluxo homologado:

~~~text
Novo Pedido
tipo = ''
   ↓
Primeiro Produto
   ↓
Produto.tipo_produto
   ↓
Pedido.tipo
~~~

---

# 7. Proibição de mistura de tipos

Foi homologada a proibição de misturar tipos diferentes no mesmo Pedido.

Combinações inválidas:

~~~text
Revenda + Uso/Consumo
Revenda + Insumo
Uso/Consumo + Insumo
~~~

Depois que o primeiro item define o tipo, todos os demais precisam possuir o mesmo tipo.

---

# 8. Exclusão do último item

Foi aprovado que, enquanto o Pedido estiver AB, a exclusão do último item faça:

~~~text
Pedido com 1 item
      ↓
Excluir último item
      ↓
0 itens
      ↓
tipo = ''
~~~

O Pedido vazio volta a ficar disponível para qualquer tipo válido de compra.

---

# 9. Fabricação Própria

Foi homologado que Fabricação Própria não pertence ao Pedido de Compra.

Produto:

~~~text
tipo_produto = '3'
~~~

deve ser tratado pelo módulo de Produção.

Não criar exceção para comprá-lo pelo Pedido de Compra.

---

# 10. Cabeçalho comum

O Pedido utiliza um cabeçalho comum independentemente do tipo.

O cabeçalho contempla, conforme o fluxo:

- Loja;
- Fornecedor;
- Emissão;
- Previsão de Entrega;
- Desconto Geral;
- Frete;
- Observações.

O tipo não é informado manualmente.

---

# 11. Situações homologadas

Os estados oficiais são:

~~~text
AB = Aberto
AP = Aprovado
AT = Atendido
CA = Cancelado
~~~

Esses estados foram aceitos como ciclo principal do Pedido de Compra.

---

# 12. Estado AB

Foi homologado que o Pedido em estado AB permita manutenção.

Entre as ações permitidas estão:

- editar cabeçalho;
- incluir itens;
- editar itens;
- excluir itens;
- configurar pagamento;
- alterar frete;
- alterar desconto geral;
- excluir o Pedido;
- aprovar.

---

# 13. Proteção após aprovação

Depois da aprovação, a composição do Pedido não deve continuar livremente editável.

Foi aprovado que os estados posteriores sejam utilizados principalmente para:

- consulta;
- acompanhamento financeiro;
- acompanhamento de recebimento;
- histórico.

---

# 14. Exclusão do Pedido

Foi homologado:

~~~text
Somente Pedido AB pode ser excluído
~~~

Pedidos AP, AT e CA devem permanecer registrados.

---

# 15. Item de Revenda

Para tipo 1, o fluxo homologado utiliza:

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

# 16. Quantidade de Revenda

Foi homologado que a quantidade seja derivada do Pack.

Regra:

~~~text
Quantidade =
Número de Packs
×
Quantidade total do Pack
~~~

A quantidade não é digitada livremente como substituição dessa regra.

---

# 17. Quantidade inteira de Revenda

Foi aprovado que Revenda não utilize quantidade fracionária.

A quantidade representa peças resultantes da composição do Pack.

---

# 18. Item de Uso/Consumo

Para tipo 2, o fluxo homologado utiliza:

- Produto;
- Unidade;
- Quantidade;
- Preço;
- Desconto;
- Total;
- Observação.

Não utiliza Pack.

---

# 19. Item de Insumo

Para tipo 4, foi homologada a mesma mecânica quantitativa básica de Uso/Consumo:

- Produto;
- Unidade;
- Quantidade;
- Preço;
- Desconto;
- Total;
- Observação.

Apesar disso, Insumo continua sendo um tipo próprio.

---

# 20. Quantidades decimais

Foi homologado que Uso/Consumo e Insumo respeitem a configuração da Unidade.

Quando a Unidade não aceita decimal:

~~~text
quantidade decimal
→ rejeitar
~~~

Quando aceita:

~~~text
quantidade decimal
→ permitir
~~~

---

# 21. Total do item

O cálculo aprovado é:

~~~text
bruto = quantidade × preço unitário

total_item =
bruto
- desconto do item
~~~

Para Revenda, a quantidade é obtida do Pack antes do cálculo.

---

# 22. Total do Pedido

Foi homologada a fórmula:

~~~text
total_pedido =
total_itens
- total_desconto
+ frete
~~~

O total não pode ser negativo.

Para aprovação, deve ser maior que zero.

---

# 23. Desconto geral

O desconto geral é opcional.

Ele permanece separado do desconto de cada item.

Não foi definida obrigatoriedade de desconto geral.

---

# 24. Frete

Foi aprovado que o frete seja opcional.

Ele pode ser informado no Pedido quando conhecido.

Também foi considerado normal que, em determinadas operações, o valor só seja conhecido no recebimento.

Portanto, não deve ser obrigatório para criação ou aprovação apenas por existir no modelo.

---

# 25. Fornecedor

O fluxo homologado mantém proteção para não utilizar, em novo Pedido:

- Fornecedor inativo;
- Fornecedor bloqueado;
- Fornecedor de Empresa incompatível.

---

# 26. Multiempresa

Foi mantido como requisito obrigatório o isolamento multiempresa.

Pedido, Loja, Fornecedor e demais estruturas relacionadas devem respeitar a Empresa do usuário.

O frontend não é a autoridade de segurança.

---

# 27. Forma de Pagamento

Foi aprovado que a Forma de Pagamento seja tratada em sobretela própria.

A tela principal do Pedido não deve ficar carregada com toda a estrutura financeira.

A sobretela contempla:

- Forma;
- Prazo;
- parcelas;
- vencimentos;
- valores;
- Total do Pedido;
- Total das Parcelas;
- Diferença;
- Situação.

---

# 28. Prazo de Pagamento

Foi homologado o uso de Prazo associado à Forma ou selecionado conforme a configuração existente.

Forma e Prazo são utilizados para gerar o planejamento das parcelas.

---

# 29. Parcelas planejadas

Foi homologada a utilização de `PedidoCompraParcela` para o planejamento financeiro antes da aprovação.

Estado principal durante preparação:

~~~text
PLAN = Planejada
~~~

---

# 30. Sincronização do planejamento

Foi aprovado que alterações no total enquanto o Pedido permanece AB mantenham as parcelas planejadas coerentes.

Condição:

~~~text
soma das parcelas
=
total do Pedido
~~~

---

# 31. Diferença das parcelas

A interface homologada apresenta:

- Total do Pedido;
- Total das Parcelas;
- Diferença;
- Situação.

A aprovação não deve prosseguir com planejamento inconsistente.

---

# 32. Natureza de Lançamento

Foi homologado que a Natureza financeira seja escolhida:

**no momento da aprovação**

e não como campo permanente de destaque no cabeçalho principal.

---

# 33. Aprovação

Fluxo homologado:

~~~text
Pedido AB
   ↓
Aprovar
   ↓
Selecionar Natureza
   ↓
Validar Pedido
   ↓
Gerar Financeiro
   ↓
Pedido AP
~~~

---

# 34. Condições para aprovação

Foram consideradas necessárias, conforme implementação:

- Pedido AB;
- pelo menos um item;
- tipo válido;
- itens do mesmo tipo;
- Forma de Pagamento definida;
- parcelas planejadas;
- parcelas consistentes;
- Natureza válida;
- total positivo.

---

# 35. Integração Financeira

Foi homologado que a aprovação gere a obrigação correspondente no Financeiro.

O fluxo utiliza as estruturas existentes de:

- Pagar;
- PagarItem.

Não deve existir Contas a Pagar paralelo dentro de Compras.

---

# 36. Separação entre planejamento e Financeiro

Foi mantida a distinção:

~~~text
PedidoCompraParcela
→ planejamento

PagarItem
→ parcela financeira efetiva
~~~

Essas duas responsabilidades não devem ser confundidas.

---

# 37. Recebimentos

Foi homologado originalmente que a tela de Pedido possua acesso aos recebimentos em sobretela.

Essa estrutura continua prioritariamente destinada a acompanhamento.

Após a evolução da Entrada de NF-e, a regra consolidada é:

~~~text
Pedido
→ acompanha recebimentos vinculados

Entrada de NF-e
→ realiza o recebimento físico na efetivação
~~~

A tela do Pedido não movimenta estoque.

---

# 38. Integração com Entrada de NF-e

A integração originalmente homologada com Nota Fiscal de Entrada evoluiu para a funcionalidade consolidada:

**Entrada de NF-e**

Quando uma NF-e estiver recebendo um Pedido:

~~~text
Pedido AP
↓
Entrada de NF-e vinculada
↓
XML
↓
Conciliação
↓
Conferência
↓
Validações do Pedido
↓
Efetivação
↓
Estoque
↓
Atualização do atendimento
~~~

O Pedido não executa uma segunda entrada independente de mercadoria.

---

# 39. Pedido não é Obrigatório para Toda NF-e

A evolução homologada da Entrada de NF-e passou a admitir:

~~~text
NF-e com Pedido
ou
NF-e sem Pedido
~~~

Essa evolução não altera a regra do Pedido de Compra.

Significa apenas que:

~~~text
Pedido
→ pode originar recebimentos

mas

Entrada de NF-e
→ não depende estruturalmente de Pedido
~~~

Quando houver vínculo, todas as validações correspondentes ao Pedido continuam obrigatórias.

---

# 40. Aprovação não Movimenta Estoque

Permanece homologada a regra:

~~~text
Aprovação do Pedido
!=
Entrada em Estoque
~~~

Também ficou consolidado posteriormente que:

~~~text
Importação do XML
!=
Entrada em Estoque
~~~

O estoque é afetado na efetivação da Entrada de NF-e.

---

# 41. Recebimento Parcial

Quando uma Entrada de NF-e válida vinculada ao Pedido atende somente parte da quantidade:

~~~text
Recebimento parcial
→ Pedido permanece AP
~~~

Não marcar Pedido como atendido apenas porque existe alguma NF ou alguma quantidade recebida.

---

# 42. Recebimento Integral

Quando o acumulado das Entradas de NF-e válidas vinculadas ao Pedido atender integralmente todos os seus itens:

~~~text
AP → AT
~~~

AT continua representando atendimento integral.

---

# 43. Múltiplas Entradas de NF-e

Permanece válida a homologação de recebimento progressivo.

Não existe a premissa:

~~~text
1 Pedido = 1 NF-e
~~~

Um Pedido pode possuir várias Entradas de NF-e.

O atendimento considera o acumulado dos recebimentos válidos.

NF cancelada não compõe esse acumulado.

---

# 44. Cancelamento de Entrada de NF-e

A integração foi posteriormente ampliada e homologada no domínio específico da Entrada de NF-e.

Quando uma NF-e vinculada ao Pedido for cancelada:

~~~text
NF cancelada
↓
deixa de compor recebimento válido
↓
recalcular atendimento
~~~

Se um Pedido anteriormente AT deixar de estar integralmente atendido:

~~~text
AT → AP
~~~

quando voltar a existir saldo pendente.

O cancelamento da NF também trata os efeitos pertencentes à própria entrada, incluindo conforme aplicável:

- Estoque;
- Custos;
- Financeiro;
- recebimento do Pedido.

A homologação específica e atual dessa integração está registrada em:

[[Homologação - Compras - Entrada de NF-e]]

---

## Atualização Documental da Integração — 27/08/2026

A homologação principal do Pedido de Compra permanece datada de:

~~~text
16/08/2026
~~~

Em:

~~~text
27/08/2026
~~~

a integração com Entrada de NF-e foi ampliada, testada, homologada e documentada no domínio específico da Entrada de NF-e.

Essa atualização:

- não reabre a homologação estrutural do Pedido;
- não altera seus tipos;
- não altera sua aprovação;
- não altera sua arquitetura financeira;
- não altera os estados AB, AP, AT e CA;
- atualiza apenas a interpretação da integração de recebimento.

---
# 45. Tela principal homologada

A tela principal foi aprovada com organização compacta e limpa.

Ela concentra:

- título;
- indicadores;
- filtros;
- listagem;
- seleção;
- ações.

Detalhes subordinados permanecem fora da tela principal.

---

# 46. Sobretela de Itens

Foi homologado que Itens sejam mantidos em sobretela.

A sobretela adapta sua estrutura ao tipo do Pedido.

Estados contemplados:

- Pedido ainda sem tipo;
- Revenda;
- Uso/Consumo;
- Insumo.

---

# 47. Layout inicial sem tipo

Foi corrigido e aprovado o comportamento visual da sobretela antes da inclusão do primeiro item.

Ela deve abrir corretamente mesmo quando:

~~~text
tipo = ''
~~~

Não depender de uma busca anterior para organizar os campos.

---

# 48. Sobretela de Forma de Pagamento

O layout da Forma de Pagamento foi ajustado durante a homologação.

Foram aprovados:

- organização dos campos;
- Forma;
- Prazo;
- Situação;
- botão Aplicar;
- indicadores de totais;
- tabela de parcelas.

---

# 49. Sobretela de Recebimentos

Foi mantida a separação visual dos recebimentos em sobretela própria.

Ela deve permanecer prioritariamente consultiva.

---

# 50. Padrão de ações

Foi adotado o padrão geral do [[Sysvar]]:

~~~text
selecionar linha
→ destacar linha
→ utilizar barra de ações
~~~

Evitar transformar cada tabela subordinada em uma coleção de botões ou menu de três pontos.

---

# 51. Correções realizadas durante a homologação

A implementação foi refinada em etapas.

Entre os pontos corrigidos estiveram:

- unificação real do frontend;
- comportamento dos itens;
- Forma de Pagamento;
- Recebimentos;
- validações;
- layout principal;
- layout das sobretelas;
- layout inicial de item sem tipo;
- organização visual da Forma de Pagamento.

---

# 52. Commits relevantes — Backend

Implementação principal:

~~~text
c3d0a3043adb362c179e0a1b0bc1f14db7ff6794
Unifica fluxo de Pedido de Compra
~~~

Fechamento técnico e testes:

~~~text
63d62b60cfdd151a4a5a801a8c4289cf4ad4bd23
Adiciona testes do Pedido de Compra unificado
~~~

---

# 53. Commits relevantes — Frontend

Implementação inicial:

~~~text
f7684267d05ef55b1f16342d5d2f81c937232ffa
~~~

Unificação dos itens:

~~~text
7975038dc54a37320c9a7e0282b05bde03462e48
Unifica itens do Pedido de Compra
~~~

Pagamento e Recebimentos:

~~~text
f57027e776a27f64eda2a88830fe9356182e67ee
Organiza pagamento e recebimentos do Pedido de Compra
~~~

Validações:

~~~text
ff4e83b5f5092d5cef01ae113db75e495dbcfa15
Corrige validações do Pedido de Compra
~~~

Ajuste visual:

~~~text
d348765a372ff1b475dee8c93c75d430b3336943
Ajusta layout do Pedido de Compra
~~~

Fechamento visual:

~~~text
28da0d8836d859deaca1adb7e057697575f2ff1f
Corrige layout das sobretelas do Pedido de Compra
~~~

---

# 54. Testes automatizados

O fechamento técnico do backend registrou:

~~~text
15 testes aprovados
~~~

para o módulo de Compras relacionado ao Pedido unificado.

Também foi validado:

~~~text
python manage.py check
~~~

sem erro relacionado ao escopo.

---

# 55. Build frontend

O frontend foi validado após as correções técnicas e visuais.

O build Angular foi concluído com sucesso no fechamento da implementação.

---

# 56. Homologação manual

Após as implementações e correções, o fluxo foi submetido à validação manual.

O resultado final informado pelo usuário foi:

**PEDIDO APROVADO**

Esse registro encerra a Fase 1 do Pedido de Compra unificado.

---

# 57. Regras que não devem ser reabertas sem novo motivo

Considerar fechadas:

1. existe somente Pedido de Compra;
2. usuário não escolhe o tipo;
3. primeiro item define tipo;
4. não é permitido misturar tipos;
5. último item removido redefine tipo para vazio;
6. Fabricação Própria não participa de Compras;
7. Revenda usa Pack;
8. Uso/Consumo e Insumo usam quantidade direta;
9. Natureza é escolhida na aprovação;
10. pagamento fica em sobretela;
11. recebimentos ficam em sobretela;
12. recebimento real ocorre pelo Fiscal;
13. parcial mantém AP;
14. integral leva a AT;
15. Pedido só é excluído em AB.

Esses pontos só devem ser revistos diante de:

- novo requisito;
- defeito comprovado;
- conflito real;
- nova decisão funcional.

---

# 58. Próximas evoluções

Qualquer nova evolução deve partir desta base homologada.

Antes de implementar:

1. consultar esta Homologação;
2. consultar [[Mapa Técnico - Compras - Pedido de Compra]];
3. consultar [[Modelo de Domínio - Compras - Pedido de Compra]];
4. consultar [[Workflows - Compras - Pedido de Compra]];
5. consultar [[Riscos e Cuidados - Compras - Pedido de Compra]];
6. consultar o código atual;
7. preservar tudo que não estiver explicitamente sendo alterado.

---

# 59. Estado oficial

A situação oficial desta funcionalidade é:

~~~text
PEDIDO DE COMPRA
IMPLEMENTADO
TESTADO
HOMOLOGADO
APROVADO
~~~

Este documento passa a ser a referência de homologação da Fase 1 do Pedido de Compra unificado do [[Sysvar]].