---
type: risks-and-care
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
  - riscos
  - auditoria
  - multiempresa
  - homologado
---

# Riscos e Cuidados - Produtos - Produto Uso e Consumo

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
- [[Modelo de Domínio - Produtos - Produto Uso e Consumo]]
- [[Homologação - Produtos - Produto Venda]]
- [[Homologação - Produtos - Insumos]]
- [[Homologação - Produtos - Cadastros Auxiliares]]

---

# 2. Objetivo

Este documento registra os principais riscos técnicos, funcionais, operacionais e arquiteturais relacionados ao **Produto Uso/Consumo** do [[Sysvar]].

Deve ser consultado antes de alterações relevantes em:

- `Produto`;
- serializers;
- views;
- endpoints;
- migrations;
- geração do código;
- Unidade;
- NCM;
- Dados Fiscais;
- Estoque;
- Compras;
- custos;
- lifecycle;
- exclusão;
- Histórico Funcional;
- Auditoria Central;
- permissões;
- frontend de Produto Uso/Consumo.

O objetivo é impedir que evoluções futuras modifiquem silenciosamente regras já definidas e homologadas.

As regras do domínio estão em:

[[Modelo de Domínio - Produtos - Produto Uso e Consumo]]

Os fluxos estão em:

[[Workflows - Produtos - Produto Uso e Consumo]]

---

# 3. Classificação de Impacto

Os riscos deste documento utilizam:

~~~text
CRÍTICO
ALTO
MÉDIO
BAIXO
~~~

## CRÍTICO

Pode causar:

- vazamento entre Empresas;
- corrupção da identidade do Produto;
- associação cross-tenant;
- perda de histórico;
- inconsistência de Estoque;
- alteração indevida de registros já utilizados;
- exposição indevida em outros módulos.

## ALTO

Pode causar:

- quebra de regra homologada;
- utilização incorreta do Produto;
- erro fiscal;
- estoque incorreto;
- mistura com Produto Venda ou Insumo;
- perda de rastreabilidade.

## MÉDIO

Pode causar:

- comportamento operacional inadequado;
- UX confusa;
- informação incompleta;
- duplicidade de lógica;
- manutenção difícil.

## BAIXO

Normalmente relacionado a:

- apresentação;
- conveniência;
- melhoria futura;
- otimização sem impacto imediato na integridade.

---

# 4. Risco — Quebra do Isolamento Multiempresa

Todo Produto Uso/Consumo pertence a uma Empresa.

Devem respeitar o mesmo contexto:

- Produto;
- Unidade;
- Dados Fiscais;
- histórico;
- operações de Compras;
- Estoque;
- custos;
- movimentações;
- demais relações empresariais.

Exemplo inválido:

~~~text
Produto Empresa A
+
Unidade ou operação Empresa B
~~~

Impacto:

**CRÍTICO**

Cuidados:

- filtrar QuerySets pela Empresa;
- validar ForeignKeys;
- validar IDs recebidos;
- nunca confiar apenas nos combos do frontend;
- manter proteção no backend.

---

# 5. Risco — Confiar Apenas no Frontend

O fato de a tela mostrar apenas registros da Empresa atual não representa proteção suficiente.

Uma requisição pode ser manipulada.

Impacto:

**CRÍTICO**

Cuidados:

- revalidar Empresa em toda operação;
- backend permanece autoridade;
- não confiar em IDs recebidos;
- validar relacionamentos no servidor.

---

# 6. Risco — Misturar Uso/Consumo com Produto Venda

Produto Uso/Consumo não é Produto Venda simplificado.

Não deve herdar automaticamente:

- Grade;
- Cor;
- Tamanho;
- SKU comercial;
- EAN obrigatório;
- Coleção;
- Tabela de Preço;
- Promoção;
- PDV;
- bloqueio de venda.

Impacto:

**ALTO**

Cuidados:

- preservar `tipo_produto = '2'`;
- separar telas e regras;
- não copiar regras de Produto Venda sem decisão funcional;
- revisar filtros de produtos comercializáveis.

---

# 7. Risco — Misturar Uso/Consumo com Insumo

