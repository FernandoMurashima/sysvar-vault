---
type: workflows
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
  - workflows
  - auditoria
  - multiempresa
  - homologado
---

# Workflows - Compras - Pedido de Compra

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
- [[Modelo de Domínio - Compras - Pedido de Compra]]
- [[Riscos e Cuidados - Compras - Pedido de Compra]]
- [[Homologação - Compras - Pedido de Compra]]
- [[Mapa Técnico - Compras - Entrada de NF-e]]
- [[Modelo de Domínio - Compras - Entrada de NF-e]]
- [[Workflows - Compras - Entrada de NF-e]]
- [[Riscos e Cuidados - Compras - Entrada de NF-e]]
- [[Homologação - Compras - Entrada de NF-e]]

---

# 2. Objetivo

Este documento descreve os principais fluxos funcionais e operacionais do Pedido de Compra unificado do [[Sysvar]].

A funcionalidade contempla:

- Revenda;
- Uso/Consumo;
- Insumo.

Não contempla Fabricação Própria.

O fluxo foi consolidado em uma única funcionalidade visível:

**Pedido de Compra**

---

# 3. Visão geral

Fluxo principal:

~~~text
Novo Pedido
    ↓
Cabeçalho
    ↓
Primeiro item
    ↓
Tipo definido automaticamente
    ↓
Demais itens do mesmo tipo
    ↓
Forma de Pagamento / Prazo
    ↓
Parcelas planejadas
    ↓
Aprovação + Natureza
    ↓
Financeiro
    ↓
Pedido AP
    ↓
Entrada de NF-e vinculada
    ↓
Efetivação
    ↓
Parcial → AP
Total → AT
~~~

---

# 4. Entrada na funcionalidade

A entrada funcional é única:

~~~text
Compras
   ↓
Pedido de Compra
~~~

Não existem, como funcionalidades independentes para o usuário:

- Pedido de Revenda;
- Pedido de Uso/Consumo;
- Pedido de Insumo.

A distinção ocorre automaticamente conforme os itens.

---

# 5. Listagem inicial

Ao acessar Pedido de Compra, o usuário encontra a listagem unificada.

A listagem pode reunir pedidos dos tipos:

- Revenda;
- Uso/Consumo;
- Insumo.

Filtros servem para consulta e organização.

O filtro por Tipo não define o tipo de um novo Pedido.

---

# 6. Criar novo Pedido

Fluxo:

~~~text
Usuário
   ↓
+ Novo Pedido
   ↓
Preenche cabeçalho
   ↓
Salva
   ↓
Pedido criado
status = AB
tipo = ''
~~~

O Pedido nasce:

- Aberto;
- sem tipo definido;
- sem itens.

---

# 7. Cabeçalho do Pedido

O cabeçalho reúne informações comuns a todos os tipos.

Entre elas:

- Loja;
- Fornecedor;
- Emissão;
- Previsão de Entrega;
- Desconto Geral;
- Frete;
- Observações.

O tipo do Pedido não é um campo de escolha manual.

---

# 8. Validação de Loja

Ao salvar o Pedido:

1. identificar a Empresa do usuário;
2. verificar a Loja;
3. validar se pertence à Empresa permitida;
4. associar o Pedido ao contexto empresarial correto.

Loja de outra Empresa deve ser rejeitada.

---

# 9. Validação de Fornecedor

Ao criar ou editar Pedido AB:

1. localizar Fornecedor;
2. verificar Empresa;
3. verificar se está ativo;
4. verificar se não está bloqueado;
5. permitir somente quando válido.

Fluxo inválido:

~~~text
Fornecedor inativo/bloqueado
        ↓
Novo Pedido
        ↓
REJEITAR
~~~

---

# 10. Abrir sobretela de Itens

Depois de criado o Pedido, o usuário acessa:

**Itens do Pedido**

A gestão de itens ocorre em sobretela/modal.

No primeiro acesso:

~~~text
pedido.tipo = ''
~~~

A interface apresenta layout inicial compatível com Pedido ainda sem tipo.

