---
type: homologation
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
  - homologacao
  - multiempresa
  - aprovado
---

# Homologação - Compras - Entrada de NF-e

## 1. Identificação

**Projeto:** [[Sysvar]]  
**Módulo:** Compras  
**Funcionalidade:** Entrada de NF-e  
**Tipos contemplados:** Revenda, Uso/Consumo e Insumo  
**Situação:** HOMOLOGADO  
**Data de conclusão da homologação:** 18/08/2026  
**Resultado:** APROVADO

### Documentos relacionados

- [[Sysvar]]
- [[Mapa Técnico - Compras - Pedido de Compra]]
- [[Mapa Técnico - Compras - Entrada de NF-e]]
- [[Homologação - Compras - Pedido de Compra]]
- [[Workflows - Compras - Pedido de Compra]]
- [[Modelo de Domínio - Compras - Pedido de Compra]]
- [[Riscos e Cuidados - Compras - Pedido de Compra]]

---

# 2. Objetivo

Este documento registra a homologação técnica, funcional e visual da Entrada de NF-e do [[Sysvar]].

A funcionalidade representa o recebimento efetivo de um Pedido de Compra aprovado.

O processo homologado integra:

- Pedido de Compra;
- recebimento;
- estoque;
- custos;
- financeiro;
- auditoria.

A Entrada de NF-e foi homologada para:

- Revenda;
- Uso/Consumo;
- Insumo.

---

# 3. Resultado geral

A funcionalidade foi considerada:

**APROVADA E HOMOLOGADA**

O fluxo principal homologado é:

~~~text
Pedido de Compra aprovado
→ Entrada de NF-e
→ selecionar Pedido
→ informar dados da NF
→ confirmar itens recebidos
→ fechar NF
→ movimentar estoque
→ atualizar custos
→ efetivar financeiro
→ atualizar recebimento do Pedido
~~~

A funcionalidade foi aprovada pelo usuário após homologação manual.

---

# 4. Localização funcional

Foi homologado que a Entrada de NF-e pertence ao módulo:

**Compras**

Rota:

~~~text
/compras/notas-entrada
~~~

A opção separada:

**Notas Lançadas**

foi removida.

A consulta das notas já registradas ocorre na própria Entrada de NF-e.

---

# 5. Permissões

Foi homologado que o acesso depende do módulo:

~~~text
compras
~~~

Não é necessário possuir acesso adicional ao módulo `fiscal`.

Comportamento confirmado:

- Compras + EDIT → pode operar;
- Compras + VIEW → pode consultar, sem alterar;
- sem Compras → bloqueado;
- somente Fiscal → bloqueado.

Frontend e backend utilizam a mesma regra.

---

# 6. Multiempresa

O isolamento multiempresa foi homologado.

Um usuário não consegue acessar dados de outra empresa por:

- listagem;
- detalhe;
- ID direto;
- itens;
- Pedido;
- filtros;
- indicadores.

Também foi confirmado isolamento dos efeitos em:

- estoque;
- financeiro.

A validação existe no backend.

---

# 7. Pedido de Compra

A Entrada de NF-e utiliza Pedido de Compra aprovado.

Foi homologado que:

- o Pedido deve pertencer à empresa;
- o fornecedor vem do Pedido;
- a Loja vem do Pedido;
- os itens da NF devem pertencer ao Pedido;
- o Pedido pode receber uma ou várias NFs.

O Pedido de Compra não faz parte da identidade única do documento fiscal.

---

# 8. Recebimento parcial

Foi homologado o recebimento parcial.

Exemplo:

~~~text
Pedido = 100

NF 1 = 60
Pedido = AP

NF 2 = 40
Pedido = AT
~~~

O Pedido permanece AP enquanto houver saldo a receber.

Quando todos os itens forem atendidos:

~~~text
AP → AT
~~~

---

# 9. Múltiplas NFs

Foi homologado que um Pedido pode receber várias NFs distintas.

Cada NF mantém seus próprios efeitos em:

- itens;
- estoque;
- financeiro;
- custos;
- rastreabilidade.

O cancelamento de uma NF não deve desfazer os efeitos das demais.

---

# 10. Status da NF

Estados homologados:

~~~text
AB = Aberta
FE = Fechada
CA = Cancelada
~~~

## AB

Permite edição dentro das regras vigentes.

## FE

Representa entrada efetivada.

Itens ficam somente para consulta.

## CA

Representa documento cancelado funcionalmente.

A NF permanece registrada para histórico e rastreabilidade.

---

# 11. Exclusão física

Foi confirmado que DELETE direto da NF é bloqueado.

A operação funcional para desfazer uma NF é:

**Cancelar NF**

Não existe exclusão física operacional normal.

---