Produto Uso/Consumo também não é Insumo de Produção.

Diferença central:

~~~text
Uso/Consumo
→ utilização interna

Insumo
→ componente de fabricação
~~~

Impacto:

**ALTO**

Cuidados:

- não disponibilizar tipo 2 na Ficha Técnica;
- não consumir tipo 2 automaticamente em Ordem de Produção;
- preservar tipo 4 para Insumos.

Referência:

[[Homologação - Produtos - Insumos]]

---

# 8. Risco — Alterar o Tipo do Produto

Um Produto criado como:

~~~text
tipo_produto = '2'
~~~

não deve ser convertido arbitrariamente em:

~~~text
1
3
4
~~~

Impacto:

**CRÍTICO**

Pode comprometer:

- histórico;
- integrações;
- Estoque;
- Compras;
- Fiscal;
- regras de tela.

Cuidado:

**tipo deve permanecer imutável após a criação.**

---

# 9. Risco — Alterar o Código

O código:

~~~text
USO-XXXXXX
~~~

é identidade funcional do Produto.

Alterá-lo posteriormente quebra rastreabilidade.

Impacto:

**ALTO**

Cuidados:

- código somente leitura após criação;
- edição não deve regenerá-lo;
- ativação/inativação não deve alterá-lo.

---

# 10. Risco — Reutilizar Código

Um código anteriormente utilizado não deve ser atribuído a outro Produto.

Exemplo incorreto:

~~~text
USO-000120
Produto excluído
↓
novo Produto recebe USO-000120
~~~

Impacto:

**ALTO**

Cuidados:

- sequência deve continuar avançando;
- exclusão não deve retroceder contador;
- não calcular próximo código por simples quantidade de registros.

---

# 11. Risco — Concorrência na Geração da Sequência

Duas inclusões simultâneas podem tentar utilizar o mesmo próximo código se a geração não for protegida.

Impacto:

**CRÍTICO**

Cuidados:

- geração no backend;
- operação transacional;
- bloqueio apropriado da sequência;
- restrição de unicidade;
- não gerar código apenas no frontend.

---

# 12. Risco — Criar Grade para Uso/Consumo

Grade não pertence ao domínio homologado de Produto Uso/Consumo.

Impacto:

**ALTO**

Consequências possíveis:

- criação desnecessária de SKU;
- confusão com Produto Venda;
- aumento de complexidade;
- quebra de filtros e integrações.

Cuidado:

**não adicionar Grade sem nova decisão funcional formal.**

---

# 13. Risco — Criar Cor × Tamanho

Produto Uso/Consumo não utiliza variações comerciais.

Impacto:

**ALTO**

Não criar:

~~~text
Produto
+ Cor
+ Tamanho
= SKU
~~~

para tipo 2.

---

# 14. Risco — Exigir EAN

EAN não é requisito obrigatório para cadastrar Produto Uso/Consumo.

Impacto:

**MÉDIO/ALTO**

Pode bloquear cadastro legítimo de itens como:

- material de limpeza;
- material administrativo;
- peças de manutenção;
- itens internos sem código de barras.

Cuidado:

não reutilizar automaticamente a regra de EAN do Produto Venda.

---

# 15. Risco — Adicionar Coleção

Coleção pertence ao contexto de Produto Venda/moda.

Produto Uso/Consumo não deve depender de:

- ano;
- estação;
- sequência de coleção;
- referência `AA-BB-CCDDD`.

Impacto:

**MÉDIO**

Cuidado:

manter código próprio `USO-XXXXXX`.

---

# 16. Risco — Tornar Grupo/Subgrupo Obrigatórios

Grupo/Subgrupo não fazem parte das obrigações homologadas deste cadastro.

Impacto:

**MÉDIO**

Cuidado:

não adicionar dependência apenas para reutilizar estrutura de Produto Venda.

---

# 17. Risco — Exigir Material

Material não integra o escopo obrigatório de Uso/Consumo.

Impacto:

**MÉDIO**

Cuidado:

não confundir com Insumo, onde Material pode ter função classificatória.

---

# 18. Risco — Tornar NCM Obrigatório no Cadastro

