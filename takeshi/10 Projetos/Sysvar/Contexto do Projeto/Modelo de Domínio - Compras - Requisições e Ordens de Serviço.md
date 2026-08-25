---
type: domain-model
status: approved
project: Sysvar
group: Compras
module: Requisições e Ordens de Serviço
phase: Fase 1
created: 2026-08-25
updated: 2026-08-25
tags:
  - sysvar
  - compras
  - requisicoes
  - ordem-de-servico
  - uso-consumo
  - manutencao
  - ti
  - almoxarifado
  - cotacao
  - pedido-de-compra
  - entrada-nfe
  - estoque
  - auditoria
  - multiempresa
  - dominio
  - homologado
---

# Modelo de Domínio - Compras - Requisições e Ordens de Serviço

## 1. Identificação

- **Projeto:** [[Sysvar]]
- **Módulo:** Compras
- **Funcionalidade:** Requisições Internas e Ordens de Serviço
- **Tipos contemplados:** Uso/Consumo, Manutenção e TI
- **Escopo:** Fase 1
- **Situação:** IMPLEMENTADO E HOMOLOGADO
- **Data da homologação:** 25/08/2026

### Documentos relacionados

- [[Sysvar]]
- [[Mapa Técnico - Compras - Requisições e Ordens de Serviço]]
- [[Workflows - Compras - Requisições e Ordens de Serviço]]
- [[Riscos e Cuidados - Compras - Requisições e Ordens de Serviço]]
- [[Homologação - Compras - Requisições e Ordens de Serviço]]

---

# 2. Objetivo do Modelo de Domínio

O domínio de Requisições e Ordens de Serviço representa necessidades internas da Empresa.

Uma necessidade pode ser:

- atendida diretamente por estoque interno;
- executada por Manutenção;
- executada por TI;
- encaminhada para aquisição.

Tipos homologados:

~~~text
USO_CONSUMO
MANUTENCAO
TI
~~~

Separação central:

~~~text
Requisição
→ representa a necessidade

Ordem de Serviço
→ representa a execução

Cotação / Pedido
→ representam aquisição
~~~

---

# 3. Agregados Principais

Os principais agregados são:

~~~text
Requisicao
├── RequisicaoItem
└── Histórico

OrdemServico
└── OrdemServicoMaterial
~~~

Estruturas de configuração relacionadas:

~~~text
RequisicaoSetor
RequisicaoMatrizResponsabilidade
~~~

Integrações externas:

- Empresa;
- Loja;
- Produto;
- Unidade;
- Cotação;
- Fornecedor;
- Pedido de Compra;
- Entrada de NF-e;
- Estoque;
- Auditoria.

---

# 4. Requisição

Entidade principal:

~~~text
Requisicao
~~~

Responsabilidade:

representar uma necessidade interna originada por uma unidade da Empresa.

A Requisição possui contexto como:

- Empresa;
- Loja solicitante;
- Setor solicitante;
- Tipo;
- prioridade;
- motivo;
- necessidade;
- status;
- itens;
- histórico.

A Requisição não representa automaticamente uma compra.

---

# 5. Empresa

Toda Requisição pertence a uma Empresa.

~~~text
Empresa
1
↓
N
Requisições
~~~

A Empresa é o limite do tenant.

Todos os relacionamentos utilizados pela Requisição devem ser compatíveis com ela.

---

# 6. Origem da Necessidade

A origem da necessidade é formada por:

~~~text
Loja
+
Setor solicitante
~~~

Essa origem identifica onde a necessidade surgiu.

Não identifica automaticamente:

- quem atenderá;
- quem comprará;
- de qual estoque sairá o material.

---

# 7. Loja Solicitante

A Loja representa a unidade operacional que originou a Requisição.

Ela não deve ser interpretada automaticamente como localização física do estoque utilizado no atendimento.

~~~text
Loja solicitante
!=
Estoque de origem
~~~

---

# 8. Setor Solicitante

O Setor representa a área da Loja que necessita do item ou serviço.

Regra:

~~~text
Setor
→ pertence à Loja selecionada
~~~

Não é válido relacionar uma Requisição com Setor de outra Loja.

---

# 9. RequisicaoSetor

`RequisicaoSetor` representa um Setor configurado para participação nos processos de Requisição.

Pode possuir capacidades como:

- receber Requisições;
- central de Uso/Consumo;
- central de Manutenção;
- central de TI;
- responsável por Compras;
- controlar estoque de Uso/Consumo;
- possuir Loja física associada.

Capacidade operacional não deve ser deduzida apenas pelo nome do Setor.

---

# 10. Tipo da Requisição

Tipos homologados:

~~~text
USO_CONSUMO
MANUTENCAO
TI
~~~

