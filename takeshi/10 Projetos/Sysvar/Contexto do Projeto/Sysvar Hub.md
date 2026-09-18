---
type: reference
status: active
project: Sysvar
source: "C:/SysvarHub"
created: 2026-09-11
updated: 2026-09-14
tags:
  - sysvar
  - sysvar-hub
  - hub-local
  - pdv
  - offline
  - integracao
  - retaguarda
  - loja
---

# Sysvar Hub

## Produto

**Sysvar Hub** é o servidor local da loja para operação offline e integração com o [[Sysvar]] central.

Objetivo:

~~~text
permitir que a Loja continue operando localmente
mesmo quando a internet ou a retaguarda central estiver indisponível
~~~

A unidade offline é a **Loja**.

Não é cada Terminal/PDV isoladamente.

Regra estrutural:

~~~text
1 Loja
→ 1 Sysvar Hub
→ N Terminais/PDVs na LAN
~~~

---

## Arquitetura

Visão conceitual:

~~~text
Sysvar Central
    ↕ Internet / API
Sysvar Hub
    ↕ Rede local / LAN
Terminais / PDVs da loja
~~~

O Hub possui banco MySQL local.

Os Terminais/PDVs acessam o Hub pela API local.

Os Terminais/PDVs não devem acessar diretamente o MySQL local do Hub.

O Sysvar central continua sendo a autoridade dos cadastros principais e das regras corporativas consolidadas.

---

## Fronteira Conceitual

O Hub não cria um segundo ERP conceitual.

Não duplicar conceitualmente:

- Empresa;
- Loja;
- Produto;
- Cliente;
- Fornecedor;
- Usuário;
- demais cadastros principais.

Essas entidades continuam existindo como conceitos da retaguarda central.

O Hub mantém cópias locais, configurações, credenciais e dados operacionais necessários para funcionamento local e sincronização futura.

---

## Repositórios e Diretórios

Backend do Hub:

~~~text
FernandoMurashima/sysvarhub-backend
C:\SysvarHub\Backend
~~~

Frontend do Hub:

~~~text
FernandoMurashima/sysvarhub-frontend
C:\SysvarHub\Frontend
~~~

Estado atual:

- backend iniciado em Django;
- app local `core` contém `HubConfig`, `CaixaHub` e `Terminal`;
- app local `integracao` contém cliente da retaguarda e commands de ativação/heartbeat/bootstrap;
- frontend operacional do Hub iniciado em Angular 17.3 no repositório `FernandoMurashima/sysvarhub-frontend`.

---

## Integração Atual com o Sysvar Central

Endpoints conhecidos da retaguarda central:

~~~text
POST /api/hub/ativacoes/
POST /api/hub/ativar/
GET /api/hub/bootstrap/
POST /api/hub/heartbeat/
~~~

Responsabilidades:

- `/api/hub/ativacoes/`: endpoint administrativo do Sysvar central para criação/gestão de ativações temporárias;
- `/api/hub/ativar/`: endpoint público usado pelo Hub para trocar código temporário por credencial permanente;
- `/api/hub/bootstrap/`: endpoint autenticado usado pelo Hub para obter sua identidade canônica e caixas operacionais da Loja;
- `/api/hub/heartbeat/`: endpoint autenticado usado pelo Hub para manter status e metadados da instalação.

Autenticação do Hub após ativação:

~~~text
Authorization: Hub <TOKEN>
~~~

Não registrar o valor real do token em documentação, logs, auditoria ou mensagens.

---

## Ativação

A ativação usa código temporário gerado pela retaguarda central.

Na chamada de ativação, o Hub envia sua identidade local:

- código temporário;
- `hub_uuid`;
- nome;
- hostname;
- versão.

O Hub **não** envia `empresa_id` nem `loja_id` na ativação.

A retaguarda determina Empresa e Loja exclusivamente através do código temporário.

Resposta esperada da retaguarda:

- token permanente;
- `hub_uuid` confirmado;
- identificador do Hub na retaguarda;
- Empresa;
- Loja.

O `hub_uuid` retornado deve ser igual ao `hub_uuid` local.

Reativação normal deve reutilizar o mesmo `hub_uuid` local.

Reativação rotaciona o token.

---

## Token e Segurança

No Sysvar central, o token do Hub é armazenado somente como hash.

No Sysvar Hub, a credencial original precisa estar disponível após reinicializações para autenticar chamadas futuras à retaguarda.

Estado atual do backend do Hub:

~~~text
HubConfig.retaguarda_token
→ persistência local no MySQL do Hub
~~~

Cuidados obrigatórios:

- não expor token em `__str__`;
- não retornar token em API local;
- não registrar token em logs;
- não imprimir token em commands;
- não incluir token em exceções;
- não versionar credenciais;
- manter caminho aberto para armazenamento protegido ou criptografado no futuro sem alterar o contrato externo.

Separação de credenciais:

- `HubConfig.retaguarda_token` é usado somente no fluxo Hub → Sysvar Central;
- Terminal possui credencial própria para falar com o Sysvar Hub na LAN;
- Hub token e Terminal token são credenciais totalmente separadas;
- Terminal nunca conhece, recebe, consulta ou serializa `HubConfig.retaguarda_token`;
- Terminal não fala diretamente com o Sysvar Central.

---

## Heartbeat

O heartbeat é uma comunicação autenticada do Hub para o Sysvar central.

Ele utiliza:

~~~text
POST /api/hub/heartbeat/
Authorization: Hub <TOKEN>
~~~

Payload atual:

- hostname;
- versão.

Objetivo:

- manter status da instalação;
- registrar última comunicação;
- atualizar metadados operacionais do Hub.

No Hub, `ultimo_heartbeat_em` não deve ser confundido com `ultima_sincronizacao_em`.

Heartbeat não implementa sincronização de cadastros ou vendas.

---

## Bootstrap Inicial

Decisão vigente em 2026-09-11:

- a Loja já existe no Sysvar Central;
- a Loja continua cadastrada somente no Sysvar Central;
- o Hub não possui cadastro independente de Loja na retaguarda;
- o Hub não possui cadastro local independente de Loja;
- `HubConfig` guarda apenas identidade/cache local da Empresa e Loja canônicas;
- o Hub não escolhe `loja_id` ou `empresa_id` por parâmetro;
- a Loja da requisição é sempre `request.sysvar_hub.loja`;
- a Empresa da requisição é sempre `request.sysvar_hub.loja.empresa`;
- parâmetros enviados pelo cliente não alteram o escopo multi-tenant.

Contrato inicial:

~~~text
GET /api/hub/bootstrap/
Authorization: Hub <TOKEN>
~~~

Resposta versão 1 contém somente:

- identificação do Hub;
- Empresa existente;
- Loja existente;
- caixas ativos e operacionais da Loja.

O Hub suporta bootstrap versão 1.

Antes de persistir qualquer dado, o Hub valida:

- `hub.hub_uuid` igual ao `HubConfig.hub_uuid`;
- `hub.id` igual ao `HubConfig.retaguarda_hub_id`;
- `empresa.id` igual ao `HubConfig.empresa_id`;
- `loja.id` igual ao `HubConfig.loja_id`;
- `caixas` como lista.

Essa validação impede troca silenciosa de Loja, Empresa ou Hub depois da ativação.

Ainda não fazem parte deste bootstrap:

- usuários;
- clientes;
- estoque;
- vendas;
- formas de pagamento;
- sincronização incremental;
- terminais locais;
- filas;
- Celery.

Regra de caixas:

- usar `financeiro.Caixa`;
- filtrar por `idloja` da Loja vinculada ao Hub autenticado;
- retornar apenas caixas `ativo=True`;
- retornar apenas caixas `tipo_caixa=Caixa.TIPO_LOJA`;
- não retornar caixa `MASTER`;
- não retornar saldos, conta contábil ou outros dados financeiros.

Distinção conceitual:

- Caixa é cadastro operacional/financeiro existente no Sysvar Central;
- Terminal é estação física/local administrada pelo Sysvar Hub;
- `Terminal.caixa_retaguarda_id` será usado futuramente para vincular um Terminal local ao `Idcaixa` recebido no bootstrap.
- Terminal e Caixa continuam conceitos distintos no Hub.

Decisão de gerenciamento local de Terminais em 2026-09-11:

- Terminal representa uma estação física local, como `PDV-01`, `PDV-02` ou `BALCAO-01`;
- Terminal pertence ao Hub da Loja e é administrado localmente;
- Terminal não é cadastro mestre do Sysvar Central;
- código de Terminal é único por Hub;
- Terminal mantém `caixa_retaguarda_id` como referência ao caixa canônico da retaguarda;
- o vínculo com caixa é validado contra `CaixaHub` do mesmo Hub;
- Terminal pode ser criado inicialmente sem Caixa;
- Caixa inativo não pode receber novo vínculo;
- Terminal não é apagado automaticamente; desativação preserva histórico, UUID e vínculo;
- ainda não foi imposta exclusividade 1 Terminal ↔ 1 Caixa;
- Terminal possui credencial própria armazenada somente como hash;
- pareamento de Terminal é temporário, de uso único e expira em 15 minutos;
- repareamento rotaciona o token do Terminal e invalida imediatamente o token anterior;
- Terminal inativo perde acesso imediatamente ao Hub local;
- próximo passo será homologar o pareamento real do `PDV-01`.

Endpoints locais de Terminal:

~~~text
POST /api/terminal/parear/
GET  /api/terminal/contexto/
POST /api/terminal/heartbeat/
~~~

Autenticação de Terminal:

~~~text
Authorization: Terminal <TOKEN>
~~~

O endpoint de pareamento troca código temporário por token do Terminal. O código puro aparece apenas no command local que o gera e o token puro aparece apenas na resposta de pareamento bem-sucedida.

Implementação local:

- `CaixaHub` é cópia operacional local dos caixas da retaguarda para funcionamento offline;
- unicidade por Hub + caixa canônico da retaguarda;
- caixas que deixam de vir no bootstrap não são apagados;
- caixas ausentes são mantidos localmente com `ativo=False`;
- saldos, conta contábil e dados financeiros não são copiados no bootstrap.

---

## Estado Atual do Desenvolvimento

Em 2026-09-11, o backend do Sysvar Hub possui implementação local inicial para:

- configuração local `HubConfig` com `hub_uuid` preservado;
- Empresa e Loja opcionais antes da ativação;
- armazenamento local dos dados retornados pela ativação;
- cache local em `HubConfig` para `loja_apelido`, `loja_cnpj`, `loja_estado` e `bootstrap_versao`;
- cópia operacional local de caixas em `CaixaHub`;
- fonte única de versão em `sysvarhub/version.py`;
- cliente HTTP `RetaguardaClient` usando biblioteca padrão do Python;
- command `ativar_hub`;
- command `heartbeat_hub`;
- command `sincronizar_bootstrap_hub`;
- serviço local `core.services.terminais` para configurar e desativar Terminais;
- command `configurar_terminal`;
- command `listar_terminais`;
- command `desativar_terminal`;
- command `gerar_pareamento_terminal`;
- modelo `PareamentoTerminal` para código temporário de pareamento;
- autenticação DRF `TerminalTokenAuthentication`;
- endpoints locais de pareamento, contexto e heartbeat de Terminal;
- testes automatizados preparados para cobrir payloads, persistência, reativação, falhas e segurança de saída.

No Sysvar Central, em 2026-09-11, foi criado o endpoint `GET /api/hub/bootstrap/` para retornar Hub, Empresa, Loja e caixas ativos operacionais da Loja autenticada.

Validação técnica registrada no desenvolvimento:

- `manage.py makemigrations --check` passou com `No changes detected`;
- `manage.py migrate` foi executado no banco local oficial do Hub;
- `core.0004_hubconfig_bootstrap_caixahub` foi aplicada na etapa de bootstrap;
- `core.0005_alter_terminal_codigo_and_more` foi aplicada na etapa de Terminais locais;
- `core.0006_terminal_pareado_em_terminal_token_hash_and_more` foi aplicada na etapa de pareamento e autenticação de Terminais;
- `manage.py check` passou;
- validações funcionais controladas via Django shell passaram;
- a suíte Django não foi executada por decisão arquitetural: não usar banco de teste separado neste momento e não usar o banco oficial no test runner.

---

## Banco Local e Validação

Decisão arquitetural vigente em 2026-09-11:

- desenvolvimento e homologação local do Sysvar Hub usam o banco oficial `sysvarhub_db`;
- banco de teste separado, como `test_sysvarhub_db`, não será criado neste momento;
- o test runner do Django não deve apontar para `sysvarhub_db`, pois pode criar, apagar ou alterar dados de forma incompatível com a homologação local;
- testes automatizados permanecem no código para uso futuro, quando uma estratégia de banco de teste for definida;
- neste estágio, a validação aceita é composta por `makemigrations --check`, `migrate`, `showmigrations`, `manage.py check` e verificações funcionais controladas/mockadas;
- instalações em cliente começam com banco vazio e recebem a estrutura por migrations.

---

## Catálogo Operacional V1

Decisão vigente em 2026-09-12:

~~~text
GET /api/hub/catalogo/
Authorization: Hub <TOKEN>
~~~

Este endpoint pertence exclusivamente à integração Sysvar Central -> Sysvar Hub da Loja autenticada. O PDV não acessa o endpoint central diretamente.

Escopo obrigatório:

- Hub autenticado por `HubTokenAuthentication`;
- Loja sempre derivada de `request.sysvar_hub.loja`;
- Empresa sempre derivada de `request.sysvar_hub.loja.empresa`;
- parâmetros como `loja_id`, `empresa_id`, `hub_id`, `loja` ou `empresa` não alteram o escopo.

Contrato e regras da versão 1:

- `catalogo_versao = 1`;
- snapshot completo, sem paginação e sem incremental neste passo;
- produtos operacionais de venda: `Produto.tipo_produto` em `1` ou `3`, produto ativo, produto não bloqueado, SKU ativo e SKU não bloqueado;
- tabela de preço da V1 é a tabela canônica `Tabela Padrão`, com código lógico `PADRAO` no contrato, centralizada no backend para futura parametrização por Loja;
- no Sysvar Central, a tabela canônica atual usa `NomeTabela = Tabela Padrão`; nenhuma nova tabela foi criada para este ajuste;
- a `Tabela Padrão` deve pertencer à Empresa do Hub; se não existir, o endpoint retorna catálogo com `tabela_preco = null`;
- preço continua por Produto via `Tabelapreco` e `TabelaprecoProduto`, respeitando ativo e validade existentes;
- não existe fallback de preço inventado;
- SKU sem preço continua no catálogo, mas `vendavel = false` e `motivos_bloqueio` contém `SEM_PRECO`;
- estoque é exclusivo da Loja do Hub, usando `Estoque.Idloja = request.sysvar_hub.loja` e `Estoque.CodigodeBarra = sku.ean13`;
- `estoque_disponivel = estoque_fisico - reserva`;
- SKU sem estoque ou sem registro de estoque continua no catálogo, mas `vendavel = false` e `motivos_bloqueio` contém `SEM_ESTOQUE`;
- identidade do item enviada como `sku_id` e `ean13`; SKU sem EAN não quebra o snapshot e mantém `sku_id`;
- imagem fica fora da V1;
- campos fiscais vêm do `Produto` e são snapshot de parâmetros, sem cálculo de imposto.

Implementação no Sysvar Hub em 2026-09-12:

- `RetaguardaClient.catalogo(token=...)` consome `GET /api/hub/catalogo/` com `Authorization: Hub <TOKEN>`;
- `CatalogoItemHub` é a cópia operacional local denormalizada por SKU;
- 1 linha local representa 1 SKU operacional da Loja;
- o Hub não recria cadastros mestres de Produto, Cor, Tamanho, Unidade, Empresa, Loja ou Tabela de Preço;
- `sku_id` do Central é a identidade técnica da sincronização local (`hub + retaguarda_sku_id`);
- EAN é índice de busca operacional futura, não chave primária de sincronização, e não é único;
- o snapshot é completo;
- ausência de SKU no snapshot novo inativa o item localmente (`ativo=False`) e não deleta;
- `ativo` significa presença no último snapshot recebido;
- `vendavel` significa condição operacional de venda no momento do snapshot;
- SKU sem preço continua ativo no catálogo quando veio no snapshot, mas fica não vendável com `SEM_PRECO`;
- SKU sem estoque continua ativo no catálogo quando veio no snapshot, mas fica não vendável com `SEM_ESTOQUE`;
- estado da sincronização fica em `HubConfig.catalogo_versao`, `catalogo_gerado_em`, `catalogo_sincronizado_em` e metadados de tabela de preço;
- persistência ocorre em transação após validação integral do contrato;
- comando local: `python manage.py sincronizar_catalogo_hub`.
- após o alinhamento do contrato do Hub para aceitar `codigo = PADRAO`, os 1480 itens locais existentes serão atualizados pelo `update_or_create` no próximo snapshot real, sem apagar os registros atuais.

API local de consulta para Terminal/PDV:

- endpoint local: `GET /api/terminal/catalogo/`;
- autenticação: `Authorization: Terminal <TOKEN>`, usando a credencial própria do Terminal;
- escopo derivado exclusivamente de `request.sysvar_terminal.hub`;
- parâmetros como `hub_id`, `loja_id`, `empresa_id` ou `terminal_id` não alteram o escopo;
- consulta somente `CatalogoItemHub` local com `hub = Terminal.hub` e `ativo = true`;
- não depende de internet, Sysvar Central, Redis ou serviço externo;
- busca por EAN, referência, código do item, descrição e descrição reduzida;
- cor e tamanho também podem participar da busca textual;
- itens não vendáveis continuam pesquisáveis, inclusive produtos sem estoque com `motivos_bloqueio = ["SEM_ESTOQUE"]`;
- resposta inclui preço, estoque, condição de venda, motivos de bloqueio, dados fiscais e metadados da tabela `PADRAO / Tabela Padrão`;
- esta API passa a ser a fonte local de consulta de produtos para o PDV.

Próxima etapa após homologação real:

- integrar o frontend/PDV existente ao endpoint local `GET /api/terminal/catalogo/`.
---

## Formas de Pagamento - Snapshot Central V1

Atualização registrada em 2026-09-14 no Sysvar Central:

~~~text
GET /api/hub/formas-pagamento/
Authorization: Hub <TOKEN>
~~~

- o Sysvar Central continua sendo a autoridade das Formas de Pagamento;
- o endpoint retorna snapshot completo por Empresa, com escopo derivado exclusivamente de `request.sysvar_hub.loja.empresa`;
- a Loja do snapshot é derivada exclusivamente de `request.sysvar_hub.loja`;
- query params ou body como `empresa_id` e `loja_id` não alteram o escopo;
- entram formas ativas e inativas da Empresa, para permitir que o Hub marque localmente formas desativadas no Central;
- formas com `empresa = null` não entram no contrato operacional do Hub;
- o payload inclui FormaPagamento, prazo_pagamento opcional, parcelas, campos TEF configuracionais e apenas o ID Central da conta de liquidação;
- valores financeiros e percentuais são serializados como string decimal, sem float;
- o Hub futuramente manterá cópia operacional offline das formas de pagamento;
- pagamentos, finalização, TEF e sincronização de vendas ainda não foram implementados nesta etapa.

Próxima etapa em repositório separado:

- consumir o snapshot no `FernandoMurashima/sysvarhub-backend` e persistir/sincronizar `FormaPagamentoHub` local.

---
## Operadores PDV - Snapshot Central V1

Atualização registrada em 2026-09-13 no Sysvar Central:

- operador de PDV continua sendo `accounts.User`; não existe cadastro mestre paralelo de Operador;
- a credencial de PDV é extensão 1:1 do usuário central em `accounts.CredencialPdvUsuario`;
- a senha de PDV é independente da senha principal do ERP e nunca copia `User.password`;
- a senha de PDV é armazenada somente como hash Django, gerado por `make_password` e validável por `check_password`;
- o endpoint administrativo fica em `GET/PUT/DELETE /api/accounts/users/{id}/credencial-pdv/` e reutiliza `UserViewSet`, `CanManageCompanyUsers` e o escopo por Empresa do `get_queryset()`;
- respostas administrativas retornam apenas metadata segura: configurada, habilitada e atualizado_em;
- o `DELETE` remove a credencial, exigindo nova senha para reabilitar o operador;
- Auditoria registra o evento administrativo sem senha e sem hash.

Endpoint central para o Hub:

~~~text
GET /api/hub/operadores/
Authorization: Hub <TOKEN>
~~~

Contrato versão 1:

- `operadores_versao = 1`;
- snapshot completo da Loja do Hub autenticado;
- Empresa e Loja são derivadas exclusivamente de `request.sysvar_hub.loja` e `request.sysvar_hub.loja.empresa`;
- query params ou body como `empresa_id` e `loja_id` não alteram escopo;
- retorna apenas operadores elegíveis no momento da geração.

Critérios de elegibilidade:

1. `User.is_active = true`;
2. `User.empresa` igual à Empresa do Hub;
3. existência de `CredencialPdvUsuario.habilitado = true`;
4. acesso explícito à Loja por `user.loja` ou por `user.lojas`.

Admin, Diretor ou master da Empresa não recebem acesso automático a todas as lojas no PDV. Para aparecer no snapshot do Hub, o acesso à Loja precisa estar explícito.

Payload de cada operador:

~~~text
usuario_id
codigo
nome
tipo
perfil
credencial_hash
ativo
~~~

`credencial_hash` é sensível e só pode existir neste endpoint autenticado por `HubTokenAuthentication`. Não deve aparecer em `UserSerializer`, CRUD administrativo comum, logs, Auditoria, erros ou documentação com valor real.