NCM é opcional no cadastro inicial.

Impacto:

**ALTO**

Torná-lo obrigatório impediria a criação de produtos ainda não preparados fiscalmente.

Cuidado:

usar o conceito:

**Fiscal Incompleto**

para identificar pendências.

---

# 19. Risco — Confundir Fiscal Incompleto com Produto Inválido

Fiscal Incompleto é uma situação gerencial.

Não significa que o cadastro não possa existir.

Impacto:

**ALTO**

Fluxo correto:

~~~text
Cadastro pode ser salvo
        ↓
Fiscal Incompleto
        ↓
Operação fiscal valida o necessário
~~~

---

# 20. Risco — Não Validar Fiscal na Operação Real

Permitir Fiscal Incompleto no cadastro não significa permitir documento fiscal inválido.

Impacto:

**CRÍTICO**

Cuidados:

- entrada fiscal valida campos necessários;
- emissão valida campos necessários;
- processo operacional bloqueia quando faltar dado obrigatório.

---

# 21. Risco — Criar Campo `controla_estoque`

A regra homologada não possui:

~~~text
controla_estoque = Sim/Não
~~~

Impacto:

**ALTO**

Esse campo poderia criar dois comportamentos paralelos para o mesmo domínio.

Cuidado:

Produto Uso/Consumo é naturalmente passível de controle de Estoque.

---

# 22. Risco — Fixar Estoque na Matriz

A ideia de estoque obrigatório na Matriz foi descartada.

Não deve voltar a existir regra:

~~~text
Produto Uso/Consumo
→ estoque somente na Matriz
~~~

Impacto:

**ALTO**

A localização deve ser definida pela operação.

---

# 23. Risco — Colocar Localização no Cadastro do Produto

Produto representa **o que é o item**.

Local de estoque representa **onde ele está**.

Impacto:

**ALTO**

Separação correta:

~~~text
Produto
!=
Localização de Estoque
~~~

Cuidado:

deixar Compras, recebimento, transferência e movimentações determinarem o local.

---

# 24. Risco — Criar Saldo no Cadastro

O cadastro não deve gerar saldo simplesmente porque o Produto foi criado.

Impacto:

**ALTO**

Saldo deve ser consequência de movimentos reais.

~~~text
Entradas - Saídas = Saldo
~~~

---

# 25. Risco — Inventar Movimentações

A consulta pode possuir área de movimentações.

Se não houver fonte real, não criar dados artificiais.

Impacto:

**ALTO**

Cuidado:

apresentar claramente:

~~~text
Nenhuma movimentação registrada
~~~

quando for o caso.

---

# 26. Risco — Duplicar Lógica de Estoque

Produto Uso/Consumo não deve criar uma segunda arquitetura de estoque.

Impacto:

**CRÍTICO**

Cuidados:

- reutilizar estruturas oficiais;
- saldo calculado pelos processos existentes;
- não criar tabela paralela apenas para tipo 2;
- manter consistência com o módulo Estoque.

---

# 27. Risco — Misturar Cadastro e Recebimento

O cadastro de Produto não deve:

- receber mercadoria;
- gerar saldo;
- lançar NF;
- atualizar custo de compra artificialmente.

Impacto:

**ALTO**

Essas responsabilidades pertencem aos processos operacionais.

---

# 28. Risco — Misturar Cadastro e Compras

Produto Uso/Consumo pode participar de Pedido de Compra.

Isso não significa que o cadastro de Produto deva implementar regras de Pedido.

Impacto:

**MÉDIO/ALTO**

Separação:

~~~text
Produto
→ identidade cadastral

Compras
→ aquisição
~~~

---

# 29. Risco — Criar Pedido de Compra Exclusivo sem Necessidade

A existência do tipo 2 não obriga arquitetura permanente de Pedido exclusiva para Uso/Consumo.

Impacto:

**MÉDIO**

A decisão de unificação ou separação pertence ao módulo Compras.

---

# 30. Risco — Atualizar Custos sem Evento Real

Custos devem refletir eventos reais.

Impacto:

**ALTO**

Não:

- inventar última compra;
- recalcular custo médio no cadastro;
- preencher custo com valor arbitrário.

O processo responsável deve atualizar custos.

---

# 31. Risco — Expor Produto Uso/Consumo no PDV

Produto Uso/Consumo não é comercializável.

Impacto:

**CRÍTICO**

Cuidados:

- filtros de PDV devem excluir tipo 2;
- consultas comerciais devem trabalhar com tipos permitidos;
- não depender somente de esconder o item no frontend.

---

# 32. Risco — Incluir em Tabela de Preço Comercial

Produto Uso/Consumo não necessita preço de venda.

Impacto:

**ALTO**

Cuidado:

não criar obrigatoriedade de Tabela de Preço para tipo 2.

---

# 33. Risco — Incluir em Promoções

Promoções comerciais destinam-se a Produtos comercializáveis.

Impacto:

**ALTO**

Produto Uso/Consumo não deve aparecer como item promocional ao consumidor.

---

# 34. Risco — Incluir na Ficha Técnica

Produto Uso/Consumo não representa matéria-prima de fabricação.

Impacto:

**CRÍTICO**

Cuidado:

filtros da Ficha Técnica devem utilizar Insumos apropriados.

---

# 35. Risco — Consumir em Ordem de Produção

Não deve haver consumo automático de Produto Uso/Consumo em OP como componente produtivo.

Impacto:

**CRÍTICO**

Para produção utilizar o domínio documentado em:

[[Homologação - Produtos - Insumos]]

---

# 36. Risco — Criar Bloqueio de Venda

Produto Uso/Consumo possui lifecycle simples:

~~~text
ATIVO
INATIVO
~~~

Não necessita:

~~~text
Bloquear Venda
Desbloquear Venda
~~~

Impacto:

**MÉDIO**

Esse comportamento pertence ao Produto Venda.

---

# 37. Risco — Excluir Produto já Utilizado

Excluir fisicamente Produto com dependências pode quebrar:

- Pedido de Compra;
- NF;
- Estoque;
- movimentos;
- histórico;
- custos;
- Auditoria.

Impacto:

**CRÍTICO**

Cuidado:

quando houver utilização operacional:

**INATIVAR**

---

# 38. Risco — Confundir Inativação com Exclusão

Inativação preserva identidade.

Exclusão remove registro.

Impacto:

**ALTO**

Não implementar exclusão como atalho para limpar cadastros antigos.

---

# 39. Risco — Apagar Histórico na Inativação

Produto inativo continua possuindo história.

Impacto:

**CRÍTICO**

Não apagar:

- histórico funcional;
- compras anteriores;
- movimentações;
- custos;
- registros fiscais;
- auditoria.

---

# 40. Risco — Misturar Históricos de Tipos Diferentes

Histórico de Produto Uso/Consumo deve permanecer coerente com seu domínio.

Impacto:

**ALTO**

Não apresentar eventos específicos de:

- Cor;
- Tamanho;
- SKU;
- Bloqueio de Venda;

como se pertencessem ao tipo 2.

---

# 41. Risco — Confundir Histórico Funcional e AuditLog

As estruturas possuem objetivos diferentes.

~~~text
Histórico Funcional
→ evolução compreensível do cadastro

AuditLog
→ rastreabilidade sistêmica
~~~

Impacto:

**MÉDIO/ALTO**

Não substituir uma pela outra sem análise.

---

# 42. Risco — Consulta Usar Snapshot Desatualizado

Abrir a consulta apenas com o objeto da linha pode apresentar dados antigos.

Impacto:

**MÉDIO**

Cuidado:

~~~text
seleção
→ ID
→ backend
→ detalhe atual
~~~

---

# 43. Risco — Edição Usar Dados Desatualizados

O mesmo cuidado vale para edição.

Impacto:

**ALTO**

Antes de editar, buscar o registro atual pelo ID quando o fluxo já oferece endpoint de detalhe.

---

# 44. Risco — Paginação Client-Side em Base Grande

Carregar todos os Produtos para depois paginar no navegador degrada desempenho.

Impacto:

**MÉDIO/ALTO**

Cuidado:

usar paginação server-side.

---

# 45. Risco — Indicadores Baseados Apenas na Página Atual

Cards como:

- Total;
- Ativos;
- Inativos;
- Fiscal Incompleto;

não devem representar apenas os registros visíveis da página atual.

Impacto:

**MÉDIO**

O cálculo deve representar corretamente o conjunto da Empresa.

---

# 46. Risco — Filtro de Tipo Incorreto

A tela de Produto Uso/Consumo deve trabalhar com:

~~~text
tipo_produto = '2'
~~~

Impacto:

**CRÍTICO**

Se o filtro falhar, podem aparecer:

- Produto Venda;
- Fabricação Própria;
- Insumos.

---

# 47. Risco — Cross-Tenant por Unidade

Uma Unidade enviada pelo frontend pode pertencer a outra Empresa.

Impacto:

**CRÍTICO**

Cuidado:

backend deve validar o relacionamento.

---

# 48. Risco — Cross-Tenant em Operações Futuras

O mesmo cuidado deve ser aplicado futuramente a:

- Estoque;
- local;
- Centro de Custo;
- Pedido;
- movimento;
- documento fiscal.

Impacto:

**CRÍTICO**

---

# 49. Risco — Transferir Produto entre Empresas alterando FK

Não se deve transformar Produto da Empresa A em Produto da Empresa B apenas alterando sua Empresa.

Impacto:

**CRÍTICO**

Cada tenant deve preservar sua própria identidade cadastral.

---

# 50. Risco — Alteração de Banco sem Migração Adequada

Mudanças no model Produto podem afetar vários tipos de Produto simultaneamente.

Impacto:

**CRÍTICO**

Cuidados:

- analisar todos os tipos;
- criar migration adequada;
- revisar defaults;
- evitar alteração destrutiva;
- testar dados existentes.

---

# 51. Risco — Regra Específica no Model Compartilhado

Como Produto é estrutura compartilhada, uma alteração pensada apenas para Uso/Consumo pode quebrar:

- Revenda;
- Fabricação Própria;
- Insumo.

Impacto:

**CRÍTICO**

Cuidado:

condicionar regras pelo domínio correto sem contaminar outros tipos.

---

# 52. Risco — Regra Genérica Demais

O problema inverso também existe.

Uma regra de Produto Venda pode ser aplicada a todos os Produtos indevidamente.

Impacto:

**CRÍTICO**

Exemplos perigosos:

- exigir Grade para todos;
- exigir Grupo/Subgrupo para todos;
- exigir EAN;
- exigir Coleção.

---

# 53. Risco — Frontend Compartilhado Contaminar Fluxos

Componentes ou services compartilhados podem introduzir campos indevidos na tela de Uso/Consumo.

Impacto:

**MÉDIO/ALTO**

Cuidado:

reutilizar infraestrutura sem perder separação funcional.

---

# 54. Risco — Criar Regra Apenas no Frontend

Validação visual não substitui domínio.

Impacto:

**CRÍTICO**

Exemplo:

~~~text
frontend impede Unidade de outra Empresa
mas API aceita
~~~

Isso permanece vulnerável.

Backend deve validar.

---

# 55. Risco — Mensagens de Erro Genéricas

Erros como:

~~~text
Erro ao salvar
~~~

sem indicar a causa dificultam homologação e operação.

Impacto:

**MÉDIO**

Cuidado:

preservar mensagens úteis de validação.

---

# 56. Risco — Transformar Fiscal Incompleto em Alerta Bloqueante Permanente

O indicador deve orientar.

Não deve impedir toda operação sem analisar a necessidade real.

Impacto:

**ALTO**

A validação pertence ao contexto da operação.

---

# 57. Risco — Duplicar Dados Fiscais

Não criar segunda estrutura fiscal exclusiva para tipo 2 sem necessidade.

Impacto:

**ALTO**

Cuidado:

reutilizar a autoridade fiscal existente.

---

# 58. Risco — Hardcode de Empresa, Loja ou Matriz

Não utilizar IDs fixos como:

~~~text
empresa_id = 1
loja_id = 1
matriz_id = 1
~~~

