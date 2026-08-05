---

type: project  
status: active  
project: Sysvar  
source: "C:/SysvarProjeto"  
created: 2026-08-03  
updated: 2026-08-05  
tags:

- projeto
    
- sysvar
    
- operacional
    
- segurança
    
- auditoria
    

---

# Sysvar

## O que é

O Sysvar é um ERP SaaS para o varejo e a indústria de moda, desenvolvido em Django REST Framework, Angular 17 Standalone e MySQL.

O sistema suporta:

- múltiplas empresas;
    
- múltiplas lojas por empresa;
    
- módulos contratáveis;
    
- perfis de acesso;
    
- permissões efetivas;
    
- licenciamento por sessões simultâneas;
    
- auditoria central;
    
- operações integradas entre os módulos.
    

Seu desenvolvimento segue uma arquitetura modular, permitindo evolução contínua sem comprometer as funcionalidades já consolidadas.

---

# Objetivos do projeto

O objetivo do Sysvar é fornecer uma plataforma única para administrar as operações de empresas do ramo de moda.

O sistema deverá contemplar:

- administração da plataforma;
    
- empresas e contratos;
    
- estabelecimentos;
    
- usuários;
    
- perfis e permissões;
    
- cadastros;
    
- produtos;
    
- compras;
    
- estoque;
    
- vendas;
    
- fiscal;
    
- financeiro;
    
- contabilidade;
    
- produção;
    
- distribuição;
    
- relatórios;
    
- dashboards;
    
- auditoria.
    

O projeto prioriza:

- simplicidade operacional;
    
- segurança;
    
- isolamento entre empresas;
    
- isolamento por loja;
    
- escalabilidade;
    
- padronização de interface;
    
- rastreabilidade;
    
- documentação técnica atualizada;
    
- testes proporcionais ao risco.
    

---

# Áreas principais

O sistema contempla os seguintes grupos e módulos:

- Operacional
    
- Cadastros
    
- Produtos
    
- Compras
    
- Estoque
    
- Distribuição
    
- Produção
    
- Vendas
    
- Módulo Loja
    
- Financeiro
    
- Fiscal
    
- Contabilidade
    
- Relatórios
    
- Dashboards
    
- Configurações
    

---

# Grupo Operacional

O grupo Operacional reúne as funcionalidades centrais de administração e segurança do cliente.

Itens do menu:

```text
Operacional
├── Empresas
├── Estabelecimento
├── Usuários
├── Perfis de acesso
└── Auditoria
```

A implementação técnica do grupo foi concluída.

Foram executados:

- revisão do código;
    
- implementação;
    
- endurecimento de segurança;
    
- migrations;
    
- testes backend;
    
- testes frontend;
    
- revisão técnica dos commits.
    

A homologação manual completa no navegador ainda deve ser executada antes de o grupo ser marcado como homologado funcionalmente.

---

# Empresas e Contratos

A empresa representa um cliente do Sysvar.

Cada empresa possui:

- contrato;
    
- módulos contratados;
    
- usuário master;
    
- limite de sessões simultâneas;
    
- estabelecimentos;
    
- usuários;
    
- perfis;
    
- permissões;
    
- sessões;
    
- dados operacionais;
    
- registros de auditoria.
    

## Situações do contrato

O contrato pode possuir estados como:

```text
PENDENTE
ATIVO
SUSPENSO
VENCIDO
CANCELADO
```

## Suspensão administrativa

Foi implementado o bloqueio administrativo de acesso da empresa.

A suspensão pode utilizar motivos como:

```text
INADIMPLENCIA
SOLICITACAO_CLIENTE
RISCO_SEGURANCA
ENCERRAMENTO_CONTRATO
BLOQUEIO_ADMINISTRATIVO
OUTRO
```

Ao suspender uma empresa:

1. o contrato é bloqueado dentro da transação;
    
2. o status passa para `SUSPENSO`;
    
3. o motivo e a observação são registrados;
    
4. todas as sessões ativas são encerradas;
    
5. os tokens são revogados;
    
6. as vagas simultâneas são liberadas;
    
7. a versão das permissões é atualizada;
    
8. a Auditoria obrigatória registra a operação.
    

Se a Auditoria obrigatória falhar, toda a suspensão sofre rollback.

## Bloqueio de acesso

Uma empresa suspensa não consegue:

- realizar novos logins;
    
- utilizar sessões anteriores;
    
