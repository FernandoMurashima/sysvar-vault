---
type: technical-map
status: approved
project: Sysvar
group: Produtos
module: Produto Uso/Consumo
phase: Fase 1
created: 2026-08-14
updated: 2026-08-14
tags:
  - sysvar
  - produtos
  - produto-uso-consumo
  - uso-consumo
  - estoque
  - fiscal
  - compras
  - auditoria
  - multiempresa
  - homologado
---

# Mapa Técnico - Produtos - Produto Uso e Consumo

## 1. Identificação

- **Projeto:** [[Sysvar]]
- **Módulo:** Produtos
- **Funcionalidade:** Produto Uso/Consumo
- **Tipo interno:** `tipo_produto = '2'`
- **Escopo documentado:** Fase 1 — Cadastro e gestão estrutural
- **Situação:** IMPLEMENTADO E HOMOLOGADO
- **Data de consolidação:** 14/08/2026

### Documentos relacionados

- [[Sysvar]]
- [[Homologação - Produtos - Produto Uso e Consumo]]
- [[Workflows - Produtos - Produto Uso e Consumo]]
- [[Modelo de Domínio - Produtos - Produto Uso e Consumo]]
- [[Riscos e Cuidados - Produtos - Produto Uso e Consumo]]
- [[Homologação - Produtos - Insumos]]
- [[Homologação - Produtos - Cadastros Auxiliares]]
- [[Mapa Técnico - Produtos - Produto Venda]]

---

# 2. Objetivo Técnico

Produto Uso/Consumo representa no [[Sysvar]] os itens adquiridos para utilização interna pela empresa.

Esses produtos:

- não são destinados à venda;
- não representam Produto Venda;
- não utilizam Grade;
- não utilizam Cor × Tamanho;
- não utilizam SKU comercial;
- não participam da Ficha Técnica;
- não são consumidos pela Ordem de Produção como componentes produtivos;
- podem participar de Compras;
- podem possuir estoque;
- podem possuir informações fiscais;
- possuem histórico próprio;
- devem respeitar isolamento multiempresa.

O tipo interno utilizado é:

~~~text
tipo_produto = '2'
~~~

A nomenclatura funcional da tela permanece:

**Produto Uso/Consumo**

As regras homologadas estão consolidadas em:

[[Homologação - Produtos - Produto Uso e Consumo]]

---

# 3. Separação de domínios dentro de Produtos

O módulo Produtos possui tipos com responsabilidades distintas.

## 3.1 Produto Venda

Abrange:

~~~text
tipo_produto = '1' → Revenda
tipo_produto = '3' → Fabricação Própria
~~~

Documentação:

[[Mapa Técnico - Produtos - Produto Venda]]

## 3.2 Produto Uso/Consumo

~~~text
tipo_produto = '2'
~~~

Representa consumo interno.

## 3.3 Insumo

~~~text
tipo_produto = '4'
~~~

Representa componente utilizado na fabricação.

Produto Uso/Consumo e Insumo não devem voltar a ser tratados como uma única funcionalidade.

---

# 4. Backend

A funcionalidade está concentrada principalmente no app Django:

`produto`

Arquivos centrais:

- `produto/models.py`
- `produto/serializers.py`
- `produto/views.py`
- `produto/urls.py`
- `produto/permissions.py`
- `produto/tests.py`

O backend permanece responsável por:

- regras de domínio;
- isolamento multiempresa;
- validação dos relacionamentos;
- geração do código;
- lifecycle;
- proteção de exclusão;
- histórico;
- auditoria;
- validação de dados fiscais;
- paginação e filtros server-side.

---

# 5. Frontend

A funcionalidade está concentrada na feature específica de Uso/Consumo.

Estrutura principal utilizada no frontend:

`src/app/features/produtos-uso`

Serviços e models ficam na estrutura compartilhada do frontend conforme implementação vigente.

O frontend é responsável por:

- formulário;
- listagem;
- indicadores;
- filtros;
- consulta;
- edição;
- ativação/inativação;
- exclusão;
- histórico;
- apresentação de informações fiscais;
- interação com os endpoints.

O frontend não deve substituir as validações de domínio do backend.

---

# 6. Model Produto

Produto Uso/Consumo utiliza a entidade principal de Produto diferenciada pelo tipo:

~~~text
tipo_produto = '2'
~~~

A entidade representa diretamente o item cadastrado.

Diferentemente do Produto Venda, não existe necessidade funcional de gerar uma árvore de variações baseada em:

~~~text
Produto
  ↓
Cor
  ↓
Tamanho
  ↓
SKU
~~~

A identidade operacional permanece no próprio Produto.

---

# 7. Código próprio

Produto Uso/Consumo utiliza código automático no padrão:

~~~text
USO-000001
USO-000002
USO-000003
...
~~~

Características obrigatórias:

- automático;
- sequencial;
- único por Empresa;
- imutável;
- não reutilizável.

A geração do código pertence ao backend.

O frontend não deve calcular sequência própria.

---

# 8. Sequência por Empresa

A sequência deve respeitar o contexto multiempresa.

Conceitualmente:

~~~text
Empresa A
USO-000001
USO-000002

Empresa B
USO-000001
USO-000002
~~~

A unicidade deve ser garantida dentro da Empresa correspondente.

O isolamento não deve depender apenas de filtros visuais.

---

# 9. Descrição

Campo obrigatório.

Limite funcional:

~~~text
120 caracteres
~~~

A descrição representa a identificação principal do item.

---

# 10. Descrição reduzida

Campo obrigatório.

Limite funcional:

~~~text
60 caracteres
~~~

É utilizada quando a aplicação necessita representar o produto de forma compacta.

---

# 11. Unidade

Produto Uso/Consumo exige Unidade.

A Unidade deve:

- existir;
- estar acessível no contexto da Empresa;
- ser válida para o Produto.

O cadastro auxiliar correspondente está documentado em:

[[Homologação - Produtos - Cadastros Auxiliares]]

---

# 12. Ausência de Grade

Produto Uso/Consumo não possui relacionamento funcional obrigatório com Grade.

Não deve ser adicionada artificialmente estrutura de:

- Grade;
- Tamanho;
- combinação por Tamanho.

Essa separação deve permanecer explícita no código e na interface.

---

# 13. Ausência de Cor comercial

Produto Uso/Consumo não possui variação por Cor.

Não deve utilizar Cor para geração de SKU.

---

# 14. Ausência de SKU comercial

Produto Uso/Consumo não utiliza `ProdutoDetalhe` como estrutura obrigatória de variação comercial Cor × Tamanho.

A identidade permanece no Produto.

Não replicar a arquitetura de Produto Venda sem necessidade funcional.

---

# 15. Ausência de EAN obrigatório

EAN não é requisito obrigatório do cadastro.

Não se deve bloquear a criação de Produto Uso/Consumo pela ausência de código de barras.

A estrutura de EAN automática de Produto Venda não deve ser aplicada indiscriminadamente a este tipo.

---

# 16. Ausência de Coleção

Produto Uso/Consumo não depende de Coleção.

Também não utiliza a referência automática de Produto Venda:

~~~text
AA-BB-CCDDD
~~~

Seu identificador próprio é:

~~~text
USO-XXXXXX
~~~

---

# 17. Grupo e Subgrupo

Grupo e Subgrupo não fazem parte do conjunto obrigatório do fluxo homologado de Uso/Consumo.

Não criar dependência artificial dessas estruturas.

---

# 18. Material

Material não faz parte do conjunto funcional obrigatório de Produto Uso/Consumo.

Essa característica diferencia Uso/Consumo de Insumos.

Ver:

[[Modelo de Domínio - Produtos - Insumos]]

---

# 19. NCM

NCM é opcional no cadastro.

Quando informado:

- deve ser válido;
- deve respeitar a Empresa;
- deve utilizar a estrutura já existente do sistema.

Ausência de NCM não impede o cadastro.

---

# 20. Estrutura fiscal

Produto Uso/Consumo possui suporte aos dados fiscais já existentes na estrutura de Produto.

Entre os conceitos disponíveis estão:

- NCM;
- origem;
- CST/CSOSN;
- ICMS;
- CFOP;
- PIS;
- COFINS;
- IPI.

O cadastro permite salvar o Produto mesmo que nem todos os campos fiscais estejam completos.

---

# 21. Fiscal Incompleto

O backend/frontend utilizam o conceito funcional:

**Fiscal Incompleto**

Essa condição permite identificar produtos cuja estrutura fiscal ainda precisa de complementação.

Fiscal Incompleto:

- não impede cadastro;
- não transforma o registro em inválido;
- deve ser visível nos indicadores/filtros adequados.

---

# 22. Validação fiscal tardia

A exigência completa dos dados fiscais pertence à operação que realmente necessitar deles.

Fluxo:

~~~text
Cadastro
   ↓
Fiscal pode estar incompleto
   ↓
Operação fiscal real
   ↓
Validação dos campos exigidos
~~~

Não antecipar no cadastro exigências que pertencem a outro processo.

---

# 23. Lifecycle

Produto Uso/Consumo utiliza lifecycle simples:

~~~text
ATIVO
  ↕
INATIVO
~~~

Não possui estado específico de bloqueio comercial.

As transições devem respeitar as permissões existentes.

---

# 24. Ausência de Bloqueio de Venda

Produto Uso/Consumo não participa do fluxo comercial de venda.

Portanto não necessita das ações:

- Bloquear Venda;
- Desbloquear Venda.

Essas ações pertencem ao domínio de Produto Venda.

---

# 25. Exclusão protegida

A exclusão física deve ser permitida somente quando não existirem dependências operacionais que exijam preservação.

Quando o Produto já tiver sido utilizado, a regra preferencial é:

~~~text
INATIVAR
~~~

e preservar a identidade histórica.

A decisão deve ser realizada pelo backend com base nos relacionamentos reais.

---

# 26. Histórico funcional próprio

Produto Uso/Consumo utiliza histórico funcional específico.

A estrutura de histórico deve permanecer separada da estrutura de Produto Venda.

O histórico registra alterações relevantes como:

- descrição;
- descrição reduzida;
- unidade;
- fiscal;
- observações;
- situação;
- demais campos monitorados.

A representação deve permitir identificar:

~~~text
valor anterior → valor novo
~~~

---

# 27. Auditoria Central

Além do histórico funcional, operações relevantes devem continuar integradas à Auditoria Central.

Responsabilidades:

### Histórico do Produto

Visão funcional da evolução do cadastro.

### Auditoria Central

Rastreabilidade sistêmica da ação, usuário e contexto.

As duas estruturas são complementares.

---

# 28. Estoque

Produto Uso/Consumo é naturalmente controlado em estoque.

Não existe regra funcional opcional:

~~~text
controla_estoque
~~~

O cadastro não decide se o item terá ou não controle de estoque.

Essa característica pertence à natureza do domínio.

---

# 29. Localização do estoque

O Produto não define seu local de estoque.

Não existe no cadastro vínculo obrigatório com:

- Matriz;
- Loja;
- depósito fixo;
- estabelecimento específico.

A localização é consequência da operação.

---

# 30. Entrada de estoque

Exemplo:

~~~text
Pedido de Compra
Empresa / Estabelecimento
        ↓
Recebimento
        ↓
Entrada do Produto Uso/Consumo
        ↓
Estoque do local definido pela operação
~~~

O cadastro não deve antecipar essa decisão.

---

# 31. Regra da Matriz cancelada

A antiga ideia de restringir Produto Uso/Consumo à Matriz foi descartada.

Não reintroduzir validações como:

~~~text
Produto Uso/Consumo só pode existir no estoque da Matriz
~~~

A regra oficial é:

**o local é determinado pela operação.**

---

# 32. Estruturas genéricas de estoque

Models existentes podem possuir relacionamento genérico com Loja/Estabelecimento.

Isso não significa que o cadastro de Produto deva exigir esse relacionamento na criação.

Separar:

~~~text
Cadastro do Produto
        ≠
Movimentação de Estoque
~~~

---

# 33. Compras

Produto Uso/Consumo participa de Compras.

Integrações esperadas:

- Pedido de Compra;
- recebimento;
- entrada fiscal;
- atualização de custo;
- entrada de estoque.

O cadastro apenas disponibiliza a entidade para esses processos.

---

# 34. Pedido de Compra

A presença de Produto Uso/Consumo em Compras não implica que deva existir permanentemente um Pedido de Compra exclusivo por tipo.

A arquitetura futura de Compras deve tratar essa decisão em seu próprio escopo.

Não codificar essa separação como obrigação estrutural do Produto.

---

# 35. Entrada Fiscal

Produto Uso/Consumo pode ser recebido através de documento fiscal.

O processo de entrada é responsável por:

- validar dados fiscais necessários;
- identificar Empresa;
- identificar local;
- atualizar estoque;
- atualizar custos;
- registrar movimentação.

Essas responsabilidades não pertencem ao cadastro.

---

# 36. Custos

O Produto pode utilizar a estrutura de custos já existente.

Conceitos existentes incluem:

- custo original;
- última compra;
- custo médio.

Esses valores devem ser alimentados por processos reais.