O Tipo determina qual fluxo operacional deverá atender a necessidade.

---

# 11. Matriz de Responsabilidade

Entidade:

~~~text
RequisicaoMatrizResponsabilidade
~~~

Responsabilidade:

definir os responsáveis por cada tipo de Requisição dentro da Empresa.

Relacionamento:

~~~text
Empresa
+
Tipo
↓
Setor de Atendimento
+
Setor de Aquisição
~~~

---

# 12. Separação das Responsabilidades

Regra de domínio:

~~~text
Origem da necessidade
!=
Responsável pelo atendimento
!=
Responsável pela aquisição
~~~

Exemplo:

~~~text
Loja A / Administrativo
→ solicita papel

Almoxarifado Central
→ atende

Compras
→ adquire se necessário
~~~

---

# 13. Ausência de Matriz

Quando o fluxo exige definição de responsabilidade e não existe Matriz válida:

~~~text
sem Matriz
→ operação bloqueada
~~~

O sistema não deve escolher arbitrariamente um responsável.

---

# 14. RequisicaoItem

`RequisicaoItem` representa o conteúdo da necessidade.

Pode representar, conforme o Tipo:

- Produto Uso/Consumo;
- material;
- descrição livre;
- Serviço.

O item pertence à Requisição.

---

# 15. Estados da Requisição

Estados utilizados pelo fluxo incluem:

~~~text
RASCUNHO
AGUARDANDO_APROVACAO
APROVADA
REJEITADA
DEVOLVIDA
EM_ATENDIMENTO
CONCLUIDA
CANCELADA
~~~

O status representa ciclo operacional.

Não deve ser tratado como um campo livre de manutenção.

---

# 16. Rascunho

`RASCUNHO` representa preparação.

Nesse estado:

- cabeçalho pode ser alterado;
- itens podem ser incluídos;
- itens podem ser alterados;
- itens podem ser excluídos.

~~~text
RASCUNHO
!=
atendimento iniciado
~~~

---

# 17. Envio

O envio formaliza a necessidade para aprovação.

~~~text
RASCUNHO
↓
Enviar
↓
AGUARDANDO_APROVACAO
~~~

O envio, por si só, não cria Ordem de Serviço.

---

# 18. Aprovação

A aprovação autoriza o início operacional.

Para Uso/Consumo:

~~~text
Aprovação
→ verificar atendimento / aquisição
~~~

Para Manutenção e TI:

~~~text
Aprovação
→ criar ou garantir OS
~~~

---

# 19. Ordem de Serviço

Entidade:

~~~text
OrdemServico
~~~

Responsabilidade:

representar a execução operacional de uma Requisição de Manutenção ou TI.

Relacionamento:

~~~text
Requisicao
1
↓
1
OrdemServico
~~~

---

# 20. Momento de Criação da OS

Regra:

~~~text
RASCUNHO
→ não cria OS

AGUARDANDO_APROVACAO
→ não cria OS

APROVAÇÃO
→ cria ou garante OS
~~~

A relação deve ser idempotente.

---

# 21. OS como Fonte Operacional

Depois que a OS existe:

~~~text
Requisição
→ necessidade

OS
→ execução
~~~

A OS passa a determinar o estado operacional da Requisição.

---

# 22. Estados da OS

Estados homologados:

~~~text
ABERTA
EM_TRIAGEM
EM_ATENDIMENTO
AGUARDANDO_MATERIAL
AGUARDANDO_TERCEIRO
CONCLUIDA
CANCELADA
~~~

---

# 23. Sincronização OS → Requisição

Enquanto a OS estiver em execução:

~~~text
ABERTA
EM_TRIAGEM
EM_ATENDIMENTO
AGUARDANDO_MATERIAL
AGUARDANDO_TERCEIRO
↓
Requisição EM_ATENDIMENTO
~~~

Quando:

~~~text
OS CONCLUIDA
↓
Requisição CONCLUIDA
~~~

---

# 24. Cancelamento da OS

Regra:

~~~text
OS CANCELADA
!=
Requisição CANCELADA
~~~

O cancelamento da execução não deve automaticamente cancelar a necessidade original.

---

# 25. OrdemServicoMaterial

Entidade:

~~~text
OrdemServicoMaterial
~~~

Responsabilidade:

representar material físico necessário à execução de uma OS.

Relacionamento:

~~~text
OrdemServico
1
↓
N
OrdemServicoMaterial
~~~

---

# 26. Material não é nova Requisição

Regra fundamental:

~~~text
Material necessário à OS
→ OrdemServicoMaterial

NÃO
→ nova Requisição
~~~

Isso preserva uma única necessidade operacional.

---