- continuar utilizando tokens existentes;
    
- acessar endpoints protegidos;
    
- manter sessões ativas.
    

Código retornado:

```text
CONTRACT_SUSPENDED
```

Mensagem pública:

```text
O acesso da empresa está temporariamente suspenso. Entre em contato com o suporte.
```

O motivo comercial detalhado não é informado a usuários comuns.

## Reativação

A reativação:

- retorna o contrato para `ATIVO`;
    
- preserva o histórico da suspensão;
    
- não reativa sessões antigas;
    
- exige novo login dos usuários;
    
- registra Auditoria obrigatória.
    

## Permissões

Superusuário:

- cria e altera empresas;
    
- administra contratos;
    
- altera módulos;
    
- altera limites;
    
- suspende;
    
- reativa;
    
- transfere master.
    

Master:

- consulta a própria empresa;
    
- consulta informações permitidas do contrato;
    
- não suspende;
    
- não reativa;
    
- não altera condições comerciais da plataforma.
    

Usuários comuns acessam somente informações autorizadas.

---

# Estabelecimentos

Estabelecimento representa uma unidade operacional da empresa.

Tipos atuais:

```text
LOJA
MATRIZ
FABRICA
```

Todo estabelecimento pertence obrigatoriamente a uma empresa.

O diagnóstico executado antes da alteração estrutural encontrou:

```text
lojas_sem_empresa = 0
```

Por isso, a migration tornou `Loja.empresa` obrigatória sem necessidade de saneamento de dados.

## Regras

- estabelecimento sempre pertence a uma empresa;
    
- usuário cliente não pode escolher outra empresa;
    
- superusuário informa a empresa ao criar;
    
- empresa não pode ser removida;
    
- loja principal e lojas permitidas devem pertencer à mesma empresa;
    
- tipo de unidade é a fonte principal;
    
- o campo legado `Matriz` permanece sincronizado por compatibilidade.
    

## Ciclo de vida

Foram criadas ações explícitas:

```text
Ativar
Inativar
Encerrar
Reabrir
```

Ações de encerramento não excluem o histórico do estabelecimento.

Antes de inativar ou encerrar, o backend pode verificar impedimentos como:

- sessões ativas;
    
- usuários vinculados;
    
- loja principal de usuários;
    
- operações pendentes;
    
- outras dependências existentes.
    

## Usuários vinculados

A consulta do estabelecimento pode apresentar:

- usuário;
    
- nome;
    
- perfil;
    
- loja principal;
    
- loja permitida;
    
- situação;
    
- sessão ativa.
    

## Permissões

```text
operacional = NONE
→ sem acesso

operacional = VIEW
→ consulta

operacional = EDIT
→ cria e altera
```

O acesso à tela não depende mais exclusivamente dos tipos antigos:

```text
Diretor
Gerente
Caixa
Vendedor
```

Os tipos podem continuar existindo para regras funcionais específicas, mas não são a autoridade principal de autorização.

## Auditoria

Eventos previstos e integrados incluem:

```text
STORE_CREATED
STORE_UPDATED
STORE_ACTIVATED
STORE_DEACTIVATED
STORE_CLOSED
STORE_REOPENED
STORE_FISCAL_CONFIG_UPDATED
STORE_NUMBERING_UPDATED
STORE_NEGATIVE_STOCK_POLICY_UPDATED
STORE_OPERATION_DENIED
```

---

# Usuários

O cadastro de usuários utiliza como regra principal:

```text
Perfil principal
+ override individual
+ contrato
+ módulos contratados
= permissão efetiva
```

O campo `type` permanece como classificação funcional e não define automaticamente as permissões.

## Tipos funcionais

Tipos existentes podem incluir:

```text
Regular
Vendedor
Caixa
Gerente
Diretor
Admin
Auxiliar
Assistente
AssistenteReceber
AssistentePagar
```

O tipo funcional não deve:

- conceder módulo;
    
- remover módulo;
    
- alterar perfil;
    
- sobrescrever overrides;
    
- definir a permissão efetiva.
    

## Perfil principal

Para usuário comum:

- perfil é obrigatório;
    
- perfil deve estar ativo;
    
- perfil deve pertencer à mesma empresa;
    
- perfil não pode conceder módulo não contratado.
    

Master e superusuário possuem regras próprias.

## Empresa e lojas

Para usuário cliente:

- empresa vem do contexto;
    
