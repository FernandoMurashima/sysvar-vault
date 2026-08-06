---
type: risk-register
status: active
project: Sysvar
group: Cadastros
module: Clientes
created: 2026-08-06
updated: 2026-08-06
tags:
  - sysvar
  - riscos
  - cuidados
  - cadastros
  - clientes
  - multiempresa
  - vendas
  - pdv
  - auditoria
  - homologado
---

# Riscos e Cuidados - Cadastros - Clientes

## Objetivo

Este documento registra os principais riscos técnicos, funcionais, operacionais e arquiteturais do módulo:

~~~text
Cadastros > Clientes
~~~

Ele deve ser consultado durante:

- novas implementações;
- correções;
- refatorações;
- migrations;
- integrações;
- criação de novos vínculos;
- alterações no PDV;
- alterações em vendas;
- alterações fiscais;
- alterações financeiras;
- importações;
- deploys;
- homologações;
- revisões de segurança;
- revisões de desempenho.

O módulo está homologado, mas continua sujeito a regressões.

Toda alteração relevante deve ser acompanhada de:

- análise de impacto;
- revisão do código atual;
- testes automatizados;
- validação multiempresa;
- revisão da Auditoria;
- homologação manual;
- atualização da documentação.

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

Documentos relacionados:

~~~text
10 Projetos\Sysvar\Homologações\Homologação - Cadastros - Clientes.md
10 Projetos\Sysvar\Contexto do Projeto\Mapa Técnico - Cadastros - Clientes.md
10 Projetos\Sysvar\Contexto do Projeto\Modelo de Domínio - Cadastros - Clientes.md
10 Projetos\Sysvar\Contexto do Projeto\Workflows - Cadastros - Clientes.md
~~~

---

# Regra Geral

Nunca considerar uma operação segura apenas porque o frontend impediu sua execução.

O backend é a autoridade final.

Não confiar isoladamente em:

- botão oculto;
- botão desabilitado;
- campo somente leitura;
- máscara;
- validação Angular;
- LocalStorage;
- SessionStorage;
- ID enviado pelo navegador;
- empresa enviada no payload;
- status enviado pelo frontend;
- rota;
- query parameter;
- objeto selecionado na tabela;
- mensagem apresentada ao usuário.

Toda operação deve validar novamente:

~~~text
autenticação
empresa
permissão
cliente
estado
vínculos
regra de negócio
~~~

---

# Risco 1 - Vazamento Entre Empresas

## Descrição

O maior risco estrutural do cadastro de Clientes é permitir que dados de uma empresa sejam consultados ou alterados por outra.

Exemplos:

- cliente da Empresa 1 aparece na Empresa 2;
- compra da Empresa 1 aparece no cliente da Empresa 2;
- mesmo ID é utilizado sem filtro de empresa;
- superusuário opera sem contexto explícito;
- indicador comercial agrega vendas de todas as empresas;
- Consumidor Final é compartilhado;
- busca por CPF retorna cliente de outra empresa.

## Regra Obrigatória

~~~text
cliente.empresa_id == empresa atual
~~~

Para vendas:

~~~text
cliente.empresa_id == venda.empresa_id
~~~

## Cuidado Técnico

Nunca utilizar apenas:

~~~python
Cliente.objects.get(pk=cliente_id)
~~~

Preferir consulta com escopo:

~~~python
Cliente.objects.get(
    pk=cliente_id,
    empresa=empresa_atual,
)
~~~

ou queryset central já filtrado pela empresa.

## Proteções Necessárias

- queryset multiempresa;
- serializer validando empresa;
- viewset aplicando empresa;
- serviços recebendo contexto de empresa;
- testes com pelo menos duas empresas;
- acesso direto por URL testado;
- indicadores filtrados por empresa;
- compras filtradas por empresa;
- Histórico filtrado por empresa;
- PDV validando empresa novamente.

---

# Risco 2 - Confiar na Empresa Enviada pelo Frontend

## Descrição

O frontend pode enviar um `empresa_id` incorreto, alterado ou malicioso.

## Regra

A empresa do cliente deve ser definida pelo contexto autenticado.

Não confiar diretamente em:

~~~json
{
  "empresa": 99
}
~~~

## Cuidado

Campos de empresa devem ser:

- ignorados quando indevidos;
- somente leitura;
- substituídos pela empresa atual;
- validados explicitamente em fluxos administrativos.

---

# Risco 3 - Consumidor Final Global

## Descrição

Criar um único Consumidor Final para toda a plataforma causaria:

- vendas misturadas;
- indicadores incorretos;
- vazamento de histórico;
- quebra de isolamento;
- relatórios errados;
- impossibilidade de identificar a empresa da venda corretamente.

## Regra

Cada empresa possui exatamente um:

~~~text
Consumidor Final
~~~

Dados:

~~~text
Tipo: PF
Documento: 00000000000
cliente_padrao: true
~~~

## Proteção

~~~text
Empresa 1 → Consumidor Final 1
Empresa 2 → Consumidor Final 2
~~~

Nunca compartilhar o mesmo registro.

