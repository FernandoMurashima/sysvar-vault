---

type: reference  
status: active  
project: Sysvar  
source: "C:/SysvarProjeto"  
created: 2026-08-03  
updated: 2026-08-05  
tags:

- sysvar
    
- arquitetura
    
- segurança
    
- operacional
    
- auditoria
    
- multiempresa
    

---

# Arquitetura

## Objetivo

A arquitetura do SISVAR foi projetada para suportar um ERP SaaS voltado ao varejo e à indústria de moda.

Seus principais objetivos são:

- segurança;
    
- isolamento entre empresas;
    
- isolamento por loja;
    
- modularização;
    
- escalabilidade;
    
- rastreabilidade;
    
- integridade transacional;
    
- evolução contínua;
    
- compatibilidade com MySQL;
    
- manutenção simplificada.
    

Toda nova funcionalidade deve reutilizar as infraestruturas centrais já existentes.

---

# Princípios arquiteturais

O SISVAR segue os seguintes princípios:

- backend como autoridade final;
    
- frontend como camada de apresentação;
    
- default deny;
    
- permissões efetivas;
    
- isolamento multiempresa obrigatório;
    
- isolamento por loja quando aplicável;
    
- módulos contratados;
    
- operações críticas transacionais;
    
- serviços centrais;
    
- auditoria centralizada;
    
- dados sensíveis protegidos;
    
- migrations obrigatórias;
    
- testes proporcionais ao risco;
    
- documentação versionada;
    
- decisões arquiteturais registradas por ADR.
    

Ocultar botão, menu, campo ou rota no frontend não substitui a validação no backend.

---

# Camadas principais

A arquitetura é dividida em:

1. Frontend.
    
2. Backend.
    
3. Banco de dados.
    
4. Infraestruturas transversais.
    
5. Módulos de negócio.
    
6. Documentação.
    

---

# Frontend

Tecnologia principal:

```text
Angular 17 Standalone
```

O frontend é responsável por:

- interface;
    
- navegação;
    
- formulários;
    
- tabelas;
    
- filtros;
    
- indicadores;
    
- experiência do usuário;
    
- exibição conforme permissões efetivas;
    
- tratamento de respostas do backend.
    

O frontend não é autoridade para decidir:

- empresa do registro;
    
- loja permitida;
    
- contrato válido;
    
- módulo contratado;
    
- permissão efetiva;
    
- limite de sessões;
    
- suspensão da empresa;
    
- regras financeiras;
    
- regras fiscais;
    
- regras de estoque;
    
- auditoria obrigatória;
    
- autorização final.
    

---

# Backend

Tecnologias principais:

- Python;
    
- Django;
    
- Django REST Framework.
    

O backend é responsável por:

- autenticação;
    
- autorização;
    
- contratos;
    
- módulos;
    
- perfis;
    
- permissões;
    
- sessões;
    
- licenciamento;
    
- isolamento multiempresa;
    
- isolamento por loja;
    
- regras de negócio;
    
- transações;
    
- validações;
    
- integrações;
    
- auditoria;
    
- proteção de dados;
    
- APIs REST.
    

Toda regra crítica deve permanecer no backend.

---

# Banco de dados

Tecnologia principal:

```text
MySQL
```

O banco é responsável por:

- persistência;
    
- integridade referencial;
    
- índices;
    
- histórico;
    
- contratos;
    
- sessões;
    
- perfis;
    
- permissões;
    
- auditoria;
    
- dados dos módulos.
    

Toda alteração estrutural deve possuir migration.

Não utilizar alteração manual do banco como solução definitiva.

Recursos do Django devem ser conferidos quanto à compatibilidade com MySQL.

Quando uma constraint não for suportada, a regra deve ser garantida por:

- serviço central;
    
- transação;
    
- `select_for_update`;
    
- validação de aplicação;
    
- testes.
    

---

# Infraestruturas transversais

Atualmente existem serviços centrais para:

- autenticação;
    
- contratos;
    
- módulos contratados;
    
- acesso efetivo;
    
- perfis;
    
- permissões;
    
- sessões;
    
- licenciamento;
    
- transferência de master;
    
- suspensão de contrato;
    
- troca obrigatória de senha;
    
- Auditoria Central.
    

Novos módulos não devem criar mecanismos paralelos para essas responsabilidades.

---

# Multiempresa

A empresa é a principal fronteira de isolamento do SISVAR.

Cada empresa possui seus próprios:

- contrato;
    
- módulos;
    
- estabelecimentos;
    
- usuários;
    
- perfis;
    
- permissões;
    
- sessões;
    
- cadastros;
    
- produtos;
    
- compras;
    
- estoque;
    
- vendas;
    
- fiscal;
    
- financeiro;
    
- produção;
    
- distribuição;
    
- auditoria.
    

Nenhum usuário cliente pode acessar dados de outra empresa.

O isolamento deve continuar válido mesmo com:

- alteração de URL;
    
- alteração de parâmetros;
    
- envio de payload manual;
    
- chamada direta à API;
    
- uso de ID de outra empresa;
    
- tentativa de exportação;
    
- tentativa de vínculo cruzado.
    

A empresa enviada pelo frontend não é fonte de verdade.

---

# Multilojas

Cada empresa pode possuir vários estabelecimentos.

Todo estabelecimento pertence obrigatoriamente a uma empresa.

Quando uma operação depender de loja, o backend valida:

- empresa da loja;
    
- empresa do usuário;
    
- lojas permitidas;
    
- loja principal;
    
- loja da sessão;
    
- loja do objeto;
    
- escopo da operação.
    

Usuário comum:

- acessa apenas lojas permitidas.
    

Master:

- acessa todas as lojas da própria empresa.
    

Superusuário:

- possui acesso global administrativo.
    

---

# Grupo Operacional

O grupo Operacional reúne as funcionalidades administrativas centrais da empresa.

Estrutura atual:

```text
Operacional
├── Empresas
├── Estabelecimento
├── Usuários
├── Perfis de acesso
└── Auditoria
```

A implementação técnica do grupo foi concluída e validada por testes automatizados.

A homologação manual completa no navegador ainda permanece pendente.

---

# Empresas

A empresa representa um cliente da plataforma.

Concentra:

- contrato;
    
- módulos;
    
- master;
    
- limite de sessões;
    
- estabelecimentos;
    
- usuários;
    
- perfis;
    
- dados operacionais;
    
- auditoria.
    

A situação da empresa é validada durante:

- login;
    
- heartbeat;
    
- requisições autenticadas;
    
- operações administrativas.
    

---

# Contratos

Cada empresa cliente depende de um contrato.

O contrato controla:

- status;
    
- vigência;
    
- plano completo;
    
- módulos contratados;
    
- limite de sessões;
    
- usuário master;
    
- versão das permissões;
    
- suspensão;
    
- reativação.
    

Estados possíveis incluem:

```text
PENDENTE
ATIVO
SUSPENSO
VENCIDO
CANCELADO
```

Operações críticas do contrato utilizam:

- `transaction.atomic`;
    
- `select_for_update`;
    
- Auditoria obrigatória;
    
- atualização de `permissions_version`.
    

---

# Suspensão administrativa

A suspensão é um bloqueio operacional do contrato.

Inadimplência é um motivo, não um status separado.

Motivos atuais:

```text
INADIMPLENCIA
SOLICITACAO_CLIENTE
RISCO_SEGURANCA
ENCERRAMENTO_CONTRATO
BLOQUEIO_ADMINISTRATIVO
OUTRO
```

## Fluxo

Ao suspender:

1. contrato é bloqueado;
    
2. status passa para `SUSPENSO`;
    
3. motivo e observação são registrados;
    
4. todas as sessões são encerradas;
    
5. tokens são revogados;
    
6. vagas são liberadas;
    
