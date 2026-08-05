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
    
- auditoria
    
- segurança
    
- multiempresa
    

---

# Modelo de Domínio

## Objetivo

O Modelo de Domínio descreve as principais entidades do SISVAR, suas responsabilidades e seus relacionamentos.

Ele representa a visão funcional do sistema.

Não deve ser confundido com uma cópia direta das tabelas do banco de dados ou das classes do Django.

---

# Organização do domínio

O domínio do SISVAR está dividido nos seguintes grupos:

- Plataforma
    
- Empresas e Contratos
    
- Segurança e Acesso
    
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
    
- lojas;
    
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

## Loja

Representa uma unidade operacional pertencente a uma empresa.

Uma empresa pode possuir várias lojas.

A loja pode estar relacionada a:

- usuários;
    
- sessões;
    
- estoque;
    
- vendas;
    
- caixa;
    
- distribuição;
    
- documentos fiscais;
    
- operações financeiras;
    
- registros de auditoria.
    

A loja nunca pode pertencer a uma empresa diferente da empresa do objeto relacionado.

---

## Módulo do Sistema

Representa uma funcionalidade comercializável e controlável.

Exemplos:

- Cadastros;
    
- Produtos;
    
- Compras;
    
- Estoque;
    
- Vendas;
    
- Fiscal;
    
- Financeiro;
    
- Produção;
    
- Distribuição;
    
- Relatórios;
    
- Auditoria.
    

O módulo possui uma chave estável.

Exemplo:

```text
auditoria
```

O contrato determina quais módulos estão disponíveis para a empresa.

---

# Empresas e Contratos

## Contrato

Representa o contrato comercial e operacional da empresa no SISVAR.

O contrato controla:

- situação;
    
- vigência;
    
- plano completo;
    
- usuário master;
    
- limite de acessos simultâneos;
    
- versão das permissões;
    
- módulos contratados.
    

A autenticação de usuários clientes depende da existência e validade do contrato.

Alterações críticas do contrato utilizam transação e auditoria obrigatória.

---

## Empresa Módulo

Representa a contratação ou disponibilidade de um módulo para uma empresa.

Relaciona:

```text
Empresa
→ Módulo do Sistema
```

Controla se determinado módulo está disponível para o cliente.

Alterações nessa entidade podem modificar imediatamente:

- menus;
    
- rotas;
    
- endpoints;
    
- permissões efetivas;
    
- acesso dos usuários.
    

Por isso, alterações de módulos contratados são operações críticas auditadas.

---

# Segurança e Acesso

## Usuário

Representa uma pessoa autorizada a utilizar o SISVAR.

Um usuário cliente pertence a uma empresa.

Um usuário pode possuir:

- perfil principal;
    
- permissões adicionais;
    
- acesso a lojas;
    
- uma ou mais sessões;
    
- registros de auditoria associados.
    

Criar ou ativar um usuário não consome licença.

O consumo ocorre apenas quando existe uma sessão ativa.

---

## Superusuário da Plataforma

Representa um administrador global do SISVAR.

Pode:

- administrar empresas;
    
- administrar contratos;
    
- administrar módulos;
    
- consultar sessões globais;
    
- consultar auditoria de todas as empresas;
    
- realizar manutenção da plataforma.
    

Não está sujeito ao limite de acessos simultâneos dos contratos das empresas clientes.

---

## Usuário Master

Representa o administrador principal de uma empresa.

O master é definido no contrato da empresa.

Pode administrar, dentro do escopo contratado:

- usuários;
    
- perfis;
    
- permissões;
    
- sessões;
    
- auditoria;
    
- configurações da empresa.
    

Existe um único master vigente por empresa.

A transferência de master é uma operação crítica, transacional e obrigatoriamente auditada.

---

## Perfil de Acesso

Representa um conjunto reutilizável de permissões.

Cada perfil pertence a uma empresa.

Um perfil pode conter permissões por módulo.

Exemplos de perfis:

- Administrador;
    
- Gerente;
    
- Vendedor;
    
- Caixa;
    
- Estoquista;
    
- Financeiro.
    

