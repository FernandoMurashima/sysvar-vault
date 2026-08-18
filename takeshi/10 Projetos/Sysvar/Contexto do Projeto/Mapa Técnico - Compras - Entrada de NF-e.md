---
type: technical-map
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
  - multiempresa
  - auditoria
  - homologado
---

# Mapa Técnico - Compras - Entrada de NF-e

## 1. Identificação

- **Projeto:** [[Sysvar]]
- **Módulo:** Compras
- **Funcionalidade:** Entrada de NF-e
- **Tipos de compra contemplados:** Revenda, Uso/Consumo e Insumo
- **Situação:** IMPLEMENTADO E HOMOLOGADO
- **Homologação técnica:** aprovada
- **Homologação manual:** aprovada pelo usuário
- **Data da homologação final:** 18/08/2026

### Documentos relacionados

- [[Sysvar]]
- [[Mapa Técnico - Compras - Pedido de Compra]]
- [[Workflows - Compras - Pedido de Compra]]
- [[Modelo de Domínio - Compras - Pedido de Compra]]
- [[Riscos e Cuidados - Compras - Pedido de Compra]]
- [[Homologação - Compras - Pedido de Compra]]
- [[Homologação - Compras - Entrada de NF-e]]

---

# 2. Objetivo

A Entrada de NF-e é a etapa de recebimento efetivo de mercadorias e materiais originados de um Pedido de Compra.

O fluxo parte de um Pedido previamente aprovado e registra o documento fiscal efetivamente recebido.

A Entrada de NF-e é responsável pela integração entre:

- Pedido de Compra;
- recebimento;
- estoque;
- custos;
- financeiro;
- auditoria.

A funcionalidade contempla:

1. Revenda;
2. Uso/Consumo;
3. Insumo.

Fabricação Própria não participa deste fluxo de Compras.

---

# 3. Princípio funcional

O processo homologado é:

~~~text
Pedido de Compra aprovado
        ↓
Entrada de NF-e
        ↓
Seleção do Pedido
        ↓
Informação dos dados da NF
        ↓
Confirmação dos itens recebidos
        ↓
Fechamento da NF
        ↓
Estoque
Custos
Financeiro
Recebimento do Pedido
        ↓
Pedido AP ou AT
~~~

Uma mesma compra pode ser recebida em mais de uma Nota Fiscal.

Portanto:

~~~text
1 Pedido de Compra
        ↓
1 ou várias NFs de Entrada
~~~

O Pedido de Compra não identifica unicamente uma Nota Fiscal.

---

# 4. Localização funcional

A funcionalidade pertence ao módulo:

**Compras**

A rota principal do frontend é:

~~~text
/compras/notas-entrada
~~~

No menu existe somente:

**Entrada de NF-e**

A antiga opção separada:

**Notas Lançadas**

foi eliminada.

As próprias notas já registradas são consultadas na listagem da Entrada de NF-e.

Não existe uma tela paralela de Notas Lançadas.

---

# 5. Permissão de acesso

A Entrada de NF-e utiliza o módulo:

~~~text
compras
~~~

Não é necessário possuir simultaneamente acesso ao módulo `fiscal`.

A regra homologada é:

- usuário com acesso adequado a Compras pode acessar a funcionalidade;
- usuário sem acesso a Compras é bloqueado;
- usuário somente com acesso a Fiscal é bloqueado;
- nível VIEW permite leitura;
- nível EDIT permite operações de escrita conforme as demais regras do processo.

Frontend e backend utilizam a mesma regra.

---

# 6. Backend

A implementação está concentrada principalmente no app Django:

~~~text
fiscal
~~~

Arquivos centrais:

- `fiscal/models/nota_fiscal_entrada.py`
- `fiscal/serializers/nota_fiscal_entrada.py`
- `fiscal/views/nota_fiscal_entrada.py`
- `fiscal/urls.py`
- `fiscal/tests.py`

Integrações relevantes:

- `compras`
- `produto`
- `financeiro`
- `estoque`
- `cadastros`
- `accounts`
- `auditoria`

Embora tecnicamente implementada dentro do app `fiscal`, a Entrada de NF-e pertence funcionalmente ao módulo de Compras.

---

# 7. Frontend

A funcionalidade está concentrada em:

~~~text
src/app/features/notas-fiscais-entrada
~~~

Arquivos principais:

- `notas-fiscais-entrada.component.ts`
- `notas-fiscais-entrada.component.html`
- `notas-fiscais-entrada.component.css`
- `notas-fiscais-entrada.component.spec.ts`

Serviço:

~~~text
src/app/core/services/notas-fiscais-entrada.service.ts
~~~

A tela concentra:

- consulta das NFs;
- inclusão;
- edição de NF aberta;
- itens;
- fechamento;
- cancelamento.

---

# 8. Modelo NotaFiscalEntrada

Model principal:

~~~text
fiscal.models.NotaFiscalEntrada
~~~

Campos funcionais principais incluem:

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

# 9. Status da Nota Fiscal

Os estados utilizados são:

~~~text
AB = Aberta
FE = Fechada
CA = Cancelada
~~~

## AB — Aberta

Permite edição dos dados e dos itens dentro das regras vigentes.

## FE — Fechada

Representa uma NF efetivada.

Pode produzir efeitos em:

- estoque;
- custos;
- financeiro;
- recebimento do Pedido.

Seus itens ficam somente para consulta.

## CA — Cancelada

Representa uma NF anteriormente registrada que foi cancelada funcionalmente.

A nota permanece registrada.

Seus itens ficam somente para consulta.

---

# 10. Exclusão física

DELETE direto de `NotaFiscalEntrada` é bloqueado.

Uma NF não deve ser eliminada fisicamente pelo fluxo operacional normal.

Quando necessário desfazer uma NF efetivada, utiliza-se:

**Cancelar NF**

Isso preserva:

- rastreabilidade;
- histórico;
- integrações;
- auditoria.

---

# 11. Relação com Pedido de Compra

A NF é obrigatoriamente vinculada a um Pedido de Compra no fluxo atual.

O Pedido deve:

- pertencer à empresa autorizada;
- estar disponível para recebimento;
- possuir os itens correspondentes.

A Entrada de NF-e não cria um fluxo paralelo de recebimento.

O recebimento real do Pedido continua sendo determinado pelas NFs de Entrada.

---

# 12. Recebimento parcial

Um Pedido pode ser atendido parcialmente.

Exemplo:

~~~text
Pedido = 100 unidades

NF 1 = 60
Pedido permanece AP

NF 2 = 40
Pedido passa para AT
~~~

Os estados relevantes do Pedido são:

~~~text
AP = Aprovado / ainda com saldo a receber
AT = Atendido
~~~

O recebimento considera somente NFs fechadas e válidas.

NF cancelada deixa de compor o recebido.

---

# 13. Múltiplas NFs

É permitido registrar várias NFs diferentes para o mesmo Pedido.

Exemplo:

~~~text
Pedido 500

NF 1001 → recebimento parcial
NF 1002 → recebimento complementar
NF 1003 → eventual saldo restante
~~~

Cada NF mantém seus próprios efeitos em:

- itens;
- estoque;
- custos;
- financeiro;
- rastreabilidade.

O cancelamento de uma NF não deve desfazer efeitos pertencentes às demais.

---

# 14. Regra de identidade documental

A regra homologada de duplicidade manual é:

~~~text
Empresa
+ Fornecedor
+ Modelo
+ Série
+ Número da Nota
~~~

O Pedido de Compra não participa da identidade da NF.

Portanto:

~~~text
mesma empresa
+ mesmo fornecedor
+ mesmo modelo
+ mesma série
+ mesmo número
= duplicidade
~~~

---

# 15. Mesmo número em documentos diferentes

O mesmo número de NF pode existir quando a identidade documental for diferente.

São situações válidas:

### Fornecedor diferente

~~~text
Fornecedor A
Modelo 55
Série 1
NF 123
~~~

e:

~~~text
Fornecedor B
Modelo 55
Série 1
NF 123
~~~

### Série diferente

~~~text
Fornecedor A
Modelo 55
Série 1
NF 123
~~~

e:

~~~text
Fornecedor A
Modelo 55
Série 2
NF 123
~~~

### Empresa diferente

Empresas distintas também permanecem isoladas entre si.

---

# 16. Chave de acesso

A chave de acesso é opcional no lançamento manual atual.

Quando informada:

- deve conter exatamente 44 dígitos;
- deve conter somente números;
- o dígito verificador é validado;
- não pode existir duplicada.

A chave permanece vinculada ao documento mesmo quando a NF é cancelada.

