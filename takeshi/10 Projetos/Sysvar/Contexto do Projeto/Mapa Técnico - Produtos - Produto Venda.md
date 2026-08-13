---
type: technical-map
status: approved
project: Sysvar
group: Produtos
module: Produto Venda
phase: Fase 1
created: 2026-08-13
updated: 2026-08-13
tags:
  - sysvar
  - produtos
  - produto-venda
  - revenda
  - fabricação-própria
  - sku
  - ean
  - estoque
  - fiscal
  - imagens
  - auditoria
  - multiempresa
  - homologado
---

# Mapa Técnico - Produtos - Produto Venda

## 1. Identificação

- **Projeto:** Sysvar
- **Módulo:** Produtos
- **Funcionalidade:** Produto Venda
- **Tipos contemplados:** Revenda e Fabricação Própria
- **Escopo documentado:** Fase 1 — Cadastro e gestão estrutural do Produto Venda
- **Situação:** IMPLEMENTADO E HOMOLOGADO
- **Homologação manual:** 19/19 itens aprovados
- **Data da homologação:** 13/08/2026

---

# 2. Objetivo Técnico

Produto Venda representa a estrutura principal dos produtos comercializáveis no Sysvar.

A funcionalidade unifica dois tipos de Produto:

1. Revenda;
2. Fabricação Própria.

Internamente permanecem os códigos:

~~~text
tipo_produto = '1' → Revenda
tipo_produto = '3' → Fabricação Própria
~~~

A nomenclatura funcional da tela e do menu é:

**Produto Venda**

A arquitetura deve preservar obrigatoriamente:

- isolamento multiempresa;
- separação Produto × SKU;
- estoque por Loja × SKU;
- geração e preservação de EAN;
- referência automática;
- integração com Compras;
- integração com Produção;
- integração com Estoque;
- integração com Preços;
- informações fiscais;
- Histórico Funcional;
- Auditoria Central;
- ativação/inativação;
- bloqueio independente de venda;
- exclusão protegida;
- gestão de imagens;
- paginação e filtros server-side;
- compatibilidade com PDV e processos já existentes.

Produto Venda não contempla nesta fase:

**Uso e Consumo**.

Esse tipo permanece em fluxo próprio.

---

# 3. Backend

A funcionalidade está concentrada principalmente no app Django:

`produto`

Arquivos centrais:

- `produto/models.py`
- `produto/serializers.py`
- `produto/views.py`
- `produto/urls.py`
- `produto/permissions.py`
- `produto/tests.py`

Integrações relevantes:

- `cadastros`
- `accounts`
- `auditoria`
- `financeiro`
- `compras`
- `fiscal`
- módulos relacionados à Produção
- estruturas de Estoque e Preço

---

# 4. Frontend

A funcionalidade principal está concentrada em:

`src/app/features/Produtos`

Arquivos principais:

- `produtos.component.ts`
- `produtos.component.html`
- `produtos.component.css`
- `produtos.component.spec.ts`

Serviço principal:

`src/app/core/services/produtos.service.ts`

Integrações visuais relevantes:

- seletor de lojas;
- seletor de cores;
- shell/menu;
- serviços de cadastros auxiliares.

O frontend Angular permanece standalone.

---

# 5. Model Produto

Model principal:

`produto.models.Produto`

Produto representa a entidade cadastral principal.

Não representa uma variação individual de tamanho ou cor.

A variação individual é responsabilidade de:

`ProdutoDetalhe`

---

# 6. Responsabilidade do Produto

O Produto concentra informações comuns às suas variações.

Entre os campos e conceitos principais estão:

- `empresa`
- `tipo_produto`
- `referencia`
- `descricao`
- `descricao_reduzida`
- `unidade`
- `grupo`
- `subgrupo`
- `colecao`
- `material`
- `grade`
- `ncm`
- informações fiscais
- `ativo`
- `bloqueado_venda`
- `observacoes`
- informações resumidas de custo
- relacionamentos de preço
- imagens
- histórico funcional

---

# 7. Isolamento Multiempresa

Produto pertence a uma Empresa.

Relacionamento principal:

`Produto.empresa`

