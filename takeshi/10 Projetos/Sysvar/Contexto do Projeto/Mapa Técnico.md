---
type: reference
status: active
project: Sysvar
source: "C:/SysvarProjeto"
created: 2026-08-03
updated: 2026-08-13
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
  - sku
  - estoque
  - produção
  - auditoria
  - sessões
  - licenciamento
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
- Administração de sessões;
- Diagnóstico de sessões;
- Reconciliação de sessões;
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
TESTADO AUTOMATICAMENTE
HOMOLOGADO MANUALMENTE
DOCUMENTADO
APROVADO
~~~

Cadastros fechados individualmente:

1. Clientes;
2. Fornecedores;
3. Funcionários.

Outros cadastros auxiliares permanecem no sistema e poderão receber revisão específica quando seus respectivos processos forem trabalhados.

### Clientes

Status:

~~~text
CONCLUÍDO
HOMOLOGADO
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
HOMOLOGADO
DOCUMENTADO
~~~

Documentação específica do domínio deve permanecer vinculada ao projeto e aos processos de Compras e Financeiro.

### Funcionários

Status:

~~~text
CONCLUÍDO
HOMOLOGADO
DOCUMENTADO
17/17 ITENS APROVADOS
~~~

Documentação:

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

Primeiro domínio consolidado:

**Produto Venda**

Produto Venda contempla:

~~~text
Produto Venda
├── Revenda
└── Fabricação Própria
~~~

Códigos internos:

~~~text
1 = Revenda
3 = Fabricação Própria
~~~

Produto Uso e Consumo não faz parte do fechamento atual de Produto Venda.

---

# Produto Venda

Status:

~~~text
IMPLEMENTADO
TESTADO AUTOMATICAMENTE
HOMOLOGADO MANUALMENTE
DOCUMENTADO
APROVADO
~~~

Homologação manual:

~~~text
19/19 itens aprovados
~~~

Produto Venda é o cadastro estrutural dos produtos comercializáveis do [[Sysvar]].

Abrange:

- Produto;
- classificação;
- Referência;
- Grade;
- Cores;
- SKUs;
- EAN;
- Lojas;
- Estoque por Loja × SKU;
- custos;
- preços relacionados;
- Dados fiscais;
- imagens;
- Histórico Funcional;
- Auditoria Central;
- ativação/inativação;
- bloqueio/desbloqueio de venda;
- exclusão protegida;
- filtros;
- paginação;
- consulta consolidada;
- integração com Compras;
- integração com Produção.

---

# Documentação de Produto Venda

Conjunto documental homologado:

- [[Homologação - Produtos - Produto Venda]]
- [[Mapa Técnico - Produtos - Produto Venda]]
- [[Workflows - Produtos - Produto Venda]]
- [[Modelo de Domínio - Produtos - Produto Venda]]
- [[Riscos e Cuidados - Produtos - Produto Venda]]

Esses documentos formam o núcleo documental específico de Produto Venda.

Devem permanecer vinculados entre si e ao [[Sysvar]].

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

Os hashes de commits não devem ser considerados referência permanente neste mapa central porque novas correções podem substituí-los.

Os documentos de homologação específicos podem registrar commits de fechamento.

Para consultar os commits atuais:

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

- empresa;
- perfil principal;
- tipo funcional;
- estabelecimento principal;
- estabelecimentos permitidos;
- permissões individuais;
- permissões de campo;
- situação ativa;
- `deve_trocar_senha`.

## PerfilAcesso

Responsável por:

- perfil da Empresa;
- nome;
- descrição;
- situação;
- perfil padrão;
- usuários vinculados.

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
- usuário;
- estabelecimento;
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
- usuário;
- Empresa;
- contrato;
- suspensão;
- troca obrigatória de senha.

Código de troca obrigatória:

~~~text
PASSWORD_CHANGE_REQUIRED
~~~

Caminhos necessários durante esse fluxo devem permanecer explicitamente controlados.

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
- perfil;
- overrides;
- master;
- superusuário;
- permissões efetivas;
- contexto utilizado pelo frontend.

A permissão final não deve ser recalculada independentemente no navegador.

Produto Venda utiliza esse modelo de permissão nas ações sensíveis.

Exemplo conceitual:

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

Uma sessão ocupa licença quando satisfaz os critérios do serviço central.

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
→ validação do usuário
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

Código de limite:

~~~text
CONCURRENT_SESSION_LIMIT_REACHED
~~~

---

# Logout

Ordem correta:

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

Commands relevantes:

~~~text
diagnosticar_sessoes_empresa
reconciliar_sessoes_ativas
~~~

