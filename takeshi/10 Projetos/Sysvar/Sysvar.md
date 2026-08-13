---
type: project
status: active
project: Sysvar
source: "C:/SysvarProjeto"
created: 2026-08-03
updated: 2026-08-13
tags:
  - projeto
  - sysvar
  - homologado
  - operacional
  - cadastros
  - clientes
  - fornecedores
  - funcionários
  - produtos
  - produto-venda
  - revenda
  - fabricação-própria
  - sku
  - ean
  - estoque
  - fiscal
  - produção
  - auditoria
  - multiempresa
---

# Sysvar

## O que é

O Sysvar é um ERP SaaS para o varejo e a indústria de moda, desenvolvido com backend Django REST Framework, frontend Angular 17 e banco de dados MySQL.

O sistema foi concebido para atender empresas com uma ou múltiplas lojas, estoque central, produção própria, facções, distribuição, compras, vendas, financeiro, fiscal, contabilidade, auditoria e BI.

---

# Objetivo

Centralizar toda a operação da empresa em uma única plataforma, mantendo:

- isolamento entre empresas;
- controle por estabelecimentos;
- segurança baseada em perfis e permissões;
- auditoria completa;
- arquitetura preparada para crescimento modular;
- integridade entre os módulos;
- rastreabilidade das operações;
- experiência visual padronizada;
- regras de negócio validadas no backend.

---

# Tecnologias Principais

## Backend

- Python;
- Django;
- Django REST Framework;
- MySQL.

## Frontend

- Angular 17 Standalone;
- TypeScript.

## Infraestrutura e Versionamento

- Git;
- GitHub;
- Ubuntu Server;
- Docker;
- Nginx Proxy Manager;
- Portainer;
- Uptime Kuma.

## Documentação

- Obsidian;
- Markdown;
- repositório Git dedicado ao vault.

---

# Áreas Principais

## Operacional

- Empresas;
- Contratos;
- Estabelecimentos;
- Usuários;
- Perfis;
- Permissões;
- Sessões;
- Licenciamento;
- Auditoria.

## Cadastros

- Clientes;
- Fornecedores;
- Funcionários;
- Lojas;
- Naturezas de lançamento;
- Formas de pagamento;
- demais cadastros auxiliares.

## Produtos

- Produto Venda;
- Revenda;
- Fabricação Própria;
- Produtos de Uso e Consumo;
- SKUs;
- EAN;
- Cores;
- Tamanhos;
- Grades;
- Packs;
- Coleções;
- Grupos;
- Subgrupos;
- NCM;
- Unidades;
- Tabelas de Preço;
- imagens;
- Dados fiscais.

## Compras

- pedidos de compra;
- pedidos de Revenda;
- pedidos de Uso e Consumo;
- aprovação;
- cancelamento;
- parcelas;
- integração financeira;
- entrada de nota fiscal.

## Fiscal

- vendas;
- NFC-e;
- devoluções;
- documentos fiscais;
- impostos;
- regras tributárias.

## Estoque

- entradas;
- saídas;
- transferências;
- saldos;
- estoque por Empresa;
- estoque por Estabelecimento;
- estoque por SKU;
- reservas;
- disponibilidade.

## Distribuição

- fábrica para lojas;
- distribuição manual;
- distribuição percentual;
- perfis de distribuição;
- distribuição por Grade;
- distribuição de Fabricação Própria;
- distribuição de Revenda.

## Produção

- Ficha Técnica;
- Ordem de Produção;
- facção;
- matéria-prima;
- retorno de Produção;
- custo de Produção.

## Vendas e PDV

- abertura de caixa;
- fechamento de caixa;
- vendas;
- pagamentos;
- Clientes;
- vendedores;
- descontos;
- NFC-e;
- operação online;
- futura operação offline.

## Financeiro

- contas a pagar;
- contas a receber;
- formas de pagamento;
- parcelas;
- rateios;
- plano financeiro;
- natureza de lançamento.

## Relatórios e Dashboards

- vendas;
- Estoque;
- Compras;
- Financeiro;
- indicadores comerciais;
- acompanhamento gerencial.

---

# Fonte do Projeto

Código-fonte:

~~~text
C:\SysvarProjeto
~~~

Backend:

~~~text
C:\SysvarProjeto\Backend
~~~

Frontend:

~~~text
C:\SysvarProjeto\Frontend\sysvar
~~~

Documentação no projeto:

~~~text
C:\SysvarProjeto\docs
~~~

Vault do Obsidian:

~~~text
C:\takeshi\takeshi
~~~

---

# Repositórios

Backend:

~~~text
FernandoMurashima/sysvarbackend
~~~

Frontend:

~~~text
FernandoMurashima/sysvarfrontend
~~~

Vault:

~~~text
FernandoMurashima/sysvar-vault
~~~

Branch principal:

~~~text
main
~~~

---

# Documentação Central

Os documentos gerais do projeto são:

- [[Mapa Técnico]]
- [[10 Projetos/Sysvar/Contexto do Projeto/Visão Geral|Visão Geral]]
- [[10 Projetos/Sysvar/Contexto do Projeto/Arquitetura|Arquitetura]]
- [[10 Projetos/Sysvar/Contexto do Projeto/Modelo de Domínio|Modelo de Domínio]]
- [[10 Projetos/Sysvar/Contexto do Projeto/Workflows|Workflows]]
- [[10 Projetos/Sysvar/Contexto do Projeto/Riscos e Cuidados|Riscos e Cuidados]]

Decisões arquiteturais:

- [[10 Projetos/Sysvar/Decisões Técnicas/ADR-001 - Licenciamento por Sessões Simultâneas|ADR-001 - Licenciamento por Sessões Simultâneas]]
- [[10 Projetos/Sysvar/Decisões Técnicas/ADR-002 - Princípios Arquiteturais do SISVAR|ADR-002 - Princípios Arquiteturais do SISVAR]]
- [[10 Projetos/Sysvar/Decisões Técnicas/ADR-003 - Auditoria Central do SISVAR|ADR-003 - Auditoria Central do SISVAR]]