Cancelar uma NF não libera sua chave para cadastrar outro documento.

No banco, `chave_acesso` aceita `NULL` quando ausente e possui proteção de unicidade quando preenchida.

---

# 17. Multiempresa

A Entrada de NF-e é protegida por tenant.

O isolamento ocorre tanto para a NF quanto para seus itens.

Um usuário de uma empresa não pode:

- listar NFs de outra empresa;
- abrir NF de outra empresa por ID;
- acessar seus itens;
- criar NF usando Pedido de outra empresa;
- relacionar item de outro tenant;
- utilizar filtros para atravessar a empresa;
- contaminar indicadores com dados de outro tenant.

A proteção é aplicada no backend.

O frontend não é considerado barreira suficiente de segurança.

---

# 18. Itens da NF

Model:

~~~text
NotaFiscalEntradaItem
~~~

O item está relacionado a:

- NotaFiscalEntrada;
- PedidoCompraItem.

Campos principais:

- quantidade recebida;
- preço unitário da NF;
- desconto do item;
- total do item.

O `PedidoCompraItem` deve pertencer ao mesmo Pedido vinculado à NF.

---

# 19. Confirmação dos itens

A interface homologada utiliza um checkbox por linha.

A primeira coluna compacta utiliza:

**OK**

O significado é:

~~~text
checkbox desmarcado
= item ainda não está gravado na NF

checkbox marcado
= item está efetivamente gravado na NF
~~~

O checkbox representa o estado persistido no backend.

Não é apenas uma marcação visual temporária.

---

# 20. Comportamento do checkbox

## Marcar

Ao marcar um item:

- utiliza quantidade desta NF;
- utiliza preço informado;
- utiliza desconto informado;
- executa a mesma operação de gravação do item;
- só permanece marcado depois de sucesso do backend.

Em caso de erro:

- permanece desmarcado;
- o erro é apresentado ao usuário.

## Desmarcar

Ao desmarcar um item já confirmado:

- executa a remoção do item da NF;
- preserva a confirmação de remoção existente;
- só fica desmarcado após sucesso.

Em caso de erro:

- permanece marcado;
- o registro continua na NF.

---

# 21. Checkbox e seleção de linha

Checkbox e seleção de linha são conceitos diferentes.

~~~text
Linha selecionada
= contexto visual atual

Checkbox marcado
= item efetivamente pertencente à NF
~~~

A seleção permanece única.

A linha selecionada utiliza o destaque visual padrão do Sysvar.

---

# 22. Interface de itens

O padrão homologado não utiliza:

- coluna `Ações`;
- botão `Inserir` na barra;
- botão `Remover` na barra;
- botões repetidos por linha;
- menu de três pontos;
- `RowActionsMenuComponent`.

A confirmação do item ocorre diretamente pelo checkbox `OK`.

Em NF:

~~~text
AB → checkbox editável
FE → checkbox somente leitura
CA → checkbox somente leitura
~~~

---

# 23. Quantidades apresentadas

A tabela apresenta de forma explícita:

- **Pedida**
- **Já recebida**
- **Saldo pendente**
- **Nesta NF**

Exemplo conceitual:

~~~text
Pedida:          100
Já recebida:      60
Saldo pendente:   40
Nesta NF:         20
~~~

Esses valores permitem identificar imediatamente a situação do item no Pedido.

---

# 24. Revenda

Para Revenda, permanecem as regras relacionadas a:

- Produto;
- Cor;
- Pack;
- tamanhos;
- SKU;
- quantidade de packs.

O recebimento deve respeitar a composição válida do Pack.

Quantidades incompatíveis com a composição não são aceitas.

O fechamento distribui a entrada entre os SKUs/tamanhos correspondentes.

---

# 25. Uso/Consumo e Insumo

Para Uso/Consumo e Insumo:

- quantidade é informada diretamente;
- podem existir quantidades decimais conforme a Unidade utilizada;
- o estoque é movimentado conforme o Produto;
- os custos são atualizados conforme a regra vigente.

Não utilizam distribuição por Pack como Revenda.

---

# 26. Validação de quantidade

A quantidade:

- não pode ser negativa;
- não pode ultrapassar o saldo disponível;
- deve respeitar a regra de Pack quando aplicável.

O backend é a autoridade definitiva.

---

# 27. Preço e desconto

