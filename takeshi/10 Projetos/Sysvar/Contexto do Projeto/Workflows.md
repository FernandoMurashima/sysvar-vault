---
type: reference
status: active
project: Sysvar
source: "C:/SysvarProjeto"
created: 2026-08-03
updated: 2026-08-25
tags:
  - sysvar
  - contexto
  - workflows
  - operacional
  - cadastros
  - produtos
  - produto-venda
  - produto-uso-consumo
  - insumos
  - cadastros-auxiliares
  - autenticação
  - sessões
  - licenciamento
  - compras
  - pedido-de-compra
  - cotacao
  - almoxarifado
  - ti
  - manutencao
  - ordem-de-servico
  - requisicoes
  - financeiro
  - fiscal
  - estoque
  - produção
  - auditoria
  - multiempresa
  - homologado
---

# Workflows

## Objetivo

Este documento descreve os principais fluxos transversais e funcionais do [[Sysvar]].

Ele funciona como mapa central de processos e deve apontar para os documentos específicos quando um domínio possuir regras próprias mais detalhadas.

Os fluxos atualmente consolidados abrangem:

- Operacional;
- autenticação;
- contratos;
- sessões;
- licenciamento;
- Perfis e Permissões;
- Auditoria Central;
- Clientes;
- Fornecedores;
- Funcionários;
- Produto Venda;
- Produto Uso/Consumo;
- Insumos;
- Cadastros Auxiliares de Produtos;
- Requisições Internas;
- Ordens de Serviço;
- Cotação;
- Pedido de Compra.

---

# 1. Estado Atual

~~~text
OPERACIONAL
→ CONCLUÍDO
→ HOMOLOGADO
→ DOCUMENTADO

CLIENTES
→ CONCLUÍDO
→ 23/23 HOMOLOGADOS
→ DOCUMENTADO

FORNECEDORES
→ CONCLUÍDO
→ 30/30 HOMOLOGADOS
→ DOCUMENTADO

FUNCIONÁRIOS
→ CONCLUÍDO
→ 17/17 HOMOLOGADOS
→ DOCUMENTADO

PRODUTO VENDA
→ CONCLUÍDO
→ 19/19 HOMOLOGADOS
→ DOCUMENTADO

PRODUTO USO/CONSUMO
→ CONCLUÍDO
→ HOMOLOGADO
→ DOCUMENTADO

INSUMOS
→ CONCLUÍDO
→ HOMOLOGADO
→ DOCUMENTADO

CADASTROS AUXILIARES DE PRODUTOS
→ CONCLUÍDOS
→ HOMOLOGADOS
→ DOCUMENTADOS

REQUISIÇÕES INTERNAS
→ CONCLUÍDAS
→ TESTADAS
→ HOMOLOGADAS
→ APROVADAS
→ DOCUMENTADAS

ORDENS DE SERVIÇO
→ CONCLUÍDAS
→ TESTADAS
→ HOMOLOGADAS
→ APROVADAS
→ DOCUMENTADAS

CICLO DE COMPRA DE USO/CONSUMO
→ CONCLUÍDO
→ TESTADO
→ HOMOLOGADO
→ APROVADO
→ DOCUMENTADO
PEDIDO DE COMPRA
→ UNIFICADO
→ CONCLUÍDO
→ TESTADO
→ HOMOLOGADO
→ APROVADO
→ DOCUMENTADO

ENTRADA DE NF-e
→ CONCLUÍDA
→ TESTADA
→ HOMOLOGADA
→ APROVADA
→ DOCUMENTADA
~~~

---

# 2. Princípio Geral dos Workflows

Todo fluxo relevante deve seguir:

~~~text
USUÁRIO
   ↓
FRONTEND
   ↓
BACKEND
   ↓
VALIDAÇÃO DE EMPRESA
   ↓
VALIDAÇÃO DE PERMISSÃO
   ↓
VALIDAÇÃO DA REGRA FUNCIONAL
   ↓
OPERAÇÃO
   ↓
AUDITORIA QUANDO APLICÁVEL
   ↓
RESPOSTA
~~~

O frontend não substitui validações do backend.

---

# 3. Multiempresa

Fluxo transversal:

~~~text
Usuário autenticado
        ↓
Empresa atual
        ↓
Solicita recurso
        ↓
Backend identifica tenant
        ↓
Objeto pertence à Empresa?
   ├── Sim → continuar
   └── Não → bloquear
~~~

A validação deve existir também nos relacionamentos.

Exemplo:

~~~text
Produto Empresa A
+
Grupo Empresa B
        ↓
REJEITAR
~~~

Outro exemplo:

~~~text
Pedido Empresa A
+
Fornecedor Empresa B
        ↓
REJEITAR
~~~

---

# 4. Login

Fluxo conceitual:

~~~text
Usuário informa credenciais
        ↓
Backend valida Usuário
        ↓
Valida Empresa
        ↓
Valida contrato
        ↓
Valida situação
        ↓
Encerra sessões expiradas
        ↓
Verifica substituição válida
        ↓
Verifica limite simultâneo
        ↓
Cria sessão
        ↓
Cria token
        ↓
Retorna contexto
~~~

---

# 5. Limite de Sessões

~~~text
Sessões válidas atuais
        ↓
Comparar com limite contratado
        ↓
Há vaga?
   ├── Sim → login permitido
   └── Não → bloquear login
~~~

Código funcional:

~~~text
CONCURRENT_SESSION_LIMIT_REACHED
~~~

Nenhuma sessão utilizável deve ser criada quando o login é bloqueado.

---

# 6. Mesmo Usuário no Mesmo Dispositivo

~~~text
Mesmo Usuário
+
Mesmo device_id
        ↓
Encerrar sessão anterior desse Usuário
        ↓
Revogar token anterior
        ↓
Criar nova sessão
        ↓
Continuar consumindo uma vaga
~~~

---

# 7. Usuários Diferentes no Mesmo Dispositivo

~~~text
Usuário A
+
Usuário B
+
Mesmo device_id
        ↓
Sessões independentes
~~~

Não substituir sessão apenas por coincidência de dispositivo.

---

# 8. Logout

Ordem correta:

~~~text
Frontend mantém token
        ↓
Solicita logout
        ↓
Backend localiza sessão
        ↓
Encerra sessão
        ↓
Revoga token
        ↓
Libera vaga
        ↓
Audita
        ↓
Frontend interrompe heartbeat
        ↓
Limpa contexto
        ↓
Redireciona
~~~

---

# 9. Timeout

~~~text
Sessão sem atividade válida
        ↓
Atinge timeout
        ↓
Sessão encerrada
        ↓
Token revogado
        ↓
Vaga liberada
~~~

Sessões abandonadas não devem ocupar licença indefinidamente.

---

# 10. Heartbeat

~~~text
Sessão autenticada
        ↓
Heartbeat
        ↓
Backend valida:
- token
- sessão
- Usuário
- Empresa
- contrato
- suspensão
        ↓
Atualiza atividade quando válido
~~~

Heartbeat não substitui a autenticação das demais requisições.

---

# 11. Suspensão de Empresa

~~~text
Superusuário autorizado
        ↓
Seleciona Empresa
        ↓
Informa motivo
        ↓
Confirma suspensão
        ↓
Backend inicia transação
        ↓
Suspende contrato
        ↓
Encerra sessões
        ↓
Revoga tokens
        ↓
Libera vagas
        ↓
Auditoria obrigatória
        ↓
Commit
~~~

Falha em etapa obrigatória deve provocar rollback.

---

# 12. Reativação da Empresa

~~~text
Empresa suspensa
        ↓
Superusuário solicita Reativar
        ↓
Backend valida
        ↓
Reativa contrato
        ↓
Registra Auditoria
        ↓
Usuários fazem novo login
~~~

Sessões antigas não devem ser restauradas.

---

# 13. Administração de Sessões

~~~text
Administrador abre sessões
        ↓
Backend retorna apenas sessões válidas
        ↓
Frontend mostra:
- Usuário
- Empresa
- dispositivo
- início
- última atividade
- Status
        ↓
Administrador pode encerrar sessão
~~~

O contador deve utilizar a mesma definição da listagem.

---

# 14. Perfis e Permissões

Fluxo:

~~~text
Usuário
   ↓
Empresa
   ↓
Perfil
   ↓
Módulos contratados
   ↓
Permissões do Perfil
   ↓
Overrides individuais
   ↓
Permissão Efetiva
~~~

Valores conceituais:

~~~text
NONE
VIEW
EDIT
~~~

Override:

~~~text
HERDAR
NONE
VIEW
EDIT
~~~

---

# 15. Troca Obrigatória de Senha

