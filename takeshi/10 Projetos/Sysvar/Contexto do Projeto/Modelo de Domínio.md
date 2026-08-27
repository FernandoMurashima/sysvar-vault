---
type: reference
status: active
project: Sysvar
source: "C:/SysvarProjeto"
created: 2026-08-03
updated: 2026-08-27
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
  - pedido-de-compra
  - entrada-nfe
  - cotacao
  - almoxarifado
  - ti
  - manutencao
  - ordem-de-servico
  - requisicoes
  - financeiro
  - fiscal
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
- Compras;
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
Pedido de Compra
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

Fabricação Própria não participa do Pedido de Compra.

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

A propriedade:

~~~text
permite_decimal
~~~

também participa das validações de quantidade em Pedido de Compra para Uso/Consumo e Insumos.

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

Pack é utilizado na aquisição de Produto de Revenda.

~~~text
n_packs
×
soma_itens_pack
=
quantidade de peças
~~~

A quantidade é derivada do Pack.

A operação de Compra preserva o resultado histórico utilizado naquele Pedido.

Mudança posterior na composição do Pack não deve reinterpretar Pedido antigo.

---

# 53. Grupo Compras

Compras representa o domínio das necessidades internas, aquisição e recebimento.

Os processos formalmente encerrados desse grupo incluem:

~~~text
Necessidade Interna
        ↓
Requisição
        ↓
Atendimento Interno
ou
Ordem de Serviço
ou
Cotação
        ↓
Pedido de Compra
        ↓
Entrada de NF-e
~~~

Situação:

~~~text
REQUISIÇÕES INTERNAS
IMPLEMENTADAS
TESTADAS
HOMOLOGADAS
APROVADAS
DOCUMENTADAS

ORDENS DE SERVIÇO
IMPLEMENTADAS
TESTADAS
HOMOLOGADAS
APROVADAS
DOCUMENTADAS

PEDIDO DE COMPRA
IMPLEMENTADO
TESTADO
HOMOLOGADO
APROVADO
DOCUMENTADO

ENTRADA DE NF-e
IMPLEMENTADA
TESTADA
HOMOLOGADA
APROVADA
DOCUMENTADA
~~~

Requisição representa uma necessidade interna da Empresa.

Ordem de Serviço representa a execução operacional de necessidades de Manutenção ou TI.

Pedido de Compra representa a intenção formal de aquisição.

Entrada de NF-e representa o recebimento efetivo dessa aquisição.

Documentação específica de Requisições e Ordens de Serviço:

- [[Homologação - Compras - Requisições e Ordens de Serviço]]
- [[Mapa Técnico - Compras - Requisições e Ordens de Serviço]]
- [[Workflows - Compras - Requisições e Ordens de Serviço]]
- [[Modelo de Domínio - Compras - Requisições e Ordens de Serviço]]
- [[Riscos e Cuidados - Compras - Requisições e Ordens de Serviço]]

Documentação específica do Pedido de Compra:

- [[Homologação - Compras - Pedido de Compra]]
- [[Mapa Técnico - Compras - Pedido de Compra]]
- [[Workflows - Compras - Pedido de Compra]]
- [[Modelo de Domínio - Compras - Pedido de Compra]]
- [[Riscos e Cuidados - Compras - Pedido de Compra]]

Documentação específica da Entrada de NF-e:

- [[Homologação - Compras - Entrada de NF-e]]
- [[Mapa Técnico - Compras - Entrada de NF-e]]
- [[Workflows - Compras - Entrada de NF-e]]
- [[Modelo de Domínio - Compras - Entrada de NF-e]]
- [[Riscos e Cuidados - Compras - Entrada de NF-e]]

---

# Requisição Interna

Requisição representa uma necessidade interna originada por uma Loja e um Setor.

Relacionamento conceitual:

~~~text
Empresa
   ↓
Requisição
   ├── Loja
   ├── Setor
   ├── Tipo
   ├── Itens
   └── Histórico
~~~

Tipos homologados:

~~~text
USO_CONSUMO
MANUTENCAO
TI
~~~

A Requisição não representa necessariamente uma compra.

Ela pode ser resolvida internamente.

---

# Origem da Necessidade

A origem é composta por:

~~~text
Loja
+
Setor solicitante
~~~

Essa origem não deve ser confundida com:

- setor que atenderá;
- setor responsável pela compra;
- localização física do estoque.

Regra:

~~~text
Origem da necessidade
!=
Responsável pelo atendimento
!=
Responsável pela aquisição
~~~

---

# Setor da Requisição

O Setor solicitante pertence à Loja escolhida.

~~~text
Loja
1
↓
N
Setores
~~~

Uma Requisição não pode apontar para Setor de outra Loja.

---

# Matriz de Responsabilidade

A Matriz define a responsabilidade operacional por tipo de Requisição.

Relacionamento:

~~~text
Empresa
+
Tipo de Requisição
        ↓
Matriz
        ├── Setor de Atendimento
        └── Setor de Aquisição
~~~

A Matriz é configuração empresarial.

Não pertence à Requisição como texto livre.

---

# Requisição de Uso/Consumo

Uso/Consumo representa necessidade de item interno não produtivo.

Fluxo conceitual com estoque:

~~~text
Requisição
→ Almoxarifado Central
→ Estoque
→ Atendimento
~~~

Sem estoque:

~~~text
Requisição
→ Necessidade de Compra
→ Cotação
→ Pedido
→ NF-e
→ Estoque
→ Atendimento
~~~

