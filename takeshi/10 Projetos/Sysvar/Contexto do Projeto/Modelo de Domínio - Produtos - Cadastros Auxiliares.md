---
type: domain-model
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
  - domínio
  - multiempresa
  - homologado
---

# Modelo de Domínio - Produtos - Cadastros Auxiliares

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
- [[Mapa Técnico - Produtos - Cadastros Auxiliares]]
- [[Workflows - Produtos - Cadastros Auxiliares]]
- [[Riscos e Cuidados - Produtos - Cadastros Auxiliares]]
- [[Homologação - Produtos - Produto Venda]]
- [[Homologação - Produtos - Produto Uso e Consumo]]
- [[Homologação - Produtos - Insumos]]

---

# 2. Objetivo do Modelo de Domínio

Os **Cadastros Auxiliares de Produtos** representam estruturas de apoio utilizadas pelos diferentes domínios de Produto do [[Sysvar]].

O conjunto homologado contempla:

- Grupo;
- Subgrupo;
- Grade;
- Tamanho;
- Coleção;
- Unidade;
- Cor;
- Material;
- Pack;
- Item de Pack.

Essas entidades não representam Produtos comercializáveis ou movimentáveis por si mesmas.

Sua função é estruturar e classificar informações utilizadas pelos Produtos e pelos processos operacionais.

Princípio central:

~~~text
Cadastro Auxiliar
        ↓
Estrutura o domínio

Produto
        ↓
Utiliza a estrutura

Processo Operacional
        ↓
Utiliza o Produto
~~~

---

# 3. Limite do Domínio

Os Cadastros Auxiliares devem permanecer fora das responsabilidades de:

- Estoque;
- Compras;
- Vendas;
- PDV;
- Fiscal;
- Produção;
- Distribuição;
- movimentações;
- recebimentos;
- baixas.

A existência de uma relação com determinado processo não transfere a responsabilidade desse processo para o Cadastro Auxiliar.

---

# 4. Modelo Conceitual Geral

~~~text
Empresa
   │
   ├── Grupo
   │     └── Subgrupo
   │
   ├── Grade
   │     └── Tamanho
   │
   ├── Coleção
   │
   ├── Unidade
   │
   ├── Cor
   │
   ├── Material
   │
   └── Pack
         └── Item do Pack
               └── Tamanho
~~~

Essas estruturas são utilizadas conforme o domínio específico do Produto.

---

# 5. Empresa

Cadastros Auxiliares empresariais devem respeitar o contexto da Empresa.

Conceitualmente:

~~~text
Empresa 1:N Cadastro Auxiliar
~~~

Quando a entidade estiver sujeita ao tenant, um registro da Empresa A não pode ser utilizado por Produto ou estrutura da Empresa B.

---

# 6. Multiempresa

O isolamento deve existir no backend.

Exemplo inválido:

~~~text
Produto Empresa A
        +
Grupo Empresa B
~~~

Outro exemplo inválido:

~~~text
Pack Empresa A
        +
Grade Empresa B
~~~

As relações devem ser validadas mesmo quando o frontend apresenta somente opções aparentemente válidas.

---

# 7. Grupo

Grupo representa uma classificação principal de Produto.

Estrutura conceitual:

~~~text
Grupo
   ├── Código
   ├── Descrição
   ├── Código de Referência
   └── Margem
~~~

Produto Venda pode referenciar Grupo.

---

# 8. Código do Grupo

O Código é identificador funcional do Grupo.

Deve possuir unicidade no contexto empresarial aplicável.

Não deve existir ambiguidade entre dois Grupos da mesma Empresa com o mesmo Código.

---

# 9. Código de Referência do Grupo

O Código de Referência é obrigatório.

Formato:

~~~text
NN
~~~

Onde:

~~~text
N = dígito numérico
~~~

Exemplos:

~~~text
01
15
99
~~~

---

# 10. Unicidade do Código de Referência

O Código de Referência deve ser único por Empresa.

Ele participa da Referência automática de Produto Venda.

~~~text
AA-BB-CCDDD
      ↑
      CC
~~~

A geração da Referência pertence ao domínio:

[[Modelo de Domínio - Produtos - Produto Venda]]

---

# 11. Margem do Grupo

Margem é um atributo de parametrização/classificação do Grupo.

Não representa diretamente:

- preço de venda;
- custo;
- promoção;
- margem obrigatória final da operação.

Separação:

~~~text
Margem do Grupo
!=
Preço Final
~~~

---

# 12. Subgrupo

