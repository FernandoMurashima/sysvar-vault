---
type: domain-model
status: approved
project: Sysvar
group: Produtos
module: Produto Venda
phase: Fase 1
created: 2026-08-13
updated: 2026-08-13
tags:
  - sysvar
  - produtos
  - produto-venda
  - revenda
  - fabricação-própria
  - sku
  - ean
  - grade
  - cores
  - estoque
  - fiscal
  - imagens
  - histórico
  - auditoria
  - multiempresa
  - domínio
  - homologado
---

# Modelo de Domínio - Produtos - Produto Venda

## 1. Identificação

- **Projeto:** Sysvar
- **Módulo:** Produtos
- **Funcionalidade:** Produto Venda
- **Tipos contemplados:** Revenda e Fabricação Própria
- **Escopo:** Fase 1 — Cadastro e gestão estrutural
- **Situação:** IMPLEMENTADO E HOMOLOGADO
- **Homologação manual:** 19/19 itens aprovados
- **Data da homologação:** 13/08/2026

---

# 2. Objetivo do Modelo de Domínio

O domínio de Produto Venda representa os produtos comercializáveis pelas empresas atendidas pelo Sysvar.

Seu objetivo é fornecer uma estrutura única e consistente para que os demais módulos possam identificar corretamente:

- qual é o Produto;
- a qual Empresa pertence;
- se é Revenda ou Fabricação Própria;
- qual é sua Referência;
- qual sua classificação;
- qual sua Grade;
- quais Cores estão vinculadas;
- quais SKUs existem;
- quais EANs identificam esses SKUs;
- em quais Lojas existe estrutura de Estoque;
- quais são os saldos por Loja × SKU;
- quais são seus Dados fiscais;
- quais imagens estão vinculadas;
- qual sua situação operacional;
- se está bloqueado para venda;
- quais eventos relevantes ocorreram;
- quais processos de Compra ou Produção podem abastecê-lo.

Produto Venda não representa todos os tipos possíveis de item do sistema.

Nesta fase, o domínio contempla:

~~~text
Produto Venda
    ├── Revenda
    └── Fabricação Própria
~~~

Produto de Uso e Consumo permanece em domínio funcional separado.

---

# 3. Agregado Principal

A entidade central do domínio é:

`Produto`

Relacionamentos conceituais principais:

~~~text
Empresa
  ↓
Produto
  ├── Tipo do Produto
  ├── Coleção
  ├── Grupo
  ├── Subgrupo
  ├── Unidade
  ├── Material
  ├── Grade
  ├── ProdutoDetalhe / SKU
  │     ├── Cor
  │     ├── Tamanho
  │     ├── EAN
  │     ├── Custos
  │     └── Estoque por Loja
  ├── Dados Fiscais
  ├── Preços
  ├── ProdutoImagem
  ├── ProdutoVendaHistorico
  └── AuditLog
~~~

Para Produto de Fabricação Própria existem ainda relações operacionais com:

~~~text
Produto
  ├── Ficha Técnica
  └── Ordem de Produção
~~~

Produto é a raiz cadastral do agregado.

ProdutoDetalhe representa suas variações comercializáveis.

---

# 4. Separações Fundamentais

O domínio depende de separações que não podem ser confundidas:

~~~text
Produto != SKU
Produto != Estoque
Produto != Preço
Produto != Movimento de Estoque
Produto != Ficha Técnica
Produto != Ordem de Produção

Ativo != Bloqueado para venda
Inativar != Excluir
Retirar Cor != Excluir SKU

ProdutoVendaHistorico != AuditLog

Revenda != Fabricação Própria
Produto Venda != Uso e Consumo
~~~

Essas separações são permanentes.

---

# 5. Empresa

Todo Produto Venda pertence a uma Empresa.

Relacionamento:

`Empresa 1:N Produto`

Regra:

> Produto Venda nunca deve existir fora do contexto de uma Empresa.

A Empresa determina o tenant do Produto.

Consequências:

- Grupo deve respeitar a Empresa;
- Subgrupo deve respeitar a Empresa;
- Coleção deve respeitar a Empresa;
- Unidade deve respeitar a Empresa;
- Grade deve respeitar o contexto permitido;
- Cores devem respeitar o contexto permitido;
- Lojas devem pertencer à Empresa;
- Estoque deve respeitar a Empresa;
- preços devem respeitar o tenant;
- histórico deve respeitar o tenant;
- imagens pertencem ao Produto da Empresa;
- consultas devem ser restritas à Empresa do usuário.

---

# 6. Isolamento Multiempresa

Não existe Produto Venda global compartilhado livremente entre empresas distintas.

Conceitualmente:

~~~text
Empresa A
  ↓
Produto A

Empresa B
  ↓
Produto B
~~~

Mesmo que os dois Produtos possuam:

- mesma descrição;
- mesmo NCM;
- mesmo Grupo textual;
- mesma Grade textual;

eles continuam pertencendo a tenants diferentes.

O backend é autoridade dessa separação.

---

# 7. Produto

Entidade:

`Produto`

Produto representa o cadastro principal da mercadoria.

Ele concentra características comuns a todas as variações.

Exemplo:

~~~text
Produto:
Calça Jeans Feminina

Variações:
Preta 38
Preta 40
Preta 42
Azul 38
Azul 40
Azul 42
~~~

O Produto é:

`Calça Jeans Feminina`

Cada combinação Cor × Tamanho é um SKU.

---

# 8. Tipos do Produto Venda

Produto Venda utiliza dois tipos.

## 8.1 Revenda

Código interno:

`1`

Representa produto adquirido de terceiros para comercialização.

Abastecimento principal:

- Pedido de Compra;
- recebimento;
- entrada de Estoque.

## 8.2 Fabricação Própria

Código interno:

`3`

Representa produto fabricado pela própria operação.

Abastecimento principal:

- Ficha Técnica;
- Ordem de Produção;
- processo produtivo;
- entrada do produto acabado.

---

# 9. Nome Funcional

O nome funcional aprovado é:

**Produto Venda**

Não utilizar como nome geral do módulo:

- Produtos Revenda;
- Produto Revenda, quando se referir aos dois tipos;
- Produto Próprio.

Para o tipo `3`, a apresentação funcional é:

**Fabricação Própria**

---

# 10. Imutabilidade do Tipo

O tipo pertence à identidade operacional do Produto.

Regra:

> Depois que o Produto é criado, seu tipo não pode ser alterado.

Não permitir:

~~~text
Revenda
   ↓
Fabricação Própria
~~~

nem:

~~~text
Fabricação Própria
   ↓
Revenda
~~~

A mudança poderia quebrar relações históricas com:

- Compras;
- Produção;
- custos;
- Estoque;
- processos posteriores.

---

# 11. Referência

Produto Venda possui Referência automática.

Formato:

~~~text
AA-BB-CCDDD
~~~

A Referência pertence ao Produto, não ao SKU.

Exemplo conceitual:

~~~text
Produto:
26-01-12001
~~~

Os SKUs derivados desse Produto possuem seus próprios identificadores e EANs.

---

# 12. Composição da Referência

A Referência utiliza:

~~~text
AA = ano da Coleção
BB = Estação
CC = CodigoRef do Grupo
DDD = sequência
~~~

A sequência identifica o Produto dentro da regra existente.

A geração deve permanecer centralizada.

Não gerar referências paralelas no frontend.

---

# 13. Descrição

Produto possui:

- descrição principal;
- descrição reduzida.

A descrição principal representa o nome comercial/cadastral.

A descrição reduzida representa versão compacta.

---

# 14. Descrição Reduzida

Regra:

- obrigatória;
- máximo de 60 caracteres.

Ela pertence ao Produto.

Não é uma descrição diferente por SKU.

---

# 15. Coleção

Coleção classifica temporal/comercialmente o Produto.

Relacionamento conceitual:

~~~text
Coleção 1:N Produto
~~~

Ela também participa da composição da Referência.

Coleção não define:

- SKU;
- Cor;
- Estoque;
- Preço diretamente.

---

# 16. Grupo

Grupo representa uma classificação principal do Produto.

Relacionamento:

~~~text
Grupo 1:N Produto
~~~