7. versão das permissões é atualizada;
    
8. Auditoria obrigatória é registrada;
    
9. a transação é confirmada.
    

Se a Auditoria falhar, toda a operação sofre rollback.

## Bloqueio

Uma empresa suspensa não pode:

- realizar login;
    
- utilizar token antigo;
    
- manter sessão ativa;
    
- acessar endpoint protegido;
    
- continuar pelo heartbeat.
    

Código:

```text
CONTRACT_SUSPENDED
```

Mensagem pública:

```text
O acesso da empresa está temporariamente suspenso. Entre em contato com o suporte.
```

O motivo comercial detalhado não é exposto ao usuário comum.

---

# Reativação

A reativação:

- retorna o contrato para `ATIVO`;
    
- mantém histórico da suspensão;
    
- atualiza a versão das permissões;
    
- não reativa sessões antigas;
    
- exige novo login;
    
- registra Auditoria obrigatória.
    

---

# Estabelecimentos

O model principal é `Loja`.

Tipos oficiais:

```text
LOJA
MATRIZ
FABRICA
```

Todo estabelecimento pertence obrigatoriamente a uma empresa.

Antes da migration final, foi executado diagnóstico:

```text
lojas_sem_empresa = 0
```

Nenhum saneamento foi necessário.

## Tipo de unidade

`tipo_unidade` é a fonte principal.

O campo legado `Matriz` permanece sincronizado por compatibilidade.

Não permitir contradição entre os dois campos.

## Ciclo de vida

Existem ações explícitas:

```text
Ativar
Inativar
Encerrar
Reabrir
```

Encerrar não exclui o histórico.

Antes de inativar ou encerrar, o backend pode verificar:

- sessões;
    
- usuários vinculados;
    
- loja principal;
    
- operações pendentes;
    
- dependências operacionais.
    

## Permissão

```text
operacional = NONE
→ sem acesso

operacional = VIEW
→ consulta

operacional = EDIT
→ criação e alteração
```

A rota não depende mais exclusivamente de tipos antigos como `Diretor` e `Gerente`.

---

# Usuários

Usuários clientes pertencem a uma empresa.

Podem possuir:

- perfil principal;
    
- tipo funcional;
    
- loja principal;
    
- lojas permitidas;
    
- overrides;
    
- permissões de campo;
    
- sessões.
    

A regra oficial é:

```text
Perfil
+ Override
+ Contrato
+ Módulos contratados
= Permissão efetiva
```

## Tipo funcional

O campo `type` continua existindo por compatibilidade e classificação funcional.

Ele não deve:

- conceder módulo;
    
- remover módulo;
    
- alterar perfil;
    
- sobrescrever override;
    
- definir acesso efetivo.
    

## Perfil principal

Para usuário comum:

- perfil é obrigatório;
    
- perfil deve estar ativo;
    
- perfil deve pertencer à mesma empresa;
    
- perfil não pode habilitar módulo não contratado.
    

Master e superusuário possuem regras próprias.

---

# Permissões efetivas

O backend calcula a permissão efetiva.

Considera:

- usuário ativo;
    
- empresa;
    
- contrato;
    
- status do contrato;
    
- módulo contratado;
    
- perfil;
    
- override;
    
- master;
    
- superusuário.
    

Níveis:

```text
NONE
VIEW
EDIT
```

Override:

```text
HERDAR
NONE
VIEW
EDIT
```

`HERDAR` significa ausência de override individual.

A permissão efetiva deve ser retornada pelo backend.

---

# Proteção do usuário master

O master não pode ser:

- excluído;
    
- inativado;
    
- movido para outra empresa;
    
- rebaixado por edição comum;
    
- privado do acesso administrativo essencial.
    

A troca de master utiliza serviço específico, transação e Auditoria obrigatória.

---

# Autoproteção

O usuário não pode:

- elevar a própria permissão;
    
- trocar o próprio perfil por um perfil superior;
    
