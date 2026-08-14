## 1. Identificação

**Projeto:** [[Sysvar]]  
**Módulo:** Produtos  
**Escopo:** Cadastros Auxiliares de Produtos  
**Situação:** HOMOLOGADO  
**Regras funcionais consolidadas:** 28  
**Data de consolidação documental:** 14/08/2026

### Documentos relacionados

- [[Sysvar]]
- [[Mapa Técnico - Produtos - Cadastros Auxiliares]]
- [[Workflows - Produtos - Cadastros Auxiliares]]
- [[Modelo de Domínio - Produtos - Cadastros Auxiliares]]
- [[Riscos e Cuidados - Produtos - Cadastros Auxiliares]]
- [[Homologação - Produtos - Produto Venda]]
- [[Homologação - Produtos - Produto Uso e Consumo]]
- [[Homologação - Produtos - Insumos]]

---

## 2. Objetivo

Os **Cadastros Auxiliares de Produtos** fornecem estruturas de apoio utilizadas pelos diferentes tipos de Produto do [[Sysvar]].

O escopo homologado contempla:

1. Grupos e Subgrupos;
2. Grades e Tamanhos;
3. Coleções;
4. Packs e Itens;
5. Unidades;
6. Cores;
7. Material.

Esses cadastros não representam Produtos propriamente ditos.

Eles fornecem classificações, estruturas e parâmetros utilizados pelos cadastros principais e pelos processos que dependem desses Produtos.

---

## 3. Princípio geral

Os Cadastros Auxiliares devem permanecer simples.

A regra estrutural é:

~~~text
Cadastro Auxiliar
        ↓
Define estrutura de apoio
        ↓
Produto utiliza quando aplicável
        ↓
Processos operacionais utilizam o Produto
~~~

Não adicionar aos Cadastros Auxiliares responsabilidades pertencentes a:

- Compras;
- Estoque;
- Produção;
- Fiscal;
- Vendas;
- PDV;
- Distribuição.

---

# 4. Grupos e Subgrupos

## 4.1 Grupo

Grupo representa uma classificação principal utilizada por Produto Venda.

Os campos funcionais consolidados são:

- Código;
- Descrição;
- Código de Referência;
- Margem.

---

## 4.2 Código do Grupo

O Código identifica o Grupo.

Deve possuir unicidade no contexto empresarial aplicável.

Não devem existir dois Grupos com o mesmo Código dentro da mesma Empresa.

---

## 4.3 Código de Referência

O campo **Código de Referência** é obrigatório.

Formato homologado:

~~~text
2 dígitos numéricos
~~~

Exemplos válidos:

~~~text
01
02
15
99
~~~

Exemplos inválidos:

~~~text
1
001
AB
A1
~~~

---

## 4.4 Unicidade do Código de Referência

O Código de Referência deve ser único por Empresa.

Ele participa da composição da Referência automática de Produto Venda.

~~~text
AA-BB-CCDDD
      ↑
      CC = Código de Referência do Grupo
~~~

A regra completa da Referência está documentada em:

[[Homologação - Produtos - Produto Venda]]

---

## 4.5 Margem do Grupo

Grupo pode possuir Margem.

A Margem funciona como parâmetro cadastral.

Não deve ser confundida automaticamente com:

- preço de venda;
- promoção;
- margem final obrigatória;
- formação definitiva de preço.

---

## 4.6 Subgrupo

Subgrupo pertence a um Grupo.

Relacionamento:

~~~text
Grupo
   ↓
Subgrupos
~~~

Não existe Subgrupo independente do Grupo pai.

---

## 4.7 Dados do Subgrupo

O Subgrupo possui:

- Grupo;
- Descrição;
- Margem.

Sua identidade funcional permanece subordinada ao Grupo.

---

## 4.8 Interface de Grupos

A tela principal de Grupos utiliza o padrão homologado:

- seleção única por checkbox;
- linha selecionada destacada;
- barra de ações acima dos resultados;
- ausência de coluna `Ações`;
- ausência de menu `⋮` por linha.