---

# 11. Busca do primeiro Produto

Fluxo:

~~~text
Sobretela de Itens
      ↓
Buscar Produto
      ↓
Selecionar Produto
      ↓
Backend verifica tipo_produto
~~~

Tipos aceitos:

~~~text
1 = Revenda
2 = Uso/Consumo
4 = Insumo
~~~

Tipo rejeitado:

~~~text
3 = Fabricação Própria
~~~

---

# 12. Produto que não participa de Compras

Se o Produto não for dos tipos 1, 2 ou 4:

~~~text
Produto selecionado
       ↓
Validação backend
       ↓
"Produto não participa de Compras"
       ↓
Item não criado
~~~

Não criar exceção visual que permita contornar essa regra.

---

# 13. Primeiro item define o tipo

Quando o Pedido ainda está sem tipo:

~~~text
pedido.tipo = ''
~~~

e o primeiro item é incluído:

~~~text
produto.tipo_produto
       ↓
pedido.tipo
~~~

Exemplo:

~~~text
Produto tipo 4
      ↓
Primeiro item
      ↓
Pedido.tipo = 4
      ↓
Pedido de Insumo
~~~

---

# 14. Adaptação da interface

Depois da definição do tipo, a sobretela de Itens passa a apresentar os campos específicos daquele fluxo.

~~~text
tipo = 1
→ layout Revenda

tipo = 2
→ layout Uso/Consumo

tipo = 4
→ layout Insumo
~~~

Uso/Consumo e Insumo compartilham a mesma mecânica básica de quantidade direta.

---

# 15. Fluxo de Revenda

Para Produto tipo 1:

~~~text
Selecionar Produto
      ↓
Selecionar Cor
      ↓
Selecionar Pack
      ↓
Informar número de Packs
      ↓
Informar preço
      ↓
Informar desconto, se houver
      ↓
Backend calcula quantidade
      ↓
Backend calcula total
      ↓
Item incluído
~~~

---

# 16. Cálculo de quantidade em Revenda

Fluxo:

~~~text
Pack selecionado
      ↓
Buscar PackItem
      ↓
Somar quantidades do Pack
      ↓
Multiplicar por n_packs
      ↓
Gerar qtd do item
~~~

Regra:

~~~text
qtd = soma_itens_pack × n_packs
~~~

O usuário não deve substituir esse cálculo por quantidade livre.

---

# 17. Exemplo de Revenda

Pack:

~~~text
PP = 1
P  = 1
M  = 2
G  = 1
GG = 1
~~~

Total:

~~~text
6 peças por Pack
~~~

Compra:

~~~text
10 Packs
~~~

Resultado:

~~~text
qtd = 60
~~~

---

# 18. Fluxo de Uso/Consumo

Para Produto tipo 2:

~~~text
Selecionar Produto
      ↓
Sistema identifica Unidade
      ↓
Informar quantidade
      ↓
Informar preço
      ↓
Informar desconto, se houver
      ↓
Calcular total
      ↓
Item incluído
~~~

Não existe Pack nesse fluxo.

---

# 19. Fluxo de Insumo

Para Produto tipo 4:

~~~text
Selecionar Produto
      ↓
Sistema identifica Unidade
      ↓
Informar quantidade
      ↓
Informar preço
      ↓
Informar desconto, se houver
      ↓
Calcular total
      ↓
Item incluído
~~~

A mecânica quantitativa é semelhante a Uso/Consumo.

O tipo continua sendo Insumo.

---

# 20. Validação de quantidade decimal

Para Uso/Consumo e Insumo:

~~~text
Produto
  ↓
Unidade
  ↓
permite_decimal?
~~~

Se:

~~~text
false
~~~

então:

~~~text
qtd decimal
   ↓
REJEITAR
~~~

Se:

~~~text
true
~~~

quantidade decimal pode ser aceita.

---

# 21. Inclusão de segundo item

Ao incluir outro Produto:

~~~text
produto.tipo_produto
       ↓