Subgrupo é uma classificação subordinada.

Relacionamento:

~~~text
Grupo 1:N Subgrupo
~~~

Não existe Subgrupo independente do Grupo pai.

---

# 13. Estrutura do Subgrupo

Conceitualmente:

~~~text
Subgrupo
   ├── Grupo
   ├── Descrição
   └── Margem
~~~

O Grupo é parte obrigatória de seu contexto.

---

# 14. Integridade Grupo × Subgrupo

O Subgrupo deve pertencer ao mesmo contexto empresarial do Grupo.

Relação inválida:

~~~text
Grupo Empresa A
        +
Subgrupo Empresa B
~~~

---

# 15. Grade

Grade representa uma estrutura de Tamanhos.

Exemplo:

~~~text
Grade Feminina
   ├── PP
   ├── P
   ├── M
   ├── G
   └── GG
~~~

Outro exemplo:

~~~text
Grade Calçados
   ├── 34
   ├── 35
   ├── 36
   ├── 37
   └── 38
~~~

---

# 16. Tamanho

Tamanho pertence a uma Grade.

Relacionamento:

~~~text
Grade 1:N Tamanho
~~~

O Tamanho é elemento da estrutura da Grade.

---

# 17. Tamanho não é Grade

Separação conceitual:

~~~text
Grade
→ conjunto

Tamanho
→ elemento do conjunto
~~~

---

# 18. Grade e Produto Venda

Produto Venda utiliza Grade para determinar Tamanhos permitidos.

~~~text
Produto Venda
        ↓
Grade
        ↓
Tamanhos
~~~

A combinação comercial posterior ocorre com Cor.

---

# 19. Grade, Cor e SKU

Conceitualmente:

~~~text
Produto
   +
Cor
   +
Tamanho
   =
SKU
~~~

A geração e gestão de SKU pertencem ao domínio de Produto Venda.

Grade e Tamanho apenas fornecem a estrutura necessária.

---

# 20. Alteração de Grade

Grade já utilizada pode possuir dependências históricas.

Não deve ser tratada como estrutura descartável.

Alterações devem considerar:

- Produtos;
- SKUs;
- Packs;
- registros históricos.

---

# 21. Coleção

Coleção representa período e Estação aplicáveis principalmente ao Produto Venda.

Estrutura:

~~~text
Coleção
   ├── Código
   ├── Estação
   ├── Descrição
   ├── Status
   └── Contador interno
~~~

---

# 22. Código da Coleção

O Código representa dois dígitos do ano.

Exemplo:

~~~text
26
~~~

representando 2026.

---

# 23. Estação

Valores homologados:

~~~text
01 = Verão
02 = Outono
03 = Inverno
04 = Primavera
~~~

---

# 24. Identidade Lógica da Coleção

A combinação relevante é:

~~~text
Código + Estação
~~~

Exemplo:

~~~text
26 / 01
26 / 02
26 / 03
26 / 04
~~~

---

# 25. Status da Coleção

Estados homologados:

~~~text
CR
PD
AT
EN
AR
~~~

Representam as etapas funcionais definidas para Coleções.

---

# 26. Contador da Coleção

O contador é atributo interno utilizado pela lógica de geração da Referência.

Não pertence à manutenção normal pelo usuário.

Separação:

~~~text
Campo operacional interno
!=
Campo de cadastro manual
~~~

---

# 27. Coleção e Referência

Coleção fornece parte da identidade usada na Referência de Produto Venda.

~~~text
AA-BB-CCDDD

AA = Código da Coleção
BB = Estação
CC = Código de Referência do Grupo
DDD = Sequência
~~~

---

# 28. Unidade

Unidade representa a forma de quantificação de um item.

Estrutura:

~~~text
Unidade
   ├── Código
   ├── Descrição
   └── Permite Decimal
~~~

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

# 29. Código da Unidade

O Código é representação compacta da Unidade.

Deve possuir unicidade no contexto aplicável.

Exemplos:

~~~text
UN
KG
M
LT
~~~

---

# 30. Permite Decimal

A propriedade:

~~~text
permite_decimal
~~~

determina se quantidades fracionárias são compatíveis com a Unidade.

Exemplo:

~~~text
M
permite_decimal = true

1,75 M
~~~

Outro exemplo:

~~~text
UN
permite_decimal = false

6 UN
~~~

---

# 31. Unidade não é Quantidade

Separação:

~~~text
Unidade
→ como medir

Quantidade
→ quanto existe ou é utilizado
~~~

