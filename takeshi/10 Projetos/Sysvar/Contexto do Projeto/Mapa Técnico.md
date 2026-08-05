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
    
- componentes frontend;
    
- testes;
    
- infraestrutura transversal.
    

Este arquivo não substitui a leitura do código real.

Antes de implementar uma alteração, os arquivos indicados devem ser abertos e analisados.

---

# Estrutura local

Projeto principal:

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

Vault do Obsidian:

```text
C:\takeshi\takeshi
```

Documentação existente no projeto:

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

Arquivo principal:

```text
Backend\manage.py
```

Projeto Django:

```text
Backend\Varejo
```

Configurações:

```text
Backend\Varejo\settings.py
```

Rotas principais:

```text
Backend\Varejo\urls.py
```

Dependências:

```text
Backend\requirements.txt
```

---

## Frontend

Raiz:

```text
Frontend\sysvar
```

Pacote:

```text
Frontend\sysvar\package.json
```

Código-fonte:

```text
Frontend\sysvar\src\app
```

Rotas:

```text
Frontend\sysvar\src\app\app.routes.ts
```

Layout principal:

```text
Frontend\sysvar\src\app\layout\shell
```

---

# Apps principais do backend

## Accounts

Caminho:

```text
Backend\accounts
```

Responsabilidades:

- usuários;
    
- autenticação;
    
- perfis;
    
- permissões;
    
- sessões;
    
- tokens;
    
- licenciamento;
    
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
```

Services principais:

```text
Backend\accounts\services\effective_access.py
Backend\accounts\services\sessions.py
```

Migrations relevantes:

```text
Backend\accounts\migrations\0006_...
Backend\accounts\migrations\0009_usermodulepermission_auditoria_choice.py
```

Testes:

```text
Backend\accounts\tests.py
```

---

## Cadastros

Caminho:

```text
Backend\cadastros
```

Responsabilidades:

- empresas;
    
- contratos;
    
- módulos;
    
- lojas;
    
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
```

Migrations estruturais recentes:

```text
Backend\cadastros\migrations\0018_empresa_plano_completo_modulosistema_empresacontrato_and_more.py
Backend\cadastros\migrations\0020_modulo_auditoria.py
```

---

## Auditoria

Caminho:

```text
Backend\auditoria
```

Responsabilidades:

- infraestrutura central de auditoria;
    
- model imutável;
    
- contexto da requisição;
    
- sanitização;
    
- snapshots;
    
- registry;
    
- signals controlados;
    
- consulta;
    
- indicadores;
    
- exportação CSV;
    
- isolamento por empresa e loja.
    

Arquivos principais:

```text
Backend\auditoria\models.py
Backend\auditoria\services.py
Backend\auditoria\middleware.py
Backend\auditoria\signals.py
Backend\auditoria\views.py
Backend\auditoria\serializers.py
Backend\auditoria\urls.py
Backend\auditoria\apps.py
Backend\auditoria\display.py
Backend\auditoria\tests.py
```

Arquivos auxiliares existentes podem incluir:

```text
Backend\auditoria\utils.py
```

O código novo deve preferir o contexto e o serviço central atuais.

Não criar outro mecanismo paralelo.

---

## Produto

Caminho:

```text
Backend\produto
```

Responsabilidades:

- produtos;
    
- SKUs;
    
- grades;
    
- tamanhos;
    
- cores;
    
- coleções;
    
- grupos;
    
- subgrupos;
    
- NCM;
    
- unidades;
    
- tabelas de preço;
    
- packs;
    
- estoque relacionado ao produto;
    
- ficha técnica e produção quando implementadas nesse domínio.
    

Arquivos principais:

```text
Backend\produto\models.py
Backend\produto\serializers.py
Backend\produto\views.py
Backend\produto\urls.py
```

---

## Compras

Caminho:

```text
Backend\compras
```

Responsabilidades:

- pedidos de compra;
    
- itens;
    
- packs;
    
- parcelas;
    
- aprovação;
    
- cancelamento;
    
