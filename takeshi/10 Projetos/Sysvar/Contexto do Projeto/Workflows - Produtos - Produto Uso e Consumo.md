---
type: workflows
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
  - workflows
  - auditoria
  - multiempresa
  - homologado
---

# Workflows - Produtos - Produto Uso e Consumo

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
- [[Modelo de Domínio - Produtos - Produto Uso e Consumo]]
- [[Riscos e Cuidados - Produtos - Produto Uso e Consumo]]
- [[Homologação - Produtos - Produto Venda]]
- [[Homologação - Produtos - Insumos]]
- [[Homologação - Produtos - Cadastros Auxiliares]]

---

# 2. Objetivo

Este documento descreve os principais fluxos funcionais e operacionais do cadastro de **Produto Uso/Consumo** do [[Sysvar]].

Produto Uso/Consumo representa itens adquiridos para utilização interna pela empresa.

Os workflows documentados abrangem:

- abertura da listagem;
- paginação;
- filtros;
- indicadores;
- criação;
- geração do código;
- validação de campos obrigatórios;
- Unidade;
- dados fiscais;
- Fiscal Incompleto;
- consulta;
- edição;
- ativação;
- inativação;
- exclusão protegida;
- histórico funcional;
- Auditoria Central;
- integração conceitual com Compras;
- entrada de estoque;
- custos;
- movimentações;
- isolamento multiempresa.

As regras homologadas estão registradas em:

[[Homologação - Produtos - Produto Uso e Consumo]]

A estrutura técnica correspondente está em:

[[Mapa Técnico - Produtos - Produto Uso e Consumo]]

A visão conceitual das entidades e relações está em:

[[Modelo de Domínio - Produtos - Produto Uso e Consumo]]

---

# 3. Princípios Gerais dos Workflows

Todo fluxo de Produto Uso/Consumo deve respeitar:

1. backend é autoridade das regras;
2. Produto pertence a uma Empresa;
3. isolamento multiempresa é obrigatório;
4. `tipo_produto = '2'`;
5. código é gerado automaticamente;
6. código é imutável;
7. Produto Uso/Consumo não utiliza Grade;
8. não utiliza Cor × Tamanho;
9. não exige SKU comercial;
10. não exige EAN para cadastro;
11. não utiliza Coleção;
12. não participa do PDV;
13. não participa da Ficha Técnica;
14. não é Insumo de Produção;
15. Unidade é obrigatória;
16. NCM pode ser opcional no cadastro;
17. Fiscal Incompleto não impede criação;
18. todo Produto Uso/Consumo possui natureza de estoque;
19. o cadastro não define o local do estoque;
20. o local é determinado pela operação;
21. lifecycle é Ativo/Inativo;
22. não existe Bloquear Venda;
23. exclusão física deve ser protegida;
24. histórico funcional deve ser preservado;
25. Auditoria Central permanece independente;
26. filtros e paginação devem ser processados no backend;
27. o cadastro não deve redesenhar Compras, Fiscal ou Estoque.

---

# 4. Workflow — Abrir Produto Uso/Consumo

~~~text
Usuário acessa Produtos
        ↓
Seleciona Produto Uso/Consumo
        ↓
Frontend verifica permissão
        ↓
Solicita primeira página
        ↓
Backend identifica Empresa
        ↓
Aplica isolamento multiempresa
        ↓
Aplica filtros padrão
        ↓
Aplica paginação
        ↓
Retorna resultados
        ↓
Frontend apresenta listagem
~~~

A listagem deve apresentar apenas registros pertencentes ao contexto autorizado da Empresa.

---

# 5. Workflow — Listagem Server-Side

~~~text
Frontend
   ↓
Solicita Produtos Uso/Consumo
   ↓
Parâmetros:
- página
- tamanho da página
- busca
- código
- descrição
- unidade
- NCM
- status
- fiscal incompleto
- ordenação
   ↓
Backend
   ↓
Força tipo_produto = '2'
   ↓
Aplica Empresa
   ↓
Aplica filtros
   ↓
Aplica ordenação
   ↓
Aplica paginação
   ↓
Retorna results + count
   ↓
Frontend apresenta
~~~

Não carregar todos os produtos da Empresa para paginar localmente.

---

# 6. Workflow — Busca Geral

