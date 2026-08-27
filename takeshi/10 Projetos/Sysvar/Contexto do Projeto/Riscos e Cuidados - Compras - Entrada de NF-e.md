---
type: risks-and-care
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
  - riscos
  - auditoria
  - multiempresa
  - homologado
---

# Riscos e Cuidados - Compras - Entrada de NF-e

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
- [[Modelo de Domínio - Compras - Pedido de Compra]]
- [[Workflows - Compras - Pedido de Compra]]
- [[Mapa Técnico - Compras - Entrada de NF-e]]
- [[Modelo de Domínio - Compras - Entrada de NF-e]]
- [[Workflows - Compras - Entrada de NF-e]]
- [[Homologação - Compras - Entrada de NF-e]]

---

# 2. Objetivo

Este documento registra riscos técnicos, funcionais, fiscais, operacionais e arquiteturais da Entrada de NF-e.

Deve ser consultado antes de alterações em:

- importação de XML;
- NotaFiscalEntrada;
- NotaFiscalEntradaItem;
- Produto × Fornecedor;
- conversão de unidade;
- conciliação;
- conferência física;
- divergências;
- Pedido de Compra;
- estoque;
- custos;
- financeiro;
- cancelamento;
- recusa de entrada;
- multiempresa;
- frontend da Entrada de NF-e.

O objetivo é evitar regressões em uma funcionalidade já homologada.

---

# 3. Risco — voltar a tornar Pedido obrigatório

A regra atual é:

~~~text
NF-e com Pedido
ou
NF-e sem Pedido
~~~

Não restaurar a regra antiga:

~~~text
Entrada de NF-e
→ exige Pedido
~~~

Pedido de Compra é opcional.

---

# 4. Risco — interpretar ausência de Pedido como ausência de controle

NF sem Pedido continua sujeita a:

- Empresa;
- Fornecedor;
- Produto;
- conciliação;
- conferência;
- divergências;
- estoque;
- custos;
- financeiro;
- auditoria.

Pedido opcional não significa entrada sem validação.

---

# 5. Risco — alterar a verdade fiscal do XML

No fluxo XML:

~~~text
XML
=
verdade fiscal recebida
~~~

Cadastro interno representa:

~~~text
interpretação operacional
~~~

Não sobrescrever silenciosamente:

- descrição fiscal;
- código externo;
- GTIN;
- unidade;
- quantidade;
- preço;
- total;
- cobrança;
- finalidade fiscal.

---

# 6. Risco — recriar Notas Lançadas como funcionalidade separada

A funcionalidade oficial permanece:

~~~text
Compras
→ Entrada de NF-e
~~~

A própria tela lista documentos já registrados.

Não recriar:

~~~text
Notas Lançadas
~~~

como fluxo paralelo sem nova decisão funcional.

---

# 7. Risco — exigir módulo Fiscal para acessar Entrada de NF-e

A Entrada de NF-e pertence funcionalmente ao módulo:

~~~text
compras
~~~

Não exigir:

~~~text
compras + fiscal
~~~

Regra:

~~~text
Compras + VIEW
→ consulta

Compras + EDIT
→ operações permitidas
~~~

---

# 8. Risco — confiar no frontend para segurança

O frontend não é a fronteira de segurança.

O backend deve proteger:

- Empresa;
- Fornecedor;
- Produto;
- Produto × Fornecedor;
- Pedido;
- itens;
- chave;
- quantidade;
- preço;
- finalidade fiscal;
- efetivação;
- cancelamento;
- recusa;
- estoque;
- financeiro.

---

# 9. Risco — quebra de isolamento multiempresa

Este é um risco crítico.

Não permitir cruzamento entre Empresas em:

- NotaFiscalEntrada;
- itens;
- Fornecedor;
- Produto;
- Produto × Fornecedor;
- Pedido;
- Loja;
- conciliação;
- conferência;
- divergências;
- estoque;
- financeiro.

Regra:

~~~text
ID existente
!=
ID autorizado para o tenant
~~~

---

# 10. Risco — aceitar Fornecedor incompatível com Pedido

