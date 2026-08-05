
---

type: adr  
status: approved  
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

Ainda não implementada integralmente.

A implementação deverá evoluir o app `auditoria` existente, preservando o que for compatível e substituindo os pontos inadequados para o modelo SaaS multiempresa do SISVAR.

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
    

O sistema precisa responder com segurança perguntas como:

- Quem realizou uma operação?
    
- Quando a operação ocorreu?
    
- Em qual empresa?
    
- Em qual loja?
    
- Qual usuário estava autenticado?
    
- Qual sessão originou a ação?
    
- Qual dispositivo foi utilizado?
    
- Qual era o valor anterior?
    
- Qual passou a ser o novo valor?
    
- A operação foi concluída?
    
- A operação foi negada?
    
- A operação falhou?
    
- Houve rollback?
    
- Qual endpoint recebeu a requisição?
    
- Qual IP e user-agent foram utilizados?
    
- Qual objeto foi afetado?
    

O projeto já possui um app chamado `auditoria`, com:

- model `AuditLog`;
    
- middleware de contexto;
    
- signals de CRUD;
    
- serializer;
    
- endpoint somente leitura;
    
- filtros;
    
- registros manuais em partes da autenticação e segurança.
    

Entretanto, a estrutura atual ainda não atende integralmente às necessidades do SISVAR.

Os principais problemas identificados são:

- ausência de empresa no log;
    
- ausência de loja;
    
- consulta global baseada em `IsAdminUser`;
    
- falta de isolamento explícito por empresa;
    
- dependência de `is_staff`;
    
- ausência de snapshots históricos;
    
- falta de request ID;
    
- falta de sessão e dispositivo;
    
- ausência de resultado e severidade;
    
- formato inconsistente de alterações;
    
- signals restritos a poucos apps;
    
- eventos manuais registrados por mecanismo paralelo;
    
- falhas de auditoria silenciosamente ignoradas;
    
- ausência de distinção entre sucesso, falha, acesso negado e rollback.
    

---

# Decisão

O SISVAR possuirá uma infraestrutura central de auditoria.

A auditoria será:

- multiempresa;
    
- multilojas;
    
- centralizada;
    
- estruturada;
    
- imutável;
    
- somente leitura;
    
- segura;
    
- transacional;
    
- orientada a eventos de negócio;
    
- complementada por signals controlados;
    
- integrada gradualmente aos módulos.
    

O app `auditoria` existente será evoluído.

Não será criada uma segunda infraestrutura paralela.

---

# 1. Objetivos

A Auditoria Central deverá:

- registrar operações críticas;
    
- preservar contexto histórico;
    
- permitir rastreabilidade;
    
- apoiar segurança;
    
- apoiar suporte;
    
- apoiar investigação de erros;
    
- apoiar conferência operacional;
    
- apoiar análise de acessos;
    
- preservar isolamento entre empresas;
    
- permitir consulta e exportação controladas;
    
- evitar exposição de dados sensíveis;
    
- manter desempenho aceitável.
    

---

# 2. Escopo dos eventos

A auditoria registrará quatro grupos principais.

## Segurança

Exemplos:

- login realizado;
    
- login negado;
    
- logout;
    
- sessão expirada;
    
- sessão substituída;
    
- sessão encerrada administrativamente;
    
- limite simultâneo atingido;
    
- acesso negado;
    
- tentativa de acesso a outra empresa;
    
- alteração de contrato;
    
- transferência de master;
    
- alteração de perfil;
    
- alteração de permissão;
    
- exportação de auditoria.
    

## Operações de negócio

Exemplos:

- pedido criado;
    
- pedido aprovado;
    
- pedido cancelado;
    
- nota recebida;
    
- título baixado;
    
- estoque movimentado;
    
- venda finalizada;
    
- NFC-e emitida;
    
- distribuição confirmada;
    
- ordem de produção finalizada.
    

## Alterações cadastrais

Exemplos:

- cliente criado;
    
- fornecedor alterado;
    
- produto alterado;
    
- preço modificado;
    
- usuário inativado;
    
- loja alterada;
    
- perfil alterado;
    
- cadastro excluído.
    

## Eventos técnicos

Exemplos:

- integração rejeitada;
    
- falha fiscal;
    
- importação executada;
    
- command administrativo executado;
    
