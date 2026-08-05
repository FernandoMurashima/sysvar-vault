---

type: reference  
status: active  
project: Sysvar  
source: "C:/SysvarProjeto"  
created: 2026-08-03  
updated: 2026-08-05  
tags:

- sysvar
    
- riscos
    
- arquitetura
    
- segurança
    
- operacional
    
- auditoria
    
- multiempresa
    

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
    
- utilizar loja de outra empresa;
    
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
    
- empresa da loja;
    
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

---

# Multilojas

## Empresa obrigatória

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

## Isolamento por loja

Quando o domínio depender de loja, validar:

- se a loja pertence à empresa;
    
- se o usuário possui acesso;
    
- se a loja é permitida;
    
- se a loja principal pertence à empresa;
    
- se a sessão está ligada ao contexto correto;
    
- se o objeto pertence à loja;
    
- se a operação permite loja nula.
    

Não confiar apenas no seletor visual do frontend.

---

## Loja principal

A loja principal deve estar incluída nas lojas permitidas.

Não permitir:

- loja principal de outra empresa;
    
- loja permitida de outra empresa;
    
- remoção da loja principal sem ajuste correspondente;
    
- definição automática de loja arbitrária.
    

---

## Eventos sem loja

Nem toda operação pertence a uma loja.

Exemplos:

- contrato;
    
- perfil;
    
- permissão;
    
- suspensão da empresa;
    
- configuração global.
    

Não inventar loja apenas para preencher auditoria.

---

# Contratos

## Validação do contrato

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

## Ação crítica

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

## Risco de suspensão acidental

Uma suspensão indevida pode paralisar todas as lojas do cliente.

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

## Bloqueio em vários pontos

Não basta bloquear somente o login.

Contrato suspenso deve ser recusado em:

- autenticação;
    
- token;
    
- heartbeat;
    
- requisição autenticada;
    
- criação de sessão;
    
- renovação de contexto.
    

Isso reduz o risco de uma sessão antiga continuar funcionando.

---

## Mensagem pública

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

## Serviço central

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
    

Token revogado ou sem sessão ativa não autentica.

---

## Credenciais inválidas

O evento de login negado não deve armazenar:

- senha;
    
- payload completo;
    
- token;
    
- dados desnecessários.
    

A resposta não deve facilitar enumeração de usuários.

---

# Sessões Simultâneas

## Consumo de licença

Licença é consumida por sessão ativa.

Não por:

- usuário cadastrado;
    
- usuário ativo;
    
- perfil;
    
- loja;
    
- senha;
    
- dispositivo sem login.
    

Nunca retornar ao controle por quantidade de usuários ativos.

---

## Concorrência da última vaga

A contagem e a criação da sessão devem permanecer na mesma transação.

O contrato deve ser bloqueado.

Não executar:

1. contagem;
    
2. fim da transação;
    
3. criação posterior.
    

Isso permite ultrapassar o limite.

---

## Mesmo dispositivo

Novo login do mesmo usuário no mesmo dispositivo deve:

- encerrar sessão anterior;
    
- revogar token anterior;
    
- criar nova sessão;
    
- manter apenas uma vaga consumida.
    

Dispositivos diferentes usam sessões independentes.

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

## Redução do limite

Reduzir o limite abaixo das sessões ativas não encerra sessões automaticamente.

O sistema deve:

- preservar sessões atuais;
    
- bloquear novos logins;
    
- reduzir o excesso por logout, timeout ou encerramento administrativo.
    

Mudança nessa regra exige nova decisão arquitetural.

---

# Encerramento de Sessões

## Sessão individual

Encerrar uma sessão deve:

- validar empresa;
    
- validar executor;
    
- revogar token;
    
- liberar vaga;
    
- registrar motivo;
    
- auditar.
    

---

## Todas as sessões do usuário

O encerramento consolidado deve ser transacional.

A operação deve:

- bloquear usuário;
    
- bloquear sessões;
    
- encerrar todas;
    
- revogar todos os tokens;
    
- criar um evento consolidado;
    
- confirmar tudo junto.
    

Se a Auditoria obrigatória falhar:

- nenhuma sessão deve ser encerrada;
    
- nenhum token deve ser revogado.
    

---

## Duplicidade de auditoria

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

# Usuários

## Empresa

Usuário cliente deve pertencer a uma empresa.

Não permitir:

- empresa nula;
    
- troca para outra empresa;
    
- edição pelo próprio usuário;
    
- empresa recebida livremente do frontend.
    

---

## Perfil principal

Usuário comum deve possuir perfil principal válido.

O perfil deve:

- estar ativo;
    
- pertencer à mesma empresa;
    
- utilizar módulos permitidos;
    
- respeitar dependências.
    

---

## Tipo funcional

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
    
- ampliar as próprias lojas;
    
- alterar a própria empresa;
    
- tornar-se master;
    
- alterar campos internos.
    

---

## Campos protegidos

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

## Usuário master

O master não pode ser:

- excluído;
    
- inativado;
    
- movido de empresa;
    
- rebaixado;
    
- privado de acesso essencial.
    

Antes disso, deve ocorrer transferência de administração.

---

# Perfis e Permissões

## Default deny

Ausência de permissão significa bloqueio.

