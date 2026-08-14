## 1. Identificação

**Projeto:** [[Sysvar]]  
**Módulo:** Produtos  
**Cadastro:** Produto Uso/Consumo  
**Tipo interno:** `tipo_produto = '2'`  
**Situação:** HOMOLOGADO  
**Data de consolidação da homologação:** 14/08/2026  
**Resultado:** APROVADO

### Documentos relacionados

- [[Sysvar]]
- [[Mapa Técnico - Produtos - Produto Uso e Consumo]]
- [[Workflows - Produtos - Produto Uso e Consumo]]
- [[Modelo de Domínio - Produtos - Produto Uso e Consumo]]
- [[Riscos e Cuidados - Produtos - Produto Uso e Consumo]]
- [[Homologação - Produtos - Insumos]]
- [[Homologação - Produtos - Cadastros Auxiliares]]
- [[Homologação - Produtos - Produto Venda]]

---

## 2. Objetivo

O cadastro de **Produto Uso/Consumo** do [[Sysvar]] representa os itens adquiridos pela empresa para utilização interna e que:

- não são destinados à revenda;
- não representam Produto Venda;
- não são incorporados diretamente ao produto fabricado;
- não fazem parte da composição produtiva como Insumo de Produção.

Exemplos funcionais:

- material de escritório;
- produtos de limpeza;
- materiais administrativos;
- itens de manutenção;
- itens utilizados internamente pela empresa;
- outros bens de consumo operacional.

Produto Uso/Consumo possui fluxo próprio dentro do módulo Produtos.

Ele não deve ser tratado como Produto Venda nem como Insumo de Produção.

---

## 3. Nomenclatura funcional

A nomenclatura funcional aprovada é:

**Produto Uso/Consumo**

Essa nomenclatura deve ser utilizada:

- no menu;
- no título da tela;
- na documentação funcional;
- nos fluxos relacionados;
- nas referências internas do projeto.

Internamente, o tipo permanece:

~~~text
tipo_produto = '2'
~~~

O código interno não deve ser alterado apenas por causa da nomenclatura visual.

---

## 4. Separação entre os tipos de produto

O módulo Produtos possui categorias funcionalmente distintas.

### 4.1 Produto Venda

Documentado em:

[[Homologação - Produtos - Produto Venda]]

Abrange:

- Revenda;
- Fabricação Própria.

São produtos destinados à comercialização.

### 4.2 Produto Uso/Consumo

Código interno:

~~~text
tipo_produto = '2'
~~~

É utilizado internamente pela empresa.

Não é vendido.

Não participa da estrutura comercial de Cor × Tamanho.

### 4.3 Insumo de Produção

Documentado em:

[[Homologação - Produtos - Insumos]]

Código interno:

~~~text
tipo_produto = '4'
~~~

É utilizado diretamente na fabricação dos Produtos Venda de Fabricação Própria.

Essa separação conceitual foi consolidada e deve ser preservada.

---

## 5. Escopo funcional do cadastro

Produto Uso/Consumo é um cadastro simplificado em relação ao Produto Venda.

O cadastro contempla:

- código automático;
- descrição;
- descrição reduzida;
- unidade;
- NCM opcional;
- informações fiscais;
- situação ativo/inativo;
- observações;
- custos já suportados pela estrutura existente;
- consulta;
- histórico funcional;
- auditoria;
- integração futura ou operacional com Compras e Estoque.

Não contempla características comerciais desnecessárias para esse tipo de produto.

---

## 6. Código do Produto Uso/Consumo

O Produto Uso/Consumo possui código próprio gerado automaticamente.

Formato aprovado:

~~~text
USO-000001
USO-000002
USO-000003
...
~~~

O código:

- é sequencial;
- é gerado por Empresa;
- é automático;
- é único;
- não é informado manualmente pelo usuário;
- é imutável;
- não deve ser reutilizado após exclusão ou inativação de um produto.

A numeração deve preservar a identidade histórica do cadastro.

