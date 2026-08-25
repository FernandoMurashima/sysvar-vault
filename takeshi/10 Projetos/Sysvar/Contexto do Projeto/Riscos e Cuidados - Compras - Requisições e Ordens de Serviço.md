---
type: risks-and-care
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
  - riscos
  - auditoria
  - multiempresa
  - homologado
---

# Riscos e Cuidados - Compras - Requisições e Ordens de Serviço

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
- [[Modelo de Domínio - Compras - Requisições e Ordens de Serviço]]
- [[Workflows - Compras - Requisições e Ordens de Serviço]]
- [[Homologação - Compras - Requisições e Ordens de Serviço]]

---

# 2. Objetivo

Este documento registra os principais riscos funcionais, técnicos e arquiteturais do fluxo de Requisições Internas e Ordens de Serviço.

O objetivo é preservar as regras já homologadas e impedir regressões principalmente nas integrações entre:

~~~text
Requisição
Estoque
Ordem de Serviço
Cotação
Pedido de Compra
Entrada de NF-e
~~~

---

# 3. Risco — confundir origem com atendimento

A Requisição nasce em:

~~~text
Loja solicitante
+
Setor solicitante
~~~

Isso representa a origem da necessidade.

Não significa automaticamente:

- estoque de origem;
- Setor de Atendimento;
- Setor de Aquisição.

Regra:

~~~text
Origem
!=
Atendimento
!=
Aquisição
~~~

---

# 4. Risco — usar a Loja solicitante como estoque

A Loja que solicita não deve ser usada automaticamente como localização física do material.

O estoque central decorre de:

~~~text
Setor de Atendimento
↓
Loja associada
↓
Estoque físico
~~~

Ignorar essa regra quebra a centralização do Almoxarifado.

---

# 5. Risco — ignorar a Matriz de Responsabilidade

O responsável pelo atendimento e pela aquisição deve ser resolvido pela:

~~~text
RequisicaoMatrizResponsabilidade
~~~

Não usar:

- IDs fixos;
- nomes de Setor;
- primeira Loja;
- primeiro Setor disponível;
- fallback silencioso.

Sem configuração válida, o fluxo deve ser bloqueado.

---

# 6. Risco — aceitar Setor de outra Loja

A combinação:

~~~text
Requisicao.loja
+
Requisicao.setor
~~~

precisa ser coerente.

Não confiar somente no filtro do frontend.

O backend deve rejeitar Setor pertencente a outra Loja.

---

# 7. Risco — iniciar atendimento durante o Rascunho

Enquanto:

~~~text
RASCUNHO
~~~

a Requisição está apenas em preparação.

Salvar:

- cabeçalho;
- item;
- alteração de item;

não deve iniciar atendimento.

---

# 8. Risco — criar OS antes da aprovação

Para Manutenção e TI:

~~~text
RASCUNHO
→ sem OS

AGUARDANDO_APROVACAO
→ sem OS

APROVAÇÃO
→ criar ou garantir OS
~~~

Criar OS antes da aprovação altera indevidamente o estado da Requisição.

---

# 9. Risco — duplicar OS

Relacionamento homologado:

~~~text
Requisição
1
↓
1
Ordem de Serviço
~~~

A criação deve ser idempotente.

Reabrir tela, sincronizar ou repetir chamada não pode criar nova OS.

---

# 10. Risco — usar item da Requisição como fonte operacional depois da OS

Para Manutenção e TI, depois da criação da OS:

~~~text
OS
→ fonte operacional
~~~

O estado da Requisição deve acompanhar a OS.

Não voltar a decidir o status da Requisição pelo item de serviço original.

---

# 11. Risco — cancelar Requisição automaticamente ao cancelar OS

Regra:

~~~text
OS CANCELADA
!=
Requisição CANCELADA
~~~

O cancelamento da execução não elimina automaticamente a necessidade original.

---

# 12. Risco — criar nova Requisição para material da OS

Material utilizado no atendimento pertence diretamente a:

~~~text
OrdemServicoMaterial
~~~

Não criar uma segunda Requisição para representar o mesmo material.

---

# 13. Risco — duplicar necessidade REQ + OS

Para Manutenção/TI com Ordem de Serviço:

~~~text
Item original da Requisição
→ não gera compra de material

