---
type: workflows
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
  - workflows
  - auditoria
  - multiempresa
  - homologado
---

# Workflows - Produtos - Insumos

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
- [[Modelo de Domínio - Produtos - Insumos]]
- [[Riscos e Cuidados - Produtos - Insumos]]
- [[Homologação - Produtos - Produto Venda]]
- [[Homologação - Produtos - Produto Uso e Consumo]]
- [[Homologação - Produtos - Cadastros Auxiliares]]

---

# 2. Objetivo

Este documento descreve os principais fluxos funcionais e operacionais do cadastro de **Insumos** do [[Sysvar]].

Insumos representam materiais utilizados diretamente na fabricação dos Produtos Venda de Fabricação Própria.

Os workflows documentados abrangem:

- abertura da listagem;
- filtros;
- paginação;
- criação;
- código;
- Unidade;
- Material opcional;
- dados fiscais;
- consulta;
- edição;
- ativação;
- inativação;
- exclusão protegida;
- Compras;
- recebimento;
- Estoque;
- custos;
- Ficha Técnica;
- relação entre quantidade e Unidade;
- preparação para Produção;
- limites atuais da integração com Ordem de Produção;
- isolamento multiempresa;
- Auditoria.

As regras homologadas estão registradas em:

[[Homologação - Produtos - Insumos]]

A estrutura técnica correspondente está em:

[[Mapa Técnico - Produtos - Insumos]]

O domínio correspondente está em:

[[Modelo de Domínio - Produtos - Insumos]]

---

# 3. Princípios Gerais dos Workflows

Todo fluxo de Insumos deve respeitar:

1. backend é autoridade das regras;
2. todo Insumo pertence ao contexto de uma Empresa;
3. isolamento multiempresa é obrigatório;
4. `tipo_produto = '4'`;
5. Insumo é diferente de Produto Venda;
6. Insumo é diferente de Produto Uso/Consumo;
7. Unidade é relevante para o controle do material;
8. Material é opcional;
9. Insumo não utiliza Grade comercial;
10. não utiliza Cor × Tamanho comercial;
11. não exige SKU comercial de Produto Venda;
12. não depende de Coleção;
13. não depende de Tabela de Preço de venda;
14. não participa do PDV;
15. possui natureza de Estoque;
16. cadastro não define localização;
17. pode participar de Compras;
18. participa de Ficha Técnica;
19. quantidade produtiva pertence à relação da Ficha Técnica;
20. Ordem de Produção não deve baixar Estoque apenas por ser criada;
21. reserva automática pela OP não foi definida nesta fase;
22. lifecycle é Ativo/Inativo;
23. exclusão deve ser protegida;
24. Auditoria deve ser preservada;
25. filtros e paginação devem seguir o padrão server-side quando implementado.

---

# 4. Workflow — Abrir Insumos

~~~text
Usuário acessa Produtos
        ↓
Seleciona Insumos
        ↓
Frontend verifica acesso
        ↓
Solicita primeira página
        ↓
Backend identifica Empresa
        ↓
Restringe tipo_produto = '4'
        ↓
Aplica filtros
        ↓
Aplica paginação
        ↓
Retorna registros
        ↓
Frontend apresenta listagem
~~~

A tela deve apresentar apenas registros do domínio de Insumos.

---

# 5. Workflow — Listagem Server-Side

~~~text
Frontend
   ↓
Solicita lista de Insumos
   ↓
Parâmetros:
- página
- tamanho da página
- busca
- código
- descrição
- unidade
- material
- NCM
- status
- ordenação
   ↓
Backend
   ↓
Aplica Empresa
   ↓
Aplica tipo 4
   ↓
Aplica filtros
   ↓
Aplica ordenação
   ↓
Aplica paginação
   ↓
Retorna results + count
~~~

Não carregar a base inteira apenas para paginar no navegador.

---

# 6. Workflow — Busca Geral

~~~text
Usuário informa termo
        ↓
Frontend envia busca
        ↓
Backend aplica Empresa
        ↓
Backend restringe tipo 4
        ↓
Pesquisa campos suportados
        ↓
Retorna página correspondente
~~~

A busca não deve misturar outros tipos de Produto.

---

# 7. Workflow — Novo Insumo

~~~text
Usuário clica Novo
        ↓
Frontend abre formulário
        ↓
Define tipo_produto = '4'
        ↓
Usuário informa dados cadastrais
        ↓
Frontend envia criação
        ↓
Backend identifica Empresa
        ↓
Valida campos obrigatórios
        ↓
