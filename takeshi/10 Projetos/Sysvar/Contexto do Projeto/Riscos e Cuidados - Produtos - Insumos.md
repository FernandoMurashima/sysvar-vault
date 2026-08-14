---
type: risks-and-care
status: approved
project: Sysvar
group: Produtos
module: Insumos
phase: Fase 1
created: 2026-08-14
updated: 2026-08-14
tags:
  - sysvar
  - produtos
  - insumos
  - produção
  - ficha-técnica
  - estoque
  - compras
  - fiscal
  - custos
  - riscos
  - auditoria
  - multiempresa
  - homologado
---

# Riscos e Cuidados - Produtos - Insumos

## 1. Identificação

- **Projeto:** [[Sysvar]]
- **Módulo:** Produtos
- **Funcionalidade:** Insumos
- **Tipo interno:** `tipo_produto = '4'`
- **Escopo:** Fase 1 — Cadastro e gestão estrutural
- **Situação:** IMPLEMENTADO E HOMOLOGADO
- **Decisões funcionais aprovadas:** 34
- **Data de consolidação documental:** 14/08/2026

### Documentos relacionados

- [[Sysvar]]
- [[Homologação - Produtos - Insumos]]
- [[Mapa Técnico - Produtos - Insumos]]
- [[Workflows - Produtos - Insumos]]
- [[Modelo de Domínio - Produtos - Insumos]]
- [[Homologação - Produtos - Produto Venda]]
- [[Homologação - Produtos - Produto Uso e Consumo]]
- [[Homologação - Produtos - Cadastros Auxiliares]]

---

# 2. Objetivo

Este documento registra os principais riscos técnicos, funcionais, operacionais e arquiteturais relacionados ao cadastro de **Insumos** do [[Sysvar]].

Deve ser consultado antes de alterações relevantes em:

- `Produto`;
- serializers;
- views;
- endpoints;
- migrations;
- filtros;
- Unidade;
- Material;
- NCM;
- Dados Fiscais;
- Compras;
- Estoque;
- custos;
- Ficha Técnica;
- Produção;
- Ordem de Produção;
- facção;
- exclusão;
- Auditoria;
- permissões;
- frontend de Insumos.

O objetivo é impedir que evoluções futuras modifiquem silenciosamente regras já aprovadas e homologadas.

A estrutura funcional está em:

[[Homologação - Produtos - Insumos]]

A estrutura técnica está em:

[[Mapa Técnico - Produtos - Insumos]]

Os fluxos estão em:

[[Workflows - Produtos - Insumos]]

O domínio está em:

[[Modelo de Domínio - Produtos - Insumos]]

---

# 3. Classificação de Impacto

Os riscos são classificados como:

~~~text
CRÍTICO
ALTO
MÉDIO
BAIXO
~~~

## CRÍTICO

Pode causar:

- vazamento de dados entre Empresas;
- corrupção de Estoque;
- consumo incorreto de materiais;
- perda de histórico;
- quebra de integridade referencial;
- baixa indevida de Insumos;
- associação cross-tenant;
- alteração indevida da identidade do Insumo.

## ALTO

Pode causar:

- quebra de regra homologada;
- classificação incorreta do Produto;
- custos errados;
- problemas fiscais;
- Ficha Técnica inconsistente;
- comportamento incorreto em Compras ou Produção.

## MÉDIO

Pode causar:

- fluxo operacional inadequado;
- UX confusa;
- duplicidade de lógica;
- dados pouco confiáveis;
- dificuldade de manutenção.

## BAIXO

Normalmente envolve:

- apresentação;
- conveniência;
- otimizações;
- melhorias sem comprometimento imediato da integridade.

---

# 4. Risco — Quebra do Isolamento Multiempresa

Todo Insumo deve permanecer no contexto autorizado da Empresa.

Devem respeitar o mesmo tenant:

- Insumo;
- Unidade;
- Material;
- informações fiscais;
- Estoque;
- movimentos;
- Ficha Técnica;
- Compras;
- custos;
- Produção;
- Auditoria.

Exemplo inválido:

~~~text
Ficha Técnica Empresa A
+
Insumo Empresa B
~~~

Impacto:

**CRÍTICO**

Cuidados:

- aplicar filtro de Empresa no backend;
- validar relacionamentos;
- não confiar em IDs enviados pelo frontend;
- testar cenários cross-tenant.

---

# 5. Risco — Confiar Apenas no Frontend

