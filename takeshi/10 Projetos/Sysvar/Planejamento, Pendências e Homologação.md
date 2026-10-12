---
type: project
status: active
project: Sysvar
source: "FernandoMurashima/sysvarbackend + FernandoMurashima/sysvarfrontend + FernandoMurashima/sysvarhub-backend + FernandoMurashima/sysvarhub-frontend + FernandoMurashima/sysvar-vault"
created: 2026-09-10
updated: 2026-10-12
tags:
  - sysvar
  - planejamento
  - pendencias
  - homologacao
  - roadmap
---

# Planejamento, Pendências e Homologação — Sysvar

## Objetivo

Este documento é a **fonte única de controle do Projeto Sysvar** para:

- situação atual;
- sequência oficial de trabalho;
- pendências abertas;
- melhorias;
- análises futuras;
- homologações necessárias;
- decisões já encerradas que não devem ser reabertas sem motivo concreto.

Ele substitui os antigos documentos `Planejamento.md` e `Pendências e Melhorias.md`.

A documentação técnica, funcional, de decisão, homologação e operação continua em seus documentos específicos. Este arquivo controla **o que já foi encerrado, o que falta fazer e em que ordem trabalhar**.

---

# 1. Regra de trabalho

Para cada etapa:

~~~text
ANALISAR
↓
identificar ERROS / MELHORIAS / SUGESTÕES
↓
DEFINIR
↓
FECHAR REGRAS
↓
IMPLEMENTAR
↓
REVISAR
↓
CORRIGIR
↓
HOMOLOGAR
↓
APROVAR
↓
DOCUMENTAR
~~~

Regras:

- não reabrir fluxo já homologado apenas por existir melhoria de acabamento;
- consultar documentação e código atuais antes de implementar;
- aplicar a prioridade REAPROVEITAR → REFATORAR → ESTENDER → CRIAR;
- separar claramente erro, melhoria e sugestão;
- implementar somente depois da definição funcional;
- homologar funcionalmente antes do encerramento quando a natureza da tarefa exigir;
- registrar commit e documentação quando uma pendência for concluída.

---

# 2. Estado atual consolidado

## 2.1 Fluxo de Revenda

Status:

~~~text
CONCLUÍDO
HOMOLOGADO DE PONTA A PONTA
~~~

Fluxo validado:

~~~text
Pedido de Compra
↓
Aprovação
↓
NF-e de entrada / XML
↓
Local Agent
↓
Recebimento na Fábrica / Almoxarifado
↓
Conferência física
↓
Efetivação do estoque
↓
Custos por SKU
↓
Distribuição
↓
Pedido de Venda de Distribuição por loja
↓
NF-e de saída
↓
Autorização
↓
Mercadoria em trânsito
↓
Recebimento na loja
↓
Entrada no estoque da loja
↓
Movimentação de estoque
~~~

Massa da homologação:

- 5 Pedidos de Compra de mercadoria de revenda;
- 5 fornecedores;
- 5 XMLs de NF-e de entrada;
- destino inicial: Fábrica;
- 17.580 peças recebidas;
- 990 SKUs;
- distribuição para 3 lojas;
- Loja Barra: 6.264 peças;
- Loja Tijuca: 5.830 peças;
- Loja Centro: 5.486 peças;
- custo total da distribuição: R$ 1.497.442,00;
- valor total de venda com fator de 20%: R$ 1.796.930,40;
- 3 Pedidos de Venda de Distribuição gerados;
- 3 NF-e de saída geradas e autorizadas;
- recebimento da Loja Barra validado com usuário Gerente da própria loja;
- isolamento por loja confirmado;
- estoque e movimentação confirmados após recebimento.

Correções concluídas nessa homologação:

- paginação completa da Distribuição — commit `bd7997c`;
- saldo e valores por SKU na matriz — commit `d800ea0`;
- persistência de custos no recebimento — commit `666178b`;
- comando idempotente `python manage.py reparar_custos_recebimentos_mercadoria`.

Melhorias de acabamento não reabrem esse fluxo.

## 2.2 Cadastros, Produtos e Compras

O planejamento anterior registrou como já trabalhados e/ou homologados:

- Cadastros;
- Produtos;
- Compras;
- Estoque;
- Distribuição.

Os estados detalhados e homologações continuam nos documentos próprios do vault.

## 2.3 Sysvar Hub / PDV

Já concluídos e homologados no ciclo atual, conforme documentação e homologações específicas:

- operação principal do PDV;
- venda local;
- Consulta de Vendas F12;
- pagamentos e recebíveis já homologados;
- Caixa e movimentos já tratados no fluxo corrente;
- Devolução;
- Vale-Troca;
- Fotos de Produto no PDV;
- sincronizações já homologadas no escopo tratado;
- numeração comercial já homologada.

Regra explícita:

**Devolução e Vale-Troca não são pendências. Não reabrir sem defeito novo, requisito novo ou nova decisão funcional.**

### NFC-e no Hub

A arquitetura aprovada permanece:

~~~text
Terminal PDV
→ solicita/finaliza a operação comercial

Sysvar Hub
→ controla numeração fiscal
→ gera chave/XML
→ assina
→ gera QR Code
→ persiste documento e estados
→ opera contingência
→ disponibiliza DANFE
→ sincroniza posteriormente com o Central

Sysvar Central
→ autoridade de cadastros e parâmetros corporativos/fiscais
→ recebe documentos e eventos do Hub
~~~

Regra estrutural:

~~~text
1 Loja → 1 Hub → N Terminais
~~~

O desenvolvimento interno previsto sem certificado real foi encerrado. A homologação externa real com SEFAZ/A1 válido continua pendente e deve ocorrer no fechamento fiscal adequado.

Referência técnica atual: [[Mapa Técnico - Sysvar Hub - NFC-e]].

## 2.4 Vendas — Central

A Consulta individual de Vendas da Central foi implementada e homologada, preservando os relatórios agregados existentes.

O domínio de Vendas continua relacionado às integrações de Devolução, Cashback, Vale-Troca e Promoções, mas não deve reabrir funções já homologadas sem necessidade concreta.

## 2.5 Financeiro — decisões já fechadas

Já foram aprovadas regras estruturais de:

- Forma de Pagamento;
- Prazos;
- FormaPagamentoCondicao;
- adquirentes e condições;
- taxas;
- geração de recebíveis;
- parcelamento;
- integração financeira das vendas tratadas no ciclo atual.

A revisão futura do Financeiro deve preservar essas decisões, salvo defeito comprovado ou novo requisito.

---

# 3. Sequência oficial atual

A sequência antiga foi atualizada porque partes relevantes de Loja/Hub e Vendas já foram concluídas.

Ordem atual:

~~~text
1. Acabamentos e pendências operacionais já conhecidas
2. Produção
3. Financeiro
4. Fiscal / Contábil funcional
5. Dashboards e CMV
6. Padronização visual Central + Hub
7. Revisão integrada final
8. Revisão fiscal completa oficial da NF-e
~~~

A **revisão fiscal completa oficial da NF-e permanece como último item**, por decisão explícita do projeto.

---

# 4. Pendências operacionais

## P2 — Faturamento com seleção múltipla e autorização em lote

Status: PENDENTE

Necessidade:

- selecionar várias NF-e;
- executar Enviar/Autorizar uma única vez;
- processar os documentos selecionados;
- apresentar resultado individual;
- impedir cliques repetidos durante processamento.

Evolução futura possível:

- agente/serviço automático para processar fila de NF-e.

A consulta/detalhamento individual permanece separada da seleção múltipla.

## P3 — Feedback visual em operações demoradas

Status: PENDENTE

Aplicar indicador de processamento e bloqueio temporário em operações como:

- Carregar para matriz;
- Confirmar distribuição;
- Gerar pedidos;
- Gerar NF-e;
- Enviar/Autorizar NF-e em lote;
- outras operações demoradas identificadas depois.

Mensagens de referência:

- `Carregando estoque. Aguarde...`
- `Confirmando distribuição. Aguarde...`
- `Gerando pedidos. Aguarde...`
- `Gerando NF-e. Aguarde...`
- `Autorizando NF-e. Aguarde...`

Objetivo: evitar dúvida e reenvio por clique repetido.

## P4 — Compactar matriz de Distribuição

Status: PENDENTE

Objetivo:

~~~text
SKU | Descrição | Código de barras | Cor | Tam. | Custo un. | Venda un. | Disp. | Loja 1 | Loja 2 | ... | Total | Saldo
~~~

Cada SKU deve ocupar uma linha física.