O diagnóstico não deve mostrar token bruto.

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

Master e superusuário possuem regras específicas.

O sistema utiliza permissões funcionais por módulo.

Não depender exclusivamente de cargos ou roles antigas.

---

# Accounts — Serializers

Responsabilidades:

- validar Empresa;
- validar perfil;
- validar estabelecimentos;
- aplicar overrides;
- retornar permissão efetiva;
- validar módulos;
- validar dependências;
- proteger campos internos;
- tratar senhas;
- serializar sessões.

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
- formas de pagamento;
- cadastros auxiliares.

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

O contrato controla aspectos como:

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

A estrutura é utilizada por vários domínios, incluindo Produto Venda e Estoque.

Produto Venda pode inicializar estrutura de Estoque apenas nas Lojas selecionadas.

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
- integração com Compras;
- integração com Financeiro;
- isolamento multiempresa.

Fornecedor é especialmente relevante ao fluxo:

~~~text
Produto Venda
tipo Revenda
    ↓
Pedido de Compra
    ↓
Fornecedor
~~~

---

# Cadastros — Funcionários

Cadastro concluído e homologado.

Resultado:

~~~text
17/17
~~~

Integrações principais:

- Cargo;
- Loja Principal;
- Lojas supervisionadas;
- Usuário;
- comissão básica;
- vendas;
- Histórico;
- Auditoria.

Documentação:

- [[Homologação - Cadastros - Funcionários]]
- [[Mapa Técnico - Cadastros - Funcionários]]
- [[Workflows - Cadastros - Funcionários]]
- [[Modelo de Domínio - Cadastros - Funcionários]]
- [[Riscos e Cuidados - Cadastros - Funcionários]]

---

# Backend — Produto

Caminho principal:

~~~text
Backend\produto
~~~

Responsabilidades gerais:

- Produtos;
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
- NCM;
- Dados fiscais;
- preços;
- Estoque relacionado;
- imagens;
- Histórico Funcional do Produto Venda.

Arquivos principais:

~~~text
Backend\produto\models.py
Backend\produto\serializers.py
Backend\produto\views.py
Backend\produto\urls.py
Backend\produto\permissions.py
Backend\produto\tests.py
~~~

Sempre confirmar estrutura atual no repositório antes de editar.

Mapa detalhado:

[[Mapa Técnico - Produtos - Produto Venda]]

---

# Produto — Entidades Principais

Para Produto Venda, as estruturas centrais são:

~~~text
Produto
ProdutoDetalhe
ProdutoVendaHistorico
ProdutoImagem
~~~

Relacionamentos importantes:

- Empresa;
- Grupo;
- Subgrupo;
- Coleção;
- Unidade;
- Material;
- Grade;
- Cor;
- Tamanho;
- Loja;
- Estoque;
- Tabela de Preço;
- Ficha Técnica;
- Ordem de Produção;
- AuditLog.

Modelo conceitual completo:

[[Modelo de Domínio - Produtos - Produto Venda]]

---

# Produto

`Produto` representa o cadastro principal da mercadoria.

Não representa uma variação individual.

Exemplo:

~~~text
Produto
Calça Jeans Feminina
~~~

Variações:

~~~text
Preta 38
Preta 40
Azul 38
Azul 40
~~~

são representadas por `ProdutoDetalhe`.

---

# ProdutoDetalhe

Representa o SKU.

Identidade lógica:

~~~text
Produto + Cor + Tamanho
~~~

Responsabilidades:

- variação;
- EAN;
- status;
- custos;
- relacionamento operacional com Estoque.

---

# Produto Venda — Tipos

Tipos homologados:

~~~text
1 = Revenda
3 = Fabricação Própria
~~~

O tipo é imutável após criação.

Não converter registros existentes entre esses tipos.

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

Não confundir os dois identificadores.

---

# Produto Venda — Grade

Grade é obrigatória.

Após geração de SKUs:

~~~text
Grade = imutável
~~~

Não permitir alteração apenas por mudança de frontend.

A proteção precisa existir no backend.

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
- reativa SKU já existente quando aplicável.

Remover Cor:

- inativa SKU;
- não apaga.

Remover última Cor:

- também precisa sincronizar;
- todos os SKUs correspondentes ficam inativos.

Reintroduzir Cor:

- reativa SKU;
- preserva EAN.

Workflow completo:

[[Workflows - Produtos - Produto Venda]]

---

# Produto Venda — EAN

EAN pertence ao SKU.

A geração utiliza a estrutura existente por Empresa.

Princípios:

- geração backend;
- unicidade;
- sequência protegida;
- EAN preservado na inativação;
- EAN preservado na reativação;
- não reciclar EAN;
- não criar gerador paralelo.

---

# Produto Venda — Estoque

Granularidade:

~~~text
Loja × SKU
~~~

Não utilizar saldo único de Produto como substituto.

Inicialização no cadastro:

~~~text
Loja selecionada
+
SKU
=
estrutura de Estoque em zero
~~~

Inicialização não significa entrada física.

---

# Produto Venda — Estoque Disponível

Conceito atual:

~~~text
Disponível = Físico - Reserva
~~~

Produto Venda apresenta essa estrutura.

Regras definitivas de:

- reserva;
- baixa;
- saldo negativo;
- disponibilidade comercial;

permanecem nos domínios operacionais responsáveis.

---

# Produto Venda — Custos

Conceitos existentes incluem:

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

Não criar atualização paralela sem considerar a origem do custo.

---

# Produto Venda — Preços

Produto se relaciona com Tabelas de Preço.

Não foi definido:

~~~text
Preço obrigatório diferente por SKU
~~~

nem:

~~~text
Tabela de Preço obrigatória por Loja
~~~

Preço comercial definitivo permanece no domínio correspondente.

---

# Produto Venda — Dados Fiscais

Campos existentes incluem:

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

São editáveis.

Alterações relevantes devem ser rastreadas.

---

# ProdutoVendaHistorico

Responsabilidade:

registrar eventos funcionais relevantes do Produto Venda.

Exemplos:

- alteração cadastral;
- alteração fiscal;
- ativação;
- inativação;
- bloqueio de venda;
- desbloqueio.

Não substituir a Auditoria Central.

---

# ProdutoImagem

Responsabilidade:

imagens associadas ao Produto.

Regras homologadas:

~~~text
0..3 imagens
~~~

- opcionais;
- no máximo três;
- no máximo uma principal;
- imagem pertence ao Produto;
- não existe imagem por Cor;
- não existe imagem por SKU.

---

# Imagem Reduzida

A interface pode priorizar:

~~~text
imagem_reduzida_url
~~~

e utilizar:

~~~text
imagem_url
~~~

como fallback.

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

# Produto Venda — Ciclo do Produto

Situação cadastral:

~~~text
ATIVO
  ↓
INATIVO
  ↓
ATIVO
~~~

Bloqueio comercial:

~~~text
LIBERADO
   ↓
BLOQUEADO
   ↓
LIBERADO
~~~

Os dois estados são independentes.

---

# Produto Venda — Exclusão

Produto nunca utilizado e sem vínculos impeditivos pode ser excluído.

Produto utilizado deve ser preservado.

Alternativas:

- Inativar;
- Bloquear venda.

Não transformar inativação em exclusão física.

---

# Produto Venda — Permissões

Ações sensíveis utilizam acesso funcional.

Estrutura relevante:

~~~text
CanToggleProductFlags
+
EffectiveAccessService
~~~

Conceito:

~~~text
Produtos + EDIT
~~~

Não voltar a depender apenas de:

~~~text
is_staff
~~~

do Django Admin.

---

# Produto Venda — Motivo e Senha

Ações que já exigem confirmação mantêm:

- permissão;
- motivo;
- senha.

Exemplo:

~~~text
Inativar
→ EDIT
→ motivo
→ senha
~~~

~~~text
Bloquear venda
→ EDIT
→ motivo
→ senha
~~~

Permissão não substitui senha.

Senha não substitui permissão.

---

# Produto Venda — Filtros

Filtros processados no backend incluem conceitos como:

- busca;
- Referência;
- Código;
- Grupo;
- Coleção;
- Tipo;
- Status;
- Bloqueado;
- combinações.

Não concatenar filtros distintos indevidamente.

---

# Produto Venda — Paginação

Paginação é server-side.

Fluxo:

~~~text
Frontend
→ page
→ page_size
→ filtros
→ ordering
→ Backend
→ count + results
~~~

O frontend apresenta indicador:

~~~text
Mostrando X–Y de Z
~~~

---

# Produto Venda — Consulta Consolidada

Consulta é somente leitura.

Pode reunir:

- Produto;
- classificação;
- Dados fiscais;
- SKUs;
- status dos SKUs;
- custos;
- preço;
- Margem %;
- imagens;
- Estoque Loja × SKU;
- Histórico Funcional;
- Ficha Técnica;
- Ordens de Produção.

Informações de Produção aparecem quando aplicáveis a Fabricação Própria.

---

# Produto Venda — Revenda

Fluxo conceitual:

~~~text
Produto Venda
tipo 1
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

