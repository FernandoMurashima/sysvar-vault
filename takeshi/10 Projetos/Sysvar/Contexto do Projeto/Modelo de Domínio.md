---

type: reference  
status: active  
project: Sysvar  
source: "C:/SysvarProjeto"  
created: 2026-08-03  
updated: 2026-08-05  
tags:

- sysvar
    
- domínio
    
- modelo
    
- operacional
    
- segurança
    
- auditoria
    
- multiempresa
    

---

# Modelo de Domínio

## Objetivo

Este documento descreve as principais entidades do SISVAR, suas responsabilidades, regras e relacionamentos.

Ele representa a visão funcional do domínio.

Não é uma cópia direta das tabelas do banco ou das classes Django.

---

# Organização do domínio

O domínio está dividido em:

- Plataforma
    
- Empresas e Contratos
    
- Estabelecimentos
    
- Segurança e Acesso
    
- Licenciamento e Sessões
    
- Auditoria
    
- Cadastros
    
- Produtos
    
- Compras
    
- Estoque
    
- Produção
    
- Distribuição
    
- Vendas e PDV
    
- Fiscal
    
- Financeiro
    
- Contabilidade
    
- Relatórios e Dashboards
    

---

# Plataforma

## Empresa

Representa um cliente do SISVAR.

A empresa é a principal fronteira de isolamento do sistema.

Cada empresa possui seus próprios:

- contrato;
    
- módulos contratados;
    
- usuário master;
    
- estabelecimentos;
    
- usuários;
    
- perfis;
    
- permissões;
    
- sessões;
    
- cadastros;
    
- produtos;
    
- documentos;
    
- operações;
    
- registros de auditoria.
    

Nenhum usuário cliente pode acessar dados pertencentes a outra empresa.

---

## Módulo do Sistema

Representa uma funcionalidade controlada comercialmente e por permissão.

Exemplos:

```text
operacional
cadastros
produtos
compras
estoque
distribuicao
producao
vendas
financeiro
fiscal
relatorios
auditoria
```

Cada módulo possui uma chave estável.

O contrato determina quais módulos estão disponíveis para a empresa.

O módulo também pode possuir:

- descrição;
    
- ordem;
    
- situação ativa;
    
- dependências de outros módulos.
    

---

## Dependência de Módulo

Representa a necessidade de um módulo estar habilitado para que outro possa funcionar.

Exemplo:

```text
Relatório financeiro
→ Relatórios
→ Financeiro
```

As dependências são declaradas no catálogo de módulos.

O backend impede configurações inconsistentes.

---

# Empresas e Contratos

## Contrato

Representa a relação comercial e operacional entre a empresa e o SISVAR.

O contrato controla:

- status;
    
- vigência;
    
- plano completo;
    
- módulos contratados;
    
- usuário master;
    
- limite de acessos simultâneos;
    
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

A autenticação de usuários clientes depende de contrato válido.

---

## Empresa Módulo

Representa a disponibilidade de um módulo para uma empresa.

Relaciona:

```text
Empresa
→ Módulo do Sistema
```

Uma alteração pode modificar imediatamente:

- menus;
    
- rotas;
    
- endpoints;
    
- permissões efetivas;
    
- acesso dos usuários.
    

Alterações nessa entidade são auditadas.

---

## Suspensão do Contrato

Representa o bloqueio administrativo do acesso da empresa.

Inadimplência é um motivo de suspensão, não um status separado.

Motivos atuais:

```text
INADIMPLENCIA
SOLICITACAO_CLIENTE
RISCO_SEGURANCA
ENCERRAMENTO_CONTRATO
BLOQUEIO_ADMINISTRATIVO
OUTRO
```

A suspensão mantém:

- empresa;
    
- usuários;
    
- perfis;
    
- estabelecimentos;
    
- módulos;
    
- dados operacionais;
    
- histórico.
    

A suspensão encerra:

- sessões ativas;
    
- tokens válidos;
    
