---
type: project
status: active
project: Sysvar
source: "C:/SysvarProjeto"
created: 2026-08-03
updated: 2026-08-14
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
  - produto-uso-consumo
  - insumos
  - cadastros-auxiliares
  - revenda
  - fabricação-própria
  - sku
  - ean
  - grades
  - tamanhos
  - cores
  - coleções
  - packs
  - unidades
  - material
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

- isolamento entre Empresas;
- controle por Estabelecimentos;
- segurança baseada em Perfis e Permissões;
- Auditoria completa;
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
- Naturezas de Lançamento;
- Formas de Pagamento;
- demais cadastros operacionais.

## Produtos

- Produto Venda;
- Revenda;
- Fabricação Própria;
- Produto Uso/Consumo;
- Insumos;
- Grupos;
- Subgrupos;
- Grades;
- Tamanhos;
- Coleções;
- Packs;
- Unidades;
- Cores;
- Material;
- SKUs;
- EAN;
- NCM;
- Tabelas de Preço;
- Promoções;
- imagens;
- Dados Fiscais.

## Compras

- Pedidos de Compra;
- Produtos Venda;
- Produtos Uso/Consumo;
- Insumos;
- Fornecedores;
- Packs;
- aprovação;
- cancelamento;
- parcelas;
- integração financeira;
- recebimento;
- Entrada Fiscal.

## Fiscal

- vendas;
- NFC-e;
- devoluções;
- documentos fiscais;
- impostos;
- regras tributárias;
- Entrada Fiscal.

## Estoque

- entradas;
- saídas;
- transferências;
- saldos;
- Estoque por Empresa;
- Estoque por Estabelecimento;
- Estoque por SKU;
- Estoque de Produtos Uso/Consumo;
- Estoque de Insumos;
- reservas;
- disponibilidade.

## Distribuição

- fábrica para Lojas;
- distribuição manual;
- distribuição percentual;
- perfis de distribuição;
- distribuição por Grade;
- distribuição de Fabricação Própria;
- distribuição de Revenda.

## Produção

- Ficha Técnica;
- Ordem de Produção;
- Insumos;
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

- Contas a Pagar;
- Contas a Receber;
- Formas de Pagamento;
- parcelas;
- rateios;
- Plano Financeiro;
- Natureza de Lançamento.

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
- Perfis;
- Permissões efetivas;
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
- Administração de Sessões;
- Diagnóstico de Sessões;
- Reconciliação de Sessões;
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

A quantidade de Usuários cadastrados não representa consumo de licença.

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
- Usuários diferentes podem utilizar o mesmo dispositivo;
- o mesmo Usuário no mesmo dispositivo substitui sua sessão anterior;
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
- Permissões;
- Estabelecimentos;
- Perfis;
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
- demais eventos relevantes.

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
- ausência de stack trace para Usuários;
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

Os três cadastros prioritários dessa etapa foram concluídos, homologados e documentados.

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

## Regras Centrais

Todo Cliente pertence a uma Empresa.

Unicidade:

~~~text
Empresa + documento
~~~

Mais de um Cliente sem documento é permitido.

Cada Empresa possui seu próprio:

~~~text
Consumidor Final
~~~

Cliente padrão possui proteção contra:

- exclusão;
- inativação;
- bloqueio;
- mudança de documento;
- mudança de Tipo;
- perda da condição de Cliente padrão.

Ciclo de vida:

~~~text
Ativar
Inativar
Bloquear
Desbloquear
~~~

## Documentação

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
- Fiscal;
- Comercial;
- Financeiro;
- Contábil;
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

Dados bancários possuem proteção própria.

Ciclo de vida:

~~~text
Ativar
Inativar
Bloquear
Desbloquear
~~~

Fornecedor com vínculos deve ser preservado e inativado em vez de excluído.

## Documentação