Grupo é obrigatório.

Seu `CodigoRef` participa da geração da Referência.

---

# 17. Subgrupo

Subgrupo representa uma classificação mais específica.

Relacionamento conceitual:

~~~text
Grupo
  ↓
Subgrupo
  ↓
Produto
~~~

Subgrupo é obrigatório.

Subgrupo deve ser compatível com o Grupo.

Não permitir:

~~~text
Grupo A
+
Subgrupo pertencente ao Grupo B
~~~

---

# 18. Unidade

Produto Venda possui Unidade obrigatória.

Relacionamento:

~~~text
Unidade 1:N Produto
~~~

Exemplos:

- UN;
- PC;
- CJ.

Unidade pertence ao Produto.

Não existe Unidade distinta por Cor ou Tamanho neste escopo.

---

# 19. Material

Material é uma classificação opcional.

Pode auxiliar:

- identificação;
- pesquisa;
- organização;
- integrações futuras.

Material não substitui os componentes da Ficha Técnica.

---

# 20. Grade

Grade define o conjunto de Tamanhos possíveis do Produto.

Relacionamento conceitual:

~~~text
Grade
  ↓
Tamanhos
  ↓
Produto
~~~

Exemplo:

~~~text
Grade Adulto Numérica
  ├── 38
  ├── 40
  ├── 42
  ├── 44
  ├── 46
  └── 48
~~~

Grade é obrigatória em Produto Venda.

---

# 21. Imutabilidade da Grade

Depois da geração de SKUs, a Grade torna-se estruturalmente protegida.

Regra:

~~~text
Produto possui SKU?
    ├── Sim → Grade imutável
    └── Não → alteração conforme regras permitidas
~~~

Motivo:

SKU já referencia Tamanho pertencente à Grade.

---

# 22. Cor

Cor é uma dimensão de variação do Produto.

Relacionamento conceitual:

~~~text
Produto
  ↓
Cores selecionadas
  ↓
SKUs
~~~

Cor isoladamente não é um SKU.

---

# 23. Tamanho

Tamanho é outra dimensão de variação.

Ele normalmente deriva da Grade.

Relacionamento:

~~~text
Grade
  ↓
Tamanho
~~~

SKU combina:

~~~text
Produto + Cor + Tamanho
~~~

---

# 24. ProdutoDetalhe

Entidade:

`ProdutoDetalhe`

Representa o SKU.

É uma entidade distinta de Produto.

Exemplo:

~~~text
Produto:
Vestido Midi

SKU 1:
Vestido Midi / Preto / P

SKU 2:
Vestido Midi / Preto / M

SKU 3:
Vestido Midi / Vermelho / P
~~~

---

# 25. Identidade do SKU

A identidade lógica da variação é:

~~~text
Produto
+
Cor
+
Tamanho
~~~

Essa combinação não deve gerar SKUs duplicados.

---

# 26. Ciclo de Vida do SKU

Estados relevantes:

~~~text
ATIVO
  ↓
Cor removida
  ↓
INATIVO
  ↓
Cor reincluída
  ↓
ATIVO
~~~

O SKU permanece sendo a mesma entidade.

Não deve ser apagado e recriado.

---

# 27. Inclusão de Cor

Quando nova Cor é incluída no Produto:

~~~text
Cor
+
todos os Tamanhos da Grade
        ↓
SKUs
~~~

Para cada combinação:

- reutilizar SKU existente quando houver;
- criar somente quando realmente inexistente.

---

# 28. Remoção de Cor

Retirar uma Cor não significa apagar sua história.

Regra:

> Todos os SKUs dessa Cor são inativados.

Preservar:

- ID;
- EAN;
- Tamanho;
- Cor;
- custos;
- histórico;
- possíveis movimentos.

---

# 29. Remoção da Última Cor

O domínio aceita Produto temporariamente sem Cor ativa, desde que os SKUs anteriores permaneçam preservados como inativos.

Não apagar o Produto automaticamente.

Não apagar SKUs automaticamente.

---

# 30. Reativação de Cor

Quando uma Cor retorna:

~~~text
Produto
+
Cor anteriormente utilizada
        ↓
