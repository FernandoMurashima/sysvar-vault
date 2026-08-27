---
type: technical-map
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
  - recusa-entrada
  - forma-pagamento-fiscal
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
- **Data da homologação final:** 27/08/2026

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

A Entrada de NF-e é o fluxo responsável por registrar no Sysvar o documento fiscal de entrada efetivamente recebido.

A funcionalidade evoluiu para um processo completo baseado em XML de NF-e, sem tornar o Pedido de Compra obrigatório.

A entrada pode ocorrer:

- vinculada a Pedido de Compra;
- sem Pedido de Compra.

O fluxo integra:

- documento fiscal XML;
- fornecedor;
- Produto × Fornecedor;
- conciliação de itens;
- conferência física;
- divergências;
- Pedido de Compra, quando existente;
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

O fluxo vigente é:

~~~text
XML da NF-e
        ↓
Importação
        ↓
Preservação dos dados fiscais
        ↓
Identificação do fornecedor
        ↓
Produto × Fornecedor
        ↓
Conciliação dos itens
        ↓
Conferência física
        ↓
Análise de divergências
        ↓
Validação com Pedido, quando houver
        ↓
Efetivação
        ↓
Estoque
Custos
Financeiro
Recebimento do Pedido, quando houver
Auditoria
~~~

A NF-e pode ser recebida sem Pedido.

Quando vinculada a Pedido, o sistema também controla:

- fornecedor;
- Loja;
- item;
- quantidade;
- saldo do Pedido;
- preço aprovado;
- recebimentos anteriores.

Uma mesma compra pode ser recebida em várias NFs.

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

A tela atual concentra:

- consulta das NFs;
- importação de XML;
- seleção opcional de Pedido;
- resumo fiscal;
- conciliação;
- vínculo Produto × Fornecedor;
- conferência física;
- divergências;
- cobrança fiscal;
- financeiro;
- efetivação;
- cancelamento de NF efetivada;
- recusa de importação provisória;
- bloqueios de finalidade fiscal especial.

A tela Produto × Fornecedor também permite administrar:

- fornecedor;
- código externo;
- produto interno;
- unidade do fornecedor;
- fator de conversão;
- status do vínculo.

---

# 8. Modelo NotaFiscalEntrada

Model principal:

~~~text
fiscal.models.NotaFiscalEntrada
~~~

A entidade representa tanto o lançamento operacional quanto a identidade fiscal da entrada.

Entre os dados relevantes estão, conforme o fluxo:

- empresa;
- fornecedor;
- Pedido de Compra opcional;
- modelo;
- série;
- número;
- chave de acesso;
- datas de emissão e entrada;
- status operacional;
- dados fiscais do XML;
- ambiente fiscal;
- finalidade da NF-e;
- cobrança;
- pagamentos;
- totais;
- cancelamento;
- usuário e timestamps.

O XML original é preservado como fonte fiscal e não deve ser sobrescrito por dados internos.

A implementação também utiliza estruturas relacionadas para:

- itens XML;
- conciliação;
- conferência;
- divergências;
- eventos;
- forma de pagamento fiscal;
- Produto × Fornecedor.

---

# 9. Status da Nota Fiscal

Os estados operacionais utilizados permanecem:

~~~text
AB = Aberta
FE = Fechada / efetivada
CA = Cancelada
~~~

## AB — Aberta

Representa uma entrada ainda não efetivada.

Pode permitir, conforme a origem e o estado atual:

- edição operacional;
- importação/conciliação;
- conferência;
- resolução de vínculos;
- análise de divergências;
- efetivação;
- recusa da entrada provisória, quando elegível.

## FE — Fechada

Representa uma NF efetivada.

Pode produzir efeitos em:

- estoque;
- custos;
- financeiro;
- recebimento do Pedido, quando houver.

Depois da efetivação, os dados operacionais sujeitos a fechamento deixam de ser livremente editáveis.

## CA — Cancelada

Representa uma NF que chegou a ser efetivada e posteriormente teve seus efeitos cancelados funcionalmente.

A nota permanece registrada para:

- histórico;
- auditoria;
- rastreabilidade;
- preservação da chave de acesso.

## Estado operacional e situação fiscal

Estado operacional e situação/finalidade fiscal não são o mesmo conceito.

