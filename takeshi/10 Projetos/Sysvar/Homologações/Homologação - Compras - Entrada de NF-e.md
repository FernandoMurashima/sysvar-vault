---
type: homologation
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
**Data de conclusão da homologação:** 27/08/2026  
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

Este documento registra a homologação técnica, funcional, operacional e visual da Entrada de NF-e do [[Sysvar]].

A homologação original de 18/08/2026 foi posteriormente ampliada com o fluxo baseado em XML.

A Entrada de NF-e passou a suportar:

- entrada vinculada a Pedido de Compra;
- entrada sem Pedido de Compra;
- importação de XML;
- preservação da verdade fiscal;
- Produto × Fornecedor;
- conversão de unidade;
- conciliação;
- conferência física;
- divergências;
- cobrança fiscal;
- integração financeira;
- cancelamento;
- recusa de importação provisória;
- bloqueio de finalidade fiscal que exige fluxo específico.

O processo integra:

- documento fiscal;
- fornecedor;
- Produto;
- Pedido de Compra, quando houver;
- estoque;
- custos;
- financeiro;
- auditoria.

A Entrada de NF-e permanece homologada para:

- Revenda;
- Uso/Consumo;
- Insumo.

---

# 3. Resultado geral

A funcionalidade foi considerada:

**APROVADA E HOMOLOGADA**

Fluxo principal homologado nesta etapa:

~~~text
XML da NF-e
→ importação
→ identificação fiscal
→ fornecedor
→ Produto × Fornecedor
→ conciliação
→ conferência física
→ divergências
→ validação com Pedido, quando houver
→ efetivação
→ estoque
→ custos
→ financeiro
→ recebimento do Pedido, quando houver
→ auditoria
~~~

Também permanecem preservadas as estruturas do lançamento manual anteriormente homologado, enquanto aplicáveis.

Regra estrutural atual:

~~~text
Pedido de Compra
!=
obrigatório
~~~

A NF-e pode ser recebida:

~~~text
com Pedido
ou
sem Pedido
~~~

---

# 4. Localização funcional

A Entrada de NF-e pertence ao módulo:

**Compras**

Rota:

~~~text
/compras/notas-entrada
~~~

A opção separada **Notas Lançadas** permanece eliminada.

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

- Produto × Fornecedor;
- forma de pagamento fiscal;
- estoque;
- financeiro;
- recusa;
- cancelamento.

A validação definitiva existe no backend.

---

# 7. Pedido de Compra

O Pedido de Compra é opcional no fluxo atual da Entrada de NF-e.

Foram homologados:

~~~text
NF-e com Pedido
NF-e sem Pedido
~~~

Quando houver Pedido:

- deve pertencer à empresa;
- fornecedor deve ser compatível;
- Loja deve ser compatível;
- itens são conciliados;
- recebimentos anteriores são considerados;
- saldo restante é considerado;
- preço aprovado é considerado.

O Pedido pode receber uma ou várias NFs.

O Pedido de Compra não faz parte da identidade única do documento fiscal.

## Quantidade acima do saldo

Foi homologado que uma quantidade fiscal superior ao saldo do Pedido:

- não impede importar o XML;
- não impede registrar a conferência física;
- gera alerta antecipado;
- impede a efetivação.

A validação definitiva ocorre novamente no backend.

## Preço

Regra homologada:

~~~text
Preço NF = Pedido
→ permitido

Preço NF < Pedido
→ permitido

Preço NF > Pedido
→ bloqueia efetivação
~~~

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

Estados operacionais homologados:

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
- resolução de divergências;
- preparação para efetivação.

## FE

Representa entrada efetivada.

Pode possuir efeitos em:

- estoque;
- custos;
- financeiro;
- Pedido, quando houver.

## CA

Representa NF anteriormente efetivada e posteriormente cancelada.

A NF permanece registrada para:

- histórico;
- chave de acesso;
- auditoria;
- rastreabilidade.

