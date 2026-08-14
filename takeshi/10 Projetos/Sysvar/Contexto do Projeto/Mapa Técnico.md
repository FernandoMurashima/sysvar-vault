---
type: reference
status: active
project: Sysvar
source: "C:/SysvarProjeto"
created: 2026-08-03
updated: 2026-08-14
tags:
  - sysvar
  - contexto
  - mapa-tecnico
  - backend
  - frontend
  - operacional
  - cadastros
  - produtos
  - produto-venda
  - produto-uso-consumo
  - insumos
  - cadastros-auxiliares
  - sku
  - estoque
  - produção
  - auditoria
  - sessões
  - licenciamento
  - multiempresa
  - homologado
---

# Mapa Técnico

## Objetivo

Este documento indica onde estão as principais responsabilidades técnicas do [[Sysvar]].

Ele deve ser utilizado para localizar rapidamente:

- apps;
- models;
- services;
- serializers;
- views;
- rotas;
- migrations;
- commands;
- components;
- guards;
- interceptors;
- testes;
- infraestrutura transversal;
- documentação técnica específica de cada domínio.

Este arquivo não substitui a leitura do código atual.

Antes de qualquer alteração:

1. localizar o arquivo;
2. abrir o conteúdo atual;
3. verificar consumidores;
4. verificar testes;
5. verificar migrations;
6. verificar impacto no frontend;
7. verificar impacto na Auditoria;
8. verificar isolamento multiempresa;
9. verificar permissões;
10. verificar a documentação relacionada.

---

# Situação Técnica Atual

## Grupo Operacional

Status:

~~~text
IMPLEMENTADO
TESTADO AUTOMATICAMENTE
HOMOLOGADO MANUALMENTE
DOCUMENTADO
APROVADO
~~~

Foram concluídos:

- Empresas;
- Contratos;
- Suspensão;
- Reativação;
- Estabelecimentos;
- Usuários;
- Perfis;
- Permissões;
- Overrides;
- Sessões;
- Tokens;
- Licenciamento simultâneo;
- Administração de Sessões;
- Diagnóstico de Sessões;
- Reconciliação de Sessões;
- Redefinição administrativa de senha;
- Troca obrigatória de senha;
- Auditoria Central.

Documentação principal:

- [[10 Projetos/Sysvar/Homologações/Homologação - Operacional|Homologação - Operacional]]
- [[10 Projetos/Sysvar/Decisões Técnicas/ADR-001 - Licenciamento por Sessões Simultâneas|ADR-001 - Licenciamento por Sessões Simultâneas]]
- [[10 Projetos/Sysvar/Decisões Técnicas/ADR-002 - Princípios Arquiteturais do SISVAR|ADR-002 - Princípios Arquiteturais do SISVAR]]
- [[10 Projetos/Sysvar/Decisões Técnicas/ADR-003 - Auditoria Central do SISVAR|ADR-003 - Auditoria Central do SISVAR]]

---

## Grupo Cadastros

Status do escopo revisado:

~~~text
IMPLEMENTADO
TESTADO
HOMOLOGADO MANUALMENTE
DOCUMENTADO
APROVADO
~~~

Cadastros fechados:

1. Clientes;
2. Fornecedores;
3. Funcionários.

### Clientes

Status:

~~~text
CONCLUÍDO
HOMOLOGADO 23/23
DOCUMENTADO
~~~

Documentação:

- [[Mapa Técnico - Cadastros - Clientes]]
- [[Workflows - Cadastros - Clientes]]
- [[Modelo de Domínio - Cadastros - Clientes]]
- [[Riscos e Cuidados - Cadastros - Clientes]]

### Fornecedores

Status:

~~~text
CONCLUÍDO
HOMOLOGADO 30/30
DOCUMENTADO
~~~

Integrações principais:

- Compras;
- Financeiro;
- Fiscal;
- Auditoria;
- multiempresa.

### Funcionários

Status:

~~~text
CONCLUÍDO
HOMOLOGADO 17/17
DOCUMENTADO
~~~

Documentação:

- [[Homologação - Cadastros - Funcionários]]
- [[Mapa Técnico - Cadastros - Funcionários]]
- [[Workflows - Cadastros - Funcionários]]
- [[Modelo de Domínio - Cadastros - Funcionários]]
- [[Riscos e Cuidados - Cadastros - Funcionários]]

---

# Grupo Produtos

Status do ciclo cadastral atual:

~~~text
CONCLUÍDO
HOMOLOGADO
DOCUMENTADO
APROVADO
~~~

Domínios consolidados:

~~~text
PRODUTO VENDA
→ tipos 1 e 3

PRODUTO USO/CONSUMO
→ tipo 2

INSUMOS
→ tipo 4

CADASTROS AUXILIARES
→ estruturas de apoio
~~~

A separação entre esses domínios é obrigatória.

---

# Tipos de Produto

Estrutura conceitual:

~~~text
Produto
   │
   ├── tipo 1 → Revenda
   ├── tipo 2 → Uso/Consumo
   ├── tipo 3 → Fabricação Própria
   └── tipo 4 → Insumo
~~~

Compartilhar o model principal não significa compartilhar todas as regras.

---

# Produto Venda

Status:

~~~text
IMPLEMENTADO
TESTADO
HOMOLOGADO MANUALMENTE
DOCUMENTADO
APROVADO

19/19 ITENS APROVADOS
~~~

Tipos:

~~~text
1 = Revenda
3 = Fabricação Própria
~~~

Produto Venda representa os Produtos destinados à comercialização.

Abrange:

- Produto;
- classificação;
- Referência;
- Grade;
- Cores;
- SKUs;
- EAN;
- Lojas;
- Estoque Loja × SKU;
- custos;
- preços;
- Dados Fiscais;
- imagens;
- Histórico Funcional;
- Auditoria;
- lifecycle;
- Bloqueio de Venda;
- exclusão protegida;
- filtros;
- paginação;
- consulta consolidada;
- integração com Compras;
- integração com Produção.

Documentação:

- [[Homologação - Produtos - Produto Venda]]
- [[Mapa Técnico - Produtos - Produto Venda]]
- [[Workflows - Produtos - Produto Venda]]
- [[Modelo de Domínio - Produtos - Produto Venda]]
- [[Riscos e Cuidados - Produtos - Produto Venda]]

---

# Produto Uso/Consumo

Status:

~~~text
IMPLEMENTADO
HOMOLOGADO
DOCUMENTADO
APROVADO
~~~

Tipo:

~~~text
tipo_produto = '2'
~~~

Produto Uso/Consumo representa itens destinados ao uso interno não produtivo.

Características técnicas consolidadas:

- domínio próprio;
- Empresa;
- código;
- descrição;
- descrição reduzida quando aplicável;
- Unidade;
- NCM opcional;
- Dados Fiscais;
- Fiscal Completo/Incompleto;
- custos;
- natureza de Estoque;
- lifecycle Ativo/Inativo;
- exclusão protegida;
- consulta;
- edição;
- filtros server-side;
- paginação server-side;
- Auditoria;
- multiempresa.

Não utiliza automaticamente:

- Grade;
- Tamanho comercial;
- Cor × Tamanho;
- SKU comercial;
- Coleção;
- Tabela de Preço;
- Promoção;
- Bloqueio de Venda.

Não pertence normalmente ao PDV.

Não participa de Ficha Técnica como Insumo.

Documentação:

- [[Homologação - Produtos - Produto Uso e Consumo]]
- [[Mapa Técnico - Produtos - Produto Uso e Consumo]]
- [[Workflows - Produtos - Produto Uso e Consumo]]
- [[Modelo de Domínio - Produtos - Produto Uso e Consumo]]
- [[Riscos e Cuidados - Produtos - Produto Uso e Consumo]]

---

# Insumos

Status:

~~~text
IMPLEMENTADO
HOMOLOGADO
DOCUMENTADO
APROVADO
~~~

Tipo:

~~~text
tipo_produto = '4'
~~~

Insumos representam materiais utilizados na fabricação.

Características consolidadas:

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
- integração com Compras;
- participação em Ficha Técnica;
- preparação para Produção;
- multiempresa.

Insumo não é Produto Uso/Consumo.

Insumo não é Produto Venda.

Documentação:

- [[Homologação - Produtos - Insumos]]
- [[Mapa Técnico - Produtos - Insumos]]
- [[Workflows - Produtos - Insumos]]
- [[Modelo de Domínio - Produtos - Insumos]]
- [[Riscos e Cuidados - Produtos - Insumos]]

---

# Cadastros Auxiliares de Produtos

Status:

~~~text
IMPLEMENTADOS
HOMOLOGADOS
DOCUMENTADOS
APROVADOS
~~~

Estruturas consolidadas:

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

Documentação:

- [[Homologação - Produtos - Cadastros Auxiliares]]
- [[Mapa Técnico - Produtos - Cadastros Auxiliares]]
- [[Workflows - Produtos - Cadastros Auxiliares]]
- [[Modelo de Domínio - Produtos - Cadastros Auxiliares]]
- [[Riscos e Cuidados - Produtos - Cadastros Auxiliares]]

---

# Estrutura Local

Projeto:

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

Vault Obsidian:

~~~text
C:\takeshi\takeshi
~~~

Documentação no projeto:

~~~text
C:\SysvarProjeto\docs
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

Hashes de commits não devem ser referência permanente neste mapa central.

Para consultar commits atuais:

~~~powershell
cd C:\SysvarProjeto\Backend
git log -5 --oneline

cd C:\SysvarProjeto\Frontend\sysvar
git log -5 --oneline

cd C:\takeshi\takeshi
git log -5 --oneline
~~~

---

# Tecnologias

## Backend

- Python;
- Django;
- Django REST Framework;
- MySQL.

## Frontend

- Angular 17 Standalone;
- TypeScript.