Toda operação deve respeitar o tenant do usuário autenticado.

O backend é autoridade sobre o isolamento.

Não confiar apenas em filtros do frontend.

O isolamento deve ser aplicado também aos relacionamentos auxiliares, incluindo:

- Grupo;
- Subgrupo;
- Coleção;
- Unidade;
- Grade;
- Cor;
- Loja;
- SKU;
- Estoque;
- Preço;
- Imagens;
- Histórico.

Dados de outra Empresa não podem ser utilizados para compor Produto Venda.

---

# 8. Tipos de Produto

Os tipos usados por Produto Venda são:

## 8.1 Revenda

Código:

`1`

Origem operacional principal:

- compra de fornecedor;
- recebimento;
- entrada de estoque;
- comercialização.

## 8.2 Fabricação Própria

Código:

`3`

Origem operacional principal:

- Ficha Técnica;
- Ordem de Produção;
- produção;
- entrada do produto produzido;
- comercialização.

A interface exibe:

**Fabricação Própria**

A antiga nomenclatura visual:

`Produto Próprio`

não deve ser utilizada.

---

# 9. Imutabilidade do Tipo

Após a criação do Produto, `tipo_produto` não deve ser alterado.

A proteção existe porque o tipo influencia relações operacionais e históricas.

Alterar posteriormente Revenda para Fabricação Própria, ou vice-versa, poderia comprometer:

- Compras;
- Produção;
- custos;
- Estoque;
- histórico;
- integrações.

Essa regra foi homologada.

---

# 10. Referência Automática

Produto Venda utiliza referência gerada automaticamente.

Formato:

~~~text
AA-BB-CCDDD
~~~

Onde:

- `AA` = ano da Coleção;
- `BB` = Estação;
- `CC` = código de referência do Grupo;
- `DDD` = sequência.

A geração utiliza a estrutura já existente de códigos/sequência.

A regra atende tanto:

- Revenda;
- Fabricação Própria.

A referência não deve ser recriada arbitrariamente em uma edição normal.

---

# 11. Coleção

Coleção participa da estrutura classificatória e da geração da referência.

Sua estrutura permanece no app `produto`.

Características já definidas incluem:

- código;
- estação;
- descrição;
- situação.

Produto Venda utiliza a Coleção existente.

A homologação não redesenhou o cadastro de Coleções.

---

# 12. Grupo

Grupo é obrigatório.

Grupo participa da classificação do Produto e também da referência automática.

O código de referência do Grupo integra o trecho `CC` da referência.

Grupo deve pertencer ao contexto permitido da Empresa.

---

# 13. Subgrupo

Subgrupo é obrigatório.

Subgrupo deve ser coerente com o Grupo selecionado.

O backend deve impedir combinação inválida.

A interface também deve auxiliar o usuário a escolher somente valores coerentes.

A regra foi homologada.

---

# 14. Unidade

Produto Venda exige Unidade.

Unidade é obrigatória.

Exemplos:

- UN;
- PC;
- CJ.

Produto Venda não deve ser salvo sem Unidade válida.

---

# 15. Descrição

Produto possui:

- descrição principal;
- descrição reduzida.

A descrição reduzida é obrigatória.

Limite funcional:

`60 caracteres`

Essa informação pode ser utilizada em contextos onde a descrição completa seja inadequada.

---

# 16. Material

Material é opcional.

Não impede gravação do Produto.

Pode ser utilizado em classificações e integrações futuras.

Para Fabricação Própria, Material não substitui os componentes definidos na Ficha Técnica.

---

# 17. Grade

Grade é obrigatória para Produto Venda.

Grade determina quais tamanhos podem compor os SKUs.

Exemplo:

~~~text
Produto
  ↓
Grade
  ↓
38
40
42
44
46
48
~~~

---

# 18. Grade Imutável após SKU

Após a existência de SKUs, a Grade não pode ser alterada.

Motivo técnico:

Os SKUs já possuem relacionamento com:

- Tamanho;
- Cor;
- EAN;
- Estoque;
- movimentações;
- histórico.

Alterar a Grade depois da criação das variações poderia gerar inconsistência estrutural.