---

# Almoxarifado Central

Almoxarifado representa o responsável pelo atendimento físico de Uso/Consumo.

A localização do estoque decorre do Setor de Atendimento configurado.

~~~text
Setor de Atendimento
→ Loja associada
→ Estoque físico
~~~

A Loja solicitante não é automaticamente a origem do estoque.

---

# Requisição de Manutenção e TI

Manutenção e TI possuem execução operacional própria.

~~~text
Requisição aprovada
→ Ordem de Serviço
~~~

A Requisição continua representando a necessidade.

A OS representa a execução.

---

# Ordem de Serviço

Relacionamento:

~~~text
Requisição
1
↓
1
Ordem de Serviço
~~~

A OS é criada somente após aprovação.

~~~text
RASCUNHO
→ sem OS

AGUARDANDO_APROVACAO
→ sem OS

APROVADA
→ cria/garante OS
~~~

A relação deve permanecer idempotente.

---

# Ordem de Serviço como Fonte Operacional

Depois de criada:

~~~text
OS
→ fonte do estado operacional
~~~

Estados de execução mantêm a Requisição em atendimento.

~~~text
OS CONCLUIDA
→ Requisição CONCLUIDA
~~~

Cancelar a OS não significa cancelar automaticamente a Requisição.

---

# Material da Ordem de Serviço

Materiais necessários pertencem à OS.

Relacionamento:

~~~text
Ordem de Serviço
1
↓
N
OrdemServicoMaterial
~~~

O material representa necessidade física para execução.

Não criar nova Requisição para o mesmo material.

---

# Estados do Material

Estados homologados:

~~~text
PENDENTE
DISPONIVEL
EM_COMPRA
ATENDIDA
CANCELADA
~~~

Separação:

~~~text
DISPONIVEL
→ existe saldo

ATENDIDA
→ baixa realizada
~~~

Disponibilidade não é atendimento.

---

# Necessidade de Compra

Necessidades internas podem originar aquisição.

Origens homologadas:

~~~text
REQ
→ Item de Requisição de Uso/Consumo

OS
→ Material de Ordem de Serviço
~~~

Essas origens alimentam o mesmo processo de Cotação.

---

# Necessidade Líquida

A necessidade real considera:

~~~text
Quantidade pendente
-
Estoque disponível
-
Quantidade já coberta por compra
~~~

Não criar nova aquisição para quantidade já coberta.

---

# Não Duplicação entre Requisição e OS

Para Manutenção e TI:

~~~text
Requisição
→ cria OS

Material necessário
→ nasce na OS
~~~

O item original da Requisição não deve gerar simultaneamente outra necessidade física.

Invariante:

~~~text
mesma necessidade
!=
REQ + OS
~~~

---

# Cotação como Continuidade da Necessidade

Cotação não substitui a Requisição.

Relacionamento conceitual:

~~~text
Necessidade
→ Cotação
→ Propostas
→ Fornecedor vencedor
→ Pedido de Compra
~~~

A Cotação é o processo de escolha comercial para uma necessidade já identificada.

---

# Entrada de NF-e e Disponibilidade

A NF-e representa entrada física.

Após o recebimento:

~~~text
NF-e
→ Estoque
→ Necessidade recalculada
~~~

Exemplo:

~~~text
Material OS EM_COMPRA
→ DISPONIVEL
~~~

---

# Estoque de Uso/Consumo

Produto tipo:

~~~text
2
~~~

utiliza domínio de estoque próprio:

~~~text
ProdutoUsoConsumoEstoque
ProdutoUsoConsumoMovimentacao
~~~

Esse comportamento independe da origem da aquisição.

---

# Atendimento

Atendimento representa execução física.

Para Uso/Consumo:

~~~text
Estoque
→ baixa
→ Requisição atendida
~~~

Para material da OS:

~~~text
DISPONIVEL
→ baixa
→ ATENDIDA
~~~

Atender material não conclui automaticamente a Ordem de Serviço.

---

# Conclusão

Requisição concluída representa necessidade encerrada.

OS concluída representa execução encerrada.

Ambas permanecem como histórico.

~~~text
CONCLUIDA
→ consultável
→ operacionalmente imutável
~~~

---
# 54. Pedido de Compra

Pedido de Compra representa a intenção formal de aquisição.

Relacionamentos principais:

~~~text
Empresa
   ↓
PedidoCompra
   ├── Loja
   ├── Fornecedor
   ├── Itens
   ├── Forma de Pagamento
   ├── Prazo
   ├── Parcelas Planejadas
   └── Entregas / Recebimentos
~~~

O Pedido não representa:

- Nota Fiscal;
- entrada física;
- saldo de Estoque;
- pagamento realizado.

---

# 55. Agregado de Pedido de Compra

A raiz do agregado é:

~~~text
PedidoCompra
~~~

Estruturas subordinadas:

~~~text
PedidoCompra
├── PedidoCompraItem
│   └── PedidoCompraEntrega
└── PedidoCompraParcela
~~~

Estruturas externas integradas:

- Empresa;
- Loja;
- Fornecedor;
- Produto;
- Cor;
- Pack;
- Unidade;
- Forma de Pagamento;
- Prazo;
- Natureza de Lançamento;
- Pagar;
- PagarItem;
- Nota Fiscal de Entrada;
- Estoque;
- Auditoria.

---

# 56. Tipo do Pedido

O tipo não é escolhido manualmente pelo usuário.