## Versionamento

- Git;
- GitHub.

## Infraestrutura

- Ubuntu;
- Docker;
- Nginx;
- serviços auxiliares conforme ambiente.

## Documentação

- Obsidian;
- Markdown;
- Git;
- GitHub.

---

# Entrypoints

## Backend

~~~text
Backend\manage.py
Backend\Varejo\settings.py
Backend\Varejo\urls.py
Backend\requirements.txt
~~~

## Frontend

~~~text
Frontend\sysvar\package.json
Frontend\sysvar\angular.json
Frontend\sysvar\src\app
Frontend\sysvar\src\app\app.routes.ts
Frontend\sysvar\src\app\layout\shell
~~~

---

# Grupo Operacional — Estrutura

Menu conceitual:

~~~text
Operacional
├── Empresas
├── Estabelecimento
├── Usuários
├── Perfis de acesso
└── Auditoria
~~~

Apps principais:

~~~text
accounts
cadastros
auditoria
~~~

Features frontend principais:

~~~text
features\empresas
features\lojas
features\usuarios
features\perfis-acesso
features\auditoria
features\change-password-required
~~~

---

# Backend — Accounts

Caminho:

~~~text
Backend\accounts
~~~

Responsabilidades:

- usuários;
- autenticação;
- perfis;
- permissões;
- overrides;
- sessões;
- tokens;
- licenciamento;
- heartbeat;
- troca de senha;
- transferência de master;
- acesso efetivo;
- administração de sessões.

Arquivos principais:

~~~text
Backend\accounts\models.py
Backend\accounts\serializers.py
Backend\accounts\views.py
Backend\accounts\permissions.py
Backend\accounts\authentication.py
Backend\accounts\urls.py
Backend\accounts\apps.py
Backend\accounts\tests.py
~~~

Services:

~~~text
Backend\accounts\services\effective_access.py
Backend\accounts\services\sessions.py
~~~

Commands:

~~~text
Backend\accounts\management\commands
~~~

---

# Accounts — Models

Entidades principais:

~~~text
User
PerfilAcesso
PerfilModuloPermissao
UserModulePermission
SessaoUsuario
SessionToken
~~~

## User

Responsabilidades relevantes:

- Empresa;
- Perfil principal;
- tipo funcional;
- Estabelecimento principal;
- Estabelecimentos permitidos;
- Permissões individuais;
- permissões de campo;
- situação ativa;
- `deve_trocar_senha`.

## PerfilAcesso

Responsável por:

- Perfil da Empresa;
- nome;
- descrição;
- situação;
- Perfil padrão;
- Usuários vinculados.

## PerfilModuloPermissao

Relaciona:

~~~text
Perfil
→ ModuloSistema
→ NONE, VIEW ou EDIT
~~~

## UserModulePermission

Representa override individual.

No frontend:

~~~text
HERDAR
=
ausência de override específico
~~~

## SessaoUsuario

Responsável por:

- Empresa;
- Usuário;
- Estabelecimento;
- dispositivo;
- início;
- última atividade;
- encerramento;
- motivo;
- situação ativa.

## SessionToken

Responsável pelo token vinculado à sessão.

Token bruto não deve ser persistido.

---

# Accounts — Authentication

Componente principal:

`CompanyTokenAuthentication`

Responsável por validar:

- autenticação;
- token;
- sessão;
- expiração;
- Usuário;
- Empresa;
- contrato;
- suspensão;
- troca obrigatória de senha.

Código de troca obrigatória:

~~~text
PASSWORD_CHANGE_REQUIRED
~~~

---

# Accounts — Effective Access

Serviço:

`EffectiveAccessService`

Arquivo:

~~~text
Backend\accounts\services\effective_access.py
~~~

Responsável por:

- Empresa;
- contrato;
- módulos;
- Perfil;
- overrides;
- master;
- superusuário;
- Permissões efetivas;
- contexto utilizado pelo frontend.

A permissão final não deve ser recalculada independentemente no navegador.

Exemplo:

~~~text
EffectiveAccessService(user)
    .has_module_access("produtos", EDIT)
~~~

---

# Accounts — Sessions

Serviço:

`ConcurrentSessionService`

Arquivo:

~~~text
Backend\accounts\services\sessions.py
~~~

Responsabilidades:

- criar sessão;
- validar token;
- controlar limite simultâneo;
- substituir sessão apropriada;
- encerrar sessão;
- revogar token;
- fechar expiradas;
- heartbeat;
- liberar licença;
- listar sessões válidas;
- centralizar contagem.

Não criar contagem paralela baseada somente em:

~~~text
SessaoUsuario.objects.filter(ativa=True)
~~~

---

# Regra Central de Sessão Válida

A mesma regra deve alimentar:

- login;
- limite;
- contador;
- quantidade disponível;
- heartbeat;
- listagem;
- encerramento;
- diagnóstico;
- reconciliação.

---

# Login e Limite Simultâneo

Fluxo conceitual:

~~~text
transaction.atomic
→ validação do Usuário
→ validação do contrato
→ encerramento de expiradas
→ substituição válida
→ bloqueio do contrato
→ contagem central
→ verificação do limite
→ criação da sessão
→ criação do token
→ commit
~~~

Código:

~~~text
CONCURRENT_SESSION_LIMIT_REACHED
~~~

---

# Logout

Ordem:

~~~text
frontend mantém token
→ chama backend
→ backend identifica sessão
→ encerra sessão
→ revoga token
→ libera licença
→ registra Auditoria
→ frontend limpa contexto
→ interrompe heartbeat
→ redireciona
~~~

Não limpar o token antes da chamada ao backend.

---

# Superusuário e Licenciamento

Superusuário:

- possui sessão própria;
- não consome licença da Empresa cliente;
- não entra no contador da Empresa;
- não deve aparecer como sessão consumindo licença de cliente.

---

# Diagnóstico e Reconciliação de Sessões

Commands:

~~~text
diagnosticar_sessoes_empresa
reconciliar_sessoes_ativas
~~~

Reconciliação deve:

- preservar histórico;
- encerrar inválidas;
- revogar tokens;
- não apagar registros.

---

# Accounts — Permissions

Regra geral:

~~~text
GET, HEAD, OPTIONS
→ VIEW

POST, PUT, PATCH, DELETE
→ EDIT
~~~

O sistema utiliza Permissões funcionais por módulo.

Não depender exclusivamente de cargos ou roles antigas.

---

# Backend — Cadastros

Caminho:

~~~text
Backend\cadastros
~~~

Responsabilidades:

- Empresas;
- contratos;
- módulos;
- Estabelecimentos;
- Clientes;
- Fornecedores;
- Funcionários;
- Naturezas;
- planos;
- Formas de Pagamento;
- cadastros auxiliares gerais.

Arquivos principais:

~~~text
Backend\cadastros\models.py
Backend\cadastros\serializers.py
Backend\cadastros\views.py
Backend\cadastros\urls.py
Backend\cadastros\tests.py
~~~

---

# Cadastros — Empresas e Contratos

Entidades relevantes:

~~~text
Empresa
EmpresaContrato
ModuloSistema
EmpresaModulo
Loja
~~~

O contrato controla:

- status;
- vigência;
- módulos;
- master;
- limite de sessões;
- versão de permissões;
- suspensão;
- reativação.

---

# Cadastros — Estabelecimentos

Model:

`Loja`

Tipos existentes:

~~~text
LOJA
MATRIZ
FABRICA
~~~

Loja pertence obrigatoriamente a uma Empresa.

A estrutura é utilizada por vários domínios.

---

# Cadastros — Clientes

Cadastro concluído e homologado.

Principais responsabilidades:

- PF/PJ;
- documento funcional;
- Cliente sem documento;
- Consumidor Final;
- indicadores;
- ciclo de vida;
- Compras;
- Histórico;
- integração com PDV;
- isolamento multiempresa.

Mapa específico:

[[Mapa Técnico - Cadastros - Clientes]]

---

# Cadastros — Fornecedores

Cadastro concluído e homologado.

Principais responsabilidades:

- identificação;
- documentos;
- contatos;
- endereços;
- informações fiscais;
- informações financeiras;
- ciclo de vida;
- Compras;
- Financeiro;
- isolamento multiempresa.

---

# Cadastros — Funcionários

Cadastro concluído e homologado.

Integrações:

- Cargo;
- Loja Principal;
- Lojas supervisionadas;
- Usuário;
- comissão;
- vendas;
- Histórico;
- Auditoria.

---

# Backend — Produto

Caminho principal:

~~~text
Backend\produto
~~~

Responsabilidades gerais:

- Produto Venda;
- Produto Uso/Consumo;
- Insumos;
- ProdutoDetalhe;
- SKU;
- EAN;
- Grade;
- Tamanho;
- Cor;
- Coleção;
- Grupo;
- Subgrupo;
- Unidade;
- Material;
- Pack;
- NCM;
- Dados Fiscais;
- preços;
- Estoque relacionado;
- imagens;
- Histórico Funcional quando aplicável.

Arquivos centrais da estrutura:

~~~text
Backend\produto\models.py
Backend\produto\serializers.py
Backend\produto\views.py
Backend\produto\urls.py
Backend\produto\permissions.py
Backend\produto\tests.py
~~~

Sempre confirmar o código atual no repositório antes de editar.

Mapas específicos:

- [[Mapa Técnico - Produtos - Produto Venda]]
- [[Mapa Técnico - Produtos - Produto Uso e Consumo]]
- [[Mapa Técnico - Produtos - Insumos]]
- [[Mapa Técnico - Produtos - Cadastros Auxiliares]]

---

# Produto — Entidade Principal

A entidade `Produto` é compartilhada por domínios distintos.

