---
type: risks-and-care
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
  - riscos
  - multiempresa
  - homologado
---

# Riscos e Cuidados - Produtos - Cadastros Auxiliares

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
- [[Modelo de Domínio - Produtos - Cadastros Auxiliares]]
- [[Homologação - Produtos - Produto Venda]]
- [[Homologação - Produtos - Produto Uso e Consumo]]
- [[Homologação - Produtos - Insumos]]

---

# 2. Objetivo

Este documento registra os principais riscos técnicos, funcionais e arquiteturais relacionados aos **Cadastros Auxiliares de Produtos** do [[Sysvar]].

O conjunto contempla:

- Grupos;
- Subgrupos;
- Grades;
- Tamanhos;
- Coleções;
- Packs;
- Itens de Pack;
- Unidades;
- Cores;
- Material.

Deve ser consultado antes de alterações relevantes em:

- models;
- serializers;
- views;
- endpoints;
- migrations;
- unicidade;
- relacionamentos;
- filtros;
- paginação;
- lifecycle;
- exclusão;
- permissões;
- interfaces master-detail;
- barras de ações;
- integrações com Produtos.

O objetivo principal é impedir que cadastros aparentemente simples provoquem inconsistências em estruturas já utilizadas por Produtos e processos operacionais.

---

# 3. Classificação de Impacto

Os riscos utilizam as classificações:

~~~text
CRÍTICO
ALTO
MÉDIO
BAIXO
~~~

## CRÍTICO

Pode causar:

- vazamento entre Empresas;
- quebra de integridade referencial;
- corrupção de SKUs;
- alteração de identidade de Produtos;
- quantidades históricas incorretas;
- associação cross-tenant;
- exclusão destrutiva de estruturas utilizadas.

## ALTO

Pode causar:

- quebra de regras homologadas;
- duplicidade de códigos;
- Pack incorreto;
- Grade inconsistente;
- referências divergentes;
- comportamento incorreto em Produtos;
- histórico reinterpretado.

## MÉDIO

Pode causar:

- UX inconsistente;
- filtros incorretos;
- dificuldade de manutenção;
- duplicidade de ações;
- cadastros confusos.

## BAIXO

Normalmente relacionado a:

- apresentação;
- conveniência;
- pequenas melhorias visuais;
- otimizações sem impacto direto na integridade.

---

# 4. Risco — Quebra do Isolamento Multiempresa

Cadastros Auxiliares sujeitos ao tenant devem permanecer isolados por Empresa.

Exemplos inválidos:

~~~text
Produto Empresa A
+
Grupo Empresa B
~~~

~~~text
Pack Empresa A
+
Grade Empresa B
~~~

Impacto:

**CRÍTICO**

Cuidados:

- aplicar Empresa no backend;
- validar ForeignKeys;
- não confiar apenas nos combos do frontend;
- testar relações cross-tenant;
- restringir QuerySets.

---

# 5. Risco — Confiar Apenas no Frontend

A interface mostrar somente registros da Empresa atual não garante segurança.

Uma requisição pode ser manipulada.

Impacto:

**CRÍTICO**

Cuidado:

~~~text
Frontend
→ UX

Backend
→ autoridade
~~~

Todas as relações devem ser revalidadas no servidor.

---

# 6. Risco — Código do Grupo Duplicado

Código do Grupo deve respeitar unicidade no contexto aplicável.

Impacto:

**ALTO**

Duplicidades podem causar:

- ambiguidade;
- filtros inconsistentes;
- dificuldade de integração;
- identificação incorreta.

---

# 7. Risco — Código de Referência do Grupo Inválido

Formato homologado:

~~~text
2 dígitos numéricos
~~~

Inválidos:

~~~text
1
001
AB
A1
~~~

Impacto:

**ALTO**

Esse campo participa da Referência do Produto Venda.

---

# 8. Risco — Código de Referência Duplicado

O Código de Referência deve ser único por Empresa.

Impacto:

**CRÍTICO**

Pode comprometer a lógica de Referência:

~~~text
AA-BB-CCDDD
      ↑
      CC
~~~

Dois Grupos com o mesmo `CC` podem gerar ambiguidade funcional.

---

# 9. Risco — Alterar Código de Referência após uso

Produtos Venda podem possuir Referências já geradas.

Impacto:

**CRÍTICO**

Não deve ocorrer:

~~~text
Grupo muda Código de Referência
        ↓
Sistema regenera Referências antigas
~~~

Referências históricas devem permanecer estáveis.

---

# 10. Risco — Confundir Margem do Grupo com Preço

Margem do Grupo é um parâmetro cadastral.

Impacto:

**ALTO**

Não tratar automaticamente:

~~~text
Margem do Grupo
=
Preço de Venda obrigatório
~~~

A formação de preço pertence ao domínio comercial correspondente.

---

# 11. Risco — Criar Subgrupo sem Grupo

Subgrupo é dependente do Grupo.

Impacto:

**ALTO**

Invariante:

~~~text
Subgrupo
→ sempre possui Grupo pai
~~~

---

# 12. Risco — Associar Subgrupo ao Grupo de Outra Empresa

Impacto:

**CRÍTICO**

A relação deve ser validada no backend.

---

# 13. Risco — Excluir Grupo com Dependências

Grupo pode estar utilizado por:

- Produtos;
- Subgrupos;
- outras estruturas.

Impacto:

**CRÍTICO**

Não aplicar exclusão em cascata destrutiva sem análise.

---

# 14. Risco — Excluir Subgrupo Utilizado

Subgrupo utilizado por Produtos deve preservar integridade histórica.

Impacto:

**CRÍTICO**

Quando necessário, utilizar inativação ou proteção conforme o lifecycle vigente.

---

# 15. Risco — Grade Modificada após Criação de SKUs

Grade pode participar diretamente da composição de SKUs.

Impacto:

**CRÍTICO**

Alterações podem tornar inconsistentes:

- Produtos;
- Tamanhos;
- SKUs;
- Packs.

---

# 16. Risco — Excluir Grade Utilizada

Impacto:

**CRÍTICO**

Antes da exclusão, verificar:

- Produto;
- SKU;
- Pack;
- demais relações.

---

# 17. Risco — Tamanho sem Grade

Tamanho pertence a uma Grade.

Impacto:

**ALTO**

Não permitir detalhe órfão.

---

# 18. Risco — Mover Tamanho entre Grades

Um Tamanho já utilizado pode estar associado a:

- SKU;
- Pack;
- histórico comercial.

Impacto:

**CRÍTICO**

Mover Tamanho de uma Grade para outra pode reinterpretar relações existentes.

---

# 19. Risco — Excluir Tamanho Utilizado

Impacto:

**CRÍTICO**

Tamanhos usados em SKUs ou Packs devem permanecer referenciáveis.

---

# 20. Risco — Alterar Nome de Tamanho sem avaliar histórico

Mesmo uma alteração aparentemente simples pode afetar:

- apresentação de SKU;
- documentos;
- consultas históricas.

Impacto:

**ALTO**

Avaliar utilização antes de alterações estruturais.

---

# 21. Risco — Código da Coleção Inválido

O Código da Coleção possui:

~~~text
2 dígitos
~~~

Impacto:

**ALTO**

Formato incorreto pode comprometer geração de Referência.

---

# 22. Risco — Estação Fora do Domínio

Valores homologados:

~~~text
01
02
03
04
~~~

Impacto:

**ALTO**

Não permitir valores fora desse conjunto sem nova decisão funcional.

---

# 23. Risco — Status de Coleção Fora do Domínio

Valores homologados:

~~~text
CR
PD
AT
EN
AR
~~~

Impacto:

**MÉDIO/ALTO**

Não criar novos estados silenciosamente.

---

# 24. Risco — Expor Contador da Coleção para Edição Manual

O contador é interno.

Impacto:

**CRÍTICO**

Permitir edição manual pode:

- duplicar sequência;
- quebrar Referências;
- causar colisões.

---

# 25. Risco — Alterar Contador para reutilizar sequência

Uma sequência já utilizada não deve ser reaproveitada apenas porque um Produto foi excluído ou cancelado.

Impacto:

**CRÍTICO**

---

# 26. Risco — Excluir Coleção Utilizada

Coleção participa da identidade funcional de Produtos.

Impacto:

**CRÍTICO**

Não destruir uma Coleção que ainda é necessária para interpretação histórica.

---

# 27. Risco — Regenerar Referências após Alterar Coleção

Produto já possui identidade própria.

Impacto:

**CRÍTICO**

Não realizar:

~~~text
Coleção alterada
        ↓
Referências antigas recalculadas
~~~

---

# 28. Risco — Código de Unidade Duplicado

O Código da Unidade deve possuir unicidade.

Impacto:

**ALTO**

Duplicidade torna ambígua a interpretação de quantidades.

---

# 29. Risco — Alterar Unidade já Utilizada

Exemplo:

~~~text
Quantidade = 100
Unidade = M
~~~

Alterar a Unidade para `KG` faria o histórico perder significado.

Impacto:

**CRÍTICO**

---

# 30. Risco — Ignorar `permite_decimal`

A propriedade deve ser respeitada pelos processos consumidores.

Impacto:

**ALTO**

Exemplo:

~~~text
M
permite_decimal = true
~~~

deve aceitar quantidades como:

~~~text
1,75
~~~

---

# 31. Risco — Aceitar Decimal em Unidade Indevida

Exemplo:

~~~text
UN
permite_decimal = false
~~~

Quantidade:

~~~text
2,5 UN
~~~

pode ser inválida.

Impacto:

**ALTO**

A regra deve ser aplicada no processo que manipula quantidades.

---

# 32. Risco — Colocar Quantidade dentro do Cadastro de Unidade

Unidade define como medir.

Não define quanto existe.

Impacto:

**ALTO**

Separação:

~~~text
Unidade
!=
Quantidade
~~~

---

# 33. Risco — Código de Cor Duplicado

Quando utilizado, o Código da Cor deve respeitar unicidade.

Impacto:

**ALTO**

Duplicidades podem gerar ambiguidade na identificação de variações.

---

# 34. Risco — Excluir Cor Utilizada por SKU

Impacto:

**CRÍTICO**

Cor já relacionada a Produto/SKU deve permanecer historicamente identificável.

---

# 35. Risco — Confundir Cor com SKU

Cor isoladamente não representa uma variação completa.

Impacto:

**ALTO**

~~~text
Produto + Cor + Tamanho = SKU
~~~

A geração pertence ao Produto Venda.

---

# 36. Risco — Código de Material Duplicado

Material deve possuir identidade consistente.

Impacto:

**ALTO**

Código duplicado pode gerar classificação ambígua.

---

# 37. Risco — Tornar Material obrigatório em Insumos

Material foi homologado como opcional para Insumos.

Impacto:

**ALTO**

Não transformar classificação opcional em requisito obrigatório.

---

# 38. Risco — Confundir Material com Insumo

Separação:

~~~text
Material
→ classificação

Insumo
→ item operacional
~~~

Impacto:

**CRÍTICO**

Não movimentar Material diretamente em:

- Estoque;
- Compras;
- Ficha Técnica;
- Produção.

---

# 39. Risco — Excluir Material Utilizado

Impacto:

**ALTO/CRÍTICO**

Material associado a Insumos deve preservar suas relações.

---

# 40. Risco — Pack sem Grade

Todo Pack pertence a uma Grade.

Impacto:

**CRÍTICO**

Sem Grade, não existe referência segura para validar os Tamanhos permitidos.

---

# 41. Risco — Pack ligado à Grade de Outra Empresa

Impacto:

**CRÍTICO**

Backend deve validar tenant.

---

# 42. Risco — Nome de Pack vazio

Nome é obrigatório.

Impacto:

**MÉDIO**

Packs sem identificação dificultam operação e seleção.

