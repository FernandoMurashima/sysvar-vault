---
type: technical-map
status: approved
project: Sysvar
group: Produtos
module: Cadastros Auxiliares
phase: Fase 1
created: 2026-08-14
updated: 2026-08-14
tags:
  - sysvar
  - produtos
  - cadastros-auxiliares
  - grupos
  - subgrupos
  - grades
  - tamanhos
  - coleções
  - packs
  - unidades
  - cores
  - material
  - multiempresa
  - homologado
---

# Mapa Técnico - Produtos - Cadastros Auxiliares

## 1. Identificação

- **Projeto:** [[Sysvar]]
- **Módulo:** Produtos
- **Escopo:** Cadastros Auxiliares de Produtos
- **Situação:** IMPLEMENTADO E HOMOLOGADO
- **Regras funcionais consolidadas:** 28
- **Data de consolidação documental:** 14/08/2026

### Documentos relacionados

- [[Sysvar]]
- [[Homologação - Produtos - Cadastros Auxiliares]]
- [[Workflows - Produtos - Cadastros Auxiliares]]
- [[Modelo de Domínio - Produtos - Cadastros Auxiliares]]
- [[Riscos e Cuidados - Produtos - Cadastros Auxiliares]]
- [[Homologação - Produtos - Produto Venda]]
- [[Homologação - Produtos - Produto Uso e Consumo]]
- [[Homologação - Produtos - Insumos]]

---

# 2. Objetivo Técnico

Os Cadastros Auxiliares de Produtos fornecem estruturas reutilizadas pelos cadastros principais do módulo Produtos.

O conjunto homologado contempla:

1. Grupos;
2. Subgrupos;
3. Grades;
4. Tamanhos;
5. Coleções;
6. Packs;
7. Itens de Pack;
8. Unidades;
9. Cores;
10. Material.

Essas entidades devem permanecer simples e com responsabilidade cadastral.

Fluxo conceitual:

~~~text
Cadastros Auxiliares
        ↓
Produtos
        ↓
Módulos Operacionais
~~~

Não transformar essas entidades em substitutas de:

- Estoque;
- Compras;
- Produção;
- Vendas;
- Fiscal;
- Distribuição.

---

# 3. Backend

Os Cadastros Auxiliares pertencem principalmente ao app Django:

`produto`

Arquivos centrais envolvidos conforme a estrutura vigente:

- `produto/models.py`
- `produto/serializers.py`
- `produto/views.py`
- `produto/urls.py`
- `produto/permissions.py`
- `produto/tests.py`

O backend é responsável por:

- persistência;
- validações;
- unicidade;
- relacionamentos;
- isolamento multiempresa;
- exclusão protegida;
- filtros;
- paginação;
- controle de situação;
- proteção contra associações inválidas.

---

# 4. Frontend

Os cadastros possuem telas próprias ou estruturas master-detail dentro do módulo Produtos.

O frontend é responsável por:

- listagem;
- filtros;
- paginação;
- seleção de registros;
- barra de ações;
- criação;
- consulta;
- edição;
- exclusão;
- abertura de detalhes;
- modais e sobretelas.

O backend continua sendo a autoridade das regras.

---

# 5. Princípio de Responsabilidade

Cada Cadastro Auxiliar deve responder apenas pelas informações que realmente representa.

Exemplo:

~~~text
Grupo
→ classificação

Grade
→ conjunto de Tamanhos

Pack
→ composição de quantidades por Tamanho

Unidade
→ forma de quantificação

Cor
→ identificação cromática

Material
→ classificação material
~~~

Não adicionar comportamento operacional apenas porque outra funcionalidade utiliza o cadastro.

---

# 6. Grupo

Grupo é uma classificação principal de Produto.

Campos homologados:

- Código;
- Descrição;
- Código de Referência;
- Margem.

Relacionamentos conceituais:

~~~text
Empresa
   ↓
Grupo
   ↓
Subgrupos
~~~

