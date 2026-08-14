---
type: domain-model
status: approved
project: Sysvar
group: Produtos
module: Insumos
phase: Fase 1
created: 2026-08-14
updated: 2026-08-14
tags:
  - sysvar
  - produtos
  - insumos
  - produção
  - ficha-técnica
  - estoque
  - compras
  - fiscal
  - custos
  - auditoria
  - multiempresa
  - domínio
  - homologado
---

# Modelo de Domínio - Produtos - Insumos

## 1. Identificação

- **Projeto:** [[Sysvar]]
- **Módulo:** Produtos
- **Funcionalidade:** Insumos
- **Tipo interno:** `tipo_produto = '4'`
- **Escopo:** Fase 1 — Cadastro e gestão estrutural
- **Situação:** IMPLEMENTADO E HOMOLOGADO
- **Decisões funcionais aprovadas:** 34
- **Data de consolidação documental:** 14/08/2026

### Documentos relacionados

- [[Sysvar]]
- [[Homologação - Produtos - Insumos]]
- [[Mapa Técnico - Produtos - Insumos]]
- [[Workflows - Produtos - Insumos]]
- [[Riscos e Cuidados - Produtos - Insumos]]
- [[Homologação - Produtos - Produto Venda]]
- [[Homologação - Produtos - Produto Uso e Consumo]]
- [[Homologação - Produtos - Cadastros Auxiliares]]

---

# 2. Objetivo do Modelo de Domínio

O domínio de **Insumos** representa os materiais utilizados direta ou operacionalmente na fabricação dos Produtos Venda de Fabricação Própria do [[Sysvar]].

Seu objetivo é fornecer uma identidade cadastral consistente para materiais como:

- tecidos;
- linhas;
- botões;
- zíperes;
- etiquetas;
- elásticos;
- aviamentos;
- componentes diversos de produção.

O Insumo define:

- qual é o material;
- a qual Empresa pertence;
- como é identificado;
- qual sua Unidade;
- qual sua classificação opcional;
- quais informações fiscais possui;
- qual sua situação;
- quais custos estão associados quando provenientes de eventos reais.

O cadastro de Insumo não define:

- quantidade necessária para cada Produto;
- saldo disponível;
- localização física;
- reserva;
- consumo produtivo;
- perda;
- material em poder de facção.

Essas responsabilidades pertencem a outros domínios.

---

# 3. Agregado Principal

A entidade central permanece:

`Produto`

O domínio é definido por:

~~~text
tipo_produto = '4'
~~~

Conceitualmente:

~~~text
Empresa
   ↓
Produto / Insumo
   ├── Código
   ├── Descrição
   ├── Descrição reduzida
   ├── Unidade
   ├── Material opcional
   ├── NCM / Fiscal
   ├── Custos
   ├── Status
   └── Auditoria
~~~

Relacionamentos operacionais:

~~~text
Insumo
   ├── Compras
   ├── Recebimento
   ├── Estoque
   ├── Movimentações
   ├── Ficha Técnica
   └── Produção futura
~~~

---

# 4. Separações Fundamentais

Devem permanecer distintas:

~~~text
Insumo != Produto Venda
Insumo != Produto Uso/Consumo

Insumo != Estoque
Insumo != Movimento
Insumo != Ficha Técnica
Insumo != Ordem de Produção

Cadastro do Insumo != Localização Física
Cadastro do Insumo != Quantidade Consumida
Cadastro do Insumo != Quantidade Necessária

Ativo != Possui Saldo
Inativar != Excluir
~~~

---

# 5. Empresa

Todo Insumo pertence ao contexto de uma Empresa.

Relacionamento conceitual:

~~~text
Empresa 1:N Insumo
~~~

A Empresa determina o tenant.

Devem respeitar esse mesmo contexto:

- Insumo;
- Unidade;
- Material;
- dados fiscais;
- Compras;
- Estoque;
- Fichas Técnicas;
- movimentos;
- Auditoria;
- demais relações empresariais.

---

# 6. Isolamento Multiempresa

Não pode existir associação indevida entre Empresas.

Exemplo inválido:

~~~text
Produto fabricado Empresa A
        +
Insumo Empresa B
~~~

Também é inválido:

~~~text
Insumo Empresa A
        +
Unidade exclusiva Empresa B
~~~

O backend deve validar todos os relacionamentos.

---