O nome do perfil não concede acesso por si só.

O acesso efetivo é calculado pelo backend.

---

## Perfil Módulo Permissão

Representa o nível de acesso de um perfil a um módulo.

Relaciona:

```text
Perfil de Acesso
→ Módulo do Sistema
→ Nível de Acesso
```

Níveis atuais:

```text
NONE
VIEW
EDIT
```

Alterar essa entidade pode modificar o acesso de vários usuários.

Por isso, a alteração é considerada crítica e utiliza auditoria obrigatória.

---

## Permissão Adicional do Usuário

Representa um override individual sobre as permissões herdadas do perfil.

Pode:

- conceder acesso adicional;
    
- reduzir acesso;
    
- substituir o nível definido no perfil.
    

O backend calcula a permissão efetiva considerando:

- empresa;
    
- contrato;
    
- módulo contratado;
    
- perfil;
    
- override;
    
- usuário master;
    
- situação do usuário.
    

---

## Permissão Efetiva

Não é apenas um cadastro isolado.

É o resultado do cálculo realizado pelo backend.

Considera:

- usuário ativo;
    
- empresa ativa;
    
- contrato válido;
    
- módulo contratado;
    
- perfil;
    
- permissão do perfil;
    
- override do usuário;
    
- master;
    
- superusuário.
    

Regra principal:

```text
Ausência de permissão = acesso negado
```

---

## Sessão de Usuário

Representa uma utilização autenticada e simultânea do sistema.

Uma sessão contém:

- identificador;
    
- empresa;
    
- usuário;
    
- loja;
    
- dispositivo;
    
- endereço IP;
    
- user-agent;
    
- início;
    
- última atividade;
    
- encerramento;
    
- motivo do encerramento;
    
- situação ativa ou encerrada.
    

Uma sessão ativa consome uma vaga do contrato.

---

## Token de Sessão

Representa a credencial técnica vinculada a uma sessão.

O token:

- autentica requisições;
    
- pertence a uma sessão;
    
- pode ser revogado;
    
- perde validade quando a sessão termina;
    
- não é armazenado em texto puro.
    

Somente o hash é persistido.

Token sem sessão válida não autentica o usuário.

---

## Dispositivo

Representa o navegador ou instalação que originou a sessão.

É identificado por um `device_id`.

O dispositivo é utilizado para:

- distinguir acessos;
    
- substituir sessão anterior no mesmo dispositivo;
    
- registrar contexto de auditoria;
    
- controlar sessões simultâneas.
    

O mesmo usuário em dispositivos diferentes mantém sessões independentes.

---

# Licenciamento

## Acesso Simultâneo

Representa uma vaga disponível no contrato.

Não existe como usuário cadastrado.

Uma vaga é consumida quando uma sessão ativa é criada.

Uma vaga é liberada quando a sessão é encerrada por:

- logout;
    
- timeout;
    
- inativação;
    
- substituição;
    
- encerramento administrativo.
    

---

## Limite de Sessões

É definido no contrato.

Controla quantas sessões simultâneas podem permanecer ativas para a empresa.

Quando o limite é atingido:

- o novo login é negado;
    
- nenhuma sessão adicional é criada;
    
- um evento de auditoria é registrado.
    

---

# Auditoria

## Evento de Auditoria

Representa um fato relevante ocorrido no SISVAR.

O evento pode representar:

- sucesso;
    
- falha;
    
- acesso negado;
    
- operação pendente;
    
- rollback;
    
- evento técnico;
    
- alteração cadastral;
    
- ação de negócio;
    
- evento de segurança.
    

O model central utilizado é:

```text
AuditLog
```

---

## Identificador do Evento

Cada evento possui um `event_id` único.

Permite:

- pesquisa;
    
- suporte;
    
- referência externa;
    
- exportação;
    
- investigação.
    

---

## Request ID

Identifica a requisição HTTP que originou o evento.

Vários eventos podem compartilhar o mesmo request ID quando foram gerados pela mesma requisição.

---

## Correlation ID

Relaciona eventos pertencentes à mesma operação de negócio.