Essa regra foi homologada.

---

# 19. Model ProdutoDetalhe

Model de variação:

`produto.models.ProdutoDetalhe`

ProdutoDetalhe representa o SKU.

A identidade funcional do SKU é:

~~~text
Produto + Cor + Tamanho
~~~

ProdutoDetalhe é a unidade operacional utilizada para:

- EAN;
- Estoque;
- situação do SKU;
- custos por variação;
- futuras operações de venda e movimentação.

---

# 20. Unicidade do SKU

A combinação lógica deve impedir duplicidade indevida da mesma variação.

Conceitualmente:

~~~text
Produto
+ Cor
+ Tamanho
= SKU único
~~~

A mesma combinação não deve gerar múltiplos SKUs ativos paralelos.

---

# 21. Geração de SKUs

A geração ocorre a partir das Cores selecionadas e dos Tamanhos pertencentes à Grade.

Fluxo conceitual:

~~~text
Produto
   ↓
Cor selecionada
   ↓
Tamanhos da Grade
   ↓
ProdutoDetalhe para cada combinação
   ↓
EAN automático
~~~

Exemplo:

~~~text
Cor Preta
+
Grade 38, 40, 42

gera:

Preta 38
Preta 40
Preta 42
~~~

---

# 22. Inclusão de Cor

Quando nova Cor é adicionada:

1. backend identifica os tamanhos da Grade;
2. verifica SKUs anteriores daquela Cor;
3. cria os inexistentes;
4. reativa os existentes quando aplicável;
5. preserva códigos já existentes;
6. preserva EAN quando o SKU já existia.

Não duplicar SKU anteriormente inativado.

---

# 23. Remoção de Cor

Remover Cor do Produto não deve apagar fisicamente seus SKUs.

Os SKUs da Cor são:

`inativados`

Motivo:

- preservação de EAN;
- preservação histórica;
- movimentações anteriores;
- possíveis referências externas.

Foi homologada inclusive a remoção da última Cor.

---

# 24. Reativação de Cor

Ao adicionar novamente uma Cor retirada anteriormente:

- localizar os SKUs existentes;
- reativar;
- preservar `ean13`;
- preservar identificadores;
- preservar histórico.

Não gerar novo EAN para o mesmo SKU.

Esse comportamento foi homologado manualmente.

---

# 25. EAN

EAN pertence ao SKU.

A estrutura de geração automática existente foi preservada.

A arquitetura utiliza configuração própria de EAN para a Empresa.

Entre os conceitos existentes estão:

- prefixo de país;
- prefixo da Empresa;
- item sequencial;
- dígito verificador.

Produto Venda não deve permitir geração aleatória ou paralela de EAN fora da estrutura existente.

---

# 26. Preservação de EAN

EAN deve permanecer estável para o SKU.

Inativar um SKU não libera seu EAN para outro SKU.

Reativar o SKU deve recuperar o mesmo EAN.

Essa regra foi homologada.

---

# 27. Status do SKU

ProdutoDetalhe possui situação ativo/inativo.

Na consulta consolidada, a interface exibe explicitamente:

- Ativo;
- Inativo.

A tabela não deve ocultar o estado do SKU.

Isso é especialmente importante para SKUs preservados após retirada de Cor.

---

# 28. Custos do SKU

ProdutoDetalhe possui informações de custo operacional.

Entre os conceitos utilizados estão:

- custo original;
- custo da última compra;
- custo médio.

O SKU é a principal unidade de variação para custos operacionais.

Produto pode apresentar visão resumida ou consolidada.

---

# 29. Fabricação Própria e Custos

Produto do tipo Fabricação Própria pode receber custos decorrentes da Produção.

A estrutura já existente de Produção deve continuar sendo autoridade para:

- custo previsto;
- custo real;
- apropriação de custos;
- atualização relacionada à Ordem de Produção.

Produto Venda não redesenhou essa lógica.

---

# 30. Estoque

Estoque não pertence diretamente apenas ao Produto.

A granularidade operacional é:

~~~text
Loja × SKU
~~~

Ou seja:

~~~text
Loja
  ↓