# 7. Tipo do Produto

O discriminador interno é:

~~~text
tipo_produto = '4'
~~~

Esse valor diferencia Insumos de:

~~~text
1 = Revenda
2 = Uso/Consumo
3 = Fabricação Própria
~~~

O tipo deve permanecer estável durante o ciclo de vida do registro.

---

# 8. Identidade do Insumo

A identidade cadastral é composta principalmente por:

- ID interno;
- Empresa;
- tipo;
- código;
- descrição.

O código deve permanecer estável após a criação.

Editar o Insumo não deve alterar sua identidade.

---

# 9. Código

O código do Insumo é controlado pela implementação vigente do backend.

Regras estruturais:

- deve ser único no contexto aplicável;
- não deve depender do frontend para geração segura;
- não deve mudar durante edição normal;
- não deve ser reutilizado de forma indevida.

---

# 10. Descrição

A descrição identifica o material.

Exemplos:

~~~text
Tecido Jeans Azul
Linha Poliéster Branca
Botão Plástico Preto 15 mm
Zíper Metálico 20 cm
Etiqueta de Composição
~~~

A descrição pertence à identidade funcional do Insumo.

---

# 11. Descrição Reduzida

Quando disponível na estrutura compartilhada de Produto, a descrição reduzida serve para apresentação compacta.

Ela não substitui a descrição principal.

---

# 12. Unidade

Unidade é um dos conceitos centrais do domínio de Insumos.

Relacionamento:

~~~text
Insumo N:1 Unidade
~~~

Exemplos:

- M;
- KG;
- G;
- UN;
- PC;
- CX;
- LT.

A Unidade representa **como o material é quantificado**.

---

# 13. Unidade e Decimal

A Unidade pode possuir a característica:

`permite_decimal`

Conceitualmente:

~~~text
Unidade M
permite_decimal = true
        ↓
1,75 M

Unidade UN
permite_decimal = false
        ↓
6 UN
~~~

Essa característica deve ser respeitada pelos processos que informam quantidade.

---

# 14. Material

Material é uma classificação opcional do Insumo.

Relacionamento conceitual:

~~~text
Insumo N:1 Material
ou
Insumo → Material opcional
~~~

Exemplo:

~~~text
Material:
Algodão

Insumo:
Tecido Tricoline Branco
~~~

---

# 15. Material não é Estoque

Material não representa a entidade física movimentada.

~~~text
Material
→ classificação

Insumo
→ item operacional
~~~

Compras, Estoque e Produção devem utilizar a identidade do Insumo.

---

# 16. Material não substitui Unidade

Material responde:

~~~text
Do que é feito / como é classificado?
~~~

Unidade responde:

~~~text
Como é quantificado?
~~~

São conceitos independentes.

---

# 17. Ausência de Grade

Insumos não possuem Grade comercial obrigatória.

Não existe relação:

~~~text
Insumo
   ↓
Grade
   ↓
PP / P / M / G / GG
~~~

como estrutura padrão do domínio.

---

# 18. Ausência de Tamanho Comercial

O domínio não utiliza automaticamente variações de Tamanho como Produto Venda.

Caso uma dimensão física identifique materiais diferentes, essa distinção deve fazer parte da identidade cadastral adequada do Insumo.

Exemplo:

~~~text
Zíper 15 cm
Zíper 20 cm
Zíper 25 cm
~~~

podem ser materiais distintos, sem necessidade de Grade comercial.

---

# 19. Ausência de Cor × Tamanho Comercial

Não existe geração automática:

~~~text
Insumo
+
Cor
+
Tamanho
=
SKU comercial
~~~

Essa regra pertence ao Produto Venda.

---

# 20. Ausência de SKU Comercial

Insumo é a entidade operacional utilizada em:

- Compras;
- Estoque;
- Ficha Técnica;
- Produção.

Não deve ser criado `ProdutoDetalhe` em massa apenas por analogia ao Produto Venda.

---

# 21. Ausência de Coleção

Insumos não dependem de Coleção.

Não possuem obrigação de:

- ano;
- estação;
- coleção de moda;
- referência `AA-BB-CCDDD`.

---

# 22. Ausência de Tabela de Preço

Insumos não possuem preço de venda obrigatório.

O valor relevante é custo.

Não precisam participar de Tabela de Preço comercial.

---

# 23. Ausência de Promoção

