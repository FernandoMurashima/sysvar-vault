# Workflows - Cadastros - Fornecedores

## 1. Identificação

- **Projeto:** Sysvar
- **Módulo:** Cadastros
- **Funcionalidade:** Fornecedores
- **Escopo:** Fase 1 — Cadastro e Gestão Operacional
- **Situação:** IMPLEMENTADO E HOMOLOGADO
- **Homologação manual:** 30/30 itens aprovados

---

# 2. Objetivo

Este documento descreve os principais fluxos operacionais relacionados ao cadastro e utilização de Fornecedores no SISVAR.

Os workflows documentados contemplam:

- criação;
- edição;
- consulta;
- documentos;
- duplicidades;
- categorias;
- contatos;
- endereços;
- dados fiscais;
- padrões comerciais;
- padrões financeiros;
- dados bancários;
- lifecycle;
- exclusão;
- compras;
- financeiro;
- histórico;
- auditoria;
- utilização operacional.

---

# 3. Workflow Geral do Fornecedor

Fluxo principal:

~~~text
Usuário
  ↓
Cadastros
  ↓
Fornecedores
  ↓
Lista de Fornecedores
  ↓
Escolher ação
  ├── Novo
  ├── Consultar
  ├── Editar
  ├── Ativar/Inativar
  ├── Bloquear/Desbloquear
  └── Excluir
~~~

---

# 4. Workflow — Listagem

~~~text
Abrir Cadastros > Fornecedores
  ↓
Frontend solicita lista ao backend
  ↓
Backend aplica empresa do usuário
  ↓
Backend aplica filtros
  ↓
Backend aplica ordenação
  ↓
Backend aplica paginação
  ↓
Retorna página de resultados
  ↓
Frontend apresenta fornecedores
~~~

A paginação é server-side.

O frontend não deve carregar toda a base para paginar localmente.

---

# 5. Workflow — Pesquisa

~~~text
Usuário informa busca/filtros
  ↓
Frontend envia parâmetros
  ↓
Backend filtra fornecedores da empresa atual
  ↓
Resultados paginados
  ↓
Frontend atualiza tabela
~~~

Filtros podem envolver, conforme implementação:

- nome;
- apelido;
- documento;
- tipo de pessoa;
- categoria;
- cidade;
- estado;
- ativo;
- bloqueio;
- utilizável.

---

# 6. Workflow — Novo Fornecedor

~~~text
Usuário clica Novo
  ↓
Formulário é aberto
  ↓
Usuário informa dados
  ↓
Seleciona PF ou PJ
  ↓
Informa documento ou deixa vazio
  ↓
Seleciona categorias
  ↓
Preenche dados opcionais
  ↓
Salvar
  ↓
Frontend valida formulário
  ↓
Backend valida empresa e regras de domínio
  ↓
Fornecedor criado
~~~

---

# 7. Workflow — Tipo de Pessoa

~~~text
Novo/Editar fornecedor
  ↓
Selecionar tipo
  ├── PF
  │    ↓
  │  Documento = CPF
  │
  └── PJ
       ↓
     Documento = CNPJ
~~~

Quando documento estiver informado:

- PF exige CPF válido;
- PJ exige CNPJ válido.

---

# 8. Workflow — Fornecedor sem Documento

~~~text
Novo fornecedor
  ↓
Documento não informado
  ↓
Backend aceita documento nulo
  ↓
Avaliação de possível duplicidade por nome
  ↓
Usuário confirma quando necessário
  ↓
Cadastro concluído
~~~

Fornecedor sem documento continua válido para operação quando:

- ativo;
- não bloqueado;
- adequado ao contexto.

---

# 9. Workflow — Documento Duplicado

~~~text
Usuário informa CPF/CNPJ
  ↓
Salvar
  ↓
Backend verifica empresa + documento
  ↓
Documento já existe?
  ├── NÃO
  │    ↓
  │  Salvar
  │
  └── SIM
       ↓
     Rejeitar cadastro
~~~

A duplicidade é analisada dentro da empresa.

Mesmo documento em empresas diferentes é permitido.

---