OrdemServicoMaterial
→ gera necessidade física
~~~

Não produzir simultaneamente:

~~~text
REQ
+
OS
~~~

para a mesma necessidade.

Isso pode gerar compra duplicada.

---

# 14. Risco — confundir DISPONIVEL com ATENDIDA

Estados diferentes:

~~~text
DISPONIVEL
→ existe saldo

ATENDIDA
→ houve atendimento e baixa
~~~

Apenas tornar o material disponível não deve baixar estoque.

---

# 15. Risco — manter OS em AGUARDANDO_MATERIAL sem falta real

`AGUARDANDO_MATERIAL` significa indisponibilidade real.

Se todos os materiais necessários estiverem disponíveis:

~~~text
OS
→ EM_ATENDIMENTO
~~~

Não manter a espera apenas porque ainda falta a ação manual de atendimento.

---

# 16. Risco — retirar AGUARDANDO_MATERIAL cedo demais

Situação:

~~~text
Material A → DISPONIVEL
Material B → EM_COMPRA
~~~

Resultado:

~~~text
OS AGUARDANDO_MATERIAL
~~~

Enquanto existir material sem cobertura, a OS continua aguardando.

---

# 17. Risco — concluir OS automaticamente

Regra:

~~~text
Materiais ATENDIDOS
!=
OS CONCLUIDA
~~~

A conclusão da OS representa término do serviço.

Deve permanecer uma ação operacional explícita.

---

# 18. Risco — concluir OS com material pendente

Antes da conclusão:

~~~text
Existe material pendente?
├── Sim → bloquear
└── Não → permitir
~~~

Não permitir encerramento inconsistente.

---

# 19. Risco — não sincronizar Requisição ao concluir OS

Quando:

~~~text
OS CONCLUIDA
~~~

deve ocorrer:

~~~text
Requisição CONCLUIDA
~~~

O histórico correspondente deve ser registrado de forma idempotente.

---

# 20. Risco — duplicar histórico

Sincronizações repetidas não podem registrar várias vezes eventos equivalentes.

Exemplo:

~~~text
Atendida pela OS nº X.
~~~

deve ser preservado sem duplicação.

---

# 21. Risco — usar estoque comercial para Uso/Consumo

Produto:

~~~text
tipo_produto = '2'
~~~

utiliza:

~~~text
ProdutoUsoConsumoEstoque
ProdutoUsoConsumoMovimentacao
~~~

Não enviar tipo 2 para o ledger genérico de Produto Venda.

---

# 22. Risco — tratar Pedido manual tipo 2 de forma diferente

A regra de estoque depende do tipo do Produto, não da origem do Pedido.

Portanto:

~~~text
Pedido manual tipo 2
→ ProdutoUsoConsumoEstoque
~~~

Não limitar o estoque dedicado apenas a pedidos originados de Cotação ou Requisição.

---

# 23. Risco — considerar Pedido como entrada física

A geração ou aprovação do Pedido não representa recebimento.

Fluxo correto:

~~~text
Pedido
↓
Entrada de NF-e
↓
Estoque
~~~

Não movimentar estoque na aprovação.

---

# 24. Risco — não sincronizar após NF-e

Depois da entrada física, necessidades relacionadas precisam ser reavaliadas.

Exemplo:

~~~text
OrdemServicoMaterial EM_COMPRA
↓
NF-e
↓
saldo disponível
↓
DISPONIVEL
~~~

Outro exemplo:

~~~text
Requisição aguardando compra
↓
NF-e
↓
saldo disponível
↓
EM_ATENDIMENTO
~~~

---

# 25. Risco — sincronização pós-NF não idempotente

Repetir uma sincronização não pode:

- duplicar estoque;
- duplicar movimentação;
- duplicar atendimento;
- duplicar histórico;
- duplicar necessidade;
- duplicar OS.

---

# 26. Risco — gerar compra já coberta

A necessidade líquida deve considerar:

~~~text
Quantidade pendente
-
Estoque disponível
-
Quantidade já coberta por compra
~~~

Não gerar nova aquisição quando já existe cobertura em processo.

---

# 27. Risco — perder vínculo com a origem da compra

Uma necessidade encaminhada para Cotação/Pedido deve permanecer rastreável até sua origem:

~~~text
REQ
ou
OS
~~~

Não transformar o Pedido gerado em aquisição sem contexto.

---

# 28. Risco — destino incorreto do Pedido interno

Para compra destinada ao atendimento central:

~~~text
Pedido
→ Loja física do Almoxarifado
~~~

Não usar automaticamente a Loja solicitante.

---

# 29. Risco — concorrência no atendimento de estoque

Duas operações simultâneas podem tentar consumir o mesmo saldo.

Não usar:

~~~text
ler saldo
↓
encerrar transação
↓
baixar depois
~~~

Operações críticas devem manter proteção transacional e bloqueio adequado.

---

# 30. Risco — dupla baixa

Atendimento repetido não pode gerar duas movimentações para a mesma quantidade já atendida.

Estados e quantidades devem ser verificados dentro da operação transacional.

---

# 31. Risco — permitir edição da Requisição concluída

Requisição:

~~~text
CONCLUIDA
~~~

é histórica.

Não permitir:

- alteração de cabeçalho;
- inclusão de item;
- edição de item;
- exclusão de item;
- novo atendimento;
- nova Cotação.

---

# 32. Risco — permitir edição da OS concluída

OS:

~~~text
CONCLUIDA
~~~

é histórica.

Não permitir:

- PUT/PATCH operacional;
- inclusão de material;
- edição de material;
- exclusão de material;
- atendimento de material.

A proteção deve existir no backend.

---

# 33. Risco — depender apenas dos botões do frontend

Ocultar ação na tela melhora UX, mas não protege a API.

Regras críticas devem existir no backend para:

- estado;
- Empresa;
- permissões;
- estoque;
- conclusão;
- edição;
- aquisição.

---

# 34. Risco — quebrar permissões funcionais

Permissões homologadas:

~~~text
requisicoes.fazer
requisicoes.aprovar
requisicoes.atender
~~~

Cada uma possui responsabilidade distinta.

Não inferir uma a partir da outra.

---

# 35. Risco — colocar permissões novamente no Usuário

A fonte funcional é:

~~~text
Perfil de Acesso
~~~

Usuário define escopo.

Não voltar a transformar o Usuário em fonte principal das permissões do módulo.

---

# 36. Risco — quebrar isolamento multiempresa

Validar Empresa em:

- Requisição;
- Loja;
- Setor;
- Matriz;
- OS;
- materiais;
- Produto;
- Estoque;
- Cotação;
- Pedido;
- NF-e.

IDs válidos de outro tenant continuam inválidos para a operação.

---

# 37. Risco — introduzir fluxo paralelo de Compras

Necessidades internas devem reutilizar:

~~~text
Cotação
↓
Pedido de Compra
↓
Entrada de NF-e
~~~

Não criar:

- Pedido especial de Requisição;
- compra própria da OS;
- recebimento próprio da Requisição;
- financeiro paralelo.

---

# 38. Risco — misturar escopo futuro com a Fase 1

Ainda não pertencem ao fluxo homologado:

- Patrimônio;
- Ativo Imobilizado;
- contratos de manutenção;
- gestão completa de prestadores;
- contratação formal de serviço pela OS;
- SLA;
- NFS-e de serviços;
- múltiplos almoxarifados regionais.

Esses itens exigem definição própria.

---

# 39. Regra de Preservação

As invariantes principais são:

~~~text
Requisição
!=
Ordem de Serviço

Origem
!=
Atendimento
!=
Aquisição

RASCUNHO
→ sem OS

Material da OS
!=
nova Requisição

DISPONIVEL
!=
ATENDIDA

Materiais atendidos
!=
OS concluída

OS CANCELADA
!=
Requisição CANCELADA

Pedido
!=
Entrada física

Produto tipo 2
→ estoque dedicado
~~~

Não alterar essas regras sem nova decisão funcional ou correção comprovada.

---

# 40. Referências

- [[Sysvar]]
- [[Riscos e Cuidados]]
- [[Mapa Técnico - Compras - Requisições e Ordens de Serviço]]
- [[Modelo de Domínio - Compras - Requisições e Ordens de Serviço]]
- [[Workflows - Compras - Requisições e Ordens de Serviço]]
- [[Homologação - Compras - Requisições e Ordens de Serviço]]