~~~text
deve_trocar_senha = true
        ↓
Login permitido
        ↓
Acesso normal bloqueado
        ↓
Usuário acessa troca de senha
        ↓
Informa senha atual
        ↓
Informa nova senha
        ↓
Backend valida
        ↓
Atualiza senha
        ↓
Remove pendência
        ↓
Encerra demais sessões quando previsto
        ↓
Audita
        ↓
Recarrega contexto
~~~

---

# 16. Auditoria Central

Fluxo conceitual:

~~~text
Operação relevante
        ↓
Backend identifica:
- Empresa
- Usuário
- ação
- origem
- resultado
        ↓
AuditService
        ↓
AuditLog
~~~

Dados sensíveis não devem ser registrados.

---

# 17. Cliente — Cadastro

~~~text
Cadastros
   ↓
Clientes
   ↓
Novo
   ↓
PF / PJ
   ↓
Documento informado?
   ├── Sim → validar e normalizar
   └── Não → permitir quando regra aceitar
        ↓
Validar unicidade por Empresa
        ↓
Salvar
        ↓
Auditar
~~~

Documentação:

[[Workflows - Cadastros - Clientes]]

---

# 18. Cliente — Unicidade

~~~text
Empresa + documento
~~~

Mais de um Cliente sem documento pode existir.

Não utilizar documento como unicidade global entre Empresas.

---

# 19. Consumidor Final

~~~text
Empresa
   ↓
Consumidor Final próprio
~~~

Venda sem Cliente identificado:

~~~text
usar Consumidor Final da Empresa
~~~

Não utilizar Consumidor Final global.

---

# 20. Cliente — Ciclo de Vida

~~~text
ATIVO
  ↓
INATIVAR
  ↓
INATIVO
  ↓
ATIVAR
  ↓
ATIVO
~~~

Bloqueio possui fluxo próprio quando aplicável.

Cliente histórico deve ser preservado.

---

# 21. Cliente — Exclusão

~~~text
Cliente sem vínculos
        ↓
DELETE pode ser permitido

Cliente com vínculos
        ↓
DELETE negado
        ↓
Utilizar Inativação
~~~

---

# 22. Fornecedor — Cadastro

~~~text
Cadastros
   ↓
Fornecedores
   ↓
Novo
   ↓
PF / PJ
   ↓
Identificação
   ↓
Categorias
   ↓
Contatos
   ↓
Endereços
   ↓
Fiscal
   ↓
Comercial
   ↓
Financeiro
   ↓
Salvar
~~~

Documentação:

[[Workflows - Cadastros - Fornecedores]]

---

# 23. Fornecedor — Categorias

Um Fornecedor pode possuir múltiplas categorias.

~~~text
Fornecedor
   ├── MATERIA_PRIMA
   ├── AVIAMENTO
   ├── REVENDA
   ├── FACCAO
   ├── PRESTADOR
   ├── TRANSPORTADORA
   └── OUTROS
~~~

Categoria classifica e orienta.

Não deve bloquear universalmente processos sem regra própria.

---

# 24. Fornecedor — Compras

~~~text
Fornecedor utilizável
        ↓
Pedido de Compra
        ↓
Itens
        ↓
Forma / Prazo
        ↓
Aprovação
        ↓
Financeiro
        ↓
Recebimento Fiscal
        ↓
Estoque
~~~

Compras continua sendo responsável pela aquisição.

---

# 25. Fornecedor — Exclusão

~~~text
Fornecedor sem vínculos
→ exclusão pode ser permitida

Fornecedor utilizado
→ preservar
→ Inativar
~~~

---

# 26. Funcionário — Cadastro

~~~text
Cadastros
   ↓
Funcionários
   ↓
Novo
   ↓
Empresa
   ↓
CPF
   ↓
Matrícula
   ↓
Cargo
   ↓
Loja Principal
   ↓
Abrangência quando aplicável
   ↓
Comissão quando aplicável
   ↓
Usuário opcional
   ↓
Salvar
~~~

Documentação:

[[Workflows - Cadastros - Funcionários]]

---

# 27. Funcionário — Ciclo Operacional

~~~text
ATIVO
  ↓
AFASTAR
  ↓
AFASTADO
  ↓
RETORNAR
  ↓
ATIVO
  ↓
DESLIGAR
  ↓
DESLIGADO
  ↓
RECONTRATAR
  ↓
ATIVO
~~~

Recontratação utiliza o mesmo cadastro.

---

# 28. Funcionário e Usuário

~~~text
Funcionário
        ↓
Usuário opcional
~~~

Vincular Usuário não deve alterar automaticamente:

- Cargo;
- Perfil;
- Permissões;
- Lojas permitidas;
- sessões.

---

# 29. Funcionário e Venda

~~~text
Venda
   ├── vendedor → Funcionário
   └── criado_por → Usuário
~~~

São responsabilidades diferentes.

---

# 30. Grupo Produtos

Fluxos cadastrais consolidados:

~~~text
Produtos
   ├── Produto Venda
   │     ├── Revenda
   │     └── Fabricação Própria
   │
   ├── Produto Uso/Consumo
   │
   ├── Insumos
   │
   └── Cadastros Auxiliares
~~~

---

# 31. Tipos de Produto

~~~text
1 = Revenda
2 = Uso/Consumo
3 = Fabricação Própria
4 = Insumo
~~~

O tipo determina regras funcionais específicas.

---

# 32. Produto Venda — Novo

~~~text
Produtos
   ↓
Produto Venda
   ↓
Novo
   ↓
Selecionar Tipo:
1 Revenda
ou
3 Fabricação Própria
   ↓
Informar dados obrigatórios
   ↓
Grupo
   ↓
Subgrupo
   ↓
Coleção
   ↓
Unidade
   ↓
Grade
   ↓
Cores
   ↓
Backend gera Referência
   ↓
Backend cria/sincroniza SKUs
   ↓
EANs
   ↓
Dados Fiscais
   ↓
Lojas quando aplicável
   ↓
Salvar
~~~

Documentação:

[[Workflows - Produtos - Produto Venda]]

---

# 33. Produto Venda — Referência

~~~text
Coleção
+
Estação
+
CodigoRef do Grupo
+
Sequência
        ↓
AA-BB-CCDDD
~~~

Referência é gerada pelo backend.

---

# 34. Produto Venda — Grade e Cores

~~~text
Grade
   ↓
Tamanhos

Produto
+
Cor
+
Tamanhos
        ↓
SKUs
~~~

---

# 35. Produto Venda — Nova Cor

~~~text
Adicionar Cor
        ↓
Para cada Tamanho da Grade
        ↓
SKU já existia?
   ├── Não → criar SKU
   └── Sim e inativo → reativar
~~~

---

# 36. Produto Venda — Remover Cor

~~~text
Remover Cor
        ↓
Localizar SKUs daquela Cor
        ↓
Inativar
        ↓
Preservar:
- ID
- EAN
- Estoque
- histórico
~~~

Não excluir SKUs.

---

# 37. Produto Venda — Reintroduzir Cor

~~~text
Adicionar novamente Cor anterior
        ↓
Localizar SKUs existentes
        ↓
Reativar
        ↓
Preservar EAN
~~~

---

# 38. Produto Venda — Grade após SKU

~~~text
Produto possui SKU
        ↓
Usuário tenta trocar Grade
        ↓
Backend bloqueia
~~~

Grade é estrutural após a geração de SKUs.

---

# 39. Produto Venda — Estoque Inicial

~~~text
Produto
+
SKU
+
Lojas selecionadas
        ↓
Preparar estrutura Loja × SKU
        ↓
Quantidade inicial = 0
~~~

Isso não representa entrada física.

---

# 40. Produto Venda — Revenda

~~~text
Produto Venda
Tipo 1
   ↓
SKU
   ↓
Pedido de Compra
   ↓
Recebimento Fiscal
   ↓
Estoque
   ↓
Venda
~~~

---

# 41. Produto Venda — Fabricação Própria

~~~text
Produto Venda
Tipo 3
   ↓
SKU
   ↓
Ficha Técnica
   ↓
Ordem de Produção
   ↓
Produção
   ↓
Estoque
   ↓
Venda
~~~

Produto tipo 3 não participa do Pedido de Compra.

---

# 42. Produto Venda — Ciclo de Vida

~~~text
ATIVO
  ↕
INATIVO
~~~

Estado comercial independente:

~~~text
LIBERADO
  ↕
BLOQUEADO PARA VENDA
~~~

---

# 43. Produto Venda — Exclusão

~~~text
Produto nunca utilizado
        ↓
Verificar vínculos
        ↓
Sem impedimento
        ↓
Excluir

Produto utilizado
        ↓