---

# Situação Geral Atual

## Infraestrutura Estrutural

Status:

~~~text
IMPLEMENTADA
TESTADA
EM EVOLUÇÃO CONTROLADA
~~~

Inclui:

- autenticação;
- isolamento multiempresa;
- isolamento por Estabelecimento;
- contratos;
- módulos contratados;
- usuário master;
- superusuário da plataforma;
- perfis;
- permissões efetivas;
- overrides;
- heartbeat;
- tokens;
- sessões;
- timeout;
- device ID;
- licenciamento simultâneo;
- Auditoria Central;
- proteção de troca obrigatória de senha.

---

# Grupo Operacional

Status:

~~~text
CONCLUÍDO
TESTADO AUTOMATICAMENTE
HOMOLOGADO MANUALMENTE
DOCUMENTADO
APROVADO
~~~

Itens concluídos:

- Empresas;
- Contratos;
- Módulos contratados;
- Suspensão;
- Reativação;
- Estabelecimentos;
- Usuários;
- Perfis;
- Permissões;
- Overrides;
- Sessões;
- Tokens;
- Administração de sessões;
- Diagnóstico de sessões;
- Reconciliação de sessões;
- Licenciamento simultâneo;
- Redefinição administrativa de senha;
- Troca obrigatória de senha;
- Auditoria Central.

Homologação:

[[10 Projetos/Sysvar/Homologações/Homologação - Operacional|Homologação - Operacional]]

---

# Licenciamento

Status:

~~~text
HOMOLOGADO MANUALMENTE
~~~

O Sysvar utiliza:

~~~text
SESSÕES SIMULTÂNEAS
~~~

A quantidade de usuários cadastrados não representa consumo de licença.

Regras homologadas:

- criar Usuário não consome licença;
- ativar Usuário não consome licença;
- manter Usuário cadastrado não consome licença;
- login válido consome licença;
- logout libera licença;
- timeout libera licença;
- encerramento administrativo libera licença;
- suspensão da Empresa libera as vagas;
- superusuário não consome licença de Empresa cliente;
- usuários diferentes podem utilizar o mesmo dispositivo;
- o mesmo usuário no mesmo dispositivo substitui sua sessão anterior;
- login acima do limite é recusado;
- contador e listagem utilizam a mesma regra central.

Referência:

[[10 Projetos/Sysvar/Decisões Técnicas/ADR-001 - Licenciamento por Sessões Simultâneas|ADR-001 - Licenciamento por Sessões Simultâneas]]

---

# Administração de Sessões

Status:

~~~text
IMPLEMENTADA
TESTADA
HOMOLOGADA
~~~

É possível:

- visualizar sessões por Empresa;
- visualizar sessões por Usuário;
- identificar navegador;
- identificar dispositivo;
- identificar sistema operacional;
- visualizar IP;
- visualizar início;
- visualizar última atividade;
- visualizar tempo conectado;
- visualizar Status;
- encerrar uma sessão;
- encerrar todas;
- diagnosticar inconsistências;
- reconciliar sessões inválidas.

O contador e a listagem utilizam a mesma regra central de sessão válida.

---

# Auditoria Central

Status:

~~~text
IMPLEMENTADA
TESTADA
HOMOLOGADA
DOCUMENTADA
~~~

A Auditoria registra eventos relacionados a:

- autenticação;
- logout;
- sessões;
- contratos;
- Empresas;
- Usuários;
- permissões;
- Estabelecimentos;
- perfis;
- módulos;
- bloqueios;
- suspensão;
- reativação;
- Clientes;
- Fornecedores;
- Funcionários;
- Produtos;
- ciclo de vida;
- alterações cadastrais;
- alterações fiscais;
- exclusões realizadas;
- exclusões negadas;
- demais eventos relevantes dos módulos.

Princípios:

- backend como autoridade;
- Empresa registrada;
- Usuário registrado;
- resultado registrado;
- origem registrada;
- correlação quando disponível;
- proteção de dados sensíveis;
- ausência de tokens brutos;
- ausência de senhas;
- ausência de stack trace para usuários;
- evitar duplicação intencional de eventos.

Referência:

[[10 Projetos/Sysvar/Decisões Técnicas/ADR-003 - Auditoria Central do SISVAR|ADR-003 - Auditoria Central do SISVAR]]

---

# Grupo Cadastros

Situação do escopo revisado:

~~~text
CLIENTES
→ CONCLUÍDO

FORNECEDORES
→ CONCLUÍDO

FUNCIONÁRIOS
→ CONCLUÍDO
~~~

Os três cadastros prioritários definidos para essa etapa foram:

1. Clientes;
2. Fornecedores;
3. Funcionários.

Os demais cadastros auxiliares continuam existentes e poderão receber revisão própria quando forem necessários aos módulos seguintes.

---

# Cadastros - Clientes

Status:

~~~text
IMPLEMENTADO
TESTADO AUTOMATICAMENTE
HOMOLOGADO MANUALMENTE
DOCUMENTADO
APROVADO
~~~

Homologação:

~~~text
23/23
~~~

O cadastro contempla:

- PF;
- PJ;
- Cliente sem documento;
- CPF/CNPJ;
- documento funcional;
- unicidade por Empresa;
- Consumidor Final;
- filtros;
- paginação;
- consulta;
- Compras;
- Histórico;
- indicadores;
- ciclo de vida;
- exclusão protegida;
- PDV;
- Auditoria Central;
- isolamento multiempresa.

---

# Regras Centrais de Clientes

## Empresa

Todo Cliente pertence a uma Empresa.

~~~text
cliente.empresa_id == empresa atual
~~~

## Tipo

~~~text
PF
PJ
~~~

## Documento

Campo funcional:

~~~text
documento
~~~

Campo legado temporário:

~~~text
cpf
~~~

## Unicidade

~~~text
Empresa + documento
~~~

Mais de um Cliente sem documento é permitido.

---

# Consumidor Final

Cada Empresa possui seu próprio:

