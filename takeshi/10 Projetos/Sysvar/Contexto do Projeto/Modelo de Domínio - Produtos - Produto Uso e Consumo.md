---
type: domain-model
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
  - histórico
  - auditoria
  - multiempresa
  - domínio
  - homologado
---

# Modelo de Domínio - Produtos - Produto Uso e Consumo

## 1. Identificação

- **Projeto:** [[Sysvar]]
- **Módulo:** Produtos
- **Funcionalidade:** Produto Uso/Consumo
- **Tipo interno:** `tipo_produto = '2'`
- **Escopo:** Fase 1 — Cadastro e gestão estrutural
- **Situação:** IMPLEMENTADO E HOMOLOGADO
- **Data de consolidação:** 14/08/2026

### Documentos relacionados

- [[Sysvar]]
- [[Homologação - Produtos - Produto Uso e Consumo]]
- [[Mapa Técnico - Produtos - Produto Uso e Consumo]]
- [[Workflows - Produtos - Produto Uso e Consumo]]
- [[Riscos e Cuidados - Produtos - Produto Uso e Consumo]]
- [[Homologação - Produtos - Produto Venda]]
- [[Homologação - Produtos - Insumos]]
- [[Homologação - Produtos - Cadastros Auxiliares]]

---

# 2. Objetivo do Modelo de Domínio

O domínio de **Produto Uso/Consumo** representa os itens utilizados internamente pelas empresas atendidas pelo [[Sysvar]].

Seu objetivo é fornecer uma entidade cadastral consistente para que os demais módulos possam identificar corretamente:

- qual é o item;
- a qual Empresa pertence;
- qual é seu código;
- qual sua descrição;
- qual sua Unidade;
- quais são seus dados fiscais;
- qual sua situação;
- quais custos estão relacionados;
- quais movimentações poderão utilizar o item;
- qual histórico cadastral existe;
- quais operações de Compras e Estoque poderão utilizar o Produto.

Produto Uso/Consumo não representa mercadoria destinada à comercialização.

Também não representa componente diretamente utilizado na fabricação.

Conceitualmente:

~~~text
Produtos
   ├── Produto Venda
   │     ├── Revenda
   │     └── Fabricação Própria
   │
   ├── Produto Uso/Consumo
   │
   └── Insumo
~~~

As regras homologadas estão registradas em:

[[Homologação - Produtos - Produto Uso e Consumo]]

---

# 3. Agregado Principal

A entidade central do domínio é:

`Produto`

Produto Uso/Consumo utiliza a entidade Produto diferenciada pelo tipo:

~~~text
tipo_produto = '2'
~~~

Relacionamentos conceituais principais:

~~~text
Empresa
  ↓
Produto Uso/Consumo
  ├── Código
  ├── Descrição
  ├── Descrição reduzida
  ├── Unidade
  ├── NCM / Dados Fiscais
  ├── Custos
  ├── Situação
  ├── Observações
  ├── Histórico Funcional
  └── AuditLog
~~~

Relacionamentos operacionais futuros ou já existentes podem incluir:

~~~text
Produto Uso/Consumo
  ├── Compras
  ├── Recebimento
  ├── Entrada Fiscal
  ├── Estoque
  ├── Movimentações
  └── Custos
~~~

Produto é a raiz cadastral do agregado.

A implementação técnica correspondente está documentada em:

[[Mapa Técnico - Produtos - Produto Uso e Consumo]]

---

# 4. Separações Fundamentais

O domínio depende de separações que não devem ser confundidas:

~~~text
Produto Uso/Consumo != Produto Venda
Produto Uso/Consumo != Insumo

Produto != Estoque
Produto != Movimento de Estoque
Produto != Pedido de Compra
Produto != Entrada Fiscal

Cadastro do Produto != Localização do Estoque

Ativo != Existência de saldo
Inativar != Excluir

Histórico Funcional != AuditLog
~~~

Essas separações devem ser preservadas em evoluções futuras.