---

## 7. Multiempresa

Produto Uso/Consumo é estritamente multiempresa.

Cada produto pertence a uma Empresa.

Toda operação deve respeitar a Empresa do usuário autenticado.

Isso se aplica a:

- produto;
- unidade;
- NCM;
- histórico;
- consultas;
- alterações;
- exclusões;
- relacionamentos futuros;
- movimentações operacionais.

Um registro de outra Empresa não pode ser utilizado indevidamente no cadastro atual.

O backend permanece a autoridade sobre o isolamento multiempresa.

---

## 8. Descrição

O campo **Descrição** é obrigatório.

Limite funcional:

~~~text
120 caracteres
~~~

A descrição deve identificar adequadamente o item utilizado pela empresa.

Exemplos:

- Papel A4;
- Detergente neutro;
- Toner para impressora;
- Material de limpeza;
- Lâmpada LED;
- Caixa para arquivo.

---

## 9. Descrição reduzida

O campo **Descrição reduzida** é obrigatório.

Limite funcional:

~~~text
60 caracteres
~~~

A descrição reduzida existe para contextos em que o sistema necessita apresentar o produto de forma compacta.

Não substitui a descrição principal.

---

## 10. Unidade

Todo Produto Uso/Consumo deve possuir uma Unidade válida.

Unidade é obrigatória.

Exemplos:

- UN;
- PC;
- CX;
- KG;
- LT;
- M.

A Unidade deve pertencer à mesma Empresa permitida pelo contexto multiempresa.

O cadastro de Unidades está relacionado à documentação dos cadastros auxiliares:

[[Homologação - Produtos - Cadastros Auxiliares]]

---

## 11. Grade

Produto Uso/Consumo **não utiliza Grade**.

Não deve ser exigido:

- cadastro de Grade;
- seleção de Grade;
- geração de Tamanhos.

Essa característica diferencia o Produto Uso/Consumo do Produto Venda.

---

## 12. Tamanhos

Produto Uso/Consumo não utiliza Tamanho como variação.

Não existe geração de SKU baseada em:

~~~text
Produto × Cor × Tamanho
~~~

O próprio Produto Uso/Consumo é a identidade cadastral utilizada para o item.

---

## 13. Cores

Produto Uso/Consumo não utiliza estrutura comercial de Cores.

Não deve gerar variações por Cor.

Cor não é requisito para seu cadastro.

---

## 14. Coleção

Produto Uso/Consumo não utiliza Coleção.

Não participa:

- de coleção de moda;
- de estação;
- da referência automática `AA-BB-CCDDD` utilizada em Produto Venda.

Seu código utiliza a sequência própria:

~~~text
USO-000001
~~~

---

## 15. Grupo e Subgrupo

Produto Uso/Consumo não exige a estrutura de Grupo e Subgrupo utilizada pelo Produto Venda.

Esses cadastros não fazem parte das informações obrigatórias do fluxo homologado de Uso/Consumo.

Não deve ser criada dependência artificial desses cadastros para Produto Uso/Consumo.

---

## 16. Material

Produto Uso/Consumo não utiliza Material como classificação obrigatória.

Material não integra o conjunto funcional aprovado para esse cadastro.

Essa regra é diferente do cadastro de Insumos, no qual Material permanece disponível de forma opcional.

Ver:

[[Homologação - Produtos - Insumos]]

---

## 17. EAN

Produto Uso/Consumo não exige EAN obrigatório.

Não utiliza a mesma estrutura de geração de EAN dos SKUs de Produto Venda.

Não deve ser criada obrigatoriedade de código de barras apenas para permitir o cadastro.

Caso operações futuras utilizem identificadores adicionais, elas devem respeitar o modelo específico desse tipo de produto e não transformar Uso/Consumo em Produto Venda.

---

## 18. SKU

Produto Uso/Consumo não utiliza SKU comercial baseado em variação.

Não possui:

- Cor × Tamanho;
- geração de ProdutoDetalhe para cada combinação;
- EAN obrigatório por variação;
- Grade comercial.

A identidade cadastral principal permanece o próprio Produto Uso/Consumo e seu código:

~~~text
USO-XXXXXX
~~~

---

## 19. NCM

NCM é opcional no momento do cadastro de Produto Uso/Consumo.

O produto pode ser criado sem NCM.

Quando informado:

- deve ser válido conforme a estrutura existente;
- deve respeitar o contexto da Empresa;
- deve ser persistido normalmente.

A ausência do NCM pode contribuir para a identificação de situação:

**Fiscal Incompleto**

---

## 20. Dados fiscais

Produto Uso/Consumo possui estrutura para informações fiscais.

Os dados fiscais são disponíveis no cadastro, mas não precisam estar integralmente preenchidos para permitir o registro inicial do produto.

A estrutura existente contempla, conforme aplicável:

- NCM;
- origem;
- CST/CSOSN;
- ICMS;
- CFOP;
- PIS;
- COFINS;
- IPI;
- demais campos fiscais já suportados.

O cadastro não deve inventar regras fiscais paralelas.

---

## 21. Fiscal Incompleto

Produto Uso/Consumo pode permanecer cadastrado com informações fiscais incompletas.

Essa condição deve ser sinalizada.

A tela possui conceito de:

**Fiscal Incompleto**

A sinalização não impede o cadastro do produto.

Ela permite identificar itens que ainda precisam de complementação fiscal.

---

## 22. Validação fiscal nas operações

A flexibilidade do cadastro não elimina validações necessárias em operações fiscais reais.

Quando uma operação fiscal exigir determinados campos:

- emissão;
- entrada fiscal;
- documento fiscal;
- outra operação tributária;

o processo operacional correspondente deve validar as informações obrigatórias.

Portanto:

~~~text
Cadastro permite fiscal incompleto
          ↓
Operação fiscal exige dados necessários
          ↓
Validação acontece no processo operacional
~~~

Não se deve bloquear desnecessariamente o cadastro apenas porque uma operação futura poderá exigir informação adicional.

---

## 23. Estoque — conceito aprovado

Todo Produto Uso/Consumo é naturalmente controlável em estoque.

Não existe opção funcional:

~~~text
controla_estoque = Sim/Não
~~~

no cadastro.

Não deve ser criado um campo opcional para decidir se o Produto Uso/Consumo controla estoque.

O comportamento de estoque pertence à natureza operacional do produto.

---

## 24. Cadastro não define local de estoque

O cadastro de Produto Uso/Consumo **não determina onde o estoque ficará**.

Não deve existir no cadastro uma regra obrigatória como:

- somente Matriz;
- somente Loja;
- somente estoque central;
- local fixo definido no Produto.

Essa decisão pertence à operação que movimenta o estoque.

---

## 25. Regra de entrada operacional

O local de estoque é determinado pela operação.

Exemplo:

~~~text
Pedido de Compra
Empresa A
      ↓
Recebimento
      ↓
Produto Uso/Consumo entra no estoque da Empresa A
~~~

Se outra operação movimentar o produto entre estabelecimentos, a localização deverá seguir essa operação.

O cadastro não antecipa nem fixa essa localização.

---

## 26. Regra antiga de estoque na Matriz

Durante a definição funcional chegou a ser considerada a ideia de restringir Produto Uso/Consumo ao estoque da Matriz.

Essa regra foi **cancelada**.

A regra oficial homologada é:

**o cadastro não determina a localização do estoque.**

A localização é consequência das operações de:

- compra;
- recebimento;
- transferência;
- consumo;
- movimentações futuras.

Não reintroduzir a regra de estoque exclusivo na Matriz.

---

## 27. Compras

Produto Uso/Consumo participa do processo de Compras.

É válido utilizá-lo em:

- Pedido de Compra;
- recebimento;
- entrada de documento;
- entrada de estoque.