---

# Risco 4 - Duplicação do Cliente Padrão

## Causas Possíveis

- criação concorrente;
- execução repetida de script;
- importação;
- migration incorreta;
- criação manual pelo frontend;
- ausência de constraint;
- serviço não idempotente.

## Consequências

- PDV seleciona cliente errado;
- vendas ficam divididas;
- indicadores ficam fragmentados;
- consulta mostra dois Consumidores Finais;
- exclusões e relatórios ficam inconsistentes.

## Cuidados

- serviço idempotente;
- operação transacional;
- constraint por empresa;
- criação automática centralizada;
- teste de chamadas repetidas;
- diagnóstico de empresas sem cliente padrão;
- diagnóstico de empresas com mais de um cliente padrão.

---

# Risco 5 - Descaracterização do Cliente Padrão

## Operações Proibidas

O cliente padrão não pode ser:

- excluído;
- inativado;
- bloqueado;
- transferido;
- convertido em PJ;
- ter o documento alterado;
- ter o nome funcional descaracterizado quando protegido;
- perder `cliente_padrao`;
- ser substituído manualmente sem processo controlado.

## Consequência

O PDV pode ficar sem cliente válido para vendas não identificadas.

## Proteção

As regras devem existir no backend, mesmo quando os botões estiverem ocultos no frontend.

---

# Risco 6 - Uso Indevido de `00000000000`

## Descrição

O documento:

~~~text
00000000000
~~~

é reservado ao Consumidor Final.

Não deve ser utilizado automaticamente para qualquer cliente sem CPF.

## Erro Possível

~~~text
cliente sem documento
→ preencher 00000000000
→ conflito com cliente padrão
~~~

## Regra

Cliente comum sem documento deve permanecer com documento vazio.

---

# Risco 7 - Campo Legado `cpf`

## Descrição

O sistema possui o campo funcional:

~~~text
documento
~~~

e mantém temporariamente o campo legado:

~~~text
cpf
~~~

## Riscos

- dois campos no formulário;
- payload com valores diferentes;
- busca utilizando campo antigo;
- serializer priorizando valor errado;
- importações antigas;
- consumidores externos dependentes;
- migrations incompletas;
- duplicidade de dados.

## Regra Atual

- frontend utiliza somente `documento`;
- backend mantém `cpf` apenas como compatibilidade;
- novos recursos utilizam `documento`.

## Antes da Remoção

Pesquisar:

- backend;
- frontend;
- serializers;
- views;
- services;
- testes;
- scripts;
- fixtures;
- migrations;
- integrações;
- relatórios;
- banco de produção.

A remoção exige migration própria e plano de compatibilidade.

---

# Risco 8 - Documento Não Normalizado

## Descrição

O mesmo CPF pode chegar como:

~~~text
52998224725
529.982.247-25
529 982 247 25
~~~

Sem normalização, podem surgir duplicidades.

## Regra

Antes da validação e consulta:

~~~text
remover todos os caracteres não numéricos
~~~

## Cuidado

A máscara é responsabilidade visual.

A persistência e a comparação devem utilizar documento normalizado.

---

# Risco 9 - CPF ou CNPJ Inválido

## Descrição

Verificar somente quantidade de dígitos não é suficiente.

Exemplos inválidos:

~~~text
11111111111
11111111111111
~~~

## Proteção

Validar:

- quantidade;
- sequência repetida;
- dígitos verificadores;
- tipo de pessoa;
- unicidade por empresa.

A validação deve existir no backend.

---

# Risco 10 - Unicidade Global Indevida

## Descrição

CPF e CNPJ não são únicos globalmente no SISVAR.

A mesma pessoa pode ser cliente de empresas distintas.

## Regra

~~~text
empresa + documento
~~~

## Erro a Evitar

~~~text
unique=True somente no campo documento
~~~

Isso impediria o mesmo CPF em empresas diferentes.

## Cuidado

Documento vazio também não deve criar conflito entre clientes comuns.

---

# Risco 11 - Bloquear Clientes Sem Documento por Unicidade

## Descrição

Se documento vazio for persistido da mesma forma para todos e tratado como único, o sistema aceitará apenas um cliente sem documento.

## Regra

Vários clientes comuns sem documento são permitidos.

## Proteção

- utilizar `null` ou vazio conforme estratégia consistente;
- aplicar unicidade somente quando documento estiver preenchido;
- testar dois clientes sem documento na mesma empresa.

---

# Risco 12 - Inferir Tipo de Pessoa pelo Documento

## Descrição

Inferir PF ou PJ apenas pela quantidade de dígitos pode gerar inconsistências.

## Regra

O campo explícito:

~~~text
tipo_pessoa
~~~

é a referência funcional.

O documento deve ser validado conforme o tipo selecionado.

---

# Risco 13 - Mass Assignment

## Descrição

Um payload comum pode tentar alterar campos protegidos.

Exemplo:

~~~json
{
  "ativo": false,
  "bloqueio": true,
  "cliente_padrao": true,
  "empresa": 2
}
~~~

