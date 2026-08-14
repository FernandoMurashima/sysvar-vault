## 1. Identificação

**Projeto:** [[Sysvar]]  
**Módulo:** Produtos  
**Cadastro:** Insumos  
**Tipo interno:** `tipo_produto = '4'`  
**Situação:** HOMOLOGADO  
**Decisões funcionais aprovadas:** 34  
**Data de consolidação documental:** 14/08/2026

### Documentos relacionados

- [[Sysvar]]
- [[Mapa Técnico - Produtos - Insumos]]
- [[Workflows - Produtos - Insumos]]
- [[Modelo de Domínio - Produtos - Insumos]]
- [[Riscos e Cuidados - Produtos - Insumos]]
- [[Homologação - Produtos - Produto Venda]]
- [[Homologação - Produtos - Produto Uso e Consumo]]
- [[Homologação - Produtos - Cadastros Auxiliares]]

---

## 2. Objetivo

O cadastro de **Insumos** do [[Sysvar]] representa os materiais utilizados diretamente na fabricação dos produtos de **Fabricação Própria**.

Insumos são componentes produtivos.

Exemplos:

- tecidos;
- linhas;
- botões;
- zíperes;
- etiquetas;
- elásticos;
- aviamentos;
- outros materiais incorporados ou consumidos diretamente na fabricação.

O cadastro de Insumos possui domínio próprio.

Não deve ser confundido com:

- Produto Venda;
- Produto Uso/Consumo.

---

## 3. Nomenclatura funcional

A nomenclatura funcional aprovada da tela é:

**Insumos**

Essa nomenclatura deve ser utilizada:

- no menu;
- no título da tela;
- na documentação;
- nos fluxos funcionais;
- nas referências futuras do projeto.

Internamente o tipo permanece:

~~~text
tipo_produto = '4'
~~~

---

## 4. Separação entre tipos de Produto

A estrutura atual de Produtos diferencia os principais domínios.

### 4.1 Produto Venda

Contempla:

~~~text
tipo_produto = '1' → Revenda
tipo_produto = '3' → Fabricação Própria
~~~

Destinado à comercialização.

Documentação:

[[Homologação - Produtos - Produto Venda]]

### 4.2 Produto Uso/Consumo

~~~text
tipo_produto = '2'
~~~

Destinado ao uso interno não produtivo.

Documentação:

[[Homologação - Produtos - Produto Uso e Consumo]]

### 4.3 Insumo

~~~text
tipo_produto = '4'
~~~

Destinado à composição produtiva.

Essa separação deve ser preservada.

---

## 5. Conceito de Insumo

Insumo representa um material que pode participar da fabricação de um Produto Venda de Fabricação Própria.

Conceitualmente:

~~~text
Insumo
   ↓
Ficha Técnica
   ↓
Produto Venda
Fabricação Própria
~~~

O cadastro define **o que é o material**.

A Ficha Técnica define **quanto desse material é necessário para fabricar determinado produto**.

A Ordem de Produção utiliza posteriormente a estrutura produtiva definida pela Ficha Técnica.

---

## 6. Insumo não é Produto Venda

Insumo não é mercadoria destinada à venda normal no PDV.

Não deve herdar automaticamente características comerciais como:

- Grade comercial;
- Cor × Tamanho para venda;
- tabela de preço de venda;
- promoção;
- bloqueio de venda;
- estrutura comercial de SKU de Produto Venda.

Produto Venda está documentado separadamente em:

[[Homologação - Produtos - Produto Venda]]

---

## 7. Insumo não é Uso/Consumo

A diferença fundamental é a finalidade.

### Uso/Consumo

Exemplo:

~~~text
Papel utilizado no escritório
~~~

Não participa diretamente da fabricação.

### Insumo

Exemplo:

~~~text
Tecido utilizado para fabricar uma camisa
~~~

Participa diretamente da produção.

Portanto:

~~~text
Uso interno administrativo/operacional
→ Produto Uso/Consumo

Componente direto de fabricação
→ Insumo
~~~

---

## 8. Tipo interno

