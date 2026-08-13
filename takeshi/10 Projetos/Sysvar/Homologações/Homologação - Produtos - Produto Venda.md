## 1. Identificação

**Projeto:** Sysvar  
**Módulo:** Produtos  
**Cadastro:** Produto Venda  
**Escopo:** Revenda e Fabricação Própria  
**Situação:** HOMOLOGADO  
**Data de conclusão da homologação:** 13/08/2026  
**Resultado:** 19/19 itens aprovados

---

## 2. Objetivo

O cadastro de **Produto Venda** do Sysvar representa os produtos destinados à comercialização pela empresa.

O cadastro unifica funcionalmente dois tipos de produto:

- **Revenda**;
- **Fabricação Própria**.

Esses dois tipos compartilham a mesma estrutura principal de produto, grade, cores, SKUs, códigos de barras, preços, estoque e informações fiscais.

A origem do abastecimento diferencia os dois tipos:

- **Revenda:** produto adquirido de fornecedor para posterior comercialização;
- **Fabricação Própria:** produto produzido pela empresa, utilizando os processos de Ficha Técnica e Ordem de Produção.

O cadastro de **Produto Venda** não contempla nesta fase os produtos classificados como **Uso e Consumo**.

Uso e Consumo permanece como escopo separado.

---

## 3. Nomenclatura funcional aprovada

A nomenclatura oficial da funcionalidade é:

**Produto Venda**

Essa nomenclatura deve ser utilizada:

- no menu;
- no título da tela;
- na documentação funcional;
- na documentação técnica;
- nos fluxos de homologação;
- nos desenvolvimentos futuros relacionados a essa funcionalidade.

Os tipos internos permanecem:

- `tipo_produto = '1'` → **Revenda**;
- `tipo_produto = '3'` → **Fabricação Própria**.

A alteração de nomenclatura é apenas funcional e visual.

Os códigos internos não foram alterados.

A antiga nomenclatura visual:

**Produto Próprio**

foi substituída por:

**Fabricação Própria**.

---

## 4. Conceito de Produto

Produto representa o cadastro principal da mercadoria comercializável.

O Produto concentra informações comuns às suas variações, entre elas:

- referência;
- descrição;
- descrição reduzida;
- tipo;
- unidade;
- grupo;
- subgrupo;
- coleção;
- material;
- grade;
- informações fiscais;
- situação ativo/inativo;
- bloqueio de venda;
- observações;
- informações gerais de custo;
- imagens;
- tabelas de preço relacionadas.

As variações comercializáveis são representadas pelos SKUs.

---

## 5. Tipo de Produto

O tipo é definido na criação do Produto Venda.

Tipos permitidos nesta funcionalidade:

### 5.1 Revenda

Código interno:

`1`

Produto comprado de fornecedor para comercialização.

Seu reabastecimento ocorre principalmente através dos processos de compra e recebimento.

### 5.2 Fabricação Própria

Código interno:

`3`

Produto produzido pela própria empresa.

Pode possuir integração com:

- Ficha Técnica;
- Ordem de Produção;
- custos de produção.

### 5.3 Imutabilidade do tipo

Após a criação do Produto Venda, o tipo não pode ser alterado.

Essa regra foi homologada.

Motivo:

Alterar posteriormente Revenda para Fabricação Própria, ou o inverso, poderia comprometer:

- histórico;
- estoque;
- compras;
- produção;
- custos;
- integrações futuras.

---

## 6. Referência do Produto Venda

A referência é gerada automaticamente para os Produtos Venda.

A regra utilizada permanece baseada no padrão:

`AA-BB-CCDDD`

Onde:

- `AA` representa o ano da coleção;
- `BB` representa a estação;
- `CC` representa o código de referência do Grupo;
- `DDD` representa sequência numérica.

Esta regra atende:

- Revenda;
- Fabricação Própria.

A referência não é digitada livremente pelo usuário na criação normal.

