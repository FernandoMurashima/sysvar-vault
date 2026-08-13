---
type: workflows
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
  - workflows
  - auditoria
  - multiempresa
  - homologado
---

# Workflows - Produtos - Produto Venda

## 1. Identificação

- **Projeto:** [[Sysvar]]
- **Módulo:** Produtos
- **Funcionalidade:** Produto Venda
- **Tipos contemplados:** Revenda e Fabricação Própria
- **Escopo:** Fase 1 — Cadastro e gestão estrutural
- **Situação:** IMPLEMENTADO E HOMOLOGADO
- **Homologação manual:** 19/19 itens aprovados
- **Data da homologação:** 13/08/2026

### Documentos relacionados

- [[Sysvar]]
- [[Homologação - Produtos - Produto Venda]]
- [[Mapa Técnico - Produtos - Produto Venda]]
- [[Modelo de Domínio - Produtos - Produto Venda]]
- [[Riscos e Cuidados - Produtos - Produto Venda]]

---

# 2. Objetivo

Este documento descreve os principais fluxos funcionais e operacionais do cadastro de Produto Venda do [[Sysvar]].

Produto Venda contempla:

- Revenda;
- Fabricação Própria.

Os workflows documentados abrangem:

- abertura da listagem;
- filtros;
- paginação;
- criação;
- escolha de tipo;
- geração de referência;
- escolha de Grupo/Subgrupo;
- Grade;
- Cores;
- geração de SKUs;
- geração e preservação de EAN;
- seleção de Lojas;
- inicialização de Estoque;
- edição;
- alteração fiscal;
- imagens;
- retirada de Cor;
- reativação de Cor;
- consulta;
- Fabricação Própria;
- inativação;
- ativação;
- bloqueio de venda;
- desbloqueio;
- exclusão;
- Histórico Funcional;
- Auditoria Central.

As regras homologadas estão registradas em:

[[Homologação - Produtos - Produto Venda]]

A estrutura técnica correspondente está em:

[[Mapa Técnico - Produtos - Produto Venda]]

A visão conceitual das entidades e relações está em:

[[Modelo de Domínio - Produtos - Produto Venda]]

---

# 3. Princípios Gerais dos Workflows

Todo fluxo de Produto Venda deve respeitar:

1. backend é autoridade das regras;
2. Produto pertence a uma Empresa;
3. isolamento multiempresa é obrigatório;
4. Produto e SKU são conceitos distintos;
5. SKU representa Produto × Cor × Tamanho;
6. tipo do Produto é imutável após criação;
7. Grade não pode ser alterada após existência de SKUs;
8. retirada de Cor inativa SKU, não exclui;
9. reativação de Cor reutiliza o SKU existente;
10. EAN deve ser preservado;
11. Estoque é controlado por Loja × SKU;
12. Inativo não significa excluído;
13. Bloqueado para venda não significa inativo;
14. Produto utilizado deve preservar histórico;
15. informações fiscais são editáveis e auditadas;
16. Histórico Funcional e Auditoria Central são estruturas distintas;
17. ações sensíveis exigem permissão funcional;
18. motivo e senha permanecem obrigatórios onde definidos;
19. filtros e paginação são processados no backend;
20. Produto Venda não redesenha Compras, Estoque, Produção, Preços, Fiscal ou PDV.

---

# 4. Workflow — Abrir Produto Venda

~~~text
Usuário acessa menu Produtos
        ↓
Seleciona Produto Venda
        ↓
Frontend verifica acesso ao módulo Produtos
        ↓
Solicita primeira página
        ↓
Backend identifica Empresa do usuário
        ↓
Aplica tenant
        ↓
Aplica filtros padrão
        ↓
Aplica ordenação
        ↓
Aplica paginação
        ↓
Frontend apresenta listagem
~~~

A tela não deve carregar todos os Produtos da Empresa para depois paginar localmente.

Esse princípio segue a arquitetura geral documentada em [[Sysvar]].

---

# 5. Workflow — Listagem Server-Side

~~~text
Frontend
   ↓