comparar com
pedido.tipo
~~~

Se forem iguais:

~~~text
permitir
~~~

Se forem diferentes:

~~~text
rejeitar
~~~

---

# 22. Exemplo de tentativa de mistura

Pedido:

~~~text
tipo = 1
Revenda
~~~

Usuário tenta incluir:

~~~text
Produto tipo 2
~~~

Resultado:

~~~text
REJEITAR
Pedido de Compra não permite misturar produtos de tipos diferentes
~~~

---

# 23. Alterar item

Enquanto:

~~~text
pedido.status = AB
~~~

o usuário pode editar item.

Fluxo:

~~~text
Selecionar item
      ↓
Editar
      ↓
Validar regras do tipo
      ↓
Recalcular item
      ↓
Recalcular Pedido
~~~

---

# 24. Excluir item

Enquanto o Pedido estiver AB:

~~~text
Selecionar item
      ↓
Excluir
      ↓
Remover item
      ↓
Recalcular totais
~~~

---

# 25. Exclusão do último item

Quando o item excluído for o último:

~~~text
Pedido
 ↓
0 itens
 ↓
tipo = ''
~~~

O Pedido volta ao estado sem tipo definido.

A próxima inclusão poderá redefinir seu tipo.

---

# 26. Recalcular totais

Após inclusão, alteração ou exclusão relevante:

~~~text
Itens
 ↓
Somar total_item
 ↓
total_itens
 ↓
Aplicar desconto geral
 ↓
Adicionar frete
 ↓
total_pedido
~~~

Regra:

~~~text
total_pedido =
total_itens
- total_desconto
+ frete
~~~

---

# 27. Desconto por item

Em cada item:

~~~text
qtd × preco_unit
       ↓
valor bruto
       ↓
- desconto_valor
       ↓
total_item
~~~

Esse desconto pertence somente à linha.

---

# 28. Desconto geral

O Pedido também pode possuir:

~~~text
total_desconto
~~~

Fluxo:

~~~text
total dos itens
      ↓
desconto geral
      ↓
frete
      ↓
total final
~~~

O valor final não pode ser negativo.

---

# 29. Frete

O frete é opcional.

Pode ser informado quando conhecido.

Fluxo:

~~~text
Pedido AB
   ↓
frete conhecido?
   ├── não → permanece 0
   └── sim → informar valor
~~~

O frete não deve ser obrigatório para aprovação apenas por existir o campo.

---

# 30. Abrir Forma de Pagamento

A Forma de Pagamento é tratada em sobretela.

Fluxo:

~~~text
Pedido AB
   ↓
Forma de Pagamento
   ↓
Abrir modal
~~~

O modal reúne:

- Forma;
- Prazo;
- Situação;
- Parcelas;
- Total do Pedido;
- Total das Parcelas;
- Diferença.

---

# 31. Selecionar Forma de Pagamento

Fluxo:

~~~text
Selecionar Forma
      ↓
Selecionar ou herdar Prazo
      ↓
Aplicar
      ↓
Backend valida Forma/Prazo
      ↓
Gerar parcelas PLAN
~~~

A Forma precisa estar válida e ativa.

---

# 32. Definição do Prazo

O Prazo pode ser:

- escolhido explicitamente;
- obtido pela configuração da Forma.

Fluxo:

~~~text
Forma
  ↓
Prazo informado?
  ├── sim → usar Prazo selecionado
  └── não → verificar Prazo da Forma
~~~

---

# 33. Geração de parcelas planejadas

Fluxo:

~~~text
Total do Pedido
      ↓
Configuração Forma/Prazo
      ↓
Dias / Percentuais
      ↓
Gerar PedidoCompraParcela
      ↓
status = PLAN
~~~

Cada parcela recebe:

- número;
- vencimento;
- valor;
- percentual, quando aplicável.

---

# 34. Cálculo de vencimento

Para cada configuração:

~~~text
data de emissão
      +
dias da parcela
      =
vencimento
~~~

---

# 35. Soma das parcelas

