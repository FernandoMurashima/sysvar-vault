---
type: technical-map
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
  - homologado
---

# Mapa Técnico - Produtos - Insumos

## 1. Identificação

- **Projeto:** [[Sysvar]]
- **Módulo:** Produtos
- **Funcionalidade:** Insumos
- **Tipo interno:** `tipo_produto = '4'`
- **Escopo documentado:** Fase 1 — Cadastro e gestão estrutural
- **Situação:** IMPLEMENTADO E HOMOLOGADO
- **Decisões funcionais aprovadas:** 34
- **Data de consolidação documental:** 14/08/2026

### Documentos relacionados

- [[Sysvar]]
- [[Homologação - Produtos - Insumos]]
- [[Workflows - Produtos - Insumos]]
- [[Modelo de Domínio - Produtos - Insumos]]
- [[Riscos e Cuidados - Produtos - Insumos]]
- [[Homologação - Produtos - Produto Venda]]
- [[Homologação - Produtos - Produto Uso e Consumo]]
- [[Homologação - Produtos - Cadastros Auxiliares]]

---

# 2. Objetivo Técnico

A funcionalidade **Insumos** representa os materiais utilizados nos processos de fabricação do [[Sysvar]].

Internamente:

~~~text
tipo_produto = '4'
~~~

Insumos possuem identidade cadastral própria e devem permanecer separados de:

~~~text
tipo_produto = '1' → Revenda
tipo_produto = '2' → Uso/Consumo
tipo_produto = '3' → Fabricação Própria
~~~

A arquitetura deve preservar:

- isolamento multiempresa;
- cadastro próprio;
- código próprio;
- Unidade;
- Material opcional;
- informações fiscais;
- custos;
- natureza de Estoque;
- integração com Compras;
- integração com Ficha Técnica;
- preparação para Produção;
- lifecycle Ativo/Inativo;
- exclusão protegida;
- Auditoria;
- paginação e filtros;
- padrão visual vigente do SYSVAR.

As regras funcionais homologadas estão em:

[[Homologação - Produtos - Insumos]]

---

# 3. Backend

A funcionalidade utiliza principalmente o app Django:

`produto`

Arquivos centrais da estrutura de Produtos incluem:

- `produto/models.py`
- `produto/serializers.py`
- `produto/views.py`
- `produto/urls.py`
- `produto/permissions.py`
- `produto/tests.py`

O backend permanece responsável por:

- identificar a Empresa;
- restringir o tipo do Produto;
- gerar código;
- validar dados;
- validar relacionamentos;
- proteger isolamento multiempresa;
- proteger exclusão;
- controlar lifecycle;
- disponibilizar filtros;
- fornecer paginação;
- integrar Auditoria.

---

# 4. Tipo do Produto

O cadastro de Insumos deve trabalhar exclusivamente com:

~~~text
tipo_produto = '4'
~~~

A tela e os endpoints específicos de Insumos não devem permitir que registros dos tipos:

~~~text
1
2
3
~~~

sejam tratados como Insumos.

---

# 5. Model Principal

A entidade cadastral principal continua sendo:

`Produto`

O tipo diferencia o domínio.

Conceitualmente:

~~~text
Produto
   ↓
tipo_produto = '4'
   ↓
Insumo
~~~

A utilização de uma estrutura de Produto compartilhada não significa que todas as regras de Produto Venda sejam aplicáveis aos Insumos.

---

# 6. Separação entre Domínios

A estrutura compartilhada deve preservar regras específicas por tipo.

~~~text
Produto
   │
   ├── tipo 1 → Revenda
   ├── tipo 2 → Uso/Consumo
   ├── tipo 3 → Fabricação Própria
   └── tipo 4 → Insumo
~~~

Não aplicar genericamente aos Insumos regras de:

- Grade;
- Cor × Tamanho;
- SKU comercial;
- Coleção;
- preço de venda;
- Promoção;
- PDV.

---

# 7. Empresa

Todo Insumo deve respeitar o contexto empresarial.

Conceitualmente:

~~~text
Empresa
   ↓
Insumos
~~~

A Empresa é determinada pelo contexto autenticado e pelas regras multiempresa vigentes.

---

# 8. Isolamento Multiempresa

O backend deve garantir que:

- usuário não consulte Insumo de outra Empresa;
- usuário não edite Insumo de outra Empresa;
- usuário não exclua Insumo de outra Empresa;
- relacionamentos não sejam realizados cross-tenant;
- filtros retornem apenas registros permitidos.