Próxima etapa no Sysvar Hub:

- consumir `GET /api/hub/operadores/`;
- persistir cópia operacional local dos operadores elegíveis;
- marcar operadores ausentes do snapshot como inativos localmente;
- autenticar o operador offline com `check_password()` usando o hash recebido;
- manter separação entre credencial do Hub, credencial do Terminal e credencial PDV do Operador.
---

## Operadores Locais no Hub

Atualização registrada em 2026-09-13 no Sysvar Hub Backend:

- `OperadorHub` é cópia operacional local dos operadores elegíveis enviados pelo Sysvar Central;
- o Sysvar Central continua sendo a autoridade do usuário, perfil, acesso à Loja e credencial PDV;
- o Hub não possui cadastro mestre de operador;
- a credencial PDV é armazenada localmente apenas como hash Django recebido no snapshot, para validação offline com `check_password()`;
- o hash não deve ser retornado por API local, exibido em admin diagnóstico, impresso em commands, registrado em logs ou incluído em mensagens de erro;
- `GET /api/hub/operadores/` é consumido pelo Hub via `Authorization: Hub <TOKEN>`;
- o snapshot de operadores é completo;
- operadores ausentes no snapshot seguinte são inativados localmente e têm `credencial_hash` limpo, sem exclusão física;
- operador recebido com `ativo=false` também fica inativo localmente e perde hash operacional;
- alteração de `credencial_hash` indica redefinição de credencial no Central e revoga sessões locais ativas do operador;
- inativação, perda de elegibilidade ou ausência no snapshot também revoga sessões locais ativas;
- `SessaoOperadorHub` representa a sessão operacional local do operador no Terminal;
- login de operador funciona offline e nunca chama a retaguarda;
- sessão de operador é vinculada ao Terminal que realizou o login;
- um Terminal possui apenas uma sessão operacional ativa por vez; novo login encerra sessão anterior do mesmo Terminal com motivo `NOVO_LOGIN`;
- o mesmo operador pode usar outro Terminal simultaneamente nesta fase;
- o token puro da sessão é retornado uma única vez no login; o banco guarda somente SHA-256 e prefixo;
- endpoints locais criados: `POST /api/terminal/operador/login/`, `GET /api/terminal/operador/contexto/`, `POST /api/terminal/operador/logout/`;
- endpoints que exigem operador usam `Authorization: Terminal <TOKEN>` mais `X-Sysvar-Operador-Session: <TOKEN_DA_SESSAO>`;
- `TerminalOperadorAuthentication` popula `request.sysvar_terminal`, `request.sysvar_operador` e `request.sysvar_operador_sessao`;
- erro de credencial de operador usa HTTP 400 com mensagem genérica para não desparear Terminal no frontend atual.

Próxima etapa:

- integrar o Frontend Hub ao login/contexto/logout de operador;
- depois implementar abertura de Caixa no Hub.
---

## Sessão Local de Caixa no Hub

Atualização registrada em 2026-09-13 no Sysvar Hub Backend:

- `CaixaHub` continua sendo a cópia operacional local do Caixa canônico vindo do Sysvar Central; não foi criado cadastro paralelo de Caixa;
- `SessaoCaixaHub` representa o ciclo de vida operacional de abertura e fechamento do Caixa físico no Hub local;
- o Terminal determina o Caixa pela combinação `terminal.hub` + `terminal.caixa_retaguarda_id`, resolvendo o `CaixaHub` correspondente;
- endpoints locais criados: `GET /api/terminal/caixa/status/`, `POST /api/terminal/caixa/abrir/`, `POST /api/terminal/caixa/fechar/`;
- os endpoints de Caixa exigem `Authorization: Terminal <TOKEN>` e `X-Sysvar-Operador-Session: <TOKEN_DA_SESSAO>`;
- o frontend já está preparado para adicionar o header de operador em `/api/terminal/caixa/...`, mas o interceptor de Terminal ainda deverá ser ajustado na próxima etapa para não desparear Terminal se um endpoint de Caixa retornar `401/403` por sessão de operador inválida;
- o valor de abertura usa `Decimal`, aceita `0.00`, rejeita negativos, inválidos e mais de duas casas decimais, e é serializado como string monetária;
- um `CaixaHub` só pode ter uma sessão `ABERTO` por vez;
- a concorrência usa `transaction.atomic()` com `select_for_update()` sobre a linha do `CaixaHub` antes de consultar/criar sessão aberta;
- há proteção adicional de unicidade compatível com MySQL por meio de `chave_caixa_aberto` nullable e unique: preenchida com o id do Caixa enquanto a sessão está aberta e `NULL` após fechamento;
- MySQL permite múltiplos `NULL` no índice único, viabilizando histórico de sessões fechadas sem permitir duas sessões abertas do mesmo Caixa;
- abertura persiste no MySQL local e sobrevive a refresh, troca de operador e reinício do navegador;
- logout/troca de operador não fecha Caixa;
- a sessão de Caixa registra Terminal, Operador e Sessão de Operador de abertura;
- o fechamento registra Terminal, Operador e Sessão de Operador de fechamento;
- nesta primeira versão, qualquer `OperadorHub` ativo com sessão local válida pode fechar o Caixa; autorização gerencial fica para etapa futura;
- as respostas não expõem tokens, hashes, credenciais ou a chave técnica interna.

Próxima etapa:

- integrar no Frontend Hub a consulta de status e abertura de Caixa local.
---

## Venda Local e Carrinho Persistido no Hub

Atualização registrada em 2026-09-13 no Sysvar Hub Backend:

- foi criada a primeira fase de Venda Local/Carrinho Local no backend do Hub;
- `VendaHub` representa a venda operacional local em MySQL e não depende do Angular para preservar carrinho;
- `VendaItemHub` representa os itens do carrinho com snapshot do produto no momento da inclusão;
- `VendaEventoHub` registra auditoria operacional de criação, inclusão, alteração de quantidade, remoção e cancelamento;
- a venda aberta pertence a Hub, `SessaoCaixaHub` e Terminal;
- a venda não pertence exclusivamente à sessão atual do operador: troca de operador no mesmo Terminal recupera a mesma venda aberta;
- `operador_criacao` permanece o operador que criou a venda, enquanto eventos posteriores registram o operador atual;
- existe no máximo uma `VendaHub` `ABERTA` por Terminal, protegida por `chave_venda_aberta_terminal` nullable/unique;
- a criação da venda é sob demanda: `GET /api/terminal/venda/atual/` retorna `{"venda": null}` enquanto nenhum item válido foi adicionado;
- a primeira inclusão válida cria a `VendaHub` e o item na mesma transação;
- endpoints locais criados:
  - `GET /api/terminal/venda/atual/`;
  - `POST /api/terminal/venda/item/`;
  - `PATCH /api/terminal/venda/item/<item_uuid>/`;
  - `DELETE /api/terminal/venda/item/<item_uuid>/`;
  - `POST /api/terminal/venda/cancelar/`;