- sincronização concluída;
    
- rotina automática executada;
    
- falha interna da própria auditoria.
    

---

# 3. Permissões de consulta

## Superusuário da plataforma

Pode:

- consultar todas as empresas;
    
- filtrar por empresa;
    
- filtrar por loja;
    
- consultar eventos internos;
    
- consultar falhas técnicas;
    
- exportar resultados;
    
- consultar eventos de segurança da plataforma.
    

## Usuário master da empresa

Pode:

- consultar todos os logs da própria empresa;
    
- consultar todas as lojas da própria empresa;
    
- consultar eventos dos usuários da própria empresa;
    
- exportar os logs que consegue consultar;
    
- visualizar detalhes de alterações.
    

Não pode:

- consultar outra empresa;
    
- alterar logs;
    
- excluir logs;
    
- alterar retenção;
    
- acessar eventos internos restritos da plataforma.
    

## Usuário comum

Depende de permissão efetiva no módulo de auditoria.

Permissão:

```text
auditoria = VIEW
```

Permite:

- consultar logs da própria empresa;
    
- consultar apenas lojas permitidas;
    
- visualizar detalhes autorizados.
    

Permissão:

```text
auditoria = EDIT
```

Não permite editar registros.

Poderá liberar funções administrativas adicionais, como:

- exportação;
    
- relatórios consolidados;
    
- detalhes técnicos permitidos.
    

## Regra geral

Nenhum usuário cliente poderá:

- criar logs pela API;
    
- editar logs;
    
- excluir logs;
    
- alterar empresa do log;
    
- alterar usuário do log;
    
- alterar dados históricos.
    

---

# 4. Modelo central

O model atual `AuditLog` será evoluído.

A estrutura deverá conter, no mínimo:

```text
id

event_id
request_id
correlation_id

empresa
empresa_id_snapshot
empresa_nome_snapshot

loja
loja_id_snapshot
loja_nome_snapshot

user
user_id_snapshot
username_snapshot
user_nome_snapshot

session_id
device_id

action
category
result
severity
origin

app_label
model
object_id
object_repr

before_data
after_data
changed_fields
metadata

ip
user_agent
http_method
endpoint
status_code

error_code
error_message

created_at
```

Os nomes finais poderão ser adaptados à convenção atual do código, desde que o significado seja preservado.

---

# 5. Identificadores

## Event ID

Cada evento terá identificador próprio e único.

Finalidades:

- referência externa;
    
- suporte;
    
- exportação;
    
- integração;
    
- pesquisa.
    

## Request ID

Cada requisição deverá receber um identificador único.

Todos os eventos originados pela mesma requisição poderão ser correlacionados.

## Correlation ID

Permitirá relacionar vários eventos de uma mesma operação de negócio.

Exemplo:

```text
Aprovação de pedido
→ geração financeira
→ movimentação de estoque
→ emissão fiscal
→ auditorias relacionadas
```

---

# 6. Empresa e loja

Todo evento de usuário cliente deverá possuir empresa.

Quando a operação estiver vinculada a uma loja, o evento também deverá registrar a loja.

A auditoria deverá manter:

- ForeignKey atual, quando aplicável;
    
- ID histórico;
    
- nome histórico.
    

Isso garante que o log continue compreensível mesmo quando:

- empresa mudar de nome;
    
- loja mudar de nome;
    
- objeto for inativado;
    
- vínculo for removido;
    
- cadastro for eliminado por manutenção autorizada.
    

---

# 7. Usuário e snapshots históricos

A auditoria manterá a ForeignKey do usuário quando possível.

Também deverá guardar:

- ID do usuário no momento;
    
- username no momento;
    
- nome no momento.
    

Exemplo:

```text
user = referência atual
user_id_snapshot = 25
username_snapshot = "fernando"
user_nome_snapshot = "Fernando Murashima"
```

A exibição histórica não deverá depender exclusivamente dos dados atuais do usuário.

---

# 8. Sessão e dispositivo

Quando o evento for originado por requisição autenticada, deverá registrar:

- session ID;
    
- device ID;
    
- IP;
    
- user-agent.
    

A auditoria nunca deverá persistir:

- token bruto;
    
- hash do token;
    
- Authorization header;
    
- cookie de autenticação.
    

---

# 9. Classificação

## Categoria