Estados possíveis:

~~~text
'' = Não definido
1  = Revenda
2  = Uso/Consumo
4  = Insumo
~~~

Não participa:

~~~text
3 = Fabricação Própria
~~~

Fabricação Própria pertence ao domínio de Produção.

---

# 57. Definição Automática do Tipo

Pedido novo pode existir com:

~~~text
tipo = ''
~~~

Quando o primeiro item é incluído:

~~~text
Produto.tipo_produto
        ↓
PedidoCompra.tipo
~~~

A partir desse momento, somente Produtos do mesmo tipo podem integrar o Pedido.

---

# 58. Homogeneidade dos Itens

Invariante:

~~~text
para todo item do Pedido:

item.produto.tipo_produto
=
pedido.tipo
~~~

São combinações inválidas:

~~~text
Revenda + Uso/Consumo
Revenda + Insumo
Uso/Consumo + Insumo
~~~

A proteção definitiva pertence ao backend.

---

# 59. Pedido Vazio

Quando Pedido AB fica sem itens:

~~~text
quantidade de itens = 0
        ↓
tipo = ''
~~~

Ao remover o último item, o tipo anterior deve ser liberado.

Isso permite redefinição pelo próximo primeiro item.

---

# 60. Estados do Pedido

Estados homologados:

~~~text
AB = Aberto
AP = Aprovado
AT = Atendido
CA = Cancelado
~~~

AB representa manutenção.

AP representa compromisso aprovado ainda sujeito a atendimento.

AT representa atendimento integral.

CA preserva Pedido cancelado para histórico.

---

# 61. Pedido AB

Enquanto AB, o Pedido pode permitir:

- alteração de cabeçalho;
- inclusão de itens;
- alteração de itens;
- exclusão de itens;
- Forma de Pagamento;
- Prazo;
- desconto geral;
- frete;
- exclusão do Pedido;
- aprovação.

A composição estrutural deixa de ser livremente editável depois da aprovação.

---

# 62. Exclusão do Pedido

Regra homologada:

~~~text
Pedido AB
→ pode ser excluído conforme as regras

Pedido AP
Pedido AT
Pedido CA
→ preservar
~~~

Cancelamento e exclusão são conceitos distintos.

---

# 63. PedidoCompraItem

Representa uma linha de aquisição.

Pode possuir:

- Pedido;
- Produto;
- Cor;
- Pack;
- número de Packs;
- quantidade;
- preço unitário;
- desconto;
- total;
- observação.

Os campos utilizados dependem do tipo do Pedido.

---

# 64. Item de Revenda

Quando:

~~~text
pedido.tipo = 1
~~~

o item utiliza:

- Produto;
- Cor;
- Pack;
- número de Packs;
- quantidade calculada;
- preço;
- desconto;
- total;
- observação.

Quantidade:

~~~text
n_packs
×
soma dos itens do Pack
=
qtd
~~~

A quantidade representa peças e não deve ser fracionária.

---

# 65. Item de Uso/Consumo

Quando:

~~~text
pedido.tipo = 2
~~~

o item utiliza:

- Produto;
- Unidade;
- quantidade direta;
- preço;
- desconto;
- total;
- observação.

Não utiliza Pack.

---

# 66. Item de Insumo

Quando:

~~~text
pedido.tipo = 4
~~~

o item utiliza:

- Produto;
- Unidade;
- quantidade direta;
- preço;
- desconto;
- total;
- observação.

Não utiliza Pack.

Insumo e Uso/Consumo possuem mecânica quantitativa semelhante, mas permanecem domínios distintos.

---

# 67. Quantidade Decimal

Para tipos 2 e 4:

~~~text
Unidade.permite_decimal
~~~

determina se quantidade fracionária é permitida.

Quando:

~~~text
permite_decimal = false
~~~

quantidade decimal deve ser rejeitada.

---

# 68. Total do Item

Regra:

~~~text
bruto =
quantidade × preço_unitário

total_item =
bruto - desconto_item
~~~

Para Revenda, a quantidade é derivada do Pack antes do cálculo.

Backend é autoridade do valor final.

---

# 69. Total do Pedido

Pedido consolida:

- total dos itens;
- desconto geral;
- frete;
- total final.

Regra:

~~~text
total_pedido =
total_itens
- total_desconto
+ frete
~~~

Invariante:

~~~text
total_pedido >= 0
~~~

Para aprovação:

~~~text
total_pedido > 0
~~~

---

# 70. Desconto Geral e Frete

Desconto geral é opcional.

Frete é opcional.

O fato de o campo existir não significa obrigatoriedade de preenchimento.

Frete pode ser conhecido somente em etapa posterior da operação.

---

# 71. Forma de Pagamento

Forma de Pagamento representa a condição financeira escolhida para o Pedido.

Ela possui processo próprio de definição.

Não deve ser tratada como simples texto sem consequência.

Sua aplicação pode produzir:

- definição do Prazo;
- geração de parcelas;
- vencimentos;
- valores planejados.

---

# 72. Prazo de Pagamento

Prazo complementa a Forma.

Pode fornecer regras como:

- quantidade de parcelas;
- dias;
- percentuais;
- vencimentos.

A configuração utilizada deve continuar respeitando Empresa e regras existentes.

---

# 73. PedidoCompraParcela

Representa o planejamento financeiro do Pedido.

Estados existentes:

~~~text
PLAN
→ Planejada

GERADA
→ Integrada ao Financeiro