A arquitetura futura de Compras deverá preservar essa possibilidade.

A existência de Produto Uso/Consumo não significa que deva existir obrigatoriamente um Pedido de Compra separado exclusivamente para esse tipo.

As decisões de unificação do Pedido de Compra pertencem ao escopo específico do módulo Compras.

---

## 28. Entrada de Nota Fiscal

Produto Uso/Consumo pode participar da Entrada de Nota Fiscal.

A entrada deve:

- identificar a Empresa da operação;
- identificar o produto correto;
- aplicar regras fiscais da operação;
- alimentar estoque quando aplicável;
- alimentar custos conforme as estruturas existentes.

Não cabe ao cadastro implementar diretamente o recebimento fiscal.

---

## 29. Custos

Produto Uso/Consumo pode utilizar as informações de custos suportadas pela estrutura existente.

Entre os conceitos existentes podem estar:

- custo original;
- custo da última compra;
- custo médio.

Esses valores devem ser alimentados pelas operações responsáveis quando houver fonte real.

O cadastro não deve inventar uma segunda fórmula de custos.

---

## 30. Movimentações

A consulta consolidada pode apresentar informações de movimentações quando existir fonte real de dados.

Não se deve fabricar histórico operacional inexistente.

Se determinada movimentação ainda não estiver integrada, a interface pode informar claramente que não existem movimentações registradas.

O cadastro não deve criar movimentações artificiais apenas para preencher a consulta.

---

## 31. PDV

Produto Uso/Consumo não participa do PDV como produto de venda.

Não deve aparecer como item comercializável no fluxo normal de venda ao cliente.

Isso inclui:

- venda;
- preço comercial;
- promoção para consumidor;
- disponibilidade para comercialização;
- ações próprias de Produto Venda.

---

## 32. Produção

Produto Uso/Consumo não participa da Ficha Técnica como componente de fabricação.

Também não deve ser utilizado como componente direto da Ordem de Produção.

Essa é uma distinção fundamental em relação a:

[[Homologação - Produtos - Insumos]]

---

## 33. Ficha Técnica

Produto Uso/Consumo não integra a composição técnica de Produto Venda de Fabricação Própria.

Exemplo de item que **não** é Uso/Consumo:

~~~text
Tecido utilizado para fabricar uma camisa
~~~

Esse item é um Insumo de Produção.

Exemplo de Uso/Consumo:

~~~text
Papel utilizado pelo setor administrativo da fábrica
~~~

A separação deve permanecer clara.

---

## 34. Ordem de Produção

Produto Uso/Consumo não é consumido pela Ordem de Produção como componente técnico do produto fabricado.

Qualquer consumo operacional interno futuro deve utilizar processo apropriado e não ser confundido com consumo de Insumos de Produção.

---

## 35. Situação do Produto

Produto Uso/Consumo utiliza lifecycle simplificado:

~~~text
ATIVO
  ↕
INATIVO
~~~

As ações funcionais são:

- Ativar;
- Inativar.

Não possui bloqueio comercial independente de venda.

---

## 36. Bloqueio de venda

Produto Uso/Consumo não possui ação:

**Bloquear Venda**

Isso ocorre porque o item não é destinado ao fluxo comercial do PDV.

Não criar:

- bloquear venda;
- desbloquear venda;

para esse tipo de produto.

---

## 37. Exclusão protegida

A exclusão física é permitida somente quando o Produto Uso/Consumo nunca tiver sido operacionalmente utilizado e não possuir dependências que exijam preservação.

Quando já houver uso operacional, o procedimento correto é:

**Inativar**

e não apagar o histórico.

A proteção deve considerar relacionamentos reais do sistema.

---

## 38. Histórico funcional

Produto Uso/Consumo possui histórico próprio.

O histórico não deve ser misturado ao histórico específico de Produto Venda.

Alterações relevantes devem permitir rastreabilidade.

Entre as alterações passíveis de registro estão:

- descrição;
- descrição reduzida;
- unidade;
- dados fiscais;
- observações;
- situação;
- demais campos relevantes suportados.

A apresentação deve permitir compreender:

~~~text
valor anterior → valor novo
~~~

---

## 39. Auditoria Central

Além do histórico funcional do cadastro, operações relevantes continuam integradas à Auditoria Central do [[Sysvar]].

O histórico funcional e a Auditoria Central possuem objetivos complementares.

### Histórico funcional

Ajuda o usuário a compreender a evolução do próprio Produto Uso/Consumo.

### Auditoria Central

Permite rastreabilidade sistêmica das operações executadas.

Não substituir um pelo outro.

---

## 40. Consulta consolidada

Produto Uso/Consumo possui consulta consolidada própria.

A consulta deve reunir, conforme dados existentes:

- identificação;
- classificação;
- situação fiscal;
- custos;
- observações;
- histórico;
- movimentações disponíveis.

A consulta deve refletir a estrutura própria de Uso/Consumo.

Não deve exibir seções de Produto Venda sem aplicabilidade.

---

## 41. Dados sempre atuais na consulta

Ao consultar um registro, a aplicação deve utilizar o identificador do produto e buscar os dados atuais no backend.

Não deve depender exclusivamente de uma cópia antiga da linha da listagem.

Isso reduz risco de apresentar informação desatualizada após alterações.

---

## 42. Edição com dados atuais

Da mesma forma, a edição deve buscar os dados atuais do Produto Uso/Consumo pelo identificador.

A tela não deve iniciar uma edição crítica baseada apenas no snapshot da listagem.

---

## 43. Listagem

A listagem de Produto Uso/Consumo segue o padrão visual do [[Sysvar]].

Entre as informações relevantes estão:

- Código;
- Descrição;
- Descrição reduzida;
- Unidade;
- NCM;
- Situação Fiscal;
- Status.

A listagem deve permanecer adequada ao tipo de produto.

Não adicionar colunas de Grade, Cor ou Tamanho sem fundamento funcional.

---

## 44. Paginação

A listagem utiliza paginação server-side.

Não deve carregar arbitrariamente milhares de registros para posteriormente paginar apenas no navegador.

A API permanece responsável por:

- página;
- quantidade por página;
- total de registros;
- filtros;
- ordenação aplicável.

---

## 45. Filtros

Os filtros funcionais contemplam informações relevantes ao cadastro, como:

- código;
- descrição;
- unidade;
- NCM;
- status;
- fiscal incompleto.

Os filtros devem ser executados de forma compatível com paginação server-side.

---

## 46. Indicadores

A tela possui indicadores relacionados ao cadastro.

Indicadores aprovados:

- Total;
- Ativos;
- Inativos;
- Fiscal Incompleto.

Os indicadores devem representar dados coerentes com o contexto da Empresa.

---

## 47. Padrão visual

Produto Uso/Consumo segue o padrão geral das telas atuais do [[Sysvar]].

A estrutura visual contempla:

- cabeçalho;
- indicadores;
- filtros;
- ações;
- resultados;
- paginação;
- formulário;
- consulta.

O padrão deve permanecer consistente com os demais cadastros modernos.

---

## 48. Permissões

As operações devem respeitar as permissões definidas no sistema.

Isso inclui:

- consultar;
- incluir;
- editar;
- inativar;
- ativar;
- excluir quando permitido.

O frontend deve refletir as permissões, mas o backend permanece autoridade de segurança.

---

## 49. Diferença entre Uso/Consumo e Produto Venda

| Característica | Produto Uso/Consumo | Produto Venda |
|---|---|---|
| Venda no PDV | Não | Sim |
| Grade | Não | Sim |
| Cor × Tamanho | Não | Sim |
| SKU comercial | Não | Sim |
| EAN obrigatório por SKU | Não | Sim |
| Coleção | Não | Sim |
| Grupo/Subgrupo obrigatório | Não | Sim |
| Bloqueio de venda | Não | Sim |
| Estoque | Sim, operacional | Sim, por estrutura comercial |
| Fiscal | Disponível | Disponível |
| Compras | Sim | Sim |
| Produção/Ficha Técnica | Não | Fabricação Própria pode participar |