A geração existente foi preservada e homologada.

---

## 7. Descrição

Produto Venda possui descrição principal.

A descrição identifica comercialmente o produto.

O cadastro também possui:

**Descrição reduzida**

A descrição reduzida:

- é obrigatória;
- possui limite de 60 caracteres;
- é utilizada onde for necessária representação compacta do produto.

A obrigatoriedade da descrição reduzida foi homologada.

---

## 8. Unidade

Todo Produto Venda deve possuir Unidade.

Unidade é obrigatória.

Exemplos:

- UN;
- PC;
- CJ;
- outras unidades cadastradas pela empresa.

A Unidade deve pertencer ao contexto permitido da empresa.

---

## 9. Grupo e Subgrupo

Todo Produto Venda deve possuir:

- Grupo;
- Subgrupo.

Grupo e Subgrupo são obrigatórios.

O Subgrupo deve ser coerente com o Grupo selecionado.

Não deve ser possível manter combinação inválida entre Grupo e Subgrupo.

A obrigatoriedade e a coerência entre os dois cadastros foram homologadas.

---

## 10. Coleção

Produto Venda pode ser organizado por Coleção.

A Coleção participa também da geração da referência automática.

A estrutura existente de Coleção foi preservada.

Não foi redesenhada durante esta homologação.

---

## 11. Material

Material é informação opcional do Produto Venda.

Não é obrigatório para salvar o produto.

Pode ser utilizado para classificação e informações futuras relacionadas à mercadoria e à produção.

---

## 12. Grade

Todo Produto Venda deve possuir Grade.

Grade é obrigatória.

A Grade define os tamanhos que poderão compor as variações do Produto.

Exemplos:

- PP / P / M / G / GG;
- 36 / 38 / 40 / 42 / 44;
- outras grades cadastradas.

### 12.1 Imutabilidade após geração de SKUs

Após existirem SKUs para o Produto, a Grade não pode ser alterada.

Essa regra foi homologada.

A proteção existe porque alterar a Grade posteriormente poderia comprometer:

- SKUs existentes;
- EANs;
- estoque;
- movimentos;
- compras;
- vendas;
- produção;
- histórico.

---

## 13. Cores

Produto Venda pode possuir uma ou mais cores.

As cores selecionadas são utilizadas em conjunto com os tamanhos da Grade para geração dos SKUs.

### 13.1 Inclusão de cor

Ao adicionar uma nova cor ao Produto:

- são criados SKUs para os tamanhos da Grade;
- cada novo SKU recebe seu identificador e EAN conforme a regra existente.

### 13.2 Remoção de cor

Remover uma cor do Produto não elimina definitivamente seus SKUs.

Os SKUs associados àquela cor são:

**inativados**

e não apagados.

Essa regra preserva:

- EAN;
- código do item;
- histórico;
- integridade de movimentações;
- rastreabilidade.

A remoção de uma cor foi homologada.

### 13.3 Remoção da última cor

O sistema permite remover também a última cor vinculada.

Os SKUs correspondentes são inativados.

Esse cenário foi homologado.

### 13.4 Reativação da cor

Caso uma cor anteriormente retirada seja adicionada novamente:

- os SKUs anteriores são reutilizados;
- os SKUs são reativados;
- o EAN anterior é preservado;
- o código de referência do item é preservado.

O sistema não deve gerar um novo EAN para a mesma variação já existente.

Esse fluxo foi homologado.

---

## 14. SKU

SKU representa a variação comercializável do Produto.

O SKU é formado essencialmente pela combinação:

**Produto × Cor × Tamanho**

Cada SKU possui identidade própria.

Entre as informações associadas ao SKU estão:

- Produto;
- Cor;
- Tamanho;
- código interno;
- EAN;
- situação ativo/inativo;
- custos;
- estoque relacionado.

O Produto representa o cadastro principal.

O SKU representa a unidade operacional de estoque e venda.

---

