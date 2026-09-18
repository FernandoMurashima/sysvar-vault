---
type: project
status: active
project: Sysvar
source: "FernandoMurashima/sysvarbackend + FernandoMurashima/sysvarfrontend + FernandoMurashima/sysvarhub-backend + FernandoMurashima/sysvarhub-frontend"
created: 2026-09-18
updated: 2026-09-18
tags:
  - sysvar
  - planejamento
  - roadmap
  - homologacao
---

# Planejamento — Sysvar

## Objetivo

Registrar a sequência de trabalho do Sysvar a partir do estado atual dos repositórios, evitando perda de contexto entre módulos e garantindo que cada etapa passe por análise, implementação, homologação e documentação.

Este documento representa a ordem de trabalho. As pendências específicas continuam registradas em [[Pendências e Melhorias]].

## Estado atual confirmado no repositório

O menu principal atual do Sysvar está organizado em:

1. Dashboard;
2. Cadastros;
3. Produtos;
4. Compras;
5. Estoque;
6. Distribuição;
7. Produção;
8. Vendas;
9. Loja;
10. Financeiro;
11. Fiscal / Contábil.

Os módulos já trabalhados não devem ser reabertos sem necessidade. Pendências de acabamento permanecem registradas para tratamento no momento adequado.

### Já trabalhados

- Cadastros;
- Produtos;
- Compras;
- Estoque;
- Distribuição.

### Em andamento

- Loja / PDV / Sysvar Hub;
- integrações locais necessárias para operação, incluindo Local Agent.

### Próxima sequência oficial

~~~text
Sysvar Hub / Loja
→ Produção
→ Vendas
→ Financeiro
→ Fiscal / Contábil
→ Dashboard e fechamento integrado
~~~

---

# Etapa 1 — Concluir Loja / Sysvar Hub

## Objetivo

Fechar a arquitetura local/offline da loja antes de avançar para os demais módulos centrais.

## Escopo

### 1.1 Sysvar Hub

- concluir as pendências funcionais do Hub;
- revisar instalação e execução como serviço;
- validar ativação e vínculo do Hub com Empresa/Loja;
- validar acesso dos terminais pela rede local;
- revisar segurança de acesso dos terminais;
- revisar bootstrap inicial e carga dos dados necessários à operação local.

### 1.2 Sincronização Central → Hub

Revisar e homologar os snapshots necessários ao PDV offline, incluindo:

- catálogo;
- estoque necessário à operação local;
- clientes;
- formas de pagamento;
- operadores;
- vendedores;
- tipos de despesa do PDV;
- regras/configurações necessárias para devolução;
- regras/configurações de Cashback;
- dados necessários para Vale-Troca;
- promoções/campanhas aplicáveis ao PDV quando fizerem parte da operação offline;
- demais parâmetros que o PDV necessite para operar sem internet.

### 1.3 Sincronização Hub → Central

Concluir e homologar o retorno das operações locais para o Sysvar Central, incluindo:

- clientes criados/localmente alterados quando aplicável;
- vendas finalizadas;
- devoluções de venda realizadas offline;
- movimentos de Cashback gerados/utilizados/estornados localmente;
- emissão e utilização de Vale-Troca quando aplicável;
- movimentos de caixa;
- sessões de caixa;
- fechamento do dia;
- mapeamentos entre registros locais e centrais;
- retry;
- idempotência;
- tratamento de conflitos;
- recuperação após falha de comunicação.

### 1.4 Operação totalmente offline

- desligar a internet durante homologação;
- operar o PDV local;
- abrir e movimentar caixa;
- realizar venda;
- utilizar cliente, vendedor e formas de pagamento locais;
- realizar devolução de venda offline;
- validar efeitos locais de estoque e caixa da devolução;
- utilizar Cashback conforme a política offline definida;
- emitir/utilizar Vale-Troca quando aplicável;
- fechar operação;
- restaurar conexão;
- confirmar sincronização posterior sem duplicidade.

### 1.5 Devoluções, Cashback e Vale-Troca no PDV offline

Essas funções fazem parte da operação de Loja e não podem depender exclusivamente de acesso ao Sysvar Central se o objetivo do Hub é manter o PDV funcionando durante indisponibilidade da internet.

#### Devolução de Venda

Planejar e homologar no Hub/PDV:

- localização da venda original disponível localmente;
- devolução total ou parcial conforme a regra do Sysvar;
- validação para impedir devolução acima da quantidade vendida;
- atualização local do estoque devolvido;
- reflexo local de caixa/forma de restituição quando aplicável;
- geração de Vale-Troca quando essa for a regra escolhida;
- persistência da devolução na base local;
- criação de evento de sincronização Hub → Central;
- idempotência para impedir devolução duplicada após reconexão;
- tratamento de conflito caso o estado da venda no Central tenha mudado enquanto a Loja estava offline.