- alterar a própria empresa;
    
- ampliar suas próprias lojas;
    
- tornar-se master;
    
- alterar campos internos do Django.
    

Campos protegidos incluem:

```text
is_staff
is_superuser
groups
user_permissions
master
token
session_id
```

---

# Sessões

Cada acesso autenticado é representado por uma sessão.

A sessão registra:

- empresa;
    
- loja;
    
- usuário;
    
- dispositivo;
    
- IP;
    
- user-agent;
    
- início;
    
- última atividade;
    
- encerramento;
    
- motivo.
    

Uma sessão pode ser encerrada por:

- logout;
    
- timeout;
    
- substituição;
    
- inativação;
    
- suspensão da empresa;
    
- encerramento administrativo;
    
- redefinição de senha.
    

---

# Encerramento de sessões do usuário

O encerramento de todas as sessões é transacional.

Fluxo:

1. usuário é bloqueado;
    
2. sessões são bloqueadas;
    
3. sessões são encerradas;
    
4. tokens são revogados;
    
5. evento consolidado é registrado;
    
6. transação é confirmada.
    

Evento:

```text
USER_SESSIONS_CLOSED
```

Se a Auditoria obrigatória falhar:

- sessões permanecem ativas;
    
- tokens permanecem válidos;
    
- não existe resultado parcial.
    

---

# Redefinição administrativa de senha

Um administrador autorizado pode redefinir a senha.

A operação:

- valida a nova senha;
    
- marca `deve_trocar_senha`;
    
- encerra sessões quando solicitado;
    
- revoga tokens;
    
- exige novo login;
    
- registra Auditoria obrigatória.
    

A operação é transacional.

Se a Auditoria falhar, senha, flag, sessões e tokens voltam ao estado anterior.

---

# Troca obrigatória de senha

Quando:

```text
deve_trocar_senha = true
```

o usuário autentica, mas não pode acessar os módulos normais.

O backend permite apenas:

- `/api/me/`;
    
- endpoint de troca;
    
- logout;
    
- heartbeat necessário ao fluxo.
    

Outros endpoints retornam:

```text
PASSWORD_CHANGE_REQUIRED
```

Mensagem:

```text
Você precisa alterar sua senha antes de continuar.
```

## Frontend

Rota:

```text
/change-password-required
```

O guard:

- redireciona o usuário;
    
- bloqueia `/home`;
    
- impede bypass por URL;
    
- libera o sistema após a troca.
    

A sessão atual permanece válida.

As demais sessões são encerradas.

---

# Perfis de acesso

Perfis representam conjuntos reutilizáveis de permissões.

Cada perfil pertence a uma empresa.

Regras:

- nome único por empresa;
    
- isolamento por empresa;
    
- perfil inativo não pode ser atribuído;
    
- perfil em uso não pode ser excluído;
    
- módulo não contratado não pode ser habilitado;
    
- dependências de módulos são validadas;
    
- alterações incrementam `permissions_version`;
    
- mudanças críticas utilizam Auditoria obrigatória.
    

## Perfil padrão

A regra de apenas um perfil padrão é garantida pela aplicação.

Utiliza:

```python
transaction.atomic()
select_for_update()
```

Não depende de constraint condicional incompatível com MySQL.

---

# Dependências de módulos

As dependências são declaradas em:

```text
ModuloSistema.dependencias
```

Um módulo não pode ser habilitado com uma dependência em `NONE`.

Exemplo:

```text
Relatórios financeiros
→ Relatórios + Financeiro
```

A validação ocorre no backend.

---

# Rotas do Operacional

As rotas de:

- Estabelecimentos;
    
- ajuda de Estabelecimentos;
    
- Usuários;
    
- Perfis;
    

não dependem mais exclusivamente de roles antigas.

O acesso utiliza:

- autenticação;
    
- módulo `operacional`;
    
- nível efetivo;
    
- master;
    
- superusuário.
    

Auditoria continua utilizando o módulo próprio:

```text
auditoria
```

---

# Auditoria Central

A Auditoria Central é uma infraestrutura transversal.

Componentes principais:

```text
AuditLog
AuditService
AuditContextMiddleware
AuditRegistry
```

Os logs são:

- imutáveis;
    
- somente leitura;
    
- sanitizados;
    
- isolados por empresa;
    
- isolados por loja;
    
- estruturados.
    

## Integrações do Operacional

A Auditoria foi integrada a:

- suspensão;
    
- reativação;
    
- criação e alteração de estabelecimento;
    
- ativação;
    
- inativação;
    
- encerramento;
    
- reabertura;
    
- criação e alteração de usuário;
    
- perfil;
    
- override;
    
- lojas permitidas;
    
- redefinição de senha;
    
- troca de senha;
    
- encerramento de sessões;
    
- perfil padrão;
    
- permissões;
    
- acessos negados.
    

---

# Auditoria normal

Eventos comuns podem ser registrados após commit:

```python
transaction.on_commit()
```

Isso evita log de sucesso em operações com rollback.

---

# Auditoria obrigatória

Operações críticas registram o evento dentro da mesma transação.

Exemplos:

- suspensão;
    
- reativação;
    
- transferência de master;
    
- permissão;
    
- perfil padrão;
    
- redefinição de senha;
    
- troca obrigatória;
    
- encerramento consolidado de sessões;
    
- exclusão administrativa.
    

Se a Auditoria falhar, a operação também falha.

---

# Licenciamento

O licenciamento é baseado em sessões simultâneas.

Regras:

- usuário cadastrado não consome licença;
    
- usuário ativo não consome licença;
    
- sessão ativa consome vaga;
    
- logout libera vaga;
    
- timeout libera vaga;
    
- inativação libera vaga;
    
- suspensão libera todas as vagas;
    
- redefinição de senha pode liberar vagas;
    
- mesmo dispositivo substitui sessão anterior;
    
- dispositivos diferentes usam vagas independentes;
    
- login acima do limite é bloqueado.
    

---

# Segurança

Cada requisição autenticada pode validar:

- token;
    
- sessão;
    
- expiração;
    
- usuário;
    
- empresa;
    
- contrato;
    
- status do contrato;
    
- troca obrigatória de senha;
    
- módulo;
    
- permissão;
    
- loja;
    
- objeto.
    

O backend aplica default deny.

Dados sensíveis não devem ser registrados.

Exemplos:

- senha;
    
- token;
    
- cookie;
    
- certificado;
    
- chave privada;
    
- Authorization;
    
- hash de token.
    

---

# Transações

Operações que alteram vários registros relacionados devem utilizar transação.

Exemplos:

- login na última vaga;
    
- suspensão;
    
- reativação;
    
- transferência de master;
    
- perfil padrão;
    
- alteração de permissões;
    
- redefinição de senha;
    
- encerramento de sessões;
    
- aprovação de pedido;
    
- entrada de nota;
    
- movimentação de estoque;
    
- emissão fiscal.
    

Quando necessário, utilizar:

```python
transaction.atomic()
select_for_update()
```

---

# APIs

As APIs devem ser aditivas sempre que possível.

Antes de alterar:

- endpoint;
    
- serializer;
    
- campo;
    
- resposta;
    
- status HTTP;
    

é necessário verificar:

- frontend;
    
- testes;
    
- integrações;
    
- documentação;
    
- commands;
    
- migrations.
    

---

# Performance

Evitar:

- N+1;
    
- consultas globais;
    
- ausência de paginação;
    
- listas de 2.000 registros no frontend;
    
- filtros em JSON para campos frequentes;
    
- payloads excessivos;
    
- duplicação de serviços.
    

Listagens operacionais devem utilizar paginação real do backend.

---

# Padrão visual

As telas devem seguir:

1. Barra Principal.
    
2. Barra do Título.
    
3. Barra de Indicadores.
    
