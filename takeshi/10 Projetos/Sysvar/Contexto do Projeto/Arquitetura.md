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
    
- auditoria
    
- multiempresa
    

---

# Arquitetura

## Objetivo

A arquitetura do SISVAR foi projetada para suportar um ERP SaaS voltado ao varejo de moda, com foco em:

- segurança;
    
- isolamento entre empresas;
    
- isolamento por loja;
    
- escalabilidade;
    
- modularização;
    
- rastreabilidade;
    
- manutenção;
    
- evolução contínua.
    

Toda decisão arquitetural deve permitir que novos módulos sejam adicionados sem comprometer os existentes.

---

# Princípios da arquitetura

O SISVAR segue os seguintes princípios:

- backend como autoridade final;
    
- frontend como camada de apresentação;
    
- acesso baseado em permissões efetivas;
    
- ausência de permissão significa bloqueio;
    
- isolamento multiempresa obrigatório;
    
- isolamento por loja quando aplicável;
    
- arquitetura modular;
    
- serviços transversais centralizados;
    
- operações críticas transacionais;
    
- auditoria centralizada;
    
- dados sensíveis protegidos;
    
- APIs compatíveis sempre que possível;
    
- migrations obrigatórias;
    
- testes proporcionais ao risco;
    
- documentação técnica versionada;
    
- decisões arquiteturais registradas por ADR.
    

---

# Arquitetura lógica

O sistema é dividido nas seguintes camadas principais:

1. Frontend.
    
2. Backend.
    
3. Banco de Dados.
    
4. Infraestrutura transversal.
    
5. Documentação.
    

---

# Frontend

Tecnologia principal:

```text
Angular 17 Standalone
```

O frontend é responsável por:

- interface do usuário;
    
- navegação;
    
- componentes;
    
- formulários;
    
- dashboards;
    
- filtros;
    
- tabelas;
    
- indicadores;
    
- experiência do usuário;
    
- validações simples;
    
- exibição conforme permissões efetivas.
    

O frontend não é responsável por decidir:

- permissões;
    
- empresa do registro;
    
- loja permitida;
    
- contrato válido;
    
- módulo contratado;
    
- limite de sessões;
    
- regras financeiras;
    
- regras de estoque;
    
- regras fiscais;
    
- auditoria obrigatória;
    
- autorização final.
    

Menus, botões, campos e rotas podem ser ocultados conforme o contexto do usuário.

Essa ocultação não representa segurança suficiente.

Toda operação é novamente validada pelo backend.

---

# Backend

Tecnologias principais:

- Python;
    
- Django;
    
- Django REST Framework.
    

O backend é responsável por:

- autenticação;
    
- autorização;
    
- isolamento multiempresa;
    
- isolamento por loja;
    
- contratos;
    
- módulos;
    
- permissões;
    
- sessões;
    
- licenciamento;
    
- regras de negócio;
    
- validações;
    
- transações;
    
- integrações;
    
- auditoria;
    
- APIs REST;
    
- tratamento de erros;
    
- proteção de dados.
    

Toda regra crítica deve permanecer no backend.

Nenhum módulo deve confiar exclusivamente em informações enviadas pelo frontend.

---

# Banco de Dados

Tecnologia principal:

```text
MySQL
```

O banco é responsável por:

- persistência;
    
- integridade referencial;
    
- histórico;
    
- índices;
    
- contratos;
    
- sessões;
    
- permissões;
    
- auditoria;
    
- dados dos módulos de negócio.
    

Toda alteração estrutural deve possuir migration.

Não utilizar alteração manual de produção como substituto de migration.

Recursos utilizados no Django devem ser conferidos quanto à compatibilidade real com MySQL.

Quando uma constraint não for suportada pelo MySQL, deve ser utilizada uma solução compatível baseada em:

- estrutura alternativa;
    
- serviço central;
    
- validação de aplicação;
    
- transação;
    
- bloqueio de linha;
    
- testes específicos.
    

---

# Infraestrutura transversal

A infraestrutura transversal é formada por serviços utilizados por vários módulos.

Atualmente inclui:

- autenticação;
    
- acesso efetivo;
    
- contratos;
    
- módulos contratados;
    
- perfis;
    
- permissões;
    
- sessões;
    
- licenciamento;
    
- transferência de master;
    
- auditoria central.
    

Novos módulos devem reutilizar esses serviços.

Não criar mecanismos paralelos para responsabilidades já centralizadas.

---

# Documentação

O Vault do Obsidian é a memória técnica oficial do projeto.

A documentação registra:

- estado atual;
    
- arquitetura;
    
- domínio;
    
- workflows;
    
