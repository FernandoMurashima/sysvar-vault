---
type: reference
status: active
project: Sysvar
source: "C:/SysvarProjeto"
created: 2026-08-03
updated: 2026-08-27
tags:
  - sysvar
  - contexto
  - negocio
  - arquitetura
  - operacional
  - cadastros
  - produtos
  - produto-venda
  - produto-uso-consumo
  - insumos
  - cadastros-auxiliares
  - compras
  - pedido-de-compra
  - entrada-nfe
  - cotacao
  - almoxarifado
  - ti
  - manutencao
  - ordem-de-servico
  - requisicoes
  - estoque
  - produção
  - distribuição
  - vendas
  - fiscal
  - financeiro
  - auditoria
  - saas
  - multiempresa
  - homologado
---

# Visão Geral

## 1. O que é o SYSVAR

O SYSVAR é um ERP SaaS voltado principalmente ao varejo e à indústria de moda.

O sistema foi concebido para atender empresas com:

- uma ou várias Lojas;
- Matriz;
- fábrica;
- estoque central;
- compras;
- produção própria;
- facções;
- distribuição para Lojas;
- vendas;
- PDV;
- controle fiscal;
- controle financeiro;
- gestão contábil;
- relatórios;
- dashboards;
- Auditoria.

A arquitetura suporta várias Empresas na mesma plataforma, mantendo os dados isolados por Empresa e, quando aplicável, por Estabelecimento.

---

# 2. Objetivo do Produto

O objetivo do SYSVAR é centralizar as operações de empresas do ramo de moda em uma única plataforma.

O sistema deve permitir acompanhar o fluxo completo:

~~~text
Administração
        ↓
Cadastros
        ↓
Produtos
        ↓
Compra ou Produção
        ↓
Estoque
        ↓
Distribuição
        ↓
Venda
        ↓
Fiscal
        ↓
Financeiro
        ↓
Contabilidade
        ↓
Relatórios
        ↓
Auditoria
~~~

Cada etapa possui responsabilidade própria.

---

# 3. Público Principal

O SYSVAR está sendo estruturado principalmente para pequenas e médias empresas do setor de moda.

Entre os cenários previstos estão:

- Loja única;
- redes de Lojas;
- empresa com Matriz e filiais;
- empresa que compra Produtos para Revenda;
- empresa que fabrica seus próprios Produtos;
- empresa com produção terceirizada por facção;
- empresa que combina Revenda e Fabricação Própria.

---

# 4. Modelo SaaS

O SYSVAR opera como uma plataforma SaaS multiempresa.

Conceitualmente:

~~~text
PLATAFORMA SYSVAR
        │
        ├── Empresa A
        │     ├── Estabelecimentos
        │     ├── Usuários
        │     ├── Cadastros
        │     ├── Produtos
        │     └── Operações
        │
        ├── Empresa B
        │     ├── Estabelecimentos
        │     ├── Usuários
        │     ├── Cadastros
        │     ├── Produtos
        │     └── Operações
        │
        └── Empresa N
~~~

Uma Empresa não pode acessar os dados privados de outra.

---

# 5. Empresa como Tenant

A Empresa é o principal limite lógico de dados.

Regra central:

~~~text
EMPRESA
=
TENANT
~~~

Devem respeitar esse limite, conforme aplicável:

- Clientes;
- Fornecedores;
- Funcionários;
- Usuários;
- Perfis;
- Produtos;
- Cadastros Auxiliares;
- Compras;
- Estoques;
- documentos;
- Financeiro;
- Produção;
- Distribuição;
- Auditoria.

A proteção deve existir no backend.

---

# 6. Estabelecimentos

Uma Empresa pode possuir vários Estabelecimentos.

Entre os tipos previstos estão:

~~~text
LOJA
MATRIZ
FÁBRICA
~~~

Estabelecimento representa contexto operacional.

Não substitui a Empresa como limite do tenant.

---

# 7. Estrutura Funcional Geral

O SYSVAR está organizado em grandes grupos funcionais.

~~~text
SYSVAR
│
├── Operacional
├── Cadastros
├── Produtos
├── Compras
├── Estoque
├── Produção
├── Distribuição
├── Vendas / PDV
├── Fiscal
├── Financeiro
├── Contabilidade
├── Relatórios
└── Auditoria
~~~

---

# 8. Grupo Operacional

O grupo Operacional fornece a infraestrutura de funcionamento da plataforma.

Inclui:

- Empresas;
- Contratos;
- Estabelecimentos;
- Usuários;
- Perfis;
- Permissões;
- Sessões;
- Licenciamento;
- administração de sessões;
- suspensão e reativação;
- troca de senha;
- Auditoria Central.

Situação:

~~~text
CONCLUÍDO
HOMOLOGADO
DOCUMENTADO
APROVADO
~~~

---

# 9. Contratos

Cada Empresa cliente possui contexto contratual.

O Contrato controla aspectos como:

- situação;
- vigência;
- módulos;
- limite de sessões simultâneas;
- administração da Empresa;
- suspensão;
- reativação.

---

# 10. Licenciamento

