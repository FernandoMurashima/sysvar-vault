---
type: risks-and-care
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
  - riscos
  - auditoria
  - multiempresa
  - homologado
---

# Riscos e Cuidados - Compras - Pedido de Compra

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
- [[Workflows - Compras - Pedido de Compra]]
- [[Homologação - Compras - Pedido de Compra]]

---

# 2. Objetivo

Este documento registra os principais riscos técnicos, funcionais, operacionais e arquiteturais relacionados ao Pedido de Compra do [[Sysvar]].

Deve ser consultado antes de alterações relevantes em:

- `PedidoCompra`;
- `PedidoCompraItem`;
- `PedidoCompraParcela`;
- `PedidoCompraEntrega`;
- serializers;
- viewsets;
- aprovação;
- Financeiro;
- Fiscal;
- recebimento;
- frontend de Pedido de Compra;
- regras de Produto relacionadas a Compras.

O objetivo é preservar o comportamento já homologado e evitar regressões.

---

# 3. Risco — recriar pedidos separados por tipo

O principal cuidado arquitetural é não desfazer a unificação.

A funcionalidade oficial é:

**Pedido de Compra**

Não devem voltar a existir como fluxos independentes:

- Pedido de Revenda;
- Pedido de Uso/Consumo;
- Pedido de Insumo.

A separação é interna e automática.

---

# 4. Risco — permitir escolha manual do tipo

O usuário não escolhe o tipo do Pedido.

O primeiro item define:

~~~text
Pedido sem tipo
      ↓
Primeiro Produto
      ↓
tipo_produto
      ↓
Pedido.tipo
~~~

Adicionar um seletor manual de tipo cria possibilidade de divergência entre:

- tipo escolhido;
- tipo real dos produtos.

Essa alteração não deve ser feita sem nova decisão funcional explícita.

---

# 5. Risco — não limpar tipo ao excluir último item

Quando o último item de um Pedido AB for removido:

~~~text
tipo deve voltar para ''
~~~

Se o tipo permanecer gravado, um Pedido vazio poderá ficar indevidamente preso ao tipo antigo.

Consequência:

- usuário não consegue reutilizar corretamente o Pedido;
- busca de Produto pode ficar incorretamente filtrada;
- comportamento deixa de refletir o estado real.

---

# 6. Risco — mistura de tipos

Nunca permitir mistura entre:

~~~text
1 = Revenda
2 = Uso/Consumo
4 = Insumo
~~~

Exemplos inválidos:

- Revenda + Uso/Consumo;
- Revenda + Insumo;
- Uso/Consumo + Insumo.

A validação precisa permanecer no backend.

Filtro de frontend não é proteção suficiente.

---

# 7. Risco — permitir Fabricação Própria em Compras

Produto:

~~~text
tipo_produto = 3
~~~

não participa de Compras.

Fabricação Própria pertence ao fluxo de Produção.

Permitir sua inclusão pode provocar:

- duplicação de abastecimento;
- estoque incorreto;
- custo incorreto;
- conflito com Ordem de Produção;
- histórico operacional incoerente.

---

# 8. Risco — confiar no frontend

As principais regras precisam permanecer protegidas pelo backend.

O frontend pode:

- filtrar;
- orientar;
- esconder opções;
- apresentar mensagens.

Mas não é autoridade para:

- tipo;
- Empresa;
- status;
- cálculo;
- aprovação;
- permissões;
- integração financeira.

Qualquer chamada direta à API deve encontrar as mesmas proteções.

---

# 9. Risco — quebra de isolamento multiempresa

Pedido de Compra é multiempresa.

Toda alteração deve verificar coerência entre:

- usuário;
- Empresa;
- Loja;
- Fornecedor;
- Produto;
- Forma de Pagamento;
- Prazo;
- Natureza;
- Financeiro;
- Recebimento.

Uma falha nessa proteção pode permitir acesso ou relacionamento cruzado entre clientes diferentes do SaaS.

