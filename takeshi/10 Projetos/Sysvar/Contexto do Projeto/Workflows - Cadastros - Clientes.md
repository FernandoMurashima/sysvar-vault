---
type: workflow
status: active
project: Sysvar
group: Cadastros
module: Clientes
created: 2026-08-06
updated: 2026-08-06
tags:
  - sysvar
  - contexto
  - workflows
  - cadastros
  - clientes
  - multiempresa
  - vendas
  - pdv
  - auditoria
  - homologado
---

# Workflows - Cadastros - Clientes

## Objetivo

Este documento descreve os principais fluxos funcionais e técnicos do módulo:

~~~text
Cadastros > Clientes
~~~

Os fluxos aqui registrados foram:

- implementados;
- testados automaticamente;
- homologados manualmente;
- validados em ambiente funcional;
- integrados ao PDV;
- integrados às vendas;
- integrados à Auditoria Central;
- validados quanto ao isolamento multiempresa.

Este documento deve ser consultado antes de qualquer alteração nos fluxos de:

- criação de cliente;
- edição;
- consulta;
- pesquisa;
- filtros;
- cliente padrão;
- ativação;
- inativação;
- bloqueio;
- desbloqueio;
- compras;
- indicadores comerciais;
- exclusão;
- PDV;
- Auditoria.

---

# Situação Atual

O módulo está:

~~~text
IMPLEMENTADO
TESTADO AUTOMATICAMENTE
HOMOLOGADO MANUALMENTE
DOCUMENTADO
APROVADO
~~~

Documentos relacionados:

~~~text
10 Projetos\Sysvar\Homologações\Homologação - Cadastros - Clientes.md
10 Projetos\Sysvar\Contexto do Projeto\Mapa Técnico - Cadastros - Clientes.md
10 Projetos\Sysvar\Contexto do Projeto\Modelo de Domínio - Cadastros - Clientes.md
~~~

---

# Princípios Gerais dos Fluxos

Todos os fluxos de Clientes devem respeitar:

1. empresa atual;
2. permissões efetivas;
3. proteção do cliente padrão;
4. documento funcional;
5. isolamento multiempresa;
6. ciclo de vida por ações;
7. integridade dos vínculos;
8. Auditoria Central;
9. proteção de dados sensíveis;
10. mensagens amigáveis;
11. backend como autoridade final;
12. testes automatizados.

---

# Fluxo Geral do Módulo

~~~text
Usuário acessa Cadastros > Clientes
→ frontend valida permissão de exibição
→ backend valida autenticação
→ backend identifica empresa atual
→ backend aplica escopo multiempresa
→ clientes da empresa são carregados
→ indicadores da empresa são carregados
→ usuário pesquisa, filtra ou seleciona
→ ação escolhida é validada
→ backend executa regra de negócio
→ Auditoria é registrada quando aplicável
→ frontend atualiza lista e indicadores
~~~

---

# Fluxo de Abertura da Tela

## Entrada

O usuário acessa:

~~~text
Cadastros > Clientes
~~~

## Processo

~~~text
Abrir rota
→ validar sessão
→ validar contrato
→ validar módulo
→ validar permissão VIEW
→ identificar empresa atual
→ carregar indicadores
→ carregar primeira página
→ aplicar ordenação padrão
→ exibir cliente padrão e clientes comuns
~~~

## Resultado Esperado

A tela deve apresentar:

- título;
- indicadores;
- filtros;
- ações disponíveis;
- tabela;
- paginação;
- total de registros;
- somente clientes da empresa atual.

## Falhas Possíveis

- sessão inválida;
- empresa sem acesso;
- módulo não contratado;
- usuário sem permissão;
- erro de API;
- empresa não resolvida.

## Comportamento em Falha

O sistema deve:

- apresentar mensagem clara;
- não misturar clientes de outra empresa;
- não apresentar lista parcial como se estivesse correta;
- não ocultar erro como estado vazio.

---

# Fluxo de Listagem

~~~text
Frontend solicita página
→ envia page e page_size
→ backend identifica empresa
→ aplica filtros da empresa
→ aplica pesquisa
→ aplica ordenação
→ pagina queryset
→ retorna count, next, previous e results
→ frontend atualiza tabela
→ frontend calcula intervalo exibido
~~~

Formato esperado:

~~~json
{
  "count": 0,
  "next": null,
  "previous": null,
  "results": []
}
~~~

---

