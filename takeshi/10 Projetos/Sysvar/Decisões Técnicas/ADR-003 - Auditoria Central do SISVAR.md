

---

type: adr  
status: implemented  
project: Sysvar  
adr: 003  
created: 2026-08-05  
updated: 2026-08-05  
tags:

- sysvar
    
- adr
    
- arquitetura
    
- auditoria
    
- segurança
    
- rastreabilidade
    
- multiempresa
    

---

# ADR-003 - Auditoria Central do SISVAR

## Status

Aprovada.

Implementada.

Revisada tecnicamente.

Validada por testes automatizados e homologação funcional.

A primeira fase da Auditoria Central está concluída.

A integração detalhada com os demais módulos de negócio continuará gradualmente durante a revisão individual de cada módulo.

---

# Contexto

O SISVAR é um ERP SaaS multiempresa e multilojas.

Suas operações afetam áreas sensíveis e integradas, como:

- contratos;
    
- usuários;
    
- permissões;
    
- produtos;
    
- preços;
    
- compras;
    
- estoque;
    
- vendas;
    
- PDV;
    
- fiscal;
    
- financeiro;
    
- contabilidade;
    
- produção;
    
- distribuição.
    

O sistema precisava possuir uma infraestrutura capaz de responder:

- quem realizou uma operação;
    
- quando ela ocorreu;
    
- em qual empresa;
    
- em qual loja;
    
- qual usuário estava autenticado;
    
- qual sessão originou a ação;
    
- qual dispositivo foi utilizado;
    
- qual objeto foi afetado;
    
- qual era o estado anterior;
    
- qual passou a ser o estado posterior;
    
- se a operação foi concluída, negada ou falhou;
    
- qual endpoint recebeu a requisição;
    
- qual IP e user-agent foram utilizados.
    

O app `auditoria` já existia, mas possuía limitações importantes:

- ausência de empresa e loja;
    
- ausência de isolamento multiempresa explícito;
    
- dependência de `IsAdminUser`;
    
- ausência de snapshots históricos;
    
- falta de request ID e correlation ID;
    
- ausência de sessão e dispositivo;
    
- ausência de resultado, severidade e origem;
    
- estrutura inconsistente de alterações;
    
- signals restritos a poucos apps;
    
- mecanismos paralelos de gravação;
    
- falhas silenciosamente ignoradas;
    
- ausência de imutabilidade forte;
    
- ausência de uma tela operacional completa.
    

---

# Decisão

O SISVAR adotou uma única infraestrutura central de auditoria.

O app `auditoria` existente foi evoluído.

Não foi criado outro app ou tabela paralela.

A Auditoria Central é:

- multiempresa;
    
- multilojas;
    
- centralizada;
    
- estruturada;
    
- imutável;
    
- somente leitura;
    
- sanitizada;
    
- transacional;
    
- orientada a eventos;
    
- protegida por permissões efetivas;
    
- complementada por signals controlados;
    
- integrada gradualmente aos módulos.
    

---

# Estrutura implementada

## AuditLog

O model central `AuditLog` passou a registrar:

- `event_id`;
    
- `request_id`;
    
- `correlation_id`;
    
- empresa;
    
- snapshots históricos da empresa;
    
- loja;
    
- snapshots históricos da loja;
    
- usuário;
    
- snapshots históricos do usuário;
    
- sessão;
    
- dispositivo;
    
- ação;
    
- categoria;
    
- resultado;
    
- severidade;
    
- origem;
    
- app;
    
- model;
    
- objeto;
    
- representação do objeto;
    
- dados anteriores;
    
- dados posteriores;
    
- campos alterados;
    
- metadata;
    
- IP;
    
- user-agent;
    
- método HTTP;
    
- endpoint;
    
- status HTTP;
    
- código de erro;
    
- mensagem de erro;
    
- data e hora.
    

O campo legado `changes` foi preservado temporariamente para compatibilidade.

Novos eventos não devem utilizá-lo como fonte principal.

---

# Classificações