- riscos;
    
- decisões técnicas;
    
- histórico das implementações;
    
- padrões;
    
- próximos passos.
    

Nenhuma funcionalidade é considerada concluída sem:

- implementação;
    
- testes;
    
- revisão;
    
- homologação;
    
- documentação;
    
- commit.
    

---

# Multiempresa

O SISVAR é multiempresa.

Cada empresa possui seus próprios:

- contratos;
    
- módulos;
    
- lojas;
    
- usuários;
    
- perfis;
    
- permissões;
    
- sessões;
    
- cadastros;
    
- produtos;
    
- compras;
    
- estoque;
    
- vendas;
    
- financeiro;
    
- fiscal;
    
- produção;
    
- distribuição;
    
- auditoria.
    

Nenhum usuário cliente pode acessar registros pertencentes a outra empresa.

Esse isolamento deve permanecer válido mesmo quando houver:

- manipulação de URL;
    
- alteração de query parameters;
    
- alteração de payload;
    
- chamada manual à API;
    
- envio de ID de outra empresa;
    
- tentativa de vínculo cruzado;
    
- tentativa de exportação;
    
- tentativa de filtragem.
    

O backend deve obter ou validar a empresa com base no usuário, sessão, objeto e regras do domínio.

A empresa enviada pelo frontend nunca deve ser considerada fonte de verdade isoladamente.

---

# Multilojas

Cada empresa pode possuir várias lojas.

Quando uma operação depender de loja, o backend deve validar:

- se a loja pertence à empresa;
    
- se o usuário possui acesso à loja;
    
- se o objeto pertence à loja;
    
- se a operação permite loja nula;
    
- se o contexto da sessão é compatível.
    

Usuário comum:

- acessa somente lojas permitidas.
    

Usuário master:

- acessa todas as lojas da própria empresa.
    

Superusuário:

- possui acesso global administrativo.
    

Filtros de loja não podem ampliar o acesso definido pelo backend.

---

# Empresas

A empresa representa um cliente do SISVAR.

A empresa concentra o contexto principal de:

- contrato;
    
- módulos;
    
- usuários;
    
- lojas;
    
- perfis;
    
- sessões;
    
- dados operacionais;
    
- auditoria.
    

A situação da empresa é validada durante a autenticação e nas operações administrativas relevantes.

---

# Contratos

Cada empresa cliente depende de contrato válido.

O contrato controla:

- situação;
    
- vigência;
    
- plano completo;
    
- módulos contratados;
    
- limite de acessos simultâneos;
    
- usuário master;
    
- versão das permissões.
    

O contrato é validado durante a autenticação.

Alterações críticas de contrato utilizam:

- transação;
    
- auditoria obrigatória;
    
- atualização da versão das permissões.
    

Exemplos:

- criação de contrato;
    
- alteração de status;
    
- alteração do limite;
    
- alteração do plano;
    
- alteração de módulos;
    
- transferência de master.
    

---

# Módulos do sistema

O SISVAR utiliza arquitetura modular.

Cada funcionalidade pertence a um módulo.

O contrato determina quais módulos ficam disponíveis para cada empresa.

Consequências:

- menus são ocultados;
    
- rotas são protegidas;
    
- endpoints são protegidos;
    
- operações são negadas;
    
- relatórios podem depender de múltiplos módulos.
    

Exemplo:

```text
Relatório financeiro = Relatórios + Financeiro
```

Mesmo que a rota exista no frontend, o backend valida o módulo antes da execução.

---

# Usuários

Existem dois grandes grupos de usuários.

## Superusuário da plataforma

Possui acesso administrativo global.

Pode:

- administrar empresas;
    
- administrar contratos;
    
- administrar módulos;
    
- consultar sessões;
    
- consultar auditoria global;
    
- realizar manutenção da plataforma.
    

Não está sujeito ao limite de acessos simultâneos das empresas clientes.

---

## Usuários das empresas

Pertencem a uma empresa.

Podem ser:

- usuário master;
    
- usuário comum.
    

O usuário master administra, dentro da própria empresa:

- usuários;
    
- perfis;
    
- permissões;
    
- sessões;
    
- auditoria;
    
- configurações permitidas.
    

Usuários comuns dependem das permissões efetivas.

---

# Usuário master

Cada empresa possui um usuário master definido no contrato.

O master possui acesso administrativo ao que a empresa contratou.

Pode administrar:

- usuários;
    
- perfis;
    
- permissões;
    
- sessões;
    
- auditoria da própria empresa.
    

A transferência de master:

- exige autorização;
    
- utiliza transação;
    
- utiliza bloqueio adequado;
    