O modelo homologado utiliza:

~~~text
SESSÕES SIMULTÂNEAS
~~~

Não quantidade de Usuários cadastrados.

Regra:

~~~text
Usuário cadastrado
→ não consome licença

Sessão válida
→ consome licença
~~~

---

# 11. Usuários e Perfis

Usuário representa identidade de autenticação.

Perfil representa conjunto de Permissões.

Separação:

~~~text
Usuário
!=
Funcionário

Perfil
!=
Cargo
~~~

A Permissão efetiva deve ser determinada pelo mecanismo oficial de acesso do SYSVAR.

---

# 12. Auditoria Central

Auditoria é transversal.

Pode registrar eventos relacionados a:

- autenticação;
- sessões;
- Empresas;
- Contratos;
- Usuários;
- Perfis;
- Permissões;
- Estabelecimentos;
- Cadastros;
- Produtos;
- Compras;
- lifecycle;
- alterações relevantes.

A Auditoria Central não deve ser substituída por históricos funcionais específicos.

---

# 13. Grupo Cadastros

O escopo prioritário revisado de Cadastros está concluído.

~~~text
CLIENTES
→ 23/23 HOMOLOGADOS

FORNECEDORES
→ 30/30 HOMOLOGADOS

FUNCIONÁRIOS
→ 17/17 HOMOLOGADOS
~~~

Todos estão:

~~~text
IMPLEMENTADOS
HOMOLOGADOS
DOCUMENTADOS
APROVADOS
~~~

---

# 14. Clientes

Cliente representa pessoa ou organização atendida pela Empresa.

O domínio contempla:

- PF;
- PJ;
- Cliente sem documento;
- documento funcional;
- Consumidor Final;
- lifecycle;
- Histórico;
- indicadores;
- Auditoria;
- integração com Vendas e PDV.

Cada Empresa possui seu próprio Consumidor Final.

---

# 15. Fornecedores

Fornecedor representa quem fornece:

- mercadorias;
- matéria-prima;
- aviamentos;
- serviços;
- facção;
- transporte;
- outros itens ou serviços.

Pode possuir múltiplas categorias.

Integra principalmente com:

- Compras;
- Financeiro;
- Fiscal;
- Produção.

---

# 16. Funcionários

Funcionário representa identidade operacional.

O SYSVAR não pretende transformar esse cadastro em um sistema completo de RH/DP.

O domínio contempla:

- identificação;
- Cargo;
- Loja Principal;
- Lojas supervisionadas;
- comissão básica;
- lifecycle;
- Usuário opcional;
- Histórico;
- Auditoria.

---

# 17. Grupo Produtos

O ciclo cadastral atualmente revisado de Produtos está concluído.

~~~text
PRODUTO VENDA
→ CONCLUÍDO
→ 19/19 HOMOLOGADOS
→ DOCUMENTADO

PRODUTO USO/CONSUMO
→ CONCLUÍDO
→ HOMOLOGADO
→ DOCUMENTADO

INSUMOS
→ CONCLUÍDO
→ HOMOLOGADO
→ DOCUMENTADO

CADASTROS AUXILIARES
→ CONCLUÍDOS
→ HOMOLOGADOS
→ DOCUMENTADOS
~~~

---

# 18. Tipos de Produto

A estrutura funcional consolidada utiliza:

~~~text
1 = Revenda
2 = Uso/Consumo
3 = Fabricação Própria
4 = Insumo
~~~

Visão:

~~~text
Produto
   │
   ├── tipo 1 → Revenda
   ├── tipo 2 → Uso/Consumo
   ├── tipo 3 → Fabricação Própria
   └── tipo 4 → Insumo
~~~

Cada tipo possui regras próprias.

---

# 19. Produto Venda

Produto Venda engloba:

~~~text
Revenda
+
Fabricação Própria
~~~

Tipos internos:

~~~text
1
3
~~~

Representa os Produtos destinados à comercialização.

---

# 20. Produto e SKU

Separação:

~~~text
Produto
!=
SKU
~~~

Produto representa o item principal.

SKU representa:

~~~text
Produto + Cor + Tamanho
~~~

Exemplo:

~~~text
Produto:
Calça Jeans Feminina

SKUs:
Azul / 38
Azul / 40
Preta / 38
Preta / 40
~~~

---

# 21. Referência de Produto Venda

Formato consolidado:

~~~text
AA-BB-CCDDD
~~~

Onde:

~~~text
AA = ano da Coleção
BB = Estação
CC = Código de Referência do Grupo
DDD = sequência
~~~

A Referência pertence ao Produto.

EAN pertence ao SKU.

---

# 22. Produto Venda — Revenda

Fluxo conceitual:

~~~text
Produto Venda
Tipo 1
        ↓
SKU
        ↓
Pedido de Compra
        ↓
Recebimento
        ↓
Estoque
        ↓
Venda
~~~

---

# 23. Produto Venda — Fabricação Própria

Fluxo:

~~~text
Produto Venda
Tipo 3
        ↓
Ficha Técnica
        ↓
Insumos
        ↓
Ordem de Produção
        ↓