# 12. Identidade documental

Foi homologada a regra:

~~~text
Empresa
+ Fornecedor
+ Modelo
+ Série
+ Número
~~~

Essa combinação identifica a duplicidade documental quando não se utiliza apenas a chave de acesso.

O Pedido não participa da regra.

---

# 13. Mesmo número de NF

Foram homologados como válidos documentos com o mesmo número quando houver diferença na identidade.

Exemplos:

~~~text
Fornecedor A / Série 1 / NF 123
Fornecedor B / Série 1 / NF 123
~~~

Permitido.

~~~text
Fornecedor A / Série 1 / NF 123
Fornecedor A / Série 2 / NF 123
~~~

Permitido.

Empresas diferentes permanecem igualmente isoladas.

---

# 14. Chave de acesso

Foi homologado que a chave:

- pode ficar ausente no lançamento manual;
- quando informada, deve possuir 44 dígitos;
- deve conter apenas números;
- deve possuir DV válido;
- não pode ser duplicada.

NF cancelada não libera a chave para novo cadastro.

---

# 15. Datas

Regra homologada:

~~~text
dt_entrada >= dt_emissao
~~~

Permitido:

- mesma data;
- entrada posterior.

Bloqueado:

- entrada anterior à emissão.

A regra vale para criação e edição permitida de NF AB.

---

# 16. Itens

Os itens da NF são baseados nos itens do Pedido de Compra.

A tela apresenta:

- Pedida;
- Já recebida;
- Saldo pendente;
- Nesta NF.

Essa apresentação foi aprovada na homologação manual.

---

# 17. Confirmação dos itens por checkbox

Durante a homologação manual foi identificado que o botão `Inserir` na barra superior não era adequado à operação.

A solução final aprovada foi:

**checkbox por item**

A primeira coluna utiliza o cabeçalho:

~~~text
OK
~~~

Estado:

~~~text
desmarcado = item não gravado na NF
marcado   = item gravado na NF
~~~

---

# 18. Marcação do checkbox

Ao marcar:

- usa quantidade atual;
- usa preço atual;
- usa desconto atual;
- grava o item;
- só permanece marcado após sucesso do backend.

Se ocorrer erro:

- permanece desmarcado;
- mensagem de erro é apresentada.

---

# 19. Desmarcação do checkbox

Ao desmarcar item já gravado:

- utiliza a operação existente de remoção;
- mantém confirmação de remoção;
- somente desmarca após sucesso.

Em erro:

- permanece marcado;
- item continua persistido.

---

# 20. Estados do checkbox

Foi homologado:

~~~text
NF AB → checkbox editável
NF FE → checkbox desabilitado
NF CA → checkbox desabilitado
~~~

Em FE e CA o estado continua indicando se o item pertence à NF.

---

# 21. Seleção da linha

A seleção da linha foi preservada.

Ela é independente do checkbox.

~~~text
linha selecionada
= contexto visual

checkbox marcado
= item gravado
~~~

Somente uma linha permanece selecionada por vez.

---

# 22. Padrão visual dos itens

A versão final aprovada não utiliza:

- coluna `Ações`;
- botão `Inserir`;
- botão `Remover`;
- botão de ação por linha;
- menu de três pontos;
- `RowActionsMenuComponent`.

A confirmação ocorre diretamente pelo checkbox.

---

# 23. Quantidades

Foi homologado que:

- quantidade negativa é bloqueada;
- quantidade acima do saldo é bloqueada;
- parcial é permitido;
- total é permitido;
- regras de Pack são preservadas.

Uso/Consumo e Insumo permanecem compatíveis com quantidade decimal quando suportada pela Unidade.

---

# 24. Revenda e Pack

O fluxo de Revenda foi homologado com:

- Produto;
- Cor;
- Pack;
- tamanhos;
- SKU.

A quantidade recebida precisa ser compatível com a composição do Pack.

No fechamento, a quantidade é distribuída pelos SKUs/tamanhos correspondentes.

O cancelamento estorna os mesmos SKUs.

---

# 25. Uso/Consumo

Foi homologado:

- quantidade direta;
- estoque;
- custo do Produto;
- financeiro;
- recebimento;
- cancelamento.

---

# 26. Insumo

Foi homologado:

- quantidade direta;
- estoque;
- custo do Produto;
- financeiro;
- recebimento;
- cancelamento.

---

# 27. Preço e desconto

Regras homologadas:

~~~text
preço >= 0
desconto >= 0
~~~

E:

~~~text
desconto <= quantidade × preço
~~~

Desconto igual ao valor bruto é permitido.

Nesse caso:

~~~text
total_item = 0
~~~

---

# 28. Total do item

Regra:

~~~text
total_item = valor_bruto - desconto
~~~