---

# 5. Empresa

Todo Produto Uso/Consumo pertence a uma Empresa.

Relacionamento conceitual:

~~~text
Empresa 1:N Produto
~~~

Regra:

**Produto Uso/Consumo nunca deve existir fora do contexto de uma Empresa.**

A Empresa determina o tenant do Produto.

Consequências:

- Unidade deve respeitar a Empresa;
- NCM e dados relacionados devem respeitar o contexto permitido;
- consultas devem respeitar a Empresa;
- alterações devem respeitar a Empresa;
- histórico deve respeitar a Empresa;
- operações futuras devem respeitar o tenant;
- estoque deve respeitar o contexto operacional da Empresa.

---

# 6. Isolamento Multiempresa

Não existe compartilhamento livre de Produto Uso/Consumo entre Empresas distintas.

Conceitualmente:

~~~text
Empresa A
  ↓
Produto Uso/Consumo A

Empresa B
  ↓
Produto Uso/Consumo B
~~~

Mesmo que os dois itens possuam:

- mesma descrição;
- mesmo NCM;
- mesma Unidade;

eles pertencem a contextos empresariais distintos.

O backend é a autoridade do isolamento multiempresa.

---

# 7. Tipo do Produto

O identificador interno do domínio é:

~~~text
tipo_produto = '2'
~~~

Esse valor caracteriza o registro como:

**Produto Uso/Consumo**

O tipo não deve ser confundido com:

~~~text
1 = Revenda
3 = Fabricação Própria
4 = Insumo
~~~

A separação do tipo influencia:

- filtros;
- telas;
- permissões;
- operações;
- disponibilidade no PDV;
- integração com Produção;
- regras de cadastro.

---

# 8. Identidade do Produto

A identidade cadastral é formada principalmente por:

- ID interno;
- Empresa;
- tipo;
- código automático.

O código funcional segue:

~~~text
USO-000001
USO-000002
USO-000003
~~~

O código funciona como identificador humano e operacional do cadastro.

---

# 9. Código

O código é:

- automático;
- sequencial;
- único por Empresa;
- imutável;
- não reutilizável.

Relacionamento conceitual:

~~~text
Empresa
  ↓
Sequência Uso/Consumo
  ↓
USO-XXXXXX
~~~

O usuário não deve controlar manualmente a sequência.

---

# 10. Imutabilidade do Código

Após a criação:

~~~text
USO-000125
~~~

deve continuar sendo o código daquele Produto durante todo o seu ciclo de vida.

Editar o Produto não deve gerar novo código.

Inativar também não deve alterar o código.

Reativar deve manter o mesmo código.

---

# 11. Não Reutilização

Mesmo que um Produto seja fisicamente excluído quando permitido, seu código não deve ser reaproveitado.

Conceitualmente:

~~~text
USO-000125
    ↓
Produto excluído
    ↓
Próxima criação
    ↓
USO-000126
~~~

e não:

~~~text
USO-000125
~~~

novamente.

A sequência possui valor histórico.

---

# 12. Descrição

Produto Uso/Consumo possui descrição principal obrigatória.

Limite funcional:

~~~text
120 caracteres
~~~

A descrição representa a identificação principal do item.

Exemplos:

- Papel A4;
- Detergente neutro;
- Toner para impressora;
- Lâmpada LED;
- Material de limpeza.

---

# 13. Descrição Reduzida

Produto Uso/Consumo possui descrição reduzida obrigatória.

Limite:

~~~text
60 caracteres
~~~

Ela serve para contextos onde a descrição integral não é adequada.

A descrição reduzida não substitui a descrição principal.

---

# 14. Unidade

Produto Uso/Consumo deve possuir Unidade.

Relacionamento conceitual:

~~~text
Produto N:1 Unidade
~~~

Exemplos:

- UN;
- PC;
- CX;
- KG;
- LT;
- M.

A Unidade deve estar disponível no contexto da Empresa.