- reabertura;
    
- recebimento;
    
- futuras entradas de nota.
    

Arquivos principais:

```text
Backend\compras\models.py
Backend\compras\serializers.py
Backend\compras\views.py
Backend\compras\urls.py
```

---

## Financeiro

Caminho:

```text
Backend\financeiro
```

Responsabilidades:

- contas a pagar;
    
- contas a receber;
    
- parcelas;
    
- baixas;
    
- cancelamentos;
    
- reaberturas;
    
- caixa;
    
- bancos;
    
- rateios;
    
- plano financeiro;
    
- integração contábil.
    

Arquivos principais:

```text
Backend\financeiro\models.py
Backend\financeiro\serializers.py
Backend\financeiro\views.py
Backend\financeiro\urls.py
```

---

## Fiscal

Caminho:

```text
Backend\fiscal
```

Responsabilidades:

- documentos fiscais;
    
- NFC-e;
    
- NF-e;
    
- emissão;
    
- rejeições;
    
- integrações fiscais;
    
- devoluções fiscais;
    
- contingência.
    

Arquivos principais:

```text
Backend\fiscal\models.py
Backend\fiscal\serializers.py
Backend\fiscal\views.py
Backend\fiscal\urls.py
```

---

## Distribuição

Caminho:

```text
Backend\distribuicao
```

Responsabilidades:

- distribuição entre origem e lojas;
    
- perfis percentuais;
    
- alocações;
    
- transferências;
    
- pedidos por loja;
    
- integração futura com estoque e fiscal.
    

Arquivos principais:

```text
Backend\distribuicao\models.py
Backend\distribuicao\serializers.py
Backend\distribuicao\views.py
Backend\distribuicao\urls.py
```

---

## Dashboard

Caminho:

```text
Backend\dashboard
```

Responsabilidades:

- indicadores;
    
- consolidações;
    
- consultas gerenciais;
    
- dashboards.
    

Arquivos principais:

```text
Backend\dashboard\views.py
Backend\dashboard\urls.py
```

Outros arquivos devem ser confirmados no código antes de alteração.

---

# Rotas backend principais

Prefixos conhecidos:

```text
/api/accounts/
/api/cadastros/
/api/auditoria/
/api/produto/
/api/financeiro/
/api/compras/
/api/fiscal/
/api/distribuicao/
/api/dashboard/
/api/docs/
/api/redoc/
```

Antes de alterar uma rota, verificar:

- `Varejo\urls.py`;
    
- `urls.py` do app;
    
- chamadas do frontend;
    
- testes;
    
- documentação.
    

---

# Infraestrutura de autenticação

## Autenticação da requisição

Arquivo principal:

```text
Backend\accounts\authentication.py
```

Responsável por validar:

- token;
    
- hash;
    
- sessão;
    
- expiração;
    
- usuário;
    
- empresa;
    
- contrato.
    

---

## Acesso efetivo

Arquivo principal:

```text
Backend\accounts\services\effective_access.py
```

Responsável por:

- contrato;
    
- módulos;
    
- perfil;
    
- overrides;
    
- master;
    
- permissões efetivas;
    
- contexto retornado por `/api/me/`.
    

Chamadas legadas de auditoria devem delegar ao `AuditService`.

---

## Sessões e licenciamento

Arquivo principal:

```text
Backend\accounts\services\sessions.py
```

Responsável por:

- login;
    
- criação de sessão;
    
- limite simultâneo;
    
- substituição por dispositivo;
    
- logout;
    
- timeout;
    
- encerramento;
    
- heartbeat;
    
- auditoria dos eventos de sessão.
    

---

# Infraestrutura da Auditoria Central

## Model

Arquivo:

```text
Backend\auditoria\models.py
```

Contém:

- `AuditLog`;
    
- enums;
    
- catálogo de ações;
    
- manager;
    
- queryset;
    
- regras de imutabilidade;
    
- índices.
    

Classificações centrais:

```text
AuditCategory
AuditResult
AuditSeverity
AuditOrigin
AuditAction
```