## Campos Sensíveis

- empresa;
- ativo;
- bloqueio;
- motivo de bloqueio;
- observação de bloqueio;
- bloqueado por;
- bloqueado em;
- cliente padrão;
- campos de Auditoria.

## Proteção

- campos somente leitura;
- serializers específicos;
- ações dedicadas;
- validação explícita;
- testes de payload malicioso.

---

# Risco 14 - Alteração Direta do Ciclo de Vida

## Descrição

Permitir edição direta de:

~~~text
ativo
bloqueio
~~~

contorna:

- confirmação;
- motivo;
- usuário responsável;
- data;
- Auditoria;
- regras do cliente padrão.

## Regra

Utilizar somente ações:

~~~text
Ativar
Inativar
Bloquear
Desbloquear
~~~

---

# Risco 15 - Bloqueio Sem Motivo

## Descrição

Um cliente bloqueado sem motivo dificulta:

- atendimento;
- auditoria;
- revisão;
- desbloqueio;
- justificativa operacional.

## Regra

Motivo obrigatório.

Observação opcional.

## Cuidado

O backend deve validar o motivo, mesmo que o frontend também valide.

---

# Risco 16 - Dados Sensíveis no Motivo ou Observação

## Descrição

Usuários podem inserir informações pessoais excessivas nos campos de bloqueio.

## Não Registrar

- senha;
- cartão;
- dados bancários;
- documento completo sem necessidade;
- informações médicas;
- conteúdo ofensivo;
- dados sem finalidade comercial.

## Cuidado

Orientar o usuário e limitar o uso ao contexto operacional.

---

# Risco 17 - Cliente Inativo Utilizado no PDV

## Consequências

- venda para cadastro desativado;
- quebra de política comercial;
- indicadores inconsistentes;
- operação não autorizada.

## Proteção

O backend da venda deve validar:

~~~text
cliente.ativo == true
~~~

Não confiar apenas no filtro da tela de busca.

---

# Risco 18 - Cliente Bloqueado Utilizado no PDV

## Consequências

- venda para cliente restrito;
- quebra de política de crédito;
- descumprimento de decisão administrativa.

## Proteção

O backend da venda deve validar:

~~~text
cliente.bloqueio == false
~~~

---

# Risco 19 - Troca Silenciosa para Consumidor Final

## Descrição

Quando um cliente identificado é recusado, o sistema não deve substituir silenciosamente pelo Consumidor Final.

## Consequências

- venda vinculada ao cliente errado;
- indicadores incorretos;
- operador acredita que o cliente foi utilizado;
- histórico comercial perdido;
- possível problema fiscal.

## Regra

Cliente inválido:

~~~text
recusar operação
→ apresentar motivo
→ exigir ação consciente do operador
~~~

---

# Risco 20 - Venda Sem Cliente

## Descrição

Uma venda sem cliente dificulta:

- rastreabilidade;
- relatórios;
- indicadores;
- devoluções;
- documentos fiscais;
- integração financeira.

## Regra

~~~text
cliente identificado
ou
Consumidor Final da empresa
~~~

A venda não deve permanecer com cliente nulo.

---

# Risco 21 - Cliente de Outra Empresa no PDV

## Ataque ou Falha

Um ID de cliente de outra empresa pode ser enviado diretamente à API.

## Proteção

Validar:

~~~text
cliente.empresa_id == venda.empresa_id
~~~

Quando não corresponder:

- recusar;
- não copiar automaticamente;
- não alterar empresa;
- não substituir silenciosamente;
- registrar Auditoria quando aplicável.

---

# Risco 22 - Indicadores Calculados no Frontend

## Descrição

Calcular indicadores com os registros da página atual produz valores errados.

## Não Calcular no Navegador

- Total comprado;
- Quantidade de compras;
- Ticket médio;
- Última compra.

## Regra

O backend calcula com todas as vendas válidas da empresa.

O frontend apenas formata.

---

# Risco 23 - Venda Cancelada nos Indicadores

## Erro

~~~text
venda CANCELADA incluída no total
~~~

## Consequências

- total comprado inflado;
- ticket médio incorreto;
- quantidade incorreta;
- última compra incorreta.

## Regra

Somente vendas válidas conforme o status homologado participam dos indicadores.

Atualmente:

~~~text
FINALIZADA
~~~

---

# Risco 24 - Devolução Ignorada

## Descrição

Uma venda pode ser finalizada e posteriormente devolvida.

Se a devolução não for considerada:

- total comprado fica inflado;
- perfil comercial fica incorreto;
- campanhas podem usar dados errados.

## Regra Atual

Devoluções finalizadas reduzem o total por:

~~~text
VendaDevolucao.credito_cliente
~~~

## Cuidado

Confirmar essa regra antes de alterar o domínio de devoluções.

---

# Risco 25 - Contar Devolução como Nova Compra

## Erro

Uma devolução não representa nova venda.

## Regra

A quantidade de compras conta vendas finalizadas.

Não contar:

- devoluções;
- itens;
- pagamentos;
- documentos fiscais relacionados.