A barra de ações contém:

~~~text
Consultar | Editar | Subgrupos | Excluir
~~~

---

## 4.9 Sobretela de Subgrupos

Ao selecionar **Subgrupos**, a manutenção é realizada em sobretela/modal.

Dentro da sobretela:

- seleção única;
- linha selecionada destacada;
- barra própria de ações;
- ausência de menu `⋮`;
- ausência de coluna `Ações`.

A barra do detalhe contém:

~~~text
Consultar | Editar | Excluir
~~~

Não deve repetir a ação:

~~~text
Subgrupos
~~~

---

# 5. Grades e Tamanhos

## 5.1 Grade

Grade representa uma estrutura de Tamanhos.

Exemplo:

~~~text
Grade Feminina

PP
P
M
G
GG
~~~

Outro exemplo:

~~~text
Grade Calçados

34
35
36
37
38
39
40
~~~

---

## 5.2 Grade e Produto Venda

Grade é utilizada principalmente por Produto Venda.

~~~text
Produto Venda
        ↓
Grade
        ↓
Tamanhos
        ↓
Cor × Tamanho
        ↓
SKU
~~~

---

## 5.3 Tamanho

Tamanho pertence a uma Grade.

~~~text
Grade
   ↓
Tamanhos
~~~

O Tamanho não deve ser mantido como detalhe independente da Grade correspondente.

---

## 5.4 Ativo e Inativo

As estruturas que possuem controle de situação utilizam:

~~~text
ATIVO
  ↕
INATIVO
~~~

Quando uma estrutura já tiver sido utilizada, a inativação deve ser preferida à exclusão destrutiva.

---

## 5.5 Exclusão protegida da Grade

Grade utilizada por Produtos não deve ser excluída de maneira que comprometa registros existentes.

Antes da exclusão, o backend deve verificar dependências.

Quando houver utilização:

~~~text
INATIVAR
~~~

é a alternativa adequada.

---

## 5.6 Interface de Grade

A tela principal de Grade utiliza:

- checkbox;
- seleção única;
- destaque da linha;
- barra superior de ações;
- ausência de coluna `Ações`;
- ausência de menu `⋮`.

A barra principal contém:

~~~text
Consultar | Editar | Tamanhos | Excluir
~~~

---

## 5.7 Sobretela de Tamanhos

A ação **Tamanhos** abre sobretela/modal.

Dentro dela, a barra de ações contém:

~~~text
Consultar | Editar | Excluir
~~~

A sobretela também utiliza:

- seleção única;
- checkbox;
- destaque da linha;
- ausência de menu por linha;
- ausência de coluna `Ações`.

---

# 6. Coleções

## 6.1 Coleção

Coleção organiza Produtos Venda por período e Estação.

Campos principais:

- Código;
- Estação;
- Descrição;
- Status.

---

## 6.2 Código da Coleção

O Código representa os dois dígitos do ano.

Exemplo:

~~~text
26
~~~

para o ano de 2026.

Formato:

~~~text
2 dígitos
~~~

---

## 6.3 Estação

Valores homologados:

~~~text
01 = Verão
02 = Outono
03 = Inverno
04 = Primavera
~~~

A combinação relevante é:

~~~text
Código + Estação
~~~

---

## 6.4 Status da Coleção

Status homologados:

~~~text
CR = Criação
PD = Planejamento/Desenvolvimento
AT = Ativa
EN = Encerrada
AR = Arquivada
~~~

---

## 6.5 Contador

Existe conceito interno de contador utilizado na geração de Referência.

O contador é interno.

Não deve ser apresentado como campo normal de manutenção manual pelo usuário.

---

## 6.6 Coleção e Referência de Produto Venda

Coleção participa da geração da Referência:

~~~text
AA-BB-CCDDD
~~~

Onde:

~~~text
AA = Código/Ano
BB = Estação
CC = Código de Referência do Grupo
DDD = Sequência
~~~

A regra completa pertence ao Produto Venda.