Produto Venda pode utilizar Grupo.

---

# 7. Código do Grupo

O Código do Grupo deve possuir unicidade no contexto empresarial aplicável.

O backend deve impedir duplicidade indevida.

---

# 8. Código de Referência do Grupo

Campo obrigatório.

Formato:

~~~text
2 dígitos numéricos
~~~

Exemplos:

~~~text
01
02
15
99
~~~

Deve ser único por Empresa.

---

# 9. Código de Referência e Produto Venda

O Código de Referência participa da Referência automática de Produto Venda.

~~~text
AA-BB-CCDDD
      ↑
      CC
~~~

A geração completa pertence ao domínio de Produto Venda:

[[Mapa Técnico - Produtos - Produto Venda]]

---

# 10. Margem do Grupo

Margem é parâmetro cadastral.

Não deve ser tratada automaticamente como preço final.

Separação:

~~~text
Margem do Grupo
!=
Preço de Venda
~~~

---

# 11. Subgrupo

Subgrupo é entidade dependente de Grupo.

Relacionamento:

~~~text
Grupo 1:N Subgrupo
~~~

Campos homologados:

- Grupo;
- Descrição;
- Margem.

---

# 12. Proteção do Subgrupo

O backend deve garantir que o Subgrupo permaneça ligado ao Grupo correto.

Não deve aceitar associações cross-tenant.

---

# 13. Tela de Grupos

A interface homologada utiliza:

- seleção única;
- checkbox;
- destaque da linha;
- barra de ações;
- ausência de coluna `Ações`;
- ausência de menu `⋮`.

Barra principal:

~~~text
Consultar | Editar | Subgrupos | Excluir
~~~

---

# 14. Sobretela de Subgrupos

A ação `Subgrupos` abre detalhe em modal/sobretela.

Ações internas:

~~~text
Consultar | Editar | Excluir
~~~

Não repetir:

~~~text
Subgrupos
~~~

dentro do próprio detalhe.

---

# 15. Grade

Grade representa um conjunto de Tamanhos.

Relacionamento:

~~~text
Grade
   ↓
Tamanhos
~~~

Exemplo:

~~~text
Grade Feminina
PP
P
M
G
GG
~~~

---

# 16. Tamanho

Tamanho pertence a uma Grade.

Relacionamento:

~~~text
Grade 1:N Tamanho
~~~

Não deve existir detalhe de Tamanho desconectado da Grade correspondente.

---

# 17. Grade e Produto Venda

Produto Venda utiliza Grade para definir as variações comerciais válidas.

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

# 18. Tela de Grade

Padrão homologado:

- checkbox;
- seleção única;
- linha destacada;
- barra de ações;
- sem coluna `Ações`;
- sem menu `⋮`.

Ações:

~~~text
Consultar | Editar | Tamanhos | Excluir
~~~

---

# 19. Sobretela de Tamanhos

A ação `Tamanhos` abre modal/sobretela.

Ações internas:

~~~text
Consultar | Editar | Excluir
~~~

O detalhe também utiliza seleção por linha.

---

# 20. Exclusão de Grade

Antes de excluir Grade, o backend deve verificar dependências.

Exemplos de dependência:

- Produto;
- SKU;
- Pack;
- outros relacionamentos existentes.

Quando já utilizada, preservar estrutura histórica.

---

# 21. Coleção

Coleção organiza Produto Venda por ano e Estação.

Campos homologados:

- Código;
- Estação;
- Descrição;
- Status.

---

# 22. Código da Coleção

Formato:

~~~text
2 dígitos
~~~

Exemplo:

~~~text
26
~~~

representando 2026.

---

# 23. Estação

Valores definidos:

~~~text
01 = Verão
02 = Outono
03 = Inverno
04 = Primavera
~~~

---

# 24. Chave Lógica da Coleção

A combinação relevante é:

~~~text
Código + Estação
~~~

Exemplo:

~~~text
26 + 01
26 + 02
26 + 03
26 + 04
~~~

