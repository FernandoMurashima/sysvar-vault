---
type: homologation
status: approved
project: Sysvar
group: Cadastros
module: Clientes
created: 2026-08-06
updated: 2026-08-06
tags:
  - sysvar
  - homologação
  - cadastros
  - clientes
  - multiempresa
  - pdv
  - vendas
  - auditoria
  - aprovado
---

# Homologação - Cadastros - Clientes

## Objetivo

Este documento registra a homologação funcional, técnica e manual do módulo:

~~~text
Cadastros > Clientes
~~~

A homologação foi realizada após:

- análise das regras de negócio;
- revisão do código real;
- implementação e correções pelo Codex;
- revisão dos commits do backend e frontend;
- execução de testes automatizados;
- testes manuais no navegador;
- testes de integração com o PDV;
- validação da Auditoria Central;
- validação do isolamento multiempresa;
- correção das falhas encontradas durante a homologação.

Status final:

~~~text
IMPLEMENTADO
TESTADO AUTOMATICAMENTE
HOMOLOGADO MANUALMENTE
DOCUMENTADO
APROVADO
~~~

---

# Escopo Homologado

Foram homologadas as seguintes funcionalidades:

- cadastro de pessoa física;
- cadastro de pessoa jurídica;
- cadastro de cliente sem documento;
- validação de CPF;
- validação de CNPJ;
- unicidade de CPF/CNPJ por empresa;
- reutilização do mesmo documento em empresas diferentes;
- cliente padrão Consumidor Final;
- pesquisa;
- filtros;
- indicadores da listagem;
- paginação;
- consulta detalhada;
- indicadores comerciais;
- compras do cliente;
- histórico administrativo;
- ativação;
- inativação;
- bloqueio;
- desbloqueio;
- exclusão de cliente sem vínculos;
- impedimento de exclusão de cliente com vínculos;
- permissões;
- integração com o PDV;
- Auditoria Central;
- isolamento multiempresa.

---

# Regras de Negócio Aprovadas

## Documento do cliente

O campo funcional utilizado pelo módulo é:

~~~text
documento
~~~

O campo antigo:

~~~text
cpf
~~~

permanece apenas como compatibilidade técnica temporária no backend.

O frontend não deve manter dois campos de formulário para o mesmo documento.

---

## Tipo de pessoa

O cliente possui tipo explícito:

~~~text
PF - Pessoa Física
PJ - Pessoa Jurídica
~~~

O tipo de pessoa determina:

- máscara do documento;
- validação aplicada;
- descrição apresentada ao usuário.

---

## Unicidade do documento

CPF e CNPJ são únicos por empresa.

Regra:

~~~text
empresa + documento
~~~

Consequências:

- o mesmo CPF não pode ser cadastrado duas vezes na mesma empresa;
- o mesmo CNPJ não pode ser cadastrado duas vezes na mesma empresa;
- o mesmo CPF pode existir em empresas diferentes;
- o mesmo CNPJ pode existir em empresas diferentes;
- clientes sem documento podem ser cadastrados mais de uma vez.

---

## Cliente sem documento

Clientes comuns podem ser cadastrados sem CPF ou CNPJ.

O sistema não deve:

- preencher documento automaticamente;
- transformar o cliente em Consumidor Final;
- utilizar `00000000000`;
- bloquear um segundo cliente também sem documento.

---

# Cliente Padrão

Cada empresa deve possuir exatamente um cliente padrão.

Dados aprovados:

~~~text
Nome: Consumidor Final
Tipo: Pessoa Física
Documento: 00000000000
cliente_padrao: true
~~~

O cliente padrão pertence exclusivamente à sua empresa.

Não existe um Consumidor Final global compartilhado entre empresas.

---

## Proteções do cliente padrão

O cliente padrão não pode ser:

- excluído;
- inativado;
- bloqueado;
- transferido de empresa;
- desmarcado como cliente padrão;
- alterado para Pessoa Jurídica;
- ter o documento alterado;
- ter o indicador `cliente_padrao` removido.

As operações negadas devem apresentar mensagem clara ao usuário e registrar Auditoria quando aplicável.

---

# Ciclo de Vida do Cliente

O ciclo de vida do cliente utiliza ações próprias.

Ações homologadas:

~~~text
Ativar
Inativar
Bloquear
Desbloquear
~~~

Não devem existir campos editáveis diretamente no formulário para:

~~~text
Ativo
Bloqueado
~~~