~~~text
Usuário informa termo
        ↓
Frontend envia busca
        ↓
Backend restringe à Empresa
        ↓
Backend restringe ao tipo 2
        ↓
Pesquisa nos campos suportados
        ↓
Aplica paginação
        ↓
Retorna resultados
~~~

A busca deve manter o isolamento de Empresa e o tipo funcional correto.

---

# 7. Workflow — Filtrar por Código

~~~text
Usuário informa código
        ↓
Exemplo:
USO-000125
        ↓
Frontend envia filtro
        ↓
Backend aplica Empresa
        ↓
Backend aplica tipo 2
        ↓
Retorna registros compatíveis
~~~

O código não deve localizar Produto Venda ou Insumo.

---

# 8. Workflow — Filtrar por Descrição

~~~text
Usuário informa descrição
        ↓
Frontend envia filtro
        ↓
Backend restringe à Empresa
        ↓
Pesquisa descrição
        ↓
Aplica paginação
        ↓
Retorna resultados
~~~

---

# 9. Workflow — Filtrar por Unidade

~~~text
Usuário escolhe Unidade
        ↓
Frontend envia identificador
        ↓
Backend valida contexto da Empresa
        ↓
Filtra Produtos Uso/Consumo
        ↓
Retorna resultados
~~~

A Unidade não pode provocar vazamento de registros entre Empresas.

---

# 10. Workflow — Filtrar por NCM

~~~text
Usuário informa ou seleciona NCM
        ↓
Frontend envia filtro
        ↓
Backend aplica Empresa
        ↓
Filtra Produtos Uso/Consumo
        ↓
Retorna resultados
~~~

Produtos sem NCM continuam válidos no cadastro.

---

# 11. Workflow — Filtrar por Status

~~~text
Usuário seleciona:
- Ativos
- Inativos
- Todos
        ↓
Frontend envia filtro
        ↓
Backend aplica Empresa
        ↓
Retorna conjunto correspondente
~~~

---

# 12. Workflow — Filtrar Fiscal Incompleto

~~~text
Usuário seleciona Fiscal Incompleto
        ↓
Frontend envia filtro
        ↓
Backend identifica Produtos tipo 2
com dados fiscais incompletos
        ↓
Aplica Empresa
        ↓
Retorna resultados
~~~

O filtro auxilia a preparação fiscal sem impedir o cadastro inicial.

---

# 13. Workflow — Indicadores

Indicadores homologados:

~~~text
Total
Ativos
Inativos
Fiscal Incompleto
~~~

Fluxo:

~~~text
Tela é carregada
        ↓
Frontend solicita indicadores
        ↓
Backend identifica Empresa
        ↓
Considera somente Produto Uso/Consumo
        ↓
Calcula indicadores
        ↓
Retorna resultados
        ↓
Frontend apresenta cards
~~~

Nenhum indicador deve contabilizar registros de outra Empresa.

---

# 14. Workflow — Novo Produto Uso/Consumo

~~~text
Usuário clica Novo
        ↓
Frontend abre formulário
        ↓
Define internamente tipo_produto = '2'
        ↓
Usuário informa:
- descrição
- descrição reduzida
- unidade
- dados fiscais opcionais
- observações
        ↓
Frontend envia cadastro
        ↓
Backend identifica Empresa
        ↓
Valida campos
        ↓
Gera código USO-XXXXXX
        ↓
Salva Produto
        ↓
Registra histórico/auditoria quando aplicável
        ↓
Retorna Produto criado
        ↓
Frontend atualiza listagem
~~~

O frontend não deve permitir alteração manual da sequência.

---

# 15. Workflow — Geração do Código

~~~text
Solicitação de criação
        ↓
Backend identifica Empresa
        ↓
Obtém próxima sequência
        ↓
Incrementa contador de forma segura
        ↓
Monta código:
USO-XXXXXX
        ↓
Valida unicidade
        ↓
Persiste Produto
~~~

Exemplo:

~~~text
USO-000001
USO-000002
USO-000003
~~~

O código não deve ser reutilizado.

---

# 16. Workflow — Código por Empresa

~~~text
Empresa A
   ↓
USO-000001
USO-000002

Empresa B
   ↓
USO-000001
USO-000002
~~~

A sequência pode ser independente por Empresa.