~~~text
Consumidor Final
~~~

Dados funcionais:

~~~text
Tipo: PF
Documento: 00000000000
cliente_padrao: true
~~~

Não existe Consumidor Final global.

O Cliente padrão possui proteções contra:

- exclusão;
- inativação;
- bloqueio;
- mudança de documento;
- mudança de tipo;
- perda da condição de Cliente padrão.

---

# Ciclo de Vida de Clientes

~~~text
Ativar
Inativar
Bloquear
Desbloquear
~~~

Cliente Inativo ou Bloqueado não deve ser utilizado em nova venda.

---

# Consulta de Clientes

Abas:

~~~text
Dados cadastrais
Compras
Histórico
~~~

Indicadores:

~~~text
Última compra
Total comprado
Quantidade de compras
Ticket médio
~~~

Cálculos são feitos no backend.

---

# Clientes e PDV

Venda sem Cliente identificado:

~~~text
Consumidor Final da Empresa
~~~

Venda com Cliente identificado:

~~~text
Cliente selecionado
~~~

Cliente Inativo ou Bloqueado deve ser recusado.

Cliente de outra Empresa deve ser recusado.

---

# Exclusão de Clientes

Cliente sem vínculos pode ser excluído.

Cliente com vínculos deve ser preservado e utilizar Inativação.

Mensagem funcional homologada:

~~~text
Este cliente possui vendas ou outros registros vinculados e não pode ser excluído. Utilize a inativação.
~~~

---

# Documentação de Clientes

- [[10 Projetos/Sysvar/Homologações/Homologação - Cadastros - Clientes|Homologação - Cadastros - Clientes]]
- [[10 Projetos/Sysvar/Contexto do Projeto/Mapa Técnico - Cadastros - Clientes|Mapa Técnico - Cadastros - Clientes]]
- [[10 Projetos/Sysvar/Contexto do Projeto/Modelo de Domínio - Cadastros - Cliente|Modelo de Domínio - Cadastros - Cliente]]
- [[10 Projetos/Sysvar/Contexto do Projeto/Workflows - Cadastros - Clientes|Workflows - Cadastros - Clientes]]
- [[10 Projetos/Sysvar/Contexto do Projeto/Riscos e Cuidados - Cadastros - Clientes|Riscos e Cuidados - Cadastros - Clientes]]

---

# Cadastros - Fornecedores

Status:

~~~text
IMPLEMENTADO
TESTADO AUTOMATICAMENTE
HOMOLOGADO MANUALMENTE
DOCUMENTADO
APROVADO
~~~

Homologação:

~~~text
30/30
~~~

A Fase 1 contempla:

- PF;
- PJ;
- Fornecedor sem documento;
- CPF/CNPJ;
- múltiplas categorias;
- múltiplos contatos;
- múltiplos endereços;
- fiscal;
- comercial;
- financeiro;
- contábil;
- dados bancários;
- ciclo de vida;
- Compras;
- Financeiro;
- Histórico;
- indicadores;
- Auditoria Central;
- multiempresa;
- paginação server-side;
- filtros server-side.

---

# Categorias de Fornecedor

Categorias:

~~~text
MATERIA_PRIMA
AVIAMENTO
REVENDA
FACCAO
PRESTADOR
TRANSPORTADORA
OUTROS
~~~

Um Fornecedor pode possuir várias categorias.

Categoria orienta contexto, classificação e sugestão.

Não deve virar bloqueio universal sem regra própria da operação.

---

# Dados Bancários de Fornecedor

Possuem proteção específica.

Permissão:

~~~text
fornecedor.dados_bancarios
~~~

Usuário sem autorização não deve receber os valores sensíveis nem por chamada direta de API.

---

# Ciclo de Vida de Fornecedores

~~~text
Ativar
Inativar
Bloquear
Desbloquear
~~~

Fornecedor utilizável:

~~~text
Empresa correta
AND ativo
AND não bloqueado
AND contexto operacional válido
~~~

---

# Exclusão de Fornecedor

Sem vínculos:

~~~text
DELETE permitido
~~~

Com vínculos:

~~~text
DELETE negado
→ utilizar Inativação
~~~

---

# Consulta de Fornecedor

Abas:

~~~text
Dados cadastrais
Compras
Financeiro
Histórico
~~~

Indicadores:

~~~text
Última compra
Total comprado
Quantidade de compras
Ticket médio
Saldo a pagar
~~~

---

# Documentação de Fornecedores

- [[10 Projetos/Sysvar/Homologações/Homologação - Cadastros - Fornecedores|Homologação - Cadastros - Fornecedores]]
- [[10 Projetos/Sysvar/Contexto do Projeto/Mapa Técnico - Cadastros - Fornecedores|Mapa Técnico - Cadastros - Fornecedores]]
- [[10 Projetos/Sysvar/Contexto do Projeto/Modelo de Domínio - Cadastros - Fornecedores|Modelo de Domínio - Cadastros - Fornecedores]]
- [[10 Projetos/Sysvar/Contexto do Projeto/Workflows - Cadastros - Fornecedores|Workflows - Cadastros - Fornecedores]]
- [[10 Projetos/Sysvar/Contexto do Projeto/Riscos e Cuidados - Cadastros - Fornecedores|Riscos e Cuidados - Cadastros - Fornecedores]]

---

# Pendências Conhecidas de Fornecedores

Não bloqueiam a Fase 1:

- validação de Inscrição Estadual por UF;
- validação específica de Inscrição Municipal;
- cadastro oficial de Bancos;
- melhorias de UX para campos bancários protegidos.

Fornecedor Fase 2 permanece reservada para inteligência e avaliação.

---

# Cadastros - Funcionários

Status:

~~~text
IMPLEMENTADO
TESTADO
HOMOLOGADO MANUALMENTE
DOCUMENTADO
APROVADO
~~~

Homologação:

~~~text
17/17
~~~

Funcionário representa identidade operacional.

Não representa módulo de RH/DP.

---

# Separações Fundamentais de Funcionários