#### Cashback

O PDV offline deve conhecer as regras necessárias para operar Cashback sem depender de consulta online a cada venda.

Planejar:

- snapshot da configuração de Cashback aplicável à Loja/Empresa;
- geração de Cashback em venda elegível;
- utilização de Cashback no PDV quando permitida;
- cancelamento/estorno de Cashback relacionado a devolução ou cancelamento de venda;
- persistência local dos movimentos;
- sincronização posterior com o Central;
- idempotência dos movimentos.

Ponto arquitetural obrigatório antes da implementação: definir a política de uso de saldo de Cashback durante operação offline, pois o saldo disponível no Hub pode ficar desatualizado em relação a operações realizadas em outra Loja. A solução deve impedir ou controlar uso duplicado de saldo sem depender de conexão permanente.

#### Vale-Troca

Como a devolução pode gerar Vale-Troca, o fluxo precisa existir também no cenário offline.

Planejar:

- emissão local vinculada à devolução;
- identificação única do Vale-Troca;
- saldo e histórico local;
- utilização em nova venda;
- utilização parcial quando a regra permitir;
- cancelamento/estorno;
- sincronização com o Central;
- proteção contra uso duplicado após reconexão.

#### Homologação específica

Executar pelo menos os seguintes cenários com a internet desligada:

1. venda normal;
2. devolução parcial;
3. devolução total;
4. devolução com geração de Vale-Troca;
5. nova venda usando Vale-Troca;
6. venda gerando Cashback;
7. venda utilizando Cashback conforme a política offline aprovada;
8. cancelamento/estorno dos benefícios gerados;
9. reconexão com o Central;
10. confirmação de estoque, caixa, venda, devolução, Cashback e Vale-Troca sem duplicidades.

### 1.6 NFC-e

- revisar arquitetura fiscal da NFC-e no cenário Hub;
- definir responsabilidade entre terminal, Hub e Central;
- implementar/homologar emissão no cenário online e contingência quando aplicável;
- garantir persistência e sincronização correta dos documentos fiscais.

### 1.7 TEF / Pinpad

- definir integração com TEF;
- definir comunicação com Pinpad;
- tratar autorização, cancelamento e falha de pagamento;
- impedir finalização inconsistente de venda.

### 1.8 Atualização e versionamento

- definir versão do Hub;
- definir estratégia de atualização do Hub e terminais;
- preservar configuração e dados locais durante atualização;
- validar compatibilidade entre versão Central, Hub e frontend local.

### 1.9 Backup e restauração

- definir o que precisa ser preservado localmente;
- criar procedimento de backup;
- criar procedimento de restauração;
- validar recuperação de uma instalação local.

### 1.10 Local Agent

O Local Agent não faz parte do Sysvar Hub, mas deve ser homologado neste ciclo de infraestrutura local.

- instalar/ativar na máquina Windows que recebe ou acessa os XMLs;
- vincular à Empresa correta;
- configurar pasta monitorada;
- validar heartbeat;
- detectar XML real de teste;
- confirmar chegada dos metadados ao Sysvar Central;
- validar comportamento com indisponibilidade temporária da internet.

Referência: [[Implantacao do Local Agent]].

### 1.11 Homologação final da Loja

Validar em conjunto:

- PDV;
- recebimento de mercadoria;
- consulta de vendas;
- devolução de venda;
- Cashback;
- Vale-Troca;
- consulta de estoque;
- caixa;
- sincronização;
- operação offline;
- retorno online.

Ao concluir, atualizar a documentação do [[Sysvar Hub]] e as homologações relacionadas.

---

# Etapa 2 — Produção

O menu atual de Produção possui três áreas principais:

- Ficha Técnica;
- Ordem de Produção;
- Painel de Produção.

## Trabalho previsto

### 2.1 Ficha Técnica

- analisar a implementação atual;
- revisar estrutura de materiais/insumos;
- revisar quantidades e unidades;
- revisar custos;
- revisar vínculos com Produto;
- revisar edição, duplicidade e consistência.

### 2.2 Ordem de Produção

- revisar criação da ordem;
- revisar estados e transições;
- revisar planejamento de quantidade;
- revisar reserva/consumo de insumos;
- revisar entrada do produto acabado;
- revisar cancelamento e estorno;
- revisar rastreabilidade das movimentações.

### 2.3 Painel de Produção

- revisar visão operacional;
- revisar filtros;
- revisar indicadores;
- revisar acompanhamento das ordens;
- revisar usabilidade para operação diária.

