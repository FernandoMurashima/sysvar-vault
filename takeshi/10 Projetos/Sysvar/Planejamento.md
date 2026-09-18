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

Fechar a arquitetura local/offline da Loja e homologar o PDV operacional antes de avançar para os demais módulos centrais.

## Princípio da etapa

Devolução, Cashback, Vale-Troca e Promoções são **capacidades operacionais do PDV offline**. Elas devem ser implementadas e validadas no momento em que cada fluxo operacional correspondente for tratado, sem alterar ou privilegiar a sequência principal de desenvolvimento do Sysvar Hub.

Portanto:

- não são quatro projetos independentes dentro do Hub;
- não devem ser esquecidas;
- devem participar dos snapshots, persistência local, regras do PDV e sincronização sempre que o fluxo exigir;
- devem estar cobertas na homologação final do PDV offline.

## Ordem de trabalho do Sysvar Hub

~~~text
1. Estrutura e pendências atuais do Hub
2. Sincronização Central → Hub
3. Sincronização Hub → Central
4. Operação do PDV totalmente offline
5. Pagamentos e finalização da venda
6. Caixa e movimentações locais
7. NFC-e
8. TEF / Pinpad
9. Atualização e versionamento
10. Backup e restauração
11. Homologação completa do Hub
~~~

Durante essa sequência, integrar nos pontos correspondentes:

- Devolução de Venda;
- Cashback;
- Vale-Troca;
- Promoções.

## 1.1 Estrutura e pendências atuais do Hub

- concluir as pendências funcionais já abertas do Hub;
- revisar instalação e execução como serviço;
- validar ativação e vínculo do Hub com Empresa/Loja;
- validar acesso dos Terminais/PDVs pela rede local;
- revisar segurança de acesso dos Terminais;
- revisar bootstrap inicial;
- revisar autenticação do Hub;
- revisar autenticação do Terminal;
- revisar sessão de Operador;
- revisar CaixaHub e SessaoCaixaHub;
- revisar catálogo local;
- revisar carrinho/venda local persistida;
- preservar a regra 1 Loja → 1 Hub → N Terminais.

## 1.2 Sincronização Central → Hub

Revisar e homologar os dados necessários para a operação local, incluindo:

- catálogo;
- estoque da Loja;
- clientes;
- formas de pagamento;
- operadores;
- vendedores;
- tipos de despesa do PDV;
- parâmetros necessários ao Caixa;
- configurações necessárias à venda;
- regras e dados necessários para Devolução;
- configuração e dados necessários para Cashback;
- dados necessários para Vale-Troca;
- Promoções/campanhas aplicáveis ao PDV;
- demais parâmetros necessários para funcionamento sem internet.

Regras gerais:

- Central continua sendo autoridade dos cadastros e configurações corporativas;
- Hub mantém cópia operacional local;
- ausência no snapshot deve seguir regra explícita de inativação/atualização, evitando exclusões indevidas;
- não criar conceitos mestres paralelos no Hub quando já existirem no Central.

## 1.3 Sincronização Hub → Central

Concluir e homologar o retorno das operações locais, incluindo:

- clientes criados/alterados localmente quando aplicável;
- vendas finalizadas;
- pagamentos;
- movimentos de Caixa;
- sessões de Caixa;
- sangrias, suprimentos e despesas quando aplicáveis;
- fechamento do dia;
- Devoluções;
- movimentos de Cashback;
- emissão/utilização/estorno de Vale-Troca;
- identificação e efeitos de Promoções aplicadas às vendas;
- documentos fiscais quando fizerem parte do fluxo;
- mapeamentos de IDs local ↔ Central;
- retry;
- idempotência;
- conflitos;
- recuperação após falha de comunicação.

## 1.4 Operação do PDV totalmente offline

Homologar o PDV com a internet desligada.

Validar:

- login do Operador;
- contexto do Terminal;
- Caixa já aberto ou abertura local;
- consulta do catálogo;
- estoque local;
- busca/bipagem do produto;
- carrinho persistido;
- vendedor;
- cliente;
- venda;
- persistência no MySQL local;
- continuidade após refresh/reinício do navegador;
- indisponibilidade do Central sem bloquear a operação local.

As funções comerciais devem entrar naturalmente nos testes quando aplicáveis:

- aplicar Promoção válida com base nos dados sincronizados;
- gerar Cashback quando a venda for elegível;
- utilizar Cashback conforme a política offline aprovada;
- utilizar Vale-Troca quando disponível;
- iniciar Devolução de venda quando o fluxo estiver implementado.

## 1.5 Pagamentos e finalização da venda

- revisar formas de pagamento locais;
- múltiplas formas na mesma venda quando permitido;
- parcelamento;
- dinheiro e troco;
- PIX quando aplicável;
- cartão/TEF quando aplicável;
- validações de total pago;
- persistência dos pagamentos;
- finalização transacional da venda;
- baixa/reserva de estoque local;
- geração dos eventos de sincronização.

Integrar aqui, quando fizer parte da regra comercial:

- Cashback como geração ou meio/benefício de pagamento;
- Vale-Troca como crédito utilizado na venda;
- Promoção alterando corretamente os valores finais da venda.

Não permitir divergência entre valor comercial, pagamento e total efetivamente finalizado.

## 1.6 Caixa e movimentações locais

- abertura de Caixa;
- status do Caixa;
- fundo inicial;
- sangria;
- suprimento;
- despesas;
- movimentos gerados por venda;
- movimentos gerados por Devolução quando aplicável;
- fechamento;
- bloqueios para venda aberta;
- persistência local;
- sincronização com o Central;
- rastreabilidade por Terminal e Operador.

## 1.7 Devolução dentro da operação do PDV

A Devolução é parte do pós-venda do PDV e deve ser integrada ao fluxo operacional, não tratada como produto separado.

Validar quando chegarmos a esse ponto:

- localização da venda original;
- devolução total;
- devolução parcial;
- limite pela quantidade originalmente vendida;
- retorno ao estoque quando aplicável;
- reflexo no Caixa;
- reflexo nos pagamentos;
- geração de Vale-Troca quando essa for a regra;
- reversão/ajuste de Cashback;
- efeitos fiscais quando aplicáveis;
- persistência local;
- sincronização posterior sem duplicidade.

## 1.8 Cashback dentro da operação do PDV

Cashback deve ser considerado em Venda e Devolução.

Validar:

- configuração sincronizada;
- geração em venda elegível;
- consulta/uso quando permitido;
- estorno/cancelamento;
- impacto de Devolução;
- persistência local;
- sincronização posterior;
- idempotência.

Antes de permitir consumo totalmente offline, definir a política segura para saldo que possa estar desatualizado em relação a outras Lojas.

## 1.9 Vale-Troca dentro da operação do PDV

Vale-Troca deve integrar Devolução e nova Venda.

Validar:

- emissão;
- identificação única;
- saldo;
- utilização total ou parcial conforme regra;
- cancelamento/estorno;
- persistência local;
- sincronização;
- proteção contra duplicidade/uso duplo.

## 1.10 Promoções dentro da operação do PDV

Promoções devem ser aplicadas no momento normal da venda, usando configuração recebida do Central.

Validar:

- snapshot das Promoções aplicáveis;
- vigência;
- elegibilidade dos produtos/itens;
- condições mínimas;
- desconto ou benefício;
- prioridade e conflitos;
- persistência na venda da promoção aplicada;
- sincronização dos valores e identificação promocional;
- comportamento offline quando a vigência termina antes da próxima sincronização.

O Hub não cria regra promocional própria: ele executa localmente a regra corporativa sincronizada.

## 1.11 NFC-e

- revisar arquitetura fiscal da NFC-e no cenário Hub;
- definir responsabilidade entre Terminal, Hub e Central;
- emissão no cenário online;
- estratégia de contingência/offline quando aplicável;
- persistência local do documento;
- numeração e identidade fiscal;
- cancelamento/eventos quando aplicáveis;
- sincronização posterior;
- consistência entre venda e documento fiscal.

## 1.12 TEF / Pinpad

- definir integração com TEF;
- definir comunicação com Pinpad;
- autorização;
- confirmação;
- cancelamento;
- falha de pagamento;
- reversão;
- reconciliação com a venda;
- impedir finalização inconsistente.

## 1.13 Atualização e versionamento