- [[10 Projetos/Sysvar/Homologações/Homologação - Cadastros - Fornecedores|Homologação - Cadastros - Fornecedores]]
- [[10 Projetos/Sysvar/Contexto do Projeto/Mapa Técnico - Cadastros - Fornecedores|Mapa Técnico - Cadastros - Fornecedores]]
- [[10 Projetos/Sysvar/Contexto do Projeto/Modelo de Domínio - Cadastros - Fornecedores|Modelo de Domínio - Cadastros - Fornecedores]]
- [[10 Projetos/Sysvar/Contexto do Projeto/Workflows - Cadastros - Fornecedores|Workflows - Cadastros - Fornecedores]]
- [[10 Projetos/Sysvar/Contexto do Projeto/Riscos e Cuidados - Cadastros - Fornecedores|Riscos e Cuidados - Cadastros - Fornecedores]]

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

Não representa módulo completo de RH/DP.

Separações fundamentais:

~~~text
Funcionário != Usuário
Cargo != Perfil
Cargo != Permissão
Loja supervisionada != Loja permitida do Usuário
Situação do Funcionário != User.is_active
Comissão básica != Motor completo de comissão
FuncionarioHistorico != AuditLog
~~~

Situações:

~~~text
ATIVO
AFASTADO
DESLIGADO
~~~

Ações:

~~~text
Afastar
Retornar
Desligar
Recontratar
~~~

Recontratação reutiliza o mesmo cadastro.

Funcionário pode possuir:

- Loja Principal;
- Cargo;
- Lojas supervisionadas;
- abrangência por todas as Lojas da Empresa;
- comissão;
- Usuário opcional.

Funcionário e Usuário permanecem entidades independentes.

## Documentação

- [[Homologação - Cadastros - Funcionários]]
- [[Mapa Técnico - Cadastros - Funcionários]]
- [[Workflows - Cadastros - Funcionários]]
- [[Modelo de Domínio - Cadastros - Funcionários]]
- [[Riscos e Cuidados - Cadastros - Funcionários]]

---

# Grupo Produtos

## Situação do Ciclo Cadastral Atual

~~~text
PRODUTO VENDA
→ CONCLUÍDO
→ HOMOLOGADO
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

O ciclo cadastral atualmente revisado do grupo Produtos está consolidado.

Os quatro blocos possuem documentação funcional, técnica, de workflows, domínio e riscos.

---

# Arquitetura dos Tipos de Produto

A entidade Produto atende domínios diferentes.

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

Esses tipos compartilham infraestrutura técnica, mas não devem compartilhar indiscriminadamente as mesmas regras funcionais.

---

# Produto Venda

Produto Venda representa os Produtos destinados à comercialização.

Tipos:

~~~text
1 = Revenda
3 = Fabricação Própria
~~~

Nomenclatura funcional:

**Produto Venda**

Para tipo `3`:

**Fabricação Própria**

Produto Venda não engloba Uso/Consumo ou Insumos.

---

# Produto versus SKU

Separação:

~~~text
Produto != SKU
~~~

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

# Estruturas Principais de Produto Venda

Produto Venda utiliza:

- Empresa;
- Coleção;
- Grupo;
- Subgrupo;
- Unidade;
- Material quando aplicável;
- Grade;
- Tamanhos;
- Cores;
- SKUs;
- EAN;
- Dados Fiscais;
- preços;
- imagens;
- Estoque Loja × SKU;
- Histórico Funcional;
- Auditoria.

Modelo detalhado:

[[Modelo de Domínio - Produtos - Produto Venda]]

---

# Grade, Cores e SKUs

Grade define Tamanhos possíveis.

Após existirem SKUs:

~~~text
GRADE IMUTÁVEL
~~~

Ao incluir Cor:

~~~text
Cor
+
Tamanhos da Grade
=
SKUs
~~~

Ao retirar Cor:

~~~text
REMOVER COR
→ INATIVAR SKUs
→ NÃO EXCLUIR
~~~

Ao reincluir Cor:

~~~text
LOCALIZAR SKUs ANTERIORES
→ REATIVAR
→ PRESERVAR EAN
→ PRESERVAR ID
~~~

---

# EAN

EAN pertence ao SKU.

Regras:

- automático;
- gerado no backend;
- único;
- preservado;
- não reciclado;
- mesmo SKU mantém o mesmo EAN;
- reativação não gera novo EAN.

---

# Estoque de Produto Venda

Granularidade:

~~~text
Loja × SKU
~~~

Inicialização de registro de Estoque com zero não representa entrada física.

Disponibilidade conceitual:

~~~text
Disponível = Físico - Reserva
~~~