O preço unitário não pode ser negativo.

Para o desconto:

~~~text
valor_bruto = qtd_recebida × preco_unit_nf
~~~

É permitido:

~~~text
desconto_item = valor_bruto
~~~

Nesse caso:

~~~text
total_item = 0
~~~

Não é permitido:

~~~text
desconto_item > valor_bruto
~~~

Nem desconto negativo.

---

# 28. Total do item

O total é calculado por:

~~~text
total_item = valor_bruto - desconto_item
~~~

A regra estrutural é:

~~~text
total_item >= 0
~~~

O backend protege essa condição.

---

# 29. Totais da NF

Os totais utilizados incluem:

- valor dos produtos;
- descontos;
- frete;
- valor total.

O total final não pode ficar negativo.

O recálculo é protegido no backend.

---

# 30. Datas

A regra homologada é:

~~~text
dt_entrada >= dt_emissao
~~~

É permitido:

- emissão e entrada no mesmo dia;
- entrada posterior à emissão.

É bloqueado:

- entrada anterior à emissão.

A regra vale para criação e edição permitida de NF aberta.

---

# 31. Contexto do Pedido na tela

Após selecionar ou abrir uma NF vinculada a Pedido, a interface mostra de forma compacta:

- Pedido;
- Loja;
- Fornecedor;
- Tipo de compra.

Os tipos apresentados utilizam a nomenclatura consolidada:

- Revenda;
- Uso/Consumo;
- Insumo.

Essa informação existe para reduzir o risco de lançamento no Pedido errado.

---

# 32. Fechamento da NF

O fechamento transforma a NF aberta em uma entrada efetivada.

O processo integra, conforme o tipo:

~~~text
NF AB
  ↓
validações
  ↓
estoque
  ↓
custos
  ↓
financeiro
  ↓
recebimento do Pedido
  ↓
NF FE
~~~

A operação é transacional.

Falha em etapa crítica deve impedir permanência de estado parcial.

---

# 33. Estoque

O fechamento gera movimentações de estoque correspondentes aos itens efetivamente recebidos.

A identificação técnica da entrada utiliza:

~~~text
NFE:<id>:ENTRADA
~~~

O número comercial da NF não é utilizado isoladamente para garantir idempotência.

Isso evita colisão entre:

- fornecedores;
- séries;
- empresas;
- documentos distintos com mesmo número.

---

# 34. Cancelamento e estoque

O cancelamento de uma NF fechada gera o movimento correspondente de estorno:

~~~text
NFE:<id>:CANCEL
~~~

O estorno:

- corresponde à própria NF;
- não afeta outra NF;
- não deve ser gerado duas vezes.

---

# 35. Estoque negativo

No cancelamento, a configuração da Loja é respeitada.

Se a Loja não permite estoque negativo e o estorno tornaria o saldo negativo:

- o cancelamento é bloqueado;
- a NF permanece FE;
- estoque permanece inalterado;
- financeiro permanece inalterado;
- custos permanecem inalterados;
- Pedido permanece inalterado.

Quando a Loja permite estoque negativo, o comportamento segue essa configuração.

---

# 36. Custos de Revenda

O fechamento de Revenda atualiza custos dos SKUs envolvidos.

São considerados os campos de custo vigentes do SKU, incluindo:

- custo original;
- custo da última compra;
- custo médio.

O custo médio utiliza a regra vigente de cálculo sobre as entradas.

---

# 37. Custos de Uso/Consumo e Insumo

Para Uso/Consumo e Insumo, os efeitos de custo recaem sobre o Produto conforme a regra vigente.

O cancelamento recalcula os custos considerando NFs fechadas e válidas.

NF cancelada deixa de compor o cálculo.

---

# 38. Recalculo de custos no cancelamento

O cancelamento não simplesmente restaura um valor antigo de forma cega.

Os custos são recalculados com base no histórico disponível de NFs:

~~~text
status = FE
e não canceladas
~~~

Isso preserva entradas válidas posteriores.

Exemplo:

~~~text
NF 1
NF 2
NF 3
~~~

Cancelar NF 1 não deve apagar o efeito legítimo de NF 2 e NF 3.

---

# 39. Financeiro no fechamento

A Entrada de NF-e integra com Contas a Pagar.

O Pedido aprovado possui planejamento/previsão financeira.

À medida que NFs são efetivadas, o financeiro correspondente é realizado.