Valida Unidade
        ↓
Valida Material, se informado
        ↓
Valida Fiscal informado
        ↓
Gera/atribui código conforme implementação
        ↓
Salva
        ↓
Registra Auditoria
        ↓
Retorna Insumo criado
~~~

---

# 8. Workflow — Código do Insumo

O código deve ser gerenciado pelo backend conforme a implementação homologada.

Fluxo conceitual:

~~~text
Nova solicitação
        ↓
Backend identifica Empresa
        ↓
Obtém próxima identidade válida
        ↓
Gera código
        ↓
Valida unicidade
        ↓
Persiste
~~~

O frontend não deve controlar sequência paralela.

---

# 9. Workflow — Descrição

~~~text
Usuário informa descrição
        ↓
Frontend envia
        ↓
Backend valida
        ↓
Descrição válida?
   ├── Sim → continuar
   └── Não → rejeitar
~~~

A descrição deve identificar claramente o material.

---

# 10. Workflow — Unidade

~~~text
Frontend solicita Unidades disponíveis
        ↓
Backend aplica contexto permitido
        ↓
Usuário seleciona Unidade
        ↓
Frontend envia ID
        ↓
Backend valida relacionamento
        ↓
Unidade válida?
   ├── Sim → continuar
   └── Não → rejeitar
~~~

---

# 11. Workflow — Unidade com Quantidade Decimal

Quando a Unidade permitir decimal:

~~~text
Unidade permite_decimal = true
        ↓
Processos consumidores
        ↓
Podem utilizar quantidades fracionadas
~~~

Exemplo:

~~~text
Tecido
1,75 M
~~~

---

# 12. Workflow — Unidade sem Quantidade Decimal

Quando a Unidade não permitir decimal:

~~~text
Unidade permite_decimal = false
        ↓
Processo consumidor
        ↓
Quantidade inteira
~~~

Exemplo:

~~~text
Botão
6 UN
~~~

A validação deve ocorrer no processo que utiliza a quantidade.

---

# 13. Workflow — Material Opcional

~~~text
Usuário cadastra Insumo
        ↓
Deseja classificar por Material?
   ├── Sim → seleciona Material
   └── Não → mantém vazio
        ↓
Cadastro continua válido
~~~

Material não deve bloquear o cadastro.

---

# 14. Workflow — Material e Insumo

Exemplo:

~~~text
Material
Algodão
        ↓
Insumo
Tecido Tricoline Branco
~~~

Material classifica.

Insumo é o item operacional.

---

# 15. Workflow — Cadastro sem Grade

~~~text
Novo Insumo
        ↓
Não solicita Grade
        ↓
Não solicita Tamanhos
        ↓
Não gera combinações comerciais
        ↓
Salva entidade única
~~~

---

# 16. Workflow — Cadastro sem Cor × Tamanho

O fluxo proibido é:

~~~text
Insumo
   ↓
Selecionar Cor
   ↓
Selecionar Grade
   ↓
Gerar SKUs
~~~

Essa estrutura não pertence ao cadastro homologado de Insumos.

---

# 17. Workflow — Cadastro sem Coleção

~~~text
Novo Insumo
        ↓
Não exige Coleção
        ↓
Não exige Estação
        ↓
Não utiliza referência AA-BB-CCDDD
~~~

---

# 18. Workflow — Dados Fiscais

~~~text
Usuário informa dados fiscais
        ↓
Frontend envia
        ↓
Backend valida dados fornecidos
        ↓
Persiste informações
~~~

A estrutura deve utilizar os campos fiscais já existentes.

---

# 19. Workflow — NCM

~~~text
Usuário seleciona/informa NCM
        ↓
Frontend envia
        ↓
Backend valida
        ↓
NCM válido?
   ├── Sim → associar
   └── Não → rejeitar
~~~

---

# 20. Workflow — Consultar Insumo

~~~text
Usuário seleciona Insumo
        ↓
Clica Consultar
        ↓
Frontend obtém ID
        ↓
Solicita detalhe
        ↓
Backend valida Empresa
        ↓
Confirma tipo_produto = '4'
        ↓
Retorna dados atuais
        ↓
Frontend apresenta consulta
~~~

---

# 21. Workflow — Consulta Consolidada

A consulta deve apresentar dados pertinentes, como:

~~~text
Insumo
  ├── Identificação
  ├── Descrição
  ├── Unidade
  ├── Material
  ├── Fiscal
  ├── Custos
  ├── Status
  └── demais dados existentes
~~~

