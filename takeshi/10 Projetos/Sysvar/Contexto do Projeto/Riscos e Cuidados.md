---
type: reference
status: active
project: Sysvar
source: "C:/SysvarProjeto"
created: 2026-08-03
updated: 2026-08-06
tags:
  - sysvar
  - riscos
  - arquitetura
  - segurança
  - operacional
  - auditoria
  - multiempresa
  - sessões
  - homologado
---

# Riscos e Cuidados

## Objetivo

Este documento reúne os principais riscos técnicos, funcionais e arquiteturais do SISVAR.

Ele deve ser consultado durante:

- novas implementações;
- correções;
- refatorações;
- migrations;
- revisão de módulos;
- alterações de segurança;
- homologações;
- integrações;
- deploys.

Uma funcionalidade implementada e testada continua sujeita a regressões.

Toda alteração em regras estruturais deve ser acompanhada de:

- análise de impacto;
- testes;
- revisão técnica;
- homologação;
- atualização da documentação.

---

# Situação do Grupo Operacional

O grupo Operacional foi:

```text
IMPLEMENTADO
TESTADO AUTOMATICAMENTE
HOMOLOGADO MANUALMENTE
DOCUMENTADO
```

Foram homologados:

- empresas;
- contratos;
- suspensão;
- reativação;
- estabelecimentos;
- usuários;
- perfis;
- permissões;
- sessões;
- licenciamento simultâneo;
- superusuário sem consumo de licença;
- administração de sessões;
- contador de sessões;
- logout;
- bloqueio por limite;
- liberação de vagas;
- modal `Ver Sessões`;
- Auditoria Central.

A conclusão do Operacional não elimina os riscos de regressão.

As regras descritas neste documento devem continuar sendo protegidas em futuras alterações.

---

# Regra Geral

Nunca considerar uma funcionalidade segura apenas porque funcionou no frontend.

Toda operação relevante deve ser validada novamente no backend.

Não confiar isoladamente em:

- JavaScript;
- LocalStorage;
- SessionStorage;
- query parameters;
- payload;
- URL;
- IDs enviados pelo cliente;
- campos ocultos;
- botões ocultos;
- menus ocultos;
- validações do formulário;
- informações mantidas no navegador.

O backend é a autoridade final.

---

# Multiempresa

## Isolamento

Todo dado pertencente a um cliente deve possuir empresa identificável.

O backend deve impedir que um usuário de uma empresa consiga:

- listar dados de outra empresa;
- consultar dados de outra empresa;
- alterar dados de outra empresa;
- excluir dados de outra empresa;
- utilizar estabelecimento de outra empresa;
- utilizar perfil de outra empresa;
- utilizar fornecedor de outra empresa;
- utilizar cliente de outra empresa;
- utilizar produto de outra empresa;
- consultar sessões de outra empresa;
- consultar auditoria de outra empresa;
- exportar dados de outra empresa;
- vincular objetos de empresas diferentes.

O risco de vazamento não está apenas no queryset.

Também existe em:

- serializers;
- actions;
- services;
- commands;
- signals;
- imports;
- exports;
- tarefas automáticas;
- integrações;
- SQL manual;
- ForeignKeys recebidas no payload.

---

## Querysets

Todo queryset de dados empresariais deve ser limitado pela empresa do usuário ou por contexto administrativo global autorizado.

Evitar:

```python
Model.objects.all()
```

em endpoints de usuário cliente sem aplicação garantida do escopo.

Não confiar que o frontend enviará o filtro correto.

---

## Relacionamentos

Mesmo com queryset filtrado, um usuário pode enviar um ID de outra empresa.

Validar sempre:

- empresa do objeto principal;
- empresa da ForeignKey;
- empresa do estabelecimento;
- empresa do perfil;
- empresa do usuário afetado;
- empresa do documento;
- empresa da sessão.

Não permitir vínculo cruzado.

---

## Superusuário

O acesso global deve depender de `is_superuser` ou da regra oficial da plataforma.

Não transformar automaticamente qualquer usuário `is_staff` em administrador global do SISVAR.

Permissões internas do Django não substituem as regras do sistema.

O superusuário:

- possui sessão;
- possui token;
- não pertence a uma empresa cliente;
- não consome licença de nenhuma empresa;
- não deve aparecer na listagem de sessões que ocupam licença de uma empresa.

Essa regra foi homologada manualmente.

Não reintroduzir vínculo automático entre superusuário e empresa.

---

# Multilojas e Estabelecimentos

## Empresa Obrigatória

Todo estabelecimento deve possuir empresa.

O campo `Loja.empresa` foi tornado obrigatório após diagnóstico real:

```text
lojas_sem_empresa = 0
```

Cuidados futuros:

- nunca voltar a permitir `null=True`;
- não criar estabelecimento sem empresa em command ou import;
- não aceitar empresa nula no serializer;
- não permitir remover a empresa em atualização;
- não utilizar empresa padrão arbitrária.

---

## Isolamento por Estabelecimento

Quando o domínio depender de estabelecimento, validar:

- se o estabelecimento pertence à empresa;
- se o usuário possui acesso;
- se o estabelecimento é permitido;
- se o estabelecimento principal pertence à empresa;
- se a sessão está ligada ao contexto correto;
- se o objeto pertence ao estabelecimento;
- se a operação permite estabelecimento nulo.

Não confiar apenas no seletor visual do frontend.

---

## Estabelecimento Principal

O estabelecimento principal deve estar incluído nos estabelecimentos permitidos.

Não permitir:

- estabelecimento principal de outra empresa;
- estabelecimento permitido de outra empresa;
- remoção do estabelecimento principal sem ajuste correspondente;
- definição automática de estabelecimento arbitrário.

---

## Eventos sem Estabelecimento

Nem toda operação pertence a um estabelecimento.

Exemplos:

- contrato;
- perfil;
- permissão;
- suspensão da empresa;
- configuração global.

Não inventar estabelecimento apenas para preencher auditoria.

---

# Contratos

## Validação do Contrato

Toda autenticação de usuário cliente depende de contrato válido.

Validar:

- existência;
- status;
- vigência;
- empresa;
- módulos;
- limite de sessões;
- usuário master;
- suspensão;
- cancelamento.

A validação deve ocorrer:

- no login;
- no heartbeat;
- em requisições autenticadas;
- em operações administrativas sensíveis.

---

## Estados

Estados como:

```text
PENDENTE
ATIVO
SUSPENSO
VENCIDO
CANCELADO
```

possuem significados diferentes.

Não tratar todos como simples booleano ativo/inativo.

Não reutilizar `INADIMPLENTE` como estado operacional.

Inadimplência é motivo de suspensão.

---

# Suspensão Administrativa

## Ação Crítica

Suspender uma empresa bloqueia todos os usuários.

Por isso, a operação deve exigir:

- superusuário;
- motivo;
- confirmação explícita;
- transação;
- bloqueio do contrato;
- Auditoria obrigatória.

Nunca permitir suspensão por simples edição genérica do status.

---

## Risco de Suspensão Acidental

Uma suspensão indevida pode paralisar todas as unidades do cliente.

A interface deve informar:

- nome da empresa;
- status atual;
- quantidade de sessões ativas;
- consequência da ação;
- necessidade de novo login após reativação.

A confirmação deve reduzir o risco de clique acidental.

---

## Atomicidade

A suspensão deve ser totalmente atômica.

Na mesma transação devem ocorrer:

1. alteração do contrato;
2. gravação do motivo;
3. encerramento das sessões;
4. revogação dos tokens;
5. liberação das vagas;
6. incremento de `permissions_version`;
7. Auditoria obrigatória.

Se qualquer etapa falhar, tudo deve sofrer rollback.

Não aceitar estado parcial como:

- contrato suspenso com sessão ativa;
- contrato ativo com tokens revogados;
- algumas sessões encerradas e outras não;
- suspensão sem auditoria.

---

## Bloqueio em Vários Pontos

Não basta bloquear somente o login.

Contrato suspenso deve ser recusado em:

- autenticação;
- validação do token;
- heartbeat;
- requisição autenticada;
- criação de sessão;
- renovação de contexto.

Isso reduz o risco de uma sessão antiga continuar funcionando.

---

## Mensagem Pública

Usuário comum deve receber mensagem genérica:

```text
O acesso da empresa está temporariamente suspenso. Entre em contato com o suporte.
```

Não expor:

- inadimplência;
- valores;
- cobrança;
- motivo comercial;
- observações internas.

---

## Reativação

A reativação não deve:

- reabrir sessões antigas;
- restaurar tokens anteriores;
- reutilizar sessão revogada;
- ocultar o histórico da suspensão.

Todo usuário deve realizar novo login.

---

# Autenticação

## Serviço Central

É proibido criar autenticação paralela.

Toda autenticação deve considerar:

- credenciais;
- usuário ativo;
- empresa;
- contrato;
- status;
- perfil;
- módulos;
- sessão;
- dispositivo;
- limite simultâneo;
- troca obrigatória de senha.

---

## Tokens

Nunca armazenar token bruto.

Persistir somente hash.

Nunca registrar:

- token;
- hash do token;
- Authorization;
- cookie;
- access token;
- refresh token;
- credencial temporária.

Token revogado ou sem sessão válida não autentica.

---

## Credenciais Inválidas

O evento de login negado não deve armazenar:

- senha;
- payload completo;
- token;
- dados desnecessários.

A resposta não deve facilitar enumeração de usuários.

---

# Sessões Simultâneas

## Regra Oficial

Licença é consumida por sessão válida.

Não por:

- usuário cadastrado;
- usuário ativo;
- perfil;
- estabelecimento;
- senha;
- dispositivo sem login.

Nunca retornar ao controle por quantidade de usuários ativos.

---

## Fonte Única de Verdade

A validade da sessão deve ser calculada pelo serviço central.

Métodos existentes:

```text
ConcurrentSessionService.valid_sessions_queryset
ConcurrentSessionService.active_sessions_queryset
ConcurrentSessionService.count_active_sessions
ConcurrentSessionService.session_validity
ConcurrentSessionService.is_session_valid
```

Login, contador, disponibilidade, heartbeat e listagem devem utilizar a mesma regra.

Não criar consulta paralela baseada somente em:

```python
SessaoUsuario.objects.filter(ativa=True)
```

Esse filtro isolado pode incluir sessões inválidas.

---

## Critérios de Validade

Uma sessão ocupa licença quando, conforme o serviço central:

- está ativa;
- não possui encerramento;
- não expirou;
- pertence a usuário ativo;
- pertence a empresa válida;
- possui contrato válido;
- possui token;
- o token não está revogado.

Sessões inválidas não podem ocupar vagas.

---

## Concorrência da Última Vaga

A contagem e a criação da sessão devem permanecer na mesma transação.

O contrato deve ser bloqueado.

Não executar:

1. contagem;
2. fim da transação;
3. criação posterior.

Isso permite ultrapassar o limite.

---

## Login Bloqueado

Quando o limite for atingido:

- nenhuma sessão válida deve ser criada;
- nenhum token utilizável deve ser criado;
- o contador não pode aumentar;
- o evento de bloqueio deve ser auditado;
- o frontend não pode guardar contexto de autenticação.

Código:

```text
CONCURRENT_SESSION_LIMIT_REACHED
```

---

## Mesmo Usuário e Mesmo Dispositivo

Novo login do mesmo usuário no mesmo dispositivo deve:

- encerrar somente a sessão anterior desse usuário;
- revogar o token anterior;
- criar nova sessão;
- manter apenas uma vaga consumida.

Regra:

```text
mesmo usuário + mesmo device_id
→ substituição
```

---

## Usuários Diferentes no Mesmo Dispositivo

Usuários diferentes podem utilizar o mesmo `device_id`.

Regra:

```text
usuários diferentes + mesmo device_id
→ sessões independentes
```

Não substituir a sessão de outro usuário apenas por compartilhar navegador ou dispositivo.

Cada sessão válida consome uma vaga.

---

## Timeout

Sessões abandonadas não podem ocupar vaga indefinidamente.

O timeout deve:

- encerrar sessão;
- revogar token;
- liberar vaga;
- registrar motivo;
- gerar auditoria quando aplicável.

---

## Heartbeat

O heartbeat não substitui a validação de cada requisição.

Cada chamada autenticada ainda deve validar:

- token;
- sessão;
- expiração;
- usuário;
- empresa;
- contrato;
- suspensão;
- troca obrigatória de senha.

---

## Redução do Limite

Reduzir o limite abaixo das sessões válidas atuais não encerra sessões automaticamente.

O sistema deve:

- preservar sessões atuais;
- bloquear novos logins;
- reduzir o excesso por logout, timeout ou encerramento administrativo.

Mudança nessa regra exige nova decisão arquitetural.

---

# Logout

## Ordem Correta

O frontend deve:

1. manter o token atual;
2. chamar o endpoint de logout;
3. aguardar a resposta;
4. somente depois limpar o token local;
5. interromper o heartbeat;
6. limpar o contexto;
7. redirecionar para o login.

Não apagar o token antes da chamada ao backend.

Esse erro já ocorreu e causava:

- sessão não encerrada;
- licença não liberada;
- contador incorreto;
- bloqueio indevido de novos logins.

O fluxo foi corrigido e homologado manualmente.

---

## Encerramento no Backend

O backend deve:

- identificar o token exato;
- localizar a sessão vinculada;
- marcar a sessão como inativa;
- preencher `encerrada_em`;
- registrar motivo `LOGOUT`;
- revogar o token;
- liberar a vaga;
- registrar Auditoria.

Não localizar sessão de forma aproximada quando existe token exato.

---

# Administração de Sessões

## Necessidade Operacional

O suporte e o administrador precisam identificar quem está ocupando as licenças.

Não pode ser necessário consultar diretamente o banco.

A interface deve permitir:

- visualizar sessões por empresa;
- visualizar sessões por usuário;
- identificar usuário;
- identificar perfil;
- identificar estabelecimento;
- identificar dispositivo;
- identificar navegador;
- identificar sistema operacional;
- identificar IP;
- visualizar início;
- visualizar última atividade;
- visualizar status;
- visualizar token válido ou revogado;
- encerrar sessão.

---

## Contador e Listagem

A regra obrigatória é:

```text
contador de sessões ativas
=
quantidade de sessões válidas exibidas
```

O contador e a listagem devem usar a mesma fonte de verdade.

Não aplicar no frontend filtros paralelos sobre:

- `ativa`;
- `status`;
- `token_valido`;
- `token_revogado`.

O backend deve retornar as sessões corretas.

---

## Formato da Resposta da API

O frontend deve tratar corretamente:

Resposta direta:

```json
[
  {}
]
```

Resposta paginada:

```json
{
  "count": 1,
  "results": [
    {}
  ]
}
```

A normalização deve ficar centralizada no service.

Não duplicar esse tratamento em vários componentes.

---

## Estado Vazio

Mostrar:

```text
Nenhuma sessão ocupando licença.
```

somente quando não existir nenhuma sessão válida na listagem.

Não mostrar estado vazio quando há uma linha carregada.

---

## Mensagem de Divergência

Mostrar aviso somente quando:

```text
contador != quantidade de linhas
```

Não mostrar divergência quando:

```text
contador = 1
linhas = 1
```

Esse erro visual já ocorreu e foi corrigido.

---

## Sessão Individual

Encerrar uma sessão deve:

- validar empresa;
- validar executor;
- validar permissão;
- revogar token;
- liberar vaga;
- registrar motivo;
- auditar;
- atualizar listagem;
- atualizar contador;
- atualizar quantidade disponível.

---

## Todas as Sessões do Usuário

O encerramento consolidado deve ser transacional.

A operação deve:

- bloquear usuário;
- bloquear sessões;
- encerrar todas as sessões válidas;
- revogar todos os tokens correspondentes;
- criar um evento consolidado;
- confirmar tudo junto.

Se a Auditoria obrigatória falhar:

- nenhuma sessão deve ser encerrada;
- nenhum token deve ser revogado.

---

## Duplicidade de Auditoria

Evitar registrar simultaneamente:

- um evento consolidado;
- eventos individuais equivalentes;
- evento do signal;
- evento da view;
- evento do service.

A política precisa ser clara.

Para encerramento em massa, o evento principal é:

```text
USER_SESSIONS_CLOSED
```

---

# Diagnóstico de Sessões