# Fluxo da Paginação

~~~text
Usuário altera página
→ frontend mantém filtros
→ solicita nova página
→ backend retorna somente registros da página
→ total geral permanece
→ tabela é substituída
→ intervalo Mostrando X–Y de Z é atualizado
~~~

Ao alterar filtros:

~~~text
Alterar filtro
→ página volta para 1
→ nova consulta é realizada
~~~

Ao alterar quantidade por página:

~~~text
Alterar page_size
→ página volta para 1
→ nova consulta é realizada
~~~

A paginação da lista é independente das paginações de:

- Compras;
- Histórico.

---

# Fluxo de Pesquisa

A pesquisa pode utilizar:

- nome;
- apelido;
- CPF;
- CNPJ;
- documento sem máscara;
- documento com máscara, após normalização.

Fluxo:

~~~text
Usuário informa termo
→ frontend envia pesquisa
→ backend normaliza quando necessário
→ backend restringe pela empresa
→ backend pesquisa campos permitidos
→ retorna resultados paginados
~~~

Regra de segurança:

~~~text
pesquisa nunca remove o filtro de empresa
~~~

---

# Fluxo de Filtros

Filtros homologados incluem:

- Pessoa Física;
- Pessoa Jurídica;
- ativo;
- inativo;
- bloqueado;
- desbloqueado;
- estado;
- nome;
- documento.

Fluxo:

~~~text
Usuário seleciona filtros
→ frontend monta parâmetros preenchidos
→ página volta para 1
→ backend aplica empresa
→ backend aplica filtros
→ backend pagina resultados
→ indicadores compatíveis são atualizados
~~~

Ao limpar:

~~~text
Limpar filtros
→ limpar campos
→ voltar página para 1
→ carregar lista original da empresa
~~~

---

# Fluxo de Indicadores da Tela

~~~text
Abrir tela ou atualizar lista
→ frontend solicita indicadores
→ backend identifica empresa
→ conta carteira completa da empresa
→ retorna totais
→ frontend apresenta cards
~~~

Os indicadores não devem ser calculados apenas com os registros da página atual.

Exemplos:

- total;
- ativos;
- inativos;
- bloqueados;
- Pessoa Física;
- Pessoa Jurídica.

---

# Fluxo de Criação de Pessoa Física

## Entrada

Usuário seleciona:

~~~text
Novo Cliente
~~~

e define:

~~~text
Tipo: Pessoa Física
~~~

## Processo

~~~text
Abrir formulário
→ iniciar campos vazios
→ usuário informa nome
→ usuário informa CPF opcional
→ frontend aplica máscara
→ usuário confirma
→ frontend envia documento normalizado
→ backend valida permissão EDIT
→ backend identifica empresa
→ backend valida tipo PF
→ backend valida CPF quando preenchido
→ backend valida unicidade por empresa
→ backend impede campos protegidos
→ cliente é criado
→ Auditoria registra criação
→ frontend fecha formulário
→ lista e indicadores são atualizados
~~~

## Resultado

- cliente pertence à empresa atual;
- documento armazenado normalizado;
- cliente comum não é padrão;
- cliente inicia no estado permitido pela regra;
- nenhum campo protegido é alterado diretamente.

---

# Fluxo de Criação de Pessoa Jurídica

## Entrada

~~~text
Tipo: Pessoa Jurídica
~~~

## Processo

~~~text
Abrir formulário
→ informar razão social ou nome
→ informar CNPJ
→ frontend aplica máscara
→ enviar documento normalizado
→ backend valida permissão
→ backend valida empresa
→ backend valida tipo PJ
→ backend valida CNPJ
→ backend valida unicidade por empresa
→ criar cliente
→ registrar Auditoria
→ atualizar lista e indicadores
~~~

---

# Fluxo de Cliente Sem Documento

~~~text
Usuário cria cliente comum
→ seleciona PF ou PJ
→ deixa documento vazio
→ frontend não preenche valor artificial
→ backend aceita documento vazio
→ backend não aplica conflito de unicidade vazio
→ cliente é criado
→ cliente_padrao permanece false
~~~

O sistema não deve:

- preencher `00000000000`;
- transformar em Consumidor Final;
- impedir um segundo cliente sem documento;
- associar vendas antigas automaticamente.

---

# Fluxo de Validação do Documento

## CPF