---

# Risco 26 - Duplicação por Join

## Descrição

Uma venda pode possuir:

- vários itens;
- vários pagamentos;
- várias devoluções.

Uma agregação inadequada pode multiplicar valores.

Exemplo:

~~~text
1 venda
3 itens
2 pagamentos
→ join pode gerar 6 linhas
~~~

## Consequências

- total comprado multiplicado;
- quantidade de itens incorreta;
- ticket médio incorreto;
- valores de devolução duplicados.

## Cuidados

- subqueries;
- `distinct` quando adequado;
- agregações separadas;
- anotações controladas;
- testes com múltiplos itens;
- testes com múltiplos pagamentos;
- testes com devoluções.

---

# Risco 27 - Quantidade de Itens Igual à Quantidade de Linhas

## Descrição

Uma venda pode ter uma linha com quantidade maior que um.

## Regra

Quantidade de itens deve utilizar:

~~~text
soma das quantidades
~~~

e não apenas:

~~~text
count das linhas
~~~

---

# Risco 28 - Forma de Pagamento Duplicando Venda

## Descrição

Uma venda com duas formas de pagamento pode aparecer duas vezes na consulta.

## Proteção

A venda deve aparecer uma única vez.

A forma pode ser apresentada como:

~~~text
Múltiplas
~~~

---

# Risco 29 - Compras Obtidas da Auditoria

## Descrição

AuditLog não é o domínio comercial.

## Regra

~~~text
Compras
→ fiscal.VendaPdv

Histórico
→ auditoria.AuditLog
~~~

Não criar eventos artificiais apenas para apresentar vendas no cadastro.

---

# Risco 30 - Misturar Compras e Histórico

## Consequências

- paginação confusa;
- filtros incompatíveis;
- registros duplicados;
- perda de significado;
- piora de desempenho.

## Proteção

Manter áreas separadas:

~~~text
Dados cadastrais
Compras
Histórico
~~~

Cada uma com estado e paginação próprios.

---

# Risco 31 - Paginações Compartilhadas

## Descrição

Reutilizar as mesmas variáveis de página pode fazer uma aba alterar a outra.

## Paginações Independentes

~~~text
lista de Clientes
Compras
Histórico
~~~

Cada uma deve possuir:

- página;
- tamanho;
- total;
- loading;
- erro;
- resultados.

---

# Risco 32 - Carregar Todas as Compras Antecipadamente

## Consequências

- tela lenta;
- consultas pesadas;
- alto tráfego;
- risco de N+1;
- consumo excessivo de memória.

## Regra

Compras devem ser carregadas sob demanda ao abrir a área correspondente.

---

# Risco 33 - Tratar Erro como Lista Vazia

## Descrição

Uma falha de API não significa que o cliente não possui compras.

## Estados Distintos

~~~text
loading
error
empty
results
~~~

## Cuidado

Não apresentar:

~~~text
Nenhuma compra encontrada
~~~

quando a API falhou.

---

# Risco 34 - Rota de Consulta de Venda Inventada

## Descrição

O botão Consultar venda ainda não possui rota frontend consolidada.

## Regra Atual

~~~text
pode_consultar_venda: false
~~~

## Cuidado

Não criar URL fictícia.

Antes de habilitar:

- localizar tela oficial;
- definir rota;
- definir permissão;
- validar empresa;
- testar acesso direto;
- retornar contrato correto.

---

# Risco 35 - Exclusão em Cascata

## Descrição

Excluir Cliente e apagar vendas ou títulos relacionados destruiria histórico operacional.

## Não Utilizar

~~~text
CASCADE
~~~

sem decisão arquitetural explícita e justificada.

## Relacionamentos Históricos

- vendas;
- devoluções;
- documentos fiscais;
- cashback;
- vale-troca;
- contas a receber;
- pagamentos;
- outros registros comerciais.

---

# Risco 36 - Relacionamento Novo Não Considerado na Exclusão

## Descrição

Um novo módulo pode criar vínculo com Cliente sem atualizar o pré-check de exclusão.

## Consequência

- erro 500;
- mensagem técnica;
- tentativa indevida de exclusão;
- Auditoria ausente.

## Ao Criar Novo Vínculo

- definir `on_delete`;
- decidir se impede exclusão;
- atualizar verificação de impedimentos;
- adicionar teste;
- atualizar mensagem, se necessário;
- atualizar documentação.

---

# Risco 37 - Expor `ProtectedError` ou `IntegrityError`

## Não Exibir ao Usuário

- nome da tabela;
- nome da constraint;
- chave estrangeira;
- stack trace;
- mensagem SQL;
- classe de exceção.

## Resposta Oficial

~~~json
{
  "detail": "Este cliente possui vendas ou outros registros vinculados e não pode ser excluído. Utilize a inativação."
}
~~~

Status:

~~~text
400 Bad Request
~~~

---

# Risco 38 - Duplicar Auditoria da Exclusão Negada

## Descrição

A mesma tentativa pode passar pelo pré-check e também pela captura de exceção.

## Regra