~~~text
status operacional
!=
situação fiscal
~~~

Um XML pode ser importado e permanecer AB, mas possuir finalidade fiscal que impeça sua efetivação no fluxo normal.

Exemplo homologado:

~~~text
finNFe = 4
→ devolução
→ XML pode ser importado
→ fluxo normal de entrada fica bloqueado
~~~

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

O vínculo com Pedido de Compra é opcional.

Fluxos permitidos:

~~~text
NF-e com Pedido
NF-e sem Pedido
~~~

Quando houver Pedido:

- deve pertencer à empresa autorizada;
- fornecedor deve ser compatível;
- Loja deve ser compatível;
- itens devem ser conciliados;
- saldo restante deve ser respeitado;
- preço aprovado deve ser respeitado;
- recebimentos anteriores são considerados.

O recebimento parcial continua permitido.

Uma NF com quantidade inferior ao saldo pode ser efetivada normalmente.

Se a quantidade fiscal ultrapassar o saldo disponível:

- a importação pode continuar;
- a conciliação alerta;
- a conferência física pode registrar a verdade;
- a efetivação é bloqueada.

Preço:

~~~text
Preço NF = Preço Pedido
→ permitido

Preço NF < Preço Pedido
→ permitido

Preço NF > Preço Pedido
→ bloqueado
~~~

A validação definitiva ocorre novamente no backend na efetivação.

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

A chave de acesso identifica fiscalmente a NF-e importada.

Quando informada/importada:

- deve conter 44 dígitos;
- deve possuir formato válido;
- não pode existir duplicada dentro das regras de isolamento da aplicação.

Regras homologadas:

~~~text
NF aberta válida
→ chave ocupada

NF efetivada
→ chave ocupada

NF cancelada após efetivação
→ chave continua ocupada

Importação provisória recusada
→ registro provisório removido
→ chave liberada
→ mesmo XML pode ser importado novamente
~~~

Cancelar uma NF efetivada não libera sua chave.

Recusar uma entrada XML ainda não efetivada abandona a importação provisória e libera a chave.

## Recusar entrada

`Recusar entrada` não é cancelamento.

É uma operação destinada à importação XML ainda provisória e não efetivada.

Fluxo:

~~~text
XML importado
→ NF AB
→ ainda sem efeitos operacionais
→ Recusar entrada
→ importação provisória removida
→ chave liberada
~~~

A operação:

- não movimenta estoque;
- não gera financeiro;
- não atualiza recebimento de Pedido;
- não cria NF cancelada;
- não transforma a recusa em evento de cancelamento;
- permite importar novamente o mesmo XML;
- deve respeitar isolamento multiempresa;
- deve ser atômica.

Endpoint homologado:

~~~text
POST /api/fiscal/notas-entrada/{id}/recusar/
~~~

A recusa deve ser bloqueada quando a entrada não for mais elegível, especialmente quando já existirem efeitos operacionais incompatíveis com abandono simples.

## Finalidade fiscal especial

A finalidade fiscal do XML deve ser preservada.

Quando a finalidade exigir fluxo específico, a NF não pode ser efetivada como entrada normal.

Exemplo homologado:

~~~text
finNFe = 4
→ devolução
~~~

Nesse cenário:

- o XML pode ser importado;
- os dados fiscais permanecem preservados;
- a interface indica que é necessário fluxo específico;
- a efetivação normal é bloqueada;
- a entrada provisória pode ser recusada;
- a recusa libera a chave para futura utilização no fluxo fiscal apropriado.

Nesta etapa não existe integração real completa com SEFAZ para execução desses eventos especiais.

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

A Entrada de NF-e baseada em XML preserva os dados fiscais do item e realiza a associação com o cadastro interno separadamente.

Cada item pode conter informações fiscais como:

- número do item;
- código do fornecedor;
- descrição fiscal;
- GTIN/EAN;
- unidade comercial;
- quantidade fiscal;
- valor unitário fiscal;
- valor total.

O produto interno do Sysvar não substitui nem sobrescreve os dados fiscais originais do XML.

## Produto × Fornecedor

O vínculo permanente utiliza conceitualmente:

~~~text
Fornecedor
+
Código externo do fornecedor
        ↓