~~~text
Funcionário != Usuário
Cargo != Perfil
Cargo != Permissão
Loja supervisionada != Loja permitida do Usuário
Situação do Funcionário != User.is_active
Comissão básica != Motor completo de comissão
FuncionarioHistorico != AuditLog
~~~

---

# Funcionário e Empresa

Todo Funcionário pertence a uma Empresa.

Também devem respeitar a mesma Empresa:

- Cargo;
- Loja Principal;
- Lojas supervisionadas;
- Usuário vinculado.

---

# CPF e Matrícula

CPF:

- obrigatório para novos cadastros;
- validado;
- normalizado;
- único por Empresa.

Matrícula:

- obrigatória;
- única por Empresa;
- automática ou manual;
- estável;
- não reutilizada.

---

# Cargo

Cargo é cadastro aberto por Empresa.

Não é enum fixo.

Pode representar:

- Vendedor;
- Caixa;
- Gerente;
- Supervisor;
- Comprador;
- Estoquista;
- Financeiro;
- Administrativo;
- Produção;
- qualquer função operacional necessária.

Cargo não concede permissão.

Permissões pertencem a Usuário/Perfil.

---

# Situação Operacional de Funcionários

Estados:

~~~text
ATIVO
AFASTADO
DESLIGADO
~~~

Fluxo:

~~~text
ATIVO
  ↓
AFASTADO
  ↓
ATIVO
  ↓
DESLIGADO
  ↓
ATIVO
~~~

Ações:

~~~text
Afastar
Retornar
Desligar
Recontratar
~~~

Recontratação utiliza o mesmo cadastro.

---

# Loja e Abrangência

Funcionário pode possuir Loja Principal.

Cargos configurados para múltiplas lojas podem possuir:

~~~text
lojas_supervisionadas
todas_lojas_da_empresa
~~~

Abrangência operacional não representa permissão de acesso.

---

# Comissão

Estruturas:

~~~text
Cargo.permite_comissao
Funcionarios.comissionado
Funcionarios.comissao_percentual
~~~

Gerente e Supervisor podem ser comissionados.

Motor avançado de comissão pertence a domínio futuro.

---

# Funcionário × Usuário

Relacionamento:

~~~text
Funcionarios.usuario
→ accounts.User
~~~

É opcional e OneToOne.

Vincular Usuário não altera automaticamente:

- Cargo;
- Perfil;
- permissões;
- lojas de acesso;
- sessões.

---

# Histórico de Funcionários

`FuncionarioHistorico` registra trajetória operacional.

Exemplos:

- mudança de Cargo;
- mudança de Loja;
- alteração de abrangência;
- afastamento;
- retorno;
- desligamento;
- recontratação.

`AuditLog` continua responsável pela Auditoria Central.

---

# Exclusão de Funcionário

Funcionário nunca utilizado pode ser excluído.

Funcionário utilizado deve ser preservado.

Mensagem homologada:

~~~text
Funcionário já utilizado em operações. Desligue o funcionário em vez de excluí-lo.
~~~

---

# Funcionários e Vendas

Venda mantém conceitos distintos:

~~~text
VendaPdv.vendedor
→ Funcionarios

VendaPdv.criado_por
→ User
~~~

Vendedor é responsável comercial.

`criado_por` identifica quem operou o sistema.

---

# Documentação de Funcionários

- [[Homologação - Cadastros - Funcionários]]
- [[Mapa Técnico - Cadastros - Funcionários]]
- [[Workflows - Cadastros - Funcionários]]
- [[Modelo de Domínio - Cadastros - Funcionários]]
- [[Riscos e Cuidados - Cadastros - Funcionários]]

---

# Grupo Produtos

Status atual:

~~~text
EM ANDAMENTO
~~~

Primeiro domínio formalmente fechado:

~~~text
PRODUTO VENDA
~~~

Resultado:

~~~text
IMPLEMENTADO
TESTADO
HOMOLOGADO
DOCUMENTADO
APROVADO

19/19 ITENS APROVADOS
~~~

---

# Produto Venda

Produto Venda representa os produtos destinados à comercialização.

Tipos contemplados:

~~~text
1 = Revenda
3 = Fabricação Própria
~~~

A nomenclatura funcional aprovada é:

**Produto Venda**

Para tipo `3`:

**Fabricação Própria**

Não utilizar como nomenclatura geral da funcionalidade:

~~~text
Produtos Revenda
~~~

quando os dois tipos estiverem sendo contemplados.

---

# Produto Venda versus Uso e Consumo

Produto Venda não engloba Uso e Consumo.

Separação:

~~~text
Produto Venda
├── Revenda
└── Fabricação Própria

Uso e Consumo
→ fluxo separado
~~~

O fechamento de Produto Venda não significa homologação de Uso e Consumo.

---

# Entidades Centrais de Produto Venda

Estruturas:

~~~text
Produto
ProdutoDetalhe
ProdutoVendaHistorico
ProdutoImagem
~~~

Relacionamentos principais:

~~~text
Empresa
  ↓
Produto
  ├── Coleção
  ├── Grupo
  ├── Subgrupo
  ├── Unidade
  ├── Material
  ├── Grade
  ├── ProdutoDetalhe / SKU
  │      ├── Cor
  │      ├── Tamanho
  │      ├── EAN
  │      └── Estoque
  ├── Dados fiscais
  ├── Preços
  ├── Imagens
  ├── Histórico funcional
  └── Auditoria
~~~

Modelo completo:

[[Modelo de Domínio - Produtos - Produto Venda]]

---

# Produto versus SKU

Separação fundamental:

~~~text
Produto != SKU
~~~

Produto representa o cadastro principal.

SKU representa:

~~~text
Produto + Cor + Tamanho
~~~

Exemplo:

~~~text
Produto:
Vestido Midi

SKUs:
Vestido Midi / Preto / P
Vestido Midi / Preto / M
Vestido Midi / Azul / P
Vestido Midi / Azul / M
~~~

---

# Tipo do Produto Venda

Tipos:

~~~text
1 = Revenda
3 = Fabricação Própria
~~~