DELETE negado
        ↓
Inativar ou Bloquear Venda
~~~

---

# 44. Produto Venda — Consulta

~~~text
Selecionar Produto
        ↓
Consultar
        ↓
Backend retorna dados atuais
        ↓
Exibir somente leitura
~~~

Pode consolidar:

- dados cadastrais;
- classificação;
- SKUs;
- Status dos SKUs;
- EAN;
- custos;
- preços;
- Fiscal;
- imagens;
- Estoque;
- Histórico;
- Produção quando aplicável.

---

# 45. Produto Uso/Consumo — Novo

~~~text
Produtos
   ↓
Produto Uso/Consumo
   ↓
Novo
   ↓
tipo_produto = 2
   ↓
Descrição
   ↓
Unidade
   ↓
Dados Fiscais quando informados
   ↓
Salvar
~~~

Documentação:

[[Workflows - Produtos - Produto Uso e Consumo]]

---

# 46. Uso/Consumo — Estrutura Simplificada

Não executar o fluxo comercial de:

~~~text
Grade
→ Cores
→ Tamanhos
→ SKUs
~~~

Produto Uso/Consumo possui domínio próprio.

---

# 47. Uso/Consumo — Estoque

~~~text
Produto cadastrado
        ↓
Pedido de Compra
        ↓
Recebimento Fiscal
        ↓
Operação determina local
        ↓
Movimento de Estoque
        ↓
Saldo
~~~

Cadastro não fixa localização.

---

# 48. Uso/Consumo — Fiscal

~~~text
Cadastro
        ↓
Dados fiscais completos?
   ├── Sim → Fiscal Completo
   └── Não → Fiscal Incompleto
~~~

Fiscal Incompleto não invalida automaticamente o cadastro.

A operação fiscal exige o necessário quando ocorrer.

---

# 49. Uso/Consumo — Compras

~~~text
Produto Uso/Consumo
        ↓
Pedido de Compra
        ↓
Primeiro item define tipo 2
        ↓
Quantidade conforme Unidade
        ↓
Preço
        ↓
Forma / Prazo
        ↓
Aprovação
        ↓
Financeiro
        ↓
Recebimento Fiscal
        ↓
Estoque
~~~

---

# 50. Uso/Consumo — Ciclo de Vida

~~~text
ATIVO
  ↕
INATIVO
~~~

Não existe necessidade de Bloqueio de Venda porque o domínio não é comercial.

---

# 51. Uso/Consumo — Exclusão

~~~text
Sem dependências
→ exclusão pode ser permitida

Com dependências
→ preservar
→ Inativar
~~~

---

# 52. Insumos — Novo

~~~text
Produtos
   ↓
Insumos
   ↓
Novo
   ↓
tipo_produto = 4
   ↓
Descrição
   ↓
Unidade
   ↓
Material opcional
   ↓
Fiscal quando aplicável
   ↓
Salvar
~~~

Documentação:

[[Workflows - Produtos - Insumos]]

---

# 53. Insumo — Material

~~~text
Material informado?
   ├── Sim → associar
   └── Não → permitir cadastro
~~~

Material permanece opcional.

---

# 54. Insumo — Unidade

~~~text
Insumo
   ↓
Unidade
   ↓
permite_decimal?
   ├── Sim → quantidade fracionária permitida
   └── Não → respeitar quantidade inteira
~~~

A validação concreta ocorre nos processos que manipulam quantidade.

---

# 55. Insumo — Compra

~~~text
Fornecedor
   ↓
Pedido de Compra
   ↓
Primeiro item define tipo 4
   ↓
Insumo
   ↓
Quantidade conforme Unidade
   ↓
Forma / Prazo
   ↓
Aprovação
   ↓
Financeiro
   ↓
Recebimento Fiscal
   ↓
Movimento de Estoque
   ↓
Saldo
~~~

---

# 56. Insumo — Ficha Técnica

~~~text
Produto Fabricação Própria
        ↓
Ficha Técnica
        ↓
Adicionar Item
        ↓
Selecionar Insumo
        ↓
Informar Quantidade
        ↓
Salvar relação
~~~

Quantidade pertence à relação Ficha Técnica × Insumo.

---

# 57. Insumo — Necessidade Teórica

~~~text
Quantidade do Insumo na Ficha
×
Quantidade a produzir
=
Necessidade teórica
~~~

Exemplo:

~~~text
1,80 M
×
100 peças
=
180 M
~~~

---

# 58. Insumo — OP

Fluxo conceitual atual:

~~~text
OP
   ↓
Produto Fabricação Própria
   ↓
Ficha Técnica
   ↓
Necessidade de Insumos
~~~

Não assumir:

~~~text
CRIAR OP
=
BAIXAR ESTOQUE
~~~

---

# 59. Insumo — Reserva

Também não assumir:

~~~text
CRIAR OP
=
RESERVAR AUTOMATICAMENTE
~~~

O fluxo de reserva deverá ser definido no módulo Produção/Estoque.

---

# 60. Insumo — Consumo Futuro

Quando o processo produtivo for definido:

~~~text
Necessidade prevista
        ↓
Separação / Reserva
        ↓
Consumo real
        ↓
Movimento de Estoque
        ↓
Apuração de diferença
~~~

Não antecipar essa implementação dentro do cadastro de Insumos.

---

# 61. Cadastros Auxiliares

Documentação:

[[Workflows - Produtos - Cadastros Auxiliares]]

Estruturas principais:

~~~text
Grupo
→ Subgrupos

Grade
→ Tamanhos

Pack
→ Itens
~~~

Outros auxiliares:

- Coleções;
- Unidades;
- Cores;
- Material.

---

# 62. Workflow Genérico de Cadastro Auxiliar

~~~text
Abrir listagem
        ↓
Backend aplica Empresa
        ↓
Filtros
        ↓
Paginação
        ↓
Usuário seleciona registro
        ↓
Barra de ações
~~~

Ações conforme tela:

~~~text
Consultar
Editar
Excluir
Detalhe quando aplicável
~~~

---

# 63. Seleção de Linha

~~~text
Checkbox
        ↓
Seleção única
        ↓
Linha destacada
        ↓
Barra de ações atua sobre o selecionado
~~~

Esse é o padrão homologado das telas modernizadas.

---

# 64. Grupo e Subgrupos

~~~text
Grupo selecionado
        ↓
Subgrupos
        ↓
Abrir sobretela
        ↓
Listar filhos do Grupo
        ↓
Selecionar Subgrupo
        ↓
Consultar / Editar / Excluir
~~~

---

# 65. Grade e Tamanhos

~~~text
Grade selecionada
        ↓
Tamanhos
        ↓
Abrir sobretela
        ↓
Listar Tamanhos da Grade
        ↓
Selecionar Tamanho
        ↓
Consultar / Editar / Excluir
~~~

---

# 66. Pack e Itens

~~~text
Pack selecionado
        ↓
Itens
        ↓
Selecionar Tamanho
        ↓
Informar Quantidade
        ↓
Backend valida:
- Tamanho pertence à Grade
- Tamanho não repete
- Quantidade > 0
        ↓
Salvar Item
~~~

---

# 67. Pack e Compras

~~~text
Pack
   ↓
Somar quantidades dos Itens
   ↓
Quantidade por Pack
   ↓
Número de Packs
   ↓
Quantidade total de peças
~~~

Fórmula:

~~~text
n_packs
×
soma_itens_pack
=
quantidade de peças
~~~

Esse fluxo é utilizado pelo Pedido de Compra de Revenda.

---

# 68. Coleções

~~~text
Novo
   ↓
Código
   ↓
Estação
   ↓
Descrição
   ↓
Status
   ↓
Salvar
~~~

Estação:

~~~text
01 = Verão
02 = Outono
03 = Inverno
04 = Primavera
~~~

Status:

~~~text
CR
PD
AT
EN
AR
~~~

---

# 69. Unidades

~~~text
Novo
   ↓
Código
   ↓
Descrição
   ↓
Permite Decimal
   ↓
Salvar
~~~

A propriedade da Unidade deve ser respeitada pelos processos consumidores.

---

# 70. Material

~~~text
Novo Material
        ↓
Código
        ↓
Descrição
        ↓
Ativo
        ↓
Salvar
~~~

Material continua sendo classificação.

Não executa Estoque ou Produção.

---

# 71. Consulta em Sobretela

Padrão:

~~~text
Selecionar registro
        ↓
Consultar
        ↓
Abrir sobretela/modal
        ↓
Somente leitura
        ↓
Fechar
        ↓
Manter contexto da listagem
~~~

---

# 72. Exclusão Protegida dos Auxiliares

~~~text
Solicitar Excluir
        ↓