Produto Venda não absorve Compras.

---

# Produto Venda — Fabricação Própria

Fluxo conceitual:

~~~text
Produto Venda
tipo 3
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

Produto Venda não absorve Produção.

---

# Integração — Produto Venda e Compras

Compras continua responsável por:

- fornecedor;
- Pedido de Compra;
- itens;
- aprovação;
- recebimento;
- parcelas;
- integração financeira.

Produto Venda fornece a identidade comercial dos Produtos/SKUs utilizados.

---

# Integração — Produto Venda e Produção

Produção permanece responsável por:

- Ficha Técnica;
- Ordem de Produção;
- consumo;
- apontamento;
- facção;
- custos;
- encerramento da produção.

Produto Venda apenas participa como Produto produzido.

---

# Integração — Produto Venda e Estoque

Estoque permanece responsável por:

- saldo;
- entradas;
- saídas;
- transferências;
- reservas;
- ajustes;
- movimentações.

Produto Venda não deve alterar livremente saldo.

---

# Integração — Produto Venda e Fiscal

Produto mantém dados cadastrais fiscais.

Fiscal permanece responsável por:

- emissão;
- documentos;
- NFC-e;
- NFe;
- regras operacionais fiscais.

---

# Integração — Produto Venda e PDV

PDV utiliza Produto/SKU.

Condições relevantes incluem:

~~~text
Produto ativo
+
Produto não bloqueado
+
SKU ativo
+
estoque conforme regra
+
preço
+
fiscal
~~~

Produto Venda não substitui validações do PDV.

---

# Backend — Auditoria

Caminho:

~~~text
Backend\auditoria
~~~

Arquivos principais:

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

Componentes principais:

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

Quando auditoria for obrigatória para a operação:

~~~text
transaction.atomic
→ alteração
→ AuditService.required_success
→ commit
~~~

Falha de Auditoria obrigatória deve impedir commit quando essa for a regra do processo.

---

# Produto Venda — Histórico versus Auditoria

Separação:

~~~text
ProdutoVendaHistorico
=
histórico funcional
~~~

~~~text
AuditLog
=
auditoria técnica central
~~~

Não eliminar uma estrutura em favor da outra.

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

Os caminhos devem ser confirmados antes de editar.

---

# Frontend — Auth Service

Responsabilidades:

- login;
- logout;
- token;
- contexto do usuário;
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

Arquivo:

~~~text
Frontend\sysvar\src\app\layout\shell\shell.component.ts
~~~

Responsabilidades:

- menu lateral;
- ações globais;
- logout;
- exibição por permissão;
- grupos funcionais.

Produto Venda deve aparecer com nomenclatura:

~~~text
Produto Venda
~~~

Não retornar à nomenclatura geral:

~~~text
Produtos Revenda
~~~

quando a tela incluir os dois tipos.

---

# Frontend — Produto Venda

Feature principal:

~~~text
Frontend\sysvar\src\app\features\Produtos
~~~

Arquivos principais:

~~~text
produtos.component.ts
produtos.component.html
produtos.component.css
produtos.component.spec.ts
~~~

Service:

~~~text
src\app\core\services\produtos.service.ts
~~~

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
- fiscal;
- imagens;
- Histórico;
- Estoque;
- ações de ciclo de vida.

Mapa específico:

[[Mapa Técnico - Produtos - Produto Venda]]

---

# Frontend — Produto Venda — Lojas

Utiliza seletor de Lojas.

Recursos homologados:

- seleção individual;
- ação Todas;
- Limpar;
- confirmação.

Seleção de Loja influencia a inicialização de Estoque.

---

# Frontend — Produto Venda — Cores

Seleção de Cores influencia estruturalmente os SKUs.

Não tratar como simples campo visual.

Frontend envia seleção.

Backend permanece autoridade para sincronização.

---

# Frontend — Produto Venda — Imagens

Service contempla operações para:

- listar;
- criar;
- marcar principal;
- remover.

Upload utiliza `FormData`.

Máximo funcional:

~~~text
3
~~~

---

# Frontend — Produto Venda — Dados Fiscais

A interface apresenta seção:

**Dados fiscais**

Inclui os campos fiscais existentes do Produto.

Esses campos não devem voltar a ficar parcialmente escondidos sem decisão funcional.

---

# Frontend — Produto Venda — Status do SKU

A consulta apresenta:

~~~text
Ativo
Inativo
~~~

em coluna própria.

Mantém:

~~~text
Margem %
~~~

Não depender somente de cor visual para o Status.

---

# Frontend — Empresas

Feature:

~~~text
features\empresas
~~~

Responsabilidades principais:

- empresas;
- contrato;
- sessões;
- suspensão;
- reativação;
- indicadores;
- ações administrativas.

---

# Frontend — Estabelecimentos

Feature:

~~~text
features\lojas
~~~

Responsabilidades:

- paginação;
- filtros;
- indicadores;
- formulário;
- ativação;
- inativação;
- encerramento;
- reabertura;
- usuários;
- permissões.

---

# Frontend — Usuários

Feature:

~~~text
features\usuarios
~~~

Responsabilidades:

- listagem;
- paginação;
- perfil;
- tipo funcional;
- estabelecimento principal;
- estabelecimentos permitidos;
- overrides;
- permissões efetivas;
- sessões;
- senha;
- ciclo de vida.

---

# Frontend — Perfis

Feature:

~~~text
features\perfis-acesso
~~~

Responsabilidades:

- perfis;
- módulos;
- dependências;
- NONE;
- VIEW;
- EDIT.

---

# Frontend — Troca Obrigatória de Senha

Rota:

~~~text
/change-password-required
~~~

Responsabilidades:

- senha atual;
- nova senha;
- confirmação;
- validação;
- backend;
- atualização do contexto;
- liberação do sistema.

---

# Interceptor

Códigos relevantes incluem:

~~~text
CONTRACT_SUSPENDED
PASSWORD_CHANGE_REQUIRED
CONCURRENT_SESSION_LIMIT_REACHED
~~~

Não tratar todos os 403 da mesma forma.

---

# Segurança Transversal

Princípios:

1. backend é autoridade;
2. tenant no backend;
3. frontend não substitui autorização;
4. VIEW e EDIT precisam ser respeitados;
5. ações sensíveis possuem proteção adicional quando definida;
6. IDs recebidos devem ser validados;
7. relações cross-tenant devem ser recusadas;
8. Auditoria deve preservar rastreabilidade;
9. dados sensíveis não devem ser logados indevidamente.

---

# Multiempresa

Regra transversal:

~~~text
Usuário
  ↓
Empresa atual
  ↓
QuerySet restrito
  ↓
Relacionamentos validados
~~~

Aplica-se especialmente a:

- Clientes;
- Fornecedores;
- Funcionários;
- Produtos;
- Lojas;
- Estoque;
- Compras;
- Financeiro;
- Produção;
- Fiscal.

---

# Testes Backend

Arquivos centrais incluem:

~~~text
Backend\accounts\tests.py
Backend\cadastros\tests.py
Backend\auditoria\tests.py
Backend\produto\tests.py
~~~

A suíte do grupo Operacional possui ampla cobertura para:

- autenticação;
- contratos;
- sessões;
- licenciamento;
- permissões;
- Estabelecimentos;
- Auditoria;
- senhas.

Cadastros adicionou cobertura para:

- Clientes;
- Fornecedores;
- Funcionários.

Produto Venda adicionou cobertura direcionada para:

- tipo;
- Grade;
- sincronização de Cores;
- última Cor;
- reativação;
- preservação de EAN;
- exclusão;
- tenant;
- Histórico;
- imagens;
- fiscal;
- permissões.

No fechamento final de Produto Venda foram reportados:

~~~text
8 testes backend direcionados aprovados
~~~

Esse número não representa o total da suíte do projeto.

O total atual deve sempre ser confirmado executando os testes.

---

# Testes Frontend

Cobertura transversal inclui:

- rotas;
- permissões;
- autenticação;
- logout;
- sessões;
- modais;
- filtros;
- paginação;
- componentes funcionais.

Produto Venda possui testes direcionados para:

- nomenclatura;
- filtros;
- paginação;
- seleção de Lojas;
- ação Todas;
- Dados fiscais;
- imagens;
- Status do SKU;
- ações de ciclo de vida.

No fechamento final foram reportados:

~~~text
11 testes frontend direcionados aprovados
~~~

Esse número não representa a suíte total.

---

# Comandos de Validação

## Backend

~~~powershell
cd C:\SysvarProjeto\Backend

python manage.py check
python manage.py makemigrations --check --dry-run
~~~

Quando pertinente:

~~~powershell
python manage.py test accounts -v 2 --noinput
python manage.py test cadastros -v 2 --noinput
python manage.py test auditoria -v 2 --noinput
python manage.py test produto -v 2 --noinput
~~~

Executar a suíte completa somente em checkpoint adequado:

~~~powershell
python manage.py test -v 2 --noinput
~~~

Não afirmar que testes passaram sem executar.

## Frontend

~~~powershell
cd C:\SysvarProjeto\Frontend\sysvar