Foi confirmado que:

~~~text
total_item >= 0
~~~

---

# 29. Total da NF

Foi homologada proteção contra total negativo.

O frete permanece compondo o total conforme a regra vigente.

---

# 30. Fechamento

O fechamento da NF foi homologado para os três tipos de compra.

Fluxo:

~~~text
NF AB
→ validações
→ estoque
→ custos
→ financeiro
→ recebimento
→ NF FE
~~~

As operações críticas são executadas de forma transacional.

---

# 31. Estoque

A entrada de estoque é rastreada por:

~~~text
NFE:<id>:ENTRADA
~~~

Foi homologado que o número comercial da NF não é suficiente para identificar tecnicamente a movimentação.

Isso evita colisões entre documentos legítimos com mesma numeração.

---

# 32. Cancelamento de estoque

O estorno utiliza:

~~~text
NFE:<id>:CANCEL
~~~

Foi confirmado que:

- estorna somente a própria NF;
- não interfere em outra NF;
- não duplica o estorno.

---

# 33. Estoque negativo

Quando o cancelamento reduziria o saldo abaixo de zero e a Loja não permite estoque negativo:

- cancelamento é bloqueado;
- NF continua FE;
- estoque permanece;
- custos permanecem;
- financeiro permanece;
- Pedido permanece.

Quando a Loja permite estoque negativo, a configuração é respeitada.

---

# 34. Custos

Foi homologado o impacto em custos.

## Revenda

Custos vinculados aos SKUs.

## Uso/Consumo e Insumo

Custos vinculados ao Produto.

No cancelamento, os custos são recalculados considerando apenas entradas válidas.

Entradas posteriores não devem ser destruídas pelo cancelamento de uma NF anterior.

---

# 35. Financeiro

O fechamento integra com Contas a Pagar.

Foi homologado:

- realização integral;
- realização parcial;
- múltiplas NFs;
- saldo previsto remanescente.

Cada NF afeta somente sua parte financeira.

---

# 36. Cancelamento financeiro

No cancelamento:

- financeiro da NF é revertido/recalculado;
- financeiro de outras NFs permanece intacto;
- previsão remanescente do Pedido é recalculada.

Não são admitidos títulos duplicados ou previsões duplicadas.

---

# 37. Financeiro baixado

Foi homologado que uma NF não pode ser cancelada de forma automática quando seu efeito financeiro já possui baixa incompatível com reversão segura.

Nesse caso:

- cancelamento é bloqueado;
- NF permanece FE;
- estoque não é alterado;
- custos não são alterados;
- Pedido não é alterado.

---

# 38. Atomicidade

Foi homologado o princípio:

~~~text
ou toda a operação conclui
ou nenhuma parte permanece
~~~

Em falha, os testes confirmam rollback dos componentes aplicáveis:

- NF;
- Pedido;
- estoque;
- movimentações;
- custos;
- Pagar;
- PagarItem.

---

# 39. Cancelamento e Pedido

Ao cancelar NF, o recebimento é recalculado.

Exemplo:

~~~text
Pedido AT
→ cancelar uma NF
→ deixa de estar integralmente atendido
→ Pedido AP
~~~

Outra NF válida permanece preservada.

---

# 40. Paginação

Foi homologada paginação server-side.

Não existe mais carregamento da listagem com:

~~~text
page_size=1000
~~~

Resposta:

- count;
- next;
- previous;
- results.

Mudança de página realiza nova chamada ao backend.

---

# 41. Filtros

Filtros homologados no backend:

- Pedido;
- Status;
- Número;
- Chave;
- Fornecedor;
- Loja;
- emissão inicial/final;
- entrada inicial/final;
- valor mínimo/máximo;
- busca geral.

Filtros podem ser combinados.

Na interface atual, Pedido, Número e Chave também são alcançados pela busca geral.

---

# 42. Indicadores

Os indicadores consideram o conjunto filtrado completo.

São apresentados:

- total;
- abertas;
- fechadas;
- canceladas;
- valor total.

Não são calculados apenas sobre a página atual.

---

# 43. Testes de segurança e multiempresa

Foram criados testes específicos para:

- isolamento por empresa;
- criação com Pedido de outra empresa;
- acesso a itens;
- filtros;
- DELETE.

O BLOCO inicial de segurança foi aprovado antes de avançar para os demais.

---

# 44. Testes de cancelamento

Foram criados testes específicos para:

- financeiro;
- Pagar;
- PagarItem;
- estoque;
- custos;
- Pedido;
- saldo negativo;
- rollback;
- cancelamento repetido.

---

# 45. Testes de identidade

Foram cobertos cenários de:

- duplicidade documental;
- Fornecedores diferentes;
- Séries diferentes;
- Empresas diferentes;
- chave de acesso;
- DV;
- movimentos de estoque por ID da NF.

---

# 46. Testes de permissões

Foram confirmados:

- Compras sem Fiscal;
- sem Compras;
- somente Fiscal;
- outra empresa;
- VIEW;
- EDIT.

---

# 47. Testes de paginação e filtros

Foram testados:

- primeira página;
- páginas seguintes;
- count;
- tenant;
- filtros individuais;
- filtros combinados;
- indicadores.

---

# 48. Testes das validações

Foram testados:

- desconto igual ao bruto;
- desconto superior ao bruto;
- desconto negativo;
- preço negativo;
- quantidade negativa;
- total negativo;
- datas;
- saldo;
- Pack.

---

# 49. Cobertura integrada

A suíte complementar do Bloco 8 incluiu:

- múltiplas NFs;
- fechamento parcial;
- atendimento final;
- cancelamento parcial;
- nova NF para saldo;
- Revenda com Pack multitamanho;
- isolamento multiempresa;
- Uso/Consumo;
- Insumo;
- quantidade decimal;
- custos;
- financeiro;
- rollback.

---

# 50. Resultado técnico final

Na homologação técnica final:

~~~text
manage.py test fiscal --keepdb
45 testes
OK
~~~

~~~text
manage.py test compras.tests.PedidoCompraUnificadoTests --keepdb
15 testes
OK
~~~

~~~text
manage.py test produto.tests --keepdb
16 testes
OK
~~~

~~~text
manage.py test accounts.tests.SaaSAccessControlTests --keepdb
33 testes
OK
~~~

~~~text
manage.py check
OK
~~~

Frontend:

~~~text
Entrada de NF-e + rota/permissão
25 testes
SUCCESS
~~~

~~~text
ng build --configuration development
OK
~~~

---

# 51. Alteração final após homologação técnica

Durante a homologação manual foi identificada uma melhoria de operação na confirmação dos itens.

O fluxo com botão `Inserir` foi substituído pelo checkbox `OK`.

Após a alteração:

~~~text
notas-fiscais-entrada.component.spec.ts
22 testes
SUCCESS
~~~

Build:

~~~text
ng build --configuration development
OK
~~~

Commit frontend:

~~~text
e349eb7
feat: confirm nfe items with checkbox
~~~

A alteração foi posteriormente aprovada pelo usuário.

---

# 52. Commits principais

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
Identidade e duplicidade
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
Cobertura integrada
~~~

## Frontend

~~~text
2afa9abffe65c3e75fe52eb541492e3f9bd66159
Remoção de Notas Lançadas
~~~

~~~text
dcb469ee7734384f2ccad6641414a07343d5d367
Permissões
~~~

~~~text
3508725f2e4d65c34ee64fd0558017a46707720f
Paginação e filtros
~~~

~~~text
77bd8f931cc5c36c82dd585e1e999e3f4f329829
Padrão dos itens
~~~

~~~text
339e04536180ad65e2b3d4df9698c4c17a89bc55
Validações e apresentação
~~~

~~~text
e349eb7
Checkbox de confirmação dos itens
~~~

---

# 53. Pendências

Na conclusão da homologação:

**nenhuma pendência funcional crítica foi identificada.**

Observação vigente:

- Pedido;
- Número;
- Chave

possuem filtros específicos no backend e também podem ser consultados operacionalmente pela busca geral da tela.

---

# 54. Aprovação manual

Depois da última alteração visual e funcional nos itens, o usuário declarou:

**MÓDULO APROVADO**

Data:

**18/08/2026**

---

# 55. Estado final

~~~text
Funcionalidade:
Entrada de NF-e

Situação:
HOMOLOGADA

Homologação técnica:
APROVADA

Homologação manual:
APROVADA

Data:
18/08/2026

Tipos:
Revenda
Uso/Consumo
Insumo

Recebimento parcial:
SIM

Múltiplas NFs:
SIM

Estoque:
INTEGRADO

Custos:
INTEGRADOS

Financeiro:
INTEGRADO

Cancelamento:
HOMOLOGADO

Multiempresa:
PROTEGIDO

Paginação:
SERVER-SIDE

Filtros:
BACKEND

Confirmação de item:
CHECKBOX OK

DELETE físico:
BLOQUEADO

Pendência crítica:
NENHUMA
~~~

---

# 56. Regra de preservação

A Entrada de NF-e passa a ser considerada funcionalidade homologada do [[Sysvar]].

Não reabrir sua implementação sem:

- novo requisito;
- defeito comprovado;
- alteração de regra;
- nova integração;
- necessidade arquitetural real.

Regras homologadas devem ser preservadas até que uma nova decisão explicitamente aprovada as substitua.