Movimentação continua sendo responsabilidade do módulo Estoque.

---

# Produto Venda - Revenda

Fluxo:

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

---

# Produto Venda - Fabricação Própria

Fluxo:

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

Produto Venda fornece a identidade do Produto fabricado.

Produção permanece responsável pelo processo produtivo.

---

# Ciclo de Vida de Produto Venda

Estado cadastral:

~~~text
ATIVO
INATIVO
~~~

Estado comercial independente:

~~~text
bloqueado_venda
~~~

Portanto:

~~~text
Ativo != Venda liberada
~~~

Produto utilizado deve ser preservado.

Alternativas à exclusão:

- Inativar;
- Bloquear Venda.

---

# Histórico e Auditoria de Produto Venda

Separação:

~~~text
ProdutoVendaHistorico
→ visão funcional

AuditLog
→ Auditoria Central
~~~

Ambos devem ser preservados.

---

# Imagens de Produto Venda

Regras consolidadas:

- imagens opcionais;
- máximo de três;
- somente uma principal;
- pertencem ao Produto;
- não pertencem à Cor;
- não pertencem ao SKU.

A interface pode utilizar:

~~~text
imagem_reduzida_url
~~~

quando disponível.

Fallback:

~~~text
imagem_url
~~~

Ainda não existe definição homologada para:

- largura;
- altura;
- resolução;
- formato;
- qualidade;
- compressão.

---

# Homologação de Produto Venda

Resultado:

~~~text
19/19 APROVADOS
~~~

Registro:

[[Homologação - Produtos - Produto Venda]]

## Documentação

- [[Homologação - Produtos - Produto Venda]]
- [[Mapa Técnico - Produtos - Produto Venda]]
- [[Workflows - Produtos - Produto Venda]]
- [[Modelo de Domínio - Produtos - Produto Venda]]
- [[Riscos e Cuidados - Produtos - Produto Venda]]

---

# Produto Uso/Consumo

Produto Uso/Consumo é um domínio próprio.

Tipo:

~~~text
tipo_produto = '2'
~~~

Situação:

~~~text
IMPLEMENTADO
HOMOLOGADO
DOCUMENTADO
APROVADO
~~~

Produto Uso/Consumo representa itens utilizados internamente pela Empresa e que não são destinados à venda normal ao consumidor.

Exemplos:

- materiais administrativos;
- materiais de limpeza;
- peças de manutenção;
- materiais internos diversos.

---

# Separação de Produto Uso/Consumo

~~~text
Produto Uso/Consumo
!=
Produto Venda

Produto Uso/Consumo
!=
Insumo
~~~

Uso/Consumo:

~~~text
uso interno não produtivo
~~~

Insumo:

~~~text
componente da fabricação
~~~

---

# Regras Centrais de Produto Uso/Consumo

- tipo interno `2`;
- domínio próprio;
- código próprio;
- descrição;
- Unidade;
- NCM opcional no cadastro;
- Dados Fiscais;
- situação Fiscal Completo/Incompleto;
- lifecycle Ativo/Inativo;
- exclusão protegida;
- multiempresa;
- paginação server-side;
- filtros server-side;
- consulta consolidada;
- custos provenientes de eventos reais;
- Auditoria.

---

# Estoque de Produto Uso/Consumo

Produto Uso/Consumo possui natureza de Estoque.

Não existe campo:

~~~text
controla_estoque
~~~

O cadastro não define localização fixa.

Não existe regra:

~~~text
Uso/Consumo
→ somente Matriz
~~~

A localização nasce da operação.

~~~text
Produto
!=
Local de Estoque
~~~

Saldo deve decorrer de movimentos reais.

---

# Produto Uso/Consumo e PDV

Produto Uso/Consumo não é destinado à venda.

~~~text
tipo_produto = '2'
→ não deve participar normalmente do PDV
~~~

Também não deve receber automaticamente:

- Grade;
- Cor × Tamanho;
- SKU comercial;
- Coleção;
- Tabela de Preço obrigatória;
- Promoção;
- Bloqueio de Venda.

---

# Produto Uso/Consumo e Produção

Produto Uso/Consumo não é Insumo.

Não deve ser utilizado automaticamente como:

- componente de Ficha Técnica;
- consumo de Ordem de Produção;
- matéria-prima.