A quantidade pertence ao processo consumidor.

---

# 32. Unidade e Produto Venda

Produto Venda pode utilizar Unidade para definir sua forma de quantificação.

A Unidade não determina:

- saldo;
- preço;
- Grade;
- Pack.

---

# 33. Unidade e Produto Uso/Consumo

Produto Uso/Consumo utiliza Unidade sem necessidade de estruturas comerciais adicionais.

Referência:

[[Modelo de Domínio - Produtos - Produto Uso e Consumo]]

---

# 34. Unidade e Insumos

Insumos utilizam Unidade como informação central de quantificação.

Exemplo:

~~~text
Tecido
→ M

Botão
→ UN
~~~

Referência:

[[Modelo de Domínio - Produtos - Insumos]]

---

# 35. Cor

Cor representa uma característica cromática.

Sua utilização principal ocorre em Produto Venda.

Conceitualmente:

~~~text
Cor
        ↓
Produto Venda
        ↓
Variações comerciais
~~~

---

# 36. Código da Cor

Quando utilizado, o Código deve possuir unicidade no contexto aplicável.

Não devem existir códigos ambíguos dentro do mesmo contexto empresarial.

---

# 37. Cor não é SKU

Cor isoladamente não representa variação comercial completa.

~~~text
Cor
!=
SKU
~~~

O SKU depende da relação completa definida pelo Produto Venda.

---

# 38. Material

Material representa classificação material.

Estrutura:

~~~text
Material
   ├── Código
   ├── Descrição
   └── Ativo/Inativo
~~~

---

# 39. Material e Insumo

Material pode ser relacionado opcionalmente ao Insumo.

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

# 40. Material não é Insumo

Separação fundamental:

~~~text
Material
→ classificação

Insumo
→ item operacional
~~~

Material não deve substituir Insumo em:

- Compras;
- Estoque;
- Ficha Técnica;
- Produção.

---

# 41. Lifecycle do Material

Material utiliza:

~~~text
ATIVO
  ↕
INATIVO
~~~

Inativação preserva identidade e relações históricas.

---

# 42. Pack

Pack representa uma composição de quantidades distribuídas entre Tamanhos de uma Grade.

Relacionamento principal:

~~~text
Grade
   ↓
Pack
   ↓
Itens
~~~

---

# 43. Pack pertence à Grade

Todo Pack possui uma Grade de referência.

Relacionamento:

~~~text
Grade 1:N Pack
~~~

A Grade define os Tamanhos permitidos para seus Itens.

---

# 44. Nome do Pack

Nome é obrigatório.

Representa identidade funcional do Pack.

Exemplos:

~~~text
Pack Básico
Pack Loja Pequena
Pack 1-2-3-2-1
~~~

---

# 45. Lifecycle do Pack

Pack utiliza:

~~~text
ATIVO
INATIVO
~~~

Pack inativo permanece historicamente identificável.

---

# 46. Item de Pack

Item de Pack representa uma quantidade associada a determinado Tamanho.

Estrutura:

~~~text
ItemPack
   ├── Pack
   ├── Tamanho
   └── Quantidade
~~~

---

# 47. Pack e Itens

Relacionamento:

~~~text
Pack 1:N ItemPack
~~~

Cada Item pertence a um único Pack.

---

# 48. Item e Tamanho

O Tamanho utilizado no Item deve pertencer à Grade do Pack.

Invariante:

~~~text
Item.Tamanho.Grade
=
Pack.Grade
~~~

---

# 49. Tamanho Único dentro do Pack

Não pode existir duplicidade do mesmo Tamanho no mesmo Pack.

Invariante:

~~~text
Pack + Tamanho
=
único
~~~

Inválido:

~~~text
Pack A
M = 2
M = 3
~~~

---

# 50. Quantidade do Item

A quantidade deve ser positiva.

Invariante:

~~~text
Quantidade > 0
~~~

Valores inválidos:

~~~text
0
-1
~~~

---

# 51. Total de Peças do Pack

O total é derivado da soma dos Itens.

~~~text
TotalPack
=
Σ Quantidade dos Itens
~~~

Exemplo:

~~~text
P = 2
M = 3
G = 2

Total = 7 peças
~~~

---

# 52. Pack e Compras

Pack pode ser utilizado em Compras de Produto Venda.

~~~text
Número de Packs
×
Total de Peças do Pack
=
Quantidade de Peças
~~~

Exemplo:

~~~text
10 × 7 = 70 peças
~~~

A operação de Compra permanece fora do domínio do Pack.

---