Insumos não integram Promoções destinadas ao consumidor.

---

# 24. Ausência de PDV

Insumos não fazem parte do conjunto normal de Produtos vendáveis no PDV.

~~~text
tipo_produto = '4'
→ não comercializável no PDV
~~~

---

# 25. NCM

O Insumo pode possuir NCM quando aplicável.

Relacionamento conceitual:

~~~text
Insumo
   ↓
NCM
~~~

NCM é relevante especialmente para:

- Compras;
- Entrada Fiscal;
- classificação tributária.

---

# 26. Dados Fiscais

O domínio utiliza a estrutura fiscal compartilhada do Produto quando aplicável.

Pode incluir:

- NCM;
- origem;
- ICMS;
- CST/CSOSN;
- CFOP;
- PIS;
- COFINS;
- IPI.

O cadastro armazena informação fiscal.

A operação fiscal valida sua utilização.

---

# 27. Estoque

Todo Insumo possui natureza de controle de Estoque.

Entretanto:

~~~text
Insumo != Estoque
~~~

O Insumo representa identidade.

O Estoque representa:

- quantidade;
- localização;
- entradas;
- saídas;
- saldo.

---

# 28. Ausência de `controla_estoque`

Não pertence ao domínio homologado:

~~~text
controla_estoque = true/false
~~~

Insumo é naturalmente um material controlável em Estoque.

---

# 29. Localização

A localização não pertence ao cadastro do Insumo.

Não deve existir vínculo fixo obrigatório com:

- Matriz;
- fábrica;
- Loja;
- almoxarifado;
- depósito;
- facção.

A localização pertence ao contexto operacional.

---

# 30. Movimento de Estoque

Movimento relaciona:

~~~text
Insumo
Quantidade
Local
Tipo de Movimento
Data
Contexto Operacional
~~~

Exemplos:

- entrada por Compra;
- transferência;
- saída produtiva futura;
- ajuste;
- inventário;
- devolução.

---

# 31. Saldo

Saldo é consequência de movimentos:

~~~text
Entradas
-
Saídas
=
Saldo
~~~

Não deve ser digitado ou criado no cadastro principal do Insumo.

---

# 32. Compras

Insumo pode ser Item de Pedido de Compra.

Relacionamento conceitual:

~~~text
Pedido de Compra
   ↓
Item
   ↓
Insumo
~~~

Compras é responsável por:

- Fornecedor;
- quantidade;
- preço;
- desconto;
- aprovação;
- recebimento;
- integração financeira.

---

# 33. Recebimento

O recebimento transforma a aquisição em evento físico.

~~~text
Pedido
   ↓
Recebimento
   ↓
Insumo
   ↓
Entrada de Estoque
~~~

Pode também produzir atualização de custos.

---

# 34. Entrada Fiscal

Insumos podem participar de documentos fiscais de entrada.

A Entrada Fiscal é responsável por:

- validar documento;
- validar dados tributários necessários;
- identificar Empresa;
- processar quantidade;
- gerar efeitos de Estoque;
- gerar demais integrações.

---

# 35. Custos

Insumos possuem custo operacional.

Conceitos possíveis:

- custo original;
- custo da última compra;
- custo médio.

Esses valores devem ser originados por eventos reais.

---

# 36. Custo não é Preço de Venda

Separação:

~~~text
Custo do Insumo
→ quanto o material custa para a empresa

Preço de Venda
→ valor cobrado do cliente
~~~

Insumos trabalham com o primeiro conceito.

---

# 37. Ficha Técnica

A principal relação produtiva do Insumo é com a:

**Ficha Técnica**

Conceitualmente:

~~~text
Produto de Fabricação Própria
        ↓
Ficha Técnica
        ↓
Itens
        ↓
Insumos
~~~

---

# 38. Relação Ficha Técnica × Insumo

A Ficha Técnica associa:

- Produto fabricado;
- Insumo;
- quantidade necessária.

Conceitualmente:

~~~text
FichaTecnica
    ↓
FichaTecnicaItem
    ├── Insumo
    └── Quantidade
~~~

Os nomes técnicos reais devem seguir a implementação existente do módulo Produção.

---

# 39. Quantidade não Pertence ao Insumo

A quantidade necessária para produção não é propriedade do Insumo.

Exemplo:

~~~text
Insumo:
Tecido Oxford

Camisa:
1,80 M