Produção
        ↓
Estoque
        ↓
Venda
~~~

Fabricação Própria não participa do Pedido de Compra.

---

# 24. Produto Uso/Consumo

Tipo:

~~~text
2
~~~

Representa itens utilizados internamente pela Empresa e que não são destinados normalmente à venda.

Exemplos:

- material de limpeza;
- material administrativo;
- manutenção;
- itens de uso interno.

---

# 25. Uso/Consumo não é Produto Venda

Não utiliza automaticamente:

- Grade;
- Cor × Tamanho;
- SKU comercial;
- Coleção;
- Pack;
- Promoção;
- Tabela de Preço comercial.

Não deve aparecer normalmente no PDV.

---

# 26. Uso/Consumo não é Insumo

Separação:

~~~text
Uso/Consumo
→ consumo interno não produtivo

Insumo
→ consumo produtivo
~~~

---

# 27. Insumos

Tipo:

~~~text
4
~~~

Representam componentes utilizados na fabricação.

Exemplos:

- tecidos;
- linhas;
- botões;
- zíperes;
- etiquetas;
- elásticos;
- aviamentos.

---

# 28. Material e Insumo

Separação:

~~~text
Material
→ classificação

Insumo
→ item operacional
~~~

Material é opcional no cadastro de Insumos.

Compras, Estoque e Produção utilizam o Insumo.

---

# 29. Cadastros Auxiliares de Produtos

O conjunto consolidado contempla:

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

Esses cadastros fornecem estruturas utilizadas pelos Produtos.

---

# 30. Princípio dos Cadastros Auxiliares

~~~text
CADASTRO AUXILIAR
→ define estrutura

PRODUTO
→ utiliza estrutura

PROCESSO OPERACIONAL
→ utiliza Produto
~~~

Não transformar Cadastro Auxiliar em processo operacional.

---

# 31. Grupos e Subgrupos

Grupo classifica Produto.

Subgrupo especializa Grupo.

~~~text
Grupo
   ↓
Subgrupos
~~~

Código de Referência do Grupo participa da Referência de Produto Venda.

---

# 32. Grade e Tamanho

~~~text
Grade
   ↓
Tamanhos
~~~

Produto Venda utiliza Grade e Cores para formar SKUs.

---

# 33. Coleções

Coleção organiza Produto Venda por ano e Estação.

Estações:

~~~text
01 = Verão
02 = Outono
03 = Inverno
04 = Primavera
~~~

Status:

~~~text
CR
PD
AT
EN
AR
~~~

---

# 34. Packs

Pack define composição de quantidades por Tamanho.

~~~text
Grade
   ↓
Pack
   ↓
Itens
   ↓
Tamanho + Quantidade
~~~

É utilizado em Compras de Produto Venda tipo Revenda.

Quantidade de compra em Revenda:

~~~text
Número de Packs
×
Soma das quantidades do Pack
=
Quantidade de peças
~~~

---

# 35. Unidade

Unidade define como um item é quantificado.

Exemplos:

~~~text
UN
M
KG
LT
CX
~~~

A propriedade:

~~~text
permite_decimal
~~~

orienta os processos que utilizam quantidades.

Essa regra é utilizada pelo Pedido de Compra para Uso/Consumo e Insumos.

---

# 36. Estoque

Estoque representa:

~~~text
O QUE
+
QUANTO
+
ONDE
~~~

Separação:

~~~text
Produto
→ identidade

Estoque
→ quantidade e localização
~~~

---

# 37. Estoque de Produto Venda

Granularidade comercial:

~~~text
Loja × SKU
~~~

A criação de estrutura com saldo zero não representa entrada física.

---

# 38. Estoque de Uso/Consumo

Produto Uso/Consumo possui natureza de Estoque.

O cadastro não define localização fixa.

~~~text
Operação
→ determina Local
~~~

Não existe necessidade do campo:

~~~text
controla_estoque
~~~

no domínio homologado.

---

# 39. Estoque de Insumos

Insumos também possuem natureza de Estoque.

O cadastro não fixa:

- Matriz;
- fábrica;
- almoxarifado;
- Loja;
- facção.

A localização decorre das operações.

---

# 40. Grupo Compras

O grupo Compras possui atualmente os seguintes blocos homologados e documentados:

- Requisições Internas;
- Ordens de Serviço;
- Compras de Uso/Consumo;
- Pedido de Compra;
- Entrada de NF-e.

Situação:

~~~text
REQUISIÇÕES INTERNAS
→ IMPLEMENTADAS
→ TESTADAS
→ HOMOLOGADAS
→ APROVADAS
→ DOCUMENTADAS

ORDENS DE SERVIÇO
→ IMPLEMENTADAS
→ TESTADAS
→ HOMOLOGADAS
→ APROVADAS
→ DOCUMENTADAS

COMPRAS DE USO/CONSUMO
→ IMPLEMENTADAS
→ TESTADAS
→ HOMOLOGADAS
→ APROVADAS
→ DOCUMENTADAS