## 15. EAN

Cada SKU recebe EAN de forma automática conforme a estrutura já existente no Sysvar.

A geração e preservação de EAN foram mantidas.

Durante a homologação foi confirmado que:

- novos SKUs recebem EAN;
- SKU inativado preserva seu EAN;
- reativação do mesmo SKU preserva o EAN original.

A regra de EAN não foi redesenhada nesta fase.

---

## 16. Situação do SKU

Na consulta do Produto Venda, a tabela de SKUs apresenta explicitamente:

- **Ativo**;
- **Inativo**.

A coluna de Status substituiu a antiga apresentação da margem monetária.

A tabela mantém:

**Margem %**

O objetivo é permitir identificar claramente quando uma variação permanece registrada apenas para preservação histórica.

---

## 17. Lojas vinculadas e inicialização de estoque

Na criação do Produto Venda, podem ser selecionadas as lojas para as quais o estoque do Produto será inicialmente preparado.

A seleção das lojas não representa quantidade disponível.

Representa a criação/preparação da estrutura necessária de estoque para:

**Loja × SKU**

A quantidade inicial permanece zero, salvo operação posterior que gere movimento de estoque.

### 17.1 Seleção de lojas

O modal permite:

- selecionar individualmente;
- desmarcar individualmente;
- selecionar todas as lojas;
- limpar seleção.

Foi adicionada a ação:

**Todas**

para facilitar empresas com várias lojas.

O modal foi homologado após ajuste de layout.

---

## 18. Estoque por Loja × SKU

O estoque é controlado no nível:

**Loja × SKU**

Não no nível apenas do Produto.

Isso significa que:

- uma mesma referência pode possuir estoque diferente entre lojas;
- cores diferentes possuem saldos independentes;
- tamanhos diferentes possuem saldos independentes.

Na consulta são apresentadas informações como:

- Loja;
- Cor;
- Tamanho;
- EAN;
- Físico;
- Reserva;
- Disponível.

A visualização Loja × SKU foi homologada.

---

## 19. Estoque físico, reserva e disponível

A estrutura diferencia os conceitos:

### Estoque físico

Quantidade fisicamente registrada para o SKU na Loja.

### Reserva

Quantidade comprometida/reservada.

### Disponível

Representado conceitualmente por:

~~~text
Disponível = Físico - Reserva
~~~

A estrutura atual foi preservada.

As regras de venda, reserva e baixa definitiva pertencem aos respectivos processos operacionais e não foram redesenhadas nesta homologação.

---

## 20. Estoque negativo

A regra existente relacionada a estoque negativo foi preservada.

Produto Venda não criou uma segunda lógica de estoque.

Qualquer autorização ou bloqueio de estoque negativo deve continuar utilizando a configuração já existente no Sysvar.

---

## 21. Custos

O Produto/SKU utiliza a estrutura de custos já existente.

Entre os valores existentes estão:

- custo original;
- custo da última compra;
- custo médio.

O SKU é a principal unidade operacional para acompanhamento dos custos relacionados à variação.

O Produto pode apresentar informações consolidadas quando aplicável.

Para Fabricação Própria, custos podem ser atualizados através dos processos de produção.

A propagação existente de custos da Ordem de Produção foi mantida.

Nenhuma nova fórmula de custo foi criada durante esta homologação.

---

## 22. Preço

Produto Venda utiliza a estrutura existente de Tabelas de Preço.

Um Produto pode participar de múltiplas tabelas.

Não existe uma tabela de preço diferente obrigatoriamente por Loja.

A autoridade comercial de preços deverá continuar sendo tratada na estrutura própria de preços e vendas.

Nesta homologação:

- preço existente foi preservado;
- cálculo de preço não foi redesenhado;
- promoções não foram redesenhadas;
- PDV não foi redesenhado.

---

## 23. Margem

A consulta mantém a informação:

**Margem %**