### 2.4 Integrações

Validar Produção com:

- Produtos;
- Estoque;
- Compras;
- Financeiro/custos quando aplicável;
- Auditoria.

### 2.5 Fechamento da etapa

- corrigir erros encontrados;
- implementar melhorias aprovadas;
- executar testes;
- homologar fluxo completo;
- documentar.

---

# Etapa 3 — Vendas

O menu atual de Vendas contém mais itens do que apenas Consulta de Vendas. Todos devem entrar na revisão.

## Escopo atual do menu

- Consulta de Vendas;
- Devoluções de Vendas;
- Cashback;
- Vales-Troca;
- Promoções.

## Trabalho previsto

### 3.1 Consulta de Vendas

- revisar filtros;
- revisar período;
- revisar Loja;
- revisar vendedor;
- revisar cliente;
- revisar produto/referência;
- revisar totais e agrupamentos;
- revisar paginação e desempenho;
- revisar exportação quando existente.

### 3.2 Devoluções

- revisar fluxo de devolução;
- revisar estoque;
- revisar caixa/financeiro;
- revisar documento fiscal quando aplicável;
- revisar Vale-Troca quando utilizado;
- revisar permissões e auditoria;
- garantir compatibilidade do fluxo central com a operação offline do Sysvar Hub.

### 3.3 Cashback

- revisar geração;
- revisar utilização;
- revisar validade;
- revisar cancelamento/estorno;
- revisar reflexo financeiro e histórico;
- definir e homologar política segura para uso offline no Sysvar Hub.

### 3.4 Vale-Troca

- revisar emissão;
- revisar utilização;
- revisar saldo;
- revisar cancelamento;
- revisar vínculo com devolução e nova venda;
- garantir sincronização e proteção contra uso duplicado no cenário Hub offline.

### 3.5 Promoções

- revisar regras atuais;
- revisar vigência;
- revisar produtos elegíveis;
- revisar prioridade/conflito entre promoções;
- revisar aplicação no PDV/Hub.

### 3.6 Fechamento da etapa

- testes;
- homologação;
- documentação.

---

# Etapa 4 — Financeiro

## Escopo atual do menu

- Contas a Receber;
- Contas a Pagar;
- Caixa;
- Movimentações de Caixa;
- Contas Bancárias;
- Movimentações Bancárias;
- Antecipações;
- Formas de Pagamento;
- Prazos de Pagamento;
- Naturezas de Lançamento;
- Configuração Financeira;
- Consulta por Natureza.

## Trabalho previsto

### 4.1 Contas a Receber

- origem dos títulos;
- parcelas;
- baixas;
- recebimentos parciais;
- juros/descontos quando aplicáveis;
- cancelamentos e estornos;
- integração com vendas.

### 4.2 Contas a Pagar

- origem dos títulos;
- vínculo com compras e fiscal;
- parcelas;
- baixas;
- pagamentos parciais;
- cancelamentos e estornos.

### 4.3 Caixa

- abertura;
- movimentos;
- sangria;
- suprimento;
- despesas;
- fechamento;
- integração com PDV e Sysvar Hub.

### 4.4 Bancos

- contas bancárias;
- movimentações;
- transferências quando aplicáveis;
- conciliação futura/atual conforme implementação existente.

### 4.5 Antecipações

- revisar fluxo atual;
- revisar impacto nos recebíveis;
- revisar taxas e liquidação quando existentes.

### 4.6 Configurações financeiras

- Formas de Pagamento;
- Prazos de Pagamento;
- Naturezas de Lançamento;
- Configuração Financeira;
- relação com Centro de Custo quando aplicável.

### 4.7 Consultas

- revisar Consulta por Natureza;
- revisar filtros, totais, períodos e desempenho;
- identificar consultas adicionais realmente necessárias.

### 4.8 Fechamento da etapa

- testes integrados;
- homologação;
- documentação.

---

# Etapa 5 — Fiscal / Contábil

O menu não é apenas Fiscal. Ele também contém Contábil e Demonstrativos e deve ser tratado como uma etapa única integrada.

## Escopo atual do menu

### Fiscal

- NCM;
- CFOP;
- Tributos;
- Regras Tributárias.

### Contábil

- Plano Contábil;
- Lançamentos Contábeis.

### Demonstrativos

- DRE.

## Fluxos fiscais transversais que também entram nesta etapa

Mesmo aparecendo em outros menus, devem ser revisados aqui:

- NF-e de entrada;
- XML de fornecedor;
- recebimento com reflexo fiscal;
- NF-e de saída;
- faturamento;
- cancelamentos/eventos fiscais;
- NFC-e do PDV/Hub.

## Trabalho previsto

### 5.1 Estrutura fiscal