## Estado operacional e finalidade fiscal

Foi homologado que:

~~~text
status operacional
!=
finalidade fiscal
~~~

Um XML pode permanecer AB e ainda assim ser impedido de seguir pelo fluxo normal em razão de sua finalidade fiscal.

---

# 11. Exclusão física

DELETE direto da NF permanece bloqueado no fluxo operacional normal.

Para uma NF efetivada, a operação funcional de desfazimento é:

**Cancelar NF**

Para uma importação XML provisória elegível, existe a operação distinta:

**Recusar entrada**

Esses dois conceitos não são equivalentes.

---

# 12. Identidade documental

No lançamento manual, permanece registrada a identidade documental composta por:

~~~text
Empresa
+ Fornecedor
+ Modelo
+ Série
+ Número
~~~

No fluxo XML, a chave de acesso é a identidade fiscal principal do documento importado.

O Pedido não participa da identidade fiscal.

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

No lançamento manual anteriormente homologado, a chave pode permanecer ausente quando o fluxo permitir.

No XML, a chave de acesso representa a identidade fiscal principal do documento importado.

Foi homologado:

- chave com 44 dígitos;
- formato válido;
- proteção contra duplicidade;
- chave ocupada enquanto existir entrada válida;
- chave preservada após efetivação;
- chave preservada após cancelamento de NF efetivada.

Teste explícito:

~~~text
importar XML
→ tentar importar novamente mesma chave
→ BLOQUEADO
~~~

Também foi confirmado:

~~~text
NF efetivada
→ cancelada
→ chave continua bloqueada
~~~

## Recusar entrada

A ação `Recusar entrada` foi homologada para importação XML:

- aberta;
- provisória;
- ainda não efetivada;
- sem efeitos operacionais incompatíveis.

Resultado:

~~~text
Recusar entrada
→ abandona importação provisória
→ remove registro provisório
→ libera chave
→ permite importar novamente o mesmo XML
~~~

Recusar entrada:

- não movimenta estoque;
- não gera financeiro;
- não atualiza Pedido;
- não cria uma NF cancelada;
- não equivale a Cancelar NF;
- respeita multiempresa;
- é uma operação atômica.

Endpoint homologado:

~~~text
POST /api/fiscal/notas-entrada/{id}/recusar/
~~~

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

# 16. Itens, XML e Produto × Fornecedor

No fluxo XML, o item fiscal é preservado conforme o documento recebido.

Podem participar da identificação:

- código do fornecedor;
- descrição fiscal;
- GTIN/EAN;
- unidade comercial;
- quantidade fiscal;
- preço fiscal;
- total fiscal.

Esses dados não são sobrescritos pelo cadastro interno.

## Produto × Fornecedor

Foi homologado o cadastro permanente Produto × Fornecedor.

Associação conceitual:

~~~text
Fornecedor
+
Código externo
→
Produto interno
~~~

O mesmo código externo pode representar produtos diferentes em fornecedores diferentes.

O vínculo é reutilizado em importações futuras.

## Conversão de unidade

Foi homologado o fator de conversão de unidade.

Exemplo efetivamente testado:

~~~text
1 PCT = 100 Un

XML:
100 PCT

Estoque:
10.000 Un
~~~

## Conciliação

Item XML sem produto conciliado bloqueia a efetivação.

A conciliação pode ser resolvida pelo usuário e reutilizada posteriormente.

---

# 17. Confirmação dos itens no lançamento manual

O mecanismo de confirmação por checkbox pertence ao lançamento manual anteriormente homologado e permanece preservado enquanto esse fluxo for aplicável.

A primeira coluna utiliza:

~~~text
OK
~~~

Estado:

~~~text
desmarcado = item não gravado na NF
marcado   = item gravado na NF
~~~

Esse mecanismo não deve ser confundido com a conciliação dos itens XML.

---

# 18. Quantidade fiscal e conferência física