A margem monetária deixou de ocupar uma coluna na tabela principal de SKUs para permitir exibição do Status.

Essa alteração foi apenas de apresentação.

Nenhum cálculo de margem foi modificado.

---

## 24. Dados fiscais

Produto Venda possui informações fiscais editáveis.

A seção:

**Dados fiscais**

foi disponibilizada no cadastro e edição.

Campos existentes contemplados:

- NCM;
- origem da mercadoria;
- CST/CSOSN ICMS;
- alíquota ICMS;
- CFOP venda dentro do estado;
- CFOP venda fora do estado;
- CST PIS;
- alíquota PIS;
- CST COFINS;
- alíquota COFINS;
- situação IPI;
- alíquota IPI.

Os campos fiscais já existiam no backend.

A homologação identificou inicialmente que apenas NCM estava exposto na tela.

A interface foi corrigida e todos os campos existentes passaram a ser disponibilizados.

### 24.1 Alteração fiscal

Dados fiscais podem ser alterados.

A alteração deve preservar rastreabilidade.

Alterações fiscais relevantes são registradas no:

- Histórico Funcional do Produto Venda;
- Audit Central.

A edição dos campos fiscais foi homologada após a correção da interface.

---

## 25. Histórico funcional

Produto Venda possui histórico funcional próprio.

O histórico registra alterações relevantes do ciclo do Produto.

Entre os eventos possíveis estão:

- alteração cadastral;
- alteração fiscal;
- ativação;
- inativação;
- bloqueio de venda;
- desbloqueio de venda;
- alterações relevantes de vínculo/variação quando aplicável.

O histórico funcional não substitui a Auditoria Central.

São estruturas com objetivos diferentes.

### Histórico funcional

Voltado à compreensão operacional do Produto.

### Audit Central

Voltado à rastreabilidade técnica e administrativa das operações realizadas no sistema.

A consulta ao histórico funcional foi homologada.

---

## 26. Imagens

Produto Venda permite cadastro de imagens.

Regras aprovadas:

- imagens são opcionais;
- máximo de 3 imagens por Produto;
- apenas uma imagem pode ser marcada como principal;
- imagem pertence ao Produto;
- não existe imagem individual por Cor;
- não existe imagem individual por SKU.

Na edição é possível:

- incluir imagem;
- visualizar miniatura;
- remover imagem;
- marcar imagem como principal.

Na consulta:

- a seção Imagens é sempre apresentada;
- quando não existem imagens é exibida a informação:

**Nenhuma imagem cadastrada**.

Quando existem imagens:

- as miniaturas são exibidas;
- a principal pode ser identificada.

O gerenciamento de imagens foi homologado após implementação da interface de cadastro/edição.

---

## 27. Imagem reduzida

A estrutura prevê imagem original e possibilidade de imagem reduzida.

Nesta fase não foram definidos parâmetros técnicos arbitrários para geração automática da imagem reduzida.

Não foram fixados sem decisão prévia:

- resolução;
- largura;
- altura;
- formato;
- qualidade;
- taxa de compressão.

Quando `imagem_reduzida_url` estiver disponível, pode ser utilizada.

Quando não estiver, a interface utiliza a imagem original como fallback.

A definição definitiva de processamento de imagem permanece para decisão técnica específica futura.

---

## 28. Ativo e Inativo

Produto Venda possui estado:

- Ativo;
- Inativo.

Inativar não significa excluir.

Produto Inativo:

- permanece cadastrado;
- preserva histórico;
- preserva SKUs;
- preserva EANs;
- preserva movimentações;
- pode ser consultado.

A inativação exige confirmação conforme regras de segurança existentes.

Foi homologado o fluxo:

~~~text
ATIVO
  ↓
INATIVAR
  ↓
INATIVO
  ↓
ATIVAR
  ↓
ATIVO
~~~

---

## 29. Bloqueio de venda

Bloqueio de venda é independente da situação Ativo/Inativo.