---

# Documentação de Produto Uso/Consumo

- [[Homologação - Produtos - Produto Uso e Consumo]]
- [[Mapa Técnico - Produtos - Produto Uso e Consumo]]
- [[Workflows - Produtos - Produto Uso e Consumo]]
- [[Modelo de Domínio - Produtos - Produto Uso e Consumo]]
- [[Riscos e Cuidados - Produtos - Produto Uso e Consumo]]

---

# Insumos

Insumos representam materiais utilizados diretamente na fabricação.

Tipo:

~~~text
tipo_produto = '4'
~~~

Situação:

~~~text
IMPLEMENTADO
HOMOLOGADO
DOCUMENTADO
APROVADO
~~~

Exemplos:

- tecidos;
- linhas;
- botões;
- zíperes;
- etiquetas;
- elásticos;
- aviamentos;
- demais componentes produtivos.

---

# Separação de Insumos

~~~text
Insumo
!=
Produto Venda

Insumo
!=
Produto Uso/Consumo
~~~

Uso/Consumo:

~~~text
consumo interno não produtivo
~~~

Insumo:

~~~text
consumo produtivo
~~~

---

# Regras Centrais de Insumos

- tipo interno `4`;
- domínio próprio;
- Empresa;
- descrição;
- Unidade;
- Material opcional;
- NCM/Dados Fiscais quando aplicáveis;
- custos;
- natureza de Estoque;
- lifecycle Ativo/Inativo;
- exclusão protegida;
- multiempresa;
- integração com Compras;
- participação em Ficha Técnica;
- preparação para Produção.

---

# Unidade de Insumos

A Unidade define como o material é quantificado.

Exemplos:

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

deve ser respeitada pelos processos consumidores.

---

# Material e Insumo

Material é opcional.

Separação:

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

Compras, Estoque e Produção utilizam o Insumo, não o Material isoladamente.

---

# Estoque de Insumos

Insumo possui natureza de Estoque.

Não existe campo:

~~~text
controla_estoque
~~~

O cadastro não define localização fixa.

Não fixa:

- Matriz;
- fábrica;
- almoxarifado;
- Loja;
- facção.

A operação física determina a localização.

---

# Insumos e Ficha Técnica

Relação conceitual:

~~~text
Produto Fabricação Própria
        ↓
Ficha Técnica
        ↓
Insumos
        ↓
Quantidade prevista
~~~

A quantidade pertence à relação:

~~~text
Ficha Técnica × Insumo
~~~

e não ao cadastro principal do Insumo.

---

# Insumos e Ordem de Produção

A Ficha Técnica pode fornecer a necessidade teórica de materiais para a OP.

Entretanto:

~~~text
CRIAR OP
!=
BAIXAR INSUMOS
~~~

e:

~~~text
CRIAR OP
!=
RESERVAR AUTOMATICAMENTE INSUMOS
~~~

O evento físico de:

- reserva;
- separação;
- baixa;
- consumo;
- perda;
- sobra;
- envio para facção;

deverá ser definido no domínio de Produção/Estoque.

---

# Consumo Previsto versus Real

~~~text
Ficha Técnica
→ consumo previsto

Produção
→ consumo real
~~~

Esses conceitos não devem ser confundidos.

---

# Documentação de Insumos

- [[Homologação - Produtos - Insumos]]
- [[Mapa Técnico - Produtos - Insumos]]
- [[Workflows - Produtos - Insumos]]
- [[Modelo de Domínio - Produtos - Insumos]]
- [[Riscos e Cuidados - Produtos - Insumos]]

---

# Cadastros Auxiliares de Produtos

Situação:

~~~text
IMPLEMENTADOS
HOMOLOGADOS
DOCUMENTADOS
APROVADOS
~~~

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

---

# Princípio dos Cadastros Auxiliares

~~~text
Cadastro Auxiliar
→ define estrutura

Produto
→ utiliza estrutura

Processo Operacional
→ utiliza Produto
~~~

Não transformar Cadastro Auxiliar em processo operacional.

---

# Grupo e Subgrupo

Grupo possui:

- Código;
- Descrição;
- Código de Referência;
- Margem.

Código de Referência:

~~~text
2 dígitos numéricos
~~~