No fluxo XML, foram homologadas duas verdades distintas:

~~~text
Quantidade fiscal
=
quantidade documental da NF-e

Quantidade conferida
=
quantidade fisicamente contada
~~~

A quantidade conferida:

- não pode ser negativa;
- não pode superar a quantidade fiscal;
- não substitui a quantidade fiscal.

Quando houver Pedido:

~~~text
quantidade fiscal > saldo
→ alerta
→ conferência permitida
→ efetivação bloqueada
~~~

## Regra definitiva de estoque

Durante a homologação foi encontrada e corrigida uma regra importante.

Com:

~~~text
Fiscal = 10
Conferida = 8
~~~

se a NF for aceita:

~~~text
Estoque = +10
Divergência = 2
~~~

Portanto:

~~~text
Quantidade conferida
NÃO substitui
Quantidade fiscal
~~~

Nos fluxos sujeitos a Pack, permanecem válidas as regras específicas de composição já homologadas.

---

# 19. Divergência física

A divergência homologada é calculada pela diferença entre a quantidade fiscal e a quantidade conferida.

~~~text
divergência = fiscal - conferida
~~~

Valor da divergência:

~~~text
quantidade divergente
×
valor unitário fiscal
~~~

Exemplo homologado:

~~~text
Fiscal = 10
Conferido = 8
Valor unitário = R$ 2,50

Divergência:
2 unidades
R$ 5,00
~~~

A divergência permanece registrada para tratamento posterior.

---

# 20. Revenda, Uso/Consumo e Insumo

## Revenda

Permanecem válidas as regras relacionadas a:

- Produto;
- Cor;
- Pack;
- tamanhos;
- SKU.

A composição do Pack continua sendo respeitada quando aplicável.

## Uso/Consumo

Foi homologado:

- quantidade direta;
- estoque;
- custo do Produto;
- financeiro;
- recebimento;
- cancelamento.

## Insumo

Foi homologado:

- quantidade direta;
- estoque;
- custo do Produto;
- financeiro;
- recebimento;
- cancelamento.

---

# 21. Efetivação

A efetivação da NF foi homologada para os três tipos de compra.

Fluxo atual:

~~~text
NF AB
→ validações finais
→ estoque
→ custos
→ financeiro
→ recebimento do Pedido, quando houver
→ NF FE
~~~

Antes de efetivar, o backend revalida, conforme aplicável:

- conciliação;
- quantidade;
- conversão;
- saldo do Pedido;
- preço do Pedido;
- cobrança;
- forma de pagamento;
- finalidade fiscal.

As operações críticas são transacionais.

Falha em uma etapa crítica não pode deixar efeitos parciais.

---

# 22. Estoque

A entrada de estoque é rastreada por:

~~~text
NFE:<id>:ENTRADA
~~~

No fluxo XML:

~~~text
quantidade de estoque
=
quantidade fiscal
×
fator de conversão
~~~

A quantidade conferida serve para identificar divergência física.

Ela não reduz automaticamente a quantidade de estoque de uma NF aceita.

Exemplo homologado:

~~~text
Fiscal = 10
Conferida = 8

NF aceita:
Estoque +10
Divergência 2
~~~

---

# 23. Cancelamento de estoque

O estorno utiliza:

~~~text
NFE:<id>:CANCEL
~~~

Foi confirmado que:

- estorna somente a própria NF;
- não interfere em outra NF;
- não duplica o estorno;
- não apaga movimentações posteriores.

---

# 24. Estoque negativo e movimentações posteriores

Foi homologado que o cancelamento deve estornar somente a entrada originada pela própria NF.

Movimentações posteriores não são apagadas.

Fluxo testado:

~~~text
NF efetivada
→ movimentação posterior
→ cancelar NF anterior
→ preservar movimento posterior
→ estornar somente a NF
~~~

Antes do cancelamento, o sistema apresenta o impacto esperado.

Quando a Loja não permite estoque negativo e o estorno produziria saldo negativo:

- cancelamento é bloqueado;
- NF continua FE;
- estoque permanece;
- custos permanecem;
- financeiro permanece;
- Pedido permanece.

Quando a Loja permite estoque negativo:

- o sistema pode apresentar alerta;
- o cancelamento pode prosseguir;
- movimentos posteriores são preservados;
- o saldo resultante pode ficar negativo.

---

# 25. Custos

Foi homologado o impacto em custos.

## Revenda

Custos vinculados aos SKUs.

## Uso/Consumo e Insumo

Custos vinculados ao Produto.

No cancelamento, os custos são recalculados considerando apenas entradas válidas.

Entradas posteriores não devem ser destruídas pelo cancelamento de uma NF anterior.

---

# 26. Financeiro

A efetivação integra com Contas a Pagar.

Foi homologado funcionamento financeiro:

- com Pedido;
- sem Pedido;
- com uma parcela;
- com múltiplas duplicatas;
- com vencimentos do XML.

## Duplicatas

Durante a homologação foi identificado que duplicatas do XML precisam gerar parcelas reais no financeiro.

A correção foi implementada e retestada.

## Forma de pagamento fiscal

Foi homologado o mapeamento permanente:

~~~text
tPag
→
FormaPagamento do Sysvar
~~~

Esse vínculo respeita a empresa.

Exemplo testado:

~~~text
tPag 15
→ BOL - Boleto
~~~

Quando a cobrança exige mapeamento ainda não resolvido, a efetivação fica bloqueada até sua resolução.

## Divergência física e financeiro

Ao aceitar uma NF com falta física:

~~~text
valor financeiro
=
valor fiscal integral
~~~

Exemplo homologado:

~~~text
Fiscal = 10
Conferido = 8
Valor unitário = R$ 2,50

Estoque:
10 unidades

Divergência:
2 unidades
R$ 5,00

Financeiro:
valor fiscal integral da NF
~~~

O Financeiro recebe indicação da divergência para tratamento posterior.

Não existe desconto automático da obrigação.

---

# 27. Cancelamento financeiro e parcela baixada

No cancelamento:

- financeiro da própria NF é revertido conforme as regras vigentes;
- financeiro de outras NFs permanece intacto;
- previsão remanescente do Pedido é recalculada quando aplicável.

Foi homologado que NF com parcela financeira baixada não pode ser cancelada enquanto a baixa impedir reversão segura.

Nesse caso:

- cancelamento é bloqueado;
- NF permanece FE;
- estoque não é alterado;
- custos não são alterados;
- Pedido não é alterado.

Durante a homologação foi identificado problema na reabertura de parcela baixada.

A correção foi implementada e retestada.

Fluxo final homologado:

~~~text
parcela baixada
→ cancelamento da NF bloqueado
→ reabrir parcela
→ situação financeira volta a permitir tratamento
→ cancelar NF
→ operação permitida
~~~

O histórico financeiro permanece preservado.

---

# 28. Finalidade fiscal especial

Foi homologado o reconhecimento de finalidade fiscal que exige fluxo específico.

Exemplo testado:

~~~text
finNFe = 4
→ devolução
~~~

Nesse caso:

- o XML pode ser importado;
- os dados fiscais são preservados;
- a interface informa que a finalidade requer fluxo específico;
- a efetivação normal fica bloqueada;
- a entrada provisória pode ser recusada;
- a recusa libera a chave para futura utilização no fluxo apropriado.

Não foi implementada nesta etapa integração real completa com SEFAZ para execução do fluxo fiscal específico.

---

# 29. Atomicidade

Foi homologado o princípio:

~~~text
ou toda a operação conclui
ou nenhuma parte permanece
~~~

As operações críticas incluem:

- efetivação;
- cancelamento;
- recusa de entrada provisória.

Em falha, não podem permanecer efeitos parciais em:

- NF;
- Pedido;
- estoque;
- movimentações;
- custos;
- Pagar;
- PagarItem;
- divergências;
- chave de acesso;
- histórico operacional.

---

# 30. Paginação, filtros e indicadores

Foi homologada paginação server-side.

A API utiliza:

- count;
- next;
- previous;
- results.

Filtros homologados no backend incluem:

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

Os indicadores consideram o conjunto filtrado completo e não apenas a página atual.

---

# 31. Homologação manual do fluxo XML

Após a homologação original de 18/08/2026, foi executado novo ciclo manual completo para o fluxo XML.

As NFs utilizadas foram sintéticas, preparadas especificamente para validar as regras operacionais.

## Teste 1 — Importação básica sem Pedido

Validado:

- importação XML;
- fornecedor;
- entrada sem Pedido;
- necessidade de Produto × Fornecedor.

Resultado final: **APROVADO**

## Teste 2 — Cobrança com duplicatas

O teste revelou problema na geração do financeiro.

Foi corrigido para utilizar parcelas reais de Contas a Pagar e o mapeamento fiscal de pagamento.

Resultado após correção: **APROVADO**

## Teste 3 — Forma de pagamento fiscal

Retestado:

~~~text
tPag 15
→ BOL - Boleto
~~~

Resultado: **APROVADO**

## Teste 4 — Divergência física sem Pedido

O comportamento inicial utilizava indevidamente a quantidade física conferida como quantidade de estoque.

A regra foi corrigida.

Regra definitiva:

~~~text
Fiscal = 10
Conferido = 8

NF aceita:
Estoque +10
Divergência 2
Financeiro integral
~~~

Resultado após correção: **APROVADO**

## Teste 5 — Financeiro baixado bloqueia cancelamento

Validado:

~~~text
parcela baixada
→ cancelar NF
→ BLOQUEADO
~~~

A reabertura da parcela também foi corrigida e retestada.

Resultado final: **APROVADO**

## Teste 6 — NF com Pedido

Validado:

- estoque;
- financeiro;
- recebimento do Pedido;
- atendimento total.

Resultado: **APROVADO**

## Teste 7 — Conversão de unidade

Produto × Fornecedor:

~~~text
1 PCT = 100 Un
~~~

XML:

~~~text
100 PCT
~~~

Resultado:

~~~text
10.000 Un
~~~

Resultado: **APROVADO**

## Teste 8 — Quantidade acima do saldo do Pedido

Pedido:

~~~text
100 unidades
~~~

XML:

~~~text
120 unidades
~~~

Homologado:

- importação permitida;
- conferência permitida;
- alerta antecipado;
- efetivação bloqueada.

Resultado: **APROVADO**

## Teste 9 — Recebimento parcial

Exemplo testado:

~~~text
Pedido = 100
NF = 60
Recebido = 60
Saldo = 40
Status = Parcial
~~~

Resultado: **APROVADO**

## Teste 10 — Chave duplicada

Reimportação da mesma chave foi bloqueada.

Também foi confirmado que cancelar NF efetivada não libera a chave.

Resultado: **APROVADO**

## Teste 11 — Preço acima do Pedido

O comportamento inicial permitia avanço indevido.

A regra foi corrigida para:

~~~text
NF > Pedido
→ alerta
→ efetivação bloqueada
~~~

Resultado após correção: **APROVADO**

## Teste 12 — Preço abaixo do Pedido

Foi homologado:

~~~text
NF < Pedido
→ permitido
~~~

Resultado: **APROVADO**

## Teste 13 — Regra conceitual da divergência

Foi consolidado:

~~~text
quantidade conferida
!=
quantidade fiscal de estoque
~~~

Essa decisão substituiu o comportamento anterior.

## Teste 14 — NF aceita com falta física

Cenário:

~~~text
Fiscal = 10
Conferido = 8
~~~

Validado:

- estoque pela quantidade fiscal;
- divergência = 2;
- valor divergente registrado;
- financeiro integral;
- alerta ao Contas a Pagar.