A tela pode mostrar somente registros permitidos e ainda assim a API aceitar IDs indevidos.

Impacto:

**CRÍTICO**

Cuidados:

- revalidar todas as relações no backend;
- frontend deve ser apenas camada de UX;
- autorização real permanece no servidor.

---

# 6. Risco — Misturar Insumo com Produto Uso/Consumo

A diferença é funcional:

~~~text
Uso/Consumo
→ utilização interna não produtiva

Insumo
→ componente da fabricação
~~~

Impacto:

**ALTO**

Cuidados:

- manter `tipo_produto = '4'` para Insumos;
- manter `tipo_produto = '2'` para Uso/Consumo;
- Ficha Técnica deve trabalhar com Insumos;
- não permitir que itens administrativos sejam tratados automaticamente como matéria-prima.

Referência:

[[Homologação - Produtos - Produto Uso e Consumo]]

---

# 7. Risco — Misturar Insumo com Produto Venda

Insumo não é mercadoria de venda.

Não deve herdar automaticamente:

- Grade;
- Cor × Tamanho;
- SKU comercial;
- EAN por variação;
- Coleção;
- preço de venda;
- Promoção;
- PDV;
- bloqueio de venda.

Impacto:

**ALTO**

Referência:

[[Homologação - Produtos - Produto Venda]]

---

# 8. Risco — Alterar o Tipo do Insumo

Uma vez criado como:

~~~text
tipo_produto = '4'
~~~

o registro não deve ser convertido arbitrariamente em outro tipo.

Impacto:

**CRÍTICO**

Pode comprometer:

- Fichas Técnicas;
- Compras;
- Estoque;
- custos;
- filtros;
- integrações;
- histórico.

---

# 9. Risco — Alterar Identidade/Código

O código do Insumo deve permanecer estável.

Impacto:

**ALTO**

Cuidados:

- não regenerar em edição;
- não mudar em ativação/inativação;
- não reutilizar indevidamente códigos históricos.

---

# 10. Risco — Gerar Código no Frontend

Sequência gerada apenas pelo frontend pode sofrer concorrência ou manipulação.

Impacto:

**CRÍTICO**

Cuidados:

- código deve ser atribuído pelo backend;
- garantir unicidade;
- usar transação quando necessário.

---

# 11. Risco — Tornar Material Obrigatório

Material foi homologado como **opcional**.

Impacto:

**ALTO**

Torná-lo obrigatório bloquearia cadastros válidos sem necessidade funcional.

Cuidado:

~~~text
Material vazio
≠
Insumo inválido
~~~

---

# 12. Risco — Confundir Material com Insumo

Material é classificação.

Insumo é item operacional.

Impacto:

**ALTO**

Exemplo correto:

~~~text
Material:
Algodão

Insumo:
Tecido Tricoline Branco
~~~

Compras e Estoque devem movimentar o Insumo.

---

# 13. Risco — Confundir Unidade com Material

Unidade responde como o item é quantificado.

Material responde como ele é classificado.

Impacto:

**MÉDIO**

Não misturar essas responsabilidades.

---

# 14. Risco — Ignorar `permite_decimal`

Insumos podem utilizar quantidades fracionadas.

Exemplo:

~~~text
1,75 M de tecido
~~~

Impacto:

**ALTO**

Se a regra de Unidade for ignorada:

- quantidades podem ser arredondadas;
- necessidades de Produção podem ficar erradas;
- custos podem ficar incorretos.

---

# 15. Risco — Usar Decimal em Unidade que Não Permite

Exemplo:

~~~text
6,5 UN de botão
~~~

pode ser inválido conforme a Unidade cadastrada.

Impacto:

**ALTO**

A validação deve respeitar o cadastro auxiliar de Unidades.

Referência:

[[Homologação - Produtos - Cadastros Auxiliares]]

---

# 16. Risco — Criar Grade Comercial para Insumos

Grade comercial não pertence ao domínio homologado.

Impacto:

**ALTO**

Não copiar para Insumos a lógica de:

~~~text
PP / P / M / G / GG
~~~

---

# 17. Risco — Gerar Cor × Tamanho

Não gerar automaticamente:

~~~text
Insumo + Cor + Tamanho = SKU
~~~

Impacto:

**ALTO**

Essa estrutura pertence ao Produto Venda.

---

# 18. Risco — Criar ProdutoDetalhe sem Necessidade