ProdutoDetalhe
  ↓
Saldo
~~~

---

# 31. Inicialização de Estoque

No cadastro de Produto Venda podem ser selecionadas Lojas para inicializar a estrutura de Estoque.

A inicialização:

- cria/prepara registros necessários;
- utiliza os SKUs do Produto;
- não significa entrada física de mercadoria;
- saldo inicial permanece zero quando não existe movimentação.

Não confundir cadastro da estrutura com movimento de Estoque.

---

# 32. Seleção de Lojas

A interface utiliza componente específico para seleção de Lojas.

O usuário pode:

- selecionar individualmente;
- desmarcar;
- selecionar todas;
- limpar.

A ação:

**Todas**

foi adicionada durante a homologação.

O modal foi visualmente aproximado do padrão utilizado na seleção de Cores.

---

# 33. Estoque Físico

Representa o saldo registrado fisicamente para o SKU em determinada Loja.

Não é saldo global do Produto.

---

# 34. Reserva

Reserva representa quantidade comprometida conforme processos que utilizem esse conceito.

Produto Venda não redesenhou as regras de reserva.

---

# 35. Disponível

Conceitualmente:

~~~text
Disponível = Estoque Físico - Reserva
~~~

A consulta apresenta:

- Físico;
- Reserva;
- Disponível.

---

# 36. Estoque Negativo

Produto Venda preserva a estrutura existente de Estoque Negativo.

Não criar uma segunda regra dentro do cadastro.

A decisão sobre permitir ou impedir saldo negativo deve continuar sendo feita pela configuração e pelos processos responsáveis.

---

# 37. Preços

Preço não pertence individualmente ao SKU nesta estrutura funcional principal.

Produto se relaciona com Tabelas de Preço.

A arquitetura prevê múltiplas tabelas.

Não existe exigência de uma Tabela por Loja.

O gerenciamento comercial definitivo de preços deve permanecer no domínio de Preços/Vendas.

---

# 38. Margem

A consulta apresenta:

`Margem %`

A coluna de margem monetária foi retirada da grade principal de SKUs para dar espaço ao Status.

O cálculo existente de margem não foi alterado.

---

# 39. Dados Fiscais

Produto contém os campos fiscais existentes para uso nos processos fiscais e de venda.

Campos relevantes:

- `ncm`
- `origem_mercadoria`
- `csosn_ou_cst_icms`
- `aliquota_icms`
- `cfop_venda_dentro`
- `cfop_venda_fora`
- `cst_pis`
- `aliq_pis`
- `cst_cofins`
- `aliq_cofins`
- `ipi_situacao`
- `aliq_ipi`

Esses campos são editáveis.

A interface os agrupa em:

**Dados fiscais**

---

# 40. Histórico de Alterações Fiscais

Alterações fiscais relevantes geram registro em:

`ProdutoVendaHistorico`

com evento correspondente à alteração fiscal.

Também devem gerar rastreabilidade na:

`Audit Central`

As duas estruturas possuem finalidades diferentes e não devem ser confundidas.

---

# 41. ProdutoVendaHistorico

Model:

`ProdutoVendaHistorico`

Responsabilidade:

registrar eventos funcionais importantes do Produto Venda.

Eventos incluem conceitos como:

- alteração cadastral;
- alteração fiscal;
- ativação;
- inativação;
- bloqueio de venda;
- desbloqueio de venda.

O histórico é somente leitura para o usuário operacional.

Não deve ser utilizado como tabela editável.

---

# 42. Auditoria Central

A Auditoria Central permanece responsável pela rastreabilidade técnica geral.

Integração:

`AuditService`

Alterações cadastrais e fiscais relevantes devem produzir informação de antes/depois quando aplicável.

Exemplos de informações:

- campos alterados;
- valores anteriores;
- valores novos;
- usuário;
- objeto;
- ação.

ProdutoVendaHistorico não substitui `AuditLog`.

---

# 43. ProdutoImagem

Model:

`ProdutoImagem`

Representa imagem associada ao Produto.

Não ao SKU.

Não à Cor.

---

# 44. Regras de Imagens

Regras homologadas:

- imagem opcional;
- máximo 3;
- uma principal;
- inclusão;
- exclusão;
- marcação de principal;
- consulta por miniatura.

Não criar imagem por Cor nesta fase.

Não criar imagem por SKU nesta fase.

---

# 45. Upload de Imagem

O frontend utiliza `FormData`.

Fluxo conceitual:

~~~text
Usuário seleciona imagem
        ↓
Frontend mantém arquivo
        ↓
Produto é salvo
        ↓
Produto possui ID
        ↓
POST ProdutoImagem
        ↓
Backend grava vínculo com Produto
~~~

Em edição de Produto já existente, o upload pode ser feito diretamente utilizando o ID existente.

---

# 46. Imagem Principal

A API permite marcar uma imagem como principal.

Deve existir no máximo uma imagem principal por Produto.

Quando outra for marcada, a estrutura deve preservar essa unicidade.

---

# 47. Imagem Reduzida

A estrutura possui suporte para URL de imagem reduzida.

A interface utiliza:

~~~text
imagem_reduzida_url
~~~

quando disponível.

Fallback:

~~~text
imagem_url
~~~

Não foram definidos nesta fase parâmetros obrigatórios de:

- resolução;
- dimensões;
- formato;
- compressão;
- qualidade.

Não inventar esses valores em implementações futuras sem decisão específica.

---

# 48. Consulta Consolidada

A tela Consultar funciona em modo somente leitura.

A consulta reúne, quando aplicável:

- dados cadastrais;
- classificação;
- tipo;
- referência;
- SKUs;
- Status dos SKUs;
- custos;
- preço;
- Margem %;
- Dados fiscais;
- imagens;
- Estoque Loja × SKU;
- histórico;
- Produção para Fabricação Própria.

---

# 49. Consulta de Fabricação Própria

Para `tipo_produto = '3'`, a consulta pode apresentar informações relacionadas à Produção.

Estruturas exibidas incluem:

- Fichas Técnicas;
- Ordens de Produção.

Exemplos de informações:

- identificação;
- versão;
- Status;
- quantidade;
- custo previsto;
- custo real.

Essa tela é apenas uma consulta consolidada.

Produto Venda não assume responsabilidade pelo processo de Produção.

---

# 50. Ativo/Inativo

Produto possui campo:

`ativo`

Inativação é lógica.

Não representa exclusão física.

Produto Inativo continua preservando:

- cadastro;
- SKUs;
- EAN;
- histórico;
- Estoque;
- movimentações anteriores.

---

# 51. Bloqueio de Venda

Produto possui campo independente:

`bloqueado_venda`

Esse campo não deve ser confundido com `ativo`.

Conceitualmente:

~~~text
Produto ativo
+
bloqueado_venda = True

= Produto cadastralmente ativo,
  porém bloqueado para novas vendas
~~~

A distinção deve ser preservada.

---

# 52. Ações Sensíveis

Ações customizadas incluem operações como:

- inativar;
- ativar;
- bloquear venda;
- desbloquear venda.

A autorização utiliza:

`CanToggleProductFlags`

---

# 53. Permissão Funcional

A implementação anterior utilizava:

- `is_staff`;
- ou permissão nativa Django.

Isso foi substituído pelo modelo funcional do Sysvar.

Estrutura utilizada:

`EffectiveAccessService`

Verificação conceitual:

~~~text
EffectiveAccessService(user)
    .has_module_access("produtos", EDIT)
~~~

Portanto, um Admin funcional do Sysvar não precisa ser `is_staff` do Django Admin apenas para executar essas operações.

---

# 54. Usuário sem Permissão

Usuário autenticado sem acesso `EDIT` ao módulo Produtos deve receber:

`HTTP 403`

A proteção é backend.

Ocultar botão no frontend não é suficiente.

---

# 55. Motivo e Senha

Ações sensíveis que já exigiam confirmação mantêm essa proteção.

Inativar exige:

- motivo;
- senha.

Bloquear venda exige:

- motivo;
- senha.

O backend valida essas informações.

Senha incorreta deve ser rejeitada.

Motivo inválido deve ser rejeitado.