GET Produtos
   ↓
Parâmetros:
- página
- tamanho da página
- busca
- tipo
- referência
- código
- grupo
- coleção
- status
- bloqueado
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
Retorna results + count
   ↓
Frontend apresenta
~~~

---

# 6. Workflow — Busca Geral

~~~text
Usuário informa termo
        ↓
Frontend envia search
        ↓
Backend limita à Empresa
        ↓
Pesquisa nos campos permitidos
        ↓
Aplica paginação
        ↓
Retorna resultado
~~~

A busca geral não substitui filtros específicos.

---

# 7. Workflow — Filtrar por Referência

~~~text
Usuário informa Referência
        ↓
Frontend envia parâmetro referencia
        ↓
Backend aplica Empresa
        ↓
Filtra Referência
        ↓
Retorna resultado paginado
~~~

Referência deve ser tratada como filtro próprio.

---

# 8. Workflow — Filtrar por Código

~~~text
Usuário informa Código
        ↓
Frontend envia parâmetro codigo
        ↓
Backend aplica Empresa
        ↓
Filtra Código
        ↓
Retorna resultado paginado
~~~

Código e Referência não devem ser concatenados indevidamente em uma única busca.

---

# 9. Workflow — Combinação de Filtros

Exemplo:

~~~text
Grupo = Vestidos
+
Coleção = Verão 2026
+
Status = Ativo
        ↓
Frontend envia filtros separados
        ↓
Backend aplica todos cumulativamente
        ↓
Retorna apenas registros compatíveis
~~~

Combinações foram homologadas em:

[[Homologação - Produtos - Produto Venda]]

---

# 10. Workflow — Paginação

~~~text
Usuário escolhe 10, 20, 50 ou outro tamanho permitido
        ↓
Frontend atualiza page_size
        ↓
Retorna para página coerente
        ↓
Backend executa nova consulta
        ↓
Retorna results + count
        ↓
Frontend mostra:
Mostrando X–Y de Z
~~~

Ao avançar ou voltar página:

~~~text
Página atual
   ↓
Usuário avança/volta
   ↓
Frontend mantém filtros
   ↓
Solicita nova página
   ↓
Backend retorna resultados
~~~

---

# 11. Workflow — Criar Novo Produto Venda

~~~text
Usuário clica Novo
        ↓
Frontend abre formulário
        ↓
Usuário informa dados obrigatórios
        ↓
Seleciona Tipo
        ↓
Seleciona Coleção
        ↓
Seleciona Grupo
        ↓
Seleciona Subgrupo
        ↓
Seleciona Unidade
        ↓
Seleciona Grade
        ↓
Seleciona Cores
        ↓
Seleciona Lojas
        ↓
Preenche Dados fiscais quando necessário
        ↓
Informa preço conforme fluxo existente
        ↓
Seleciona imagens opcionalmente
        ↓
Salva
        ↓
Backend valida tenant e regras
        ↓
Gera Referência
        ↓
Cria Produto
        ↓
Gera/reativa SKUs
        ↓
Gera EAN para novos SKUs
        ↓
Inicializa Estoque nas Lojas selecionadas
        ↓
Frontend envia imagens após obter ID do Produto
        ↓
Produto criado
~~~

---

# 12. Workflow — Escolher Tipo

Tipos disponíveis:

~~~text
1 = Revenda
3 = Fabricação Própria
~~~

Fluxo:

~~~text
Usuário cria Produto
        ↓
Seleciona Tipo
        ↓
Salva Produto
        ↓
Tipo passa a ser imutável
~~~

Depois da criação:

~~~text
Editar Produto
        ↓
Campo Tipo bloqueado
~~~

A regra de domínio está detalhada em:

[[Modelo de Domínio - Produtos - Produto Venda]]

---

# 13. Workflow — Gerar Referência

~~~text
Produto novo
   ↓
Coleção
   ↓
Ano + Estação
   ↓
Grupo
   ↓
CodigoRef
   ↓
Sequência
   ↓
Referência AA-BB-CCDDD
~~~