~~~text
Produto
   ├── tipo 1 → Revenda
   ├── tipo 2 → Uso/Consumo
   ├── tipo 3 → Fabricação Própria
   └── tipo 4 → Insumo
~~~

Regras específicas devem ser condicionadas ao domínio correto.

Não transformar regra de um tipo em regra global sem análise.

---

# ProdutoDetalhe

`ProdutoDetalhe` representa principalmente a variação comercial/SKU do Produto Venda.

Identidade lógica:

~~~text
Produto + Cor + Tamanho
~~~

Responsabilidades:

- variação;
- EAN;
- status;
- custos relacionados;
- relacionamento operacional com Estoque.

Produto Uso/Consumo e Insumos não devem receber geração comercial automática de `ProdutoDetalhe` apenas por compartilharem o model Produto.

---

# Produto Venda — Referência

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

Referência pertence ao Produto.

EAN pertence ao SKU.

---

# Produto Venda — Grade

Grade é obrigatória para Produto Venda no domínio homologado.

Após geração de SKUs:

~~~text
GRADE IMUTÁVEL
~~~

A proteção deve existir no backend.

---

# Produto Venda — Cores e SKUs

Fluxo:

~~~text
Produto
   ↓
Grade
   ↓
Cores
   ↓
Cor × Tamanho
   ↓
ProdutoDetalhe / SKU
~~~

Adicionar Cor:

- cria SKU inexistente;
- reativa SKU anterior quando aplicável.

Remover Cor:

- inativa SKU;
- não exclui.

Reintroduzir Cor:

- reativa SKU;
- preserva EAN;
- preserva identidade.

---

# Produto Venda — EAN

Princípios:

- geração no backend;
- unicidade;
- sequência protegida;
- preservação;
- não reciclagem;
- reativação mantém EAN.

---

# Produto Venda — Estoque

Granularidade:

~~~text
Loja × SKU
~~~

Inicialização em zero não significa entrada física.

Conceito:

~~~text
Disponível = Físico - Reserva
~~~

Movimentações pertencem ao módulo Estoque.

---

# Produto Venda — Custos

Revenda:

~~~text
Compra
→ Recebimento
→ Estoque
→ Custos
~~~

Fabricação Própria:

~~~text
Ficha Técnica
→ Ordem de Produção
→ Produção
→ Custos
~~~

---

# Produto Venda — Dados Fiscais

Estrutura pode contemplar:

- NCM;
- Origem;
- CST/CSOSN ICMS;
- alíquota ICMS;
- CFOP;
- PIS;
- COFINS;
- IPI.

Alterações relevantes devem ser rastreadas.

---

# ProdutoVendaHistorico

Responsabilidade:

registrar eventos funcionais relevantes de Produto Venda.

Exemplos:

- alteração cadastral;
- alteração fiscal;
- Ativação;
- Inativação;
- Bloqueio de Venda;
- Desbloqueio.

Não substitui `AuditLog`.

---

# ProdutoImagem

Regras:

~~~text
0..3 imagens
~~~

- opcionais;
- no máximo três;
- somente uma principal;
- pertencem ao Produto;
- não pertencem à Cor;
- não pertencem ao SKU.

A interface pode priorizar:

~~~text
imagem_reduzida_url
~~~

com fallback:

~~~text
imagem_url
~~~

Parâmetros técnicos da miniatura ainda não devem ser inventados sem decisão específica.

---

# Produto Venda — Ciclo de Vida

Situação:

~~~text
ATIVO
  ↕
INATIVO
~~~

Estado comercial independente:

~~~text
LIBERADO
  ↕
BLOQUEADO
~~~

Portanto:

~~~text
Ativo != Venda liberada
~~~

---

# Produto Venda — Permissões

Ações sensíveis utilizam o modelo funcional de acesso.

Conceito:

~~~text
Produtos + EDIT
~~~

Não depender apenas de `is_staff`.

Quando a ação exige motivo e senha, esses requisitos permanecem independentes da permissão.

---

# Produto Uso/Consumo — Estrutura Técnica

Tipo:

~~~text
2
~~~

Regras centrais:

- somente tipo 2;
- Empresa obrigatória;
- código próprio;
- Unidade;
- Fiscal;
- lifecycle Ativo/Inativo;
- exclusão protegida;
- sem estrutura comercial de Grade/Cor/SKU;
- sem localização fixa de Estoque;
- sem campo `controla_estoque`.

Separação:

~~~text
Produto Uso/Consumo
!=
Produto Venda

Produto Uso/Consumo
!=
Insumo
~~~

Mapa específico:

[[Mapa Técnico - Produtos - Produto Uso e Consumo]]

---

# Produto Uso/Consumo — Estoque

Produto possui natureza de Estoque.

O cadastro não define:

- Matriz;
- Loja;
- depósito;
- local fixo.

A operação define a localização.

~~~text
Produto
!=
Local de Estoque
~~~

Saldo deve ser derivado dos movimentos.

---

# Produto Uso/Consumo — Fiscal

