---

type: reference  
status: active  
project: Sysvar  
source: "C:/SysvarProjeto"  
created: 2026-08-03  
updated: 2026-08-05  
tags:

- sysvar
    
- contexto
    
- mapa-tecnico
    
- backend
    
- frontend
    
- operacional
    
- auditoria
    

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
    
7. verificar impacto na Auditoria.
    

---

# Estrutura local

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

# Tecnologias

## Backend

- Python
    
- Django
    
- Django REST Framework
    
- MySQL
    

## Frontend

- Angular 17 Standalone
    
- TypeScript
    

## Versionamento

- Git
    
- GitHub
    

## Documentação

- Obsidian
    
- Markdown
    

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

Arquivos frontend principais:

```text
features\empresas
features\lojas
features\usuarios
features\perfis-acesso
features\auditoria
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
    
- acesso efetivo.
    

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

Responsabilidades e campos relevantes:

- empresa;
    
- perfil principal;
    
- tipo funcional;
    
- loja principal;
    
- lojas permitidas;
    
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
    
- loja;
    
- dispositivo;
    
- início;
    
- última atividade;
    
- encerramento;
    
- motivo;
    
- situação ativa.
    

## SessionToken

Responsável pelo token vinculado à sessão.

O token bruto não é persistido.

---

# Accounts — Migrations

Migrations relevantes da infraestrutura:

```text
Backend\accounts\migrations\0006_...
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

Lista de caminhos permitidos durante a troca obrigatória é centralizada nesse arquivo.

Caminhos conhecidos:

```text
/api/me/
/api/accounts/users/me/
/api/accounts/change-required-password/
/api/accounts/auth/logout/
/api/auth/logout/
/api/accounts/sessoes/heartbeat/
```

Antes de criar novos endpoints necessários durante esse fluxo, atualizar essa lista conscientemente.

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
    
- calcular permissões efetivas;
    
- retornar contexto para `/api/me/`.
    

A permissão final não deve ser calculada de forma independente no frontend.

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
    
- substituir sessão do mesmo dispositivo;
    
- encerrar sessão;
    
- revogar token;
    
- fechar sessões expiradas;
    
- heartbeat;
    
- liberar licença.
    

Método de encerramento:

```text
close_session(...)
```

Possui controle:

```text
audit=True ou audit=False
```

Esse parâmetro permite evitar eventos individuais duplicados quando uma operação em massa gera um evento consolidado.

Não utilizar `audit=False` fora de um fluxo que registre auditoria equivalente de forma explícita.

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
    

Perfis passaram a utilizar:

```text
operacional
```

em vez de depender do módulo:

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
    
- validar lojas;
    
- aplicar overrides;
    
- retornar permissão efetiva;
    
- validar módulos disponíveis;
    
- validar dependências;
    
- proteger campos internos;
    
- tratar redefinição e troca de senha.
    

## Dependências de módulos

A validação utiliza:

```text
ModuloSistema.dependencias
```

Um módulo com acesso diferente de `NONE` não pode possuir dependência em `NONE`.

## HERDAR

Quando o frontend envia `HERDAR`, o backend deve remover o override correspondente.

Não persistir `HERDAR` como um nível real do banco.

---

# Accounts — Views e Endpoints

Arquivo:

```text
Backend\accounts\views.py
```

Rotas registradas em:

```text
Backend\accounts\urls.py
```

Endpoints relevantes incluem:

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

A resposta informa:

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

Existe também migration posterior do fechamento final tornando:

```text
Loja.empresa
```

obrigatória.

Confirmar o nome exato dessa migration no diretório antes de referenciá-la em scripts ou deploys.

Não editar migrations aplicadas.

---

# Diagnóstico de Lojas sem Empresa

Command criado no backend:

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

Fluxo técnico:

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

Código de bloqueio:

```text
CONTRACT_SUSPENDED
```

## Reativação

Fluxo:

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

Endpoints implementados:

```text
POST /api/cadastros/lojas/{id}/ativar/
POST /api/cadastros/lojas/{id}/inativar/
POST /api/cadastros/lojas/{id}/encerrar/
POST /api/cadastros/lojas/{id}/reabrir/
GET  /api/cadastros/lojas/{id}/usuarios/
GET  /api/cadastros/lojas/indicadores/
```

Confirmar os caminhos exatos em `cadastros/urls.py` e no router.

Responsabilidades:

- ciclo de vida;
    
- impedimentos;
    
- usuários vinculados;
    
- indicadores;
    
- isolamento por empresa;
    
- isolamento por loja;
    
- permissão operacional.
    

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

Antes de adicionar nova ação, confirmar o catálogo real em:

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