A referência é gerada automaticamente.

Não deve ser digitada manualmente como fluxo normal.

---

# 14. Workflow — Validar Descrição Reduzida

~~~text
Usuário salva Produto
        ↓
Descrição reduzida vazia?
        ├── Sim → rejeitar
        └── Não → continuar
~~~

Limite:

`60 caracteres`

---

# 15. Workflow — Grupo e Subgrupo

~~~text
Usuário seleciona Grupo
        ↓
Frontend restringe/organiza Subgrupos compatíveis
        ↓
Usuário seleciona Subgrupo
        ↓
Backend valida relação
        ↓
Relação válida?
        ├── Não → rejeitar
        └── Sim → continuar
~~~

Subgrupo é obrigatório.

---

# 16. Workflow — Selecionar Grade

~~~text
Produto novo
        ↓
Usuário seleciona Grade
        ↓
Grade define tamanhos
        ↓
Produto é salvo
        ↓
SKUs são gerados
        ↓
Grade passa a ser protegida
~~~

---

# 17. Workflow — Alterar Grade

~~~text
Usuário edita Produto
        ↓
Existem SKUs?
        ├── Sim → Grade bloqueada
        └── Não → alteração pode seguir conforme regras
~~~

No Produto Venda normal com SKUs já gerados, Grade deve permanecer imutável.

---

# 18. Workflow — Selecionar Cores

~~~text
Usuário abre modal de Cores
        ↓
Pesquisa/seleciona Cores
        ↓
Confirma
        ↓
Frontend compara seleção anterior × nova
        ↓
Identifica incluídas e removidas
        ↓
Salva Produto
        ↓
Backend sincroniza SKUs
~~~

---

# 19. Workflow — Incluir Nova Cor

~~~text
Produto existente
        ↓
Usuário adiciona Cor
        ↓
Backend percorre tamanhos da Grade
        ↓
Para cada Cor × Tamanho:
        ↓
SKU já existia?
   ├── Sim e inativo → reativar
   └── Não → criar novo SKU
        ↓
Se novo SKU:
gerar EAN
~~~

---

# 20. Workflow — Remover Cor

~~~text
Produto existente
        ↓
Usuário remove Cor
        ↓
Salva Produto
        ↓
Backend localiza SKUs daquela Cor
        ↓
Marca SKUs como Inativos
        ↓
Preserva:
- ID
- EAN
- código
- histórico
- movimentações
~~~

Não excluir fisicamente os SKUs.

---

# 21. Workflow — Remover Última Cor

~~~text
Produto possui uma única Cor
        ↓
Usuário remove essa Cor
        ↓
Backend recebe lista vazia
        ↓
Localiza SKUs anteriormente ativos
        ↓
Inativa todos
        ↓
Produto permanece cadastrado
~~~

Esse cenário foi homologado.

---

# 22. Workflow — Reativar Cor

~~~text
Cor foi removida anteriormente
        ↓
Usuário adiciona novamente
        ↓
Backend encontra SKUs antigos
        ↓
Reativa os SKUs
        ↓
Preserva EAN
        ↓
Preserva código do item
~~~

Não criar novo SKU duplicado.

---

# 23. Workflow — Gerar EAN

Para um novo SKU:

~~~text
SKU novo
   ↓
Backend consulta ConfigEan da Empresa
   ↓
Obtém próximo item
   ↓
Monta código
   ↓
Calcula dígito verificador
   ↓
Grava EAN
~~~

EAN deve ser único conforme a estrutura existente.

---

# 24. Workflow — Preservar EAN

~~~text
SKU ativo
   ↓
Cor removida
   ↓
SKU inativo
   ↓
EAN permanece
   ↓
Cor reincluída
   ↓
SKU reativado
   ↓
Mesmo EAN
~~~

Esse é um dos cuidados de integridade destacados também em:

[[Riscos e Cuidados - Produtos - Produto Venda]]

---

# 25. Workflow — Selecionar Lojas

~~~text
Usuário abre modal Selecionar lojas
        ↓
