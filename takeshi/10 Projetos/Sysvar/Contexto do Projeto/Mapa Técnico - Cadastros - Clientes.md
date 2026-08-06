---
type: technical-map
status: active
project: Sysvar
group: Cadastros
module: Clientes
created: 2026-08-06
updated: 2026-08-06
tags:
  - sysvar
  - contexto
  - mapa-tecnico
  - cadastros
  - clientes
  - backend
  - frontend
  - multiempresa
  - vendas
  - pdv
  - auditoria
  - homologado
---

# Mapa Técnico - Cadastros - Clientes

## Objetivo

Este documento identifica as principais responsabilidades técnicas do módulo:

~~~text
Cadastros > Clientes
~~~

Ele deve ser utilizado para localizar rapidamente:

- model do cliente;
- serializer;
- viewset;
- endpoints;
- ações de ciclo de vida;
- consulta de compras;
- indicadores comerciais;
- integração com vendas;
- integração com o PDV;
- permissões;
- Auditoria Central;
- componente Angular;
- service Angular;
- models TypeScript;
- testes;
- regras multiempresa;
- riscos e limitações conhecidas.

Este documento não substitui a leitura do código atual.

Antes de qualquer alteração no módulo:

1. abrir os arquivos atuais;
2. localizar todos os consumidores;
3. verificar o impacto multiempresa;
4. verificar o impacto no PDV;
5. verificar o impacto em vendas;
6. verificar o impacto financeiro;
7. verificar o impacto fiscal;
8. verificar a Auditoria;
9. executar os testes;
10. atualizar a documentação.

---

# Situação Atual

O módulo de Clientes está:

~~~text
IMPLEMENTADO
TESTADO AUTOMATICAMENTE
HOMOLOGADO MANUALMENTE
DOCUMENTADO
APROVADO
~~~

Documento de homologação:

~~~text
10 Projetos\Sysvar\Homologações\Homologação - Cadastros - Clientes.md
~~~

---

# Estrutura Local

## Backend

~~~text
C:\SysvarProjeto\Backend
~~~

## Frontend

~~~text
C:\SysvarProjeto\Frontend\sysvar
~~~

## Vault do Obsidian

~~~text
C:\takeshi\takeshi
~~~

---

# Repositórios

Backend:

~~~text
FernandoMurashima/sysvarbackend
~~~

Frontend:

~~~text
FernandoMurashima/sysvarfrontend
~~~

Vault:

~~~text
FernandoMurashima/sysvar-vault
~~~

Branch principal:

~~~text
main
~~~

---

# Apps Envolvidos

Os principais apps envolvidos no cadastro de clientes são:

~~~text
cadastros
accounts
auditoria
fiscal
financeiro
produto
~~~

Responsabilidades gerais:

| App | Responsabilidade |
|---|---|
| `cadastros` | Cliente, empresa, loja, funcionários e API principal |
| `accounts` | Usuário, autenticação e permissões |
| `auditoria` | Eventos administrativos e de segurança |
| `fiscal` | Vendas, itens, pagamentos, devoluções e NFC-e |
| `financeiro` | Cashback, vale-troca e títulos financeiros |
| `produto` | Produtos e SKUs utilizados nas vendas |

---

# Backend - Arquivos Principais

## Model

~~~text
C:\SysvarProjeto\Backend\cadastros\models.py
~~~

Entidade principal:

~~~text
Cliente
~~~

## Serializer

~~~text
C:\SysvarProjeto\Backend\cadastros\serializers.py
~~~

Serializer principal:

~~~text
ClienteSerializer
~~~

## ViewSet

~~~text
C:\SysvarProjeto\Backend\cadastros\views.py
~~~

ViewSet principal:

~~~text
ClienteViewSet
~~~

## Rotas

As rotas são registradas no conjunto de URLs do app `cadastros`.

Localizar em:

~~~text
C:\SysvarProjeto\Backend\cadastros\urls.py
~~~

e, quando aplicável:

~~~text
C:\SysvarProjeto\Backend\Varejo\urls.py
~~~

## Testes

~~~text
C:\SysvarProjeto\Backend\cadastros\tests.py
~~~

---

# Model Cliente

A entidade `Cliente` pertence obrigatoriamente a uma empresa.

Regra fundamental:

~~~text
Cliente.empresa
~~~