O isolamento deve permanecer garantido pelo backend.

---

# 17. Workflow — Validação da Descrição

~~~text
Usuário informa descrição
        ↓
Frontend envia
        ↓
Backend valida presença
        ↓
Vazio?
   ├── Sim → rejeitar
   └── Não → continuar
~~~

Limite funcional:

~~~text
120 caracteres
~~~

---

# 18. Workflow — Validação da Descrição Reduzida

~~~text
Usuário informa descrição reduzida
        ↓
Backend valida
        ↓
Vazia?
   ├── Sim → rejeitar
   └── Não → continuar
~~~

Limite:

~~~text
60 caracteres
~~~

---

# 19. Workflow — Seleção de Unidade

~~~text
Frontend solicita Unidades
        ↓
Backend aplica Empresa
        ↓
Retorna Unidades permitidas
        ↓
Usuário seleciona Unidade
        ↓
Frontend envia ID
        ↓
Backend valida pertencimento/contexto
        ↓
Unidade válida?
   ├── Sim → continuar
   └── Não → rejeitar
~~~

A estrutura do cadastro auxiliar é documentada em:

[[Homologação - Produtos - Cadastros Auxiliares]]

---

# 20. Workflow — Cadastro sem NCM

~~~text
Usuário cadastra Produto
        ↓
Não informa NCM
        ↓
Demais obrigatórios estão válidos?
   ├── Não → rejeitar
   └── Sim → salvar
        ↓
Produto pode ficar como Fiscal Incompleto
~~~

NCM não é requisito absoluto para criação do registro.

---

# 21. Workflow — Cadastro com NCM

~~~text
Usuário seleciona NCM
        ↓
Frontend envia NCM
        ↓
Backend valida
        ↓
NCM válido?
   ├── Não → rejeitar
   └── Sim → persistir
~~~

---

# 22. Workflow — Fiscal Incompleto

~~~text
Produto é salvo
        ↓
Backend/estrutura avalia dados fiscais
        ↓
Existem campos fiscais ainda pendentes?
   ├── Sim → Fiscal Incompleto
   └── Não → Fiscal adequado ao cadastro
~~~

Fiscal Incompleto é informação gerencial.

Não significa que o cadastro seja inválido.

---

# 23. Workflow — Complementar Dados Fiscais

~~~text
Usuário seleciona Produto
        ↓
Clica Editar
        ↓
Sistema busca dados atuais
        ↓
Usuário completa:
- NCM
- origem
- ICMS
- CFOP
- PIS
- COFINS
- IPI
conforme campos existentes
        ↓
Frontend envia alteração
        ↓
Backend valida
        ↓
Salva
        ↓
Registra histórico/auditoria
        ↓
Atualiza situação Fiscal Incompleto
~~~

---

# 24. Workflow — Validação em Operação Fiscal

O cadastro pode permitir fiscal incompleto.

Uma operação fiscal real deve validar suas próprias exigências.

~~~text
Produto Uso/Consumo
com fiscal incompleto
        ↓
Participa de operação fiscal
        ↓
Operação verifica campos necessários
        ↓
Dados suficientes?
   ├── Sim → prosseguir
   └── Não → impedir operação e informar pendência
~~~

Não transferir toda essa responsabilidade para o cadastro.

---

# 25. Workflow — Consultar Produto

~~~text
Usuário seleciona Produto
        ↓
Clica Consultar
        ↓
Frontend obtém ID
        ↓
Solicita detalhe ao backend
        ↓
Backend:
- identifica Empresa
- valida permissão
- confirma tipo 2
        ↓
Retorna dados atuais
        ↓
Frontend abre consulta
        ↓
Apresenta informações somente leitura
~~~

A consulta deve utilizar dados atuais do backend.

---

# 26. Workflow — Consulta Consolidada

A consulta pode reunir:

~~~text
Produto Uso/Consumo
        │
        ├── Identificação
        ├── Unidade
        ├── Fiscal
        ├── Custos
        ├── Observações
        ├── Histórico
        └── Movimentações existentes
~~~

Não apresentar estruturas artificiais de:

- Grade;
- Cor;
- Tamanho;
- SKU comercial;
- preço de venda;
- promoção.

---

# 27. Workflow — Editar Produto

~~~text
Usuário seleciona Produto
        ↓