Backend verifica dependências
        ↓
Registro utilizado?
   ├── Não → excluir quando permitido
   └── Sim → bloquear
~~~

---

# 73. Paginação Server-Side

~~~text
Frontend envia:
- page
- page_size
- filtros
- ordering
        ↓
Backend filtra
        ↓
Backend pagina
        ↓
Retorna:
- count
- results
~~~

---

# 74. Filtros Server-Side

Filtros devem ser processados sobre o conjunto total permitido.

Não apenas sobre os registros da página atual.

---

# 75. Consulta Atualizada por ID

Quando a tela possui endpoint de detalhe:

~~~text
Selecionar linha
        ↓
Obter ID
        ↓
Buscar backend
        ↓
Abrir dados atuais
~~~

Evitar depender apenas de snapshot antigo da listagem.

---

# 76. Exclusão Geral

Princípio transversal:

~~~text
NUNCA UTILIZADO
        ↓
Exclusão pode ser possível

JÁ UTILIZADO
        ↓
Preservar histórico
        ↓
Inativar / Desligar / Bloquear / Cancelar
conforme domínio
~~~

---

# 77. Grupo Compras

Os fluxos homologados do grupo são:

~~~text
Compras
├── Pedido de Compra
└── Entrada de NF-e
~~~

O Pedido de Compra representa a intenção formal de aquisição.

A Entrada de NF-e representa o recebimento efetivo dessa aquisição.

Tipos participantes:

~~~text
1 = Revenda
2 = Uso/Consumo
4 = Insumo
~~~

Não participante:

~~~text
3 = Fabricação Própria
~~~

Documentação específica:

- [[Workflows - Compras - Pedido de Compra]]
- [[Workflows - Compras - Entrada de NF-e]]

---

# Requisições Internas — Fluxo Geral

~~~text
Usuário
↓
Nova Requisição
↓
Seleciona Loja
↓
Seleciona Setor da Loja
↓
Define Tipo
↓
Inclui Itens
↓
RASCUNHO
↓
Enviar
↓
AGUARDANDO_APROVACAO
↓
Aprovar
↓
Fluxo operacional
~~~

Tipos homologados:

~~~text
USO_CONSUMO
MANUTENCAO
TI
~~~

A Requisição permanece em RASCUNHO durante a preparação.

Criar ou alterar item não inicia atendimento.

---

# Requisições — Loja e Setor

~~~text
Seleciona Loja
↓
Sistema oferece Setores da Loja
↓
Seleciona Setor compatível
~~~

O backend também valida:

~~~text
Setor.loja
=
Requisicao.loja
~~~

Setor de outra Loja deve ser rejeitado.

---

# Requisições — Matriz de Responsabilidade

Depois da aprovação:

~~~text
Empresa
+
Tipo de Requisição
↓
Matriz de Responsabilidade
↓
Setor de Atendimento
+
Setor de Aquisição
~~~

Regra:

~~~text
Origem da necessidade
!=
Responsável pelo atendimento
!=
Responsável pela aquisição
~~~

Sem Matriz válida, o fluxo dependente dela deve ser bloqueado.

---

# Uso/Consumo — Atendimento com Estoque

~~~text
Requisição aprovada
↓
Resolver Almoxarifado Central
↓
Consultar estoque dedicado
↓
Saldo suficiente?
├── Sim
│   ↓
│   Atender
│   ↓
│   Baixar estoque
│   ↓
│   CONCLUIDA
│
└── Não
    ↓
    Necessidade de aquisição
~~~

A Loja solicitante não é automaticamente a origem do estoque.

---

# Uso/Consumo — Compra por Falta de Estoque

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
Fornecedor / Proposta
↓
Aprovação da Cotação
↓
Pedido de Compra
↓
Entrada de NF-e
↓
ProdutoUsoConsumoEstoque
↓
Requisição volta ao atendimento
↓
Atender
↓
CONCLUIDA
~~~

A entrada física acontece na NF-e, não na aprovação do Pedido.

---

# Manutenção / TI — Criação da OS

~~~text
RASCUNHO
↓
sem OS

AGUARDANDO_APROVACAO
↓
sem OS

Aprovação
↓
criar ou garantir OS
↓
Requisição EM_ATENDIMENTO
~~~

A criação da OS deve ser idempotente.

---

# Manutenção / TI — Execução sem Material

~~~text
Requisição aprovada
↓
OS
↓
Execução
↓
Concluir OS
↓
OS CONCLUIDA
↓
Requisição CONCLUIDA
~~~

Uma OS pode ser concluída sem material quando o serviço não exigir consumo físico.

---

# Manutenção / TI — Material Disponível

~~~text
OS
↓
Adicionar Material
↓
Consultar estoque central
↓
Saldo disponível
↓
Material DISPONIVEL
↓
Atender Material
↓
Baixa de estoque
↓
Material ATENDIDA
↓
Concluir OS manualmente
↓
Requisição CONCLUIDA
~~~

`DISPONIVEL` não significa baixa realizada.

---

# Manutenção / TI — Material sem Estoque

~~~text
OS
↓
Material necessário
↓
Saldo insuficiente
↓
Material PENDENTE / EM_COMPRA
↓
OS AGUARDANDO_MATERIAL
↓
Necessidade OS
↓
Cotação
↓
Pedido de Compra
↓
Entrada de NF-e
↓
Estoque disponível
↓
Material DISPONIVEL
↓
OS EM_ATENDIMENTO
↓
Atender Material
↓
Material ATENDIDA
↓
Concluir OS
↓
Requisição CONCLUIDA
~~~

---

# OS — Materiais Mistos

~~~text
Material A
→ DISPONIVEL

Material B
→ EM_COMPRA
↓
OS AGUARDANDO_MATERIAL
~~~

Enquanto existir material realmente sem cobertura, a OS permanece aguardando material.

---

# OS — Conclusão

~~~text
Existe material pendente?
├── Sim → bloquear conclusão
└── Não → permitir ação Concluir
~~~

Mesmo com todos os materiais atendidos:

~~~text
Materiais ATENDIDOS
!=
OS CONCLUIDA
~~~

A conclusão da OS é explícita.

---

# Requisição e OS — Sincronização

Enquanto a OS estiver em:

~~~text
ABERTA
EM_TRIAGEM
EM_ATENDIMENTO
AGUARDANDO_MATERIAL
AGUARDANDO_TERCEIRO
~~~

a Requisição permanece:

~~~text
EM_ATENDIMENTO
~~~

Quando:

~~~text
OS CONCLUIDA
↓
Requisição CONCLUIDA
~~~

OS CANCELADA não cancela automaticamente a Requisição.

---

# Necessidades de Compra — REQ e OS

~~~text
REQ
→ RequisicaoItem de Uso/Consumo

OS
→ OrdemServicoMaterial
~~~

Necessidade líquida:

~~~text
Quantidade pendente
-
Estoque disponível
-
Quantidade já coberta por compra
~~~

Para Manutenção e TI com OS:

~~~text
Item da Requisição
→ NÃO gerar necessidade física paralela

Material da OS
→ origem da necessidade
~~~

Evitar duplicidade `REQ + OS`.

---

# Pós-NF — Sincronização

~~~text
Entrada de NF-e
↓
Atualização de estoque
↓
Recalcular necessidades
~~~

Exemplo de OS:

~~~text
EM_COMPRA
↓
DISPONIVEL
~~~

Exemplo de Requisição:

~~~text
Aguardando aquisição
↓
saldo disponível
↓
EM_ATENDIMENTO
~~~

A sincronização deve ser idempotente.

---

# Estados Finais — Requisição e OS

~~~text
CONCLUIDA
↓
consulta permitida
↓
alteração operacional bloqueada
~~~

Requisição concluída não aceita:

- edição de cabeçalho;
- alteração de itens;
- inclusão ou exclusão de itens;
- novo atendimento;
- nova Cotação.

OS concluída não aceita:

- alteração operacional;
- inclusão, edição ou exclusão de material;
- novo atendimento de material.

Documentação específica:

[[Workflows - Compras - Requisições e Ordens de Serviço]]

---
# 78. Pedido de Compra — Entrada

~~~text
Compras
   ↓
Pedido de Compra
   ↓
Listagem unificada
~~~

A listagem pode conter:

- Revenda;
- Uso/Consumo;
- Insumo.

Não existem telas funcionais independentes de Pedido para cada tipo.

---

# 79. Pedido de Compra — Novo

~~~text
Novo Pedido
        ↓
Cabeçalho
        ↓
Empresa
        ↓
Loja
        ↓
Fornecedor
        ↓
Emissão
        ↓
Previsão quando informada
        ↓
Salvar
        ↓