Deve ser único por Empresa.

Subgrupo pertence ao Grupo.

~~~text
Grupo
   ↓
Subgrupos
~~~

---

# Grade e Tamanho

Grade possui Tamanhos.

~~~text
Grade
   ↓
Tamanhos
~~~

Produto Venda utiliza:

~~~text
Grade
+
Cor
+
Tamanho
→ SKU
~~~

Grade utilizada deve ter alterações estruturais protegidas.

---

# Coleções

Coleção possui:

- Código;
- Estação;
- Descrição;
- Status.

Estação:

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

O contador de geração da Referência permanece interno.

---

# Unidades

Unidade possui:

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
~~~

Código deve possuir unicidade.

---

# Cores

Cor é utilizada principalmente por Produto Venda.

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

Cor não é SKU.

---

# Material

Material é um cadastro classificatório.

Campos:

- Código;
- Descrição;
- Ativo/Inativo.

Material é opcional em Insumos.

Não substitui Insumo.

---

# Packs

Pack pertence a uma Grade.

Possui:

- Nome;
- Grade;
- Ativo/Inativo;
- Itens.

Cada Item possui:

- Tamanho;
- Quantidade.

Regras:

~~~text
Tamanho não pode repetir no mesmo Pack

Quantidade > 0
~~~

Cálculo:

~~~text
Número de Packs
×
Soma das quantidades do Pack
=
Quantidade total de peças
~~~

---

# Padrão Visual dos Cadastros Auxiliares

O padrão homologado utiliza:

~~~text
Checkbox
+
Seleção única
+
Linha destacada
+
Barra de ações
~~~

Nas telas modernizadas foram removidos:

~~~text
Coluna Ações
Menu ⋮
~~~

quando redundantes.

---

# Master-Detail

Principais pares:

~~~text
Grupo
→ Subgrupos

Grade
→ Tamanhos

Pack
→ Itens
~~~

O detalhe é tratado em sobretela/modal.

A barra do detalhe apresenta apenas as ações pertinentes.

---

# Consulta em Sobretela

Nas telas que utilizam o padrão atual:

~~~text
Selecionar registro
        ↓
Consultar
        ↓
Sobretela / Modal
        ↓
Somente leitura
        ↓
Fechar
        ↓
Retornar ao contexto original
~~~

---

# Exclusão Protegida dos Auxiliares

Antes da exclusão devem ser verificadas dependências.

Exemplos:

- Grupo usado por Produto;
- Subgrupo usado por Produto;
- Grade usada;
- Tamanho usado;
- Coleção usada;
- Unidade usada;
- Cor usada;
- Material usado;
- Pack usado em Pedido.

Integridade histórica possui prioridade sobre exclusão física.

---

# Documentação dos Cadastros Auxiliares

- [[Homologação - Produtos - Cadastros Auxiliares]]
- [[Mapa Técnico - Produtos - Cadastros Auxiliares]]
- [[Workflows - Produtos - Cadastros Auxiliares]]
- [[Modelo de Domínio - Produtos - Cadastros Auxiliares]]
- [[Riscos e Cuidados - Produtos - Cadastros Auxiliares]]

---

# Integração entre os Domínios de Produtos

Visão consolidada:

~~~text
                    PRODUTO
                       │
       ┌───────────────┼────────────────┐
       │               │                │
       ↓               ↓                ↓
 PRODUTO VENDA    USO/CONSUMO       INSUMO
 tipos 1 e 3        tipo 2           tipo 4
       │               │                │
       ↓               ↓                ↓
 Venda/PDV        Uso interno       Produção
       │               │                │
       ↓               ↓                ↓
 Estoque SKU         Estoque          Estoque
                                         │
                                         ↓
                                   Ficha Técnica
~~~

Cadastros Auxiliares fornecem estruturas compartilháveis somente quando pertencem ao domínio correspondente.

---

# Produto Venda e Compras

Compras permanece responsável por:

- Fornecedor;
- Pedido;
- itens;
- Packs;
- aprovação;
- recebimento;
- parcelas;
- integração financeira;
- entrada.

Produto Venda fornece:

- Produto;
- SKU;
- Grade;
- Pack;
- demais informações cadastrais necessárias.

---

# Produto Uso/Consumo e Compras

