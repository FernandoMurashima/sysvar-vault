---
type: reference
status: active
project: Sysvar
source: "C:/SysvarProjeto"
created: 2026-08-03
updated: 2026-08-06
tags:
  - sysvar
  - contexto
  - mapa-tecnico
  - backend
  - frontend
  - operacional
  - auditoria
  - sessões
  - licenciamento
  - homologado
---

# Mapa Técnico

## Objetivo

Este documento indica onde estão as principais responsabilidades técnicas do SISVAR.

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
- infraestrutura transversal.

Este arquivo não substitui a leitura do código atual.

Antes de qualquer alteração:

1. localizar o arquivo;
2. abrir o conteúdo atual;
3. verificar consumidores;
4. verificar testes;
5. verificar migrations;
6. verificar impacto no frontend;
7. verificar impacto na Auditoria;
8. verificar a documentação relacionada.

---

# Situação Técnica Atual

O grupo Operacional está:

```text
IMPLEMENTADO
TESTADO AUTOMATICAMENTE
HOMOLOGADO MANUALMENTE
DOCUMENTADO
```

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

Próximo grupo:

```text
Cadastros
```

Primeiros itens:

1. Clientes;
2. Fornecedores;
3. Funcionários.

---

# Estrutura Local

Projeto:

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

Vault Obsidian:

```text
C:\takeshi\takeshi
```

Documentação no projeto:

```text
C:\SysvarProjeto\docs
```

---

# Repositórios

Backend:

```text
FernandoMurashima/sysvarbackend
```

Frontend:

```text
FernandoMurashima/sysvarfrontend
```

Vault:

```text
FernandoMurashima/sysvar-vault
```

Branch principal:

```text
main
```

Os hashes não devem ser mantidos como referência permanente neste arquivo, porque novas correções podem substituí-los.

Para consultar os commits atuais:

```powershell
cd C:\SysvarProjeto\Backend
git log -5 --oneline

cd C:\SysvarProjeto\Frontend\sysvar
git log -5 --oneline

cd C:\takeshi
git log -5 --oneline
```

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

## Documentação

- Obsidian;
- Markdown.

---

# Entrypoints

## Backend

```text
Backend\manage.py
Backend\Varejo\settings.py
Backend\Varejo\urls.py
Backend\requirements.txt
```

## Frontend

```text
Frontend\sysvar\package.json
Frontend\sysvar\angular.json
Frontend\sysvar\src\app
Frontend\sysvar\src\app\app.routes.ts
Frontend\sysvar\src\app\layout\shell
```

---

# Grupo Operacional

Estrutura do menu:

```text
Operacional
├── Empresas
├── Estabelecimento
├── Usuários
├── Perfis de acesso
└── Auditoria
```

Apps principais envolvidos:

```text
accounts
cadastros
auditoria
```

Features principais do frontend:

```text
features\empresas
features\lojas
features\usuarios
features\perfis-acesso
features\auditoria
features\change-password-required
```

---

# Backend — Accounts

Caminho:

```text
Backend\accounts
```

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

```text
Backend\accounts\models.py
Backend\accounts\serializers.py
Backend\accounts\views.py
Backend\accounts\permissions.py
Backend\accounts\authentication.py
Backend\accounts\urls.py
Backend\accounts\apps.py
Backend\accounts\tests.py
```

Services:

```text
Backend\accounts\services\effective_access.py
Backend\accounts\services\sessions.py
```

Commands:

```text
Backend\accounts\management\commands
```

---

# Accounts — Models

Arquivo:

```text
Backend\accounts\models.py
```

Entidades principais:

```text
User
PerfilAcesso
PerfilModuloPermissao
UserModulePermission
SessaoUsuario
SessionToken
```

## User

Campos e responsabilidades relevantes:

- empresa;
- perfil principal;
- tipo funcional;
- estabelecimento principal;
- estabelecimentos permitidos;
- permissões individuais;
- permissões de campo;
- situação ativa;
- `deve_trocar_senha`.

O campo:

```text
deve_trocar_senha
```

controla o fluxo obrigatório de alteração após redefinição administrativa.

## PerfilAcesso

Responsável por:

- perfil da empresa;
- nome;
- descrição;
- situação;
- perfil padrão;
- usuários vinculados.

## PerfilModuloPermissao

Relaciona:

```text
Perfil
→ ModuloSistema
→ NONE, VIEW ou EDIT
```

## UserModulePermission

Representa o override individual.

No frontend, `HERDAR` significa ausência desse registro.

## SessaoUsuario

Responsável por:

