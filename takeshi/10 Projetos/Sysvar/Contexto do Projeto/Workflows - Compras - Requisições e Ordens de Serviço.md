---
type: workflows
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
  - workflows
  - auditoria
  - multiempresa
  - homologado
---

# Workflows - Compras - Requisições e Ordens de Serviço

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
- [[Riscos e Cuidados - Compras - Requisições e Ordens de Serviço]]
- [[Homologação - Compras - Requisições e Ordens de Serviço]]

---

# 2. Visão Geral

Fluxo conceitual:

~~~text
Necessidade Interna
        ↓
Requisição
        ↓
Aprovação
        ↓
┌───────────────────────┐
│                       │
Uso/Consumo       Manutenção / TI
│                       │
Estoque                  OS
│                       │
└──── falta material ───┘
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

# 3. Nova Requisição

~~~text
Usuário
↓
Requisições
↓
Nova
↓
Selecionar Loja
↓
Selecionar Setor
↓
Selecionar Tipo
↓
Informar motivo / prioridade / necessidade
↓
Salvar
↓
RASCUNHO
~~~

Tipos:

~~~text
USO_CONSUMO
MANUTENCAO
TI
~~~

---

# 4. Loja e Setor

~~~text
Selecionar Loja
↓
Carregar Setores da Loja
↓
Selecionar Setor compatível
~~~

Regra:

~~~text
Requisicao.loja
=
Requisicao.setor.loja
~~~

O backend rejeita combinação incompatível.

---

# 5. Rascunho

Enquanto:

~~~text
status = RASCUNHO
~~~

o usuário pode:

- alterar cabeçalho;
- incluir itens;
- editar itens;
- excluir itens;
- salvar e reabrir;
- enviar.

Criar item não inicia atendimento.

---

# 6. Envio

~~~text
RASCUNHO
↓
Enviar
↓
AGUARDANDO_APROVACAO
~~~

Para Manutenção e TI:

~~~text
Enviar
!=
Criar OS
~~~

---

# 7. Aprovação

~~~text
AGUARDANDO_APROVACAO
↓
Aprovar
↓
Resolver Matriz de Responsabilidade
↓
Iniciar fluxo operacional
~~~

Sem Matriz válida, o processo dependente dela deve ser bloqueado.

---

# 8. Matriz de Responsabilidade

~~~text
Empresa
+
Tipo
↓
Matriz
↓
Setor de Atendimento
+
Setor de Aquisição
~~~

Regra:

~~~text
Origem
!=
Atendimento
!=
Aquisição
~~~

---

# 9. Uso/Consumo com Estoque

~~~text
Requisição aprovada
↓
Resolver Setor de Atendimento
↓
Resolver Loja física do Almoxarifado
↓
Consultar ProdutoUsoConsumoEstoque
↓
Saldo suficiente
↓
Atender
↓
Baixar estoque
↓
CONCLUIDA
~~~

A Loja solicitante não é automaticamente o estoque de origem.

---

# 10. Uso/Consumo sem Estoque

~~~text
Requisição aprovada
↓
Saldo insuficiente
↓
Aguardar Cotação
↓
Necessidade REQ
↓
Cotação
↓
Fornecedor vencedor
↓
Pedido de Compra
↓
Entrada de NF-e
↓
Estoque Central
↓
Requisição volta ao atendimento
↓
Atender
↓
CONCLUIDA
~~~

---

# 11. Necessidade REQ

Origem:

~~~text
REQ
→ RequisicaoItem de Uso/Consumo
~~~

Necessidade líquida:

~~~text
Quantidade pendente
-
Estoque disponível
-
Quantidade já coberta por compra
~~~

Não gerar aquisição duplicada.

---

# 12. Manutenção / TI — Criação da OS

~~~text
RASCUNHO
→ sem OS

AGUARDANDO_APROVACAO
→ sem OS

Aprovação
↓
Criar ou garantir OS
↓
EM_ATENDIMENTO
~~~

A criação da OS deve ser idempotente.

---

# 13. OS sem Material