Pode:
- marcar individualmente
- desmarcar
- clicar Todas
- clicar Limpar
        ↓
Confirma seleção
        ↓
Frontend mantém IDs selecionados
~~~

---

# 26. Workflow — Ação Todas

~~~text
Usuário clica Todas
        ↓
Frontend obtém IDs das Lojas disponíveis
        ↓
Marca todas
        ↓
Usuário ainda pode desmarcar uma ou mais
        ↓
Confirma
~~~

---

# 27. Workflow — Inicializar Estoque

~~~text
Produto + SKUs
        ↓
Lojas selecionadas
        ↓
Backend percorre Loja × SKU
        ↓
Cria/prepara estrutura de Estoque
        ↓
Quantidade inicial = 0
~~~

Inicialização não representa entrada física.

---

# 28. Workflow — Consultar Estoque por Loja × SKU

~~~text
Usuário abre Consultar Produto
        ↓
Frontend solicita dados consolidados
        ↓
Backend retorna Estoque relacionado
        ↓
Frontend apresenta:
- Loja
- Cor
- Tamanho
- EAN
- Físico
- Reserva
- Disponível
~~~

---

# 29. Workflow — Calcular Disponível

Conceito:

~~~text
Disponível = Físico - Reserva
~~~

Produto Venda apenas apresenta a estrutura.

As regras finais de reserva e venda pertencem aos módulos operacionais responsáveis.

---

# 30. Workflow — Editar Produto

~~~text
Usuário clica Editar
        ↓
Frontend carrega Produto
        ↓
Carrega:
- dados cadastrais
- fiscal
- Lojas
- Cores
- SKUs
- Imagens
        ↓
Aplica campos protegidos
        ↓
Usuário altera campos permitidos
        ↓
Salva
        ↓
Backend compara alterações
        ↓
Valida regras
        ↓
Grava Produto
        ↓
Registra Histórico Funcional quando aplicável
        ↓
Registra Auditoria Central
~~~

---

# 31. Workflow — Alteração Cadastral

~~~text
Usuário altera campo cadastral relevante
        ↓
PATCH Produto
        ↓
Backend captura before
        ↓
Valida
        ↓
Salva
        ↓
Captura after
        ↓
Existem alterações relevantes?
        ├── Sim → ProdutoVendaHistorico
        │         + AuditLog
        └── Não → não gerar evento redundante
~~~

---

# 32. Workflow — Alteração Fiscal

~~~text
Usuário altera Dados fiscais
        ↓
Frontend envia campos fiscais
        ↓
Backend valida
        ↓
Grava
        ↓
Gera evento ALTERACAO_FISCAL
        ↓
Registra Auditoria Central
~~~

---

# 33. Workflow — Dados Fiscais

Campos utilizados:

- NCM;
- Origem;
- CST/CSOSN ICMS;
- Alíquota ICMS;
- CFOP dentro;
- CFOP fora;
- CST PIS;
- Alíquota PIS;
- CST COFINS;
- Alíquota COFINS;
- Situação IPI;
- Alíquota IPI.

A interface agrupa esses campos em:

**Dados fiscais**

---

# 34. Workflow — Incluir Imagem em Produto Novo

~~~text
Usuário seleciona imagem antes de salvar
        ↓
Frontend mantém arquivo pendente
        ↓
Usuário salva Produto
        ↓
Backend cria Produto
        ↓
Frontend recebe ID
        ↓
Frontend envia FormData para ProdutoImagem
        ↓
Imagem vinculada ao Produto
~~~

---

# 35. Workflow — Incluir Imagem em Produto Existente

~~~text
Produto já possui ID
        ↓
Usuário seleciona imagem
        ↓
Frontend envia FormData
        ↓
Backend valida limite
        ↓
Grava ProdutoImagem
        ↓
Frontend atualiza miniaturas
~~~

---

# 36. Workflow — Limite de Imagens

~~~text
Usuário tenta incluir imagem
        ↓
Quantidade atual + pendentes
        ↓