Um Produto pode permanecer cadastrado e ativo administrativamente, mas estar impedido de participar de novas vendas.

O Produto possui indicador próprio:

**Bloqueado para venda**

Fluxo homologado:

~~~text
LIBERADO
   ↓
BLOQUEAR VENDA
   ↓
BLOQUEADO
   ↓
DESBLOQUEAR VENDA
   ↓
LIBERADO
~~~

A distinção entre inativação e bloqueio de venda deve ser preservada.

---

## 30. Segurança para ações sensíveis

As ações sensíveis utilizam o modelo funcional de permissões do Sysvar.

A homologação identificou inicialmente um problema:

A permissão dependia de:

- `is_staff`;
- ou permissão nativa Django `produto.change_produto`.

Isso fazia com que um Admin funcional do Sysvar recebesse erro de falta de permissão.

A regra foi corrigida.

Produto Venda passou a utilizar a permissão funcional do módulo de Produtos através da estrutura de acesso efetivo do Sysvar.

O usuário precisa possuir autorização adequada para edição do módulo Produtos.

Admin funcional autorizado pode:

- Inativar;
- Ativar;
- Bloquear venda;
- Desbloquear venda.

Usuário sem autorização adequada continua impedido.

A correção foi homologada manualmente.

---

## 31. Motivo e senha

A correção de autorização não eliminou as proteções já existentes.

Nas ações que exigem confirmação de segurança continuam sendo utilizados:

- motivo;
- senha.

Em especial:

### Inativação

Exige:

- motivo válido;
- senha válida.

### Bloqueio de venda

Exige:

- motivo válido;
- senha válida.

Senha inválida deve ser rejeitada.

Motivo inválido ou ausente deve ser rejeitado quando obrigatório.

Ativação e desbloqueio mantêm o comportamento definido pela implementação atual.

---

## 32. Exclusão

Excluir Produto é diferente de Inativar Produto.

### 32.1 Produto nunca utilizado

Um Produto pode ser excluído definitivamente quando não possui utilização que exija preservação histórica.

A exclusão pode remover também estruturas técnicas vazias associadas, como registros de estoque zero criados apenas durante inicialização.

Esse cenário foi homologado.

### 32.2 Produto utilizado

Produto que já possui utilização ou movimentação relevante não pode ser excluído fisicamente.

Nesses casos deve ser utilizada a situação operacional apropriada:

- inativação;
- bloqueio de venda.

A proteção contra exclusão de Produto utilizado foi homologada.

---

## 33. Isolamento multiempresa

Produto Venda pertence à Empresa.

O backend é autoridade sobre isolamento de tenant.

Não é permitido acessar ou relacionar indevidamente dados pertencentes a outra empresa.

O isolamento deve ser preservado para:

- Produto;
- Grupo;
- Subgrupo;
- Coleção;
- Unidade;
- Grade;
- Cores;
- Lojas;
- estoque;
- SKUs;
- preços;
- imagens;
- histórico;
- demais relações do Produto.

O frontend não deve ser considerado a única proteção multiempresa.

---

## 34. Filtros

A listagem de Produto Venda utiliza filtros processados no backend.

Foram homologados filtros relacionados a:

- busca geral;
- Referência;
- Código;
- Grupo;
- Coleção;
- Status;
- Bloqueado;
- combinações de filtros.

A combinação de filtros deve restringir corretamente os resultados.

Não deve concatenar indevidamente Referência, Código ou outros critérios em uma única pesquisa genérica.

Os filtros foram homologados.

---

## 35. Paginação

A listagem utiliza paginação orientada ao backend.

Foram homologados:

- alteração da quantidade de itens por página;
- avanço de página;
- retorno de página;
- total de registros;
- indicador de intervalo exibido.

O padrão visual inclui informação equivalente a:

**Mostrando X–Y de Z**

A paginação deve continuar funcionando juntamente com os filtros ativos.

A paginação foi homologada.

---

