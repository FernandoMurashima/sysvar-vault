---
type: reference
status: active
project: Sysvar
source: "C:/SysvarProjeto"
created: 2026-08-03
updated: 2026-08-14
tags:
  - sysvar
  - domínio
  - modelo
  - operacional
  - cadastros
  - produtos
  - produto-venda
  - produto-uso-consumo
  - insumos
  - cadastros-auxiliares
  - estoque
  - compras
  - produção
  - segurança
  - auditoria
  - multiempresa
  - homologado
---

# Modelo de Domínio

## 1. Objetivo

Este documento descreve as principais entidades e fronteiras funcionais do [[Sysvar]], suas responsabilidades e os relacionamentos fundamentais entre os diferentes domínios.

Ele representa uma **visão funcional e conceitual**.

Não é uma cópia direta:

- das tabelas do banco;
- dos models Django;
- dos serializers;
- dos componentes Angular.

Para localização técnica utilizar:

[[Mapa Técnico]]

Para fluxos:

[[Workflows]]

Para riscos:

[[Riscos e Cuidados]]

---

# 2. Organização Geral do Domínio

O Sysvar está organizado conceitualmente em:

- Plataforma;
- Empresas e Contratos;
- Estabelecimentos;
- Segurança e Acesso;
- Licenciamento e Sessões;
- Auditoria;
- Cadastros;
- Produtos;
- Compras;
- Estoque;
- Produção;
- Distribuição;
- Vendas e PDV;
- Fiscal;
- Financeiro;
- Contabilidade;
- Relatórios e Dashboards.

---

# 3. Princípio de Separação de Responsabilidades

Cada domínio deve preservar sua responsabilidade.

~~~text
CADASTRO
→ define identidade e parâmetros

COMPRAS
→ define aquisição

ESTOQUE
→ define quantidade e localização

FISCAL
→ aplica regras fiscais nas operações

PRODUÇÃO
→ transforma Insumos em Produtos

DISTRIBUIÇÃO
→ movimenta mercadoria entre unidades

PDV / VENDAS
→ realiza comercialização

FINANCEIRO
→ representa obrigações e recebimentos

AUDITORIA
→ registra rastreabilidade transversal
~~~

Não transportar automaticamente responsabilidade de um módulo para outro.

---

# 4. Empresa

Empresa é o principal limite de dados do cliente dentro do Sysvar.

Relacionamento conceitual:

~~~text
Plataforma
   ↓
Empresa
   ↓
Dados Empresariais
~~~

Uma Empresa pode possuir:

- Contrato;
- Estabelecimentos;
- Usuários;
- Perfis;
- Clientes;
- Fornecedores;
- Funcionários;
- Produtos;
- Estoques;
- operações;
- documentos;
- registros financeiros.

---

# 5. Multiempresa

A regra fundamental é:

~~~text
Empresa
=
limite do tenant
~~~

Dados privados de uma Empresa não podem ser utilizados por outra.

Exemplo inválido:

~~~text
Produto Empresa A
+
Grupo Empresa B
~~~

Outro exemplo:

~~~text
Pedido Empresa A
+
Fornecedor Empresa B
~~~

A validação final pertence ao backend.

---

# 6. Empresa e Estabelecimentos

Relacionamento:

~~~text
Empresa 1:N Estabelecimento
~~~

Estabelecimentos representam unidades operacionais.

Podem possuir funções como:

~~~text
LOJA
MATRIZ
FÁBRICA
~~~

O Estabelecimento fornece contexto operacional.

Não substitui a Empresa como tenant.

---

# 7. Empresa e Contrato

A Empresa cliente possui contexto contratual.

Conceitualmente:

~~~text
Empresa
   ↓
Contrato
   ├── Status
   ├── Vigência
   ├── Módulos
   └── Limite de Sessões
~~~

O Contrato controla o direito de utilização da plataforma.

---

# 8. Usuário

Usuário representa identidade de autenticação.

Responsabilidades:

- credenciais;
- Empresa;
- Perfil;
- acesso;
- Estabelecimentos permitidos;
- sessão;
- Permissões;
- contexto operacional.

Separação importante:

~~~text
Usuário
!=
Funcionário
~~~

---

# 9. Funcionário

Funcionário representa identidade operacional da pessoa dentro da Empresa.