Esses estados são controlados pelas ações oficiais.

---

## Bloqueio

O bloqueio exige:

- motivo;
- observação opcional;
- usuário responsável;
- data e hora;
- registro no Histórico;
- registro na Auditoria Central.

Cliente bloqueado não pode ser utilizado em nova venda no PDV.

---

## Desbloqueio

O desbloqueio:

- remove o bloqueio operacional;
- preserva o histórico anterior;
- registra usuário;
- registra data e hora;
- registra Auditoria;
- permite novamente o uso do cliente no PDV, desde que esteja ativo.

---

## Inativação

Cliente inativo:

- permanece no banco;
- preserva suas vendas;
- preserva títulos e demais vínculos;
- preserva Histórico e Auditoria;
- não pode ser utilizado em nova venda;
- pode ser reativado posteriormente.

---

## Reativação

A reativação:

- retorna o cliente ao estado ativo;
- não apaga o histórico de inativação;
- registra Auditoria;
- permite novamente o uso no PDV, desde que o cliente não esteja bloqueado.

---

# Organização da Consulta do Cliente

A tela Consultar Cliente foi organizada em três áreas:

~~~text
Dados cadastrais
Compras
Histórico
~~~

As três áreas possuem finalidades diferentes e não devem misturar seus dados.

---

## Dados cadastrais

A área Dados cadastrais apresenta:

- nome;
- apelido;
- tipo de pessoa;
- CPF ou CNPJ;
- telefone;
- celular;
- e-mail;
- endereço;
- categoria;
- consentimentos;
- status;
- situação de bloqueio;
- motivo do bloqueio;
- responsável pelo bloqueio;
- indicadores comerciais.

---

## Compras

A área Compras apresenta as vendas vinculadas ao cliente.

Origem dos dados:

~~~text
fiscal.VendaPdv
~~~

As compras não são obtidas da Auditoria Central.

A tabela pode apresentar:

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
- ação de consulta da venda.

A tabela possui:

- carregamento sob demanda;
- paginação própria;
- quantidade por página;
- filtro por data;
- filtro por situação;
- estado de carregamento;
- mensagem de erro;
- estado vazio;
- botão Atualizar.

Mensagem de estado vazio:

~~~text
Nenhuma compra encontrada para este cliente.
~~~

---

## Histórico

A área Histórico apresenta eventos administrativos do cadastro.

Exemplos:

- criação;
- alteração;
- bloqueio;
- desbloqueio;
- inativação;
- reativação;
- exclusão negada;
- exclusão realizada.

O Histórico não é utilizado para apresentar vendas.

---

# Indicadores Comerciais

Foram homologados os indicadores:

~~~text
Última compra
Total comprado
Quantidade de compras
Ticket médio
~~~

Os indicadores são calculados no backend.

O frontend apenas apresenta os valores recebidos.

---

## Última compra

Representa a data da venda finalizada mais recente do cliente.

Cliente sem vendas apresenta:

~~~text
Nenhuma compra
~~~

---

## Total comprado

Representa o valor líquido considerado das vendas finalizadas.

Vendas canceladas não entram no total.

Devoluções finalizadas reduzem o total pelo valor definido no domínio de devoluções.

A regra atualmente utiliza:

~~~text
VendaDevolucao.credito_cliente
~~~

---

## Quantidade de compras

Representa a quantidade de vendas com status:

~~~text
FINALIZADA
~~~

Vendas canceladas não entram na quantidade.

---

## Ticket médio

Cálculo:

~~~text
total_comprado / quantidade_compras
~~~

Quando não houver compras:

~~~text
0,00
~~~

---

# Endpoint de Compras

Endpoint homologado:

~~~text
GET /api/cadastros/clientes/{id}/compras/
~~~

O endpoint:

- exige permissão VIEW;
- valida a empresa atual;
- impede acesso entre empresas;
- retorna somente vendas do cliente consultado;
- utiliza paginação DRF;
- ordena da compra mais recente para a mais antiga;
- suporta filtros;
- não mistura Histórico com Compras;
- evita carregamento de todas as vendas no frontend.

Formato paginado:

~~~json
{
  "count": 0,
  "next": null,
  "previous": null,
  "results": []
}
~~~

---

# Status das Vendas

As vendas podem aparecer na tabela mesmo quando não participam dos indicadores.

## Venda finalizada

- aparece na tabela;
- participa dos indicadores.