---

## 6.7 Interface de Coleções

Coleções seguem o padrão homologado:

- seleção única;
- checkbox;
- linha selecionada destacada;
- barra de ações;
- ausência de coluna `Ações`;
- ausência de menu `⋮`.

---

# 7. Unidades

## 7.1 Unidade

Unidade representa a forma de quantificação do item.

Campos principais:

- Código;
- Descrição;
- Permite Decimal.

Exemplos:

~~~text
UN
PC
CX
M
KG
LT
~~~

---

## 7.2 Código da Unidade

O Código deve ser único no contexto aplicável.

Exemplos:

~~~text
UN
KG
M
CX
~~~

O Código é a representação compacta da Unidade.

---

## 7.3 Permite Decimal

O campo:

~~~text
permite_decimal
~~~

define se quantidades fracionadas são aceitas.

Exemplo:

~~~text
M
permite_decimal = Sim

Quantidade:
1,75 M
~~~

Outro exemplo:

~~~text
UN
permite_decimal = Não

Quantidade:
6 UN
~~~

---

## 7.4 Uso da Unidade

Unidade pode ser utilizada por:

- Produto Venda;
- Produto Uso/Consumo;
- Insumos;
- Compras;
- Estoque;
- Ficha Técnica;
- demais processos que utilizam quantidade.

Cada processo deve respeitar `permite_decimal`.

---

# 8. Cores

## 8.1 Cor

Cor representa uma opção cromática utilizada principalmente pelos Produtos Venda.

O cadastro permanece conforme a estrutura homologada do sistema.

---

## 8.2 Código da Cor

Quando utilizado, o Código da Cor deve ser único no contexto aplicável.

Não devem existir códigos duplicados que tornem ambígua a identificação.

---

## 8.3 Cor e Produto Venda

Cor participa da formação das variações comerciais.

~~~text
Produto
+
Cor
+
Tamanho
=
SKU
~~~

Referência:

[[Homologação - Produtos - Produto Venda]]

---

## 8.4 Estado da homologação de Cores

O cadastro de Cores foi validado funcionalmente e visualmente.

Não há pendência registrada nesta fase.

---

# 9. Material

## 9.1 Material

Material é um cadastro classificatório.

Campos principais homologados:

- Código;
- Descrição;
- Ativo/Inativo.

---

## 9.2 Código do Material

O Código identifica o Material.

Deve manter unicidade no contexto empresarial aplicável.

---

## 9.3 Situação do Material

Material utiliza lifecycle simples:

~~~text
ATIVO
  ↕
INATIVO
~~~

Material utilizado não deve ser removido de maneira destrutiva sem análise das dependências.

---

## 9.4 Material e Insumo

Material é opcional no cadastro de Insumos.

Exemplo:

~~~text
Material:
Algodão

Insumo:
Tecido Tricoline Branco
~~~

Referência:

[[Homologação - Produtos - Insumos]]

---

## 9.5 Material não é Insumo

Material representa classificação.

Insumo representa o item operacional.

Não utilizar Material diretamente como entidade de:

- Compra;
- Estoque;
- Ficha Técnica;
- consumo produtivo.

Esses processos devem utilizar o Insumo.

---

# 10. Packs e Itens

## 10.1 Pack

Pack representa uma composição de quantidades por Tamanho.

É utilizado no contexto de Produto Venda.

Exemplo:

~~~text
Pack Grade Feminina

PP = 1
P  = 2
M  = 3
G  = 2
GG = 1
~~~

---

## 10.2 Pack vinculado à Grade

Todo Pack deve estar relacionado a uma Grade.

~~~text
Grade
   ↓
Pack
   ↓
Itens
   ↓
Tamanhos da Grade
~~~

Isso garante que os Tamanhos pertencem à estrutura adequada.

---

## 10.3 Nome do Pack

Nome é obrigatório.

Exemplos:

~~~text
Pack Básico
Pack Loja Pequena
Pack 1-2-3-2-1
~~~

---

## 10.4 Situação do Pack