Produto interno do Sysvar
~~~

O mesmo código externo pode representar produtos diferentes em fornecedores diferentes.

O vínculo pode armazenar, conforme o cadastro vigente:

- código do fornecedor;
- descrição;
- GTIN/EAN;
- produto interno;
- unidade do fornecedor;
- fator de conversão;
- status.

## Conversão de unidade

O Produto mantém sua unidade interna oficial.

O vínculo Produto × Fornecedor pode definir a unidade utilizada pelo fornecedor.

Exemplo homologado:

~~~text
1 PCT = 100 Un
~~~

Assim:

~~~text
100 PCT
×
100 Un/PCT
=
10.000 Un internas
~~~

## Conciliação

A conciliação identifica o produto interno correspondente ao item fiscal.

Item não conciliado bloqueia a efetivação.

O vínculo pode ser resolvido manualmente quando necessário e reutilizado em futuras importações.

## Conferência física

Quantidade fiscal e quantidade conferida são conceitos diferentes.

~~~text
Quantidade fiscal
= verdade documental do XML

Quantidade conferida
= contagem física realizada no recebimento
~~~

Exemplo:

~~~text
Fiscal:      10 UN
Conferida:    8 UN
Faltante:     2 UN
~~~

A quantidade conferida NÃO substitui a quantidade fiscal.

Se a NF for aceita com divergência:

~~~text
Estoque
→ entra pela quantidade fiscal

Divergência
→ permanece registrada separadamente
~~~

Valor da divergência:

~~~text
quantidade faltante
×
valor unitário fiscal
~~~

Exemplo:

~~~text
2 UN × R$ 2,50
=
R$ 5,00
~~~

O financeiro permanece pelo valor fiscal integral da NF.

O valor divergente é alertado para tratamento posterior com o fornecedor.

---

# 19. Confirmação dos itens no lançamento manual

As seções 19 a 22 registram o mecanismo já homologado de confirmação de itens do lançamento manual existente.

Esse comportamento deve ser preservado enquanto esse modo de entrada continuar disponível.

Ele não deve ser confundido com o novo fluxo de importação XML.

~~~text
Lançamento manual
→ confirmação por checkbox

Importação XML
→ item fiscal
→ Produto × Fornecedor
→ conciliação
→ conferência
~~~

No lançamento manual, a interface homologada utiliza um checkbox por linha.

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

No fluxo XML:

~~~text
quantidade fiscal
= quantidade documental da NF-e
~~~

A quantidade conferida:

- não pode ser negativa;
- não pode superar a quantidade fiscal;
- serve para registrar a contagem física;
- não altera a verdade fiscal do documento.

Quando houver Pedido:

~~~text
quantidade fiscal <= saldo do Pedido
→ efetivação permitida

quantidade fiscal > saldo do Pedido
→ alerta antecipado
→ efetivação bloqueada
~~~

A conferência pode registrar a quantidade física real mesmo quando existir incompatibilidade com o saldo do Pedido.

No lançamento manual e nos produtos sujeitos a Pack, permanecem válidas as regras específicas de composição já homologadas.

A validação definitiva pertence ao backend.

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

A efetivação transforma a NF aberta em uma entrada operacional efetivada.

Antes dos efeitos definitivos, o backend revalida:

- conciliação;
- quantidade;
- conversão de unidade;
- saldo do Pedido, quando houver;
- preço do Pedido, quando houver;
- cobrança;
- forma de pagamento fiscal;
- finalidade fiscal;
- demais bloqueios vigentes.

Fluxo:

~~~text
NF AB
  ↓
validações finais
  ↓
estoque
  ↓
custos
  ↓
financeiro
  ↓
recebimento do Pedido, quando houver
  ↓
NF FE
~~~

A operação é transacional.

Falha em etapa crítica impede permanência de efeitos parciais.

---

# 33. Estoque

Ao aceitar e efetivar uma NF, o estoque utiliza a quantidade fiscal do XML convertida para a unidade interna.

~~~text
quantidade interna
=
quantidade fiscal
×
fator de conversão
~~~

A quantidade conferida fisicamente é utilizada para detectar divergência, não para reduzir automaticamente a entrada fiscal aceita.

Exemplo:

~~~text
Fiscal:       10
Conferida:     8