Não gerar valores fictícios no cadastro.

---

# 37. Movimentações

A consulta pode apresentar movimentações quando existir fonte real.

Se não existir fonte integrada, a interface deve deixar isso claro.

Não criar dados artificiais.

Exemplo aceitável:

~~~text
Nenhuma movimentação registrada.
~~~

---

# 38. PDV

Produto Uso/Consumo não deve ser disponibilizado como item comercializável no PDV.

O backend/frontend devem preservar a separação de tipo.

Não expor `tipo_produto = '2'` no fluxo padrão de venda.

---

# 39. Tabela de Preço

Produto Uso/Consumo não depende de Tabela de Preço comercial para sua existência.

Não deve herdar obrigatoriedade de preço de venda.

---

# 40. Promoção

Produto Uso/Consumo não participa de promoção comercial ao consumidor.

Não criar integração promocional por semelhança com Produto Venda.

---

# 41. Produção

Produto Uso/Consumo não é componente produtivo.

Não deve integrar a Ficha Técnica.

Não deve ser consumido automaticamente pela Ordem de Produção como matéria-prima.

---

# 42. Diferença para Insumo

A principal diferença técnica é:

~~~text
Uso/Consumo
    ↓
uso interno não produtivo

Insumo
    ↓
componente da fabricação
    ↓
Ficha Técnica
    ↓
Ordem de Produção
~~~

O Insumo está documentado separadamente em:

[[Homologação - Produtos - Insumos]]

---

# 43. Consulta consolidada

A consulta do Produto Uso/Consumo reúne informações relevantes em uma visão única.

Blocos previstos:

- Identificação;
- Fiscal;
- Custos;
- Observações;
- Histórico;
- Movimentações.

Não incluir blocos específicos de Produto Venda sem aplicabilidade.

---

# 44. Consulta por ID

Ao abrir a consulta, o frontend deve buscar o registro atual pelo identificador.

Fluxo recomendado já adotado:

~~~text
Linha selecionada
      ↓
Idproduto
      ↓
GET detalhe
      ↓
Consulta atualizada
~~~

Não confiar exclusivamente no objeto da listagem.

---

# 45. Edição por ID

A edição deve seguir a mesma premissa.

Antes de editar, buscar os dados atuais do Produto.

Isso reduz risco de edição sobre snapshot desatualizado.

---

# 46. Listagem

A listagem apresenta informações adequadas ao domínio.

Campos principais:

- Código;
- Descrição;
- Descrição reduzida;
- Unidade;
- NCM;
- Situação Fiscal;
- Status.

Não incluir Grade, Cor ou Tamanho.

---

# 47. Paginação server-side

A listagem utiliza paginação do servidor.

Parâmetros e conceitos esperados:

- `page`;
- `page_size`;
- busca;
- filtros;
- ordenação;
- `count`.

Não carregar milhares de registros para paginação local.

---

# 48. Filtros

Filtros relevantes:

- código;
- descrição;
- unidade;
- NCM;
- status;
- fiscal incompleto.

O backend deve ser autoridade sobre o conjunto retornado.

---

# 49. Indicadores

Indicadores funcionais aprovados:

- Total;
- Ativos;
- Inativos;
- Fiscal Incompleto.

Os indicadores devem respeitar Empresa e filtros globais aplicáveis.

---

# 50. Padrão visual

A interface segue o padrão atual do [[Sysvar]].

Estruturas visuais principais:

- cabeçalho;
- indicadores;
- filtros;
- barra de ações;
- formulário;
- resultados;
- paginação;
- consulta consolidada.

A consistência visual deve ser preservada em evoluções futuras.

---

# 51. Permissões

O acesso às ações deve respeitar os mecanismos de autorização existentes.

Operações relevantes:

- consultar;
- criar;
- editar;
- ativar;
- inativar;
- excluir.

O frontend controla apresentação e disponibilidade.

O backend continua sendo a autoridade de segurança.

---

# 52. Multiempresa — pontos de proteção

A validação multiempresa deve abranger:

- Produto;
- Unidade;
- NCM;
- histórico;
- operações futuras;
- custos;
- estoque;
- movimentações.

Nunca aceitar IDs de objetos pertencentes a outra Empresa apenas porque foram enviados pelo frontend.

---

# 53. Integrações

Integrações principais do domínio:

~~~text
Produto Uso/Consumo
       │
       ├── Unidade
       ├── NCM / Fiscal
       ├── Compras
       ├── Entrada Fiscal
       ├── Estoque
       ├── Custos
       ├── Histórico
       └── Auditoria