Cada tentativa deve gerar somente um:

~~~text
CLIENT_DELETE_DENIED
~~~

## Cuidado

Centralizar a gravação ou controlar o fluxo para evitar duplicação.

---

# Risco 39 - Limpar Seleção Após Exclusão Negada

## Consequência

O usuário perde o cliente selecionado e não consegue inativá-lo imediatamente.

## Regra Homologada

Após negativa:

- modal fecha;
- cliente permanece selecionado;
- mensagem aparece;
- botão Inativar permanece disponível;
- lista permanece;
- loading termina.

---

# Risco 40 - Duplo Clique na Exclusão

## Consequências

- duas requisições;
- eventos duplicados;
- mensagens inconsistentes;
- corrida de estado.

## Proteção

Estado:

~~~text
exclusaoSaving
~~~

Enquanto ativo:

- bloquear botão;
- ignorar nova chamada;
- não alterar lista antecipadamente.

---

# Risco 41 - Ocultar Mensagem da API

## Descrição

O backend pode retornar uma orientação correta, mas o frontend substituí-la por mensagem genérica.

## Prioridade Recomendada

~~~text
detail
message
non_field_errors
erro de campo
err.message
fallback
~~~

## Fallback

~~~text
Não foi possível excluir o cliente. Verifique se existem vendas ou outros registros vinculados. Nesse caso, utilize a inativação.
~~~

---

# Risco 42 - Auditoria Sem Empresa

## Descrição

Um evento sem empresa dificulta isolamento, consulta e investigação.

## Regra

Eventos de Cliente devem registrar a empresa correta.

Superusuário também deve operar com contexto de empresa quando a ação atingir cliente de uma empresa.

---

# Risco 43 - Dados Sensíveis na Auditoria

## Evitar

- CPF completo;
- CNPJ completo;
- telefone;
- e-mail;
- endereço;
- informações financeiras;
- observações excessivas;
- payload integral;
- stack trace.

## Preferir

- ID do cliente;
- empresa;
- usuário;
- campos alterados;
- valores mascarados;
- motivo operacional;
- resultado;
- origem;
- correlation ID.

---

# Risco 44 - Histórico Paralelo

## Descrição

Criar outra tabela para repetir a Auditoria causa:

- duplicidade;
- divergência;
- manutenção dupla;
- eventos faltantes.

## Regra

Utilizar a Auditoria Central como fonte do Histórico administrativo.

---

# Risco 45 - Eventos de Auditoria Duplicados

## Causas

- serializer audita;
- viewset audita;
- service audita;
- signal audita;
- frontend repete ação.

## Proteção

Definir um ponto responsável pela operação.

Testar quantidade exata de eventos.

---

# Risco 46 - Permissão Apenas no Frontend

## Ataque

Usuário VIEW chama diretamente:

~~~http
POST
PATCH
DELETE
~~~

## Proteção

Backend valida:

~~~text
GET, HEAD, OPTIONS
→ VIEW

POST, PUT, PATCH, DELETE e ações
→ EDIT
~~~

---

# Risco 47 - VIEW Sem Acesso às Consultas

## Descrição

Usuário VIEW precisa consultar:

- lista;
- detalhe;
- Compras;
- Histórico.

Não exigir EDIT para leitura.

---

# Risco 48 - EDIT Ultrapassando Regra de Negócio

## Descrição

Permissão EDIT não significa liberdade total.

Mesmo com EDIT, o usuário não pode:

- alterar empresa indevidamente;
- excluir cliente com vínculos;
- bloquear cliente padrão;
- inativar cliente padrão;
- cadastrar documento duplicado;
- utilizar cliente de outra empresa.

---

# Risco 49 - Busca de Documento Sem Normalização

## Descrição

Pesquisa por documento com máscara pode não encontrar o registro armazenado sem máscara.

## Proteção

Normalizar o termo quando ele representar CPF ou CNPJ.

Testar:

~~~text
52998224725
529.982.247-25
~~~

---

# Risco 50 - Indicadores da Lista Calculados pela Página

## Erro

Somar somente os registros visíveis.

## Regra

Os cards devem representar toda a carteira da empresa, conforme a finalidade de cada indicador.

---

# Risco 51 - Atualização Incompleta da Tela

Após ações como:

- criar;
- editar;
- ativar;
- inativar;
- bloquear;
- desbloquear;
- excluir;

devem ser atualizados, conforme necessário:

- lista;
- indicadores;
- cliente selecionado;
- detalhe;
- Histórico;
- mensagens.

---

# Risco 52 - Venda Alterada sem Atualizar Indicadores

## Descrição

Após cancelamento ou devolução, dados em tela podem ficar antigos.

## Cuidado

Ao atualizar ou reabrir a consulta:

- recalcular no backend;
- recarregar indicadores;
- recarregar Compras;
- não reutilizar valor antigo do frontend.

---

# Risco 53 - Desempenho e N+1

## Pontos Críticos

- nome da loja;
- nome do vendedor;
- quantidade de itens;
- formas de pagamento;
- devoluções;
- indicadores.

## Cuidados

