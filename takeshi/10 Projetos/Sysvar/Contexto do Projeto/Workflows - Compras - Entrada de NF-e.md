---
type: workflows
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
- **Data da homologação:** 18/08/2026

### Documentos relacionados

- [[Sysvar]]
- [[Mapa Técnico - Compras - Pedido de Compra]]
- [[Workflows - Compras - Pedido de Compra]]
- [[Mapa Técnico - Compras - Entrada de NF-e]]
- [[Homologação - Compras - Entrada de NF-e]]

---

# 2. Objetivo

Este documento descreve os fluxos funcionais e operacionais homologados da Entrada de NF-e do [[Sysvar]].

A Entrada de NF-e representa o recebimento efetivo de um Pedido de Compra aprovado.

O fluxo integra:

- Pedido de Compra;
- recebimento;
- estoque;
- custos;
- financeiro;
- auditoria.

---

# 3. Entrada na funcionalidade

O acesso ocorre por:

~~~text
Compras
   ↓
Entrada de NF-e
~~~

Rota:

~~~text
/compras/notas-entrada
~~~

Não existe funcionalidade separada de:

**Notas Lançadas**

As notas já existentes são consultadas na própria tela de Entrada de NF-e.

---

# 4. Fluxo principal

~~~text
Pedido de Compra AP
        ↓
Entrada de NF-e
        ↓
Nova NF-e
        ↓
Selecionar Pedido
        ↓
Informar dados da NF
        ↓
Confirmar itens recebidos
        ↓
Fechar NF
        ↓
Estoque
        ↓
Custos
        ↓
Financeiro
        ↓
Recebimento
        ↓
Pedido AP ou AT
~~~

---

# 5. Pré-condição

A Entrada de NF-e parte de um Pedido de Compra válido para recebimento.

O Pedido:

- pertence à empresa atual;
- possui Fornecedor;
- possui Loja;
- possui itens;
- deve estar em situação compatível com recebimento.

O fluxo não utiliza Pedido de outra empresa.

---

# 6. Seleção do Pedido

Ao criar uma NF:

~~~text
Nova NF-e
   ↓
Selecionar Pedido
~~~

Após a seleção, a tela apresenta de forma compacta:

- Pedido;
- Loja;
- Fornecedor;
- Tipo.

Tipos:

~~~text
Revenda
Uso/Consumo
Insumo
~~~

O objetivo é permitir que o usuário identifique claramente o contexto antes de lançar a nota.

---

# 7. Cabeçalho da NF

O usuário informa, conforme o fluxo:

- Modelo;
- Série;
- Número;
- Data de emissão;
- Data de entrada;
- Frete;
- Chave de acesso;
- Observações.

A NF inicia em:

~~~text
AB = Aberta
~~~

---

# 8. Regra de datas

A regra é:

~~~text
Data de entrada >= Data de emissão
~~~

Permitido:

~~~text
Emissão 10/08
Entrada 10/08
~~~

Permitido:

~~~text
Emissão 10/08
Entrada 11/08
~~~

Bloqueado:

~~~text
Emissão 11/08
Entrada 10/08
~~~

---

# 9. Identidade documental

A duplicidade da NF é verificada por:

~~~text
Empresa
+ Fornecedor
+ Modelo
+ Série
+ Número
~~~

O Pedido de Compra não faz parte dessa identidade.

---

# 10. Chave de acesso

A chave é opcional no lançamento manual.

Quando informada:

~~~text
44 dígitos
+ somente números
+ DV válido
+ não duplicada
~~~

NF cancelada continua mantendo a chave utilizada.

---

# 11. Carregamento dos itens

Depois de vinculada ao Pedido, a NF apresenta seus itens disponíveis para recebimento.

Para cada item são mostrados:

- Pedida;
- Já recebida;
- Saldo pendente;
- Nesta NF;
- Preço;
- Desconto;
- Total.

---

# 12. Significado das quantidades

Exemplo:

~~~text
Pedido:
100

Já recebida:
60

Saldo pendente:
40

Nesta NF:
20
~~~

A quantidade `Nesta NF` representa o que será confirmado naquele documento.

---

# 13. Confirmação do item

A confirmação utiliza o checkbox:

**OK**

Fluxo:

~~~text
Item não confirmado
checkbox desmarcado
        ↓
Usuário informa quantidade/preço/desconto
        ↓
Marca OK
        ↓
Backend grava o item
        ↓
Sucesso
        ↓
checkbox permanece marcado
~~~

---

# 14. Erro na confirmação

Se a gravação falhar:

~~~text
Marcar OK
   ↓
Erro do backend
   ↓
Item não gravado
   ↓
Checkbox permanece desmarcado
~~~

A mensagem de erro é apresentada ao usuário.

---

# 15. Remoção do item

Para retirar da NF um item já confirmado:

~~~text
Checkbox marcado
       ↓
Usuário desmarca
       ↓
Confirma remoção
       ↓
Backend remove o item
       ↓
Sucesso
       ↓
Checkbox fica desmarcado
~~~

Se a remoção falhar, o checkbox permanece marcado.

---