Todo Insumo desta funcionalidade deve ser identificado internamente por:

~~~text
tipo_produto = '4'
~~~

A tela de Insumos deve trabalhar exclusivamente com esse tipo.

Não deve misturar:

- tipo 1;
- tipo 2;
- tipo 3.

---

## 9. Multiempresa

Insumos obedecem ao isolamento multiempresa do [[Sysvar]].

Todo Insumo pertence ao contexto de uma Empresa.

O backend deve proteger:

- criação;
- consulta;
- edição;
- ativação;
- inativação;
- exclusão;
- relacionamentos auxiliares;
- utilização em processos produtivos.

Um usuário de uma Empresa não pode manipular Insumos pertencentes a outra Empresa.

---

## 10. Descrição

O Insumo possui descrição que identifica o material.

A descrição deve permitir reconhecimento claro do item utilizado na produção.

Exemplos:

- Tecido Jeans Azul;
- Linha Poliéster;
- Botão Plástico;
- Zíper Metálico;
- Etiqueta de Composição.

---

## 11. Descrição reduzida

Quando suportada pela estrutura vigente de Produto, a descrição reduzida pode ser utilizada para apresentação compacta.

Ela não substitui a descrição principal.

---

## 12. Unidade

Todo Insumo deve possuir Unidade adequada à forma como é controlado.

Exemplos:

- UN;
- M;
- MT;
- KG;
- G;
- LT;
- PC;
- CX.

A Unidade é especialmente importante para Insumos porque participa das quantidades utilizadas na Ficha Técnica.

Exemplo:

~~~text
Tecido
Unidade: metro

Linha
Unidade: metro

Botão
Unidade: unidade
~~~

---

## 13. Unidade e quantidade produtiva

A Unidade do Insumo deve ser coerente com a quantidade informada posteriormente na Ficha Técnica.

Exemplo:

~~~text
Insumo: Tecido
Unidade: M

Ficha Técnica:
1,80 M por peça
~~~

A quantidade produtiva pertence à Ficha Técnica.

Não deve ser cadastrada como consumo fixo diretamente no Insumo.

---

## 14. Permissão de quantidade decimal

Quando a Unidade permitir quantidade decimal, os processos que utilizarem o Insumo devem respeitar essa característica.

Exemplo:

~~~text
Tecido = 1,75 M
Linha = 12,50 M
~~~

Para unidades que não permitem decimal:

~~~text
Botão = 6 UN
~~~

A estrutura de Unidades está relacionada a:

[[Homologação - Produtos - Cadastros Auxiliares]]

---

## 15. Material

O campo **Material** é opcional para Insumos.

Essa decisão foi homologada.

Material pode servir como classificação adicional do Insumo.

Exemplo:

~~~text
Insumo: Tecido Oxford Branco
Material: Poliéster
~~~

Entretanto, a ausência de Material não deve impedir o cadastro.

---

## 16. Material não substitui o Insumo

Material e Insumo são conceitos distintos.

~~~text
Material
→ classificação

Insumo
→ item operacional utilizado na produção
~~~

Exemplo:

~~~text
Material:
Algodão

Insumos:
Tecido Tricoline Branco
Tecido Tricoline Azul
Tecido Sarja Cru
~~~

Não transformar Material na entidade movimentada em estoque.

---

## 17. Grade

Insumos não utilizam Grade comercial como Produto Venda.

Não existe obrigatoriedade de:

- Grade;
- PP/P/M/G/GG;
- numeração de roupas;
- combinação comercial de tamanhos.

---

## 18. Cor

Cor de um Insumo pode ser uma característica descritiva do próprio material quando necessário.

Entretanto, o cadastro homologado não deve ser transformado automaticamente na estrutura:

~~~text
Produto × Cor × Tamanho
~~~

utilizada pelo Produto Venda.

Caso diferentes cores sejam controladas como materiais distintos, cada Insumo deve possuir identidade cadastral apropriada conforme o modelo vigente.

---

## 19. SKU comercial

Insumos não utilizam o modelo de SKU comercial de Produto Venda.

Não existe obrigatoriedade de geração automática de variações por:

~~~text
Cor × Tamanho
~~~

O Insumo é a entidade operacional utilizada nos processos produtivos.

---

## 20. Coleção

Insumos não dependem de Coleção para existir.

Coleção pertence principalmente à organização dos Produtos Venda de moda.

Não deve ser criada obrigatoriedade de:

- Coleção;
- Estação;
- referência comercial baseada em Coleção.

---

## 21. Grupo e Subgrupo

Não devem ser aplicadas automaticamente ao Insumo obrigações classificatórias exclusivas do Produto Venda.

Qualquer classificação adicional deve seguir o modelo efetivamente aprovado para Insumos.

Não criar dependência artificial apenas porque Grupo/Subgrupo existem no módulo Produtos.

---

## 22. NCM

Insumos podem possuir NCM quando aplicável.

Exemplos de materiais que podem exigir classificação fiscal:

- tecidos;
- linhas;
- botões;
- zíperes;
- etiquetas;
- aviamentos.

A estrutura fiscal deve utilizar os cadastros e regras fiscais existentes no [[Sysvar]].

---

## 23. Dados fiscais

O Insumo pode possuir informações fiscais necessárias aos processos de aquisição e entrada fiscal.

Essas informações podem incluir, conforme a estrutura vigente:

- NCM;
- origem;
- CST/CSOSN;
- ICMS;
- CFOP;
- PIS;
- COFINS;
- IPI.

A existência de dados fiscais no Produto não transfere para o cadastro a responsabilidade da Entrada Fiscal.

---

## 24. Compras

Insumos podem ser adquiridos por meio do processo de Compras.

Fluxo conceitual:

~~~text
Insumo
   ↓
Pedido de Compra
   ↓
Fornecedor
   ↓
Recebimento
   ↓
Entrada Fiscal
   ↓
Estoque
~~~

O módulo Compras deve utilizar o cadastro de Insumos como origem da identidade do material.

---

## 25. Pedido de Compra

O cadastro de Insumos não deve implementar regras de Pedido de Compra.

O Insumo apenas fica disponível para ser utilizado pelo processo de Compras.

As decisões sobre Pedido de Compra pertencem ao módulo específico de Compras.

---

## 26. Recebimento

O recebimento de Insumos deve ocorrer através do processo operacional correspondente.

O cadastro não deve gerar saldo automaticamente.

Fluxo correto:

~~~text
Insumo cadastrado
        ↓
Compra
        ↓
Recebimento
        ↓
Movimento de entrada
        ↓
Estoque
~~~

---

## 27. Estoque

Todo Insumo possui natureza de controle de estoque.

Não deve existir necessidade de marcar no cadastro:

~~~text
Controla estoque?
Sim / Não
~~~

O Insumo representa material físico utilizado na operação produtiva.

---

## 28. Cadastro não define localização do estoque

O cadastro do Insumo não determina onde o material ficará armazenado.

Não deve fixar obrigatoriamente:

- Matriz;
- fábrica;
- Loja;
- almoxarifado específico;
- depósito específico.

A localização é definida pela operação de estoque.

---

## 29. Estoque por operação

Conceitualmente:

~~~text
Insumo
   ↓
Recebimento / Transferência / Movimento
   ↓
Local operacional
   ↓
Saldo
~~~

O cadastro define **qual material é**.

A operação define **onde está**.

---

## 30. Saldo

O cadastro do Insumo não cria saldo.

Saldo deve resultar de movimentos reais.

~~~text
Entradas
-
Saídas
=
Saldo
~~~

Essa separação deve ser preservada.

---

## 31. Movimentações

Movimentações de Insumos pertencem ao módulo de Estoque e aos processos operacionais.

Podem incluir futuramente ou conforme estruturas existentes:

- entrada por compra;
- transferência;
- ajuste;
- inventário;
- consumo produtivo;
- devolução;
- retorno de produção.

O cadastro não deve fabricar movimentos fictícios.

---

## 32. Ficha Técnica

Insumos participam da **Ficha Técnica**.

