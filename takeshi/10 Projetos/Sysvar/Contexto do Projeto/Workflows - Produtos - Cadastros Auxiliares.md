---
type: workflows
status: approved
project: Sysvar
group: Produtos
module: Cadastros Auxiliares
phase: Fase 1
created: 2026-08-14
updated: 2026-08-14
tags:
  - sysvar
  - produtos
  - cadastros-auxiliares
  - grupos
  - subgrupos
  - grades
  - tamanhos
  - coleções
  - packs
  - unidades
  - cores
  - material
  - workflows
  - multiempresa
  - homologado
---

# Workflows - Produtos - Cadastros Auxiliares

## 1. Identificação

- **Projeto:** [[Sysvar]]
- **Módulo:** Produtos
- **Escopo:** Cadastros Auxiliares de Produtos
- **Situação:** IMPLEMENTADO E HOMOLOGADO
- **Regras funcionais consolidadas:** 28
- **Data de consolidação documental:** 14/08/2026

### Documentos relacionados

- [[Sysvar]]
- [[Homologação - Produtos - Cadastros Auxiliares]]
- [[Mapa Técnico - Produtos - Cadastros Auxiliares]]
- [[Modelo de Domínio - Produtos - Cadastros Auxiliares]]
- [[Riscos e Cuidados - Produtos - Cadastros Auxiliares]]
- [[Homologação - Produtos - Produto Venda]]
- [[Homologação - Produtos - Produto Uso e Consumo]]
- [[Homologação - Produtos - Insumos]]

---

# 2. Objetivo

Este documento descreve os principais fluxos funcionais e operacionais dos **Cadastros Auxiliares de Produtos** do [[Sysvar]].

O escopo contempla:

- Grupos;
- Subgrupos;
- Grades;
- Tamanhos;
- Coleções;
- Packs;
- Itens de Pack;
- Unidades;
- Cores;
- Material.

Os workflows abrangem:

- abertura de listagens;
- filtros;
- paginação;
- criação;
- consulta;
- edição;
- ativação/inativação quando aplicável;
- exclusão protegida;
- relacionamentos master-detail;
- seleção de linha;
- barra de ações;
- isolamento multiempresa;
- integração com Produto Venda;
- integração com Produto Uso/Consumo;
- integração com Insumos.

As regras homologadas estão registradas em:

[[Homologação - Produtos - Cadastros Auxiliares]]

A estrutura técnica correspondente está em:

[[Mapa Técnico - Produtos - Cadastros Auxiliares]]

---

# 3. Princípios Gerais

Todo fluxo dos Cadastros Auxiliares deve respeitar:

1. backend é autoridade das regras;
2. isolamento multiempresa deve ser preservado;
3. unicidade deve ser validada no backend;
4. relacionamentos filhos dependem do mestre correto;
5. exclusão de registros utilizados deve ser protegida;
6. inativação deve ser utilizada quando aplicável;
7. paginação e filtros devem utilizar backend;
8. seleção única deve identificar o alvo das ações;
9. barra de ações substitui ações redundantes por linha;
10. consulta deve utilizar sobretela/modal quando o padrão da tela assim exigir;
11. cadastros auxiliares não devem absorver responsabilidades operacionais;
12. histórico individual sofisticado não faz parte deste escopo.

---

# 4. Workflow — Abrir um Cadastro Auxiliar

~~~text
Usuário acessa Produtos
        ↓
Seleciona cadastro auxiliar
        ↓
Frontend verifica permissão
        ↓
Solicita primeira página
        ↓
Backend identifica Empresa
        ↓
Aplica filtros
        ↓
Aplica ordenação
        ↓
Aplica paginação
        ↓
Retorna resultados
        ↓
Frontend apresenta listagem
~~~

---

# 5. Workflow — Listagem Server-Side

~~~text
Frontend
   ↓
Envia:
- página
- tamanho da página
- filtros
- busca
- ordenação
   ↓
Backend
   ↓
Aplica Empresa
   ↓
Aplica filtros
   ↓
Aplica ordenação
   ↓
Aplica paginação
   ↓
Retorna count + results
~~~

Não carregar toda a base apenas para paginar localmente.

---

# 6. Workflow — Seleção de Registro

~~~text
Usuário marca checkbox
        ↓
Registro fica selecionado
        ↓
Linha recebe destaque visual
        ↓
Barra de ações passa a atuar sobre esse registro
~~~