Preservar:

- lojas dinâmicas;
- edição;
- custo;
- venda;
- disponível;
- total;
- saldo;
- scroll horizontal;
- comportamento homologado.

## P5 — Recebimento de Loja

Status: PENDENTE

O recebimento deve evoluir para uma experiência própria da Loja/Hub, evitando a grade extensa na listagem da Central.

Fluxo desejado:

~~~text
Lista de notas para recebimento
↓
Selecionar nota
↓
Consultar
↓
Tela própria da NF-e / Recebimento
↓
Conferir
↓
Lançar no estoque
~~~

Cabeçalho:

- NF-e;
- origem;
- loja destino;
- emissão/saída;
- status;
- chave;
- protocolo.

Resumo:

- valor dos produtos;
- descontos;
- frete;
- total;
- itens/SKUs;
- quantidade total;
- volumes/transporte quando válidos;
- natureza da operação;
- resumo tributário.

Itens/conferência:

- referência;
- descrição;
- cor;
- tamanho;
- EAN;
- enviado;
- recebido;
- valor unitário;
- total.

Ações previstas:

- Tudo recebido;
- Zerar;
- Lançar no estoque.

Não apresentar valores fiscais inventados.

## P6 — Consulta por Referência / Coleção

Status: PENDENTE PARA DECISÃO/IMPLEMENTAÇÃO

Regra proposta:

- Referência preenchida → somente aquela referência;
- Referência vazia + Coleção preenchida → todas as referências da coleção;
- Referência vazia + Coleção vazia → não carregar todo o estoque automaticamente.

Manter diferença de apresentação entre Consulta por Referência e Consulta por Coleção.

## P7 — Limitar carga da Movimentação de Estoque

Status: PENDENTE

Revisar:

- isolamento por Loja;
- filtro de Loja;
- Referência/EAN;
- Data inicial;
- Data final;
- tipo/origem;
- período padrão reduzido;
- paginação e carga compatíveis com grande volume.

Objetivo: evitar degradação progressiva.

## P8 — Formatação inteira na Conferência Física

Status: PENDENTE

Para mercadoria tratada como peça inteira, apresentar sem casas decimais:

- Qtd Pedido;
- Qtd NF-e;
- Qtd Física;
- comparativos;
- Esperado;
- Recebido;
- Diferença;
- Última leitura.

Preferir correção de apresentação/entrada sem alterar tipos de banco desnecessariamente.

---

# 5. Sysvar Hub — pendências restantes

## P9 — Cashback

Status: PENDENTE — SOMENTE CASHBACK

A Devolução e o Vale-Troca no Hub já foram implementados, testados e homologados.

A única pendência deste item é integrar o Cashback existente no Central ao Hub, inclusive offline.

Revisar/implementar:

- snapshot da configuração;
- geração em venda elegível;
- utilização quando permitida;
- cancelamento/estorno;
- impacto de devolução/cancelamento;
- persistência local;
- sincronização posterior;
- idempotência;
- política segura para saldo possivelmente desatualizado entre lojas.

Homologação futura:

1. venda gerando Cashback;
2. venda utilizando Cashback;
3. estorno/cancelamento;
4. operação offline;
5. reconexão;
6. confirmação no Central sem duplicidade.

## P10 — Substituir quadro de Vale-Troca por Recebimento de Loja

Status: PENDENTE — NAVEGAÇÃO/QUADRO

Diretriz:

- retirar quadro independente de Vale-Troca;
- colocar Recebimento de Loja;
- Vale-Troca continua interno à Devolução e à nova Venda;
- não remover a lógica de Vale-Troca;
- a implementação funcional de Recebimento deve ser tratada com P5.

## P11 — Promoções Central → Hub

Status: PENDENTE DE VERIFICAÇÃO/INTEGRAÇÃO

Validar:

- criação;
- alteração;
- vigência;
- produtos/SKUs;
- preço promocional;
- sincronização Central → Hub;
- aplicação no PDV;
- comportamento offline;
- expiração;
- ausência de preço obsoleto.

Se já existir, homologar e documentar. Se estiver incompleta, corrigir em etapa própria.

## 5.1 Itens estruturais herdados do roadmap do Hub

Estes itens existiam no planejamento anterior e permanecem registrados para não serem perdidos:

### TEF / Pinpad

- definir integração;
- autorização;
- confirmação;
- cancelamento;
- falha;
- reversão;
- reconciliação;
- impedir finalização inconsistente.

Execução condicionada à disponibilidade/definição da integração real.

### Atualização e versionamento

- versão do Hub;
- compatibilidade do frontend local;
- estratégia de atualização;
- preservação de configuração e dados;
- preservação de filas;
- compatibilidade Central ↔ Hub;
- impedir atualização inconsistente.

### Backup e restauração

- banco local;
- configuração;
- credenciais protegidas;
- filas/eventos;
- documentos/XML fiscais locais;
- procedimento de backup;
- procedimento de restauração;
- validação de recuperação.

### Homologação integrada final do Hub

Ao fechar as pendências restantes, revalidar o conjunto aplicável:

- ativação;
- Terminal;
- Operador;
- Caixa;
- catálogo;
- estoque;
- fotos;
- cliente;
- vendedor;
- carrinho;
- venda;
- pagamentos;
- movimentos;
- Cashback;
- Promoções;
- NFC-e no escopo disponível;
- sincronização;
- retry;
- idempotência;
- reconexão;
- ausência de duplicidades.

Devolução e Vale-Troca já homologados só entram como regressão final, não como pendência aberta.

### Local Agent — atividade paralela

Preservar a necessidade de validar:

- instalação/ativação;
- vínculo com Empresa;
- pasta monitorada;
- heartbeat;
- XML real;
- chegada de metadados ao Central;
- indisponibilidade temporária da internet.

Referência: [[Implantacao do Local Agent]].

---

# 6. Navegação da Central

## P12 — Reorganizar menu Distribuição

Status: PENDENTE — AJUSTE LEVE

Estrutura desejada:

~~~text
Distribuição
├─ Distribuição
├─ Pedido de Venda
└─ Faturamento
~~~

Remover da navegação intermediária:

- Configuração;
- Operação;
- Perfil Distribuição.

Preservar rotas e regras.

## P14 — Ocultar menu Loja

Status: PENDENTE — NAVEGAÇÃO/ARQUITETURA FUNCIONAL

Diretriz:

- Central não deve concentrar operações diárias da Loja;
- operações de loja devem migrar para o Hub quando apropriado;
- ocultar o menu sem apagar código/rotas antes de revisar dependências;
- classificar cada opção atual em: Hub, outra área da Central ou retirada da navegação;
- Recebimento de Mercadoria deve orientar a futura funcionalidade Recebimento de Loja no Hub.

---

# 7. Produção

## P13 — Analisar, verificar, sugerir melhorias e homologar

Status: PENDENTE DE ANÁLISE

O módulo já recebeu alterações anteriormente. A revisão deve começar pela documentação e código atuais.

## 7.1 Ficha Técnica

Revisar:

- materiais/insumos;
- quantidades;
- unidades;
- custos;
- vínculos com Produto;
- edição;
- duplicidade;
- consistência;
- composição do custo de produção.

## 7.2 Ordem de Produção

Revisar:

- criação;
- estados e transições;
- planejamento;
- reserva/consumo;
- entrada do produto acabado;
- cancelamento/estorno;
- rastreabilidade.

## 7.3 Painel de Produção

Revisar:

- visão operacional;
- filtros;
- indicadores;
- acompanhamento;
- usabilidade diária.

## 7.4 Integrações

Validar com:

- Produtos;
- Estoque;
- Compras;
- Financeiro/custos;
- Auditoria;
- Distribuição quando aplicável.

## 7.5 Fechamento

- classificar ERROS / MELHORIAS / SUGESTÕES;
- corrigir erros;
- aprovar melhorias;
- testar;
- homologar;
- documentar.

---

# 8. Vendas — revisão residual do domínio Central

O planejamento anterior previa revisão completa de:

- Consulta de Vendas;
- Devoluções;
- Cashback;
- Vale-Troca;
- Promoções.

Estado atual:

- Consulta individual de Vendas da Central está concluída e homologada;
- Devolução e Vale-Troca no Hub estão concluídos e homologados;
- Cashback permanece como integração Hub pendente em P9;
- Promoções permanecem como verificação Hub pendente em P11.

Ao revisar Vendas no fechamento integrado, preservar:

- estoque;
- Caixa/Financeiro;
- documentos fiscais aplicáveis;
- permissões;
- Auditoria;
- sincronização com Hub;
- validade, saldo, cancelamento e estornos dos benefícios;
- consistência dos valores promocionais.