# 27. Quantidades do Material

O Material controla conceitos como:

- quantidade necessária;
- quantidade atendida;
- quantidade pendente.

Conceitualmente:

~~~text
Pendente
=
Necessária
-
Atendida
~~~

---

# 28. Estados do Material

Estados homologados:

~~~text
PENDENTE
DISPONIVEL
EM_COMPRA
ATENDIDA
CANCELADA
~~~

---

# 29. Material Disponível

`DISPONIVEL` representa existência de saldo para atendimento.

~~~text
DISPONIVEL
!=
ATENDIDA
~~~

Ainda não houve necessariamente baixa física.

---

# 30. Material Atendido

`ATENDIDA` representa consumo/entrega efetivamente realizado.

Fluxo:

~~~text
DISPONIVEL
↓
Atender
↓
Baixa
↓
ATENDIDA
~~~

---

# 31. OS Aguardando Material

`AGUARDANDO_MATERIAL` representa falta efetiva de material.

~~~text
PENDENTE ou EM_COMPRA
+
saldo insuficiente
↓
AGUARDANDO_MATERIAL
~~~

---

# 32. Material Disponível e Estado da OS

Quando todos os materiais pendentes já estão disponíveis ou tratados:

~~~text
não existe falta física
↓
OS EM_ATENDIMENTO
~~~

Não manter `AGUARDANDO_MATERIAL` apenas porque ainda falta a ação manual de atender.

---

# 33. Materiais Mistos

Exemplo:

~~~text
Material A
→ DISPONIVEL

Material B
→ EM_COMPRA
↓
OS AGUARDANDO_MATERIAL
~~~

Uma única pendência ainda sem cobertura mantém a espera.

---

# 34. Conclusão da OS

Atender todos os materiais não conclui automaticamente a OS.

~~~text
Materiais atendidos
!=
Serviço concluído
~~~

A conclusão permanece ação operacional explícita.

---

# 35. OS sem Material

Uma OS pode não exigir material.

Nesse caso:

~~~text
Execução do Serviço
↓
Concluir OS
~~~

---

# 36. Requisição de Uso/Consumo

Uso/Consumo representa necessidade interna não produtiva.

Exemplos:

- limpeza;
- escritório;
- manutenção;
- materiais internos.

Pode ser atendida diretamente por estoque.

---

# 37. Almoxarifado Central

O Almoxarifado representa o local operacional de atendimento central.

A localização física é determinada pela configuração do Setor de Atendimento.

~~~text
Setor de Atendimento
↓
Loja associada
↓
Estoque físico
~~~

---

# 38. Estoque de Uso/Consumo

Produto:

~~~text
tipo_produto = '2'
~~~

utiliza domínio próprio:

~~~text
ProdutoUsoConsumoEstoque
ProdutoUsoConsumoMovimentacao
~~~

Esse estoque é distinto do estoque comercial de Produto Venda.

---

# 39. Atendimento Direto

Quando existe saldo:

~~~text
Requisição
↓
Estoque Central
↓
Atender
↓
Baixa
↓
Conclusão
~~~

---

# 40. Falta de Estoque

Quando não existe saldo suficiente:

~~~text
Requisição
↓
Necessidade de Compra
~~~

A Requisição não deve ser marcada como atendida antes da entrada física.

---

# 41. Necessidade de Compra

A necessidade representa quantidade ainda não coberta internamente.

Pode ter origem:

~~~text
REQ
OS
~~~

---

# 42. Origem REQ

`REQ` representa necessidade originada em:

~~~text
RequisicaoItem
~~~

aplicável ao fluxo de Uso/Consumo.

---

# 43. Origem OS

`OS` representa necessidade originada em:

~~~text
OrdemServicoMaterial
~~~

aplicável aos materiais necessários à execução.

---

# 44. Necessidade Líquida

Conceitualmente:

~~~text
Necessidade Líquida
=
Quantidade Pendente
-
Estoque Disponível
-
Quantidade já coberta por Compra
~~~

A mesma necessidade não deve ser comprada duas vezes.

---

# 45. Não Duplicação REQ + OS

Para Manutenção e TI com OS:

~~~text
Material
→ OS

Item original da Requisição
→ não gera necessidade física paralela
~~~

Invariante:

~~~text
uma necessidade
→ uma origem de aquisição
~~~

---

# 46. Cotação

Cotação representa o processo comercial de obtenção e comparação de propostas.

Relacionamento conceitual:

~~~text
Necessidade
↓
Cotação
↓
Propostas
↓
Fornecedor vencedor
↓
Pedido
~~~

---

# 47. Pedido de Compra

O Pedido representa a formalização da aquisição.