---

# 25. Status da Coleção

Valores homologados:

~~~text
CR
PD
AT
EN
AR
~~~

Correspondendo aos estados funcionais definidos para Coleção.

---

# 26. Contador Interno da Coleção

Existe contador utilizado pela geração de Referência.

Esse contador:

- é interno;
- não deve ser editado manualmente;
- não deve ser tratado como informação normal da interface.

---

# 27. Coleção e Referência

Coleção participa da composição:

~~~text
AA-BB-CCDDD
~~~

Onde:

~~~text
AA = Código da Coleção
BB = Estação
CC = Código de Referência do Grupo
DDD = sequência
~~~

---

# 28. Tela de Coleções

Padrão homologado:

- seleção única;
- checkbox;
- linha destacada;
- barra de ações;
- sem coluna `Ações`;
- sem menu `⋮`.

---

# 29. Unidade

Unidade define como um item é quantificado.

Campos:

- Código;
- Descrição;
- `permite_decimal`.

Exemplos:

~~~text
UN
M
KG
LT
CX
PC
~~~

---

# 30. Código da Unidade

Deve possuir unicidade no contexto aplicável.

O Código funciona como representação compacta da Unidade.

---

# 31. Permite Decimal

Campo:

~~~text
permite_decimal
~~~

Define se quantidades fracionárias são aceitas.

Exemplo:

~~~text
M
permite_decimal = true
1,75 M
~~~

Exemplo:

~~~text
UN
permite_decimal = false
6 UN
~~~

---

# 32. Uso de Unidade

A Unidade pode ser consumida por:

- Produto Venda;
- Produto Uso/Consumo;
- Insumos;
- Compras;
- Estoque;
- Ficha Técnica;
- outros módulos com quantidades.

Cada consumidor deve respeitar as regras da Unidade.

---

# 33. Cor

Cor representa característica cromática utilizada principalmente por Produto Venda.

O cadastro segue a estrutura vigente e homologada.

---

# 34. Código da Cor

Quando existente, deve possuir unicidade no contexto aplicável.

Não permitir ambiguidade por código duplicado.

---

# 35. Cor e SKU

Produto Venda utiliza Cor em conjunto com Tamanho.

~~~text
Produto
+
Cor
+
Tamanho
=
SKU
~~~

O Cadastro de Cor não gera SKU sozinho.

---

# 36. Material

Material é uma entidade classificatória.

Campos homologados:

- Código;
- Descrição;
- Ativo/Inativo.

---

# 37. Material e Insumo

Material pode ser associado opcionalmente ao Insumo.

~~~text
Material
        ↓
Insumos
~~~

Exemplo:

~~~text
Material:
Algodão

Insumo:
Tecido Tricoline Branco
~~~

---

# 38. Material não é Item Operacional

Material não deve substituir Insumo em:

- Pedido de Compra;
- Estoque;
- Ficha Técnica;
- Produção.

Esses processos utilizam o Insumo.

---

# 39. Pack

Pack representa uma composição de quantidades por Tamanho.

Relacionamento:

~~~text
Grade
   ↓
Pack
   ↓
Itens
   ↓
Tamanhos
~~~

---

# 40. Pack e Grade

Todo Pack deve estar vinculado a uma Grade.

Isso limita os Tamanhos permitidos.

---

# 41. Nome do Pack

Nome é obrigatório.

Exemplos:

~~~text
Pack Básico
Pack Loja Pequena
Pack 1-2-3-2-1
~~~

---

# 42. Status do Pack

Pack utiliza:

~~~text
ATIVO
INATIVO
~~~

Pack inativo deve permanecer historicamente identificável.

---

# 43. Item do Pack

Cada Item possui:

- Pack;
- Tamanho;
- Quantidade.

Relacionamento conceitual:

~~~text
Pack 1:N ItemPack
~~~

---

# 44. Tamanho Duplicado no Pack