- definir versão do Hub;
- definir versão compatível do frontend local;
- definir estratégia de atualização;
- preservar configuração e dados locais;
- preservar filas pendentes;
- validar compatibilidade Central ↔ Hub;
- impedir atualização que deixe operação local inconsistente.

## 1.14 Backup e restauração

- definir dados locais que precisam ser preservados;
- banco local;
- configuração;
- credenciais protegidas;
- filas/eventos ainda não sincronizados;
- criar procedimento de backup;
- criar procedimento de restauração;
- validar recuperação de uma instalação.

## 1.15 Homologação completa do Sysvar Hub

Executar homologação integrada com internet ligada e desligada.

Validar no mínimo:

- ativação do Hub;
- Terminal pareado;
- Operador;
- Caixa;
- catálogo;
- estoque;
- cliente;
- vendedor;
- carrinho;
- venda;
- pagamentos;
- movimentações de Caixa;
- Devolução;
- Cashback;
- Vale-Troca;
- Promoções;
- NFC-e;
- TEF/Pinpad quando disponível;
- sincronização Central → Hub;
- sincronização Hub → Central;
- retry;
- idempotência;
- reconexão;
- ausência de duplicidades;
- consistência de estoque, Caixa, venda e benefícios comerciais.

Somente depois da homologação completa do Hub seguimos para Produção.

## Atividade paralela — Local Agent

O Local Agent não faz parte do Sysvar Hub, mas precisa ser homologado no mesmo ciclo de infraestrutura local.

- instalar/ativar na máquina Windows que recebe ou acessa os XMLs;
- vincular à Empresa correta;
- configurar pasta monitorada;
- validar heartbeat;
- detectar XML real de teste;
- confirmar chegada dos metadados ao Sysvar Central;
- validar indisponibilidade temporária da internet.

Referência: [[Implantacao do Local Agent]].

---

# Etapa 2 — Produção

O menu atual de Produção possui:

- Ficha Técnica;
- Ordem de Produção;
- Painel de Produção.

## 2.1 Ficha Técnica

- analisar a implementação atual;
- revisar estrutura de materiais/insumos;
- revisar quantidades e unidades;
- revisar custos;
- revisar vínculos com Produto;
- revisar edição, duplicidade e consistência.

## 2.2 Ordem de Produção

- revisar criação;
- revisar estados e transições;
- planejamento de quantidade;
- reserva/consumo de insumos;
- entrada do produto acabado;
- cancelamento e estorno;
- rastreabilidade das movimentações.

## 2.3 Painel de Produção

- revisar visão operacional;
- filtros;
- indicadores;
- acompanhamento das ordens;
- usabilidade diária.

## 2.4 Integrações

Validar Produção com:

- Produtos;
- Estoque;
- Compras;
- Financeiro/custos quando aplicável;
- Auditoria.

## 2.5 Fechamento

- corrigir erros;
- implementar melhorias aprovadas;
- testar;
- homologar fluxo completo;
- documentar.

---

# Etapa 3 — Vendas

O menu atual de Vendas contém:

- Consulta de Vendas;
- Devoluções de Vendas;
- Cashback;
- Vales-Troca;
- Promoções.

Nesta etapa será revisado o **domínio central de Vendas**. Devolução, Cashback, Vale-Troca e Promoções também terão sua implementação central revisada, incluindo a coerência com o que foi implementado no PDV/Hub offline.

## 3.1 Consulta de Vendas

- filtros;
- período;
- Loja;
- vendedor;
- cliente;
- produto/referência;
- totais e agrupamentos;
- paginação e desempenho;
- exportação quando existente.

## 3.2 Devoluções

- fluxo central;
- estoque;
- Caixa/Financeiro;
- documento fiscal quando aplicável;
- Vale-Troca;
- Cashback;
- permissões;
- Auditoria;
- integração com operações sincronizadas do Hub.

## 3.3 Cashback

- geração;
- utilização;
- validade;
- cancelamento/estorno;
- reflexo financeiro;
- histórico;
- coerência com operações sincronizadas do Hub.

## 3.4 Vale-Troca

- emissão;
- utilização;
- saldo;
- cancelamento;
- vínculo com Devolução e nova Venda;
- integração com Hub.

## 3.5 Promoções

- regras atuais;
- vigência;
- produtos elegíveis;
- prioridade/conflito;
- aplicação no PDV/Hub;
- consistência dos valores sincronizados.