---

# 43. Risco — Tamanho do Item fora da Grade

Exemplo inválido:

~~~text
Pack → Grade Feminina
Item → Tamanho pertencente à Grade Calçados
~~~

Impacto:

**CRÍTICO**

A validação deve ocorrer no backend.

---

# 44. Risco — Tamanho duplicado no mesmo Pack

Invariante:

~~~text
Pack + Tamanho
=
único
~~~

Impacto:

**ALTO**

Inválido:

~~~text
P = 2
M = 3
M = 1
G = 2
~~~

---

# 45. Risco — Quantidade zero no Item do Pack

Quantidade deve ser:

~~~text
> 0
~~~

Impacto:

**ALTO**

Não aceitar:

~~~text
0
~~~

---

# 46. Risco — Quantidade negativa no Pack

Impacto:

**CRÍTICO**

Não permitir valores negativos.

---

# 47. Risco — Alterar Pack utilizado em Pedido

Um Pedido histórico deve preservar as quantidades registradas no momento da operação.

Impacto:

**CRÍTICO**

Não recalcular Pedidos antigos com base na composição atual do Pack.

---

# 48. Risco — Excluir Pack utilizado

Impacto:

**CRÍTICO**

Pack já usado em Pedido deve permanecer identificável.

---

# 49. Risco — Ativar/Inativar apagar histórico

Lifecycle não deve alterar operações antigas.

Impacto:

**ALTO**

~~~text
INATIVO
!=
INEXISTENTE
~~~

---

# 50. Risco — Reativação criar novo cadastro

Reativação deve utilizar a mesma entidade quando o lifecycle suportar essa operação.

Impacto:

**ALTO**

Preservar:

- ID;
- Código;
- Empresa;
- relações.

---

# 51. Risco — Exclusão em Cascata

Mudanças em ForeignKeys podem provocar exclusões involuntárias.

Impacto:

**CRÍTICO**

Revisar cuidadosamente:

~~~text
on_delete
~~~

em estruturas mestre-detalhe.

---

# 52. Risco — Excluir Mestre e apagar Detalhes utilizados

Exemplos:

~~~text
Grupo → Subgrupos
Grade → Tamanhos
Pack → Itens
~~~

Impacto:

**CRÍTICO**

A exclusão do mestre precisa considerar dependências dos detalhes.

---

# 53. Risco — Histórico Sofisticado Desnecessário

Não foi homologado um sistema individual complexo de histórico para cada Cadastro Auxiliar.

Impacto:

**MÉDIO**

Evitar:

- novas tabelas sem necessidade;
- eventos redundantes;
- duplicação do AuditLog;
- complexidade operacional sem ganho real.

---

# 54. Risco — Falta de Auditoria Geral

A simplicidade dos auxiliares não significa ausência de rastreabilidade.

Impacto:

**ALTO**

Eventos relevantes devem utilizar a Auditoria geral quando aplicável.

---

# 55. Risco — Paginação Client-Side

Bases grandes podem degradar desempenho.

Impacto:

**MÉDIO/ALTO**

Utilizar paginação server-side conforme padrão homologado.

---

# 56. Risco — Filtros Client-Side em Base Parcial

Se o frontend possui apenas uma página, filtrar localmente produz resultados incorretos.

Impacto:

**ALTO**

Filtros devem consultar o backend.

---

# 57. Risco — Indicadores baseados somente na página

Caso existam indicadores, eles não devem representar apenas os registros carregados na página atual.

Impacto:

**MÉDIO**

---

# 58. Risco — Misturar Barra de Ações e Menu por Linha

O padrão homologado utiliza barra de ações nas telas modernizadas.

Impacto:

**MÉDIO**

Evitar simultaneamente:

~~~text
Barra de ações
+
Coluna Ações
+
Menu ⋮
~~~

Isso gera duplicidade e inconsistência visual.

---

# 59. Risco — Reintroduzir coluna `Ações`

Nas telas já padronizadas, a coluna foi removida.

Impacto:

**MÉDIO**

Não reintroduzir sem decisão de alteração de padrão.

---

# 60. Risco — Reintroduzir menu `⋮`

O mesmo vale para ações por linha.

Impacto:

**MÉDIO**

Preservar seleção + barra de ações.

---

# 61. Risco — Seleção múltipla em tela de ação única

A interface homologada utiliza seleção única.

Impacto:

**MÉDIO/ALTO**

Ações como:

- Consultar;
- Editar;
- Excluir;

devem ter alvo inequívoco.

---

# 62. Risco — Barra atuar sobre registro incorreto

A seleção visual deve corresponder exatamente ao ID enviado ao backend.

Impacto:

**ALTO**

---

# 63. Risco — Abrir detalhe sem mestre selecionado

Em estruturas master-detail, é necessário contexto.

Exemplo:

~~~text
Subgrupos
→ exige Grupo selecionado
~~~

Impacto:

**MÉDIO**

---

# 64. Risco — Sobretela carregar filhos de outro mestre

Impacto:

**CRÍTICO**

Ao abrir:

~~~text
Grupo A
→ Subgrupos
~~~

a consulta não pode retornar filhos do Grupo B.

---

# 65. Risco — Consultar virar edição

A ação Consultar deve ser somente leitura.

Impacto:

**MÉDIO**

Não disponibilizar alteração acidental em modal de consulta.

---

# 66. Risco — Consulta abandonar contexto desnecessariamente

O padrão homologado usa sobretela/modal quando aplicável.

Impacto:

**BAIXO/MÉDIO**

Preservar contexto da listagem melhora operação.

---

# 67. Risco — Alterar padrão visual apenas em uma tela

Os auxiliares modernizados devem manter coerência.

Impacto:

**MÉDIO**

Mudanças isoladas podem fragmentar a experiência do SYSVAR.

---

# 68. Risco — Transformar Cadastro Auxiliar em Processo Operacional

Exemplo incorreto:

~~~text
Cadastro de Unidade
→ editar saldo
~~~

Outro:

~~~text
Cadastro de Material
→ realizar consumo produtivo
~~~

Impacto:

**ALTO**

Cada módulo deve preservar sua responsabilidade.

---

# 69. Risco — Criar Estoque no Cadastro Auxiliar

Nenhum auxiliar deve armazenar saldo operacional diretamente.

Impacto:

**CRÍTICO**

Saldo pertence ao domínio de Estoque.

---

# 70. Risco — Criar Pedido dentro de Pack

Pack define composição.

Pedido registra operação.

Impacto:

**ALTO**

~~~text
Pack
!=
Pedido de Compra
~~~

---

# 71. Risco — Criar SKU dentro de Grade

Grade fornece Tamanhos.

Produto Venda cria suas variações.

Impacto:

**ALTO**

~~~text
Grade
!=
Produto
~~~

---

# 72. Risco — Criar Referência dentro de Grupo

Grupo fornece o Código de Referência.

Produto Venda é responsável pela identidade completa.

Impacto:

**ALTO**

~~~text
Grupo
fornece CC

Produto Venda
gera AA-BB-CCDDD
~~~

---

# 73. Risco — Regra Compartilhada quebrar outros tipos de Produto

Alterações nos Cadastros Auxiliares podem afetar:

- Produto Venda;
- Produto Uso/Consumo;
- Insumos.

Impacto:

**CRÍTICO**

Antes de mudar uma estrutura compartilhada, revisar consumidores.

---

# 74. Risco — Obrigar todos os Produtos a usar todos os auxiliares

Nem todo Produto utiliza:

- Grade;
- Cor;
- Coleção;
- Pack;
- Grupo;
- Material.

Impacto:

**CRÍTICO**

Cada domínio utiliza somente o que lhe pertence.

---

# 75. Risco — Produto Uso/Consumo herdar estrutura comercial

Não exigir automaticamente:

- Grade;
- Cor;
- Pack;
- Coleção.

Impacto:

**ALTO**

Referência:

[[Homologação - Produtos - Produto Uso e Consumo]]

---

# 76. Risco — Insumo herdar estrutura comercial

Não exigir:

- Grade comercial;
- Pack;
- Coleção;
- Cor × Tamanho comercial.

Impacto:

**ALTO**

Referência:

[[Homologação - Produtos - Insumos]]

---

# 77. Risco — Produto Venda perder auxiliares necessários

O inverso também é perigoso.

Produto Venda depende de estruturas como:

- Grupo;
- Grade;
- Coleção;
- Cor;
- Pack.

Impacto:

**CRÍTICO**

Referência:

[[Homologação - Produtos - Produto Venda]]

---

# 78. Risco — Migration sem considerar dependências

Alterações de banco em auxiliares podem atingir registros já utilizados.

Impacto:

**CRÍTICO**

Cuidados:

- revisar dados existentes;
- evitar defaults inválidos;
- preservar ForeignKeys;
- testar migrations;
- não assumir banco vazio.

---

# 79. Risco — Mudança de unicidade sem saneamento prévio

Adicionar constraint em base contendo duplicidades pode falhar.

Impacto:

**ALTO**

Antes da migration:

1. identificar duplicidades;
2. corrigir dados;
3. aplicar constraint.

---

# 80. Risco — Remover constraint de unicidade

Retirar proteção pode permitir dados inválidos.

Impacto:

**ALTO/CRÍTICO**

Exemplos sensíveis:

- Código de Referência;
- Código de Unidade;
- Tamanho por Pack.

---

# 81. Risco — Validação apenas no Serializer

Para regras críticas, também deve existir integridade estrutural adequada quando aplicável.

Impacto:

**ALTO**

A camada correta depende da regra:

~~~text
UX
Serializer
Service
Model
Banco
~~~

Cada uma possui responsabilidade própria.

---

# 82. Risco — Mensagem de erro genérica

Exemplo ruim:

~~~text
Erro ao salvar
~~~

Impacto:

**MÉDIO**

Quando possível, informar:

~~~text
Código de Referência já utilizado.
~~~

ou:

~~~text
Este Tamanho já existe no Pack.
~~~

---

# 83. Risco — Alterar Tabela de Preço como se fosse Auxiliar Estrutural

Tabela de Preço participou da padronização visual, mas pertence ao domínio comercial.

Impacto:

**MÉDIO/ALTO**

Não misturar regras estruturais deste documento com precificação.

---

# 84. Risco — Alterar Promoção como se fosse Auxiliar Estrutural

Promoção também é funcionalidade comercial.

Impacto:

**MÉDIO/ALTO**

Compartilhar padrão visual não significa compartilhar domínio.

---

# 85. Checklist — Grupo/Subgrupo

Antes de alterar:

1. Código continua único?
2. Código de Referência continua com 2 dígitos?
3. Código de Referência continua único por Empresa?
4. Subgrupo continua dependente do Grupo?
5. cross-tenant continua bloqueado?
6. exclusão continua protegida?
7. Referências históricas não serão recalculadas?

---

# 86. Checklist — Grade/Tamanho

Verificar:

1. Tamanho continua ligado à Grade?
2. Grade utilizada está protegida?
3. SKUs existentes permanecem válidos?
4. Packs existentes permanecem válidos?
5. exclusão está protegida?
6. tela continua master-detail?
7. barra de ações continua no padrão homologado?

---

# 87. Checklist — Coleção

Verificar:

1. Código possui 2 dígitos?
2. Estação está entre 01 e 04?
3. Status pertence ao conjunto oficial?
4. contador permanece interno?
5. sequência não será reutilizada?
6. Referências existentes permanecem estáveis?
7. exclusão está protegida?

---

# 88. Checklist — Unidade

Verificar:

1. Código continua único?
2. `permite_decimal` continua correto?
3. processos consumidores respeitam a regra?
4. Unidade já utilizada pode ser alterada com segurança?
5. exclusão está protegida?
6. nenhuma quantidade foi colocada dentro do cadastro de Unidade?