CANC
→ Cancelada
~~~

PedidoCompraParcela não representa pagamento realizado.

---

# 74. Consistência das Parcelas

Invariante para aprovação:

~~~text
soma das parcelas
=
total do Pedido
~~~

Diferenças de arredondamento precisam ser tratadas pelo processo de geração.

O Pedido não deve ser aprovado com planejamento inconsistente.

---

# 75. PedidoCompraParcela não é PagarItem

Separação fundamental:

~~~text
PedidoCompraParcela
→ planejamento

PagarItem
→ obrigação financeira efetiva
~~~

A aprovação transforma o planejamento da compra em obrigação financeira.

Não fundir automaticamente os conceitos.

---

# 76. Natureza de Lançamento

A Natureza é escolhida no momento da aprovação.

Não pertence à etapa normal de preenchimento inicial do cabeçalho.

A Natureza deve ser válida para a Empresa do Pedido.

---

# 77. Aprovação

Fluxo conceitual:

~~~text
Pedido AB
        ↓
Itens válidos
        ↓
Tipo válido
        ↓
Forma/Prazo
        ↓
Parcelas consistentes
        ↓
Natureza
        ↓
Aprovação
        ↓
Financeiro
        ↓
Pedido AP
~~~

A aprovação deve preservar atomicidade.

---

# 78. Pedido de Compra e Financeiro

Na aprovação:

~~~text
PedidoCompra
        ↓
Pagar
        ↓
PagarItem
~~~

Financeiro permanece responsável por:

- obrigação;
- parcelas financeiras efetivas;
- vencimentos;
- baixas;
- pagamentos;
- juros;
- descontos financeiros.

Compras não substitui Contas a Pagar.

---

# 79. PedidoCompraEntrega

Representa informações relacionadas ao atendimento de um item do Pedido.

Pode registrar conceitos como:

- quantidade prevista;
- quantidade recebida;
- data prevista;
- data recebida;
- situação;
- observação.

Estados existentes incluem:

~~~text
PREV
PARC
RECB
ATR
~~~

---

# 80. Recebimento não é Pedido

Separação:

~~~text
Pedido
→ intenção formal de aquisição

Recebimento
→ ocorrência física
~~~

A simples aprovação do Pedido não representa chegada da mercadoria.

---

# 81. Recebimento e Fiscal

O recebimento operacional permanece integrado ao processo Fiscal.

~~~text
Pedido AP
        ↓
Nota Fiscal de Entrada
        ↓
Recebimento
        ↓
Estoque
        ↓
Atualização do atendimento
~~~

A tela do Pedido acompanha o recebimento.

Não deve criar entrada física paralela.

---

# 82. Recebimento Parcial

Quando existe saldo pendente:

~~~text
Pedido permanece AP
~~~

O fato de existir um recebimento não significa atendimento integral.

---

# 83. Recebimento Integral

Quando todos os itens estão integralmente atendidos:

~~~text
AP → AT
~~~

AT representa Pedido atendido.

---

# 84. Cancelamento Fiscal e Atendimento

Quando uma Nota Fiscal de Entrada relacionada ao recebimento é cancelada, o atendimento precisa refletir novamente os fatos válidos.

Se um Pedido AT deixar de estar integralmente atendido:

~~~text
AT → AP
~~~

conforme o fluxo Fiscal vigente.

---

# 85. Aprovação não é Movimento de Estoque

Regra:

~~~text
Aprovação
!=
Entrada Física
~~~

Fluxo correto:

~~~text
Pedido
→ Aprovação
→ AP
→ Recebimento Fiscal
→ Movimento de Estoque
~~~

Estoque não deve ser movimentado simplesmente pela aprovação do Pedido.

---

# 86. Compra não é Produto

Separação:

~~~text
Produto
→ o que está sendo adquirido

Pedido de Compra
→ evento de aquisição
~~~

O cadastro de Produto não deve incorporar o processo de compra.

---

# 87. Compra não é Nota Fiscal

Separação:

~~~text
Pedido de Compra
→ intenção / compromisso comercial

Nota Fiscal de Entrada
→ documento fiscal da entrada
~~~

Uma estrutura não substitui a outra.

---

# 88. Compra não é Financeiro

Separação:

~~~text
Pedido de Compra
→ compromisso comercial

Financeiro
→ obrigação monetária
~~~

A aprovação integra os domínios sem fundi-los.

---

# 89. Compra não é Estoque

Separação:

~~~text
Pedido
→ quantidade solicitada

Estoque
→ quantidade física
~~~

Saldo não deve ser inferido diretamente da existência do Pedido.

---

# 90. Relação Produto × Pedido de Compra

Participação:

~~~text
Produto tipo 1
→ participa como Revenda

Produto tipo 2
→ participa como Uso/Consumo

Produto tipo 3
→ não participa

Produto tipo 4
→ participa como Insumo
~~~

O primeiro item define o tipo do Pedido.

---

# 91. Relação Pack × Pedido de Compra

Para Revenda:

~~~text
Pack
+
n_packs
=
quantidade calculada
~~~

Pack fornece estrutura.

Pedido representa a operação realizada.

Não são a mesma entidade.

---

# 92. Relação Unidade × Pedido de Compra

Para Uso/Consumo e Insumo:

~~~text
Produto
        ↓
Unidade
        ↓
permite_decimal
        ↓
regra de quantidade
~~~

Unidade define como medir.

Pedido define quanto adquirir.

---

# 93. Relação Fornecedor × Pedido