# 10. Workflow — Possível Duplicidade por Nome

~~~text
Fornecedor sem documento
  ↓
Nome/apelido semelhante encontrado
  ↓
Sistema apresenta aviso
  ↓
Usuário decide
  ├── Cancelar
  │    ↓
  │  Cadastro não prossegue
  │
  └── Confirmar
       ↓
     Cadastro prossegue
~~~

A similaridade não é bloqueante.

---

# 11. Workflow — Categorias

~~~text
Editar/Novo fornecedor
  ↓
Selecionar uma ou mais categorias
  ↓
Salvar
  ↓
Backend grava associações
  ↓
Categorias passam a ser utilizadas
  em filtros e seleção contextual
~~~

Exemplo:

~~~text
Fornecedor
  ├── REVENDA
  ├── AVIAMENTO
  └── PRESTADOR
~~~

---

# 12. Workflow — Uso Contextual das Categorias

Exemplo de compra de revenda:

~~~text
Nova compra de revenda
  ↓
Solicitar fornecedores
  ↓
Considerar empresa atual
  ↓
Considerar ativo
  ↓
Considerar não bloqueado
  ↓
Priorizar/filtrar categoria REVENDA
  ↓
Apresentar opções válidas
~~~

A categoria não deve ser transformada automaticamente em bloqueio universal.

---

# 13. Workflow — Cadastro de Contato

~~~text
Editar fornecedor
  ↓
Área de Contatos
  ↓
Novo contato
  ↓
Informar:
  - Nome
  - Função
  - Tipo
  - Telefone
  - WhatsApp
  - E-mail
  - Observação
  - Principal
  ↓
Salvar contato
  ↓
Frontend valida
  ↓
POST para API
  ↓
Backend valida
  ↓
Contato criado
  ↓
Lista de contatos atualizada
~~~

---

# 14. Workflow — Telefone do Contato

~~~text
Usuário digita telefone
  ↓
Frontend mantém somente até 11 dígitos úteis
  ↓
Aplica máscara visual
  ↓
Valida quantidade
  ├── 10 dígitos → válido
  ├── 11 dígitos → válido
  ├── vazio → válido
  └── outro tamanho → inválido
  ↓
Ao salvar
  ↓
Enviar somente dígitos
~~~

Exemplo:

~~~text
Entrada:
21990087565

Exibição:
(21) 99008-7565

Payload:
21990087565
~~~

---

# 15. Workflow — Contato Inválido

~~~text
Usuário clica Salvar contato
  ↓
Formulário inválido?
  ├── NÃO
  │    ↓
  │  Enviar API
  │
  └── SIM
       ↓
     Marcar campos
       ↓
     Mostrar mensagens de erro
       ↓
     Não enviar API
~~~

Não deve existir retorno silencioso que faça o botão parecer inoperante.

---

# 16. Workflow — Contato Principal

~~~text
Contato A do tipo COMERCIAL é principal
  ↓
Usuário marca Contato B do tipo COMERCIAL como principal
  ↓
Backend inicia transação
  ↓
Contato B recebe principal = true
  ↓
Outros contatos COMERCIAL perdem principal
  ↓
Transação concluída
~~~

Resultado:

somente um contato principal ativo por tipo.

---

# 17. Workflow — Inativar Contato

~~~text
Contato ativo
  ↓
Inativar
  ↓
Contato permanece cadastrado
  ↓
ativo = false
  ↓
Histórico preservado
  ↓
Lista atualizada
~~~

---

# 18. Workflow — Reativar Contato

~~~text
Contato inativo
  ↓
Reativar
  ↓
ativo = true
  ↓
Contato volta a ficar operacional
~~~

A regra de principal deve continuar consistente.

---

# 19. Workflow — Cadastro de Endereço

~~~text
Editar fornecedor
  ↓
Área de Endereços
  ↓
Novo endereço
  ↓
Selecionar tipo
  ↓
Preencher endereço
  ↓
Definir Principal, se aplicável
  ↓
Salvar
  ↓
Backend valida
  ↓
Endereço criado
  ↓
Lista atualizada
~~~