A geração deve garantir:

~~~text
soma das parcelas
=
total do Pedido
~~~

A interface apresenta a diferença.

Fluxo visual:

~~~text
Total Pedido
Total Parcelas
Diferença
Situação
~~~

---

# 36. Alteração do total após Forma aplicada

Enquanto o Pedido permanecer AB, mudanças em:

- itens;
- desconto geral;
- frete;
- cabeçalho relevante;

podem alterar o total.

O planejamento financeiro deve permanecer sincronizado.

Fluxo esperado:

~~~text
Total alterado
    ↓
Recalcular Pedido
    ↓
Regenerar parcelas PLAN quando aplicável
    ↓
Novo total das parcelas
~~~

---

# 37. Pedido pronto para aprovação

Antes da aprovação, o Pedido deve possuir:

- pelo menos um item;
- tipo válido;
- itens homogêneos;
- total maior que zero;
- Forma de Pagamento;
- planejamento financeiro válido.

A Natureza ainda será escolhida no ato da aprovação.

---

# 38. Abrir aprovação

Fluxo:

~~~text
Selecionar Pedido AB
      ↓
Aprovar
      ↓
Abrir modal de aprovação
      ↓
Selecionar Natureza de Lançamento
~~~

A Natureza não precisa permanecer exposta no cabeçalho principal.

---

# 39. Validar Natureza

Ao confirmar:

~~~text
idnatureza
    ↓
Existe?
    ↓
Pertence à Empresa permitida?
    ↓
Válida?
~~~

Se qualquer validação falhar:

~~~text
aprovação interrompida
~~~

---

# 40. Validações da aprovação

O backend valida:

~~~text
status = AB?
itens existem?
tipo válido?
todos os itens têm o mesmo tipo?
Forma definida?
Natureza válida?
total > 0?
parcelas existem?
parcelas consistentes?
~~~

Somente depois prossegue.

---

# 41. Geração financeira

A aprovação utiliza o planejamento de parcelas para gerar o Financeiro.

Fluxo conceitual:

~~~text
PedidoCompra
      ↓
PedidoCompraParcela PLAN
      ↓
Aprovação
      ↓
Pagar
      ↓
PagarItem
~~~

O Pedido é a origem do compromisso.

---

# 42. Transição para AP

Depois da aprovação válida:

~~~text
AB
 ↓
AP
~~~

O Pedido passa a aguardar recebimento.

Não deve mais permitir edição estrutural normal.

---

# 43. Consulta após aprovação

Depois de AP:

- cabeçalho torna-se essencialmente consulta;
- itens são consultáveis;
- Forma de Pagamento é consultável;
- parcelas são consultáveis;
- recebimentos são consultáveis.

O usuário não deve alterar livremente a composição já aprovada.

---

# 44. Recebimento fora do Pedido

A tela do Pedido não realiza a entrada física da mercadoria.

Quando uma Entrada de NF-e estiver recebendo aquele Pedido, o vínculo deve existir de forma estruturada.

Fluxo:

~~~text
Pedido AP
↓
Entrada de NF-e vinculada
↓
Importação / preparação
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

A tela do Pedido não substitui a Entrada de NF-e.

A existência desse fluxo não significa:

~~~text
Toda NF-e exige Pedido
~~~

Também existe Entrada de NF-e sem Pedido.

---

# 45. Abrir Recebimentos

No Pedido:

~~~text
Selecionar Pedido
      ↓
Recebimentos
      ↓
Abrir sobretela
~~~

A função principal é consulta.

Deve representar somente recebimentos efetivamente vinculados ao Pedido.

Pode apresentar:

- quantidade prevista;
- quantidade recebida;
- datas;
- situação;
- Entradas de NF-e relacionadas;
- informações operacionais disponíveis.

Essa sobretela não executa:

- importação de XML;
- conciliação;
- conferência;
- efetivação;
- movimentação direta de estoque.

---

# 46. Recebimento parcial

Exemplo:

~~~text
Pedido:
100 unidades