---

# 9. Financeiro

## P15 — Analisar, sugerir melhorias e homologar

Status: PENDENTE DE ANÁLISE E HOMOLOGAÇÃO

Preservar decisões financeiras já homologadas.

## 9.1 Contas a Receber

Revisar:

- origem;
- parcelas;
- baixas;
- recebimentos parciais;
- juros/descontos quando aplicáveis;
- cancelamentos/estornos;
- integração com Vendas.

## 9.2 Contas a Pagar

Revisar:

- origem;
- Compras/Fiscal;
- parcelas;
- baixas;
- pagamentos parciais;
- cancelamentos/estornos.

## 9.3 Caixa

Revisar:

- abertura;
- movimentos;
- sangria;
- suprimento;
- despesas;
- fechamento;
- integração com PDV/Hub.

## 9.4 Bancos

Revisar:

- contas bancárias;
- movimentações;
- transferências;
- conciliação conforme implementação aprovada.

## 9.5 Antecipações / Adiantamentos

Revisar:

- fluxo;
- impacto nos recebíveis;
- taxas;
- liquidação.

## 9.6 Configurações

Revisar:

- Formas de Pagamento;
- Prazos;
- Naturezas;
- Configuração Financeira;
- relação com Centro de Custo quando aplicável.

## 9.7 Consultas

Revisar:

- Consulta por Natureza;
- filtros;
- totais;
- períodos;
- desempenho;
- consultas adicionais somente se realmente necessárias.

## 9.8 Fechamento

- identificar erros, inconsistências, redundâncias e lacunas;
- separar erro/melhoria/sugestão;
- revisar integrações com Vendas, Compras, Hub e Fiscal;
- homologar fluxos considerados prontos;
- documentar.

---

# 10. Fiscal / Contábil

## P16 — Analisar, sugerir melhorias e homologar

Status: PENDENTE DE ANÁLISE E HOMOLOGAÇÃO

Esta revisão funcional não antecipa a revisão fiscal oficial completa da NF-e, que permanece no fim do roadmap.

## 10.1 Fiscal

Revisar:

- NCM;
- CFOP;
- Tributos;
- Regras Tributárias;
- coerência por operação;
- NF-e de entrada;
- XML de fornecedor;
- recebimento com reflexo fiscal;
- NF-e de saída;
- faturamento;
- cancelamentos/eventos;
- NFC-e Hub.

## 10.2 Contábil

Revisar:

- Plano Contábil;
- lançamentos;
- origem por módulo;
- débito/crédito;
- rastreabilidade;
- DRE.

## 10.3 Faturamento

Incorporar P2:

- fila;
- seleção múltipla;
- autorização em lote;
- feedback;
- falha individual;
- reprocessamento.

## 10.4 Fechamento funcional

- testes;
- homologação;
- documentação.

A revisão oficial completa de leiaute/regras fiscais fica no P1, ao final.

---

# 11. CMV

## P19 — Revisar composição, origem e utilização do custo

Status: PENDENTE DE ANÁLISE E CORREÇÃO

Problema observado:

- CMV aparece zerado no Dashboard Margem/CMV;
- como consequência, a margem aparece igual à receita.

## 11.1 Produto de revenda

Origem esperada:

~~~text
Pedido de Compra
↓
Fornecedor
↓
NF-e / Recebimento
↓
Custo do produto/SKU
↓
Venda
↓
CMV
~~~

O CMV deve refletir o custo de aquisição persistido de forma coerente.

## 11.2 Produção própria

Origem esperada:

~~~text
Ficha Técnica
↓
matérias-primas / insumos / componentes / custos de produção
↓
Produto acabado
↓
Venda
↓
CMV
~~~

Não inventar nova regra de custeio antes de revisar o módulo de Produção.

## 11.3 Pontos obrigatórios

- onde o custo de revenda é persistido;
- se o custo da compra chega ao SKU/estoque;
- qual custo a Venda grava/referencia;
- preservação histórica;
- evitar alteração retroativa de vendas antigas;
- ligação da produção própria com Ficha Técnica;
- cálculo de CMV;
- cálculo de Margem Bruta;
- Dashboard;
- causa do CMV zerado;
- separar dado ausente, erro e regra não implementada;
- homologar revenda e produção própria.

Regra conceitual:

~~~text
Margem Bruta = Receita de Venda - CMV
~~~

---

# 12. Dashboards

## P17 — Analisar, sugerir melhorias e homologar

Status: PENDENTE DE ANÁLISE E HOMOLOGAÇÃO

Escopo herdado do planejamento:

- Visão Geral;
- Executivo;
- Vendas;
- Produtos;
- Estoque;
- Financeiro;
- Margem / CMV.

Para cada indicador:

~~~text
qual é a origem?
↓
qual é a regra?
↓
o número confere?
↓
os filtros funcionam?
↓
o indicador tem utilidade?
~~~

Revisar:

- indicadores;
- fontes;
- filtros;
- períodos;
- agrupamentos;
- isolamento Empresa/Loja;
- totais contra consultas operacionais;
- desempenho;
- usabilidade;
- clareza visual;
- redundâncias;
- indicadores sem origem confiável.

---

# 13. Padronização visual e modernização

## P18 — Central + Hub

Status: PENDENTE DE ANÁLISE, DEFINIÇÃO DE PADRÃO E HOMOLOGAÇÃO

Objetivo: Central e Hub devem parecer partes do mesmo produto.

## 13.1 Estrutura de tela

Padronizar:

- área ampla/tela cheia;
- menu lateral recolhível/ocultável;
- cabeçalhos;
- título/contexto/ações/status;
- filtros compactos;
- tabelas;
- detalhes em painel/drawer/modal/seção expansível;
- paginação.

## 13.2 Design System Sysvar

Definir:

- tipografia;
- títulos;
- espaçamentos;
- raios;
- sombras;
- hierarquia de botões;
- cores de status;
- badges;
- campos;
- selects;
- tabelas;
- paginação;
- mensagens;
- loading;
- estados vazios;
- ícones.

## 13.3 Modernização / “florzinhas”

Avaliar:

- ícones coerentes;
- microinterações;
- hover/seleção refinados;
- status visuais;
- transições curtas;
- melhor hierarquia;
- realce de totais/informações-chave;
- feedback de ações;
- identidade visual Sysvar.

Evitar:

- cartões em excesso;
- cores sem função;
- animações chamativas;
- espaço vazio excessivo;
- componentes diferentes para funções equivalentes;
- perda de densidade operacional.

## 13.4 Estratégia

~~~text
analisar Central + Hub
↓
identificar inconsistências
↓
escolher 2 ou 3 telas representativas
↓
criar proposta
↓
homologar padrão
↓
replicar gradualmente
~~~

---

# 14. Revisão integrada final

Após os módulos e pendências:

1. revisar permissões e perfis;
2. revisar menu e rotas órfãs/duplicadas;
3. executar fluxos integrados;
4. revisar Auditoria;
5. revisar mensagens e feedback;
6. revisar desempenho;
7. validar Central ↔ Hub;
8. validar estoque;
9. validar financeiro;
10. validar produção;
11. validar vendas;
12. validar dashboards;
13. homologar com base controlada;
14. atualizar documentação;
15. atualizar ambiente de produção homologado quando aplicável.

---

# 15. Revisão fiscal oficial final

## P1 — Revisão fiscal completa da NF-e de saída

Status: PENDENTE — EXECUTAR POR ÚLTIMO

Revisar com especificação oficial vigente:

- campos obrigatórios;
- campos condicionais;
- emitente;
- destinatário;
- natureza;
- CFOP;
- NCM;
- tributação;
- totais;
- transporte;
- volumes;
- frete;
- chave;
- protocolo;
- ambiente;
- XML;
- consistência entre persistência e documento;
- notas técnicas vigentes;
- mudanças oficiais aplicáveis, inclusive Reforma Tributária quando couber.

Não assumir obrigatoriedade universal de grupos condicionais.

---

# 16. Regra de encerramento

Uma pendência só deixa o estado aberto quando, conforme aplicável:

~~~text
IMPLEMENTADA
+
REVISADA
+
TESTADA
+
HOMOLOGADA
+
APROVADA
+
DOCUMENTADA
~~~

Depois disso, o fato de estar concluída permanece registrado para evitar reabertura indevida.

---

# 17. Referências principais