NF aceita:
Estoque +10

Divergência:
2
~~~

A identificação técnica da entrada utiliza:

~~~text
NFE:<id>:ENTRADA
~~~

O número comercial da NF não é usado isoladamente para idempotência.

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

No cancelamento, o Sysvar deve preservar a verdade histórica das movimentações.

Movimentações posteriores à entrada original não são apagadas nem reescritas.

Fluxo:

~~~text
NF efetivada
↓
movimentações posteriores
↓
cancelamento da NF
↓
estorno somente da entrada original
~~~

Antes do cancelamento, o sistema calcula o impacto do estorno.

A configuração da Loja continua sendo respeitada.

Quando a Loja NÃO permite estoque negativo e o estorno produziria saldo negativo:

- o cancelamento é bloqueado;
- a NF permanece FE;
- o estoque não é alterado;
- o financeiro não é alterado;
- os custos não são alterados;
- o Pedido não é alterado.

Quando a Loja permite estoque negativo:

- o sistema pode alertar que o estorno produzirá saldo negativo;
- o usuário pode prosseguir dentro das regras vigentes;
- o estorno da NF é executado;
- as movimentações posteriores permanecem intactas;
- o saldo resultante pode ficar negativo.

Regra central:

~~~text
cancelar NF anterior
!=
apagar movimentos posteriores
~~~

O cancelamento deve estornar somente o fato originado pela própria NF.

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

A NF pode gerar financeiro:

- vinculada a Pedido;
- sem Pedido.

Quando o XML contém duplicatas, o financeiro utiliza as parcelas fiscais efetivamente informadas.

São preservados:

- valor fiscal;
- número da parcela;
- vencimento;
- forma de pagamento mapeada.

Existe mapeamento permanente:

~~~text
tPag fiscal
→
FormaPagamento do Sysvar
~~~

Esse mapeamento respeita o contexto multiempresa.

Quando houver cobrança que exija forma fiscal ainda não resolvida, a efetivação é bloqueada até o mapeamento necessário.

## Divergência física e financeiro

Quando a NF é aceita com divergência física:

~~~text
valor financeiro
=
valor fiscal integral da NF
~~~

A divergência física não reduz automaticamente:

- total da NF;
- título;
- parcela;
- obrigação financeira.

Exemplo:

~~~text
Fiscal: 10 unidades
Conferido: 8 unidades

NF aceita
→ estoque fiscal = 10
→ financeiro fiscal = valor de 10
→ divergência = 2 unidades
~~~

O Contas a Pagar recebe indicação do valor divergente para tratamento posterior.

Esse tratamento poderá resultar, fora da efetivação normal da entrada, em:

- desconto negociado;
- crédito;
- devolução;
- compensação;
- outro tratamento comercial/fiscal adequado.

A Entrada de NF-e não inventa automaticamente qual dessas soluções deverá ser utilizada.

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

Uma NF efetivada não pode ser cancelada enquanto existir parcela financeira baixada incompatível com a reversão.

Nesse caso:

- cancelamento é bloqueado;
- NF permanece FE;
- estoque não é estornado;
- Pedido não é alterado.

O fluxo financeiro permite reabertura controlada da parcela baixada.

Na reabertura:

- a movimentação financeira é revertida/cancelada conforme a estrutura vigente;
- a parcela volta a situação efetiva/em aberto;
- histórico é preservado.

Depois da regularização financeira, o cancelamento da NF pode ser novamente analisado.

---

# 43. Atomicidade

Efetivação, cancelamento e recusa de entrada são operações que exigem consistência transacional.

O princípio é:

~~~text
ou toda a operação conclui
ou nenhuma parte permanece alterada
~~~

Na efetivação, falha crítica não pode deixar efeitos parciais em:

- NF;
- Pedido;
- estoque;
- movimentações;
- custos;
- Pagar;
- PagarItem;
- divergências;
- histórico operacional.

A recusa de entrada provisória também deve ser atômica para não deixar:

- itens órfãos;
- divergências órfãs;
- chave bloqueada indevidamente;
- efeitos operacionais parciais.

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

Devem permanecer rastreáveis, conforme aplicável:

- importação;
- conciliação;
- vínculo Produto × Fornecedor;
- conferência;
- divergências;
- efetivação;
- cancelamento;
- recusa da importação;
- efeitos financeiros;
- movimentações de estoque;
- eventos fiscais registrados.

Uma transação revertida por rollback não deve ser registrada como operação concluída.

## XML original

O XML original da NF-e representa o documento fiscal recebido.

Depois de importado e aceito no fluxo, não deve ser adulterado para refletir decisões internas do Sysvar.

Dados internos como:

- produto;
- vínculo com fornecedor;
- conferência;
- divergência;
- Pedido;
- estoque;
- financeiro;

devem permanecer separados da verdade fiscal original.

## XML de eventos

Quando houver estrutura para eventos fiscais, o XML do evento deve permanecer separado do XML original da NF-e.

~~~text
XML original da NF-e
!=
XML de evento fiscal
~~~

Nesta etapa, a estrutura não representa integração SEFAZ completa.

---

# 50. Rastreabilidade

A partir da NF deve ser possível relacionar, conforme o caso:

- XML original;
- fornecedor;
- Produto × Fornecedor;
- itens fiscais;
- produto interno;
- Pedido;
- conciliação;
- conferência;
- divergências;
- entrada de estoque;
- cancelamento de estoque;
- efeitos financeiros;
- recebimento do Pedido;
- eventos fiscais registrados.

A identificação técnica das movimentações utiliza o ID interno da NF.

Isso permite coexistência segura de documentos com mesmo número comercial e preserva os vínculos entre fato fiscal e efeitos internos.

---

# 51. Testes automatizados

Após a evolução do fluxo XML e as correções da homologação manual, a suíte do módulo fiscal foi ampliada.

Validação final registrada em 27/08/2026:

~~~text
python manage.py test fiscal --noinput
92 testes
OK
~~~

Também foram executados durante o ciclo:

~~~text
python manage.py check
OK
~~~

~~~text
python manage.py makemigrations --check --dry-run
OK
sem migrations pendentes
~~~

A suíte `compras` possui falhas históricas conhecidas fora do escopo da Entrada de NF-e.

Essas falhas não foram mascaradas nem corrigidas como parte desta homologação.

---

# 52. Testes frontend

A versão final do frontend foi validada com:

~~~text
npx tsc -p tsconfig.app.json --noEmit
OK
~~~

~~~text
npx ng test --watch=false --browsers=ChromeHeadless
230 testes
OK
~~~

~~~text
npx ng build --configuration development
OK
~~~

Também foi executado:

~~~text
git diff --check
OK
~~~

---

# 53. Testes integrados adicionais

A homologação manual final cobriu, entre outros:

- entrada XML sem Pedido;
- entrada XML vinculada a Pedido;
- recebimento parcial;
- múltiplas NFs;
- duplicidade de chave;
- chave preservada após cancelamento;
- Produto × Fornecedor;
- conversão `1 PCT = 100 Un`;
- quantidade acima do saldo do Pedido;
- preço acima do Pedido;
- preço abaixo do Pedido;
- divergência física;
- alerta financeiro de divergência;
- efetivação pela quantidade fiscal;
- cancelamento com movimentações posteriores;
- financeiro baixado e reabertura;
- finalidade fiscal especial;
- recusa de entrada;
- liberação da chave após recusa;
- reimportação do mesmo XML recusado;
- multiempresa.

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

## Evolução XML e homologação de 27/08/2026

### Backend

~~~text
8f4e984ac53758a723964aaada64c44e66fd997c
Corrige financeiro da NF-e sem pedido
~~~

~~~text
9cc9758db31f578172e8a676513cc5779ffa3862
Corrige reabertura financeira da NF-e
~~~

~~~text
dac4565
Valida preço da NF-e contra Pedido
~~~

~~~text
a8ae105
Corrige tratamento de divergência física da NF-e
~~~

~~~text
82a2c4f
Corrige recusa de entrada da NF-e
~~~

### Frontend

~~~text
33a30fb60411e25ca0fa975ec47941bfcba9a636
Exibe cobrança da NF-e na entrada
~~~

~~~text
72cb070
Ajusta homologação financeira da NF-e
~~~

~~~text
3361abc
Adiciona manutenção Produto × Fornecedor
~~~