O padrão é de seleção única.

---

# 7. Workflow — Troca de Seleção

~~~text
Registro A selecionado
        ↓
Usuário seleciona Registro B
        ↓
Registro A é desmarcado
        ↓
Registro B passa a ser o selecionado
~~~

Não manter múltiplos registros selecionados em telas concebidas para ação única.

---

# 8. Workflow — Consultar

~~~text
Usuário seleciona registro
        ↓
Clica Consultar
        ↓
Frontend utiliza o ID
        ↓
Backend valida Empresa e permissão
        ↓
Retorna dados atuais
        ↓
Frontend abre consulta somente leitura
~~~

Quando adotado o padrão moderno:

~~~text
Consulta
→ sobretela/modal
~~~

---

# 9. Workflow — Editar

~~~text
Usuário seleciona registro
        ↓
Clica Editar
        ↓
Frontend obtém dados atuais
        ↓
Abre formulário
        ↓
Usuário altera campos permitidos
        ↓
Backend valida
        ↓
Salva
        ↓
Atualiza listagem
~~~

---

# 10. Workflow — Excluir

~~~text
Usuário seleciona registro
        ↓
Clica Excluir
        ↓
Frontend solicita confirmação
        ↓
Backend valida:
- Empresa
- permissão
- dependências
        ↓
Pode excluir?
   ├── Sim → excluir
   └── Não → bloquear
~~~

---

# 11. Workflow — Exclusão Protegida

~~~text
Registro utilizado por outra entidade
        ↓
Usuário solicita exclusão
        ↓
Backend detecta dependência
        ↓
Exclusão bloqueada
        ↓
Preservar histórico
~~~

Quando houver lifecycle:

~~~text
Utilizar Inativar
~~~

---

# 12. Workflow — Ativar

~~~text
Registro INATIVO
        ↓
Usuário solicita Ativar
        ↓
Backend valida permissão
        ↓
Atualiza situação
        ↓
Registro ATIVO
~~~

---

# 13. Workflow — Inativar

~~~text
Registro ATIVO
        ↓
Usuário solicita Inativar
        ↓
Backend valida dependências e permissão
        ↓
Atualiza situação
        ↓
Registro INATIVO
~~~

Inativar não deve apagar relações históricas.

---

# 14. Workflow — Grupo

~~~text
Produtos
   ↓
Grupos
   ↓
Listagem
   ↓
Selecionar Grupo
   ↓
Consultar / Editar / Subgrupos / Excluir
~~~

---

# 15. Workflow — Novo Grupo

~~~text
Usuário clica Novo
        ↓
Informa:
- Código
- Descrição
- Código de Referência
- Margem
        ↓
Frontend envia
        ↓
Backend valida Empresa
        ↓
Valida Código
        ↓
Valida Código de Referência
        ↓
Salva Grupo
~~~

---

# 16. Workflow — Validar Código de Referência do Grupo

~~~text
Código informado
        ↓
Possui exatamente 2 dígitos numéricos?
   ├── Não → rejeitar
   └── Sim → verificar unicidade
        ↓
Já existe na Empresa?
   ├── Sim → rejeitar
   └── Não → aceitar
~~~

---

# 17. Workflow — Abrir Subgrupos

~~~text
Usuário seleciona Grupo
        ↓
Clica Subgrupos
        ↓
Frontend abre sobretela
        ↓
Carrega apenas Subgrupos do Grupo selecionado
~~~

O Grupo mestre permanece como contexto do detalhe.

---

# 18. Workflow — Novo Subgrupo

~~~text
Sobretela de Subgrupos aberta
        ↓
Grupo mestre já conhecido
        ↓
Usuário cria Subgrupo
        ↓
Informa:
- Descrição
- Margem
        ↓
Backend associa ao Grupo mestre
        ↓
Salva
~~~

Não permitir criar Subgrupo solto sem Grupo.

---

# 19. Workflow — Selecionar Subgrupo

~~~text
Usuário marca Subgrupo
        ↓
Linha é destacada
        ↓
Barra interna passa a atuar sobre ele
~~~

Ações:

~~~text
Consultar | Editar | Excluir
~~~

---

# 20. Workflow — Excluir Grupo com Subgrupos

~~~text
Grupo possui Subgrupos
        ↓
Usuário solicita Excluir
        ↓
Backend verifica dependências
        ↓