Impacto:

**CRÍTICO**

Toda resolução deve ocorrer pelo contexto real da operação.

---

# 59. Risco — Hardcode de Tipo em Locais Errados

O tipo 2 deve ser fixado onde define o domínio da funcionalidade.

Não espalhar `2` sem contexto por todo o sistema.

Impacto:

**MÉDIO/ALTO**

Cuidado:

centralizar constantes quando apropriado e manter semântica clara.

---

# 60. Risco — Alterar Nomenclatura sem Atualizar Links

A nomenclatura funcional oficial é:

**Produto Uso/Consumo**

Os arquivos do Obsidian utilizam:

**Produto Uso e Consumo**

no nome físico para evitar `/` no filename.

Impacto:

**MÉDIO**

Cuidado:

preservar exatamente os links:

- [[Homologação - Produtos - Produto Uso e Consumo]]
- [[Mapa Técnico - Produtos - Produto Uso e Consumo]]
- [[Workflows - Produtos - Produto Uso e Consumo]]
- [[Modelo de Domínio - Produtos - Produto Uso e Consumo]]
- [[Riscos e Cuidados - Produtos - Produto Uso e Consumo]]

---

# 61. Risco — Quebrar Navegação do Obsidian

Alterar nomes de arquivos sem atualizar backlinks cria documentação fragmentada.

Impacto:

**MÉDIO**

Cuidados:

- manter nomes padronizados;
- revisar links ao renomear;
- usar os nomes exatos definidos no conjunto documental.

---

# 62. Risco — Documentação Divergir da Implementação

Documentação deve refletir o estado homologado.

Impacto:

**ALTO**

Antes de alteração futura relevante:

1. implementar;
2. testar;
3. homologar;
4. atualizar documentação.

Não documentar regra futura como se já estivesse vigente.

---

# 63. Risco — Reintroduzir Regra Cancelada

Duas decisões canceladas merecem atenção especial:

~~~text
estoque obrigatório na Matriz
controla_estoque = Sim/Não
~~~

Impacto:

**ALTO**

Essas regras não pertencem ao estado homologado.

---

# 64. Risco — Ampliar Escopo do Cadastro

O cadastro não deve absorver funções de:

- Compras;
- Recebimento;
- Estoque;
- Fiscal;
- Consumo Interno;
- Transferência.

Impacto:

**ALTO**

Separação modular deve ser preservada.

---

# 65. Risco — Criar Consumo Interno sem Movimento

Uma futura baixa de consumo precisa gerar movimento de Estoque.

Impacto:

**CRÍTICO**

Não reduzir saldo diretamente sem rastreabilidade.

---

# 66. Risco — Transferência sem Origem e Destino

Uma futura transferência deve registrar corretamente:

- origem;
- destino;
- Produto;
- quantidade;
- data;
- responsável.

Impacto:

**CRÍTICO**

Não resolver transferência alterando cadastro do Produto.

---

# 67. Risco — Centro de Custo no Lugar Errado

Centro de Custo poderá ser relevante no consumo futuro.

Isso não significa que precise ser obrigatório no cadastro do Produto.

Impacto:

**MÉDIO**

A relação pode pertencer ao movimento de consumo.

---

# 68. Risco — Produto Inativo em Nova Operação

Processos futuros devem definir claramente se Produtos inativos podem ser selecionados.

Impacto:

**ALTO**

Regra recomendada:

- preservar operações históricas;
- impedir novas utilizações quando o processo exigir Produto ativo.

---

# 69. Risco — Reativação Criar Novo Registro

Reativar deve recuperar o mesmo Produto.

Impacto:

**ALTO**

Deve preservar:

- ID;
- código;
- Empresa;
- histórico.

---

# 70. Risco — Exclusão em Cascata

Cascade delete pode apagar dependências importantes.

Impacto:

**CRÍTICO**

Revisar cuidadosamente qualquer alteração em `on_delete`.

Para dados históricos, proteção costuma ser preferível.

---

# 71. Risco — Falta de Teste Cross-Tenant

Uma feature pode funcionar visualmente e ainda possuir vulnerabilidade multiempresa.