- consumo de vagas simultâneas.
    

---

## Dados da Suspensão

O contrato pode registrar:

- motivo;
    
- observação;
    
- data da suspensão;
    
- usuário responsável;
    
- data da reativação;
    
- usuário responsável pela reativação.
    

O motivo comercial detalhado não deve ser exposto a usuários comuns.

---

## Reativação do Contrato

Representa a liberação do acesso de uma empresa suspensa.

A reativação:

- retorna o contrato para `ATIVO`;
    
- preserva o histórico da suspensão;
    
- não reativa sessões antigas;
    
- exige novo login;
    
- atualiza a versão das permissões;
    
- gera Auditoria obrigatória.
    

---

# Estabelecimentos

## Estabelecimento

O model principal utilizado é `Loja`.

Representa uma unidade operacional pertencente a uma empresa.

Todo estabelecimento pertence obrigatoriamente a uma empresa.

O diagnóstico executado antes da migration final encontrou:

```text
lojas_sem_empresa = 0
```

Nenhum saneamento de dados foi necessário.

---

## Tipos de Estabelecimento

Tipos oficiais:

```text
LOJA
MATRIZ
FABRICA
```

O campo `tipo_unidade` é a fonte principal da classificação.

O campo legado `Matriz` permanece temporariamente por compatibilidade e deve permanecer sincronizado com `tipo_unidade`.

---

## Loja

Representa uma unidade comercial ou operacional.

Pode estar relacionada a:

- usuários;
    
- sessões;
    
- estoque;
    
- caixas;
    
- vendas;
    
- documentos fiscais;
    
- transferências;
    
- distribuição;
    
- operações financeiras;
    
- auditoria.
    

---

## Matriz

Representa a unidade administrativa ou operacional principal da empresa.

Pode concentrar:

- administração;
    
- estoque central;
    
- compras;
    
- faturamento;
    
- financeiro;
    
- distribuição.
    

A existência de uma matriz não elimina a necessidade de vínculo obrigatório com a empresa.

---

## Fábrica

Representa uma unidade de produção.

Pode participar de:

- estoque de matéria-prima;
    
- produção;
    
- facção;
    
- recebimento de produto acabado;
    
- distribuição.
    

A fábrica pode não emitir NFC-e.

---

## Situação do Estabelecimento

O estabelecimento pode estar:

- ativo;
    
- inativo;
    
- encerrado;
    
- reaberto.
    

O encerramento não exclui o histórico.

---

## Ativação

Representa a liberação operacional de um estabelecimento.

A ativação não cria automaticamente:

- sessões;
    
- usuários;
    
- estoque;
    
- caixas.
    

---

## Inativação

Representa a interrupção temporária do uso do estabelecimento.

Antes da inativação, podem ser verificados:

- sessões ativas;
    
- usuários vinculados;
    
- loja principal de usuários;
    
- caixas abertos;
    
- operações pendentes;
    
- movimentações em andamento.
    

---

## Encerramento

Representa o encerramento formal de um estabelecimento.

Pode exigir:

- data;
    
- motivo;
    
- validação de dependências;
    
- inativação;
    
- Auditoria obrigatória.
    

O encerramento não apaga:

- vendas;
    
- estoque histórico;
    
- documentos;
    
- usuários;
    
- auditoria.
    

---

## Reabertura

Representa a retomada das operações de um estabelecimento encerrado.

A reabertura:

- valida empresa e contrato;
    
- altera a situação;
    
- preserva o histórico anterior;
    
- gera auditoria.
    

---

## Usuário Vinculado ao Estabelecimento

Representa a relação entre usuário e loja.

Um usuário pode estar vinculado como:

- usuário com loja principal;
    
- usuário com loja permitida;
    
- usuário com sessão ativa na loja.
    

A consulta deve respeitar empresa e permissão efetiva.

---

# Segurança e Acesso

## Usuário

Representa uma pessoa autorizada a utilizar o SISVAR.