Produto Uso/Consumo pode participar de Compras.

Compras determina:

- Fornecedor;
- quantidade;
- preço;
- recebimento;
- localização de Estoque;
- custos;
- Financeiro.

O cadastro não executa essas operações.

---

# Insumos e Compras

Insumos também podem participar de Compras.

Fluxo:

~~~text
Fornecedor
   ↓
Pedido
   ↓
Insumo
   ↓
Recebimento
   ↓
Estoque
   ↓
Produção futura
~~~

---

# Produtos e Estoque

Separação geral:

~~~text
Produto
→ identidade cadastral

Estoque
→ quantidade + localização + movimentos
~~~

Produto Venda:

~~~text
Loja × SKU
~~~

Uso/Consumo e Insumos:

~~~text
localização definida pela operação
~~~

---

# Produtos e Fiscal

Produto mantém informações fiscais cadastrais.

Fiscal permanece responsável por:

- validar operação;
- aplicar tributação;
- emitir documentos;
- processar entradas e saídas.

Cadastro fiscal incompleto pode existir quando o domínio permitir.

A operação fiscal é responsável por exigir os dados necessários ao evento real.

---

# Produtos e Produção

Fabricação Própria:

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
~~~

Uso/Consumo tipo 2 não deve ser tratado automaticamente como Insumo.

---

# Produtos e PDV

Produto Venda é o domínio comercial.

Antes da venda devem ser consideradas as regras próprias de:

- Produto Ativo;
- Bloqueio de Venda;
- SKU Ativo;
- Estoque;
- Preço;
- Fiscal.

Produto Uso/Consumo e Insumos não devem aparecer como Produtos normais de venda.

---

# Estratégia de Uso do Codex

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
- revisão;
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
- homologação;
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
→ ESCOPO PRIORITÁRIO ENCERRADO

PRODUTOS
→ CICLO CADASTRAL ATUAL CONCLUÍDO

PRODUTO VENDA
→ CONCLUÍDO
→ HOMOLOGADO 19/19
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
~~~

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

Documentos:

- [[Homologação - Produtos - Produto Venda]]
- [[Mapa Técnico - Produtos - Produto Venda]]
- [[Workflows - Produtos - Produto Venda]]
- [[Modelo de Domínio - Produtos - Produto Venda]]
- [[Riscos e Cuidados - Produtos - Produto Venda]]

## Produto Uso/Consumo

~~~text
HOMOLOGADO
DOCUMENTAÇÃO CONCLUÍDA
~~~

Documentos:

- [[Homologação - Produtos - Produto Uso e Consumo]]
- [[Mapa Técnico - Produtos - Produto Uso e Consumo]]
- [[Workflows - Produtos - Produto Uso e Consumo]]
- [[Modelo de Domínio - Produtos - Produto Uso e Consumo]]
- [[Riscos e Cuidados - Produtos - Produto Uso e Consumo]]

## Insumos

~~~text
HOMOLOGADO
DOCUMENTAÇÃO CONCLUÍDA
~~~

Documentos:

- [[Homologação - Produtos - Insumos]]
- [[Mapa Técnico - Produtos - Insumos]]
- [[Workflows - Produtos - Insumos]]
- [[Modelo de Domínio - Produtos - Insumos]]
- [[Riscos e Cuidados - Produtos - Insumos]]

## Cadastros Auxiliares de Produtos

~~~text
HOMOLOGADOS
DOCUMENTAÇÃO CONCLUÍDA
~~~

Documentos:

- [[Homologação - Produtos - Cadastros Auxiliares]]
- [[Mapa Técnico - Produtos - Cadastros Auxiliares]]
- [[Workflows - Produtos - Cadastros Auxiliares]]
- [[Modelo de Domínio - Produtos - Cadastros Auxiliares]]
- [[Riscos e Cuidados - Produtos - Cadastros Auxiliares]]

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

PRODUTOS > PRODUTO VENDA
→ CONCLUÍDO
→ 19/19 HOMOLOGADOS
→ DOCUMENTADO

PRODUTOS > PRODUTO USO/CONSUMO
→ CONCLUÍDO
→ HOMOLOGADO
→ DOCUMENTADO