## Categorias

Foram centralizadas as seguintes categorias:

```text
SECURITY
ACCESS
CONTRACT
USER_MANAGEMENT
CADASTRO
PRODUCT
PURCHASE
STOCK
SALE
FISCAL
FINANCIAL
ACCOUNTING
PRODUCTION
DISTRIBUTION
REPORT
SYSTEM
INTEGRATION
```

## Resultados

```text
SUCCESS
FAILURE
DENIED
PENDING
ROLLED_BACK
```

## Severidades

```text
INFO
WARNING
ERROR
CRITICAL
```

## Origens

```text
API
WEB
PDV
OFFLINE_SYNC
COMMAND
IMPORT
INTEGRATION
SYSTEM
```

---

# Catálogo de ações

As ações oficiais são centralizadas no catálogo `AuditAction`.

Exemplos implementados:

```text
USER_LOGIN
USER_LOGIN_DENIED
USER_LOGOUT
USER_CREATED
USER_UPDATED
USER_ACTIVATED
USER_INACTIVATED
USER_DELETED

SESSION_CREATED
SESSION_REPLACED
SESSION_CLOSED
SESSION_TIMEOUT
SESSION_LIMIT_REACHED
SESSION_CLOSE_DENIED

CONTRACT_CREATED
CONTRACT_UPDATED
CONTRACT_STATUS_CHANGED
CONTRACT_LIMIT_CHANGED

MASTER_TRANSFERRED
MASTER_TRANSFER_DENIED

PROFILE_CREATED
PROFILE_UPDATED
PROFILE_INACTIVATED
PROFILE_DEFAULT_CHANGED

PERMISSION_UPDATED
PERMISSION_DENIED

AUDIT_EXPORT
AUDIT_ACCESS_DENIED

OBJECT_CREATED
OBJECT_UPDATED
OBJECT_DELETED

AUDIT_INTERNAL_FAILURE
LEGACY_EVENT
```

Ações desconhecidas não são aceitas como ações oficiais.

Eventos antigos desconhecidos são registrados como `LEGACY_EVENT`, mantendo a ação original em metadata sanitizada.

---

# Contexto da requisição

O `AuditContextMiddleware` passou a controlar o contexto de cada requisição.

Ele registra e disponibiliza:

- request ID;
    
- correlation ID;
    
- usuário;
    
- empresa;
    
- loja;
    
- sessão;
    
- dispositivo;
    
- IP;
    
- user-agent;
    
- método HTTP;
    
- endpoint.
    

Os identificadores são retornados nos headers da resposta quando aplicável:

```text
X-Request-ID
X-Correlation-ID
```

O contexto é limpo ao final de cada requisição para impedir vazamento entre operações.

---

# AuditService

Foi criado um serviço central único chamado `AuditService`.

Responsabilidades:

- validar ações e classificações;
    
- obter contexto da requisição;
    
- resolver empresa e loja;
    
- obter sessão e dispositivo;
    
- criar snapshots históricos;
    
- sanitizar dados;
    
- truncar conteúdos excessivos;
    
- registrar eventos;
    
- registrar falhas no logger;
    
- suportar eventos sem request;
    
- impedir gravação de tokens e segredos;
    
- distinguir auditoria normal e obrigatória.
    

Métodos centrais incluem:

```python
AuditService.record(...)
AuditService.success(...)
AuditService.failure(...)
AuditService.denied(...)
AuditService.security(...)
AuditService.on_commit(...)
AuditService.required(...)
AuditService.required_success(...)
```

Chamadas antigas de auditoria passaram a delegar para esse serviço.

---

# Auditoria normal e obrigatória

## Auditoria após commit

Eventos comuns de sucesso confirmado utilizam:

```python
transaction.on_commit()
```

Isso evita registrar sucesso quando a operação principal sofre rollback.

Exemplos:

- criação comum de usuário;
    
- alteração comum de perfil;
    
- login;
    
- logout;
    
- eventos operacionais não críticos.
    

## Auditoria obrigatória