Um usuário cliente pertence a uma empresa.

Pode possuir:

- perfil principal;
    
- tipo funcional;
    
- loja principal;
    
- lojas permitidas;
    
- overrides;
    
- permissões de campo;
    
- sessões;
    
- registros de auditoria.
    

Criar ou ativar usuário não consome licença.

---

## Tipo Funcional

Representa uma classificação operacional legada ou funcional.

Exemplos:

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

O tipo funcional pode continuar sendo usado em regras específicas.

Ele não define automaticamente a permissão efetiva.

Não deve:

- conceder módulo;
    
- remover módulo;
    
- substituir perfil;
    
- criar override;
    
- elevar acesso.
    

---

## Superusuário da Plataforma

Representa o administrador global do SISVAR.

Pode:

- administrar empresas;
    
- administrar contratos;
    
- suspender e reativar empresas;
    
- administrar módulos;
    
- consultar sessões globais;
    
- consultar auditoria global;
    
- realizar manutenção.
    

Não está sujeito ao limite de sessões das empresas clientes.

---

## Usuário Master

Representa o administrador principal de uma empresa.

É definido no contrato.

Pode administrar, dentro da própria empresa:

- usuários;
    
- perfis;
    
- permissões;
    
- estabelecimentos;
    
- sessões;
    
- auditoria;
    
- configurações permitidas.
    

O master não pode ser:

- excluído;
    
- inativado;
    
- movido para outra empresa;
    
- rebaixado por edição comum.
    

A transferência utiliza fluxo específico e Auditoria obrigatória.

---

## Perfil de Acesso

Representa um conjunto reutilizável de permissões.

Cada perfil pertence a uma empresa.

Exemplos:

- Administrador;
    
- Gerente;
    
- Vendedor;
    
- Caixa;
    
- Estoquista;
    
- Financeiro.
    

O nome do perfil não concede acesso por si só.

---

## Perfil Padrão

Representa o perfil aplicado automaticamente quando a regra de negócio exigir.

Existe apenas um perfil padrão ativo por empresa.

A garantia ocorre por:

```text
transaction.atomic()
select_for_update()
```

A regra não depende de constraint condicional incompatível com MySQL.

---

## Perfil Módulo Permissão

Relaciona:

```text
Perfil
→ Módulo
→ Nível
```

Níveis:

```text
NONE
VIEW
EDIT
```

Alterações podem afetar vários usuários.

Por isso:

- incrementam `permissions_version`;
    
- geram Auditoria obrigatória;
    
- respeitam módulos contratados;
    
- respeitam dependências.
    

---

## Override do Usuário

Representa uma exceção individual à permissão herdada do perfil.

Opções:

```text
HERDAR
NONE
VIEW
EDIT
```

`HERDAR` significa que não existe permissão individual persistida.

O valor do perfil volta a ser utilizado.

---

## Permissão Efetiva

Representa o resultado final calculado pelo backend.

A regra é:

```text
Perfil
+ Override
+ Contrato
+ Módulos contratados
+ Situação do usuário
= Permissão efetiva
```

Também considera:

- master;
    
- superusuário;
    
- status do contrato;
    
- dependências do módulo.
    

Regra principal:

```text
Ausência de permissão = acesso negado
```

---

## Matriz de Permissões

A tela de usuário representa:

|Módulo|Perfil|Override|Efetivo|
|---|---|---|---|
|Compras|VIEW|EDIT|EDIT|
|Financeiro|NONE|HERDAR|NONE|
|Auditoria|VIEW|HERDAR|VIEW|

O frontend exibe os valores.

O backend é responsável pelo cálculo efetivo.

---

## Loja Principal

Representa a unidade operacional principal do usuário.

Regras:

- deve pertencer à empresa do usuário;
    
- deve estar incluída nas lojas permitidas;
    
- não pode pertencer a outra empresa;
    
- pode ser nula quando a função não exigir loja.
    