Vestido:
2,40 M
~~~

A quantidade depende da Ficha Técnica.

---

# 40. Mesmo Insumo em Vários Produtos

Relacionamento:

~~~text
Insumo 1:N FichaTecnicaItem
~~~

Um material pode ser usado em múltiplos Produtos.

Não duplicar cadastro para cada aplicação.

---

# 41. Produto de Fabricação Própria

A relação produtiva principal ocorre com:

~~~text
tipo_produto = '3'
~~~

Documentação:

[[Homologação - Produtos - Produto Venda]]

Fluxo:

~~~text
Insumos
   ↓
Ficha Técnica
   ↓
Produto Venda / Fabricação Própria
~~~

---

# 42. Produto de Revenda

Produto de Revenda:

~~~text
tipo_produto = '1'
~~~

não necessita de Ficha Técnica para seu abastecimento normal.

Seu fluxo principal é aquisição do Produto pronto.

---

# 43. Produto Uso/Consumo

Produto Uso/Consumo:

~~~text
tipo_produto = '2'
~~~

possui finalidade diferente.

~~~text
Uso/Consumo
→ consumo interno não produtivo

Insumo
→ consumo produtivo
~~~

Referência:

[[Homologação - Produtos - Produto Uso e Consumo]]

---

# 44. Ordem de Produção

A Ordem de Produção pode utilizar a Ficha Técnica para identificar necessidades.

~~~text
OP
 ↓
Produto Fabricação Própria
 ↓
Ficha Técnica
 ↓
Insumos previstos
~~~

A OP não altera a identidade do Insumo.

---

# 45. Necessidade Teórica

A necessidade teórica pode ser calculada conceitualmente por:

~~~text
Quantidade por peça
×
Quantidade a produzir
=
Necessidade teórica
~~~

Exemplo:

~~~text
1,80 M
×
100 peças
=
180 M
~~~

Esse cálculo pertence ao domínio de Produção.

---

# 46. Criação da OP não Significa Consumo

Uma invariável importante:

~~~text
OP criada
!=
Insumo consumido
~~~

A criação da OP não representa automaticamente uma saída física.

---

# 47. OP não Reserva Automaticamente nesta Fase

Também não existe como regra homologada:

~~~text
OP criada
=
Reserva imediata de Insumos
~~~

A reserva deverá ser definida quando o processo produtivo for detalhado.

---

# 48. Consumo Previsto

A Ficha Técnica representa:

~~~text
Consumo previsto
~~~

Esse valor pode ser usado para:

- planejamento;
- necessidade;
- estimativa de custo.

Não significa consumo real.

---

# 49. Consumo Real

Consumo real deverá ser resultado de movimentos produtivos.

~~~text
Movimento real
        ↓
Quantidade consumida
~~~

O momento de registro ainda pertence à evolução do módulo Produção.

---

# 50. Desvio de Consumo

Futuramente poderá existir:

~~~text
Consumo Real
-
Consumo Previsto
=
Desvio
~~~

Esse conceito poderá apoiar:

- análise de perda;
- eficiência;
- custos;
- produtividade.

Não pertence ao cadastro de Insumo.

---

# 51. Facção

Produção por facção poderá utilizar Insumos em fluxos futuros.

Conceitualmente:

~~~text
Estoque da Empresa
        ↓
Envio
        ↓
Material em poder da Facção
        ↓
Produção
        ↓
Sobra / Retorno / Consumo
~~~

O cadastro permanece inalterado.

---

# 52. Estoque em Poder de Terceiro

Se implementado, deve ser tratado como conceito operacional de Estoque.

Não criar campo:

~~~text
facção_atual
~~~

no cadastro do Insumo para representar localização temporária.

---

# 53. Perdas

Perda não é propriedade fixa do Insumo.

Pode depender:

- do Produto;
- da operação;
- da Ficha Técnica;
- do processo produtivo;
- da facção.

Portanto deve ser modelada no contexto apropriado.

---

# 54. Sobras

Sobra também representa evento operacional.

Não alterar o cadastro para registrar quantidade de sobra.

Deve gerar ou resultar de movimentos adequados.

---

# 55. Conversão de Unidade

A conversão entre Unidade de Compra e Unidade de Consumo não foi definida nesta fase.

Exemplo:

~~~text
Compra:
1 rolo

Produção:
consumo em metros
~~~