- [[Sysvar]]
- [[Sysvar Hub]]
- [[Mapa Técnico - Sysvar Hub - NFC-e]]
- [[Mapa Técnico - Sysvar Hub - Fotos de Produto no PDV]]
- [[Metodologia de Trabalho]]
- [[Protocolo de Trabalho com IA]]
- [[Fluxo de Desenvolvimento e Homologacao]]
- [[Padrao de Prompts para Codex]]

---

# 18. Preservação integral dos documentos substituídos

As seções abaixo preservam integralmente os conteúdos dos dois documentos substituídos para que nenhuma informação, detalhe técnico, histórico, commit, regra ou contexto seja perdido.

**Importante:** os snapshots abaixo são históricos. Quando houver diferença de status, prioridade ou decisão, prevalecem as seções 1 a 17 deste documento e as documentações técnicas/homologações mais atuais.

---

# Anexo A — Snapshot integral do antigo Planejamento.md

````markdown
---
type: project
status: active
project: Sysvar
source: "FernandoMurashima/sysvarbackend + FernandoMurashima/sysvarfrontend + FernandoMurashima/sysvarhub-backend + FernandoMurashima/sysvarhub-frontend"
created: 2026-09-18
updated: 2026-09-20
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

Fotos de Produto também são uma **capacidade operacional do PDV**. A integração principal foi implementada e validada na etapa corrente, sem virar uma etapa independente nem alterar a ordem principal do desenvolvimento.

Estado das Fotos de Produto em 20/09/2026:

- foto principal do Central é sincronizada e mantida localmente pelo Hub;
- PDV apresenta a foto local sem depender do Central durante a operação;
- produto sem foto utiliza fallback visual sem bloquear a venda;
- alteração da foto no Central é refletida após nova sincronização;
- não foi observada troca indevida de imagem entre produtos;
- clique simples da sugestão do produto inclui o SKU na venda e possui proteção contra inclusão duplicada por clique rápido;
- refinamentos de proporção/altura da área da foto e texto inferior ficam como acabamento visual não bloqueante;
- todo o fluxo será revalidado no pente-fino da homologação final do Hub.

Portanto:

- Devolução, Cashback, Vale-Troca e Promoções não são projetos independentes dentro do Hub;
- não devem ser esquecidas;
- devem participar dos snapshots, persistência local, regras do PDV e sincronização sempre que o fluxo exigir;
- Fotos de Produto já participam do catálogo e da apresentação operacional do item no PDV;
- Fotos de Produto permanecem cobertas na homologação final do PDV offline.

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

### Posição atual

A etapa corrente chegou ao **item 7 — NFC-e**.

Durante essa sequência, integrar nos pontos correspondentes:

- Devolução de Venda;
- Cashback;
- Vale-Troca;
- Promoções;
- Fotos de Produto no PDV.

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
- manter a integração local já implementada de Fotos de Produto no PDV e deixar apenas refinamentos visuais para acabamento;
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
- metadados/referências necessários para Fotos de Produto no PDV;
- configuração fiscal necessária à NFC-e local;
- demais parâmetros necessários para funcionamento sem internet.

Regras gerais:

- Central continua sendo autoridade dos cadastros e configurações corporativas;
- Hub mantém cópia operacional local;
- ausência no snapshot deve seguir regra explícita de inativação/atualização, evitando exclusões indevidas;
- não criar conceitos mestres paralelos no Hub quando já existirem no Central;
- a estratégia de Fotos de Produto deve preservar o funcionamento local do PDV e evitar dependência indevida do Central durante a operação offline;
- a configuração fiscal da NFC-e deve ser sincronizada ao Hub para permitir operação local sem dependência do Central.

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
- NFC-e, XML, chave, protocolo, status e eventos fiscais gerados no Hub;
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
- exibição da Foto de Produto quando disponível localmente;
- fallback visual adequado quando não houver foto;
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

Referência de Fotos de Produto: [[Mapa Técnico - Sysvar Hub - Fotos de Produto no PDV]].

## 1.11 NFC-e

### Decisão arquitetural aprovada em 20/09/2026

A NFC-e do PDV será emitida operacionalmente pelo **Sysvar Hub local**.

Responsabilidades:

~~~text
Terminal PDV
→ solicita/finaliza a operação comercial

Sysvar Hub
→ controla a numeração fiscal
→ gera a NFC-e modelo 65
→ gera a chave de acesso
→ monta o XML fiscal
→ assina o XML
→ gera QR Code
→ persiste documento/XML/status/eventos
→ transmite à SEFAZ quando a integração real estiver habilitada
→ opera contingência quando aplicável
→ disponibiliza DANFE NFC-e ao Terminal
→ sincroniza o resultado posteriormente com o Central

Sysvar Central
→ continua autoridade dos cadastros e parâmetros corporativos/fiscais
→ fornece configuração fiscal ao Hub
→ recebe posteriormente os documentos e eventos gerados localmente
~~~

O Terminal não controla numeração, certificado, CSC nem comunicação fiscal com a SEFAZ.

A regra estrutural permanece **1 Loja → 1 Hub → N Terminais**, portanto a numeração da NFC-e deve ser serializada no Hub e protegida contra concorrência entre caixas/terminais.

### Estado atual em 20/09/2026

O Central já possuía uma estrutura anterior de NFC-e ligada ao PDV, tratada como **protótipo legado** para a arquitetura do Hub. Esse fluxo antigo simula autorização e não deve ser reutilizado como motor fiscal definitivo.

Para a nova arquitetura, o Central já passou a fornecer ao Hub:

- bloco fiscal da Loja no bootstrap, com ambiente, regime, IE, série, próximo número, identidade do emitente, endereço e código IBGE do município;
- mapeamentos fiscais das formas de pagamento (`tPag`), preservando múltiplos códigos quando configurados;
- snapshot fiscal de produto no catálogo local.

Implementações aprovadas no Central:

- `873b097fe6a42dc5717bb4940291cd5cdfb6a5cd` — configuração fiscal no bootstrap do Hub;
- `4687d2b8a68796aa3609d663d1abb7efe449ae22` — mapeamentos fiscais de pagamento para o Hub.

No Hub, a Fase 1 criou o domínio fiscal local e foi corrigida/revisada antes de aprovação:

- `3773101ebc660d29b1018811ceb377b81b5144a0` — núcleo local inicial da NFC-e;
- `bc49f649996cf2820f803629882bd8d748560738` — correções de XMLDSIG, QR Code 3.00 e tributação suportada.

### Desenvolvimento sem certificado A1 real

A ausência atual de certificado A1 **não bloqueia o desenvolvimento da NFC-e**.

Durante o desenvolvimento serão implementados e testados todos os componentes que independem de autorização real da SEFAZ:

- geração da chave de acesso;
- controle de série e número;
- geração do XML NFC-e modelo 65 conforme leiaute oficial vigente;
- emitente;
- destinatário quando aplicável;
- itens;
- tributação;
- totais;
- pagamentos;
- assinatura XML com certificado de desenvolvimento/local;
- QR Code estruturalmente correto com configuração de desenvolvimento;
- DANFE NFC-e;
- armazenamento do XML;
- estados do documento fiscal;
- tratamento de autorização, rejeição, timeout e falhas por adapter/mock;
- contingência;
- fila de transmissão e retransmissão;
- cancelamento/eventos quando aplicáveis;
- integração da NFC-e com a VendaHub;
- sincronização Hub → Central;
- testes automatizados do fluxo fiscal local.

Não será simulada como definitiva uma autorização SEFAZ inexistente. O desenvolvimento deverá separar claramente:

~~~text
MOTOR FISCAL LOCAL
→ executável e testável sem SEFAZ real

ADAPTER SEFAZ
→ preparado para homologação real posterior
~~~

### Certificado, QR Code e CSC

No desenvolvimento:

- utilizar certificado local/de desenvolvimento apenas para exercitar tecnicamente a assinatura XML;
- o QR Code principal do fluxo online utiliza **versão 3.00** e não depende de CSC/ID CSC;
- CSC/ID CSC ficam apenas como possibilidade de compatibilidade com versão anterior quando realmente aplicável, não como requisito do fluxo principal atual;
- nunca tratar valores de desenvolvimento como credenciais fiscais reais;
- não registrar senha, chave privada, certificado ou CSC em logs;
- preparar armazenamento protegido para o A1 real no ambiente instalado do Hub.

Na homologação externa real:

- utilizar empresa real parceira ou primeira implantação controlada;
- utilizar certificado A1 ICP-Brasil válido da empresa;
- utilizar CNPJ/IE reais;
- utilizar endpoints/configuração fiscal reais do ambiente de homologação da UF;
- utilizar CSC/ID CSC somente se a versão/procedimento fiscal efetivamente aplicável exigir;
- executar transmissão real contra a SEFAZ;
- validar autorização, rejeições, QR Code, DANFE, contingência, cancelamento e demais eventos aplicáveis.

Caso não haja empresa parceira disponível antes da comercialização, essa homologação externa poderá ocorrer na **primeira implantação controlada**, permanecendo registrada como pendência obrigatória antes de considerar o fluxo fiscal plenamente homologado.

### Diretriz técnica

O motor fiscal deve ser **versionável** e preparado para evolução das regras oficiais da NF-e/NFC-e, evitando regras fiscais rígidas espalhadas pelo código.

A implementação deve considerar as notas técnicas e leiautes oficiais vigentes no momento da homologação, inclusive mudanças decorrentes da Reforma Tributária.

Não inventar IBS/CBS ou qualquer outro dado fiscal ainda não fornecido pelo Central. Cenários não representáveis pelos dados atuais devem falhar com erro de domínio controlado em vez de gerar XML aparentemente válido.

### Fase 1 — Núcleo fiscal local — APROVADA em 20/09/2026

A Fase 1 foi implementada e aprovada tecnicamente no Hub.

Concluído:

- snapshot/configuração fiscal Central → Hub;
- `ConfiguracaoFiscalHub` como snapshot operacional local;
- `FormaPagamentoFiscalMapHub` para os mapas `tPag`;
- `NFCeHub` ligado 1:1 à `VendaHub`;
- snapshot fiscal imutável do item vendido em `VendaItemHub.fiscal`;
- controle transacional e monotônico de série/número no Hub;
- proteção contra concorrência e reutilização de número após erro;
- idempotência por venda;
- chave de acesso de 44 dígitos e DV módulo 11;
- XML NFC-e 4.00 para os cenários fiscais atualmente suportados;
- assinatura XMLDSIG enveloped com C14N, SHA-1/RSA-SHA1 conforme o padrão adotado;
- validação da assinatura e detecção de adulteração do `infNFe`;
- QR Code **3.00 online** no formato atual, sem dependência de CSC;
- `infNFeSupl` com `qrCode` e `urlChave`;
- persistência de XML sem assinatura, XML assinado e payload do QR Code;
- ICMS suportado inicialmente para Simples Nacional CSOSN 102/103/300/400 e regime normal CST 00;
- PIS/COFINS suportados inicialmente para CST 01/02 e 49 quando representáveis pelos dados atuais;
- totais fiscais calculados com `Decimal`;
- desconto de item refletido em `vDesc`;
- desconto geral ainda não rateado bloqueado explicitamente por erro de domínio;
- troco refletido em `vTroco`;
- certificado temporário gerado somente em runtime de teste;
- dependências `cryptography` e `lxml` preparadas para o runtime/PyInstaller;
- testes focados do núcleo fiscal aprovados;
- nenhuma autorização SEFAZ falsa criada.

A Fase 1 termina com uma NFC-e estruturalmente gerada, assinada e persistida pelo Hub, sem depender do Central e sem transmitir para a SEFAZ real.

### Fase 2 — PDV, DANFE e contingência — PRÓXIMA ETAPA

Com a Fase 1 aprovada, seguir agora para:

- integrar a geração fiscal ao fluxo de finalização do PDV sem comprometer a consistência comercial;
- definir comportamento quando `emite_nfce=false` e quando ocorrer erro fiscal;
- disponibilizar estado/resultado fiscal ao Terminal;
- gerar DANFE NFC-e para impressão;
- estruturar impressão térmica;
- implementar adapter/simulador de transmissão para autorização, rejeição, timeout e indisponibilidade sem fingir autorização real;
- tratar indisponibilidade de comunicação fiscal;
- implementar contingência aplicável de forma versionável;
- fila de transmissão/retransmissão;
- recuperação após reinício do Hub;
- impedir inconsistência entre venda comercial, pagamento, numeração e documento fiscal;
- preservar números fiscais consumidos e rastreabilidade de erros.

### Fase 3 — Sincronização e preparação para SEFAZ real

Após aprovar a Fase 2:

- sincronizar NFC-e Hub → Central;
- sincronizar XML, chave, protocolo, status e eventos;
- garantir idempotência e retry;
- impedir duplicidade de documento no Central;
- estruturar adapter da SEFAZ real;
- parametrizar endpoints por UF/ambiente;
- preparar leitura segura do A1 real;
- suportar CSC/ID CSC somente quando a versão/procedimento aplicável exigir;
- deixar homologação externa pronta para execução com empresa parceira.

### Critério desta etapa

Não bloquear o avanço do Sysvar Hub por ausência atual do certificado A1.

O bloqueio fica restrito à **homologação externa real SEFAZ**, que será executada posteriormente com credenciais fiscais válidas.

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
- documentos/XMLs fiscais locais ainda não sincronizados;
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
- Fotos de Produto no PDV;
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
- NFC-e local completa;
- homologação externa real da NFC-e com A1 válido e demais credenciais/configurações exigidas pelo procedimento aplicável quando a empresa parceira estiver disponível;
- TEF/Pinpad quando disponível;
- sincronização Central → Hub;
- sincronização Hub → Central;
- retry;
- idempotência;
- reconexão;
- ausência de duplicidades;
- consistência de estoque, Caixa, venda, documento fiscal e benefícios comerciais.

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
- Fotos de Produto no PDV offline/Hub → integração principal concluída; manter refinamentos visuais não bloqueantes e revalidar no pente-fino final;
- NFC-e → Fase 1 do motor fiscal local aprovada; seguir Fase 2 (PDV/DANFE/contingência) e Fase 3 (sincronização/SEFAZ real); homologação externa real com A1 válido e demais credenciais/configurações exigidas permanece obrigatória antes do fechamento fiscal definitivo;
- revisão fiscal completa da NF-e de saída → Fiscal / Contábil;
- faturamento com seleção múltipla/autorização em lote → Fiscal / Contábil;
- feedback visual em operações demoradas → revisão transversal;
- compactação da matriz de Distribuição → Distribuição / acabamento;
- recebimento em Loja com tela própria de consulta da NF-e → Loja;
- consulta de Estoque por coleção sem referência específica → Estoque / acabamento;
- limitação de carga da Movimentação de Estoque → Estoque / acabamento;
- formatação inteira na Conferência Física → Recebimento / acabamento.

A fonte detalhada desses itens é [[Pendências e Melhorias]].

Referência específica: [[Mapa Técnico - Sysvar Hub - Fotos de Produto no PDV]].

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
- [[Mapa Técnico - Sysvar Hub - Fotos de Produto no PDV]]
- [[Metodologia de Trabalho]]
````

---

# Anexo B — Snapshot integral do antigo Pendências e Melhorias.md

````markdown
---
type: project-tracking
status: active
project: Sysvar
created: 2026-09-10
updated: 2026-10-09
tags:
  - sysvar
  - pendencias
  - melhorias
  - homologacao
  - revenda
  - compras
  - distribuicao
  - fiscal
  - estoque
  - sysvar-hub
---

# Pendências e Melhorias — Sysvar

## Objetivo deste documento

Centralizar pendências, melhorias de acabamento e pontos de revisão identificados durante homologações do Sysvar, para evitar perda de contexto entre etapas de desenvolvimento.

Este documento não representa falhas bloqueantes do fluxo já homologado. Quando um item for resolvido, deve ser marcado como concluído e, quando aplicável, registrar o commit correspondente.

---

# Fluxo de Revenda — Homologação concluída em 10/09/2026

## Status

~~~text
FLUXO OPERACIONAL COMPLETO
HOMOLOGADO DE PONTA A PONTA
PENDÊNCIAS RESTANTES: ACABAMENTO, ESCALA E REVISÃO FISCAL
~~~

## Processo validado

~~~text
Pedido de Compra
↓
Aprovação
↓
NF-e de entrada / XML
↓
Local Agent
↓
Recebimento na Fábrica / Almoxarifado
↓
Conferência física
↓
Efetivação do estoque
↓
Custos por SKU
↓
Distribuição
↓
Pedido de Venda de Distribuição por loja
↓
NF-e de saída
↓
Autorização
↓
Mercadoria em trânsito
↓
Recebimento na loja
↓
Entrada no estoque da loja
↓
Movimentação de estoque
~~~

## Massa utilizada na homologação