Exclusão deve respeitar integridade
~~~

Não remover em cascata destrutiva sem regra explícita.

---

# 21. Workflow — Grade

~~~text
Produtos
   ↓
Grades
   ↓
Listagem
   ↓
Selecionar Grade
   ↓
Consultar / Editar / Tamanhos / Excluir
~~~

---

# 22. Workflow — Nova Grade

~~~text
Usuário clica Novo
        ↓
Informa dados da Grade
        ↓
Backend valida
        ↓
Salva Grade
~~~

Os Tamanhos são tratados como detalhe.

---

# 23. Workflow — Abrir Tamanhos

~~~text
Usuário seleciona Grade
        ↓
Clica Tamanhos
        ↓
Frontend abre sobretela
        ↓
Carrega Tamanhos vinculados à Grade
~~~

---

# 24. Workflow — Novo Tamanho

~~~text
Grade selecionada
        ↓
Sobretela aberta
        ↓
Usuário cria Tamanho
        ↓
Backend associa à Grade
        ↓
Salva
~~~

Não permitir Tamanho desligado do contexto da Grade.

---

# 25. Workflow — Selecionar Tamanho

~~~text
Usuário seleciona Tamanho
        ↓
Linha destacada
        ↓
Ações:
Consultar | Editar | Excluir
~~~

---

# 26. Workflow — Grade Utilizada

~~~text
Grade já vinculada a Produto/SKU
        ↓
Usuário tenta alteração estrutural
        ↓
Backend avalia impacto
        ↓
Protege integridade
~~~

Não permitir mudança que invalide SKUs históricos.

---

# 27. Workflow — Excluir Grade Utilizada

~~~text
Grade possui dependências
        ↓
Excluir
        ↓
Backend bloqueia
        ↓
Preservar estrutura
~~~

---

# 28. Workflow — Coleção

~~~text
Produtos
   ↓
Coleções
   ↓
Listagem
   ↓
Selecionar Coleção
   ↓
Consultar / Editar / Excluir
~~~

---

# 29. Workflow — Nova Coleção

~~~text
Usuário clica Novo
        ↓
Informa:
- Código
- Estação
- Descrição
- Status
        ↓
Backend valida
        ↓
Salva
~~~

---

# 30. Workflow — Validar Código da Coleção

~~~text
Código informado
        ↓
Possui 2 dígitos?
   ├── Não → rejeitar
   └── Sim → continuar
~~~

Exemplo:

~~~text
26
~~~

---

# 31. Workflow — Validar Estação

~~~text
Estação informada
        ↓
É uma das opções?
01 / 02 / 03 / 04
   ├── Não → rejeitar
   └── Sim → aceitar
~~~

---

# 32. Workflow — Validar Status da Coleção

Valores permitidos:

~~~text
CR
PD
AT
EN
AR
~~~

Outro valor deve ser rejeitado.

---

# 33. Workflow — Contador da Coleção

~~~text
Coleção cadastrada
        ↓
Contador interno é utilizado
pela geração de Referência
        ↓
Usuário não edita manualmente
~~~

---

# 34. Workflow — Coleção em Produto Venda

~~~text
Produto Venda novo
        ↓
Seleciona Coleção
        ↓
Coleção fornece:
- Código
- Estação
        ↓
Participa da Referência
~~~

---

# 35. Workflow — Unidade

~~~text
Produtos
   ↓
Unidades
   ↓
Listagem
   ↓
Consultar / Editar / Excluir
~~~

---

# 36. Workflow — Nova Unidade

~~~text
Usuário clica Novo
        ↓
Informa:
- Código
- Descrição
- Permite Decimal
        ↓
Backend valida Código
        ↓
Valida unicidade
        ↓
Salva
~~~

---

# 37. Workflow — Unidade com Decimal

~~~text
permite_decimal = true
        ↓
Processo consumidor
        ↓
Aceita quantidade fracionária
~~~

Exemplo:

~~~text
1,75 M
~~~

---

# 38. Workflow — Unidade sem Decimal

~~~text
permite_decimal = false
        ↓
Processo consumidor
        ↓
Quantidade deve respeitar regra inteira
~~~

Exemplo:

~~~text
6 UN
~~~

---

# 39. Workflow — Unidade Utilizada

~~~text
Unidade já associada a Produtos
        ↓
Usuário solicita exclusão
        ↓
Backend identifica dependência
        ↓