status = AB
tipo = ''
~~~

O usuário não escolhe manualmente o tipo.

---

# 80. Pedido de Compra — Fornecedor

~~~text
Fornecedor selecionado
        ↓
Backend valida:
- Empresa
- ativo
- não bloqueado
        ↓
Válido?
   ├── Sim → continuar
   └── Não → rejeitar
~~~

---

# 81. Pedido de Compra — Primeiro Item

~~~text
Pedido AB
tipo = ''
        ↓
Abrir Itens
        ↓
Selecionar Produto
        ↓
Backend identifica tipo_produto
        ↓
Tipo permitido?
   ├── 1 → Revenda
   ├── 2 → Uso/Consumo
   ├── 4 → Insumo
   └── 3 → rejeitar
        ↓
Criar primeiro item
        ↓
Pedido.tipo = Produto.tipo_produto
~~~

---

# 82. Pedido de Compra — Fabricação Própria

Fluxo inválido:

~~~text
Pedido
   ↓
Selecionar Produto tipo 3
   ↓
Backend
   ↓
REJEITAR
~~~

Fabricação Própria pertence ao fluxo de Produção.

---

# 83. Pedido de Compra — Homogeneidade

Após o primeiro item:

~~~text
Pedido.tipo definido
        ↓
Novo Produto
        ↓
Produto.tipo_produto == Pedido.tipo?
   ├── Sim → permitir
   └── Não → rejeitar
~~~

Não misturar:

~~~text
1 + 2
1 + 4
2 + 4
~~~

---

# 84. Pedido de Compra — Revenda

~~~text
Pedido tipo 1
        ↓
Produto
        ↓
Cor
        ↓
Pack
        ↓
Número de Packs
        ↓
Backend soma PackItem
        ↓
Calcula quantidade
        ↓
Preço
        ↓
Desconto quando houver
        ↓
Total do item
~~~

Quantidade:

~~~text
qtd =
n_packs
×
soma_itens_pack
~~~

A quantidade não é digitada livremente.

---

# 85. Pedido de Compra — Uso/Consumo

~~~text
Pedido tipo 2
        ↓
Produto
        ↓
Unidade
        ↓
Quantidade
        ↓
Validar permite_decimal
        ↓
Preço
        ↓
Desconto quando houver
        ↓
Total
~~~

Não utiliza Pack.

---

# 86. Pedido de Compra — Insumo

~~~text
Pedido tipo 4
        ↓
Insumo
        ↓
Unidade
        ↓
Quantidade
        ↓
Validar permite_decimal
        ↓
Preço
        ↓
Desconto quando houver
        ↓
Total
~~~

Não utiliza Pack.

---

# 87. Pedido de Compra — Quantidade Decimal

Para tipos 2 e 4:

~~~text
Unidade.permite_decimal?
   ├── true → fracionário permitido
   └── false → exigir quantidade inteira
~~~

Revenda utiliza quantidade inteira derivada do Pack.

---

# 88. Pedido de Compra — Alterar Item

Somente enquanto:

~~~text
status = AB
~~~

Fluxo:

~~~text
Selecionar item
        ↓
Editar
        ↓
Validar regras do tipo
        ↓
Salvar
        ↓
Recalcular item
        ↓
Recalcular Pedido
~~~

---

# 89. Pedido de Compra — Excluir Item

~~~text
Pedido AB
        ↓
Selecionar item
        ↓
Excluir
        ↓
Recalcular Pedido
~~~

Se o item era o último:

~~~text
0 itens
        ↓
Pedido.tipo = ''
~~~

---

# 90. Pedido de Compra — Redefinição de Tipo

Exemplo válido:

~~~text
Pedido AB
tipo = 1
1 item
        ↓
Excluir último item
        ↓
tipo = ''
        ↓
Adicionar Produto tipo 4
        ↓
tipo = 4
~~~

---

# 91. Pedido de Compra — Total do Item

~~~text
quantidade
×
preço unitário
=
valor bruto
        ↓
- desconto do item
        ↓
total_item
~~~

Backend permanece autoridade do cálculo.

---

# 92. Pedido de Compra — Total Geral

~~~text
Somar total_item
        ↓
total_itens
        ↓
- desconto geral
        ↓
+ frete
        ↓
total_pedido
~~~

Fórmula:

~~~text
total_pedido =
total_itens
- total_desconto
+ frete
~~~

Total não pode ser negativo.

---

# 93. Pedido de Compra — Forma de Pagamento

~~~text
Pedido AB
        ↓
Abrir Forma de Pagamento
        ↓
Selecionar Forma
        ↓
Selecionar ou obter Prazo
        ↓
Aplicar
        ↓
Backend valida
        ↓
Gerar parcelas PLAN
~~~

---

# 94. Pedido de Compra — Parcelas Planejadas

~~~text
Total do Pedido
        ↓
Forma / Prazo
        ↓
Dias / Percentuais
        ↓
PedidoCompraParcela
        ↓
PLAN
~~~

Cada parcela pode possuir:

- número;
- vencimento;
- valor;
- percentual.

---

# 95. Pedido de Compra — Vencimentos

~~~text
Data de emissão
+
dias configurados
=
vencimento
~~~

A soma das parcelas deve permanecer coerente com o total.

---

# 96. Pedido de Compra — Sincronização de Parcelas

Enquanto AB:

~~~text
Alterar item / desconto / frete
        ↓
Total do Pedido muda
        ↓
Recalcular
        ↓
Sincronizar parcelas PLAN
~~~

Invariante:

~~~text
soma(parcelas)
=
total_pedido
~~~

---

# 97. Pedido de Compra — Preparação para Aprovação

O Pedido deve possuir:

- status AB;
- pelo menos um item;
- tipo permitido;
- itens homogêneos;
- total positivo;
- Forma de Pagamento;
- planejamento de parcelas consistente.

A Natureza será informada durante a aprovação.

---

# 98. Pedido de Compra — Natureza

~~~text
Usuário solicita Aprovar
        ↓
Selecionar Natureza de Lançamento
        ↓
Backend valida Natureza
        ↓
Natureza pertence à Empresa?
   ├── Sim → continuar
   └── Não → rejeitar
~~~

A Natureza não precisa ocupar permanentemente o cabeçalho principal.

---

# 99. Pedido de Compra — Aprovação

~~~text
Pedido AB
        ↓
Aprovar
        ↓
Validar itens
        ↓
Validar tipo
        ↓
Validar homogeneidade
        ↓
Validar total > 0
        ↓
Validar Forma/Prazo
        ↓
Validar parcelas
        ↓
Validar Natureza
        ↓
Gerar Financeiro
        ↓
Alterar status para AP
        ↓
Auditar
~~~

---

# 100. Pedido de Compra — Atomicidade

A aprovação representa uma unidade lógica.

~~~text
Validações
+
Pagar
+
PagarItem
+
Parcelas
+
Status
+
Auditoria quando obrigatória
=
uma operação
~~~

Em caso de falha:

~~~text
ROLLBACK
~~~

Não deixar aprovação parcial.

---

# 101. Pedido de Compra — Financeiro

Fluxo:

~~~text
PedidoCompraParcela
        ↓
Aprovação
        ↓
Pagar
        ↓
PagarItem
~~~

Separação:

~~~text
PedidoCompraParcela
→ planejamento

PagarItem
→ obrigação financeira
~~~

---

# 102. Pedido de Compra — Estado AP

Depois da aprovação:

~~~text
AB → AP
~~~

AP significa:

- compra aprovada;
- compromisso financeiro criado;
- aguardando atendimento.

Não significa mercadoria recebida.

---

# 103. Pedido de Compra — Aprovação não Movimenta Estoque

Fluxo inválido:

~~~text
Aprovar Pedido
        ↓
Entrada de Estoque
~~~

Fluxo correto:

~~~text
Aprovar Pedido
        ↓
AP
        ↓
Nota Fiscal de Entrada
        ↓
Recebimento
        ↓
Estoque
~~~

---

# 104. Pedido de Compra — Recebimentos

~~~text
Pedido AP
        ↓
Abrir Recebimentos
        ↓
Consultar atendimento
~~~

A sobretela de Recebimentos é principalmente consultiva.

A entrada efetiva ocorre através do Fiscal.

---

# 105. Pedido de Compra — Recebimento Parcial

~~~text
Quantidade pedida
>
Quantidade recebida acumulada
        ↓
Pedido permanece AP
~~~

Exemplo:

~~~text
Pedido = 100
Recebido = 40
        ↓
AP
~~~

---

# 106. Pedido de Compra — Recebimento Integral

~~~text
Quantidade pedida
=
Quantidade recebida válida
        ↓
Todos os itens atendidos
        ↓