- 5 Pedidos de Compra de mercadoria de revenda;
- 5 fornecedores;
- 5 XMLs de NF-e de entrada;
- destino inicial: Fábrica;
- 17.580 peças recebidas;
- 990 SKUs;
- distribuição para 3 lojas;
- Loja Barra: 6.264 peças;
- Loja Tijuca: 5.830 peças;
- Loja Centro: 5.486 peças;
- custo total da distribuição: R$ 1.497.442,00;
- valor total de venda com fator de 20%: R$ 1.796.930,40;
- 3 Pedidos de Venda de Distribuição gerados;
- 3 NF-e de saída geradas e autorizadas;
- recebimento da Loja Barra validado com usuário Gerente da própria loja;
- isolamento por loja confirmado no recebimento;
- estoque e movimentação da loja confirmados após o recebimento.

Observação: a distribuição utilizada foi propositalmente muito grande para um cenário operacional normal. Isso ajudou a revelar pontos de UX e escala que provavelmente não apareceriam em uma distribuição pequena.

---

# Correções concluídas durante esta homologação

## Paginação completa da Distribuição

Status: CONCLUÍDO

Corrigido o carregamento incompleto causado por `page_size` fixo nas telas de:

- Distribuição;
- Pedidos de Venda de Distribuição;
- Mercadoria em Trânsito / Recebimento de Loja.

A paginação passou a percorrer `next` até o fim antes de calcular totais, indicadores, agrupamentos e paginação local.

Commit frontend:

`bd7997c Corrige paginacao completa na distribuicao`

## Saldo e valores por SKU na matriz

Status: CONCLUÍDO

- saldo igual a zero passou a ser preservado corretamente;
- Custo un. e Venda un. foram retirados do resumo geral;
- Custo un. e Venda un. passaram a ser exibidos por SKU;
- venda unitária segue `custo_unitario × (1 + fator_preco)`.

Commit frontend:

`d800ea0 Corrige saldo e valores por SKU na distribuicao`

## Persistência de custo no recebimento

Status: CONCLUÍDO

O novo fluxo de Recebimento de Mercadoria efetivava quantidade em estoque, mas não gravava corretamente custo no SKU.

Foi corrigida a persistência de:

- custo_original;
- custo_ultima_compra;
- custo_medio;
- custo_unitario na movimentação;
- custo_total na movimentação;
- custo_medio_apos.

Também foi criado o comando idempotente:

`python manage.py reparar_custos_recebimentos_mercadoria`

Reparação executada na base da homologação:

- 5 recebimentos analisados;
- 990 SKUs corrigidos;
- 990 movimentações corrigidas;
- 1 distribuição RASC/CALC atualizada;
- 990 itens da distribuição atualizados.

Commit backend:

`666178b Corrige custos no recebimento de mercadoria`

---

# Pendências e Melhorias

## P1 — Revisão fiscal completa da NF-e de saída

Status: PENDENTE

Antes de considerar a emissão fiscal pronta para produção real, fazer um pente fino utilizando o leiaute e regras oficiais vigentes da NF-e modelo 55.

Revisar no mínimo:

- campos obrigatórios;
- campos condicionais;
- identificação do emitente;
- destinatário;
- natureza da operação;
- CFOP;
- NCM;
- tributação por item;
- totais tributários;
- transporte;
- volumes;
- quantidade de volumes;
- espécie, peso, identificação e demais dados de volume quando aplicáveis;
- frete;
- chave de acesso;
- protocolo de autorização;
- ambiente de homologação/produção;
- XML gerado;
- consistência entre os dados persistidos e o XML enviado.

Não assumir obrigatoriedade universal de grupos condicionais. Conferir cada regra diretamente na especificação oficial aplicável no momento da revisão.

## P2 — Faturamento com seleção múltipla e autorização em lote

Status: PENDENTE

Hoje a tela de Faturamento possui checkbox visual, mas internamente trabalha com apenas uma NF-e selecionada por vez.

Necessidade:

- permitir selecionar várias NF-e;
- clicar uma única vez em Enviar / Autorizar;
- processar todas as NF-e selecionadas;
- apresentar resultado individual por documento;
- impedir cliques repetidos durante o processamento.

Evolução futura possível:

- agente/serviço automático que processe a fila de NF-e sem depender de ação manual.

A consulta/detalhamento individual da NF-e deve continuar separada da seleção múltipla para faturamento.

## P3 — Feedback visual em operações demoradas

Status: PENDENTE

Durante a homologação com 990 SKUs e 17.580 peças, algumas operações demoraram e a tela aparentou estar parada.

Aplicar indicador de processamento e bloqueio temporário de ações em operações como:

- Carregar para matriz;
- Confirmar distribuição;
- Gerar pedidos;
- Gerar NF-e;
- Enviar / Autorizar NF-e em lote quando implementado.

Exemplos de mensagens:

- `Carregando estoque. Aguarde...`
- `Confirmando distribuição. Aguarde...`
- `Gerando pedidos. Aguarde...`
- `Gerando NF-e. Aguarde...`
- `Autorizando NF-e. Aguarde...`

Objetivo principal: evitar dúvida do usuário e impedir reenvio por clique repetido.

## P4 — Compactar a matriz de Distribuição para uma linha por SKU

Status: PENDENTE

Hoje a identificação do item ocupa mais de uma linha, aumentando excessivamente a altura da matriz.

Objetivo futuro:

~~~text
SKU | Descrição | Código de barras | Cor | Tam. | Custo un. | Venda un. | Disp. | Loja 1 | Loja 2 | ... | Total | Saldo
~~~

Cada SKU deve ocupar uma única linha física.

Preservar:

- lojas dinâmicas;
- edição das quantidades;
- custo por SKU;
- venda por SKU;
- disponível;
- total;
- saldo;
- scroll horizontal;
- comportamento da matriz já homologado.

## P5 — Recebimento em Loja com tela própria de consulta da NF-e

Status: PENDENTE

Hoje a seleção de uma nota expande uma grade extensa de itens na mesma tela de listagem. Em notas grandes isso torna a tela longa e pouco prática.

Fluxo desejado:

~~~text
Lista de notas para recebimento
↓
Selecionar nota
↓
Consultar
↓
Tela própria da NF-e / Recebimento
~~~

Na tela própria, exibir:

### Cabeçalho

- NF-e;
- origem;
- loja destino;
- emissão/saída;
- status;
- chave de acesso;
- protocolo.

### Resumo da NF-e

- valor dos produtos;
- descontos;
- frete;
- valor total;
- quantidade de itens/SKUs;
- quantidade total de peças;
- volumes e dados de transporte quando existirem de forma válida;
- natureza da operação;
- resumo tributário.

### Itens / Conferência

- referência;
- descrição;
- cor;
- tamanho;
- EAN;
- enviado;
- recebido;
- valor unitário;
- total.

Ações:

- Tudo recebido;
- Zerar;
- Lançar no estoque.

Não apresentar valores fiscais inventados. Os dados do resumo devem vir do documento fiscal e do XML válido.

## P6 — Consulta por Referência: permitir consulta por coleção sem referência específica

Status: PENDENTE PARA DECISÃO/IMPLEMENTAÇÃO

Comportamento atual validado:

- Consulta por Referência exige referência/EAN para montar a grade;
- Loja, Coleção e Saldo apenas restringem a referência consultada;
- Consulta por Coleção é a modalidade que traz várias referências.

Melhoria proposta:

- Referência preenchida → consultar somente aquela referência;
- Referência vazia + Coleção preenchida → trazer todas as referências da coleção;
- Referência vazia + Coleção vazia → não carregar o estoque inteiro automaticamente.

Manter diferença de apresentação entre Consulta por Referência e Consulta por Coleção.

## P7 — Limitar carga da Movimentação de Estoque

Status: PENDENTE

A Movimentação de Estoque não deve carregar indiscriminadamente todo o histórico da empresa/loja à medida que a base crescer.

Revisar e garantir:

- usuário de loja vê somente movimentações das lojas permitidas;
- filtro por Loja quando o perfil permitir múltiplas lojas;
- filtro por Referência/EAN;
- Data inicial;
- Data final;
- filtro por tipo/origem quando aplicável;
- período padrão reduzido, evitando consulta de todo o histórico sem intenção explícita;
- paginação/carga compatível com grandes volumes.

Objetivo: impedir degradação progressiva da tela quando o histórico de estoque crescer.

## P8 — Formatação inteira na Conferência Física de mercadoria de revenda

Status: PENDENTE

Na conferência de mercadoria de revenda, quantidades de peças estavam sendo exibidas com 3 ou 4 casas decimais em diversos pontos.