Pode possuir:

- Cargo;
- Loja Principal;
- Lojas supervisionadas;
- comissão;
- Usuário opcional.

Não representa mecanismo de autenticação.

Não representa Perfil de acesso.

---

# 10. Funcionário e Usuário

Relacionamento conceitual:

~~~text
Funcionário
   ↓
Usuário opcional
~~~

Não existe equivalência:

~~~text
Funcionário = Usuário
~~~

Nem:

~~~text
Cargo = Perfil
~~~

Nem:

~~~text
Cargo = Permissão
~~~

---

# 11. Perfil de Acesso

Perfil organiza Permissões funcionais.

~~~text
Empresa
   ↓
Perfil
   ↓
Permissões por Módulo
~~~

Usuário pode receber:

- Permissões herdadas do Perfil;
- overrides individuais.

---

# 12. Permissão Efetiva

Conceitualmente:

~~~text
Contrato
+
Módulo contratado
+
Perfil
+
Override
+
Contexto do Usuário
=
Permissão Efetiva
~~~

A Permissão efetiva não deve depender apenas do nome do Cargo ou Perfil.

---

# 13. Sessão

Sessão representa uma utilização autenticada válida do sistema.

~~~text
Usuário
   ↓
Sessão
   ↓
Token
~~~

Licenciamento simultâneo utiliza Sessões válidas.

---

# 14. Licenciamento

Regra homologada:

~~~text
LICENÇA
=
SESSÃO VÁLIDA
~~~

Não:

~~~text
LICENÇA
=
USUÁRIO CADASTRADO
~~~

Uma Empresa pode possuir muitos Usuários e um limite menor de Sessões simultâneas.

---

# 15. Auditoria

Auditoria é transversal.

~~~text
Usuário
   ↓
Ação
   ↓
Objeto / Processo
   ↓
AuditLog
~~~

Pode registrar eventos de:

- Operacional;
- Cadastros;
- Produtos;
- Segurança;
- lifecycle;
- alterações críticas;
- operações administrativas.

Auditoria não substitui Históricos Funcionais específicos.

---

# 16. Cliente

Cliente representa pessoa física, pessoa jurídica ou consumidor sem documento quando permitido.

Relacionamento:

~~~text
Empresa 1:N Cliente
~~~

Unicidade documental deve respeitar Empresa.

~~~text
Empresa + documento
~~~

---

# 17. Consumidor Final

Cada Empresa possui seu próprio Cliente padrão para operações sem identificação nominal.

~~~text
Empresa
   ↓
Consumidor Final
~~~

Não existe Consumidor Final global compartilhado entre Empresas.

---

# 18. Fornecedor

Fornecedor representa a entidade da qual a Empresa adquire Produtos, materiais ou serviços.

Pode possuir categorias como:

- matéria-prima;
- aviamento;
- revenda;
- facção;
- prestador;
- transportadora;
- outros.

Relacionamentos principais:

~~~text
Fornecedor
   ├── Compras
   ├── Financeiro
   ├── Fiscal
   └── Produção / Facção quando aplicável
~~~

---

# 19. Produtos — Modelo Geral

O conceito `Produto` é compartilhado por domínios distintos.

~~~text
Produto
   │
   ├── tipo 1 → Revenda
   │
   ├── tipo 2 → Uso/Consumo
   │
   ├── tipo 3 → Fabricação Própria
   │
   └── tipo 4 → Insumo
~~~

Compartilhar identidade técnica não significa compartilhar todas as regras funcionais.

---

# 20. Produto Venda

Produto Venda engloba:

~~~text
tipo 1 = Revenda
tipo 3 = Fabricação Própria
~~~

Representa itens destinados à comercialização.

Documentação específica:

- [[Homologação - Produtos - Produto Venda]]
- [[Mapa Técnico - Produtos - Produto Venda]]
- [[Workflows - Produtos - Produto Venda]]
- [[Modelo de Domínio - Produtos - Produto Venda]]
- [[Riscos e Cuidados - Produtos - Produto Venda]]

---

# 21. Produto Venda — Identidade

Produto Venda possui identidade própria.

Pode utilizar:

- Grupo;
- Subgrupo;
- Coleção;
- Unidade;
- Grade;
- Cores;
- Dados Fiscais;
- imagens;
- preços;
- SKUs.