Localizar SKUs
        ↓
Reativar
~~~

A reativação preserva a identidade do SKU.

---

# 31. EAN

EAN identifica o SKU.

Relacionamento conceitual:

~~~text
ProdutoDetalhe
   ↓
EAN
~~~

EAN não pertence diretamente ao Produto principal.

Um Produto com várias variações possuirá vários EANs.

---

# 32. Estabilidade do EAN

EAN deve permanecer estável.

Regra:

~~~text
SKU inativado
    ↓
EAN continua pertencendo ao SKU
~~~

Quando reativado:

~~~text
mesmo SKU
=
mesmo EAN
~~~

Não reciclar EAN para outro SKU.

---

# 33. Configuração de EAN

A geração utiliza a estrutura existente de configuração por Empresa.

Conceitualmente:

~~~text
ConfigEan
  ├── prefixo do país
  ├── prefixo da Empresa
  ├── próximo item
  └── regras de geração
~~~

Produto Venda não cria segundo gerador de EAN.

---

# 34. Código Interno do SKU

Além do EAN, ProdutoDetalhe preserva seu identificador interno.

Esse identificador também deve ser estável durante:

- inativação;
- reativação.

---

# 35. Status do SKU

Atributo conceitual:

`ativo`

Estados:

- Ativo;
- Inativo.

A consulta deve informar explicitamente o estado.

SKU inativo não deve desaparecer completamente das consultas de histórico/estrutura quando sua visualização for necessária.

---

# 36. Loja

Loja representa o local operacional onde o SKU pode possuir Estoque.

Relacionamento:

~~~text
Empresa
  ↓
Loja
~~~

Loja utilizada em Produto Venda deve pertencer à mesma Empresa.

---

# 37. Estoque

Estoque não é atributo simples do Produto.

A granularidade correta é:

~~~text
Loja × SKU
~~~

Exemplo:

~~~text
Produto: Camiseta
SKU: Preta M

Loja Barra:
10 unidades

Loja Tijuca:
3 unidades
~~~

São dois saldos distintos.

---

# 38. Inicialização do Estoque

Ao cadastrar Produto Venda podem ser selecionadas Lojas.

Isso cria/prepara a estrutura:

~~~text
Loja × ProdutoDetalhe
~~~

com saldo zero quando não existe entrada física.

Inicialização não é movimentação.

---

# 39. Estoque Físico

Representa a quantidade física registrada.

Entidade conceitual:

~~~text
Estoque
  ├── Loja
  ├── SKU
  └── quantidade física
~~~

---

# 40. Reserva

Reserva representa quantidade comprometida.

Ela não altera a identidade do Produto ou do SKU.

Reserva é conceito operacional de Estoque/Vendas.

---

# 41. Disponível

Derivação conceitual:

~~~text
Disponível = Físico - Reserva
~~~

Não criar campo funcional independente sem necessidade se o valor puder ser derivado pelas regras existentes.

---

# 42. Estoque Negativo

A permissão para trabalhar com Estoque negativo pertence às regras próprias de Estoque e operação.

Produto Venda não deve possuir regra paralela.

---

# 43. Custos

Custos são relacionados operacionalmente ao Produto/SKU.

Conceitos existentes incluem:

- custo original;
- custo da última compra;
- custo médio.

O SKU é a unidade mais específica da variação.

---

# 44. Custo de Revenda

No tipo Revenda, custos são alimentados principalmente por processos como:

~~~text
Compra
   ↓
Recebimento
   ↓
Entrada
   ↓
Atualização de custos
~~~

Produto Venda não substitui essas regras.

---

# 45. Custo de Fabricação Própria

No tipo Fabricação Própria, custos podem derivar do domínio de Produção:

~~~text
Ficha Técnica
   ↓
Ordem de Produção
   ↓
Custos previstos/reais
   ↓
Produto/SKU
~~~

A regra atual de Produção permanece autoridade.

---

# 46. Preço

Preço é um domínio relacionado ao Produto Venda.

Produto pode participar de múltiplas Tabelas de Preço.

Relacionamento conceitual:

~~~text
Produto
  ↓