O fluxo suporta:

- NF que atende integralmente o valor previsto;
- NF parcial;
- várias NFs para o mesmo Pedido.

---

# 40. Financeiro em recebimento parcial

Quando uma NF representa somente parte do Pedido:

- o valor correspondente à NF é efetivado;
- o saldo restante permanece previsto;
- outras NFs podem realizar posteriormente o restante.

Não devem existir:

- previsões duplicadas;
- títulos duplicados;
- realização financeira de outra NF alterada indevidamente.

---

# 41. Financeiro no cancelamento

Cancelar uma NF desfaz somente os efeitos financeiros produzidos por aquela NF.

Outras NFs do mesmo Pedido permanecem intactas.

O saldo/previsão restante do Pedido é recalculado de forma coerente.

---

# 42. Financeiro já baixado

Se a NF já possuir efeito financeiro efetivamente baixado/pago e a reversão não for segura:

**o cancelamento é bloqueado.**

O sistema não força reversão silenciosa de pagamento.

Nesse cenário:

- NF permanece FE;
- estoque não é estornado;
- custos não são alterados;
- Pedido não é alterado.

---

# 43. Atomicidade

Fechamento e cancelamento são operações que atravessam múltiplos subsistemas.

As operações críticas são tratadas transacionalmente.

O princípio é:

~~~text
ou tudo é concluído
ou nada permanece alterado
~~~

Em falha, deve ocorrer rollback dos efeitos aplicáveis em:

- NF;
- Pedido;
- estoque;
- movimentações;
- custos;
- Pagar;
- PagarItem.

---

# 44. Recebimento do Pedido

Após fechamento ou cancelamento, o recebimento do Pedido é recalculado.

São consideradas somente NFs válidas e fechadas.

O comportamento homologado inclui:

~~~text
recebimento parcial → AP
recebimento completo → AT
~~~

Se uma NF for cancelada e o Pedido deixar de estar totalmente atendido:

~~~text
AT → AP
~~~

---

# 45. Paginação

A listagem utiliza paginação server-side.

O frontend não carrega mais artificialmente:

~~~text
page_size=1000
~~~

A API utiliza o padrão paginado do projeto:

- `count`
- `next`
- `previous`
- `results`

Mudança de página gera nova consulta ao backend.

---

# 46. Filtros

A API suporta filtros por:

- Pedido;
- Status;
- Número;
- Chave de acesso;
- Fornecedor;
- Loja;
- período de emissão;
- período de entrada;
- valor mínimo;
- valor máximo;
- busca geral.

Na interface atual, Pedido, Número e Chave também podem ser alcançados operacionalmente pela busca geral.

Os filtros são processados no backend.

---

# 47. Indicadores

A listagem apresenta indicadores baseados no conjunto filtrado completo.

O endpoint específico fornece:

- total;
- abertas;
- fechadas;
- canceladas;
- valor total.

Os indicadores não são calculados apenas sobre os registros da página atual.

---

# 48. Seleção na listagem

A seleção da NF permanece vinculada à página visível.

Ao trocar de página, caso o registro selecionado não esteja mais presente, a seleção é limpa.

Isso evita ações sobre um registro que não está mais no contexto visual atual.

---

# 49. Auditoria

As operações relevantes seguem o padrão de auditoria existente.

No cancelamento, o registro de sucesso deve corresponder a uma transação efetivamente concluída.

Uma operação revertida por rollback não deve ser registrada como cancelamento concluído.

---

# 50. Rastreabilidade

A partir da NF deve ser possível relacionar:

- Pedido;
- itens;
- entrada de estoque;
- cancelamento de estoque;
- efeitos financeiros;
- recebimento.

A identificação técnica das movimentações é baseada no ID interno da NF.

Isso permite coexistência segura de documentos com mesmo número comercial.

---

# 51. Testes automatizados

A implementação foi fechada com cobertura específica no módulo `fiscal`.

Na homologação técnica final:

~~~text
manage.py test fiscal --keepdb
45 testes
OK
~~~

Também foram validados:

~~~text
compras.tests.PedidoCompraUnificadoTests
15 testes
OK
~~~

~~~text
produto.tests
16 testes
OK
~~~

~~~text
accounts.tests.SaaSAccessControlTests
33 testes
OK
~~~

~~~text
manage.py check
OK
~~~