Os caminhos reais devem ser confirmados antes de editar, pois alguns services podem estar organizados em subpastas diferentes.

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

Responsabilidades da tela:

- listar empresas;
    
- consultar contrato;
    
- mostrar status;
    
- mostrar sessões ativas;
    
- suspender;
    
- reativar;
    
- controlar ações por superusuário;
    
- impedir master e usuário comum de executar ações comerciais.
    

Métodos esperados no service:

```text
suspender
reativar
```

Confirmar os nomes reais antes de reutilizar.

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
    

A rota não deve conter dependência obrigatória de:

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

Services relacionados:

```text
Frontend\sysvar\src\app\core\services\users.service.ts
```

Responsabilidades:

- listagem;
    
- paginação;
    
- indicadores;
    
- perfil principal;
    
- tipo funcional;
    
- loja principal;
    
- lojas permitidas;
    
- matriz Perfil/Override/Efetivo;
    
- sessões;
    
- redefinição de senha;
    
- ativação;
    
- inativação;
    
- encerramento das sessões.
    

Métodos esperados:

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

Feature criada para o fluxo obrigatório.

Localizar em:

```text
Frontend\sysvar\src\app\features
```

Nome relacionado:

```text
change-password-required
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

Confirmar o caminho exato no repositório antes de editar.

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

Guard central criado para impedir acesso aos módulos enquanto:

```text
deve_trocar_senha = true
```

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

Regras:

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

Cobertura adicionada no fechamento:

- contrato suspenso;
    
- login bloqueado;
    
- encerramento de sessões;
    
- rollback de sessões;
    
- evento consolidado;
    
- redefinição de senha;
    
- rollback da redefinição;
    
- troca obrigatória;
    
- bloqueio de endpoints;
    
- liberação após troca;
    
- rollback da troca;
    
- dependências de módulos;
    
- empresa obrigatória em Loja;
    
- permissões do Operacional.
    

Resultado final informado:

```text
50 testes backend aprovados
```

---

# Testes Frontend

Arquivos relevantes incluem:

```text
src\app\app.routes.spec.ts
src\app\core\permission.service.spec.ts
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
    
- permissões visuais.
    

Resultado final informado:

```text
33 testes frontend aprovados
```

Confirmar os nomes exatos dos novos arquivos no repositório antes de alterá-los.

---

# Comandos de Validação

## Backend

```powershell
cd C:\SysvarProjeto\Backend

python manage.py check
python manage.py makemigrations --check --dry-run
python manage.py migrate
python manage.py diagnosticar_lojas_sem_empresa
python manage.py test accounts -v 2 --noinput
python manage.py test cadastros -v 2 --noinput
python manage.py test auditoria -v 2 --noinput
python manage.py test -v 2 --noinput
```

Resultado final:

```text
50 testes aprovados
```

## Frontend

```powershell
cd C:\SysvarProjeto\Frontend\sysvar

npx tsc -p tsconfig.app.json --noEmit
ng build --configuration development
ng test --watch=false --browsers=ChromeHeadless
```

Resultado final:

```text
33 testes aprovados
```

Não afirmar que passaram sem executar.

---

# Homologação Manual Pendente

A implementação técnica está concluída.

Ainda precisa ser validado no navegador:

## Suspensão

- duas sessões abertas;
    
- suspensão;
    
- queda das sessões;
    
- tokens inválidos;
    
- login bloqueado;
    
- reativação;
    
- novo login.
    

## Troca de senha

- redefinição administrativa;
    
- login com senha temporária;
    
- redirecionamento;
    
- bloqueio de `/home`;
    
- alteração;
    
- liberação;
    
- sessão atual mantida;
    
- demais sessões encerradas.
    

## Estabelecimentos

- VIEW;
    
- EDIT;
    
- master;
    
- superusuário;
    
- criar;
    
- inativar;
    
- encerrar;
    
- reabrir.
    

## Usuários e Perfis

- perfil;
    
- HERDAR;
    
- override;
    
- efetivo;
    
- dependência;
    
- sessões;
    
- eventos de Auditoria.
    

Status correto:

```text
Implementado
Validado automaticamente
Homologação manual pendente
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

Após a homologação manual do Operacional, a revisão seguirá para:

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
Frontend\sysvar\src\app\features
Frontend\sysvar\src\app\core\services
Backend\auditoria
```

Antes de criar qualquer prompt:

1. conferir a ordem real do menu;
    
2. localizar componentes reais;
    
3. verificar models e serializers;
    
4. verificar isolamento;
    
5. verificar permissões;
    
6. verificar paginação;
    
7. verificar Auditoria;
    
8. verificar testes existentes.
    

---

# Última Atualização

```text
2026-08-05
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