- todos exigem `Authorization: Terminal <TOKEN>` e `X-Sysvar-Operador-Session`;
- nenhuma operação de venda chama o Sysvar Central;
- Caixa aberto é obrigatório: a sessão de Caixa é resolvida exclusivamente pelo Terminal autenticado e pelo `CaixaHub` associado;
- o frontend não envia e o backend não aceita preço, subtotal, total, caixa, terminal ou operador como fonte de verdade;
- o preço aplicado vem de `CatalogoItemHub.preco_venda`;
- valores monetários são calculados com `Decimal` no backend, arredondados em dinheiro com `ROUND_HALF_UP` e serializados como string;
- ao incluir item, o Hub copia para `VendaItemHub` produto, SKU, EAN, referência, código item, descrição, cor, tamanho, unidade e preço aplicado;
- esse snapshot garante que a venda preserve o contexto mesmo que o catálogo ou preço mude depois;
- uma venda possui no máximo uma linha por SKU; nova bipagem incrementa quantidade;
- a reserva local é derivada das quantidades em `VendaItemHub` de todas as `VendaHub` `ABERTA` do mesmo Hub;
- ao validar incremento de quantidade, a disponibilidade local inclui a própria venda atual nas reservas já tomadas; valida-se apenas o delta contra `estoque_disponivel - reservas_abertas_totais`;
- dois Terminais compartilham a mesma disponibilidade local do SKU;
- a inclusão/alteração bloqueia `CatalogoItemHub` com `select_for_update()` antes de recalcular reserva;
- o carrinho não altera `CatalogoItemHub.estoque_fisico`, `CatalogoItemHub.reserva` ou `CatalogoItemHub.estoque_disponivel`;
- redução, remoção e cancelamento liberam reserva automaticamente porque a reserva é calculada a partir das vendas abertas;
- venda cancelada mantém itens e histórico, mas deixa de contar na reserva;
- o fechamento de Caixa (`POST /api/terminal/caixa/fechar/`) agora bloqueia se existir `VendaHub` `ABERTA` vinculada à `SessaoCaixaHub`, retornando conflito controlado;
- a migration `core.0010_vendahub_vendaeventohub_vendaitemhub_and_more` cria as tabelas de venda, item e evento sem alterar a sessão real de Caixa aberta.

Próxima etapa:

- integrar o Frontend Hub ao carrinho local: consultar venda atual, adicionar item ao bipar, alterar/remover item, cancelar venda e refletir totais persistidos no MySQL.

---

## Frontend Operacional do Hub

### Migração estruturada do PDV - Fase 1

Atualização registrada em 2026-09-13:

- o Frontend Hub iniciou a migração do PDV real do Sysvar Central para a rota `/pdv`;
- HTML e CSS do `pdv-desktop` do Sysvar Central foram usados como base visual direta, preservando topbar, busca, painéis, atalhos, área de itens, produto selecionado e rodapé;
- a camada antiga do Central não foi portada: não há imports de services administrativos, Electron, fila offline antiga ou conectividade com Sysvar Central;
- os dados do PDV Hub vêm do contexto do Terminal e do catálogo local via `/api/terminal/catalogo/`;
- foi criada a `PdvHubFacade` para centralizar contexto, busca no catálogo e mapeamento de `CatalogoItem` para modelo próprio do PDV;
- o modelo `PdvProdutoConsulta` usa `skuId` como identidade canônica futura da venda e preserva preços como `DecimalString | null` e estoques como strings decimais;
- a busca do PDV usa debounce de 250 ms e limite 40, consultando somente o Hub local;
- ENTER/EAN seleciona produto quando há correspondência exata única por EAN, referência ou código do item;
- nesta fase o produto selecionado aparece no painel direito, mas não entra em carrinho operacional;
- itens não vendáveis continuam visíveis para consulta, incluindo `SEM_ESTOQUE` e `SEM_PRECO`;
- não há fallback de preço: preço nulo aparece como indisponível;
- operador e vendedor permanecem neutros/readonly até migração dos domínios correspondentes;
- atalhos F2-F10 permanecem visíveis; apenas consulta de preço usa catálogo Hub nesta fase;
- recursos não integrados exibem mensagem controlada e não chamam APIs inexistentes;
- rodapé/status passa a representar Hub Local, Terminal, Loja, Caixa e metadados do catálogo.

### Sessão de Operador no Frontend Hub

Atualização registrada em 2026-09-13:

- o Frontend Hub possui sessão própria de operador, independente da sessão/credencial do Terminal;
- o token do Terminal continua em `TerminalCredentialStore` e é enviado como `Authorization: Terminal <TOKEN>`;
- o token da sessão de operador fica em `OperatorSessionStore`, implementado por `BrowserOperatorSessionStore` com `sessionStorage`;
- chave do storage do operador: `sysvar.hub.operator.session`;
- senha/credencial do operador nunca é armazenada no browser;
- dados completos do operador não são persistidos; a identidade oficial é restaurada por `GET /api/terminal/operador/contexto/`;
- endpoints locais usados pelo frontend: `POST /api/terminal/operador/login/`, `GET /api/terminal/operador/contexto/`, `POST /api/terminal/operador/logout/`;
- endpoints autenticados por operador usam o header `X-Sysvar-Operador-Session`;
- `operatorSessionInterceptor` adiciona `X-Sysvar-Operador-Session` em contexto/logout de operador e já fica preparado para rotas futuras de caixa/venda;
- o interceptor de Terminal continua enviando `Authorization: Terminal` no login, contexto e logout de operador, mas não remove pareamento por `401/403` em contexto/logout de operador;
- `/operador` é rota protegida por `terminalSessionGuard`, exigindo Terminal pareado mas não operador autenticado;
- `/pdv` usa `canActivate` em ordem: `terminalSessionGuard`, depois `operatorSessionGuard`;
- `/suporte` permanece protegido somente por `terminalSessionGuard` e não exige operador;
- `OperatorSessionService` mantém estado com `signals`: inicializando, não autenticado, autenticado e erro;
- refresh com token de operador em `sessionStorage` chama `/api/terminal/operador/contexto/` e restaura operador/sessão antes de liberar o PDV;
- sessão de operador revogada limpa somente `OperatorSessionStore`, redireciona para `/operador` e preserva o pareamento do Terminal;
- erro de comunicação local não inventa usuário e não apaga Terminal;
- a tela `/operador` exibe contexto local de Empresa/Sysvar, PDV, Loja, Caixa e Terminal;
- login de operador chama somente o Hub local em `/api/terminal/operador/login/` e é homologável com o Sysvar Central desligado;
- credencial inválida mostra mensagem genérica: `Operador ou credencial inválidos.`;
- após login, o PDV exibe o operador real vindo do estado restaurado/contexto, atualmente homologável com `Juliana Rocha`;
- a ação `Trocar operador` chama logout de operador, limpa a sessão operacional local e volta para `/operador`, sem apagar token do Terminal e sem navegar para `/pareamento`;
- esta etapa não implementa abertura/fechamento de caixa, carrinho, venda, pagamentos, sangria, suprimento ou autorização gerencial.

Próxima etapa do PDV Hub:

- integrar Carrinho/Venda local ou fechamento de Caixa, conforme decisão funcional da próxima etapa.

### Abertura de Caixa Local no Frontend Hub

Atualização registrada em 2026-09-13:

- o Frontend Hub passou a consultar o estado do Caixa local ao entrar no PDV usando `GET /api/terminal/caixa/status/`;
- foi criado o módulo `features/caixa` no Angular, com `HubCaixaService`, `CaixaSessionService` e parser dedicado de valor de abertura;
- o contrato TypeScript de Caixa fica em `core/models/caixa.models.ts` e converte `snake_case` da API local para `camelCase` sem converter valores monetários para `number`;
- `valor_abertura` permanece string monetária/decimal no frontend, alinhado ao `Decimal` do backend;
- o estado de Caixa do frontend vive em `signals` em memória e é restaurado pela consulta ao Hub local; não há persistência de sessão de Caixa em `localStorage` ou `sessionStorage`;
- refresh da página, troca de operador e reinício do navegador não fecham Caixa, pois a autoridade do estado é o MySQL local do Hub;
- quando o Caixa está fechado, o PDV exibe modal bloqueante de abertura, sem botão de fechar, contendo Loja, Caixa, Terminal e Operador;
- abertura usa `POST /api/terminal/caixa/abrir/` com `Authorization: Terminal <TOKEN>` e `X-Sysvar-Operador-Session`;
- o frontend valida valores vazios, negativos, notação científica, mais de duas casas e valores acima do limite antes de chamar o Hub;
- retorno `201` abre a sessão no estado local da tela;
- retorno `409` com sessão aberta é tratado como recuperação idempotente: o frontend assume a sessão aberta retornada pelo Hub;
- retorno `400` mostra a mensagem operacional do backend e não limpa a sessão de operador;
- retorno `401/403` em endpoint de Caixa invalida somente a sessão de operador e preserva o pareamento do Terminal;
- o `terminalAuthInterceptor` foi ajustado para não desparear Terminal quando `/api/terminal/caixa/...` retornar erro operacional de autenticação/autorização;
- o `operatorSessionInterceptor` envia a sessão de operador também nos endpoints de Caixa;
- o status visual do PDV mostra `CAIXA ABERTO`, `CAIXA FECHADO`, consulta em andamento ou falha de consulta;
- com Caixa aberto, o PDV mostra data/hora de abertura e fundo inicial;
- F10 continua apenas como atalho visual/pendente de fechamento e não chama endpoint de fechamento;
- `HubCaixaService.fechar()` existe para contrato futuro, mas o PDV ainda não aciona fechamento nesta etapa;
- a etapa foi coberta por testes unitários de modelos, parser, service HTTP, sessão de Caixa, interceptors e integração visual/comportamental no `PdvPageComponent`.

Próxima etapa do PDV Hub:

- integrar pagamentos/finalização ou implementar Fechamento de Caixa, conforme decisão de produto.

### Carrinho Local Persistido no Frontend Hub

Atualização registrada em 2026-09-13:

- o Frontend Hub passou a usar `VendaHub`/`VendaItemHub` do backend local como autoridade do carrinho;
- o carrinho não usa `localStorage`, `sessionStorage` ou `IndexedDB`;
- `VendaSessionService` mantém apenas estado reativo em memória e reconstrói a tela por `GET /api/terminal/venda/atual/`;
- o bootstrap do PDV consulta venda atual somente depois de confirmar Caixa aberto;
- sem venda no Hub, o PDV mostra `Venda ainda não iniciada`;
- a primeira bipagem/ENTER exato de produto vendável chama `POST /api/terminal/venda/item/` e deixa o backend criar a venda sob demanda;
- a tabela central de itens renderiza o snapshot serializado de `VendaItemHub`, não o catálogo;
- incremento e redução de quantidade usam `PATCH /api/terminal/venda/item/<uuid>/`;
- remoção de item usa `DELETE /api/terminal/venda/item/<uuid>/`;
- F5 remove o item selecionado via backend;
- F6 cancela a `VendaHub` via `POST /api/terminal/venda/cancelar/`;
- refresh recupera a venda aberta e seus totais pelo Hub local;
- troca de operador não cancela a venda; novo operador recupera a mesma venda do Terminal;
- 401/403 em `/api/terminal/venda/...` invalida apenas a sessão do operador e preserva o pareamento do Terminal;
- saldo insuficiente exibe a disponibilidade local retornada pelo backend e não altera o carrinho em memória;
- erro de rede em operação de venda preserva a venda atual e tenta recarregar `GET /venda/atual/`;
- totais do PDV vêm exclusivamente da `VendaHub`;
- pagamentos, finalização, NFC-e, TEF e fechamento operacional de Caixa continuam pendentes.

Próxima etapa do PDV Hub:

- integrar pagamento/finalização local da venda ou fechamento de Caixa, sem perder a autoridade do Hub local sobre estado operacional.

Funcionalidades pendentes do PDV e domínios necessários:

- abertura/fechamento de caixa: domínio de caixa local do Hub e movimentações financeiras locais;
- vendedor: domínio de usuários/funcionários sincronizados ou credencial operacional local;
- cliente: sincronização/consulta local de clientes;
- carrinho e venda: sessão de venda local, estoque reservado e persistência MySQL Hub;
- pagamentos: contratos locais de formas de pagamento e baixa financeira;
- fiscal/NFC-e: integração fiscal própria do Hub ou estratégia de contingência;
- sangria/suprimento/despesa: movimentações de caixa locais;
- vale-troca: contrato local de vales e saldos;
- sincronização de venda: fila Hub -> Central e resolução de conflitos;
- relatórios/reimpressão: histórico local de vendas e documentos fiscais.

### Alinhamento de contratos do Frontend Hub

Complemento registrado em 2026-09-13:

- `POST /api/terminal/parear/` retorna Terminal resumido, contendo somente `uuid`, `codigo` e `nome`;
- `GET /api/terminal/contexto/` retorna Terminal completo, incluindo `hostname` e `ativo`;
- no contrato local de catálogo, `tabela_preco` é objeto com `codigo` e `nome`, atualmente `PADRAO / Tabela Padrão`;
- preços do catálogo podem ser `null` quando o item está sem preço, preservando `vendavel = false` e `motivos_bloqueio = ["SEM_PRECO"]`;
- `cor`, `tamanho` e `unidade` são objetos sempre presentes na API local, mesmo quando IDs internos forem nulos;
- a tela `/suporte` deve exibir `-` quando `preco_venda` vier `null`.

Correção registrada em 2026-09-13:

- o pareamento real do Terminal usa `POST /api/terminal/parear/` com body `{ "codigo": "...", "hostname": "..." }`;
- o frontend não deve enviar `codigo_pareamento` para o backend;
- a resposta real do pareamento vem em nível principal com `token`, `terminal`, `caixa`, `loja` e `empresa`, sem wrapper `contexto`;
- após parear, o frontend persiste o token via `TerminalCredentialStore` e carrega `GET /api/terminal/contexto/` para obter o contexto operacional definitivo antes de navegar para `/pdv`;
- o contexto real contém `terminal.uuid`, `terminal.codigo`, `terminal.nome`, `terminal.hostname`, `terminal.ativo`, `caixa` opcional, `loja.nome`, `loja.apelido`, `loja.estado` e `empresa.nome`;
- o heartbeat real usa `POST /api/terminal/heartbeat/` com body `{ "hostname": "..." }` e resposta `{ "status": "ok", "terminal_uuid": "...", "servidor_em": "..." }`;
- o bootstrap da sessão deve revalidar a existência da credencial antes de reaproveitar contexto em memória, pois o interceptor pode remover o token em `401` ou `403`.

Decisão vigente em 2026-09-13:

- o frontend do Hub é uma aplicação operacional local da loja, não uma cópia do ERP administrativo do Sysvar Central;
- o frontend é servido pelo próprio Sysvar Hub e acessado pelos Terminais/PDVs pela LAN;
- em produção, frontend e API operam em same origin;
- a base lógica da API no cliente é sempre `/api`;
- serviços Angular chamam rotas relativas como `/api/terminal/contexto/`, `/api/terminal/heartbeat/`, `/api/terminal/catalogo/` e `/api/terminal/parear/`;
- não há `127.0.0.1`, IP fixo ou host de produção espalhado no código Angular;
- em desenvolvimento, `proxy.conf.json` encaminha `/api` para `http://127.0.0.1:8100`;
- produção não depende do proxy de desenvolvimento e não deve depender de CORS para a operação normal;
- depois de carregado pelo Hub, o frontend deve depender somente do Hub local para sessão, contexto, catálogo e futuro PDV.

Stack criada:

- Angular 17.3;
- TypeScript 5.4;
- RxJS 7.8;
- aplicação standalone;
- testes unitários com Karma/Jasmine.

Fluxo operacional inicial:

- rota inicial verifica sessão do Terminal;
- sem credencial válida, redireciona para `/pareamento`;
- com sessão válida, redireciona para `/pdv`;
- `/pareamento` é rota definitiva para vincular um novo Terminal ao Hub;
- `POST /api/terminal/parear/` recebe código de pareamento e hostname/nome do equipamento;
- em caso de sucesso, o token do Terminal é armazenado pela abstração de credencial e a aplicação carrega o contexto local;
- `/pdv` é a rota operacional protegida e, neste momento, contém apenas placeholder limpo com Loja, Caixa e Terminal;
- `/suporte` é uma área operacional protegida para diagnóstico local sem exibir segredos.

Segurança e sessão:

- `TerminalCredentialStore` abstrai a credencial do Terminal;
- implementação inicial: `BrowserTerminalCredentialStore`, usando `localStorage` internamente;
- chave local: `sysvar.hub.terminal.token`;
- componentes e services não acessam `localStorage` diretamente;
- token não deve ser exibido na tela, logado, documentado, colocado em environment ou versionado;
- `TerminalSessionService` mantém o estado operacional: inicializando, não pareado, pareado, contexto carregado e erro;
- o contexto mantido em memória contém Terminal, Caixa, Loja e Empresa;
- credencial inválida limpa o armazenamento e permite retorno controlado para `/pareamento`;
- `terminalSessionGuard` protege rotas operacionais;
- interceptor HTTP adiciona `Authorization: Terminal <TOKEN>` somente em rotas autenticadas de `/api/terminal/`, excluindo `/api/terminal/parear/` e URLs externas.

Catálogo local no frontend:

- `HubCatalogoService.buscar(q?, limit?)` consulta `GET /api/terminal/catalogo/`;
- o contrato TypeScript preserva preços e quantidades como strings decimais;
- o frontend não presume que item pesquisável seja vendável;
- `vendavel` e `motivos_bloqueio` fazem parte do contrato e devem ser respeitados na futura migração do PDV;
- `/suporte` permite pesquisar o catálogo e mostra referência, descrição, EAN, cor, tamanho, preço de venda, estoque disponível, vendável e motivos de bloqueio;
- `/suporte` não mostra token, hash ou segredos.

Decisão para migração do PDV:

- o `PdvDesktopComponent` real do Sysvar Central será migrado em etapa posterior;
- a migração deve criar uma camada operacional `PdvHubFacade` ou gateways locais equivalentes;
- o PDV final não deve ficar diretamente acoplado a dezenas de services administrativos do Sysvar Central;
- dependências antigas como `ProdutosService`, `ProdutoDetalheService`, `LojasService`, `CaixasService`, `ClientesService`, `FuncionariosService`, `VendaPdvService`, `PdvOfflineCatalogService`, `PdvOfflineQueueService`, `PdvLocalCaixaService`, `ElectronBridgeService`, `PdvConnectivityService`, `TipoDespesaPdvService`, `MovimentacoesFinanceirasService`, `PdvLocalAuditoriaService` e `ValeTrocaService` devem ser analisadas uma a uma antes de qualquer reaproveitamento;
- não adicionar Electron, SQLite ou IndexedDB de catálogo nesta fase, pois o catálogo operacional já reside no MySQL local do Hub.

---


## Formas de Pagamento no Hub Backend

Atualização registrada em 2026-09-14 no Sysvar Hub Backend:

~~~text
GET /api/hub/formas-pagamento/
Authorization: Hub <TOKEN>
~~~

- o Sysvar Central continua sendo a autoridade das Formas de Pagamento;
- o Hub agora mantém `FormaPagamentoHub` como cópia operacional local;
- o Hub agora mantém `FormaPagamentoParcelaHub` como parametrização local atual das parcelas;
- o endpoint Central `/api/hub/formas-pagamento/` é consumido pelo `RetaguardaClient` do Hub;
- o contrato é snapshot completo da Empresa/Loja do Hub autenticado;
- antes de persistir, o Hub valida identidade de Hub, `hub_uuid`, Empresa e Loja contra `HubConfig` local;
- formas ausentes no snapshot novo são inativadas localmente, não apagadas;
- formas inativas recebidas continuam persistidas localmente com `ativo = false`;
- parcelas refletem a parametrização atual do snapshot e parcelas ausentes são removidas;
- valores decimais financeiros são aceitos somente como string decimal com escala contratada;
- pagamentos, finalização de venda, TEF real, PIX real, NFC-e e sincronização de vendas Hub -> Central ainda não foram implementados nesta etapa.
---


## Pagamento e Finalização Local da Venda

Atualização registrada em 2026-09-14 no Sysvar Hub Backend:

- `VendaPagamentoHub` registra pagamentos locais da `VendaHub` com snapshot da Forma de Pagamento usada;
- `VendaPagamentoParcelaHub` copia as parcelas de `FormaPagamentoParcelaHub` no momento da inclusão do pagamento;
- uma venda pode ter múltiplos pagamentos ativos;
- pagamento em dinheiro pode exceder o total e gerar troco;
- formas TEF ficam bloqueadas para captura manual nesta fase, pois TEF real ainda não foi integrado;
- `EstoqueMovimentoHub` registra a baixa local definitiva da venda finalizada;
- `CatalogoItemHub.estoque_fisico` e `CatalogoItemHub.estoque_disponivel` continuam fotografia do último snapshot Central e não são decrementados diretamente;
- saldo local operacional passa a ser: snapshot disponível menos movimentos locais não reconciliados menos reservas de vendas abertas;
- a finalização da venda é atômica, cria movimentos de estoque e registra auditoria sem depender do Sysvar Central;
- venda finalizada ainda não é enviada ao Central nesta etapa;
- NFC-e, TEF real, PIX automático, recebíveis e sincronização Hub -> Central continuam fases futuras.
---


## Pagamentos no Frontend Hub

Atualização registrada em 2026-09-14 no Frontend do Sysvar Hub:

- F9 passou a abrir o fluxo operacional de pagamentos da VendaHub;
- formas de pagamento são carregadas do Hub local por `/api/terminal/formas-pagamento/` com sessão de operador;
- o PDV suporta múltiplos pagamentos ativos, remoção lógica de pagamento, total pago, pendente e troco vindos do Backend;
- botões DINHEIRO, CARTÃO, PIX e OUTRAS usam categorias dinâmicas das formas sincronizadas, sem hardcodear cadastros;
- a finalização local da venda usa `/api/terminal/venda/finalizar/` com `venda_uuid` e limpa o estado operacional após confirmação;
- VendaHub e pagamentos não são persistidos no browser; o Backend/MySQL local segue como autoridade;
- o carrinho fica travado visualmente quando há pagamento ativo, e o Backend continua validando a regra;
- F10 continua reservado para fechamento de caixa futuro;
- ajuste visual registrado em 2026-09-14: no PDV Hub, a área de Produto Selecionado ganhou mais espaço para imagem, o formulário lateral redundante de adicionar pagamento foi removido, a mensagem operacional passou a ter região própria acima dos botões de pagamento, e o header agrupa NFC-e/TEF separando Suporte na região direita.
---

## Ainda Não Implementado

Ainda não existe no Hub:

- sincronização de Estoque;
- sincronização de Vendas;
- sincronização de Usuários;
- filas de sincronização;
- sincronização periódica;
- Celery no Hub;
- serviço Windows;
- migração do `PdvDesktopComponent` real para o frontend do Hub.
- homologação real do pareamento do `PDV-01`.
- carrinho, venda, pagamentos e persistência local do cupom/venda no Hub.
- fechamento de Caixa local no PDV Hub.

---

## Clientes no Hub Backend

Atualização registrada em 2026-09-14 no Backend do Sysvar Hub:

- `ClienteHub` foi introduzido como cache local de clientes vindos do Sysvar Central;
- o contrato Central consumido é `GET /api/hub/clientes/`, com `clientes_versao`, `gerado_em`, identidade de Hub/Empresa/Loja e lista de clientes;
- `HubConfig` passou a registrar `clientes_versao`, `clientes_gerado_em` e `clientes_sincronizado_em`;
- o Hub usa `cliente_uuid` local e imutável como identidade própria;
- `retaguarda_id` é nullable para permitir futuro cadastro offline antes de existir ID no Central;
- `origem` diferencia clientes `RETAGUARDA` de futuros clientes `LOCAL`;
- `presente_retaguarda` indica presença no snapshot Central sem apagar fisicamente registros ausentes;
- documento vazio é normalizado para `NULL`, preservando unicidade por Hub quando existir documento;
- a sincronização Central -> Hub valida todo o contrato antes de persistir e ocorre em transação;
- há preparação para reconciliar futuro cliente local pelo mesmo documento quando o Central devolver `retaguarda_id`;
- o endpoint local `GET /api/terminal/clientes/` consulta apenas o MySQL local do Hub e exige autenticação de operador do Terminal;
- VendaHub ainda não possui FK para ClienteHub e a seleção F2 continua etapa futura.

---

## Cliente na VendaHub

Atualização registrada em 2026-09-14 no Backend do Sysvar Hub:

- cliente selecionado na venda é salvo como snapshot na `VendaHub`, sem FK para `ClienteHub`;
- o snapshot preserva `cliente_uuid`, `retaguarda_id`, tipo de pessoa, documento, flag de cliente padrão e nome no momento da seleção;
- `cliente_uuid` permite selecionar futuramente cliente criado offline ainda sem `retaguarda_id`;
- a seleção de cliente funciona totalmente offline, usando apenas o MySQL local do Hub;
- F2 pode iniciar uma venda aberta vazia, antes do primeiro item, reaproveitando a criação lazy oficial da venda;
- troca e remoção de cliente são bloqueadas quando há pagamento ativo, seguindo a regra de remover pagamentos antes de alterar a venda;
- seleção, troca e remoção registram auditoria técnica sem nome, documento, telefone, email ou endereço.

---

## F2 Cliente no PDV Hub

Atualização registrada em 2026-09-14 no Frontend do Sysvar Hub:

- F2 passou a consultar clientes exclusivamente pelo Hub local em `/api/terminal/clientes/`;
- a busca por cliente funciona offline enquanto o MySQL local do Hub estiver disponível;
- seleção, troca e remoção de cliente usam a `VendaHub` como autoridade por meio de `/api/terminal/venda/cliente/`;
- selecionar cliente pode iniciar uma venda aberta vazia antes do primeiro item;
- refresh da tela restaura o cliente pelo snapshot retornado em `GET /api/terminal/venda/atual/`;
- o cliente selecionado não é salvo em `localStorage`, `sessionStorage` ou `IndexedDB`;
- cadastro offline de novo cliente permanece como próxima etapa.

---

## Próximos Passos

Próximos passos recomendados:

1. homologar manualmente o login de operador offline no `/operador` com Central desligado;
2. homologar manualmente abertura de Caixa local no `/pdv` com Central desligado;
3. definir modelo de sincronização Hub ↔ Central para vendas;
4. definir estratégia futura de testes automatizados sem usar o banco oficial `sysvarhub_db` no test runner.

---

## Riscos e Cuidados

- Não tratar cada Terminal como unidade offline independente.
- Não permitir múltiplos `HubConfig` silenciosamente.
- Não gerar novo `hub_uuid` em reativação normal.
- Não gravar estado parcial se a resposta de ativação vier incompleta.
- Não substituir token válido por resposta inválida.
- Não vazar token em logs, exceptions, API local, console ou documentação.
- Não transformar o Hub em autoridade conceitual de Empresa, Loja, Produto ou Cliente.
- Não permitir que o bootstrap troque silenciosamente a Loja ou Empresa estabelecida na ativação.
- Não apagar caixas locais quando eles deixam de vir no bootstrap; apenas inativar.
- Não confundir `CaixaHub` com cadastro mestre de caixa.
- Não iniciar sincronização de dados sem contrato funcional próprio.
- Não fazer Terminal/PDV acessar diretamente o MySQL local.
- Não fazer Terminal/PDV acessar diretamente o Sysvar Central.
- Não expor `retaguarda_token` em endpoints locais de Terminal.
- Não armazenar token puro de Terminal nem código puro de pareamento.
- Não aceitar `Authorization: Hub` em endpoints autenticados de Terminal.
- Não usar EAN como identidade de upsert do catálogo.
- Não apagar fisicamente SKU ausente no snapshot; apenas inativar.
- Não confundir `ativo` com `vendavel` no catálogo operacional.
- Não misturar token de Terminal com token de sessão do Operador.
- Não apagar pareamento do Terminal por sessão operacional inválida.
- Não apagar pareamento do Terminal por `401/403` operacional em endpoints de Caixa.
- Não armazenar sessão de Caixa no navegador; a fonte do estado é o Hub local.
- Não armazenar senha ou credencial digitada do operador no frontend.
- Não executar a suíte Django apontando para o banco oficial `sysvarhub_db`.
- Não criar banco `test_sysvarhub_db` até nova decisão arquitetural.

---

## Última atualização

~~~text
2026-09-14
~~~

## Fonte do projeto

~~~text
C:\SysvarHub\Backend
C:\SysvarHub\Frontend
~~~

## Limitações do contexto

Esta nota documenta o estado atual do Sysvar Hub backend e frontend operacional. A API local de consulta de catálogo para Terminal/PDV já existe no backend; a fundação Angular do frontend foi criada para consumir o Hub em same origin e preparar a migração estruturada do PDV real.

