Fornecedor é obrigatório para o processo de compra.

Relacionamento conceitual:

~~~text
Empresa
   ↓
Fornecedor
   ↓
Pedido de Compra
~~~

Fornecedor utilizado deve respeitar:

- Empresa;
- situação;
- bloqueio;
- regras operacionais.

---

# 94. Relação Loja × Pedido

Loja representa o contexto/destino operacional definido no Pedido.

Deve pertencer à Empresa correspondente.

Não utilizar Loja de outro tenant.

---

# 95. Multiempresa em Compras

O tenant deve ser respeitado em toda a cadeia:

~~~text
Empresa
   ↓
Pedido
   ├── Loja
   ├── Fornecedor
   ├── Produto
   ├── Forma
   ├── Prazo
   ├── Natureza
   ├── Financeiro
   └── Recebimento
~~~

A proteção final pertence ao backend.

---

## Entrada de NF-e — Agregado

A raiz do agregado de recebimento fiscal é:

~~~text
NotaFiscalEntrada
~~~

Estrutura subordinada:

~~~text
NotaFiscalEntrada
└── NotaFiscalEntradaItem
~~~

O Pedido de Compra é relacionamento opcional.

Estruturas e integrações relacionadas incluem:

- Empresa;
- Loja;
- Fornecedor;
- Produto;
- Produto × Fornecedor;
- PedidoCompra, quando houver;
- PedidoCompraItem, quando houver;
- SKU;
- Estoque;
- ProdutoUsoConsumoEstoque;
- Custos;
- Conciliação;
- Conferência;
- Divergências;
- Cobrança fiscal;
- Forma de pagamento fiscal;
- Pagar;
- PagarItem;
- Auditoria.

A Entrada de NF-e pertence funcionalmente ao domínio de Compras, embora sua implementação backend esteja localizada no app `fiscal`.

---

## Entrada de NF-e — XML

No fluxo atual, o XML representa a principal fonte da verdade fiscal recebida.

Separação:

~~~text
XML
→ verdade fiscal

Cadastro interno
→ interpretação operacional
~~~

Informações fiscais originais não devem ser sobrescritas silenciosamente para adequação ao cadastro interno.

---

## Entrada de NF-e — Identidade

A identidade técnica é:

~~~text
NotaFiscalEntrada.id
~~~

No lançamento manual, a identidade documental permanece:

~~~text
Empresa
+ Fornecedor
+ Modelo
+ Série
+ Número
~~~

O Pedido de Compra não participa dessa identidade.

No fluxo XML, a identidade fiscal principal é:

~~~text
Chave de acesso
~~~

A chave deve respeitar as validações fiscais vigentes.

Estados importantes:

~~~text
NF AB válida
→ chave ocupada

NF FE
→ chave ocupada

NF CA após efetivação
→ chave continua ocupada

Importação provisória recusada
→ chave liberada
~~~

---

## Entrada de NF-e — Estados

Estados operacionais:

~~~text
AB = Aberta
FE = Fechada / efetivada
CA = Cancelada
~~~

Fluxo normal:

~~~text
AB
↓
Efetivação
↓
FE
↓
eventual Cancelamento
↓
CA
~~~

AB também pode representar entrada em:

- importação;
- conciliação;
- conferência;
- tratamento de divergências;
- preparação para efetivação.

Status operacional não deve ser confundido com finalidade fiscal.

~~~text
status operacional
!=
finalidade fiscal
~~~

DELETE físico não faz parte do fluxo operacional normal.

---

## Entrada de NF-e — Relação com Pedido

O Pedido de Compra é opcional.

São fluxos válidos:

~~~text
NF-e com Pedido
ou
NF-e sem Pedido
~~~

Quando houver Pedido:

~~~text
PedidoCompra 1:N NotaFiscalEntrada
~~~

Portanto:

~~~text
1 Pedido
→ pode possuir várias NFs
~~~

O Pedido participa das validações de:

- Empresa;
- Loja;
- Fornecedor;
- itens;
- saldo restante;
- preço aprovado;
- recebimentos anteriores.

Quando não houver Pedido, a NF continua sujeita às regras fiscais e operacionais do domínio.

---

## Entrada de NF-e — Fornecedor

No fluxo XML, o Fornecedor é identificado a partir do emitente fiscal.

Quando houver Pedido:

~~~text
Fornecedor NF
=
Fornecedor Pedido
~~~

A incompatibilidade impede a efetivação.

---

## Entrada de NF-e — Produto × Fornecedor

O relacionamento permite identificar o Produto interno a partir do código utilizado pelo Fornecedor.

~~~text
Fornecedor
+
Código externo
→
Produto interno
~~~

O mesmo código externo pode representar Produtos diferentes para Fornecedores distintos.

O vínculo pode preservar:

- Produto interno;
- código externo;
- unidade do Fornecedor;
- fator de conversão;
- situação do vínculo.

O relacionamento é reutilizável em importações futuras.

---

## Entrada de NF-e — Conversão de Unidade

A unidade comercial do XML pode ser diferente da unidade interna.

Exemplo:

~~~text
1 PCT = 100 UN

XML:
100 PCT

Operacional:
10.000 UN
~~~

A quantidade fiscal original permanece preservada.

A conversão é utilizada para os efeitos operacionais.

---

## Entrada de NF-e — Conciliação

A conciliação relaciona o item fiscal ao Produto interno correto.