Pack possui:

~~~text
ATIVO
INATIVO
~~~

Pack inativo não deve ser utilizado normalmente em novas operações.

---

## 10.5 Item do Pack

Cada Item relaciona:

- Pack;
- Tamanho;
- Quantidade.

---

## 10.6 Tamanho duplicado

O mesmo Tamanho não pode aparecer duas vezes dentro do mesmo Pack.

Inválido:

~~~text
P = 2
M = 3
M = 1
G = 2
~~~

Correto:

~~~text
P = 2
M = 4
G = 2
~~~

---

## 10.7 Quantidade do Item

Quantidade deve ser maior que zero.

Inválido:

~~~text
M = 0
M = -1
~~~

A quantidade representa o número de peças daquele Tamanho no Pack.

---

## 10.8 Pack em Pedido de Compra

Pack participa da lógica de Produto Venda.

~~~text
Número de Packs
×
Soma das quantidades do Pack
=
Quantidade de Peças
~~~

Exemplo:

~~~text
Pack:

P = 2
M = 3
G = 2

Total do Pack = 7

10 Packs × 7 = 70 peças
~~~

---

## 10.9 Interface de Pack

A estrutura utiliza padrão master-detail.

Na tela principal:

- seleção única;
- destaque da linha;
- barra de ações;
- ausência de menu por linha quando aplicável.

Itens do Pack são tratados na área de detalhe correspondente.

A homologação funcional e visual desse fluxo foi concluída.

---

# 11. Padrões Gerais

## 11.1 Multiempresa

Os Cadastros Auxiliares devem respeitar isolamento multiempresa quando sua estrutura for empresarial.

O backend deve impedir:

~~~text
Empresa A
        ↓
utilizar cadastro privado
da Empresa B
~~~

Não confiar somente nos filtros apresentados pelo frontend.

---

## 11.2 Paginação

As listagens devem utilizar paginação server-side conforme o padrão vigente.

Não carregar toda a base apenas para paginar localmente.

---

## 11.3 Filtros

Filtros devem ser processados de forma consistente com o backend.

Podem considerar, conforme o cadastro:

- Código;
- Descrição;
- Status;
- relacionamentos específicos.

---

# 12. Padrão Visual Homologado

## 12.1 Seleção

O padrão visual consolidado para os auxiliares modernizados é:

~~~text
Checkbox
+
Seleção única
+
Linha selecionada destacada
+
Barra de ações
~~~

---

## 12.2 Ausência de menu por linha

Nas telas que adotaram esse padrão, as ações principais não devem depender de:

~~~text
⋮
~~~

Também não deve existir uma coluna genérica:

~~~text
Ações
~~~

quando a tela já possui barra de ações.

---

## 12.3 Barra de ações

A barra deve apresentar somente as ações aplicáveis à tela.

Exemplo básico:

~~~text
Consultar | Editar | Excluir
~~~

Telas master-detail acrescentam a ação específica correspondente.

Exemplos:

~~~text
Subgrupos
Tamanhos
Itens
~~~

---

## 12.4 Consultar

A ação **Consultar** apresenta o registro em modo somente leitura.

No padrão atual, a consulta deve utilizar uma sobretela/modal sobre a tela de origem quando aplicável.

O usuário não deve ser obrigado a abandonar desnecessariamente o contexto da listagem para consultar um registro.

---

## 12.5 Editar

A ação **Editar** carrega o registro selecionado e permite somente alterações autorizadas.

Devem ser preservados:

- identidade;
- Empresa;
- relacionamentos protegidos;
- integridade histórica.

---

## 12.6 Excluir

Excluir é uma ação protegida.

Antes da remoção física, o backend deve verificar dependências.

Quando o registro já estiver utilizado, não deve ocorrer exclusão destrutiva.

---

# 13. Exclusão Protegida

Exemplos de dependências:

- Grupo utilizado por Produto;
- Subgrupo utilizado;
- Grade utilizada;
- Tamanho utilizado;
- Coleção utilizada;
- Unidade utilizada;
- Cor utilizada;
- Material utilizado;
- Pack utilizado em Pedido.

