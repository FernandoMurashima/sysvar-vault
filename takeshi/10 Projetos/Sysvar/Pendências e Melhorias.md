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

## P9 — Sysvar Hub / PDV offline: Devolução, Cashback e Vale-Troca

Status: PENDENTE

O objetivo do Sysvar Hub é manter o PDV operacional mesmo sem conexão com o Sysvar Central. Portanto, os fluxos essenciais de pós-venda e benefícios comerciais não podem depender exclusivamente de internet.

### Devolução de Venda

O PDV offline deve suportar o fluxo de devolução com consistência local e sincronização posterior.

Revisar/implementar:

- localização da venda original disponível no Hub;
- devolução total e parcial;
- bloqueio de quantidade devolvida acima da vendida;
- retorno local do item ao estoque quando aplicável;
- reflexo local em caixa/forma de restituição;
- geração de Vale-Troca quando essa for a regra adotada;
- persistência local da devolução;
- envio posterior ao Central;
- idempotência;
- tratamento de conflito após reconexão.

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

### Vale-Troca

Como a devolução pode resultar em Vale-Troca, o recurso também precisa funcionar no Hub offline.

Decisão de interface em 09/10/2026: o Vale-Troca não deve permanecer como opção/quadro operacional independente no menu do Sysvar Hub. A emissão do Vale-Troca pertence ao fluxo de Devolução e seu consumo pertence ao fluxo de uma nova Venda. Manter a entidade e as regras necessárias ao processo, mas sem exigir uma tela isolada apenas para Vale-Troca, salvo necessidade futura comprovada.

Revisar/implementar:

- emissão local vinculada à devolução;
- identificador único;
- controle de saldo;
- uso em nova venda;
- uso parcial quando permitido;
- cancelamento/estorno;
- sincronização com o Central;
- proteção contra duplicidade e uso duplo após reconexão.

### Homologação obrigatória

Testar com a internet desligada:

1. venda normal;
2. devolução parcial;
3. devolução total;
4. devolução gerando Vale-Troca;
5. nova venda usando Vale-Troca;
6. venda gerando Cashback;
7. venda utilizando Cashback conforme política aprovada;
8. estorno/cancelamento dos benefícios;
9. reconexão;
10. confirmação no Central sem duplicidade de venda, estoque, caixa, devolução, Cashback ou Vale-Troca.

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