NCM pode permanecer opcional no cadastro quando essa é a regra do domínio.

Situação:

~~~text
Fiscal Completo
Fiscal Incompleto
~~~

Fiscal Incompleto não significa Produto inválido.

A operação fiscal deve exigir os dados necessários ao evento real.

---

# Produto Uso/Consumo — Integrações

Pode integrar com:

- Compras;
- Recebimento;
- Estoque;
- Fiscal;
- custos;
- Auditoria.

Não deve integrar automaticamente com:

- PDV;
- Promoções;
- Tabela de Preço comercial;
- Ficha Técnica;
- Ordem de Produção como componente.

---

# Insumos — Estrutura Técnica

Tipo:

~~~text
4
~~~

Responsabilidades:

- identidade do material;
- Empresa;
- descrição;
- Unidade;
- Material opcional;
- Fiscal;
- custos;
- lifecycle;
- integração com Compras;
- integração com Estoque;
- participação em Ficha Técnica.

Mapa específico:

[[Mapa Técnico - Produtos - Insumos]]

---

# Insumos — Unidade

Unidade é especialmente relevante para quantidades produtivas.

Exemplos:

~~~text
Tecido → M
Botão → UN
Linha → M
~~~

A propriedade:

~~~text
permite_decimal
~~~

deve ser respeitada pelos processos consumidores.

---

# Insumos — Material

Material é opcional.

~~~text
Material
→ classificação

Insumo
→ item operacional
~~~

Não movimentar Material como se fosse Insumo.

---

# Insumos — Estoque

O cadastro não possui localização fixa.

Não fixar:

- Matriz;
- fábrica;
- almoxarifado;
- Loja;
- facção.

A operação determina onde o material está.

Não criar campo:

~~~text
controla_estoque
~~~

---

# Insumos — Ficha Técnica

Relacionamento conceitual:

~~~text
Produto Fabricação Própria
        ↓
Ficha Técnica
        ↓
Item da Ficha
        ↓
Insumo + Quantidade
~~~

A quantidade pertence ao relacionamento.

Não pertence ao cadastro principal do Insumo.

---

# Insumos — Ordem de Produção

A existência de uma Ficha Técnica não autoriza presumir baixa física.

Não assumir:

~~~text
Criar OP
=
Baixar Insumo
~~~

Nem:

~~~text
Criar OP
=
Reservar automaticamente Insumo
~~~

Reserva, separação, consumo, perda e sobra pertencem ao processo de Produção/Estoque.

---

# Cadastros Auxiliares — Grupo e Subgrupo

Grupo possui:

- Código;
- Descrição;
- Código de Referência;
- Margem.

Código de Referência:

~~~text
2 dígitos numéricos
~~~

Único por Empresa.

Subgrupo:

~~~text
Grupo 1:N Subgrupo
~~~

Não existe sem o Grupo pai.

---

# Cadastros Auxiliares — Grade e Tamanho

Relacionamento:

~~~text
Grade 1:N Tamanho
~~~

Grade fornece Tamanhos para Produto Venda.

Alterações em Grade utilizada devem considerar:

- Produtos;
- SKUs;
- Packs;
- histórico.

---

# Cadastros Auxiliares — Coleção

Campos:

- Código;
- Estação;
- Descrição;
- Status.

Estação:

~~~text
01
02
03
04
~~~

Status:

~~~text
CR
PD
AT
EN
AR
~~~

Contador da geração de Referência permanece interno.

---

# Cadastros Auxiliares — Unidade

Campos:

- Código;
- Descrição;
- `permite_decimal`.

Unidade define como quantificar.

Não armazena saldo nem quantidade operacional.

---

# Cadastros Auxiliares — Cor

Cor é principalmente utilizada por Produto Venda.

~~~text
Produto + Cor + Tamanho = SKU
~~~

Cor isoladamente não é SKU.

---

# Cadastros Auxiliares — Material

Campos:

- Código;
- Descrição;
- Ativo/Inativo.

Material é classificação.

Não substitui Insumo.

---

# Cadastros Auxiliares — Pack

Pack pertence a uma Grade.

Possui:

- Nome;
- Grade;
- Ativo/Inativo;
- Itens.

Item:

~~~text
Pack
+
Tamanho
+
Quantidade
~~~

Invariantes:

~~~text
Tamanho pertence à Grade do Pack

Tamanho não repete no mesmo Pack

Quantidade > 0
~~~

---

# Cadastros Auxiliares — Master-Detail

Principais estruturas:

~~~text
Grupo
→ Subgrupos

Grade
→ Tamanhos

Pack
→ Itens
~~~

O detalhe utiliza contexto do mestre selecionado.

---

# Cadastros Auxiliares — Padrão Visual

Padrão consolidado:

~~~text
Checkbox
+
Seleção única
+
Linha destacada
+
Barra de ações
~~~

Nas telas modernizadas não utilizar simultaneamente:

~~~text
Barra de ações
+
Coluna Ações
+
Menu ⋮
~~~

---