4. Barra de Filtros.
    
5. Barra de Ações.
    
6. Área de Resultados.
    

A área de resultados deve possuir:

- paginação;
    
- total;
    
- intervalo exibido;
    
- ordenação;
    
- estado vazio;
    
- loading;
    
- tratamento de erro.
    

---

# Testes

Toda implementação deve possuir testes proporcionais ao risco.

## Grupo Operacional

Validação automatizada final:

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

---

# Homologação manual

A implementação técnica do Operacional está concluída.

Ainda falta homologar manualmente:

- suspensão;
    
- reativação;
    
- queda das sessões;
    
- bloqueio do login;
    
- troca obrigatória de senha;
    
- acesso VIEW e EDIT;
    
- ciclo de vida do estabelecimento;
    
- matriz Perfil/Override/Efetivo;
    
- eventos na Auditoria.
    

Até essa execução, o grupo deve ser considerado:

```text
Implementado e validado automaticamente
Homologação manual pendente
```

---

# Situação atual da arquitetura

Implementado:

- autenticação centralizada;
    
- isolamento multiempresa;
    
- isolamento por loja;
    
- contratos;
    
- suspensão;
    
- reativação;
    
- módulos contratados;
    
- usuário master;
    
- estabelecimentos obrigatoriamente vinculados à empresa;
    
- perfis;
    
- perfil padrão;
    
- dependências de módulos;
    
- permissões efetivas;
    
- sessões;
    
- licenciamento;
    
- redefinição de senha;
    
- troca obrigatória de senha;
    
- Auditoria Central;
    
- imutabilidade;
    
- sanitização;
    
- snapshots;
    
- indicadores;
    
- exportação.
    

---

# Próxima etapa

Após a homologação manual do Operacional, a revisão seguirá a ordem do menu lateral.

Próximo grupo:

```text
Cadastros
```

Itens iniciais:

- Clientes;
    
- Fornecedores;
    
- Funcionários.
    

Cada item deverá ser analisado quanto a:

- isolamento;
    
- permissão;
    
- validação;
    
- layout;
    
- auditoria;
    
- integrações;
    
- paginação;
    
- testes;
    
- melhorias.
    

---

# Commits relacionados

Backend do Operacional:

```text
3955ea48c721afc7b15520a7afd6ec32f8374af6
```

Frontend do Operacional:

```text
bf66e81e6f1c0d58255a135d9339a34b95ef332f
```

---

# Decisões arquiteturais

- ADR-001 — Licenciamento por Sessões Simultâneas.
    
- ADR-002 — Princípios Arquiteturais do SISVAR.
    
- ADR-003 — Auditoria Central do SISVAR.
    

---

# Notas relacionadas

- [[10 Projetos/Sysvar/Sysvar|Sysvar]]
    
- [[10 Projetos/Sysvar/Contexto do Projeto/Visão Geral|Visão Geral]]
    
- [[10 Projetos/Sysvar/Contexto do Projeto/Modelo de Domínio|Modelo de Domínio]]
    
- [[10 Projetos/Sysvar/Contexto do Projeto/Workflows|Workflows]]
    
- [[10 Projetos/Sysvar/Contexto do Projeto/Riscos e Cuidados|Riscos e Cuidados]]
    
- [[10 Projetos/Sysvar/Contexto do Projeto/Mapa Técnico|Mapa Técnico]]
    
- [[10 Projetos/Sysvar/Decisões Técnicas/ADR-001 - Licenciamento por Sessões Simultâneas|ADR-001 - Licenciamento por Sessões Simultâneas]]
    
- [[10 Projetos/Sysvar/Decisões Técnicas/ADR-002 - Princípios Arquiteturais do SISVAR|ADR-002 - Princípios Arquiteturais do SISVAR]]
    
- [[10 Projetos/Sysvar/Decisões Técnicas/ADR-003 - Auditoria Central do SISVAR|ADR-003 - Auditoria Central do SISVAR]]