npx tsc -p tsconfig.app.json --noEmit
ng build --configuration development
~~~

Quando pertinente:

~~~powershell
ng test --watch=false --browsers=ChromeHeadless
~~~

Utilizar testes direcionados para correções localizadas.

Executar suíte ampla em checkpoints relevantes.

---

# Homologação Manual Concluída — Operacional

Foram homologados:

- licenciamento;
- limite simultâneo;
- liberação de vaga;
- superusuário;
- contador;
- sessões;
- encerramento;
- segurança;
- Auditoria.

Status:

~~~text
OPERACIONAL HOMOLOGADO
~~~

---

# Homologação Manual Concluída — Cadastros

Cadastros revisados:

~~~text
Clientes
Fornecedores
Funcionários
~~~

Status do escopo atual:

~~~text
HOMOLOGADO
DOCUMENTADO
~~~

Funcionários:

~~~text
17/17 itens aprovados
~~~

---

# Homologação Manual Concluída — Produto Venda

Resultado:

~~~text
19/19 itens aprovados
~~~

Foram homologados:

1. cadastro e obrigatoriedades;
2. tipo imutável;
3. Grade imutável;
4. descrição reduzida;
5. Grupo/Subgrupo;
6. remoção de Cor;
7. remoção da última Cor;
8. reativação e preservação de EAN;
9. exclusão de Produto nunca utilizado;
10. proteção de Produto utilizado;
11. Histórico cadastral;
12. fiscal;
13. imagens;
14. Estoque Loja × SKU;
15. consulta de Fabricação Própria;
16. filtros;
17. Inativar/Ativar;
18. Bloquear/Desbloquear venda;
19. paginação.

Documento:

[[Homologação - Produtos - Produto Venda]]

---

# Onde Mexer por Funcionalidade

## Suspensão da Empresa

Backend:

~~~text
cadastros\models.py
cadastros\serializers.py
cadastros\views.py
accounts\authentication.py
accounts\services\sessions.py
auditoria\models.py
auditoria\services.py
~~~

Frontend:

~~~text
features\empresas
core\services\empresas.service.ts
interceptor
auth service
~~~

---

## Estabelecimentos

Backend:

~~~text
cadastros\models.py
cadastros\serializers.py
cadastros\views.py
cadastros\urls.py
cadastros\tests.py
~~~

Frontend:

~~~text
features\lojas
core\services\lojas.service.ts
app.routes.ts
layout\shell
~~~

---

## Usuários

Backend:

~~~text
accounts\models.py
accounts\serializers.py
accounts\views.py
accounts\permissions.py
accounts\tests.py
~~~

Frontend:

~~~text
features\usuarios
core\services\users.service.ts
permission service
auth service
~~~

---

## Perfis

Backend:

~~~text
accounts\models.py
accounts\serializers.py
accounts\permissions.py
accounts\services\effective_access.py
~~~

Frontend:

~~~text
features\perfis-acesso
app.routes.ts
permission service
~~~

---

## Sessões

Backend:

~~~text
accounts\models.py
accounts\views.py
accounts\serializers.py
accounts\services\sessions.py
accounts\management\commands
cadastros\views.py
auditoria\services.py
~~~

Frontend:

~~~text
core\auth.service.ts
layout\shell\shell.component.ts
features\empresas
features\usuarios
core\services\empresas.service.ts
core\services\users.service.ts
~~~

---

## Senhas

Backend:

~~~text
accounts\authentication.py
accounts\serializers.py
accounts\views.py
accounts\urls.py
accounts\tests.py
~~~

Frontend:

~~~text
features\change-password-required
guards
interceptors
auth service
app.routes.ts
~~~

---

## Auditoria

Backend:

~~~text
auditoria\models.py
auditoria\services.py
auditoria\middleware.py
auditoria\signals.py
auditoria\views.py
auditoria\tests.py
~~~

Frontend:

~~~text
features\auditoria
core\models\audit.ts
core\services\audit.service.ts
~~~

---

## Clientes

Principalmente:

~~~text
Backend\cadastros
Backend\auditoria
Frontend\sysvar\src\app\features
Frontend\sysvar\src\app\core\services
~~~

Antes de alterar:

[[Mapa Técnico - Cadastros - Clientes]]

---

## Funcionários

Principalmente:

~~~text
Backend\cadastros
Backend\accounts
Backend\auditoria
Frontend\sysvar\src\app\features
Frontend\sysvar\src\app\core\services
~~~

Antes de alterar:

- [[Mapa Técnico - Cadastros - Funcionários]]
- [[Modelo de Domínio - Cadastros - Funcionários]]
- [[Workflows - Cadastros - Funcionários]]
- [[Riscos e Cuidados - Cadastros - Funcionários]]