Referência:

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

---

# 22. Produto versus SKU

Separação fundamental:

~~~text
Produto
!=
SKU
~~~

SKU representa uma variação comercial.

~~~text
Produto
+
Cor
+
Tamanho
=
SKU
~~~

---

# 23. ProdutoDetalhe / SKU

Conceitualmente:

~~~text
Produto Venda 1:N SKU
~~~

SKU possui identidade própria e pode relacionar:

- Cor;
- Tamanho;
- EAN;
- Status;
- Estoque;
- custos relacionados.

---

# 24. Grade

Grade representa um conjunto de Tamanhos.

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

Produto Venda utiliza Grade para definir suas variações.

---

# 25. Cor

Cor fornece característica cromática da variação comercial.

~~~text
Produto
+
Cor
+
Tamanho
→ SKU
~~~

Cor isoladamente não representa SKU.

---

# 26. EAN

EAN pertence ao SKU.

~~~text
Produto
→ Referência

SKU
→ EAN
~~~

EAN deve preservar identidade histórica.

Inativação e reativação não devem criar novo EAN para o mesmo SKU.

---

# 27. Produto Venda — Revenda

Fluxo conceitual:

~~~text
Produto Venda
Tipo 1
   ↓
SKU
   ↓
Compra
   ↓
Recebimento
   ↓
Estoque
   ↓
Venda
~~~

Compras controla aquisição.

Produto apenas fornece identidade comercial.

---

# 28. Produto Venda — Fabricação Própria

Fluxo conceitual:

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

Produto Venda não substitui o módulo Produção.

---

# 29. Produto Venda — Lifecycle

Dois conceitos devem permanecer independentes.

Estado cadastral:

~~~text
ATIVO
INATIVO
~~~

Estado comercial:

~~~text
LIBERADO
BLOQUEADO
~~~

Logo:

~~~text
Produto Ativo
não significa necessariamente
Produto Liberado para Venda
~~~

---

# 30. Produto Uso/Consumo

Tipo:

~~~text
tipo_produto = '2'
~~~

Representa itens destinados ao consumo interno não produtivo da Empresa.

Exemplos:

- limpeza;
- escritório;
- manutenção;
- materiais internos.

Documentação:

- [[Homologação - Produtos - Produto Uso e Consumo]]
- [[Mapa Técnico - Produtos - Produto Uso e Consumo]]
- [[Workflows - Produtos - Produto Uso e Consumo]]
- [[Modelo de Domínio - Produtos - Produto Uso e Consumo]]
- [[Riscos e Cuidados - Produtos - Produto Uso e Consumo]]

---

# 31. Uso/Consumo não é Produto Venda

Não necessita automaticamente de:

- Grade;
- Cor × Tamanho;
- SKU comercial;
- Coleção;
- Pack;
- Tabela de Preço comercial;
- Promoção;
- Bloqueio de Venda.

---

# 32. Uso/Consumo não é Insumo

Separação:

~~~text
Uso/Consumo
→ consumo interno não produtivo

Insumo
→ consumo produtivo
~~~

Produto Uso/Consumo não deve entrar automaticamente em Ficha Técnica.

---

# 33. Estoque de Uso/Consumo

Produto Uso/Consumo possui natureza de Estoque.

Entretanto:

~~~text
Produto
!=
Estoque
~~~

O cadastro define o item.

Estoque define:

- quantidade;
- localização;
- movimentos.

Não existe necessidade de campo:

~~~text
controla_estoque
~~~

no domínio homologado.

---

# 34. Localização de Uso/Consumo

O cadastro não fixa:

- Matriz;
- Loja;
- depósito;
- outro local.

~~~text
Operação
→ define Local
~~~

---

# 35. Insumo

Tipo:

~~~text
tipo_produto = '4'
~~~

Insumo representa material utilizado diretamente na fabricação.

Exemplos:

- tecido;
- linha;
- botão;
- zíper;
- etiqueta;
- elástico;
- aviamentos.

Documentação:

- [[Homologação - Produtos - Insumos]]
- [[Mapa Técnico - Produtos - Insumos]]
- [[Workflows - Produtos - Insumos]]
- [[Modelo de Domínio - Produtos - Insumos]]
- [[Riscos e Cuidados - Produtos - Insumos]]