~~~text
Documento informado
→ remover máscara
→ verificar quantidade de dígitos
→ rejeitar sequência inválida
→ validar dígitos verificadores
→ verificar duplicidade na empresa
→ aceitar ou recusar
~~~

## CNPJ

~~~text
Documento informado
→ remover máscara
→ verificar quantidade de dígitos
→ rejeitar sequência inválida
→ validar dígitos verificadores
→ verificar duplicidade na empresa
→ aceitar ou recusar
~~~

Exemplos recusados:

~~~text
CPF: 11111111111
CNPJ: 11111111111111
~~~

---

# Fluxo de Documento Duplicado

~~~text
Usuário informa documento
→ backend normaliza
→ consulta Cliente por empresa + documento
→ ignora registro atual durante edição
→ se existir outro cliente na mesma empresa
   → recusar
   → retornar mensagem amigável
→ se existir somente em outra empresa
   → permitir
~~~

Regra:

~~~text
mesma empresa + mesmo documento
→ proibido

empresa diferente + mesmo documento
→ permitido
~~~

---

# Fluxo de Edição

~~~text
Usuário seleciona cliente
→ clica Editar
→ frontend solicita detalhe
→ backend valida VIEW
→ backend valida empresa
→ formulário é preenchido
→ usuário altera campos permitidos
→ frontend envia payload
→ backend valida EDIT
→ backend protege empresa
→ backend protege cliente padrão
→ backend protege ciclo de vida
→ backend valida documento
→ backend salva alterações
→ Auditoria registra campos alterados
→ frontend atualiza lista
~~~

Não devem ser alterados diretamente pelo formulário comum:

- empresa;
- cliente padrão;
- ativo;
- bloqueio;
- responsável pelo bloqueio;
- data de bloqueio;
- campos internos de Auditoria.

---

# Fluxo de Consulta

~~~text
Usuário seleciona cliente
→ clica Consultar
→ frontend solicita detalhe
→ backend valida empresa
→ backend retorna cadastro e indicadores
→ frontend abre consulta
→ área inicial Dados cadastrais
→ Histórico pode ser carregado
→ Compras são carregadas sob demanda
~~~

Áreas:

~~~text
Dados cadastrais
Compras
Histórico
~~~

---

# Fluxo de Dados Cadastrais

~~~text
Abrir Consultar
→ selecionar Dados cadastrais
→ exibir cadastro
→ exibir status
→ exibir bloqueio
→ exibir indicadores comerciais
~~~

Indicadores:

- Última compra;
- Total comprado;
- Quantidade de compras;
- Ticket médio.

---

# Fluxo de Cliente Padrão

## Garantia do Cliente Padrão

~~~text
Empresa criada ou verificada
→ serviço procura cliente_padrao
→ se já existe corretamente
   → reutilizar
→ se não existe
   → criar Consumidor Final
→ se houver inconsistência
   → diagnosticar e impedir duplicação
~~~

Dados:

~~~text
Nome: Consumidor Final
Tipo: PF
Documento: 00000000000
cliente_padrao: true
~~~

---

# Fluxo de Proteção do Cliente Padrão

Ao tentar alterar operação protegida:

~~~text
Usuário seleciona Consumidor Final
→ solicita exclusão, bloqueio, inativação ou descaracterização
→ backend identifica cliente_padrao
→ operação é negada
→ mensagem amigável é retornada
→ Auditoria registra negativa quando aplicável
→ cliente permanece intacto
~~~

O frontend deve ocultar ou desabilitar ações incompatíveis, mas o backend é a autoridade final.

---

# Fluxo de Ativação

~~~text
Usuário seleciona cliente inativo
→ clica Ativar
→ modal de confirmação
→ frontend envia ação
→ backend valida EDIT
→ backend valida empresa
→ backend protege cliente padrão conforme regra
→ backend verifica estado atual
→ altera ativo para true
→ registra Auditoria
→ retorna cliente atualizado
→ frontend atualiza lista e indicadores
~~~

Resultado:

- cliente permanece com histórico;
- cliente pode voltar ao PDV se não estiver bloqueado.

---

# Fluxo de Inativação

~~~text
Usuário seleciona cliente ativo
→ clica Inativar
→ confirma operação
→ backend valida EDIT
→ backend valida empresa
→ backend impede inativação do cliente padrão
→ altera ativo para false
→ preserva vendas e vínculos
→ registra Auditoria
→ frontend atualiza estado
~~~

Cliente inativo:

- não pode ser utilizado em nova venda;
- permanece consultável;
- pode ser reativado.

---

# Fluxo de Bloqueio

~~~text
Usuário seleciona cliente desbloqueado
→ clica Bloquear
→ modal solicita motivo
→ observação pode ser informada
→ frontend valida motivo
→ envia ação
→ backend valida EDIT
→ backend valida empresa
→ backend impede bloqueio do cliente padrão
→ backend valida motivo
→ grava bloqueio
→ grava motivo
→ grava observação
→ grava usuário responsável
→ grava data e hora
→ registra Auditoria
→ retorna cliente atualizado
→ frontend atualiza lista
~~~

---

# Fluxo de Desbloqueio

~~~text
Usuário seleciona cliente bloqueado
→ clica Desbloquear
→ confirma
→ backend valida EDIT
→ backend valida empresa
→ remove restrição atual
→ preserva histórico do bloqueio
→ registra Auditoria
→ frontend atualiza lista
~~~

---

# Fluxo de Elegibilidade no PDV

~~~text
PDV recebe cliente selecionado
→ backend valida empresa do cliente
→ backend valida ativo
→ backend valida bloqueio
→ se todas as regras forem válidas
   → aceitar cliente
→ caso contrário
   → recusar com mensagem clara
~~~

Regra:

~~~text
mesma empresa
e ativo = true
e bloqueio = false
→ permitido
~~~

---

# Fluxo de Venda Sem Cliente Identificado

~~~text
Abrir nova venda
→ nenhum cliente comum selecionado
→ localizar Consumidor Final da empresa
→ validar cliente padrão
→ associar à venda
→ adicionar itens
→ receber pagamentos
→ finalizar venda
→ venda permanece vinculada ao Consumidor Final
→ indicadores do Consumidor Final são atualizados
~~~

A venda não deve ficar sem cliente.

---

# Fluxo de Venda com Cliente Identificado

~~~text
Abrir nova venda
→ Consumidor Final pode estar inicialmente selecionado
→ usuário pesquisa cliente
→ cliente é encontrado na empresa atual
→ backend valida ativo e bloqueio
→ substituir Consumidor Final pelo cliente
→ finalizar venda
→ venda fica vinculada ao cliente identificado
→ indicadores do cliente são atualizados
→ Consumidor Final não recebe essa venda
~~~

---

# Fluxo de Cliente Bloqueado no PDV

~~~text
Selecionar cliente bloqueado
→ backend detecta bloqueio
→ operação é recusada
→ mensagem informa restrição
→ venda não é vinculada
→ sistema não troca silenciosamente para Consumidor Final
→ indicadores não são alterados
~~~

---

# Fluxo de Cliente Inativo no PDV

~~~text
Selecionar cliente inativo
→ backend detecta inatividade
→ operação é recusada
→ mensagem informa situação
→ venda não é vinculada
→ indicadores não são alterados
~~~

---

# Fluxo de Cliente de Outra Empresa no PDV

~~~text
PDV da Empresa 1 recebe ID de cliente da Empresa 2
→ backend aplica escopo da Empresa 1
→ cliente não é localizado no escopo
→ retornar 404 ou negativa controlada
→ venda não é criada com vínculo cruzado
~~~

---

# Fluxo de Compras do Cliente

~~~text
Usuário abre Consultar
→ seleciona aba Compras
→ frontend verifica se já carregou
→ envia cliente, page, page_size e filtros
→ backend valida VIEW
→ backend valida empresa
→ backend filtra VendaPdv por cliente e empresa
→ aplica status, datas, loja e ordenação
→ agrega itens e pagamentos sem duplicação
→ pagina resultado
→ retorna compras
→ frontend apresenta tabela
~~~

Endpoint:

~~~text
GET /api/cadastros/clientes/{id}/compras/
~~~

---

# Fluxo de Carregamento Sob Demanda

~~~text
Abrir consulta
→ permanecer em Dados cadastrais
→ não carregar Compras ainda
→ usuário seleciona Compras
→ solicitar endpoint
→ guardar estado da página
~~~

Objetivos:

- evitar requisições desnecessárias;
- manter lista leve;
- evitar carregar vendas de todos os clientes;
- reduzir risco de N+1.

---

# Fluxo de Filtro de Compras

~~~text
Usuário altera status ou data
→ frontend atualiza filtro
→ comprasPage volta para 1
→ frontend solicita endpoint
→ backend aplica filtros
→ retorna página filtrada
→ tabela e total são atualizados
~~~