Não permitir o mesmo Tamanho duas vezes no mesmo Pack.

Inválido:

~~~text
M = 2
M = 3
~~~

Correto:

~~~text
M = 5
~~~

A validação pertence ao backend.

---

# 45. Quantidade do Item

Deve ser:

~~~text
quantidade > 0
~~~

Não aceitar:

~~~text
0
-1
~~~

---

# 46. Cálculo do Pack

A soma dos itens define a quantidade total de peças por Pack.

~~~text
P = 2
M = 3
G = 2

Total = 7
~~~

Em Compras:

~~~text
10 Packs × 7 peças = 70 peças
~~~

---

# 47. Tela de Packs

Packs utilizam padrão master-detail.

A seleção ocorre no registro principal.

Os Itens são mantidos em estrutura de detalhe.

O padrão visual homologado deve ser preservado.

---

# 48. Multiempresa

Todo Cadastro Auxiliar empresarial deve respeitar tenant.

O backend deve validar:

- consulta;
- criação;
- edição;
- exclusão;
- relacionamentos.

---

# 49. Cross-Tenant

Exemplo inválido:

~~~text
Produto Empresa A
+
Grupo Empresa B
~~~

Outro exemplo:

~~~text
Pack Empresa A
+
Grade Empresa B
~~~

Essas associações devem ser rejeitadas.

---

# 50. Paginação

As listagens devem utilizar paginação server-side quando aplicável.

Fluxo:

~~~text
Frontend
   ↓
page / page_size / filtros
   ↓
Backend
   ↓
QuerySet filtrado
   ↓
count + results
~~~

---

# 51. Filtros

Cada cadastro pode oferecer filtros adequados ao seu domínio.

Exemplos:

- Código;
- Descrição;
- Status;
- Grupo;
- Grade;
- Coleção.

Os filtros não devem romper o contexto da Empresa.

---

# 52. Seleção Única

O padrão visual homologado utiliza seleção única.

~~~text
Checkbox
+
Linha selecionada
+
Barra de ações
~~~

A seleção determina o registro alvo das ações.

---

# 53. Barra de Ações

A barra deve conter somente ações pertinentes.

Exemplo:

~~~text
Consultar | Editar | Excluir
~~~

Em master-detail:

~~~text
Consultar | Editar | Subgrupos | Excluir
~~~

ou:

~~~text
Consultar | Editar | Tamanhos | Excluir
~~~

---

# 54. Remoção de Ações por Linha

Nas telas modernizadas, não utilizar simultaneamente:

~~~text
Barra de ações
+
Coluna Ações
+
Menu ⋮
~~~

Isso cria duplicidade de UX.

O padrão homologado é a barra de ações.

---

# 55. Consultar

Consultar deve abrir visualização somente leitura.

Quando adotado o padrão atual, utilizar modal/sobretela.

Fluxo:

~~~text
Selecionar
   ↓
Consultar
   ↓
Abrir sobretela
   ↓
Exibir dados
~~~

---

# 56. Editar

Editar deve atuar sobre o registro selecionado.

O backend deve validar novamente o ID e o contexto empresarial.

---

# 57. Excluir

Excluir deve:

1. validar permissão;
2. validar Empresa;
3. verificar dependências;
4. excluir somente quando seguro.

---

# 58. Exclusão Protegida

Exemplos:

~~~text
Grupo usado por Produto
→ não excluir destrutivamente

Grade usada por Produto
→ não excluir destrutivamente

Unidade usada por Produto
→ proteger

Pack usado por Pedido
→ proteger
~~~

---

# 59. Ativo e Inativo

Cadastros que possuem lifecycle utilizam:

~~~text
ATIVO
INATIVO
~~~

A inativação preserva identidade e relações históricas.

---

# 60. Histórico

Não foi aprovada uma estrutura sofisticada de Histórico individual para cada Cadastro Auxiliar.

A arquitetura deve permanecer simples.

---

# 61. Auditoria

