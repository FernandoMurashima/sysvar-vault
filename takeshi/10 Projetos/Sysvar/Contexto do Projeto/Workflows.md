---
type: reference
status: active
project: Sysvar
source: "C:/SysvarProjeto"
created: 2026-08-03
updated: 2026-08-14
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
- Cadastros Auxiliares de Produtos.

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
Aprovação
        ↓
Recebimento
        ↓
Financeiro / Estoque
~~~

Compras continua sendo responsável pelo processo.

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
Recebimento
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
Operação de Compra/Entrada
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
Fornecedor
        ↓
Quantidade
        ↓
Preço
        ↓
Recebimento
        ↓
Estoque
        ↓
Custos
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
Insumo
   ↓
Recebimento
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
Inativar / Desligar / Bloquear
conforme domínio
~~~

---

# 77. Compras e Produtos

Fluxo geral:

~~~text
Produto
        ↓
Pedido de Compra
        ↓
Fornecedor
        ↓
Itens
        ↓
Quantidade / Pack quando aplicável
        ↓
Preço
        ↓
Aprovação
        ↓
Recebimento
        ↓
Estoque
        ↓
Financeiro
~~~

Produto fornece identidade.

Compras controla a aquisição.

---

# 78. Estoque e Produto Venda

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

# 79. Estoque e Uso/Consumo

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

# 80. Estoque e Insumos

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

# 81. Fiscal e Produtos

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

# 82. Produção

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

# 83. PDV

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

# 84. Auditoria nos Domínios

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

# 85. Erro de Validação

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

# 86. Erro de Permissão

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

# 87. Mudança Estrutural Sensível

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

# 88. Não Reinterpretar Histórico

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

# 89. Fluxo de Implementação

Para nova funcionalidade:

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

# 90. Fluxo de Correção Localizada

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

# 91. Responsabilidades

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

# 92. Regra de Economia de Implementação

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

# 93. Fechamento de Escopo

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

---

# 94. Documentação de Produto Venda

- [[Homologação - Produtos - Produto Venda]]
- [[Mapa Técnico - Produtos - Produto Venda]]
- [[Workflows - Produtos - Produto Venda]]
- [[Modelo de Domínio - Produtos - Produto Venda]]
- [[Riscos e Cuidados - Produtos - Produto Venda]]

---

# 95. Documentação de Produto Uso/Consumo

- [[Homologação - Produtos - Produto Uso e Consumo]]
- [[Mapa Técnico - Produtos - Produto Uso e Consumo]]
- [[Workflows - Produtos - Produto Uso e Consumo]]
- [[Modelo de Domínio - Produtos - Produto Uso e Consumo]]
- [[Riscos e Cuidados - Produtos - Produto Uso e Consumo]]

---

# 96. Documentação de Insumos

- [[Homologação - Produtos - Insumos]]
- [[Mapa Técnico - Produtos - Insumos]]
- [[Workflows - Produtos - Insumos]]
- [[Modelo de Domínio - Produtos - Insumos]]
- [[Riscos e Cuidados - Produtos - Insumos]]

---

# 97. Documentação de Cadastros Auxiliares

- [[Homologação - Produtos - Cadastros Auxiliares]]
- [[Mapa Técnico - Produtos - Cadastros Auxiliares]]
- [[Workflows - Produtos - Cadastros Auxiliares]]
- [[Modelo de Domínio - Produtos - Cadastros Auxiliares]]
- [[Riscos e Cuidados - Produtos - Cadastros Auxiliares]]

---

# 98. Relação Geral dos Fluxos

~~~text
                         [[Sysvar]]
                             │
                             ↓
                       [[Workflows]]
                             │
         ┌───────────────────┼────────────────────┐
         │                   │                    │
         ↓                   ↓                    ↓
    OPERACIONAL          CADASTROS            PRODUTOS
         │                   │                    │
         │            ┌──────┼──────┐      ┌──────┼────────┐
         │            ↓      ↓      ↓      ↓      ↓        ↓
         │         Clientes Forn. Func.  Venda Uso/Cons. Insumos
         │                                      │
         │                                      ↓
         │                              Cadastros Auxiliares
         │
         ↓
 Autenticação / Sessões
 Permissões / Auditoria
~~~

---

# 99. Estado Atual dos Workflows

Em **14/08/2026**, estão formalmente consolidados neste mapa:

~~~text
OPERACIONAL
CLIENTES
FORNECEDORES
FUNCIONÁRIOS
PRODUTO VENDA
PRODUTO USO/CONSUMO
INSUMOS
CADASTROS AUXILIARES DE PRODUTOS
~~~

O próximo domínio deverá ter suas regras definidas antes de ser incorporado a este documento central.

---

# 100. Notas Relacionadas

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