---

# 20. Workflow — Endereço Principal

~~~text
Endereço Fiscal A = principal
  ↓
Usuário marca Endereço Fiscal B como principal
  ↓
Backend executa alteração transacional
  ↓
Fiscal B = principal
  ↓
Fiscal A deixa de ser principal
~~~

Resultado:

somente um endereço principal ativo por tipo.

---

# 21. Workflow — Inativar Endereço

~~~text
Endereço ativo
  ↓
Inativar
  ↓
ativo = false
  ↓
Registro permanece associado
  ↓
Histórico preservado
~~~

---

# 22. Workflow — Reativar Endereço

~~~text
Endereço inativo
  ↓
Reativar
  ↓
ativo = true
  ↓
Endereço volta a ficar disponível
~~~

---

# 23. Workflow — Dados Fiscais

~~~text
Editar fornecedor
  ↓
Dados fiscais
  ↓
Informar:
  - Inscrição Estadual
  - Inscrição Municipal
  - Contribuinte ICMS
  ↓
Salvar
~~~

Nesta fase:

- IE não possui validação específica por UF;
- IM não possui validação municipal;
- Contribuinte ICMS é estruturado.

---

# 24. Workflow — Contribuinte ICMS

~~~text
Usuário abre seletor
  ↓
Escolhe:
  - Não informado
  - Sim
  - Não
  - Isento
  ↓
Frontend envia valor interno
  ↓
Backend valida choice
  ↓
Fornecedor salvo
~~~

Valores internos:

- SIM
- NAO
- ISENTO

---

# 25. Workflow — Prazo Padrão

~~~text
Editar fornecedor
  ↓
Frontend solicita prazos ativos
  ↓
Backend retorna prazos da empresa
  ↓
Usuário seleciona prazo
  ↓
Frontend envia ID
  ↓
Backend valida:
  - mesma empresa
  - ativo
  ↓
Fornecedor salvo
~~~

Entidade:

`financeiro.PrazoPagamento`

---

# 26. Workflow — Conta Contábil Padrão

~~~text
Editar fornecedor
  ↓
Frontend consulta Plano Contábil
  ↓
Filtrar:
  - mesma empresa
  - ativa
  - analítica
  ↓
Usuário seleciona conta
  ↓
Enviar ID
  ↓
Backend valida novamente
  ↓
Fornecedor salvo
~~~

Entidade:

`cadastros.PlanoContabil`

---

# 27. Workflow — Natureza Financeira Padrão

~~~text
Editar fornecedor
  ↓
Frontend consulta naturezas
  ↓
Listar naturezas válidas da empresa
  ↓
Usuário seleciona
  ↓
Enviar ID
  ↓
Backend valida empresa/status
  ↓
Fornecedor salvo
~~~

Entidade:

`cadastros.Nat_Lancamento`

---

# 28. Workflow — Padrões em Nova Operação

Conceito:

~~~text
Nova operação
  ↓
Fornecedor selecionado
  ↓
Fornecedor possui padrões?
  ├── SIM
  │    ↓
  │  Sugerir:
  │  - Prazo
  │  - Conta contábil
  │  - Natureza financeira
  │
  └── NÃO
       ↓
     Continuar sem sugestão
~~~

Esses dados são padrões e não necessariamente travamentos.

---

# 29. Workflow — Dados Bancários com Permissão

~~~text
Usuário abre fornecedor
  ↓
Backend verifica permissão
  ↓
Possui fornecedor.dados_bancarios?
  ├── SIM
  │    ↓
  │  API retorna dados bancários
  │    ↓
  │  Frontend apresenta valores
  │
  └── NÃO
       ↓
     API não expõe valores sensíveis
~~~

---

# 30. Workflow — Edição de Dados Bancários

~~~text
Usuário autorizado
  ↓
Editar fornecedor
  ↓
Preencher:
  - Banco
  - Agência
  - Conta
  - Tipo
  - PIX
  - Favorecido
  - Documento
  - Observação
  ↓
Salvar
  ↓
Backend valida permissão
  ↓
Dados persistidos
~~~

---