- `select_related`;
- `prefetch_related`;
- subqueries;
- agregações;
- paginação;
- testes de quantidade de queries;
- não carregar tudo na lista principal.

---

# Risco 54 - Ordenação Instável

## Descrição

Paginação sem ordenação consistente pode repetir ou omitir registros.

## Cuidado

Utilizar ordenação determinística, incluindo ID como critério secundário quando necessário.

Exemplo:

~~~text
-data_venda
-id
~~~

---

# Risco 55 - Valores Monetários com Float

## Descrição

Utilizar ponto flutuante pode gerar diferenças de centavos.

## Proteção

- Decimal no backend;
- Decimal no banco;
- arredondamento definido;
- formatação apenas no frontend;
- testes com centavos.

---

# Risco 56 - Ticket Médio Dividido por Zero

## Regra

~~~text
quantidade_compras = 0
→ ticket_medio = 0
~~~

Não gerar exceção ou valor indefinido.

---

# Risco 57 - Última Compra Considerando Venda Cancelada

## Regra

A Última compra deve usar a venda válida mais recente.

Venda cancelada não deve substituir a data anterior válida.

---

# Risco 58 - Devolução Superior ao Total

## Descrição

Dependendo das regras futuras, devoluções podem produzir total comercial negativo.

## Cuidado

Definir conscientemente:

- permitir total negativo;
- limitar em zero;
- representar crédito excedente;
- tratar múltiplas devoluções.

Não alterar sem decisão de negócio.

---

# Risco 59 - Importação de Clientes

## Riscos

- documentos com máscara;
- duplicidade;
- documento inválido;
- empresa incorreta;
- criação de cliente padrão duplicado;
- campos de ciclo de vida indevidos;
- dados sensíveis em logs.

## Cuidados

Toda importação deve:

- exigir empresa;
- normalizar documento;
- validar PF/PJ;
- respeitar unicidade;
- proteger cliente padrão;
- registrar resultado;
- gerar relatório de erros;
- ser idempotente quando possível.

---

# Risco 60 - LGPD e Dados Pessoais

## Dados Possíveis

- nome;
- CPF;
- endereço;
- telefone;
- e-mail;
- data de nascimento;
- histórico de compras;
- preferências;
- consentimentos.

## Cuidados

- coletar apenas o necessário;
- restringir acesso;
- proteger logs;
- evitar exposição na Auditoria;
- definir finalidade;
- controlar exportações;
- controlar relatórios;
- revisar retenção;
- evitar dados excessivos em observações.

Regras legais específicas devem ser tratadas em política própria e revisadas conforme a legislação vigente.

---

# Risco 61 - Exportação de Clientes

## Riscos

- vazamento de CPF;
- dados de outra empresa;
- exportação sem permissão;
- arquivo deixado em pasta pública.

## Cuidados

- validar empresa;
- validar permissão;
- limitar campos;
- mascarar quando aplicável;
- registrar Auditoria;
- proteger arquivo;
- evitar URL pública permanente.

---

# Risco 62 - Logs Técnicos com Documento

## Descrição

Logs de requisição podem armazenar payload completo.

## Cuidado

Mascarar ou remover:

- documento;
- telefone;
- e-mail;
- endereço;
- tokens;
- dados financeiros.

---

# Risco 63 - Cache Entre Empresas

## Descrição

Cache sem chave de empresa pode retornar clientes ou indicadores de outro tenant.

## Regra

Toda chave de cache relacionada ao módulo deve incluir:

~~~text
empresa_id
~~~

e, quando necessário:

~~~text
cliente_id
usuário
permissão
filtros
~~~

---

# Risco 64 - Uso Offline do PDV

Quando o PDV offline for implementado, será necessário considerar:

- cliente atualizado no servidor e antigo localmente;
- cliente bloqueado após última sincronização;
- cliente inativado após última sincronização;
- conflito de documentos;
- Consumidor Final local;
- sincronização multiempresa;
- venda feita offline para cliente posteriormente bloqueado;
- política de resolução de conflitos.

Esse fluxo exige documentação e decisão específica antes da implementação.

---

# Risco 65 - Alteração de Status Durante uma Venda

## Cenário

Cliente é selecionado no PDV e depois bloqueado por outro usuário antes da finalização.

## Proteção

Validar novamente no momento de finalizar:

~~~text
empresa
ativo
bloqueio
~~~

Não validar somente na seleção inicial.

---

# Risco 66 - Exclusão Durante Operação Concorrente

## Cenário

Um usuário tenta excluir cliente sem vínculos enquanto outro cria uma venda.

## Proteção

- transação;
- integridade do banco;
- `PROTECT`;
- tratamento de `IntegrityError`;
- resposta amigável;
- Auditoria.

---

# Risco 67 - Falha da Auditoria

## Descrição

Operações relevantes podem exigir Auditoria obrigatória.

## Cuidado

Definir por operação se:

- a falha de Auditoria deve cancelar a operação;
- ou se a operação pode continuar com alerta técnico.

A decisão deve seguir a política central da Auditoria do SISVAR.