Não confiar apenas na filtragem visual do frontend.

---

# 9. Código do Insumo

Insumos utilizam identidade própria.

O padrão homologado deve ser preservado conforme a implementação vigente.

A geração do código deve ocorrer no backend.

O frontend não deve determinar sequência de forma independente.

O código deve:

- identificar o Insumo;
- permanecer estável;
- não ser alterado em edição normal;
- não ser reutilizado indevidamente.

---

# 10. Descrição

Descrição identifica o material operacional.

Exemplos:

~~~text
Tecido Jeans Azul
Linha Poliéster Branca
Botão Plástico Preto
Zíper Metálico 20 cm
Etiqueta de Composição
~~~

A descrição pertence ao cadastro principal.

---

# 11. Descrição Reduzida

Quando existente na estrutura compartilhada, a descrição reduzida pode ser utilizada para representação compacta.

Ela não substitui a descrição principal.

---

# 12. Unidade

Unidade é uma informação central para Insumos.

Exemplos:

~~~text
UN
M
KG
LT
PC
CX
~~~

A Unidade define como o Insumo é quantificado.

Essa informação é essencial para integrações posteriores com:

- Compras;
- Estoque;
- Ficha Técnica;
- Produção.

---

# 13. Unidade com Decimal

A estrutura de Unidades possui a característica:

`permite_decimal`

Essa característica deve ser respeitada pelos processos consumidores.

Exemplo:

~~~text
Tecido
Unidade = M
Quantidade = 1,75
~~~

Outro exemplo:

~~~text
Botão
Unidade = UN
Quantidade = 6
~~~

A regra detalhada de Unidade pertence aos cadastros auxiliares:

[[Homologação - Produtos - Cadastros Auxiliares]]

---

# 14. Material

Material é opcional para Insumos.

Relacionamento conceitual:

~~~text
Insumo
   ↓
Material opcional
~~~

Material serve como classificação complementar.

Não representa o item operacional de estoque.

---

# 15. Material versus Insumo

Exemplo:

~~~text
Material:
Algodão

Insumo:
Tecido Tricoline Branco
~~~

Outro exemplo:

~~~text
Material:
Metal

Insumo:
Zíper Metálico 20 cm
~~~

A movimentação operacional utiliza o Insumo.

---

# 16. Ausência de Grade Comercial

Insumos não exigem Grade.

Não aplicar:

~~~text
PP
P
M
G
GG
~~~

como estrutura automática de variação.

---

# 17. Ausência de Tamanho Comercial

Tamanho de moda não faz parte obrigatória do domínio de Insumos.

Se uma dimensão fizer parte da identificação física do material, ela pode estar representada na própria descrição ou em estrutura específica futura.

Não reutilizar automaticamente o modelo de SKU de Produto Venda.

---

# 18. Ausência de Cor × Tamanho

Insumos não utilizam automaticamente:

~~~text
Produto
+
Cor
+
Tamanho
=
SKU
~~~

Essa combinação pertence ao domínio comercial de Produto Venda.

---

# 19. Ausência de SKU Comercial

Não gerar `ProdutoDetalhe` em massa por Grade e Cor apenas porque essa estrutura existe no módulo Produto.

O Insumo deve preservar o modelo específico homologado.

---

# 20. Ausência de Coleção

Insumos não dependem de:

- Coleção;
- Estação;
- ano da Coleção;
- referência comercial baseada em Coleção.

---

# 21. Ausência de Preço de Venda

Insumos não possuem obrigatoriedade de Tabela de Preço de venda.

O custo do material é relevante.

Preço comercial ao consumidor não é parte do domínio.

---

# 22. Ausência de Promoção

Insumos não participam de Promoções comerciais.

Não devem aparecer como itens promocionais destinados ao consumidor.

---

# 23. Ausência no PDV

O tipo:

~~~text
tipo_produto = '4'
~~~

não deve ser disponibilizado como Produto normal de venda no PDV.

O filtro de Produtos vendáveis deve preservar essa separação.

---

# 24. NCM

NCM pode ser associado ao Insumo quando aplicável.

O cadastro deve utilizar a estrutura fiscal existente.

Não criar tabela paralela de NCM específica para Insumos.

---

# 25. Dados Fiscais

Insumos podem possuir dados fiscais necessários principalmente para:

- Compras;
- documentos de entrada;
- recebimento;
- apuração fiscal aplicável.

Entre os conceitos já suportados pela estrutura geral estão:

- NCM;
- origem;
- CST/CSOSN;
- ICMS;
- CFOP;
- PIS;
- COFINS;
- IPI.

---

# 26. Estoque

Insumos possuem natureza de estoque.

Não deve existir como requisito funcional uma escolha:

~~~text
Controla estoque?
Sim / Não
~~~

O material físico adquirido e utilizado na produção deve poder ser movimentado e controlado.

---

# 27. Cadastro versus Estoque

Separação obrigatória:

~~~text
Cadastro do Insumo
        !=
Saldo de Estoque
~~~

O cadastro identifica o material.

O estoque registra:

- local;
- saldo;
- movimentos;
- reservas futuras;
- consumo futuro.

---

# 28. Localização

O Insumo não deve possuir localização fixa determinada pelo cadastro.

Não fixar automaticamente:

- Matriz;
- fábrica;
- Loja;
- almoxarifado;
- facção.

A localização deve nascer da operação.

---

# 29. Entrada de Estoque

Fluxo conceitual:

~~~text
Compra
   ↓
Recebimento
   ↓
Insumo
   ↓
Local definido pela operação
   ↓
Movimento de entrada
   ↓
Saldo
~~~

---

# 30. Saldo

Saldo deve resultar de movimentos reais.

~~~text
Entradas
-
Saídas
=
Saldo
~~~

Não criar saldo automaticamente durante o cadastro.

---

# 31. Compras

Insumos devem ser disponibilizados aos processos de Compras quando permitido.

Fluxo:

~~~text
Fornecedor
   ↓
Pedido de Compra
   ↓
Insumo
   ↓
Recebimento
~~~

O cadastro não implementa Pedido de Compra.

---

# 32. Recebimento

O processo de recebimento é responsável por:

- identificar o Insumo;
- identificar Empresa;
- identificar localização;
- registrar quantidade;
- atualizar Estoque;
- atualizar custos;
- processar documento fiscal.

---

# 33. Custos

Insumos possuem relevância direta para custos de Produção.

A estrutura pode utilizar conceitos como:

- custo original;
- custo da última compra;
- custo médio.

A atualização deve decorrer de eventos reais.

Não calcular custo fictício dentro do formulário de cadastro.

---

# 34. Ficha Técnica

A principal integração produtiva de Insumos é com a:

**Ficha Técnica**

Conceitualmente:

~~~text
Produto Venda
Fabricação Própria
        ↓
Ficha Técnica
        ↓
Itens da Ficha
        ↓
Insumos
~~~

A Ficha Técnica define a quantidade necessária.

---

# 35. Relação Ficha Técnica × Insumo

A quantidade utilizada não pertence ao cadastro do Insumo.

Ela pertence à relação.

Conceitualmente:

~~~text
FichaTecnicaItem
   ├── Ficha Técnica
   ├── Insumo
   └── Quantidade
~~~

O nome técnico real da entidade deve seguir a implementação do módulo Produção.

---

# 36. Mesmo Insumo em Múltiplas Fichas

Relacionamento esperado:

~~~text
Insumo 1:N Itens de Ficha Técnica
~~~

Um Insumo pode participar de vários produtos fabricados.

Exemplo:

~~~text
Linha Branca
   ├── Camisa Branca
   ├── Vestido Branco
   └── Blusa Branca
~~~

---

# 37. Quantidade por Produto

A quantidade varia conforme o Produto fabricado.

Exemplo:

~~~text
Tecido A

Camisa:
1,80 M

Vestido:
2,40 M

Saia:
1,25 M
~~~

Não armazenar uma única quantidade fixa no Insumo.

---

# 38. Ordem de Produção

A Ordem de Produção pode consumir futuramente a estrutura definida pela Ficha Técnica.

Conceitualmente:

~~~text
OP
 ↓
Produto de Fabricação Própria
 ↓
Ficha Técnica
 ↓
Insumos necessários
~~~

Entretanto, a homologação do cadastro de Insumos não definiu o evento físico de baixa.

---

# 39. Não Baixar Estoque ao Criar OP

Não implementar automaticamente:

~~~text
Criar OP
   ↓
Baixar todos os Insumos
~~~

Essa regra não foi aprovada.

O momento de baixa pertence ao módulo Produção.

---

# 40. Não Reservar Automaticamente ao Criar OP

Da mesma forma, não assumir:

~~~text
Criar OP
   ↓
Reservar automaticamente todos os Insumos
~~~

sem decisão funcional específica.

---

# 41. Consumo Previsto

A Ficha Técnica representa consumo previsto.