O cliente nunca deve ser tratado como cadastro global.

Campos funcionais relevantes incluem:

~~~text
empresa
nome_cliente
apelido
tipo_pessoa
documento
cpf
cliente_padrao
ativo
bloqueio
motivo_bloqueio
observacao_bloqueio
bloqueado_em
bloqueado_por
~~~

Os nomes exatos devem sempre ser confirmados no model atual antes de qualquer alteração.

---

# Documento Funcional

O campo funcional oficial é:

~~~text
documento
~~~

O campo:

~~~text
cpf
~~~

permanece somente como compatibilidade técnica temporária no backend.

Regras:

- o frontend envia `documento`;
- o formulário Angular não deve possuir controles duplicados para `cpf` e `documento`;
- novos recursos devem utilizar `documento`;
- a remoção definitiva de `cpf` exige análise de consumidores, migrations e dados existentes.

---

# Tipo de Pessoa

Tipos aprovados:

~~~text
PF
PJ
~~~

O tipo determina:

- CPF ou CNPJ;
- máscara;
- validação;
- apresentação;
- regras específicas do documento.

Não inferir o tipo exclusivamente pela quantidade de dígitos quando o campo explícito estiver disponível.

---

# Unicidade do Documento

A unicidade é por empresa.

Regra funcional:

~~~text
empresa + documento
~~~

Consequências:

- CPF duplicado na mesma empresa é recusado;
- CNPJ duplicado na mesma empresa é recusado;
- o mesmo CPF pode existir em empresas diferentes;
- o mesmo CNPJ pode existir em empresas diferentes;
- documento vazio não deve gerar conflito entre clientes comuns.

A validação deve existir no backend, independentemente da validação do frontend.

---

# Cliente Sem Documento

Cliente comum pode ser cadastrado sem CPF ou CNPJ.

O backend deve aceitar documento vazio conforme a regra funcional.

O sistema não deve:

- preencher `00000000000`;
- marcar como cliente padrão;
- impedir outro cliente também sem documento;
- transformar automaticamente em Consumidor Final.

---

# Cliente Padrão

Cada empresa possui exatamente um cliente padrão.

Dados funcionais:

~~~text
Nome: Consumidor Final
Tipo: PF
Documento: 00000000000
cliente_padrao: true
~~~

Serviço relacionado:

~~~text
ClientePadraoService
~~~

Localizar em:

~~~text
C:\SysvarProjeto\Backend\cadastros\services.py
~~~

ou na estrutura atual de services do app.

---

# Proteções do Cliente Padrão

O cliente padrão não pode ser:

- criado manualmente como um segundo cliente padrão;
- excluído;
- inativado;
- bloqueado;
- transferido de empresa;
- descaracterizado;
- alterado para PJ;
- ter seu documento funcional alterado;
- ter `cliente_padrao` desmarcado.

Essas proteções devem existir no backend.

O frontend apenas melhora a experiência do usuário, mas não é a autoridade final.

---

# Criação Automática do Cliente Padrão

O sistema deve garantir um cliente padrão por empresa.

A lógica deve ser:

- idempotente;
- transacional quando necessário;
- segura contra duplicação;
- limitada à empresa correta;
- capaz de diagnosticar inconsistências.

Não criar Consumidor Final global.

---

# ClienteSerializer

Arquivo:

~~~text
C:\SysvarProjeto\Backend\cadastros\serializers.py
~~~

Responsabilidades esperadas:

- validar empresa;
- validar tipo de pessoa;
- normalizar documento;
- validar CPF;
- validar CNPJ;
- aplicar unicidade por empresa;
- permitir cliente comum sem documento;
- proteger cliente padrão;
- bloquear mass assignment;
- expor indicadores comerciais;
- não permitir alteração direta indevida do ciclo de vida.

Campos de ciclo de vida não devem ser livremente alteráveis por chamadas comuns de criação ou edição.

---

# Proteção Contra Mass Assignment

Campos sensíveis não devem ser alterados por payload comum sem autorização explícita.

Exemplos:

~~~text
ativo
bloqueio
motivo_bloqueio
observacao_bloqueio
bloqueado_em
bloqueado_por
cliente_padrao
empresa
~~~

O ciclo de vida deve utilizar ações oficiais.

Não permitir que um consumidor da API contorne:

- Ativar;
- Inativar;
- Bloquear;
- Desbloquear;
- proteções do cliente padrão.

---

# ClienteViewSet

Arquivo:

~~~text
C:\SysvarProjeto\Backend\cadastros\views.py
~~~

Responsabilidades principais:

- listar clientes;
- consultar cliente;
- criar;
- editar;
- excluir quando permitido;
- pesquisar;
- filtrar;
- paginar;
- retornar indicadores;
- executar ciclo de vida;
- retornar Histórico;
- retornar Compras;
- proteger empresa;
- aplicar permissões;
- registrar Auditoria.

---

# Endpoints Principais

Base:

~~~text
/api/cadastros/clientes/
~~~

## Lista

~~~http
GET /api/cadastros/clientes/
~~~

Responsabilidades:

- filtrar pela empresa atual;
- pesquisar;
- ordenar;
- paginar;
- não retornar clientes de outras empresas.

## Criação

~~~http
POST /api/cadastros/clientes/
~~~

Responsabilidades:

- validar permissão;
- validar empresa;
- validar documento;
- impedir cliente padrão manual indevido;
- registrar Auditoria.

## Detalhe

~~~http
GET /api/cadastros/clientes/{id}/
~~~

Responsabilidades:

- validar empresa;
- retornar dados cadastrais;
- retornar situação;
- retornar indicadores comerciais.

## Alteração

~~~http
PUT /api/cadastros/clientes/{id}/
PATCH /api/cadastros/clientes/{id}/
~~~

Responsabilidades:

- validar permissão;
- proteger empresa;
- proteger cliente padrão;
- proteger ciclo de vida;
- validar documento;
- registrar Auditoria.

## Exclusão

~~~http
DELETE /api/cadastros/clientes/{id}/
~~~

Responsabilidades:

- permitir exclusão somente quando não houver vínculos;
- proteger cliente padrão;
- preservar operações históricas;
- retornar mensagem amigável;
- registrar Auditoria.

---

# Ações de Ciclo de Vida

## Ativar

~~~http
POST /api/cadastros/clientes/{id}/ativar/
~~~

## Inativar

~~~http
POST /api/cadastros/clientes/{id}/inativar/
~~~

## Bloquear

~~~http
POST /api/cadastros/clientes/{id}/bloquear/
~~~

## Desbloquear

~~~http
POST /api/cadastros/clientes/{id}/desbloquear/
~~~

Os caminhos exatos devem ser confirmados no router atual antes de qualquer consumo novo.

---

# Bloqueio

O bloqueio deve registrar:

~~~text
motivo_bloqueio
observacao_bloqueio
bloqueado_em
bloqueado_por
~~~

Regras:

- motivo obrigatório;
- observação opcional;
- proteção multiempresa;
- Auditoria obrigatória;
- preservação do histórico;
- cliente bloqueado não pode ser utilizado em nova venda.

---

# Desbloqueio

O desbloqueio deve:

- retirar o bloqueio operacional;
- preservar o evento anterior;
- registrar o responsável;
- registrar Auditoria;
- não apagar o motivo histórico já auditado;
- permitir o uso no PDV quando o cliente estiver ativo.

---

# Inativação

A inativação não representa exclusão.

Cliente inativo:

- permanece no banco;
- preserva vendas;
- preserva pagamentos;
- preserva documentos fiscais;
- preserva devoluções;
- preserva cashback;
- preserva títulos;
- preserva Auditoria;
- não pode ser usado em nova venda.

---

# Histórico do Cliente

Endpoint:

~~~http
GET /api/cadastros/clientes/{id}/historico/
~~~

Origem:

~~~text
AuditLog
~~~

O Histórico apresenta eventos administrativos.

Exemplos:

~~~text
CLIENT_CREATED
CLIENT_UPDATED
CLIENT_ACTIVATED
CLIENT_DEACTIVATED
CLIENT_BLOCKED
CLIENT_UNBLOCKED
CLIENT_DELETED
CLIENT_DELETE_DENIED
~~~

Os nomes exatos dos eventos devem ser confirmados em:

~~~text
C:\SysvarProjeto\Backend\auditoria\models.py
~~~

ou no arquivo atual onde `AuditAction` estiver definido.

---

# Histórico Não é Extrato de Compras