A integridade histórica possui prioridade sobre a simples remoção visual do cadastro.

---

# 14. Histórico Individual

Não foi homologada uma estrutura sofisticada de Histórico individual para cada Cadastro Auxiliar.

A decisão é manter esses cadastros simples.

Não criar subsistemas paralelos de Histórico sem necessidade funcional aprovada.

---

# 15. Auditoria

Ações relevantes devem utilizar a infraestrutura geral de Auditoria do [[Sysvar]] quando aplicável.

Isso permite rastreabilidade sem transformar cada Cadastro Auxiliar em um módulo independente e complexo.

---

# 16. Permissões

As ações devem respeitar as permissões funcionais existentes.

Entre elas:

- consultar;
- criar;
- editar;
- excluir;
- ativar;
- inativar,

conforme o cadastro.

O frontend controla a experiência e disponibilidade visual.

O backend permanece autoridade de segurança.

---

# 17. Ativo e Inativo

Cadastros que possuem lifecycle utilizam:

~~~text
ATIVO
INATIVO
~~~

A inativação preserva o registro histórico sem permitir seu uso normal em novas operações.

---

# 18. Alterações em Estruturas já Utilizadas

Alguns Cadastros Auxiliares possuem impacto estrutural importante.

Exemplos:

- alterar Grade já utilizada por Produtos;
- alterar Unidade de Insumo já movimentado;
- alterar Código de Referência do Grupo;
- alterar Coleção relacionada à Referência;
- alterar Item de Pack já utilizado em Pedido.

Essas alterações precisam respeitar as dependências existentes.

---

# 19. Relação com Produto Venda

Produto Venda utiliza principalmente:

- Grupo;
- Subgrupo;
- Grade;
- Tamanho;
- Coleção;
- Unidade;
- Cor;
- Material quando aplicável;
- Pack.

Referência:

[[Homologação - Produtos - Produto Venda]]

---

# 20. Relação com Produto Uso/Consumo

Produto Uso/Consumo utiliza somente os auxiliares que pertencem ao seu domínio.

Principalmente:

- Unidade;
- estruturas fiscais relacionadas.

Não deve herdar obrigatoriamente:

- Grade;
- Tamanho;
- Cor comercial;
- Coleção;
- Pack.

Referência:

[[Homologação - Produtos - Produto Uso e Consumo]]

---

# 21. Relação com Insumos

Insumos utilizam principalmente:

- Unidade;
- Material opcional;
- estruturas fiscais relacionadas.

Não devem utilizar automaticamente:

- Grade comercial;
- Coleção;
- Pack comercial;
- Cor × Tamanho comercial.

Referência:

[[Homologação - Produtos - Insumos]]

---

# 22. Regras Funcionais Consolidadas

As 28 decisões homologadas são:

1. Grupo possui Código, Descrição, Código de Referência e Margem.
2. Código de Referência do Grupo é obrigatório, numérico, com exatamente 2 dígitos e único por Empresa.
3. Código do Grupo deve ser único no contexto aplicável.
4. Subgrupo pertence ao Grupo.
5. Subgrupo possui Descrição, Grupo e Margem.
6. Grade possui Tamanhos como detalhe.
7. Estruturas aplicáveis utilizam Ativo/Inativo.
8. Exclusão de registros utilizados deve ser protegida.
9. Coleção possui Código, Estação, Descrição e Status.
10. Status de Coleção utiliza CR, PD, AT, EN e AR.
11. Contador da Coleção é interno e não deve ser mantido manualmente.
12. Unidade possui Descrição, Código e `permite_decimal`.
13. Código de Unidade deve ser único.
14. Cores permanecem conforme a estrutura homologada.
15. Código da Cor, quando utilizado, deve ser único.
16. Material possui Código, Descrição e Ativo/Inativo.
17. Pack pertence a uma Grade.
18. Nome do Pack é obrigatório.
19. Pack utiliza Ativo/Inativo.
20. Não pode haver Tamanho duplicado dentro do Pack.
21. Quantidade de cada Item do Pack deve ser maior que zero.
22. Multiempresa deve ser estrito.
23. Paginação e filtros devem utilizar backend/server-side.
24. Visual deve seguir o padrão SYSVAR.
25. Consultar, Editar e Excluir devem respeitar permissões.
26. Exclusão de cadastro utilizado deve ser protegida.
27. Não criar Histórico individual sofisticado desnecessariamente.
28. Não expandir os Cadastros Auxiliares para responsabilidades operacionais de outros módulos.