---

## Lojas Permitidas

Representam o conjunto de estabelecimentos que o usuário pode acessar.

Todas devem pertencer à empresa do usuário.

A relação não pode ampliar o acesso para outra empresa.

---

## Autoproteção do Usuário

Um usuário não pode:

- elevar a própria permissão;
    
- alterar a própria empresa;
    
- atribuir a si mesmo um perfil superior;
    
- ampliar as próprias lojas;
    
- tornar-se master;
    
- alterar campos internos de segurança.
    

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

# Ciclo de Vida do Usuário

## Criação

Na criação:

- empresa é validada;
    
- perfil é validado;
    
- lojas são validadas;
    
- senha inicial é definida;
    
- nenhuma licença é consumida;
    
- auditoria é registrada.
    

---

## Ativação

A ativação:

- permite novo login;
    
- não cria sessão;
    
- não consome licença;
    
- não reativa sessões antigas.
    

---

## Inativação

A inativação:

- bloqueia novos logins;
    
- encerra sessões;
    
- revoga tokens;
    
- libera vagas;
    
- atualiza permissões;
    
- registra auditoria.
    

Master não pode ser inativado.

---

## Exclusão Administrativa

Representa uma exclusão excepcional.

Antes da exclusão devem ser verificadas dependências.

O master não pode ser excluído.

A exclusão utiliza Auditoria obrigatória.

---

## Redefinição Administrativa de Senha

Representa a definição de uma nova senha por administrador autorizado.

A operação:

- valida a senha;
    
- marca `deve_trocar_senha`;
    
- pode encerrar sessões;
    
- revoga tokens;
    
- exige novo login;
    
- registra Auditoria obrigatória.
    

A senha nunca é gravada na Auditoria.

---

## Troca Obrigatória de Senha

Representa a obrigação de o próprio usuário trocar a senha temporária.

Campo:

```text
deve_trocar_senha
```

Enquanto estiver ativo:

- o usuário consegue autenticar;
    
- o usuário não acessa os módulos normais;
    
- o usuário acessa apenas recursos mínimos;
    
- o backend retorna `PASSWORD_CHANGE_REQUIRED`.
    

---

## Troca de Senha pelo Usuário

O usuário informa:

- senha atual;
    
- nova senha;
    
- confirmação.
    

A operação:

- valida a senha atual;
    
- aplica validadores do Django;
    
- impede reutilização imediata da mesma senha;
    
- limpa `deve_trocar_senha`;
    
- encerra outras sessões;
    
- mantém a sessão atual;
    
- registra Auditoria obrigatória.
    

---

# Licenciamento e Sessões

## Sessão de Usuário

Representa uma utilização autenticada e simultânea.

Contém:

- empresa;
    
- usuário;
    
- loja;
    
- dispositivo;
    
- IP;
    
- user-agent;
    
- início;
    
- última atividade;
    
- encerramento;
    
- motivo;
    
- situação.
    

Uma sessão ativa consome uma vaga do contrato.

---

## Token de Sessão

Representa a credencial vinculada à sessão.

O token:

- autentica requisições;
    
- pertence a uma sessão;
    
- pode ser revogado;
    
- perde validade ao encerrar a sessão;
    
- não é armazenado em texto puro.
    

Somente o hash é persistido.

---

## Dispositivo

Representa o navegador ou instalação de origem.

É identificado por:

```text
device_id
```

Serve para:

- distinguir sessões;
    
- substituir sessão anterior;
    
- controlar acessos simultâneos;
    
- registrar auditoria.
    

---

## Acesso Simultâneo

Representa uma vaga do contrato.

Não corresponde a um usuário cadastrado.

Uma vaga é consumida quando uma sessão é criada.

É liberada por:

- logout;
    
- timeout;
    
- substituição;
    
- inativação;
    
- suspensão da empresa;
    
- encerramento administrativo;
    
- redefinição de senha.
    

---

## Limite de Sessões