# 16. Checkbox e seleção

A seleção da linha não representa gravação.

~~~text
Linha selecionada
= contexto visual

Checkbox OK
= item efetivamente gravado
~~~

Somente uma linha pode ficar selecionada visualmente por vez.

---

# 17. NF Aberta

Em:

~~~text
AB
~~~

o usuário pode:

- alterar os dados permitidos;
- informar quantidades;
- alterar preço;
- informar desconto;
- marcar item;
- desmarcar item;
- fechar a NF.

---

# 18. NF Fechada

Em:

~~~text
FE
~~~

a NF já foi efetivada.

Os itens ficam para consulta.

O checkbox continua demonstrando quais itens pertencem à NF, mas fica desabilitado.

---

# 19. NF Cancelada

Em:

~~~text
CA
~~~

a NF permanece registrada.

Itens ficam para consulta.

Checkbox permanece somente visual.

---

# 20. Validação da quantidade

O fluxo bloqueia:

- quantidade negativa;
- quantidade superior ao saldo;
- quantidade incompatível com Pack quando aplicável.

Recebimento parcial é permitido.

---

# 21. Fluxo de Revenda

Revenda utiliza:

- Produto;
- Cor;
- Pack;
- tamanho;
- SKU.

Fluxo:

~~~text
Pedido de Revenda
       ↓
Entrada NF
       ↓
Quantidade recebida
       ↓
Validação do Pack
       ↓
Distribuição pelos tamanhos
       ↓
SKUs
       ↓
Estoque
~~~

---

# 22. Pack

A quantidade precisa permitir distribuição coerente com a composição do Pack.

Quantidade incompatível é rejeitada.

Exemplo conceitual:

~~~text
Pack:
P  = 1
M  = 2
G  = 1

Total por Pack = 4
~~~

O recebimento deve respeitar combinações válidas segundo a regra vigente do Pedido.

---

# 23. Uso/Consumo

Fluxo:

~~~text
Pedido Uso/Consumo
       ↓
NF Entrada
       ↓
Quantidade direta
       ↓
Produto
       ↓
Estoque
       ↓
Custos
~~~

Não existe distribuição por Pack.

---

# 24. Insumo

Fluxo:

~~~text
Pedido Insumo
       ↓
NF Entrada
       ↓
Quantidade direta
       ↓
Produto
       ↓
Estoque
       ↓
Custos
~~~

Também não utiliza Pack.

---

# 25. Preço e desconto

Regra:

~~~text
Valor bruto = quantidade × preço
~~~

O desconto:

~~~text
>= 0
<= valor bruto
~~~

Desconto igual ao bruto é permitido.

~~~text
Valor bruto = 100
Desconto = 100
Total = 0
~~~

---

# 26. Fechamento da NF

Quando os itens estiverem confirmados:

~~~text
NF AB
   ↓
Fechar NF
   ↓
Validar
   ↓
Movimentar estoque
   ↓
Atualizar custos
   ↓
Efetivar financeiro
   ↓
Atualizar recebimento
   ↓
NF FE
~~~

O fechamento é transacional.

---

# 27. Identificação da movimentação

Movimento de entrada:

~~~text
NFE:<id>:ENTRADA
~~~

Esse identificador utiliza o ID interno da NF.

O número comercial não é utilizado isoladamente para garantir unicidade técnica.

---

# 28. Recebimento parcial

Exemplo:

~~~text
Pedido = 100

NF 1 = 30
Pedido = AP

NF 2 = 40
Pedido = AP

NF 3 = 30
Pedido = AT
~~~

O Pedido pode receber várias NFs.

---

# 29. Status do Pedido

Após cada fechamento:

~~~text
Ainda existe saldo
→ AP
~~~

~~~text
Tudo recebido
→ AT
~~~

---

# 30. Financeiro no fechamento

O Pedido aprovado possui previsão financeira.

A NF realiza financeiramente a parcela correspondente ao documento recebido.

Em recebimento parcial:

~~~text
Pedido previsto
      ↓
NF parcial
      ↓
parte efetivada
      +
saldo ainda previsto
~~~

---

# 31. Várias NFs e financeiro

Exemplo:

~~~text
Pedido = R$ 10.000

NF 1 = R$ 4.000
NF 2 = R$ 3.000
Saldo = R$ 3.000
~~~

Cada NF mantém seus próprios efeitos.

Uma NF não deve alterar o título efetivo pertencente à outra.

---

# 32. Cancelamento

Fluxo:

~~~text
NF FE
   ↓
Cancelar
   ↓
Validar possibilidade
   ↓
Validar financeiro
   ↓
Validar estoque
   ↓
Estornar estoque
   ↓
Recalcular custos
   ↓
Recalcular financeiro
   ↓
Recalcular Pedido
   ↓
NF CA
~~~

---

# 33. Movimento de cancelamento

O estorno utiliza:

~~~text
NFE:<id>:CANCEL
~~~

O estorno pertence somente à NF cancelada.

---

# 34. Cancelamento com estoque insuficiente

Exemplo:

~~~text
NF recebeu 10
Saldo atual = 2