~~~text
Item XML
↓
Produto × Fornecedor existe?
├── Sim → Produto identificado
└── Não → conciliar Produto
              ↓
         vínculo pode ser salvo
~~~

Regra:

~~~text
Item sem Produto conciliado
→ não efetiva
~~~

---

## Entrada de NF-e — Item

`NotaFiscalEntradaItem` representa um item fiscal recebido.

O item pode existir:

- ligado a PedidoCompraItem, quando houver Pedido;
- sem Pedido;
- conciliado diretamente com Produto interno.

Quando houver Pedido:

~~~text
NotaFiscalEntrada.pedido_compra
=
NotaFiscalEntradaItem.pedido_item.pedido
~~~

Não é permitido utilizar item pertencente a outro Pedido.

Quando não houver Pedido:

~~~text
Item XML
↓
Produto × Fornecedor
↓
Produto interno
~~~

---

## Entrada de NF-e — Conferência Física

A conferência representa a quantidade efetivamente recebida fisicamente.

~~~text
Quantidade fiscal
↓
Quantidade conferida
~~~

A conferência não altera a quantidade existente no XML.

Quando houver diferença:

~~~text
Quantidade fiscal
!=
Quantidade conferida
→ divergência
~~~

---

## Entrada de NF-e — Divergências

Divergências podem ocorrer entre:

- XML e Pedido;
- XML e físico;
- Produto;
- unidade;
- quantidade;
- preço;
- saldo restante.

A divergência deve ser preservada e tratada explicitamente.

Não modificar a verdade fiscal para eliminar uma divergência.

---

## Entrada de NF-e — Quantidade e Pedido

Quando houver Pedido, o saldo considera:

~~~text
Quantidade pedida
-
Quantidade recebida em NFs válidas
=
Saldo pendente
~~~

NF cancelada não compõe recebimento válido.

Regra homologada para quantidade acima do saldo:

~~~text
Quantidade NF > saldo
→ importação permitida
→ conferência permitida
→ alerta
→ efetivação bloqueada
~~~

Logo, a quantidade fiscal recebida pode ultrapassar o saldo durante importação e conferência, mas não pode ser efetivada dessa forma.

---

## Entrada de NF-e — Preço e Pedido

Quando houver Pedido:

~~~text
Preço NF = Pedido
→ permitido

Preço NF < Pedido
→ permitido

Preço NF > Pedido
→ efetivação bloqueada
~~~

O preço fiscal recebido não deve ser alterado para coincidir artificialmente com o Pedido.

---

## Entrada de NF-e — Recebimento Parcial

O recebimento parcial permanece permitido.

~~~text
Pedido = 100
↓
NF 1 = 60
↓
Pedido AP
↓
NF 2 = 40
↓
Pedido AT
~~~

Um Pedido pode receber várias NFs.

---

## Entrada de NF-e — Confirmação Manual do Item

No lançamento manual anteriormente homologado:

~~~text
checkbox OK desmarcado
→ item não persistido

checkbox OK marcado
→ item persistido
~~~

A seleção visual da linha continua independente da persistência.

Essa regra pertence ao fluxo manual.

Ela não substitui:

~~~text
Conciliação XML
+
Conferência física
~~~

---

## Entrada de NF-e — Revenda

Para Revenda, conforme aplicável:

~~~text
Produto
+ Cor
+ Pack
+ Tamanhos
→ SKUs
~~~

A entrada movimenta os SKUs correspondentes.

A composição operacional deve respeitar as regras próprias da Revenda.

---

## Entrada de NF-e — Uso/Consumo

Produto:

~~~text
tipo_produto = 2
~~~

utiliza estoque dedicado de Uso/Consumo.

A regra independe da origem:

~~~text
Pedido gerado por Cotação
ou
Pedido manual
ou
NF sem Pedido
↓
Produto tipo 2
↓
ProdutoUsoConsumoEstoque
~~~

Uso/Consumo utiliza quantidade direta e não utiliza Pack.

---

## Entrada de NF-e — Insumo

Produto tipo 4 representa Insumo.

Utiliza quantidade direta.

Pode trabalhar com quantidade decimal conforme a Unidade configurada.

Não utiliza a mecânica de Pack da Revenda.

Seu estoque permanece separado conceitualmente do estoque dedicado de Uso/Consumo.

---

## Entrada de NF-e — Estoque

Importação de XML não representa entrada física.

~~~text
Importar XML
!=
Movimentar estoque
~~~

A entrada física ocorre na efetivação.

Identificação técnica:

~~~text
NFE:<id>:ENTRADA
~~~

O cancelamento gera:

~~~text
NFE:<id>:CANCEL
~~~

O ID interno da NF identifica tecnicamente os movimentos.

---

## Entrada de NF-e — Custos

A efetivação participa da atualização de custos conforme o tipo do Produto.

Conceitualmente:

~~~text
Revenda
→ custos conforme domínio de SKU

Uso/Consumo
→ custos do Produto

Insumo
→ custos do Produto
~~~

No cancelamento, os custos devem ser recalculados considerando as demais entradas válidas.

Não realizar rollback cego ignorando entradas posteriores.

---

## Entrada de NF-e — Financeiro

Quando houver Pedido:

~~~text
Pedido
→ planejamento comercial
~~~

A NF representa:

~~~text
verdade fiscal recebida
~~~

O XML pode possuir:

- cobrança;
- duplicatas;
- vencimentos;
- valores;
- formas de pagamento fiscal.