# 53. Pack não é Pedido de Compra

Separação:

~~~text
Pack
→ composição

Pedido
→ operação
~~~

O Pack fornece estrutura.

O Pedido registra o evento comercial.

---

# 54. Ativo e Inativo

Cadastros que possuem lifecycle usam:

~~~text
ATIVO
INATIVO
~~~

Inativação não representa exclusão.

---

# 55. Inativação

Inativação preserva:

- identidade;
- referências;
- operações históricas;
- relacionamentos existentes.

Registro inativo pode ser impedido de participar de novas operações, conforme o processo consumidor.

---

# 56. Exclusão

Exclusão física somente deve ocorrer quando segura.

O backend deve verificar dependências.

---

# 57. Exclusão Protegida de Grupo

Grupo utilizado por Produto deve ter sua integridade protegida.

Não destruir associação histórica.

---

# 58. Exclusão Protegida de Subgrupo

Subgrupo utilizado por Produto também deve ser protegido.

---

# 59. Exclusão Protegida de Grade

Grade utilizada por:

- Produto;
- SKU;
- Pack;

não deve ser excluída destrutivamente sem validação.

---

# 60. Exclusão Protegida de Tamanho

Tamanho utilizado em:

- SKU;
- Pack;
- outras relações;

deve permanecer historicamente identificável.

---

# 61. Exclusão Protegida de Coleção

Coleção utilizada em Produto Venda não deve provocar perda da identidade histórica do Produto.

---

# 62. Exclusão Protegida de Unidade

Unidade já utilizada pode ser necessária para interpretar quantidades históricas.

A exclusão deve respeitar dependências.

---

# 63. Exclusão Protegida de Cor

Cor utilizada por SKUs não deve ser removida de forma a quebrar essas referências.

---

# 64. Exclusão Protegida de Material

Material utilizado por Insumos deve permanecer consistente.

---

# 65. Exclusão Protegida de Pack

Pack já utilizado em Pedido precisa preservar o histórico da operação.

Alteração ou exclusão posterior não deve reinterpretar o Pedido antigo.

---

# 66. Histórico

Não foi definida uma entidade sofisticada de Histórico individual para cada Cadastro Auxiliar.

Essas estruturas permanecem intencionalmente simples.

---

# 67. Auditoria

A Auditoria geral pode registrar eventos relevantes.

Conceitualmente:

~~~text
Usuário
   ↓
Ação
   ↓
Cadastro Auxiliar
   ↓
AuditLog
~~~

Não criar necessariamente um histórico paralelo por entidade.

---

# 68. Permissões

Permissões definem quais ações o usuário pode executar.

Exemplos:

- consultar;
- criar;
- editar;
- excluir;
- ativar;
- inativar.

O frontend representa a disponibilidade visual.

O backend executa a autorização efetiva.

---

# 69. Paginação

Paginação é preocupação da camada de consulta.

Não altera o domínio das entidades.

Deve ser processada pelo backend conforme padrão homologado.

---

# 70. Filtros

Filtros podem utilizar atributos próprios de cada entidade.

Exemplos:

~~~text
Código
Descrição
Status
Grupo
Grade
Coleção
~~~

Sempre respeitando Empresa quando aplicável.

---

# 71. Modelo Master-Detail

Algumas entidades possuem estrutura mestre-detalhe.

Principais pares:

~~~text
Grupo
   ↓
Subgrupo

Grade
   ↓
Tamanho

Pack
   ↓
Item
~~~

---

# 72. Grupo × Subgrupo

~~~text
Grupo 1:N Subgrupo
~~~

A tela principal trabalha com Grupo.

Subgrupos são mantidos no contexto do Grupo selecionado.

---

# 73. Grade × Tamanho

~~~text
Grade 1:N Tamanho
~~~

A Grade é mestre.

Tamanho é detalhe.

---

# 74. Pack × Item

~~~text
Pack 1:N ItemPack
~~~

O Pack é mestre.

Item é detalhe.

---

# 75. Padrão Visual de Seleção

Nas telas homologadas, o modelo visual utiliza:

~~~text
Checkbox
+
Seleção única
+
Linha destacada
+
Barra de ações
~~~

---

# 76. Barra de Ações

A barra atua sobre o registro selecionado.

Exemplo simples:

~~~text
Consultar | Editar | Excluir
~~~

Exemplo master-detail:

~~~text
Consultar | Editar | Subgrupos | Excluir
~~~

ou:

~~~text
Consultar | Editar | Tamanhos | Excluir
~~~