Tabela de Preço
  ↓
Preço
~~~

Não existe obrigação de preço distinto por Loja.

---

# 47. Preço e SKU

No modelo funcional atual, preço comercial principal não é mantido como preço independente obrigatório para cada combinação Cor × Tamanho.

A gestão de preços permanece no domínio próprio de Preços.

---

# 48. Margem

Margem percentual é uma informação derivada/exibida.

Não é responsável pela identidade do Produto.

A consulta preserva:

**Margem %**

A margem monetária não é mais coluna principal na tabela de SKUs.

---

# 49. Dados Fiscais

Dados fiscais pertencem ao Produto.

Campos estruturais existentes incluem:

- NCM;
- origem da mercadoria;
- CST/CSOSN ICMS;
- alíquota ICMS;
- CFOP dentro do Estado;
- CFOP fora do Estado;
- CST PIS;
- alíquota PIS;
- CST COFINS;
- alíquota COFINS;
- situação IPI;
- alíquota IPI.

---

# 50. Mutabilidade Fiscal

Dados fiscais podem mudar ao longo do tempo.

Portanto:

> Dados fiscais não são imutáveis.

Alterações devem ser permitidas e rastreadas.

---

# 51. Histórico Fiscal

Mudanças fiscais relevantes produzem evento em:

`ProdutoVendaHistorico`

e rastreabilidade no:

`AuditLog`

A alteração do valor atual não elimina a informação de que houve mudança.

---

# 52. ProdutoVendaHistorico

Entidade:

`ProdutoVendaHistorico`

Representa eventos funcionais relevantes.

Relacionamento:

~~~text
Produto 1:N ProdutoVendaHistorico
~~~

Exemplos de eventos:

- alteração cadastral;
- alteração fiscal;
- ativação;
- inativação;
- bloqueio de venda;
- desbloqueio de venda.

---

# 53. AuditLog

AuditLog pertence à Auditoria Central do Sysvar.

Relacionamento lógico:

~~~text
Operação
   ↓
AuditService
   ↓
AuditLog
~~~

Pode registrar:

- usuário;
- ação;
- objeto;
- valores anteriores;
- valores posteriores;
- campos alterados;
- metadata.

---

# 54. Histórico Funcional versus Auditoria

Separação obrigatória:

~~~text
ProdutoVendaHistorico
=
visão funcional do ciclo do Produto
~~~

~~~text
AuditLog
=
rastreabilidade técnica e administrativa
~~~

Um não substitui o outro.

---

# 55. ProdutoImagem

Entidade:

`ProdutoImagem`

Relacionamento:

~~~text
Produto 1:N ProdutoImagem
~~~

A imagem pertence ao Produto principal.

---

# 56. Imagem não Pertence à Cor

Não existe neste escopo:

~~~text
Cor
  ↓
Imagem própria
~~~

As imagens representam o Produto como um todo.

---

# 57. Imagem não Pertence ao SKU

Também não existe:

~~~text
ProdutoDetalhe
  ↓
Imagem específica
~~~

A relação permanece no Produto.

---

# 58. Limite de Imagens

Cardinalidade funcional:

~~~text
Produto
  ↓
0..3 imagens
~~~

Imagem é opcional.

Máximo:

`3`

---

# 59. Imagem Principal

Entre as imagens existentes, no máximo uma é principal.

Conceitualmente:

~~~text
Produto
  ├── Imagem A — principal
  ├── Imagem B
  └── Imagem C
~~~

Não permitir duas imagens principais simultaneamente.

---

# 60. Imagem Reduzida

ProdutoImagem pode oferecer:

- imagem original;
- imagem reduzida.

A interface prioriza a reduzida quando existir.

Não existe ainda domínio fechado sobre:

- dimensões;
- formato;
- qualidade;
- compressão.

Esses parâmetros não devem ser inferidos.

---

# 61. Estado Ativo do Produto

Produto possui atributo:

`ativo`

Estados:

~~~text
Ativo
Inativo
~~~

Ativo/Inativo representa situação cadastral/operacional.

---

# 62. Inativação

Inativar preserva a entidade.

~~~text
Produto
  ↓