- empresa permanece bloqueada no frontend;
    
- loja principal pertence à empresa;
    
- lojas permitidas pertencem à empresa;
    
- loja principal deve fazer parte das lojas permitidas.
    

## Matriz de permissões

A tela de usuários utiliza o conceito:

|Módulo|Perfil|Override|Efetivo|
|---|---|---|---|
|Compras|VIEW|EDIT|EDIT|
|Financeiro|NONE|HERDAR|NONE|
|Auditoria|VIEW|HERDAR|VIEW|

Valores do override:

```text
HERDAR
NONE
VIEW
EDIT
```

`HERDAR` remove a permissão individual e utiliza o valor do perfil.

O acesso efetivo é calculado pelo backend.

## Ciclo de vida

As operações foram separadas em:

```text
Criar
Consultar
Editar
Ativar
Inativar
Redefinir senha
Encerrar sessões
Excluir administrativamente
Transferir administração
```

Regras:

- criar usuário não consome licença;
    
- ativar usuário não consome licença;
    
- inativar encerra sessões;
    
- exclusão é excepcional;
    
- master não pode ser inativado ou excluído;
    
- usuário não pode elevar a própria permissão;
    
- usuário não pode alterar a própria empresa;
    
- campos internos do Django são protegidos.
    

## Campos protegidos

Usuários clientes não podem alterar:

```text
is_staff
is_superuser
groups
user_permissions
empresa de outra empresa
master
token
session_id
session_token
```

Tentativas são rejeitadas pelo backend.

---

# Sessões de usuário

A tela de usuários pode consultar:

- sessão;
    
- dispositivo;
    
- IP;
    
- loja;
    
- início;
    
- última atividade;
    
- situação;
    
- motivo do encerramento.
    

Ações disponíveis:

```text
Encerrar sessão
Encerrar todas as sessões
```

## Encerramento consolidado

O encerramento de todas as sessões é transacional.

Fluxo:

1. usuário é bloqueado;
    
2. sessões ativas são bloqueadas;
    
3. sessões são encerradas;
    
4. tokens são revogados;
    
5. um evento consolidado é registrado;
    
6. a transação é confirmada.
    

Evento consolidado:

```text
USER_SESSIONS_CLOSED
```

Se a Auditoria obrigatória falhar:

- sessões permanecem ativas;
    
- tokens permanecem válidos;
    
- nenhuma alteração parcial é confirmada.
    

---

# Redefinição administrativa de senha

Um administrador autorizado pode redefinir a senha de um usuário.

A redefinição:

- valida a nova senha;
    
- marca `deve_trocar_senha = true`;
    
- pode encerrar todas as sessões;
    
- revoga os tokens;
    
- exige novo login;
    
- registra Auditoria obrigatória.
    

Evento:

```text
USER_PASSWORD_RESET
```

A senha nunca é registrada na Auditoria.

Se a Auditoria falhar:

- senha anterior permanece;
    
- flag anterior permanece;
    
- sessões permanecem;
    
- tokens permanecem;
    
- toda a operação sofre rollback.
    

---

# Troca obrigatória de senha

Foi implementado o fluxo completo de troca obrigatória de senha.

Quando:

```text
deve_trocar_senha = true
```

o usuário consegue autenticar, mas não pode utilizar os módulos comuns.

O backend permite apenas os endpoints mínimos necessários:

- `/api/me/`;
    
- troca de senha;
    
- logout;
    
- heartbeat, quando necessário.
    

Outros endpoints retornam:

```text
PASSWORD_CHANGE_REQUIRED
```

Mensagem:

```text
Você precisa alterar sua senha antes de continuar.
```

## Frontend

Existe uma rota específica:

```text
/change-password-required
```

O guard:

- redireciona o usuário para a troca;
    
- bloqueia acesso direto ao `/home`;
    
- permite a tela de alteração;
    
- libera o sistema após a flag ser removida.
    

A tela solicita:

- senha atual;
    
- nova senha;
    
- confirmação.
    

Após a troca:

- a flag é removida;
    
- outras sessões são encerradas;
    
- a sessão atual permanece válida;
    
- `/me/` é atualizado;
    
- o acesso aos módulos é liberado.
    

Evento:

```text
USER_PASSWORD_CHANGED
```

A senha atual, a nova senha e a confirmação nunca são auditadas.

---

# Perfis de acesso