Valores iniciais:

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

## Resultado

Valores iniciais:

```text
SUCCESS
FAILURE
DENIED
PENDING
ROLLED_BACK
```

## Severidade

Valores iniciais:

```text
INFO
WARNING
ERROR
CRITICAL
```

## Origem

Valores iniciais:

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

Esses valores deverão ser definidos em enums centralizados.

---

# 10. Ações

A ação deverá representar o evento de forma clara e estável.

Exemplos:

```text
USER_LOGIN
USER_LOGIN_DENIED
SESSION_CLOSED
SESSION_TIMEOUT
SESSION_LIMIT_REACHED
CONTRACT_UPDATED
MASTER_TRANSFERRED
PROFILE_UPDATED
PERMISSION_UPDATED
CUSTOMER_CREATED
PRODUCT_UPDATED
PRICE_CHANGED
PURCHASE_ORDER_APPROVED
PURCHASE_ORDER_CANCELLED
STOCK_MOVED
PAYABLE_SETTLED
SALE_COMPLETED
NFCE_ISSUED
```

Não utilizar textos livres diferentes para o mesmo tipo de evento.

---

# 11. Antes, depois e campos alterados

O formato atual de `changes` será substituído conceitualmente por campos separados.

## Criação

```text
before_data = null
after_data = snapshot criado
changed_fields = lista dos campos registrados
```

## Alteração

```text
before_data = valores anteriores
after_data = valores posteriores
changed_fields = campos efetivamente alterados
```

## Exclusão

```text
before_data = snapshot anterior
after_data = null
changed_fields = lista dos campos relevantes
```

## Ação de negócio

Exemplo:

```json
{
  "before_data": {
    "status": "AB"
  },
  "after_data": {
    "status": "AP"
  },
  "changed_fields": [
    "status"
  ],
  "metadata": {
    "numero_pedido": 150,
    "total": "2500.00"
  }
}
```

---

# 12. Metadata

O campo `metadata` poderá armazenar contexto adicional que não represente diretamente alteração de campos.

Exemplos:

- número do documento;
    
- total;
    
- quantidade de itens;
    
- forma de pagamento;
    
- origem da integração;
    
- nome do command;
    
- quantidade importada;
    
- código de rejeição;
    
- duração da operação.
    

Metadata também passará por sanitização.

---

# 13. Imutabilidade

Os registros de auditoria serão imutáveis.

Regras:

- endpoint apenas de leitura;
    
- sem `POST`;
    
- sem `PUT`;
    
- sem `PATCH`;
    
- sem `DELETE`;
    
- Django Admin somente leitura, caso seja habilitado;
    
- bloqueio de alteração comum pelo model ou manager;
    
- bloqueio de exclusão comum;
    
- retenção executada somente por serviço administrativo controlado;
    
- exclusão por retenção também será auditada.
    

A imutabilidade não deve impedir migrations oficiais.

---

# 14. Serviço central

Será criado um serviço central, por exemplo:

```python
AuditService
```

Responsabilidades:

- receber o evento;
    
- obter contexto;
    
- definir empresa;
    
- definir loja;
    
- obter snapshots;
    
- sanitizar dados;
    
- padronizar enums;
    
- validar campos obrigatórios;
    
- registrar sucesso;
    
- registrar falha;
    
- registrar acesso negado;
    
- registrar evento técnico;
    
- usar `transaction.on_commit()` quando necessário;
    
- registrar erros da própria auditoria no logger.
    

Métodos sugeridos:

```python
AuditService.record(...)
AuditService.success(...)
AuditService.failure(...)
AuditService.denied(...)
AuditService.security(...)
```

Os nomes podem ser adaptados, mantendo uma única fonte oficial.

---

# 15. Contexto da requisição

Será criado ou evoluído um middleware, por exemplo:

```python
AuditContextMiddleware
```

Responsabilidades:

- gerar request ID;
    
- obter usuário;
    
- obter empresa;
    
- obter loja;
    
- obter sessão;
    
- obter device ID;
    
- obter IP;
    
- obter user-agent;
    
- obter endpoint;
    
- obter método HTTP;
    
- medir duração quando necessário;
    
- disponibilizar o contexto para serviços e signals.
    

O middleware atual baseado em thread-local poderá ser evoluído.

A solução deve continuar compatível com o modelo de execução atual do Django.