Total >= 3?
        ├── Sim → impedir quarta imagem
        └── Não → permitir
~~~

O backend também deve proteger o limite.

---

# 37. Workflow — Marcar Imagem Principal

~~~text
Usuário escolhe imagem
        ↓
Clica Principal
        ↓
Frontend chama ação específica
        ↓
Backend remove principal anterior quando necessário
        ↓
Marca nova principal
        ↓
Permanece somente uma principal
~~~

---

# 38. Workflow — Remover Imagem

~~~text
Usuário clica Excluir
        ↓
Imagem já salva?
        ├── Sim → DELETE ProdutoImagem
        └── Pendente → remover apenas da fila local
        ↓
Atualizar visualização
~~~

---

# 39. Workflow — Consultar Imagens

~~~text
Usuário abre Consultar
        ↓
Frontend carrega imagens
        ↓
Existem imagens?
        ├── Sim → mostrar miniaturas
        │         + identificar principal
        └── Não → mostrar
                  "Nenhuma imagem cadastrada"
~~~

---

# 40. Workflow — Imagem Reduzida

~~~text
Imagem possui imagem_reduzida_url?
        ├── Sim → usar reduzida
        └── Não → usar imagem_url
~~~

Nenhum processo futuro deve inventar resolução ou compressão sem decisão técnica específica.

Ver também:

[[Riscos e Cuidados - Produtos - Produto Venda]]

---

# 41. Workflow — Consultar Produto

~~~text
Usuário clica Consultar
        ↓
Frontend abre modo somente leitura
        ↓
Carrega Produto
        ↓
Carrega SKUs
        ↓
Carrega fiscal
        ↓
Carrega Estoque Loja × SKU
        ↓
Carrega Imagens
        ↓
Carrega Histórico Funcional
        ↓
Se tipo 3:
carrega dados de Produção
        ↓
Apresenta consulta consolidada
~~~

---

# 42. Workflow — Consultar Status do SKU

~~~text
Consulta Produto
        ↓
Lista SKUs
        ↓
Para cada SKU:
ativo = true → "Ativo"
ativo = false → "Inativo"
~~~

A interface deve exibir texto.

Não apenas diferenciação visual por cor.

---

# 43. Workflow — Consultar Fabricação Própria

Somente quando:

`tipo_produto = '3'`

~~~text
Produto Fabricação Própria
        ↓
Consulta
        ↓
Frontend carrega Fichas Técnicas
        ↓
Frontend carrega Ordens de Produção
        ↓
Apresenta dados disponíveis
~~~

Informações podem incluir:

- Ficha;
- versão;
- Status;
- ativa;
- OP;
- quantidade;
- custo previsto;
- custo real.

---

# 44. Workflow — Produto Revenda

~~~text
Produto Venda
tipo = 1
        ↓
Cadastro
        ↓
SKUs
        ↓
EAN
        ↓
Pedido de Compra
        ↓
Recebimento
        ↓
Entrada de Estoque
        ↓
Venda
~~~

Compras continua responsável pelo processo de aquisição.

---

# 45. Workflow — Produto Fabricação Própria

~~~text
Produto Venda
tipo = 3
        ↓
Cadastro
        ↓
SKUs
        ↓
EAN
        ↓
Ficha Técnica
        ↓
Ordem de Produção
        ↓
Produção
        ↓
Entrada em Estoque
        ↓
Venda
~~~

Produto Venda não substitui o módulo de Produção.

---

# 46. Workflow — Inativar Produto

~~~text
Usuário clica Inativar
        ↓
Frontend abre confirmação
        ↓
Solicita:
- motivo
- senha
        ↓
Usuário confirma
        ↓
Backend verifica autenticação
        ↓
Backend verifica EDIT em Produtos
        ↓
Permissão válida?
        ├── Não → 403
        └── Sim → continuar
        ↓
Valida motivo
        ↓
Valida senha
        ↓
Marca Produto ativo = false
        ↓
Registra Histórico Funcional
        ↓
Registra Auditoria
~~~

---

# 47. Workflow — Ativar Produto