PEDIDO DE COMPRA
→ IMPLEMENTADO
→ TESTADO
→ HOMOLOGADO
→ APROVADO
→ DOCUMENTADO

ENTRADA DE NF-e
→ IMPLEMENTADA
→ TESTADA
→ HOMOLOGADA
→ APROVADA
→ DOCUMENTADA
~~~
## Entrada de NF-e — Visão Consolidada

A Entrada de NF-e representa o recebimento fiscal e operacional de mercadorias.

O fluxo atual admite:

~~~text
NF-e com Pedido
ou
NF-e sem Pedido
~~~

O Pedido de Compra não é obrigatório para importar e tratar uma NF-e.

Quando houver Pedido, ele participa das validações de:

- Empresa;
- Loja;
- Fornecedor;
- itens;
- saldo restante;
- preço aprovado;
- recebimentos anteriores.

O XML representa a verdade fiscal recebida.

~~~text
XML
↓
Fornecedor
↓
Produto × Fornecedor
↓
Conciliação
↓
Conferência física
↓
Divergências
↓
Pedido, quando houver
↓
Efetivação
↓
Estoque
↓
Custos
↓
Financeiro
~~~

O cadastro Produto × Fornecedor permite associar:

~~~text
Fornecedor
+
Código externo
→
Produto interno
~~~

e pode preservar unidade e fator de conversão.

Item XML sem Produto conciliado não pode ser efetivado.

A conferência física não altera o conteúdo fiscal do XML.

Quando houver diferença:

~~~text
XML
!=
Físico
→
Divergência
~~~

Quando houver Pedido:

~~~text
Quantidade NF > saldo
→ importar permitido
→ conferir permitido
→ efetivação bloqueada
~~~

Preço:

~~~text
NF = Pedido
→ permitido

NF < Pedido
→ permitido

NF > Pedido
→ efetivação bloqueada
~~~

Produto Uso/Consumo:

~~~text
tipo_produto = 2
→ estoque dedicado de Uso/Consumo
~~~

Essa regra independe da origem:

- Pedido gerado por Cotação;
- Pedido manual;
- NF sem Pedido.

Importação não representa entrada física.

~~~text
Importar XML
!=
Efetivar NF
~~~

A entrada física ocorre somente na efetivação.

Operações distintas:

~~~text
Recusar entrada
→ NF AB provisória elegível
→ sem efeitos operacionais
→ libera chave

Cancelar NF
→ NF já efetivada
→ desfaz efeitos
→ preserva chave
~~~

Status operacionais:

~~~text
AB = Aberta
FE = Efetivada
CA = Cancelada
~~~

Status operacional não deve ser confundido com finalidade fiscal.

Exemplo:

~~~text
finNFe = 4
→ devolução
→ pode importar
→ efetivação normal bloqueada
~~~

Documentação específica:

- [[Mapa Técnico - Compras - Entrada de NF-e]]
- [[Modelo de Domínio - Compras - Entrada de NF-e]]
- [[Workflows - Compras - Entrada de NF-e]]
- [[Riscos e Cuidados - Compras - Entrada de NF-e]]
- [[Homologação - Compras - Entrada de NF-e]]


As Requisições Internas atendem três tipos principais:

~~~text
USO_CONSUMO
MANUTENCAO
TI
~~~

A responsabilidade operacional é separada entre:

~~~text
Origem da necessidade
!=
Setor de atendimento
!=
Setor de aquisição
~~~

A Matriz de Responsabilidade determina os setores envolvidos.

Para Uso/Consumo, o atendimento pode ocorrer diretamente pelo Almoxarifado Central.

Quando não existe estoque suficiente:

~~~text
Requisição
→ Cotação
→ Pedido de Compra
→ Entrada de NF-e
→ Estoque
→ Atendimento
~~~

Para Manutenção e TI:

~~~text
Requisição aprovada
→ Ordem de Serviço
→ execução
→ conclusão da OS
→ conclusão da Requisição
~~~

Materiais necessários à execução pertencem diretamente à Ordem de Serviço.

A fila de necessidades de compra aceita origens:

~~~text
REQ
→ Requisição de Uso/Consumo

OS
→ Material de Ordem de Serviço
~~~

O Pedido de Compra permanece consolidado em uma única funcionalidade.

Não existem como funções independentes para o usuário:

- Pedido de Revenda;
- Pedido de Uso/Consumo;
- Pedido de Insumo.

Documentação da homologação:

[[Homologação - Compras - Requisições e Ordens de Serviço]]

---

# 41. Pedido de Compra Unificado

O Pedido de Compra contempla:

~~~text
tipo 1
→ Revenda

tipo 2
→ Uso/Consumo

tipo 4
→ Insumo
~~~

Não contempla:

~~~text
tipo 3
→ Fabricação Própria
~~~

Fabricação Própria pertence ao domínio de Produção.

---

# 42. Definição do Tipo do Pedido

O usuário não escolhe manualmente o tipo.

Pedido novo nasce:

~~~text
tipo = ''
status = AB
~~~

O primeiro item define automaticamente:

~~~text
Produto.tipo_produto
        ↓
Pedido.tipo
~~~