O cadastro auxiliar está relacionado a:

[[Homologação - Produtos - Cadastros Auxiliares]]

---

# 15. NCM

Produto Uso/Consumo pode possuir NCM.

NCM é opcional no cadastro inicial.

Relacionamento conceitual:

~~~text
Produto
  ↓
NCM opcional
~~~

A ausência de NCM não torna o Produto cadastralmente inválido.

Pode, entretanto, contribuir para o estado gerencial:

**Fiscal Incompleto**

---

# 16. Dados Fiscais

Produto Uso/Consumo utiliza a estrutura fiscal disponível na entidade Produto.

Entre os conceitos fiscais existentes estão:

- NCM;
- origem da mercadoria;
- CST/CSOSN;
- ICMS;
- CFOP;
- PIS;
- COFINS;
- IPI.

Esses dados pertencem ao Produto como informação cadastral.

As exigências finais de uma operação fiscal pertencem ao processo que realiza a operação.

---

# 17. Fiscal Incompleto

Fiscal Incompleto representa uma condição cadastral/gerencial.

Conceitualmente:

~~~text
Produto cadastrado
        ↓
Dados fiscais não totalmente preenchidos
        ↓
Fiscal Incompleto = Sim
~~~

Essa condição:

- não impede a existência do Produto;
- permite localizar pendências;
- não substitui validações fiscais operacionais.

---

# 18. Unidade versus Localização

Unidade não deve ser confundida com localização de estoque.

Exemplo:

~~~text
Unidade = CX
~~~

significa unidade de medida.

Não significa:

~~~text
Loja X
Depósito Y
Matriz
~~~

Esses são conceitos distintos.

---

# 19. Ausência de Grade

Produto Uso/Consumo não possui Grade como parte do seu agregado.

Não existe relação obrigatória:

~~~text
Produto Uso/Consumo
        ↓
Grade
~~~

Grade pertence ao domínio de Produto Venda e aos cadastros auxiliares correspondentes.

---

# 20. Ausência de Tamanho

Produto Uso/Consumo não possui variações de Tamanho.

Não existe:

~~~text
Produto Uso/Consumo
        ↓
PP / P / M / G
~~~

como estrutura comercial.

---

# 21. Ausência de Cor Comercial

Produto Uso/Consumo não possui variação comercial por Cor.

Não deve gerar diferentes registros operacionais por combinação de cor.

---

# 22. Ausência de SKU Comercial

Produto Uso/Consumo não utiliza o conceito de SKU comercial:

~~~text
Produto + Cor + Tamanho
~~~

como ocorre em Produto Venda.

Não deve ser criada uma estrutura de `ProdutoDetalhe` por analogia sem necessidade funcional.

---

# 23. Ausência de EAN Obrigatório

Produto Uso/Consumo não exige EAN obrigatório.

A geração automática utilizada para SKUs de Produto Venda não pertence obrigatoriamente a este domínio.

EAN não deve se tornar requisito cadastral sem nova decisão funcional.

---

# 24. Ausência de Coleção

Produto Uso/Consumo não pertence à estrutura de Coleção de moda.

Não utiliza:

- ano de coleção;
- estação;
- sequência baseada em coleção;
- referência `AA-BB-CCDDD`.

Seu código próprio é suficiente para identidade cadastral:

~~~text
USO-XXXXXX
~~~

---

# 25. Ausência de Grupo e Subgrupo Obrigatórios

Grupo e Subgrupo não fazem parte das obrigações homologadas de Produto Uso/Consumo.

Não criar relacionamento obrigatório apenas porque essas entidades existem em Produto Venda.

---

# 26. Ausência de Material no Escopo Funcional

Material não pertence ao conjunto funcional obrigatório de Produto Uso/Consumo.

Esse conceito deve ser diferenciado de Insumos.

No domínio de Insumos, Material pode ser utilizado como classificação opcional.

Ver:

[[Homologação - Produtos - Insumos]]

