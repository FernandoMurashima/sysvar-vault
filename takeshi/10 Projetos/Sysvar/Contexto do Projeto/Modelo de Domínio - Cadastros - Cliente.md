
---
type: domain-model
status: active
project: Sysvar
group: Cadastros
module: Clientes
created: 2026-08-06
updated: 2026-08-06
tags:
  - sysvar
  - domínio
  - cadastros
  - clientes
  - multiempresa
  - vendas
  - pdv
  - auditoria
  - homologado
---

# Modelo de Domínio - Cadastros - Clientes

## Objetivo

Este documento descreve o domínio funcional do módulo:

~~~text
Cadastros > Clientes
~~~

Ele registra:

- significado da entidade Cliente;
- relacionamento com Empresa;
- documento funcional;
- pessoa física e pessoa jurídica;
- cliente padrão;
- ciclo de vida;
- vendas;
- indicadores comerciais;
- exclusão;
- permissões;
- integração com o PDV;
- Auditoria Central;
- regras de integridade e isolamento.

Este documento representa a visão funcional do domínio.

Ele não substitui:

- models Django;
- serializers;
- viewsets;
- migrations;
- contratos reais da API;
- código Angular;
- testes automatizados.

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

Documento de homologação relacionado:

~~~text
10 Projetos\Sysvar\Homologações\Homologação - Cadastros - Clientes.md
~~~

Mapa técnico relacionado:

~~~text
10 Projetos\Sysvar\Contexto do Projeto\Mapa Técnico - Cadastros - Clientes.md
~~~

---

# Contexto do Domínio

O Cliente representa a pessoa física ou jurídica que pode se relacionar comercialmente com uma empresa do SISVAR.

O cliente pode participar de operações como:

- venda no PDV;
- emissão fiscal;
- devolução;
- cashback;
- vale-troca;
- contas a receber;
- campanhas;
- consultas comerciais;
- relatórios;
- indicadores de relacionamento.

O Cliente não é um cadastro global da plataforma.

Ele pertence a uma empresa específica.

---

# Entidade Principal

Entidade:

~~~text
Cliente
~~~

Responsabilidade:

- identificar o comprador;
- armazenar dados cadastrais;
- armazenar contatos;
- armazenar endereço;
- indicar situação operacional;
- participar de vendas;
- acumular histórico comercial;
- permitir consulta de compras;
- permitir cálculo de indicadores;
- preservar vínculos fiscais e financeiros.

---

# Relacionamento com Empresa

Todo Cliente pertence a uma Empresa.

Relacionamento:

~~~text
Empresa 1 --- N Clientes
~~~

Regra obrigatória:

~~~text
cliente.empresa_id == empresa atual
~~~

Consequências:

- um cliente da Empresa 1 não pertence à Empresa 2;
- clientes de empresas diferentes podem ter o mesmo CPF;
- clientes de empresas diferentes podem ter o mesmo CNPJ;
- compras não podem ser compartilhadas entre empresas;
- Histórico não pode ser compartilhado entre empresas;
- indicadores comerciais não podem agregar dados de outra empresa;
- Consumidor Final é individual por empresa.

---

# Identidade do Cliente

A identidade funcional do cliente é formada por:

~~~text
Empresa
Tipo de pessoa
Documento, quando informado
Nome
~~~

O ID interno não representa identidade comercial global.

O mesmo documento pode gerar IDs diferentes em empresas diferentes.

---

# Tipos de Cliente

O módulo aceita:

~~~text
PF - Pessoa Física
PJ - Pessoa Jurídica
~~~

O tipo de pessoa é explícito.

Ele não deve ser inferido exclusivamente pelo tamanho do documento.

---

# Pessoa Física

Pessoa Física pode possuir:

- nome;
- apelido;
- CPF;
- data de nascimento;
- contatos;
- endereço;
- categoria;
- consentimentos;
- situação ativa;
- situação de bloqueio.

O CPF pode ser omitido para clientes comuns.

Quando informado, deve ser válido.

---

# Pessoa Jurídica

Pessoa Jurídica pode possuir:

- razão social ou nome do cliente;
- nome fantasia ou apelido;
- CNPJ;
- contatos;
- endereço;
- categoria;
- consentimentos;
- situação ativa;
- situação de bloqueio.