# Backend — Auditoria

Caminho:

~~~text
Backend\auditoria
~~~

Arquivos centrais:

~~~text
Backend\auditoria\models.py
Backend\auditoria\services.py
Backend\auditoria\middleware.py
Backend\auditoria\signals.py
Backend\auditoria\views.py
Backend\auditoria\serializers.py
Backend\auditoria\urls.py
Backend\auditoria\display.py
Backend\auditoria\tests.py
~~~

Componentes:

~~~text
AuditLog
AuditService
AuditContextMiddleware
AuditAction
AuditCategory
AuditResult
AuditSeverity
AuditOrigin
~~~

---

# Auditoria — Princípio Geral

Operações críticas devem utilizar Auditoria Central.

Quando Auditoria for obrigatória:

~~~text
transaction.atomic
→ alteração
→ AuditService.required_success
→ commit
~~~

Falha da Auditoria obrigatória deve impedir commit quando essa for a regra do processo.

---

# Histórico Funcional versus Auditoria

Históricos funcionais específicos e Auditoria Central não são sinônimos.

Exemplo de Produto Venda:

~~~text
ProdutoVendaHistorico
→ histórico funcional

AuditLog
→ Auditoria Central
~~~

Não eliminar automaticamente uma estrutura em favor da outra.

---

# Frontend — Estrutura Central

Caminho:

~~~text
Frontend\sysvar\src\app
~~~

Arquivos centrais:

~~~text
src\app\app.routes.ts
src\app\layout\shell\shell.component.ts
src\app\core\auth.service.ts
src\app\core\permission.service.ts
src\app\core\services\access-control.service.ts
~~~

Confirmar caminhos atuais antes de alterações.

---

# Frontend — Auth Service

Responsabilidades:

- login;
- logout;
- token;
- contexto do Usuário;
- sessão;
- heartbeat;
- troca obrigatória de senha;
- limpeza de contexto;
- comunicação entre abas.

No logout:

1. chamar backend;
2. aguardar resposta;
3. interromper heartbeat;
4. limpar contexto;
5. redirecionar.

---

# Frontend — Shell

Responsabilidades:

- menu lateral;
- ações globais;
- logout;
- exibição por Permissão;
- grupos funcionais.

Estrutura de Produtos deve apresentar claramente os domínios:

~~~text
Cadastro de Produtos
├── Produto Venda
├── Produto Uso/Consumo
└── Insumos
~~~

Além dos Cadastros Auxiliares correspondentes.

---

# Frontend — Produto Venda

Responsabilidades:

- listagem;
- filtros;
- paginação;
- cadastro;
- edição;
- consulta;
- Cores;
- Lojas;
- SKUs;
- Fiscal;
- imagens;
- Histórico;
- Estoque;
- ações de lifecycle.

Mapa específico:

[[Mapa Técnico - Produtos - Produto Venda]]

---

# Frontend — Produto Uso/Consumo

Responsabilidades:

- listagem;
- filtros;
- paginação;
- novo;
- consulta;
- edição;
- lifecycle;
- Fiscal;
- custos;
- integração cadastral.

Mapa específico:

[[Mapa Técnico - Produtos - Produto Uso e Consumo]]

---

# Frontend — Insumos

Responsabilidades:

- listagem;
- filtros;
- paginação;
- novo;
- consulta;
- edição;
- lifecycle;
- Unidade;
- Material opcional;
- Fiscal;
- custos.

Mapa específico:

[[Mapa Técnico - Produtos - Insumos]]

---

# Frontend — Cadastros Auxiliares

Responsabilidades:

- listagem;
- filtros;
- paginação;
- seleção;
- criação;
- consulta;
- edição;
- exclusão;
- lifecycle quando aplicável;
- master-detail.

Mapa específico:

[[Mapa Técnico - Produtos - Cadastros Auxiliares]]

---

# Integração — Produtos e Compras

Produto Venda, Produto Uso/Consumo e Insumos podem possuir relações distintas com Compras.

Compras permanece responsável por:

- Fornecedor;
- Pedido;
- itens;
- quantidades;
- preços;
- aprovação;
- recebimento;
- parcelas;
- integração financeira.

Produtos fornecem a identidade dos itens.

---

# Integração — Produtos e Estoque

Separação:

~~~text
Produto
→ identidade

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

Não criar localização fixa no cadastro apenas para simplificar Estoque.

---

# Integração — Produtos e Fiscal

Produto mantém dados fiscais cadastrais.

Fiscal permanece responsável por:

- aplicação tributária;
- documentos;
- validação operacional;
- NFe;
- NFC-e;
- Entrada Fiscal.

---

# Integração — Produtos e Produção

Fluxo principal:

~~~text
Produto Venda
tipo 3
        ↓
Ficha Técnica
        ↓
Insumos
tipo 4
        ↓
Ordem de Produção
        ↓
Produção
~~~

Produto Uso/Consumo tipo 2 não deve ser utilizado automaticamente como componente produtivo.