## Venda cancelada

- aparece na tabela;
- é identificada como cancelada;
- não participa dos indicadores.

## Venda devolvida

- aparece identificada conforme o domínio;
- o valor devolvido reduz o total comprado;
- preserva o vínculo histórico com o cliente.

---

# Consulta da Venda

O botão:

~~~text
Consultar venda
~~~

permanece desabilitado enquanto não existir uma rota frontend consolidada para consulta detalhada da venda.

O backend retorna:

~~~text
pode_consultar_venda: false
~~~

Essa situação não impede a homologação da consulta de compras do cliente.

A criação da rota consolidada de detalhe da venda permanece como evolução futura do módulo de Vendas ou Fiscal.

---

# Exclusão do Cliente

## Cliente sem vínculos

Cliente comum sem vendas, títulos ou outros relacionamentos pode ser excluído.

Resultado homologado:

- exclusão realizada;
- registro removido da lista;
- indicadores atualizados;
- seleção limpa;
- evento de exclusão registrado;
- nenhuma resposta 500.

---

## Cliente com vínculos

Cliente com venda ou outro relacionamento não pode ser excluído fisicamente.

Vínculos verificados incluem:

- vendas;
- devoluções;
- cashback;
- vale-troca;
- títulos financeiros;
- relacionamentos protegidos pelo Django;
- relacionamentos protegidos pelo banco de dados.

Mensagem homologada:

~~~text
Este cliente possui vendas ou outros registros vinculados e não pode ser excluído. Utilize a inativação.
~~~

Contrato da resposta:

~~~json
{
  "detail": "Este cliente possui vendas ou outros registros vinculados e não pode ser excluído. Utilize a inativação."
}
~~~

Status:

~~~text
400 Bad Request
~~~

Após a negativa:

- o modal fecha;
- a mensagem aparece de forma visível;
- o cliente continua selecionado;
- o botão Inativar permanece disponível;
- a venda permanece;
- o cliente permanece;
- o loading é encerrado;
- não ocorre exclusão duplicada;
- o Histórico mostra Exclusão negada.

---

# Auditoria da Exclusão Negada

Evento utilizado:

~~~text
CLIENT_DELETE_DENIED
~~~

A tentativa negada registra:

- empresa;
- usuário;
- cliente;
- data e hora;
- motivo;
- resultado negado;
- origem;
- correlação, quando disponível;
- mensagem amigável.

Não são apresentados ao usuário:

- stack trace;
- nome de constraint;
- nome técnico de tabela;
- mensagem de foreign key;
- `ProtectedError`;
- `IntegrityError`.

---

# Permissões

## Usuário com VIEW

O usuário com somente VIEW pode:

- abrir a lista;
- pesquisar;
- filtrar;
- consultar o cliente;
- visualizar Dados cadastrais;
- visualizar Compras;
- visualizar Histórico.

O usuário com somente VIEW não pode:

- criar;
- editar;
- excluir;
- ativar;
- inativar;
- bloquear;
- desbloquear.

O backend permanece como autoridade final das permissões.

---

# Isolamento Multiempresa

Todas as consultas e operações respeitam a empresa atual.

Regras aprovadas:

~~~text
cliente.empresa_id == empresa atual
cliente.empresa_id == venda.empresa_id
~~~

Foi homologado que:

- clientes da Empresa 1 não aparecem na Empresa 2;
- clientes da Empresa 2 não aparecem na Empresa 1;
- o mesmo CPF pode existir nas duas empresas;
- o mesmo CNPJ pode existir nas duas empresas;
- compras não se misturam;
- Histórico não se mistura;
- indicadores não se misturam;
- Consumidor Final não se mistura;
- busca por documento retorna apenas o cliente da empresa atual;
- acesso direto a cliente de outra empresa é negado.

---

# Integração com o PDV

## Venda sem cliente identificado

Ao iniciar uma venda sem selecionar cliente, o PDV utiliza automaticamente:

~~~text
Consumidor Final
~~~

da empresa atual.

A venda:

- não fica sem cliente;
- não utiliza Consumidor Final de outra empresa;
- aparece nas Compras do Consumidor Final;
- atualiza os indicadores desse Consumidor Final.

---

## Venda com cliente identificado

Ao selecionar um cliente comum:

- a venda fica vinculada ao cliente selecionado;
- deixa de pertencer ao Consumidor Final;
- aparece na área Compras do cliente;
- atualiza os indicadores comerciais;
- não atualiza o Consumidor Final;
- não permite cliente de outra empresa;
- não duplica a venda na consulta.

---

## Cliente bloqueado ou inativo no PDV

Cliente bloqueado não pode ser utilizado em nova venda.

Cliente inativo não pode ser utilizado em nova venda.

O PDV:

- apresenta mensagem clara;
- não troca silenciosamente para Consumidor Final;
- não cria venda para o cliente impedido;
- não altera os indicadores comerciais;
- volta a permitir o cliente após desbloqueio e reativação.

---

# Auditoria Central

Foram confirmados eventos relacionados a:

- cliente criado;
- cliente alterado;
- cliente bloqueado;
- cliente desbloqueado;
- cliente inativado;
- cliente reativado;
- exclusão negada;
- cliente excluído.

Os eventos apresentam:

- empresa correta;
- usuário responsável;
- data e hora;
- ação;
- resultado;
- origem;
- identificação do objeto;
- correlação, quando disponível.

Os eventos não devem expor desnecessariamente:

- CPF completo;
- CNPJ completo;
- dados sensíveis;
- mensagens técnicas internas;
- stack trace;
- constraints do banco.

---

# Homologação Manual

## Item 1 - Abertura da tela

Validado:

- carregamento da lista;
- indicadores;
- paginação;
- cliente padrão;
- isolamento da empresa.

Resultado:

~~~text
APROVADO
~~~

---

## Item 2 - Cadastro de Pessoa Física

Cliente utilizado:

~~~text
Mariaa Homologacao
CPF: 52998224725
~~~

Validado:

- cadastro;
- máscara;
- documento funcional;
- exibição na lista;
- consulta.

Resultado:

~~~text
APROVADO
~~~

---

## Item 3 - CPF duplicado na mesma empresa

Validado:

- duplicidade recusada;
- mensagem apresentada;
- nenhum segundo registro criado;
- nenhum erro 500.

Resultado:

~~~text
APROVADO
~~~

---

## Item 4 - Cadastro de Pessoa Jurídica

Cliente utilizado:

~~~text
Empresa Homologação Ltda
CNPJ: 11222333000181
~~~

Validado:

- cadastro;
- máscara;
- tipo PJ;
- exibição;
- consulta.

Resultado:

~~~text
APROVADO
~~~

---

## Item 5 - CNPJ duplicado na mesma empresa

Validado:

- duplicidade recusada;
- mensagem apresentada;
- nenhum segundo registro criado.

Resultado:

~~~text
APROVADO
~~~

---

## Item 6 - Proteções do cliente padrão

Validado que o Consumidor Final não pode ser:

- excluído;
- inativado;
- bloqueado;
- descaracterizado;
- transferido;
- ter documento ou tipo alterados.

Resultado:

~~~text
APROVADO
~~~

---

## Item 7 - Bloqueio e desbloqueio

Validado:

- motivo obrigatório;
- observação;
- bloqueio;
- desbloqueio;
- estado atual;
- Histórico;
- Auditoria.

Resultado:

~~~text
APROVADO
~~~

---

## Item 8 - Inativação e reativação

Validado:

- inativação;
- reativação;
- preservação do cadastro;
- Histórico;
- Auditoria.

Resultado:

~~~text
APROVADO
~~~

---

## Item 9 - Histórico completo

Validado:

- eventos administrativos;
- data e hora;
- usuário;
- descrição;
- motivo;
- observação;
- paginação;
- ausência de dados sensíveis desnecessários;
- isolamento entre clientes.

Resultado:

~~~text
APROVADO
~~~

---

## Item 10 - Pesquisa e filtros

Validado:

- pesquisa por nome;
- pesquisa por CPF;
- pesquisa por CNPJ;
- documento com e sem máscara;
- filtro PF;
- filtro PJ;
- filtro ativo;
- filtro bloqueado;
- filtro por estado;
- limpeza dos filtros;
- retorno à primeira página;
- isolamento multiempresa.

Resultado:

~~~text
APROVADO
~~~

---

## Item 11 - Paginação

Validado:

- troca de quantidade por página;
- próxima página;
- página anterior;
- texto Mostrando X–Y de Z;
- total independente da página atual;
- ausência de registros duplicados;
- seleção tratada com segurança.

Resultado:

~~~text
APROVADO
~~~

---

## Item 12 - Indicadores comerciais e Compras