Gerar `ProdutoDetalhe` para Insumos apenas por reutilização de arquitetura pode criar complexidade sem benefício.

Impacto:

**ALTO**

O Insumo deve seguir sua própria estrutura homologada.

---

# 19. Risco — Exigir Coleção

Coleção não pertence ao domínio de Insumos.

Impacto:

**MÉDIO**

Não exigir:

- Estação;
- ano;
- Coleção;
- referência comercial de moda.

---

# 20. Risco — Exigir Tabela de Preço

Insumo não precisa de preço comercial.

Impacto:

**ALTO**

O valor relevante é custo de aquisição/produção.

---

# 21. Risco — Disponibilizar Insumo no PDV

Insumos não devem ser vendidos pelo fluxo normal de PDV.

Impacto:

**CRÍTICO**

Cuidados:

- excluir tipo 4 das consultas vendáveis;
- validar também no backend;
- não depender apenas de menu/tela.

---

# 22. Risco — Disponibilizar Insumo em Promoções

Promoções comerciais não devem aceitar Insumos como item normal.

Impacto:

**ALTO**

---

# 23. Risco — Criar Campo `controla_estoque`

Insumo possui natureza de Estoque.

Não pertence ao domínio homologado:

~~~text
controla_estoque = Sim/Não
~~~

Impacto:

**ALTO**

Criar esse campo poderia gerar regras paralelas de saldo.

---

# 24. Risco — Fixar Estoque na Matriz

A localização não pertence ao cadastro.

Impacto:

**ALTO**

Não criar regra:

~~~text
Insumo
→ estoque somente na Matriz
~~~

O local é definido pelas operações.

---

# 25. Risco — Fixar Insumo na Fábrica

Mesmo sendo material produtivo, o cadastro não deve obrigar uma localização fixa denominada fábrica.

Impacto:

**ALTO**

O material pode estar:

- estoque central;
- almoxarifado;
- fábrica;
- em trânsito;
- futuramente em poder de facção.

Localização é operacional.

---

# 26. Risco — Fixar Facção no Cadastro

Uma facção é um destino temporário possível.

Não é característica permanente do Insumo.

Impacto:

**ALTO**

Não criar:

~~~text
insumo.faccao_atual
~~~

para controlar localização física.

---

# 27. Risco — Criar Saldo no Cadastro

Cadastro não deve criar ou editar saldo arbitrariamente.

Impacto:

**CRÍTICO**

Saldo deve resultar de movimentos.

~~~text
Entradas - Saídas = Saldo
~~~

---

# 28. Risco — Duplicar Arquitetura de Estoque

Não criar um estoque exclusivo de Insumos se o sistema já possui infraestrutura oficial capaz de representá-los.

Impacto:

**CRÍTICO**

Consequências:

- saldos divergentes;
- relatórios conflitantes;
- dificuldade de inventário;
- duplicidade de movimentação.

---

# 29. Risco — Misturar Cadastro e Recebimento

Cadastrar o Insumo não significa recebê-lo fisicamente.

Impacto:

**ALTO**

Separação:

~~~text
Cadastro
→ cria identidade

Recebimento
→ cria evento físico
~~~

---

# 30. Risco — Misturar Cadastro e Compra

O Insumo pode ser comprado, mas o formulário cadastral não deve executar Pedido de Compra.

Impacto:

**MÉDIO/ALTO**

---

# 31. Risco — Atualizar Custo sem Evento Real

Não inventar:

- custo médio;
- última compra;
- custo original operacional;

sem uma fonte real.

Impacto:

**ALTO**

O custo deve vir de processo apropriado.

---

# 32. Risco — Tratar Custo como Preço de Venda

Custo e preço comercial são conceitos diferentes.

Impacto:

**ALTO**

~~~text
Insumo
→ Custo

Produto Venda
→ Preço de Venda
~~~

---

# 33. Risco — Colocar Quantidade de Consumo no Cadastro do Insumo

A quantidade necessária depende do Produto fabricado.

Impacto:

**CRÍTICO**

Exemplo:

~~~text
Tecido A

Camisa = 1,80 M
Vestido = 2,40 M
Saia = 1,25 M
~~~

Não existe uma única quantidade correta no cadastro do Insumo.

---

# 34. Risco — Quantidade no Lugar Errado

A quantidade deve pertencer à relação:

~~~text
Ficha Técnica × Insumo
~~~

e não ao Insumo isoladamente.

Impacto:

**CRÍTICO**