AP → AT
~~~

AT significa atendimento integral.

---

# 107. Pedido de Compra — Múltiplos Recebimentos

~~~text
Pedido = 100
        ↓
NF 1 recebe 40
        ↓
AP
        ↓
NF 2 recebe 30
        ↓
AP
        ↓
NF 3 recebe 30
        ↓
AT
~~~

Não presumir:

~~~text
1 Pedido
=
1 Nota Fiscal
~~~

---

# 108. Pedido de Compra — Cancelamento Fiscal

~~~text
Pedido AT
        ↓
NF relacionada é cancelada
        ↓
Recalcular recebimentos válidos
        ↓
Ainda integral?
   ├── Sim → AT
   └── Não → AP
~~~

Esse fluxo depende da integração Fiscal vigente.

---

# 109. Pedido de Compra — Exclusão

~~~text
Selecionar Pedido
        ↓
Excluir
        ↓
status == AB?
   ├── Sim → permitir conforme regras
   └── Não → rejeitar
~~~

Exclusão não substitui cancelamento.

---

# 110. Pedido de Compra — Consulta

~~~text
Selecionar Pedido
        ↓
Consultar
        ↓
Exibir:
- cabeçalho
- tipo
- status
- itens
- totais
- Forma
- Prazo
- parcelas
- recebimentos
~~~

Após aprovação, o Pedido é predominantemente consultivo.

---

# 111. Pedido de Compra — Sobretelas

Estruturas subordinadas:

~~~text
Pedido de Compra
├── Itens
├── Forma de Pagamento
├── Recebimentos
└── Aprovação / Natureza
~~~

A tela principal deve permanecer limpa.

---

# 112. Pedido de Compra — Seleção e Ações

Padrão visual:

~~~text
Selecionar linha
        ↓
Linha destacada
        ↓
Barra de ações
~~~

Não reintroduzir como padrão:

~~~text
Coluna Ações
+
Menu de três pontos
~~~

onde o padrão homologado utiliza seleção de linha.

---

# 113. Pedido de Compra — Multiempresa

Em qualquer operação:

~~~text
Usuário
        ↓
Empresa
        ↓
Pedido
        ↓
Loja / Fornecedor / Produto / Forma / Prazo / Natureza
        ↓
Validar tenant
~~~

Relacionamentos de outra Empresa devem ser rejeitados.

---

# 114. Pedido de Compra — Auditoria

Operações relevantes podem gerar Auditoria.

Exemplos:

- aplicação de Forma;
- alteração relevante;
- geração/regeneração de parcelas;
- aprovação;
- transições.

Utilizar Auditoria Central.

Não criar mecanismo paralelo exclusivo de Compras.

---

# 115. Pedido de Compra — Fluxo Completo Revenda

~~~text
Novo Pedido
        ↓
Cabeçalho
        ↓
Primeiro Produto tipo 1
        ↓
Pedido.tipo = 1
        ↓
Cor
        ↓
Pack
        ↓
Número de Packs
        ↓
Quantidade automática
        ↓
Preço / Desconto
        ↓
Demais itens tipo 1
        ↓
Forma / Prazo
        ↓
Parcelas
        ↓
Aprovação + Natureza
        ↓
Financeiro
        ↓
AP
        ↓
NF Entrada
        ↓
Recebimento
        ↓
AT quando integral
~~~

---

# 116. Pedido de Compra — Fluxo Completo Uso/Consumo

~~~text
Novo Pedido
        ↓
Cabeçalho
        ↓
Primeiro Produto tipo 2
        ↓
Pedido.tipo = 2
        ↓
Quantidade conforme Unidade
        ↓
Preço / Desconto
        ↓
Demais itens tipo 2
        ↓
Forma / Prazo
        ↓
Parcelas
        ↓
Aprovação + Natureza
        ↓
Financeiro
        ↓
AP
        ↓
NF Entrada
        ↓
Recebimento
        ↓
AT quando integral
~~~

---

# 117. Pedido de Compra — Fluxo Completo Insumo

~~~text
Novo Pedido
        ↓
Cabeçalho
        ↓
Primeiro Produto tipo 4
        ↓
Pedido.tipo = 4
        ↓
Quantidade conforme Unidade
        ↓
Preço / Desconto
        ↓
Demais itens tipo 4
        ↓
Forma / Prazo
        ↓
Parcelas
        ↓
Aprovação + Natureza
        ↓
Financeiro
        ↓
AP
        ↓
NF Entrada
        ↓
Recebimento
        ↓
AT quando integral
~~~

---

# Entrada de NF-e — Fluxo Principal

~~~text
Pedido AP
        ↓
Compras
        ↓
Entrada de NF-e
        ↓
Nova NF
        ↓
Selecionar Pedido
        ↓
Informar dados da NF
        ↓
Confirmar itens pelo checkbox OK
        ↓
Fechar
        ↓
Estoque
        ↓
Custos
        ↓
Financeiro
        ↓
Atualizar recebimento
        ↓
Pedido AP ou AT
~~~

Documentação:

[[Workflows - Compras - Entrada de NF-e]]

---

# Entrada de NF-e — Acesso

~~~text
Compras
   ↓
Entrada de NF-e
~~~

Rota:

~~~text
/compras/notas-entrada
~~~

A funcionalidade pertence ao módulo:

~~~text
compras
~~~

Não existe tela separada de:

~~~text
Notas Lançadas
~~~

A própria listagem da Entrada de NF-e permite consultar notas já registradas.

---

# Entrada de NF-e — Nova Nota

~~~text
Nova NF
   ↓
Selecionar Pedido AP
   ↓
Backend valida Empresa
   ↓
Carregar contexto:
- Pedido
- Loja
- Fornecedor
- Tipo
   ↓
Informar:
- Modelo
- Série
- Número
- Emissão
- Entrada
- Chave quando houver
- Frete
- Observações
   ↓
Salvar
   ↓
status = AB
~~~

---

# Entrada de NF-e — Identidade Documental

Regra homologada:

~~~text
Empresa
+ Fornecedor
+ Modelo
+ Série
+ Número
~~~

O Pedido de Compra não participa da unicidade da NF.

Quando informada:

~~~text
Chave de acesso
→ 44 dígitos
→ DV válido
→ única
~~~

---

# Entrada de NF-e — Datas

~~~text
dt_entrada >= dt_emissao
~~~

Entrada anterior à emissão deve ser rejeitada.

---

# Entrada de NF-e — Carregar Itens

~~~text
Pedido selecionado
        ↓
Carregar PedidoCompraItem
        ↓
Calcular:
- Pedida
- Já recebida
- Saldo pendente
- Nesta NF
~~~

Somente recebimentos válidos participam do acumulado.

NF cancelada não deve compor `Já recebida`.

---

# Entrada de NF-e — Confirmar Item

A confirmação homologada utiliza o checkbox:

~~~text
OK
~~~

Fluxo:

~~~text
Checkbox desmarcado
        ↓
Informar quantidade / preço / desconto
        ↓
Marcar OK
        ↓
Backend salva NotaFiscalEntradaItem
        ↓
Sucesso?
   ├── Sim → checkbox permanece marcado
   └── Não → permanece desmarcado
~~~

O checkbox representa persistência real.

---

# Entrada de NF-e — Remover Item

~~~text
Checkbox marcado
        ↓
Usuário desmarca
        ↓
Confirmar remoção
        ↓
Backend remove NotaFiscalEntradaItem
        ↓
Sucesso?
   ├── Sim → checkbox desmarcado
   └── Não → permanece marcado
~~~

---

# Entrada de NF-e — Seleção Visual

~~~text
Linha selecionada
!=
Item confirmado
~~~

A linha selecionada representa contexto visual.

O checkbox representa se o item pertence efetivamente à NF.

---

# Entrada de NF-e — Estado AB

Enquanto:

~~~text
status = AB
~~~

é permitido, conforme regras vigentes:

- editar dados;
- informar quantidades;
- informar preços;
- informar descontos;
- confirmar itens;
- remover itens;
- fechar a NF.

---

# Entrada de NF-e — Estado FE

Após fechamento:

~~~text
AB → FE
~~~

A NF passa a representar recebimento efetivado.

Itens tornam-se consultivos.

Checkbox permanece exibindo o estado, mas desabilitado.

---

# Entrada de NF-e — Estado CA

Após cancelamento:

~~~text
FE → CA
~~~

A NF permanece registrada.

Não existe DELETE físico operacional.

---

# Entrada de NF-e — Revenda

~~~text
Pedido tipo 1
        ↓
Produto
        ↓
Cor
        ↓
Pack
        ↓
Quantidade recebida
        ↓
Validar composição
        ↓