~~~text
OS
↓
Execução do serviço
↓
Concluir
↓
OS CONCLUIDA
↓
Requisição CONCLUIDA
~~~

Material não é obrigatório para toda OS.

---

# 14. Inclusão de Material na OS

~~~text
OS
↓
Adicionar Material
↓
Produto / descrição
↓
Unidade
↓
Quantidade necessária
↓
Salvar
↓
Verificar disponibilidade
~~~

O material pertence diretamente à OS.

Não criar nova Requisição.

---

# 15. Material Disponível

~~~text
Material necessário
↓
Estoque suficiente
↓
DISPONIVEL
↓
Atender
↓
Baixa física
↓
ATENDIDA
~~~

Regra:

~~~text
DISPONIVEL
!=
ATENDIDA
~~~

---

# 16. Material sem Estoque

~~~text
Material necessário
↓
Saldo insuficiente
↓
PENDENTE / EM_COMPRA
↓
OS AGUARDANDO_MATERIAL
↓
Necessidade OS
~~~

---

# 17. Necessidade OS

Origem:

~~~text
OS
→ OrdemServicoMaterial
~~~

O item original da Requisição de Manutenção/TI não deve gerar necessidade física paralela.

~~~text
Material da OS
→ compra

Item da Requisição
→ não duplicar compra
~~~

---

# 18. Material da OS em Cotação

~~~text
OrdemServicoMaterial
↓
Necessidade OS
↓
Cotação
↓
Fornecedor / Proposta
↓
Vencedor
↓
Pedido de Compra
~~~

---

# 19. Pedido de Material Interno

Quando gerado a partir de necessidade interna:

~~~text
Pedido
↓
Destino físico
↓
Almoxarifado Central configurado
~~~

O destino não deve ser inferido pela Loja solicitante.

---

# 20. Entrada de NF-e

~~~text
Pedido
↓
NF-e de Entrada
↓
Recebimento
↓
Estoque
~~~

Para Produto tipo 2:

~~~text
ProdutoUsoConsumoEstoque
+
ProdutoUsoConsumoMovimentacao
~~~

A aprovação do Pedido não representa entrada física.

---

# 21. Pós-NF — Material da OS

~~~text
Material EM_COMPRA
↓
Entrada de NF-e
↓
Saldo disponível
↓
DISPONIVEL
↓
OS EM_ATENDIMENTO
~~~

A sincronização deve ser idempotente.

---

# 22. Pós-NF — Requisição

~~~text
Requisição aguardando aquisição
↓
Entrada de NF-e
↓
Saldo disponível
↓
EM_ATENDIMENTO
↓
Atender
~~~

---

# 23. AGUARDANDO_MATERIAL

A OS fica nesse estado quando ainda existe indisponibilidade real.

~~~text
PENDENTE / EM_COMPRA
+
saldo insuficiente
↓
AGUARDANDO_MATERIAL
~~~

Se todos os materiais pendentes estiverem disponíveis:

~~~text
OS
→ EM_ATENDIMENTO
~~~

---

# 24. Materiais Mistos

~~~text
Material A
→ DISPONIVEL

Material B
→ EM_COMPRA
↓
OS AGUARDANDO_MATERIAL
~~~

Uma pendência sem cobertura mantém a OS aguardando.

---

# 25. Atendimento do Material

~~~text
DISPONIVEL
↓
Atender
↓
Bloquear registro / estoque
↓
Baixar quantidade
↓
Atualizar quantidade atendida
↓
ATENDIDA
~~~

Operações críticas devem permanecer transacionais.

---

# 26. Conclusão da OS

Antes de concluir:

~~~text
Existe material pendente?
├── Sim → bloquear
└── Não → permitir
~~~

Mesmo quando todos os materiais estão atendidos:

~~~text
Materiais ATENDIDOS
!=
OS CONCLUIDA
~~~

A conclusão é ação explícita.

---

# 27. Sincronização OS → Requisição

Estados:

~~~text
ABERTA
EM_TRIAGEM
EM_ATENDIMENTO
AGUARDANDO_MATERIAL
AGUARDANDO_TERCEIRO
↓
Requisição EM_ATENDIMENTO
~~~