~~~text
Produto
   ↓
Ficha Técnica
   ↓
Quantidade teórica de Insumos
~~~

---

# 42. Consumo Real

Consumo real deverá ser determinado pelo processo produtivo.

~~~text
Produção
   ↓
Movimentações reais
   ↓
Quantidade efetivamente consumida
~~~

Consumo previsto e real não devem ser confundidos.

---

# 43. Facção

Produção por facção poderá exigir futuramente estruturas de movimentação de Insumos.

Exemplos:

- envio para facção;
- saldo em poder de terceiro;
- retorno;
- sobra;
- perda.

O cadastro de Insumo não deve carregar essas informações como estado fixo.

---

# 44. Material em Poder de Terceiro

Se implementado futuramente, deve ser tratado pelo domínio de Estoque/Produção.

Conceitualmente:

~~~text
Estoque próprio
   ↓
Movimento de envio
   ↓
Estoque/local em poder de terceiro
~~~

Não alterar o cadastro do Insumo para representar localização transitória.

---

# 45. Conversão de Unidade

A homologação atual não definiu conversão automática entre Unidades.

Exemplo futuro:

~~~text
Compra:
1 rolo

Consumo:
50 metros
~~~

Esse cenário exigirá regra formal.

Não inferir conversão automaticamente.

---

# 46. Perdas

Perda de Produção não pertence diretamente ao cadastro do Insumo.

Uma futura estrutura poderá relacionar:

- perda padrão;
- perda real;
- sobra;
- reaproveitamento.

Essas decisões pertencem ao módulo Produção.

---

# 47. Lifecycle

Insumos utilizam:

~~~text
ATIVO
INATIVO
~~~

O backend deve preservar a transição conforme permissões.

---

# 48. Inativação

Inativar um Insumo não deve apagar suas relações históricas.

Preservar:

- Compras;
- recebimentos;
- Estoque;
- movimentos;
- Fichas Técnicas existentes;
- custos;
- Auditoria.

---

# 49. Reativação

Reativação deve utilizar o mesmo registro.

Preservar:

- ID;
- código;
- Empresa;
- relações históricas.

Não criar novo Insumo apenas para reativar um item.

---

# 50. Ausência de Bloqueio de Venda

Insumos não possuem necessidade funcional de:

- Bloquear Venda;
- Desbloquear Venda.

Eles não são Produtos destinados ao PDV.

---

# 51. Exclusão Protegida

Antes de excluir, verificar dependências reais.

Exemplos:

- Ficha Técnica;
- Compras;
- estoque;
- movimento;
- documento fiscal;
- outra entidade persistente.

Fluxo conceitual:

~~~text
Solicitar exclusão
        ↓
Possui dependências?
   ├── Sim → impedir
   └── Não → permitir conforme regra
~~~

---

# 52. Auditoria

Operações relevantes devem utilizar a Auditoria geral do [[Sysvar]].

Eventos importantes:

- criação;
- edição;
- ativação;
- inativação;
- exclusão quando possível.

Não foi definida nesta fase uma estrutura sofisticada adicional de histórico individual.

---

# 53. Frontend

O frontend da funcionalidade deve apresentar uma tela específica de:

**Insumos**

A interface deve:

- listar somente tipo 4;
- respeitar permissões;
- utilizar padrão visual vigente;
- fornecer criação;
- consulta;
- edição;
- ativação/inativação;
- exclusão protegida;
- filtros;
- paginação.

---

# 54. Padrão Visual

A tela segue o padrão dos cadastros modernos de Produtos.

O padrão atual utiliza:

- seleção única do registro;
- destaque da linha;
- barra de ações;
- ausência de ações redundantes por linha quando aplicável;
- consulta em fluxo coerente com o restante do sistema.

---

# 55. Consulta

A consulta deve exibir dados do Insumo sem incluir estruturas comerciais irrelevantes.

Blocos possíveis:

- identificação;
- Unidade;
- Material;
- Fiscal;
- Custos;
- Status;
- demais informações existentes.

---

# 56. Consulta Atualizada

Quando houver endpoint de detalhe, a consulta deve utilizar o ID para obter o registro atual.

~~~text
Registro selecionado
        ↓
ID
        ↓
Backend
        ↓
Dados atuais
        ↓
Consulta
~~~

---

# 57. Edição Atualizada

A edição deve preservar o mesmo princípio.

Antes de alterar campos relevantes, utilizar os dados atuais da entidade.

---

# 58. Filtros

Filtros devem trabalhar apenas sobre Insumos.