É definido no contrato.

Quando atingido:

- novo login é negado;
    
- nenhuma sessão adicional é criada;
    
- evento de auditoria é registrado.
    

Código:

```text
CONCURRENT_SESSION_LIMIT_REACHED
```

---

## Encerramento de Sessão

Uma sessão pode ser encerrada por:

```text
LOGOUT
TIMEOUT
REPLACED
ADMIN_TERMINATED
SELF_TERMINATED
USER_INACTIVATED
CONTRACT_SUSPENDED
PASSWORD_RESET
```

Os nomes exatos devem seguir os choices existentes no código.

---

## Encerramento Consolidado

Representa o encerramento de todas as sessões de um usuário.

A operação é transacional.

Evento principal:

```text
USER_SESSIONS_CLOSED
```

Se a Auditoria obrigatória falhar:

- sessões permanecem ativas;
    
- tokens permanecem válidos;
    
- não ocorre encerramento parcial.
    

---

## Heartbeat

Representa a atualização periódica da atividade da sessão.

Pode informar:

- sessão válida;
    
- última atividade;
    
- versão das permissões;
    
- necessidade de novo login;
    
- suspensão do contrato;
    
- troca obrigatória de senha.
    

---

# Auditoria

## Evento de Auditoria

Representa um fato relevante ocorrido no SISVAR.

O model central é:

```text
AuditLog
```

Pode representar:

- sucesso;
    
- falha;
    
- acesso negado;
    
- rollback;
    
- alteração cadastral;
    
- ação administrativa;
    
- evento de segurança;
    
- ação de negócio.
    

---

## Contexto de Auditoria

Pode conter:

- empresa;
    
- loja;
    
- usuário;
    
- sessão;
    
- dispositivo;
    
- IP;
    
- user-agent;
    
- método HTTP;
    
- endpoint;
    
- status HTTP;
    
- request ID;
    
- correlation ID.
    

---

## Snapshot Histórico

Preserva informações no momento do evento.

Snapshots existentes:

```text
empresa_id_snapshot
empresa_nome_snapshot

loja_id_snapshot
loja_nome_snapshot

user_id_snapshot
username_snapshot
user_nome_snapshot
```

---

## Estado Anterior e Posterior

Estado anterior:

```text
before_data
```

Estado posterior:

```text
after_data
```

Campos alterados:

```text
changed_fields
```

Dados complementares:

```text
metadata
```

---

## Auditoria Normal

Representa eventos que podem ser persistidos depois da confirmação da operação.

Utiliza:

```text
transaction.on_commit()
```

Se a operação sofrer rollback, o evento de sucesso não é criado.

---

## Auditoria Obrigatória

Representa eventos necessários para confirmar uma operação crítica.

Se a Auditoria falhar, a operação principal sofre rollback.

Aplicações atuais incluem:

- suspensão;
    
- reativação;
    
- transferência de master;
    
- perfil padrão;
    
- alteração de permissão;
    
- redefinição de senha;
    
- troca obrigatória de senha;
    
- encerramento consolidado de sessões;
    
- exclusão administrativa.
    

---

## Eventos do Contrato

Exemplos:

```text
CONTRACT_SUSPENDED
CONTRACT_REACTIVATED
CONTRACT_SUSPENSION_DENIED
CONTRACT_REACTIVATION_DENIED
```

---

## Eventos do Estabelecimento

Exemplos:

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

## Eventos do Usuário

Exemplos:

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

---

## Imutabilidade

Eventos não podem ser alterados ou excluídos por operações comuns.

A criação ocorre pelo `AuditService`.

A API é somente leitura.

---

## Sanitização

Não registrar:

- senha;
    
- token;
    
- cookie;
    
- Authorization;
    
- certificado;
    
- chave privada;
    
- hash de token;
    
- secrets.
    

Esses valores são removidos ou substituídos por:

```text
[REDACTED]
```

---

# Cadastros