Depois dessa definição, todos os demais itens devem possuir o mesmo tipo.

---

# 43. Proibição de Mistura

Não é permitido misturar no mesmo Pedido:

~~~text
Revenda + Uso/Consumo
Revenda + Insumo
Uso/Consumo + Insumo
~~~

A regra é protegida no backend.

---

# 44. Pedido sem Itens

Pedido AB sem itens utiliza:

~~~text
tipo = ''
~~~

Se o último item for removido:

~~~text
0 itens
→ tipo = ''
~~~

O próximo primeiro item pode então definir um novo tipo válido.

---

# 45. Estados do Pedido de Compra

Estados homologados:

~~~text
AB = Aberto
AP = Aprovado
AT = Atendido
CA = Cancelado
~~~

AB representa o estado normal de edição.

Somente Pedido AB pode ser excluído fisicamente pelo fluxo normal.

---

# 46. Pedido de Revenda

Para:

~~~text
tipo = 1
~~~

o item utiliza:

- Produto;
- Cor;
- Pack;
- número de Packs;
- quantidade calculada;
- preço unitário;
- desconto;
- total;
- observação.

Quantidade:

~~~text
número de Packs
×
quantidade total do Pack
=
quantidade do item
~~~

Revenda não aceita quantidade fracionária.

---

# 47. Pedido de Uso/Consumo

Para:

~~~text
tipo = 2
~~~

o item utiliza:

- Produto;
- Unidade;
- quantidade;
- preço;
- desconto;
- total;
- observação.

Não utiliza Pack.

Quantidade decimal depende da Unidade.

---

# 48. Pedido de Insumo

Para:

~~~text
tipo = 4
~~~

o item utiliza:

- Produto;
- Unidade;
- quantidade;
- preço;
- desconto;
- total;
- observação.

Não utiliza Pack.

Uso/Consumo e Insumo compartilham mecânica quantitativa semelhante, mas permanecem tipos funcionalmente distintos.

---

# 49. Total do Item de Compra

Regra:

~~~text
bruto =
quantidade × preço unitário

total_item =
bruto - desconto do item
~~~

Para Revenda, a quantidade é obtida do Pack.

---

# 50. Total do Pedido

Regra homologada:

~~~text
total_pedido =
total_itens
- total_desconto
+ frete
~~~

O Pedido pode possuir:

- desconto geral opcional;
- frete opcional.

O total não pode ser negativo.

Para aprovação:

~~~text
total_pedido > 0
~~~

---

# 51. Forma de Pagamento

Forma de Pagamento é tratada em estrutura subordinada própria.

A sobretela apresenta:

- Forma;
- Prazo;
- situação;
- parcelas;
- vencimentos;
- valores;
- Total do Pedido;
- Total das Parcelas;
- Diferença.

O planejamento financeiro não precisa ocupar permanentemente o cabeçalho principal.

---

# 52. Parcelas Planejadas

O planejamento utiliza:

`PedidoCompraParcela`

Estado principal antes da aprovação:

~~~text
PLAN = Planejada
~~~

Invariante:

~~~text
Soma das parcelas
=
Total do Pedido
~~~

Mudanças do total em Pedido AB devem manter o planejamento coerente.

---

# 53. Natureza de Lançamento

A Natureza financeira é escolhida no momento da aprovação.

Não é um campo que o usuário precise definir durante a criação inicial do cabeçalho.

---

# 54. Aprovação do Pedido

Fluxo consolidado:

~~~text
Pedido AB
        ↓
Itens válidos
        ↓
Tipo válido
        ↓
Forma e Prazo
        ↓
Parcelas consistentes
        ↓
Selecionar Natureza
        ↓
Aprovar
        ↓
Financeiro
        ↓
Pedido AP
~~~

---

# 55. Compras e Financeiro

A aprovação pode gerar:

~~~text
PedidoCompra
        ↓
Pagar
        ↓
PagarItem
~~~

Separação:

~~~text
PedidoCompraParcela
→ planejamento

PagarItem
→ obrigação financeira
~~~

Compras não deve duplicar Contas a Pagar.

---

# 56. Aprovação não é Recebimento

Regra fundamental:

~~~text
Pedido aprovado
!=
Mercadoria recebida
~~~

A aprovação não deve gerar automaticamente entrada física de Estoque.

---

# 57. Recebimento

O recebimento operacional da compra permanece ligado ao processo Fiscal.

Fluxo:

~~~text
Pedido AP
        ↓
Nota Fiscal de Entrada
        ↓
Recebimento
        ↓
Estoque
        ↓
Atualização do atendimento do Pedido
~~~

A tela de Pedido possui acompanhamento dos recebimentos, mas não cria um processo paralelo de entrada.

---

# 58. Recebimento Parcial

Quando somente parte da quantidade é recebida:

~~~text
Pedido permanece AP
~~~

O Pedido continua aguardando atendimento.

---

# 59. Recebimento Integral

Quando todas as quantidades forem atendidas:

~~~text
AP → AT
~~~

AT significa:

**Pedido integralmente atendido.**

---

# 60. Cancelamento Fiscal