Recebido em NF-e válida vinculada:
40 unidades
~~~

Resultado:

~~~text
Entrega = Parcial
Pedido = AP
~~~

O Pedido continua aguardando o saldo pendente.

---

# 47. Novo recebimento parcial

Um mesmo Pedido pode possuir várias Entradas de NF-e válidas.

Exemplo:

~~~text
Pedido:
100

Recebido anteriormente:
40

Nova NF-e válida:
30

Acumulado:
70
~~~

Resultado:

~~~text
Pedido continua AP
~~~

---

# 48. Recebimento integral

Quando o acumulado das Entradas de NF-e válidas atingir integralmente o Pedido:

~~~text
Quantidade pedida
=
Quantidade recebida válida
~~~

Resultado:

~~~text
AP → AT
~~~

---

# 49. Estado Atendido

AT significa:

**Pedido integralmente atendido.**

Não significa apenas:

- aprovado;
- faturado;
- parcialmente recebido.

---

# 50. Cancelamento de Entrada de NF-e

Se uma Entrada de NF-e vinculada ao Pedido for cancelada:

~~~text
NF cancelada
↓
deixa de compor recebimento válido
↓
recalcular atendimento
~~~

Se o Pedido deixar de estar integralmente recebido:

~~~text
AT → AP
~~~

quando voltar a existir saldo pendente.

O cancelamento da NF também deve tratar seus próprios efeitos de Estoque, Custos e Financeiro.

---

# 51. Não duplicar recebimento

É proibido criar processo físico paralelo dentro do Pedido.

Fluxo inválido:

~~~text
Pedido movimenta Estoque
+
Entrada de NF-e movimenta Estoque novamente
~~~

Fluxo correto:

~~~text
Pedido
→ acompanha

Entrada de NF-e efetivada
→ produz o recebimento físico
~~~

---

# 52. Estoque

A aprovação não movimenta estoque.

Fluxo incorreto:

~~~text
Aprovar Pedido
      ↓
Entrada de estoque
~~~

Fluxo correto quando houver Pedido:

~~~text
Aprovar Pedido
↓
AP
↓
Entrada de NF-e vinculada
↓
Efetivação
↓
Estoque
~~~

A aprovação do Pedido não movimenta estoque.

A importação do XML também não movimenta estoque.

O movimento ocorre na efetivação da Entrada de NF-e.

---

# 53. Consultar Pedido

Fluxo:

~~~text
Listagem
   ↓
Selecionar Pedido
   ↓
Consultar
~~~

A consulta deve permitir visualizar, conforme disponibilidade:

- cabeçalho;
- tipo;
- status;
- itens;
- totais;
- Forma/Prazo;
- parcelas;
- Natureza financeira;
- recebimentos.

---

# 54. Editar Pedido

Fluxo permitido:

~~~text
Pedido AB
   ↓
Editar
~~~

Fluxo bloqueado:

~~~text
Pedido AP/AT/CA
   ↓
Edição estrutural
   ↓
BLOQUEAR
~~~

---

# 55. Excluir Pedido

Fluxo:

~~~text
Selecionar Pedido
      ↓
Excluir
      ↓
status == AB?
   ├── sim → permitir
   └── não → rejeitar
~~~

Exclusão não substitui cancelamento.

---

# 56. Cancelar Pedido

Quando a operação de cancelamento estiver disponível conforme regras vigentes:

~~~text
Pedido válido para cancelamento
      ↓
Confirmar
      ↓
CA
~~~

O Pedido permanece para histórico.

As consequências financeiras e operacionais devem respeitar as integrações existentes.

---

# 57. Busca de Produto em Pedido sem tipo

Quando ainda não há primeiro item:

~~~text
Pedido.tipo = ''
~~~

a busca pode apresentar produtos participantes de Compras.

Após selecionar um Produto válido e incluí-lo, o Pedido passa a ser restringido ao tipo correspondente.

---

# 58. Busca de Produto após definição do tipo

Depois que:

~~~text
Pedido.tipo = 2
~~~