Clica Editar
        ↓
Frontend obtém ID
        ↓
Busca dados atuais
        ↓
Backend valida Empresa e tipo
        ↓
Frontend carrega formulário
        ↓
Usuário altera campos permitidos
        ↓
Frontend envia atualização
        ↓
Backend valida
        ↓
Salva
        ↓
Registra histórico
        ↓
Registra auditoria
        ↓
Frontend atualiza listagem
~~~

---

# 28. Workflow — Código na Edição

~~~text
Produto existente
        ↓
Código USO-XXXXXX
        ↓
Usuário edita Produto
        ↓
Código permanece inalterado
~~~

O código é identidade estável.

---

# 29. Workflow — Ativar Produto

~~~text
Produto INATIVO
        ↓
Usuário seleciona registro
        ↓
Solicita Ativar
        ↓
Backend valida:
- Empresa
- permissão
- tipo
        ↓
Altera status
        ↓
Produto ATIVO
        ↓
Registra histórico/auditoria
~~~

---

# 30. Workflow — Inativar Produto

~~~text
Produto ATIVO
        ↓
Usuário seleciona registro
        ↓
Solicita Inativar
        ↓
Backend valida:
- Empresa
- permissão
- tipo
        ↓
Altera status
        ↓
Produto INATIVO
        ↓
Registra histórico/auditoria
~~~

Inativar preserva identidade e histórico.

---

# 31. Workflow — Ausência de Bloqueio de Venda

Para Produto Uso/Consumo não existe workflow:

~~~text
Bloquear Venda
Desbloquear Venda
~~~

Motivo:

~~~text
Produto Uso/Consumo
        ↓
não é item comercializável
        ↓
não participa do PDV
~~~

Não adicionar esse lifecycle futuramente sem redefinição formal de domínio.

---

# 32. Workflow — Solicitar Exclusão

~~~text
Usuário seleciona Produto
        ↓
Solicita Excluir
        ↓
Frontend pede confirmação
        ↓
Backend identifica Empresa
        ↓
Valida permissão
        ↓
Verifica dependências
~~~

---

# 33. Workflow — Exclusão sem Dependências

~~~text
Produto nunca utilizado
        ↓
Sem dependências protegidas
        ↓
Exclusão solicitada
        ↓
Backend permite
        ↓
Produto removido
        ↓
Auditoria registra operação
~~~

Mesmo após exclusão, o código anterior não deve ser reaproveitado para outro Produto.

---

# 34. Workflow — Exclusão com Dependências

~~~text
Produto possui uso operacional
        ↓
Exclusão solicitada
        ↓
Backend detecta dependência
        ↓
Bloqueia exclusão
        ↓
Retorna motivo
        ↓
Usuário deve utilizar Inativar
~~~

A integridade histórica tem prioridade sobre conveniência de exclusão.

---

# 35. Workflow — Histórico Funcional

~~~text
Alteração relevante
        ↓
Backend identifica:
- Produto
- Empresa
- usuário
- campo
- valor anterior
- valor novo
- data/hora
        ↓
Persiste histórico
        ↓
Consulta futura apresenta alteração
~~~

O histórico ajuda a compreender a evolução cadastral do Produto.

---

# 36. Workflow — Visualizar Histórico

~~~text
Usuário consulta Produto
        ↓
Acessa Histórico
        ↓
Frontend solicita registros
        ↓
Backend aplica Empresa e Produto
        ↓
Retorna eventos
        ↓
Frontend apresenta cronologia
~~~

Uma apresentação adequada deve permitir interpretar:

~~~text
Campo
valor anterior → valor novo
~~~

---

# 37. Workflow — Auditoria Central

~~~text
Usuário executa ação relevante
        ↓
Backend processa operação
        ↓
Auditoria Central recebe:
- usuário
- Empresa
- entidade
- ação
- identificação
- data/hora
- contexto disponível
        ↓
Registro preservado
~~~

A Auditoria Central não substitui o histórico funcional.

---

# 38. Workflow — Produto e Estoque

Produto Uso/Consumo possui natureza de estoque.

Não existe decisão cadastral:

~~~text
Controla Estoque?
Sim / Não
~~~

O fluxo correto é:

~~~text
Produto cadastrado
        ↓
Disponível para operações de estoque
        ↓