ativo = false
~~~

Preservar:

- Referência;
- SKUs;
- EANs;
- imagens;
- histórico;
- Estoque;
- movimentações anteriores.

---

# 63. Ativação

Produto Inativo pode voltar a Ativo.

~~~text
ativo = false
    ↓
Ativar
    ↓
ativo = true
~~~

Isso não cria novo Produto.

---

# 64. Bloqueio de Venda

Produto possui conceito independente:

`bloqueado_venda`

Estados possíveis incluem:

~~~text
Produto ativo
+
venda liberada
~~~

ou:

~~~text
Produto ativo
+
venda bloqueada
~~~

---

# 65. Ativo não é Venda Liberada

Não assumir:

~~~text
ativo = true
→ venda obrigatoriamente permitida
~~~

Também deve ser considerado:

`bloqueado_venda`

e demais regras do processo de Venda.

---

# 66. Bloqueio não é Inativação

Bloquear venda não deve modificar automaticamente:

`ativo`

São dimensões diferentes.

---

# 67. Exclusão

Exclusão é destruição física do cadastro.

É diferente de:

- Inativação;
- Bloqueio de venda.

---

# 68. Produto Nunca Utilizado

Produto sem utilização relevante pode ser excluído quando as regras de integridade permitirem.

Estruturas técnicas vazias, como Estoque zero criado apenas para inicialização, podem ser removidas com segurança conforme implementação.

---

# 69. Produto Utilizado

Produto que possui uso/movimentação relevante deve ser preservado.

Nesse cenário:

~~~text
Excluir
   ↓
Bloqueado
~~~

Alternativas:

- Inativar;
- Bloquear venda.

---

# 70. Permissão Funcional

Ações sensíveis utilizam o sistema funcional de permissões do Sysvar.

Conceito:

~~~text
Usuário
  ↓
EffectiveAccessService
  ↓
Módulo Produtos
  ↓
EDIT
~~~

O usuário não precisa ser `is_staff` do Django Admin apenas para operar o ERP.

---

# 71. Admin Funcional

Admin funcional autorizado é reconhecido pelas estruturas de:

- contrato;
- módulo;
- acesso efetivo;
- permissões funcionais.

Não pelo simples fato de ser administrador do Django.

---

# 72. Usuário sem EDIT

Usuário sem acesso `EDIT` em Produtos não pode executar ações sensíveis.

Resultado esperado:

`HTTP 403`

A segurança deve existir no backend.

---

# 73. Confirmação por Senha

Permissão funcional e confirmação por senha são conceitos independentes.

~~~text
Permissão
   ↓
Pode tentar executar a ação
   ↓
Senha
   ↓
Confirma identidade
~~~

Quando a ação exige senha, ambas as validações devem passar.

---

# 74. Motivo

Algumas ações também exigem Motivo.

Motivo representa justificativa operacional/auditável.

Exemplos:

- Inativação;
- Bloqueio de venda.

---

# 75. Consulta

Consulta não é uma nova entidade.

É uma visão consolidada do agregado.

Apresenta informações de:

- Produto;
- SKU;
- Dados fiscais;
- imagens;
- Estoque;
- histórico;
- Produção quando aplicável.

---

# 76. Revenda e Compras

Produto Revenda se relaciona com Compras.

Relacionamento conceitual:

~~~text
Produto Revenda
   ↓
Pedido de Compra
   ↓
Item
   ↓
Recebimento
   ↓
Estoque
~~~

Produto Venda não absorve o domínio de Compras.

---

# 77. Fabricação Própria e Produção

Produto Fabricação Própria se relaciona com Produção.

~~~text
Produto Fabricação Própria
   ↓
Ficha Técnica
   ↓
Ordem de Produção
   ↓
Produto produzido
   ↓
Estoque
~~~

Produto não é a Ordem de Produção.

---

# 78. Ficha Técnica

Ficha Técnica descreve a composição/processo produtivo.

Ela pertence ao domínio de Produção.

Produto Venda apenas se relaciona e apresenta suas informações quando necessário.

---

# 79. Ordem de Produção

Ordem de Produção representa execução produtiva.