Não deve apresentar características comerciais sem aplicabilidade.

---

# 22. Workflow — Editar Insumo

~~~text
Usuário seleciona Insumo
        ↓
Clica Editar
        ↓
Frontend busca dados atuais pelo ID
        ↓
Backend valida Empresa e tipo
        ↓
Frontend abre edição
        ↓
Usuário altera campos permitidos
        ↓
Frontend envia
        ↓
Backend valida
        ↓
Salva
        ↓
Auditoria
        ↓
Atualiza listagem
~~~

---

# 23. Workflow — Preservar Tipo na Edição

~~~text
Insumo existente
tipo_produto = '4'
        ↓
Edição
        ↓
tipo permanece '4'
~~~

Não converter o Insumo em outro tipo.

---

# 24. Workflow — Ativar Insumo

~~~text
Insumo INATIVO
        ↓
Usuário solicita Ativar
        ↓
Backend valida:
- Empresa
- permissão
- tipo
        ↓
Atualiza status
        ↓
Auditoria
        ↓
Insumo ATIVO
~~~

---

# 25. Workflow — Inativar Insumo

~~~text
Insumo ATIVO
        ↓
Usuário solicita Inativar
        ↓
Backend valida:
- Empresa
- permissão
- tipo
        ↓
Atualiza status
        ↓
Auditoria
        ↓
Insumo INATIVO
~~~

Inativar preserva referências históricas.

---

# 26. Workflow — Excluir Insumo

~~~text
Usuário seleciona Insumo
        ↓
Solicita Excluir
        ↓
Frontend confirma
        ↓
Backend valida Empresa
        ↓
Backend valida permissão
        ↓
Backend verifica dependências
~~~

---

# 27. Workflow — Exclusão sem Dependências

~~~text
Insumo nunca utilizado
        ↓
Sem dependências
        ↓
Backend permite exclusão
        ↓
Auditoria
        ↓
Registro removido
~~~

---

# 28. Workflow — Exclusão com Dependências

~~~text
Insumo possui:
- Ficha Técnica
ou
- Compra
ou
- Estoque
ou
- Movimento
ou
- documento relacionado
        ↓
Solicitação de exclusão
        ↓
Backend bloqueia
        ↓
Usuário deve Inativar
~~~

---

# 29. Workflow — Compra de Insumo

~~~text
Insumo ATIVO
        ↓
Pedido de Compra
        ↓
Selecionar Insumo
        ↓
Fornecedor
        ↓
Quantidade
        ↓
Preço
        ↓
Pedido segue fluxo de Compras
~~~

As regras do Pedido pertencem ao módulo Compras.

---

# 30. Workflow — Recebimento de Insumo

~~~text
Pedido / Documento fiscal
        ↓
Recebimento
        ↓
Identifica Insumo
        ↓
Identifica Empresa
        ↓
Identifica local da operação
        ↓
Gera entrada
        ↓
Atualiza Estoque
        ↓
Atualiza custos quando aplicável
~~~

---

# 31. Workflow — Entrada no Estoque

~~~text
Recebimento confirmado
        ↓
Movimento de entrada
        ↓
Insumo
        ↓
Local definido pela operação
        ↓
Quantidade
        ↓
Novo saldo
~~~

O local não vem fixado no cadastro.

---

# 32. Workflow — Cadastro sem Localização

~~~text
Novo Insumo
        ↓
Cadastrar identidade
        ↓
NÃO escolher localização obrigatória
        ↓
Salvar
~~~

A localização nasce quando ocorre uma operação física.

---

# 33. Workflow — Saldo

~~~text
Movimentos de Entrada
        ↓
Movimentos de Saída
        ↓
Saldo resultante
~~~

O cadastro não possui ação para digitar saldo arbitrariamente.

---

# 34. Workflow — Custos

~~~text
Compra / Recebimento / Evento real
        ↓
Valor do Insumo
        ↓
Regra de custo vigente
        ↓
Atualização de custos
        ↓
Consulta passa a refletir valor
~~~

---

# 35. Workflow — Ficha Técnica

~~~text
Usuário acessa Produto de Fabricação Própria
        ↓
Abre Ficha Técnica
        ↓
Adiciona componente
        ↓
Sistema pesquisa Insumos ATIVOS
        ↓
Usuário seleciona Insumo
        ↓
Informa quantidade necessária
        ↓
Sistema valida quantidade/Unidade
        ↓
Salva Item da Ficha Técnica
~~~

---

# 36. Workflow — Quantidade na Ficha Técnica