~~~text
Produto Inativo
        ↓
Usuário clica Ativar
        ↓
Backend verifica permissão funcional
        ↓
Marca ativo = true
        ↓
Registra evento
~~~

Ativação não cria novo Produto.

---

# 48. Workflow — Bloquear Venda

~~~text
Usuário clica Bloquear venda
        ↓
Solicita motivo + senha
        ↓
Backend verifica EDIT em Produtos
        ↓
Valida motivo
        ↓
Valida senha
        ↓
bloqueado_venda = true
        ↓
Histórico Funcional
        ↓
Auditoria
~~~

Produto pode continuar:

`ativo = true`

e simultaneamente:

`bloqueado_venda = true`

---

# 49. Workflow — Desbloquear Venda

~~~text
Produto bloqueado
        ↓
Usuário clica Desbloquear venda
        ↓
Backend verifica permissão
        ↓
bloqueado_venda = false
        ↓
Registra evento
~~~

---

# 50. Workflow — Permissão Funcional

Ações sensíveis utilizam:

`EffectiveAccessService`

Fluxo:

~~~text
Request autenticado
        ↓
CanToggleProductFlags
        ↓
EffectiveAccessService(user)
        ↓
has_module_access("produtos", EDIT)
        ↓
Autorizado?
        ├── Não → HTTP 403
        └── Sim → executar validações da ação
~~~

Não utilizar `is_staff` como regra funcional do ERP.

A regra faz parte do modelo geral de acesso do [[Sysvar]].

---

# 51. Workflow — Usuário sem Permissão

~~~text
Usuário possui apenas VIEW
        ↓
Tenta POST em ação sensível
        ↓
Backend verifica EDIT
        ↓
Acesso negado
        ↓
HTTP 403
~~~

Mesmo que o frontend esconda botões, o backend deve impedir a ação.

---

# 52. Workflow — Senha Inválida

~~~text
Usuário autorizado
        ↓
Informa senha incorreta
        ↓
Backend valida senha
        ↓
Senha inválida
        ↓
HTTP 400
        ↓
Nenhuma alteração no Produto
~~~

Permissão válida não elimina a necessidade de senha quando exigida.

---

# 53. Workflow — Motivo Inválido

~~~text
Usuário autorizado
        ↓
Motivo ausente ou insuficiente
        ↓
Backend valida
        ↓
Rejeita operação
        ↓
Produto permanece inalterado
~~~

---

# 54. Workflow — Excluir Produto Nunca Utilizado

~~~text
Usuário solicita exclusão
        ↓
Backend verifica tenant
        ↓
Verifica relacionamentos
        ↓
Existe movimentação/uso impeditivo?
        ├── Sim → bloquear exclusão
        └── Não → continuar
        ↓
Existem apenas estruturas de Estoque zero?
        ├── Sim → limpar estruturas seguras
        └── Não → continuar
        ↓
Excluir Produto
~~~

---

# 55. Workflow — Bloquear Exclusão de Produto Utilizado

~~~text
Usuário solicita exclusão
        ↓
Backend encontra movimentação ou uso relevante
        ↓
Exclusão física bloqueada
        ↓
Usuário deve utilizar:
- Inativar
ou
- Bloquear venda
~~~

---

# 56. Workflow — Histórico Funcional

~~~text
Evento relevante ocorre
        ↓
Backend identifica tipo
        ↓
Cria ProdutoVendaHistorico
        ↓
Registra:
- Produto
- usuário
- data/hora
- tipo de evento
- descrição
- dados relevantes
~~~

O usuário consulta, mas não edita esse histórico.

---

# 57. Workflow — Auditoria Central

~~~text
Operação relevante
        ↓
AuditService
        ↓
Registra:
- model
- object_id
- usuário
- before
- after
- changed_fields
- metadata
~~~

AuditLog não substitui ProdutoVendaHistorico.

Essa separação também está descrita em:

[[Mapa Técnico - Produtos - Produto Venda]]

---

# 58. Workflow — Multiempresa