- utiliza auditoria obrigatória.
    

Um master não deve ser excluído ou inativado sem transferência prévia.

---

# Perfis de acesso

Perfis representam conjuntos reutilizáveis de permissões.

Cada perfil pertence a uma empresa.

Um perfil pode determinar o nível de acesso a cada módulo.

Níveis atuais:

```text
NONE
VIEW
EDIT
```

O perfil padrão é único por empresa conforme a regra de aplicação implementada.

Alterações em perfis podem modificar as permissões efetivas dos usuários.

Por isso, alterações críticas de perfil e permissão são auditadas.

---

# Permissões efetivas

O backend calcula o acesso efetivo.

O cálculo considera:

- usuário;
    
- situação do usuário;
    
- empresa;
    
- situação da empresa;
    
- contrato;
    
- vigência;
    
- módulos disponíveis;
    
- perfil principal;
    
- override do usuário;
    
- usuário master;
    
- superusuário.
    

Regras principais:

- ausência de configuração resulta em bloqueio;
    
- módulo não contratado resulta em bloqueio;
    
- contrato inválido resulta em bloqueio;
    
- usuário inativo resulta em bloqueio;
    
- master possui acesso administrativo ao escopo contratado;
    
- superusuário possui acesso global.
    

O frontend recebe o resultado do backend e monta a interface.

---

# Autenticação

A autenticação é centralizada.

O login valida:

- username;
    
- senha;
    
- situação do usuário;
    
- empresa;
    
- contrato;
    
- perfil;
    
- módulos;
    
- limite de sessões simultâneas;
    
- dispositivo;
    
- loja, quando aplicável.
    

Quando o login é aprovado:

- uma sessão é criada;
    
- um token opaco é emitido;
    
- somente o hash do token é persistido;
    
- o token é vinculado à sessão;
    
- o frontend recebe o contexto efetivo.
    

O token sem sessão válida não autentica o usuário.

---

# Sessões

Cada acesso autenticado é representado por uma sessão.

A sessão registra:

- usuário;
    
- empresa;
    
- loja;
    
- dispositivo;
    
- IP;
    
- user-agent;
    
- início;
    
- última atividade;
    
- encerramento;
    
- motivo do encerramento.
    

Uma sessão pode ser encerrada por:

- logout;
    
- timeout;
    
- substituição;
    
- inativação do usuário;
    
- encerramento administrativo;
    
- outras regras de segurança.
    

---

# Licenciamento por sessões simultâneas

O SISVAR licencia por sessões simultâneas.

Regras:

- usuário cadastrado não consome licença;
    
- usuário ativo não consome licença;
    
- sessão ativa consome uma vaga;
    
- logout libera a vaga;
    
- timeout libera a vaga;
    
- inativação encerra sessões;
    
- dispositivos diferentes usam sessões independentes;
    
- novo login no mesmo dispositivo substitui a sessão anterior;
    
- login acima do limite é bloqueado;
    
- redução do limite não encerra sessões automaticamente;
    
- novos logins ficam bloqueados enquanto o limite estiver excedido.
    

O controle da última vaga utiliza transação e bloqueio de contrato.

---

# Heartbeat

O frontend mantém a sessão ativa por heartbeat.

O heartbeat:

- confirma que a sessão continua válida;
    
- atualiza a última atividade;
    
- informa a versão das permissões;
    
- detecta sessão encerrada;
    
- permite atualização do contexto.
    

O heartbeat não substitui a validação realizada nas demais requisições.

---

# Segurança

Cada requisição autenticada pode validar:

- token;
    
- sessão;
    
- expiração;
    
- usuário;
    
- empresa;
    
- contrato;
    
- módulo;
    
- permissão;
    
- loja;
    
- objeto acessado.
    

O backend aplica default deny.

A ocultação de telas no frontend não substitui a segurança no servidor.

Dados sensíveis não devem ser expostos ou registrados sem necessidade.

Exemplos:

- senhas;
    
- tokens;
    
- cookies;
    
- certificados;
    
- chaves privadas;
    
- segredos;
    
- Authorization headers.
    

---

# Auditoria Central

A Auditoria Central está implementada, testada, revisada e homologada.

Ela é uma infraestrutura transversal.

O model central é:

```text
AuditLog
```

O serviço central é:

```text
AuditService
```

O contexto é mantido por:

```text
AuditContextMiddleware
```

---

## Contexto auditado

A auditoria pode registrar:

- event ID;
    
- request ID;
    
- correlation ID;
    
- empresa;
    
- loja;
    
- usuário;
    
- sessão;
    
- dispositivo;
    
- IP;
    
- user-agent;
    