Resultado: **APROVADO**

## Teste 15 — Cancelamento com movimento posterior

Após a entrada, houve movimentação posterior de estoque.

Ao cancelar a NF:

- movimento posterior foi preservado;
- estorno foi aplicado somente à NF;
- impacto negativo foi exibido;
- saldo negativo pôde ocorrer conforme configuração da Loja.

Resultado: **APROVADO**

## Teste 16 — Finalidade fiscal especial

Foi importado XML com:

~~~text
finNFe = 4
~~~

O sistema identificou finalidade que requer fluxo específico e bloqueou a efetivação normal.

Resultado: **APROVADO**

## Teste 17 — Recusar entrada e reutilizar chave

Foi homologado:

~~~text
importar XML especial
→ Recusar entrada
→ remover importação provisória
→ liberar chave
→ importar o mesmo XML novamente
~~~

Resultado: **APROVADO**

---

# 32. Regras consolidadas após o novo ciclo

Regras finais:

~~~text
Pedido:
OPCIONAL

XML:
PRESERVADO

Produto × Fornecedor:
PERMANENTE

Conversão:
quantidade fiscal × fator

Conferência:
não substitui quantidade fiscal

NF aceita com divergência:
estoque fiscal integral

Financeiro:
valor fiscal integral

Preço NF > Pedido:
BLOQUEIA

Preço NF <= Pedido:
PERMITE

Quantidade NF > saldo:
conferência permitida
efetivação bloqueada

Cancelar NF:
preserva chave
preserva histórico
estorna efeitos

Recusar entrada:
somente provisória
remove importação
libera chave

finNFe = 4:
fluxo normal bloqueado
~~~

---

# 33. Resultado técnico

## Ciclo original de 18/08/2026

A homologação técnica original registrou:

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

## Ciclo XML posterior

O fluxo XML recebeu nova cobertura automatizada durante as correções e regressões.

Foram executados, conforme as etapas:

- testes direcionados do módulo fiscal;
- testes específicos das novas regras;
- testes de frontend;
- typecheck;
- build Angular;
- `manage.py check`;
- verificação de migrations.

Além da cobertura automatizada, o novo ciclo foi homologado manualmente nos cenários registrados neste documento.

Nenhuma falha crítica conhecida permaneceu aberta no escopo funcional homologado.

---

# 34. Commits relevantes

## Ciclo original

### Backend

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

### Frontend

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
e349eb7
Checkbox de confirmação dos itens
~~~

## Evolução XML

### Backend

~~~text
8f4e984ac53758a723964aaada64c44e66fd997c
Financeiro da NF-e sem Pedido
~~~

~~~text
9cc9758db31f578172e8a676513cc5779ffa3862
Reabertura financeira
~~~

~~~text
dac4565
Validação de preço contra Pedido
~~~

~~~text
a8ae105
Correção da divergência física
~~~

~~~text
82a2c4f
Recusa da entrada provisória
~~~

### Frontend

~~~text
33a30fb60411e25ca0fa975ec47941bfcba9a636
Cobrança da NF-e
~~~

~~~text
72cb070
Ajustes financeiros da homologação
~~~

~~~text
3361abc
Produto × Fornecedor
~~~

~~~text
8cf69ec
Correção visual Produto × Fornecedor
~~~

~~~text
50266cc
Divergências e Produto × Fornecedor
~~~

~~~text
6e33a91
Divergência física no recebimento
~~~

~~~text
f2ff987
Recusa/abandono da importação
~~~

---

# 35. Pendências e limites da etapa

Na conclusão da homologação funcional do escopo implementado:

**nenhuma pendência funcional crítica foi identificada.**

Não fazem parte desta etapa:

- integração real completa com SEFAZ;
- certificado A1/A3;
- assinatura digital;
- manifestação do destinatário;
- download automático de DF-e;
- CC-e;
- DANFE;
- execução do fluxo específico de devolução;
- demais eventos fiscais externos que dependam de integração oficial.