Movimentações reais definem saldos
~~~

---

# 39. Workflow — Definição do Local de Estoque

O cadastro não escolhe onde o produto ficará armazenado.

~~~text
Produto cadastrado
        ↓
Operação de entrada
        ↓
Operação informa Empresa/Estabelecimento/local aplicável
        ↓
Sistema registra estoque no contexto da operação
~~~

Não existe regra obrigatória de Matriz no cadastro.

---

# 40. Workflow — Compra de Produto Uso/Consumo

~~~text
Produto Uso/Consumo ATIVO
        ↓
Pedido de Compra
        ↓
Produto selecionado como item
        ↓
Fornecedor
        ↓
Quantidades / preços
        ↓
Pedido segue fluxo de Compras
~~~

As regras completas pertencem ao módulo Compras.

O cadastro apenas disponibiliza o Produto.

---

# 41. Workflow — Recebimento

~~~text
Pedido / Documento de entrada
        ↓
Recebimento operacional
        ↓
Identifica Produto Uso/Consumo
        ↓
Identifica Empresa/Estabelecimento
        ↓
Valida documento
        ↓
Gera entrada
        ↓
Atualiza estoque
        ↓
Atualiza custos quando aplicável
~~~

Não realizar essa lógica diretamente no formulário de Produto.

---

# 42. Workflow — Entrada Fiscal

~~~text
Documento fiscal
        ↓
Item corresponde a Produto Uso/Consumo
        ↓
Sistema valida dados fiscais necessários
        ↓
Vincula à Empresa
        ↓
Processa entrada
        ↓
Estoque / custos / demais integrações
~~~

A exigência fiscal é definida pelo processo de entrada.

---

# 43. Workflow — Atualização de Custos

~~~text
Evento real de custo
ex.: recebimento
        ↓
Sistema obtém valor
        ↓
Aplica regra de custos existente
        ↓
Atualiza campos correspondentes
        ↓
Consulta passa a apresentar valor atualizado
~~~

Não gerar custo fictício apenas para preencher a tela.

---

# 44. Workflow — Movimentações

~~~text
Operação de estoque
        ↓
Gera movimento
        ↓
Relaciona:
- Produto
- Empresa
- local
- quantidade
- tipo de movimento
- data/hora
        ↓
Consulta pode apresentar movimentação
~~~

Somente apresentar dados quando houver fonte real.

---

# 45. Workflow — Produto sem Movimentação

~~~text
Produto cadastrado
        ↓
Ainda não recebeu entrada
        ↓
Consulta Movimentações
        ↓
Nenhum registro encontrado
        ↓
Frontend informa ausência de movimentações
~~~

Não fabricar eventos fictícios.

---

# 46. Workflow — Não Participar do PDV

~~~text
PDV solicita produtos vendáveis
        ↓
Backend aplica tipos comerciais
        ↓
tipo_produto = '2'
        ↓
Produto Uso/Consumo é excluído do conjunto vendável
~~~

Não deve ser vendido ao cliente pelo fluxo normal.

---

# 47. Workflow — Não Participar de Promoção

~~~text
Promoção comercial
        ↓
Busca Produtos comercializáveis
        ↓
Produto Uso/Consumo
        ↓
Não participa
~~~

---

# 48. Workflow — Não Participar de Tabela de Preço Comercial

~~~text
Tabela de Preço de Venda
        ↓
Produtos destinados à comercialização
        ↓
Produto Uso/Consumo
        ↓
Não exige preço comercial
~~~

---

# 49. Workflow — Não Participar da Ficha Técnica

~~~text
Ficha Técnica
        ↓
Selecionar componentes de produção
        ↓
Produto Uso/Consumo
        ↓
Não deve ser tratado como componente
~~~

Para componentes produtivos, utilizar:

[[Homologação - Produtos - Insumos]]

---

# 50. Workflow — Diferença para Insumo

~~~text
O item será incorporado ou consumido
diretamente para fabricar um Produto?
        ↓
       SIM
        ↓
      Insumo

        OU

O item será utilizado internamente
sem compor o produto fabricado?
        ↓
       SIM
        ↓
Produto Uso/Consumo
~~~

Exemplo:

~~~text
Tecido para produzir camisa
→ Insumo

Papel para o escritório
→ Uso/Consumo
~~~