No XML, o Fornecedor decorre do emitente fiscal.

Quando houver Pedido:

~~~text
Fornecedor NF
=
Fornecedor Pedido
~~~

Incompatibilidade deve impedir efetivação.

---

# 11. Risco — identificar Produto somente pelo código externo

Não usar apenas:

~~~text
codigo externo
~~~

A associação correta é:

~~~text
Fornecedor
+
Código externo
→
Produto interno
~~~

O mesmo código externo pode existir em Fornecedores diferentes.

---

# 12. Risco — compartilhar vínculo Produto × Fornecedor indevidamente

Não assumir que:

~~~text
Fornecedor A / código 001
=
Fornecedor B / código 001
~~~

O Fornecedor faz parte da identidade do vínculo.

---

# 13. Risco — perder fator de conversão de unidade

Exemplo:

~~~text
1 PCT = 100 UN
~~~

Não interpretar:

~~~text
100 PCT
=
100 UN
~~~

quando existe fator de conversão.

---

# 14. Risco — sobrescrever quantidade fiscal após conversão

Regra:

~~~text
Quantidade XML
→ preservada

Quantidade convertida
→ uso operacional
~~~

Conversão não altera a verdade fiscal.

---

# 15. Risco — efetivar item sem conciliação

Regra:

~~~text
Item XML
+
sem Produto interno
→
não efetiva
~~~

Não gerar estoque ou financeiro para item não conciliado.

---

# 16. Risco — conciliação existir apenas no frontend

A conciliação resolvida deve possuir estado persistido.

O vínculo Produto × Fornecedor deve ser reutilizável nas próximas importações.

Não manter essa informação somente em memória ou estado visual.

---

# 17. Risco — alterar XML para corrigir conferência física

Exemplo:

~~~text
XML = 100
Físico = 98
~~~

Resultado correto:

~~~text
registrar divergência
~~~

Resultado incorreto:

~~~text
alterar XML para 98
~~~

---

# 18. Risco — esconder divergências

Diferenças podem existir entre:

- XML e Pedido;
- XML e conferência;
- quantidade;
- preço;
- Produto;
- unidade;
- saldo restante.

Não normalizar silenciosamente divergências reais.

---

# 19. Risco — bloquear importação apenas porque quantidade excede Pedido

Regra homologada:

~~~text
Quantidade NF > saldo do Pedido
→ importação permitida
→ conferência permitida
→ alerta
→ efetivação bloqueada
~~~

Não rejeitar a verdade fiscal no momento da importação.

---

# 20. Risco — permitir efetivação acima do saldo do Pedido

A importação pode ocorrer.

A efetivação não.

A validação deve ser repetida no backend imediatamente antes da efetivação.

---

# 21. Risco — contar NF cancelada no recebimento do Pedido

NF CA não representa recebimento válido.

Cálculos de:

- já recebido;
- saldo pendente;
- atendimento do Pedido;

devem excluir documentos cancelados.

---

# 22. Risco — impedir múltiplas NFs

O domínio suporta:

~~~text
1 Pedido
→ várias NFs
~~~

Não restaurar regra de uma única NF por Pedido.

---

# 23. Risco — bloquear recebimento parcial

Exemplo válido:

~~~text
Pedido = 100

NF 1 = 60
NF 2 = 40
~~~

Enquanto existir saldo, o Pedido permanece parcialmente atendido.

---

# 24. Risco — aceitar preço maior que o aprovado no Pedido

Quando houver Pedido:

~~~text
Preço NF = Pedido
→ permitido

Preço NF < Pedido
→ permitido

Preço NF > Pedido
→ efetivação bloqueada
~~~

---

# 25. Risco — substituir preço fiscal pelo preço do Pedido

Mesmo quando o preço do XML estiver acima do Pedido, o XML deve permanecer intacto.

A divergência deve bloquear a efetivação, não modificar o documento fiscal.

---

# 26. Risco — substituir cobrança fiscal pelo planejamento do Pedido

Regra:

~~~text
Pedido
→ planejamento comercial

NF-e
→ verdade fiscal recebida
~~~

Não sobrescrever silenciosamente:

- duplicatas;
- vencimentos;
- valores;
- forma de pagamento fiscal.

---

# 27. Risco — ignorar finalidade fiscal

Status operacional e finalidade fiscal não são equivalentes.

~~~text
status AB
!=
finalidade fiscal normal
~~~

Exemplo:

~~~text
finNFe = 4
→ devolução
→ importação permitida
→ efetivação normal bloqueada
~~~

---

# 28. Risco — tratar devolução como compra normal

Uma NF-e de devolução exige fluxo fiscal específico.

Não movimentar automaticamente estoque e financeiro como compra normal apenas porque o XML foi importado.

---

# 29. Risco — considerar importação XML como entrada física

Regra:

~~~text
Importar XML
!=
Efetivar NF
~~~

Importação não movimenta estoque.

Entrada física ocorre somente na efetivação.

---

# 30. Risco — considerar Pedido aprovado como entrada de estoque

Regra:

~~~text
Cotação aprovada
!=
entrada física

Pedido aprovado
!=
entrada física

NF efetivada
=
entrada física
~~~

---

# 31. Risco — usar estoque comercial para Produto tipo 2

Produto:

~~~text
tipo_produto = 2
~~~

deve utilizar estoque dedicado de Uso/Consumo.

A regra vale independentemente da origem:

- Pedido gerado por Cotação;
- Pedido manual;
- NF sem Pedido.

Não decidir o estoque pelo tipo de origem do Pedido.

---

# 32. Risco — aplicar Pack em Uso/Consumo

Uso/Consumo utiliza quantidade direta.

Não aplicar:

- Pack;
- n_packs;
- tamanhos;
- distribuição de Revenda.

---

# 33. Risco — aplicar Pack em Insumo

Insumo também não utiliza a mecânica de Pack de Revenda.

Preservar unidade e quantidade decimal quando aplicável.

---

# 34. Risco — movimentar SKU incorreto em Revenda

Revenda pode envolver:

- Produto;
- Cor;
- Pack;
- tamanho;
- SKU.

Entrada e cancelamento devem atingir exatamente os SKUs correspondentes.

---

# 35. Risco — duplicar movimento de entrada

A efetivação deve permanecer idempotente.

Identificador:

~~~text
NFE:<id>:ENTRADA
~~~

Não gerar duas entradas para a mesma NF.

---

# 36. Risco — duplicar movimento de cancelamento

Cancelamento deve utilizar:

~~~text
NFE:<id>:CANCEL
~~~

Uma NF já cancelada não pode gerar novo estorno.

---

# 37. Risco — utilizar número comercial da NF como identidade técnica

Não utilizar apenas:

~~~text
numero da NF
~~~

para identificar movimentação ou estorno.

Utilizar o ID interno da NotaFiscalEntrada.

---

# 38. Risco — liberar chave ao cancelar NF efetivada

Regra:

~~~text
NF FE
→ Cancelar
→ NF CA
→ chave continua ocupada
~~~

Cancelar NF efetivada não libera a chave.

---

# 39. Risco — confundir Recusar entrada com Cancelar NF

Regra:

~~~text
Recusar entrada
!=
Cancelar NF
~~~

Recusa:

~~~text
NF AB provisória
→ abandono da importação
~~~

Cancelamento:

~~~text
NF FE
→ desfaz efeitos operacionais
~~~

---

# 40. Risco — recusar NF efetivada

Recusa só pode ocorrer quando a entrada ainda é provisória e elegível.

NF efetivada deve seguir:

~~~text
Cancelar NF
~~~

---

# 41. Risco — recusa deixar efeitos operacionais

Recusar entrada não pode:

- movimentar estoque;
- gerar financeiro;
- atualizar Pedido;
- criar NF cancelada;
- manter efeitos incompatíveis com abandono.

---

# 42. Risco — não liberar chave após recusa válida

Fluxo esperado:

~~~text
NF AB provisória
→ Recusar entrada
→ registro provisório removido
→ chave liberada
→ XML pode ser importado novamente
~~~

---

# 43. Risco — permitir DELETE operacional comum