---

## Serviço central

Arquivo:

```text
Backend\auditoria\services.py
```

Serviço:

```text
AuditService
```

Responsabilidades:

- registrar eventos;
    
- validar ações;
    
- validar enums;
    
- resolver contexto;
    
- resolver empresa;
    
- resolver loja;
    
- snapshots;
    
- sanitização;
    
- truncamento;
    
- eventos após commit;
    
- auditoria obrigatória;
    
- falhas;
    
- acessos negados.
    

Métodos existentes devem ser conferidos diretamente no arquivo antes de uso.

Métodos conhecidos incluem:

```text
record
success
failure
denied
security
on_commit
required
required_success
```

---

## Middleware

Arquivo:

```text
Backend\auditoria\middleware.py
```

Componente:

```text
AuditContextMiddleware
```

Responsável por:

- request ID;
    
- correlation ID;
    
- usuário;
    
- empresa;
    
- loja;
    
- sessão;
    
- device ID;
    
- IP;
    
- user-agent;
    
- método;
    
- endpoint;
    
- limpeza do contexto.
    

Headers:

```text
X-Request-ID
X-Correlation-ID
```

Confirmar registro em:

```text
Backend\Varejo\settings.py
```

---

## Display helpers

Arquivo:

```text
Backend\auditoria\display.py
```

Responsável por obter nomes históricos e representações de:

- empresa;
    
- loja;
    
- usuário.
    

Prioridades atuais informadas:

Empresa:

```text
nome_fantasia
nome
string representation
```

Loja:

```text
nome_loja
apelido_loja
string representation
```

Usuário:

```text
nome completo
username
email
```

Sempre conferir os campos reais antes de alterar o helper.

---

## Registry e signals

Arquivo:

```text
Backend\auditoria\signals.py
```

Responsabilidades:

- registry de models;
    
- CRUD simples;
    
- captura de estado anterior;
    
- captura de estado posterior;
    
- encaminhamento ao `AuditService`.
    

Não utilizar signals como única solução para ações de negócio.

---

## API

Arquivos:

```text
Backend\auditoria\views.py
Backend\auditoria\serializers.py
Backend\auditoria\urls.py
```

Endpoints:

```text
GET /api/auditoria/logs/
GET /api/auditoria/logs/{id}/
GET /api/auditoria/logs/indicadores/
GET /api/auditoria/logs/exportar/
```

A API é somente leitura.

Não existem endpoints de:

```text
POST
PUT
PATCH
DELETE
```

---

## Migrations da Auditoria

Migrations estruturais principais:

```text
Backend\auditoria\migrations\0004_central_audit_phase1.py
Backend\auditoria\migrations\0005_backfill_historical_context.py
```

A `0004`:

- amplia o model;
    
- preserva `changes`;
    
- cria campos;
    
- cria índices;
    
- migra dados legados quando possível.
    

A `0005`:

- recupera empresa;
    
- recupera loja;
    
- recupera snapshots;
    
- usa apenas fontes confiáveis;
    
- preserva dados preenchidos.
    

Não editar migrations já aplicadas.

Criar nova migration para evoluções futuras.

---

## Testes da Auditoria

Arquivo:

```text
Backend\auditoria\tests.py
```

Cobertura atual informada:

- criação central;
    
- snapshots;
    
- sanitização;
    
- imutabilidade;
    
- ações;
    
- isolamento;
    
- empresa;
    
- loja;
    
- permissões;
    
- filtros;
    
- exportação;
    
- indicadores;
    
- audit_required;
    
- rollback;
    
- on_commit;
    
- migração histórica;
    
- recursão;
    
- status HTTP.
    

Resultado final informado e revisado:

```text
21 testes da Auditoria aprovados
```

---

# Frontend — serviços centrais

## AuthService

Localizar em:

```text
Frontend\sysvar\src\app\core
```

Responsável por:

- login;
    
- usuário atual;
    
- contexto;
    
- token;
    
- empresa;
    
- permissões;
    