O endpoint de Histórico não deve listar vendas.

Separação obrigatória:

~~~text
Histórico
→ AuditLog e ações administrativas

Compras
→ domínio fiscal.VendaPdv
~~~

Não criar eventos artificiais de Auditoria apenas para fazer vendas aparecerem no cadastro do cliente.

---

# Compras do Cliente

Endpoint:

~~~http
GET /api/cadastros/clientes/{id}/compras/
~~~

Origem principal:

~~~text
fiscal.VendaPdv
~~~

Entidades relacionadas:

~~~text
VendaPdv
VendaPdvItem
VendaPdvPagamento
VendaDevolucao
NFCe
~~~

Localizar em:

~~~text
C:\SysvarProjeto\Backend\fiscal\models.py
~~~

---

# Contrato da Consulta de Compras

Formato paginado:

~~~json
{
  "count": 0,
  "next": null,
  "previous": null,
  "results": []
}
~~~

Campos conhecidos do item retornado:

~~~text
id
data_venda
numero_venda
numero_documento
loja_id
loja_nome
vendedor_id
vendedor_nome
quantidade_itens
valor_bruto
desconto
valor_final
valor_devolvido
forma_pagamento
status
status_descricao
cancelada
devolvida
pode_consultar_venda
detalhe_venda_url
~~~

O contrato real do código é a autoridade final.

---

# Filtros de Compras

Parâmetros suportados conforme implementação atual:

~~~text
page
page_size
data_inicio
data_fim
status
loja
ordering
~~~

O frontend deve enviar somente parâmetros preenchidos.

A paginação de Compras deve ser independente de:

- paginação da lista de Clientes;
- paginação do Histórico.

---

# Regra Multiempresa das Compras

Regra obrigatória:

~~~text
cliente.empresa_id == venda.empresa_id
~~~

O endpoint deve filtrar simultaneamente por:

~~~text
cliente_id
empresa_id
~~~

Comportamento esperado:

- cliente de outra empresa retorna 404 no contexto comum;
- vendas de outra empresa nunca aparecem;
- superusuário deve operar dentro de contexto de empresa explícito quando necessário;
- nenhum indicador pode agregar vendas de outra empresa.

---

# Indicadores Comerciais

Indicadores retornados no detalhe do cliente:

~~~text
ultima_compra
total_comprado
quantidade_compras
ticket_medio
~~~

O backend é responsável pelo cálculo.

O frontend não deve recalcular esses valores a partir da página atual da tabela.

---

# Última Compra

Representa a venda finalizada mais recente.

Cliente sem vendas válidas:

~~~text
ultima_compra = null
~~~

Apresentação no frontend:

~~~text
Nenhuma compra
~~~

---

# Total Comprado

Regra atual:

- considera vendas `FINALIZADA`;
- ignora vendas `CANCELADA`;
- reduz devoluções finalizadas;
- utiliza `VendaDevolucao.credito_cliente` como abatimento atual.

O cálculo deve evitar duplicação por joins com:

- itens;
- pagamentos;
- devoluções.

---

# Quantidade de Compras

Representa a quantidade de vendas:

~~~text
FINALIZADA
~~~

Vendas canceladas não entram na quantidade.

A devolução não deve duplicar a quantidade da venda original.

---

# Ticket Médio

Cálculo:

~~~text
total_comprado / quantidade_compras
~~~

Quando não houver compras:

~~~text
0
~~~

O tratamento de arredondamento deve seguir o padrão monetário do backend.

---

# Venda Cancelada

Venda cancelada:

- permanece na tabela de Compras;
- aparece identificada como cancelada;
- não entra nos indicadores;
- preserva seu vínculo com o cliente;
- impede exclusão física do cliente quando o relacionamento existir.

---

# Venda Devolvida

Venda devolvida:

- permanece vinculada;
- aparece identificada conforme a implementação;
- reduz o total comprado;
- preserva histórico fiscal;
- não deve apagar a venda original.

Entidade:

~~~text
VendaDevolucao
~~~

Status considerado na regra atual:

~~~text
FINALIZADA
~~~

---

# Forma de Pagamento

A consulta de Compras utiliza:

~~~text
VendaPdvPagamento
~~~

Quando houver mais de uma forma, a resposta pode apresentar:

~~~text
Múltiplas
~~~