Não criar fallback permissivo.

---

## Nomes de perfil

Não conceder acesso com base no nome:

```text
Admin
Gerente
Master
Diretor
```

O acesso depende do cálculo efetivo.

---

## Role antiga

Rotas não devem depender exclusivamente de:

```text
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

## Perfil padrão

O MySQL não garante constraint condicional do Django.

A regra de um perfil padrão por empresa deve continuar garantida por:

- transação;
    
- `select_for_update`;
    
- serviço central;
    
- testes concorrentes.
    

---

## Dependências de módulos

Módulos dependentes devem respeitar `ModuloSistema.dependencias`.

Não permitir:

- módulo dependente em `VIEW` ou `EDIT`;
    
- dependência necessária em `NONE`.
    

Não inventar dependências no frontend.

A fonte é o catálogo do backend.

---

## Módulos hardcoded

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

## Permissão efetiva

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

## Operação administrativa

A redefinição deve ser transacional.

Na mesma operação:

1. senha é alterada;
    
2. `deve_trocar_senha` é marcado;
    
3. sessões são encerradas;
    
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

## Exposição da senha

Não:

- retornar senha na API;
    
- mostrar senha cadastrada;
    
- guardar no navegador;
    
- enviar por log;
    
- incluir em exception;
    
- persistir em metadata.
    

---

# Troca Obrigatória de Senha

## Bloqueio central

Quando:

```text
deve_trocar_senha = true
```

o usuário não deve acessar módulos normais.

O bloqueio precisa ocorrer no backend centralmente.

Não depender apenas do guard Angular.

---

## Endpoints permitidos

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

## Sessão atual

Após a troca:

- sessão atual pode permanecer;
    
- demais sessões devem ser encerradas;
    
- token atual permanece válido conforme a regra implementada;
    
- contexto deve ser recarregado.
    

Não criar uma sessão adicional e consumir nova licença.

---

## Nova senha

Validar:

- senha atual;
    
- confirmação;
    
- diferença em relação à atual;
    
- validadores do Django;
    
- tamanho mínimo;
    
- regras de segurança.
    

---

# Estabelecimentos

## Empresa obrigatória

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

## Tipo de unidade

`tipo_unidade` é a fonte principal.

O campo legado `Matriz` não pode contradizer o tipo.

Manter sincronização enquanto existir compatibilidade.

---

## Campos legados

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

## Ciclo de vida

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
    
- loja principal;
    
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

## Infraestrutura única

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

## Auditoria normal

Eventos comuns podem usar:

```python
transaction.on_commit()
```

Não registrar sucesso antes do commit.

---

## Auditoria obrigatória

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

## Dados sensíveis

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

## Permissão visual

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

401:

- token inválido;
    
- sessão expirada;
    
- sessão encerrada.
    

403:

- sem permissão;
    
- contrato suspenso;
    
- troca obrigatória;
    
- empresa incorreta;
    
- loja não permitida.
    

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

# Banco de Dados

## Migrations

Toda mudança estrutural deve possuir migration.

Não editar migration já aplicada.

---

## Data migrations

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
    
- loja;
    
- filtros;
    
- permissão.
    

---

# Testes

## Testes automatizados

O grupo Operacional possui validação automatizada:

```text
Backend: 50 testes
Frontend: 33 testes
```

Esses testes não eliminam a necessidade de homologação manual.

---

## Homologação manual

Ainda deve ser executada para:

- suspensão;
    
- reativação;
    
- queda de sessões;
    
- bloqueio de token;
    
- troca obrigatória de senha;
    
- bypass por URL;
    
- usuário VIEW;
    
- usuário EDIT;
    
- ciclo do estabelecimento;
    
- matriz Perfil/Override/Efetivo;
    
- dependência de módulos;
    
- eventos na Auditoria.
    

Enquanto isso, o status correto é:

```text
Implementado
Validado automaticamente
Homologação manual pendente
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
    
- override HERDAR;
    
- dependências de módulos;
    
- proteção do master;
    
- transação no encerramento de sessões;
    
- transação na redefinição de senha;
    
- troca obrigatória de senha;
    
- bloqueio central durante troca;
    
- Auditoria dos novos eventos;
    
- testes backend e frontend.
    

---

# Riscos Ainda Abertos

## Homologação manual do Operacional

A principal pendência do grupo é validar os fluxos reais no navegador.

---

## Campos legados de Loja

Ainda precisam ser revisados em uma fase futura para possível remoção.

---

## Tipos funcionais antigos

O campo `type` continua existindo.

Deve ser monitorado para evitar que novas regras voltem a utilizá-lo como permissão.

---

## Automação de suspensão

Nesta fase, a suspensão é manual.

Ainda não existe:

- cobrança automática;
    
- integração com gateway;
    
- suspensão automática por vencimento;
    
- aviso prévio;
    
- tolerância configurável.
    

Esses itens exigem projeto próprio.

---

## Recuperação pública de senha

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

Depois da homologação manual do Operacional, a revisão seguirá a barra lateral.

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
    
- permissões;
    
- validações;
    
- layout;
    
- paginação;
    
- auditoria;
    
- integrações;
    
- testes;
    
- riscos funcionais.
    

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