Filtros atuais podem incluir:

- data inicial;
- data final;
- status;
- loja;
- ordenação.

---

# Fluxo da Paginação de Compras

~~~text
Usuário avança página
→ frontend mantém filtros de Compras
→ solicita nova página
→ backend retorna página
→ intervalo Mostrando X–Y de Z é atualizado
~~~

Essa paginação não altera:

- página da lista de Clientes;
- página do Histórico.

---

# Fluxo de Estado Vazio de Compras

~~~text
Endpoint retorna count = 0
→ não há erro
→ frontend exibe:
Nenhuma compra encontrada para este cliente.
~~~

Não confundir:

~~~text
lista vazia
≠
erro de API
~~~

---

# Fluxo de Erro em Compras

~~~text
Endpoint falha
→ frontend encerra loading
→ mantém erro separado
→ exibe mensagem
→ não apresenta estado vazio falso
→ permite Atualizar
~~~

---

# Fluxo dos Indicadores Comerciais

~~~text
Consultar detalhe do cliente
→ backend identifica empresa e cliente
→ busca vendas FINALIZADA
→ identifica última data
→ soma total válido
→ conta vendas válidas
→ reduz devoluções finalizadas
→ calcula ticket médio
→ retorna indicadores
→ frontend apenas formata
~~~

Indicadores:

~~~text
ultima_compra
total_comprado
quantidade_compras
ticket_medio
~~~

---

# Fluxo da Última Compra

~~~text
Selecionar vendas do cliente e da empresa
→ considerar status FINALIZADA
→ ordenar por data_venda
→ obter maior data
→ retornar data
~~~

Sem venda válida:

~~~text
ultima_compra = null
~~~

Frontend:

~~~text
Nenhuma compra
~~~

---

# Fluxo do Total Comprado

~~~text
Selecionar vendas FINALIZADA
→ somar valor final
→ localizar devoluções FINALIZADA
→ somar credito_cliente
→ subtrair devoluções
→ retornar total líquido
~~~

Vendas canceladas não entram.

---

# Fluxo da Quantidade de Compras

~~~text
Selecionar VendaPdv
→ filtrar cliente
→ filtrar empresa
→ filtrar FINALIZADA
→ contar vendas
~~~

Não contar:

- itens;
- pagamentos;
- devoluções;
- vendas canceladas.

---

# Fluxo do Ticket Médio

~~~text
Se quantidade_compras > 0
→ total_comprado / quantidade_compras

Se quantidade_compras = 0
→ ticket_medio = 0
~~~

---

# Fluxo de Venda Cancelada

~~~text
Venda finalizada é cancelada
→ status muda para CANCELADA
→ vínculo com cliente é preservado
→ venda continua em Compras
→ situação aparece como Cancelada
→ venda deixa de participar dos indicadores
~~~

---

# Fluxo de Devolução

~~~text
Venda pertence ao cliente
→ devolução é criada
→ devolução é finalizada
→ crédito ao cliente é definido
→ venda permanece
→ devolução aparece na situação comercial
→ total comprado é reduzido
→ vínculo impede exclusão física
~~~

---

# Fluxo de Histórico do Cliente

~~~text
Usuário abre Consultar
→ seleciona Histórico
→ frontend solicita endpoint paginado
→ backend valida VIEW
→ backend valida empresa
→ consulta AuditLog do cliente
→ transforma ação em descrição amigável
→ remove dados sensíveis desnecessários
→ retorna eventos paginados
→ frontend apresenta lista
~~~

Endpoint:

~~~text
GET /api/cadastros/clientes/{id}/historico/
~~~

---

# Separação entre Compras e Histórico

~~~text
Compras
→ VendaPdv e domínio comercial

Histórico
→ AuditLog e ações administrativas
~~~

Não inserir vendas artificialmente no Histórico.

Não inserir ações cadastrais na tabela de Compras.

---

# Fluxo de Exclusão sem Vínculos

~~~text
Usuário seleciona cliente comum
→ clica Excluir
→ modal solicita confirmação
→ usuário confirma
→ frontend ativa exclusaoSaving
→ botões são desabilitados
→ backend valida EDIT
→ backend valida empresa
→ backend protege cliente padrão
→ backend verifica vínculos
→ nenhum vínculo encontrado
→ cliente é excluído
→ Auditoria registra CLIENT_DELETED
→ backend retorna 204
→ modal fecha
→ seleção é limpa
→ lista é atualizada
→ indicadores são atualizados
→ mensagem de sucesso aparece
~~~