Não duplicar valores da venda ao agregar pagamentos.

---

# Quantidade de Itens

A quantidade apresentada deve representar a soma das quantidades dos itens.

Não deve representar apenas:

~~~text
quantidade de linhas
~~~

Entidade relacionada:

~~~text
VendaPdvItem
~~~

---

# Exclusão do Cliente

Método principal:

~~~text
ClienteViewSet.perform_destroy
~~~

A exclusão física é permitida somente quando o cliente não possui vínculos impeditivos.

Antes da exclusão, devem ser verificados relacionamentos conhecidos.

---

# Vínculos que Impedem Exclusão

Relacionamentos conhecidos incluem:

~~~text
vendas_pdv
devolucoes_venda
cashback_movimentos
vales_troca
receber_set
~~~

Além desses, relacionamentos protegidos podem ser interceptados por:

~~~text
ProtectedError
IntegrityError
~~~

Não utilizar `CASCADE` para contornar a proteção histórica sem uma decisão arquitetural formal.

---

# Resposta da Exclusão Negada

Status:

~~~text
400 Bad Request
~~~

Contrato:

~~~json
{
  "detail": "Este cliente possui vendas ou outros registros vinculados e não pode ser excluído. Utilize a inativação."
}
~~~

Constante no ViewSet:

~~~text
EXCLUSAO_NEGADA_DETAIL
~~~

A resposta não deve expor:

- nome de constraint;
- tabela;
- foreign key;
- stack trace;
- `ProtectedError`;
- `IntegrityError`.

---

# Auditoria da Exclusão Negada

Evento:

~~~text
CLIENT_DELETE_DENIED
~~~

A Auditoria deve ser gerada uma única vez.

Método auxiliar atual:

~~~text
_auditar_exclusao_negada
~~~

O evento pode registrar de forma segura:

- motivo;
- lista resumida de impedimentos;
- mensagem amigável;
- empresa;
- usuário;
- cliente;
- request;
- correlation ID;
- código HTTP.

---

# Auditoria Central

App:

~~~text
C:\SysvarProjeto\Backend\auditoria
~~~

Arquivos principais:

~~~text
auditoria\models.py
auditoria\services.py
auditoria\views.py
auditoria\tests.py
~~~

Componentes relevantes:

~~~text
AuditLog
AuditAction
AuditCategory
AuditService
~~~

Operações relevantes devem utilizar a infraestrutura oficial.

Não criar tabela paralela de histórico de clientes.

---

# Permissões

Consulta de clientes:

~~~text
VIEW
~~~

Consulta de Compras:

~~~text
VIEW
~~~

Consulta de Histórico:

~~~text
VIEW
~~~

Criação, alteração, exclusão e ciclo de vida:

~~~text
EDIT
~~~

O backend é a autoridade final.

O frontend deve apenas:

- ocultar;
- desabilitar;
- orientar.

Não confiar exclusivamente no estado dos botões.

---

# Frontend - Estrutura Principal

Caminho da feature:

~~~text
C:\SysvarProjeto\Frontend\sysvar\src\app\features\clientes
~~~

Arquivos principais:

~~~text
clientes.component.ts
clientes.component.html
clientes.component.css
clientes.component.spec.ts
~~~

---

# Models TypeScript

Arquivo:

~~~text
C:\SysvarProjeto\Frontend\sysvar\src\app\core\models\clientes.ts
~~~

Interfaces relevantes:

~~~text
Cliente
ClienteFiltros
ClienteIndicadores
ClienteBloqueioPayload
ClienteHistoricoItem
ClienteHistoricoResponse
ClienteCompraItem
ClienteComprasFiltros
ClienteComprasResponse
PaginatedResponse
~~~

Evitar:

~~~text
any
~~~

quando o contrato já for conhecido.

---

# Service Angular

Arquivo:

~~~text
C:\SysvarProjeto\Frontend\sysvar\src\app\core\services\clientes.service.ts
~~~

Responsabilidades:

- listar;
- consultar;
- criar;
- atualizar;
- excluir;
- ativar;
- inativar;
- bloquear;
- desbloquear;
- carregar indicadores;
- carregar Histórico;
- carregar Compras.

Métodos relevantes incluem:

~~~text
list
indicadores
get
create
update
patch
remove
ativar
inativar
bloquear
desbloquear
historico
compras
~~~