Validado:

- Última compra;
- Total comprado;
- Quantidade de compras;
- Ticket médio;
- aba Compras;
- tabela de vendas;
- filtros;
- paginação própria;
- Histórico separado.

Resultado:

~~~text
APROVADO
~~~

---

## Item 13 - Exclusão

Validado:

- cliente sem vínculo pode ser excluído;
- cliente com venda não pode ser excluído;
- mensagem orienta inativação;
- modal fecha após negativa;
- cliente permanece selecionado;
- botão Inativar permanece disponível;
- evento Exclusão negada aparece no Histórico;
- venda permanece preservada.

Resultado:

~~~text
APROVADO APÓ CORREÇÃO
~~~

---

## Item 14 - Cliente sem documento

Validado:

- cadastro sem CPF/CNPJ;
- documento permanece vazio;
- não vira cliente padrão;
- segundo cliente sem documento também pode ser cadastrado.

Resultado:

~~~text
APROVADO
~~~

---

## Item 15 - CPF e CNPJ inválidos

Documentos utilizados:

~~~text
CPF: 11111111111
CNPJ: 11111111111111
~~~

Validado:

- CPF inválido recusado;
- CNPJ inválido recusado;
- mensagem clara;
- máscara não evita validação;
- nenhum registro criado;
- nenhum erro 500.

Resultado:

~~~text
APROVADO
~~~

---

## Item 16 - Mesmo documento em empresas diferentes

Validado:

- mesmo CPF permitido em empresas diferentes;
- mesmo CNPJ permitido em empresas diferentes;
- registros isolados;
- buscas isoladas;
- compras isoladas;
- Histórico isolado;
- indicadores isolados.

Resultado:

~~~text
APROVADO
~~~

---

## Item 17 - Permissão VIEW

Validado:

- lista;
- pesquisa;
- filtros;
- consulta;
- Dados cadastrais;
- Compras;
- Histórico;
- bloqueio das operações de alteração.

Resultado:

~~~text
APROVADO
~~~

---

## Item 18 - Cliente padrão no PDV

Validado nas duas empresas:

- Consumidor Final automático;
- documento `00000000000`;
- venda sempre vinculada;
- Consumidor Final correto por empresa;
- compra exibida no cliente correto;
- indicadores atualizados;
- ausência de mistura entre empresas.

Resultado:

~~~text
APROVADO
~~~

---

## Item 19 - Cliente identificado no PDV

Validado:

- substituição do Consumidor Final;
- vínculo com cliente selecionado;
- compra apresentada no cliente;
- indicadores atualizados;
- ausência de impacto no Consumidor Final;
- isolamento da empresa;
- ausência de duplicação.

Resultado:

~~~text
APROVADO
~~~

---

## Item 20 - Cliente bloqueado ou inativo no PDV

Validado:

- cliente bloqueado recusado;
- cliente inativo recusado;
- mensagem clara;
- ausência de troca silenciosa;
- nenhuma venda criada;
- indicadores não alterados;
- uso liberado após reativação e desbloqueio.

Resultado:

~~~text
APROVADO
~~~

---

## Item 21 - Auditoria Central

Validado:

- eventos esperados;
- empresa;
- usuário;
- data e hora;
- ação;
- resultado;
- origem;
- correlação;
- proteção de dados sensíveis;
- isolamento multiempresa.

Resultado:

~~~text
APROVADO
~~~

---

## Item 22 - Consistência dos indicadores

Validado:

- Última compra correta;
- Total comprado correto;
- Quantidade correta;
- Ticket médio correto;
- cancelamento removido dos indicadores;
- venda cancelada preservada na tabela;
- devolução reduzindo o total.

Resultado:

~~~text
APROVADO
~~~

---

## Item 23 - Regressão final

Validado novamente:

- lista;
- criação;
- edição;
- consulta;
- Compras;
- Histórico;
- bloqueio;
- desbloqueio;
- inativação;
- reativação;
- pesquisa;
- documento;
- troca de empresa;
- integração com PDV;
- paginações independentes;
- padrão visual;
- ausência de campos duplicados;
- ausência de erros 500;
- ausência de regressões identificadas.

Resultado:

~~~text
APROVADO
~~~

---

# Correções Realizadas Durante a Homologação

## Documento funcional duplicado

Problema:

- frontend possuía controle antigo relacionado a CPF;
- existia risco de coexistência entre `cpf` e `documento`.