---

# 16. Transações

Existirão comportamentos diferentes conforme o evento.

## Evento confirmado

Eventos que representam operação concluída deverão ser registrados após commit:

```python
transaction.on_commit()
```

Exemplos:

- pedido aprovado;
    
- título baixado;
    
- produto alterado;
    
- estoque movimentado;
    
- contrato atualizado.
    

## Evento negado

Eventos de acesso negado devem ser registrados imediatamente.

Exemplos:

- login negado;
    
- acesso a outra empresa;
    
- módulo não contratado;
    
- permissão insuficiente;
    
- limite de sessão atingido.
    

## Evento de falha

Falhas devem ser registradas quando houver contexto seguro para isso.

Exemplos:

- integração rejeitada;
    
- emissão fiscal falhou;
    
- importação falhou;
    
- validação de negócio recusou operação.
    

## Rollback

Quando uma operação relevante sofrer rollback e isso puder ser detectado, o evento deverá possuir:

```text
result = ROLLED_BACK
```

Não registrar sucesso antes do commit.

---

# 17. Signals

Signals continuarão existindo apenas como mecanismo auxiliar.

Serão usados para CRUD simples e models cadastrados explicitamente.

Não será mantida uma lista genérica por app como única estratégia.

Será criado um registro central, por exemplo:

```python
AuditRegistry.register(
    Cliente,
    excluded_fields=["updated_at"],
    sensitive_fields=["documento"],
)
```

O registro deverá permitir:

- models incluídos;
    
- campos ignorados;
    
- campos sensíveis;
    
- representação do objeto;
    
- categoria;
    
- ações permitidas;
    
- empresa do objeto;
    
- loja do objeto.
    

Signals não serão usados para interpretar ações de negócio complexas.

---

# 18. Eventos explícitos de negócio

Ações relevantes devem registrar auditoria explicitamente.

Exemplo:

```python
AuditService.success(
    action="PURCHASE_ORDER_APPROVED",
    category="PURCHASE",
    instance=pedido,
    before={"status": "AB"},
    after={"status": "AP"},
)
```

Ações que exigem evento explícito incluem:

- aprovar;
    
- cancelar;
    
- reabrir;
    
- baixar;
    
- estornar;
    
- faturar;
    
- emitir;
    
- distribuir;
    
- transferir;
    
- finalizar;
    
- sincronizar;
    
- importar;
    
- encerrar sessão;
    
- alterar contrato;
    
- alterar permissões.
    

---

# 19. Sanitização

A sanitização deverá ser recursiva.

Campos proibidos:

```text
password
senha
token
authorization
cookie
secret
client_secret
private_key
certificate
certificado
refresh_token
access_token
session_token
```

Campos que podem exigir mascaramento:

- CPF;
    
- CNPJ;
    
- telefone;
    
- email;
    
- dados bancários;
    
- documentos pessoais;
    
- XML fiscal;
    
- informações financeiras sensíveis.
    

A auditoria deverá registrar apenas o necessário para explicar a operação.

---

# 20. Falha da própria auditoria

A auditoria não deve ocultar permanentemente suas próprias falhas.

Não será utilizada como solução definitiva:

```python
except Exception:
    pass
```

Regra:

1. eventos comuns não devem necessariamente derrubar a operação principal;
    
2. a falha deve ser registrada no logger;
    
3. deve existir métrica ou contador;
    
4. eventos críticos poderão usar modo estrito;
    
5. falhas deverão ser testadas;
    
6. a indisponibilidade da tabela durante migrations deverá ser tratada de forma controlada.
    

Poderá existir parâmetro:

```text
audit_required = true
```

para operações que não podem ser concluídas sem auditoria.

Exemplos candidatos:

- alteração de contrato;
    
- transferência de master;
    
- alteração de permissão;
    
- exclusão administrativa;
    
- operação fiscal crítica.
    

A adoção do modo estrito deverá ser gradual.

---

# 21. Endpoint

O endpoint continuará somente leitura.

Rota prevista:

```text
/api/auditoria/logs/
```

O queryset deverá respeitar:

- superusuário;
    
- empresa;
    
- loja;
    
- usuário;
    
- permissão efetiva;
    
- módulo contratado.
    

Não será utilizado `IsAdminUser` como regra principal.