Essas informações não devem ser substituídas silenciosamente pelo planejamento anterior do Pedido.

A efetivação produz os efeitos financeiros correspondentes ao documento recebido.

---

## Entrada de NF-e — Finalidade Fiscal

A finalidade fiscal deve ser considerada antes da efetivação.

Exemplo homologado:

~~~text
finNFe = 4
→ devolução
→ importação permitida
→ efetivação normal bloqueada
~~~

Importar o XML não significa que a operação pode seguir como uma compra normal.

---

## Entrada de NF-e — Recusar Entrada

Importação XML provisória elegível pode utilizar:

~~~text
Recusar entrada
~~~

Fluxo:

~~~text
XML importado
↓
NF AB
↓
sem efeitos operacionais incompatíveis
↓
Recusar entrada
↓
registro provisório removido
↓
chave liberada
~~~

Recusar entrada:

- não movimenta estoque;
- não gera financeiro;
- não atualiza Pedido;
- não cria NF cancelada;
- permite importar novamente o mesmo XML.

---

## Entrada de NF-e — Recusa versus Cancelamento

São operações distintas:

~~~text
Recusar entrada
!=
Cancelar NF
~~~

Recusa:

~~~text
NF AB provisória
→ abandono da importação
~~~

Cancelamento:

~~~text
NF FE
→ desfaz efeitos já produzidos
~~~

NF cancelada mantém sua chave ocupada.

---

## Entrada de NF-e — Cancelamento

Cancelar NF fechada deve desfazer somente os efeitos daquela NF.

Pode envolver:

- estoque;
- custos;
- financeiro;
- recebimento do Pedido, quando houver;
- status do Pedido.

Exemplo:

~~~text
Pedido AT
↓
Cancelar uma NF
↓
volta a existir saldo
↓
Pedido AP
~~~

Se houver baixa financeira incompatível com reversão automática segura, o cancelamento deve ser bloqueado.

---

## Entrada de NF-e — Atomicidade

Devem ser transacionais:

~~~text
Efetivação
Cancelamento
Recusa
~~~

Regra:

~~~text
SUCESSO COMPLETO
OU
ROLLBACK COMPLETO
~~~

Não deve existir estado parcialmente aplicado entre:

- NF;
- Pedido;
- Estoque;
- Custos;
- Financeiro;
- vínculos relacionados.

---

## Entrada de NF-e — Multiempresa

Toda a cadeia permanece limitada pela Empresa:

~~~text
Empresa
├── NF
├── Fornecedor
├── Produto
├── Produto × Fornecedor
├── Pedido, quando houver
├── Loja
├── Conciliação
├── Conferência
├── Divergências
├── Estoque
└── Financeiro
~~~

Uma Empresa não pode consultar nem relacionar dados de outra.

---

## Entrada de NF-e — Permissões

A funcionalidade pertence ao módulo:

~~~text
compras
~~~

Níveis:

~~~text
VIEW
→ consulta

EDIT
→ operações permitidas
~~~

Possuir somente o módulo Fiscal não concede acesso à Entrada de NF-e.

---

## Entrada de NF-e — Documentação

Documentação específica:

- [[Homologação - Compras - Entrada de NF-e]]
- [[Mapa Técnico - Compras - Entrada de NF-e]]
- [[Workflows - Compras - Entrada de NF-e]]
- [[Modelo de Domínio - Compras - Entrada de NF-e]]
- [[Riscos e Cuidados - Compras - Entrada de NF-e]]

O domínio encontra-se homologado e deve ser preservado até que nova decisão funcional aprovada substitua explicitamente alguma regra.

---
# 96. Estoque

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

# 97. Estoque de Produto Venda

Granularidade consolidada:

~~~text
Loja × SKU
~~~

O SKU é a unidade comercial de variação.

---

# 98. Estoque de Uso/Consumo

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

# 99. Estoque de Insumos

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

# 100. Movimento de Estoque

Saldo deve resultar de eventos.

~~~text
Entradas
-
Saídas
=
Saldo
~~~

Movimento pode representar:

- recebimento de Compra;
- transferência;
- venda;
- ajuste;
- inventário;
- futura Produção;
- devolução;
- distribuição.

---

# 101. Fiscal

Produto mantém dados fiscais cadastrais.

O módulo Fiscal aplica os dados à operação.

~~~text
Produto
→ Classificação Fiscal

Operação
→ Tributação aplicada
~~~

Não confundir Cadastro Fiscal com emissão fiscal.

Em Compras, Fiscal também participa da Nota Fiscal de Entrada e do recebimento operacional.

---

# 102. Venda

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

# 103. PDV

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

# 104. Financeiro

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

# 105. Pagar

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

Quando originado pela aprovação do Pedido, deve preservar sua rastreabilidade até a Compra correspondente.

---

# 106. Produção

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

Produto tipo 3 pertence a esse fluxo e não ao Pedido de Compra.

---

# 107. Facção

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

# 108. Distribuição

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

# 109. Auditoria versus Histórico Funcional

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

Pedido de Compra também deve reutilizar a Auditoria Central para os eventos auditáveis definidos pelo processo.

---

# 110. Lifecycle

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

Pedido de Compra:

~~~text
AB
AP
AT
CA
~~~

Contrato:

~~~text
possui estados próprios
~~~

Não criar um único enum genérico para domínios com significados diferentes.

---

# 111. Exclusão Protegida

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
- Encerramento;
- Cancelamento.

No Pedido de Compra:

~~~text
AB
→ exclusão pode ser permitida