---

# 36. Insumo e Unidade

Unidade define como o material é quantificado.

~~~text
Tecido
→ M

Botão
→ UN

Material líquido
→ LT
~~~

A propriedade:

~~~text
permite_decimal
~~~

orienta os processos que manipulam quantidade.

---

# 37. Insumo e Material

Material é classificação opcional.

~~~text
Material
→ classificação

Insumo
→ item operacional
~~~

Exemplo:

~~~text
Material:
Algodão

Insumo:
Tecido Tricoline Branco
~~~

---

# 38. Insumo e Estoque

Todo Insumo possui natureza de Estoque.

O cadastro não define sua localização física.

~~~text
Insumo
→ identidade

Estoque
→ quantidade + localização
~~~

O mesmo Insumo pode estar em locais diferentes durante seu ciclo operacional.

---

# 39. Ficha Técnica

Ficha Técnica representa a composição prevista de um Produto de Fabricação Própria.

~~~text
Produto Fabricação Própria
        ↓
Ficha Técnica
        ↓
Itens
        ↓
Insumos
~~~

---

# 40. Quantidade do Insumo na Ficha Técnica

A quantidade necessária não pertence ao Insumo.

Pertence à relação:

~~~text
Ficha Técnica
+
Insumo
+
Quantidade
~~~

Exemplo:

~~~text
Tecido A

Camisa
→ 1,80 M

Vestido
→ 2,40 M
~~~

---

# 41. Mesmo Insumo em Múltiplas Fichas

Relacionamento conceitual:

~~~text
Insumo
   ↓
múltiplos Itens de Ficha Técnica
~~~

Não duplicar cadastro do material apenas porque ele participa de Produtos diferentes.

---

# 42. Ordem de Produção

Ordem de Produção representa uma execução planejada de fabricação.

Conceitualmente:

~~~text
OP
   ↓
Produto Fabricação Própria
   ↓
Quantidade a Produzir
   ↓
Ficha Técnica
   ↓
Necessidades de Insumos
~~~

---

# 43. OP não é Consumo

Regra atual:

~~~text
CRIAR OP
!=
CONSUMIR INSUMOS
~~~

O evento físico de consumo deve pertencer ao processo produtivo apropriado.

---

# 44. OP não é Reserva Automática

Também:

~~~text
CRIAR OP
!=
RESERVAR INSUMOS AUTOMATICAMENTE
~~~

Reserva ainda deve ser definida no domínio operacional de Produção/Estoque.

---

# 45. Consumo Previsto e Consumo Real

Separação:

~~~text
Ficha Técnica
→ Consumo Previsto

Produção
→ Consumo Real
~~~

Essa separação será importante para:

- perdas;
- sobras;
- eficiência;
- custos;
- planejamento.

---

# 46. Cadastros Auxiliares de Produtos

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
- Item do Pack.

Documentação:

- [[Homologação - Produtos - Cadastros Auxiliares]]
- [[Mapa Técnico - Produtos - Cadastros Auxiliares]]
- [[Workflows - Produtos - Cadastros Auxiliares]]
- [[Modelo de Domínio - Produtos - Cadastros Auxiliares]]
- [[Riscos e Cuidados - Produtos - Cadastros Auxiliares]]

---

# 47. Grupo e Subgrupo

Relacionamento:

~~~text
Grupo 1:N Subgrupo
~~~

Grupo pode fornecer:

- classificação;
- Código;
- Código de Referência;
- Margem.

Subgrupo especializa o Grupo.

---

# 48. Código de Referência do Grupo

Formato:

~~~text
2 dígitos numéricos
~~~

O Código de Referência participa da Referência de Produto Venda.

~~~text
AA-BB-CCDDD
      ↑
      CC
~~~

---

# 49. Coleção

Coleção representa:

~~~text
Ano
+
Estação
~~~

Estações homologadas:

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

# 50. Unidade

Unidade representa **como medir**.

Não representa quantidade.

~~~text
Unidade
→ como quantificar

Quantidade
→ quanto existe / quanto foi utilizado
~~~

---

# 51. Pack

Pack representa composição de quantidades por Tamanho.

~~~text
Grade
   ↓
Pack
   ↓
Itens
   ↓
Tamanho + Quantidade
~~~