A infraestrutura geral de Auditoria pode registrar operações relevantes.

Não criar uma tabela de histórico própria para cada auxiliar sem necessidade funcional.

---

# 62. Permissões

As ações devem respeitar as permissões vigentes.

Frontend:

~~~text
controla disponibilidade visual
~~~

Backend:

~~~text
controla autorização real
~~~

---

# 63. Relação com Produto Venda

Produto Venda utiliza vários Cadastros Auxiliares.

~~~text
Produto Venda
   ├── Grupo
   ├── Subgrupo
   ├── Grade
   ├── Tamanhos
   ├── Coleção
   ├── Unidade
   ├── Cores
   ├── Material quando aplicável
   └── Packs
~~~

Referência:

[[Mapa Técnico - Produtos - Produto Venda]]

---

# 64. Relação com Produto Uso/Consumo

Produto Uso/Consumo deve utilizar somente estruturas compatíveis.

Principalmente:

~~~text
Unidade
Dados fiscais relacionados
~~~

Não impor automaticamente:

~~~text
Grade
Tamanho
Cor comercial
Coleção
Pack
~~~

---

# 65. Relação com Insumos

Insumos utilizam principalmente:

~~~text
Unidade
Material opcional
Dados fiscais relacionados
~~~

Não devem herdar estruturas comerciais de Produto Venda.

---

# 66. Tabela de Preço e Promoções

Tabela de Preço e Promoções passaram pela mesma padronização visual durante o ciclo de Produtos.

Entretanto, não fazem parte do núcleo de Cadastros Auxiliares documentado aqui.

Elas devem permanecer em seus próprios domínios funcionais.

---

# 67. Responsabilidades que Não Pertencem aos Auxiliares

Não implementar dentro dessas entidades:

- saldo;
- movimento;
- compra;
- recebimento;
- venda;
- preço operacional real;
- emissão fiscal;
- produção;
- distribuição;
- baixa de material.

---

# 68. Matriz de Responsabilidades

| Cadastro | Responsabilidade |
|---|---|
| Grupo | Classificação principal |
| Subgrupo | Classificação subordinada |
| Grade | Estrutura de Tamanhos |
| Tamanho | Elemento da Grade |
| Coleção | Período/Estação |
| Unidade | Forma de quantificação |
| Cor | Característica cromática |
| Material | Classificação de material |
| Pack | Composição comercial de Tamanhos |
| Item do Pack | Quantidade por Tamanho |

---

# 69. Fluxo Técnico de Cadastro

Fluxo genérico:

~~~text
Usuário
   ↓
Novo cadastro auxiliar
   ↓
Frontend coleta dados
   ↓
Backend identifica Empresa
   ↓
Valida obrigatórios
   ↓
Valida unicidade
   ↓
Valida relacionamentos
   ↓
Persiste
   ↓
Retorna registro
~~~

---

# 70. Fluxo Técnico de Edição

~~~text
Selecionar registro
        ↓
Editar
        ↓
Backend valida Empresa
        ↓
Valida alterações
        ↓
Protege campos estruturais
        ↓
Salva
~~~

---

# 71. Fluxo Técnico de Exclusão

~~~text
Selecionar registro
        ↓
Excluir
        ↓
Backend verifica dependências
        ↓
Sem dependência?
   ├── Sim → excluir
   └── Não → impedir
~~~

---

# 72. Fluxo Master-Detail

Para Grupo/Subgrupo, Grade/Tamanho e estruturas equivalentes:

~~~text
Selecionar Mestre
        ↓
Abrir Detalhes
        ↓
Modal/Sobretela
        ↓
Listar filhos do Mestre
        ↓
Selecionar filho
        ↓
Consultar / Editar / Excluir
~~~

---

# 73. Alterações Estruturais Sensíveis

Algumas mudanças exigem atenção especial.

Exemplos:

~~~text
Código de Referência do Grupo
Coleção
Grade
Tamanho
Unidade
Pack
~~~