---

# 89. Checklist — Cor

Verificar:

1. Código continua único quando utilizado?
2. Cor continua separada de SKU?
3. Produtos/SKUs existentes permanecem íntegros?
4. exclusão está protegida?

---

# 90. Checklist — Material

Verificar:

1. Código permanece consistente?
2. lifecycle Ativo/Inativo continua válido?
3. Material continua opcional para Insumo?
4. não foi transformado em entidade de Estoque?
5. exclusão está protegida?

---

# 91. Checklist — Pack/Itens

Verificar:

1. Pack possui Grade?
2. Grade pertence ao tenant correto?
3. Nome está preenchido?
4. Tamanho pertence à Grade?
5. Tamanho não está duplicado?
6. Quantidade é maior que zero?
7. Pack utilizado está protegido?
8. Pedidos históricos não serão recalculados?

---

# 92. Checklist — Interface

Verificar:

1. seleção continua única?
2. checkbox corresponde ao registro ativo?
3. linha selecionada está destacada?
4. barra de ações está presente?
5. coluna `Ações` não foi reintroduzida?
6. menu `⋮` não foi reintroduzido?
7. Consultar é somente leitura?
8. master-detail abre no contexto correto?
9. modal preserva o mestre?
10. permissões continuam funcionando?

---

# 93. Regras que Não Devem Ser Reintroduzidas

Não reintroduzir sem nova decisão:

1. coluna `Ações` nas telas já modernizadas;
2. menu `⋮` redundante;
3. seleção múltipla para ações individuais;
4. Subgrupo independente do Grupo;
5. Tamanho independente da Grade;
6. Pack sem Grade;
7. Tamanho duplicado no Pack;
8. quantidade zero ou negativa;
9. edição manual do contador da Coleção;
10. códigos de Referência fora de 2 dígitos;
11. cross-tenant;
12. exclusão destrutiva de estruturas utilizadas;
13. histórico individual sofisticado desnecessário;
14. responsabilidades operacionais dentro dos auxiliares.

---

# 94. Baseline Homologada

A baseline funcional é:

[[Homologação - Produtos - Cadastros Auxiliares]]

A baseline técnica é:

[[Mapa Técnico - Produtos - Cadastros Auxiliares]]

Os fluxos são:

[[Workflows - Produtos - Cadastros Auxiliares]]

O modelo conceitual é:

[[Modelo de Domínio - Produtos - Cadastros Auxiliares]]

Esses documentos devem ser avaliados em conjunto antes de mudanças estruturais.

---

# 95. Estado Final

**Cadastros Auxiliares de Produtos estão IMPLEMENTADOS E HOMOLOGADOS.**

Os principais cuidados são:

- preservar multiempresa;
- preservar unicidades;
- proteger estruturas já utilizadas;
- manter mestre e detalhe corretamente relacionados;
- preservar a Referência histórica dos Produtos;
- respeitar `permite_decimal`;
- preservar Packs históricos;
- impedir exclusões destrutivas;
- manter o padrão visual de seleção e barra de ações;
- não transformar auxiliares em processos operacionais.

A regra central continua sendo:

~~~text
CADASTRO AUXILIAR
define estrutura.

PRODUTO
usa essa estrutura.

PROCESSO OPERACIONAL
usa o Produto.

Alterar um auxiliar
pode afetar muitos registros,
mesmo quando a tela parece simples.
~~~

---

# 96. Navegação Documental

## Cadastros Auxiliares

- [[Homologação - Produtos - Cadastros Auxiliares]]
- [[Mapa Técnico - Produtos - Cadastros Auxiliares]]
- [[Workflows - Produtos - Cadastros Auxiliares]]
- [[Modelo de Domínio - Produtos - Cadastros Auxiliares]]

## Produtos

- [[Homologação - Produtos - Produto Venda]]
- [[Homologação - Produtos - Produto Uso e Consumo]]
- [[Homologação - Produtos - Insumos]]

## Projeto

- [[Sysvar]]