Uma futura solução deverá possuir fator de conversão explícito.

---

# 56. Lifecycle

O lifecycle cadastral é:

~~~text
ATIVO
  ↕
INATIVO
~~~

Não existe bloqueio de venda.

---

# 57. Ativo

Insumo Ativo pode participar de novas operações permitidas.

Exemplos:

- Pedido de Compra;
- nova Ficha Técnica;
- movimentos.

---

# 58. Inativo

Insumo Inativo permanece no sistema.

Não deve ser selecionado normalmente para novas operações.

Entretanto, deve permanecer visível em relações históricas.

---

# 59. Reativação

Reativar utiliza a mesma entidade.

Preserva:

- ID;
- código;
- Empresa;
- histórico;
- relacionamentos.

---

# 60. Exclusão

Exclusão é possível apenas quando segura.

A entidade não deve ser fisicamente removida quando houver relações que necessitem preservação.

---

# 61. Exclusão Protegida por Ficha Técnica

Se existir relação:

~~~text
Ficha Técnica
        ↓
Insumo
~~~

a exclusão deve respeitar integridade referencial e histórica.

A solução operacional preferencial é:

**Inativar**

---

# 62. Exclusão Protegida por Compras

Se o Insumo já participou de Pedido ou recebimento, sua identidade pode ser necessária para histórico.

Não destruir a relação.

---

# 63. Exclusão Protegida por Estoque

Insumo com saldo ou movimentos não deve ser simplesmente apagado.

Impactaria rastreabilidade.

---

# 64. Auditoria

O domínio deve preservar Auditoria Central para ações relevantes.

Conceitualmente:

~~~text
Usuário
   ↓
Ação
   ↓
Insumo
   ↓
AuditLog
~~~

Eventos:

- criação;
- edição;
- ativação;
- inativação;
- exclusão quando permitida.

---

# 65. Histórico Individual

Não foi aprovada nesta fase uma estrutura sofisticada adicional de histórico funcional específico para Insumos.

Isso deve ser preservado para evitar expansão desnecessária.

Auditoria existente permanece suficiente nesta etapa.

---

# 66. Consulta

A consulta representa projeção da entidade e de informações relacionadas.

Pode apresentar:

~~~text
Insumo
  ├── Identificação
  ├── Unidade
  ├── Material
  ├── Fiscal
  ├── Custos
  └── Status
~~~

Não deve incluir seções de Produto Venda sem aplicabilidade.

---

# 67. Edição

Na edição devem permanecer invariantes:

~~~text
ID
Empresa
tipo_produto = '4'
código
~~~

Campos permitidos podem ser alterados conforme regras vigentes.

---

# 68. Paginação

Paginação pertence à camada de consulta.

A base de Insumos deve ser paginada sem alterar o domínio.

---

# 69. Filtros

Filtros são projeções.

Podem considerar:

- código;
- descrição;
- Unidade;
- Material;
- NCM;
- status.

Sempre limitados por:

~~~text
Empresa
+
tipo_produto = '4'
~~~

---

# 70. Permissões

Permissões controlam as ações sobre o domínio.

Operações:

- consultar;
- criar;
- editar;
- ativar;
- inativar;
- excluir quando permitido.

A autorização final pertence ao backend.

---

# 71. Cadastros Auxiliares

Insumos utilizam principalmente:

- Unidade;
- Material;
- NCM.

Referência:

[[Homologação - Produtos - Cadastros Auxiliares]]

Esses relacionamentos devem respeitar multiempresa quando aplicável.

---

# 72. Modelo Conceitual Simplificado

~~~text
                        ┌─────────────┐
                        │   Empresa   │
                        └──────┬──────┘
                               │
                               ↓
                     ┌─────────────────┐
                     │     Insumo      │
                     │ tipo = '4'      │
                     └───────┬─────────┘
                             │
          ┌──────────────────┼────────────────────┐
          │                  │                    │
          ↓                  ↓                    ↓
       Unidade            Material              Fiscal
          │               opcional                │
          │                                       │
          └──────────────────┬────────────────────┘
                             │
                ┌────────────┼─────────────┐
                │            │             │
                ↓            ↓             ↓
             Compras      Estoque      Ficha Técnica
                │            │             │
                ↓            ↓             ↓
          Recebimento    Movimentos    Produto tipo 3
                │                          │
                ↓                          ↓
              Custos                  Produção / OP