Esse risco é crítico.

---

# 10. Risco — Loja de outra Empresa

Não aceitar Loja apenas porque o ID existe.

A Loja precisa pertencer à Empresa permitida ao usuário.

O backend deve continuar validando esse relacionamento.

---

# 11. Risco — Fornecedor de outra Empresa

Fornecedor também precisa respeitar o contexto empresarial.

Não permitir relacionamento cruzado indevido entre:

~~~text
Pedido da Empresa A
+
Fornecedor da Empresa B
~~~

---

# 12. Risco — Fornecedor inativo ou bloqueado

Novo Pedido AB não deve utilizar Fornecedor:

- inativo;
- bloqueado.

Alterações futuras no cadastro de Fornecedor não devem remover silenciosamente essa proteção.

---

# 13. Risco — alterar itens depois da aprovação

Itens são editáveis somente enquanto:

~~~text
status = AB
~~~

Permitir alteração após AP pode provocar divergência entre:

- Pedido;
- parcelas;
- Financeiro;
- Nota Fiscal;
- recebimento;
- estoque.

Essa proteção é fundamental.

---

# 14. Risco — excluir Pedido aprovado

Exclusão física só é permitida em:

~~~text
AB
~~~

Pedidos AP, AT ou CA possuem significado histórico e operacional.

Não usar `delete` para substituir cancelamento.

---

# 15. Risco — tratar cancelamento como exclusão

Cancelamento deve preservar o Pedido.

A exclusão elimina o registro.

São conceitos diferentes:

~~~text
Excluir
→ registro deixa de existir

Cancelar
→ registro permanece, status muda
~~~

Não misturar esses comportamentos.

---

# 16. Risco — cálculo duplicado no frontend

Os cálculos podem ser mostrados antecipadamente no frontend, mas backend deve continuar recalculando.

Não considerar valores enviados pela tela como definitivos para:

- quantidade de Revenda;
- total do item;
- total dos itens;
- total do Pedido.

---

# 17. Risco — alterar fórmula do total

A fórmula vigente é:

~~~text
total_pedido =
total_itens
- total_desconto
+ frete
~~~

Alterações futuras em impostos, despesas ou acréscimos não devem ser incorporadas silenciosamente a essa fórmula.

Se houver novo componente financeiro, precisa de decisão explícita e modelagem própria.

---

# 18. Risco — desconto negativo

Tanto desconto geral quanto valores financeiros relacionados precisam respeitar as validações vigentes.

Não utilizar valores negativos para representar acréscimos.

Se acréscimo for necessário futuramente, deve existir conceito próprio.

---

# 19. Risco — total negativo

O Pedido nunca pode ficar com:

~~~text
total_pedido < 0
~~~

E para aprovação:

~~~text
total_pedido > 0
~~~

Essa regra deve permanecer no backend.

---

# 20. Risco — quantidade manual em Revenda

Para tipo 1:

~~~text
qtd = quantidade derivada do Pack
~~~

Não permitir que o usuário informe uma quantidade independente do Pack.

Isso quebraria a lógica da compra por grade.

---

# 21. Risco — Pack sem itens

A quantidade de Revenda depende dos itens do Pack.

Se um Pack estiver vazio ou inconsistente, a quantidade calculada pode resultar em zero.

Alterações futuras devem impedir aprovação de uma compra estruturalmente inválida.

---

# 22. Risco — Pack incompatível com Produto

A simples existência de um Pack não significa que ele seja válido para qualquer Produto.

Ao evoluir essa área, preservar a coerência entre:

- Produto;
- Grade;
- Pack;
- Cor.

Não aceitar combinações arbitrárias.

---

# 23. Risco — quantidade decimal em Revenda

Revenda trabalha com quantidade final de peças.

Não permitir quantidade fracionária nesse tipo.

---

# 24. Risco — ignorar permite_decimal

Para Uso/Consumo e Insumo, quantidade decimal depende da Unidade.

Não remover a validação baseada em:

`unidade.permite_decimal`

Sem ela podem surgir quantidades impossíveis, por exemplo:

~~~text
0,5 UN
~~~

para uma Unidade que só aceite valores inteiros.

---

# 25. Risco — reutilizar regra de Revenda em Insumo

Insumo não utiliza Pack.

Mesmo que o domínio compartilhe parte da estrutura de itens, não aplicar automaticamente:

- Cor;
- Pack;
- `n_packs`.

A mecânica é de quantidade direta.

---

# 26. Risco — confundir Uso/Consumo com Insumo

Tipos 2 e 4 possuem mecânica semelhante, mas finalidade diferente.

Não unificar os códigos de domínio.

O tipo precisa continuar distinguível para:

- relatórios;
- estoque;
- produção;
- compras;
- análise gerencial.

---

# 27. Risco — permitir edição direta de forma_pagamento

A Forma de Pagamento é configurada por ação específica.

Não transformar:

`forma_pagamento`

em simples campo livre de edição.

A ação existente também é responsável pela sincronização das parcelas.

---

# 28. Risco — alterar Forma sem regenerar parcelas

Forma e Prazo determinam o planejamento financeiro.

Se forem alterados:

~~~text
Forma/Prazo
    ↓
parcelas PLAN antigas
    ↓
devem ser regeneradas
~~~

Caso contrário, o cabeçalho pode indicar uma condição e as parcelas refletirem outra.

---

# 29. Risco — alterar total sem sincronizar parcelas

Mudanças em:

- itens;
- desconto;
- frete;

podem alterar o total.

Se existirem parcelas planejadas, é necessário manter:

~~~text
soma das parcelas = total_pedido
~~~

Não deixar planejamento financeiro obsoleto.

---

# 30. Risco — arredondamento financeiro

Parcelas usam valores monetários com duas casas decimais.

Distribuições percentuais podem gerar resíduos de centavos.

A lógica deve assegurar que a soma final seja exatamente igual ao total do Pedido.

Não tolerar diferença acumulada silenciosamente.

---

# 31. Risco — aprovar sem parcelas

Pedido não deve ser aprovado sem planejamento financeiro válido quando a Forma de Pagamento fizer parte do fluxo.

Aprovação exige coerência entre:

- Forma;
- Prazo;
- parcelas;
- total.

---

# 32. Risco — aprovar parcelas inconsistentes

Não aprovar quando:

~~~text
soma(parcelas) != total_pedido
~~~

A interface pode indicar a diferença, mas backend deve impedir a aprovação.

---

# 33. Risco — Natureza fora da Empresa

A Natureza escolhida na aprovação precisa ser compatível com a Empresa do Pedido.

Não aceitar `idnatureza` apenas porque o registro existe.

---

# 34. Risco — colocar Natureza no cabeçalho principal

O padrão homologado escolhe a Natureza na aprovação.

Ela não precisa ocupar a tela principal durante toda a edição.

Mover essa decisão para o cabeçalho altera o fluxo funcional aprovado.

---

# 35. Risco — aprovação não atômica

A aprovação é uma operação crítica.

Ela pode envolver:

- validações;
- criação de Pagar;
- criação de PagarItem;
- atualização de parcelas;
- mudança de status;
- auditoria.

A operação precisa permanecer transacional.

Em caso de falha:

~~~text
ROLLBACK
~~~

Não deixar registros financeiros parciais.

---

# 36. Risco — duplicar financeiro em nova aprovação

Pedido não pode gerar compromissos financeiros duplicados.

A mudança de estado e as validações devem impedir aprovação repetida indevida.

---

# 37. Risco — confundir planejamento com título financeiro

`PedidoCompraParcela` não é a mesma coisa que `PagarItem`.

Conceitos:

~~~text
PedidoCompraParcela
→ planejamento

PagarItem
→ obrigação financeira
~~~

Não eliminar uma dessas estruturas sem revisar profundamente a integração.

---