---

# Fluxo de Exclusão com Vínculos Conhecidos

~~~text
Usuário confirma exclusão
→ backend valida cliente
→ verifica vendas
→ verifica devoluções
→ verifica cashback
→ verifica vale-troca
→ verifica contas a receber
→ encontra vínculo
→ registra CLIENT_DELETE_DENIED
→ retorna 400 com detail amigável
→ frontend fecha modal
→ mantém cliente selecionado
→ apresenta mensagem
→ ação Inativar permanece disponível
~~~

Mensagem:

~~~text
Este cliente possui vendas ou outros registros vinculados e não pode ser excluído. Utilize a inativação.
~~~

---

# Fluxo de ProtectedError

~~~text
Pré-verificação não localiza vínculo
→ tentativa de delete é executada
→ Django lança ProtectedError
→ exceção é capturada
→ detalhes técnicos são descartados
→ CLIENT_DELETE_DENIED é registrado
→ resposta 400 amigável é retornada
~~~

Não expor:

- nome do model;
- constraint;
- stack trace;
- mensagem técnica.

---

# Fluxo de IntegrityError

~~~text
Tentativa de delete
→ banco rejeita integridade
→ IntegrityError é capturado
→ transação não remove cliente
→ Auditoria de negativa é registrada
→ resposta amigável é retornada
~~~

---

# Fluxo do Frontend na Exclusão Negada

~~~text
API retorna erro
→ exclusaoSaving = false
→ modal fecha
→ cliente permanece selecionado
→ extractApiErrorMessage lê detail
→ alerta global apresenta mensagem
→ botões voltam a funcionar
→ Inativar continua disponível
~~~

Prioridade de mensagem:

~~~text
err.error.detail
err.error.message
err.error.non_field_errors
primeiro erro de campo
err.message
fallback
~~~

Fallback:

~~~text
Não foi possível excluir o cliente. Verifique se existem vendas ou outros registros vinculados. Nesse caso, utilize a inativação.
~~~

---

# Fluxo de Proteção contra Duplo Clique

~~~text
Usuário confirma exclusão
→ exclusaoSaving = true
→ segundo clique ocorre
→ método detecta estado em andamento
→ segunda requisição não é enviada
→ primeira requisição termina
→ exclusaoSaving = false
~~~

---

# Fluxo de Auditoria da Criação

~~~text
Cliente criado
→ capturar empresa
→ capturar usuário
→ capturar objeto
→ registrar CLIENT_CREATED
→ registrar resultado
→ registrar origem
→ registrar correlação quando disponível
~~~

---

# Fluxo de Auditoria da Edição

~~~text
Cliente alterado
→ capturar estado anterior
→ salvar alterações
→ capturar estado posterior
→ identificar campos alterados
→ registrar CLIENT_UPDATED
~~~

Não registrar documento completo desnecessariamente.

---

# Fluxo de Auditoria do Bloqueio

~~~text
Bloqueio confirmado
→ salvar motivo e observação
→ salvar usuário e data
→ registrar CLIENT_BLOCKED
→ disponibilizar evento no Histórico
~~~

---

# Fluxo de Auditoria do Desbloqueio

~~~text
Desbloqueio confirmado
→ retirar restrição
→ preservar histórico anterior
→ registrar CLIENT_UNBLOCKED
~~~

---

# Fluxo de Auditoria da Inativação

~~~text
Inativação confirmada
→ alterar estado
→ registrar CLIENT_DEACTIVATED
→ preservar vínculos
~~~

---

# Fluxo de Auditoria da Ativação

~~~text
Ativação confirmada
→ alterar estado
→ registrar CLIENT_ACTIVATED
~~~

---

# Fluxo de Auditoria da Exclusão Negada

~~~text
Vínculo encontrado ou erro protegido
→ construir mensagem segura
→ registrar CLIENT_DELETE_DENIED
→ incluir motivo seguro
→ incluir impedimentos resumidos quando aplicável
→ retornar negativa
→ exibir Exclusão negada no Histórico
~~~

Apenas um evento deve ser criado por tentativa.

---

# Fluxo de Permissão VIEW