---

## Produto Venda

Backend:

~~~text
Backend\produto\models.py
Backend\produto\serializers.py
Backend\produto\views.py
Backend\produto\urls.py
Backend\produto\permissions.py
Backend\produto\tests.py
~~~

Integrações possíveis:

~~~text
Backend\cadastros
Backend\accounts
Backend\auditoria
Backend\compras
Backend\fiscal
estruturas de Estoque
estruturas de Produção
estruturas de Preços
~~~

Frontend:

~~~text
Frontend\sysvar\src\app\features\Produtos
Frontend\sysvar\src\app\core\services\produtos.service.ts
Frontend\sysvar\src\app\layout\shell
componentes auxiliares de Loja e Cor
~~~

Antes de alterar Produto Venda, consultar obrigatoriamente:

- [[Homologação - Produtos - Produto Venda]]
- [[Mapa Técnico - Produtos - Produto Venda]]
- [[Workflows - Produtos - Produto Venda]]
- [[Modelo de Domínio - Produtos - Produto Venda]]
- [[Riscos e Cuidados - Produtos - Produto Venda]]

---

# Dependências Principais de Produto Venda

~~~text
Empresa
   ↓
Produto Venda
   ↓
Produto
   ↓
ProdutoDetalhe / SKU
   ├── Cor
   ├── Tamanho
   ├── EAN
   └── Estoque
        ↓
      Loja
~~~

Classificação:

~~~text
Produto
├── Coleção
├── Grupo
├── Subgrupo
├── Unidade
├── Material
└── Grade
~~~

Domínios relacionados:

~~~text
Produto Venda
├── Compras
├── Estoque
├── Preços
├── Fiscal
├── Produção
├── Vendas / PDV
└── Auditoria
~~~

---

# Regras Técnicas Críticas de Produto Venda

Não devem regredir:

1. tenant no backend;
2. tipo imutável;
3. Referência automática;
4. Grade imutável após SKU;
5. SKU = Produto × Cor × Tamanho;
6. remoção de Cor inativa SKU;
7. remoção da última Cor precisa funcionar;
8. reentrada de Cor reativa SKU;
9. EAN preservado;
10. Estoque Loja × SKU;
11. inicialização de Estoque não é entrada;
12. Produto utilizado não pode ser excluído;
13. Inativo não é excluído;
14. Bloqueado não é Inativo;
15. fiscal é editável e rastreado;
16. Histórico Funcional não substitui AuditLog;
17. máximo de três imagens;
18. uma imagem principal;
19. sem imagem por Cor;
20. sem imagem por SKU;
21. filtros server-side;
22. paginação server-side;
23. ações sensíveis usam permissão funcional;
24. senha e motivo continuam quando exigidos.

Detalhamento:

[[Riscos e Cuidados - Produtos - Produto Venda]]

---

# Fluxo Técnico Geral do Produto Venda

~~~text
Usuário
   ↓
Frontend Produto Venda
   ↓
API Produto
   ↓
Tenant
   ↓
Validações
   ↓
Produto
   ↓
SKUs
   ↓
EAN
   ↓
Loja × SKU
   ↓
Estoque
~~~

Em paralelo:

~~~text
Produto
├── Dados fiscais
├── Imagens
├── Preços
├── Histórico Funcional
└── Auditoria Central
~~~

Fluxo completo:

[[Workflows - Produtos - Produto Venda]]

---

# Próxima Área Técnica

Situação atual:

~~~text
Operacional
→ CONCLUÍDO

Cadastros revisados
→ CONCLUÍDOS NO ESCOPO ATUAL

Produtos
→ EM ANDAMENTO

Produto Venda
→ CONCLUÍDO
~~~

O próximo item do grupo Produtos deve ser definido antes de iniciar nova implementação/homologação.

Produto Uso e Consumo continua separado de Produto Venda e não deve ser considerado homologado apenas pelo fechamento de Produto Venda.

Antes de qualquer novo prompt para Codex:

1. identificar exatamente o próximo cadastro/processo;
2. verificar código atual;
3. verificar integrações;
4. levantar comportamento atual;
5. definir regras funcionais;
6. comparar com os padrões já homologados;
7. verificar multiempresa;
8. verificar permissões;
9. verificar Auditoria;
10. verificar testes;
11. registrar riscos;
12. somente então criar prompt de implementação.

---

# Padrão de Trabalho Técnico

Fluxo recomendado:

~~~text
Decisão funcional
        ↓
Investigação do código atual
        ↓