# 38. Risco — alterar parcelas após geração financeira

Depois da aprovação, as parcelas financeiras já possuem significado em Contas a Pagar.

Não permitir simples reconfiguração pela tela de Pedido como se ainda fossem apenas planejamento.

---

# 39. Risco — gerar estoque na aprovação

Aprovação significa:

**autorização/fechamento da compra**

Não significa:

**mercadoria recebida**

Nunca gerar entrada de estoque diretamente em:

~~~text
AB → AP
~~~

---

# 40. Risco — criar recebimento paralelo no Pedido

Recebimento real deve permanecer integrado à Nota Fiscal de Entrada.

Não criar botão ou rotina que faça entrada física independente diretamente pelo Pedido sem considerar Fiscal.

Isso poderia gerar:

- duplicidade;
- estoque incorreto;
- fiscal sem correspondência;
- divergência de custo.

---

# 41. Risco — transformar modal de Recebimentos em tela de entrada

A sobretela de Recebimentos no Pedido é principalmente consultiva.

Não transformá-la silenciosamente em uma segunda rotina de entrada de mercadoria.

---

# 42. Risco — marcar AT com recebimento parcial

Estado:

~~~text
AT = Atendido
~~~

significa atendimento integral.

Se existir qualquer saldo ainda pendente, Pedido deve permanecer AP.

---

# 43. Risco — não recalcular depois de cancelamento fiscal

Uma NF cancelada pode invalidar quantidades anteriormente recebidas.

Se o Pedido estava AT e deixa de estar integralmente atendido, seu status precisa refletir novamente a realidade.

Não tratar AT como estado irreversível.

---

# 44. Risco — cancelamento de NF sem reflexo no estoque

O fluxo fiscal de cancelamento precisa permanecer coerente também com Estoque.

Ao evoluir o recebimento de Pedido, não atualizar apenas o status de Compras ignorando o movimento físico.

---

# 45. Risco — vínculo insuficiente entre Pedido e NF

A integração precisa permitir rastrear qual recebimento corresponde a qual Pedido/item.

Não depender apenas de:

- texto;
- observação;
- número digitado manualmente.

Relacionamentos estruturados devem ser priorizados.

---

# 46. Risco — recebimento acima da quantidade

Alterações futuras na integração devem cuidar para não aceitar recebimento acumulado indevido acima do Pedido sem regra explícita.

Caso compra excedente seja necessária, precisa existir tratamento funcional definido.

---

# 47. Risco — múltiplos recebimentos

Pedidos podem ser recebidos parcialmente em várias entradas.

Não presumir relação:

~~~text
1 Pedido = 1 NF
~~~

O modelo precisa continuar suportando atendimento progressivo.

---

# 48. Risco — filtros sem multiempresa

Listagens e buscas auxiliares devem sempre respeitar a Empresa.

Isso inclui:

- pedidos;
- produtos;
- fornecedores;
- formas;
- prazos;
- naturezas;
- recebimentos.

---

# 49. Risco — consulta de produto incompatível

Depois que o Pedido tiver tipo definido, a busca do frontend deve evitar apresentar Produtos incompatíveis.

Mesmo assim, nunca retirar a validação equivalente do backend.

---

# 50. Risco — rotas antigas voltarem a ser telas reais

As rotas antigas podem existir para compatibilidade de navegação por redirecionamento.

Não voltar a associá-las a componentes próprios divergentes.

A rota canônica permanece:

~~~text
/compras/pedidos
~~~

---

# 51. Risco — código legado de pedidos separados

Ao encontrar componentes antigos como:

- pedidos-revenda;
- pedidos-uso-consumo;

não assumir que devem ser reutilizados como telas independentes.

A referência funcional atual é o componente unificado.

Código legado só deve ser mantido quando ainda houver dependência real.

---

# 52. Risco — remover legado sem verificar referência

Por outro lado, não apagar arquivos antigos apenas por parecerem obsoletos.

Antes:

1. pesquisar imports;
2. pesquisar rotas;
3. pesquisar serviços;
4. pesquisar testes;
5. verificar dependências.

Somente remover quando comprovadamente sem uso.

---

# 53. Risco — quebrar padrão visual homologado

O layout final foi ajustado e aprovado.

Preservar:

- tela principal limpa;
- indicadores compactos;
- itens em sobretela;
- pagamento em sobretela;
- recebimentos em sobretela;
- seleção de linha;
- ações coerentes com status.

Não redesenhar a tela sem requisito.

---

# 54. Risco — voltar a usar coluna de ações como padrão

Nas estruturas que seguem o padrão homologado do [[Sysvar]], privilegiar:

~~~text
seleção de linha
+
barra de ações
~~~

Não reintroduzir menus de três pontos ou coluna de ações de forma indiscriminada.

---

# 55. Risco — esconder informação de estado

Mesmo com interface compacta, não ocultar informações relevantes como:

- tipo;
- status;
- situação de parcelas;
- recebimento;
- total.

Compactar não significa retirar contexto operacional.

---

# 56. Risco — permitir ação incompatível com status

Cada ação deve respeitar o ciclo de vida.

Exemplo:

~~~text
AB
→ edição

AP
→ acompanhamento

AT
→ consulta

CA
→ consulta
~~~

Não habilitar botão apenas porque tecnicamente existe endpoint.

---

# 57. Risco — permissões apenas pela rota Angular

A rota Angular possui restrições, mas backend continua sendo autoridade.

Nunca assumir que esconder a rota protege a API.

---

# 58. Risco — auditoria fora da transação

Operações críticas devem registrar auditoria sem comprometer consistência.

A implementação existente considera gravação após commit quando necessário.

Alterações futuras devem preservar o princípio:

~~~text
operação concluída
→ auditoria de sucesso
~~~

e não registrar sucesso antes da confirmação da transação.

---

# 59. Risco — criar auditoria paralela

Pedido de Compra usa a Auditoria Central do [[Sysvar]].

Não criar tabela ou mecanismo separado apenas para Compras sem necessidade arquitetural real.

---

# 60. Risco — alterar status diretamente

Mudanças de estado devem ocorrer por operações de domínio.

Evitar:

~~~text
pedido.status = 'AT'
pedido.save()
~~~

espalhado em múltiplos locais sem regra comum.

Mudanças futuras devem concentrar e reutilizar lógica de transição sempre que possível.

---

# 61. Risco — status inconsistente com entregas

Exemplo inválido:

~~~text
Pedido = AT
entregas ainda parciais
~~~

O status geral precisa refletir os dados reais de recebimento.

---

# 62. Risco — usar Pedido como substituto da NF

Pedido é documento comercial/operacional interno.

Nota Fiscal é documento fiscal.

Não misturar responsabilidades.

---

# 63. Risco — usar Pedido como substituto do Financeiro

Pedido define o compromisso comercial.

Financeiro controla o título.

Não implementar baixa, juros ou pagamento diretamente dentro do Pedido sem integração correta com Financeiro.

---

# 64. Risco — alterar Produto para atender Compras localmente

Se Compras precisar de informação já pertencente a Produto, preferir reutilizar o domínio de Produto.

Não duplicar:

- Unidade;
- Cor;
- Pack;
- tipo;
- descrição;
- classificação.

---

# 65. Risco — modificar Packs pelo Pedido

Pedido consome Pack existente.

Não transformar a sobretela de Itens em cadastro de Pack.

A manutenção do Pack pertence ao domínio de Produtos.

---

# 66. Risco — custo futuro confundido com preço do Pedido

`preco_unit` representa preço negociado naquela compra.

Não substituir automaticamente campos de custo de Produto sem regra de recebimento/custeio definida.

Atualização de custo deve ocorrer no ponto operacional correto.

---

# 67. Risco — previsão de entrega tratada como recebimento

`previsao_entrega` é expectativa.

Não confundir:

~~~text
data prevista