- empresa;
- usuário;
- estabelecimento;
- dispositivo;
- início;
- última atividade;
- encerramento;
- motivo;
- situação ativa.

A sessão do superusuário pode permanecer sem empresa.

## SessionToken

Responsável pelo token vinculado à sessão.

O token bruto não é persistido.

---

# Accounts — Migrations

Migrations relevantes:

```text
Backend\accounts\migrations\0009_usermodulepermission_auditoria_choice.py
Backend\accounts\migrations\0010_user_deve_trocar_senha.py
```

A migration `0010` adicionou:

```text
User.deve_trocar_senha
```

Não editar migrations aplicadas.

Novas mudanças devem gerar nova migration.

---

# Accounts — Authentication

Arquivo:

```text
Backend\accounts\authentication.py
```

Componente principal:

```text
CompanyTokenAuthentication
```

Responsável por validar:

- cabeçalho de autenticação;
- token;
- hash;
- sessão;
- expiração;
- usuário;
- empresa;
- contrato;
- suspensão;
- troca obrigatória de senha.

Código de bloqueio da troca obrigatória:

```text
PASSWORD_CHANGE_REQUIRED
```

Mensagem:

```text
Você precisa alterar sua senha antes de continuar.
```

Caminhos conhecidos permitidos durante a troca obrigatória:

```text
/api/me/
/api/accounts/users/me/
/api/accounts/change-required-password/
/api/accounts/auth/logout/
/api/auth/logout/
/api/accounts/sessoes/heartbeat/
```

Antes de criar novo endpoint necessário nesse fluxo, revisar conscientemente essa lista.

---

# Accounts — Effective Access

Arquivo:

```text
Backend\accounts\services\effective_access.py
```

Serviço:

```text
EffectiveAccessService
```

Responsável por:

- verificar empresa;
- verificar contrato;
- verificar módulos;
- verificar perfil;
- verificar overrides;
- identificar master;
- identificar superusuário;
- calcular permissões efetivas;
- retornar contexto para `/api/me/`.

A permissão final não deve ser calculada independentemente no frontend.

---

# Accounts — Sessions

Arquivo:

```text
Backend\accounts\services\sessions.py
```

Serviço:

```text
ConcurrentSessionService
```

Responsabilidades:

- criar sessão;
- validar token;
- controlar limite simultâneo;
- substituir sessão do mesmo usuário e dispositivo;
- encerrar sessão;
- revogar token;
- fechar sessões expiradas;
- heartbeat;
- liberar licença;
- listar sessões válidas;
- calcular validade;
- centralizar a contagem.

Métodos centrais:

```text
ConcurrentSessionService.valid_sessions_queryset
ConcurrentSessionService.active_sessions_queryset
ConcurrentSessionService.count_active_sessions
ConcurrentSessionService.session_validity
ConcurrentSessionService.is_session_valid
```

Método de encerramento:

```text
close_session(...)
```

Pode possuir controle:

```text
audit=True
audit=False
```

`audit=False` só deve ser utilizado quando o fluxo registrar auditoria equivalente de forma explícita.

---

# Regra Central de Sessão Válida

Uma sessão ocupa licença quando atende aos critérios do serviço central, incluindo:

- `ativa=True`;
- `encerrada_em` nulo;
- sessão não expirada;
- usuário ativo;
- empresa válida;
- contrato válido;
- token existente;
- token não revogado.

A mesma regra deve ser utilizada por:

- login;
- bloqueio por limite;
- contador da empresa;
- quantidade disponível;
- heartbeat;
- listagem por empresa;
- listagem por usuário;
- encerramento;
- diagnóstico;
- reconciliação.

Não criar contagem paralela baseada somente em:

```python
SessaoUsuario.objects.filter(ativa=True)
```

---

# Login e Limite Simultâneo

O fluxo técnico deve manter:

```text
transaction.atomic
→ validação do usuário
→ validação do contrato
→ encerramento de expiradas
→ substituição do mesmo usuário e device_id
→ bloqueio do contrato
→ contagem de sessões válidas
→ verificação do limite
→ criação da sessão
→ criação do token
→ commit
```

Código de limite atingido:

```text
CONCURRENT_SESSION_LIMIT_REACHED
```

Login bloqueado não deve criar:

- sessão válida;
- token utilizável;
- contexto local de autenticação.

---

# Mesmo Dispositivo

## Mesmo Usuário

```text
mesmo usuário + mesmo device_id
→ substitui a sessão anterior
```

## Usuários Diferentes

```text
usuários diferentes + mesmo device_id
→ sessões independentes
```

Não substituir sessão apenas porque os usuários utilizaram o mesmo navegador.

---

# Logout