Ela possui ciclo próprio.

Produto Venda não deve duplicar:

- Status de OP;
- custos da OP;
- consumo;
- apontamentos;
- encerramento.

---

# 80. Venda e PDV

Produto Venda fornece informações necessárias ao processo comercial.

Conceitualmente:

~~~text
Produto
   ↓
SKU
   ↓
EAN
   ↓
PDV
~~~

Mas o PDV permanece responsável pelas validações de Venda.

---

# 81. Condições Estruturais para Venda

Entre as condições que podem influenciar a Venda estão:

- Produto Ativo;
- Produto não bloqueado para venda;
- SKU Ativo;
- Estoque disponível;
- preço aplicável;
- regras fiscais;
- regras específicas do PDV.

A decisão final pertence ao processo de Venda.

---

# 82. Relação com Tabela de Preço

Produto pode possuir preços em diferentes tabelas.

Cardinalidade conceitual:

~~~text
Produto
   ↓
N preços / tabelas
~~~

Não criar tabela específica automaticamente para cada Loja.

---

# 83. Relação com Estoque

Um Produto possui vários SKUs.

Cada SKU pode possuir registros em várias Lojas.

~~~text
Produto
  ↓
SKU 1
  ├── Loja A
  └── Loja B

SKU 2
  ├── Loja A
  └── Loja B
~~~

Essa é a base da granularidade do Estoque.

---

# 84. Modelo Relacional Conceitual

~~~text
Empresa
  |
  | 1:N
  ↓
Produto
  |
  ├── N:1 Coleção
  ├── N:1 Grupo
  ├── N:1 Subgrupo
  ├── N:1 Unidade
  ├── N:1 Material
  ├── N:1 Grade
  |
  ├── 1:N ProdutoDetalhe
  |       |
  |       ├── N:1 Cor
  |       ├── N:1 Tamanho
  |       ├── 1 EAN
  |       └── 1:N Estoque
  |               └── N:1 Loja
  |
  ├── 1:N ProdutoImagem
  |
  ├── 1:N ProdutoVendaHistorico
  |
  ├── N relações de Preço
  |
  └── AuditLog
~~~

Para Fabricação Própria:

~~~text
Produto
  ├── Ficha Técnica
  └── Ordem de Produção
~~~

---

# 85. Agregado e Autoridade

Produto é raiz do agregado cadastral.

Porém não é autoridade sobre todos os domínios relacionados.

Autoridades principais:

~~~text
Produto
→ cadastro estrutural

ProdutoDetalhe
→ variação / SKU

Estoque
→ saldo e movimentação

Preço
→ valor comercial

Compras
→ aquisição

Produção
→ fabricação

Fiscal
→ emissão e regras fiscais operacionais

PDV
→ venda

Auditoria
→ rastreabilidade técnica
~~~

---

# 86. Dependências que Devem Permanecer Separadas

Não mover para Produto responsabilidades como:

- fechamento de Venda;
- emissão NFC-e;
- recebimento de Compra;
- baixa financeira;
- Ordem de Produção;
- cálculo completo de CMV;
- regras de comissão;
- distribuição;
- sincronização offline.

Produto é base cadastral para esses domínios.

---

# 87. Invariantes do Domínio

As seguintes invariantes devem permanecer verdadeiras:

1. Produto pertence a uma Empresa;
2. tipo 1 significa Revenda;
3. tipo 3 significa Fabricação Própria;
4. tipo não muda depois da criação;
5. Referência é gerada conforme regra oficial;
6. descrição reduzida é obrigatória;
7. Grupo é obrigatório;
8. Subgrupo é obrigatório;
9. Subgrupo deve ser coerente com Grupo;
10. Unidade é obrigatória;
11. Grade é obrigatória;
12. Grade é imutável após geração de SKU;
13. SKU representa Produto × Cor × Tamanho;
14. a mesma combinação não deve gerar SKU duplicado;
15. remover Cor inativa SKU;
16. reincluir Cor reativa SKU;
17. EAN é preservado;
18. Estoque é Loja × SKU;
19. Dados fiscais são editáveis;
20. alteração fiscal deve ser rastreada;
21. Produto Inativo não é excluído;
22. Bloqueado para venda não é Inativo;
23. Produto utilizado não deve ser apagado;
24. imagem pertence ao Produto;
25. máximo de 3 imagens;
26. no máximo uma imagem principal;
27. Histórico Funcional não substitui Auditoria Central;
28. segurança depende do backend;
29. tenant é validado no backend.