- ação;
    
- categoria;
    
- resultado;
    
- severidade;
    
- origem;
    
- app;
    
- model;
    
- objeto;
    
- representação;
    
- dados anteriores;
    
- dados posteriores;
    
- campos alterados;
    
- metadata;
    
- método HTTP;
    
- endpoint;
    
- status HTTP;
    
- erro;
    
- data e hora.
    

---

## Imutabilidade

Os logs são imutáveis.

A infraestrutura bloqueia:

- criação direta;
    
- alteração por `save`;
    
- exclusão;
    
- `QuerySet.update`;
    
- `QuerySet.delete`;
    
- `bulk_create`;
    
- `bulk_update`;
    
- `update_or_create`;
    
- `get_or_create`.
    

A criação ocorre pelo `AuditService`.

A API é somente leitura.

---

## Sanitização

A auditoria possui sanitização recursiva.

Dados como:

- senha;
    
- token;
    
- cookie;
    
- segredo;
    
- certificado;
    
- chave privada;
    
- Authorization;
    
- hash de token;
    

são removidos ou substituídos por:

```text
[REDACTED]
```

Conteúdos excessivos são truncados.

---

## Snapshots históricos

A auditoria mantém snapshots de:

- empresa;
    
- loja;
    
- usuário.
    

Isso preserva o contexto histórico mesmo quando o cadastro é alterado posteriormente.

Logs antigos foram migrados sem exclusão.

O contexto anterior foi recuperado somente quando existia fonte confiável.

---

## Auditoria normal

Eventos comuns de sucesso confirmado utilizam:

```python
transaction.on_commit()
```

Assim, não existe log de sucesso quando a transação principal sofre rollback.

---

## Auditoria obrigatória

Operações críticas podem exigir auditoria dentro da mesma transação.

Se a auditoria obrigatória falhar, a operação também falha.

Atualmente esse comportamento é utilizado em operações como:

- contrato;
    
- limite de acessos;
    
- módulos contratados;
    
- transferência de master;
    
- permissões;
    
- perfil padrão;
    
- exclusão administrativa de usuário.
    

---

## Permissões da Auditoria

Superusuário:

- consulta todas as empresas.
    

Master:

- consulta toda a própria empresa;
    
- consulta todas as lojas da empresa;
    
- exporta.
    

Usuário com `VIEW`:

- consulta a própria empresa;
    
- consulta lojas permitidas;
    
- não exporta.
    

Usuário com `EDIT`:

- consulta;
    
- exporta;
    
- não altera logs.
    

Usuário com `NONE`:

- não vê menu;
    
- não acessa rota;
    
- recebe bloqueio da API.
    

---

## API da Auditoria

Endpoints:

```text
GET /api/auditoria/logs/
GET /api/auditoria/logs/{id}/
GET /api/auditoria/logs/indicadores/
GET /api/auditoria/logs/exportar/
```

A consulta possui:

- paginação;
    
- filtros;
    
- busca;
    
- ordenação;
    
- indicadores;
    
- detalhe;
    
- exportação CSV.
    

Tentativa de consultar outra empresa ou loja não permitida retorna `403`.

---

## Integrações atuais

A Auditoria Central já está integrada a:

- login;
    
- login negado;
    
- logout;
    
- sessões;
    
- timeout;
    
- substituição de sessão;
    
- limite simultâneo;
    
- contratos;
    
- módulos;
    
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
    

Os eventos específicos dos módulos de negócio serão integrados gradualmente.

---

# Transações

Operações que alteram vários registros relacionados devem utilizar transação.

Exemplos:

- login ocupando a última vaga;
    
- transferência de master;
    
- alteração de contrato;
    
- alteração de permissões;
    
- aprovação de pedido;
    
- entrada de nota;
    
- movimentação de estoque;
    
- geração financeira;
    
- emissão fiscal;
    
- distribuição;
    
- produção;
    
- estornos.
    

Quando necessário, utilizar:

```python
transaction.atomic()
```

e:

```python
select_for_update()
```

Não registrar sucesso antes da confirmação da operação.

---

# Integração entre módulos

O SISVAR possui módulos interdependentes.

Uma alteração pode afetar:

- estoque;
    
- financeiro;
    
- fiscal;
    
- contabilidade;
    
- auditoria;
    
- dashboards;
    
- relatórios.
    

Exemplo:

```text
Aprovação de compra
→ financeiro
→ estoque
→ fiscal
→ auditoria
```

As integrações devem utilizar os serviços responsáveis pelo domínio.

Um módulo não deve duplicar regras pertencentes a outro.

---

# Escalabilidade