---

# 51. Workflow — Proteção Multiempresa na Consulta

~~~text
Usuário da Empresa A
        ↓
Solicita ID de Produto
        ↓
Backend consulta Produto
        ↓
Produto pertence à Empresa A?
   ├── Sim → retornar
   └── Não → negar/não localizar
~~~

Nunca confiar apenas no fato de o ID ter vindo da interface.

---

# 52. Workflow — Proteção Multiempresa na Edição

~~~text
Usuário envia atualização
        ↓
Backend identifica Empresa autenticada
        ↓
Valida Produto
        ↓
Valida relacionamentos
        ↓
Tudo pertence ao contexto permitido?
   ├── Sim → continuar
   └── Não → rejeitar
~~~

---

# 53. Workflow — Proteção Multiempresa da Unidade

~~~text
Usuário envia unidade_id
        ↓
Backend busca Unidade
        ↓
Unidade disponível para a Empresa?
   ├── Sim → aceitar
   └── Não → rejeitar
~~~

---

# 54. Workflow — Atualizar Listagem após Operação

Após:

- criar;
- editar;
- ativar;
- inativar;
- excluir;

o frontend deve atualizar a lista mantendo a experiência do usuário sempre que possível.

~~~text
Operação concluída
        ↓
Recarrega página atual
        ↓
Mantém filtros aplicáveis
        ↓
Atualiza indicadores
        ↓
Apresenta resultado consistente
~~~

---

# 55. Workflow — Erro de Validação

~~~text
Frontend envia operação
        ↓
Backend detecta erro
        ↓
Retorna mensagem estruturada
        ↓
Frontend apresenta mensagem compreensível
        ↓
Usuário corrige dados
~~~

Não esconder a causa real do erro quando ela puder ser apresentada com segurança.

---

# 56. Workflow — Erro de Permissão

~~~text
Usuário solicita ação
        ↓
Backend valida permissão
        ↓
Não autorizado
        ↓
Operação é negada
        ↓
Frontend informa falta de permissão
~~~

Ocultar botão no frontend é apenas uma camada de UX.

Não substitui autorização backend.

---

# 57. Workflow — Registro Inativo em Processos Futuros

~~~text
Produto INATIVO
        ↓
Processo tenta utilizá-lo como novo item operacional
        ↓
Processo deve respeitar situação
        ↓
Bloquear nova utilização quando a regra do processo exigir
~~~

Históricos anteriores permanecem válidos.

---

# 58. Workflow — Reativação

~~~text
Produto INATIVO
        ↓
Usuário autorizado solicita Ativar
        ↓
Backend altera situação
        ↓
Mantém mesmo ID
        ↓
Mantém mesmo código
        ↓
Mantém histórico
        ↓
Produto volta a ficar ATIVO
~~~

Reativar não cria novo Produto.

---

# 59. Workflow — Não Reutilizar Código

~~~text
USO-000123 foi criado
        ↓
Produto posteriormente excluído
        ↓
Novo Produto é criado
        ↓
Sistema NÃO usa novamente USO-000123
        ↓
Utiliza próxima sequência disponível
~~~

A sequência é histórica.

---

# 60. Workflow — Operação Correta de Estoque

O fluxo conceitual aprovado é:

~~~text
Cadastro
   ↓
Produto existe
   ↓
Compra / Entrada / Transferência / Consumo
   ↓
Operação identifica localização
   ↓
Movimento de estoque
   ↓
Saldo
~~~

O cadastro não deve pular essas etapas.

---

# 61. Workflow — Regra que Não Deve Existir

O fluxo abaixo está proibido:

~~~text
Novo Produto Uso/Consumo
        ↓
Selecionar obrigatoriamente Matriz
        ↓
Fixar estoque na Matriz
~~~

Essa regra foi descartada durante a definição funcional.

---

# 62. Workflow — Regra `controla_estoque` que Não Deve Existir

Também não deve existir:

~~~text
Novo Produto Uso/Consumo
        ↓
Controla estoque?
   ├── Sim
   └── Não
~~~

Produto Uso/Consumo pertence naturalmente ao domínio de estoque.

---

# 63. Workflow — Evolução futura de Compras

Compras deve consumir Produto Uso/Consumo sem alterar sua identidade.

~~~text
Produto Uso/Consumo
        ↓