Quando informado, o CNPJ deve ser válido.

---

# Documento Funcional

O campo funcional oficial é:

~~~text
documento
~~~

Esse campo representa:

~~~text
CPF para Pessoa Física
CNPJ para Pessoa Jurídica
~~~

O campo legado:

~~~text
cpf
~~~

permanece temporariamente no backend apenas para compatibilidade.

Novos fluxos devem utilizar `documento`.

---

# Normalização do Documento

Antes da validação e persistência, o documento deve ser normalizado.

Exemplo:

~~~text
529.982.247-25
→
52998224725
~~~

Exemplo:

~~~text
11.222.333/0001-81
→
11222333000181
~~~

A máscara é apenas visual.

A regra funcional utiliza os dígitos normalizados.

---

# Validação do Documento

## Pessoa Física

Quando informado, o CPF deve:

- possuir 11 dígitos;
- passar na validação dos dígitos verificadores;
- não ser uma sequência repetida inválida.

Exemplo inválido:

~~~text
11111111111
~~~

## Pessoa Jurídica

Quando informado, o CNPJ deve:

- possuir 14 dígitos;
- passar na validação dos dígitos verificadores;
- não ser uma sequência repetida inválida.

Exemplo inválido:

~~~text
11111111111111
~~~

---

# Cliente Sem Documento

Um cliente comum pode ser cadastrado sem CPF ou CNPJ.

Regras:

- documento vazio é permitido;
- mais de um cliente sem documento pode existir na mesma empresa;
- documento vazio não identifica Consumidor Final;
- documento vazio não deve ser convertido para `00000000000`;
- o cliente não deve ser marcado automaticamente como padrão.

Exemplo:

~~~text
Nome: Cliente Sem Documento
Tipo: PF
Documento: vazio
cliente_padrao: false
~~~

---

# Unicidade do Documento

A unicidade é aplicada somente quando o documento estiver preenchido.

Regra:

~~~text
Empresa + Documento
~~~

Exemplo permitido:

~~~text
Empresa 1
CPF 52998224725

Empresa 2
CPF 52998224725
~~~

Exemplo proibido:

~~~text
Empresa 1
CPF 52998224725

Empresa 1
CPF 52998224725
~~~

A mesma regra vale para CNPJ.

---

# Cliente Padrão

Cada Empresa deve possuir exatamente um Cliente padrão.

Nome funcional:

~~~text
Consumidor Final
~~~

Dados obrigatórios:

~~~text
Tipo: PF
Documento: 00000000000
cliente_padrao: true
~~~

Relacionamento:

~~~text
Empresa 1 --- 1 Consumidor Final
Empresa 2 --- 1 Consumidor Final
~~~

Não existe Consumidor Final global.

---

# Finalidade do Cliente Padrão

O Cliente padrão representa vendas nas quais o consumidor não foi identificado individualmente.

Exemplos:

- venda rápida no balcão;
- cliente não deseja informar CPF;
- venda sem cadastro individual;
- operação de varejo comum.

A venda não deve ficar sem cliente.

Ela deve ser vinculada ao Consumidor Final da empresa atual.

---

# Proteções do Cliente Padrão

O Consumidor Final não pode ser:

- excluído;
- inativado;
- bloqueado;
- transferido de empresa;
- convertido em Pessoa Jurídica;
- alterado para outro documento;
- desmarcado como cliente padrão;
- criado manualmente em duplicidade.

Essas proteções são regras de domínio.

Elas devem ser impostas pelo backend.

---

# Criação do Cliente Padrão

A criação deve ser:

- automática;
- idempotente;
- isolada por empresa;
- protegida contra duplicação;
- segura em execuções repetidas;
- auditável quando aplicável.

Execuções repetidas do serviço não devem criar múltiplos Consumidores Finais.

---

# Estado do Cliente

O Cliente possui dois eixos operacionais principais:

~~~text
Ativo ou Inativo
Bloqueado ou Desbloqueado
~~~

Esses estados não são equivalentes.

---

# Cliente Ativo

Cliente ativo:

- pode ser pesquisado;
- pode ser consultado;
- pode ser utilizado em vendas, desde que não esteja bloqueado;
- pode receber atualizações cadastrais;
- pode ser bloqueado;
- pode ser inativado.