# 31. Workflow — Usuário sem Permissão Bancária

~~~text
Usuário sem permissão
  ↓
Consultar fornecedor
  ↓
Backend oculta valores sensíveis
  ↓
Frontend não apresenta os dados reais
~~~

Na implementação homologada, a estrutura visual pode permanecer visível com campos vazios.

Melhoria futura:

~~~text
Dados bancários — acesso restrito
~~~

ou ocultação integral da seção.

---

# 32. Workflow — Tipo de Conta Bancária

~~~text
Usuário abre seletor
  ↓
Escolhe:
  - Conta corrente
  - Conta poupança
  - Conta de pagamento
  - Outra
  ↓
Frontend envia código interno
  ↓
Backend valida choice
~~~

Valores internos:

- CORRENTE
- POUPANCA
- PAGAMENTO
- OUTRA

---

# 33. Workflow — Banco

Situação atual:

~~~text
Usuário informa banco
  ↓
Texto persistido
~~~

Situação futura prevista:

~~~text
Usuário pesquisa banco
  ↓
Lista oficial
  ↓
Seleciona código + instituição
  ↓
Sistema persiste identificador padronizado
~~~

Integração BACEN ainda não implementada.

---

# 34. Workflow — Editar Fornecedor

~~~text
Lista
  ↓
Selecionar fornecedor
  ↓
Editar
  ↓
Backend carrega registro
  ↓
Frontend carrega:
  - dados principais
  - categorias
  - contatos
  - endereços
  - padrões
  ↓
Usuário altera
  ↓
Salvar
  ↓
Frontend valida
  ↓
Backend valida
  ↓
Persistir
  ↓
Auditar alterações relevantes
~~~

---

# 35. Workflow — Consultar Fornecedor

~~~text
Lista
  ↓
Selecionar fornecedor
  ↓
Consultar
  ↓
Carregar dados
  ↓
Exibir abas:
  - Dados cadastrais
  - Compras
  - Financeiro
  - Histórico
~~~

Consulta é somente leitura.

---

# 36. Workflow — Aba Dados Cadastrais

~~~text
Consultar
  ↓
Dados cadastrais
  ↓
Exibir:
  - identificação
  - categorias
  - contatos
  - endereços
  - fiscal
  - comercial
  - padrões
  - bancário conforme permissão
~~~

---

# 37. Workflow — Aba Compras

~~~text
Consultar fornecedor
  ↓
Compras
  ↓
Frontend solicita compras
  ↓
Backend valida empresa/fornecedor
  ↓
Retorna histórico
  ↓
Frontend apresenta registros e status
~~~

Podem aparecer:

- concluídas;
- abertas;
- canceladas.

O status deve estar claro.

---

# 38. Workflow — Indicadores de Compra

~~~text
Backend consulta compras do fornecedor
  ↓
Seleciona compras válidas
  ↓
Exclui:
  - canceladas
  - rascunhos
  - abertas não concluídas
  ↓
Calcula:
  - última compra
  - total
  - quantidade
  - ticket médio
  ↓
Retorna indicadores
~~~

---

# 39. Workflow — Ticket Médio

~~~text
Quantidade de compras válidas > 0?
  ├── SIM
  │    ↓
  │  Total / Quantidade
  │
  └── NÃO
       ↓
     Valor neutro
~~~

O cálculo deve ocorrer no backend.

---

# 40. Workflow — Aba Financeiro

~~~text
Consultar fornecedor
  ↓
Financeiro
  ↓
Frontend solicita títulos
  ↓
Backend filtra:
  - empresa
  - fornecedor
  ↓
Calcula valores/saldos
  ↓
Retorna títulos
  ↓
Frontend exibe
~~~

---

# 41. Workflow — Saldo de um Título

~~~text
Título
  ↓
Valor original
  ↓
Subtrair pagamentos válidos
  ↓
Considerar status
  ↓
Saldo
~~~

Regras:

- pago → zero;
- cancelado → não entra no saldo;
- parcial → saldo restante;
- aberto → saldo aberto.

---

# 42. Workflow — Saldo a Pagar

