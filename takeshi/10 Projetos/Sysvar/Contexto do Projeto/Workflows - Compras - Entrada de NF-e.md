---
type: workflows
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
  - xml
  - produto-fornecedor
  - conciliacao
  - conferencia
  - divergencia
  - recusa-entrada
  - forma-pagamento-fiscal
  - recebimento
  - estoque
  - financeiro
  - custos
  - revenda
  - uso-consumo
  - insumo
  - workflows
  - auditoria
  - multiempresa
  - homologado
---

# Workflows - Compras - Entrada de NF-e

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
- [[Workflows - Compras - Pedido de Compra]]
- [[Mapa Técnico - Compras - Entrada de NF-e]]
- [[Modelo de Domínio - Compras - Entrada de NF-e]]
- [[Riscos e Cuidados - Compras - Entrada de NF-e]]
- [[Homologação - Compras - Entrada de NF-e]]

---

# 2. Objetivo

Este documento descreve os fluxos funcionais e operacionais homologados da Entrada de NF-e do [[Sysvar]].

A entrada pode ocorrer:

- com Pedido de Compra;
- sem Pedido de Compra.

O fluxo principal atual utiliza o XML da NF-e como fonte fiscal e integra:

- XML;
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
- auditoria.

---

# 3. Entrada na funcionalidade

Acesso:

~~~text
Compras
↓
Entrada de NF-e
~~~

Rota:

~~~text
/compras/notas-entrada
~~~

Não existe tela separada de:

~~~text
Notas Lançadas
~~~

A própria Entrada de NF-e concentra:

- importação;
- processamento;
- consulta;
- efetivação;
- cancelamento;
- recusa de importação provisória.

---

# 4. Fluxo principal atual

~~~text
XML da NF-e
↓
Importar
↓
Identificar documento
↓
Identificar Fornecedor
↓
Preservar dados fiscais
↓
Produto × Fornecedor
↓
Conciliar itens
↓
Conferir fisicamente
↓
Analisar divergências
↓
Validar Pedido, quando houver
↓
Validar cobrança
↓
Efetivar
↓
Estoque
↓
Custos
↓
Financeiro
↓
Atualizar Pedido, quando houver
↓
Auditoria
~~~

---

# 5. Pedido de Compra não é obrigatório

Fluxos válidos:

~~~text
NF-e com Pedido
ou
NF-e sem Pedido
~~~

Quando houver Pedido, o sistema utiliza suas informações para validar:

- Empresa;
- Loja;
- Fornecedor;
- itens;
- saldo restante;
- preço;
- recebimentos anteriores.

Quando não houver Pedido, a NF-e continua podendo seguir o fluxo mediante conciliação e demais validações.

---

# 6. Importação do XML

~~~text
Usuário
↓
Importar XML
↓
Backend interpreta NF-e
↓
Valida estrutura fiscal
↓
Valida Empresa
↓
Valida chave
↓
Cria entrada provisória AB
~~~

O XML importado representa a verdade fiscal recebida.

Dados internos não devem sobrescrever silenciosamente os dados originais.

---

# 7. Chave de acesso

No XML, a chave de acesso é a principal identidade fiscal.

Fluxo:

~~~text
XML
↓
Chave
↓
Já existe?
├── sim → bloquear duplicidade
└── não → continuar
~~~

Estados:

~~~text
NF AB válida
→ chave ocupada

NF FE
→ chave ocupada

NF CA após efetivação
→ chave continua ocupada

Entrada provisória recusada
→ chave liberada
~~~

---

# 8. Identificação do Fornecedor

~~~text
XML
↓
Emitente
↓
Documento fiscal
↓
Fornecedor da Empresa
~~~

Quando houver Pedido:

~~~text
Fornecedor XML
=
Fornecedor Pedido
~~~

A incompatibilidade deve impedir a efetivação.

---

# 9. Produto × Fornecedor

Para cada item XML:

~~~text
Fornecedor
+
Código externo
↓
Existe vínculo?
├── sim → Produto interno identificado
└── não → conciliação necessária
~~~

O vínculo é permanente e reutilizável.

Pode manter:

- Produto interno;
- código externo;
- unidade do fornecedor;
- fator de conversão;
- situação.

---

# 10. Mesmo código em fornecedores diferentes

É permitido:

~~~text
Fornecedor A
Código 001
→ Produto X
~~~

e:

~~~text
Fornecedor B
Código 001
→ Produto Y
~~~

A identidade do vínculo depende também do Fornecedor.

---

# 11. Conversão de unidade

Exemplo homologado:

~~~text
Fornecedor:
1 PCT = 100 UN

XML:
100 PCT

Estoque:
10.000 UN
~~~

Fluxo:

~~~text
Quantidade fiscal
×
Fator de conversão
=
Quantidade operacional
~~~

A quantidade original do XML permanece preservada.

---

# 12. Conciliação

Item sem Produto identificado:

~~~text
Item XML
↓
Sem vínculo
↓
Selecionar Produto interno
↓
Definir unidade/fator quando necessário
↓
Salvar vínculo
↓
Item conciliado
~~~

Regra:

~~~text
Item não conciliado
→ não efetiva
~~~

---

# 13. Pedido opcional na conciliação

Se houver Pedido:

~~~text
Item XML
↓
Produto interno
↓
Item do Pedido compatível
↓
Conciliar
~~~

Se não houver Pedido:

~~~text
Item XML
↓
Produto interno
↓
Conciliação direta
~~~

---

# 14. Conferência física

Depois da conciliação:

~~~text
Item fiscal
↓
Quantidade XML
↓
Quantidade fisicamente recebida
↓
Conferência
~~~

A conferência registra a realidade física.

Ela não altera a informação fiscal original do XML.

---

# 15. Divergência de quantidade física

Se:

~~~text
Quantidade XML
!=
Quantidade conferida
~~~

o sistema registra divergência.

A divergência deve ser tratada explicitamente.

Não alterar o XML para esconder a diferença.

---

# 16. Quantidade acima do Pedido

Quando houver Pedido:

~~~text
Quantidade NF
>
Saldo restante
~~~

Resultado:

~~~text
Importação
→ permitida

Conferência
→ permitida

Alerta
→ apresentado

Efetivação
→ bloqueada
~~~

O backend valida novamente no momento da efetivação.

---

# 17. Quantidade inferior ao Pedido

~~~text
Quantidade NF
<
Saldo restante
~~~

Resultado:

~~~text
Recebimento parcial
→ permitido
~~~

O Pedido permanece com saldo pendente.

---

# 18. Preço em relação ao Pedido

Quando houver Pedido:

~~~text
Preço NF = Pedido
→ permitido

Preço NF < Pedido
→ permitido

Preço NF > Pedido
→ bloqueia efetivação
~~~

A importação do XML não deve destruir a verdade fiscal apenas porque existe divergência.

---

# 19. Recebimento parcial

Exemplo:

~~~text
Pedido = 100

NF 1 = 60
↓
Pedido AP

NF 2 = 40
↓
Pedido AT
~~~

Um Pedido pode possuir várias NFs.

---

# 20. Múltiplas NFs

~~~text
Pedido
├── NF 1
├── NF 2
└── NF N
~~~

Cada NF possui efeitos independentes.

Cancelar uma delas não deve desfazer efeitos pertencentes às demais.

---

# 21. Status da NF

Estados operacionais:

~~~text
AB = Aberta
FE = Fechada / efetivada
CA = Cancelada
~~~

---

# 22. NF AB

Uma entrada AB pode estar em:

- importação;
- conciliação;
- conferência;
- análise de divergências;
- preparação para efetivação.

Ainda não representa necessariamente recebimento operacional concluído.

---

# 23. NF FE

~~~text
AB
↓
Efetivar
↓
FE
~~~

A efetivação pode produzir:

- estoque;
- custos;
- financeiro;
- recebimento do Pedido;
- auditoria.

Depois disso, o documento deixa de ser livremente editável.

---

# 24. NF CA

~~~text
FE
↓
Cancelar
↓
CA
~~~

A NF permanece registrada para:

- histórico;
- auditoria;
- rastreabilidade;
- preservação da chave.

---

# 25. Finalidade fiscal

Status operacional e finalidade fiscal são conceitos diferentes.

~~~text
status operacional
!=
finalidade fiscal
~~~

Exemplo homologado:

~~~text
finNFe = 4
↓
NF de devolução
↓
XML pode ser importado
↓
entrada permanece identificada
↓
efetivação pelo fluxo normal é bloqueada
~~~