- revisar cadastros fiscais;
- revisar regras tributárias;
- revisar coerência entre NCM, CFOP, tributos e operação.

### 5.2 NF-e de entrada

- revisar materialização do XML;
- revisar tratamento fiscal;
- revisar integrações com Compras, Estoque e Financeiro;
- revisar cancelamentos e histórico.

### 5.3 NF-e de saída

Executar o pente fino fiscal completo já registrado em [[Pendências e Melhorias]], incluindo regras oficiais vigentes, XML e consistência dos dados persistidos.

### 5.4 Faturamento

- revisar fila de documentos;
- implementar/revisar seleção múltipla e autorização em lote conforme pendência existente;
- revisar feedback de processamento;
- revisar falhas individuais e reprocessamento.

### 5.5 Contábil

- revisar Plano Contábil;
- revisar geração dos lançamentos;
- revisar origem dos lançamentos por módulo;
- revisar consistência de débito/crédito;
- revisar rastreabilidade até a operação de origem.

### 5.6 DRE

- revisar estrutura;
- revisar período;
- revisar agrupamento das naturezas/contas;
- revisar valores e origem;
- validar contra os lançamentos financeiros/contábeis.

### 5.7 Fechamento da etapa

- testes fiscais e contábeis;
- homologação;
- documentação.

---

# Etapa 6 — Dashboard e fechamento integrado

O Dashboard é um menu principal e deve ser revisado depois dos módulos operacionais, porque depende dos dados produzidos por eles.

## Escopo atual

- Visão Geral;
- Executivo;
- Vendas;
- Produtos;
- Estoque;
- Financeiro;
- Margem / CMV.

## Trabalho previsto

- conferir origem de cada indicador;
- validar filtros e períodos;
- validar isolamento por Empresa/Loja;
- validar totais contra as consultas operacionais;
- revisar desempenho;
- revisar Margem / CMV com dados reais dos fluxos homologados;
- eliminar indicador que não tenha origem confiável.

---

# Etapa 7 — Revisão geral do Sysvar

Após concluir os módulos restantes:

1. revisar permissões e perfis de acesso;
2. revisar menu e rotas órfãs/duplicadas;
3. executar fluxo integrado entre módulos;
4. revisar auditoria;
5. revisar mensagens de erro e feedback de operações demoradas;
6. revisar desempenho das consultas mais pesadas;
7. executar homologação final com base de teste controlada;
8. atualizar [[Pendências e Melhorias]];
9. atualizar documentação técnica e operacional;
10. atualizar o Ubuntu/Viper-II com a versão homologada.

---

# Pendências já registradas que não podem ser esquecidas

As pendências existentes continuam válidas e devem ser absorvidas pela etapa correspondente, sem interromper a sequência atual sem necessidade.

- devolução de venda no PDV offline/Hub, com estoque, caixa e sincronização → Loja / Sysvar Hub;
- Cashback no PDV offline/Hub, incluindo política segura de saldo offline → Loja / Sysvar Hub;
- Vale-Troca no PDV offline/Hub, incluindo emissão e utilização offline → Loja / Sysvar Hub;
- revisão fiscal completa da NF-e de saída → Fiscal / Contábil;
- faturamento com seleção múltipla/autorização em lote → Fiscal / Contábil;
- feedback visual em operações demoradas → revisão transversal;
- compactação da matriz de Distribuição → Distribuição / acabamento;
- recebimento em Loja com tela própria de consulta da NF-e → Loja;
- consulta de Estoque por coleção sem referência específica → Estoque / acabamento;
- limitação de carga da Movimentação de Estoque → Estoque / acabamento;
- formatação inteira na Conferência Física → Recebimento / acabamento.

A fonte detalhada desses itens é [[Pendências e Melhorias]].

---

# Regra de execução para cada etapa

Cada módulo deve seguir a metodologia oficial:

~~~text
Analisar repositório atual
→ identificar ERROS / MELHORIAS / SUGESTÕES
→ discutir e definir escopo
→ aprovar
→ preparar prompt para Codex
→ implementar e testar
→ revisar commit no GitHub
→ homologar passo a passo
→ corrigir quando necessário
→ aprovar
→ documentar no sysvar-vault
~~~

Referência: [[Metodologia de Trabalho]].

## Ordem oficial resumida

~~~text
1. Concluir Loja / Sysvar Hub
2. Produção
3. Vendas
4. Financeiro
5. Fiscal / Contábil
6. Dashboard
7. Revisão geral e homologação final
~~~

## Relacionados

- [[Sysvar]]
- [[Sysvar Hub]]
- [[Pendências e Melhorias]]
- [[Metodologia de Trabalho]]