Impacto:

**CRÍTICO**

Testes importantes:

~~~text
Empresa A não consulta Produto B
Empresa A não edita Produto B
Empresa A não exclui Produto B
Empresa A não vincula relação da Empresa B
~~~

---

# 72. Risco — Testar Apenas Caminho Feliz

Cadastro correto não é suficiente.

Impacto:

**ALTO**

Também testar:

- campos obrigatórios ausentes;
- Unidade inválida;
- cross-tenant;
- código duplicado;
- Produto inativo;
- exclusão protegida;
- NCM ausente;
- fiscal incompleto.

---

# 73. Risco — Ignorar Dados Legados

Mudanças futuras devem considerar registros existentes.

Impacto:

**ALTO**

Cuidados:

- migrations seguras;
- defaults coerentes;
- compatibilidade;
- não assumir banco vazio.

---

# 74. Risco — Alterar Service Compartilhado sem Revisão

Mudanças em services genéricos de Produtos podem afetar outros tipos.

Impacto:

**ALTO**

Revisar consumidores antes de alterar contratos.

---

# 75. Risco — Alterar Serializer Compartilhado sem Revisão

O mesmo vale para serializers.

Impacto:

**CRÍTICO**

Uma obrigatoriedade adicionada genericamente pode quebrar tipos 1, 2, 3 ou 4.

---

# 76. Risco — Alterar Filtros Globais

Filtros de Produto são usados em vários módulos.

Impacto:

**ALTO**

Exemplo:

um ajuste para mostrar Uso/Consumo em Compras não pode fazê-lo aparecer no PDV.

---

# 77. Risco — Confundir Disponibilidade de Compra com Disponibilidade de Venda

Produto Uso/Consumo pode estar disponível para Compras e indisponível para PDV ao mesmo tempo.

Impacto:

**ALTO**

Esses contextos são independentes.

---

# 78. Risco — Usar Status Fiscal como Status Operacional

Fiscal Incompleto não significa Inativo.

Impacto:

**ALTO**

Separação:

~~~text
Status Operacional
→ Ativo/Inativo

Situação Fiscal
→ Completo/Incompleto
~~~

---

# 79. Risco — Misturar Unidade de Medida e Estabelecimento

`Unidade` significa unidade de medida.

Não significa Loja ou estabelecimento.

Impacto:

**MÉDIO**

Preservar nomenclatura clara.

---

# 80. Risco — Remover Produto da Listagem ao Inativar

Inativo não significa inexistente.

Impacto:

**MÉDIO**

A tela deve permitir consultar registros inativos por filtros adequados.

---

# 81. Risco — Perder Filtros após Consulta/Edição

Não é risco de domínio, mas afeta operação.

Impacto:

**BAIXO/MÉDIO**

Quando possível, preservar:

- filtro;
- página;
- ordenação;
- contexto da listagem.

---

# 82. Risco — Excesso de Regras no Cadastro

O cadastro deve permanecer simples.

Impacto:

**MÉDIO**

Antes de adicionar campo, perguntar:

~~~text
Isso define o Produto?
ou
Isso pertence a uma operação?
~~~

Se pertencer à operação, não deve necessariamente entrar no cadastro.

---

# 83. Checklist antes de Alterar Backend

Antes de modificar backend relacionado a Produto Uso/Consumo, verificar:

1. a mudança afeta apenas tipo 2?
2. pode afetar tipos 1, 3 ou 4?
3. multiempresa continua protegido?
4. código continua imutável?
5. sequência continua segura?
6. Unidade continua validada?
7. fiscal incompleto continua permitido?
8. Estoque continua separado do cadastro?
9. exclusão continua protegida?
10. histórico permanece íntegro?

---

# 84. Checklist antes de Alterar Frontend

Verificar:

1. tela continua exclusiva para tipo 2;
2. não foram adicionados campos de Produto Venda;
3. não foram adicionados campos de Insumo;
4. filtros continuam server-side;
5. consulta busca dados atuais;
6. edição busca dados atuais;
7. permissões continuam respeitadas;
8. mensagens de erro continuam visíveis;
9. Ativo/Inativo permanece correto;
10. Fiscal Incompleto continua distinto de Status.