~~~text
Títulos do fornecedor
  ↓
Selecionar títulos válidos
  ↓
Excluir cancelados
  ↓
Somar saldos abertos
  ↓
Saldo a pagar do fornecedor
~~~

---

# 43. Workflow — Aba Histórico

~~~text
Consultar fornecedor
  ↓
Histórico
  ↓
Solicitar eventos
  ↓
Backend filtra entidade/empresa
  ↓
Retorna eventos
  ↓
Frontend apresenta:
  - ação
  - data/hora
  - usuário
  - contexto
~~~

---

# 44. Workflow — Audit Central

~~~text
Ação auditável
  ↓
Backend executa operação
  ↓
Cria AuditLog
  ↓
Audit Central
  ↓
Evento pesquisável
~~~

Exemplos:

- edição;
- bloqueio;
- desbloqueio;
- inativação;
- reativação;
- contato;
- endereço.

---

# 45. Workflow — Ativar Fornecedor

~~~text
Fornecedor inativo
  ↓
Usuário clica Ativar
  ↓
Backend valida permissão
  ↓
ativo = true
  ↓
Registrar auditoria
  ↓
Fornecedor volta a poder ser utilizado
  se não estiver bloqueado
~~~

---

# 46. Workflow — Inativar Fornecedor

~~~text
Fornecedor ativo
  ↓
Usuário clica Inativar
  ↓
Backend valida
  ↓
ativo = false
  ↓
Registrar auditoria
  ↓
Fornecedor permanece no histórico
  ↓
Novas operações ficam proibidas
~~~

---

# 47. Workflow — Bloquear Fornecedor

~~~text
Fornecedor
  ↓
Usuário clica Bloquear
  ↓
Informar motivo
  ↓
Informar observação
  ↓
Confirmar
  ↓
Backend registra:
  - bloqueio
  - motivo
  - observação
  - data/hora
  - usuário
  ↓
AuditLog
  ↓
Fornecedor deixa de ser utilizável
~~~

---

# 48. Workflow — Desbloquear Fornecedor

~~~text
Fornecedor bloqueado
  ↓
Desbloquear
  ↓
Backend valida permissão
  ↓
bloqueio = false
  ↓
Auditoria
  ↓
Fornecedor volta a poder ser utilizado
  se estiver ativo
~~~

---

# 49. Workflow — Fornecedor Utilizável

~~~text
Nova operação
  ↓
Fornecedor pertence à empresa?
  ├── NÃO → Rejeitar
  └── SIM
       ↓
     Está ativo?
       ├── NÃO → Rejeitar
       └── SIM
            ↓
          Está bloqueado?
            ├── SIM → Rejeitar
            └── NÃO
                 ↓
               Validar contexto/categoria
                 ↓
               Permitir
~~~

---

# 50. Workflow — Tentativa de Usar Fornecedor Inativo

~~~text
Nova compra
  ↓
Fornecedor inativo
  ↓
Frontend pode ocultar
  ↓
Se ID for enviado manualmente
  ↓
Backend rejeita
~~~

A proteção não pode existir somente no frontend.

---

# 51. Workflow — Tentativa de Usar Fornecedor Bloqueado

~~~text
Nova operação
  ↓
Fornecedor bloqueado
  ↓
Não apresentar ou rejeitar
  ↓
Backend impede utilização
~~~

---

# 52. Workflow — Exclusão de Fornecedor sem Vínculo

~~~text
Usuário solicita exclusão
  ↓
Backend verifica dependências
  ↓
Existem vínculos?
  ├── NÃO
  │    ↓
  │  Exclusão física permitida
  │
  └── SIM
       ↓
     Exclusão negada
~~~

---

# 53. Workflow — Exclusão Protegida

~~~text
Fornecedor possui histórico
  ↓
Usuário solicita excluir
  ↓
Backend identifica dependência
  ↓
Não excluir
  ↓
Mensagem:
Este fornecedor possui compras ou outros registros vinculados
e não pode ser excluído.
Utilize a inativação.
~~~

---

# 54. Workflow — Multiempresa

Para toda operação sensível:

~~~text
Usuário autenticado
  ↓
Determinar empresa corrente
  ↓
Receber ID solicitado
  ↓
Entidade pertence à empresa?
  ├── SIM → Continuar
  └── NÃO → Rejeitar
~~~

Aplicável a:

- fornecedor;
- prazo;
- conta contábil;
- natureza;
- contato;
- endereço;
- compra;
- financeiro.

---

# 55. Workflow — Prazo de Outra Empresa

~~~text
Frontend/API recebe ID de prazo
  ↓
Backend busca referência
  ↓
prazo.empresa == fornecedor.empresa?
  ├── SIM → Aceitar
  └── NÃO → Rejeitar
~~~

---

# 56. Workflow — Conta de Outra Empresa

~~~text
Conta contábil enviada
  ↓
Backend verifica empresa
  ↓
Empresa diferente?
  ├── SIM → Rejeitar
  └── NÃO
       ↓
     Conta ativa?
       ↓
     Conta analítica?
       ↓
     Aceitar
~~~

---

# 57. Workflow — Natureza de Outra Empresa

~~~text
Natureza enviada
  ↓
Backend verifica empresa
  ↓
Empresa diferente?
  ├── SIM → Rejeitar
  └── NÃO
       ↓
     Validar status
       ↓
     Aceitar
~~~

---

# 58. Workflow — Carregamento de Padrões no Frontend

~~~text
Abrir tela
  ↓
Carregar opções auxiliares
  ├── Prazos
  ├── Plano Contábil
  └── Naturezas
  ↓
Aplicar filtros adequados
  ↓
Popular seletores
~~~

Evitar carregamentos gigantes como solução permanente.

Quando o volume justificar:

usar lookup/autocomplete server-side.

---

# 59. Workflow — Edição sem Alterar Padrões

~~~text
Fornecedor possui:
  - prazo
  - conta
  - natureza
  ↓
Usuário edita outro campo
  ↓
Salvar
  ↓
Valores estruturados existentes são preservados
~~~

Salvar uma edição parcial não deve apagar referências não modificadas.

---

# 60. Workflow — Auditoria de Contato

~~~text
Contato criado/editado/inativado/reativado
  ↓
Operação concluída
  ↓
Gerar evento de auditoria
  ↓
Associar contexto ao fornecedor
  ↓
Evento disponível no histórico
~~~

---

# 61. Workflow — Auditoria de Endereço

~~~text
Endereço criado/editado/inativado/reativado
  ↓
Gerar evento
  ↓
Associar fornecedor
  ↓
Histórico/Audit Central
~~~

---

# 62. Workflow — Mudança de Principal

~~~text
Novo contato/endereço principal
  ↓
Atualizar principal anterior
  ↓
Registrar alteração
  ↓
Preservar rastreabilidade
~~~

---

# 63. Workflow — Compra com Fornecedor sem Documento

~~~text
Nova compra
  ↓
Selecionar fornecedor sem CPF/CNPJ
  ↓
Fornecedor ativo?
  ↓
Não bloqueado?
  ↓
Categoria/contexto válido?
  ↓
SIM
  ↓
Permitir operação
~~~

Ausência de documento, isoladamente, não bloqueia a operação.

---

# 64. Workflow — Consulta com Usuário VIEW

~~~text
Usuário possui VIEW
  ↓
Consultar fornecedor
  ↓
Pode carregar dados cadastrais permitidos
  ↓
Pode consultar contatos/endereço
  ↓
Não deve precisar de EDIT para simples leitura
~~~

Esse comportamento foi corrigido durante a homologação.

---

# 65. Workflow — Dados Bancários e VIEW

~~~text
Usuário possui VIEW do fornecedor
  ↓
Tem fornecedor.dados_bancarios?
  ├── SIM
  │    ↓
  │  Receber dados bancários
  │
  └── NÃO
       ↓
     Dados sensíveis ocultados
~~~

VIEW geral não implica permissão bancária.

---

# 66. Workflow — Regressão Após Correção

Para correções pequenas:

~~~text
Identificar defeito
  ↓
Investigar causa
  ↓