## 36. Consulta consolidada

A operação Consultar apresenta as informações do Produto Venda em modo somente leitura.

A consulta consolidada contempla, conforme aplicável:

- dados principais;
- tipo;
- referência;
- classificações;
- SKUs;
- status dos SKUs;
- custos;
- preço;
- margem percentual;
- informações fiscais;
- imagens;
- estoque Loja × SKU;
- histórico funcional;
- dados de Fabricação Própria.

A consulta não deve permitir edição acidental.

---

## 37. Fabricação Própria

Produto Venda do tipo Fabricação Própria utiliza código interno:

`3`

Na interface deve ser apresentado como:

**Fabricação Própria**

e não como Produto Próprio.

A consulta pode apresentar informações relacionadas à Produção.

Entre elas:

- Fichas Técnicas vinculadas;
- Ordens de Produção vinculadas;
- status;
- quantidades;
- custos previstos;
- custos reais, quando disponíveis.

Essa consulta é informativa.

A lógica do módulo de Produção não foi redesenhada nesta implementação.

A consulta de Fabricação Própria foi homologada.

---

## 38. Revenda

Produto Venda do tipo Revenda utiliza código interno:

`1`

Produto de Revenda é normalmente abastecido através do processo de Compras.

A estrutura de Produto Venda não cria uma segunda lógica de Pedido de Compra.

Compras continua responsável pelos processos próprios de:

- pedido;
- fornecedor;
- recebimento;
- integração financeira;
- entrada de estoque.

A integração existente foi preservada.

---

## 39. Regras de disponibilidade para venda

A capacidade definitiva de um SKU participar de uma venda deve considerar as regras operacionais aplicáveis.

Entre os fatores estruturais estão:

- Produto ativo;
- Produto não bloqueado para venda;
- SKU ativo;
- disponibilidade de estoque conforme regra da operação.

As validações definitivas do processo de venda pertencem ao módulo de Vendas/PDV.

Produto Venda não redesenhou o PDV nesta fase.

---

## 40. Observações

Produto Venda possui campo de observações.

Observações são opcionais.

Seu objetivo é permitir informação interna pertinente ao cadastro.

Não foi criada regra operacional obrigatória baseada no conteúdo de Observações.

---

## 41. Integrações preservadas

Durante o desenvolvimento e homologação de Produto Venda foram preservadas as estruturas já existentes de:

- Compras;
- Estoque;
- Preços;
- Produção;
- Fiscal;
- Vendas/PDV;
- Auditoria;
- multiempresa.

Nenhum desses módulos foi redesenhado como consequência da unificação do Produto Venda.

---

## 42. Itens homologados

### Item 1 — Cadastro novo e campos obrigatórios

**Resultado:** OK

Foram validadas as obrigatoriedades principais do cadastro.

---

### Item 2 — Tipo imutável

**Resultado:** OK

Após criação, o tipo não pode ser alterado.

---

### Item 3 — Grade imutável após SKU

**Resultado:** OK

Produto com SKUs existentes não permite alteração da Grade.

---

### Item 4 — Descrição reduzida obrigatória

**Resultado:** OK

O sistema impede gravação sem descrição reduzida válida.

---

### Item 5 — Subgrupo obrigatório e coerente

**Resultado:** OK

Subgrupo é obrigatório e deve estar associado corretamente ao Grupo.

---

### Item 6 — Remoção de uma cor

**Resultado:** OK

A cor pode ser retirada e os SKUs correspondentes são inativados, preservando histórico.

---

### Item 7 — Remoção da última cor

**Resultado:** OK

A retirada da última cor foi processada corretamente.

---

### Item 8 — Reativação de cor e preservação do EAN

**Resultado:** OK

Ao adicionar novamente a cor, os mesmos SKUs são reativados e os EANs anteriores são preservados.

---

### Item 9 — Exclusão de Produto nunca utilizado

**Resultado:** OK