Operações críticas registram a auditoria dentro da mesma transação.

Se a auditoria obrigatória falhar, a operação também deve falhar.

Foram classificadas como obrigatórias nesta fase:

- criação e alteração de contrato;
    
- alteração do limite de acessos;
    
- alteração de módulos contratados;
    
- transferência de master;
    
- alteração de permissão de módulo;
    
- alteração do perfil padrão;
    
- exclusão administrativa de usuário.
    

---

# Imutabilidade

Os registros de auditoria são imutáveis.

Foram bloqueados:

- criação direta pelo manager;
    
- alteração por `save()`;
    
- exclusão por `delete()`;
    
- `QuerySet.update()`;
    
- `QuerySet.delete()`;
    
- `bulk_create()`;
    
- `bulk_update()`;
    
- `update_or_create()`;
    
- `get_or_create()`.
    

A criação ocorre somente pelo caminho interno controlado do `AuditService`.

A API não possui:

- `POST`;
    
- `PUT`;
    
- `PATCH`;
    
- `DELETE`.
    

A retenção futura deverá utilizar um caminho administrativo explícito.

---

# Segurança e sanitização

Foi criado sanitizador recursivo.

Campos proibidos são removidos ou substituídos por:

```text
[REDACTED]
```

Exemplos:

- senha;
    
- token;
    
- Authorization;
    
- cookie;
    
- secrets;
    
- chaves privadas;
    
- certificados;
    
- access token;
    
- refresh token;
    
- hashes de tokens.
    

Dados pessoais e documentos podem ser mascarados quando necessário.

Conteúdos excessivamente grandes são truncados.

A auditoria não armazena:

- token bruto;
    
- hash do token;
    
- senha;
    
- Authorization header;
    
- cookie;
    
- certificado;
    
- chave privada.
    

---

# Snapshots históricos

A auditoria mantém ForeignKeys quando disponíveis, mas também grava snapshots.

## Empresa

- ID histórico;
    
- nome histórico.
    

## Loja

- ID histórico;
    
- nome histórico.
    

## Usuário

- ID histórico;
    
- username histórico;
    
- nome histórico.
    

Os nomes são obtidos por helpers centrais baseados nos campos reais dos models.

Isso preserva o contexto mesmo quando cadastros forem:

- renomeados;
    
- inativados;
    
- desvinculados;
    
- excluídos por manutenção autorizada.
    

---

# Logs antigos

Os registros antigos foram preservados.

As migrations:

```text
0004_central_audit_phase1
0005_backfill_historical_context
```

realizam:

- criação dos novos campos;
    
- geração de event IDs;
    
- conversão do campo legado `changes`;
    
- separação de antes e depois;
    
- preenchimento de campos alterados;
    
- preenchimento de metadata;
    
- recuperação de empresa quando existe fonte confiável;
    
- recuperação de loja quando existe fonte confiável;
    
- recuperação de snapshots de usuário;
    
- preservação de dados já preenchidos.
    

Nenhum log existente foi apagado.

Quando não existe fonte confiável, o contexto histórico permanece nulo em vez de ser inventado.

---

# Permissões de consulta

## Superusuário da plataforma

Pode:

- consultar todas as empresas;
    
- filtrar por empresa e loja;
    
- visualizar eventos globais;
    
- exportar resultados.
    

## Usuário master

Pode:

- consultar todos os eventos da própria empresa;
    
- consultar todas as lojas da própria empresa;
    
- exportar resultados permitidos.
    

## Usuário com VIEW

Pode:

- acessar a tela;
    
- consultar eventos da própria empresa;
    
- consultar apenas lojas permitidas;
    
- visualizar detalhes.
    

Não pode exportar.

## Usuário com EDIT

Pode:

- consultar;
    
- visualizar detalhes;
    
- exportar os registros permitidos.
    

`EDIT` não permite modificar ou excluir logs.

## Usuário com NONE

- não vê o menu;
    
- não acessa a rota;
    
- recebe bloqueio da API.
    