~~~text
Request
   ↓
Usuário autenticado
   ↓
Empresa do usuário
   ↓
QuerySet limitado ao tenant
   ↓
Relacionamentos validados
   ↓
Resposta
~~~

Nenhum ID recebido do frontend deve ser aceito automaticamente sem validação de Empresa.

---

# 59. Workflow — Relação com Loja de Outra Empresa

~~~text
Frontend envia Loja
        ↓
Backend localiza objeto
        ↓
Loja pertence à mesma Empresa?
        ├── Não → rejeitar
        └── Sim → permitir
~~~

O mesmo princípio vale para demais relacionamentos multiempresa.

---

# 60. Workflow — Relação com Grupo/Subgrupo de Outra Empresa

~~~text
Produto
        ↓
Grupo/Subgrupo recebido
        ↓
Backend valida Empresa
        ↓
Valida coerência Grupo × Subgrupo
        ↓
Somente então salva
~~~

---

# 61. Workflow — Preço

~~~text
Produto Venda
        ↓
Tabela de Preço selecionada
        ↓
Preço informado/gerenciado
        ↓
Estrutura existente de Preços
~~~

Produto Venda não deve criar motor comercial paralelo.

---

# 62. Workflow — Custos de Revenda

Conceitualmente:

~~~text
Compra
   ↓
Recebimento
   ↓
Custos do SKU
   ↓
Última compra / custo médio
~~~

As regras definitivas pertencem aos processos de Compras e Estoque.

---

# 63. Workflow — Custos de Fabricação Própria

~~~text
Ficha Técnica
   ↓
Ordem de Produção
   ↓
Custos previstos
   ↓
Produção
   ↓
Custos reais
   ↓
Atualização conforme regra existente
~~~

Produto Venda apenas consulta/apresenta esses valores quando aplicável.

---

# 64. Workflow — Produto Disponível para Venda

Conceitualmente, uma operação de Venda deve considerar fatores como:

~~~text
Produto ativo?
        ↓
Não bloqueado para venda?
        ↓
SKU ativo?
        ↓
Estoque disponível conforme regra?
        ↓
Demais validações do PDV
~~~

A decisão definitiva pertence ao módulo de Vendas/PDV.

---

# 65. Workflow — Produto Inativo

~~~text
Produto ativo = false
        ↓
Permanece cadastrado
        ↓
Permanece consultável
        ↓
Preserva SKUs
        ↓
Preserva EAN
        ↓
Preserva histórico
~~~

Não apagar automaticamente estruturas relacionadas.

---

# 66. Workflow — SKU Inativo

~~~text
SKU ativo = false
        ↓
Permanece no banco
        ↓
Permanece no histórico
        ↓
Mantém EAN
        ↓
Pode ser reativado se a Cor voltar
~~~

---

# 67. Workflow — Observações

~~~text
Usuário informa Observações
        ↓
Campo opcional
        ↓
Salva com Produto
~~~

Nenhuma lógica obrigatória deve depender do texto de Observações.

---

# 68. Workflow — Erro de Backend

~~~text
Frontend executa operação
        ↓
Backend retorna erro
        ↓
Frontend extrai detail/mensagem
        ↓
Apresenta ao usuário
~~~

Não substituir mensagem funcional clara por erro genérico quando `detail` estiver disponível.

---

# 69. Workflow — Consulta Somente Leitura

~~~text
Usuário clica Consultar
        ↓
consultando = true
        ↓
Campos são apresentados
        ↓
Controles de alteração ficam ocultos/bloqueados
        ↓
Usuário apenas navega pelas informações
~~~

---

# 70. Workflow — Edição com Permissão

~~~text
Usuário possui EDIT em Produtos
        ↓
Botões de edição disponíveis
        ↓
Backend também valida permissão nas ações protegidas
~~~

Frontend e backend trabalham em conjunto, mas backend permanece autoridade.

---

# 71. Workflow — Usuário Apenas Consulta

~~~text
Usuário possui VIEW
        ↓
Pode acessar listagem/consulta conforme licença e permissões
        ↓