O backend deve aplicar:

~~~text
tipo_produto = '4'
~~~

além do isolamento da Empresa.

---

# 59. Paginação Server-Side

A listagem deve utilizar paginação no servidor.

Não carregar toda a base de Insumos apenas para paginar no browser.

---

# 60. Permissões

As ações devem respeitar a autorização vigente.

Entre elas:

- consultar;
- criar;
- editar;
- ativar;
- inativar;
- excluir quando permitido.

Frontend não substitui segurança backend.

---

# 61. Integração com Cadastros Auxiliares

Insumos podem utilizar estruturas como:

- Unidade;
- Material;
- NCM.

Essas entidades devem respeitar a documentação:

[[Homologação - Produtos - Cadastros Auxiliares]]

---

# 62. Integração com Produto Venda

A relação produtiva ocorre principalmente com:

~~~text
Produto Venda
tipo = 3
Fabricação Própria
        ↓
Ficha Técnica
        ↓
Insumos
~~~

Referência:

[[Homologação - Produtos - Produto Venda]]

---

# 63. Não Integrar com Revenda por Produção

Produto de Revenda:

~~~text
tipo_produto = '1'
~~~

é adquirido pronto.

Não necessita de Insumos através de Ficha Técnica para abastecimento normal.

---

# 64. Integração com Uso/Consumo

Não existe relação hierárquica entre Insumo e Uso/Consumo.

São dois tipos paralelos de item interno.

~~~text
Uso/Consumo
→ uso interno não produtivo

Insumo
→ uso produtivo
~~~

Referência:

[[Homologação - Produtos - Produto Uso e Consumo]]

---

# 65. Integração com Compras

O módulo Compras deve poder selecionar Insumos adequados.

Não deve exigir que o Insumo seja convertido em Produto Venda.

---

# 66. Integração com Fiscal

Entrada fiscal utiliza os dados cadastrais do Insumo e valida os requisitos da operação.

O cadastro não deve executar a operação fiscal.

---

# 67. Integração com Estoque

Toda movimentação física deve utilizar a arquitetura oficial de Estoque.

Não criar estoque paralelo exclusivo de Insumos.

---

# 68. Integração com Produção

A Produção consome a identidade cadastral do Insumo.

Conceitualmente:

~~~text
Insumo
   ↓
Ficha Técnica
   ↓
Ordem de Produção
   ↓
Movimentações futuras
~~~

Apenas a participação na Ficha Técnica está consolidada neste escopo.

---

# 69. Matriz de Responsabilidades

| Responsabilidade | Cadastro de Insumo | Outro módulo |
|---|---:|---:|
| Identificar material | Sim | Consome |
| Descrição | Sim | Não |
| Unidade | Sim | Consome |
| Material classificatório | Sim | Não |
| Fiscal cadastral | Sim | Consome/valida |
| Código | Sim | Não |
| Saldo | Não | Estoque |
| Localização | Não | Estoque |
| Compra | Não | Compras |
| Recebimento | Não | Compras/Fiscal |
| Quantidade na Ficha | Não | Produção |
| Reserva | Não | Produção/Estoque |
| Baixa produtiva | Não | Produção/Estoque |
| Perda | Não | Produção |
| Estoque em facção | Não | Produção/Estoque |

---

# 70. Fluxo Técnico de Cadastro

~~~text
Frontend
   ↓
Novo Insumo
   ↓
tipo_produto = '4'
   ↓
Backend identifica Empresa
   ↓
Valida campos
   ↓
Valida Unidade
   ↓
Valida Material, se informado
   ↓
Valida fiscal informado
   ↓
Gera/atribui código conforme implementação
   ↓
Persiste Produto
   ↓
Auditoria
   ↓
Retorna registro
~~~

---

# 71. Fluxo Técnico de Consulta

~~~text
Selecionar Insumo
        ↓
ID
        ↓
GET detalhe
        ↓
Backend aplica Empresa
        ↓
Confirma tipo 4
        ↓
Retorna dados
        ↓
Frontend apresenta consulta
~~~

---

# 72. Fluxo Técnico de Edição

~~~text
Selecionar Insumo
        ↓
Buscar por ID
        ↓
Carregar dados atuais
        ↓
Editar
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

# 73. Fluxo Técnico de Inativação

~~~text
Insumo ATIVO
        ↓
Usuário autorizado
        ↓
Solicita Inativar
        ↓
Backend valida Empresa
        ↓
Atualiza status
        ↓