A operação exige fluxo fiscal específico.

---

# 26. Cobrança fiscal

O XML pode possuir:

- duplicatas;
- vencimentos;
- valores;
- formas de pagamento;
- informações de cobrança.

Esses dados são provenientes do documento fiscal recebido.

---

# 27. Forma de pagamento fiscal

A condição fiscal encontrada no XML não deve ser substituída silenciosamente pela condição comercial planejada no Pedido.

Regra:

~~~text
Pedido
→ planejamento comercial

XML / NF-e
→ verdade fiscal recebida
~~~

A integração financeira deve respeitar a NF efetivada.

---

# 28. Efetivação

Fluxo:

~~~text
NF AB
↓
Validar chave
↓
Validar conciliação
↓
Validar conferência
↓
Validar divergências
↓
Validar finalidade fiscal
↓
Validar Pedido, quando houver
↓
Validar quantidade
↓
Validar preço
↓
Validar financeiro
↓
Movimentar estoque
↓
Atualizar custos
↓
Efetivar financeiro
↓
Atualizar Pedido, quando houver
↓
NF FE
~~~

A operação é transacional.

---

# 29. Uso/Consumo

Produto:

~~~text
tipo_produto = 2
~~~

utiliza estoque dedicado de Uso/Consumo.

A regra independe da origem:

~~~text
Pedido de Cotação
ou
Pedido manual
ou
NF sem Pedido
↓
Produto tipo 2
↓
ProdutoUsoConsumoEstoque
~~~

---

# 30. Revenda

Revenda utiliza o domínio próprio de estoque de venda.

Quando aplicáveis, participam:

- Produto;
- Cor;
- Pack;
- tamanho;
- SKU.

A efetivação deve movimentar os SKUs corretos.

---

# 31. Insumo

Insumo utiliza quantidade direta e seu fluxo próprio de estoque/custo.

Pode utilizar quantidade decimal conforme a Unidade configurada.

---

# 32. Estoque

Entrada física ocorre na efetivação:

~~~text
NF AB
↓
Efetivar
↓
Movimento de entrada
↓
NF FE
~~~

Identificador técnico:

~~~text
NFE:<id>:ENTRADA
~~~

---

# 33. Pedido não movimenta estoque

~~~text
Pedido aprovado
!=
mercadoria recebida
~~~

Não movimentar estoque apenas porque:

- Cotação foi aprovada;
- Pedido foi criado;
- Pedido foi aprovado.

A entrada física ocorre pela NF-e efetivada.

---

# 34. Financeiro

A NF efetivada produz os efeitos financeiros definidos para o documento recebido.

Quando houver Pedido, seu planejamento financeiro pode participar do fluxo.

Mas:

~~~text
Planejamento do Pedido
!=
verdade fiscal recebida
~~~

---

# 35. Recusar entrada

`Recusar entrada` destina-se à importação XML ainda provisória.

Fluxo:

~~~text
XML importado
↓
NF AB
↓
Ainda sem efeitos incompatíveis
↓
Recusar entrada
↓
Importação provisória removida
↓
Chave liberada
~~~

---

# 36. Recusa não é cancelamento

~~~text
Recusar entrada
!=
Cancelar NF
~~~

Recusar:

- não movimenta estoque;
- não gera financeiro;
- não atualiza Pedido;
- não cria uma NF cancelada;
- libera a chave;
- permite importar o mesmo XML novamente.

---

# 37. Quando não pode recusar

Se a entrada já possuir efeitos incompatíveis com abandono simples:

~~~text
Recusar
→ bloqueado
~~~

NF efetivada deve utilizar:

~~~text
Cancelar NF
~~~

---

# 38. Cancelamento

Fluxo:

~~~text
NF FE
↓
Cancelar
↓
Validar estoque
↓
Validar financeiro
↓
Estornar estoque
↓
Recalcular custos
↓
Reverter/recalcular financeiro
↓
Recalcular Pedido, quando houver
↓
NF CA
~~~

A operação é transacional.

---

# 39. Cancelamento e chave

~~~text
NF FE
↓
Cancelar
↓
NF CA
↓
Chave continua ocupada
~~~

O mesmo XML não deve ser reutilizado como novo documento fiscal.

---

# 40. Cancelamento com estoque insuficiente

Se o estorno provocar saldo negativo e a Loja não permitir:

~~~text
Cancelar
↓
Bloqueado
~~~

Nenhum efeito parcial deve permanecer.

---

# 41. Cancelamento com financeiro baixado

Quando existir baixa financeira que impeça reversão automática segura:

~~~text
Cancelar NF
↓
Bloqueado
~~~

O sistema não desfaz pagamento silenciosamente.

---

# 42. Recalcular Pedido após cancelamento

Exemplo:

~~~text
Pedido AT
↓
Cancelar NF que compunha recebimento
↓
saldo volta a existir
↓
Pedido AP
~~~

---

# 43. Recalcular custos

O cancelamento deve considerar as demais NFs válidas.

~~~text
NF 1
NF 2
NF 3

Cancelar NF 1
↓
preservar efeitos válidos de NF 2 e NF 3
~~~

Não utilizar rollback cego de custo antigo.

---

# 44. Atomicidade

Efetivação, cancelamento e recusa seguem:

~~~text
SUCESSO COMPLETO
ou
ROLLBACK COMPLETO
~~~

Não deixar estado parcial entre:

- NF;
- Pedido;
- estoque;
- custos;
- financeiro;
- vínculos operacionais.

---

# 45. Multiempresa

Toda operação deve permanecer dentro da Empresa autorizada.

Validar:

- NF;
- Fornecedor;
- Produto;
- Produto × Fornecedor;
- Pedido;
- Loja;
- estoque;
- financeiro;
- conciliação;
- conferência;
- divergências.

ID válido de outro tenant continua inválido.

---

# 46. Permissões

A Entrada de NF-e pertence funcionalmente ao módulo:

~~~text
compras
~~~

Níveis:

~~~text
VIEW
→ consulta

EDIT
→ operações de escrita permitidas
~~~

Acesso ao módulo Fiscal não é requisito adicional.

---

# 47. Consulta

A mesma tela lista:

~~~text
AB
FE
CA
~~~

A consulta utiliza paginação no backend.

---

# 48. Filtros

A consulta pode utilizar filtros por dados como:

- Pedido;
- Status;
- Número;
- Chave;
- Fornecedor;
- Loja;
- emissão;
- entrada;
- valor;
- pesquisa geral.

Todos permanecem subordinados à Empresa.

---

# 49. Lançamento manual

O lançamento manual anteriormente homologado permanece preservado enquanto aplicável.

Nesse fluxo, o checkbox `OK` representa a persistência do item.

~~~text
desmarcado
→ não persistido

marcado
→ persistido
~~~

Esse mecanismo não deve ser confundido com a conciliação do fluxo XML.

---

# 50. Fluxo resumido — com Pedido

~~~text
XML
↓
Fornecedor
↓
Selecionar/vincular Pedido
↓
Produto × Fornecedor
↓
Conciliação
↓
Conferência
↓
Validar saldo e preço
↓
Efetivar
↓
Estoque
↓
Custos
↓
Financeiro
↓
Atualizar Pedido
~~~

---

# 51. Fluxo resumido — sem Pedido

~~~text
XML
↓
Fornecedor
↓
Produto × Fornecedor
↓
Conciliação
↓
Conferência
↓
Validar divergências
↓
Efetivar
↓
Estoque
↓
Custos
↓
Financeiro
~~~

---

# 52. Fluxo resumido — recusa

~~~text
XML
↓
NF AB provisória
↓
Recusar entrada
↓
Sem efeitos operacionais
↓
Registro provisório removido
↓
Chave liberada
~~~

---

# 53. Fluxo resumido — cancelamento

~~~text
NF FE
↓
Cancelar
↓
Estorno
↓
Recalcular integrações
↓
NF CA
↓
Chave preservada
~~~

---

# 54. Regra de preservação

As regras centrais deste Workflow são:

~~~text
Pedido
= opcional

XML
= verdade fiscal

Produto × Fornecedor
= vínculo reutilizável

Item sem conciliação
= não efetiva

Quantidade acima do saldo
= pode importar/conferir
= não pode efetivar

Preço NF > Pedido
= não efetiva

Pedido aprovado
!=
entrada física

Produto tipo 2
= estoque dedicado

Recusar entrada
!=
Cancelar NF

NF cancelada
= chave preservada
~~~

Alterações futuras devem preservar essas regras até que nova decisão funcional homologada as substitua.