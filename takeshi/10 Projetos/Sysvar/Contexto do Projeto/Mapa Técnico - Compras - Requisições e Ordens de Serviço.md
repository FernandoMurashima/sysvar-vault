---
type: technical-map
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
  - homologado
---

# Mapa Técnico - Compras - Requisições e Ordens de Serviço

## 1. Identificação

- **Projeto:** [[Sysvar]]
- **Módulo:** Compras
- **Funcionalidade:** Requisições Internas e Ordens de Serviço
- **Tipos contemplados:** Uso/Consumo, Manutenção e TI
- **Escopo documentado:** Fase 1
- **Situação:** IMPLEMENTADO E HOMOLOGADO
- **Homologação manual:** aprovada pelo usuário
- **Data da homologação:** 25/08/2026

### Documentos relacionados

- [[Sysvar]]
- [[Homologação - Compras - Requisições e Ordens de Serviço]]
- [[Workflows - Compras - Requisições e Ordens de Serviço]]
- [[Modelo de Domínio - Compras - Requisições e Ordens de Serviço]]
- [[Riscos e Cuidados - Compras - Requisições e Ordens de Serviço]]

---

# 2. Objetivo Técnico

O domínio controla necessidades internas da Empresa que podem ser resolvidas por:

- estoque interno;
- atendimento operacional;
- Ordem de Serviço;
- processo de aquisição.

Tipos homologados:

~~~text
USO_CONSUMO
MANUTENCAO
TI
~~~

Regra conceitual:

~~~text
Necessidade
→ Requisição
→ Atendimento interno ou aquisição
~~~

Para Manutenção e TI:

~~~text
Requisição aprovada
→ Ordem de Serviço
~~~

---

# 3. Backend

A implementação está concentrada principalmente no app:

~~~text
Backend\compras
~~~

Arquivos centrais:

~~~text
Backend\compras\models.py
Backend\compras\serializers.py
Backend\compras\views.py
Backend\compras\urls.py
Backend\compras\tests.py
~~~

O backend é autoridade para:

- tenant;
- Loja;
- Setor;
- status;
- permissões;
- Matriz de Responsabilidade;
- criação da OS;
- necessidades de compra;
- disponibilidade de estoque;
- atendimento;
- sincronização;
- conclusão;
- imutabilidade de estados finais.

---

# 4. Requisição

Estrutura principal:

~~~text
Requisicao
~~~

Representa a necessidade interna.

Relacionamentos principais:

- Empresa;
- Loja;
- Setor solicitante;
- Tipo;
- prioridade;
- motivo;
- data necessária;
- status;
- itens.

A Loja e o Setor representam:

~~~text
origem da necessidade
~~~

Não representam necessariamente o local físico de estoque ou o setor responsável pela aquisição.

---

# 5. Tipos de Requisição

Valores funcionais homologados:

~~~text
USO_CONSUMO
MANUTENCAO
TI
~~~

Cada tipo utiliza a mesma estrutura de Requisição, mas segue atendimento operacional próprio.

---

# 6. Setor da Requisição

Estrutura relacionada:

~~~text
RequisicaoSetor
~~~

O Setor solicitante precisa ser compatível com a Loja escolhida.

Regra:

~~~text
Requisicao.loja
+
Requisicao.setor
→ mesma Loja
~~~

O frontend filtra os setores.

O backend também valida a relação.

---

# 7. Capacidades de Setor

`RequisicaoSetor` pode possuir capacidades relacionadas a:

- receber Requisições;
- central de Uso/Consumo;
- central de Manutenção;
- central de TI;
- responsável por Compras;
- controle de estoque de Uso/Consumo;
- Loja física vinculada.

Essas capacidades não devem ser inferidas pelo nome do Setor.

---

# 8. Matriz de Responsabilidade

Estrutura:

~~~text
RequisicaoMatrizResponsabilidade
~~~

Relacionamento:

~~~text
Empresa
+ Tipo da Requisição
→ Setor de Atendimento
→ Setor de Aquisição
~~~