Correção:

- frontend passou a enviar somente `documento`;
- backend manteve `cpf` apenas como compatibilidade temporária;
- mass assignment de campos protegidos foi bloqueado.

---

## Ciclo de vida incompleto

Problema:

- Ativo e Bloqueio apareciam como campos diretos;
- não existiam ações completas;
- não existiam motivo, observação e Histórico adequados.

Correção:

- ações Ativar, Inativar, Bloquear e Desbloquear;
- modal de bloqueio;
- confirmações;
- Histórico administrativo;
- Auditoria Central.

---

## Compras e indicadores ausentes

Problema:

- a consulta apresentava somente dados cadastrais e Histórico;
- vendas do cliente não eram exibidas;
- indicadores comerciais não apareciam.

Correção:

- abas Dados cadastrais, Compras e Histórico;
- endpoint de compras;
- indicadores comerciais;
- paginação própria;
- filtros;
- estados de carregamento, erro e vazio.

---

## Mensagem de exclusão negada ausente

Problema:

- backend recusava corretamente;
- frontend ignorava o corpo da resposta;
- usuário recebia mensagem genérica ou nenhuma orientação útil;
- modal podia esconder o alerta.

Correção:

- contrato `detail` padronizado;
- mensagem amigável;
- fechamento do modal;
- seleção preservada;
- botão Inativar disponível;
- proteção contra duplo clique;
- evento Exclusão negada no Histórico.

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

---

## Correção do documento funcional

Backend:

~~~text
ef3e5ddb08d27063d3420f567974fe529e53e915
~~~

Frontend:

~~~text
5fe3a5f78a076d831f752f86d23c852cb7c0b460
~~~

---

## Ciclo de vida e Histórico

Backend:

~~~text
c81053b05d0949ccb945f873ff7e416255b9a406
~~~

Frontend:

~~~text
9ea4abd975982c5d0df58229ff7934836ae197f2
~~~

---

## Compras e indicadores comerciais

Backend:

~~~text
c95323f041dc87d617ebdaaeabaa8d094e55b4f8
~~~

Frontend:

~~~text
d8175e91c74e19b9c799a7e939a9812daf283ac0
~~~

---

## Exclusão negada com mensagem amigável

Backend:

~~~text
82608d6c578b37336dec162fa186da11f3350823
~~~

Frontend:

~~~text
7881c54b35a2fadc0c7089fcc283a0a65bf1d5e9
~~~

---

# Testes Automatizados Finais

## Backend

Última suíte informada após as correções:

~~~text
Cadastros: 42/42 aprovados
Auditoria: 21/21 aprovados
Suíte geral: 97/97 aprovados
Falhas: 0
Ignorados: 0
~~~

Validações executadas:

~~~powershell
python manage.py check
python manage.py makemigrations --check --dry-run
python manage.py test cadastros -v 2 --noinput
python manage.py test auditoria -v 2 --noinput
python manage.py test -v 2 --noinput
~~~

Resultado:

~~~text
APROVADO
~~~

---

## Frontend

Última suíte informada após as correções:

~~~text
Karma: 90/90 aprovados
Falhas: 0
Ignorados: 0
TypeScript: aprovado
Build development: aprovado
~~~

Validações executadas:

~~~powershell
npx.cmd tsc -p tsconfig.app.json --noEmit
ng build --configuration development
ng test --watch=false --browsers=ChromeHeadless
~~~

Resultado:

~~~text
APROVADO
~~~

---

# Limitações Conhecidas

Permanece pendente:

- criação ou consolidação de uma rota frontend para consultar o detalhe completo de uma venda a partir da aba Compras;
- remoção futura do campo legado `cpf`, somente após confirmar que nenhum consumidor antigo depende dele;
- expansão de testes manuais específicos para todos os tipos possíveis de vínculos financeiros e fiscais.

Essas limitações não impedem o uso homologado do cadastro de clientes.

---

# Resultado Final

O módulo:

~~~text
Cadastros > Clientes
~~~

foi aprovado quanto a:

- regras de negócio;
- segurança;
- multiempresa;
- permissões;
- ciclo de vida;
- integridade referencial;
- Auditoria;
- compras;
- indicadores comerciais;
- integração com PDV;
- experiência do usuário;
- testes automatizados;
- testes manuais.

Status definitivo:

~~~text
HOMOLOGADO
APROVADO PARA CONTINUIDADE DO PROJETO
~~~