Pedido de Compra
        ↓
Recebimento
        ↓
Estoque / Custos / Fiscal
~~~

A eventual unificação do Pedido de Compra entre tipos de Produto deve ser definida no módulo Compras.

---

# 64. Workflow — Evolução futura de Consumo Interno

Um processo futuro de baixa por consumo pode utilizar:

~~~text
Produto Uso/Consumo
        ↓
Estoque disponível
        ↓
Solicitação de consumo
        ↓
Centro/local responsável
        ↓
Movimento de saída
        ↓
Novo saldo
~~~

Esse processo não pertence ao cadastro atual.

---

# 65. Workflow — Evolução futura de Transferência

Uma transferência futura pode utilizar:

~~~text
Origem
        ↓
Produto Uso/Consumo
        ↓
Quantidade
        ↓
Destino
        ↓
Saída da origem
        ↓
Entrada no destino
~~~

Novamente, a localização é definida pela operação e não pelo cadastro.

---

# 66. Matriz de responsabilidades

| Processo | Cadastro Produto | Processo Operacional |
|---|---|---|
| Identificar Produto | Sim | Consome |
| Gerar código | Sim | Não |
| Definir descrição | Sim | Não |
| Definir Unidade | Sim | Não |
| Guardar fiscal cadastral | Sim | Consome/valida |
| Definir local de estoque | Não | Sim |
| Gerar saldo | Não | Sim |
| Receber compra | Não | Sim |
| Atualizar custo real | Não | Sim |
| Consumir estoque | Não | Sim |
| Transferir estoque | Não | Sim |
| Emitir documento fiscal | Não | Sim |

---

# 67. Fluxo consolidado

~~~text
CADASTRO
   ↓
Produto Uso/Consumo
tipo = 2
código USO-XXXXXX
   ↓
Disponível para operações
   ↓
┌──────────────┬──────────────┬──────────────┐
│              │              │              │
Compras       Fiscal        Estoque       Auditoria
│              │              │              │
Recebimento   Validação     Entradas       Histórico
│              │            Saídas
Custos         │            Transferências
└──────────────┴──────────────┴──────────────┘
~~~

O cadastro é a origem cadastral.

Os demais módulos são responsáveis pelos eventos operacionais.

---

# 68. Fluxos que Não Pertencem ao Produto Uso/Consumo

Não pertencem a esse cadastro:

~~~text
Produto × Cor × Tamanho
Geração de SKU comercial
EAN por SKU
Coleção
Grade
Pack comercial
Preço de venda
Promoção
PDV
Ficha Técnica
Consumo automático de OP
Bloqueio de Venda
~~~

---

# 69. Cuidados em Alterações Futuras

Antes de alterar qualquer workflow, verificar:

1. se a alteração pertence realmente ao cadastro;
2. se não pertence a Compras;
3. se não pertence a Estoque;
4. se não pertence ao Fiscal;
5. se não pertence à Produção;
6. se o tipo 2 continua isolado;
7. se não está sendo confundido com Insumo;
8. se o código permanecerá estável;
9. se multiempresa permanece protegido;
10. se histórico será preservado.

Os riscos detalhados estão em:

[[Riscos e Cuidados - Produtos - Produto Uso e Consumo]]

---

# 70. Estado final

Os workflows de **Produto Uso/Consumo** estão consolidados e homologados.

A regra central que deve orientar evoluções futuras é:

~~~text
Produto Uso/Consumo é um cadastro de item interno
com identidade própria e natureza de estoque.

O cadastro define O QUE o item é.

As operações definem ONDE ele está
e COMO ele foi movimentado.
~~~

---

# 71. Navegação documental

## Produto Uso/Consumo

- [[Homologação - Produtos - Produto Uso e Consumo]]
- [[Mapa Técnico - Produtos - Produto Uso e Consumo]]
- [[Modelo de Domínio - Produtos - Produto Uso e Consumo]]
- [[Riscos e Cuidados - Produtos - Produto Uso e Consumo]]

## Outros tipos de Produto

- [[Homologação - Produtos - Produto Venda]]
- [[Homologação - Produtos - Insumos]]

## Cadastros auxiliares

- [[Homologação - Produtos - Cadastros Auxiliares]]

## Projeto

- [[Sysvar]]