Regra conceitual:

~~~text
Origem da necessidade
!=
Responsável pelo atendimento
!=
Responsável pela aquisição
~~~

A ausência de Matriz válida bloqueia o fluxo dependente dessa resolução.

---

# 9. Estados da Requisição

Fluxo principal inclui estados como:

~~~text
RASCUNHO
AGUARDANDO_APROVACAO
EM_ATENDIMENTO
CONCLUIDA
CANCELADA
REJEITADA
DEVOLVIDA
~~~

O status não deve ser tratado como campo de edição livre pelo frontend.

As transições devem ocorrer por ações específicas.

---

# 10. Rascunho

Enquanto a Requisição estiver em:

~~~text
RASCUNHO
~~~

podem ocorrer:

- edição do cabeçalho;
- inclusão de itens;
- alteração de itens;
- exclusão de itens;
- envio para aprovação.

Salvar cabeçalho ou item não deve iniciar atendimento operacional.

---

# 11. Envio

A ação Enviar altera:

~~~text
RASCUNHO
→ AGUARDANDO_APROVACAO
~~~

Essa ação ainda não cria Ordem de Serviço para Manutenção ou TI.

---

# 12. Aprovação

A aprovação inicia o fluxo operacional.

Para Uso/Consumo:

~~~text
Aprovação
→ avaliação de estoque / aquisição
~~~

Para Manutenção e TI:

~~~text
Aprovação
→ garantir Ordem de Serviço
~~~

---

# 13. Ordem de Serviço

Estrutura:

~~~text
OrdemServico
~~~

Relacionamento:

~~~text
Requisicao
1
↓
1
OrdemServico
~~~

A criação deve ser idempotente.

Não criar múltiplas OS para a mesma Requisição.

---

# 14. Momento de Criação da OS

Regra homologada:

~~~text
RASCUNHO
→ sem OS

AGUARDANDO_APROVACAO
→ sem OS

APROVAÇÃO
→ cria ou garante OS
~~~

Criar ou alterar itens antes da aprovação não cria OS.

---

# 15. Estados da Ordem de Serviço

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

# 16. OS como Fonte Operacional

Depois da criação da OS:

~~~text
OS
→ fonte operacional da Requisição
~~~

Sincronização:

~~~text
ABERTA
EM_TRIAGEM
EM_ATENDIMENTO
AGUARDANDO_MATERIAL
AGUARDANDO_TERCEIRO
→ Requisição EM_ATENDIMENTO
~~~

~~~text
OS CONCLUIDA
→ Requisição CONCLUIDA
~~~

`OS CANCELADA` não cancela automaticamente a Requisição.

---

# 17. Materiais da Ordem de Serviço

Estrutura:

~~~text
OrdemServicoMaterial
~~~

O material pertence diretamente à OS.

Campos operacionais incluem:

- Produto;
- descrição;
- Unidade;
- quantidade necessária;
- quantidade atendida;
- quantidade pendente;
- status.

Não criar segunda Requisição para material da mesma OS.

---

# 18. Estados do Material da OS

Estados homologados:

~~~text
PENDENTE
DISPONIVEL
EM_COMPRA
ATENDIDA
CANCELADA
~~~

`DISPONIVEL` significa:

~~~text
há estoque para atendimento
~~~

Não significa que a baixa já foi realizada.

---

# 19. Atendimento do Material

Fluxo:

~~~text
DISPONIVEL
→ ação Atender
→ baixa de estoque
→ ATENDIDA
~~~

A baixa deve ocorrer de forma explícita.

Disponibilidade e atendimento são eventos distintos.

---

# 20. OS sem Material

Uma OS pode ser concluída sem materiais quando o serviço não exigir consumo de item físico.

Fluxo:

~~~text
OS
→ execução
→ Concluir
~~~

---

# 21. OS com Material Pendente

Quando existe material pendente, a conclusão da OS deve ser bloqueada.