A correção de permissão não deve enfraquecer essa camada.

---

# 56. Exclusão Física

Produto só pode ser apagado fisicamente quando não possui utilização impeditiva.

Antes da exclusão devem ser verificadas relações que exigem preservação histórica.

---

# 57. Registros de Estoque Zero

A existência apenas de estruturas vazias de Estoque criadas durante inicialização não deve necessariamente impedir a exclusão de um Produto nunca utilizado.

A implementação permite remover estruturas vazias seguras quando necessário para concluir a exclusão.

---

# 58. Produto Utilizado

Produto com movimentação ou uso relevante deve ser protegido contra exclusão.

Nesses casos utilizar:

- Inativação;
- Bloqueio de venda;

conforme a necessidade operacional.

---

# 59. Filtros Server-Side

A listagem não deve carregar todos os Produtos para filtrar apenas no navegador.

Filtros são enviados ao backend.

Filtros homologados incluem:

- busca geral;
- Referência;
- Código;
- Grupo;
- Coleção;
- Status;
- Bloqueado;
- Tipo;
- combinações.

---

# 60. Busca e Filtros Específicos

Referência e Código possuem filtros próprios.

Não devem ser incorretamente concatenados em uma única string genérica.

A API deve receber parâmetros distintos quando o critério funcional for distinto.

---

# 61. Paginação Server-Side

A listagem é paginada pelo backend.

Fluxo:

~~~text
Frontend
   ↓
page
page_size
filtros
ordenação
   ↓
Backend
   ↓
tenant
filtros
ordenação
paginação
   ↓
results + count
   ↓
Frontend
~~~

O frontend apresenta indicador equivalente a:

~~~text
Mostrando X–Y de Z
~~~

---

# 62. Ordenação

Ordenação deve ser aplicada no backend juntamente com os filtros e paginação.

Não deve depender da existência da página inteira carregada no frontend.

---

# 63. Frontend — Formulário

O formulário de Produto Venda contempla blocos como:

- dados principais;
- preço;
- Dados fiscais;
- Lojas vinculadas;
- Cores vinculadas;
- SKUs e custos;
- Imagens.

A interface muda conforme:

- criação;
- edição;
- consulta.

Consulta permanece somente leitura.

---

# 64. Frontend — Lojas

Componente utilizado:

`app-lojas-selector`

Permite seleção de lojas.

O modal principal adiciona ferramentas:

- Todas;
- Limpar.

O layout deve permanecer compacto e responsivo.

---

# 65. Frontend — Cores

A seleção de Cores é separada da seleção de Lojas.

As alterações na seleção de Cores participam diretamente da sincronização de SKUs.

Não tratar Cor apenas como informação visual.

Ela altera a estrutura de ProdutoDetalhe.

---

# 66. Frontend — Imagens

Serviço possui operações para:

- listar imagens;
- criar imagem;
- marcar principal;
- remover imagem.

O upload utiliza arquivo real.

Limite visual:

`3 imagens`

A regra também deve permanecer protegida no backend.

---

# 67. Frontend — Status do SKU

A tabela de SKUs apresenta Status textual.

Exemplo:

~~~text
Ativo
Inativo
~~~

Não utilizar apenas diferenciação por cor CSS.

O texto é obrigatório para clareza operacional.

---

# 68. Integração com Compras

Produto Revenda utiliza os processos existentes de Compras.

Produto Venda não cria Pedido de Compra paralelo.

Compras permanece responsável por:

- fornecedor;
- pedido;
- recebimento;
- entrada;
- integração financeira.

---

# 69. Integração com Produção

Produto Fabricação Própria utiliza a estrutura existente de Produção.

Produto Venda não redefine:

- Ficha Técnica;
- Ordem de Produção;
- consumo de componentes;
- facção;
- cálculo de custos;
- encerramento de OP.

A consulta apenas agrega informações relevantes.

---

# 70. Integração com Estoque

Produto Venda fornece a identidade dos SKUs.

Estoque permanece responsável pelos saldos e movimentos.

Não alterar saldo diretamente pelo cadastro de Produto, exceto inicialização estrutural em zero quando prevista.