Esses itens não devem ser considerados defeitos da homologação atual.

A finalidade fiscal especial já é identificada e bloqueada no fluxo normal para futura evolução específica.

---

# 36. Aprovação manual

A homologação manual original de 18/08/2026 foi sucedida por novo ciclo completo de testes do fluxo XML.

Durante esse ciclo foram encontrados problemas reais em:

- financeiro sem Pedido;
- duplicatas;
- reabertura de parcela;
- preço superior ao Pedido;
- divergência física;
- recusa da importação.

Cada problema foi corrigido e retestado.

Após o último teste, inclusive:

~~~text
XML com finalidade especial
→ Recusar entrada
→ liberar chave
→ reimportar o mesmo XML
~~~

o fluxo foi considerado homologado para o escopo implementado.

Resultado:

**APROVADO**

Data final da homologação desta etapa:

**27/08/2026**

---

# 37. Estado final

~~~text
Funcionalidade:
Entrada de NF-e

Situação:
HOMOLOGADA

Homologação funcional:
APROVADA

Homologação manual:
APROVADA

Data:
27/08/2026

Tipos:
Revenda
Uso/Consumo
Insumo

Fluxo XML:
HOMOLOGADO

Entrada com Pedido:
SIM

Entrada sem Pedido:
SIM

Pedido obrigatório:
NÃO

Recebimento parcial:
SIM

Múltiplas NFs:
SIM

Produto × Fornecedor:
HOMOLOGADO

Conversão de unidade:
HOMOLOGADA

Conciliação:
HOMOLOGADA

Conferência física:
HOMOLOGADA

Quantidade de estoque na NF XML aceita:
QUANTIDADE FISCAL × FATOR

Quantidade conferida substitui fiscal:
NÃO

Divergência física:
HOMOLOGADA

Financeiro da divergência:
VALOR FISCAL INTEGRAL

Preço NF > Pedido:
BLOQUEADO

Preço NF <= Pedido:
PERMITIDO

Quantidade NF > saldo Pedido:
EFETIVAÇÃO BLOQUEADA

Chave duplicada:
BLOQUEADA

Chave após cancelamento:
PRESERVADA

Recusar entrada provisória:
HOMOLOGADO

Reimportar XML após recusa:
PERMITIDO

Cancelamento:
HOMOLOGADO

Movimentos posteriores:
PRESERVADOS

Financeiro:
INTEGRADO

Duplicatas:
INTEGRADAS

tPag:
MAPEADO

Finalidade fiscal especial:
IDENTIFICADA

finNFe = 4 no fluxo normal:
BLOQUEADO

SEFAZ real:
FORA DO ESCOPO DESTA ETAPA

Multiempresa:
PROTEGIDO

Paginação:
SERVER-SIDE

Filtros:
BACKEND

DELETE físico operacional:
BLOQUEADO

Pendência funcional crítica:
NENHUMA
~~~

---

# 38. Regra de preservação

A Entrada de NF-e é considerada funcionalidade homologada do [[Sysvar]] para o escopo implementado e documentado.

Não reabrir ou substituir suas regras sem:

- novo requisito;
- defeito comprovado;
- alteração de regra;
- nova integração;
- necessidade arquitetural real.

As decisões homologadas em 27/08/2026 prevalecem sobre comportamentos antigos que tenham sido explicitamente substituídos.

Especialmente, preservar:

~~~text
Pedido opcional

Quantidade fiscal
!=
Quantidade conferida

Estoque de NF aceita
=
Quantidade fiscal × fator

Recusar entrada
!=
Cancelar NF

NF cancelada
→ chave preservada

Entrada provisória recusada
→ chave liberada

Preço NF > Pedido
→ bloqueia

Quantidade NF > saldo
→ bloqueia efetivação
~~~

Integrações fiscais externas ainda não implementadas não devem ser presumidas como existentes.