~~~text
material pendente
→ não concluir OS
~~~

---

# 22. AGUARDANDO_MATERIAL

Esse estado representa indisponibilidade real.

~~~text
PENDENTE ou EM_COMPRA
+
estoque insuficiente
→ AGUARDANDO_MATERIAL
~~~

Material apenas `DISPONIVEL` não deve manter a OS nesse estado.

---

# 23. Materiais Mistos

Quando existem vários materiais:

~~~text
um disponível
+
outro ainda sem estoque
→ AGUARDANDO_MATERIAL
~~~

Somente quando nenhuma pendência depender mais de aquisição a OS pode voltar para atendimento normal.

---

# 24. Conclusão da OS

Mesmo após todos os materiais serem atendidos:

~~~text
materiais atendidos
!=
OS concluída
~~~

A conclusão permanece uma ação operacional explícita.

---

# 25. Histórico da Requisição

Quando a OS é concluída, a Requisição registra historicamente o atendimento.

Exemplo funcional:

~~~text
Atendida pela OS nº X.
~~~

O registro deve ser idempotente.

---

# 26. Uso/Consumo com Estoque

Fluxo:

~~~text
Requisição
→ Aprovação
→ Almoxarifado Central
→ Estoque disponível
→ Atender
→ Conclusão
~~~

O estoque consultado pertence à localização física determinada pelo Setor de Atendimento.

---

# 27. Almoxarifado Central

A localização física decorre de:

~~~text
Setor de Atendimento
→ Loja associada
~~~

A Loja solicitante não deve ser utilizada automaticamente como estoque de origem.

---

# 28. Uso/Consumo sem Estoque

Fluxo:

~~~text
Requisição
→ Aprovação
→ necessidade de aquisição
→ Cotação
→ Pedido de Compra
→ Entrada de NF-e
→ Estoque Central
→ Atendimento
→ Conclusão
~~~

---

# 29. Necessidades de Compra

A fila de necessidades aceita duas origens:

~~~text
REQ
OS
~~~

Onde:

~~~text
REQ
→ item de Requisição de Uso/Consumo

OS
→ OrdemServicoMaterial
~~~

---

# 30. Necessidade Líquida

A necessidade de compra considera conceitualmente:

~~~text
quantidade pendente
- estoque central disponível
- quantidade já coberta por compra
~~~

Não gerar compra duplicada para necessidade já coberta.

---

# 31. Proibição de Duplicidade REQ + OS

Para Manutenção e TI com OS:

~~~text
item original da Requisição
→ não entra como necessidade de material
~~~

A necessidade física deve partir de:

~~~text
OrdemServicoMaterial
~~~

Isso impede:

~~~text
REQ + OS
→ compra duplicada
~~~

---

# 32. Cotação

A necessidade pode seguir para o domínio de Cotação.

A Cotação pode receber necessidades de origem:

- Requisição;
- material de OS;
- item avulso conforme regras próprias do módulo.

O fluxo não cria uma infraestrutura paralela de Compras.

---

# 33. Pedido de Compra Gerado

Quando o Pedido é criado a partir do processo interno:

~~~text
Destino
→ localização central configurada
~~~

Para Uso/Consumo e material interno, a Loja de destino deve refletir a unidade física central apropriada.

---

# 34. Entrada de NF-e

A entrada física ocorre no fechamento da NF.

~~~text
Pedido
→ NF-e de Entrada
→ Estoque
~~~

A simples aprovação do Pedido não representa recebimento.

---

# 35. Estoque Dedicado de Uso/Consumo

Produto:

~~~text
tipo_produto = '2'
~~~

utiliza:

~~~text
ProdutoUsoConsumoEstoque
ProdutoUsoConsumoMovimentacao
~~~

Essa regra vale independentemente da origem do Pedido.

Inclusive:

~~~text
Pedido manual tipo 2
→ estoque dedicado
~~~

---

# 36. Separação de Ledgers