Exemplo:

```text
Aprovação de pedido
→ geração financeira
→ movimentação de estoque
→ auditorias relacionadas
```

---

## Contexto de Auditoria

Representa as informações técnicas e funcionais disponíveis no momento do evento.

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
    

Esse contexto é fornecido pelo `AuditContextMiddleware`.

---

## Snapshot Histórico

Representa uma cópia dos dados de identificação no momento do evento.

São mantidos snapshots de:

- empresa;
    
- loja;
    
- usuário.
    

Exemplos:

```text
empresa_id_snapshot
empresa_nome_snapshot

loja_id_snapshot
loja_nome_snapshot

user_id_snapshot
username_snapshot
user_nome_snapshot
```

Os snapshots preservam o significado histórico mesmo quando o cadastro original é alterado posteriormente.

---

## Ação de Auditoria

Representa o tipo específico de evento.

Exemplos:

```text
USER_LOGIN
USER_LOGOUT
SESSION_TIMEOUT
SESSION_LIMIT_REACHED
CONTRACT_UPDATED
MASTER_TRANSFERRED
PERMISSION_UPDATED
AUDIT_EXPORT
OBJECT_CREATED
OBJECT_UPDATED
OBJECT_DELETED
```

Ações oficiais pertencem ao catálogo central `AuditAction`.

Ações desconhecidas não são aceitas livremente.

---

## Categoria de Auditoria

Classifica o domínio funcional do evento.

Categorias atuais:

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

---

## Resultado da Auditoria

Representa o resultado da operação.

Valores atuais:

```text
SUCCESS
FAILURE
DENIED
PENDING
ROLLED_BACK
```

---

## Severidade

Representa a importância ou gravidade do evento.

Valores atuais:

```text
INFO
WARNING
ERROR
CRITICAL
```

---

## Origem

Representa o canal ou processo que gerou o evento.

Valores atuais:

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

## Objeto Auditado

Representa a entidade afetada pelo evento.

Pode conter:

- app;
    
- model;
    
- object ID;
    
- representação textual.
    

Exemplo:

```text
accounts.user #25
```

---

## Estado Anterior

Representado por:

```text
before_data
```

Contém os valores relevantes existentes antes da operação.

---

## Estado Posterior

Representado por:

```text
after_data
```

Contém os valores relevantes existentes depois da operação.

---

## Campos Alterados

Representado por:

```text
changed_fields
```

Contém a lista de campos efetivamente modificados.

---

## Metadata

Contém informações complementares que não representam diretamente antes e depois.

Exemplos:

- motivo;
    
- limite de sessões;
    
- quantidade exportada;
    
- filtros utilizados;
    
- número do documento;
    
- código de rejeição;
    
- origem da integração.
    

---

## Erro Auditado

Quando a operação falha, o evento pode registrar:

- código do erro;
    
- mensagem segura;
    
- status HTTP;
    
- severidade.
    

Dados internos sensíveis não devem ser expostos.

---

## Auditoria Normal

Representa eventos de sucesso que podem ser gravados depois da confirmação da operação.

Utiliza:

```python
transaction.on_commit()
```

Se a operação sofre rollback, o evento de sucesso não é criado.

---

## Auditoria Obrigatória

Representa eventos que precisam ser registrados para que a operação crítica possa ser confirmada.

Se a auditoria obrigatória falhar, a operação principal também falha.

É utilizada atualmente em operações como:

- contrato;
    
- limite de sessões;
    
- módulos contratados;
    
- transferência de master;
    
- permissões;
    
- perfil padrão;
    
- exclusão administrativa de usuário.
    

---

## Imutabilidade do Evento

Um evento de auditoria não pode ser alterado ou excluído por operações comuns.

São bloqueados:

- criação direta;
    
- edição;
    
- exclusão;
    
- atualização em massa;
    
- criação em massa;
    
- `update_or_create`;
    
- `get_or_create`.
    

A criação ocorre por meio do `AuditService`.

---

## Sanitização

Antes de persistir o evento, os dados passam por sanitização.

Exemplos de informações proibidas:

- senha;
    
- token;
    
- cookie;
    
- Authorization;
    
- segredo;
    
- certificado;
    
- chave privada;
    
- hash de token.
    

Esses dados são removidos ou substituídos por:

```text
[REDACTED]
```

---

## Consulta de Auditoria

A consulta depende da permissão efetiva.

Superusuário:

- todas as empresas.
    

Master:

- toda a própria empresa.
    

Usuário com `VIEW`:

- própria empresa;
    
- lojas permitidas;
    
- sem exportação.
    

Usuário com `EDIT`:

- própria empresa;
    
- lojas permitidas;
    
- com exportação.
    

Usuário com `NONE`:

- sem acesso.
    

---

## Exportação de Auditoria

Representa a geração de arquivo CSV dos eventos permitidos.

A exportação:

- respeita empresa;
    
- respeita loja;
    
- respeita filtros;
    
- possui limite;
    
- é auditada.
    

A exportação não altera eventos.

---

# Cadastros

O domínio de Cadastros reúne entidades básicas utilizadas por vários módulos.

Inclui, entre outros:

- clientes;
    
- fornecedores;
    
- funcionários;
    
- lojas;
    
- naturezas de lançamento;
    
- plano financeiro;
    
- plano contábil;
    
- formas de pagamento;
    
- tabelas auxiliares.
    

Todos os cadastros de cliente devem respeitar a empresa.

Quando aplicável, também devem respeitar a loja.

---

# Produtos

O domínio de Produtos representa a estrutura comercial e técnica dos itens.

Inclui:

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
    

Eventos específicos de produto e preço serão integrados detalhadamente à Auditoria durante a revisão do módulo.

---

# Compras

O domínio de Compras representa:

- pedidos;
    
- itens;
    
- packs;
    
- parcelas;
    
- aprovação;
    
- cancelamento;
    
- reabertura;
    
- recebimento;
    
- entrada de mercadorias.
    

Compras podem integrar:

- estoque;
    
- financeiro;
    
- fiscal;
    
- auditoria.
    

A integração detalhada dos eventos de negócio será revisada na etapa do módulo.

---

# Estoque

O domínio de Estoque controla movimentações físicas.

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

Eventos críticos deverão utilizar auditoria explícita.

---

# Produção

O domínio de Produção controla:

- ficha técnica;
    
- matéria-prima;
    
- ordem de produção;
    
- consumo;
    
- envio para facção;
    
- retorno;
    
- finalização;
    
- entrada do produto acabado.
    

A integração completa ainda será revisada.

---

# Distribuição

O domínio de Distribuição controla o envio de produtos da origem para as lojas.

Pode incluir:

- estoque disponível;
    
- perfil de distribuição;
    
- percentuais;
    
- quantidades por tamanho;
    
- reserva;
    
- separação;
    
- pedidos por loja;
    
- transferência;
    
- faturamento;
    
- recebimento.
    

A integração detalhada com estoque, fiscal e auditoria ainda será revisada.

---

# Vendas e PDV

O domínio de Vendas representa:

- orçamento;
    
- pedido;
    
- venda;
    
- itens;
    
- pagamento;
    
- desconto;
    
- caixa;
    
- NFC-e;
    
- devolução.
    

O PDV Offline deverá utilizar a mesma identidade de empresa, loja, usuário, sessão e auditoria, adaptada ao processo de sincronização.

---

# Fiscal

O domínio Fiscal é responsável por:

- documentos fiscais;
    
- NFC-e;
    
- NF-e;
    
- eventos fiscais;
    
- tributos;
    
- integrações;
    
- rejeições;
    
- contingência.
    

Falhas e operações fiscais críticas deverão gerar auditoria explícita.

---

# Financeiro

O domínio Financeiro é responsável por:

- contas a pagar;
    
- contas a receber;
    
- parcelas;
    
- baixas;
    
- cancelamentos;
    
- reaberturas;
    
- caixa;
    
- bancos;
    
- fluxo de caixa;
    
- rateios.
    

Operações financeiras críticas deverão ser auditadas durante a revisão do módulo.