---

# Cliente Inativo

Cliente inativo:

- permanece cadastrado;
- continua visível em consultas e filtros;
- preserva vendas;
- preserva documentos fiscais;
- preserva devoluções;
- preserva cashback;
- preserva títulos;
- preserva Histórico;
- não pode ser utilizado em nova venda;
- pode ser reativado.

Inativação não é exclusão.

---

# Cliente Desbloqueado

Cliente desbloqueado pode operar normalmente, desde que esteja ativo.

Regra:

~~~text
ativo = true
bloqueio = false
→ cliente elegível para venda
~~~

---

# Cliente Bloqueado

Cliente bloqueado:

- permanece ativo ou inativo conforme seu estado próprio;
- permanece cadastrado;
- preserva seus vínculos;
- não pode ser utilizado em nova venda;
- possui motivo de bloqueio;
- pode possuir observação;
- possui responsável;
- possui data e hora;
- pode ser desbloqueado posteriormente.

---

# Motivo do Bloqueio

O bloqueio exige motivo.

Exemplos funcionais:

- inadimplência;
- fraude;
- cadastro em análise;
- solicitação administrativa;
- documentação pendente;
- restrição comercial.

O motivo deve ser claro e adequado ao uso operacional.

Não registrar dados sensíveis desnecessários.

---

# Observação do Bloqueio

A observação é opcional.

Ela complementa o motivo.

Não deve ser utilizada para armazenar:

- senha;
- dados bancários sensíveis;
- documentos completos desnecessários;
- informações pessoais excessivas;
- dados sem finalidade operacional.

---

# Ações de Ciclo de Vida

O ciclo de vida é controlado por ações próprias:

~~~text
Ativar
Inativar
Bloquear
Desbloquear
~~~

Não deve ser controlado por edição direta de checkboxes no formulário comum.

---

# Ativação

A ativação:

- altera o cliente para ativo;
- preserva o histórico anterior;
- registra usuário;
- registra data e hora;
- registra Auditoria;
- permite uso em vendas quando não houver bloqueio.

---

# Inativação

A inativação:

- altera o cliente para inativo;
- não exclui o registro;
- preserva vínculos;
- registra usuário;
- registra data e hora;
- registra Auditoria;
- impede nova venda.

---

# Bloqueio

O bloqueio:

- exige motivo;
- aceita observação;
- registra usuário;
- registra data e hora;
- registra Auditoria;
- impede nova venda;
- não remove vendas anteriores.

---

# Desbloqueio

O desbloqueio:

- remove a restrição operacional;
- preserva o evento de bloqueio;
- registra usuário;
- registra data e hora;
- registra Auditoria;
- permite nova venda quando o cliente estiver ativo.

---

# Transições Permitidas

~~~text
Ativo
→ Inativo

Inativo
→ Ativo

Desbloqueado
→ Bloqueado

Bloqueado
→ Desbloqueado
~~~

Cliente padrão não participa das transições que o descaracterizem ou impeçam seu uso no PDV.

---

# Elegibilidade para Venda

Um Cliente identificado pode ser utilizado em nova venda quando:

~~~text
pertence à empresa atual
e
ativo = true
e
bloqueio = false
~~~

O backend da venda deve validar novamente essas condições.

Não confiar exclusivamente na interface.

---

# Integração com o PDV

## Venda sem cliente identificado

Fluxo:

~~~text
Abrir venda
→ nenhum cliente identificado
→ selecionar Consumidor Final da empresa
→ registrar venda
~~~

A venda não deve ficar com cliente nulo.

---

## Venda com cliente identificado

Fluxo:

~~~text
Abrir venda
→ Consumidor Final inicialmente selecionado
→ localizar cliente
→ validar empresa
→ validar ativo
→ validar bloqueio
→ substituir Consumidor Final
→ finalizar venda
~~~

A venda passa a pertencer ao cliente identificado.

---

# Cliente de Outra Empresa no PDV

Um Cliente de outra empresa não pode ser utilizado.

Regra:

~~~text
cliente.empresa_id != venda.empresa_id
→ operação negada
~~~

O sistema não deve:

- aceitar o cliente;
- copiar o cliente automaticamente;
- misturar dados;
- alterar a empresa da venda;
- criar vínculo cruzado.

---

# Cliente Bloqueado no PDV

Ao tentar utilizar Cliente bloqueado:

- a operação deve ser recusada;
- deve aparecer mensagem clara;
- a venda não deve ser criada para esse cliente;
- o sistema não deve trocar silenciosamente para Consumidor Final;
- os indicadores não devem ser alterados.

---

# Cliente Inativo no PDV

Ao tentar utilizar Cliente inativo:

- a operação deve ser recusada;
- deve aparecer mensagem clara;
- a venda não deve ser criada para esse cliente;
- o sistema não deve ignorar o estado;
- os indicadores não devem ser alterados.

---

# Relacionamento com Venda

Relacionamento principal:

~~~text
Cliente 1 --- N VendaPdv
~~~

Cada VendaPdv possui um Cliente.

O Cliente pode possuir várias vendas.

A venda pertence à mesma Empresa do Cliente.

---

# Relacionamento com Itens da Venda

Estrutura:

~~~text
Cliente
→ VendaPdv
→ VendaPdvItem
~~~

Os itens pertencem à venda.

A consulta comercial do cliente pode consolidar a quantidade total dos itens vendidos.

---

# Relacionamento com Pagamentos

Estrutura:

~~~text
Cliente
→ VendaPdv
→ VendaPdvPagamento
~~~

Uma venda pode possuir:

- uma forma de pagamento;
- várias formas de pagamento.

Quando houver mais de uma, a apresentação pode utilizar:

~~~text
Múltiplas
~~~

---

# Relacionamento com Devolução

Estrutura:

~~~text
Cliente
→ VendaPdv
→ VendaDevolucao
~~~

A devolução:

- não apaga a venda original;
- preserva o histórico;
- pode reduzir o total comprado;
- permanece vinculada ao cliente;
- impede exclusão física quando aplicável.

---

# Relacionamento com Cashback

Estrutura funcional:

~~~text
Cliente 1 --- N CashbackMovimento
~~~

Movimentos de cashback devem:

- pertencer à mesma empresa;
- permanecer vinculados;
- impedir exclusão física do cliente;
- preservar histórico financeiro.

---

# Relacionamento com Vale-Troca

Estrutura funcional:

~~~text
Cliente 1 --- N ValeTroca
~~~

O vale-troca deve:

- pertencer à empresa do cliente;
- preservar o vínculo;
- impedir exclusão física;
- ser considerado em fluxos futuros de venda e devolução.

---

# Relacionamento com Contas a Receber

Estrutura funcional:

~~~text
Cliente 1 --- N Títulos a Receber
~~~

Títulos financeiros vinculados:

- preservam o cliente;
- impedem exclusão física;
- continuam existentes após inativação;
- não devem ser apagados por alteração cadastral.

---

# Compras do Cliente

As Compras representam as vendas vinculadas ao Cliente.

Origem:

~~~text
fiscal.VendaPdv
~~~

Compras não são eventos de Auditoria.

---

# Consulta de Compras

A consulta pode apresentar:

- data;
- número da venda;
- documento;
- loja;
- vendedor;
- quantidade de itens;
- valor bruto;
- desconto;
- valor final;
- forma de pagamento;
- situação;
- acesso ao detalhe da venda.

A consulta é paginada.

Ela deve respeitar a Empresa atual.

---

# Status das Compras

## Finalizada

Venda finalizada:

- aparece na consulta;
- participa dos indicadores;
- compõe quantidade de compras;
- pode definir a última compra.

## Cancelada

Venda cancelada:

- permanece na consulta;
- aparece identificada como cancelada;
- não participa dos indicadores;
- preserva o vínculo histórico.

## Devolvida

Venda devolvida:

- permanece na consulta;
- aparece identificada;
- reduz o valor comprado conforme a devolução;
- preserva a venda original.

---

# Indicadores Comerciais

O Cliente possui indicadores derivados de suas vendas.

Indicadores homologados:

~~~text
Última compra
Total comprado
Quantidade de compras
Ticket médio
~~~

Esses valores não são editados manualmente.

Eles são calculados no backend.

---

# Última Compra