Produto Uso/Consumo não deve utilizar automaticamente o ledger comercial de Produto Venda.

~~~text
tipo 2
→ estoque Uso/Consumo

Produto Venda
→ estoque comercial
~~~

Essas estruturas são distintas.

---

# 37. Sincronização Pós-NF

Após Entrada de NF-e válida:

~~~text
estoque atualizado
→ necessidades relacionadas recalculadas
~~~

Exemplo:

~~~text
OrdemServicoMaterial EM_COMPRA
→ DISPONIVEL
~~~

Outro exemplo:

~~~text
Requisição aguardando aquisição
→ material disponível
→ retorna ao atendimento
~~~

---

# 38. Atendimento da Requisição

O atendimento deve bloquear condições incompatíveis.

Não atender novamente item:

- cancelado;
- rejeitado;
- já atendido;
- coberto por processo incompatível;
- serviço já concluído.

Operações críticas de estoque devem permanecer transacionais.

---

# 39. Permissões

A arquitetura funcional utiliza Perfil de Acesso como fonte de permissões.

Permissões específicas da Requisição:

~~~text
requisicoes.fazer
requisicoes.aprovar
requisicoes.atender
~~~

A visibilidade e as ações devem respeitar as permissões efetivas.

O backend permanece autoridade.

---

# 40. Imutabilidade da Requisição Concluída

Requisição:

~~~text
CONCLUIDA
~~~

permanece consultável.

Não permite:

- edição de cabeçalho;
- edição de itens;
- inclusão;
- exclusão de item;
- novo atendimento;
- envio para Cotação.

---

# 41. Imutabilidade da OS Concluída

OS:

~~~text
CONCLUIDA
~~~

não permite:

- PUT/PATCH operacional;
- inclusão de material;
- alteração de material;
- exclusão de material;
- novo atendimento de material.

Mensagem funcional protegida pelo backend:

~~~text
Ordem de Serviço concluída não pode mais ser alterada.
~~~

---

# 42. Frontend

O frontend possui funcionalidades para:

- Requisições;
- Matriz de Responsabilidade;
- Ordens de Serviço;
- materiais;
- ações de atendimento;
- integração com Cotação.

O frontend deve refletir os estados retornados pelo backend.

Não implementar regra crítica apenas por ocultação de botão.

---

# 43. Multiempresa

Todas as estruturas devem respeitar Empresa.

Proteções incluem:

- Requisição;
- Setor;
- Matriz;
- OS;
- materiais;
- Produto;
- Loja;
- Estoque;
- Cotação;
- Pedido;
- NF.

Uma API não pode atravessar tenant mesmo com IDs manipulados diretamente.

---

# 44. Integrações

Integrações principais:

~~~text
Requisição
↓
Matriz de Responsabilidade
↓
Almoxarifado / Ordem de Serviço
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
~~~

---

# 45. Escopo Não Incluído nesta Fase

Não fazem parte desta homologação:

- Patrimônio / Ativo Imobilizado;
- contratos de manutenção;
- gestão completa de prestador externo;
- contratação formal de serviço originada pela OS;
- SLA;
- múltiplos almoxarifados regionais;
- NFS-e de serviços;
- gestão de contratos.

Esses itens exigem definição própria antes de implementação.

---

# 46. Regra de Preservação

Este fluxo está homologado.

Não reabrir regras funcionando corretamente apenas para reconfirmá-las.

Nova alteração deve partir de:

- erro real;
- vulnerabilidade;
- ausência;
- novo requisito;
- nova integração;
- melhoria necessária.

---

# 47. Referências

- [[Sysvar]]
- [[Mapa Técnico]]
- [[Arquitetura]]
- [[Homologação - Compras - Requisições e Ordens de Serviço]]
- [[Workflows - Compras - Requisições e Ordens de Serviço]]
- [[Modelo de Domínio - Compras - Requisições e Ordens de Serviço]]
- [[Riscos e Cuidados - Compras - Requisições e Ordens de Serviço]]