Cancelar precisa retirar 10
Saldo resultante = -8
~~~

Se a Loja não permite estoque negativo:

~~~text
Cancelamento bloqueado
~~~

Nada deve ser parcialmente alterado.

---

# 35. Loja permitindo estoque negativo

Quando a Loja permite estoque negativo, o cancelamento segue a configuração vigente.

O comportamento é aplicado de forma consistente aos tipos envolvidos.

---

# 36. Cancelamento com financeiro baixado

Quando o título ou parcela vinculada à NF já possui baixa que não permite reversão automática:

~~~text
Cancelar NF
   ↓
Financeiro baixado
   ↓
Cancelamento bloqueado
~~~

O sistema não desfaz pagamento silenciosamente.

---

# 37. Recalculo do Pedido no cancelamento

Exemplo:

~~~text
Pedido AT
   ↓
Cancelar uma das NFs
   ↓
Recebimento deixa de ser total
   ↓
Pedido AP
~~~

---

# 38. Recalculo de custos

O cancelamento recalcula os custos considerando apenas NFs válidas.

Exemplo:

~~~text
NF 1
NF 2
NF 3
~~~

Cancelar NF 1 não deve eliminar os efeitos legítimos das NFs 2 e 3.

---

# 39. Atomicidade

Fechamento e cancelamento seguem:

~~~text
SUCESSO COMPLETO
ou
ROLLBACK COMPLETO
~~~

Não deve existir resultado parcial entre:

- NF;
- Pedido;
- estoque;
- custos;
- financeiro.

---

# 40. Cancelamento repetido

Uma NF já cancelada não deve gerar novo estorno.

~~~text
Primeiro cancelamento
→ NFE:<id>:CANCEL

Nova tentativa
→ nenhum segundo movimento
~~~

---

# 41. Consulta das notas

A própria tela Entrada de NF-e funciona também como consulta.

Não existe tela separada de Notas Lançadas.

A listagem apresenta NFs:

- AB;
- FE;
- CA.

---

# 42. Paginação

A consulta utiliza paginação server-side.

~~~text
Frontend
→ page + page_size
→ Backend
→ count + results
~~~

O frontend recebe somente a página solicitada.

---

# 43. Filtros

Filtros disponíveis no backend:

- Pedido;
- Status;
- Número;
- Chave;
- Fornecedor;
- Loja;
- Data de emissão;
- Data de entrada;
- Valor;
- Busca geral.

Filtros podem ser combinados.

---

# 44. Indicadores

Indicadores representam todo o conjunto filtrado:

- Total;
- Abertas;
- Fechadas;
- Canceladas;
- Valor total.

Não apenas a página atual.

---

# 45. Isolamento multiempresa

Todos os fluxos devem respeitar:

~~~text
Empresa A
≠
Empresa B
~~~

Isso inclui:

- NF;
- itens;
- Pedido;
- estoque;
- financeiro;
- filtros;
- indicadores.

---

# 46. Permissões

A Entrada de NF-e pertence ao módulo:

~~~text
compras
~~~

Fluxo de acesso:

~~~text
Compras + VIEW
→ consulta

Compras + EDIT
→ consulta + operação

Sem Compras
→ bloqueado

Somente Fiscal
→ bloqueado
~~~

---

# 47. DELETE

Não existe fluxo operacional de exclusão física da NF.

~~~text
DELETE
→ bloqueado
~~~

O fluxo correto é:

~~~text
NF FE
→ Cancelar
→ NF CA
~~~

---

# 48. Auditoria

Operações concluídas devem registrar auditoria conforme o padrão do sistema.

Uma operação revertida por rollback não deve aparecer como sucesso concluído.

---

# 49. Fluxo completo resumido

~~~text
PEDIDO AP
   ↓
ENTRADA DE NF-e
   ↓
SELECIONAR PEDIDO
   ↓
PREENCHER NF
   ↓
CONFIRMAR ITENS PELO CHECKBOX OK
   ↓
FECHAR
   ↓
ESTOQUE
   ↓
CUSTOS
   ↓
FINANCEIRO
   ↓
RECEBIMENTO
   ↓
PEDIDO AP / AT
   ↓
EVENTUAL CANCELAMENTO
   ↓
ESTORNO + RECÁLCULOS
   ↓
NF CA
~~~

---

# 50. Estado vigente

~~~text
Entrada de NF-e:
HOMOLOGADA

Recebimento parcial:
SIM

Múltiplas NFs:
SIM

Revenda:
HOMOLOGADA

Uso/Consumo:
HOMOLOGADO

Insumo:
HOMOLOGADO

Estoque:
INTEGRADO

Custos:
INTEGRADOS

Financeiro:
INTEGRADO

Cancelamento:
HOMOLOGADO

Checkbox de item:
HOMOLOGADO

Multiempresa:
PROTEGIDO

DELETE:
BLOQUEADO
~~~

---

# 51. Regra de preservação

Este workflow representa o comportamento homologado da Entrada de NF-e.

Alterações futuras devem preservar o fluxo vigente, exceto nos pontos explicitamente substituídos por nova decisão aprovada.