---

# Isolamento multiempresa e por loja

O queryset é sempre limitado pelo contexto do usuário.

Usuários clientes não podem consultar logs de outra empresa.

Tentativas de informar outra empresa retornam:

```text
403 Forbidden
```

Tentativas de consultar loja não permitida também retornam:

```text
403 Forbidden
```

Essas tentativas geram um único evento:

```text
AUDIT_ACCESS_DENIED
```

Foi implementada proteção contra recursão ao auditar acessos negados na própria API de Auditoria.

---

# API

A rota central é:

```text
/api/auditoria/logs/
```

Endpoints implementados:

```text
GET /api/auditoria/logs/
GET /api/auditoria/logs/{id}/
GET /api/auditoria/logs/indicadores/
GET /api/auditoria/logs/exportar/
```

A API possui:

- paginação;
    
- ordenação;
    
- busca;
    
- filtros;
    
- serializer resumido;
    
- serializer detalhado;
    
- indicadores agregados;
    
- exportação CSV.
    

---

# Filtros

Filtros disponíveis incluem:

- data inicial;
    
- data final;
    
- empresa;
    
- loja;
    
- usuário;
    
- categoria;
    
- ação;
    
- resultado;
    
- severidade;
    
- origem;
    
- app;
    
- model;
    
- object ID;
    
- request ID;
    
- correlation ID;
    
- session ID;
    
- device ID;
    
- IP;
    
- método HTTP;
    
- endpoint;
    
- status HTTP.
    

Filtros enviados pelo frontend nunca substituem o isolamento aplicado pelo backend.

---

# Indicadores

O endpoint de indicadores retorna:

```json
{
  "total": 0,
  "success": 0,
  "failure": 0,
  "denied": 0,
  "critical": 0
}
```

Os indicadores respeitam:

- empresa;
    
- loja;
    
- permissão;
    
- período;
    
- demais filtros aplicados.
    

---

# Exportação

A exportação inicial utiliza CSV.

Ela está disponível para:

- superusuário;
    
- master;
    
- usuário com `auditoria=EDIT`.
    

A exportação:

- respeita empresa;
    
- respeita loja;
    
- respeita filtros;
    
- possui limite de registros;
    
- não exporta dados secretos;
    
- gera evento `AUDIT_EXPORT`.
    

O evento registra:

- formato;
    
- filtros;
    
- quantidade exportada;
    
- limite;
    
- indicação de limite atingido;
    
- empresa;
    
- loja;
    
- status HTTP.
    

---

# Frontend

Foi criada a feature Angular standalone de Auditoria.

Rota:

```text
/config/auditoria
```

A rota não depende da role antiga `Admin`.

O acesso utiliza a permissão efetiva do módulo `auditoria`.

A tela possui:

- barra de título;
    
- indicadores;
    
- filtros;
    
- barra de ações;
    
- tabela;
    
- paginação;
    
- detalhe;
    
- comparação antes e depois;
    
- exportação condicionada à permissão;
    
- estados de carregamento;
    
- estado vazio;
    
- tratamento de erro.
    

A tela não possui ações de editar ou excluir.

---

# Integrações concluídas nesta fase

A Auditoria Central foi integrada a:

- autenticação;
    
- login negado;
    
- login realizado;
    
- logout;
    
- sessões;
    
- timeout;
    
- substituição de sessão;
    
- limite simultâneo;
    
- encerramento administrativo;
    
- contratos;
    
- limites de acesso;
    
- módulos contratados;
    
- transferência de master;
    
- perfis;
    
- perfil padrão;
    
- permissões;
    
- usuários;
    
- ativação;
    
- inativação;
    
- exclusão administrativa;
    
- consulta da Auditoria;
    
- exportação da Auditoria.
    

---

# Signals e registry

Os signals deixaram de depender de uma whitelist fixa por app.

Foi criado um registry central para os models auditados.

Signals são utilizados apenas como apoio para CRUD simples.

Ações de negócio críticas devem chamar o `AuditService` explicitamente.