A quantidade pertence ao relacionamento.

~~~text
Ficha Técnica
      +
Insumo
      +
Quantidade
~~~

Exemplo:

~~~text
Produto:
Camisa

Insumo:
Tecido Oxford

Quantidade:
1,80 M
~~~

---

# 37. Workflow — Mesmo Insumo em Diferentes Produtos

~~~text
Insumo: Linha Branca
        ↓
Ficha Camisa
12 M
        ↓
Ficha Vestido
18 M
        ↓
Ficha Blusa
9 M
~~~

Não duplicar o cadastro do Insumo.

---

# 38. Workflow — Cálculo de Necessidade Teórica

Conceitualmente:

~~~text
Quantidade por peça
        ×
Quantidade a produzir
        =
Necessidade teórica
~~~

Exemplo:

~~~text
1,80 M por camisa
×
100 camisas
=
180 M de tecido
~~~

Esse cálculo pertence à Produção/planejamento, não ao cadastro.

---

# 39. Workflow — Ordem de Produção Consulta Ficha Técnica

~~~text
Ordem de Produção
        ↓
Produto a fabricar
        ↓
Ficha Técnica vigente
        ↓
Itens da Ficha
        ↓
Insumos e quantidades previstas
~~~

---

# 40. Workflow — Criar OP sem Baixa Automática

O fluxo atual não deve presumir:

~~~text
Criar OP
        ↓
Baixar Estoque
~~~

A criação da OP por si só não define o momento de consumo.

---

# 41. Workflow — Criar OP sem Reserva Automática Obrigatória

Também não deve presumir:

~~~text
Criar OP
        ↓
Reservar automaticamente todos os Insumos
~~~

A reserva não foi definida neste escopo.

---

# 42. Workflow — Consumo Previsto

~~~text
Ficha Técnica
        ↓
Quantidade padrão
        ↓
OP
        ↓
Necessidade prevista
~~~

Esse valor não significa consumo físico efetivo.

---

# 43. Workflow — Consumo Real Futuro

Um futuro processo poderá seguir:

~~~text
Produção inicia
        ↓
Material separado
        ↓
Movimento de saída/consumo
        ↓
Quantidade realmente utilizada
        ↓
Registro de consumo real
~~~

O evento oficial ainda deve ser definido no módulo Produção.

---

# 44. Workflow — Desvio de Consumo Futuro

Conceitualmente:

~~~text
Consumo Real
-
Consumo Previsto
=
Desvio
~~~

Esse indicador poderá ser útil para:

- perda;
- eficiência;
- custo;
- controle de Produção.

Não pertence ao cadastro atual.

---

# 45. Workflow — Envio de Insumo à Facção Futuro

Um processo futuro pode utilizar:

~~~text
Estoque da Empresa
        ↓
Separação
        ↓
Envio à Facção
        ↓
Movimento de saída da origem
        ↓
Controle em poder de terceiro
~~~

Esse comportamento não deve ser registrado modificando o cadastro do Insumo.

---

# 46. Workflow — Retorno de Sobra Futuro

~~~text
Facção conclui produção
        ↓
Existem sobras
        ↓
Retorno físico
        ↓
Movimento de entrada
        ↓
Atualização do saldo
~~~

O cadastro permanece o mesmo.

---

# 47. Workflow — Perda Futuro

~~~text
Produção
        ↓
Material perdido
        ↓
Apontamento
        ↓
Movimento correspondente
        ↓
Custo / histórico operacional
~~~

Não utilizar exclusão ou edição do Insumo para representar perda.

---

# 48. Workflow — Conversão de Unidade Futuro

Se houver necessidade:

~~~text
Compra = Rolo
Consumo = Metro
~~~

a conversão deverá possuir regra explícita.

Não assumir:

~~~text
1 rolo = X metros
~~~

sem cadastro ou definição formal.

---

# 49. Workflow — Não Disponibilizar no PDV

~~~text
PDV solicita Produtos vendáveis
        ↓
Backend aplica tipos comerciais
        ↓
tipo 4
        ↓
Insumo não é retornado
~~~

---

# 50. Workflow — Não Disponibilizar em Tabela de Preço

~~~text
Tabela de Preço Comercial
        ↓
Busca Produtos de venda
        ↓
Insumo
        ↓
Não participa
~~~

---

# 51. Workflow — Não Disponibilizar em Promoção

~~~text
Promoção
        ↓
Selecionar Produto comercial
        ↓
Insumo
        ↓
Não deve ser oferecido
~~~

---