O command oficial é:

```powershell
python manage.py diagnosticar_sessoes_empresa --empresa-id <id>
```

O diagnóstico pode mostrar:

- ID da sessão;
- usuário;
- empresa;
- dispositivo;
- estado;
- encerramento;
- última atividade;
- token existente;
- token revogado;
- validade;
- motivo da não validade.

Nunca exibir token bruto.

---

# Reconciliação de Sessões

Commands:

```powershell
python manage.py reconciliar_sessoes_ativas --empresa-id <id> --dry-run
python manage.py reconciliar_sessoes_ativas --empresa-id <id> --apply
```

O `dry-run` não altera dados.

O `apply` deve:

- preservar histórico;
- encerrar sessões inválidas;
- revogar tokens restantes;
- registrar motivo coerente;
- não apagar registros.

Possíveis inconsistências:

- sessão ativa com token revogado;
- sessão ativa sem token;
- sessão ativa com `encerrada_em` preenchido;
- sessão expirada ainda ativa;
- token válido ligado a sessão encerrada.

---

# Usuários

## Empresa

Usuário cliente deve pertencer a uma empresa.

Não permitir:

- empresa nula;
- troca para outra empresa;
- edição pelo próprio usuário;
- empresa recebida livremente do frontend.

---

## Perfil Principal

Usuário comum deve possuir perfil principal válido.

O perfil deve:

- estar ativo;
- pertencer à mesma empresa;
- utilizar módulos permitidos;
- respeitar dependências.

---

## Tipo Funcional

O campo `type` não define permissão efetiva.

Nunca usar tipo funcional para:

- conceder módulo;
- retirar módulo;
- sobrescrever perfil;
- criar override;
- elevar acesso.

Tipos antigos podem continuar em regras específicas, mas não como autoridade de segurança.

---

## Autoproteção

O usuário não pode:

- aumentar a própria permissão;
- trocar o próprio perfil;
- ampliar os próprios estabelecimentos;
- alterar a própria empresa;
- tornar-se master;
- alterar campos internos.

---

## Campos Protegidos

Usuários clientes não podem alterar:

```text
is_staff
is_superuser
groups
user_permissions
empresa
master
token
session_id
session_token
```

O backend deve rejeitar explicitamente.

Não apenas ocultar no frontend.

---

## Usuário Master

O master não pode ser:

- excluído;
- inativado;
- movido de empresa;
- rebaixado;
- privado de acesso essencial.

Antes disso, deve ocorrer transferência de administração.

O master pertence à empresa e consome licença quando possui sessão válida.

Não confundir master com superusuário da plataforma.

---

# Perfis e Permissões

## Default Deny

Ausência de permissão significa bloqueio.

Não criar fallback permissivo.

---

## Nomes de Perfil

Não conceder acesso com base no nome:

```text
Admin
Gerente
Master
Diretor
```

O acesso depende do cálculo efetivo.

---

## Roles Antigas

Rotas não devem depender exclusivamente de:

```typescript
roles: ['Admin']
roles: ['Diretor', 'Gerente']
```

Esse problema já foi corrigido em:

- Auditoria;
- Estabelecimentos;
- Perfis;
- demais rotas do Operacional.

Não reintroduzir.

---

## Perfil Padrão

O MySQL não garante constraint condicional do Django.

A regra de um perfil padrão por empresa deve continuar garantida por:

- transação;
- `select_for_update`;
- serviço central;
- testes concorrentes.

---

## Dependências de Módulos

Módulos dependentes devem respeitar `ModuloSistema.dependencias`.

Não permitir:

- módulo dependente em `VIEW` ou `EDIT`;
- dependência necessária em `NONE`.

Não inventar dependências no frontend.

A fonte é o catálogo do backend.

---

## Módulos Hardcoded

Evitar listas fixas diferentes em:

- usuário;
- perfil;
- menu;
- guard;
- frontend;
- backend.

O catálogo deve vir do backend.

A ordenação deve utilizar o cadastro do módulo.

---

## Override

Valores possíveis:

```text
HERDAR
NONE
VIEW
EDIT
```

`HERDAR` deve remover o override individual.

Não persistir valor redundante sem necessidade.

---

## Permissão Efetiva