Não se deve depender de signals para interpretar ações como:

- aprovar;
    
- cancelar;
    
- baixar;
    
- faturar;
    
- emitir;
    
- distribuir;
    
- transferir;
    
- finalizar.
    

---

# Testes executados

## Backend

```text
python manage.py check
python manage.py makemigrations --check --dry-run
python manage.py migrate
python manage.py test auditoria -v 2 --noinput
python manage.py test accounts -v 2 --noinput
python manage.py test -v 2 --noinput
```

Resultados finais informados e revisados:

```text
auditoria: 21 testes aprovados
accounts: 14 testes aprovados
suíte geral: 35 testes aprovados
```

## Frontend

```text
tsc -p tsconfig.app.json --noEmit
ng build --configuration development
ng test --watch=false --browsers=ChromeHeadless
```

Resultado final:

```text
25 testes aprovados
```

---

# Homologação funcional

Foram validados manualmente:

- acesso do master;
    
- acesso com `auditoria=VIEW`;
    
- ausência de exportação para VIEW;
    
- acesso com `auditoria=EDIT`;
    
- disponibilidade da exportação para EDIT;
    
- criação de eventos de usuário;
    
- exibição de empresa;
    
- exibição de usuário;
    
- ação;
    
- data;
    
- antes e depois.
    

A homologação funcional foi aprovada em 2026-08-05.

---

# Limitações atuais

A infraestrutura central está concluída.

Ainda não foi realizada integração detalhada de todos os eventos específicos dos módulos:

- compras;
    
- estoque;
    
- financeiro;
    
- fiscal;
    
- vendas;
    
- PDV;
    
- produção;
    
- distribuição;
    
- relatórios.
    

Esses módulos já podem utilizar o `AuditService`, mas seus eventos de negócio serão revisados e integrados durante a análise individual de cada módulo.

Também permanecem para fases futuras:

- política automatizada de retenção;
    
- arquivamento externo;
    
- exportação Excel;
    
- integração com SIEM;
    
- armazenamento especializado de grande volume.
    

---

# Próxima etapa

Com a infraestrutura central concluída, a Auditoria passa a ser utilizada como padrão obrigatório durante a revisão dos demais módulos.

A próxima etapa geral do SISVAR deverá ser definida no planejamento do projeto.

Candidatos já registrados:

- Entrada de Nota Fiscal;
    
- revisão dos Cadastros;
    
- revisão de Produtos;
    
- Produção;
    
- Distribuição;
    
- PDV Offline.
    

---

# Decisão final

A primeira fase da Auditoria Central do SISVAR está implementada, testada, revisada e homologada.

A infraestrutura oficial é o app `auditoria`.

Não devem ser criados mecanismos paralelos.

Todo novo módulo deverá utilizar:

- `AuditService`;
    
- classificações centralizadas;
    
- sanitização;
    
- isolamento multiempresa;
    
- eventos explícitos de negócio;
    
- auditoria obrigatória quando a operação crítica exigir.
    

---

# Notas relacionadas

- [[10 Projetos/Sysvar/Sysvar|Sysvar]]
    
- [[10 Projetos/Sysvar/Contexto do Projeto/Arquitetura|Arquitetura]]
    
- [[10 Projetos/Sysvar/Contexto do Projeto/Modelo de Domínio|Modelo de Domínio]]
    
- [[10 Projetos/Sysvar/Contexto do Projeto/Workflows|Workflows]]
    
- [[10 Projetos/Sysvar/Contexto do Projeto/Riscos e Cuidados|Riscos e Cuidados]]
    
- [[10 Projetos/Sysvar/Decisões Técnicas/ADR-001 - Licenciamento por Sessões Simultâneas|ADR-001 - Licenciamento por Sessões Simultâneas]]
    
- [[10 Projetos/Sysvar/Decisões Técnicas/ADR-002 - Princípios Arquiteturais do SISVAR|ADR-002 - Princípios Arquiteturais do SISVAR]]