---

# Método de Compras no Service

Assinatura funcional:

~~~typescript
compras(
  id: number,
  filtros?: ClienteComprasFiltros
): Observable<ClienteComprasResponse>
~~~

URL:

~~~text
/api/cadastros/clientes/{id}/compras/
~~~

O método envia somente parâmetros preenchidos.

Não enviar:

- `undefined`;
- `null`;
- string vazia.

---

# Organização da Consulta no Frontend

A consulta possui três áreas:

~~~text
dados
compras
historico
~~~

Apresentação:

~~~text
Dados cadastrais
Compras
Histórico
~~~

Estado relacionado:

~~~text
consultaArea
~~~

A separação deve ser preservada.

---

# Área Dados Cadastrais

Apresenta:

- informações cadastrais;
- endereço;
- contatos;
- categoria;
- consentimentos;
- situação;
- bloqueio;
- indicadores comerciais.

Cards comerciais:

~~~text
Última compra
Total comprado
Quantidade de compras
Ticket médio
~~~

---

# Área Compras

Estados próprios:

~~~text
compras
comprasPage
comprasPageSize
comprasTotal
comprasLoading
comprasError
comprasStatus
comprasDataInicio
comprasDataFim
~~~

Métodos relacionados podem incluir:

~~~text
carregarCompras
selecionarAreaConsulta
aplicarFiltrosCompras
atualizarCompras
onComprasPageSizeChange
comprasPaginaAnterior
comprasProximaPagina
~~~

Confirmar os nomes no componente atual antes de reutilizá-los.

---

# Carregamento Sob Demanda

As compras são carregadas quando a área Compras é acessada.

Não carregar compras de todos os clientes na listagem principal.

Objetivos:

- reduzir tráfego;
- evitar consultas desnecessárias;
- impedir N+1;
- manter a lista principal leve.

---

# Estado Vazio de Compras

Mensagem:

~~~text
Nenhuma compra encontrada para este cliente.
~~~

Não tratar erro de API como lista vazia.

Estados distintos:

~~~text
loading
error
empty
results
~~~

---

# Tabela de Compras

Colunas atuais:

~~~text
Data
Venda
Documento
Loja
Vendedor
Itens
Valor bruto
Desconto
Valor final
Pagamento
Situação
Ação
~~~

Vendas canceladas e devolvidas possuem identificação visual própria.

---

# Consultar Venda

O botão:

~~~text
Consultar venda
~~~

permanece desabilitado quando:

~~~text
pode_consultar_venda = false
~~~

Limitação atual:

- não existe rota frontend consolidada para o detalhe da venda.

Não inventar uma rota.

A implementação futura deve primeiro localizar o fluxo oficial de consulta de venda no módulo Fiscal ou Vendas.

---

# Histórico no Frontend

Estados próprios do Histórico não devem ser reutilizados por Compras.

Exemplos:

~~~text
historico
historicoPage
historicoPageSize
historicoTotal
historicoLoading
historicoError
~~~

A paginação deve permanecer independente.

---

# Tratamento de Erro da Exclusão

O componente possui lógica para extrair a mensagem retornada pela API.

Prioridade esperada:

1. `err.error.detail`;
2. `err.error.message`;
3. `err.error.non_field_errors`;
4. primeiro erro de campo;
5. `err.message`;
6. fallback.

Fallback:

~~~text
Não foi possível excluir o cliente. Verifique se existem vendas ou outros registros vinculados. Nesse caso, utilize a inativação.
~~~

---

# Estado da Exclusão

Estado:

~~~text
exclusaoSaving
~~~

Durante a requisição:

- botões ficam desabilitados;
- segundo clique é ignorado;
- seleção não é limpa;
- lista não é alterada antecipadamente.

Em caso de sucesso:

- modal fecha;
- seleção é limpa;
- lista é atualizada;
- indicadores são atualizados;
- mensagem de sucesso aparece.

Em caso de negativa:

- modal fecha;
- cliente permanece selecionado;
- mensagem da API aparece;
- loading termina;
- botão Inativar permanece disponível.

---

# Integração com o PDV

O PDV deve utilizar cliente da empresa atual.

Fluxos homologados:

~~~text
Venda sem cliente identificado
→ Consumidor Final da empresa