A permissão efetiva considera:

- contrato;
- módulo contratado;
- perfil;
- override;
- master;
- superusuário;
- status do usuário;
- status do contrato.

O frontend exibe.

O backend calcula.

---

# Redefinição de Senha

## Operação Administrativa

A redefinição deve ser transacional.

Na mesma operação:

1. senha é alterada;
2. `deve_trocar_senha` é marcado;
3. sessões são encerradas, quando previsto;
4. tokens são revogados;
5. Auditoria obrigatória é criada.

Se a Auditoria falhar, tudo deve voltar ao estado anterior.

---

## Senhas na Auditoria

Nunca registrar:

- senha atual;
- senha nova;
- confirmação;
- hash;
- senha temporária.

O sanitizer deve continuar protegendo esses campos.

---

## Exposição da Senha

Não:

- retornar senha na API;
- mostrar senha cadastrada;
- guardar no navegador;
- enviar por log;
- incluir em exception;
- persistir em metadata.

---

# Troca Obrigatória de Senha

## Bloqueio Central

Quando:

```text
deve_trocar_senha = true
```

o usuário não deve acessar módulos normais.

O bloqueio precisa ocorrer no backend centralmente.

Não depender apenas do guard Angular.

---

## Endpoints Permitidos

Durante a pendência, liberar apenas:

- `/api/me/`;
- troca de senha;
- logout;
- heartbeat necessário.

Qualquer outro endpoint deve retornar:

```text
PASSWORD_CHANGE_REQUIRED
```

---

## Bypass por URL

O frontend deve impedir acesso direto a:

```text
/home
/config
/lojas
/usuarios
```

mas o backend ainda deve bloquear caso o usuário chame a API manualmente.

---

## Sessão Atual

Após a troca:

- sessão atual pode permanecer;
- demais sessões devem ser encerradas;
- token atual permanece válido conforme a regra implementada;
- contexto deve ser recarregado.

Não criar uma sessão adicional e consumir nova licença.

---

## Nova Senha

Validar:

- senha atual;
- confirmação;
- diferença em relação à atual;
- validadores do Django;
- tamanho mínimo;
- regras de segurança.

---

# Estabelecimentos

## Empresa Obrigatória

Não permitir estabelecimento sem empresa.

Isso vale para:

- API;
- admin;
- command;
- import;
- migration;
- testes;
- scripts.

---

## Tipo de Unidade

`tipo_unidade` é a fonte principal.

O campo legado `Matriz` não pode contradizer o tipo.

Manter sincronização enquanto existir compatibilidade.

---

## Campos Legados

Campos antigos não devem ser removidos sem análise:

```text
EstoqueNegativo
Rede
DataAbertura
ContaContabil
DataEnceramento
Matriz
```

Antes de remover:

- localizar usos;
- revisar frontend;
- revisar API;
- criar migration;
- preservar dados;
- documentar breaking change.

---

## Ciclo de Vida

Não usar apenas edição direta de `ativo`.

Ações oficiais:

```text
Ativar
Inativar
Encerrar
Reabrir
```

Cada ação possui significado próprio e deve ser auditada.

---

## Inativação

Antes de inativar, verificar:

- sessões;
- usuários;
- estabelecimento principal;
- caixas;
- estoque;
- documentos;
- operações pendentes;
- distribuição;
- integrações.

Não automatizar transferências sem projeto específico.

---

## Encerramento

Encerrar não pode apagar histórico.

Deve preservar:

- vendas;
- documentos;
- estoque histórico;
- sessões;
- usuários;
- Auditoria.

---

## Fiscal

Alterações em:

- série NFC-e;
- próximo número NFC-e;
- série NF-e;
- próximo número NF-e;
- habilitação de emissão;
- política de estoque negativo;

devem possuir validação e auditoria.

Numeração inválida pode causar rejeição fiscal.

---

# Auditoria Central

## Infraestrutura Única

O app oficial é:

```text
auditoria
```

O serviço oficial é:

```text
AuditService
```

Não criar:

- tabela paralela;
- middleware paralelo;
- serviço paralelo;
- gravações diretas espalhadas.

---

## Imutabilidade

Não permitir:

- `save()` em log existente;
- `delete()`;
- `QuerySet.update()`;
- `QuerySet.delete()`;
- `bulk_create()`;
- `bulk_update()`;
- `update_or_create()`;
- `get_or_create()`.

---

## Auditoria Normal

Eventos comuns podem usar:

```python
transaction.on_commit()
```

Não registrar sucesso antes do commit.

---

## Auditoria Obrigatória

Operações críticas do Operacional incluem:

- suspensão;
- reativação;
- transferência de master;
- perfil padrão;
- permissões;
- redefinição de senha;
- troca obrigatória;
- encerramento consolidado de sessões;
- exclusão administrativa.

Se a Auditoria falhar, a operação deve falhar.

---

## Dados Sensíveis

Nunca registrar:

- senha;
- token;
- cookie;
- Authorization;
- certificado;
- chave privada;
- hash de token;
- segredo;
- payload completo de autenticação.

---

## Duplicidade

Uma ação não pode gerar eventos equivalentes por:

- signal;
- serializer;
- view;
- service;
- wrapper legado.

Testes devem conferir contagem exata.

---

# Frontend

## Permissão Visual

O frontend deve ocultar ações sem autorização.

Exemplos:

- master não vê suspender empresa;
- usuário comum não vê alterar contrato;
- VIEW não vê editar;
- NONE não vê menu;
- usuário com troca pendente não acessa módulos.

Mas a segurança final permanece no backend.

---

## Tratamento de 401 e 403

401 pode representar:

- token inválido;
- sessão expirada;
- sessão encerrada.

403 pode representar:

- sem permissão;
- contrato suspenso;
- troca obrigatória;
- empresa incorreta;
- estabelecimento não permitido.

Não tratar todo 403 como logout automático sem considerar o código retornado.

---

## Paginação

Não carregar milhares de registros e paginar somente no navegador.

Listagens devem utilizar paginação real da API.

Preservar:

```text
Mostrando X–Y de Z
```

---

## Cache e Estado Local

Contadores e listas administrativas não devem permanecer presos a dados antigos.

Após:

- login;
- logout;
- encerramento de sessão;
- atualização do modal;
- suspensão;
- reativação;

o frontend deve recarregar os dados necessários.

Cuidado com:

- `shareReplay`;
- objetos mantidos em memória;
- indicadores calculados sobre resposta antiga;
- ausência de recarga;
- filtros locais adicionais.

---

# Banco de Dados

## Migrations

Toda mudança estrutural deve possuir migration.

Não editar migration já aplicada.

---

## Data Migrations

Usar:

```python
apps.get_model()
```

Não importar model atual diretamente.

Considerar:

- banco vazio;
- banco com dados;
- MySQL;
- registros nulos;
- volume;
- ambiguidade;
- rollback.

---

## Saneamento

Nunca preencher empresa com valor arbitrário.

Não usar:

- primeira empresa;
- empresa mais antiga;
- empresa do superusuário;
- empresa padrão inventada.

Quando houver ambiguidade, parar e documentar.

---

## Constraints MySQL

Não confiar em recursos não suportados.

Sempre conferir avisos durante migration.

---

# Performance

## Consultas

Evitar:

- N+1;
- queries globais;
- consultas sem índice;
- paginação local;
- payloads grandes;
- filtros frequentes em JSON.

Utilizar:

- paginação;
- índices;
- `select_related`;
- `prefetch_related`;
- agregações;
- endpoints de indicadores.

---

## Indicadores

Indicadores não devem ser calculados apenas sobre a página atual.

Devem respeitar:

- empresa;
- estabelecimento;
- filtros;
- permissão;
- regra central do domínio.

O contador de sessões deve usar o mesmo método utilizado pelo login e pela listagem.

---

# Testes

## Testes Automatizados

Rodadas registradas durante o fechamento do Operacional:

```text
Backend: 59 testes aprovados na centralização das sessões
Frontend: 37 testes aprovados na centralização das sessões
```

Testes posteriores foram adicionados para:

- superusuário sem consumo de licença;
- sessões por empresa;
- sessões por usuário;
- encerramento individual;
- encerramento consolidado;
- resposta em array;
- resposta paginada;
- contador;
- estado vazio;
- modal `Ver Sessões`;
- atualização após encerramento.