O cancelamento de Nota Fiscal relacionada ao recebimento pode alterar novamente a situação de atendimento.

Quando um Pedido AT deixa de estar integralmente recebido:

~~~text
AT → AP
~~~

conforme o fluxo Fiscal vigente.

A suíte específica de Compras não representa cobertura integral de todo o processo real de cancelamento fiscal.

---

# 61. Multiempresa em Compras

Todo o processo deve respeitar o tenant.

Devem permanecer coerentes:

- Empresa;
- Loja;
- Fornecedor;
- Produto;
- Forma de Pagamento;
- Prazo;
- Natureza;
- Financeiro;
- recebimentos.

A proteção definitiva pertence ao backend.

---

# 62. Documentação do Pedido de Compra

O domínio possui conjunto documental próprio:

- [[Homologação - Compras - Pedido de Compra]]
- [[Mapa Técnico - Compras - Pedido de Compra]]
- [[Workflows - Compras - Pedido de Compra]]
- [[Modelo de Domínio - Compras - Pedido de Compra]]
- [[Riscos e Cuidados - Compras - Pedido de Compra]]

A situação oficial é:

~~~text
CONCLUÍDO
TESTADO
HOMOLOGADO
APROVADO
DOCUMENTADO
~~~

---

# 63. Produção

Produção transforma Insumos em Produto acabado.

~~~text
Produto Venda tipo 3
        ↓
Ficha Técnica
        ↓
Insumos tipo 4
        ↓
Ordem de Produção
        ↓
Produção
        ↓
Produto Acabado
~~~

Produto tipo 3 não entra no Pedido de Compra.

---

# 64. Ficha Técnica

Ficha Técnica representa composição prevista.

~~~text
Produto Fabricado
        ↓
Ficha Técnica
        ↓
Insumo + Quantidade
~~~

A quantidade pertence à relação Ficha Técnica × Insumo.

---

# 65. Consumo Previsto e Real

Separação:

~~~text
Ficha Técnica
→ consumo previsto

Produção
→ consumo real
~~~

Criar OP não significa automaticamente:

- baixar Insumo;
- reservar Insumo.

Essas regras pertencem à evolução do processo produtivo.

---

# 66. Facção

O sistema prevê produção terceirizada.

Fluxo conceitual:

~~~text
Insumos
        ↓
Envio à Facção
        ↓
Produção
        ↓
Retorno
        ↓
Produto Acabado
~~~

Os eventos físicos devem ser representados por movimentos adequados.

---

# 67. Distribuição

Distribuição representa envio de mercadoria do estoque central/fábrica para as Lojas.

~~~text
Origem
   ↓
Distribuição
   ↓
Loja A
Loja B
Loja C
~~~

Pode considerar:

- Produto;
- referência;
- Grade;
- Tamanho;
- percentuais;
- quantidades;
- estoque disponível.

---

# 68. Vendas

Venda representa o evento comercial.

~~~text
Cliente
+
Vendedor
+
Produto / SKU
+
Quantidade
+
Preço
+
Pagamento
=
Venda
~~~

Produto Venda participa do processo.

Uso/Consumo e Insumos não devem aparecer como mercadorias normais de venda.

---

# 69. PDV

O PDV é responsável pela operação de venda da Loja.

Deve considerar:

- Produto;
- SKU;
- preço;
- Estoque;
- Cliente;
- Funcionário/Vendedor;
- pagamento;
- Fiscal.

---

# 70. PDV Offline

Existe previsão de operação offline para Loja sem acesso à internet.

A arquitetura deve permitir base local mínima com:

- Produtos;
- SKUs;
- preços;
- Clientes necessários;
- configurações;
- dados fiscais necessários.

Vendas offline devem ser posteriormente sincronizadas com o SYSVAR central.

---

# 71. NFC-e no PDV Offline

O certificado fiscal pode permanecer na máquina da Loja responsável pela emissão.

A operação offline deve tratar adequadamente:

- emissão;
- contingência;
- fila;
- sincronização;
- reprocessamento;
- atualização do Estoque central.

Esse domínio exige documentação específica quando for implementado.

---

# 72. Fiscal

Fiscal é responsável por aplicar as regras tributárias às operações.

Produto mantém informações cadastrais.

~~~text
Produto
→ Dados Fiscais

Operação
→ aplicação Fiscal
~~~

Não confundir cadastro fiscal com documento fiscal.

No processo de Compras, a Nota Fiscal de Entrada representa o documento do recebimento.

---

# 73. Financeiro

Financeiro representa obrigações e direitos decorrentes das operações.

Exemplos:

~~~text
Compra
→ Contas a Pagar

Venda
→ Contas a Receber
~~~

No Pedido de Compra, a integração financeira ocorre na aprovação.

---

# 74. Contabilidade

O domínio contábil deve receber informações das operações sem substituir os módulos operacionais.

Integrações futuras podem envolver:

- Plano Contábil;
- Naturezas;
- centros;
- rateios;
- lançamentos;
- conciliações.

---

# 75. Auditoria como Camada Transversal

A Auditoria acompanha os diferentes domínios.