---

# 77. Ausência de Ações por Linha

O padrão modernizado não utiliza simultaneamente:

~~~text
Barra de ações
+
Coluna Ações
+
Menu ⋮
~~~

A barra centraliza as operações.

---

# 78. Consulta

Consultar representa projeção somente leitura da entidade selecionada.

O padrão atual pode utilizar:

~~~text
Modal / Sobretela
~~~

preservando a listagem ao fundo.

---

# 79. Edição

A edição modifica somente atributos permitidos.

Deve preservar:

- Empresa;
- identidade;
- relacionamentos estruturais protegidos;
- integridade histórica.

---

# 80. Relação com Produto Venda

Produto Venda utiliza principalmente:

~~~text
Grupo
Subgrupo
Grade
Tamanho
Coleção
Unidade
Cor
Pack
Material quando aplicável
~~~

Referência:

[[Modelo de Domínio - Produtos - Produto Venda]]

---

# 81. Relação com Produto Uso/Consumo

Produto Uso/Consumo possui domínio mais simples.

Utiliza principalmente:

~~~text
Unidade
~~~

e estruturas fiscais relacionadas.

Não deve depender obrigatoriamente de:

- Grupo;
- Grade;
- Tamanho;
- Cor comercial;
- Coleção;
- Pack.

Referência:

[[Modelo de Domínio - Produtos - Produto Uso e Consumo]]

---

# 82. Relação com Insumos

Insumos utilizam principalmente:

~~~text
Unidade
Material opcional
~~~

e informações fiscais relacionadas.

Não devem receber automaticamente estruturas comerciais de Produto Venda.

Referência:

[[Modelo de Domínio - Produtos - Insumos]]

---

# 83. Tabela de Preço

Tabela de Preço é funcionalidade correlata do módulo Produtos.

Não pertence ao núcleo dos Cadastros Auxiliares definido neste documento.

Seu padrão visual pode compartilhar:

- seleção única;
- barra de ações;
- consulta em sobretela.

Isso não transforma Tabela de Preço em entidade auxiliar deste domínio.

---

# 84. Promoções

Promoções também participaram da padronização visual do módulo.

Entretanto:

~~~text
Promoção
!=
Cadastro Auxiliar Estrutural
~~~

Promoção pertence ao domínio comercial.

---

# 85. Alterações Estruturais

Cadastros Auxiliares podem possuir impacto muito maior do que sua simplicidade visual sugere.

Mudanças sensíveis incluem:

- Código de Referência de Grupo;
- Grade;
- Tamanho;
- Coleção;
- Unidade;
- Pack.

Antes da alteração, devem ser avaliadas relações existentes.

---

# 86. Alteração do Código de Referência

Produto Venda pode possuir Referências já geradas.

Alterar o Código de Referência do Grupo não deve regenerar automaticamente identidades históricas.

Separação:

~~~text
Configuração atual do Grupo
!=
Identidade histórica do Produto
~~~

---

# 87. Alteração de Grade

Uma Grade já utilizada por SKUs não deve ser modificada de forma a invalidar combinações existentes.

---

# 88. Alteração de Tamanho

Renomear ou remover Tamanho utilizado pode alterar a interpretação histórica de SKUs e Packs.

Requer cuidado.

---

# 89. Alteração de Unidade

Unidade utilizada em operações históricas possui significado semântico.

Exemplo:

~~~text
Quantidade = 100
Unidade = M
~~~

Alterar posteriormente para `KG` mudaria completamente a interpretação.

---

# 90. Alteração de Pack

Pedido histórico deve preservar as quantidades gravadas na operação.

Alterações futuras no Pack não devem recalcular operações antigas.

---

# 91. Invariantes do Grupo

1. Código deve respeitar unicidade.
2. Código de Referência é obrigatório.
3. Código de Referência possui exatamente 2 dígitos numéricos.
4. Código de Referência é único por Empresa.
5. Subgrupo depende do Grupo.

---

# 92. Invariantes da Grade

1. Grade possui Tamanhos.
2. Tamanho pertence a uma Grade.
3. dependências históricas devem ser protegidas.
4. Grade utilizada não deve ser destruída de maneira inconsistente.

---

# 93. Invariantes da Coleção

1. Código possui 2 dígitos.
2. Estação pertence ao conjunto homologado.
3. Status pertence ao conjunto homologado.
4. contador permanece interno.
5. Código + Estação representam a combinação relevante.

---

# 94. Invariantes da Unidade