A autorização deverá usar os mecanismos centrais do SISVAR.

---

# 22. Filtros

Filtros previstos:

- período inicial;
    
- período final;
    
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
    
- endpoint;
    
- status HTTP.
    

Filtros globais por empresa só estarão disponíveis ao superusuário da plataforma.

---

# 23. Tela

A tela seguirá o padrão visual oficial.

## Barra do título

```text
Auditoria do Sistema
```

## Indicadores

- total no período;
    
- sucessos;
    
- falhas;
    
- acessos negados;
    
- eventos críticos.
    

## Filtros

- período;
    
- empresa;
    
- loja;
    
- usuário;
    
- categoria;
    
- ação;
    
- resultado;
    
- severidade;
    
- módulo;
    
- entidade;
    
- objeto;
    
- IP;
    
- request ID.
    

## Resultado

Colunas:

- data e hora;
    
- usuário;
    
- empresa;
    
- loja;
    
- categoria;
    
- ação;
    
- resultado;
    
- entidade;
    
- objeto;
    
- IP;
    
- severidade.
    

## Detalhe

Deverá apresentar:

- contexto;
    
- antes;
    
- depois;
    
- campos alterados;
    
- metadata;
    
- requisição;
    
- sessão;
    
- dispositivo;
    
- erro;
    
- correlação.
    

A diferença deverá ser apresentada de maneira legível.

Não exibir apenas JSON bruto como interface principal.

---

# 24. Exportação

Usuários autorizados poderão exportar apenas os registros que conseguem consultar.

Formatos iniciais:

- CSV;
    
- Excel, quando o padrão de exportação do sistema estiver disponível.
    

A exportação deverá:

- respeitar os filtros;
    
- respeitar empresa;
    
- respeitar loja;
    
- respeitar permissões;
    
- mascarar dados sensíveis;
    
- limitar volume;
    
- registrar evento de exportação;
    
- impedir exportação global por usuário cliente.
    

---

# 25. Retenção

Decisão inicial:

- retenção padrão de cinco anos;
    
- eventos fiscais e financeiros podem exigir prazo maior;
    
- eventos críticos de segurança podem possuir regra própria;
    
- exclusão somente por command administrativo;
    
- exclusão auditada;
    
- possibilidade futura de arquivamento antes da exclusão.
    

A retenção será configurada por categoria.

Usuários clientes não poderão alterar a política.

A implementação da retenção poderá ocorrer em fase posterior, sem impedir a criação da infraestrutura central.

---

# 26. Índices

Índices mínimos:

```text
empresa + created_at
empresa + category + created_at
empresa + user + created_at
empresa + app_label + model + object_id
loja + created_at
request_id
correlation_id
event_id
result + severity + created_at
```

Campos usados frequentemente em filtros terão colunas próprias.

Não depender de consultas em JSON para filtros principais.

---

# 27. Performance

A implementação deverá evitar:

- N+1;
    
- carregamento global;
    
- ausência de paginação;
    
- snapshots excessivamente grandes;
    
- JSON sem limite;
    
- auditoria duplicada;
    
- consultas sem índice;
    
- gravação desnecessária para leituras.
    

A auditoria de consultas simples não será automática por padrão.

Serão auditadas consultas sensíveis ou exportações quando necessário.

---

# 28. Migração da estrutura atual

A migration deverá preservar os logs existentes.

Estratégia:

1. adicionar novos campos como opcionais;
    
2. migrar dados aproveitáveis;
    
3. mapear `changes` para a nova estrutura quando possível;
    
4. manter compatibilidade temporária;
    
5. atualizar serializers e views;
    
6. substituir gradualmente chamadas antigas;
    
7. remover campos legados apenas em etapa posterior.
    

Não apagar logs existentes.

---

# 29. Integração gradual

Ordem:

1. infraestrutura central;
    
2. autenticação e sessões;
    
3. contratos;
    
4. módulos;
    
5. perfis;
    
6. permissões;
    
7. usuários;
    
8. cadastros;
    
9. produtos e preços;
    
10. compras;
    
11. estoque;
    
12. financeiro;
    
13. fiscal;
    
14. vendas e PDV;
    
15. produção;
    
16. distribuição;
    
17. relatórios;
    
18. rotinas automáticas.
    

Cada módulo deverá atualizar sua própria documentação ao ser integrado.