Produto sem utilização impeditiva pode ser excluído.

---

### Item 10 — Proteção de exclusão de Produto utilizado

**Resultado:** OK

Produto com utilização relevante não pode ser apagado fisicamente.

---

### Item 11 — Histórico funcional de alteração cadastral

**Resultado:** OK

Alterações cadastrais relevantes aparecem no Histórico Funcional.

---

### Item 12 — Alteração fiscal e histórico

**Resultado:** OK após correção

Durante a primeira homologação foi constatado que apenas NCM estava disponível na interface de edição.

A tela foi corrigida para apresentar os demais campos fiscais existentes no backend.

Após correção:

- campos fiscais ficaram editáveis;
- histórico fiscal permaneceu funcional;
- auditoria permaneceu funcional.

---

### Item 13 — Imagens

**Resultado:** OK após correção

Inicialmente não existia interface para cadastrar imagens.

Foi implementado gerenciamento de imagens no cadastro/edição.

Foram homologados:

- inclusão;
- remoção;
- principal;
- limite de 3;
- visualização;
- estado sem imagens.

---

### Item 14 — Estoque Loja × SKU

**Resultado:** OK

A consulta apresenta corretamente as combinações entre Loja e SKU e seus saldos.

---

### Item 15 — Consulta de Fabricação Própria

**Resultado:** OK

A consulta apresenta informações relacionadas a Ficha Técnica e Ordem de Produção quando existentes.

---

### Item 16 — Filtros

**Resultado:** OK

Filtros individuais e combinados foram validados.

---

### Item 17 — Inativar/Ativar Produto

**Resultado:** OK após correção

A primeira tentativa apresentou erro de autorização para usuário Admin funcional.

A autorização foi corrigida para utilizar o modelo funcional de permissões do Sysvar.

O reteste foi aprovado.

---

### Item 18 — Bloquear/Desbloquear venda

**Resultado:** OK após correção

Apresentava a mesma falha de autorização do Item 17.

Após correção, o fluxo foi retestado e aprovado.

---

### Item 19 — Paginação

**Resultado:** OK

Foram validados:

- tamanhos de página;
- avanço;
- retorno;
- total;
- indicador X–Y de Z;
- manutenção dos filtros.

---

## 43. Correções identificadas durante a homologação

A homologação manual identificou alguns pontos que não foram aceitos como concluídos até serem corrigidos.

Foram eles:

### 43.1 Modal de lojas

Problema:

- organização visual inferior ao modal de cores;
- ausência de seleção rápida de todas as lojas.

Correção:

- reorganização do layout;
- inclusão da ação **Todas**;
- inclusão/manutenção da opção de limpar seleção.

**Situação final:** HOMOLOGADO.

### 43.2 Status dos SKUs

Problema:

SKU inativo não possuía identificação suficientemente clara na consulta.

Correção:

- remoção da coluna Margem monetária;
- inclusão da coluna Status;
- apresentação textual Ativo/Inativo;
- manutenção de Margem %.

**Situação final:** HOMOLOGADO.

### 43.3 Campos fiscais

Problema:

Somente NCM aparecia na edição.

Correção:

- inclusão dos demais campos fiscais já existentes no backend;
- organização na seção Dados fiscais.

**Situação final:** HOMOLOGADO.

### 43.4 Nomenclatura

Problema:

Ainda existiam textos como:

- Produtos Revenda;
- Produto Próprio.

Correção:

- módulo visual passou a ser **Produto Venda**;
- tipo 3 passou a aparecer como **Fabricação Própria**.

**Situação final:** HOMOLOGADO.

### 43.5 Imagens

Problema:

Backend possuía estrutura de imagens, mas a interface não permitia gerenciá-las.

Correção:

- inclusão;
- remoção;
- imagem principal;
- limite de três;
- miniaturas;
- estado vazio na consulta.

**Situação final:** HOMOLOGADO.

### 43.6 Permissão de ações sensíveis