---

# 35. Risco — Duplicar Insumo para Cada Ficha Técnica

O mesmo Insumo pode participar de vários Produtos.

Impacto:

**ALTO**

Não criar:

~~~text
Linha Branca para Camisa
Linha Branca para Vestido
Linha Branca para Blusa
~~~

quando se trata do mesmo material físico.

A relação é que deve variar.

---

# 36. Risco — Excluir Insumo Utilizado em Ficha Técnica

Uma Ficha Técnica histórica pode depender da identidade do Insumo.

Impacto:

**CRÍTICO**

Cuidado:

- proteger exclusão;
- utilizar Inativação.

---

# 37. Risco — Inativar e Remover das Fichas Históricas

Inativação não significa apagar vínculos existentes.

Impacto:

**CRÍTICO**

Uma Ficha Técnica histórica deve continuar identificando qual Insumo foi utilizado.

---

# 38. Risco — Criar OP e Baixar Insumos Automaticamente

Esta regra **não foi homologada**.

Impacto:

**CRÍTICO**

O fluxo proibido é assumir:

~~~text
OP criada
=
estoque consumido
~~~

O momento da baixa deverá ser definido no módulo Produção.

---

# 39. Risco — Criar OP e Reservar Automaticamente

Reserva automática também não foi definida nesta fase.

Impacto:

**ALTO/CRÍTICO**

Não implementar sem decisão formal.

---

# 40. Risco — Confundir Necessidade com Consumo

Ficha Técnica pode calcular necessidade teórica.

Isso não é consumo real.

Impacto:

**CRÍTICO**

Separação:

~~~text
Necessidade prevista
!=
Movimento físico
~~~

---

# 41. Risco — Confundir Consumo Previsto e Real

Impacto:

**ALTO**

Conceitos:

~~~text
Ficha Técnica
→ previsto

Produção
→ real
~~~

Misturar os dois prejudica:

- custos;
- perdas;
- eficiência;
- Estoque.

---

# 42. Risco — Baixar Estoque duas vezes

Ao evoluir Produção, existe risco de baixar no momento da reserva e novamente no consumo.

Impacto:

**CRÍTICO**

Antes de implementar, definir claramente:

- reserva;
- separação;
- saída;
- consumo;
- devolução.

---

# 43. Risco — Consumir sem Movimento de Estoque

Uma baixa produtiva não pode alterar apenas um campo de saldo.

Impacto:

**CRÍTICO**

Deve existir rastreabilidade por movimento.

---

# 44. Risco — Envio para Facção sem Movimento

Material enviado a terceiro precisa de rastreabilidade.

Impacto:

**CRÍTICO**

Não apenas marcar:

~~~text
enviado = true
~~~

A operação deverá registrar origem, destino e quantidade.

---

# 45. Risco — Perder Material em Poder de Terceiro

Sem estrutura adequada, o sistema pode considerar o material inexistente ou disponível na origem.

Impacto:

**CRÍTICO**

Uma futura implementação deve distinguir localização e posse.

---

# 46. Risco — Retorno de Sobra sem Movimento

Sobra retornada deve produzir entrada física correspondente.

Impacto:

**ALTO**

---

# 47. Risco — Registrar Perda no Cadastro

Perda é evento operacional.

Impacto:

**ALTO**

Não alterar cadastro ou descrição para representar perda.

---

# 48. Risco — Criar Percentual de Perda Universal no Insumo

Perda pode variar por Produto/processo.

Impacto:

**ALTO**

Exemplo:

~~~text
Mesmo tecido
Produto A → perda 3%
Produto B → perda 8%
~~~

Não assumir percentual universal sem regra formal.

---

# 49. Risco — Conversão de Unidade Implícita

Exemplo:

~~~text
Compra em rolo
Consumo em metro
~~~

Sem fator explícito, o sistema não sabe converter.

Impacto:

**CRÍTICO**

Não presumir conversões.

---

# 50. Risco — Conversão com Fator Incorreto

Mesmo após futura implementação, fatores devem ser rastreáveis.

Impacto:

**CRÍTICO**

Conversão errada afeta:

- saldo;
- custo;
- necessidade;
- compra;
- produção.

---

# 51. Risco — Excluir Insumo com Compras

Pedido ou recebimento histórico pode depender do registro.

Impacto:

**CRÍTICO**

Proteção de exclusão obrigatória.

---

# 52. Risco — Excluir Insumo com Movimentos