Arquivos principais:

```text
Backend\accounts\views.py
Backend\accounts\services\sessions.py
Frontend\sysvar\src\app\core\auth.service.ts
Frontend\sysvar\src\app\layout\shell\shell.component.ts
```

Ordem correta:

```text
frontend mantém o token
→ frontend chama o backend
→ backend identifica SessionToken
→ backend identifica SessaoUsuario
→ backend encerra a sessão
→ backend revoga o token
→ backend libera a vaga
→ backend registra Auditoria
→ frontend limpa o token
→ frontend interrompe o heartbeat
→ frontend redireciona
```

Não limpar o token antes da chamada ao backend.

Esse erro já ocorreu e foi corrigido.

---

# Superusuário e Licenciamento

O superusuário:

- cria sessão;
- cria token;
- permanece sem empresa cliente;
- não consome licença de empresa;
- não entra no contador da empresa;
- não aparece na listagem de sessões que ocupam licença.

Essa regra foi testada e homologada manualmente.

---

# Commands de Sessões

## Diagnóstico

Arquivo:

```text
Backend\accounts\management\commands\diagnosticar_sessoes_empresa.py
```

Execução:

```powershell
python manage.py diagnosticar_sessoes_empresa --empresa-id <id>
```

Pode apresentar:

- ID da sessão;
- usuário;
- device ID;
- estado;
- última atividade;
- token existente;
- token revogado;
- validade;
- motivo da não validade.

Não exibe token bruto.

## Reconciliação

Arquivo:

```text
Backend\accounts\management\commands\reconciliar_sessoes_ativas.py
```

Execução:

```powershell
python manage.py reconciliar_sessoes_ativas --empresa-id <id> --dry-run
python manage.py reconciliar_sessoes_ativas --empresa-id <id> --apply
```

O `dry-run` não altera dados.

O `apply`:

- preserva histórico;
- encerra sessões inválidas;
- revoga tokens restantes;
- não apaga registros.

---

# Accounts — Permissions

Arquivo:

```text
Backend\accounts\permissions.py
```

Responsabilidades:

- acesso aos usuários;
- acesso aos perfis;
- permissão por módulo;
- nível VIEW ou EDIT;
- master;
- superusuário;
- isolamento por empresa.

Perfis utilizam:

```text
operacional
```

em vez de depender exclusivamente de:

```text
configuracoes
```

Regra:

```text
GET, HEAD e OPTIONS
→ VIEW

POST, PUT, PATCH e DELETE
→ EDIT
```

Master e superusuário seguem regras próprias.

---

# Accounts — Serializers

Arquivo:

```text
Backend\accounts\serializers.py
```

Responsabilidades:

- validar empresa;
- validar perfil;
- validar estabelecimentos;
- aplicar overrides;
- retornar permissão efetiva;
- validar módulos disponíveis;
- validar dependências;
- proteger campos internos;
- tratar redefinição e troca de senha;
- serializar sessões.

## Dependências de Módulos

A validação utiliza:

```text
ModuloSistema.dependencias
```

Um módulo com acesso diferente de `NONE` não pode possuir dependência em `NONE`.

## HERDAR

Quando o frontend envia `HERDAR`, o backend deve remover o override correspondente.

Não persistir `HERDAR` como nível real do banco.

---

# Accounts — Views e Endpoints

Arquivo:

```text
Backend\accounts\views.py
```

Rotas:

```text
Backend\accounts\urls.py
```

Endpoints relevantes podem incluir:

```text
POST /api/accounts/auth/token/
POST /api/accounts/auth/logout/
GET  /api/me/
GET  /api/accounts/users/
GET  /api/accounts/users/{id}/
POST /api/accounts/users/{id}/ativar/
POST /api/accounts/users/{id}/inativar/
GET  /api/accounts/users/{id}/sessoes/
POST /api/accounts/users/{id}/encerrar-sessoes/
POST /api/accounts/users/{id}/redefinir-senha/
POST /api/accounts/change-required-password/
POST /api/accounts/sessoes/heartbeat/
POST /api/accounts/sessoes/{id}/encerrar/
```

Os caminhos exatos devem ser confirmados no arquivo de rotas antes de uso externo.

---

# Encerramento Individual de Sessão

Implementação principal:

```text
Backend\accounts\views.py
Backend\accounts\services\sessions.py
```

Fluxo:

```text
validar executor
→ validar empresa
→ localizar sessão
→ close_session
→ revogar token
→ liberar vaga
→ Auditoria
→ atualizar resposta
```

O frontend deve atualizar:

- listagem;
- contador;
- quantidade disponível.

---