Invariantes:

~~~text
Tamanho pertence à Grade do Pack

Tamanho não repete no mesmo Pack

Quantidade > 0
~~~

---

# 52. Pack e Compras

Pack pode ser utilizado para determinar quantidade de peças.

~~~text
n_packs
×
soma_itens_pack
=
quantidade de peças
~~~

A operação de Compra preserva o resultado histórico utilizado naquele Pedido.

---

# 53. Compras

Pedido de Compra representa a aquisição.

Relacionamentos principais:

~~~text
Empresa
   ↓
Pedido de Compra
   ├── Fornecedor
   ├── Loja / Destino
   ├── Itens
   ├── Forma de Pagamento
   └── Parcelas
~~~

Itens podem envolver diferentes domínios de Produto conforme as regras do processo.

---

# 54. Compra não é Produto

Separação:

~~~text
Produto
→ o que está sendo adquirido

Pedido de Compra
→ evento de aquisição
~~~

O cadastro de Produto não deve incorporar o processo de compra.

---

# 55. Recebimento

Recebimento representa o evento físico da chegada da mercadoria/material.

~~~text
Pedido
   ↓
Recebimento
   ↓
Entrada
   ↓
Estoque
~~~

Pode também originar efeitos:

- fiscais;
- financeiros;
- de custo.

---

# 56. Estoque

Estoque representa a posição física dos itens.

Conceitualmente:

~~~text
Produto / SKU
+
Local
+
Movimentos
=
Saldo
~~~

Estoque não é propriedade simples do cadastro do Produto.

---

# 57. Estoque de Produto Venda

Granularidade consolidada:

~~~text
Loja × SKU
~~~

O SKU é a unidade comercial de variação.

---

# 58. Estoque de Uso/Consumo

Conceitualmente:

~~~text
Produto tipo 2
+
Local da Operação
=
Posição de Estoque
~~~

Não existe localização fixa definida no cadastro.

---

# 59. Estoque de Insumos

Conceitualmente:

~~~text
Insumo tipo 4
+
Local da Operação
=
Posição de Estoque
~~~

Pode existir material em:

- estoque central;
- fábrica;
- almoxarifado;
- trânsito;
- futuramente em poder de facção.

---

# 60. Movimento de Estoque

Saldo deve resultar de eventos.

~~~text
Entradas
-
Saídas
=
Saldo
~~~

Movimento pode representar:

- Compra;
- recebimento;
- transferência;
- venda;
- ajuste;
- inventário;
- futura Produção;
- devolução.

---

# 61. Fiscal

Produto mantém dados fiscais cadastrais.

O módulo Fiscal aplica os dados à operação.

~~~text
Produto
→ Classificação Fiscal

Operação
→ Tributação aplicada
~~~

Não confundir Cadastro Fiscal com emissão fiscal.

---

# 62. Venda

Venda representa evento comercial.

Conceitualmente:

~~~text
Cliente
+
Vendedor
+
Produtos / SKUs
+
Quantidade
+
Preço
+
Pagamento
=
Venda
~~~

Produto Uso/Consumo e Insumos não pertencem normalmente a esse fluxo.

---

# 63. PDV

PDV utiliza Produto Venda.

Fluxo conceitual:

~~~text
Produto Venda
   ↓
SKU
   ↓
Preço
   ↓
Estoque
   ↓
Fiscal
   ↓
Venda
~~~

A decisão final de comercialização pertence ao domínio Vendas/PDV.

---

# 64. Financeiro

Financeiro representa obrigações e direitos decorrentes das operações.

Exemplos:

~~~text
Compra
→ Contas a Pagar

Venda
→ Contas a Receber
~~~

Não deve ser confundido com o evento que originou a obrigação.

---

# 65. Pagar

Conceitualmente:

~~~text
Fornecedor
   ↓
Pagar
   ↓
Parcelas
   ↓
Baixas
~~~

Pode ter origem em:

- Pedido de Compra;
- documento fiscal;
- outras obrigações.

---

# 66. Produção

Produção transforma materiais em Produto acabado.

~~~text
Insumos
   ↓
Ficha Técnica
   ↓
Ordem de Produção
   ↓
Processo Produtivo
   ↓
Produto Venda tipo 3
~~~

---

# 67. Facção