Essa é uma das principais diferenças entre Insumo e Produto Uso/Consumo.

A Ficha Técnica relaciona:

~~~text
Produto de Fabricação Própria
        ↓
Insumos necessários
        ↓
Quantidade de cada Insumo
~~~

Exemplo:

~~~text
Produto:
Camisa Social

Ficha Técnica:

Tecido Oxford        1,80 M
Linha                 12,00 M
Botão                  8 UN
Etiqueta Marca         1 UN
Etiqueta Composição    1 UN
~~~

---

## 33. Quantidade da Ficha Técnica

A quantidade utilizada para fabricar uma unidade do Produto não pertence ao cadastro principal do Insumo.

Ela pertence ao relacionamento:

~~~text
Ficha Técnica × Insumo
~~~

Isso permite que o mesmo Insumo seja utilizado em vários Produtos com quantidades diferentes.

Exemplo:

~~~text
Tecido A

Camisa:
1,80 M

Vestido:
2,40 M

Saia:
1,25 M
~~~

---

## 34. Mesmo Insumo em várias Fichas Técnicas

Um mesmo Insumo pode participar de várias Fichas Técnicas.

Relacionamento conceitual:

~~~text
Insumo
   ├── Ficha Técnica A
   ├── Ficha Técnica B
   └── Ficha Técnica C
~~~

Não deve haver necessidade de duplicar o cadastro do Insumo para cada Produto fabricado.

---

## 35. Ordem de Produção

A Ordem de Produção utiliza a estrutura definida pela Ficha Técnica.

Conceitualmente:

~~~text
Ordem de Produção
        ↓
Produto a fabricar
        ↓
Ficha Técnica
        ↓
Insumos necessários
~~~

Entretanto, a homologação atual de Insumos **não implementa nem redefine o consumo físico de estoque pela Ordem de Produção**.

Essa separação é importante.

---

## 36. Consumo de estoque pela Ordem de Produção

Nesta fase, o cadastro de Insumos foi preparado para participação na Ficha Técnica.

Não foi definido neste escopo um novo mecanismo completo de:

- reserva de Insumos pela OP;
- baixa automática;
- baixa no envio à facção;
- baixa no início da produção;
- retorno de sobra;
- perdas;
- consumo real versus previsto.

Essas regras pertencem ao futuro detalhamento operacional da Produção.

---

## 37. Regra de proteção sobre a OP

Não deve ser inferido que:

~~~text
Criar Ordem de Produção
=
baixar automaticamente todos os Insumos
~~~

apenas porque o Insumo participa da Ficha Técnica.

O momento e a regra de consumo de estoque precisam ser definidos no módulo Produção.

---

## 38. Ficha Técnica versus estoque

Ficha Técnica representa necessidade teórica.

Estoque representa quantidade física.

Portanto:

~~~text
Ficha Técnica
→ Quanto deveria ser utilizado

Estoque
→ Quanto existe fisicamente

Movimento produtivo
→ Quanto foi efetivamente consumido
~~~

São conceitos diferentes.

---

## 39. Custos

Insumos possuem impacto direto no custo do Produto de Fabricação Própria.

Conceitualmente:

~~~text
Quantidade do Insumo
×
Custo do Insumo
=
Custo do componente
~~~

A soma dos componentes pode participar da composição do custo de produção.

A fórmula definitiva pertence à estrutura de custos e Produção.

---

## 40. Custo do Insumo

O Insumo pode possuir informações de custo provenientes de eventos reais, como:

- compra;
- recebimento;
- atualização de custo médio.

Não inventar custo diretamente apenas para preencher o cadastro.

---

## 41. Custo na Ficha Técnica

A Ficha Técnica pode utilizar:

~~~text
quantidade necessária
×
custo aplicável do Insumo
~~~

para projeções de custo.

Entretanto, o cadastro do Insumo não deve congelar automaticamente uma quantidade produtiva.

Quantidade é propriedade da relação com a Ficha Técnica.

---

## 42. Ativo e Inativo

O lifecycle de Insumos é simples:

~~~text
ATIVO
  ↕
INATIVO
~~~