~~~

Não integra diretamente:

~~~text
PDV
Ficha Técnica
SKU Cor × Tamanho
Coleção
Promoções comerciais
~~~

---

# 54. Fluxo conceitual de cadastro

~~~text
Usuário
   ↓
Novo Produto Uso/Consumo
   ↓
Backend identifica Empresa
   ↓
Gera código USO-XXXXXX
   ↓
Valida campos obrigatórios
   ↓
Valida Unidade
   ↓
Valida dados opcionais informados
   ↓
Salva Produto
   ↓
Registro disponível para processos operacionais
~~~

---

# 55. Fluxo conceitual de edição

~~~text
Selecionar Produto
   ↓
Buscar por ID
   ↓
Carregar dados atuais
   ↓
Editar
   ↓
Backend valida
   ↓
Salvar
   ↓
Registrar histórico/auditoria quando aplicável
~~~

---

# 56. Fluxo conceitual de inativação

~~~text
Produto ATIVO
   ↓
Usuário solicita Inativar
   ↓
Permissão
   ↓
Backend altera situação
   ↓
Histórico
   ↓
Auditoria
   ↓
Produto INATIVO
~~~

---

# 57. Fluxo conceitual de exclusão

~~~text
Solicitar exclusão
   ↓
Backend verifica dependências
   ↓
Sem uso operacional?
   ├── Sim → excluir
   └── Não → bloquear exclusão e orientar inativação
~~~

---

# 58. Pontos que não pertencem ao cadastro

Não implementar dentro do cadastro:

- transferência de estoque;
- consumo interno;
- recebimento;
- entrada de NF;
- geração financeira;
- baixa de estoque;
- nova fórmula de custo;
- integração com PDV;
- integração com Produção.

Esses processos devem consumir o Produto como entidade já cadastrada.

---

# 59. Regras estruturais que devem permanecer

1. `tipo_produto = '2'`.
2. Código `USO-XXXXXX`.
3. Código automático.
4. Código imutável.
5. Sem Grade.
6. Sem Cor × Tamanho.
7. Sem SKU comercial obrigatório.
8. Sem EAN obrigatório.
9. Sem Coleção.
10. Sem Grupo/Subgrupo obrigatório.
11. Unidade obrigatória.
12. NCM opcional.
13. Fiscal incompleto permitido.
14. Estoque não opcional como conceito.
15. Local de estoque definido pela operação.
16. Active/Inactive.
17. Sem bloqueio de venda.
18. Exclusão protegida.
19. Histórico próprio.
20. Auditoria Central.
21. Paginação server-side.
22. Multiempresa estrito.

---

# 60. Riscos de regressão

Os principais riscos de alterações futuras são:

- misturar novamente Uso/Consumo e Insumo;
- aplicar arquitetura de Produto Venda ao tipo 2;
- exigir Grade;
- exigir Cor;
- exigir SKU comercial;
- exigir EAN;
- fixar estoque na Matriz;
- criar `controla_estoque`;
- permitir exposição no PDV;
- incluir Uso/Consumo em Ficha Técnica;
- quebrar sequência por Empresa;
- quebrar isolamento multiempresa.

Esses riscos são detalhados em:

[[Riscos e Cuidados - Produtos - Produto Uso e Consumo]]

---

# 61. Homologação

O cadastro foi homologado funcionalmente.

Referência oficial:

[[Homologação - Produtos - Produto Uso e Consumo]]

O estado homologado deve ser tratado como baseline para alterações futuras.

---

# 62. Estado final

**Produto Uso/Consumo está IMPLEMENTADO E HOMOLOGADO.**

A estrutura atual deve servir como referência para itens de consumo interno não destinados à venda nem à incorporação direta em produtos fabricados.

---

# 63. Navegação documental

## Produto Uso/Consumo

- [[Homologação - Produtos - Produto Uso e Consumo]]
- [[Workflows - Produtos - Produto Uso e Consumo]]
- [[Modelo de Domínio - Produtos - Produto Uso e Consumo]]
- [[Riscos e Cuidados - Produtos - Produto Uso e Consumo]]

## Produtos relacionados

- [[Mapa Técnico - Produtos - Produto Venda]]
- [[Homologação - Produtos - Insumos]]

## Cadastros auxiliares

- [[Homologação - Produtos - Cadastros Auxiliares]]

## Projeto

- [[Sysvar]]