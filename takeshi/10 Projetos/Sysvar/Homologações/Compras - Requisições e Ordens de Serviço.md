---
type: homologation
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
  - estoque
  - cotacao
  - pedido-de-compra
  - entrada-nfe
  - homologacao
  - multiempresa
  - aprovado
---

# Homologação - Compras - Requisições e Ordens de Serviço

## 1. Identificação

**Projeto:** [[Sysvar]]  
**Módulo:** Compras  
**Funcionalidade:** Requisições Internas e Ordens de Serviço  
**Tipos contemplados:** Uso/Consumo, Manutenção e TI  
**Situação:** HOMOLOGADO  
**Data de conclusão da homologação:** 25/08/2026  
**Resultado:** APROVADO

### Documentos relacionados

- [[Sysvar]]
- [[Homologação - Compras - Pedido de Compra]]
- [[Homologação - Compras - Entrada de NF-e]]
- [[Mapa Técnico]]
- [[Modelo de Domínio]]
- [[Workflows]]
- [[Arquitetura]]
- [[Riscos e Cuidados]]

---

# 2. Objetivo

Este documento registra a homologação funcional, técnica e visual do fluxo de Requisições Internas e Ordens de Serviço do [[Sysvar]].

O bloco homologado contempla:

- Requisição de Uso/Consumo;
- Requisição de Manutenção;
- Requisição de TI;
- setores solicitantes;
- setores centrais de atendimento;
- Matriz de Responsabilidade;
- Almoxarifado Central;
- Ordens de Serviço;
- materiais de Ordens de Serviço;
- necessidades de compra;
- Cotação;
- Pedido de Compra;
- Entrada de NF-e;
- estoque dedicado de Uso/Consumo;
- atendimento;
- sincronização de estados;
- conclusão.

---

# 3. Resultado geral

A funcionalidade foi considerada:

**APROVADA E HOMOLOGADA**

Foram homologados os três fluxos principais:

~~~text
USO/CONSUMO
Requisição
→ Aprovação
→ Estoque Central
→ Atendimento
→ Conclusão
~~~

~~~text
USO/CONSUMO SEM ESTOQUE
Requisição
→ Aprovação
→ Cotação
→ Pedido de Compra
→ Entrada de NF-e
→ Estoque Central
→ Atendimento
→ Conclusão
~~~

~~~text
MANUTENÇÃO / TI
Requisição
→ Aprovação
→ Ordem de Serviço
→ Atendimento
→ Material, quando necessário
→ Conclusão da OS
→ Conclusão da Requisição
~~~

A funcionalidade foi aprovada após homologação manual completa dos cenários previstos neste bloco.

---

# 4. Tipos de Requisição homologados

Foram homologados os seguintes tipos:

~~~text
USO_CONSUMO
MANUTENCAO
TI
~~~

Cada tipo representa uma necessidade interna diferente.

Foi homologado que a Requisição identifica a origem da necessidade, enquanto o atendimento pode ser direcionado para outro setor responsável.

---

# 5. Origem da necessidade

Foi homologada a separação entre:

~~~text
Origem da necessidade
≠
Responsável pelo atendimento
≠
Responsável pela aquisição
~~~

A Loja e o Setor da Requisição representam quem originou a necessidade.

Eles não determinam automaticamente o estoque físico responsável pelo atendimento.

---

# 6. Loja e Setor

Foi homologado que o Setor da Requisição deve pertencer à Loja selecionada.

Comportamento aprovado:

- selecionar Loja filtra os Setores disponíveis;
- Setor de outra Loja não pode ser utilizado;
- trocar a Loja limpa Setor incompatível;
- Loja sem Setor configurado não apresenta Setores de outras unidades;
- backend valida a relação Loja × Setor.

Essa regra não depende apenas do frontend.

---

# 7. Estado inicial da Requisição

Toda nova Requisição inicia em:

~~~text
RASCUNHO
~~~

Foi homologado que salvar cabeçalho não significa enviar a Requisição.

Também foi homologado que gravar, editar ou excluir itens durante a preparação não altera automaticamente o estado para atendimento.

---

# 8. Rascunho editável

Enquanto estiver em RASCUNHO, a Requisição permanece editável conforme permissões.

Foram homologadas ações como:

- alterar cabeçalho;
- alterar Loja;
- alterar Setor;
- alterar Tipo;
- alterar motivo;
- incluir itens;
- editar itens;
- remover itens;
- continuar a preparação.

O botão de envio deve permanecer disponível após salvar e reabrir um Rascunho válido.

---

# 9. Envio da Requisição

O envio é uma ação explícita.

Fluxo homologado:

~~~text
RASCUNHO
↓
Enviar
↓
AGUARDANDO_APROVACAO
~~~

Salvar a Requisição ou seus itens não substitui essa ação.

---

# 10. Aprovação

Foi homologado que a operação somente inicia efetivamente após a aprovação.

Para Requisições de Manutenção e TI, a Ordem de Serviço não pode ser criada antes desse momento.

Fluxo:

~~~text
RASCUNHO
→ AGUARDANDO_APROVACAO
→ APROVADA
→ atendimento
~~~

---

# 11. Geração da Ordem de Serviço

Para:

~~~text
MANUTENCAO
TI
~~~

foi homologado que a Ordem de Serviço seja criada somente depois da aprovação da Requisição.

Não criar OS:

- ao salvar o Rascunho;
- ao editar o Rascunho;
- ao gravar item;
- ao enviar para aprovação;
- enquanto estiver aguardando aprovação.

---

# 12. Idempotência da Ordem de Serviço

Foi homologado que a criação da Ordem de Serviço seja idempotente.

Uma mesma Requisição não pode gerar Ordens de Serviço duplicadas por repetição do fluxo ou sincronização.

---

# 13. Matriz de Responsabilidade

Foi homologada a utilização da Matriz de Responsabilidade para definir o fluxo interno.

A Matriz considera:

- Empresa;
- Tipo de Requisição;
- Setor de Atendimento;
- Setor de Aquisição;
- situação ativa.

Exemplo validado:

~~~text
Uso/Consumo
→ Almoxarifado Central
→ Compras

Manutenção
→ Manutenção
→ Compras

TI
→ TI
→ setor de aquisição configurado
~~~

---

# 14. Ausência de Matriz

Foi homologado que a ausência de configuração válida da Matriz impeça o prosseguimento normal da Requisição.

O sistema deve saber quem é responsável por:

- atendimento;
- aquisição, quando necessária.

Não utilizar definição implícita ou arbitrária.

---

# 15. Almoxarifado Central

No fluxo de Uso/Consumo, foi homologado que o atendimento seja realizado pelo estoque físico do Almoxarifado Central configurado.

A Loja solicitante representa:

**origem da necessidade**

e não obrigatoriamente:

**origem física do estoque**

---

# 16. Uso/Consumo com estoque disponível

Foi homologado o fluxo:

~~~text
Criar Requisição
→ Enviar
→ Aprovar
→ verificar estoque central
→ material disponível
→ Atender
→ baixar estoque
→ concluir Requisição
~~~

O atendimento gera a baixa efetiva no estoque dedicado de Uso/Consumo.

---

# 17. Uso/Consumo sem estoque

Foi homologado o fluxo completo de compra:

~~~text
Requisição
→ Aprovação
→ sem estoque
→ Aguardar Cotação
→ Cotação
→ fornecedor/proposta
→ aprovação da Cotação
→ Pedido de Compra
→ Entrada de NF-e
→ estoque disponível
→ Requisição volta para atendimento
→ Atender
→ Conclusão
~~~

Esse fluxo foi executado manualmente até sua conclusão.

---

# 18. Necessidade de compra da Requisição

Foi homologado que itens de Uso/Consumo sem cobertura de estoque possam gerar necessidade para Cotação.

A necessidade proveniente diretamente de Requisição utiliza origem:

~~~text
REQ
~~~

---

# 19. Ordem de Serviço como fonte operacional

Depois que uma OS é criada para Manutenção ou TI, foi homologado que ela passe a ser a fonte operacional de verdade para o atendimento.

A Requisição representa a necessidade original.

A OS representa a execução operacional.

---

# 20. Estados homologados da Ordem de Serviço

Foram homologados:

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

# 21. Sincronização OS → Requisição

Foi homologado que estados operacionais da OS mantenham a Requisição em atendimento.

Regra aprovada:

~~~text
OS ABERTA
OS EM_TRIAGEM
OS EM_ATENDIMENTO
OS AGUARDANDO_MATERIAL
OS AGUARDANDO_TERCEIRO