---

# 71. Integração com Vendas/PDV

A decisão final de venda deve utilizar informações como:

- Produto ativo;
- Produto não bloqueado;
- SKU ativo;
- Estoque disponível;
- regras específicas do PDV.

O cadastro não substitui as validações do processo de Venda.

PDV não foi redesenhado nesta fase.

---

# 72. Integração Fiscal

Dados fiscais do Produto são utilizados pelos processos fiscais e comerciais.

O cadastro permite manutenção dessas informações.

A emissão de documento fiscal permanece responsabilidade do módulo Fiscal.

---

# 73. Integração com Preços

Produto Venda utiliza a estrutura de Tabela de Preço existente.

Não criar preço independente e paralelo somente para esta tela.

Preço comercial definitivo continua sendo domínio próprio.

---

# 74. Segurança Arquitetural

Princípios que devem ser preservados:

1. backend é autoridade;
2. frontend não garante segurança sozinho;
3. tenant sempre deve ser aplicado;
4. ações sensíveis exigem permissão funcional;
5. senha não substitui permissão;
6. permissão não substitui senha quando a ação exige confirmação;
7. objetos utilizados devem preservar histórico;
8. EAN não deve ser reciclado indevidamente;
9. SKU inativado não deve ser apagado apenas porque a Cor foi retirada.

---

# 75. Histórico e Auditoria

Separação obrigatória:

~~~text
ProdutoVendaHistorico
    =
Histórico funcional e operacional
~~~

~~~text
AuditLog
    =
Auditoria técnica central
~~~

Não eliminar uma estrutura em favor da outra.

---

# 76. Models Centrais da Funcionalidade

Estruturas principais:

- `Produto`
- `ProdutoDetalhe`
- `ProdutoVendaHistorico`
- `ProdutoImagem`

Estruturas relacionadas importantes:

- Grade;
- Tamanho;
- Cor;
- Coleção;
- Grupo;
- Subgrupo;
- Unidade;
- ConfigEan;
- Codigos;
- Preço/Tabela de Preço;
- Estoque;
- Loja;
- Ficha Técnica;
- Ordem de Produção.

---

# 77. Fluxo Estrutural do Produto Venda

~~~text
Empresa
   ↓
Produto
   ↓
Tipo
   ├── Revenda
   └── Fabricação Própria
   ↓
Grade
   ↓
Cores
   ↓
ProdutoDetalhe / SKU
   ↓
EAN
   ↓
Loja × SKU
   ↓
Estoque
~~~

Em paralelo:

~~~text
Produto
   ├── Dados fiscais
   ├── Tabelas de preço
   ├── Imagens
   ├── Histórico funcional
   └── Auditoria Central
~~~

---

# 78. Fluxo Revenda

~~~text
Produto Venda
tipo = 1
   ↓
Cadastro estrutural
   ↓
SKUs / EAN
   ↓
Compra
   ↓
Recebimento
   ↓
Estoque
   ↓
Venda
~~~

---

# 79. Fluxo Fabricação Própria

~~~text
Produto Venda
tipo = 3
   ↓
Cadastro estrutural
   ↓
SKUs / EAN
   ↓
Ficha Técnica
   ↓
Ordem de Produção
   ↓
Produção
   ↓
Entrada
   ↓
Estoque
   ↓
Venda
~~~

---

# 80. Testes Backend

O fechamento de Produto Venda possui testes direcionados.

Cobertura relevante inclui:

- sincronização de Cores;
- inativação;
- reativação;
- preservação de EAN;
- exclusão segura;
- proteção de Produto utilizado;
- filtros;
- tenant;
- Histórico Funcional;
- regras de Imagem;
- permissão funcional;
- usuário sem permissão;
- senha inválida;
- motivo obrigatório;
- alterações fiscais;
- Auditoria Central.

No fechamento final foram reportados:

`8 testes direcionados aprovados`

além dos testes anteriores do módulo.

---

# 81. Testes Frontend

A suíte direcionada contempla pontos como:

- filtros;
- Status do SKU;
- Dados fiscais;
- Imagens;
- seleção de Lojas;
- ação Todas;
- nomenclatura;
- fluxo de segurança.