# 52. Workflow — Diferença para Produto Uso/Consumo

~~~text
O item participa diretamente
da fabricação?
        ↓
       SIM
        ↓
      Insumo

        OU

O item é consumido internamente,
sem compor o Produto fabricado?
        ↓
       SIM
        ↓
Produto Uso/Consumo
~~~

---

# 53. Workflow — Diferença para Produto Venda

~~~text
O item é o Produto comercializado
ao consumidor?
        ↓
       SIM
        ↓
Produto Venda

O item é componente para fabricar
esse Produto?
        ↓
       SIM
        ↓
Insumo
~~~

---

# 54. Workflow — Proteção Multiempresa na Consulta

~~~text
Usuário Empresa A
        ↓
Solicita ID de Insumo
        ↓
Backend verifica Empresa
        ↓
Pertence à Empresa A?
   ├── Sim → retornar
   └── Não → negar/não localizar
~~~

---

# 55. Workflow — Proteção Multiempresa na Edição

~~~text
Frontend envia atualização
        ↓
Backend valida:
- Empresa
- Insumo
- Unidade
- Material
- demais relações
        ↓
Tudo é válido no tenant?
   ├── Sim → salvar
   └── Não → rejeitar
~~~

---

# 56. Workflow — Proteção na Ficha Técnica

Ao adicionar Insumo:

~~~text
Produto da Empresa A
        ↓
Ficha Técnica Empresa A
        ↓
Selecionar Insumo
        ↓
Insumo pertence ao contexto permitido?
   ├── Sim → permitir
   └── Não → rejeitar
~~~

Nunca confiar apenas na lista exibida pelo frontend.

---

# 57. Workflow — Insumo Inativo em Nova Ficha Técnica

Regra operacional esperada:

~~~text
Insumo INATIVO
        ↓
Nova inclusão em Ficha Técnica
        ↓
Não disponibilizar / bloquear
~~~

Relacionamentos históricos existentes devem permanecer preservados.

---

# 58. Workflow — Insumo Inativo em Histórico

~~~text
Ficha Técnica antiga
        ↓
Insumo posteriormente inativado
        ↓
Relação histórica continua válida
~~~

Inativação não destrói o passado.

---

# 59. Workflow — Insumo Inativo em Compras

Novas operações devem respeitar a situação.

Conceitualmente:

~~~text
Insumo INATIVO
        ↓
Novo Pedido de Compra
        ↓
Não selecionar normalmente
~~~

Compras históricas permanecem preservadas.

---

# 60. Workflow — Atualização da Listagem

Após:

- criar;
- editar;
- ativar;
- inativar;
- excluir;

o frontend deve atualizar a listagem de forma consistente.

~~~text
Operação concluída
        ↓
Recarrega resultados
        ↓
Mantém filtros quando possível
        ↓
Atualiza paginação/indicadores
~~~

---

# 61. Workflow — Erro de Validação

~~~text
Frontend envia operação
        ↓
Backend identifica erro
        ↓
Retorna detalhe
        ↓
Frontend apresenta mensagem
        ↓
Usuário corrige
~~~

Evitar mensagens genéricas quando o backend fornecer causa específica.

---

# 62. Workflow — Erro de Permissão

~~~text
Usuário solicita ação
        ↓
Backend valida autorização
        ↓
Sem permissão
        ↓
Operação negada
        ↓
Frontend informa
~~~

---

# 63. Workflow — Exclusão Bloqueada por Ficha Técnica

~~~text
Insumo pertence a uma Ficha Técnica
        ↓
Usuário solicita Excluir
        ↓
Backend detecta dependência
        ↓
Rejeita exclusão
        ↓
Orientação operacional:
Inativar
~~~

---

# 64. Workflow — Exclusão Bloqueada por Estoque/Movimento

~~~text
Insumo possui movimento
        ↓
Exclusão solicitada
        ↓
Backend preserva integridade
        ↓
Bloqueia exclusão
~~~

---

# 65. Workflow — Exclusão Bloqueada por Compra

~~~text
Insumo já foi comprado
        ↓
Possui histórico relacionado
        ↓
Exclusão solicitada
        ↓
Backend bloqueia
~~~

---

# 66. Workflow — Auditoria

~~~text
Ação relevante
        ↓
Backend executa
        ↓
Registra:
- usuário
- Empresa
- entidade
- ação
- data/hora
- contexto disponível
~~~

A Auditoria não deve ser ignorada apenas porque o cadastro é auxiliar à Produção.

---

# 67. Workflow — Compra até Produção