# Encerramento Consolidado de Sessões

Implementação principal:

```text
Backend\accounts\views.py
Backend\accounts\services\sessions.py
```

Fluxo esperado:

```text
transaction.atomic
→ select_for_update no usuário
→ select_for_update nas sessões
→ close_session(audit=False)
→ revogação dos tokens
→ AuditService.required_success
→ commit
```

Evento consolidado:

```text
USER_SESSIONS_CLOSED
```

A resposta pode informar:

```text
sessoes_encerradas
```

Falha da Auditoria provoca rollback das sessões e tokens.

---

# Redefinição Administrativa de Senha

Implementação principal:

```text
Backend\accounts\views.py
Backend\accounts\serializers.py
```

Fluxo:

```text
bloqueia usuário
→ altera senha
→ deve_trocar_senha = true
→ encerra sessões
→ revoga tokens
→ auditoria obrigatória
→ commit
```

Evento:

```text
USER_PASSWORD_RESET
```

Não registrar senha.

---

# Troca Obrigatória de Senha

Implementação principal:

```text
Backend\accounts\authentication.py
Backend\accounts\views.py
Backend\accounts\serializers.py
Backend\accounts\urls.py
```

Endpoint:

```text
POST /api/accounts/change-required-password/
```

Payload:

```json
{
  "senha_atual": "...",
  "nova_senha": "...",
  "confirmacao": "..."
}
```

Fluxo:

- valida senha atual;
- valida nova senha;
- aplica validadores Django;
- limpa `deve_trocar_senha`;
- encerra outras sessões;
- mantém a sessão atual;
- registra `USER_PASSWORD_CHANGED`;
- libera o acesso aos módulos.

---

# Backend — Cadastros

Caminho:

```text
Backend\cadastros
```

Responsabilidades:

- empresas;
- contratos;
- módulos;
- estabelecimentos;
- clientes;
- fornecedores;
- funcionários;
- naturezas;
- planos;
- formas de pagamento;
- tabelas auxiliares.

Arquivos principais:

```text
Backend\cadastros\models.py
Backend\cadastros\serializers.py
Backend\cadastros\views.py
Backend\cadastros\urls.py
Backend\cadastros\tests.py
```

Commands:

```text
Backend\cadastros\management\commands
```

---

# Cadastros — Empresa e Contrato

Arquivo principal:

```text
Backend\cadastros\models.py
```

Entidades:

```text
Empresa
EmpresaContrato
ModuloSistema
EmpresaModulo
Loja
```

## EmpresaContrato

Campos relevantes:

- status;
- vigência;
- plano completo;
- master;
- limite de sessões;
- versão das permissões;
- motivo da suspensão;
- observação da suspensão;
- data da suspensão;
- responsável pela suspensão;
- data da reativação;
- responsável pela reativação.

Motivos de suspensão:

```text
INADIMPLENCIA
SOLICITACAO_CLIENTE
RISCO_SEGURANCA
ENCERRAMENTO_CONTRATO
BLOQUEIO_ADMINISTRATIVO
OUTRO
```

---

# Cadastros — Migrations do Operacional

Migrations relevantes:

```text
Backend\cadastros\migrations\0018_empresa_plano_completo_modulosistema_empresacontrato_and_more.py
Backend\cadastros\migrations\0020_modulo_auditoria.py
Backend\cadastros\migrations\0021_empresacontrato_motivo_suspensao_and_more.py
```

Existe migration posterior tornando:

```text
Loja.empresa
```

obrigatória.

Confirmar o nome exato no diretório antes de citar em script ou deploy.

Não editar migrations aplicadas.

---

# Diagnóstico de Estabelecimentos sem Empresa

Command:

```text
diagnosticar_lojas_sem_empresa
```

Execução:

```powershell
python manage.py diagnosticar_lojas_sem_empresa
```

Resultado executado durante o fechamento:

```text
lojas_sem_empresa=0
```

Nenhum saneamento foi necessário.

O campo `Loja.empresa` foi posteriormente tornado obrigatório.

---

# Cadastros — Suspensão e Reativação

Implementação principal:

```text
Backend\cadastros\views.py
Backend\cadastros\serializers.py
Backend\cadastros\models.py
```

Endpoints:

```text
POST /api/cadastros/empresas/{id}/suspender/
POST /api/cadastros/empresas/{id}/reativar/
```

Somente superusuário executa essas ações.

## Suspensão

```text
transaction.atomic
→ select_for_update no contrato
→ status SUSPENSO
→ motivo e observação
→ encerramento das sessões
→ revogação dos tokens
→ incremento de permissions_version
→ AuditService.required_success
→ commit
```