Representa a data da venda finalizada mais recente.

Regra:

~~~text
máxima data_venda
entre vendas FINALIZADA
do cliente
da empresa atual
~~~

Quando não houver compra válida:

~~~text
ultima_compra = null
~~~

Apresentação:

~~~text
Nenhuma compra
~~~

---

# Total Comprado

Representa o valor líquido comercial válido do Cliente.

Regra atual:

~~~text
Soma das vendas FINALIZADA
menos devoluções FINALIZADA
~~~

Vendas canceladas não participam.

O valor de devolução atualmente considerado utiliza:

~~~text
VendaDevolucao.credito_cliente
~~~

---

# Quantidade de Compras

Representa a quantidade de vendas finalizadas.

Regra:

~~~text
COUNT de VendaPdv com status FINALIZADA
~~~

Não contar:

- canceladas;
- linhas dos itens;
- pagamentos;
- devoluções como novas compras.

---

# Ticket Médio

Cálculo:

~~~text
total_comprado / quantidade_compras
~~~

Quando a quantidade for zero:

~~~text
ticket_medio = 0
~~~

---

# Coerência dos Indicadores

Os indicadores devem:

- usar a mesma regra na lista e no detalhe;
- respeitar a empresa;
- ignorar canceladas;
- considerar devoluções;
- evitar duplicação por joins;
- não depender da página atual da tabela;
- não ser calculados no navegador.

---

# Histórico Administrativo

O Histórico do Cliente representa ações sobre o cadastro.

Origem:

~~~text
AuditLog
~~~

Exemplos:

- criação;
- alteração;
- ativação;
- inativação;
- bloqueio;
- desbloqueio;
- exclusão;
- exclusão negada.

---

# Separação entre Histórico e Compras

Regra:

~~~text
Histórico
→ ações administrativas

Compras
→ operações de venda
~~~

Uma venda não deve ser inserida artificialmente no Histórico administrativo.

Uma alteração cadastral não deve ser inserida na tabela de Compras.

---

# Auditoria Central

Eventos relevantes podem incluir:

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

A nomenclatura real do código é a autoridade final.

---

# Conteúdo da Auditoria

Os eventos devem registrar, conforme aplicável:

- empresa;
- usuário;
- data e hora;
- ação;
- resultado;
- origem;
- objeto;
- campos alterados;
- motivo;
- observação;
- correlation ID.

---

# Proteção de Dados na Auditoria

Não registrar desnecessariamente:

- CPF completo;
- CNPJ completo;
- endereço completo;
- telefone;
- e-mail;
- dados financeiros sensíveis;
- stack trace;
- nomes de constraints.

A Auditoria deve cumprir sua finalidade sem expor dados além do necessário.

---

# Consulta do Cliente

A consulta está organizada em:

~~~text
Dados cadastrais
Compras
Histórico
~~~

Cada área representa uma responsabilidade diferente.

---

# Dados Cadastrais

Podem incluir:

- nome;
- apelido;
- tipo;
- documento;
- contatos;
- endereço;
- categoria;
- consentimentos;
- estado ativo;
- bloqueio;
- responsável pelo bloqueio;
- indicadores comerciais.

---

# Compras

Inclui:

- vendas;
- cancelamentos;
- devoluções;
- valores;
- vendedor;
- loja;
- pagamentos;
- paginação;
- filtros.

---

# Histórico

Inclui:

- eventos administrativos;
- usuário;
- data;
- resultado;
- motivo;
- observação;
- origem;
- paginação.

---

# Exclusão Física

A exclusão física é permitida apenas para Cliente comum sem vínculos.

Exemplo permitido:

~~~text
Cliente criado para teste
sem venda
sem devolução
sem cashback
sem vale-troca
sem título financeiro
sem documento fiscal vinculado
~~~

---

# Cliente com Vínculos

Cliente com vínculos não pode ser excluído.

Vínculos conhecidos:

- venda;
- devolução;
- cashback;
- vale-troca;
- conta a receber;
- documento fiscal;
- outros relacionamentos protegidos.

A alternativa é:

~~~text
Inativar
~~~

---

# Mensagem de Exclusão Negada

Mensagem oficial:

~~~text
Este cliente possui vendas ou outros registros vinculados e não pode ser excluído. Utilize a inativação.
~~~

A resposta não deve expor detalhes técnicos.

---

# Exclusão Negada

Quando a exclusão é recusada:

- o Cliente permanece;
- as vendas permanecem;
- os demais vínculos permanecem;
- a seleção pode permanecer na interface;
- a ação Inativar continua disponível;
- a Auditoria registra a negativa;
- o Histórico apresenta Exclusão negada.

---

# Cliente Padrão e Exclusão

O Consumidor Final não pode ser excluído, mesmo sem vendas.

A proteção decorre de sua função estrutural dentro da Empresa.

---

# Permissões

## VIEW

Permite:

- listar;
- pesquisar;
- filtrar;
- consultar;
- visualizar Dados cadastrais;
- visualizar Compras;
- visualizar Histórico.

## EDIT

Permite, conforme demais regras:

- criar;
- editar;
- ativar;
- inativar;
- bloquear;
- desbloquear;
- excluir quando permitido.

---

# Autoridade das Permissões

O backend é a autoridade final.

O frontend pode:

- ocultar;
- desabilitar;
- orientar.

O frontend não pode substituir a validação do backend.

---

# Pesquisa

A pesquisa pode considerar:

- nome;
- apelido;
- CPF;
- CNPJ;
- documento normalizado.

A pesquisa deve respeitar a Empresa atual.

---

# Filtros

Filtros homologados incluem:

- Pessoa Física;
- Pessoa Jurídica;
- ativo;
- inativo;
- bloqueado;
- desbloqueado;
- estado;
- documento;
- nome.

A combinação de filtros não pode misturar empresas.

---

# Paginação

Existem paginações independentes para:

~~~text
Lista de Clientes
Compras
Histórico
~~~

Alterar uma paginação não deve alterar as demais.

---

# Indicadores da Listagem

Os indicadores gerais da tela de Clientes representam a carteira da Empresa atual.

Eles não devem ser calculados apenas sobre a página exibida.

Exemplos:

- total;
- ativos;
- inativos;
- bloqueados;
- Pessoa Física;
- Pessoa Jurídica.

---

# Consistência Multiempresa

Toda operação deve responder:

~~~text
Qual é a Empresa atual?
O Cliente pertence a essa Empresa?
A Venda pertence à mesma Empresa?
O usuário tem acesso a essa Empresa?
~~~

Na dúvida, a operação deve ser negada.

---

# Regras de Integridade

## Regra 1

~~~text
Cliente sempre pertence a uma Empresa
~~~

## Regra 2

~~~text
Documento preenchido é único por Empresa
~~~

## Regra 3

~~~text
Cliente padrão é único por Empresa
~~~

## Regra 4

~~~text
Cliente padrão não pode ser descaracterizado
~~~

## Regra 5

~~~text
Cliente bloqueado não pode ser usado em nova venda
~~~

## Regra 6

~~~text
Cliente inativo não pode ser usado em nova venda
~~~

## Regra 7

~~~text
Venda e Cliente devem pertencer à mesma Empresa
~~~

## Regra 8

~~~text
Cliente com vínculos não pode ser excluído
~~~

## Regra 9

~~~text
Ciclo de vida utiliza ações próprias
~~~

## Regra 10

~~~text
Compras e Histórico são domínios distintos
~~~

---

# Eventos Importantes

Eventos de domínio relevantes:

~~~text
Cliente criado
Cliente alterado
Cliente ativado
Cliente inativado
Cliente bloqueado
Cliente desbloqueado
Exclusão realizada
Exclusão negada
Venda vinculada
Venda cancelada
Devolução finalizada
~~~

Nem todos precisam ser eventos formais de mensageria.

No estado atual, os eventos administrativos são representados principalmente pela Auditoria Central.

---

# Dependências do Domínio

O Cliente possui dependências com:

~~~text
Empresa
Loja
Usuário
Funcionário ou Vendedor
VendaPdv
VendaPdvItem
VendaPdvPagamento
VendaDevolucao
NFCe
CashbackMovimento
ValeTroca
Contas a Receber
AuditLog
~~~

Os nomes técnicos exatos devem ser confirmados no código atual.

---

# Riscos de Domínio