Bloqueia exclusão
~~~

---

# 40. Workflow — Cor

~~~text
Produtos
   ↓
Cores
   ↓
Listagem
   ↓
Novo / Consultar / Editar / Excluir
~~~

---

# 41. Workflow — Nova Cor

~~~text
Usuário informa dados da Cor
        ↓
Frontend envia
        ↓
Backend valida Código quando utilizado
        ↓
Valida unicidade
        ↓
Salva
~~~

---

# 42. Workflow — Cor em Produto Venda

~~~text
Produto Venda
        ↓
Seleciona Cores
        ↓
Combina com Tamanhos da Grade
        ↓
Gera SKUs
~~~

A geração de SKU pertence ao Produto Venda.

---

# 43. Workflow — Excluir Cor Utilizada

~~~text
Cor já utilizada por Produto/SKU
        ↓
Excluir
        ↓
Backend protege dependência
~~~

Não destruir histórico comercial.

---

# 44. Workflow — Material

~~~text
Produtos
   ↓
Material
   ↓
Listagem
   ↓
Novo / Consultar / Editar / Excluir
~~~

---

# 45. Workflow — Novo Material

~~~text
Usuário informa:
- Código
- Descrição
- Status
        ↓
Backend valida
        ↓
Salva Material
~~~

---

# 46. Workflow — Ativar/Inativar Material

~~~text
Material ATIVO
        ↓
Inativar
        ↓
Material INATIVO
        ↓
Histórico de usos permanece
~~~

Reativação utiliza o mesmo registro.

---

# 47. Workflow — Material em Insumo

~~~text
Usuário cadastra Insumo
        ↓
Material é opcional
        ↓
Seleciona Material ou deixa vazio
        ↓
Backend valida relacionamento
        ↓
Salva Insumo
~~~

---

# 48. Workflow — Pack

~~~text
Produtos
   ↓
Packs
   ↓
Listagem
   ↓
Selecionar Pack
   ↓
Consultar / Editar / Itens / Excluir
~~~

---

# 49. Workflow — Novo Pack

~~~text
Usuário clica Novo
        ↓
Informa:
- Nome
- Grade
- Status
        ↓
Backend valida
        ↓
Salva Pack
~~~

Pack deve pertencer a uma Grade.

---

# 50. Workflow — Abrir Itens do Pack

~~~text
Usuário seleciona Pack
        ↓
Abre detalhe de Itens
        ↓
Frontend carrega Itens do Pack
        ↓
Usuário mantém composição
~~~

---

# 51. Workflow — Novo Item de Pack

~~~text
Pack selecionado
        ↓
Usuário escolhe Tamanho
        ↓
Informa Quantidade
        ↓
Backend valida:
- Tamanho pertence à Grade
- Tamanho não está duplicado
- Quantidade > 0
        ↓
Salva Item
~~~

---

# 52. Workflow — Tamanho Fora da Grade

~~~text
Pack pertence à Grade A
        ↓
Usuário tenta inserir Tamanho da Grade B
        ↓
Backend rejeita
~~~

---

# 53. Workflow — Tamanho Duplicado no Pack

~~~text
Pack já possui M
        ↓
Usuário tenta adicionar M novamente
        ↓
Backend rejeita
~~~

---

# 54. Workflow — Quantidade Inválida no Pack

~~~text
Quantidade <= 0
        ↓
Backend rejeita
~~~

Quantidade válida:

~~~text
> 0
~~~

---

# 55. Workflow — Cálculo de Quantidade do Pack

Exemplo:

~~~text
P = 2
M = 3
G = 2

Total por Pack = 7 peças
~~~

Em uma operação:

~~~text
10 Packs
×
7 peças
=
70 peças
~~~

---

# 56. Workflow — Pack Inativo

~~~text
Pack INATIVO
        ↓
Nova operação
        ↓
Não disponibilizar normalmente para seleção
~~~

Operações históricas permanecem válidas.

---

# 57. Workflow — Excluir Pack Utilizado

~~~text
Pack já utilizado em Pedido
        ↓
Usuário solicita excluir
        ↓
Backend verifica dependência
        ↓
Bloqueia exclusão
~~~

---

# 58. Workflow — Atualizar Listagem após Operação

Após:

- criar;
- editar;
- ativar;
- inativar;
- excluir;

o frontend deve:

~~~text
Recarregar dados
        ↓