AP / AT / CA
→ preservar
~~~

---

# 112. Integridade Histórica

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

Pedido de Compra deve preservar a realidade comercial que existia no momento da operação.

---

# 113. Modelo Consolidado de Produtos

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

# 114. Relação dos Cadastros Auxiliares

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

# 115. Relação Produto × Compras × Estoque

~~~text
Produto tipo 1, 2 ou 4
        ↓
Pedido de Compra
        ↓
Aprovação
        ↓
Nota Fiscal de Entrada
        ↓
Recebimento
        ↓
Movimento de Entrada
        ↓
Estoque
~~~

Produto não executa Compra.

Pedido não representa Saldo.

Aprovação não representa Recebimento.

Estoque não representa Cadastro.

Produto tipo 3 não participa dessa cadeia de aquisição.

---

# 116. Relação Pedido × Financeiro

~~~text
Pedido AB
        ↓
Forma / Prazo
        ↓
PedidoCompraParcela
        ↓
Aprovação + Natureza
        ↓
Pagar
        ↓
PagarItem
~~~

Planejamento e obrigação financeira permanecem entidades distintas.

---

# 117. Relação Pedido × Fiscal

~~~text
Pedido AP
        ↓
Nota Fiscal de Entrada
        ↓
Recebimento
        ↓
Atualização do atendimento
~~~

Recebimento parcial mantém AP.

Atendimento integral leva a AT.

Cancelamento fiscal deve permitir recálculo da realidade do atendimento.

---

# 118. Relação Produto × Produção

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

# 119. Relação Produto × Venda

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

# 120. Estado dos Domínios Consolidados

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

## Pedido de Compra

~~~text
UNIFICADO
CONCLUÍDO
TESTADO
HOMOLOGADO
APROVADO
DOCUMENTADO
~~~

---

# 121. Documentação de Produto Venda

- [[Homologação - Produtos - Produto Venda]]
- [[Mapa Técnico - Produtos - Produto Venda]]
- [[Workflows - Produtos - Produto Venda]]
- [[Modelo de Domínio - Produtos - Produto Venda]]
- [[Riscos e Cuidados - Produtos - Produto Venda]]

---

# 122. Documentação de Produto Uso/Consumo

- [[Homologação - Produtos - Produto Uso e Consumo]]
- [[Mapa Técnico - Produtos - Produto Uso e Consumo]]
- [[Workflows - Produtos - Produto Uso e Consumo]]
- [[Modelo de Domínio - Produtos - Produto Uso e Consumo]]
- [[Riscos e Cuidados - Produtos - Produto Uso e Consumo]]

---

# 123. Documentação de Insumos

- [[Homologação - Produtos - Insumos]]
- [[Mapa Técnico - Produtos - Insumos]]
- [[Workflows - Produtos - Insumos]]
- [[Modelo de Domínio - Produtos - Insumos]]
- [[Riscos e Cuidados - Produtos - Insumos]]

---

# 124. Documentação de Cadastros Auxiliares

- [[Homologação - Produtos - Cadastros Auxiliares]]
- [[Mapa Técnico - Produtos - Cadastros Auxiliares]]
- [[Workflows - Produtos - Cadastros Auxiliares]]
- [[Modelo de Domínio - Produtos - Cadastros Auxiliares]]
- [[Riscos e Cuidados - Produtos - Cadastros Auxiliares]]

---

# 125. Documentação de Compras

## Pedido de Compra

- [[Homologação - Compras - Pedido de Compra]]
- [[Mapa Técnico - Compras - Pedido de Compra]]
- [[Workflows - Compras - Pedido de Compra]]
- [[Modelo de Domínio - Compras - Pedido de Compra]]
- [[Riscos e Cuidados - Compras - Pedido de Compra]]

---

# 126. Regras de Evolução do Domínio

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
11. verificar efeitos financeiros;
12. somente então alterar a estrutura.

No caso de Pedido de Compra, não reabrir regras homologadas sem:

- novo requisito;
- defeito comprovado;
- conflito real;
- nova decisão funcional explícita.

---

# 127. Princípio Central

O modelo do Sysvar deve continuar respeitando:

~~~text
EMPRESA
define o tenant.

CADASTROS
definem identidades.

PRODUTOS
definem itens.

COMPRAS
formalizam a aquisição.

FISCAL
documenta o recebimento e aplica tributação.

ESTOQUE
controla quantidade e localização.

PRODUÇÃO
transforma.

DISTRIBUIÇÃO
movimenta entre unidades.

VENDAS
comercializam.

FINANCEIRO
controla obrigações e direitos.

AUDITORIA
preserva rastreabilidade.
~~~

---

# 128. Navegação Documental

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

## Compras

- [[Modelo de Domínio - Compras - Pedido de Compra]]
- [[Mapa Técnico - Compras - Pedido de Compra]]
- [[Workflows - Compras - Pedido de Compra]]
- [[Riscos e Cuidados - Compras - Pedido de Compra]]
- [[Homologação - Compras - Pedido de Compra]]

---

# 129. Estado do Modelo em 16/08/2026

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

PEDIDO DE COMPRA
~~~

O Pedido de Compra está:

~~~text
UNIFICADO
IMPLEMENTADO
TESTADO
HOMOLOGADO
APROVADO
DOCUMENTADO
~~~

Os próximos módulos devem ser incorporados a este documento somente após suas respectivas regras funcionais serem analisadas, implementadas e homologadas.