Movimentos históricos não podem ficar sem referência.

Impacto:

**CRÍTICO**

Utilizar Inativação.

---

# 53. Risco — Excluir Insumo com Saldo

Excluir item com saldo causa inconsistência grave.

Impacto:

**CRÍTICO**

---

# 54. Risco — Excluir em Cascata

Alterações em `on_delete` podem causar exclusão em massa de relações.

Impacto:

**CRÍTICO**

Revisar migrations e ForeignKeys com cuidado.

---

# 55. Risco — Confundir Inativação com Exclusão

~~~text
Inativar
→ preserva identidade

Excluir
→ remove entidade
~~~

Impacto:

**ALTO**

---

# 56. Risco — Criar Bloqueio de Venda

Insumos não participam do PDV.

Não necessitam:

- Bloquear Venda;
- Desbloquear Venda.

Impacto:

**MÉDIO**

Lifecycle homologado:

~~~text
ATIVO / INATIVO
~~~

---

# 57. Risco — Insumo Inativo em Nova Ficha Técnica

Um Insumo inativo não deve ser escolhido normalmente para nova composição.

Impacto:

**ALTO**

Mas relações antigas devem continuar existindo.

---

# 58. Risco — Insumo Inativo em Nova Compra

O processo de Compras deve tratar corretamente a situação do cadastro.

Impacto:

**ALTO**

Históricos anteriores permanecem.

---

# 59. Risco — Reativação Criar Novo Registro

Reativar deve manter:

- ID;
- código;
- Empresa;
- histórico.

Impacto:

**ALTO**

Não duplicar o Insumo.

---

# 60. Risco — Filtro de Tipo Incorreto

A tela de Insumos deve utilizar:

~~~text
tipo_produto = '4'
~~~

Impacto:

**CRÍTICO**

Caso contrário, podem aparecer outros Produtos.

---

# 61. Risco — Insumo Aparecer como Uso/Consumo

Filtros genéricos mal implementados podem misturar tipos 2 e 4.

Impacto:

**ALTO**

As duas telas devem permanecer distintas.

---

# 62. Risco — Insumo Aparecer no Produto Venda

Não misturar a listagem principal de Produto Venda com Insumos.

Impacto:

**ALTO**

---

# 63. Risco — Paginação Client-Side

Bases grandes de Insumos podem comprometer desempenho.

Impacto:

**MÉDIO/ALTO**

Utilizar paginação server-side.

---

# 64. Risco — Indicadores Calculados só na Página Atual

Caso existam indicadores, eles não devem considerar apenas a página visível.

Impacto:

**MÉDIO**

---

# 65. Risco — Consulta com Dados Desatualizados

A consulta deve utilizar o ID para buscar os dados atuais quando houver endpoint de detalhe.

Impacto:

**MÉDIO**

Fluxo preferido:

~~~text
seleção
→ ID
→ backend
→ dados atuais
~~~

---

# 66. Risco — Edição com Snapshot Antigo

Editar usando apenas o objeto da listagem pode trabalhar com dados desatualizados.

Impacto:

**ALTO**

Buscar detalhes atuais quando suportado.

---

# 67. Risco — Regra Apenas no Frontend

Validação de Empresa, tipo ou dependência apenas visual não é segurança.

Impacto:

**CRÍTICO**

Backend deve validar.

---

# 68. Risco — Regra Genérica no Model Produto

Como `Produto` é compartilhado, uma alteração para Insumos pode quebrar outros tipos.

Impacto:

**CRÍTICO**

Revisar sempre:

~~~text
tipo 1
tipo 2
tipo 3
tipo 4
~~~

---

# 69. Risco — Aplicar Regra de Produto Venda a Todos

Exemplos perigosos:

- Grade obrigatória;
- Grupo obrigatório;
- Coleção obrigatória;
- EAN obrigatório.

Impacto:

**CRÍTICO**

As regras devem respeitar cada domínio.

---

# 70. Risco — Aplicar Regra de Insumo a Todos

O inverso também é perigoso.

Não tornar Ficha Técnica ou Material relevantes para todos os Produtos.

Impacto:

**CRÍTICO**

---

# 71. Risco — Alteração de Migration sem Considerar Dados Existentes

Mudanças em Produto podem afetar registros antigos.

Impacto:

**CRÍTICO**

Cuidados:

- analisar dados legados;
- criar migration segura;
- evitar defaults incorretos;
- testar em base com dados.