---

# 30. Testes obrigatórios

## Backend

Testar:

- criação de evento;
    
- sanitização;
    
- snapshots;
    
- empresa;
    
- loja;
    
- usuário;
    
- sessão;
    
- request ID;
    
- sucesso após commit;
    
- evento negado imediato;
    
- falha;
    
- rollback;
    
- isolamento entre empresas;
    
- isolamento por loja;
    
- permissões de consulta;
    
- imutabilidade;
    
- bloqueio de criação pela API;
    
- bloqueio de alteração;
    
- bloqueio de exclusão;
    
- filtros;
    
- paginação;
    
- exportação;
    
- falha da própria auditoria;
    
- compatibilidade com logs antigos.
    

## Frontend

Testar:

- carregamento;
    
- indicadores;
    
- filtros;
    
- paginação;
    
- detalhe;
    
- antes e depois;
    
- restrição por empresa;
    
- restrição por loja;
    
- restrição por permissão;
    
- exportação;
    
- tratamento de erro.
    

---

# 31. Consequências

## Positivas

- rastreabilidade;
    
- maior segurança;
    
- suporte mais eficiente;
    
- investigação de problemas;
    
- histórico confiável;
    
- isolamento multiempresa;
    
- base para compliance;
    
- padronização dos módulos;
    
- menor dependência de logs técnicos dispersos.
    

## Negativas

- aumento de armazenamento;
    
- necessidade de índices;
    
- custo adicional de gravação;
    
- necessidade de sanitização;
    
- integração gradual;
    
- aumento do esforço de testes;
    
- necessidade de política de retenção.
    

Os custos são aceitos porque a auditoria é infraestrutura essencial para um ERP SaaS.

---

# Resultado esperado

Quando concluída, a Auditoria Central deverá permitir responder:

- quem realizou a operação;
    
- em qual empresa;
    
- em qual loja;
    
- em qual sessão;
    
- em qual dispositivo;
    
- em qual momento;
    
- sobre qual objeto;
    
- qual era o estado anterior;
    
- qual passou a ser o estado posterior;
    
- qual foi o resultado;
    
- qual erro ocorreu;
    
- qual requisição originou o evento;
    
- quais outros eventos pertencem à mesma operação.
    

---

# Situação da implementação

## Existente

- app `auditoria`;
    
- model `AuditLog`;
    
- middleware;
    
- thread-local;
    
- signals;
    
- serializer;
    
- endpoint somente leitura;
    
- filtros;
    
- registros manuais de eventos de segurança.
    

## A implementar

- empresa;
    
- loja;
    
- snapshots;
    
- classificação;
    
- contexto de sessão;
    
- request ID;
    
- correlation ID;
    
- estrutura antes/depois;
    
- serviço central;
    
- registry;
    
- imutabilidade;
    
- permissões efetivas;
    
- isolamento;
    
- sanitização;
    
- transações;
    
- frontend completo;
    
- exportação;
    
- testes.
    

---

# Decisão final

O SISVAR adotará uma Auditoria Central única e obrigatória para operações críticas.

Não serão criados mecanismos paralelos por módulo.

Signals serão auxiliares.

Eventos de negócio serão explícitos.

A consulta será somente leitura e isolada por empresa.

Logs serão imutáveis e sanitizados.

A integração será gradual.

---

# Notas relacionadas

- [[10 Projetos/Sysvar/Sysvar|Sysvar]]
    
- [[10 Projetos/Sysvar/Contexto do Projeto/Arquitetura|Arquitetura]]
    
- [[10 Projetos/Sysvar/Contexto do Projeto/Modelo de Domínio|Modelo de Domínio]]
    
- [[10 Projetos/Sysvar/Contexto do Projeto/Workflows|Workflows]]
    
- [[10 Projetos/Sysvar/Contexto do Projeto/Riscos e Cuidados|Riscos e Cuidados]]
    
- [[10 Projetos/Sysvar/Decisões Técnicas/ADR-001 - Licenciamento por Sessões Simultâneas|ADR-001 - Licenciamento por Sessões Simultâneas]]
    
- [[10 Projetos/Sysvar/Decisões Técnicas/ADR-002 - Princípios Arquiteturais do SISVAR|ADR-002 - Princípios Arquiteturais do SISVAR]]