---

# 23. Regras Visuais Consolidadas

Durante a homologação foi consolidado o padrão:

~~~text
Seleção de linha
+
Checkbox
+
Linha destacada
+
Barra de ações
~~~

Substituindo, nas telas adequadas:

~~~text
Coluna Ações
+
Menu ⋮
~~~

Esse padrão foi aplicado às estruturas correspondentes de:

- Grupos/Subgrupos;
- Grades/Tamanhos;
- Coleções;
- Pack/Itens;
- demais telas ajustadas durante a padronização de Produtos.

---

# 24. Telas Correlatas

Durante a mesma rodada de padronização visual de Produtos também foram ajustadas funcionalidades correlatas como:

- Tabela de Preço;
- Promoções.

Essas funcionalidades não fazem parte dos sete Cadastros Auxiliares definidos neste documento.

Entretanto, compartilham o mesmo princípio visual de:

- seleção;
- barra de ações;
- consulta em sobretela quando aplicável;
- eliminação de ações redundantes por linha.

---

# 25. Escopo que Não Pertence aos Auxiliares

Não implementar diretamente nesses cadastros:

- saldo de Estoque;
- entrada de mercadoria;
- Pedido de Compra;
- custo operacional real;
- venda;
- emissão fiscal;
- Ordem de Produção;
- Distribuição;
- consumo de Insumos;
- movimentação de Estoque.

Os Cadastros Auxiliares apenas fornecem estruturas utilizadas pelos Produtos e pelos processos.

---

# 26. Estado da Homologação

Foram homologados funcionalmente e visualmente:

- Cores;
- Material;
- Grupos/Subgrupos;
- Coleções;
- Grades/Tamanhos;
- Packs/Itens.

As correções identificadas durante a rodada de homologação foram concluídas.

Unidades permanecem dentro da estrutura funcional consolidada dos Cadastros Auxiliares.

---

# 27. Baseline Documental

Este documento representa a baseline funcional dos Cadastros Auxiliares de Produtos.

Alterações futuras devem consultar também:

- [[Mapa Técnico - Produtos - Cadastros Auxiliares]]
- [[Workflows - Produtos - Cadastros Auxiliares]]
- [[Modelo de Domínio - Produtos - Cadastros Auxiliares]]
- [[Riscos e Cuidados - Produtos - Cadastros Auxiliares]]

---

# 28. Estado Final

**Cadastros Auxiliares de Produtos estão HOMOLOGADOS.**

A regra central é:

~~~text
CADASTROS AUXILIARES
definem estruturas de apoio.

PRODUTOS
utilizam essas estruturas.

MÓDULOS OPERACIONAIS
utilizam os Produtos.

Não transformar
Cadastro Auxiliar
em Processo Operacional.
~~~

---

# 29. Navegação Documental

## Cadastros Auxiliares

- [[Mapa Técnico - Produtos - Cadastros Auxiliares]]
- [[Workflows - Produtos - Cadastros Auxiliares]]
- [[Modelo de Domínio - Produtos - Cadastros Auxiliares]]
- [[Riscos e Cuidados - Produtos - Cadastros Auxiliares]]

## Produtos

- [[Homologação - Produtos - Produto Venda]]
- [[Homologação - Produtos - Produto Uso e Consumo]]
- [[Homologação - Produtos - Insumos]]

## Projeto

- [[Sysvar]]