Conclusão:

~~~text
OS CONCLUIDA
↓
Requisição CONCLUIDA
~~~

Cancelamento:

~~~text
OS CANCELADA
!=
Requisição CANCELADA
~~~

---

# 28. Histórico

Na conclusão pela OS:

~~~text
Atendida pela OS nº X.
~~~

O evento deve ser registrado uma única vez.

Sincronizações repetidas não devem duplicar histórico.

---

# 29. Requisição Concluída

~~~text
CONCLUIDA
↓
consulta
~~~

Não permite:

- editar cabeçalho;
- incluir item;
- editar item;
- excluir item;
- atender novamente;
- enviar novamente para Cotação.

---

# 30. OS Concluída

~~~text
CONCLUIDA
↓
somente leitura
~~~

Não permite:

- PUT/PATCH operacional;
- inclusão de material;
- edição de material;
- exclusão de material;
- novo atendimento de material.

---

# 31. Permissões

Permissões específicas:

~~~text
requisicoes.fazer
requisicoes.aprovar
requisicoes.atender
~~~

Fluxo:

~~~text
Perfil de Acesso
↓
Permissão efetiva
↓
Ação disponível
~~~

O backend valida a autorização final.

---

# 32. Multiempresa

Em qualquer fluxo:

~~~text
Objeto
↓
Empresa compatível?
├── Sim → continuar
└── Não → bloquear
~~~

Aplica-se a:

- Loja;
- Setor;
- Matriz;
- Requisição;
- OS;
- Produto;
- Estoque;
- Cotação;
- Pedido;
- NF.

---

# 33. Fluxo Completo — Uso/Consumo com Estoque

~~~text
Nova Requisição
↓
RASCUNHO
↓
Enviar
↓
Aprovar
↓
Estoque Central disponível
↓
Atender
↓
Baixa
↓
CONCLUIDA
~~~

---

# 34. Fluxo Completo — Uso/Consumo com Compra

~~~text
Nova Requisição
↓
Enviar
↓
Aprovar
↓
Sem estoque
↓
REQ
↓
Cotação
↓
Pedido
↓
NF-e
↓
Estoque Central
↓
Atender
↓
CONCLUIDA
~~~

---

# 35. Fluxo Completo — Manutenção/TI sem Material

~~~text
Nova Requisição
↓
Enviar
↓
Aprovar
↓
OS
↓
Executar Serviço
↓
Concluir OS
↓
Requisição CONCLUIDA
~~~

---

# 36. Fluxo Completo — Manutenção/TI com Material Disponível

~~~text
Requisição
↓
Aprovação
↓
OS
↓
Material
↓
DISPONIVEL
↓
Atender Material
↓
ATENDIDA
↓
Concluir OS
↓
Requisição CONCLUIDA
~~~

---

# 37. Fluxo Completo — Manutenção/TI com Compra

~~~text
Requisição
↓
Aprovação
↓
OS
↓
Material sem estoque
↓
AGUARDANDO_MATERIAL
↓
Necessidade OS
↓
Cotação
↓
Pedido
↓
NF-e
↓
DISPONIVEL
↓
EM_ATENDIMENTO
↓
Atender Material
↓
Concluir OS
↓
Requisição CONCLUIDA
~~~

---

# 38. Limites desta Fase

Não fazem parte deste workflow homologado:

- Patrimônio;
- Ativo Imobilizado;
- contratos de manutenção;
- prestador externo completo;
- contratação formal de serviço pela OS;
- SLA;
- múltiplos almoxarifados regionais;
- NFS-e de serviços;
- gestão de contratos.

---

# 39. Referências

- [[Sysvar]]
- [[Workflows]]
- [[Mapa Técnico - Compras - Requisições e Ordens de Serviço]]
- [[Modelo de Domínio - Compras - Requisições e Ordens de Serviço]]
- [[Riscos e Cuidados - Compras - Requisições e Ordens de Serviço]]
- [[Homologação - Compras - Requisições e Ordens de Serviço]]