O grupo Cadastros reúne entidades compartilhadas pelos demais módulos.

Itens iniciais do menu:

- Clientes;
    
- Fornecedores;
    
- Funcionários.
    

Também existem entidades auxiliares como:

- naturezas de lançamento;
    
- plano financeiro;
    
- plano contábil;
    
- formas de pagamento;
    
- tabelas auxiliares.
    

Esse grupo será revisado após a homologação manual do Operacional.

---

# Produtos

O domínio de Produtos inclui:

- produto;
    
- SKU;
    
- grade;
    
- tamanho;
    
- cor;
    
- coleção;
    
- estação;
    
- grupo;
    
- subgrupo;
    
- NCM;
    
- unidade;
    
- tabela de preço;
    
- pack;
    
- itens do pack.
    

A revisão detalhada ainda será realizada.

---

# Compras

O domínio de Compras inclui:

- pedido;
    
- itens;
    
- packs;
    
- parcelas;
    
- aprovação;
    
- cancelamento;
    
- reabertura;
    
- recebimento;
    
- futura Entrada de Nota Fiscal.
    

Pode integrar:

- estoque;
    
- fiscal;
    
- financeiro;
    
- contabilidade;
    
- auditoria.
    

---

# Estoque

Controla movimentações físicas.

Origens possíveis:

- compras;
    
- produção;
    
- vendas;
    
- devoluções;
    
- distribuição;
    
- transferências;
    
- ajustes;
    
- inventário.
    

Toda movimentação deve possuir origem rastreável.

---

# Produção

Pode incluir:

- ficha técnica;
    
- matéria-prima;
    
- ordem de produção;
    
- consumo;
    
- facção;
    
- retorno;
    
- finalização;
    
- produto acabado.
    

---

# Distribuição

Pode incluir:

- estoque de origem;
    
- lojas de destino;
    
- perfis percentuais;
    
- quantidades por tamanho;
    
- reserva;
    
- separação;
    
- pedidos por loja;
    
- transferências;
    
- faturamento;
    
- recebimento.
    

---

# Vendas e PDV

Pode incluir:

- orçamento;
    
- pedido;
    
- venda;
    
- itens;
    
- pagamentos;
    
- descontos;
    
- caixa;
    
- NFC-e;
    
- devoluções;
    
- PDV Offline.
    

---

# Fiscal

Responsável por:

- NF-e;
    
- NFC-e;
    
- documentos fiscais;
    
- tributos;
    
- emissão;
    
- rejeições;
    
- contingência;
    
- eventos fiscais.
    

---

# Financeiro

Responsável por:

- contas a pagar;
    
- contas a receber;
    
- parcelas;
    
- baixas;
    
- cancelamentos;
    
- reaberturas;
    
- caixas;
    
- bancos;
    
- fluxo de caixa;
    
- rateios.
    

---

# Contabilidade

Responsável por:

- plano contábil;
    
- contas;
    
- hierarquia;
    
- lançamentos;
    
- integração financeira;
    
- estornos.
    

---

# Relatórios e Dashboards

Representam consultas consolidadas.

O acesso depende de:

- empresa;
    
- loja;
    
- módulos contratados;
    
- permissão efetiva;
    
- dependências entre módulos.
    

---

# Relacionamentos Principais

## Empresa

```text
Empresa
→ Contrato
→ Módulos Contratados
→ Estabelecimentos
→ Usuários
→ Perfis
→ Sessões
→ Cadastros
→ Produtos
→ Compras
→ Estoque
→ Produção
→ Distribuição
→ Vendas
→ Fiscal
→ Financeiro
→ Contabilidade
→ Auditoria
```

## Contrato

```text
Contrato
→ Empresa
→ Master
→ Limite de Sessões
→ Status
→ Suspensão
→ Reativação
→ Módulos
→ Versão das Permissões
```

## Estabelecimento

```text
Estabelecimento
→ Empresa
→ Usuários
→ Sessões
→ Estoque
→ Vendas
→ Fiscal
→ Distribuição
→ Auditoria
```