Não deve executar ações de EDIT protegidas
~~~

---

# 72. Workflow — Fluxo Completo de Revenda

~~~text
Cadastrar Produto Venda
        ↓
Tipo Revenda
        ↓
Referência automática
        ↓
Grade + Cores
        ↓
SKUs + EAN
        ↓
Lojas
        ↓
Estrutura de Estoque
        ↓
Pedido de Compra
        ↓
Recebimento
        ↓
Entrada
        ↓
Atualização de custo
        ↓
Preço
        ↓
Venda
~~~

---

# 73. Workflow — Fluxo Completo de Fabricação Própria

~~~text
Cadastrar Produto Venda
        ↓
Tipo Fabricação Própria
        ↓
Referência automática
        ↓
Grade + Cores
        ↓
SKUs + EAN
        ↓
Ficha Técnica
        ↓
Ordem de Produção
        ↓
Produção
        ↓
Custos
        ↓
Entrada no Estoque
        ↓
Preço
        ↓
Venda
~~~

---

# 74. Pontos que Não Pertencem ao Workflow de Produto Venda

Não implementar dentro do cadastro:

- emissão de NFC-e;
- fechamento de venda;
- contingência fiscal;
- compra completa;
- recebimento completo;
- cálculo completo de CMV;
- regras de comissão;
- distribuição;
- facção;
- reserva avançada;
- promoções;
- sincronização offline;
- planejamento comercial.

Produto Venda fornece a estrutura cadastral necessária para que esses processos utilizem o Produto e seus SKUs.

Os limites de escopo e riscos de regressão estão registrados em:

[[Riscos e Cuidados - Produtos - Produto Venda]]

---

# 75. Regras Homologadas que Devem Permanecer

Os fluxos futuros devem preservar:

1. tipo imutável;
2. referência automática;
3. descrição reduzida obrigatória;
4. Grupo obrigatório;
5. Subgrupo obrigatório;
6. Unidade obrigatória;
7. Grade obrigatória;
8. Grade imutável após SKU;
9. Cor cria/reativa SKUs;
10. retirada de Cor inativa;
11. EAN preservado;
12. Estoque Loja × SKU;
13. imagens no máximo 3;
14. uma imagem principal;
15. sem imagem por Cor;
16. sem imagem por SKU;
17. fiscal editável;
18. alteração fiscal auditada;
19. Histórico Funcional;
20. Audit Central;
21. Produto Inativo preservado;
22. Bloqueio de venda independente;
23. exclusão física apenas quando segura;
24. filtros server-side;
25. paginação server-side;
26. tenant no backend;
27. permissão funcional de Produtos;
28. motivo e senha onde exigidos.

---

# 76. Documentação Relacionada

Projeto principal:

[[Sysvar]]

Homologação:

[[Homologação - Produtos - Produto Venda]]

Mapa Técnico:

[[Mapa Técnico - Produtos - Produto Venda]]

Modelo de Domínio:

[[Modelo de Domínio - Produtos - Produto Venda]]

Riscos e Cuidados:

[[Riscos e Cuidados - Produtos - Produto Venda]]

Esses documentos devem permanecer conectados entre si para preservar contexto funcional, técnico e arquitetural no grafo do Obsidian.

---

# 77. Estado Atual

Os workflows descritos neste documento representam o comportamento implementado e homologado do Produto Venda na Fase 1.

Situação:

**IMPLEMENTADO E HOMOLOGADO**

Homologação:

**19/19 itens aprovados**

Commits finais considerados de referência:

Backend:

`574f5badc79ab3a969bf24ffc67904215bdbc49a`

Frontend:

`1be513e4a5d7b3220ae239fee555594307115826`

Este documento deve ser interpretado em conjunto com:

- [[Sysvar]]
- [[Homologação - Produtos - Produto Venda]]
- [[Mapa Técnico - Produtos - Produto Venda]]
- [[Modelo de Domínio - Produtos - Produto Venda]]
- [[Riscos e Cuidados - Produtos - Produto Venda]]