## Duplicação de Cliente Padrão

Risco:

- duas criações simultâneas;
- importação incorreta;
- criação manual;
- dados antigos inconsistentes.

Controle esperado:

- serviço idempotente;
- validação;
- constraint;
- transação;
- diagnóstico.

---

## Vazamento entre Empresas

Risco:

- consulta por ID sem empresa;
- agregação comercial global;
- PDV utilizando cliente de outra empresa;
- superusuário sem contexto explícito.

Controle esperado:

- queryset por empresa;
- validação no serializer;
- validação no serviço;
- testes multiempresa.

---

## Campo Legado CPF

Risco:

- coexistência entre `cpf` e `documento`;
- payload divergente;
- consumidores antigos;
- dados duplicados.

Controle esperado:

- frontend utiliza somente `documento`;
- backend mantém compatibilidade temporária;
- remoção futura planejada;
- testes antes da remoção.

---

## Indicadores Duplicados por Joins

Risco:

- venda com vários itens;
- venda com vários pagamentos;
- várias devoluções;
- agregações combinadas.

Controle esperado:

- subqueries;
- agregações seguras;
- testes;
- comparação com dados reais.

---

## Exclusão Indevida

Risco:

- relacionamento novo não incluído no pré-check;
- `CASCADE` inadequado;
- exclusão de histórico fiscal.

Controle esperado:

- `PROTECT`;
- verificação de impedimentos;
- tratamento de `ProtectedError`;
- tratamento de `IntegrityError`;
- mensagem amigável;
- Auditoria.

---

## Dados Sensíveis

Risco:

- documento completo no log;
- endereço no AuditLog;
- dados pessoais em mensagens;
- vazamento entre empresas.

Controle esperado:

- minimização;
- mascaramento;
- controle de acesso;
- Auditoria;
- revisão de payloads.

---

# Limitações Atuais

Permanecem pendentes:

- rota frontend consolidada para consultar o detalhe completo da venda;
- remoção futura do campo legado `cpf`;
- testes manuais de todos os tipos possíveis de vínculos fiscais;
- testes manuais de todos os tipos possíveis de vínculos financeiros;
- eventual criação de serviço dedicado aos indicadores comerciais.

Essas limitações não impedem o estado homologado atual.

---

# Documentos Relacionados

~~~text
10 Projetos\Sysvar\Sysvar.md
10 Projetos\Sysvar\Contexto do Projeto\Visão Geral.md
10 Projetos\Sysvar\Contexto do Projeto\Arquitetura.md
10 Projetos\Sysvar\Contexto do Projeto\Modelo de Domínio.md
10 Projetos\Sysvar\Contexto do Projeto\Mapa Técnico.md
10 Projetos\Sysvar\Contexto do Projeto\Mapa Técnico - Cadastros - Clientes.md
10 Projetos\Sysvar\Contexto do Projeto\Workflows.md
10 Projetos\Sysvar\Contexto do Projeto\Riscos e Cuidados.md
10 Projetos\Sysvar\Homologações\Homologação - Cadastros - Clientes.md
10 Projetos\Sysvar\Decisões Técnicas\ADR-003 - Auditoria Central do SISVAR.md
~~~

---

# Regra de Evolução

Toda alteração futura em Clientes deve verificar:

1. o Cliente continua pertencendo a uma Empresa?
2. o documento continua único apenas dentro da Empresa?
3. cliente sem documento continua permitido?
4. Consumidor Final continua único por Empresa?
5. Consumidor Final continua protegido?
6. ciclo de vida continua usando ações próprias?
7. cliente inativo continua impedido no PDV?
8. cliente bloqueado continua impedido no PDV?
9. vendas continuam na mesma Empresa do Cliente?
10. Compras continuam separadas do Histórico?
11. indicadores continuam corretos?
12. exclusão continua preservando vínculos?
13. Auditoria continua protegendo dados sensíveis?
14. permissões continuam validadas no backend?
15. testes e documentação foram atualizados?

---

# Estado Final

Módulo:

~~~text
Cadastros > Clientes
~~~

Situação:

~~~text
HOMOLOGADO
DOCUMENTADO
APROVADO
~~~

Próximo item do grupo Cadastros:

~~~text
Fornecedores
~~~