Quando originado de Requisição ou OS, deve preservar o vínculo com a necessidade que lhe deu origem.

O Pedido não representa entrada física.

---

# 48. Destino do Pedido

Para aquisições internas centralizadas:

~~~text
Pedido
→ destino físico central
~~~

O destino deve refletir a Loja associada ao Setor de Atendimento responsável.

---

# 49. Entrada de NF-e

A Entrada de NF-e representa recebimento físico.

~~~text
Pedido
↓
NF-e
↓
Estoque
~~~

Somente após esse evento o material comprado passa a estar fisicamente disponível.

---

# 50. Sincronização Pós-NF

Depois da entrada:

~~~text
Estoque atualizado
↓
Necessidades recalculadas
~~~

Exemplo:

~~~text
OrdemServicoMaterial EM_COMPRA
↓
DISPONIVEL
~~~

---

# 51. Retorno da Requisição ao Atendimento

Quando a necessidade de Uso/Consumo comprada passa a ter saldo:

~~~text
aguardando aquisição
↓
estoque disponível
↓
EM_ATENDIMENTO
~~~

A sincronização deve ser idempotente.

---

# 52. Atendimento não é Disponibilidade

Separação:

~~~text
Disponibilidade
→ pode atender

Atendimento
→ efetivamente atendeu
~~~

Essa distinção vale para Requisição e Material de OS.

---

# 53. Estados Finais

Requisição `CONCLUIDA` e OS `CONCLUIDA` representam fatos históricos encerrados.

~~~text
CONCLUIDA
→ preservar
→ consultar
→ não alterar operacionalmente
~~~

---

# 54. Imutabilidade da Requisição

Requisição concluída não permite:

- alteração de cabeçalho;
- inclusão de item;
- edição de item;
- exclusão de item;
- novo atendimento;
- nova Cotação.

---

# 55. Imutabilidade da OS

OS concluída não permite:

- edição operacional;
- alteração de status;
- inclusão de material;
- edição de material;
- exclusão de material;
- novo atendimento de material.

---

# 56. Histórico

O histórico registra transições e eventos funcionais relevantes.

Exemplo na conclusão por OS:

~~~text
Atendida pela OS nº X.
~~~

Eventos equivalentes não devem ser duplicados por sincronizações repetidas.

---

# 57. Permissões

O Perfil de Acesso é a fonte de verdade das permissões funcionais.

Permissões específicas:

~~~text
requisicoes.fazer
requisicoes.aprovar
requisicoes.atender
~~~

Usuário define escopo operacional, não substitui permissões do Perfil.

---

# 58. Multiempresa

Todas as entidades respeitam Empresa.

Não é permitido relacionar:

~~~text
Requisição Empresa A
+
Loja / Setor / Produto Empresa B
~~~

A mesma proteção se aplica a:

- Matriz;
- OS;
- materiais;
- Estoque;
- Cotação;
- Pedido;
- NF.

---

# 59. Integração entre Domínios

Visão consolidada:

~~~text
Necessidade Interna
        ↓
Requisição
        ↓
┌──────────────────────────┐
│                          │
Uso/Consumo          Manutenção / TI
│                          │
Estoque                     OS
│                          │
└────── falta material ─────┘
        ↓
Necessidade de Compra
        ↓
Cotação
        ↓
Pedido de Compra
        ↓
Entrada de NF-e
        ↓
Estoque
        ↓
Atendimento
        ↓
Conclusão
~~~

---

# 60. Limites desta Fase

Não pertencem ao domínio homologado desta fase:

- Patrimônio / Ativo Imobilizado;
- contratos de manutenção;
- gestão completa de prestadores externos;
- contratação formal de serviços originada pela OS;
- SLA;
- múltiplos almoxarifados regionais;
- NFS-e de serviços;
- gestão de contratos.

Esses assuntos exigem domínio próprio antes de implementação.

---

# 61. Regra de Preservação

O domínio está homologado.

Não modificar suas invariantes sem:

- novo requisito;
- correção de erro real;
- nova integração;
- necessidade funcional comprovada.

Preservar principalmente:

~~~text
Requisição
!=
OS

Origem
!=
Atendimento
!=
Aquisição

DISPONIVEL
!=
ATENDIDA

Material da OS
!=
nova Requisição

Pedido
!=
Entrada física
~~~

---

# 62. Referências

- [[Sysvar]]
- [[Modelo de Domínio]]
- [[Mapa Técnico - Compras - Requisições e Ordens de Serviço]]
- [[Workflows - Compras - Requisições e Ordens de Serviço]]
- [[Riscos e Cuidados - Compras - Requisições e Ordens de Serviço]]
- [[Homologação - Compras - Requisições e Ordens de Serviço]]