PRODUTOS > INSUMOS
→ CONCLUÍDO
→ HOMOLOGADO
→ DOCUMENTADO

PRODUTOS > CADASTROS AUXILIARES
→ CONCLUÍDOS
→ HOMOLOGADOS
→ DOCUMENTADOS
~~~

---

# Marco Atual

Em **14/08/2026**, o projeto atingiu o seguinte marco:

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

PRODUTO USO/CONSUMO
CONCLUÍDO E HOMOLOGADO

INSUMOS
CONCLUÍDO E HOMOLOGADO

CADASTROS AUXILIARES DE PRODUTOS
CONCLUÍDOS E HOMOLOGADOS
~~~

O ciclo cadastral atualmente revisado do grupo Produtos está concluído e documentado.

---

# Próximas Etapas

O próximo escopo funcional deve ser definido antes de nova implementação.

Antes de iniciar qualquer novo domínio:

1. identificar o escopo;
2. analisar o comportamento existente;
3. verificar backend;
4. verificar frontend;
5. identificar integrações;
6. definir regras funcionais;
7. verificar multiempresa;
8. verificar Permissões;
9. verificar Auditoria;
10. definir responsabilidades entre módulos;
11. definir testes;
12. somente então preparar implementação.

Não transportar automaticamente regras de um domínio para outro.

---

# Princípios que Devem Continuar Sendo Preservados

- isolamento multiempresa;
- tenant no backend;
- Empresa como limite de dados;
- Estabelecimento como contexto operacional;
- Perfis e Permissões;
- Permissões efetivas;
- Auditoria Central;
- Histórico funcional quando o domínio exigir;
- integridade histórica;
- proteção de dados sensíveis;
- backend como autoridade;
- separação dos domínios;
- paginação server-side;
- filtros server-side;
- compatibilidade entre módulos;
- exclusão protegida;
- lifecycle coerente;
- documentação no Obsidian;
- links internos entre documentos;
- testes proporcionais ao risco;
- uso econômico do Codex.

---

# Navegação Documental

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

## Produto Uso/Consumo

- [[Homologação - Produtos - Produto Uso e Consumo]]
- [[Mapa Técnico - Produtos - Produto Uso e Consumo]]
- [[Workflows - Produtos - Produto Uso e Consumo]]
- [[Modelo de Domínio - Produtos - Produto Uso e Consumo]]
- [[Riscos e Cuidados - Produtos - Produto Uso e Consumo]]

## Insumos

- [[Homologação - Produtos - Insumos]]
- [[Mapa Técnico - Produtos - Insumos]]
- [[Workflows - Produtos - Insumos]]
- [[Modelo de Domínio - Produtos - Insumos]]
- [[Riscos e Cuidados - Produtos - Insumos]]

## Cadastros Auxiliares de Produtos

- [[Homologação - Produtos - Cadastros Auxiliares]]
- [[Mapa Técnico - Produtos - Cadastros Auxiliares]]
- [[Workflows - Produtos - Cadastros Auxiliares]]
- [[Modelo de Domínio - Produtos - Cadastros Auxiliares]]
- [[Riscos e Cuidados - Produtos - Cadastros Auxiliares]]

---

# Estado do Projeto em 14/08/2026

A infraestrutura operacional central está concluída e homologada.

O escopo prioritário de Cadastros possui três módulos encerrados:

~~~text
CLIENTES
FORNECEDORES
FUNCIONÁRIOS
~~~

O ciclo cadastral atualmente revisado de Produtos também está encerrado:

~~~text
PRODUTO VENDA
PRODUTO USO/CONSUMO
INSUMOS
CADASTROS AUXILIARES DE PRODUTOS
~~~

Produto Venda possui homologação manual:

~~~text
19/19
~~~

Produto Uso/Consumo, Insumos e Cadastros Auxiliares foram funcionalmente validados e possuem seus respectivos conjuntos documentais concluídos.

Todos os quatro blocos estão ligados ao nó principal [[Sysvar]].

O desenvolvimento deve continuar preservando:

- decisão funcional antes do código;
- investigação antes do Codex;
- implementação restrita ao escopo decidido;
- testes proporcionais à alteração;
- revisão técnica;
- homologação manual;
- documentação;
- integração ao grafo do Obsidian;
- fechamento formal somente após aprovação.