Facção é um Fornecedor/Prestador participante do processo produtivo quando a fabricação ocorre com terceiro.

Fluxo conceitual futuro:

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

Movimentos físicos devem ser representados operacionalmente.

---

# 68. Distribuição

Distribuição representa movimentação da fábrica/estoque central para as Lojas.

Conceitualmente:

~~~text
Estoque Origem
   ↓
Distribuição
   ↓
Quantidade por Loja
   ↓
Saída Origem
   ↓
Entrada Destino
~~~

Pode trabalhar com:

- distribuição manual;
- percentuais;
- Grade;
- Tamanho;
- Produtos de Revenda;
- Produtos de Fabricação Própria.

---

# 69. Auditoria versus Histórico Funcional

Separação:

~~~text
Histórico Funcional
→ explica evolução do domínio

AuditLog
→ registra ação auditável do sistema
~~~

Exemplo:

~~~text
ProdutoVendaHistorico
!=
AuditLog
~~~

---

# 70. Lifecycle

Nem todos os domínios utilizam o mesmo conjunto de estados.

Exemplos:

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

Contrato:

~~~text
possui estados próprios
~~~

Não criar um único enum genérico para domínios com significados diferentes.

---

# 71. Exclusão Protegida

Regra geral:

~~~text
Registro nunca utilizado
→ pode ser excluível

Registro utilizado
→ preservar histórico
~~~

Dependendo do domínio, utilizar:

- Inativação;
- Desligamento;
- Bloqueio;
- Encerramento.

---

# 72. Integridade Histórica

Mudança cadastral futura não deve reinterpretar operação passada.

Exemplos:

~~~text
Grupo mudou CodigoRef
→ Referência antiga permanece

Pack mudou composição
→ Pedido antigo permanece

Unidade mudou
→ movimento histórico não muda de significado

Cor foi retirada
→ SKU histórico permanece
~~~

---

# 73. Modelo Consolidado de Produtos

~~~text
                              EMPRESA
                                 │
                                 ↓
                              PRODUTO
                                 │
          ┌──────────────────────┼──────────────────────┐
          │                      │                      │
          ↓                      ↓                      ↓
   PRODUTO VENDA           USO/CONSUMO              INSUMO
    tipos 1 e 3              tipo 2                  tipo 4
          │                      │                      │
          ↓                      ↓                      ↓
     Comercialização        Uso interno              Produção
          │                      │                      │
          ↓                      ↓                      ↓
         SKU                  Estoque                Estoque
          │                                             │
          ↓                                             ↓
       Estoque                                    Ficha Técnica
          │                                             │
          ↓                                             ↓
        Venda                                      Produto tipo 3
~~~

---

# 74. Relação dos Cadastros Auxiliares

~~~text
Grupo ───────────────┐
Subgrupo ────────────┤
Coleção ─────────────┤
Grade ───────────────┤
Tamanho ─────────────┤
Cor ─────────────────┤
Unidade ─────────────┤
Pack ────────────────┤
                     ↓
                PRODUTO VENDA

Unidade ─────────────→ PRODUTO USO/CONSUMO

Unidade ─────────────→ INSUMO
Material ────────────→ INSUMO
~~~

Cada Produto utiliza somente os auxiliares aplicáveis ao seu domínio.

---

# 75. Relação Produto × Compras × Estoque

~~~text
Produto
   ↓
Pedido de Compra
   ↓
Recebimento
   ↓
Movimento de Entrada
   ↓
Estoque
~~~

Produto não executa Compra.

Pedido não representa Saldo.

Estoque não representa Cadastro.

---

# 76. Relação Produto × Produção

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
        ↓
Estoque
~~~

---

# 77. Relação Produto × Venda

~~~text
Produto Venda
   ↓
SKU
   ↓
Preço
   ↓
Estoque
   ↓
Venda
   ↓
Fiscal
   ↓
Financeiro
~~~

Cada módulo continua com sua responsabilidade própria.

---

# 78. Estado dos Domínios Consolidados

## Operacional

~~~text
CONCLUÍDO
HOMOLOGADO
DOCUMENTADO
~~~

## Clientes

~~~text
23/23
CONCLUÍDO
~~~

## Fornecedores

~~~text
30/30
CONCLUÍDO
~~~

## Funcionários