Preservar filtros quando possível
        ↓
Preservar contexto de página quando possível
        ↓
Atualizar resultado
~~~

---

# 59. Workflow — Erro de Validação

~~~text
Frontend envia dados
        ↓
Backend identifica erro
        ↓
Retorna mensagem
        ↓
Frontend apresenta ao usuário
        ↓
Usuário corrige
~~~

---

# 60. Workflow — Erro de Permissão

~~~text
Usuário solicita ação
        ↓
Backend verifica permissão
        ↓
Sem autorização
        ↓
Operação bloqueada
~~~

Ocultar botão no frontend não substitui autorização backend.

---

# 61. Workflow — Proteção Multiempresa em Consulta

~~~text
Usuário Empresa A
        ↓
Solicita ID
        ↓
Backend verifica tenant
        ↓
Registro pertence à Empresa A?
   ├── Sim → retornar
   └── Não → negar
~~~

---

# 62. Workflow — Proteção Multiempresa em Relacionamento

Exemplo:

~~~text
Pack Empresa A
        +
Grade Empresa B
        ↓
Backend rejeita
~~~

Outro exemplo:

~~~text
Subgrupo Empresa A
        +
Grupo Empresa B
        ↓
Backend rejeita
~~~

---

# 63. Workflow — Grupo em Produto Venda

~~~text
Produto Venda
        ↓
Seleciona Grupo
        ↓
Seleciona Subgrupo quando aplicável
        ↓
Grupo fornece Código de Referência
        ↓
Referência do Produto é formada
~~~

---

# 64. Workflow — Grade em Produto Venda

~~~text
Produto Venda
        ↓
Seleciona Grade
        ↓
Grade fornece Tamanhos
        ↓
Produto recebe Cores
        ↓
Sistema forma SKUs
~~~

---

# 65. Workflow — Coleção em Produto Venda

~~~text
Produto Venda
        ↓
Seleciona Coleção
        ↓
Código + Estação
        ↓
Participam da Referência
~~~

---

# 66. Workflow — Pack em Compras

~~~text
Produto Venda
        ↓
Seleciona Pack
        ↓
Informa número de Packs
        ↓
Sistema soma itens
        ↓
Calcula quantidade total de peças
~~~

---

# 67. Workflow — Unidade em Produto Uso/Consumo

~~~text
Produto Uso/Consumo
        ↓
Seleciona Unidade
        ↓
Backend valida
        ↓
Salva Produto
~~~

Não herdar Grade, Pack ou Coleção.

---

# 68. Workflow — Unidade em Insumo

~~~text
Insumo
        ↓
Seleciona Unidade
        ↓
Unidade define forma de quantificação
        ↓
Ficha Técnica e Estoque utilizam essa referência
~~~

---

# 69. Workflow — Material em Insumo

~~~text
Insumo
        ↓
Material informado?
   ├── Sim → associar
   └── Não → manter vazio
~~~

Material permanece opcional.

---

# 70. Workflow — Não Transformar Auxiliar em Operação

Fluxo proibido:

~~~text
Cadastro de Unidade
        ↓
Alterar saldo de Estoque
~~~

Outro fluxo proibido:

~~~text
Cadastro de Pack
        ↓
Criar Pedido de Compra
~~~

Outro:

~~~text
Cadastro de Material
        ↓
Baixar Insumo da Produção
~~~

Cada responsabilidade deve permanecer no módulo correto.

---

# 71. Workflow — Master-Detail Consolidado

~~~text
Listagem Mestre
        ↓
Selecionar registro
        ↓
Abrir ação de detalhe
        ↓
Sobretela/modal
        ↓
Listar filhos
        ↓
Selecionar filho
        ↓
Consultar / Editar / Excluir
~~~

Aplicações principais:

~~~text
Grupo → Subgrupos
Grade → Tamanhos
Pack → Itens
~~~

---

# 72. Workflow — Consulta em Sobretela

~~~text
Usuário seleciona registro
        ↓
Consultar
        ↓
Modal/Sobretela
        ↓
Visualização somente leitura
        ↓
Fechar
        ↓
Retorna à mesma listagem
~~~

Preserva o contexto da tela de origem.

---

# 73. Workflow — Padrão Visual

O fluxo visual consolidado é:

~~~text
Listagem
   ↓
Checkbox
   ↓
Seleção única
   ↓
Linha destacada
   ↓
Barra de ações
~~~