Problema:

Admin funcional do Sysvar recebia 403 por depender de `is_staff` ou permissão nativa Django.

Correção:

- utilização do modelo funcional de acesso do Sysvar para o módulo Produtos;
- preservação de motivo e senha;
- usuário sem acesso continua recebendo bloqueio.

**Situação final:** HOMOLOGADO.

---

## 44. Testes automatizados do fechamento

No fechamento da homologação foram adicionados e ajustados testes direcionados.

### Backend

Foram reportados:

**8 testes direcionados aprovados**

Cobertura adicional incluindo:

- permissão funcional;
- Admin autorizado;
- usuário sem permissão;
- senha inválida;
- motivo obrigatório;
- alteração fiscal;
- histórico;
- auditoria.

Validação:

~~~text
python manage.py check
~~~

Resultado reportado:

**sem issues**

### Frontend

Foram reportados:

**11 testes direcionados aprovados**

Cobertura incluindo pontos como:

- modal de lojas;
- seleção de todas;
- Status de SKU;
- campos fiscais;
- nomenclatura;
- imagens;
- fluxo de segurança.

Validação TypeScript:

~~~text
npx tsc -p tsconfig.app.json --noEmit
~~~

Resultado reportado:

**aprovado**

Foram mantidos apenas warnings Angular preexistentes relacionados a `disabled` em Reactive Forms durante testes.

---

## 45. Commits finais homologados

### Backend

Repositório:

`FernandoMurashima/sysvarbackend`

Commit final do fechamento:

`574f5badc79ab3a969bf24ffc67904215bdbc49a`

Mensagem:

`Corrige permissoes Produto Venda`

---

### Frontend

Repositório:

`FernandoMurashima/sysvarfrontend`

Commit final do fechamento:

`1be513e4a5d7b3220ae239fee555594307115826`

Mensagem:

`Finaliza homologacao visual Produto Venda`

---

## 46. Pontos deliberadamente não redesenhados

A homologação de Produto Venda não teve como objetivo redesenhar:

- PDV;
- emissão fiscal;
- NFC-e;
- motor comercial de preços;
- promoções;
- regras avançadas de reserva;
- produção;
- Ficha Técnica;
- Ordem de Produção;
- cálculo estrutural de custos;
- distribuição;
- compras;
- EAN;
- estoque negativo;
- sincronização offline.

Essas estruturas permanecem sob responsabilidade dos seus respectivos módulos.

---

## 47. Pendência futura — processamento de imagem reduzida

A única definição técnica deliberadamente não criada nesta fase foi o padrão definitivo de geração de imagem reduzida.

Ainda precisam ser definidos em decisão específica, quando necessário:

- dimensões;
- resolução;
- qualidade;
- formato;
- compressão;
- estratégia de armazenamento.

Não deve ser criada regra arbitrária para esses parâmetros.

Isso não impede o uso atual das imagens do Produto Venda.

---

## 48. Resultado final da homologação

Produto Venda foi homologado para o escopo definido nesta fase.

Resultado:

**19/19 itens aprovados**

Situação:

**HOMOLOGADO**

Abrangência final homologada:

- Revenda;
- Fabricação Própria;
- referência automática;
- campos obrigatórios;
- descrição reduzida;
- Grupo/Subgrupo;
- Unidade;
- Coleção;
- Grade;
- Cores;
- geração e preservação de SKUs;
- EAN;
- ativação/inativação de SKU;
- lojas;
- Estoque Loja × SKU;
- custos;
- preço existente;
- Margem %;
- fiscal;
- imagens;
- histórico funcional;
- Auditoria Central;
- ativação/inativação de Produto;
- bloqueio/desbloqueio de venda;
- exclusão protegida;
- filtros;
- paginação;
- consulta consolidada;
- Fabricação Própria;
- isolamento multiempresa;
- permissões funcionais.

O cadastro **Produto Venda** está fechado e homologado no escopo atual.