~~~text
17/17
CONCLUÍDO
~~~

## Produto Venda

~~~text
19/19
CONCLUÍDO
~~~

## Produto Uso/Consumo

~~~text
CONCLUÍDO
HOMOLOGADO
DOCUMENTADO
~~~

## Insumos

~~~text
CONCLUÍDO
HOMOLOGADO
DOCUMENTADO
~~~

## Cadastros Auxiliares de Produtos

~~~text
CONCLUÍDOS
HOMOLOGADOS
DOCUMENTADOS
~~~

---

# 79. Documentação de Produto Venda

- [[Homologação - Produtos - Produto Venda]]
- [[Mapa Técnico - Produtos - Produto Venda]]
- [[Workflows - Produtos - Produto Venda]]
- [[Modelo de Domínio - Produtos - Produto Venda]]
- [[Riscos e Cuidados - Produtos - Produto Venda]]

---

# 80. Documentação de Produto Uso/Consumo

- [[Homologação - Produtos - Produto Uso e Consumo]]
- [[Mapa Técnico - Produtos - Produto Uso e Consumo]]
- [[Workflows - Produtos - Produto Uso e Consumo]]
- [[Modelo de Domínio - Produtos - Produto Uso e Consumo]]
- [[Riscos e Cuidados - Produtos - Produto Uso e Consumo]]

---

# 81. Documentação de Insumos

- [[Homologação - Produtos - Insumos]]
- [[Mapa Técnico - Produtos - Insumos]]
- [[Workflows - Produtos - Insumos]]
- [[Modelo de Domínio - Produtos - Insumos]]
- [[Riscos e Cuidados - Produtos - Insumos]]

---

# 82. Documentação de Cadastros Auxiliares

- [[Homologação - Produtos - Cadastros Auxiliares]]
- [[Mapa Técnico - Produtos - Cadastros Auxiliares]]
- [[Workflows - Produtos - Cadastros Auxiliares]]
- [[Modelo de Domínio - Produtos - Cadastros Auxiliares]]
- [[Riscos e Cuidados - Produtos - Cadastros Auxiliares]]

---

# 83. Regras de Evolução do Domínio

Antes de ampliar qualquer entidade:

1. identificar a responsabilidade real;
2. verificar se existe domínio responsável;
3. não duplicar informação;
4. preservar multiempresa;
5. preservar integridade histórica;
6. verificar módulos consumidores;
7. verificar lifecycle;
8. verificar Auditoria;
9. verificar efeitos no Estoque;
10. verificar efeitos fiscais;
11. somente então alterar a estrutura.

---

# 84. Princípio Central

O modelo do Sysvar deve continuar respeitando:

~~~text
EMPRESA
define o tenant.

CADASTROS
definem identidades.

PRODUTOS
definem itens.

COMPRAS
adquirem.

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

# 85. Navegação Documental

## Projeto

- [[Sysvar]]
- [[Mapa Técnico]]
- [[Workflows]]
- [[Riscos e Cuidados]]
- [[10 Projetos/Sysvar/Contexto do Projeto/Visão Geral|Visão Geral]]
- [[10 Projetos/Sysvar/Contexto do Projeto/Arquitetura|Arquitetura]]

## Produtos

- [[Modelo de Domínio - Produtos - Produto Venda]]
- [[Modelo de Domínio - Produtos - Produto Uso e Consumo]]
- [[Modelo de Domínio - Produtos - Insumos]]
- [[Modelo de Domínio - Produtos - Cadastros Auxiliares]]

## Cadastros

- [[Modelo de Domínio - Cadastros - Clientes]]
- [[Modelo de Domínio - Cadastros - Fornecedores]]
- [[Modelo de Domínio - Cadastros - Funcionários]]

---

# 86. Estado do Modelo em 14/08/2026

O Modelo de Domínio central está consolidado até o fechamento dos seguintes blocos:

~~~text
OPERACIONAL

CLIENTES

FORNECEDORES

FUNCIONÁRIOS

PRODUTO VENDA

PRODUTO USO/CONSUMO

INSUMOS

CADASTROS AUXILIARES DE PRODUTOS
~~~

Os módulos seguintes devem ser incorporados a este documento somente após suas respectivas regras funcionais serem analisadas, implementadas e homologadas.