- módulos;
    
- sessão.
    

Confirmar o caminho exato antes de editar.

---

## PermissionService

Arquivo conhecido:

```text
Frontend\sysvar\src\app\core\permission.service.ts
```

Responsável por decidir exibição de itens conforme:

- módulos;
    
- permissões efetivas;
    
- contexto do usuário.
    

Teste da Auditoria:

```text
Frontend\sysvar\src\app\core\permission.service.spec.ts
```

Não reintroduzir dependência de role antiga `Admin` na Auditoria.

---

## Serviços relacionados à sessão

Localizar em:

```text
Frontend\sysvar\src\app\core\services
```

Responsabilidades:

- heartbeat;
    
- sessão;
    
- device ID;
    
- logout;
    
- contexto.
    

Confirmar os nomes e caminhos exatos no repositório antes de alterar.

---

# Frontend — Auditoria

## Models

Arquivo:

```text
Frontend\sysvar\src\app\core\models\audit.ts
```

Interfaces principais:

```text
AuditLogListItem
AuditLogDetail
AuditIndicators
AuditFilters
AuditCategory
AuditResult
AuditSeverity
AuditOrigin
```

---

## Service

Arquivo:

```text
Frontend\sysvar\src\app\core\services\audit.service.ts
```

Métodos principais:

```text
list
get
getIndicators
exportCsv
```

---

## Feature

Caminho:

```text
Frontend\sysvar\src\app\features\auditoria
```

Arquivos principais:

```text
auditoria.component.ts
auditoria.component.html
auditoria.component.css
auditoria.component.spec.ts
```

Confirmar extensões e nomes reais antes de editar.

---

## Rota

Arquivo:

```text
Frontend\sysvar\src\app\app.routes.ts
```

Rota:

```text
/config/auditoria
```

Configuração atual:

```text
moduloEmpresa: auditoria
```

A rota não exige:

```text
roles: ['Admin']
```

---

## Menu

Arquivo:

```text
Frontend\sysvar\src\app\layout\shell\shell.component.ts
```

Item:

```text
Auditoria
```

O menu depende da permissão efetiva do módulo.

Regras:

- `NONE`: oculto;
    
- `VIEW`: visível;
    
- `EDIT`: visível;
    
- master: visível;
    
- superusuário: visível.
    

---

## Testes frontend

Arquivos relevantes:

```text
Frontend\sysvar\src\app\features\auditoria\auditoria.component.spec.ts
Frontend\sysvar\src\app\app.routes.spec.ts
Frontend\sysvar\src\app\core\permission.service.spec.ts
```

Resultado final informado:

```text
25 testes frontend aprovados
```

---

# Onde mexer por tipo de funcionalidade

## Autenticação

Backend:

```text
accounts\authentication.py
accounts\views.py
accounts\serializers.py
accounts\services\sessions.py
```

Frontend:

```text
core
guards
interceptors
login
```

---

## Contratos e módulos

Backend:

```text
cadastros\models.py
cadastros\serializers.py
cadastros\views.py
accounts\services\effective_access.py
```

Frontend:

```text
features de empresas
features de contratos
services relacionados
```

---

## Usuários e perfis

Backend:

```text
accounts\models.py
accounts\serializers.py
accounts\views.py
accounts\permissions.py
```

Frontend:

```text
features de usuários
features de perfis
PermissionService
AuthService
```

---

## Auditoria

Backend:

```text
auditoria\models.py
auditoria\services.py
auditoria\middleware.py
auditoria\signals.py
auditoria\views.py
auditoria\serializers.py
auditoria\tests.py
```

Frontend:

```text
core\models\audit.ts
core\services\audit.service.ts
features\auditoria
app.routes.ts
layout\shell
```

---

## Cadastros

Backend:

```text
cadastros
```

Frontend:

```text
features de empresas
lojas
clientes
fornecedores
funcionários
naturezas
planos
formas de pagamento
```

---

## Produtos

Backend:

```text
produto
```

Frontend:

```text
features de produtos
SKUs
grades
cores
coleções
packs
estoque
produção
```

---

## Compras e Entrada de Nota

Backend:

```text
compras
```

Frontend:

```text
features de pedidos
recebimento
entrada de nota
```

Antes de implementar Entrada de Nota, revisar também:

```text
fiscal
financeiro
produto
auditoria
```

---

## Financeiro

Backend:

```text
financeiro
```

Frontend:

```text
contas a pagar
contas a receber
caixa
bancos
fluxo
rateios
```

---

## Fiscal

Backend:

```text
fiscal
```

Frontend:

```text
NFC-e
NF-e
faturamento
devoluções
configurações fiscais
```

---

## Distribuição

Backend:

```text
distribuicao
```

Frontend:

```text
features de distribuição
perfis
alocações
pedidos por loja
```

---

## Dashboards

Backend:

```text
dashboard
```

Frontend:

```text
features de dashboard
indicadores
gráficos
```

---

# Comandos de validação

## Backend

```powershell
python manage.py check
python manage.py makemigrations --check --dry-run
python manage.py migrate
python manage.py test auditoria -v 2 --noinput
python manage.py test accounts -v 2 --noinput
python manage.py test -v 2 --noinput
```

---

## Frontend

```powershell
npx tsc -p tsconfig.app.json --noEmit
ng build --configuration development
ng test --watch=false --browsers=ChromeHeadless
```

Não informar que passaram sem executar.

---

# Commits da Auditoria Central

Primeira fase revisada:

Backend:

```text
e9f6f8f69071f388eef4fb4d774b3ec176093f33
```

Frontend:

```text
54dc03d867fbf16b9f90e21a4de01cdd6cb9b466
```

Rodada de endurecimento:

Backend:

```text
123b7c1bc3844c3135daac4654ca4a3aab2c76a3
```

Frontend:

```text
acbab0a08818069fc1a40724afe4d4cc9e4cf50f
```

Esses commits representam a infraestrutura da Auditoria Central analisada, corrigida e homologada.

---

# Limitações

Este mapa indica os pontos principais, mas o projeto continua evoluindo.

Antes de qualquer alteração:

1. localizar o arquivo real;
    
2. abrir o código atual;
    
3. verificar usos;
    
4. verificar testes;
    
5. verificar migrations;
    
6. verificar frontend;
    
7. verificar documentação;
    
8. verificar impacto em outros módulos.
    

Não assumir que um caminho antigo continua válido sem conferência.

---

# Próxima área técnica recomendada

A próxima análise deve se concentrar em:

```text
Entrada de Nota Fiscal
```

Apps que provavelmente serão envolvidos:

```text
compras
produto
fiscal
financeiro
cadastros
auditoria
```

A análise deverá localizar primeiro o que já existe no código antes de criar models, endpoints ou telas.

---

# Última atualização

```text
2026-08-05
```

---

# Notas relacionadas

- [[10 Projetos/Sysvar/Sysvar|Sysvar]]
    
- [[10 Projetos/Sysvar/Contexto do Projeto/Arquitetura|Arquitetura]]
    
- [[10 Projetos/Sysvar/Contexto do Projeto/Modelo de Domínio|Modelo de Domínio]]
    
- [[10 Projetos/Sysvar/Contexto do Projeto/Workflows|Workflows]]
    
- [[10 Projetos/Sysvar/Contexto do Projeto/Riscos e Cuidados|Riscos e Cuidados]]
    
- [[10 Projetos/Sysvar/Decisões Técnicas/ADR-001 - Licenciamento por Sessões Simultâneas|ADR-001 - Licenciamento por Sessões Simultâneas]]
    
- [[10 Projetos/Sysvar/Decisões Técnicas/ADR-002 - Princípios Arquiteturais do SISVAR|ADR-002 - Princípios Arquiteturais do SISVAR]]
    
- [[10 Projetos/Sysvar/Decisões Técnicas/ADR-003 - Auditoria Central do SISVAR|ADR-003 - Auditoria Central do SISVAR]]