Quando já utilizados, alterações podem impactar processos históricos.

---

# 74. Grupo e Referência Histórica

Alterar Código de Referência após geração de Produtos pode gerar divergência entre:

- cadastro atual;
- Referências já emitidas.

Não regenerar Referências existentes automaticamente.

---

# 75. Grade e SKUs Existentes

Grade está ligada à formação de SKUs de Produto Venda.

Alterações em Grade utilizada devem ser protegidas conforme as regras de Produto Venda.

---

# 76. Unidade e Histórico

Alterar Unidade de um item já movimentado pode alterar o significado de quantidades históricas.

Essa alteração deve ser tratada com cuidado pelos módulos consumidores.

---

# 77. Pack Utilizado

Pack já utilizado em Pedido não deve ter seu histórico reinterpretado silenciosamente por mudanças posteriores.

A operação histórica deve preservar as quantidades registradas.

---

# 78. Riscos Técnicos Principais

Os principais riscos são:

- quebra multiempresa;
- duplicidade de códigos;
- alteração de estruturas já utilizadas;
- exclusão destrutiva;
- relacionamento filho com mestre incorreto;
- duplicação de Tamanho em Pack;
- quantidade inválida no Pack;
- mistura de ações por linha com barra de ações;
- transformação de auxiliar em processo operacional.

Detalhes:

[[Riscos e Cuidados - Produtos - Cadastros Auxiliares]]

---

# 79. Regras Estruturais Homologadas

1. Grupo possui Código, Descrição, Código de Referência e Margem.
2. Código de Referência possui exatamente 2 dígitos numéricos.
3. Código de Referência é único por Empresa.
4. Código do Grupo possui unicidade.
5. Subgrupo pertence ao Grupo.
6. Grade possui Tamanhos.
7. Lifecycle Ativo/Inativo é usado quando aplicável.
8. Exclusão deve ser protegida.
9. Coleção possui Código, Estação, Descrição e Status.
10. Status de Coleção utiliza CR, PD, AT, EN e AR.
11. Contador da Coleção permanece interno.
12. Unidade possui Código, Descrição e `permite_decimal`.
13. Código da Unidade deve ser único.
14. Cor mantém estrutura homologada.
15. Código de Cor deve ser único quando utilizado.
16. Material possui Código, Descrição e Ativo/Inativo.
17. Pack pertence a Grade.
18. Nome do Pack é obrigatório.
19. Pack utiliza Ativo/Inativo.
20. Item do Pack relaciona Tamanho e Quantidade.
21. Tamanho não pode repetir dentro do Pack.
22. Quantidade do Item deve ser maior que zero.
23. Multiempresa deve ser estrito.
24. Paginação/filtros devem utilizar backend.
25. Interface deve seguir padrão SYSVAR.
26. Permissões devem ser respeitadas.
27. Histórico sofisticado individual não é necessário.
28. Escopo dos auxiliares não deve ser expandido indevidamente.

---

# 80. Estado Final

**Cadastros Auxiliares de Produtos estão IMPLEMENTADOS E HOMOLOGADOS.**

O princípio técnico central é:

~~~text
CADASTRO AUXILIAR
define uma estrutura.

PRODUTO
referencia essa estrutura.

OPERAÇÃO
utiliza o Produto.

Não transportar
responsabilidades operacionais
para o Cadastro Auxiliar.
~~~

---

# 81. Navegação Documental

## Cadastros Auxiliares

- [[Homologação - Produtos - Cadastros Auxiliares]]
- [[Workflows - Produtos - Cadastros Auxiliares]]
- [[Modelo de Domínio - Produtos - Cadastros Auxiliares]]
- [[Riscos e Cuidados - Produtos - Cadastros Auxiliares]]

## Produtos

- [[Homologação - Produtos - Produto Venda]]
- [[Homologação - Produtos - Produto Uso e Consumo]]
- [[Homologação - Produtos - Insumos]]

## Projeto

- [[Sysvar]]