Código:

```text
CONTRACT_SUSPENDED
```

## Reativação

```text
transaction.atomic
→ select_for_update no contrato
→ status ATIVO
→ data e executor
→ incremento de permissions_version
→ Auditoria obrigatória
→ commit
```

Sessões antigas não são restauradas.

---

# Cadastros — Estabelecimentos

Model:

```text
Loja
```

Arquivos principais:

```text
Backend\cadastros\models.py
Backend\cadastros\serializers.py
Backend\cadastros\views.py
Backend\cadastros\urls.py
```

Tipos:

```text
LOJA
MATRIZ
FABRICA
```

Empresa:

```text
null=False
blank=False
```

O nome exato da ForeignKey e seus parâmetros devem ser verificados no model antes de nova alteração.

---

# Actions de Estabelecimento

Endpoints podem incluir:

```text
POST /api/cadastros/lojas/{id}/ativar/
POST /api/cadastros/lojas/{id}/inativar/
POST /api/cadastros/lojas/{id}/encerrar/
POST /api/cadastros/lojas/{id}/reabrir/
GET  /api/cadastros/lojas/{id}/usuarios/
GET  /api/cadastros/lojas/indicadores/
```

Confirmar os caminhos exatos no router.

Responsabilidades:

- ciclo de vida;
- impedimentos;
- usuários vinculados;
- indicadores;
- isolamento por empresa;
- isolamento por estabelecimento;
- permissão operacional.

---

# Sessions da Empresa

Implementação envolve:

```text
Backend\cadastros\views.py
Backend\accounts\services\sessions.py
Backend\accounts\serializers.py
```

A tela de Empresas utiliza:

```text
Ver Sessões
```

O endpoint deve retornar somente sessões válidas que ocupam licença da empresa.

A regra obrigatória é:

```text
contador da empresa
=
quantidade de sessões válidas retornadas
```

Superusuário não aparece nessa lista.

---

# Backend — Auditoria

Caminho:

```text
Backend\auditoria
```

Arquivos principais:

```text
Backend\auditoria\models.py
Backend\auditoria\services.py
Backend\auditoria\middleware.py
Backend\auditoria\signals.py
Backend\auditoria\views.py
Backend\auditoria\serializers.py
Backend\auditoria\urls.py
Backend\auditoria\display.py
Backend\auditoria\tests.py
```

Componentes:

```text
AuditLog
AuditService
AuditContextMiddleware
AuditAction
AuditCategory
AuditResult
AuditSeverity
AuditOrigin
```

---

# Ações de Auditoria do Operacional

## Contratos

```text
CONTRACT_SUSPENDED
CONTRACT_REACTIVATED
CONTRACT_SUSPENSION_DENIED
CONTRACT_REACTIVATION_DENIED
```

## Estabelecimentos

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

## Usuários e Senhas

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

## Sessões

```text
USER_LOGIN
USER_LOGOUT
SESSION_REPLACED
SESSION_CLOSED
SESSION_TIMEOUT
SESSION_LIMIT_REACHED
```

Os nomes exatos devem ser confirmados no catálogo real:

```text
Backend\auditoria\models.py
```

Ação não cadastrada gera erro de validação.

---

# Auditoria Obrigatória no Operacional

Operações principais:

- suspensão;
- reativação;
- redefinição de senha;
- troca obrigatória de senha;
- encerramento consolidado de sessões;
- perfil padrão;
- alteração de permissão;
- transferência de master;
- exclusão administrativa.

Método principal:

```text
AuditService.required_success(...)
```

A chamada deve ocorrer dentro da mesma transação da operação principal.

---

# Frontend — Estrutura Central

Caminho:

```text
Frontend\sysvar\src\app
```

Arquivos centrais:

```text
src\app\app.routes.ts
src\app\layout\shell\shell.component.ts
src\app\core\auth.service.ts
src\app\core\permission.service.ts
src\app\core\services\access-control.service.ts
```

Os caminhos devem ser confirmados antes de editar.

---

# Frontend — Auth Service

Arquivo principal:

```text
Frontend\sysvar\src\app\core\auth.service.ts
```

Responsabilidades:

- login;
- logout;
- token;
- contexto do usuário;
- sessão;
- heartbeat;
- troca obrigatória de senha;
- limpeza do contexto;
- comunicação entre abas.

No logout:

- chamar o backend antes de limpar o token;
- aguardar a resposta;
- interromper heartbeat;
- limpar contexto;
- redirecionar.

---

# Frontend — Shell

Arquivo:

```text
Frontend\sysvar\src\app\layout\shell\shell.component.ts
```