## Usuário

```text
Usuário
→ Empresa
→ Perfil
→ Tipo Funcional
→ Loja Principal
→ Lojas Permitidas
→ Overrides
→ Sessões
→ Auditoria
```

## Perfil

```text
Perfil
→ Empresa
→ Permissões por Módulo
→ Usuários
→ Perfil Padrão
```

## Sessão

```text
Sessão
→ Empresa
→ Estabelecimento
→ Usuário
→ Dispositivo
→ Token
→ Auditoria
```

## Auditoria

```text
Evento
→ Empresa
→ Estabelecimento
→ Usuário
→ Sessão
→ Dispositivo
→ Objeto
→ Requisição
→ Operação
```

---

# Situação Atual

## Implementado e validado automaticamente

- Empresa
    
- Contrato
    
- Módulos contratados
    
- Suspensão administrativa
    
- Reativação
    
- Estabelecimento obrigatório por empresa
    
- Tipos de estabelecimento
    
- Ciclo de vida do estabelecimento
    
- Usuário
    
- Usuário master
    
- Perfil de acesso
    
- Perfil padrão
    
- Dependências entre módulos
    
- Permissão por módulo
    
- Override
    
- Permissão efetiva
    
- Loja principal
    
- Lojas permitidas
    
- Sessão
    
- Token
    
- Device ID
    
- Licenciamento simultâneo
    
- Encerramento consolidado de sessões
    
- Redefinição administrativa de senha
    
- Troca obrigatória de senha
    
- Auditoria Central
    

## Validação automatizada

Backend:

```text
50 testes aprovados
```

Frontend:

```text
33 testes aprovados
```

## Homologação manual pendente

Ainda precisam ser testados no navegador:

- suspensão;
    
- reativação;
    
- encerramento das sessões;
    
- bloqueio de login;
    
- troca obrigatória de senha;
    
- Estabelecimento com VIEW;
    
- Estabelecimento com EDIT;
    
- matriz Perfil/Override/Efetivo;
    
- dependências de módulos;
    
- novos eventos na Auditoria.
    

---

# Próxima Etapa

Após a homologação manual do Operacional, a revisão seguirá a ordem do menu lateral.

Próximo grupo:

```text
Cadastros
```

Itens iniciais:

- Clientes;
    
- Fornecedores;
    
- Funcionários.
    

---

# Decisões Relacionadas

- ADR-001 — Licenciamento por Sessões Simultâneas.
    
- ADR-002 — Princípios Arquiteturais do SISVAR.
    
- ADR-003 — Auditoria Central do SISVAR.
    

---

# Notas Relacionadas

- [[10 Projetos/Sysvar/Sysvar|Sysvar]]
    
- [[10 Projetos/Sysvar/Contexto do Projeto/Visão Geral|Visão Geral]]
    
- [[10 Projetos/Sysvar/Contexto do Projeto/Arquitetura|Arquitetura]]
    
- [[10 Projetos/Sysvar/Contexto do Projeto/Workflows|Workflows]]
    
- [[10 Projetos/Sysvar/Contexto do Projeto/Riscos e Cuidados|Riscos e Cuidados]]
    
- [[10 Projetos/Sysvar/Contexto do Projeto/Mapa Técnico|Mapa Técnico]]
    
- [[10 Projetos/Sysvar/Decisões Técnicas/ADR-001 - Licenciamento por Sessões Simultâneas|ADR-001 - Licenciamento por Sessões Simultâneas]]
    
- [[10 Projetos/Sysvar/Decisões Técnicas/ADR-002 - Princípios Arquiteturais do SISVAR|ADR-002 - Princípios Arquiteturais do SISVAR]]
    
- [[10 Projetos/Sysvar/Decisões Técnicas/ADR-003 - Auditoria Central do SISVAR|ADR-003 - Auditoria Central do SISVAR]]