Venda com cliente identificado
→ cliente selecionado da empresa
~~~

O PDV não deve aceitar:

- cliente de outra empresa;
- cliente inativo;
- cliente bloqueado.

---

# Consumidor Final no PDV

Documento:

~~~text
00000000000
~~~

O cliente padrão:

- é selecionado automaticamente quando não há cliente identificado;
- recebe a venda;
- apresenta a venda na aba Compras;
- recebe indicadores comerciais;
- permanece isolado por empresa.

---

# Cliente Identificado no PDV

Ao selecionar cliente comum:

- o vínculo com Consumidor Final é substituído;
- a venda pertence ao cliente identificado;
- indicadores são atualizados;
- a venda aparece uma única vez;
- o Consumidor Final não recebe essa venda.

---

# Cliente Bloqueado ou Inativo no PDV

O PDV deve recusar o uso.

Não deve:

- criar venda para o cliente;
- trocar silenciosamente para Consumidor Final;
- alterar indicadores;
- ignorar o estado atual.

Após reativação e desbloqueio, o cliente volta a ser elegível.

---

# Testes Backend

Arquivo:

~~~text
C:\SysvarProjeto\Backend\cadastros\tests.py
~~~

Cobertura relevante:

- cliente padrão;
- CPF;
- CNPJ;
- documento vazio;
- duplicidade por empresa;
- isolamento multiempresa;
- mass assignment;
- ativação;
- inativação;
- bloqueio;
- desbloqueio;
- Histórico;
- indicadores;
- Compras;
- cancelamento;
- devolução;
- paginação;
- permissões;
- exclusão permitida;
- exclusão negada;
- Auditoria;
- `ProtectedError`;
- `IntegrityError`;
- N+1.

Último total informado após a correção final:

~~~text
Cadastros: 42/42
Auditoria: 21/21
Suíte geral: 97/97
Falhas: 0
Ignorados: 0
~~~

---

# Testes Frontend

Arquivo:

~~~text
C:\SysvarProjeto\Frontend\sysvar\src\app\features\clientes\clientes.component.spec.ts
~~~

Service spec:

~~~text
C:\SysvarProjeto\Frontend\sysvar\src\app\core\services\clientes.service.spec.ts
~~~

Cobertura relevante:

- documento funcional;
- formulário sem duplicação;
- ciclo de vida;
- permissões;
- Histórico;
- abas da consulta;
- indicadores;
- carregamento de Compras;
- filtros;
- paginação;
- estado vazio;
- erro;
- exclusão permitida;
- exclusão negada;
- mensagem da API;
- fallback;
- seleção preservada;
- duplo clique;
- evento de exclusão negada.

Último total informado:

~~~text
Karma: 90/90
Falhas: 0
Ignorados: 0
TypeScript: aprovado
Build development: aprovado
~~~

---

# Comandos de Validação

## Backend

~~~powershell
cd C:\SysvarProjeto\Backend

python manage.py check
python manage.py makemigrations --check --dry-run
python manage.py test cadastros -v 2 --noinput
python manage.py test auditoria -v 2 --noinput
python manage.py test -v 2 --noinput
~~~

## Frontend

~~~powershell
cd C:\SysvarProjeto\Frontend\sysvar

npx.cmd tsc -p tsconfig.app.json --noEmit
ng build --configuration development
ng test --watch=false --browsers=ChromeHeadless
~~~

---

# Commits Homologados

## Implementação inicial

Backend:

~~~text
df9e955b9bc5b39903647232a1072f8a9964508e
~~~

Frontend:

~~~text
73db1f96cfac11accccff2616685161a2553e6e6
~~~

## Documento funcional

Backend:

~~~text
ef3e5ddb08d27063d3420f567974fe529e53e915
~~~

Frontend:

~~~text
5fe3a5f78a076d831f752f86d23c852cb7c0b460
~~~

## Ciclo de vida e Histórico

Backend:

~~~text
c81053b05d0949ccb945f873ff7e416255b9a406
~~~

Frontend:

~~~text
9ea4abd975982c5d0df58229ff7934836ae197f2
~~~

## Compras e indicadores

Backend:

~~~text
c95323f041dc87d617ebdaaeabaa8d094e55b4f8
~~~

Frontend:

~~~text
d8175e91c74e19b9c799a7e939a9812daf283ac0
~~~

## Exclusão negada

Backend:

~~~text
82608d6c578b37336dec162fa186da11f3350823
~~~

Frontend:

~~~text
7881c54b35a2fadc0c7089fcc283a0a65bf1d5e9
~~~

---

# Riscos e Cuidados

## Campo legado CPF

O campo `cpf` ainda existe como compatibilidade.

Risco:

- consumidores antigos ainda podem depender dele.

Antes da remoção:

- pesquisar backend;
- pesquisar frontend;
- pesquisar integrações;
- pesquisar scripts;
- pesquisar migrations;
- pesquisar dados;
- executar testes completos.

---

## Indicadores com Joins

Risco:

- duplicação de valor quando itens, pagamentos e devoluções são agregados na mesma consulta.

Cuidados:

- usar subqueries;
- usar agregações distintas quando aplicável;
- testar vendas com vários itens;
- testar vários pagamentos;
- testar devoluções.

---

## Exclusão e Novos Relacionamentos

Novos módulos podem criar vínculos com Cliente.

Ao criar relacionamento novo:

- definir política `on_delete`;
- atualizar `_impedimentos_exclusao`;
- adicionar teste;
- preservar a mensagem amigável;
- garantir Auditoria;
- atualizar este documento.

---

## Cliente Padrão Duplicado

Risco:

- criação concorrente ou importação incorreta.

Cuidados:

- serviço idempotente;
- constraint adequada;
- operação transacional;
- diagnóstico de inconsistência;
- nunca criar manualmente pelo frontend.

---

## Vazamento entre Empresas

Todas as consultas devem usar a empresa atual.

Nunca consultar Cliente apenas por:

~~~python
Cliente.objects.get(pk=id)
~~~

sem aplicar o escopo de empresa adequado.

---

## Dados Sensíveis na Auditoria

Não registrar desnecessariamente:

- CPF completo;
- CNPJ completo;
- telefone;
- e-mail;
- endereço;
- conteúdo sensível.

Preferir:

- campos alterados;
- IDs;
- dados mascarados;
- motivo operacional seguro.

---

## Status do Cliente no PDV

Não confiar somente no frontend.

O backend do fluxo de venda deve validar novamente:

~~~text
empresa
ativo
bloqueio
~~~

---

# Limitações Atuais

Permanecem como evoluções futuras:

- rota consolidada do frontend para consultar o detalhe completo da venda;
- remoção planejada do campo legado `cpf`;
- testes manuais de todos os possíveis vínculos fiscais e financeiros;
- eventual extração de cálculos comerciais para service dedicado, caso a complexidade aumente.

---

# Documentos Relacionados

~~~text
10 Projetos\Sysvar\Sysvar.md
10 Projetos\Sysvar\Contexto do Projeto\Visão Geral.md
10 Projetos\Sysvar\Contexto do Projeto\Arquitetura.md
10 Projetos\Sysvar\Contexto do Projeto\Modelo de Domínio.md
10 Projetos\Sysvar\Contexto do Projeto\Workflows.md
10 Projetos\Sysvar\Contexto do Projeto\Riscos e Cuidados.md
10 Projetos\Sysvar\Contexto do Projeto\Mapa Técnico.md
10 Projetos\Sysvar\Homologações\Homologação - Cadastros - Clientes.md
10 Projetos\Sysvar\Decisões Técnicas\ADR-003 - Auditoria Central do SISVAR.md
~~~

---

# Regra de Manutenção

Toda alteração relevante no módulo Clientes deve responder:

1. a regra continua multiempresa?
2. o cliente padrão continua protegido?
3. documento vazio continua permitido?
4. CPF/CNPJ continuam únicos por empresa?
5. o ciclo de vida continua protegido?
6. o PDV continua validando ativo e bloqueio?
7. as compras continuam isoladas?
8. os indicadores continuam corretos?
9. exclusões continuam preservando vínculos?
10. a Auditoria continua obrigatória?
11. os testes foram atualizados?
12. a documentação foi atualizada?

---

# Estado Final

~~~text
Cadastros > Clientes
~~~

Status:

~~~text
HOMOLOGADO
DOCUMENTADO
APROVADO
~~~

Próximo item funcional do grupo Cadastros:

~~~text
Fornecedores
~~~