---

# Integração — Produtos e PDV

PDV utiliza Produto Venda/SKU.

Condições comerciais pertencem ao domínio Vendas/PDV.

Produto Uso/Consumo e Insumos não devem aparecer como Produtos normais de venda.

---

# Integração — Packs e Compras

Pack fornece uma composição de Tamanhos.

~~~text
Número de Packs
×
Soma dos Itens do Pack
=
Quantidade total de peças
~~~

O Pedido deve preservar a quantidade histórica da operação.

Alterações futuras do Pack não devem recalcular Pedido antigo.

---

# Multiempresa

Princípio transversal:

~~~text
Empresa
=
limite de dados
~~~

O backend deve validar:

- Produto;
- Grupo;
- Subgrupo;
- Grade;
- Coleção;
- Unidade;
- Cor;
- Material;
- Pack;
- Loja;
- Ficha Técnica;
- demais relacionamentos empresariais.

Não confiar apenas em filtros do frontend.

---

# Paginação

Listagens relevantes utilizam processamento server-side.

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

Não carregar bases completas apenas para paginação local.

---

# Filtros

Filtros devem ser aplicados no backend.

A listagem deve considerar:

- Empresa;
- domínio/tipo;
- filtros específicos;
- ordenação;
- paginação.

Não filtrar apenas a página visível no frontend.

---

# Exclusão Protegida

Princípio geral:

~~~text
Registro sem utilização
→ exclusão pode ser possível

Registro utilizado
→ preservar
→ inativar quando aplicável
~~~

Aplicável a:

- Produtos;
- Grupos;
- Subgrupos;
- Grades;
- Tamanhos;
- Coleções;
- Unidades;
- Cores;
- Material;
- Packs;
- outros cadastros com dependências.

---

# Princípio de Integridade Histórica

Não reinterpretar registros passados após alterações cadastrais.

Exemplos:

~~~text
Grupo mudou CodigoRef
→ não regenerar Referência histórica

Pack mudou composição
→ não recalcular Pedido antigo

Unidade alterada
→ não mudar significado de movimento antigo

Cor inativada
→ não apagar SKU histórico
~~~

---

# Testes

Correção localizada:

- testes específicos;
- validação necessária;
- homologação manual.

Checkpoint relevante:

- suíte mais ampla;
- build;
- regressão.

Fechamento:

- testes relevantes;
- homologação;
- documentação.

---

# Regra de Investigação

Antes de modificar código:

~~~text
LOCALIZAR
        ↓
LER
        ↓
IDENTIFICAR CONSUMIDORES
        ↓
ENTENDER REGRA
        ↓
DEFINIR IMPACTO
        ↓
ALTERAR
        ↓
TESTAR
        ↓
HOMOLOGAR
~~~

Não presumir estrutura técnica apenas pela nomenclatura funcional.

---

# Regra de Separação de Responsabilidades

~~~text
CADASTRO
define identidade e parâmetros.

COMPRAS
define aquisição.

ESTOQUE
define quantidade e localização.

FISCAL
define aplicação tributária operacional.

PRODUÇÃO
define transformação e consumo produtivo.

PDV
define venda.

AUDITORIA
define rastreabilidade transversal.
~~~

---

# Estado Técnico Consolidado

~~~text
OPERACIONAL
→ CONCLUÍDO
→ HOMOLOGADO
→ DOCUMENTADO

CADASTROS > CLIENTES
→ CONCLUÍDO
→ 23/23
→ DOCUMENTADO

CADASTROS > FORNECEDORES
→ CONCLUÍDO
→ 30/30
→ DOCUMENTADO

CADASTROS > FUNCIONÁRIOS
→ CONCLUÍDO
→ 17/17
→ DOCUMENTADO

PRODUTOS > PRODUTO VENDA
→ CONCLUÍDO
→ 19/19
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

# Documentação de Produtos

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

## Cadastros Auxiliares

- [[Homologação - Produtos - Cadastros Auxiliares]]
- [[Mapa Técnico - Produtos - Cadastros Auxiliares]]
- [[Workflows - Produtos - Cadastros Auxiliares]]
- [[Modelo de Domínio - Produtos - Cadastros Auxiliares]]
- [[Riscos e Cuidados - Produtos - Cadastros Auxiliares]]

---

# Estado do Mapa Técnico em 14/08/2026

O Mapa Técnico central reconhece como domínios de Produtos concluídos:

~~~text
PRODUTO VENDA
PRODUTO USO/CONSUMO
INSUMOS
CADASTROS AUXILIARES DE PRODUTOS
~~~

Esses domínios possuem documentação específica própria.

O mapa central deve continuar funcionando como índice técnico e ponto de ligação entre:

~~~text
[[Sysvar]]
        ↓
[[Mapa Técnico]]
        ↓
Documentação específica de cada domínio
        ↓
Código atual
~~~

Nenhum caminho técnico deste documento deve ser usado como substituto da conferência do repositório antes de uma alteração.