~~~text
Operacional
Cadastros
Produtos
Compras
Estoque
Produção
Vendas
Fiscal
Financeiro
        ↓
AuditLog
~~~

Quando aplicável.

---

# 76. Lifecycle

Cada domínio utiliza estados adequados ao seu significado.

Produto:

~~~text
ATIVO
INATIVO
~~~

Funcionário:

~~~text
ATIVO
AFASTADO
DESLIGADO
~~~

Pedido de Compra:

~~~text
AB
AP
AT
CA
~~~

Contrato:

~~~text
Estados contratuais próprios
~~~

Não utilizar um lifecycle genérico indiscriminadamente.

---

# 77. Exclusão Protegida

Regra geral:

~~~text
Nunca utilizado
→ exclusão pode ser possível

Já utilizado
→ preservar histórico
~~~

Alternativas dependem do domínio:

- Inativar;
- Bloquear;
- Desligar;
- Encerrar;
- Cancelar.

No Pedido de Compra:

~~~text
AB
→ pode ser excluído conforme regras

AP / AT / CA
→ preservar
~~~

---

# 78. Integridade Histórica

Configuração atual não deve reinterpretar operação antiga.

Exemplos:

~~~text
Grupo mudou CodigoRef
→ Referência antiga permanece

Pack mudou composição
→ Pedido antigo permanece

Cor foi retirada
→ SKU permanece histórico

Unidade mudou
→ movimento antigo não muda silenciosamente
~~~

---

# 79. Paginação e Filtros

Listagens de volume relevante devem utilizar:

~~~text
PAGINAÇÃO SERVER-SIDE
+
FILTROS SERVER-SIDE
~~~

Não carregar a base completa para paginar somente no navegador.

---

# 80. Padrão Visual

O SYSVAR utiliza identidade visual consistente entre as telas.

A estrutura geral considera barras funcionais como:

- Principal;
- Título;
- Indicadores;
- Filtros;
- Ações;
- Resultados.

Cada tela utiliza apenas as estruturas necessárias.

---

# 81. Padrão Visual dos Cadastros Auxiliares

Nas telas modernizadas de Produtos:

~~~text
Checkbox
+
Seleção única
+
Linha destacada
+
Barra de ações
~~~

Ações redundantes por linha foram removidas quando não necessárias.

---

# 82. Padrão Visual do Pedido de Compra

O Pedido de Compra segue a mesma orientação de clareza visual.

A tela principal concentra:

- informações gerais;
- indicadores;
- filtros;
- listagem;
- seleção;
- ações.

Estruturas subordinadas são tratadas em sobretelas/modais, principalmente:

- Itens;
- Forma de Pagamento;
- Recebimentos;
- aprovação com Natureza.

O objetivo é preservar uma tela principal limpa.

---

# 83. Master-Detail

Alguns cadastros utilizam mestre-detalhe.

~~~text
Grupo
→ Subgrupos

Grade
→ Tamanhos

Pack
→ Itens
~~~

O detalhe é apresentado no contexto do mestre correspondente.

---

# 84. Sobretelas e Modais

Consultas e detalhes podem ser exibidos em sobretela/modal quando isso preserva melhor o contexto operacional.

Exemplo:

~~~text
Selecionar
        ↓
Consultar
        ↓
Sobretela
        ↓
Fechar
        ↓
Retornar à listagem
~~~

Pedido de Compra utiliza esse princípio para suas estruturas subordinadas.

---

# 85. Backend como Autoridade

Princípio estrutural:

~~~text
FRONTEND
→ apresentação e experiência

BACKEND
→ regra de negócio e segurança
~~~

Não depender de:

- botão escondido;
- combo filtrado;
- campo desabilitado;
- rota Angular;
- validação JavaScript;

como única proteção.

---

# 86. Estratégia de Desenvolvimento

O processo geral de trabalho está definido em:

[[Protocolo de Trabalho com IA]]

Fluxo consolidado:

~~~text
ANÁLISE
        ↓
DEFINIÇÃO FUNCIONAL
        ↓
FECHAMENTO DAS REGRAS
        ↓
IMPLEMENTAÇÃO
        ↓
REVISÃO
        ↓
CORREÇÕES
        ↓
HOMOLOGAÇÃO
        ↓
APROVAÇÃO
        ↓
DOCUMENTAÇÃO
~~~

---

# 87. Uso do Codex

Os prompts devem seguir:

[[Padrao de Prompts para Codex]]

A utilização deve ser objetiva.

~~~text
Problema definido
        ↓
Análise prévia
        ↓
Prompt específico
        ↓
Implementação
        ↓
Testes proporcionais
        ↓
Revisão
        ↓
Homologação
~~~

Evitar investigação ampla pelo Codex quando o problema já estiver identificado.

---

# 88. Hierarquia de Fontes

Em caso de divergência, consultar:

[[Hierarquia de Fontes e Decisoes]]

Ordem básica:

~~~text
Nova decisão aprovada
        ↓
Documentação vigente
        ↓
Código atual
        ↓
Inferência técnica
~~~