Um Insumo pode ser:

- ativado;
- inativado.

Não existe necessidade de bloqueio comercial de venda.

---

## 43. Insumo Ativo

Insumo Ativo pode ser disponibilizado para novas operações compatíveis, como:

- Compras;
- Ficha Técnica;
- entradas;
- movimentações.

As regras específicas de cada módulo devem respeitar a situação do cadastro.

---

## 44. Insumo Inativo

Insumo Inativo permanece no banco para preservação de histórico.

Inativar não deve eliminar:

- compras anteriores;
- recebimentos;
- movimentos;
- Fichas Técnicas históricas;
- custos;
- auditoria.

---

## 45. Exclusão protegida

Insumo utilizado não deve ser excluído de forma destrutiva.

Antes da exclusão, o backend deve verificar dependências.

Exemplos:

- Ficha Técnica;
- Pedido de Compra;
- recebimento;
- estoque;
- movimentos;
- documentos fiscais;
- outras referências persistidas.

Havendo dependência, utilizar:

**Inativar**

---

## 46. Insumo ainda não utilizado

A exclusão física pode ser admitida quando o registro nunca tiver sido operacionalmente utilizado e nenhuma dependência impedir a remoção.

Essa decisão deve ser validada pelo backend.

---

## 47. Histórico

Não foi aprovada nesta fase uma estrutura sofisticada de histórico individual semelhante a módulos mais complexos.

O cadastro deve manter a rastreabilidade necessária através das estruturas de auditoria existentes, sem ampliar o escopo desnecessariamente.

---

## 48. Auditoria

Operações relevantes devem respeitar a estrutura geral de Auditoria do [[Sysvar]].

Ações como:

- criação;
- edição;
- ativação;
- inativação;
- exclusão quando permitida;

devem permanecer rastreáveis conforme a arquitetura vigente.

---

## 49. Consulta

A consulta de Insumo deve apresentar informações pertinentes ao domínio.

Entre elas:

- identificação;
- descrição;
- Unidade;
- Material quando informado;
- situação;
- dados fiscais;
- custos disponíveis;
- demais informações existentes.

Não deve apresentar blocos de Produto Venda sem aplicabilidade.

---

## 50. Edição

A edição deve preservar:

- identidade;
- Empresa;
- tipo do Produto.

Não deve permitir converter Insumo em outro tipo.

~~~text
tipo_produto = '4'
~~~

deve permanecer estável.

---

## 51. Listagem

A listagem de Insumos deve apresentar informações relevantes para localização e gerenciamento dos materiais.

Não deve ser sobrecarregada com campos específicos de Produto Venda.

A tela deve permanecer simples e operacional.

---

## 52. Filtros

Filtros devem permitir localizar Insumos utilizando informações pertinentes ao cadastro.

A implementação deve respeitar:

- Empresa;
- tipo 4;
- paginação;
- filtros server-side quando aplicável.

---

## 53. Paginação

A listagem deve utilizar o padrão de paginação adotado no módulo.

Bases com grande volume de Insumos não devem ser carregadas integralmente no navegador.

---

## 54. Padrão visual

A tela de Insumos segue o padrão visual vigente dos cadastros do [[Sysvar]].

Ações devem permanecer coerentes com os cadastros modernos do sistema.

---

## 55. Permissões

As operações devem respeitar as permissões existentes.

Entre elas:

- consultar;
- criar;
- editar;
- ativar;
- inativar;
- excluir quando permitido.

O frontend auxilia a experiência do usuário.

O backend permanece autoridade de segurança.

---

## 56. Relação com Produto Venda de Fabricação Própria

A principal integração produtiva é:

~~~text
Insumo
   ↓
Ficha Técnica
   ↓
Produto Venda
tipo_produto = '3'
Fabricação Própria
~~~

Produto Venda está documentado em:

[[Homologação - Produtos - Produto Venda]]

---

## 57. Relação com Revenda

Produto de Revenda:

~~~text
tipo_produto = '1'
~~~

não é produzido internamente.

Portanto, normalmente não depende de Ficha Técnica de Insumos para seu abastecimento.