---

# 27. Situação

Produto Uso/Consumo possui situação:

~~~text
ATIVO
INATIVO
~~~

Conceitualmente:

~~~text
Produto
   ↓
Ativo = true / false
~~~

O status representa disponibilidade cadastral/operacional para novas utilizações.

---

# 28. Ativo

Produto Ativo pode ser disponibilizado para processos permitidos, como:

- Compras;
- entradas;
- movimentações;
- consultas;
- demais operações compatíveis.

Estar ativo não significa possuir estoque.

---

# 29. Inativo

Produto Inativo permanece cadastrado para preservação histórica.

Não deve ser apagado simplesmente porque deixou de ser utilizado.

Inativação preserva:

- código;
- identidade;
- histórico;
- relacionamentos anteriores;
- rastreabilidade.

---

# 30. Ausência de Bloqueio de Venda

Produto Uso/Consumo não possui:

~~~text
Bloqueado para venda
~~~

como estado funcional relevante.

Motivo:

~~~text
Produto Uso/Consumo
        ↓
não participa do PDV
~~~

Portanto:

~~~text
Ativo/Inativo
~~~

é suficiente para o lifecycle cadastral homologado.

---

# 31. Exclusão

Exclusão é diferente de inativação.

~~~text
Inativação
→ preserva registro

Exclusão
→ remove registro quando seguro
~~~

A exclusão só pode ocorrer quando não houver dependências operacionais que exijam preservação.

---

# 32. Exclusão Protegida

O domínio deve proteger Produto utilizado em processos.

Exemplos de dependências relevantes:

- Pedido de Compra;
- recebimento;
- documento fiscal;
- estoque;
- movimento;
- histórico operacional;
- outra entidade persistente.

Conceitualmente:

~~~text
Produto
   ↓
Possui dependência?
   ├── Sim → não excluir
   └── Não → exclusão pode ser permitida
~~~

---

# 33. Estoque

Produto Uso/Consumo pertence naturalmente ao domínio de Estoque.

Entretanto:

~~~text
Produto != Estoque
~~~

Produto representa **o que é o item**.

Estoque representa:

- quantidade;
- localização;
- movimentação;
- saldo.

---

# 34. Ausência de `controla_estoque`

Não existe no domínio homologado uma propriedade funcional:

~~~text
controla_estoque = true/false
~~~

Todo Produto Uso/Consumo pode ser controlado em estoque.

O usuário não precisa decidir essa natureza no cadastro.

---

# 35. Localização do Estoque

O cadastro do Produto não define localização.

Não existe relacionamento cadastral obrigatório:

~~~text
Produto Uso/Consumo
        ↓
Matriz fixa
~~~

ou:

~~~text
Produto Uso/Consumo
        ↓
Loja fixa
~~~

A localização nasce da operação.

---

# 36. Estoque por Operação

Conceitualmente:

~~~text
Produto Uso/Consumo
        ↓
Operação de Entrada
        ↓
Empresa / Estabelecimento / Local
        ↓
Estoque
~~~

É a operação que informa onde o Produto está.

---

# 37. Estoque e Empresa

Qualquer estrutura de estoque relacionada a Produto Uso/Consumo deve respeitar a Empresa.

Não pode ocorrer:

~~~text
Produto Empresa A
        ↓
Saldo Empresa B
~~~

O tenant deve ser consistente em toda a cadeia.

---

# 38. Movimento de Estoque

Movimento não pertence ao agregado cadastral diretamente.

Relacionamento conceitual:

~~~text
Produto
   ↓
Movimento de Estoque
   ├── tipo
   ├── origem
   ├── destino
   ├── quantidade
   ├── data
   └── contexto operacional
~~~

O cadastro não cria movimentos sozinho.

---

# 39. Saldo

Saldo é consequência de movimentos.

~~~text
Entradas
   -
Saídas
   =
Saldo
~~~