Responsabilidades:

- menu lateral;
- ações globais;
- logout;
- exibição por permissão;
- agrupamento do Operacional.

Não implementar logout paralelo no Shell.

O Shell deve delegar ao `AuthService`.

---

# Frontend — Empresas

Caminho:

```text
Frontend\sysvar\src\app\features\empresas
```

Service relacionado:

```text
Frontend\sysvar\src\app\core\services\empresas.service.ts
```

Responsabilidades:

- listar empresas;
- consultar contrato;
- mostrar status;
- mostrar limite;
- mostrar sessões ativas;
- mostrar acessos disponíveis;
- suspender;
- reativar;
- abrir `Ver Sessões`;
- encerrar sessão;
- controlar ações por superusuário.

Métodos podem incluir:

```text
suspender
reativar
listarSessoes
encerrarSessao
```

Confirmar os nomes atuais no código.

---

# Modal Ver Sessões

A implementação está relacionada à feature Empresas.

Responsabilidades:

- carregar sessões válidas;
- tratar resposta direta;
- tratar resposta paginada;
- exibir somente as linhas retornadas;
- comparar contador e quantidade de linhas;
- mostrar estado vazio correto;
- permitir encerramento;
- atualizar indicadores.

Formatos esperados:

```json
[
  {}
]
```

ou:

```json
{
  "count": 1,
  "results": [
    {}
  ]
}
```

A normalização deve ficar no service.

Não espalhar tratamento no componente.

---

# Frontend — Estabelecimentos

Caminho:

```text
Frontend\sysvar\src\app\features\lojas
```

Service:

```text
Frontend\sysvar\src\app\core\services\lojas.service.ts
```

Responsabilidades:

- paginação;
- filtros;
- indicadores;
- formulário;
- ativação;
- inativação;
- encerramento;
- reabertura;
- usuários vinculados;
- permissão VIEW e EDIT.

A rota não deve depender obrigatoriamente de:

```text
Diretor
Gerente
```

O acesso utiliza:

```text
moduloEmpresa: operacional
```

---

# Frontend — Usuários

Caminho:

```text
Frontend\sysvar\src\app\features\usuarios
```

Service relacionado:

```text
Frontend\sysvar\src\app\core\services\users.service.ts
```

Responsabilidades:

- listagem;
- paginação;
- indicadores;
- perfil principal;
- tipo funcional;
- estabelecimento principal;
- estabelecimentos permitidos;
- matriz Perfil/Override/Efetivo;
- sessões;
- redefinição de senha;
- ativação;
- inativação;
- encerramento das sessões.

Métodos podem incluir:

```text
listarSessoes
encerrarSessao
encerrarSessoes
redefinirSenha
```

Confirmar os nomes atuais no arquivo real.

---

# Frontend — Perfis de Acesso

Caminho:

```text
Frontend\sysvar\src\app\features\perfis-acesso
```

A rota utiliza:

```text
moduloEmpresa: operacional
```

Não deve depender exclusivamente de:

```text
roles: ['Admin']
```

Responsabilidades:

- listar perfis;
- criar;
- editar;
- inativar;
- definir padrão;
- carregar módulos do backend;
- apresentar dependências;
- configurar NONE, VIEW e EDIT.

---

# Frontend — Troca Obrigatória de Senha

Local relacionado:

```text
Frontend\sysvar\src\app\features\change-password-required
```

Rota:

```text
/change-password-required
```

Arquivos esperados:

```text
change-password-required.component.ts
change-password-required.component.html
change-password-required.component.css
change-password-required.component.spec.ts
```

Responsabilidades:

- senha atual;
- nova senha;
- confirmação;
- validação;
- chamada ao backend;
- atualização de `/api/me/`;
- liberação do sistema.

---

# Frontend — Guard de Troca de Senha

Localizar em:

```text
Frontend\sysvar\src\app\core
Frontend\sysvar\src\app\guards
```

O guard deve:

- permitir a rota de troca;
- permitir logout;
- redirecionar outras rotas;
- não criar loop;
- consultar o contexto de autenticação.

O backend continua sendo a autoridade final.

---

# Frontend — Interceptor

O interceptor deve tratar códigos específicos.

Principais:

```text
CONTRACT_SUSPENDED
PASSWORD_CHANGE_REQUIRED
CONCURRENT_SESSION_LIMIT_REACHED
```

Não tratar todos os erros 403 da mesma forma.

## CONTRACT_SUSPENDED

Deve:

- limpar sessão local;
- interromper heartbeat;
- direcionar ao login;
- mostrar mensagem segura.

## PASSWORD_CHANGE_REQUIRED