---

# 52. Testes frontend

A homologação final da Entrada de NF-e e da rota/permissão executou:

~~~text
25 testes Angular
SUCCESS
~~~

Depois da alteração final de confirmação dos itens por checkbox, o componente específico executou:

~~~text
22 testes
SUCCESS
~~~

Build:

~~~text
ng build --configuration development
OK
~~~

---

# 53. Testes integrados adicionais

O fechamento da cobertura incluiu cenários integrados de:

- múltiplas NFs no mesmo Pedido;
- recebimento parcial e final;
- cancelamento parcial;
- reentrada do saldo;
- Revenda com Pack multitamanho;
- estoque por SKU;
- isolamento multiempresa;
- Uso/Consumo;
- Insumo;
- quantidades decimais;
- financeiro;
- custo médio;
- rollback integral em erro.

---

# 54. Commits relevantes

Principais commits do ciclo de revisão e homologação:

## Backend

~~~text
37fcbb93162327022db1862111b64e9e08fe4786
Segurança e multiempresa
~~~

~~~text
3bc99650bf455e7c42e8ffb12c872f0e00865010
Cancelamento, financeiro, custos e estoque
~~~

~~~text
ec4697d27ca8b41c7a34b6869217fd75f534158a
Identidade da NF e duplicidade
~~~

~~~text
a529ad3afe5f17ee87c55bf1461aea43d6a01ce8
Permissões
~~~

~~~text
768e87208f6924d9d1acd69ed115cdafe62400c3
Paginação e filtros
~~~

~~~text
457c30b666a5d8470c64cdd109ee806ca179a86a
Validações funcionais
~~~

~~~text
ba6911f
Cobertura integrada do Bloco 8
~~~

## Frontend

~~~text
2afa9abffe65c3e75fe52eb541492e3f9bd66159
Remoção de Notas Lançadas
~~~

~~~text
dcb469ee7734384f2ccad6641414a07343d5d367
Permissões e rota
~~~

~~~text
3508725f2e4d65c34ee64fd0558017a46707720f
Paginação e filtros
~~~

~~~text
77bd8f931cc5c36c82dd585e1e999e3f4f329829
Padrão inicial de seleção e barra dos itens
~~~

~~~text
339e04536180ad65e2b3d4df9698c4c17a89bc55
Validações e apresentação das informações
~~~

~~~text
e349eb7
Confirmação dos itens por checkbox
~~~

---

# 55. Homologação final

A homologação técnica final foi:

**APROVADA**

Nenhum defeito técnico adicional foi encontrado na bateria final.

Depois da homologação técnica, o usuário realizou homologação manual da funcionalidade.

Foi identificada somente uma melhoria visual/operacional na confirmação dos itens:

- remoção do botão `Inserir`;
- remoção do botão `Remover`;
- adoção do checkbox `OK` por item.

A melhoria foi implementada, testada e novamente homologada pelo usuário.

Situação final:

**MÓDULO APROVADO**

Data:

**18/08/2026**

---

# 56. Regra de preservação

A Entrada de NF-e é uma funcionalidade homologada.

Não deve ser reaberta ou reimplementada sem:

- novo requisito;
- defeito comprovado;
- nova integração necessária;
- mudança de regra de negócio;
- alteração arquitetural que realmente afete o fluxo.

Alterações futuras devem preservar as regras aqui documentadas que não forem explicitamente substituídas por nova decisão aprovada.

---

# 57. Resumo do estado vigente

~~~text
Entrada de NF-e
Status: HOMOLOGADA

Módulo de acesso:
Compras

Tipos:
Revenda
Uso/Consumo
Insumo

Pedido:
obrigatório no fluxo atual

Recebimento parcial:
sim

Múltiplas NFs:
sim

Identidade:
Empresa + Fornecedor + Modelo + Série + Número

Chave:
opcional quando ausente
44 dígitos + DV quando informada
única

Estoque:
integrado

Custos:
integrados

Financeiro:
integrado

Cancelamento:
integrado e transacional

Movimento de entrada:
NFE:<id>:ENTRADA

Movimento de cancelamento:
NFE:<id>:CANCEL

DELETE físico:
bloqueado

Paginação:
server-side

Filtros:
backend

Confirmação de item:
checkbox OK

Homologação técnica:
aprovada

Homologação manual:
aprovada em 18/08/2026
~~~