Seu fluxo principal é:

~~~text
Fornecedor
   ↓
Compra
   ↓
Recebimento
   ↓
Produto Venda
~~~

---

## 58. Relação com Uso/Consumo

Produto Uso/Consumo pode também ser comprado e controlado em estoque.

A diferença está na finalidade:

~~~text
Uso/Consumo
→ consumo interno não produtivo

Insumo
→ consumo produtivo
~~~

Ambos devem permanecer separados funcionalmente.

---

## 59. Relação com Estoque

Insumos utilizam a infraestrutura operacional de Estoque.

O cadastro não deve criar uma segunda arquitetura de Estoque apenas para Produção.

Evoluções futuras devem preferir integração com o módulo oficial.

---

## 60. Relação com Distribuição

Distribuição de Produto acabado entre fábrica e Lojas não é o mesmo processo que movimentação de Insumos.

O módulo Distribuição de Produtos Venda não deve ser confundido com abastecimento interno de matéria-prima.

---

## 61. Relação com Facção

Na Produção por facção, Insumos poderão futuramente participar de fluxos como:

- envio de materiais à facção;
- controle de materiais em poder da facção;
- retorno de sobras;
- perdas;
- consumo efetivo.

Esses processos não foram implementados dentro do cadastro de Insumos.

Devem ser definidos no módulo Produção.

---

## 62. Insumo em poder de terceiro

Caso futuramente haja estoque em poder de facção, a solução deve tratar isso como localização/movimentação operacional.

Não se deve alterar o cadastro do Insumo para indicar permanentemente:

~~~text
Está na Facção X
~~~

Localização não é identidade cadastral.

---

## 63. Unidade e conversão

Caso futuramente seja necessário comprar um Insumo em uma Unidade e consumir em outra, isso exigirá regra explícita de conversão.

Exemplo:

~~~text
Compra:
1 rolo

Produção:
consumo em metros
~~~

Essa conversão não foi definida no escopo atual.

Não presumir fatores de conversão sem regra formal.

---

## 64. Perdas de produção

Perda de material não é propriedade do cadastro do Insumo.

Uma futura regra de perda deve pertencer:

- à Ficha Técnica;
- à Produção;
- ou ao movimento correspondente,

conforme decisão funcional futura.

---

## 65. Reserva de Insumos

A existência de uma OP pode futuramente gerar reserva de Insumos.

Essa regra não foi definida nesta homologação.

Não implementar automaticamente:

~~~text
OP criada
→ reserva imediata
~~~

sem definição do processo de Produção.

---

## 66. Baixa de Insumos

Também não foi definido o momento oficial da baixa.

Possibilidades futuras podem envolver:

- separação do material;
- envio à facção;
- início da produção;
- apontamento;
- conclusão;
- consumo real.

A decisão pertence ao módulo Produção.

---

## 67. Consumo previsto versus consumo real

Esses conceitos devem permanecer separados.

~~~text
Ficha Técnica
→ consumo previsto

Produção
→ consumo efetivo
~~~

A diferença poderá futuramente alimentar:

- perdas;
- eficiência;
- custo real;
- desvios.

Não resolver essa diferença dentro do cadastro de Insumos.

---

## 68. Compras versus Produção

O Insumo conecta dois grandes processos:

~~~text
COMPRAS
Fornecedor
   ↓
Insumo
   ↓
Estoque

PRODUÇÃO
Estoque
   ↓
Insumo
   ↓
Ficha Técnica / Processo Produtivo
   ↓
Produto Fabricado
~~~

O cadastro é a entidade comum entre esses processos.

---

## 69. Princípio de responsabilidade

O cadastro de Insumos deve responder:

~~~text
O que é este material?
~~~

Não deve responder sozinho:

~~~text
Quanto devo comprar?
Onde está?
Quanto foi consumido?
Quanto está reservado?
Quanto foi perdido?
Para qual OP foi enviado?
~~~

Essas respostas pertencem aos módulos operacionais.

---

## 70. Regras que não devem ser introduzidas

Não introduzir sem nova decisão funcional:

1. Grade comercial;
2. Cor × Tamanho comercial;
3. SKU comercial obrigatório;
4. Coleção obrigatória;
5. preço de venda obrigatório;
6. promoção;
7. disponibilidade no PDV;
8. Bloquear Venda;
9. localização fixa de estoque;
10. `controla_estoque`;
11. baixa automática ao criar OP;
12. reserva automática ao criar OP;
13. conversão de Unidade não definida;
14. perda padrão não definida.

---

## 71. Diferença consolidada entre os tipos

| Característica | Produto Venda | Uso/Consumo | Insumo |
|---|---:|---:|---:|
| Venda no PDV | Sim | Não | Não |
| Fabricação | Produto final quando tipo 3 | Não | Componente |
| Ficha Técnica | Produto fabricado possui | Não participa | Participa |
| Grade comercial | Sim | Não | Não |
| Cor × Tamanho comercial | Sim | Não | Não |
| Tabela de Preço | Sim | Não obrigatória | Não |
| Promoção | Sim | Não | Não |
| Estoque | Sim | Sim | Sim |
| Local definido no cadastro | Não | Não | Não |
| Compras | Sim | Sim | Sim |
| Material | Opcional | Não integra escopo | Opcional |
| Ativo/Inativo | Sim | Sim | Sim |
| Bloqueio de Venda | Produto Venda | Não | Não |

---

## 72. Fluxo conceitual completo

~~~text
CADASTRO DO INSUMO
        ↓
tipo_produto = '4'
        ↓
Disponível para operação
        ↓
┌──────────────────────┬──────────────────────┐
│                      │                      │
Compras               Estoque               Produção
│                      │                      │
Fornecedor             Entradas              Ficha Técnica
│                      │                      │
Pedido                 Saldos                 Produto Fabricação Própria
│                      │                      │
Recebimento            Movimentos             Ordem de Produção
│                                             │
Custos                                        Consumo futuro
                                              conforme regra própria
~~~

---

## 73. Escopo não implementado nesta homologação

Não foram definidos neste cadastro:

- reserva de Insumos pela OP;
- baixa automática;
- controle de material em facção;
- retorno de sobras;
- perdas;
- consumo previsto versus real;
- conversão avançada de Unidades;
- inventário específico de Produção;
- planejamento de necessidade de materiais;
- MRP.

Esses assuntos pertencem às próximas etapas dos módulos de Produção e Estoque.

---

## 74. Baseline homologada

O cadastro de Insumos foi implementado e validado.

As decisões principais consolidadas incluem:

- tela própria de Insumos;
- `tipo_produto = '4'`;
- domínio separado de Uso/Consumo;
- domínio separado de Produto Venda;
- Material opcional;
- Unidade adequada ao controle;
- natureza de Estoque;
- ausência de localização fixa no cadastro;
- integração conceitual com Compras;
- participação na Ficha Técnica;
- preparação para Produção;
- ausência de baixa automática de estoque pela OP nesta fase;
- lifecycle Ativo/Inativo;
- exclusão protegida;
- multiempresa;
- padrão visual do SYSVAR.

---

## 75. Estado final

**Insumos está HOMOLOGADO.**

O cadastro deve ser tratado como a origem cadastral dos materiais utilizados na fabricação.

A regra central é:

~~~text
Insumo define O QUE é o material.

Ficha Técnica define QUANTO é necessário.

Estoque define ONDE está e QUANTO existe.

Produção definirá QUANTO foi efetivamente consumido.
~~~

---

## 76. Navegação documental

### Insumos

- [[Mapa Técnico - Produtos - Insumos]]
- [[Workflows - Produtos - Insumos]]
- [[Modelo de Domínio - Produtos - Insumos]]
- [[Riscos e Cuidados - Produtos - Insumos]]

### Outros Produtos

- [[Homologação - Produtos - Produto Venda]]
- [[Homologação - Produtos - Produto Uso e Consumo]]

### Cadastros Auxiliares

- [[Homologação - Produtos - Cadastros Auxiliares]]

### Projeto

- [[Sysvar]]