Auditoria
        ↓
Insumo INATIVO
~~~

---

# 74. Fluxo Técnico de Exclusão

~~~text
Solicitar Excluir
        ↓
Backend verifica Empresa
        ↓
Verifica permissões
        ↓
Verifica dependências
        ↓
Possui dependência?
   ├── Sim → negar exclusão
   └── Não → excluir
~~~

---

# 75. Fluxo Técnico com Ficha Técnica

~~~text
Produto Fabricação Própria
        ↓
Ficha Técnica
        ↓
Adicionar Item
        ↓
Selecionar Insumo ATIVO
        ↓
Informar quantidade
        ↓
Validar Unidade
        ↓
Salvar relação
~~~

A quantidade pertence à relação da Ficha Técnica.

---

# 76. Fluxo Técnico Futuro de Produção

Não está homologado como implementação atual, mas a arquitetura deverá permitir:

~~~text
OP
 ↓
Ficha Técnica
 ↓
Necessidades
 ↓
Disponibilidade de Estoque
 ↓
Separação / Reserva / Consumo
 ↓
Movimentos
~~~

O evento exato deverá ser decidido no módulo Produção.

---

# 77. Estruturas que não devem ser criadas no cadastro

Não adicionar ao Insumo apenas para antecipar processos futuros:

- saldo atual editável;
- Loja fixa;
- facção fixa;
- quantidade por Produto;
- quantidade padrão universal;
- reserva;
- consumo acumulado;
- quantidade perdida;
- OP atual.

Esses dados pertencem a relacionamentos e movimentos.

---

# 78. Riscos Técnicos Principais

Alterações futuras devem evitar:

- misturar tipo 4 com tipo 2;
- expor tipo 4 no PDV;
- exigir Grade;
- gerar SKU comercial;
- fixar local de estoque;
- duplicar arquitetura de Estoque;
- baixar estoque ao criar OP sem regra aprovada;
- associar Insumo de outra Empresa;
- excluir Insumo utilizado;
- alterar Unidade sem avaliar relações existentes.

Detalhes:

[[Riscos e Cuidados - Produtos - Insumos]]

---

# 79. Regras Estruturais Homologadas

1. funcionalidade denominada **Insumos**;
2. tipo interno `4`;
3. domínio distinto de Produto Venda;
4. domínio distinto de Uso/Consumo;
5. multiempresa;
6. Unidade relevante;
7. Material opcional;
8. sem Grade comercial;
9. sem Cor × Tamanho comercial;
10. sem SKU comercial obrigatório;
11. sem Coleção obrigatória;
12. sem preço de venda obrigatório;
13. não aparece no PDV;
14. possui natureza de Estoque;
15. cadastro não define localização;
16. pode participar de Compras;
17. participa de Ficha Técnica;
18. quantidade produtiva pertence à Ficha Técnica;
19. pode participar de várias Fichas;
20. preparação para Ordem de Produção;
21. criação de OP não baixa estoque automaticamente;
22. reserva de OP não foi definida neste escopo;
23. lifecycle Ativo/Inativo;
24. exclusão protegida;
25. Auditoria preservada.

---

# 80. Escopo Ainda Fora desta Fase

Não pertence ao cadastro homologado:

- MRP;
- planejamento de compras por necessidade;
- explosão de materiais;
- reserva automática;
- separação de material;
- baixa produtiva;
- apontamento de consumo;
- perdas;
- sobras;
- retorno de facção;
- estoque em poder de terceiro;
- conversão avançada de Unidade;
- custo real completo de Produção.

---

# 81. Estado Final

**Insumos está IMPLEMENTADO E HOMOLOGADO.**

A arquitetura deve preservar a divisão de responsabilidades:

~~~text
INSUMO
define o material

FICHA TÉCNICA
define quanto é necessário

ESTOQUE
define quanto existe e onde está

COMPRAS
define como entra

PRODUÇÃO
definirá quanto é efetivamente consumido
~~~

---

# 82. Navegação Documental

## Insumos

- [[Homologação - Produtos - Insumos]]
- [[Workflows - Produtos - Insumos]]
- [[Modelo de Domínio - Produtos - Insumos]]
- [[Riscos e Cuidados - Produtos - Insumos]]

## Outros Produtos

- [[Homologação - Produtos - Produto Venda]]
- [[Homologação - Produtos - Produto Uso e Consumo]]

## Cadastros Auxiliares

- [[Homologação - Produtos - Cadastros Auxiliares]]

## Projeto

- [[Sysvar]]