a interface deve priorizar/exibir produtos compatíveis com tipo 2.

Mesmo assim, o backend continua sendo a proteção definitiva.

---

# 59. Fluxo completo de Revenda

~~~text
Novo Pedido
    ↓
Cabeçalho
    ↓
Itens
    ↓
Selecionar Produto Revenda
    ↓
tipo = 1
    ↓
Cor
    ↓
Pack
    ↓
Número de Packs
    ↓
Quantidade automática
    ↓
Preço / Desconto
    ↓
Adicionar demais itens tipo 1
    ↓
Forma / Prazo
    ↓
Parcelas
    ↓
Aprovação + Natureza
    ↓
Financeiro
    ↓
AP
    ↓
NF Entrada
    ↓
Recebimento
    ↓
AT
~~~

---

# 60. Fluxo completo de Uso/Consumo

~~~text
Novo Pedido
    ↓
Cabeçalho
    ↓
Itens
    ↓
Selecionar Produto Uso/Consumo
    ↓
tipo = 2
    ↓
Quantidade conforme Unidade
    ↓
Preço / Desconto
    ↓
Adicionar demais itens tipo 2
    ↓
Forma / Prazo
    ↓
Parcelas
    ↓
Aprovação + Natureza
    ↓
Financeiro
    ↓
AP
    ↓
NF Entrada / Recebimento
    ↓
AT
~~~

---

# 61. Fluxo completo de Insumo

~~~text
Novo Pedido
    ↓
Cabeçalho
    ↓
Itens
    ↓
Selecionar Insumo
    ↓
tipo = 4
    ↓
Quantidade conforme Unidade
    ↓
Preço / Desconto
    ↓
Adicionar demais itens tipo 4
    ↓
Forma / Prazo
    ↓
Parcelas
    ↓
Aprovação + Natureza
    ↓
Financeiro
    ↓
AP
    ↓
NF Entrada / Recebimento
    ↓
AT
~~~

---

# 62. Tentativa de Fabricação Própria

~~~text
Pedido AB
   ↓
Selecionar Produto tipo 3
   ↓
Backend
   ↓
Produto não participa de Compras
   ↓
Item rejeitado
~~~

O usuário deve utilizar o fluxo de Produção.

---

# 63. Fluxo multiempresa

Em qualquer operação:

~~~text
Usuário
   ↓
Empresa
   ↓
Pedido
   ↓
Loja / Fornecedor / Natureza / Forma / Prazo
~~~

Os relacionamentos devem pertencer ao contexto permitido.

A tentativa de cruzar Empresas deve ser rejeitada.

---

# 64. Auditoria

Operações relevantes devem passar pela Auditoria Central.

Exemplo:

~~~text
Alteração relevante
      ↓
Executar operação
      ↓
Commit da transação
      ↓
Registrar auditoria
~~~

O histórico técnico não deve depender apenas de logs visuais.

---

# 65. Fluxo visual da tela

Estrutura aprovada:

~~~text
Tela principal
    ↓
Listagem
    ↓
Selecionar linha
    ↓
Barra de ações
    ├── Consultar
    ├── Editar
    ├── Excluir
    ├── Aprovar
    ├── Forma de Pagamento
    ├── Recebimentos
    └── demais ações permitidas pelo estado
~~~

As ações disponíveis dependem do status.

---

# 66. Sobretelas

Estruturas subordinadas devem permanecer em modal/sobretela:

- Itens;
- Forma de Pagamento;
- Recebimentos;
- aprovação/Natureza;
- pesquisas auxiliares.

Isso preserva a tela principal limpa.

---

# 67. Fluxo de seleção nas sobretelas

Quando houver tabelas de detalhe:

~~~text
Tabela
  ↓
Selecionar uma linha
  ↓
Linha destacada
  ↓
Barra de ações
~~~

Não utilizar coluna genérica de ações como padrão principal onde o padrão homologado do sistema usar seleção de linha.

---

# 68. Erro durante inclusão de item

Fluxo:

~~~text
Usuário informa item
      ↓
Backend valida
      ↓
Erro
      ↓
Item NÃO salvo
      ↓
Pedido preservado
      ↓
Mensagem ao usuário
~~~

Não deixar alteração parcial do Pedido.

---

# 69. Erro durante aprovação

Se qualquer validação falhar:

~~~text
Aprovação
   ↓
Falha
   ↓
Pedido permanece AB
   ↓
Financeiro não deve ficar parcialmente gerado
~~~

A operação deve preservar atomicidade.

---

# 70. Atomicidade financeira

A aprovação é uma operação crítica.

Conceitualmente:

~~~text
Validar tudo
    ↓
Gerar Financeiro
    ↓
Atualizar parcelas
    ↓
Atualizar Pedido
    ↓
Confirmar transação
~~~

Se houver erro:

~~~text
ROLLBACK
~~~

Não deixar:

- Pagar sem Pedido aprovado;
- parcelas parcialmente geradas;
- status inconsistente.

---

# 71. Alteração da Forma antes da aprovação

Enquanto AB:

~~~text
Forma atual
   ↓
Usuário escolhe nova Forma/Prazo
   ↓
Aplicar
   ↓
Excluir/regenerar planejamento PLAN
   ↓
Novo planejamento
~~~

---

# 72. Forma após aprovação

Depois de AP, a Forma de Pagamento deve ser tratada como informação já consolidada no fluxo financeiro.

Alterações posteriores não devem ser feitas por simples edição do Pedido.

---

# 73. Estado e ações

Resumo:

~~~text
AB
→ criar/editar/excluir itens
→ alterar cabeçalho
→ configurar pagamento
→ aprovar
→ excluir Pedido

AP
→ consultar
→ acompanhar recebimento

AT
→ consultar histórico e atendimento

CA
→ consultar histórico
~~~

---

# 74. Retomada de Pedido vazio

Exemplo:

~~~text
Pedido AB
tipo = 1
1 item de Revenda
   ↓
Excluir último item
   ↓
0 itens
tipo = ''
   ↓
Adicionar primeiro item tipo 4
   ↓
tipo = 4
~~~

Esse comportamento é válido e homologado.

---

# 75. Separação entre Pedido e documento fiscal

Pedido responde:

~~~text
O que queremos comprar?
De quem?
Quanto?
Por quanto?
Quando?
Como pagar?
~~~

Nota Fiscal de Entrada responde:

~~~text
O que efetivamente entrou?
Qual documento fiscal?
Quais tributos?
Qual recebimento ocorreu?
~~~

Os dois processos se integram, mas não se substituem.

---

# 76. Separação entre Pedido e Financeiro

Pedido responde:

~~~text
Qual compromisso será assumido?
~~~

Financeiro responde:

~~~text
Quais títulos existem?
Quando vencem?
Foram pagos?
Quanto foi baixado?
~~~

A aprovação faz a ponte entre os dois.

---

# 77. Fluxo de homologação aprovado

A homologação manual confirmou o funcionamento geral do fluxo:

~~~text
Criar
→ incluir item
→ definir tipo
→ impedir mistura
→ configurar pagamento
→ aprovar
→ consultar
→ acompanhar recebimento
~~~

Além das correções visuais aplicadas às sobretelas.

---

# 78. Regra para evoluções futuras

Antes de alterar qualquer workflow:

1. consultar este documento;
2. consultar [[Mapa Técnico - Compras - Pedido de Compra]];
3. consultar [[Modelo de Domínio - Compras - Pedido de Compra]];
4. consultar [[Riscos e Cuidados - Compras - Pedido de Compra]];
5. consultar [[Homologação - Compras - Pedido de Compra]];
6. consultar backend e frontend atuais;
7. verificar integrações impactadas.

---

# 79. Situação final

Os workflows do Pedido de Compra unificado estão:

**IMPLEMENTADOS E HOMOLOGADOS**

Este documento representa o fluxo funcional de referência para continuidade do módulo de Compras.