---

# 85. Checklist antes de Alterar Estoque

Verificar:

1. o cadastro continua sem localização fixa;
2. não foi reintroduzida Matriz obrigatória;
3. não foi criado `controla_estoque`;
4. movimento possui origem correta;
5. movimento possui destino quando necessário;
6. Empresa está consistente;
7. saldo deriva de operações reais;
8. histórico não é perdido.

---

# 86. Checklist antes de Alterar Compras

Verificar:

1. Produto Uso/Consumo pode ser selecionado quando permitido;
2. Produto Venda não foi afetado indevidamente;
3. Insumo continua distinto;
4. Empresa está correta;
5. recebimento gera efeitos operacionais corretos;
6. custos são atualizados por fonte real;
7. Estoque recebe no local definido pela operação.

---

# 87. Checklist antes de Alterar Fiscal

Verificar:

1. NCM continua opcional no cadastro;
2. Fiscal Incompleto continua permitido;
3. operação fiscal valida campos obrigatórios;
4. dados não são duplicados;
5. multiempresa permanece protegido.

---

# 88. Checklist antes de Alterar Produção

Regra principal:

~~~text
Produto Uso/Consumo NÃO é Insumo
~~~

Verificar:

- tipo 2 não aparece na Ficha Técnica;
- tipo 2 não é consumido automaticamente na OP;
- tipo 4 permanece responsável pelos Insumos.

---

# 89. Checklist antes de Alterar PDV

Regra principal:

~~~text
Produto Uso/Consumo NÃO é vendável
~~~

Verificar:

- tipo 2 não aparece na pesquisa de produtos do PDV;
- não recebe preço comercial obrigatório;
- não participa de promoção;
- não possui Bloqueio de Venda.

---

# 90. Regras que Não Devem Ser Reintroduzidas

Não reintroduzir:

1. Grade;
2. Cor × Tamanho;
3. SKU comercial obrigatório;
4. EAN obrigatório;
5. Coleção;
6. Grupo/Subgrupo obrigatório;
7. Material obrigatório;
8. Tabela de Preço obrigatória;
9. Promoção;
10. PDV;
11. Ficha Técnica;
12. Bloqueio de Venda;
13. estoque fixo na Matriz;
14. `controla_estoque`.

---

# 91. Baseline Homologada

A baseline funcional é definida por:

[[Homologação - Produtos - Produto Uso e Consumo]]

A baseline técnica é definida por:

[[Mapa Técnico - Produtos - Produto Uso e Consumo]]

Os fluxos são definidos por:

[[Workflows - Produtos - Produto Uso e Consumo]]

O domínio é definido por:

[[Modelo de Domínio - Produtos - Produto Uso e Consumo]]

Alterações futuras devem considerar esse conjunto como uma unidade documental.

---

# 92. Estado Final

**Produto Uso/Consumo está IMPLEMENTADO E HOMOLOGADO.**

Os maiores cuidados para sua evolução são:

- preservar isolamento multiempresa;
- preservar o tipo 2;
- não transformá-lo em Produto Venda;
- não transformá-lo em Insumo;
- preservar o código `USO-XXXXXX`;
- manter o cadastro sem localização fixa de estoque;
- não reintroduzir `controla_estoque`;
- preservar Fiscal Incompleto;
- impedir venda no PDV;
- impedir uso produtivo na Ficha Técnica;
- proteger exclusão e histórico.

---

# 93. Navegação Documental

## Produto Uso/Consumo

- [[Homologação - Produtos - Produto Uso e Consumo]]
- [[Mapa Técnico - Produtos - Produto Uso e Consumo]]
- [[Workflows - Produtos - Produto Uso e Consumo]]
- [[Modelo de Domínio - Produtos - Produto Uso e Consumo]]

## Outros Produtos

- [[Homologação - Produtos - Produto Venda]]
- [[Homologação - Produtos - Insumos]]

## Cadastros Auxiliares

- [[Homologação - Produtos - Cadastros Auxiliares]]

## Projeto

- [[Sysvar]]