A arquitetura foi desenhada para permitir crescimento.

Novos módulos devem seguir os mesmos padrões de:

- autenticação;
    
- autorização;
    
- isolamento;
    
- sessões;
    
- auditoria;
    
- transações;
    
- paginação;
    
- índices;
    
- padronização visual;
    
- testes;
    
- documentação.
    

Não carregar tabelas inteiras no frontend sem necessidade.

Evitar:

- N+1;
    
- consultas sem índice;
    
- payloads excessivos;
    
- JSON sem limite;
    
- duplicação de serviços;
    
- regras críticas em componentes.
    

---

# Padrão visual

As telas devem seguir, conforme aplicável:

1. Barra Principal.
    
2. Barra do Título.
    
3. Barra de Indicadores.
    
4. Barra de Filtros.
    
5. Barra de Ações.
    
6. Área de Resultados.
    

A área de resultados deve preservar:

- tabela;
    
- paginação;
    
- intervalo exibido;
    
- total;
    
- ordenação;
    
- estado vazio;
    
- estado de carregamento;
    
- tratamento de erro.
    

Botões não aplicáveis devem ser ocultados.

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
    
- scripts;
    
- commands.
    

Breaking changes inevitáveis devem ser documentadas.

---

# Testes

Toda implementação deve possuir testes proporcionais ao risco.

Tipos:

- unitários;
    
- integração;
    
- API;
    
- banco;
    
- concorrência;
    
- frontend;
    
- regressão;
    
- homologação manual.
    

Não afirmar que um teste passou sem executá-lo.

A suíte geral deve descobrir e executar testes reais.

---

# Decisões arquiteturais

As decisões principais atuais são:

## ADR-001

Licenciamento por sessões simultâneas.

## ADR-002

Princípios arquiteturais do SISVAR.

## ADR-003

Auditoria Central do SISVAR.

Novas decisões relevantes devem gerar ADR própria.

---

# Tecnologias

## Backend

- Python
    
- Django
    
- Django REST Framework
    

## Frontend

- Angular 17 Standalone
    
- TypeScript
    

## Banco de Dados

- MySQL
    

## Versionamento

- Git
    
- GitHub
    

## Documentação

- Obsidian
    

---

# Situação atual da arquitetura

Implementado, testado e validado:

- autenticação centralizada;
    
- isolamento multiempresa;
    
- isolamento por loja;
    
- contratos;
    
- módulos contratados;
    
- usuário master;
    
- perfis;
    
- permissões efetivas;
    
- sessões simultâneas;
    
- licenciamento por sessões;
    
- device ID;
    
- heartbeat;
    
- timeout;
    
- encerramento de sessões;
    
- proteção de endpoints;
    
- Auditoria Central;
    
- imutabilidade dos logs;
    
- sanitização;
    
- snapshots históricos;
    
- consulta da Auditoria;
    
- indicadores;
    
- exportação CSV;
    
- auditoria obrigatória para operações críticas definidas.
    

---

# Próximas evoluções arquiteturais

As próximas evoluções devem acontecer durante a revisão dos módulos de negócio.

Prioridades candidatas:

- Entrada de Nota Fiscal;
    
- integração de auditoria em Cadastros;
    
- integração de auditoria em Produtos;
    
- revisão de Compras;
    
- Estoque;
    
- Financeiro;
    
- Fiscal;
    
- Produção;
    
- Distribuição;
    
- PDV Offline.
    

Cada módulo deverá seguir os serviços centrais já consolidados.

---

# Notas relacionadas

- [[10 Projetos/Sysvar/Sysvar|Sysvar]]
    
- [[10 Projetos/Sysvar/Contexto do Projeto/Modelo de Domínio|Modelo de Domínio]]
    
- [[10 Projetos/Sysvar/Contexto do Projeto/Workflows|Workflows]]
    
- [[10 Projetos/Sysvar/Contexto do Projeto/Riscos e Cuidados|Riscos e Cuidados]]
    
- [[10 Projetos/Sysvar/Contexto do Projeto/Mapa Técnico|Mapa Técnico]]
    
- [[10 Projetos/Sysvar/Decisões Técnicas/ADR-001 - Licenciamento por Sessões Simultâneas|ADR-001 - Licenciamento por Sessões Simultâneas]]
    
- [[10 Projetos/Sysvar/Decisões Técnicas/ADR-002 - Princípios Arquiteturais do SISVAR|ADR-002 - Princípios Arquiteturais do SISVAR]]
    
- [[10 Projetos/Sysvar/Decisões Técnicas/ADR-003 - Auditoria Central do SISVAR|ADR-003 - Auditoria Central do SISVAR]]