Não inventar regra de negócio para preencher lacunas.

---

# 89. Estado Atual Consolidado

Em **16/08/2026**:

~~~text
OPERACIONAL
→ CONCLUÍDO
→ HOMOLOGADO
→ DOCUMENTADO

CLIENTES
→ CONCLUÍDO
→ 23/23
→ DOCUMENTADO

FORNECEDORES
→ CONCLUÍDO
→ 30/30
→ DOCUMENTADO

FUNCIONÁRIOS
→ CONCLUÍDO
→ 17/17
→ DOCUMENTADO

PRODUTO VENDA
→ CONCLUÍDO
→ 19/19
→ DOCUMENTADO

PRODUTO USO/CONSUMO
→ CONCLUÍDO
→ HOMOLOGADO
→ DOCUMENTADO

INSUMOS
→ CONCLUÍDO
→ HOMOLOGADO
→ DOCUMENTADO

CADASTROS AUXILIARES DE PRODUTOS
→ CONCLUÍDOS
→ HOMOLOGADOS
→ DOCUMENTADOS

PEDIDO DE COMPRA
→ UNIFICADO
→ CONCLUÍDO
→ TESTADO
→ HOMOLOGADO
→ APROVADO
→ DOCUMENTADO
~~~

---

# 90. Documentação de Produto Venda

- [[Homologação - Produtos - Produto Venda]]
- [[Mapa Técnico - Produtos - Produto Venda]]
- [[Workflows - Produtos - Produto Venda]]
- [[Modelo de Domínio - Produtos - Produto Venda]]
- [[Riscos e Cuidados - Produtos - Produto Venda]]

---

# 91. Documentação de Produto Uso/Consumo

- [[Homologação - Produtos - Produto Uso e Consumo]]
- [[Mapa Técnico - Produtos - Produto Uso e Consumo]]
- [[Workflows - Produtos - Produto Uso e Consumo]]
- [[Modelo de Domínio - Produtos - Produto Uso e Consumo]]
- [[Riscos e Cuidados - Produtos - Produto Uso e Consumo]]

---

# 92. Documentação de Insumos

- [[Homologação - Produtos - Insumos]]
- [[Mapa Técnico - Produtos - Insumos]]
- [[Workflows - Produtos - Insumos]]
- [[Modelo de Domínio - Produtos - Insumos]]
- [[Riscos e Cuidados - Produtos - Insumos]]

---

# 93. Documentação de Cadastros Auxiliares

- [[Homologação - Produtos - Cadastros Auxiliares]]
- [[Mapa Técnico - Produtos - Cadastros Auxiliares]]
- [[Workflows - Produtos - Cadastros Auxiliares]]
- [[Modelo de Domínio - Produtos - Cadastros Auxiliares]]
- [[Riscos e Cuidados - Produtos - Cadastros Auxiliares]]

---

# 94. Documentação de Compras

## Pedido de Compra

- [[Homologação - Compras - Pedido de Compra]]
- [[Mapa Técnico - Compras - Pedido de Compra]]
- [[Workflows - Compras - Pedido de Compra]]
- [[Modelo de Domínio - Compras - Pedido de Compra]]
- [[Riscos e Cuidados - Compras - Pedido de Compra]]

Situação:

~~~text
IMPLEMENTADO
TESTADO
HOMOLOGADO
APROVADO
DOCUMENTADO
~~~

---

# 95. Documentação Central

- [[Sysvar]]
- [[Mapa Técnico]]
- [[Modelo de Domínio]]
- [[Workflows]]
- [[Riscos e Cuidados]]
- [[Arquitetura]]
- [[Protocolo de Trabalho com IA]]
- [[Mapa de Consulta por Projeto]]

---

# 96. Próxima Evolução

O próximo domínio ou módulo deverá ser definido funcionalmente antes de nova implementação.

O processo deve começar por:

1. identificar o escopo;
2. analisar o que já existe;
3. identificar integrações;
4. definir responsabilidades;
5. definir regras;
6. verificar multiempresa;
7. verificar Permissões;
8. verificar Auditoria;
9. definir testes;
10. somente então implementar.

Não transportar automaticamente regras de um domínio para outro.

---

# 97. Princípio Final

~~~text
SYSVAR
não é apenas um conjunto de telas.

É uma cadeia integrada de domínios.

EMPRESA
define o tenant.

CADASTROS
definem as identidades.

PRODUTOS
definem os itens.

COMPRAS
adquirem e formalizam o compromisso de aquisição.

ESTOQUE
controla quantidade e localização.

PRODUÇÃO
transforma.

DISTRIBUIÇÃO
movimenta entre unidades.

VENDAS
comercializam.

FISCAL
documenta e tributa.

FINANCEIRO
controla obrigações e direitos.

AUDITORIA
preserva rastreabilidade.
~~~

---

# 98. Última Atualização

~~~text
16/08/2026
~~~

Este documento representa a visão geral consolidada do SYSVAR após:

- fechamento do ciclo cadastral atual de Produtos;
- conclusão;
- testes;
- homologação;
- aprovação;
- documentação do Pedido de Compra unificado.