Alteração localizada
  ↓
Executar testes específicos
  ↓
Validar TypeScript/checks necessários
  ↓
Homologação manual
~~~

Suíte completa pode ser reservada para checkpoints maiores, salvo quando a alteração justificar regressão ampla.

---

# 67. Workflow — Checkpoint de Módulo

Ao concluir uma etapa significativa:

~~~text
Implementação
  ↓
Testes específicos
  ↓
Suíte relevante
  ↓
Build
  ↓
Homologação manual
  ↓
Documentação
  ↓
Commit
  ↓
Próxima fase
~~~

---

# 68. Workflow — Evolução dos Campos Legados

~~~text
Campo legado identificado
  ↓
Criar estrutura nova
  ↓
Manter compatibilidade
  ↓
Migrar consumidores
  ↓
Validar regressão
  ↓
Avaliar remoção futura
~~~

Campos atuais que exigem cuidado:

- cnpj;
- categoria;
- prazo_padrao_pagamento;
- conta_contabil.

---

# 69. Workflow Futuro — Avaliação de Fornecedor

Planejamento da Fase 2:

~~~text
Fornecedor
  ↓
Selecionar categoria
  ↓
Nova avaliação
  ↓
Informar notas por critério
  ↓
Salvar
  ↓
Calcular score da avaliação
  ↓
Atualizar score atual
  ↓
Atualizar classificação
~~~

Ainda não implementado.

---

# 70. Workflow Futuro — Score

~~~text
Avaliações recentes
  ↓
Aplicar pesos de critérios
  ↓
Aplicar peso de recência
  ↓
Normalizar
  ↓
Score 0–100
  ↓
Classificação
~~~

Classificações planejadas:

- Excelente;
- Bom;
- Regular;
- Ruim.

---

# 71. Workflow Futuro — Score Ruim

~~~text
Fornecedor com score ruim
  ↓
Nova seleção operacional
  ↓
Apresentar alerta
  ↓
Usuário confirma?
  ├── SIM → continuar
  └── NÃO → cancelar
~~~

Score ruim não deve bloquear automaticamente o fornecedor.

---

# 72. Workflow Futuro — Comparação

~~~text
Escolher categoria
  ↓
Selecionar 2 ou mais fornecedores
  ↓
Consultar:
  - Score
  - Critérios
  - Histórico
  - Indicadores comerciais
  ↓
Comparar
~~~

Não implementado na Fase 1.

---

# 73. Workflow Futuro — Banco Oficial

~~~text
Fonte oficial BACEN
  ↓
Atualizar cadastro de bancos
  ↓
Usuário pesquisa instituição
  ↓
Seleciona código + nome
  ↓
Fornecedor referencia banco padronizado
~~~

Ainda pendente.

---

# 74. Regras que Não Podem ser Quebradas

1. Fornecedor sempre pertence a uma empresa.
2. Documento é único por empresa quando informado.
3. Fornecedor sem documento é permitido.
4. Múltiplas categorias são permitidas.
5. Só um contato principal ativo por tipo.
6. Só um endereço principal ativo por tipo.
7. Fornecedor inativo não participa de nova operação.
8. Fornecedor bloqueado não participa de nova operação.
9. Dados bancários exigem permissão própria.
10. Prazo, conta e natureza devem respeitar empresa.
11. Fornecedor vinculado não deve ser apagado.
12. Indicadores devem ser calculados no backend.
13. Histórico deve ser preservado.
14. Eventos administrativos relevantes devem ser auditados.

---

# 75. Resultado da Homologação

Foram executados manualmente:

**30 itens de homologação**

Resultado:

**30 OK**

Nenhuma pendência conhecida impede o uso da Fase 1.

---

# 76. Conclusão

Os workflows da Fase 1 de Fornecedores estão homologados e representam o comportamento esperado do SISVAR para cadastro e utilização operacional de fornecedores.

Qualquer mudança futura deve preservar estes fluxos ou documentar explicitamente sua substituição.

Status:

> **WORKFLOWS — FORNECEDORES FASE 1 — HOMOLOGADOS**