Deve:

- preservar a sessão;
- direcionar para troca obrigatória;
- não executar logout automático.

## CONCURRENT_SESSION_LIMIT_REACHED

Deve:

- permanecer na tela de login;
- não salvar token;
- não salvar sessão;
- não iniciar heartbeat;
- exibir mensagem de limite.

---

# Frontend — Rotas do Operacional

Arquivo:

```text
Frontend\sysvar\src\app\app.routes.ts
```

Rotas principais:

```text
/empresas
/lojas
/usuarios
/config/perfis
/config/auditoria
/change-password-required
```

Os caminhos exatos devem ser confirmados no arquivo.

## Empresas

```text
operacional
```

Ações críticas somente para superusuário.

## Estabelecimentos

```text
operacional
```

Sem bloqueio exclusivo por roles antigas.

## Usuários

```text
operacional
```

## Perfis

```text
operacional
```

## Auditoria

```text
auditoria
```

---

# Frontend — Menu Lateral

Arquivo:

```text
Frontend\sysvar\src\app\layout\shell\shell.component.ts
```

Grupo:

```text
Operacional
```

Itens:

- Empresas;
- Estabelecimento;
- Usuários;
- Perfis de acesso;
- Auditoria.

A exibição deve utilizar permissões efetivas.

Não reintroduzir listas baseadas somente em tipo funcional.

---

# Testes Backend

Arquivos principais:

```text
Backend\accounts\tests.py
Backend\cadastros\tests.py
Backend\auditoria\tests.py
```

Cobertura adicionada:

- contrato suspenso;
- login bloqueado;
- login acima do limite;
- login bloqueado sem sessão fantasma;
- logout;
- liberação de vaga;
- substituição no mesmo dispositivo;
- usuários diferentes no mesmo dispositivo;
- superusuário sem consumo de licença;
- sessão revogada;
- contador central;
- sessões por empresa;
- sessões por usuário;
- encerramento individual;
- encerramento consolidado;
- rollback de sessões;
- redefinição de senha;
- rollback da redefinição;
- troca obrigatória;
- bloqueio de endpoints;
- liberação após troca;
- dependências de módulos;
- empresa obrigatória em Loja;
- permissões do Operacional;
- Auditoria.

Rodada registrada durante a centralização:

```text
59 testes backend aprovados
```

Testes posteriores foram adicionados.

O total atual deve ser confirmado executando a suíte.

---

# Testes Frontend

Arquivos relevantes incluem:

```text
src\app\app.routes.spec.ts
src\app\core\permission.service.spec.ts
src\app\core\auth.service.spec.ts
src\app\features\auditoria\auditoria.component.spec.ts
```

Também foram adicionados ou ampliados testes para:

- rotas do Operacional;
- Estabelecimentos sem roles antigas;
- Perfis usando Operacional;
- troca obrigatória de senha;
- guard;
- componente de alteração;
- tratamento dos códigos de erro;
- permissões visuais;
- logout antes da limpeza local;
- superusuário;
- modal `Ver Sessões`;
- resposta em array;
- resposta paginada;
- contador;
- estado vazio;
- encerramento e atualização.

Rodada registrada durante a centralização:

```text
37 testes frontend aprovados
```

Testes posteriores foram adicionados.

O total atual deve ser confirmado executando a suíte.

---

# Comandos de Validação

## Backend

```powershell
cd C:\SysvarProjeto\Backend

python manage.py check
python manage.py makemigrations --check --dry-run
python manage.py migrate
python manage.py diagnosticar_lojas_sem_empresa
python manage.py diagnosticar_sessoes_empresa --empresa-id <id>
python manage.py reconciliar_sessoes_ativas --empresa-id <id> --dry-run
python manage.py test accounts -v 2 --noinput
python manage.py test cadastros -v 2 --noinput
python manage.py test auditoria -v 2 --noinput
python manage.py test -v 2 --noinput
```

Não afirmar que os testes passaram sem executar.

## Frontend

```powershell
cd C:\SysvarProjeto\Frontend\sysvar

npx tsc -p tsconfig.app.json --noEmit
ng build --configuration development
ng test --watch=false --browsers=ChromeHeadless
```

Não afirmar que os testes passaram sem executar.

---

# Homologação Manual Concluída

## Licenciamento

Foi validado:

- primeiro usuário logado;
- segundo usuário logado;
- bloqueio do terceiro acesso;
- logout liberando vaga;
- novo login após liberação;
- contador correto;
- quantidade disponível correta.

## Superusuário

Foi validado:

- superusuário logado;
- contador da empresa em zero sem usuário cliente;
- superusuário fora da listagem de licenças.