DELETE direto da NF permanece bloqueado.

Operações válidas:

~~~text
NF AB provisória elegível
→ Recusar entrada

NF FE
→ Cancelar NF
~~~

---

# 44. Risco — tratar cancelamento como simples mudança de status

Cancelar não significa apenas:

~~~text
FE → CA
~~~

Também envolve:

- estoque;
- custos;
- financeiro;
- Pedido, quando houver;
- auditoria.

---

# 45. Risco — cancelamento não atômico

Cancelamento deve ser:

~~~text
SUCESSO COMPLETO
ou
ROLLBACK COMPLETO
~~~

Não deixar estado parcial.

---

# 46. Risco — efetivação não atômica

Efetivação atravessa vários domínios.

Falha em etapa crítica deve provocar rollback.

Não deixar parcialmente aplicados:

- estoque;
- custos;
- financeiro;
- Pedido;
- status da NF.

---

# 47. Risco — recusa não atômica

Recusa também deve ser transacional.

Não remover apenas parte das estruturas relacionadas.

---

# 48. Risco — cancelar uma NF e afetar outras NFs

Exemplo:

~~~text
Pedido
├── NF 1
├── NF 2
└── NF 3
~~~

Cancelar NF 2 não pode remover efeitos de NF 1 ou NF 3.

---

# 49. Risco — rollback cego de custos

Ao cancelar uma NF antiga, não restaurar simplesmente um snapshot anterior.

Custos devem ser recalculados considerando as demais NFs válidas.

---

# 50. Risco — ignorar estoque insuficiente no cancelamento

Se o estorno produzir saldo negativo não permitido pela Loja:

~~~text
Cancelamento
→ bloqueado
~~~

Nenhum outro efeito deve permanecer aplicado.

---

# 51. Risco — desfazer pagamento silenciosamente

Quando o financeiro possuir baixa incompatível com reversão automática:

~~~text
Cancelar NF
→ bloqueado
~~~

Não apagar ou desfazer pagamento silenciosamente.

---

# 52. Risco — usar checkbox manual como regra do fluxo XML

O checkbox OK pertence ao lançamento manual anteriormente homologado.

Não confundir:

~~~text
checkbox manual
~~~

com:

~~~text
conciliação XML
+
conferência física
~~~

São mecanismos diferentes.

---

# 53. Risco — reintroduzir ações antigas sem decisão funcional

Não reintroduzir automaticamente:

- Inserir;
- Remover;
- coluna Ações;
- menu por linha;

como substituição do fluxo XML.

Mudanças desse tipo exigem nova decisão funcional.

---

# 54. Risco — permitir edição livre em FE ou CA

NF efetivada ou cancelada representa histórico operacional.

Não permitir edição irrestrita depois da efetivação.

---

# 55. Risco — filtros escaparem do tenant

Filtros por:

- Pedido;
- número;
- chave;
- Fornecedor;
- Loja;
- datas;
- status;

devem permanecer subordinados à Empresa.

---

# 56. Risco — indicadores representarem somente a página atual

Paginação não pode alterar o significado dos indicadores.

Totais devem representar o conjunto filtrado completo.

---

# 57. Invariantes de preservação

~~~text
Pedido
= opcional

XML
= verdade fiscal

Fornecedor + código externo
= Produto × Fornecedor

Item sem conciliação
= não efetiva

Quantidade NF > saldo Pedido
= importação permitida
= conferência permitida
= efetivação bloqueada

Preço NF > Pedido
= efetivação bloqueada

Importar XML
!=
entrada física

Pedido aprovado
!=
entrada física

Produto tipo 2
= estoque dedicado de Uso/Consumo

Recusar entrada
!=
Cancelar NF

NF cancelada
= chave preservada

Recusa válida
= chave liberada

Efetivação
= transacional

Cancelamento
= transacional

Recusa
= transacional

Multiempresa
= obrigatória
~~~

---

# 58. Regra de preservação

Este documento representa os riscos e cuidados do fluxo homologado da Entrada de NF-e.

Alterações futuras devem preservar estas regras até que nova decisão funcional seja implementada, testada, homologada e documentada.