O cadastro não deve manter quantidade arbitrária apenas por existir.

---

# 40. Compras

Produto Uso/Consumo pode participar de Compras.

Relacionamento conceitual:

~~~text
Pedido de Compra
        ↓
Item
        ↓
Produto Uso/Consumo
~~~

O domínio de Compras é responsável por:

- fornecedor;
- quantidade;
- preço;
- parcelas;
- aprovação;
- recebimento;
- integrações financeiras.

O Produto apenas fornece sua identidade.

---

# 41. Recebimento

Recebimento utiliza Produto Uso/Consumo como item recebido.

Conceitualmente:

~~~text
Pedido / NF
   ↓
Recebimento
   ↓
Produto Uso/Consumo
   ↓
Estoque
   ↓
Custos
~~~

O cadastro não executa diretamente esse processo.

---

# 42. Entrada Fiscal

Produto Uso/Consumo pode participar de documentos fiscais de entrada.

A Entrada Fiscal é responsável por:

- validar documento;
- validar campos fiscais necessários;
- identificar Empresa;
- identificar localização;
- gerar integrações correspondentes.

---

# 43. Custos

Produto Uso/Consumo pode possuir informações de custos.

Conceitos possíveis na estrutura existente:

- custo original;
- custo da última compra;
- custo médio.

Custos são derivados de eventos reais.

O cadastro não deve fabricar custo.

---

# 44. Custo Médio

Quando suportado pela estrutura operacional, o custo médio deve refletir movimentos e regras de custo existentes.

Não pertence ao Produto Uso/Consumo criar fórmula paralela de custo.

---

# 45. Última Compra

O custo da última compra deve refletir um evento real de aquisição.

A origem desse valor pertence aos processos de Compras/Recebimento.

---

# 46. PDV

Produto Uso/Consumo não integra o conjunto normal de produtos vendáveis.

Relacionamento proibido no fluxo comercial comum:

~~~text
Produto Uso/Consumo
        ↓
Venda ao consumidor
~~~

O filtro operacional de PDV deve considerar apenas tipos comercializáveis.

---

# 47. Tabela de Preço

Produto Uso/Consumo não depende de Tabela de Preço comercial.

Não possui obrigatoriedade de:

- preço de venda;
- tabela promocional;
- margem comercial.

---

# 48. Promoção

Produto Uso/Consumo não integra promoção comercial destinada a clientes.

Promoção pertence ao domínio de produtos comercializáveis.

---

# 49. Produção

Produto Uso/Consumo não representa componente produtivo.

Não existe relação funcional direta:

~~~text
Ficha Técnica
   ↓
Produto Uso/Consumo
~~~

para composição do Produto fabricado.

---

# 50. Insumo

Insumo é um domínio separado.

Conceitualmente:

~~~text
Insumo
   ↓
Ficha Técnica
   ↓
Produto de Fabricação Própria
~~~

Produto Uso/Consumo:

~~~text
Uso interno
   ↓
Não compõe diretamente o produto fabricado
~~~

Documentação relacionada:

[[Homologação - Produtos - Insumos]]

---

# 51. Diferença de Uso

Exemplo:

~~~text
Tecido usado para fabricar vestido
→ Insumo

Linha usada diretamente na fabricação
→ Insumo

Papel A4 do escritório
→ Produto Uso/Consumo

Detergente para limpeza interna
→ Produto Uso/Consumo
~~~

A finalidade operacional determina o domínio correto.

---

# 52. Histórico Funcional

Produto Uso/Consumo possui histórico próprio.

Relacionamento conceitual:

~~~text
Produto
   ↓
Histórico Funcional
   ├── usuário
   ├── data/hora
   ├── campo
   ├── valor anterior
   └── valor novo
~~~

O histórico permite compreender a evolução cadastral.

---

# 53. Histórico e Produto

O histórico deve estar ligado ao Produto correto e à Empresa correta.

Não deve haver mistura entre:

- histórico de Produto Venda;
- histórico de Insumo;
- histórico de Produto Uso/Consumo.

---

# 54. AuditLog

AuditLog representa auditoria sistêmica.

Conceitualmente:

~~~text
Usuário
   ↓
Ação
   ↓
Produto Uso/Consumo
   ↓
AuditLog
~~~

Pode registrar:

- criação;
- edição;
- ativação;
- inativação;
- exclusão;
- demais ações relevantes.

---

# 55. Histórico Funcional versus Auditoria

Esses conceitos são distintos:

~~~text
Histórico Funcional
→ evolução compreensível do cadastro

AuditLog
→ rastreabilidade técnica/sistêmica da operação
~~~

Ambos podem registrar aspectos da mesma ação, mas com objetivos diferentes.

---

# 56. Consulta

Consulta representa uma projeção consolidada do agregado e relacionamentos disponíveis.

Pode apresentar:

~~~text
Produto
  ├── Identificação
  ├── Unidade
  ├── Fiscal
  ├── Custos
  ├── Observações
  ├── Histórico
  └── Movimentações
~~~

A consulta não deve criar relações que não existam no domínio.

---

# 57. Consulta por Identidade

A seleção visual de uma linha não é a autoridade final do dado.

Fluxo conceitual:

~~~text
Registro selecionado
        ↓
ID
        ↓
Backend
        ↓
Produto atual
        ↓
Consulta
~~~

Isso reduz risco de apresentar snapshot desatualizado.

---

# 58. Edição

Edição mantém a identidade do agregado.

Após edição:

~~~text
ID permanece
Código permanece
Empresa permanece
Tipo permanece
~~~

Podem mudar apenas os campos permitidos.

---

# 59. Tipo Imutável

Uma vez criado como:

~~~text
tipo_produto = '2'
~~~

o registro não deve ser transformado arbitrariamente em:

~~~text
tipo_produto = '1'
tipo_produto = '3'
tipo_produto = '4'
~~~

Essa mudança descaracterizaria o domínio e poderia quebrar integrações e histórico.

---

# 60. Empresa Imutável no Contexto Normal

Produto não deve ser transferido simplesmente de uma Empresa para outra alterando sua FK cadastral.

Cada Empresa deve possuir seus próprios registros.

---

# 61. Relações Permitidas

Resumo:

~~~text
Produto Uso/Consumo
   │
   ├── Empresa             obrigatório
   ├── Unidade             obrigatória
   ├── NCM                 opcional
   ├── Dados Fiscais       opcionais/incrementais
   ├── Custos              conforme eventos
   ├── Histórico           rastreabilidade
   ├── Auditoria           rastreabilidade sistêmica
   ├── Compras             operação
   ├── Estoque             operação
   └── Movimentações       operação
~~~

---

# 62. Relações que Não Pertencem ao Domínio

Não pertencem ao Produto Uso/Consumo:

~~~text
Grade obrigatória
Tamanho comercial
Cor comercial
SKU Cor × Tamanho
EAN obrigatório
Coleção
Referência AA-BB-CCDDD
Pack comercial
Tabela de Preço de venda obrigatória
Promoção comercial
PDV
Ficha Técnica
Bloqueio de Venda
~~~

---

# 63. Modelo Conceitual Simplificado

~~~text
                     ┌─────────────┐
                     │   Empresa   │
                     └──────┬──────┘
                            │ 1:N
                            ↓
              ┌──────────────────────────┐
              │ Produto Uso/Consumo      │
              │ tipo_produto = '2'       │
              │ USO-XXXXXX               │
              └───────────┬──────────────┘
                          │
          ┌───────────────┼────────────────┐
          │               │                │
          ↓               ↓                ↓
      Unidade          Fiscal          Histórico
          │               │                │
          │               │                ↓
          │               │            AuditLog
          │               │
          └───────────────┼────────────────────────┐
                          │                        │
                          ↓                        ↓
                       Compras                  Estoque
                          │                        │
                          ↓                        ↓
                     Recebimento              Movimentos
                          │                        │
                          └─────────→ Custos ←────┘