→ Requisição EM_ATENDIMENTO
~~~

Quando:

~~~text
OS CONCLUIDA
~~~

a Requisição vinculada passa para:

~~~text
CONCLUIDA
~~~

---

# 22. Cancelamento da OS

Foi homologado que:

~~~text
OS CANCELADA
≠
Requisição CANCELADA automaticamente
~~~

Cancelar uma execução operacional não significa necessariamente cancelar a necessidade original.

A decisão sobre a Requisição permanece explícita.

---

# 23. OS sem material

Foi homologado que uma OS de Manutenção ou TI possa ser concluída sem material quando o serviço não exigir componente físico.

Fluxo:

~~~text
OS
→ atendimento
→ execução do serviço
→ conclusão manual
~~~

A conclusão da OS conclui a Requisição vinculada.

---

# 24. Materiais da Ordem de Serviço

Foi homologado que materiais necessários para Manutenção ou TI pertençam diretamente à Ordem de Serviço.

Não deve ser criada uma segunda Requisição apenas para representar material da OS.

---

# 25. Estados do material da OS

Foram homologados:

~~~text
PENDENTE
DISPONIVEL
EM_COMPRA
ATENDIDA
CANCELADA
~~~

---

# 26. Material disponível

Quando existe estoque suficiente, foi homologado que o material possa ficar:

~~~text
DISPONIVEL
~~~

Nesse estado:

- o material ainda não foi atendido;
- a OS pode permanecer EM_ATENDIMENTO;
- o usuário deve executar a ação Atender.

---

# 27. Atendimento do material

Fluxo homologado:

~~~text
DISPONIVEL
→ Atender
→ baixa de estoque
→ ATENDIDA
~~~

A baixa não ocorre apenas porque o material ficou disponível.

---

# 28. Material sem estoque

Foi homologado que material de OS sem estoque possa gerar necessidade de compra.

Origem:

~~~text
OS
~~~

Fluxo:

~~~text
Ordem de Serviço
→ material necessário
→ sem estoque
→ Cotação
→ Pedido
→ NF
→ estoque
→ material DISPONIVEL
→ Atender
→ ATENDIDA
~~~

---

# 29. Necessidade de compra unificada

Foi homologada uma única fila funcional de necessidades de compra para:

~~~text
REQ
OS
~~~

onde:

~~~text
REQ = necessidade originada por Requisição de Uso/Consumo
OS  = necessidade originada por material da Ordem de Serviço
~~~

---

# 30. Proibição de duplicidade REQ + OS

Para Requisições de Manutenção e TI que possuam Ordem de Serviço, foi homologado que o item de serviço original da Requisição não seja enviado para Cotação como necessidade de material.

Somente:

~~~text
OrdemServicoMaterial
~~~

participa do processo de aquisição.

Isso evita necessidade duplicada:

~~~text
REQ + OS
~~~

para a mesma demanda operacional.

---

# 31. Aguardando Material

Foi homologado que o estado:

~~~text
AGUARDANDO_MATERIAL
~~~

represente material efetivamente indisponível.

Exemplos:

- PENDENTE sem cobertura;
- EM_COMPRA.

Material:

~~~text
DISPONIVEL
~~~

não deve manter sozinho a OS em AGUARDANDO_MATERIAL.

---

# 32. Vários materiais

Foi homologado o comportamento combinado.

Exemplo:

~~~text
Material A = DISPONIVEL
Material B = EM_COMPRA
~~~

Resultado:

~~~text
OS = AGUARDANDO_MATERIAL
~~~

Enquanto houver necessidade realmente indisponível, a OS continua aguardando material.

---

# 33. Todos os materiais disponíveis ou tratados

Quando os materiais restantes estiverem em situações como:

~~~text
DISPONIVEL
ATENDIDA
CANCELADA
~~~

sem necessidade indisponível, a OS pode permanecer:

~~~text
EM_ATENDIMENTO
~~~

---

# 34. Conclusão da OS

Foi homologado que atender todos os materiais não conclua automaticamente a Ordem de Serviço.

Fluxo correto:

~~~text
materiais tratados
→ OS EM_ATENDIMENTO
→ usuário conclui manualmente
→ OS CONCLUIDA
~~~

---

# 35. Item original da Requisição

Quando uma OS é concluída, foi homologado que o item de serviço original da Requisição reflita:

~~~text
SERVICO_CONCLUIDO
~~~

Essa situação é consequência da conclusão da OS.

Ela não deve ser utilizada como pré-condição para decidir a conclusão da Requisição.

---

# 36. Histórico da Requisição

Foi homologado o registro de atendimento através da OS.

Exemplo funcional:

~~~text
Atendida pela OS nº X.
~~~

O histórico deve permanecer idempotente, sem duplicar registros pela mesma sincronização.

---

# 37. Cotação

Foi homologada a integração das necessidades deste bloco com Cotação.

A Cotação pode receber necessidade:

- de Requisição de Uso/Consumo;
- de material de Ordem de Serviço.

O processo contempla, conforme a funcionalidade implementada:

- fornecedores;
- propostas;
- comparação;
- definição de vencedor;
- aprovação;
- geração de Pedido de Compra.

---

# 38. Pedido de Compra gerado

Foi homologado que a Cotação aprovada gere Pedido de Compra conforme o fluxo existente.

O Pedido mantém vínculo com a origem de compra e herda os termos comerciais aplicáveis.

Para compra interna deste fluxo, o destino físico deve respeitar o Almoxarifado Central configurado.

---

# 39. Entrada de NF-e

Foi homologada a integração com a Entrada de NF-e.

Fluxo:

~~~text
Pedido
→ Entrada de NF-e
→ fechamento
→ estoque dedicado
→ sincronização da necessidade
~~~

A entrada efetiva ocorre pela Nota Fiscal, preservando o fluxo já homologado de Compras.

---

# 40. Estoque dedicado de Uso/Consumo

Foi homologado que produtos:

~~~text
tipo_produto = '2'
~~~

utilizem estoque específico de Uso/Consumo.

Estruturas homologadas:

~~~text
ProdutoUsoConsumoEstoque
ProdutoUsoConsumoMovimentacao
~~~

---

# 41. Pedido manual de Uso/Consumo

Foi homologado que a utilização do estoque dedicado não dependa da origem do Pedido.

Produto tipo 2 utiliza o estoque de Uso/Consumo inclusive quando o Pedido é criado manualmente.

Portanto:

~~~text
Produto tipo 2
→ estoque Uso/Consumo
~~~

independentemente de:

- Cotação;
- Requisição;
- Ordem de Serviço;
- Pedido manual.

---

# 42. Separação do estoque de Revenda

Foi homologado que o estoque de Uso/Consumo não utilize o ledger genérico de Revenda.

A separação deve existir tanto no saldo quanto nas movimentações.

---

# 43. Consultas de Uso/Consumo

Foram homologadas telas específicas para consulta:

- Por Referência Uso/Consumo;
- Movimentação por Referência Uso/Consumo.

Essas consultas utilizam as estruturas próprias do estoque de Uso/Consumo.

---

# 44. Sincronização após NF

Foi homologado que, após a entrada da Nota Fiscal, o sistema sincronize as necessidades relacionadas.

Exemplos:

~~~text
Material da OS
EM_COMPRA
→ DISPONIVEL
~~~

e:

~~~text
Requisição aguardando compra
→ estoque disponível
→ retorno para atendimento
~~~

---

# 45. Requisição concluída

Foi homologado que:

~~~text
CONCLUIDA
~~~

seja estado final operacional da Requisição.

Depois de concluída, permanece consultável, mas não deve aceitar:

- edição de cabeçalho;
- inclusão de item;
- edição de item;
- exclusão de item;
- novo atendimento;
- nova Cotação;
- retorno arbitrário de status.

---

# 46. Ordem de Serviço concluída

Foi homologado que:

~~~text
CONCLUIDA
~~~

seja estado final da Ordem de Serviço.

Depois da conclusão:

- não pode alterar status;
- não pode editar dados operacionais;
- não pode incluir material;
- não pode editar material;
- não pode excluir/cancelar material;
- não pode atender material.

A OS permanece disponível para consulta.

---

# 47. Proteção no backend

Foi homologado que as proteções de estado final existam no backend.

Não depender apenas de:

- botão oculto;
- campo desabilitado;
- comportamento do frontend.

Tentativas diretas de alteração devem ser bloqueadas pela regra de domínio.

---

# 48. Comportamento visual da OS concluída

Foi homologado que ao abrir uma OS concluída:

- campos apareçam somente para leitura;
- status seja somente leitura;
- botão Salvar não fique disponível;
- ações de material não fiquem disponíveis;
- formulário de novo material não fique operacional.

---

# 49. Permissões de Requisição

Foram homologadas as permissões de processo:

~~~text
requisicoes.fazer
requisicoes.aprovar
requisicoes.atender
~~~

Essas permissões pertencem ao Perfil de Acesso.

---

# 50. Arquitetura de permissões

Foi mantida a arquitetura homologada:

~~~text
Perfil de Acesso
→ permissões funcionais

Usuário
→ escopo
~~~

O cadastro de Usuário não deve funcionar como segunda fonte paralela de permissões funcionais do módulo.

---

# 51. Cenários manuais homologados

Foram executados e aprovados os seguintes cenários:

### Uso/Consumo

- Requisição com estoque disponível;
- atendimento direto;
- baixa do estoque;
- conclusão.

### Uso/Consumo com compra

- Requisição sem estoque;
- envio para Cotação;
- Cotação;
- Pedido;
- Entrada de NF-e;
- atualização do estoque;
- retorno da Requisição para atendimento;
- atendimento;
- conclusão.

### Manutenção

- OS sem material;
- OS com material disponível;
- OS com material comprado através de Cotação/Pedido/NF;
- atendimento do material;
- conclusão manual da OS;
- conclusão automática da Requisição pela OS.

### TI

- Requisição criada em Rascunho;
- item gravado sem criação prematura da OS;
- envio para aprovação;
- aprovação;
- criação da OS;
- TI sem material;
- TI com material disponível;
- atendimento;
- conclusão.

---

# 52. Correções validadas durante a homologação

Durante o fechamento do bloco foram identificados e corrigidos comportamentos relacionados a:

- uso incorreto do estoque genérico para Produto tipo 2;
- sincronização pós-NF de Requisição;
- sincronização pós-NF de material da OS;
- OS permanecendo AGUARDANDO_MATERIAL com material já DISPONIVEL;
- duplicidade de necessidade entre Requisição e OS;
- geração prematura de OS antes da aprovação;
- Setor não filtrado pela Loja;
- Rascunho deixando de permanecer editável após salvar;
- estados finais permitindo alteração operacional.

Todos os pontos foram retestados nos fluxos afetados.

---

# 53. Integrações homologadas

O bloco foi homologado integrado a:

- Empresas;
- Lojas;
- Setores;
- Perfil de Acesso;
- Produtos Uso/Consumo;
- Estoque Uso/Consumo;
- Cotação;
- Fornecedores;
- Pedido de Compra;
- Entrada de NF-e;
- histórico da Requisição.

---

# 54. Itens fora do escopo homologado

Não fazem parte desta homologação:

- Patrimônio/Ativo Imobilizado;
- contratos de manutenção;
- gestão de fornecedores terceirizados por OS;
- contratação formal de serviço externo originada pela OS;
- SLA;
- múltiplos almoxarifados regionais;
- NFS-e de serviços;
- gestão contratual.

Esses itens permanecem como escopos futuros e não devem ser considerados implementados por esta homologação.

---

# 55. Resultado final

O bloco:

**Requisições Internas + Ordens de Serviço + Compras de Uso/Consumo**

foi considerado:

**APROVADO E HOMOLOGADO**

Foram validados:

- origem da necessidade;
- Loja e Setor;
- Matriz de Responsabilidade;
- Almoxarifado Central;
- aprovação;
- geração correta de OS;
- Manutenção;
- TI;
- materiais;
- compra de materiais;
- Cotação;
- Pedido;
- Entrada de NF-e;
- estoque dedicado;
- atendimento;
- sincronização;
- histórico;
- estados finais;
- imutabilidade após conclusão.

O bloco pode ser considerado funcionalmente encerrado no escopo descrito nesta homologação.

---

# 56. Documentação relacionada a atualizar

Esta homologação deve ser refletida, conforme aplicável, nos documentos de contexto do [[Sysvar]]:

- [[Sysvar]]
- [[Visão Geral]]
- [[Arquitetura]]
- [[Mapa Técnico]]
- [[Modelo de Domínio]]
- [[Workflows]]
- [[Riscos e Cuidados]]

As atualizações devem registrar somente o delta correspondente ao bloco homologado.