## Modal Ver Sessões

Foi validado:

- contador com uma sessão;
- modal com uma linha;
- ausência de divergência falsa;
- ausência de estado vazio indevido;
- sessão identificada corretamente;
- controle de sessões funcionando.

Status:

```text
OPERACIONAL HOMOLOGADO
```

---

# Onde Mexer por Funcionalidade

## Suspensão da Empresa

Backend:

```text
cadastros\models.py
cadastros\serializers.py
cadastros\views.py
accounts\authentication.py
accounts\services\sessions.py
auditoria\models.py
auditoria\services.py
```

Frontend:

```text
features\empresas
core\services\empresas.service.ts
interceptor
auth service
```

## Estabelecimentos

Backend:

```text
cadastros\models.py
cadastros\serializers.py
cadastros\views.py
cadastros\urls.py
cadastros\tests.py
```

Frontend:

```text
features\lojas
core\services\lojas.service.ts
app.routes.ts
layout\shell
```

## Usuários

Backend:

```text
accounts\models.py
accounts\serializers.py
accounts\views.py
accounts\permissions.py
accounts\tests.py
```

Frontend:

```text
features\usuarios
core\services\users.service.ts
permission service
auth service
```

## Perfis

Backend:

```text
accounts\models.py
accounts\serializers.py
accounts\permissions.py
accounts\services\effective_access.py
```

Frontend:

```text
features\perfis-acesso
app.routes.ts
permission service
```

## Sessões

Backend:

```text
accounts\models.py
accounts\views.py
accounts\serializers.py
accounts\services\sessions.py
accounts\management\commands
cadastros\views.py
auditoria\services.py
```

Frontend:

```text
core\auth.service.ts
layout\shell\shell.component.ts
features\empresas
features\usuarios
core\services\empresas.service.ts
core\services\users.service.ts
```

## Senhas

Backend:

```text
accounts\authentication.py
accounts\serializers.py
accounts\views.py
accounts\urls.py
accounts\tests.py
```

Frontend:

```text
features\change-password-required
guards
interceptors
auth service
app.routes.ts
```

## Auditoria

Backend:

```text
auditoria\models.py
auditoria\services.py
auditoria\middleware.py
auditoria\signals.py
auditoria\views.py
auditoria\tests.py
```

Frontend:

```text
features\auditoria
core\models\audit.ts
core\services\audit.service.ts
```

---

# Próxima Área Técnica

A revisão seguirá para:

```text
Cadastros
```

Primeiros itens:

```text
Clientes
Fornecedores
Funcionários
```

Apps e arquivos que provavelmente serão envolvidos:

```text
Backend\cadastros
Backend\auditoria
Frontend\sysvar\src\app\features
Frontend\sysvar\src\app\core\services
Frontend\sysvar\src\app\app.routes.ts
Frontend\sysvar\src\app\layout\shell
```

Antes de criar qualquer prompt:

1. conferir a ordem real do menu;
2. localizar componentes reais;
3. verificar models;
4. verificar serializers;
5. verificar views;
6. verificar endpoints;
7. verificar isolamento;
8. verificar permissões;
9. verificar paginação;
10. verificar Auditoria;
11. verificar testes existentes;
12. levantar melhorias funcionais;
13. registrar riscos;
14. somente depois preparar o prompt para o Codex.

---

# Última Atualização

```text
2026-08-06
```

---

# Notas Relacionadas

- [[10 Projetos/Sysvar/Sysvar|Sysvar]]
- [[10 Projetos/Sysvar/Contexto do Projeto/Visão Geral|Visão Geral]]
- [[10 Projetos/Sysvar/Contexto do Projeto/Arquitetura|Arquitetura]]
- [[10 Projetos/Sysvar/Contexto do Projeto/Modelo de Domínio|Modelo de Domínio]]
- [[10 Projetos/Sysvar/Contexto do Projeto/Workflows|Workflows]]
- [[10 Projetos/Sysvar/Contexto do Projeto/Riscos e Cuidados|Riscos e Cuidados]]
- [[10 Projetos/Sysvar/Decisões Técnicas/ADR-001 - Licenciamento por Sessões Simultâneas|ADR-001 - Licenciamento por Sessões Simultâneas]]
- [[10 Projetos/Sysvar/Decisões Técnicas/ADR-002 - Princípios Arquiteturais do SISVAR|ADR-002 - Princípios Arquiteturais do SISVAR]]
- [[10 Projetos/Sysvar/Decisões Técnicas/ADR-003 - Auditoria Central do SISVAR|ADR-003 - Auditoria Central do SISVAR]]