Não utilizar simultaneamente:

~~~text
Barra de ações
+
Coluna Ações
+
Menu ⋮
~~~

---

# 74. Workflow — Registro Não Selecionado

~~~text
Nenhum registro selecionado
        ↓
Ação que depende de registro
        ↓
Deve permanecer indisponível
ou
solicitar seleção
~~~

---

# 75. Workflow — Mudança Estrutural Sensível

Antes de alterar registros já utilizados:

~~~text
Usuário solicita edição
        ↓
Backend identifica dependências
        ↓
Alteração pode quebrar histórico?
   ├── Sim → proteger/restringir
   └── Não → permitir
~~~

Exemplos sensíveis:

- Código de Referência;
- Grade;
- Unidade;
- Pack;
- Coleção.

---

# 76. Workflow — Não Regenerar Histórico

Exemplo:

~~~text
Produto Venda já possui Referência
        ↓
Código de Referência do Grupo muda
        ↓
Referência histórica do Produto
NÃO deve ser regenerada automaticamente
~~~

---

# 77. Workflow — Não Reinterpretar Pedido Histórico

~~~text
Pedido utilizou Pack com 7 peças
        ↓
Pack é alterado futuramente
        ↓
Pedido histórico continua representando
a quantidade registrada na operação
~~~

---

# 78. Workflow — Não Reinterpretar Quantidade Histórica

~~~text
Produto/Insumo foi movimentado em Unidade X
        ↓
Cadastro auxiliar sofre alteração
        ↓
Movimentos históricos não devem
mudar de significado silenciosamente
~~~

---

# 79. Workflow — Auditoria

~~~text
Ação relevante
        ↓
Backend processa
        ↓
Auditoria geral registra
quando aplicável
~~~

Não criar obrigatoriamente histórico individual sofisticado para cada auxiliar.

---

# 80. Fluxo Consolidado

~~~text
CADASTROS AUXILIARES
        ↓
┌───────────────┬───────────────┬───────────────┐
│               │               │               │
Grupo/         Grade/         Coleção         Unidade
Subgrupo       Tamanho
│               │               │               │
└───────────────┴───────────────┴───────────────┘
                        ↓
                  PRODUTO VENDA

Material ───────────────→ INSUMOS

Unidade ────────────────→ USO/CONSUMO
Unidade ────────────────→ INSUMOS

Grade
  ↓
Pack
  ↓
Itens
  ↓
COMPRAS DE PRODUTO VENDA
~~~

---

# 81. Workflows Fora do Escopo

Não pertencem aos Cadastros Auxiliares:

- movimentação de Estoque;
- recebimento;
- Pedido de Compra completo;
- emissão fiscal;
- venda;
- baixa produtiva;
- Ordem de Produção;
- Distribuição;
- formação completa de custo;
- precificação final.

---

# 82. Cuidados em Evoluções Futuras

Antes de alterar um Cadastro Auxiliar, verificar:

1. já existem registros utilizando-o?
2. a mudança altera significado histórico?
3. existe relação multiempresa?
4. algum Produto depende dele?
5. alguma operação já gravou sua informação?
6. exclusão é realmente segura?
7. a nova regra pertence ao auxiliar ou a outro módulo?
8. a interface continua seguindo o padrão visual homologado?

Os riscos completos estão em:

[[Riscos e Cuidados - Produtos - Cadastros Auxiliares]]

---

# 83. Estado Final

Os workflows dos **Cadastros Auxiliares de Produtos** estão consolidados e homologados.

A regra central permanece:

~~~text
CADASTRO AUXILIAR
define estrutura.

PRODUTO
utiliza estrutura.

PROCESSO OPERACIONAL
utiliza o Produto.

Cada camada deve permanecer
com sua própria responsabilidade.
~~~

---

# 84. Navegação Documental

## Cadastros Auxiliares

- [[Homologação - Produtos - Cadastros Auxiliares]]
- [[Mapa Técnico - Produtos - Cadastros Auxiliares]]
- [[Modelo de Domínio - Produtos - Cadastros Auxiliares]]
- [[Riscos e Cuidados - Produtos - Cadastros Auxiliares]]

## Produtos

- [[Homologação - Produtos - Produto Venda]]
- [[Homologação - Produtos - Produto Uso e Consumo]]
- [[Homologação - Produtos - Insumos]]

## Projeto

- [[Sysvar]]