---

# 72. Risco — Alterar Unidade de Insumo já Utilizado

Trocar Unidade após o Insumo participar de:

- Ficha Técnica;
- Compras;
- Estoque;

pode alterar a interpretação histórica das quantidades.

Impacto:

**CRÍTICO**

Exemplo:

~~~text
Antes:
Unidade = M

Depois:
Unidade = KG
~~~

Os valores históricos perderiam significado.

Antes de permitir esse tipo de alteração, avaliar dependências.

---

# 73. Risco — Alterar Material e Confundir Histórico

Material é classificatório e pode ser editável conforme regra vigente.

Impacto:

**MÉDIO**

Não usar Material como chave para reconstruir operações históricas.

A identidade deve permanecer no Insumo.

---

# 74. Risco — Atualização de Custo pela Ficha Técnica

Ficha Técnica não deve arbitrariamente modificar custo de aquisição do Insumo.

Impacto:

**ALTO**

Ela consome o custo aplicável para projeção.

---

# 75. Risco — Custo de Produção Usar Unidade Incompatível

Se custo estiver em uma Unidade e consumo em outra sem conversão explícita, o cálculo pode ser incorreto.

Impacto:

**CRÍTICO**

Exemplo:

~~~text
Custo por rolo
×
consumo em metro
~~~

sem fator de conversão.

---

# 76. Risco — Planejamento usar Estoque sem Considerar Local

Um futuro MRP deve considerar onde o material está disponível.

Impacto:

**ALTO**

Saldo total sem contexto pode não significar disponibilidade real para aquela Produção.

---

# 77. Risco — MRP virar Responsabilidade do Cadastro

Planejamento de necessidades não deve ser implementado dentro do formulário de Insumos.

Impacto:

**MÉDIO/ALTO**

Deve ser processo próprio.

---

# 78. Risco — Sugestão de Compra sem Considerar Necessidade Real

Um futuro planejamento deve considerar:

- necessidade;
- estoque;
- reserva;
- pedidos em aberto;
- localização;
- prazo.

Impacto:

**ALTO**

Não criar regra simplista no cadastro.

---

# 79. Risco — Auditoria Insuficiente

Ações relevantes precisam permanecer rastreáveis.

Impacto:

**ALTO**

A Auditoria Central deve continuar registrando operações conforme arquitetura vigente.

---

# 80. Risco — Criar Histórico Sofisticado sem Necessidade

A homologação não aprovou nova estrutura individual complexa de histórico para Insumos.

Impacto:

**MÉDIO**

Não ampliar o escopo sem necessidade real.

---

# 81. Risco — Documentação Divergir da Implementação

Impacto:

**ALTO**

Ordem correta para mudanças futuras:

~~~text
Decidir
→ Implementar
→ Testar
→ Homologar
→ Documentar
~~~

Não registrar comportamento futuro como se já estivesse implementado.

---

# 82. Risco — Quebrar Links do Obsidian

Os documentos usam nomes padronizados.

Impacto:

**MÉDIO**

Preservar os links:

- [[Homologação - Produtos - Insumos]]
- [[Mapa Técnico - Produtos - Insumos]]
- [[Workflows - Produtos - Insumos]]
- [[Modelo de Domínio - Produtos - Insumos]]
- [[Riscos e Cuidados - Produtos - Insumos]]

---

# 83. Checklist antes de Alterar Backend

Verificar:

1. alteração afeta somente tipo 4?
2. pode afetar tipos 1, 2 ou 3?
3. multiempresa continua protegido?
4. código continua estável?
5. Unidade continua coerente?
6. Material continua opcional?
7. não foi criada Grade?
8. não foi criada lógica comercial?
9. exclusão continua protegida?
10. Auditoria permanece?
11. Ficha Técnica continua consistente?
12. Estoque não foi duplicado?

---

# 84. Checklist antes de Alterar Frontend

Verificar:

1. tela continua exclusiva para Insumos;
2. `tipo_produto = '4'`;
3. não aparecem campos comerciais indevidos;
4. Material continua opcional;
5. Unidade continua correta;
6. seleção/listagem seguem padrão SYSVAR;
7. filtros continuam funcionando;
8. paginação continua funcionando;
9. consulta usa dados atuais;
10. permissões permanecem respeitadas.

---

# 85. Checklist antes de Alterar Estoque

Verificar:

1. cadastro continua sem localização fixa;
2. não foi criado `controla_estoque`;
3. saldo deriva de movimentos;
4. Empresa está correta;
5. Unidade está correta;
6. entrada e saída são rastreáveis;
7. movimentos não são duplicados;
8. Insumo em poder de terceiro não será confundido com baixa definitiva.

---

# 86. Checklist antes de Alterar Compras

Verificar:

1. Insumo Ativo pode ser selecionado quando permitido;
2. Empresa está correta;
3. Unidade é interpretada corretamente;
4. recebimento gera efeitos corretos;
5. custos vêm de fonte real;
6. Estoque recebe no local operacional;
7. outros tipos de Produto não foram afetados.

---

# 87. Checklist antes de Alterar Ficha Técnica

Verificar:

1. somente Insumos permitidos são selecionados;
2. multiempresa permanece protegido;
3. quantidade pertence ao Item da Ficha;
4. Unidade é respeitada;
5. quantidade decimal é validada;
6. Insumo inativo não entra em nova composição;
7. Fichas históricas permanecem intactas;
8. mesmo Insumo pode participar de várias Fichas.

---

# 88. Checklist antes de Alterar Ordem de Produção

Verificar:

1. criar OP não deve baixar material sem regra aprovada;
2. reserva não deve ser presumida;
3. consumo previsto e real estão separados;
4. cada movimento será rastreável;
5. não haverá baixa duplicada;
6. sobra terá tratamento correto;
7. perda terá tratamento correto;
8. facção terá origem/destino corretos;
9. custos não serão calculados com Unidade incompatível.

---

# 89. Checklist antes de Alterar Facção

Verificar:

1. envio gera movimento;
2. origem é identificada;
3. destino é identificado;
4. quantidade é identificada;
5. material continua pertencendo à Empresa;
6. retorno gera movimento;
7. sobra é rastreada;
8. perda é rastreada;
9. cadastro do Insumo não é alterado para representar localização.

---

# 90. Regras que Não Devem Ser Reintroduzidas

Não introduzir sem nova decisão funcional:

1. Grade comercial;
2. Cor × Tamanho comercial;
3. SKU comercial obrigatório;
4. Coleção obrigatória;
5. preço de venda obrigatório;
6. Promoção;
7. PDV;
8. Bloqueio de Venda;
9. Material obrigatório;
10. localização fixa;
11. `controla_estoque`;
12. quantidade de Ficha Técnica no cadastro do Insumo;
13. baixa automática ao criar OP;
14. reserva automática ao criar OP;
15. conversão de Unidade implícita;
16. perda universal no cadastro;
17. facção fixa no cadastro.

---

# 91. Baseline Homologada

A baseline funcional é:

[[Homologação - Produtos - Insumos]]

A baseline técnica é:

[[Mapa Técnico - Produtos - Insumos]]

Os fluxos homologados são:

[[Workflows - Produtos - Insumos]]

O modelo conceitual é:

[[Modelo de Domínio - Produtos - Insumos]]

Esses documentos devem ser analisados em conjunto antes de mudanças estruturais.

---

# 92. Estado Final

**Insumos está IMPLEMENTADO E HOMOLOGADO.**

Os principais cuidados são:

- preservar `tipo_produto = '4'`;
- preservar isolamento multiempresa;
- não confundir Insumo com Uso/Consumo;
- não transformar Insumo em Produto Venda;
- manter Material opcional;
- respeitar Unidade;
- preservar natureza de Estoque;
- manter localização fora do cadastro;
- manter quantidade produtiva na Ficha Técnica;
- não baixar ou reservar automaticamente ao criar OP;
- proteger exclusão;
- preservar relações históricas.

A regra central continua sendo:

~~~text
INSUMO
define qual é o material.

FICHA TÉCNICA
define quanto é previsto.

ESTOQUE
define quanto existe e onde está.

PRODUÇÃO
define quanto realmente foi utilizado.
~~~

---

# 93. Navegação Documental

## Insumos

- [[Homologação - Produtos - Insumos]]
- [[Mapa Técnico - Produtos - Insumos]]
- [[Workflows - Produtos - Insumos]]
- [[Modelo de Domínio - Produtos - Insumos]]

## Outros Produtos

- [[Homologação - Produtos - Produto Venda]]
- [[Homologação - Produtos - Produto Uso e Consumo]]

## Cadastros Auxiliares

- [[Homologação - Produtos - Cadastros Auxiliares]]

## Projeto

- [[Sysvar]]