Os totais devem ser confirmados novamente antes de uma nova declaração formal.

---

## Homologação Manual

Foram homologados manualmente:

- primeiro login;
- segundo login;
- bloqueio acima do limite;
- logout liberando vaga;
- novo login após liberação;
- superusuário sem consumo de licença;
- contador de sessões;
- quantidade disponível;
- modal `Ver Sessões`;
- consistência entre contador e listagem;
- administração visual das sessões.

Status:

```text
OPERACIONAL HOMOLOGADO
```

---

# Riscos Mitigados no Operacional

Foram tratados:

- suspensão administrativa;
- bloqueio imediato do contrato;
- encerramento de sessões;
- revogação de tokens;
- reativação segura;
- empresa obrigatória em estabelecimentos;
- remoção da dependência exclusiva de roles antigas;
- perfil como base das permissões;
- override `HERDAR`;
- dependências de módulos;
- proteção do master;
- transação no encerramento de sessões;
- transação na redefinição de senha;
- troca obrigatória de senha;
- bloqueio central durante troca;
- Auditoria dos novos eventos;
- fonte única de validade das sessões;
- correção da ordem do logout;
- superusuário fora do licenciamento;
- administração visual de sessões;
- consistência entre contador e listagem;
- diagnóstico de sessões;
- reconciliação de sessões;
- testes backend e frontend;
- homologação manual.

---

# Riscos Ainda Abertos

## Regressão no Licenciamento

Apesar da homologação, alterações futuras podem reintroduzir:

- contagem apenas por `ativa=True`;
- logout sem token;
- sessão bloqueada criada indevidamente;
- superusuário associado a empresa;
- divergência entre contador e listagem;
- filtros paralelos no frontend.

Toda alteração em autenticação, sessão ou contrato deve repetir os testes do licenciamento.

---

## Campos Legados de Loja

Ainda precisam ser revisados em fase futura para possível remoção.

---

## Tipos Funcionais Antigos

O campo `type` continua existindo.

Deve ser monitorado para evitar que novas regras voltem a utilizá-lo como permissão.

---

## Automação de Suspensão

Nesta fase, a suspensão é manual.

Ainda não existe:

- cobrança automática;
- integração com gateway;
- suspensão automática por vencimento;
- aviso prévio;
- tolerância configurável.

Esses itens exigem projeto próprio.

---

## Recuperação Pública de Senha

Não foi implementada nesta fase.

Ainda pode ser necessária futuramente:

- recuperação por email;
- token temporário;
- expiração;
- proteção contra abuso;
- Auditoria.

---

## Retenção da Auditoria

Ainda não existe política automatizada de retenção.

A tabela continuará crescendo.

---

## Backups

A estratégia de backup ainda precisa ser formalizada com:

- frequência;
- retenção;
- cópia externa;
- criptografia;
- teste de restauração;
- monitoramento.

Backup sem teste de restauração não é garantia.

---

# Próxima Prioridade

A revisão seguirá a barra lateral.

Próximo grupo:

```text
Cadastros
```

Itens iniciais:

1. Clientes;
2. Fornecedores;
3. Funcionários.

Cada item deverá ser analisado quanto a:

- isolamento;
- permissões;
- validações;
- layout;
- paginação;
- auditoria;
- integrações;
- testes;
- riscos funcionais.

Antes de iniciar Cadastros, o arquivo `Mapa Técnico.md` deve ser atualizado com o estado final do Operacional.

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
- [[10 Projetos/Sysvar/Contexto do Projeto/Mapa Técnico|Mapa Técnico]]
- [[10 Projetos/Sysvar/Decisões Técnicas/ADR-001 - Licenciamento por Sessões Simultâneas|ADR-001 - Licenciamento por Sessões Simultâneas]]
- [[10 Projetos/Sysvar/Decisões Técnicas/ADR-002 - Princípios Arquiteturais do SISVAR|ADR-002 - Princípios Arquiteturais do SISVAR]]
- [[10 Projetos/Sysvar/Decisões Técnicas/ADR-003 - Auditoria Central do SISVAR|ADR-003 - Auditoria Central do SISVAR]]