Regra:

~~~text
TIPO IMUTÁVEL APÓS CRIAÇÃO
~~~

Não converter Revenda em Fabricação Própria.

Não converter Fabricação Própria em Revenda.

---

# Referência de Produto Venda

Referência é automática.

Formato:

~~~text
AA-BB-CCDDD
~~~

Composição:

~~~text
AA = ano da Coleção
BB = Estação
CC = CodigoRef do Grupo
DDD = sequência
~~~

A Referência pertence ao Produto.

EAN pertence ao SKU.

---

# Descrição Reduzida

Obrigatória.

Limite:

~~~text
60 caracteres
~~~

---

# Grupo e Subgrupo

Grupo:

~~~text
OBRIGATÓRIO
~~~

Subgrupo:

~~~text
OBRIGATÓRIO
~~~

Subgrupo deve ser coerente com Grupo.

---

# Unidade

Unidade é obrigatória para Produto Venda.

---

# Material

Material permanece opcional.

Material classificatório não substitui os componentes da Ficha Técnica.

---

# Grade

Grade é obrigatória.

Ela define os Tamanhos possíveis.

Após a existência de SKUs:

~~~text
GRADE IMUTÁVEL
~~~

---

# Cores e SKUs

Ao incluir Cor:

~~~text
Cor
+
Tamanhos da Grade
=
SKUs
~~~

Quando o SKU já existia e estava Inativo:

~~~text
REATIVAR
~~~

Quando nunca existiu:

~~~text
CRIAR
~~~

---

# Remoção de Cor

Regra:

~~~text
REMOVER COR
→ INATIVAR SKUs
→ NÃO EXCLUIR
~~~

Preservar:

- ID;
- Cor;
- Tamanho;
- EAN;
- custos;
- Estoque;
- histórico.

---

# Remoção da Última Cor

A última Cor também pode ser retirada.

Nesse caso:

~~~text
todos os SKUs correspondentes
→ INATIVOS
~~~

O Produto permanece cadastrado.

Esse cenário foi homologado.

---

# Reativação de Cor

Ao reincluir uma Cor:

~~~text
localizar SKUs anteriores
→ reativar
→ preservar EAN
→ preservar identificador
~~~

Não criar SKU duplicado.

---

# EAN

EAN pertence ao SKU.

Regras:

- automático;
- backend;
- único;
- preservado;
- não reciclado;
- mesmo SKU mantém mesmo EAN;
- reativação não gera novo EAN.

---

# Estoque de Produto Venda

Granularidade:

~~~text
Loja × SKU
~~~

Não existe saldo comercial suficiente apenas no nível Produto.

Exemplo:

~~~text
Produto X
SKU Preto M
Loja 1 = 10
Loja 2 = 3
~~~

---

# Inicialização de Estoque

Ao cadastrar Produto Venda podem ser selecionadas Lojas.

Isso prepara:

~~~text
Loja × SKU
~~~

com quantidade inicial zero quando não existe movimentação.

Inicialização não representa entrada física.

---

# Estoque Físico, Reserva e Disponível

Conceito:

~~~text
Disponível = Físico - Reserva
~~~

Produto Venda apresenta a estrutura.

As regras definitivas de movimentação e reserva pertencem ao domínio de Estoque/Vendas.

---

# Custos

Conceitos existentes:

- custo original;
- última compra;
- custo médio.

Para Revenda:

~~~text
Compra
→ Recebimento
→ Estoque
→ Custos
~~~

Para Fabricação Própria:

~~~text
Ficha Técnica
→ Ordem de Produção
→ Produção
→ Custos
~~~

---

# Preços

Produto pode participar de múltiplas Tabelas de Preço.

Não foi definida regra obrigatória de:

~~~text
Preço por SKU
~~~

nem:

~~~text
Tabela de Preço por Loja
~~~

O motor comercial continua pertencendo ao domínio próprio.

---

# Dados Fiscais de Produto Venda

Campos expostos:

- NCM;
- Origem;
- CST/CSOSN ICMS;
- alíquota ICMS;
- CFOP dentro;
- CFOP fora;
- CST PIS;
- alíquota PIS;
- CST COFINS;
- alíquota COFINS;
- situação IPI;
- alíquota IPI.

Dados fiscais:

~~~text
EDITÁVEIS
+
RASTREADOS
~~~

---

# Histórico Funcional de Produto Venda

Estrutura:

~~~text
ProdutoVendaHistorico
~~~

Eventos incluem:

- alteração cadastral;
- alteração fiscal;
- Ativação;
- Inativação;
- Bloqueio de venda;
- Desbloqueio.

Não substitui `AuditLog`.

---

# Produto Venda e Auditoria

Separação:

~~~text
ProdutoVendaHistorico
→ visão funcional

AuditLog
→ Auditoria Central
~~~

Ambos devem ser preservados.

---

# Imagens do Produto

Estrutura:

~~~text
ProdutoImagem
~~~

Regras:

- opcionais;
- máximo de três;
- no máximo uma principal;
- pertencem ao Produto;
- não pertencem à Cor;
- não pertencem ao SKU.

---

# Imagem Reduzida

A interface utiliza:

~~~text
imagem_reduzida_url
~~~

quando disponível.

Fallback:

~~~text
imagem_url
~~~

Ainda não foram definidos:

- largura;
- altura;
- resolução;
- formato;
- qualidade;
- compressão.

Não inventar esses parâmetros.

Referência:

[[Riscos e Cuidados - Produtos - Produto Venda]]

---

# Situação do Produto

Estado cadastral:

~~~text
ATIVO
INATIVO
~~~

Inativar não exclui.

Produto Inativo preserva:

- Referência;
- SKUs;
- EANs;
- Estoque;
- histórico;
- movimentações.

---

# Bloqueio de Venda

Estado independente:

~~~text
bloqueado_venda
~~~

É permitido:

~~~text
ativo = true
bloqueado_venda = true
~~~

Portanto:

~~~text
Ativo != Venda liberada
~~~

---