---

## 50. Diferença entre Uso/Consumo e Insumo

| Característica | Produto Uso/Consumo | Insumo |
|---|---|---|
| Uso interno | Sim | Sim, produtivo |
| Incorporado ao produto fabricado | Não | Sim |
| Ficha Técnica | Não | Sim |
| Ordem de Produção | Não | Indiretamente pela Ficha Técnica |
| Código | `USO-...` | `INS-...` |
| Material | Não integra o escopo aprovado | Opcional |
| Venda no PDV | Não | Não |
| Grade comercial | Não | Não |
| Cor × Tamanho | Não | Não |

A distinção entre os dois cadastros deve ser preservada.

---

## 51. Integrações aprovadas

Produto Uso/Consumo se relaciona conceitualmente com:

- [[Sysvar]];
- Compras;
- Entrada de Nota Fiscal;
- Estoque;
- Custos;
- Fiscal;
- Auditoria;
- Unidades;
- NCM.

Não participa diretamente de:

- PDV;
- Produto Venda;
- Ficha Técnica;
- Ordem de Produção como componente produtivo.

---

## 52. O que não foi implementado neste escopo

A homologação do cadastro não representa implementação de todos os processos operacionais futuros.

Não foram criados neste escopo:

- novo processo de transferência;
- processo específico de consumo interno;
- nova lógica de recebimento;
- nova lógica de Entrada Fiscal;
- nova fórmula de custo;
- nova estrutura de estoque;
- novo Pedido de Compra;
- integração de PDV;
- integração de Produção.

Essas funcionalidades pertencem aos módulos operacionais correspondentes.

---

## 53. Regras que não devem ser reintroduzidas

Desenvolvimentos futuros não devem reintroduzir:

1. estoque obrigatório apenas na Matriz;
2. campo opcional `controla_estoque`;
3. Grade para Uso/Consumo;
4. Cor × Tamanho;
5. EAN obrigatório como requisito cadastral;
6. participação em PDV;
7. participação em Ficha Técnica;
8. Bloquear/Desbloquear Venda;
9. dependência artificial de Coleção;
10. dependência artificial de Grupo/Subgrupo.

---

## 54. Resultado da homologação

O cadastro de Produto Uso/Consumo foi homologado funcionalmente.

Foram validados os conceitos centrais de:

- identidade própria;
- código automático;
- cadastro simplificado;
- separação de Produto Venda;
- separação de Insumos;
- informações fiscais;
- fiscal incompleto;
- lifecycle;
- exclusão protegida;
- histórico;
- auditoria;
- paginação;
- filtros;
- indicadores;
- multiempresa;
- conceito correto de estoque;
- integração conceitual com Compras e recebimento.

---

## 55. Estado final

**Produto Uso/Consumo está HOMOLOGADO.**

O cadastro deve ser tratado como referência funcional para itens de consumo interno da empresa que não sejam comercializados e não componham diretamente a fabricação.

As implementações futuras de Compras, Estoque, Fiscal e movimentações devem consumir essa estrutura sem descaracterizar seu domínio.

---

## 56. Navegação documental

### Produto Uso/Consumo

- [[Mapa Técnico - Produtos - Produto Uso e Consumo]]
- [[Workflows - Produtos - Produto Uso e Consumo]]
- [[Modelo de Domínio - Produtos - Produto Uso e Consumo]]
- [[Riscos e Cuidados - Produtos - Produto Uso e Consumo]]

### Outros tipos de Produto

- [[Homologação - Produtos - Produto Venda]]
- [[Homologação - Produtos - Insumos]]

### Cadastros de apoio

- [[Homologação - Produtos - Cadastros Auxiliares]]

### Projeto

- [[Sysvar]]