Distribuir pelos tamanhos
        ↓
SKUs
        ↓
Movimento de Estoque
~~~

O recebimento deve respeitar o Pack utilizado no Pedido.

---

# Entrada de NF-e — Uso/Consumo

~~~text
Pedido tipo 2
        ↓
Produto
        ↓
Quantidade direta
        ↓
Validar Unidade
        ↓
Estoque
        ↓
Custos
~~~

Não utiliza Pack.

---

# Entrada de NF-e — Insumo

~~~text
Pedido tipo 4
        ↓
Produto
        ↓
Quantidade direta
        ↓
Validar Unidade
        ↓
Estoque
        ↓
Custos
~~~

Não utiliza Pack.

---

# Entrada de NF-e — Quantidade

Regra geral:

~~~text
Nesta NF
<=
Saldo pendente
~~~

Não permitir quantidade negativa.

Para Uso/Consumo e Insumo:

~~~text
Unidade.permite_decimal
~~~

define se quantidade fracionária é aceita.

---

# Entrada de NF-e — Valores

~~~text
valor_bruto =
qtd_recebida × preco_unit_nf
~~~

~~~text
0 <= desconto_item <= valor_bruto
~~~

~~~text
total_item =
valor_bruto - desconto_item
~~~

Invariantes:

~~~text
total_item >= 0
valor_total >= 0
~~~

---

# Entrada de NF-e — Fechamento

~~~text
NF AB
        ↓
Fechar
        ↓
Validar documento
        ↓
Validar itens
        ↓
Validar quantidades
        ↓
Movimentar Estoque
        ↓
Atualizar Custos
        ↓
Efetivar Financeiro
        ↓
Atualizar Recebimento
        ↓
NF FE
~~~

A operação deve ser transacional.

---

# Entrada de NF-e — Estoque

Movimento de entrada:

~~~text
NFE:<id>:ENTRADA
~~~

O ID interno da NF identifica tecnicamente a movimentação.

Não utilizar apenas número, série ou fornecedor como chave técnica de movimento.

---

# Entrada de NF-e — Recebimento Parcial

~~~text
Pedido = 100
        ↓
NF 1 = 40
        ↓
Pedido AP
        ↓
NF 2 = 30
        ↓
Pedido AP
        ↓
NF 3 = 30
        ↓
Pedido AT
~~~

---

# Entrada de NF-e — Financeiro

~~~text
Pedido aprovado
        ↓
Planejamento Financeiro
        ↓
NF fechada
        ↓
Realizar parte correspondente
        ↓
Saldo ainda não recebido
        ↓
Manter previsão remanescente
~~~

Múltiplas NFs não devem duplicar títulos.

---

# Entrada de NF-e — Cancelamento

~~~text
NF FE
        ↓
Cancelar
        ↓
Validar Financeiro
        ↓
Validar Estoque
        ↓
Estornar Estoque
        ↓
Recalcular Custos
        ↓
Recalcular Financeiro
        ↓
Recalcular Recebimento
        ↓
NF CA
~~~

Cancelamento deve afetar somente a própria NF.

---

# Entrada de NF-e — Movimento de Cancelamento

~~~text
NFE:<id>:CANCEL
~~~

Não gerar segundo movimento de cancelamento para NF já cancelada.

---

# Entrada de NF-e — Estoque Negativo

~~~text
Cancelar NF
        ↓
Estorno produzirá saldo negativo?
   ├── Não → continuar
   └── Sim
         ↓
Loja permite negativo?
   ├── Sim → continuar
   └── Não → bloquear cancelamento
~~~

Em bloqueio, nenhuma parte da operação deve permanecer alterada.

---

# Entrada de NF-e — Financeiro Baixado

~~~text
Cancelar NF
        ↓
Existe baixa incompatível com reversão automática?
   ├── Não → continuar
   └── Sim → bloquear
~~~

O sistema não deve desfazer pagamento silenciosamente.

---

# Entrada de NF-e — Recalcular Pedido

Após fechamento ou cancelamento:

~~~text
Somar recebimentos válidos
        ↓
Todos os itens atendidos?
   ├── Sim → AT
   └── Não → AP
~~~

Cancelamento pode provocar:

~~~text
AT → AP
~~~

---

# Entrada de NF-e — Atomicidade

Tanto fechamento quanto cancelamento seguem:

~~~text
SUCESSO COMPLETO
OU
ROLLBACK COMPLETO
~~~

Não deixar divergência entre:

- NF;
- Pedido;
- Estoque;
- Custos;
- Financeiro.

---

# Entrada de NF-e — Consulta

~~~text
Entrada de NF-e
        ↓
Filtros
        ↓
Backend
        ↓
Paginação server-side
        ↓
results
~~~

Estados consultáveis:

~~~text
AB
FE
CA
~~~

---

# Entrada de NF-e — Filtros

Filtros de backend contemplam:

- Pedido;
- Status;
- Número;
- Chave;
- Fornecedor;
- Loja;
- período de emissão;
- período de entrada;
- valor;
- busca geral.

Filtros respeitam Empresa.

---

# Entrada de NF-e — Indicadores

~~~text
Conjunto completo filtrado
        ↓
Indicadores
~~~

Indicadores:

- total;
- abertas;
- fechadas;
- canceladas;
- valor total.

Não calcular somente sobre a página atual.

---

# Entrada de NF-e — Multiempresa

~~~text
Usuário
        ↓
Empresa
        ↓
NF
        ↓
Pedido
        ↓
Itens
        ↓
Estoque / Financeiro
~~~

Qualquer relacionamento de outro tenant deve ser rejeitado.

---

# Entrada de NF-e — Fluxo Completo

~~~text
PEDIDO AP
   ↓
ENTRADA DE NF-e
   ↓
DADOS DA NF
   ↓
ITENS
   ↓
CHECKBOX OK
   ↓
FECHAMENTO
   ↓
ESTOQUE
   ↓
CUSTOS
   ↓
FINANCEIRO
   ↓
RECEBIMENTO
   ↓
PEDIDO AP / AT
   ↓
EVENTUAL CANCELAMENTO
   ↓
ESTORNO E RECÁLCULOS
   ↓
NF CA
~~~

---
# 118. Estoque e Produto Venda

~~~text
SKU
+
Local
        ↓
Movimentos
        ↓
Saldo
~~~

Para Produto Venda, a granularidade comercial consolidada é:

~~~text
Loja × SKU
~~~

---

# 119. Estoque e Uso/Consumo

~~~text
Produto tipo 2
+
Local definido pela operação
        ↓
Movimento
        ↓
Saldo
~~~

Não fixar Matriz no cadastro.

---

# 120. Estoque e Insumos

~~~text
Insumo tipo 4
+
Local operacional
        ↓
Movimento
        ↓
Saldo
~~~

Não fixar fábrica ou facção no cadastro do Insumo.

---

# 121. Fiscal e Produtos

~~~text
Produto
        ↓
Dados Fiscais cadastrais
        ↓
Operação Fiscal
        ↓
Validação das informações necessárias
        ↓
Documento Fiscal
~~~

Cadastro fiscal e operação fiscal são responsabilidades distintas.

---

# 122. Fiscal e Pedido de Compra

~~~text
Pedido AP
        ↓
Nota Fiscal de Entrada
        ↓
Vinculação ao Pedido
        ↓
Recebimento
        ↓
Movimento de Estoque
        ↓
Atualização do atendimento
~~~

Compras não deve executar recebimento paralelo independente do Fiscal.

---

# 123. Financeiro e Pedido de Compra

~~~text
Pedido AB
        ↓
Planejamento
        ↓
Aprovação
        ↓
Pagar
        ↓
PagarItem
        ↓
Financeiro assume controle da obrigação
~~~

Baixas e pagamentos pertencem ao Financeiro.

---

# 124. Produção

Fluxo conceitual:

~~~text
Produto Venda
Tipo 3
        ↓
Ficha Técnica
        ↓
Insumos
Tipo 4
        ↓
Ordem de Produção
        ↓
Produção
        ↓
Produto Acabado
        ↓
Estoque
~~~

O detalhamento de baixa/reserva de Insumos ainda pertence à evolução do módulo Produção.

---

# 125. PDV

Fluxo conceitual de venda:

~~~text
Produto Venda
        ↓
SKU
        ↓
Validar Produto
        ↓
Validar SKU
        ↓
Validar Bloqueio
        ↓
Validar Preço
        ↓
Validar Estoque
        ↓
Validar Fiscal
        ↓
Venda
~~~

Produto Uso/Consumo e Insumos não devem entrar normalmente nesse fluxo.

---

# 126. Auditoria nos Domínios

Ações relevantes podem produzir:

~~~text
Evento funcional
+
AuditLog
~~~

quando o domínio possuir histórico funcional próprio.

Exemplo:

~~~text
ProdutoVendaHistorico
!=
AuditLog
~~~

---

# 127. Erro de Validação

Fluxo:

~~~text
Frontend envia dados
        ↓
Backend rejeita regra
        ↓
Retorna erro funcional
        ↓
Frontend apresenta mensagem
        ↓
Usuário corrige
~~~

Evitar mensagens genéricas quando a causa é conhecida.

---

# 128. Erro de Permissão

~~~text
Usuário solicita operação
        ↓
Backend verifica Permissão
        ↓
Não autorizado
        ↓
Bloquear
~~~

Botão oculto não substitui essa validação.

---

# 129. Mudança Estrutural Sensível

Antes de alterar estrutura utilizada:

~~~text
Registro selecionado
        ↓
Backend identifica dependências
        ↓
Mudança altera histórico?
   ├── Sim → bloquear ou tratar especificamente
   └── Não → permitir
~~~

Exemplos:

- Grade;
- Unidade;
- CodigoRef;
- Coleção;
- Pack.

---

# 130. Não Reinterpretar Histórico

~~~text
Configuração atual
!=
Operação histórica
~~~

Exemplos:

~~~text
Pack alterado
→ Pedido antigo não recalculado

Grupo alterado
→ Referência antiga não regenerada

Unidade alterada
→ Movimento antigo não reinterpretado
~~~

---

# 131. Fluxo de Implementação

O protocolo oficial deve ser consultado em:

[[Protocolo de Trabalho com IA]]

Fluxo:

~~~text
Definir regra funcional
        ↓
Analisar código existente
        ↓
Identificar dependências
        ↓
Definir solução
        ↓
Implementar
        ↓
Testar
        ↓
Revisar
        ↓
Homologar
        ↓
Documentar
~~~

---

# 132. Fluxo de Correção Localizada

~~~text
Problema identificado
        ↓
Localizar causa
        ↓
Definir menor alteração segura
        ↓
Implementar
        ↓
Teste direcionado
        ↓
Homologação
~~~

Evitar investigação ampla pelo Codex quando a causa já está delimitada.

---

# 133. Responsabilidades

## Usuário

Responsável por:

- decisão funcional;
- teste manual;
- homologação.

## ChatGPT

Responsável por:

- análise;
- investigação;
- leitura de repositório;
- arquitetura;
- definição da solução;
- prompt de implementação;
- revisão;
- documentação.

## Codex

Responsável por:

- implementação;
- alterações de arquivos;
- testes necessários;
- commit.

---

# 134. Regra de Economia de Implementação

~~~text
ANALISAR ANTES
↓
LOCALIZAR CAUSA
↓
ALTERAR SOMENTE O NECESSÁRIO
↓
TESTAR PROPORCIONALMENTE AO RISCO
↓
HOMOLOGAR
~~~

Não gastar recursos em investigação ampla quando o problema está identificado.

---

# 135. Fechamento de Escopo

Um escopo somente está fechado após:

~~~text
REGRAS DEFINIDAS
+
IMPLEMENTAÇÃO
+
TESTES
+
REVISÃO
+
HOMOLOGAÇÃO
+
DOCUMENTAÇÃO
~~~

O Pedido de Compra já cumpriu esse fluxo.

---

# 136. Documentação de Produto Venda

- [[Homologação - Produtos - Produto Venda]]
- [[Mapa Técnico - Produtos - Produto Venda]]
- [[Workflows - Produtos - Produto Venda]]
- [[Modelo de Domínio - Produtos - Produto Venda]]
- [[Riscos e Cuidados - Produtos - Produto Venda]]

---

# 137. Documentação de Produto Uso/Consumo

- [[Homologação - Produtos - Produto Uso e Consumo]]
- [[Mapa Técnico - Produtos - Produto Uso e Consumo]]
- [[Workflows - Produtos - Produto Uso e Consumo]]
- [[Modelo de Domínio - Produtos - Produto Uso e Consumo]]
- [[Riscos e Cuidados - Produtos - Produto Uso e Consumo]]

---

# 138. Documentação de Insumos

- [[Homologação - Produtos - Insumos]]
- [[Mapa Técnico - Produtos - Insumos]]
- [[Workflows - Produtos - Insumos]]
- [[Modelo de Domínio - Produtos - Insumos]]
- [[Riscos e Cuidados - Produtos - Insumos]]

---

# 139. Documentação de Cadastros Auxiliares

- [[Homologação - Produtos - Cadastros Auxiliares]]
- [[Mapa Técnico - Produtos - Cadastros Auxiliares]]
- [[Workflows - Produtos - Cadastros Auxiliares]]
- [[Modelo de Domínio - Produtos - Cadastros Auxiliares]]
- [[Riscos e Cuidados - Produtos - Cadastros Auxiliares]]

---

# 140. Documentação de Compras

## Pedido de Compra

- [[Homologação - Compras - Pedido de Compra]]
- [[Mapa Técnico - Compras - Pedido de Compra]]
- [[Workflows - Compras - Pedido de Compra]]
- [[Modelo de Domínio - Compras - Pedido de Compra]]
- [[Riscos e Cuidados - Compras - Pedido de Compra]]

Status:

~~~text
IMPLEMENTADO
TESTADO
HOMOLOGADO
APROVADO
DOCUMENTADO
~~~

---

# 141. Relação Geral dos Fluxos

~~~text
                              [[Sysvar]]
                                  │
                                  ↓
                            [[Workflows]]
                                  │
       ┌──────────────────────────┼───────────────────────────┐
       │                          │                           │
       ↓                          ↓                           ↓
  OPERACIONAL                 CADASTROS                   PRODUTOS
       │                          │                           │
       │                   ┌──────┼──────┐           ┌────────┼─────────┐
       │                   ↓      ↓      ↓           ↓        ↓         ↓
       │                Clientes Forn. Func.      Venda   Uso/Cons.  Insumos
       │                                                      │
       │                                                      ↓
       │                                             Cadastros Auxiliares
       │
       ↓
 Autenticação / Sessões
 Permissões / Auditoria

                                  │
                                  ↓
                               COMPRAS
                                  │
                                  ↓
                         PEDIDO DE COMPRA
                                  │
                     ┌────────────┼────────────┐
                     ↓            ↓            ↓
                  Revenda    Uso/Consumo    Insumo
                     │            │            │
                     └────────────┼────────────┘
                                  ↓
                             Aprovação
                                  ↓
                              Financeiro
                                  ↓
                           Recebimento Fiscal
                                  ↓
                               Estoque
~~~

---

# 142. Estado Atual dos Workflows

Em **16/08/2026**, estão formalmente consolidados neste mapa:

~~~text
OPERACIONAL

CLIENTES

FORNECEDORES

FUNCIONÁRIOS

PRODUTO VENDA

PRODUTO USO/CONSUMO

INSUMOS

CADASTROS AUXILIARES DE PRODUTOS

PEDIDO DE COMPRA
~~~

O Pedido de Compra está:

~~~text
UNIFICADO
IMPLEMENTADO
TESTADO
HOMOLOGADO
APROVADO
DOCUMENTADO
~~~

O próximo domínio deverá ter suas regras definidas antes de ser incorporado a este documento central.

---

# 143. Notas Relacionadas

## Contexto Central

- [[Sysvar]]
- [[Mapa Técnico]]
- [[10 Projetos/Sysvar/Contexto do Projeto/Visão Geral|Visão Geral]]
- [[10 Projetos/Sysvar/Contexto do Projeto/Arquitetura|Arquitetura]]
- [[10 Projetos/Sysvar/Contexto do Projeto/Modelo de Domínio|Modelo de Domínio]]
- [[10 Projetos/Sysvar/Contexto do Projeto/Riscos e Cuidados|Riscos e Cuidados]]

## Produtos

- [[Workflows - Produtos - Produto Venda]]
- [[Workflows - Produtos - Produto Uso e Consumo]]
- [[Workflows - Produtos - Insumos]]
- [[Workflows - Produtos - Cadastros Auxiliares]]

## Compras

- [[Workflows - Compras - Pedido de Compra]]
- [[Mapa Técnico - Compras - Pedido de Compra]]
- [[Modelo de Domínio - Compras - Pedido de Compra]]
- [[Riscos e Cuidados - Compras - Pedido de Compra]]
- [[Homologação - Compras - Pedido de Compra]]

---

# 144. Última Atualização

~~~text
16/08/2026
~~~

Este documento representa os workflows centrais consolidados do SYSVAR após o fechamento, homologação e documentação do Pedido de Compra unificado.