Definição completa da solução
        ↓
Avaliação de impactos
        ↓
Prompt direcionado ao Codex
        ↓
Implementação
        ↓
Testes direcionados
        ↓
Revisão técnica
        ↓
Homologação manual
        ↓
Correções
        ↓
Reteste
        ↓
Documentação
        ↓
Fechamento
~~~

Evitar investigação ampla via Codex quando a análise puder ser feita previamente.

Usar suíte completa apenas em checkpoints em que ela agregue valor.

---

# Documentação e Grafo do Obsidian

Os documentos principais devem possuir links internos.

Núcleo:

[[Sysvar]]

Contexto geral:

- [[10 Projetos/Sysvar/Contexto do Projeto/Visão Geral|Visão Geral]]
- [[10 Projetos/Sysvar/Contexto do Projeto/Arquitetura|Arquitetura]]
- [[10 Projetos/Sysvar/Contexto do Projeto/Modelo de Domínio|Modelo de Domínio]]
- [[10 Projetos/Sysvar/Contexto do Projeto/Workflows|Workflows]]
- [[10 Projetos/Sysvar/Contexto do Projeto/Riscos e Cuidados|Riscos e Cuidados]]

Produto Venda:

- [[Homologação - Produtos - Produto Venda]]
- [[Mapa Técnico - Produtos - Produto Venda]]
- [[Workflows - Produtos - Produto Venda]]
- [[Modelo de Domínio - Produtos - Produto Venda]]
- [[Riscos e Cuidados - Produtos - Produto Venda]]

Os links não existem apenas para navegação textual.

Eles também preservam as relações entre documentos no Graph View do Obsidian.

---

# Última Atualização

~~~text
2026-08-13
~~~

---

# Estado do Documento

Este Mapa Técnico central representa a visão técnica consolidada atual do [[Sysvar]].

Situação dos principais grupos trabalhados:

~~~text
OPERACIONAL
→ HOMOLOGADO E DOCUMENTADO

CADASTROS
→ CLIENTES, FORNECEDORES E FUNCIONÁRIOS
→ HOMOLOGADOS E DOCUMENTADOS

PRODUTOS
→ EM ANDAMENTO

PRODUTO VENDA
→ HOMOLOGADO E DOCUMENTADO
→ 19/19
~~~

Qualquer desenvolvimento futuro deve consultar este mapa e, quando a alteração atingir um domínio já fechado, também consultar sua documentação específica.

---

# Notas Relacionadas

## Projeto

- [[10 Projetos/Sysvar/Sysvar|Sysvar]]

## Contexto Geral

- [[10 Projetos/Sysvar/Contexto do Projeto/Visão Geral|Visão Geral]]
- [[10 Projetos/Sysvar/Contexto do Projeto/Arquitetura|Arquitetura]]
- [[10 Projetos/Sysvar/Contexto do Projeto/Modelo de Domínio|Modelo de Domínio]]
- [[10 Projetos/Sysvar/Contexto do Projeto/Workflows|Workflows]]
- [[10 Projetos/Sysvar/Contexto do Projeto/Riscos e Cuidados|Riscos e Cuidados]]

## Operacional

- [[10 Projetos/Sysvar/Homologações/Homologação - Operacional|Homologação - Operacional]]
- [[10 Projetos/Sysvar/Decisões Técnicas/ADR-001 - Licenciamento por Sessões Simultâneas|ADR-001 - Licenciamento por Sessões Simultâneas]]
- [[10 Projetos/Sysvar/Decisões Técnicas/ADR-002 - Princípios Arquiteturais do SISVAR|ADR-002 - Princípios Arquiteturais do SISVAR]]
- [[10 Projetos/Sysvar/Decisões Técnicas/ADR-003 - Auditoria Central do SISVAR|ADR-003 - Auditoria Central do SISVAR]]

## Cadastros — Clientes

- [[Mapa Técnico - Cadastros - Clientes]]

## Cadastros — Funcionários

- [[Homologação - Cadastros - Funcionários]]
- [[Mapa Técnico - Cadastros - Funcionários]]
- [[Workflows - Cadastros - Funcionários]]
- [[Modelo de Domínio - Cadastros - Funcionários]]
- [[Riscos e Cuidados - Cadastros - Funcionários]]

## Produtos — Produto Venda

- [[Homologação - Produtos - Produto Venda]]
- [[Mapa Técnico - Produtos - Produto Venda]]
- [[Workflows - Produtos - Produto Venda]]
- [[Modelo de Domínio - Produtos - Produto Venda]]
- [[Riscos e Cuidados - Produtos - Produto Venda]]