Não ignorar silenciosamente falhas.

---

# Risco 68 - Mensagens Técnicas ao Usuário

## Não Exibir

~~~text
IntegrityError
ProtectedError
KeyError
TypeError
constraint
foreign key
traceback
SQL
500 Internal Server Error
~~~

## Exibir

Mensagens funcionais, claras e orientadoras.

---

# Risco 69 - Alterar Contrato da API Sem Atualizar Frontend

## Pontos Críticos

- nome dos campos;
- paginação;
- status;
- filtros;
- indicadores;
- formato de erros;
- `pode_consultar_venda`;
- Histórico;
- Compras.

## Cuidado

Alteração deve ser aditiva quando possível.

Atualizar:

- interfaces TypeScript;
- service;
- componente;
- testes;
- documentação.

---

# Risco 70 - Uso Excessivo de `any` no Frontend

## Consequências

- campos incorretos passam despercebidos;
- erros em tempo de execução;
- tratamento de API inconsistente.

## Cuidado

Utilizar interfaces para:

- Cliente;
- filtros;
- indicadores;
- compras;
- Histórico;
- respostas paginadas;
- erros conhecidos.

---

# Risco 71 - Formulário com Controles Duplicados

## Erro Já Corrigido

Coexistência entre:

~~~text
cpf
documento
~~~

## Proteção

- manter um único controle funcional;
- testar payload;
- revisar HTML e TypeScript;
- impedir envio divergente.

---

# Risco 72 - Regressão Visual

Ao alterar a tela, preservar:

- padrão de barras;
- tabela;
- seleção;
- paginação;
- mensagens;
- modais;
- botões;
- indicadores;
- responsividade mínima;
- acessibilidade básica;
- consistência com o SISVAR.

---

# Risco 73 - Botões de Ação Incorretos

Os botões devem considerar:

- permissão;
- cliente selecionado;
- cliente padrão;
- estado ativo;
- bloqueio;
- operação em andamento.

Exemplos:

~~~text
cliente ativo
→ Inativar

cliente inativo
→ Ativar

cliente bloqueado
→ Desbloquear

cliente desbloqueado
→ Bloquear
~~~

---

# Risco 74 - Ação com Seleção Antiga

## Descrição

Após atualizar filtros ou página, o cliente selecionado pode não estar mais na lista.

## Cuidado

- limpar ou revalidar seleção;
- não executar ação com objeto obsoleto;
- confirmar ID e empresa no backend.

---

# Risco 75 - Ausência de Testes Multiempresa

Toda alteração relevante deve testar:

~~~text
Empresa 1
Empresa 2
mesmo CPF
mesmo CNPJ
clientes distintos
vendas distintas
Consumidores Finais distintos
~~~

---

# Risco 76 - Cobertura Insuficiente de Vínculos

Os testes de exclusão devem evoluir conforme novos módulos forem adicionados.

Vínculos atuais ou previstos:

- vendas;
- devoluções;
- NFC-e;
- cashback;
- vale-troca;
- contas a receber;
- pedidos;
- reservas;
- campanhas;
- crédito;
- atendimento.

---

# Risco 77 - Migration Destrutiva

Antes de alterar campos de Cliente:

- gerar backup;
- analisar valores existentes;
- verificar `null`;
- verificar duplicidades;
- verificar cliente padrão;
- testar migration reversa quando possível;
- executar em cópia da base;
- não editar migration aplicada.

---

# Risco 78 - Dados Antigos Inconsistentes

Possíveis inconsistências:

- cliente sem empresa;
- dois clientes padrão;
- documento com máscara;
- documento duplicado;
- CPF no campo legado e documento vazio;
- cliente padrão inativo;
- cliente padrão bloqueado;
- venda com cliente de outra empresa.

## Cuidados

Criar commands de diagnóstico antes de correções massivas.

Preferir:

~~~text
diagnosticar
→ dry-run
→ revisar
→ aplicar
~~~

---

# Risco 79 - Correção Massiva Sem Auditoria

Atualizações em lote podem alterar muitos clientes.

## Cuidados

- limitar por empresa;
- utilizar transação;
- gerar relatório;
- registrar origem;
- não expor documentos;
- possuir dry-run;
- permitir conferência.

---

# Risco 80 - Alteração de Regra de Indicadores

Antes de mudar o cálculo, definir:

- quais status contam;
- impacto de devolução;
- impacto de troca;
- impacto de cashback;
- impacto de vale;
- valor bruto ou líquido;
- data considerada;
- arredondamento;
- vendas antigas.

A alteração deve atualizar:

- backend;
- testes;
- frontend, quando necessário;
- relatórios;
- documentação;
- homologação.

---

# Checklist Antes de Alterar o Backend

- [ ] abriu o model atual;
- [ ] abriu serializer atual;
- [ ] abriu viewset atual;
- [ ] verificou services;
- [ ] verificou rotas;
- [ ] verificou migrations;
- [ ] verificou testes;
- [ ] confirmou empresa;
- [ ] confirmou permissões;
- [ ] confirmou cliente padrão;
- [ ] confirmou ciclo de vida;
- [ ] confirmou Auditoria;
- [ ] confirmou vendas;
- [ ] confirmou financeiro;
- [ ] confirmou fiscal;
- [ ] confirmou impacto no PDV.