1. Código deve ser único.
2. Descrição identifica a Unidade.
3. `permite_decimal` define comportamento quantitativo.
4. Unidade não contém saldo.
5. Unidade não contém quantidade operacional.

---

# 95. Invariantes da Cor

1. Código deve ser único quando utilizado.
2. Cor não é SKU.
3. Cor utilizada deve preservar relações históricas.

---

# 96. Invariantes do Material

1. Código identifica Material.
2. Material possui Descrição.
3. lifecycle é Ativo/Inativo.
4. Material é opcional para Insumo.
5. Material não substitui Insumo.

---

# 97. Invariantes do Pack

1. Pack pertence a Grade.
2. Nome é obrigatório.
3. Pack possui Ativo/Inativo.
4. Item pertence ao Pack.
5. Item utiliza Tamanho da Grade.
6. mesmo Tamanho não pode repetir no Pack.
7. quantidade deve ser maior que zero.

---

# 98. Matriz de Responsabilidades

| Entidade | Responsabilidade principal |
|---|---|
| Grupo | Classificação principal |
| Subgrupo | Classificação subordinada |
| Grade | Estrutura de Tamanhos |
| Tamanho | Elemento da Grade |
| Coleção | Ano/Estação do Produto |
| Unidade | Forma de quantificação |
| Cor | Característica cromática |
| Material | Classificação material |
| Pack | Composição de Tamanhos |
| Item do Pack | Quantidade por Tamanho |

---

# 99. Modelo Consolidado

~~~text
                         EMPRESA
                            │
          ┌─────────────────┼───────────────────┐
          │                 │                   │
          ↓                 ↓                   ↓
        Grupo             Grade              Coleção
          │                 │
          ↓                 ↓
      Subgrupo           Tamanho
                            │
                            ↓
                           Pack
                            │
                            ↓
                       Item do Pack

          Unidade       Cor       Material
             │           │           │
             └─────┬─────┴─────┬─────┘
                   │           │
                   ↓           ↓
              PRODUTOS      INSUMOS
~~~

---

# 100. Escopo que Não Pertence ao Domínio

Os Cadastros Auxiliares não devem armazenar diretamente:

- saldo;
- localização física;
- compra;
- recebimento;
- venda;
- movimentação;
- nota fiscal;
- OP;
- consumo;
- distribuição;
- estoque em trânsito.

Essas informações pertencem aos processos operacionais.

---

# 101. Riscos de Violação do Domínio

Os principais riscos são:

- quebra multiempresa;
- códigos duplicados;
- relacionamento filho/mestre incorreto;
- alteração de estrutura histórica;
- exclusão destrutiva;
- Grade inconsistente;
- Pack com Tamanho duplicado;
- quantidade inválida no Pack;
- Unidade reinterpretada;
- transformação de Cadastro Auxiliar em módulo operacional.

Detalhes:

[[Riscos e Cuidados - Produtos - Cadastros Auxiliares]]

---

# 102. Baseline Homologada

A baseline funcional é:

[[Homologação - Produtos - Cadastros Auxiliares]]

A baseline técnica é:

[[Mapa Técnico - Produtos - Cadastros Auxiliares]]

Os fluxos são:

[[Workflows - Produtos - Cadastros Auxiliares]]

Esses documentos devem ser avaliados em conjunto antes de alterações estruturais.

---

# 103. Estado Final

**Cadastros Auxiliares de Produtos estão IMPLEMENTADOS E HOMOLOGADOS.**

O modelo deve continuar respeitando:

~~~text
GRUPO
classifica.

SUBGRUPO
especializa o Grupo.

GRADE
organiza Tamanhos.

TAMANHO
compõe a Grade.

COLEÇÃO
organiza período e Estação.

UNIDADE
define como quantificar.

COR
define característica cromática.

MATERIAL
classifica material.

PACK
define composição por Tamanho.

PRODUTO
utiliza essas estruturas.

PROCESSOS
utilizam o Produto.
~~~

---

# 104. Navegação Documental

## Cadastros Auxiliares

- [[Homologação - Produtos - Cadastros Auxiliares]]
- [[Mapa Técnico - Produtos - Cadastros Auxiliares]]
- [[Workflows - Produtos - Cadastros Auxiliares]]
- [[Riscos e Cuidados - Produtos - Cadastros Auxiliares]]

## Produtos

- [[Homologação - Produtos - Produto Venda]]
- [[Homologação - Produtos - Produto Uso e Consumo]]
- [[Homologação - Produtos - Insumos]]

## Projeto

- [[Sysvar]]