Perfis representam conjuntos reutilizáveis de permissões.

Cada perfil pertence a uma empresa.

Níveis:

```text
NONE
VIEW
EDIT
```

## Regras

- isolamento por empresa;
    
- nome único por empresa;
    
- perfil inativo não pode ser atribuído;
    
- perfil em uso não pode ser excluído;
    
- módulo não contratado não pode ser configurado;
    
- alterações incrementam `permissions_version`;
    
- mudanças críticas utilizam Auditoria obrigatória.
    

## Perfil padrão

A regra de perfil padrão único é garantida pela aplicação.

O fluxo utiliza:

```text
transaction.atomic()
select_for_update()
```

Não depende de constraint condicional incompatível com MySQL.

## Dependências entre módulos

As dependências declaradas em `ModuloSistema.dependencias` são validadas pelo backend.

Um módulo dependente não pode ser ativado com sua dependência em `NONE`.

## Permissão do menu

Perfis de acesso passaram a utilizar o módulo:

```text
operacional
```

A rota não depende mais exclusivamente da role antiga `Admin`.

---

# Auditoria Central

A Auditoria Central está implementada, testada, revisada e homologada.

Ela foi integrada aos novos fluxos do grupo Operacional.

## Empresas e contratos

Eventos como:

```text
CONTRACT_SUSPENDED
CONTRACT_REACTIVATED
CONTRACT_SUSPENSION_DENIED
CONTRACT_REACTIVATION_DENIED
```

## Estabelecimentos

Eventos `STORE_*`.

## Usuários

Eventos como:

```text
USER_CREATED
USER_UPDATED
USER_ACTIVATED
USER_INACTIVATED
USER_PASSWORD_RESET
USER_PASSWORD_CHANGED
USER_PROFILE_CHANGED
USER_STORE_ACCESS_CHANGED
USER_OVERRIDE_CHANGED
USER_SESSIONS_CLOSED
USER_DELETED
USER_OPERATION_DENIED
PASSWORD_CHANGE_REQUIRED_ACCESS_DENIED
```

## Perfis e permissões

- criação;
    
- alteração;
    
- perfil padrão;
    
- permissões de módulo;
    
- operações negadas;
    
- rollback em falha da auditoria obrigatória.
    

---

# Licenciamento

O Sysvar utiliza licenciamento por sessões simultâneas.

As licenças não são consumidas pela quantidade de usuários cadastrados.

Regras:

- criar usuário não consome licença;
    
- ativar usuário não consome licença;
    
- login cria uma sessão;
    
- sessão ativa consome uma vaga;
    
- logout libera a vaga;
    
- timeout libera a vaga;
    
- inativação encerra sessões;
    
- redefinição de senha pode encerrar sessões;
    
- suspensão da empresa encerra todas as sessões;
    
- login no mesmo dispositivo substitui a sessão anterior;
    
- dispositivos diferentes utilizam sessões independentes;
    
- login acima do limite é bloqueado.
    

---

# Segurança

O controle de acesso considera:

- usuário;
    
- empresa;
    
- loja;
    
- contrato;
    
- módulos;
    
- perfil;
    
- override;
    
- permissão efetiva;
    
- sessão;
    
- dispositivo;
    
- situação do contrato;
    
- troca obrigatória de senha.
    

O backend permanece como autoridade final.

Ocultar menus, botões e rotas no frontend não substitui a validação no servidor.

---

# Situação atual

## Infraestrutura concluída

- autenticação multiempresa;
    
- isolamento entre empresas;
    
- isolamento por loja;
    
- contratos;
    
- módulos contratados;
    
- usuário master;
    
- perfis;
    
- permissões efetivas;
    
- sessões simultâneas;
    
- licenciamento;
    
- device ID;
    
- heartbeat;
    
- timeout;
    
- encerramento administrativo;
    
- Auditoria Central.
    

## Grupo Operacional — implementado

- Empresas;
    
- Contratos;
    
- suspensão administrativa;
    
- reativação;
    
- Estabelecimentos;
    
- empresa obrigatória no estabelecimento;
    
- ciclo de vida do estabelecimento;
    
- Usuários;
    
- Perfil/Override/Efetivo;
    
- sessões de usuário;
    
- redefinição administrativa de senha;
    
- troca obrigatória de senha;
    
- Perfis de acesso;
    
- perfil padrão;
    
- dependências de módulos;
    
- Auditoria integrada.
    