~~~text
Usuário acessa Clientes
→ backend resolve permissão VIEW
→ permite GET
→ lista, pesquisa, consulta, Compras e Histórico são permitidos
→ ações de alteração são recusadas
~~~

No frontend:

- botões de alteração não aparecem ou ficam desabilitados;
- tentativa direta na API continua sendo recusada.

---

# Fluxo de Permissão EDIT

~~~text
Usuário possui EDIT
→ pode criar
→ pode editar
→ pode executar ciclo de vida
→ pode excluir quando a regra permitir
~~~

EDIT não permite:

- ultrapassar escopo de empresa;
- alterar cliente padrão indevidamente;
- excluir cliente com vínculos;
- ignorar regras de documento.

---

# Fluxo Multiempresa de Consulta

~~~text
Usuário da Empresa 1 solicita cliente
→ queryset é filtrado por Empresa 1
→ cliente da Empresa 2 não é localizado
→ retorno controlado
~~~

---

# Fluxo Multiempresa de Documento

~~~text
CPF existe na Empresa 1
→ usuário cria mesmo CPF na Empresa 2
→ consulta de duplicidade usa Empresa 2
→ nenhum conflito local
→ criação permitida
~~~

---

# Fluxo Multiempresa de Compras

~~~text
Cliente pertence à Empresa 1
→ endpoint filtra cliente_id + empresa_id
→ somente VendaPdv da Empresa 1 é retornada
→ vendas da Empresa 2 são ignoradas
~~~

---

# Fluxo Multiempresa do Consumidor Final

~~~text
Venda da Empresa 1 sem cliente
→ localizar Consumidor Final da Empresa 1

Venda da Empresa 2 sem cliente
→ localizar Consumidor Final da Empresa 2
~~~

Não compartilhar o mesmo registro.

---

# Fluxo de Atualização Após Operações

Após criar, editar, ativar, inativar, bloquear, desbloquear ou excluir:

~~~text
operação termina
→ frontend atualiza lista
→ frontend atualiza indicadores
→ seleção é ajustada conforme a ação
→ mensagens são apresentadas
~~~

Após venda, cancelamento ou devolução:

~~~text
usuário reabre ou atualiza consulta
→ backend recalcula indicadores
→ Compras refletem o estado atual
~~~

Não utilizar polling para esse fluxo.

---

# Fluxo de Formatação no Frontend

O frontend pode formatar:

- CPF;
- CNPJ;
- data;
- moeda;
- quantidade;
- status.

O frontend não deve recalcular:

- total comprado;
- ticket médio;
- quantidade real de compras;
- última compra;
- valores líquidos da venda.

---

# Fluxo de Erro de API

~~~text
Backend retorna erro controlado
→ frontend identifica corpo
→ extrai mensagem
→ encerra loading
→ mantém estado seguro
→ apresenta orientação
~~~

Não substituir toda mensagem por:

~~~text
Falha ao executar.
~~~

quando a API fornecer explicação útil.

---

# Fluxo de Segurança de Dados

~~~text
Operação gera Auditoria
→ selecionar somente dados necessários
→ evitar documento completo
→ evitar contatos
→ evitar endereço
→ evitar mensagens técnicas
→ persistir evento seguro
~~~

---

# Fluxo de Testes Backend

Antes de concluir alteração:

~~~text
python manage.py check
→ validar configuração

python manage.py makemigrations --check --dry-run
→ confirmar migrations

python manage.py test cadastros
→ validar módulo

python manage.py test auditoria
→ validar Auditoria

python manage.py test
→ validar regressão geral
~~~

Último resultado registrado:

~~~text
Cadastros: 42/42
Auditoria: 21/21
Suíte geral: 97/97
Falhas: 0
Ignorados: 0
~~~

---

# Fluxo de Testes Frontend

~~~text
npx.cmd tsc -p tsconfig.app.json --noEmit
→ validar TypeScript

ng build --configuration development
→ validar build

ng test --watch=false --browsers=ChromeHeadless
→ validar testes
~~~

Último resultado registrado:

~~~text
Karma: 90/90
Falhas: 0
Ignorados: 0
TypeScript: aprovado
Build: aprovado
~~~

---

# Fluxo de Homologação Manual

A homologação percorreu:

1. abertura da tela;
2. criação de PF;
3. CPF duplicado;
4. criação de PJ;
5. CNPJ duplicado;
6. cliente padrão;
7. bloqueio e desbloqueio;
8. inativação e reativação;
9. Histórico;
10. pesquisa e filtros;
11. paginação;
12. Compras e indicadores;
13. exclusão;
14. cliente sem documento;
15. documentos inválidos;
16. mesmo documento em empresas diferentes;
17. permissões;
18. Consumidor Final no PDV;
19. cliente identificado no PDV;
20. cliente bloqueado ou inativo no PDV;
21. Auditoria Central;
22. consistência dos indicadores;
23. regressão final.

Resultado:

~~~text
APROVADO
~~~

---

# Fluxos que Não Devem Ser Criados

Não implementar:

~~~text
alteração direta de ativo pelo formulário
alteração direta de bloqueio pelo formulário
cliente global entre empresas
Consumidor Final global
venda sem cliente
exclusão em cascata de vendas
Histórico paralelo fora da Auditoria
Compras obtidas do AuditLog
indicadores calculados pela página atual
aceitação de cliente inativo no PDV
aceitação de cliente bloqueado no PDV
mensagens técnicas de banco ao usuário
~~~

---

# Pontos de Atenção para Evoluções

## Nova relação com Cliente

Ao criar novo model relacionado:

~~~text
novo vínculo
→ definir empresa
→ validar isolamento
→ definir on_delete
→ decidir se impede exclusão
→ atualizar pré-check
→ criar teste
→ atualizar documentação
~~~

## Nova operação comercial

~~~text
nova operação
→ decidir impacto nos indicadores
→ decidir exibição em Compras
→ decidir impacto em exclusão
→ decidir Auditoria
→ testar cancelamento e estorno
~~~

## Nova rota de detalhe de venda

~~~text
localizar tela oficial
→ definir permissão
→ definir rota
→ retornar pode_consultar_venda
→ habilitar botão
→ testar acesso entre empresas
~~~

---

# Limitações Atuais

Permanecem pendentes:

- rota frontend consolidada para consultar venda;
- remoção futura do campo legado `cpf`;
- testes manuais de todos os relacionamentos fiscais;
- testes manuais de todos os relacionamentos financeiros;
- eventual serviço dedicado aos indicadores comerciais.

---

# Documentos Relacionados

~~~text
10 Projetos\Sysvar\Sysvar.md
10 Projetos\Sysvar\Contexto do Projeto\Visão Geral.md
10 Projetos\Sysvar\Contexto do Projeto\Arquitetura.md
10 Projetos\Sysvar\Contexto do Projeto\Modelo de Domínio.md
10 Projetos\Sysvar\Contexto do Projeto\Modelo de Domínio - Cadastros - Clientes.md
10 Projetos\Sysvar\Contexto do Projeto\Mapa Técnico.md
10 Projetos\Sysvar\Contexto do Projeto\Mapa Técnico - Cadastros - Clientes.md
10 Projetos\Sysvar\Contexto do Projeto\Workflows.md
10 Projetos\Sysvar\Contexto do Projeto\Riscos e Cuidados.md
10 Projetos\Sysvar\Homologações\Homologação - Cadastros - Clientes.md
10 Projetos\Sysvar\Decisões Técnicas\ADR-003 - Auditoria Central do SISVAR.md
~~~

---

# Checklist de Alteração

Antes de concluir qualquer mudança em Clientes:

- [ ] empresa foi validada;
- [ ] permissão foi validada no backend;
- [ ] cliente padrão permanece protegido;
- [ ] documento vazio continua permitido;
- [ ] CPF/CNPJ continuam únicos por empresa;
- [ ] mass assignment continua bloqueado;
- [ ] ciclo de vida utiliza ações próprias;
- [ ] cliente inativo é recusado no PDV;
- [ ] cliente bloqueado é recusado no PDV;
- [ ] Compras continuam isoladas;
- [ ] indicadores continuam coerentes;
- [ ] vendas canceladas continuam fora dos indicadores;
- [ ] devoluções continuam consideradas;
- [ ] exclusão preserva vínculos;
- [ ] Auditoria não duplica eventos;
- [ ] dados sensíveis não são expostos;
- [ ] paginações continuam independentes;
- [ ] testes foram executados;
- [ ] documentação foi atualizada.

---

# Estado Final

Módulo:

~~~text
Cadastros > Clientes
~~~

Status:

~~~text
HOMOLOGADO
DOCUMENTADO
APROVADO
~~~

Próximo item do grupo Cadastros:

~~~text
Fornecedores
~~~