No fechamento final foram reportados:

`11 testes direcionados aprovados`

Validação TypeScript:

~~~text
npx tsc -p tsconfig.app.json --noEmit
~~~

Resultado reportado:

`aprovado`

---

# 82. Validação Django

Comando executado no fechamento:

~~~text
python manage.py check
~~~

Resultado reportado:

`System check identified no issues`

---

# 83. Migrations da Consolidação

A estrutura de Produto Venda introduziu anteriormente suporte a:

- ProdutoVendaHistorico;
- ProdutoImagem.

No fechamento final de homologação não foi necessária nova migration.

Os campos fiscais já existiam.

A correção final de permissões também não exigiu alteração de banco.

---

# 84. Commits de Referência

## Implementação inicial consolidada

Backend:

`196042a24e7dc8840234cc333ff6c0bea1edb172`

Frontend:

`6d8681c312cf607a971d29bb6814e7b05df3120b`

---

## Fechamento técnico anterior

Backend:

`15e5afb167a7c94efc144fa7f892c4fce5b00bda`

Frontend:

`b1446baca3d388ec5f6d3610e35f2374f73951d1`

---

## Fechamento final após homologação

Backend:

`574f5badc79ab3a969bf24ffc67904215bdbc49a`

Mensagem:

`Corrige permissoes Produto Venda`

Frontend:

`1be513e4a5d7b3220ae239fee555594307115826`

Mensagem:

`Finaliza homologacao visual Produto Venda`

Esses são os commits finais considerados homologados para o escopo atual.

---

# 85. Itens Deliberadamente Fora do Escopo

Não redesenhar como consequência deste módulo:

- Produto Uso e Consumo;
- PDV;
- NFC-e;
- emissão fiscal;
- preço avançado;
- promoções;
- motor de reserva;
- sincronização offline;
- Produção;
- facção;
- Distribuição;
- Compras;
- cálculo completo de CMV;
- Estoque negativo;
- regras avançadas de comissão;
- planejamento comercial.

Cada assunto deve permanecer em seu domínio próprio.

---

# 86. Pendência Técnica Futura — Imagem Reduzida

Ainda não existe decisão definitiva para geração automática da imagem reduzida.

Parâmetros ainda não aprovados:

- largura;
- altura;
- resolução;
- formato;
- qualidade;
- compressão.

Até decisão futura:

~~~text
usar imagem_reduzida_url quando existir
senão
usar imagem_url
~~~

Não criar parâmetros arbitrários.

---

# 87. Regras que Não Devem Regredir

Implementações futuras devem preservar:

1. nome funcional Produto Venda;
2. tipo 1 = Revenda;
3. tipo 3 = Fabricação Própria;
4. tipo imutável;
5. referência automática;
6. Grade obrigatória;
7. Grade imutável após SKU;
8. Grupo obrigatório;
9. Subgrupo obrigatório;
10. Unidade obrigatória;
11. descrição reduzida obrigatória;
12. SKU = Produto × Cor × Tamanho;
13. retirada de Cor inativa SKU;
14. reentrada de Cor reativa SKU;
15. EAN preservado;
16. Estoque Loja × SKU;
17. Produto inativo não é Produto excluído;
18. bloqueio de venda é independente de ativo;
19. Produto utilizado não pode ser excluído;
20. fiscal editável e auditado;
21. histórico funcional separado de Auditoria Central;
22. até 3 imagens;
23. uma imagem principal;
24. sem imagem por Cor;
25. sem imagem por SKU;
26. filtros server-side;
27. paginação server-side;
28. isolamento multiempresa;
29. ações sensíveis usando permissão funcional do Sysvar;
30. motivo e senha preservados onde exigidos.

---

# 88. Estado Atual

Produto Venda encontra-se:

**IMPLEMENTADO E HOMOLOGADO**

Homologação manual:

**19/19 itens aprovados**

O escopo de Cadastro de Produto Venda está fechado para esta fase.

Próximas evoluções devem respeitar este documento como mapa técnico consolidado e não devem alterar regras homologadas sem nova decisão funcional registrada.