Para mercadoria tratada como peça inteira, apresentar sem casas decimais:

- Qtd Pedido;
- Qtd NF-e;
- Qtd Física;
- NF-e x Pedido;
- Físico x NF-e;
- Físico x Pedido;
- Esperado;
- Recebido;
- Diferença;
- Última leitura da bipagem.

Preferir correção de apresentação/entrada sem alterar desnecessariamente os tipos decimais do banco utilizados por outros fluxos.

## P9 — Sysvar Hub / PDV offline: Cashback

Status: PENDENTE — SOMENTE CASHBACK

A Devolução de Venda e o Vale-Troca no Sysvar Hub já foram implementados, testados e homologados. Eles NÃO são pendências desta seção e não devem ser reabertos sem defeito novo ou nova decisão funcional.

A única pendência deste item é integrar o Cashback existente no Sysvar Central ao Sysvar Hub, inclusive para operação offline.

### Cashback

Status específico: PENDENTE DE INTEGRAÇÃO CENTRAL → SYSVAR HUB

O recurso de Cashback já existe no Sysvar Central, mas ainda não está integrado ao Sysvar Hub. A pendência é levar ao Hub as regras/configurações e os movimentos necessários para que o PDV consiga tratar Cashback também no cenário offline, sem duplicar a regra de negócio já existente na Central.

Revisar/implementar:

- snapshot da configuração de Cashback;
- geração em venda elegível;
- utilização quando permitida;
- cancelamento e estorno relacionados a devolução/cancelamento;
- persistência local dos movimentos;
- sincronização posterior;
- idempotência.

Antes da implementação do consumo offline de Cashback, definir política segura para saldo possivelmente desatualizado entre lojas, evitando uso duplicado do mesmo saldo em operações simultâneas desconectadas.

### Homologação futura do Cashback

Testar, quando essa integração for implementada:

1. venda gerando Cashback;
2. venda utilizando Cashback conforme política aprovada;
3. estorno/cancelamento do benefício;
4. operação offline;
5. reconexão;
6. confirmação no Central sem duplicidade de movimentos ou saldo.

Referência: [[Planejamento]].

## P10 — Sysvar Hub: substituir quadro de Vale-Troca por Recebimento de Loja

Status: PENDENTE — SOMENTE NAVEGAÇÃO/QUADRO NESTA ETAPA

O quadro/opção independente de Vale-Troca no Sysvar Hub foi considerado redundante, pois o Vale-Troca já faz parte do fluxo de Devolução e pode ser utilizado posteriormente em uma nova Venda.

Diretriz aprovada:

- retirar futuramente o quadro/opção independente de Vale-Troca da navegação principal do Hub;
- substituir esse espaço por um quadro de `Recebimento de Loja` (nome final pode ser refinado na implementação);
- o novo quadro será o ponto de entrada futuro para o processo de recebimento de mercadorias pela loja;
- nesta etapa, registrar apenas a necessidade e o espaço de navegação;
- NÃO implementar agora a funcionalidade de recebimento, APIs, sincronização, conferência ou entrada em estoque;
- NÃO remover a lógica interna de Vale-Troca necessária à Devolução e à Venda.

A implementação funcional futura de Recebimento de Loja deve ser tratada em etapa própria e alinhada com a pendência P5 — Recebimento em Loja com tela própria de consulta da NF-e.

## P11 — Sysvar Hub: verificar sincronização de Promoções e atualização de preços

Status: PENDENTE DE VERIFICAÇÃO/INTEGRAÇÃO

O recurso de Promoções já existe no Sysvar Central.

É necessário verificar se o Sysvar Hub já recebe corretamente as promoções criadas ou alteradas na Central e se essas informações passam a refletir no PDV para atualização/aplicação dos preços promocionais.

Validar no mínimo:

- criação de promoção na Central;
- alteração de promoção existente;
- vigência inicial e final;
- produtos/SKUs abrangidos;
- preço promocional;
- atualização/sincronização Central → Hub;
- aplicação correta no PDV;
- comportamento offline após a última sincronização válida;
- expiração da promoção no Hub;
- ausência de preço promocional obsoleto após nova sincronização.

Se a sincronização já existir, homologar e documentar o fluxo.
Se não existir ou estiver incompleta, implementar em etapa própria.

## P12 — Reorganizar menu de Distribuição

Status: PENDENTE — AJUSTE LEVE DE NAVEGAÇÃO

Reorganizar o menu de Distribuição no Sysvar Central para eliminar a hierarquia atual considerada confusa e redundante.

Diretriz aprovada:

- abaixo do menu principal `Distribuição` devem existir diretamente apenas três opções:
  1. `Distribuição`;
  2. `Pedido de Venda`;
  3. `Faturamento`;
- a rota hoje localizada em `Perfil Distribuição` deve passar a aparecer como `Distribuição`;
- a rota de `Pedido de Venda` deve subir para o primeiro nível abaixo de `Distribuição`;
- a rota de `Faturamento` deve subir para o primeiro nível abaixo de `Distribuição`;
- remover da navegação intermediária os agrupamentos/submenus atuais de `Configuração`, `Operação` e `Perfil Distribuição`, preservando as rotas e funcionalidades;
- nesta pendência não alterar regras de negócio, apenas nomenclatura e estrutura de navegação.

Estrutura desejada:

~~~text
Distribuição
├─ Distribuição
├─ Pedido de Venda
└─ Faturamento
~~~

## P13 — Produção: analisar, verificar e sugerir melhorias

Status: PENDENTE DE ANÁLISE

O módulo de Produção já recebeu alterações anteriormente, mas ainda deve passar por uma revisão funcional específica.

Objetivo da pendência:

- analisar o estado atual do módulo de Produção;
- verificar os fluxos já existentes e o que foi implementado;
- identificar inconsistências, lacunas, redundâncias e pontos de melhoria;
- diferenciar claramente erro, melhoria e sugestão;
- propor ajustes funcionais e de usabilidade sem alterar nada antes da análise;
- preservar o que já estiver correto e homologado.

A revisão deve começar pela documentação e pelo código atual do módulo, seguida de uma análise da interface e dos fluxos reais antes de qualquer implementação.

## P14 — Sysvar Central: ocultar menu Loja

Status: PENDENTE — AJUSTE DE NAVEGAÇÃO/ARQUITETURA FUNCIONAL

O menu `Loja` dentro do Sysvar Central deve ser ocultado da navegação principal.

Diretriz aprovada:

- o Sysvar Central não deve concentrar operações que pertencem ao uso diário da loja;
- as facilidades operacionais da loja devem ficar no ambiente próprio da loja/Sysvar Hub;
- ocultar o menu `Loja` da Central sem remover regras, rotas ou código antes de revisar dependências;
- revisar as opções hoje existentes sob esse menu e classificar cada uma como:
  - mover para o Hub;
  - manter acessível por outra área da Central;
  - descontinuar da navegação;
- `Recebimento de Mercadoria` deve ser considerado operação de loja e deve orientar a futura funcionalidade de `Recebimento de Loja` no Sysvar Hub;
- não implementar agora o fluxo completo de recebimento no Hub nesta pendência;
- não apagar funcionalidades existentes antes da análise de dependências e realocação das rotas necessárias.

## P15 — Financeiro: analisar, sugerir melhorias e homologar

Status: PENDENTE DE ANÁLISE E HOMOLOGAÇÃO

O módulo Financeiro já passou por reestruturações e possui fluxos já implementados/homologados, mas ainda deve passar por uma revisão funcional completa do conjunto.

Objetivo da pendência:

- analisar o estado atual do Financeiro;
- revisar os fluxos existentes de Receber, Pagar, Caixa, Banco, Adiantamentos, Formas de Pagamento, Prazos, Naturezas e demais configurações relacionadas;
- identificar erros, inconsistências, redundâncias, lacunas e oportunidades de melhoria;
- diferenciar claramente erro, melhoria e sugestão;
- revisar integração com Vendas, Compras, Hub e demais origens financeiras;
- verificar usabilidade, navegação, clareza das telas e coerência dos cadastros;
- preservar as decisões financeiras já aprovadas e homologadas, sem reabrir regras encerradas sem motivo concreto;
- propor melhorias antes de implementar;
- realizar homologação funcional dos fluxos considerados prontos após a análise e eventuais correções.

A revisão deve começar pela documentação e pelo código atual do módulo, seguida da análise das telas e dos fluxos reais.

## P16 — Fiscal/Contábil: analisar, sugerir melhorias e homologar

Status: PENDENTE DE ANÁLISE E HOMOLOGAÇÃO