# Ações Sensíveis de Produto Venda

Incluem:

- Inativar;
- Ativar;
- Bloquear venda;
- Desbloquear venda.

A autorização utiliza modelo funcional do Sysvar.

Estrutura:

~~~text
EffectiveAccessService
→ Produtos
→ EDIT
~~~

Não depender apenas de:

~~~text
is_staff
~~~

do Django Admin.

---

# Motivo e Senha

Quando exigidos pela ação, continuam obrigatórios.

Exemplo:

~~~text
Permissão EDIT
+
motivo
+
senha válida
→ executar
~~~

Permissão não substitui senha.

Senha não substitui permissão.

---

# Exclusão de Produto Venda

Produto nunca utilizado pode ser excluído quando não possuir vínculos impeditivos.

Produto utilizado:

~~~text
DELETE NEGADO
~~~

Alternativas:

- Inativar;
- Bloquear venda.

Registros técnicos de Estoque zero criados apenas na inicialização podem ser tratados de forma segura quando não existir utilização real.

---

# Filtros de Produto Venda

Processamento:

~~~text
SERVER-SIDE
~~~

Filtros incluem:

- busca;
- Tipo;
- Referência;
- Código;
- Grupo;
- Coleção;
- Status;
- Bloqueado;
- combinações.

Referência e Código permanecem critérios independentes.

---

# Paginação de Produto Venda

Processamento:

~~~text
SERVER-SIDE
~~~

Fluxo:

~~~text
page
page_size
filtros
ordering
↓
backend
↓
count
results
~~~

Indicador visual:

~~~text
Mostrando X–Y de Z
~~~

---

# Consulta Consolidada de Produto Venda

Consulta é somente leitura.

Apresenta, quando aplicável:

- dados cadastrais;
- classificação;
- Tipo;
- Referência;
- SKUs;
- Status dos SKUs;
- custos;
- Preço;
- Margem %;
- Dados fiscais;
- imagens;
- Estoque Loja × SKU;
- Histórico Funcional;
- Fichas Técnicas;
- Ordens de Produção.

---

# Status do SKU

A consulta apresenta explicitamente:

~~~text
Ativo
Inativo
~~~

Não utilizar apenas diferenciação visual por cor.

---

# Produto Venda - Revenda

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

Compras permanece responsável pelo processo de aquisição.

---

# Produto Venda - Fabricação Própria

Fluxo conceitual:

~~~text
Produto Venda
Tipo 3
   ↓
SKU
   ↓
Ficha Técnica
   ↓
Ordem de Produção
   ↓
Produção
   ↓
Estoque
   ↓
Venda
~~~

Produto Venda não substitui Produção.

---

# Integrações de Produto Venda

Produto Venda se relaciona com:

~~~text
Compras
Estoque
Preços
Fiscal
Produção
Vendas / PDV
Auditoria
~~~

Cada domínio preserva sua responsabilidade.

---

# Produto Venda e Compras

Compras permanece responsável por:

- Fornecedor;
- Pedido;
- itens;
- aprovação;
- recebimento;
- parcelas;
- integração financeira;
- entrada.

Produto Venda fornece Produto/SKU.

---

# Produto Venda e Produção

Produção permanece responsável por:

- Ficha Técnica;
- Ordem de Produção;
- consumo;
- facção;
- apontamento;
- custo;
- encerramento.

Produto Venda fornece a identidade do Produto fabricado.

---

# Produto Venda e Estoque

Estoque permanece responsável por:

- entradas;
- saídas;
- transferências;
- reservas;
- ajustes;
- saldos.

Produto Venda não executa livremente movimentos.

---

# Produto Venda e Fiscal

Produto mantém dados fiscais cadastrais.

Fiscal continua responsável pela aplicação desses dados nos documentos fiscais e pelas regras de emissão.

---

# Produto Venda e PDV

Para utilização comercial devem ser consideradas regras como:

~~~text
Produto ativo
AND não bloqueado para venda
AND SKU ativo
AND Estoque conforme política
AND preço válido
AND fiscal válido
~~~

A decisão definitiva pertence ao PDV/Vendas.

---

# Homologação Manual de Produto Venda

Foram homologados:

~~~text
19 ITENS
~~~

Resultado:

~~~text
19/19 APROVADOS
~~~

Itens:

1. Cadastro novo e obrigatoriedades;
2. Tipo imutável;
3. Grade imutável após SKU;
4. Descrição reduzida;
5. Grupo/Subgrupo;
6. Remoção de uma Cor;
7. Remoção da última Cor;
8. Reativação e preservação de EAN;
9. Exclusão de Produto nunca utilizado;
10. Proteção de Produto utilizado;
11. Histórico cadastral;
12. Alteração fiscal e Histórico;
13. Imagens;
14. Estoque Loja × SKU;
15. Consulta Fabricação Própria;
16. Filtros;
17. Inativar/Ativar;
18. Bloquear/Desbloquear venda;
19. Paginação.

Registro:

[[Homologação - Produtos - Produto Venda]]

---

# Correções Surgidas na Homologação de Produto Venda

## Modal de Lojas

Foi melhorado para:

- organização visual;
- seleção individual;
- ação Todas;
- Limpar.

## Status dos SKUs

Foi adicionada coluna:

~~~text
Status
~~~

com:

~~~text
Ativo
Inativo
~~~

Margem % foi preservada.

## Dados Fiscais

A interface inicialmente mostrava apenas NCM.

Foi corrigida para expor os demais campos fiscais já existentes.

## Imagens

Foi implementado gerenciamento frontend para:

- inclusão;
- remoção;
- principal;
- limite de três;
- miniaturas.

## Permissões

Ações de ciclo de vida inicialmente dependiam de `is_staff`/permissão Django.

Foram corrigidas para utilizar o modelo funcional do Sysvar.

Todos esses pontos foram retestados e aprovados.

---

# Testes Registrados de Produto Venda

Backend no fechamento final:

~~~text
8 testes direcionados aprovados
python manage.py check aprovado
~~~

Frontend no fechamento final:

~~~text
11 testes direcionados aprovados
TypeScript aprovado
~~~

Esses números representam testes direcionados de fechamento.

Não representam a quantidade total da suíte do Sysvar.

---

# Commits Homologados de Produto Venda

Backend final:

~~~text
574f5badc79ab3a969bf24ffc67904215bdbc49a
Corrige permissoes Produto Venda
~~~

Frontend final:

~~~text
1be513e4a5d7b3220ae239fee555594307115826
Finaliza homologacao visual Produto Venda
~~~

---

# Documentação Específica de Produto Venda

## Homologação

- [[Homologação - Produtos - Produto Venda]]

## Mapa Técnico

- [[Mapa Técnico - Produtos - Produto Venda]]

## Workflows

- [[Workflows - Produtos - Produto Venda]]

## Modelo de Domínio

- [[Modelo de Domínio - Produtos - Produto Venda]]

## Riscos e Cuidados

- [[Riscos e Cuidados - Produtos - Produto Venda]]

Esses documentos formam o conjunto documental oficial do Produto Venda.

---

# Relação Documental de Produto Venda

~~~text
                           [[Sysvar]]
                               │
             ┌─────────────────┼─────────────────┐
             │                 │                 │
             ↓                 ↓                 ↓
 [[Mapa Técnico]]   [[Homologação - Produtos - Produto Venda]]
                               │
               ┌───────────────┼───────────────┐
               ↓               ↓               ↓
 [[Mapa Técnico - Produtos - Produto Venda]]
 [[Workflows - Produtos - Produto Venda]]
 [[Modelo de Domínio - Produtos - Produto Venda]]
 [[Riscos e Cuidados - Produtos - Produto Venda]]
~~~

O objetivo é manter Produto Venda integrado ao grafo geral do projeto e não como ilha documental.

---

# Riscos Centrais de Produto Venda

Principais pontos que não devem regredir:

1. isolamento multiempresa;
2. Tipo imutável;
3. Referência automática;
4. Grade imutável após SKU;
5. SKU = Produto × Cor × Tamanho;
6. retirada de Cor inativa SKU;
7. retirada da última Cor;
8. reativação preserva SKU;
9. EAN preservado;
10. EAN não reciclado;
11. Estoque Loja × SKU;
12. inicialização não é entrada;
13. Produto utilizado não é excluído;
14. Inativação não é exclusão;
15. Bloqueio não é Inativação;
16. Fiscal é auditado;
17. Histórico Funcional não substitui AuditLog;
18. imagens no máximo três;
19. somente uma imagem principal;
20. backend continua autoridade;
21. filtros server-side;
22. paginação server-side;
23. permissões funcionais;
24. motivo e senha quando exigidos.

Detalhamento:

[[Riscos e Cuidados - Produtos - Produto Venda]]

---

# Pendência Conhecida - Imagem Reduzida

Ainda não foram aprovados:

- tamanho;
- resolução;
- largura;
- altura;
- formato;
- qualidade;
- compressão.

Regra atual:

~~~text
imagem_reduzida_url quando existir

senão

imagem_url
~~~

Não criar parâmetros arbitrários sem decisão técnica específica.

---

# Uso e Consumo

Uso e Consumo permanece separado.

Status:

~~~text
NÃO HOMOLOGADO COMO PARTE DE PRODUTO VENDA
~~~

Seu comportamento deverá ser analisado separadamente quando esse cadastro for escolhido como próximo escopo.

---

# Estratégia de Uso do Codex

Método atual:

## Usuário

Responsável por:

- decisão funcional;
- teste manual;
- homologação.

## ChatGPT

Responsável por:

- análise;
- leitura do GitHub;
- investigação;
- arquitetura;
- localização da causa;
- definição da solução;
- criação de prompt;
- revisão de commit;
- documentação.

## Codex

Responsável por:

- implementação;
- alteração de arquivos;
- testes necessários;
- commit.

---

# Regra de Economia de Codex

Para correções localizadas:

~~~text
ANALISAR ANTES
↓
LOCALIZAR CAUSA
↓
DEFINIR ARQUIVOS
↓
PROMPT CIRÚRGICO
↓
TESTES DIRECIONADOS
↓
REVISÃO
↓
HOMOLOGAÇÃO
~~~

Evitar investigação ampla desnecessária pelo Codex.

---

# Estratégia de Testes

Correção localizada:

- testes específicos;
- validação técnica necessária;
- homologação manual.

Checkpoint importante:

- suíte mais ampla;
- build;
- regressão.

Fechamento:

- testes relevantes;
- homologação completa;
- documentação.

---

# Regra de Continuidade

Nenhum item é considerado concluído apenas porque visualmente funciona.

Fechamento exige:

~~~text
ANÁLISE
↓
IMPLEMENTAÇÃO
↓
TESTES
↓
REVISÃO
↓
HOMOLOGAÇÃO
↓
DOCUMENTAÇÃO
↓
APROVAÇÃO
~~~

---

# Situação Atual dos Grupos

~~~text
OPERACIONAL
→ CONCLUÍDO
→ HOMOLOGADO
→ DOCUMENTADO

CADASTROS
→ CLIENTES CONCLUÍDO
→ FORNECEDORES CONCLUÍDO
→ FUNCIONÁRIOS CONCLUÍDO
→ ESCOPO PRIORITÁRIO ATUAL ENCERRADO

PRODUTOS
→ EM ANDAMENTO

PRODUTO VENDA
→ CONCLUÍDO
→ HOMOLOGADO 19/19
→ DOCUMENTADO
~~~

---

# Próxima Etapa

O projeto entrou no grupo:

~~~text
PRODUTOS
~~~

O primeiro escopo foi:

~~~text
PRODUTO VENDA
~~~

e está concluído.

O próximo item do grupo Produtos deverá ser definido funcionalmente antes de nova implementação.

Uso e Consumo permanece candidato natural por proximidade de domínio, mas não deve ser tratado como automaticamente aprovado ou igual a Produto Venda.

Antes de qualquer implementação:

1. identificar o próximo escopo;
2. analisar o comportamento existente;
3. verificar backend;
4. verificar frontend;
5. identificar vínculos;
6. definir regras funcionais;
7. verificar multiempresa;
8. verificar permissões;
9. verificar Auditoria;
10. verificar integrações;
11. definir testes;
12. somente então preparar o prompt do Codex.

---

# Estado Documental

## Operacional

~~~text
HOMOLOGADO
DOCUMENTADO
~~~

## Clientes

~~~text
23/23
DOCUMENTAÇÃO CONCLUÍDA
~~~

## Fornecedores

~~~text
30/30
DOCUMENTAÇÃO CONCLUÍDA
~~~

## Funcionários

~~~text
17/17
DOCUMENTAÇÃO CONCLUÍDA
~~~

## Produto Venda

~~~text
19/19
DOCUMENTAÇÃO CONCLUÍDA
~~~

Documentos de Produto Venda:

- [[Homologação - Produtos - Produto Venda]]
- [[Mapa Técnico - Produtos - Produto Venda]]
- [[Workflows - Produtos - Produto Venda]]
- [[Modelo de Domínio - Produtos - Produto Venda]]
- [[Riscos e Cuidados - Produtos - Produto Venda]]

---

# Estado Atual Consolidado

~~~text
GRUPO OPERACIONAL
→ CONCLUÍDO
→ HOMOLOGADO
→ DOCUMENTADO

CADASTROS > CLIENTES
→ CONCLUÍDO
→ 23/23 HOMOLOGADOS
→ DOCUMENTADO

CADASTROS > FORNECEDORES
→ CONCLUÍDO
→ 30/30 HOMOLOGADOS
→ DOCUMENTADO

CADASTROS > FUNCIONÁRIOS
→ CONCLUÍDO
→ 17/17 HOMOLOGADOS
→ DOCUMENTADO

GRUPO PRODUTOS
→ EM ANDAMENTO

PRODUTOS > PRODUTO VENDA
→ CONCLUÍDO
→ 19/19 HOMOLOGADOS
→ DOCUMENTADO
~~~

---

# Marco Atual

Em **13/08/2026**, o projeto atingiu o seguinte marco:

~~~text
INFRAESTRUTURA OPERACIONAL
CONCLUÍDA E HOMOLOGADA

CLIENTES
CONCLUÍDO E HOMOLOGADO
23/23

FORNECEDORES
FASE 1 CONCLUÍDA E HOMOLOGADA
30/30

FUNCIONÁRIOS
FASE 1 CONCLUÍDA E HOMOLOGADA
17/17

PRODUTO VENDA
CONCLUÍDO E HOMOLOGADO
19/19
~~~

O desenvolvimento segue agora dentro do grupo Produtos.

---

# Princípios que Devem Continuar Sendo Preservados

- isolamento multiempresa;
- tenant no backend;
- Empresa como limite de dados;
- Estabelecimento como contexto operacional;
- perfis e permissões;
- permissões efetivas;
- Auditoria Central;
- Histórico funcional quando o domínio exigir;
- integridade histórica;
- proteção de dados sensíveis;
- backend como autoridade;
- separação dos domínios;
- paginação server-side;
- filtros server-side;
- compatibilidade entre módulos;
- homologação item a item;
- documentação no Obsidian;
- links internos entre documentos;
- uso econômico do Codex.

---

# Notas Gerais Relacionadas

## Contexto Central

- [[Mapa Técnico]]
- [[10 Projetos/Sysvar/Contexto do Projeto/Visão Geral|Visão Geral]]
- [[10 Projetos/Sysvar/Contexto do Projeto/Arquitetura|Arquitetura]]
- [[10 Projetos/Sysvar/Contexto do Projeto/Modelo de Domínio|Modelo de Domínio]]
- [[10 Projetos/Sysvar/Contexto do Projeto/Workflows|Workflows]]
- [[10 Projetos/Sysvar/Contexto do Projeto/Riscos e Cuidados|Riscos e Cuidados]]

## Decisões Técnicas

- [[10 Projetos/Sysvar/Decisões Técnicas/ADR-001 - Licenciamento por Sessões Simultâneas|ADR-001 - Licenciamento por Sessões Simultâneas]]
- [[10 Projetos/Sysvar/Decisões Técnicas/ADR-002 - Princípios Arquiteturais do SISVAR|ADR-002 - Princípios Arquiteturais do SISVAR]]
- [[10 Projetos/Sysvar/Decisões Técnicas/ADR-003 - Auditoria Central do SISVAR|ADR-003 - Auditoria Central do SISVAR]]

## Produto Venda

- [[Homologação - Produtos - Produto Venda]]
- [[Mapa Técnico - Produtos - Produto Venda]]
- [[Workflows - Produtos - Produto Venda]]
- [[Modelo de Domínio - Produtos - Produto Venda]]
- [[Riscos e Cuidados - Produtos - Produto Venda]]

---

# Estado do Projeto em 13/08/2026

A infraestrutura operacional central está concluída e homologada.

O escopo prioritário revisado de Cadastros possui três módulos encerrados:

~~~text
CLIENTES
FORNECEDORES
FUNCIONÁRIOS
~~~

O grupo Produtos está em andamento.

Seu primeiro domínio consolidado está encerrado:

~~~text
PRODUTO VENDA
~~~

Resultados acumulados das homologações documentadas:

~~~text
CLIENTES
23/23

FORNECEDORES
30/30

FUNCIONÁRIOS
17/17

PRODUTO VENDA
19/19
~~~

Produto Venda possui documentação funcional, técnica, de domínio, workflows e riscos interligada ao nó principal [[Sysvar]].

O próximo domínio deverá ser definido antes de qualquer nova implementação.

O desenvolvimento deve continuar preservando:

- decisões funcionais antes do código;
- investigação antes do Codex;
- testes proporcionais à alteração;
- revisão técnica;
- homologação manual;
- documentação;
- integração do documento ao grafo do Obsidian;
- fechamento formal somente após aprovação.