---

# 88. Eventos Relevantes do Domínio

Eventos funcionais importantes incluem:

~~~text
ProdutoCriado
ProdutoAlterado
DadosFiscaisAlterados
CorIncluida
CorRemovida
SkuCriado
SkuInativado
SkuReativado
ProdutoInativado
ProdutoAtivado
VendaBloqueada
VendaDesbloqueada
ImagemIncluida
ImagemRemovida
ImagemPrincipalAlterada
~~~

Nem todos precisam necessariamente existir como classes formais de Domain Event.

A lista representa eventos conceituais relevantes para evolução futura e rastreabilidade.

---

# 89. Transições de Estado do Produto

Situação cadastral:

~~~text
ATIVO
  ↓
INATIVO
  ↓
ATIVO
~~~

Venda:

~~~text
LIBERADA
   ↓
BLOQUEADA
   ↓
LIBERADA
~~~

Os dois ciclos são independentes.

---

# 90. Transições de Estado do SKU

~~~text
ATIVO
  ↓
Cor retirada
  ↓
INATIVO
  ↓
Cor reincluída
  ↓
ATIVO
~~~

O SKU não muda de identidade durante o ciclo.

---

# 91. Homologação do Domínio

Foram homologados manualmente:

- cadastro e obrigatoriedades;
- tipo imutável;
- Grade imutável;
- descrição reduzida;
- Grupo/Subgrupo;
- remoção de Cor;
- remoção da última Cor;
- reativação;
- preservação de EAN;
- exclusão segura;
- bloqueio de exclusão de Produto utilizado;
- histórico cadastral;
- fiscal;
- imagens;
- Estoque Loja × SKU;
- consulta de Fabricação Própria;
- filtros;
- Inativar/Ativar;
- Bloquear/Desbloquear;
- paginação.

Resultado:

**19/19 itens aprovados**

---

# 92. Commits de Referência

Backend final homologado:

`574f5badc79ab3a969bf24ffc67904215bdbc49a`

Frontend final homologado:

`1be513e4a5d7b3220ae239fee555594307115826`

Esses commits representam o fechamento da homologação atual de Produto Venda.

---

# 93. Pontos Deliberadamente Fora do Domínio desta Fase

Não pertencem ao fechamento atual:

- Produto Uso e Consumo;
- motor completo de preços;
- promoções;
- PDV offline;
- emissão NFC-e;
- contingência fiscal;
- cálculo completo de CMV;
- regras avançadas de reserva;
- Distribuição;
- facção;
- planejamento comercial;
- comissão;
- parâmetros definitivos de geração de imagem reduzida.

Esses assuntos devem ser tratados em seus domínios específicos.

---

# 94. Evolução Futura

Qualquer evolução futura deve preservar as invariantes homologadas.

Novas funcionalidades podem utilizar Produto Venda como base, por exemplo:

- Distribuição;
- Vendas;
- PDV;
- Estoque;
- Compras;
- Produção;
- Fiscal;
- BI;
- Planejamento;
- integração omnichannel.

Esses módulos não devem criar uma segunda identidade concorrente para Produto ou SKU.

---

# 95. Estado Atual

O Modelo de Domínio de Produto Venda encontra-se:

**IMPLEMENTADO E HOMOLOGADO**

Abrangência:

~~~text
Produto Venda
    ├── Revenda
    └── Fabricação Própria
~~~

Estruturas centrais:

~~~text
Produto
ProdutoDetalhe
ProdutoImagem
ProdutoVendaHistorico
Estoque por Loja × SKU
Dados Fiscais
Preços relacionados
Auditoria Central
~~~

Homologação:

**19/19 itens aprovados**

As regras descritas neste documento formam a base de domínio aprovada para a continuidade do desenvolvimento do Sysvar.