---

# Contabilidade

O domínio Contábil representa:

- plano contábil;
    
- contas;
    
- hierarquia;
    
- lançamentos;
    
- integração financeira;
    
- estornos.
    

Alterações contábeis devem preservar rastreabilidade.

---

# Relatórios e Dashboards

Representam consultas consolidadas sobre os módulos.

Podem depender simultaneamente de:

- módulo de Relatórios;
    
- módulo de origem;
    
- empresa;
    
- loja;
    
- permissão efetiva.
    

Exportações sensíveis podem exigir auditoria.

---

# Relacionamentos principais

## Empresa

```text
Empresa
→ Contrato
→ Módulos Contratados
→ Lojas
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
→ Usuário Master
→ Limite de Sessões
→ Plano Completo
→ Versão das Permissões
```

## Usuário

```text
Usuário
→ Empresa
→ Perfil
→ Permissões Adicionais
→ Lojas Permitidas
→ Sessões
→ Eventos de Auditoria
```

## Perfil

```text
Perfil
→ Empresa
→ Permissões por Módulo
→ Usuários
```

## Sessão

```text
Sessão
→ Empresa
→ Loja
→ Usuário
→ Dispositivo
→ Token
→ Eventos de Auditoria
```

## Auditoria

```text
Evento de Auditoria
→ Empresa
→ Loja
→ Usuário
→ Sessão
→ Dispositivo
→ Objeto
→ Requisição
→ Operação de Negócio
```

---

# Situação atual

## Implementado, testado e homologado

- Empresa
    
- Loja
    
- Contrato
    
- Módulo do Sistema
    
- Empresa Módulo
    
- Usuário
    
- Usuário Master
    
- Perfil de Acesso
    
- Permissão por Módulo
    
- Permissão adicional
    
- Permissão efetiva
    
- Sessão de Usuário
    
- Token de Sessão
    
- Device ID
    
- Licenciamento por sessões simultâneas
    
- Auditoria Central
    
- Contexto de Auditoria
    
- Snapshots históricos
    
- Sanitização
    
- Imutabilidade
    
- Consulta de Auditoria
    
- Indicadores
    
- Exportação CSV
    

## Implementado em módulos existentes, ainda sujeito a revisão detalhada

- Cadastros
    
- Produtos
    
- Compras
    
- Estoque
    
- Financeiro
    
- Fiscal
    
- Vendas
    
- Dashboards
    

## Em evolução ou pendente de revisão completa

- Entrada de Nota Fiscal
    
- Produção
    
- Distribuição
    
- PDV Offline
    
- Integração detalhada da Auditoria com cada módulo
    
- Relatórios consolidados
    
- Contabilidade integrada
    

---

# Decisões relacionadas

- ADR-001 — Licenciamento por Sessões Simultâneas.
    
- ADR-002 — Princípios Arquiteturais do SISVAR.
    
- ADR-003 — Auditoria Central do SISVAR.
    

---

# Notas relacionadas

- [[10 Projetos/Sysvar/Sysvar|Sysvar]]
    
- [[10 Projetos/Sysvar/Contexto do Projeto/Arquitetura|Arquitetura]]
    
- [[10 Projetos/Sysvar/Contexto do Projeto/Workflows|Workflows]]
    
- [[10 Projetos/Sysvar/Contexto do Projeto/Riscos e Cuidados|Riscos e Cuidados]]
    
- [[10 Projetos/Sysvar/Contexto do Projeto/Mapa Técnico|Mapa Técnico]]
    
- [[10 Projetos/Sysvar/Decisões Técnicas/ADR-001 - Licenciamento por Sessões Simultâneas|ADR-001 - Licenciamento por Sessões Simultâneas]]
    
- [[10 Projetos/Sysvar/Decisões Técnicas/ADR-002 - Princípios Arquiteturais do SISVAR|ADR-002 - Princípios Arquiteturais do SISVAR]]
    
- [[10 Projetos/Sysvar/Decisões Técnicas/ADR-003 - Auditoria Central do SISVAR|ADR-003 - Auditoria Central do SISVAR]]