~~~

---

# 64. Agregado Cadastral versus Domínios Operacionais

O agregado cadastral termina onde começam as operações.

~~~text
CADASTRO
Produto Uso/Consumo
- identidade
- descrição
- unidade
- fiscal
- status
        ↓
DOMÍNIOS OPERACIONAIS
- Compras
- Fiscal
- Estoque
- Movimentações
- Custos
~~~

Não concentrar todas as responsabilidades no model de Produto.

---

# 65. Regra de Localização

Uma das separações mais importantes é:

~~~text
Produto
   ↓
NÃO define onde está

Movimento
   ↓
define onde entrou/saiu
~~~

A localização é um atributo do contexto de estoque, não da identidade do Produto.

---

# 66. Regra Cancelada da Matriz

Não existe no modelo homologado:

~~~text
Produto Uso/Consumo
        ↓
Matriz obrigatória
~~~

A regra foi descartada.

Não deve aparecer futuramente em:

- model;
- serializer;
- tela;
- service;
- validação;
- documentação.

---

# 67. Regra Cancelada de Controle Opcional de Estoque

Também não pertence ao domínio:

~~~text
Produto Uso/Consumo
        ↓
controla_estoque?
~~~

O Produto é naturalmente passível de controle de estoque.

---

# 68. Dependências Futuras

Evoluções futuras podem criar relações adicionais, por exemplo:

- solicitação de consumo;
- requisição interna;
- transferência;
- centro de custo;
- baixa por consumo;
- inventário;
- reposição.

Essas relações devem consumir o Produto existente sem mudar sua natureza cadastral.

---

# 69. Centro de Custo Futuro

Uma operação futura pode relacionar consumo com Centro de Custo.

Exemplo:

~~~text
Produto Uso/Consumo
        ↓
Saída por consumo
        ↓
Centro de Custo
~~~

Centro de Custo não precisa fazer parte obrigatória do cadastro do Produto.

---

# 70. Transferência Futura

Transferência deve ser relação operacional:

~~~text
Produto
   ↓
Origem
   ↓
Destino
~~~

Não uma alteração cadastral do Produto.

---

# 71. Consumo Interno Futuro

Uma futura baixa de consumo deve relacionar:

~~~text
Produto
Quantidade
Local
Data
Responsável
Motivo
Centro de Custo, quando aplicável
~~~

A operação deve gerar movimento de estoque.

---

# 72. Integridade Referencial

O domínio deve preservar integridade entre:

- Empresa;
- Produto;
- Unidade;
- Fiscal;
- Estoque;
- Movimentos;
- Compras;
- Histórico.

IDs enviados pelo frontend não são suficientes para garantir validade.

O backend deve validar os relacionamentos.

---

# 73. Proteção contra Cross-Tenant

Exemplo inválido:

~~~text
Produto Empresa A
        +
Unidade privada Empresa B
~~~

O backend deve rejeitar.

O mesmo princípio vale para relacionamentos futuros.

---

# 74. Produto Inativo e Histórico

Inativar não deve eliminar:

- compras anteriores;
- entradas;
- movimentos;
- custos;
- registros fiscais;
- histórico;
- auditoria.

O Produto continua existindo como entidade histórica.

---

# 75. Produto Excluído

Exclusão física só deve ocorrer quando a remoção não comprometer referências.

Em caso de dúvida operacional:

~~~text
Inativar
~~~

é preferível a destruir a identidade histórica.

---

# 76. Indicadores como Projeção

Indicadores como:

- Total;
- Ativos;
- Inativos;
- Fiscal Incompleto;

não são entidades do domínio.

São projeções calculadas a partir dos Produtos pertencentes à Empresa.

---

# 77. Filtros como Consulta

Filtros também não alteram o agregado.

Eles apenas projetam subconjuntos do domínio conforme:

- Empresa;
- tipo;
- código;
- descrição;
- Unidade;
- NCM;
- status;
- situação fiscal.

---

# 78. Paginação

Paginação pertence à camada de consulta.

Não altera o domínio.

O backend deve fornecer subconjuntos consistentes dos registros autorizados.

---

# 79. Autoridade das Camadas

Responsabilidades:

~~~text
Frontend
→ UX, formulário, apresentação

Backend
→ domínio, validação, segurança

Banco
→ persistência e integridade

Módulos operacionais
→ eventos de negócio
~~~

Evitar deslocar regra crítica exclusivamente para a interface.

---

# 80. Regras Invariantes

As principais invariantes do domínio são:

1. todo Produto Uso/Consumo pertence a uma Empresa;
2. `tipo_produto = '2'`;
3. código segue `USO-XXXXXX`;
4. código é automático;
5. código não muda;
6. código não é reutilizado;
7. descrição é obrigatória;
8. descrição reduzida é obrigatória;
9. Unidade é obrigatória;
10. NCM pode ser opcional;
11. Fiscal Incompleto é permitido;
12. não existe Grade;
13. não existe Cor × Tamanho;
14. não existe SKU comercial obrigatório;
15. não existe EAN obrigatório;
16. não existe Coleção;
17. não existe preço comercial obrigatório;
18. não participa do PDV;
19. não participa da Ficha Técnica;
20. não é Insumo;
21. possui natureza de estoque;
22. cadastro não define localização;
23. não existe `controla_estoque`;
24. lifecycle é Ativo/Inativo;
25. não existe Bloqueio de Venda;
26. exclusão deve ser protegida;
27. multiempresa é obrigatório;
28. histórico deve ser preservado;
29. auditoria deve ser preservada.

---

# 81. Riscos de Violação do Domínio

Alterações futuras podem degradar o modelo se:

- transformarem Uso/Consumo em Produto Venda simplificado;
- confundirem Uso/Consumo com Insumo;
- adicionarem Grade;
- adicionarem Cor × Tamanho;
- exigirem EAN;
- vincularem Matriz obrigatória;
- criarem `controla_estoque`;
- incluírem o tipo 2 no PDV;
- incluírem o tipo 2 na Ficha Técnica;
- permitirem alteração do tipo;
- quebrarem o isolamento multiempresa;
- permitirem exclusão de Produto já utilizado.

Os cuidados específicos estão registrados em:

[[Riscos e Cuidados - Produtos - Produto Uso e Consumo]]

---

# 82. Estado Homologado

O modelo atual representa o domínio aprovado de Produto Uso/Consumo.

Referência funcional:

[[Homologação - Produtos - Produto Uso e Consumo]]

Referência técnica:

[[Mapa Técnico - Produtos - Produto Uso e Consumo]]

Fluxos:

[[Workflows - Produtos - Produto Uso e Consumo]]

---

# 83. Estado Final

**Produto Uso/Consumo está IMPLEMENTADO E HOMOLOGADO.**

Sua responsabilidade central é representar um item de uso interno da Empresa sem transformá-lo em:

- mercadoria comercial;
- SKU de moda;
- componente produtivo.

As operações de Compras, Estoque, Fiscal e consumo interno devem utilizar esse cadastro como origem de identidade.

---

# 84. Navegação Documental

## Produto Uso/Consumo

- [[Homologação - Produtos - Produto Uso e Consumo]]
- [[Mapa Técnico - Produtos - Produto Uso e Consumo]]
- [[Workflows - Produtos - Produto Uso e Consumo]]
- [[Riscos e Cuidados - Produtos - Produto Uso e Consumo]]

## Outros Produtos

- [[Homologação - Produtos - Produto Venda]]
- [[Homologação - Produtos - Insumos]]

## Cadastros Auxiliares

- [[Homologação - Produtos - Cadastros Auxiliares]]

## Projeto

- [[Sysvar]]