## Validação automatizada

Backend:

```text
50 testes aprovados
```

Frontend:

```text
33 testes aprovados
```

Comandos executados:

```text
python manage.py check
python manage.py makemigrations --check --dry-run
python manage.py migrate
python manage.py test -v 2 --noinput

npx tsc -p tsconfig.app.json --noEmit
ng build --configuration development
ng test --watch=false --browsers=ChromeHeadless
```

## Homologação manual

Ainda pendente a execução completa dos fluxos reais no navegador:

- suspensão e reativação;
    
- encerramento das sessões;
    
- troca obrigatória de senha;
    
- usuário VIEW e EDIT;
    
- matriz Perfil/Override/Efetivo;
    
- ações de Estabelecimentos;
    
- integração visual com Auditoria.
    

O grupo Operacional está tecnicamente implementado e validado automaticamente, mas ainda não deve ser marcado como homologado funcionalmente até esses cenários serem executados.

---

# Decisões arquiteturais registradas

## ADR-001

Licenciamento por sessões simultâneas.

## ADR-002

Princípios arquiteturais do SISVAR.

## ADR-003

Auditoria Central do SISVAR.

As regras do grupo Operacional seguem essas decisões.

Uma ADR adicional poderá ser criada futuramente caso seja necessário consolidar a suspensão administrativa e a troca obrigatória de senha como decisão arquitetural independente.

---

# Processo oficial de desenvolvimento

Toda nova tarefa deve seguir:

1. definição funcional;
    
2. análise do código real;
    
3. análise arquitetural;
    
4. elaboração do prompt;
    
5. implementação;
    
6. testes técnicos;
    
7. revisão técnica;
    
8. correções;
    
9. homologação funcional;
    
10. atualização do Obsidian;
    
11. ADR, quando necessária;
    
12. commit do código;
    
13. commit da documentação.
    

Uma funcionalidade só é considerada homologada quando os testes manuais aplicáveis forem concluídos.

---

# Próximas etapas

Depois da homologação manual do Operacional, a revisão continuará seguindo a ordem real da barra lateral.

Próximo grupo:

```text
Cadastros
```

Itens iniciais:

- Clientes
    
- Fornecedores
    
- Funcionários
    

A análise deve verificar:

- permissões;
    
- isolamento;
    
- validações;
    
- layout;
    
- auditoria;
    
- integrações;
    
- testes;
    
- melhorias funcionais.
    

---

# Código e documentação

Código local:

```text
C:\SysvarProjeto
```

Backend:

```text
C:\SysvarProjeto\Backend
```

Frontend:

```text
C:\SysvarProjeto\Frontend\sysvar
```

Vault:

```text
C:\takeshi\takeshi
```

Repositórios:

```text
FernandoMurashima/sysvarbackend
FernandoMurashima/sysvarfrontend
FernandoMurashima/sysvar-vault
```

Commits finais do grupo Operacional:

Backend:

```text
3955ea48c721afc7b15520a7afd6ec32f8374af6
```

Frontend:

```text
bf66e81e6f1c0d58255a135d9339a34b95ef332f
```

---

# Notas relacionadas

- [[10 Projetos/Sysvar/Contexto do Projeto/Visão Geral|Visão Geral]]
    
- [[10 Projetos/Sysvar/Contexto do Projeto/Arquitetura|Arquitetura]]
    
- [[10 Projetos/Sysvar/Contexto do Projeto/Modelo de Domínio|Modelo de Domínio]]
    
- [[10 Projetos/Sysvar/Contexto do Projeto/Workflows|Workflows]]
    
- [[10 Projetos/Sysvar/Contexto do Projeto/Mapa Técnico|Mapa Técnico]]
    
- [[10 Projetos/Sysvar/Contexto do Projeto/Riscos e Cuidados|Riscos e Cuidados]]
    
- [[10 Projetos/Sysvar/Decisões Técnicas/ADR-001 - Licenciamento por Sessões Simultâneas|ADR-001 - Licenciamento por Sessões Simultâneas]]
    
- [[10 Projetos/Sysvar/Decisões Técnicas/ADR-002 - Princípios Arquiteturais do SISVAR|ADR-002 - Princípios Arquiteturais do SISVAR]]
    
- [[10 Projetos/Sysvar/Decisões Técnicas/ADR-003 - Auditoria Central do SISVAR|ADR-003 - Auditoria Central do SISVAR]]