O conjunto Fiscal/Contábil deve passar por uma revisão funcional específica antes de ser considerado encerrado.

Objetivo da pendência:

- analisar o estado atual dos módulos Fiscal e Contábil;
- revisar os fluxos, telas, integrações e cadastros já existentes;
- identificar erros, inconsistências, redundâncias, lacunas e oportunidades de melhoria;
- diferenciar claramente erro, melhoria e sugestão;
- revisar a integração com Vendas, Compras, Estoque, Financeiro e demais origens relacionadas;
- verificar usabilidade, navegação e coerência funcional;
- preservar o que já estiver correto e homologado;
- propor melhorias antes de qualquer implementação;
- realizar homologação funcional dos fluxos considerados prontos após a análise e eventuais correções.

A revisão deve começar pela documentação e pelo código atual, seguida da análise das telas e dos fluxos reais.

Observação: a revisão fiscal completa de leiaute/regras oficiais de NF-e permanece como último item da fila, conforme prioridade já definida para o projeto.

## P17 — Dashboards: analisar, sugerir melhorias e homologar

Status: PENDENTE DE ANÁLISE E HOMOLOGAÇÃO

Os dashboards do Sysvar devem passar por uma revisão funcional específica.

Objetivo da pendência:

- analisar o estado atual dos dashboards existentes;
- revisar indicadores, filtros, períodos, agrupamentos e fontes de dados;
- verificar se os números apresentados correspondem aos dados reais dos módulos de origem;
- identificar erros, inconsistências, redundâncias, lacunas e oportunidades de melhoria;
- diferenciar claramente erro, melhoria e sugestão;
- revisar usabilidade, clareza visual, hierarquia das informações e utilidade gerencial;
- evitar indicadores duplicados ou sem valor prático;
- preservar o que já estiver correto;
- propor melhorias antes de qualquer implementação;
- realizar homologação funcional dos dashboards considerados prontos após a análise e eventuais correções.

A revisão deve considerar, quando aplicável, dashboards de vendas, produtos, estoque, financeiro e demais painéis existentes no sistema.

## P18 — Padronização visual e modernização de layout — Central e Sysvar Hub

Status: PENDENTE DE ANÁLISE, DEFINIÇÃO DE PADRÃO E HOMOLOGAÇÃO

O Sysvar Central e o Sysvar Hub devem passar por uma revisão conjunta de layout e design para ganhar identidade visual consistente, melhor aproveitamento de tela e aparência mais moderna.

Diretriz principal aprovada:

- todas as telas operacionais devem seguir um padrão de abertura em área de trabalho ampla/tela cheia;
- ao entrar em uma funcionalidade, o menu lateral deve poder ser ocultado/recolhido para liberar a área útil;
- evitar a situação atual em que algumas telas usam toda a largura e outras ficam limitadas a áreas menores sem necessidade;
- Central e Hub devem compartilhar linguagem visual, espaçamentos, cabeçalhos, filtros, tabelas, badges, botões e padrões de detalhe;
- preservar diferenças funcionais entre Central e Hub, mas manter a sensação de que ambos pertencem ao mesmo produto.

Pontos para analisar e propor antes de implementar:

### Estrutura de tela

- cabeçalho padrão para todas as funcionalidades;
- título, contexto, ações principais e status sempre em posições consistentes;
- área principal ocupando o máximo da tela;
- menu lateral recolhível/ocultável;
- comportamento consistente de tela cheia;
- filtros em barra compacta;
- tabelas como elemento principal nas telas de consulta/operação;
- detalhes abrindo em painel, drawer, modal amplo ou seção expansível sem desperdiçar espaço quando fechados.

### Padronização visual

Definir um design system simples para o Sysvar com:

- tipografia;
- tamanhos de título/subtítulo;
- espaçamentos;
- raios de borda;
- sombras;
- hierarquia de botões;
- cores de status;
- badges;
- campos;
- selects;
- tabelas;
- paginação;
- mensagens de erro/alerta/sucesso;
- loading;
- estados vazios;
- ícones.

### Modernização / “florzinhas”

Avaliar recursos visuais discretos que deixem o sistema mais moderno sem virar dashboard decorativo ou comprometer a operação:

- ícones coerentes nas ações;
- microinterações leves;
- hover/seleção mais refinados;
- indicadores visuais de status;
- transições curtas em drawers/painéis;
- cabeçalhos com melhor hierarquia;
- realce visual de totais e informações-chave;
- empty states mais cuidados;
- feedback visual de ações concluídas;
- pequenos elementos de identidade da marca Sysvar.

Evitar:

- excesso de cartões;
- cores sem função;
- animações chamativas;
- espaços vazios excessivos;
- componentes diferentes para funções equivalentes;
- redesenho que reduza densidade operacional de ERP.

### Estratégia

Antes de alterar telas em massa:

1. analisar Central e Hub atuais;
2. identificar padrões repetidos e inconsistências;
3. escolher 2 ou 3 telas representativas;
4. criar proposta visual padrão;
5. homologar o padrão;
6. somente depois aplicar gradualmente ao restante do sistema.

A revisão deve gerar uma proposta clara de padrão visual e componentes reutilizáveis antes da implementação ampla.

## P19 — CMV: revisar composição, origem dos custos e atualização dos dashboards

Status: PENDENTE DE ANÁLISE E CORREÇÃO

Foi identificado indício de erro no Dashboard de Margem/CMV: os valores de CMV aparecem zerados e, como consequência, a margem exibida fica igual ao valor total da receita.

A estrutura de CMV deve ser revisada de ponta a ponta, desde a formação do custo até o consumo desse custo nos relatórios e dashboards.

Diretriz de negócio aprovada:

### Produto de revenda

O CMV deve ter como base o custo efetivamente recebido da compra do fornecedor, originado no fluxo de:

~~~text
Pedido de Compra
↓
Fornecedor
↓
NF-e / Recebimento de Mercadoria
↓
Custo do produto/SKU
↓
Venda
↓
CMV
~~~

O valor de custo usado no CMV deve refletir o custo de aquisição persistido no estoque/SKU conforme a regra vigente do sistema, sem ser substituído pelo preço de venda.

### Produto de produção própria

O CMV deve ser formado pela composição de custos da Ficha Técnica / estrutura produtiva do produto.

A revisão deve verificar como entram na composição, conforme o modelo já existente no sistema:

- matérias-primas;
- insumos;
- componentes;
- custos de produção já previstos na estrutura atual;
- demais elementos de custo vinculados à Ficha Técnica.

Não inventar nova regra de custeio antes de analisar o que já existe no módulo de Produção.

### Pontos obrigatórios da revisão

- identificar onde o custo é persistido para produto de revenda;
- verificar se o custo recebido da compra chega corretamente ao SKU/estoque;
- verificar qual custo a Venda grava ou referencia no momento da saída;
- verificar se o CMV da venda fica historicamente preservado;
- verificar se alterações posteriores de custo não distorcem vendas antigas;
- analisar produtos de produção própria e sua ligação com a Ficha Técnica;
- revisar cálculo de CMV nos relatórios;
- revisar cálculo de margem bruta;
- revisar o Dashboard de Margem/CMV;
- identificar por que o CMV atual está zerado;
- diferenciar erro de implementação, dado ausente e regra de negócio ainda não implementada;
- corrigir somente após a análise;
- homologar com exemplos reais de revenda e produção própria.

Regra conceitual esperada para os indicadores:

~~~text
Margem Bruta = Receita de Venda - CMV
~~~

O dashboard não deve apresentar a receita integral como margem quando existir custo associado à mercadoria vendida.

---

# Regras para manutenção deste documento

1. Toda melhoria identificada durante homologação que não for resolvida imediatamente deve ser incluída aqui.
2. Não reabrir fluxo homologado apenas porque existe uma melhoria de acabamento.
3. Quando uma pendência for resolvida:
   - alterar `Status: PENDENTE` para `Status: CONCLUÍDO`;
   - registrar o commit;
   - resumir a solução aplicada.
4. Se a pendência evoluir para decisão arquitetural relevante, criar ADR específico e deixar aqui o link para o ADR.
5. Se a pendência exigir homologação funcional própria, criar documento em `Homologações` e referenciá-lo aqui.

---

# Próxima leitura recomendada

Ao retomar melhorias do fluxo de revenda, consultar primeiro este documento e depois os documentos técnicos/homologações específicos de:

- Compras;
- Entrada de NF-e;
- Estoque;
- Distribuição;
- Fiscal;
- Recebimento em Loja;
- Sysvar Hub / PDV offline.
````