~~~text
8cf69ec
Corrige manutenção Produto × Fornecedor
~~~

~~~text
50266cc
Ajusta divergências da NF-e e Produto × Fornecedor
~~~

~~~text
6e33a91
Ajusta fluxo de divergência no recebimento da NF-e
~~~

~~~text
f2ff987
Ajusta abandono da importação de NF-e
~~~

---

# 55. Homologação final

A Entrada de NF-e passou por nova etapa de desenvolvimento e homologação após a versão originalmente aprovada em 18/08/2026.

A evolução adicionou e consolidou:

- importação XML;
- NF com ou sem Pedido;
- Produto × Fornecedor;
- conversão de unidade;
- conciliação;
- conferência física;
- divergências;
- cobrança fiscal;
- mapeamento de forma de pagamento;
- validação de saldo do Pedido;
- validação de preço do Pedido;
- cancelamento com rastreabilidade;
- reabertura financeira;
- finalidade fiscal especial;
- recusa de importação provisória.

Durante a homologação manual foram encontradas regras que precisaram ser corrigidas.

A principal correção funcional foi:

~~~text
Quantidade conferida
NÃO substitui
Quantidade fiscal
~~~

Regra definitiva:

~~~text
NF aceita
→ estoque pela quantidade fiscal

Diferença física
→ divergência separada
→ alerta ao Financeiro
~~~

Também foi homologada a distinção:

~~~text
Recusar entrada
→ abandonar importação provisória
→ liberar chave
→ permitir reimportação

Cancelar NF
→ NF já efetivada
→ preservar histórico
→ preservar chave bloqueada
→ estornar efeitos
~~~

Situação final:

**MÓDULO APROVADO E HOMOLOGADO**

Data final desta etapa:

**27/08/2026**

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

Módulo funcional:
Compras

Tipos:
Revenda
Uso/Consumo
Insumo

Fluxo homologado nesta etapa:
importação XML de NF-e

Lançamento manual:
estruturas existentes preservadas quando aplicáveis

Pedido:
opcional

NF com Pedido:
sim

NF sem Pedido:
sim

Recebimento parcial:
sim

Múltiplas NFs:
sim

Produto × Fornecedor:
sim

Conversão de unidade:
sim

Conciliação:
sim

Conferência física:
sim

Quantidade de estoque na NF XML aceita:
quantidade fiscal × fator de conversão

Quantidade conferida:
não substitui quantidade fiscal

Divergência física:
registrada separadamente

Alerta financeiro de divergência:
sim

Financeiro em divergência:
valor fiscal integral

Preço NF > Pedido:
bloqueia efetivação

Preço NF = Pedido:
aceita

Preço NF < Pedido:
aceita

Quantidade NF > saldo Pedido:
bloqueia efetivação

Chave duplicada:
bloqueada

NF cancelada:
chave permanece bloqueada

Recusar entrada provisória:
remove importação provisória
libera chave
permite reimportação

Cancelar NF:
preserva histórico
preserva chave
estorna efeitos da NF

Financeiro:
integrado

Cobrança/duplicatas:
integradas

tPag:
mapeado para FormaPagamento

Movimento de entrada:
NFE:<id>:ENTRADA

Movimento de cancelamento:
NFE:<id>:CANCEL

Movimentos posteriores:
preservados no cancelamento

Estoque negativo no cancelamento:
segue configuração da Loja
bloqueia quando negativo não é permitido
pode prosseguir com alerta quando permitido

Finalidade fiscal especial:
identificada
fluxo normal bloqueado

finNFe = 4:
requer fluxo específico

XML original:
preservado separadamente dos efeitos internos

XML de evento:
separado do XML original

DELETE físico operacional:
bloqueado

Paginação:
server-side

Filtros:
backend

Confirmação no lançamento manual:
checkbox OK

SEFAZ real:
não integrada nesta etapa

Assinatura digital:
não implementada nesta etapa

Certificado A1/A3:
não implementado nesta etapa

Manifestação do destinatário:
não implementada nesta etapa

CC-e:
não implementada nesta etapa

DANFE:
não implementado nesta etapa

Download automático de DF-e:
não implementado nesta etapa

Homologação técnica:
aprovada

Homologação manual:
aprovada em 27/08/2026
~~~