## 3.6 Fechamento

- testes;
- homologação;
- documentação.

---

# Etapa 4 — Financeiro

## Escopo atual

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

## 4.1 Contas a Receber

- origem dos títulos;
- parcelas;
- baixas;
- recebimentos parciais;
- juros/descontos quando aplicáveis;
- cancelamentos/estornos;
- integração com Vendas.

## 4.2 Contas a Pagar

- origem dos títulos;
- Compras/Fiscal;
- parcelas;
- baixas;
- pagamentos parciais;
- cancelamentos/estornos.

## 4.3 Caixa

- abertura;
- movimentos;
- sangria;
- suprimento;
- despesas;
- fechamento;
- integração com PDV e Sysvar Hub.

## 4.4 Bancos

- contas bancárias;
- movimentações;
- transferências quando aplicáveis;
- conciliação conforme implementação existente ou futura aprovada.

## 4.5 Antecipações

- fluxo atual;
- impacto nos recebíveis;
- taxas e liquidação quando existentes.

## 4.6 Configurações financeiras

- Formas de Pagamento;
- Prazos de Pagamento;
- Naturezas de Lançamento;
- Configuração Financeira;
- relação com Centro de Custo quando aplicável.

## 4.7 Consultas

- Consulta por Natureza;
- filtros;
- totais;
- períodos;
- desempenho;
- identificar consultas adicionais realmente necessárias.

## 4.8 Fechamento

- testes integrados;
- homologação;
- documentação.

---

# Etapa 5 — Fiscal / Contábil

## Escopo atual

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

### Fluxos fiscais transversais

- NF-e de entrada;
- XML de fornecedor;
- recebimento com reflexo fiscal;
- NF-e de saída;
- faturamento;
- cancelamentos/eventos fiscais;
- NFC-e do PDV/Hub.

## 5.1 Estrutura fiscal

- cadastros fiscais;
- regras tributárias;
- coerência entre NCM, CFOP, tributos e operação.

## 5.2 NF-e de entrada

- materialização do XML;
- tratamento fiscal;
- integração com Compras, Estoque e Financeiro;
- cancelamentos e histórico.

## 5.3 NF-e de saída

Executar o pente fino fiscal completo registrado em [[Pendências e Melhorias]], utilizando regras oficiais vigentes.

## 5.4 Faturamento

- fila de documentos;
- seleção múltipla/autorização em lote conforme pendência existente;
- feedback de processamento;
- falhas individuais;
- reprocessamento.

## 5.5 Contábil

- Plano Contábil;
- geração dos lançamentos;
- origem por módulo;
- consistência débito/crédito;
- rastreabilidade até a operação de origem.

## 5.6 DRE

- estrutura;
- período;
- agrupamento de naturezas/contas;
- valores e origem;
- validação contra Financeiro/Contábil.

## 5.7 Fechamento

- testes fiscais/contábeis;
- homologação;
- documentação.

---

# Etapa 6 — Dashboard e fechamento integrado

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
- validar totais contra consultas operacionais;
- revisar desempenho;
- revisar Margem / CMV com dados dos fluxos homologados;
- eliminar indicador sem origem confiável.

---

# Etapa 7 — Revisão geral do Sysvar

Após concluir os módulos restantes:

1. revisar permissões e perfis de acesso;
2. revisar menu e rotas órfãs/duplicadas;
3. executar fluxo integrado entre módulos;
4. revisar Auditoria;
5. revisar mensagens de erro e feedback de operações demoradas;
6. revisar desempenho das consultas pesadas;
7. executar homologação final com base de teste controlada;
8. atualizar [[Pendências e Melhorias]];
9. atualizar documentação técnica e operacional;
10. atualizar o Ubuntu/Viper-II com a versão homologada.

---

# Pendências já registradas que não podem ser esquecidas

- Devolução no PDV offline/Hub → integrar ao fluxo operacional do PDV e sincronização;
- Cashback no PDV offline/Hub → integrar a Venda/Devolução e definir política segura de saldo offline;
- Vale-Troca no PDV offline/Hub → integrar Devolução e nova Venda;
- Promoções no PDV offline/Hub → integrar ao cálculo normal da Venda e sincronização;
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