Fluxo conceitual completo:

~~~text
CADASTRO DO INSUMO
        ↓
COMPRA
        ↓
RECEBIMENTO
        ↓
ESTOQUE
        ↓
FICHA TÉCNICA
        ↓
ORDEM DE PRODUÇÃO
        ↓
CONSUMO FUTURO
conforme regra produtiva
~~~

Cada etapa possui responsabilidade própria.

---

# 68. Workflow — Produto Fabricado

~~~text
Insumos
   ↓
Processo de Produção
   ↓
Produto Venda
tipo_produto = '3'
   ↓
Estoque de Produto acabado
   ↓
Distribuição / Venda
~~~

O Insumo não se transforma cadastralmente em Produto Venda.

O processo gera outro tipo de entidade operacional.

---

# 69. Workflow — Responsabilidade do Cadastro

O cadastro responde:

~~~text
Qual é o material?
Qual sua descrição?
Qual sua Unidade?
Qual sua classificação?
Qual sua situação?
Quais dados fiscais possui?
~~~

Não responde sozinho:

~~~text
Quanto está disponível?
Onde está?
Quanto será usado?
Quanto já foi consumido?
Quanto está com a facção?
Quanto foi perdido?
~~~

---

# 70. Workflow — Responsabilidade da Ficha Técnica

A Ficha Técnica responde:

~~~text
Quais Insumos são necessários?
Quanto de cada Insumo é previsto?
~~~

---

# 71. Workflow — Responsabilidade do Estoque

O Estoque responde:

~~~text
Quanto existe?
Onde está?
Quais movimentos ocorreram?
~~~

---

# 72. Workflow — Responsabilidade da Produção

A Produção deverá responder:

~~~text
Quanto será produzido?
Quais Insumos são necessários?
Quanto foi separado?
Quanto foi consumido?
Quanto sobrou?
Quanto foi perdido?
~~~

Essas regras não pertencem ao cadastro de Insumos.

---

# 73. Fluxo Consolidado de Domínio

~~~text
                        ┌───────────┐
                        │  Insumo   │
                        └─────┬─────┘
                              │
             ┌────────────────┼────────────────┐
             │                │                │
             ↓                ↓                ↓
          Compras          Estoque         Ficha Técnica
             │                │                │
             ↓                ↓                ↓
        Recebimento        Saldos        Produto Próprio
             │            Movimentos      tipo = 3
             ↓                                  │
           Custos                               ↓
                                         Ordem de Produção
                                                │
                                                ↓
                                       Consumo futuro
~~~

---

# 74. Workflows Fora do Escopo Atual

Não estão definidos nesta homologação:

- reserva automática de material;
- baixa ao criar OP;
- baixa ao liberar OP;
- baixa ao enviar para facção;
- apontamento de consumo;
- perdas;
- sobras;
- retorno de facção;
- estoque de terceiros;
- conversão automática de Unidade;
- planejamento MRP;
- sugestão automática de Compra.

---

# 75. Cuidados em Alterações Futuras

Antes de alterar os fluxos de Insumos, verificar:

1. a mudança pertence ao cadastro?
2. pertence a Compras?
3. pertence ao Estoque?
4. pertence à Ficha Técnica?
5. pertence à Ordem de Produção?
6. tipo 4 continua isolado?
7. Insumo continua distinto de Uso/Consumo?
8. não foi criado comportamento comercial?
9. localização continua operacional?
10. exclusão continua protegida?
11. multiempresa continua protegido?

Detalhes:

[[Riscos e Cuidados - Produtos - Insumos]]

---

# 76. Estado Final

Os workflows de **Insumos** estão consolidados e homologados para a Fase 1.

A regra central é:

~~~text
INSUMO
define o material.

FICHA TÉCNICA
define a quantidade prevista.

ESTOQUE
define quantidade e localização física.

COMPRAS
abastece o Estoque.

PRODUÇÃO
definirá o consumo real.
~~~

---

# 77. Navegação Documental

## Insumos

- [[Homologação - Produtos - Insumos]]
- [[Mapa Técnico - Produtos - Insumos]]
- [[Modelo de Domínio - Produtos - Insumos]]
- [[Riscos e Cuidados - Produtos - Insumos]]

## Outros Produtos

- [[Homologação - Produtos - Produto Venda]]
- [[Homologação - Produtos - Produto Uso e Consumo]]

## Cadastros Auxiliares

- [[Homologação - Produtos - Cadastros Auxiliares]]

## Projeto

- [[Sysvar]]