---

# Checklist Antes de Alterar o Frontend

- [ ] abriu TS atual;
- [ ] abriu HTML atual;
- [ ] abriu CSS atual;
- [ ] abriu service atual;
- [ ] abriu models TypeScript;
- [ ] abriu specs;
- [ ] preservou padrão visual;
- [ ] preservou paginações independentes;
- [ ] preservou tratamento de erro;
- [ ] preservou permissões;
- [ ] preservou cliente selecionado;
- [ ] preservou carregamento sob demanda;
- [ ] não reintroduziu `cpf` no formulário.

---

# Checklist de Testes

## Cadastro

- [ ] criar PF;
- [ ] criar PJ;
- [ ] criar sem documento;
- [ ] recusar CPF inválido;
- [ ] recusar CNPJ inválido;
- [ ] recusar duplicidade na empresa;
- [ ] permitir documento em outra empresa.

## Cliente Padrão

- [ ] existe um por empresa;
- [ ] não existe duplicado;
- [ ] não pode ser excluído;
- [ ] não pode ser bloqueado;
- [ ] não pode ser inativado;
- [ ] não pode ser descaracterizado.

## Ciclo de Vida

- [ ] ativar;
- [ ] inativar;
- [ ] bloquear com motivo;
- [ ] desbloquear;
- [ ] registrar Histórico;
- [ ] registrar Auditoria.

## PDV

- [ ] Consumidor Final correto;
- [ ] cliente identificado;
- [ ] cliente inativo recusado;
- [ ] cliente bloqueado recusado;
- [ ] cliente de outra empresa recusado;
- [ ] revalidação na finalização.

## Compras

- [ ] venda finalizada;
- [ ] venda cancelada;
- [ ] devolução;
- [ ] múltiplos itens;
- [ ] múltiplos pagamentos;
- [ ] paginação;
- [ ] filtros;
- [ ] isolamento multiempresa.

## Exclusão

- [ ] cliente sem vínculo;
- [ ] cliente com venda;
- [ ] cliente com vínculo financeiro;
- [ ] `ProtectedError`;
- [ ] `IntegrityError`;
- [ ] mensagem amigável;
- [ ] um único evento de Auditoria;
- [ ] seleção preservada;
- [ ] duplo clique bloqueado.

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

# Resultado de Testes Registrado

Backend:

~~~text
Cadastros: 42/42
Auditoria: 21/21
Suíte geral: 97/97
Falhas: 0
Ignorados: 0
~~~

Frontend:

~~~text
Karma: 90/90
Falhas: 0
Ignorados: 0
TypeScript: aprovado
Build development: aprovado
~~~

Esses resultados representam o estado homologado registrado.

Novas alterações exigem nova execução.

---

# Limitações Conhecidas

Permanecem pendentes:

- rota frontend consolidada para consultar o detalhe completo da venda;
- remoção futura do campo legado `cpf`;
- testes manuais de todos os vínculos fiscais possíveis;
- testes manuais de todos os vínculos financeiros possíveis;
- definição futura do comportamento offline para bloqueio e inativação;
- eventual serviço dedicado aos indicadores comerciais;
- commands específicos para diagnóstico de inconsistências antigas, caso necessários.

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
10 Projetos\Sysvar\Contexto do Projeto\Workflows - Cadastros - Clientes.md
10 Projetos\Sysvar\Contexto do Projeto\Riscos e Cuidados.md
10 Projetos\Sysvar\Homologações\Homologação - Cadastros - Clientes.md
10 Projetos\Sysvar\Decisões Técnicas\ADR-003 - Auditoria Central do SISVAR.md
~~~

---

# Regra de Manutenção

Toda alteração no módulo Clientes deve responder:

1. a empresa continua sendo validada?
2. o cliente padrão continua único?
3. o cliente padrão continua protegido?
4. documento vazio continua permitido?
5. CPF e CNPJ continuam válidos?
6. a unicidade continua sendo por empresa?
7. o campo legado continua controlado?
8. mass assignment continua bloqueado?
9. ciclo de vida continua por ações?
10. cliente inativo continua recusado no PDV?
11. cliente bloqueado continua recusado no PDV?
12. a venda continua vinculada à empresa correta?
13. compras continuam separadas do Histórico?
14. indicadores continuam corretos?
15. joins continuam sem duplicação?
16. exclusões continuam preservando vínculos?
17. mensagens continuam amigáveis?
18. Auditoria continua sem duplicação?
19. dados sensíveis continuam protegidos?
20. paginações continuam independentes?
21. desempenho continua aceitável?
22. testes foram executados?
23. homologação foi atualizada?
24. documentação foi atualizada?

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
COM RISCOS CONTROLADOS
~~~

Próximo item funcional do grupo Cadastros:

~~~text
Fornecedores
~~~