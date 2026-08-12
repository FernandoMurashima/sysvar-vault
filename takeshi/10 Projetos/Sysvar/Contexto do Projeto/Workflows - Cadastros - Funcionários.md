---
type: workflows
status: approved
project: Sysvar
group: Cadastros
module: Funcionários
phase: Fase 1
created: 2026-08-12
updated: 2026-08-12
tags:
  - sysvar
  - cadastros
  - funcionários
  - cargos
  - workflows
  - multiempresa
  - comissão
  - usuários
  - lojas
  - auditoria
  - homologado
---

# Workflows - Cadastros - Funcionários

## 1. Identificação

- **Projeto:** Sysvar
- **Módulo:** Cadastros
- **Funcionalidade:** Funcionários
- **Escopo:** Fase 1 — Gestão Operacional
- **Situação:** IMPLEMENTADO E HOMOLOGADO
- **Homologação manual:** 17/17 itens aprovados
- **Data da homologação:** 12/08/2026

---

# 2. Objetivo

Este documento descreve os principais fluxos funcionais e operacionais do cadastro de Funcionários do Sysvar.

Os workflows documentados contemplam:

- criação de Cargo;
- criação de Funcionário;
- matrícula automática e manual;
- validação de CPF;
- definição de Loja Principal;
- configuração multi-loja;
- participação em vendas;
- comissão;
- vínculo Funcionário × Usuário;
- edição;
- afastamento;
- retorno;
- desligamento;
- recontratação;
- histórico;
- exclusão;
- consulta;
- filtros;
- proteção de salário;
- integração com vendas;
- Auditoria Central.

O objetivo é registrar como cada operação deve ocorrer e quais regras precisam ser respeitadas em cada etapa.

---

# 3. Princípios Gerais dos Workflows

Todo fluxo de Funcionários deve respeitar os seguintes princípios:

1. backend é autoridade das regras;
2. todo Funcionário pertence a uma Empresa;
3. Cargo pertence à mesma Empresa;
4. Loja pertence à mesma Empresa;
5. Usuário vinculado pertence à mesma Empresa;
6. matrícula é única por Empresa;
7. CPF é único por Empresa;
8. Cargo não concede permissão;
9. Funcionário não é Usuário;
10. histórico operacional deve ser preservado;
11. operações relevantes devem ser auditadas;
12. Funcionário utilizado deve ser desligado, e não apagado;
13. afastado ou desligado não deve ser utilizado normalmente em nova operação;
14. recontratação reutiliza o mesmo Funcionário.

---

# 4. Workflow — Abrir Cadastro de Funcionários

Fluxo:

~~~text
Usuário acessa Cadastros
        ↓
Seleciona Funcionários
        ↓
Frontend verifica acesso ao módulo
        ↓
Carrega indicadores
        ↓
Carrega filtros
        ↓
Solicita primeira página à API
        ↓
Backend aplica empresa/tenant
        ↓
Backend aplica paginação
        ↓
Frontend apresenta resultados
~~~

A tela não deve carregar todos os Funcionários da Empresa para depois realizar paginação local.

---

# 5. Workflow — Listagem Server-Side

Fluxo:

~~~text
Frontend
   ↓
GET Funcionários
   ↓
Parâmetros:
- página
- tamanho da página
- busca
- Cargo
- Loja
- situação
- participa de vendas
- comissionado
- ordenação
   ↓
Backend identifica Empresa
   ↓
Aplica filtros
   ↓
Aplica ordenação
   ↓
Aplica paginação
   ↓
Retorna página + total
   ↓
Frontend apresenta resultado
~~~

A listagem é orientada ao servidor.

---

# 6. Workflow — Pesquisa Textual

O campo de busca deve permitir localizar Funcionários por informações como:

- matrícula;
- nome;
- apelido;
- CPF.

Fluxo:

~~~text
Usuário informa busca
        ↓
Frontend envia termo à API
        ↓
Backend restringe à Empresa
        ↓
Backend pesquisa campos permitidos
        ↓
Resultado paginado
        ↓
Frontend apresenta
~~~

A busca não deve romper isolamento multiempresa.

---

# 7. Workflow — Filtrar por Cargo

Fluxo:

~~~text
Usuário seleciona Cargo
        ↓
Frontend envia cargo_id
        ↓
Backend valida contexto
        ↓
Filtra Funcionários da Empresa
        ↓
Retorna página
~~~

Cargo de outra Empresa nunca pode produzir acesso cross-tenant.

---

# 8. Workflow — Filtrar por Loja

Fluxo:

~~~text
Usuário seleciona Loja
        ↓
Frontend envia loja_id
        ↓
Backend restringe à Empresa
        ↓
Filtra Funcionários
        ↓
Retorna resultado
~~~

Loja de outra Empresa não deve ser aceita como escopo válido.

---

# 9. Workflow — Filtrar por Situação

Situações:

~~~text
ATIVO
AFASTADO
DESLIGADO
~~~

Fluxo:

~~~text
Usuário seleciona situação
        ↓
Frontend envia parâmetro
        ↓
Backend filtra
        ↓
Retorna somente situação solicitada
~~~

---

# 10. Workflow — Criar Novo Cargo

Fluxo:

~~~text
Usuário acessa Cargos
        ↓
Clica Novo Cargo
        ↓
Informa:
- código
- descrição
- participa de vendas
- permite comissão
- exige Loja Principal
- permite múltiplas lojas
- gerencial
- ativo
        ↓
Frontend envia à API
        ↓
Backend identifica Empresa
        ↓
Valida código único na Empresa
        ↓
Valida dados
        ↓
Cria Cargo
        ↓
Registra auditoria
        ↓
Retorna Cargo
        ↓
Cargo passa a estar disponível aos Funcionários
~~~

---

# 11. Workflow — Código de Cargo Duplicado

Fluxo:

~~~text
Usuário cria Cargo
        ↓
Código já existe na mesma Empresa
        ↓
Backend recusa
        ↓
Frontend apresenta mensagem
        ↓
Nenhum Cargo duplicado é criado
~~~

O mesmo código pode existir em Empresa diferente.

---

# 12. Workflow — Cargo Livre

O sistema não trabalha com enumeração fechada.

Fluxo:

~~~text
Empresa necessita novo Cargo
        ↓
Usuário cria código e descrição
        ↓
Configura características
        ↓
Salva
        ↓
Cargo fica disponível
        ↓
Funcionários podem receber esse Cargo
~~~

Exemplo:

~~~text
Código: ANALFIN
Descrição: Analista Financeiro
~~~

Nenhuma alteração de código-fonte é necessária.

---

# 13. Workflow — Cargos Básicos de Nova Empresa

Fluxo:

~~~text
Nova Empresa é criada
        ↓
Signal de Empresa é executado
        ↓
CargoInicialService é chamado
        ↓
Sistema verifica Cargo por código
        ↓
Cria somente os inexistentes
        ↓
Empresa recebe conjunto inicial
~~~

O processo não deve:

- duplicar Cargo;
- sobrescrever configuração existente.

---

# 14. Workflow — Nova Empresa com Cargos Básicos

Após a criação da Empresa, devem estar disponíveis os Cargos básicos previstos.

Entre eles:

- Vendedor;
- Caixa;
- Gerente;
- Supervisor;
- Assistente;
- Auxiliar;
- Assistente Financeiro;
- Comprador;
- Estoquista;
- Almoxarife;
- Conferente;
- Costureira.

A Empresa continua livre para criar outros.

---

# 15. Workflow — Criar Funcionário

Fluxo principal:

~~~text
Usuário clica Novo Funcionário
        ↓
Frontend abre formulário
        ↓
Carrega Cargos da Empresa
        ↓
Carrega Lojas da Empresa
        ↓
Carrega Usuários elegíveis
        ↓
Usuário informa dados
        ↓
Frontend realiza validações básicas
        ↓
Envia dados à API
        ↓
Backend identifica Empresa
        ↓
Valida CPF
        ↓
Valida matrícula
        ↓
Valida Cargo
        ↓
Valida Loja
        ↓
Valida abrangência
        ↓
Valida comissão
        ↓
Valida Usuário vinculado
        ↓
Valida salário conforme permissão
        ↓
Cria Funcionário
        ↓
Registra auditoria
        ↓
Retorna registro
        ↓
Frontend atualiza listagem
~~~

---

# 16. Workflow — Empresa do Novo Funcionário

Para usuário pertencente a uma Empresa:

~~~text
Usuário autenticado
        ↓
Backend obtém user.empresa
        ↓
Funcionário é criado nessa Empresa
~~~

Não confiar em Empresa arbitrária enviada pelo frontend.

Para superusuário, a Empresa pode ser explicitamente selecionada conforme fluxo administrativo existente.

---

# 17. Workflow — Matrícula Automática

Fluxo:

~~~text
Usuário deixa matrícula vazia
        ↓
Frontend envia cadastro
        ↓
Backend identifica Empresa
        ↓
Localiza sequência aplicável
        ↓
Calcula próxima matrícula
        ↓
Exemplo: 000007
        ↓
Valida unicidade
        ↓
Cria Funcionário
~~~

A sequência é por Empresa.

---

# 18. Workflow — Matrícula Manual

Fluxo:

~~~text
Usuário informa matrícula
        ↓
Backend normaliza conforme regra
        ↓
Verifica Empresa + matrícula
        ↓
Não existe
   ↓
Aceita
~~~

Se já existir:

~~~text
Empresa + matrícula existente
        ↓
Cadastro recusado
~~~

---

# 19. Workflow — Preservação da Matrícula

Após criação:

~~~text
Funcionário
        ↓
Afastamento
        ↓
Mesma matrícula
        ↓
Retorno
        ↓
Mesma matrícula
        ↓
Desligamento
        ↓
Mesma matrícula
        ↓
Recontratação
        ↓
Mesma matrícula
~~~

A matrícula não deve ser regenerada.

---

# 20. Workflow — CPF Obrigatório

Fluxo:

~~~text
Novo Funcionário
        ↓
CPF vazio
        ↓
Backend recusa
        ↓
Frontend apresenta erro
~~~

CPF é obrigatório na Fase 1.

---

# 21. Workflow — CPF Inválido

Fluxo:

~~~text
Usuário informa CPF
        ↓
Frontend pode validar formato
        ↓
Backend normaliza para dígitos
        ↓
Backend valida CPF
        ↓
CPF inválido
        ↓
Operação recusada
~~~

A validação do frontend nunca substitui a do backend.

---

# 22. Workflow — CPF Duplicado

Fluxo:

~~~text
CPF válido
        ↓
Backend consulta Empresa + CPF
        ↓
Já existe Funcionário
        ↓
Operação recusada
~~~

Em Empresa diferente, o CPF pode ser reutilizado.

---

# 23. Workflow — Seleção de Cargo

Fluxo:

~~~text
Formulário de Funcionário
        ↓
Frontend consulta API de Cargos
        ↓
Mostra Cargos da Empresa
        ↓
Usuário seleciona Cargo
        ↓
Frontend ajusta campos dependentes
        ↓
Backend valida novamente ao salvar
~~~

Não utilizar lista hardcoded.

---

# 24. Workflow — Cargo de Outra Empresa

Mesmo que uma requisição seja manipulada manualmente:

~~~text
funcionario.empresa = Empresa A
cargo.empresa = Empresa B
        ↓
Backend detecta divergência
        ↓
Operação recusada
~~~

---

# 25. Workflow — Cargo Inativo

Fluxo esperado para nova atribuição:

~~~text
Cargo inativo
        ↓
Não deve ser oferecido normalmente no combo
        ↓
Se ID for enviado manualmente
        ↓
Backend valida
        ↓
Nova atribuição recusada
~~~

Relacionamentos históricos permanecem preservados.

---

# 26. Workflow — Loja Principal Obrigatória

Para Cargo configurado com necessidade operacional de Loja:

~~~text
Cargo exige Loja Principal
        ↓
Funcionário sem Loja
        ↓
Backend recusa
~~~

Exemplos iniciais:

- Vendedor;
- Caixa;
- Gerente;
- Estoquista;
- Almoxarife.

---

# 27. Workflow — Funcionário Administrativo sem Loja

Para Cargo que não exige Loja:

~~~text
Cargo administrativo
        ↓
Loja Principal vazia
        ↓
Backend aceita
~~~

Exemplo:

~~~text
Assistente Financeiro
Loja Principal: Nenhuma
~~~

quando a configuração do Cargo permitir.

---

# 28. Workflow — Loja de Outra Empresa

Fluxo:

~~~text
Funcionário da Empresa A
        ↓
Recebe loja_id da Empresa B
        ↓
Backend valida Loja
        ↓
Empresa divergente
        ↓
Operação recusada
~~~

---

# 29. Workflow — Alterar Loja Principal

Fluxo:

~~~text
Funcionário possui Loja A
        ↓
Usuário edita para Loja B
        ↓
Backend valida mesma Empresa
        ↓
Atualiza Funcionário
        ↓
Cria FuncionarioHistorico
        ↓
Registra valor anterior
        ↓
Registra valor novo
        ↓
Registra Auditoria Central
~~~

---

# 30. Workflow — Supervisor Multi-Loja

Fluxo:

~~~text
Funcionário recebe Cargo Supervisor
        ↓
Cargo permite_multiplas_lojas = true
        ↓
Frontend habilita abrangência
        ↓
Usuário seleciona:
- lojas específicas
OU
- todas as lojas
        ↓
Backend valida Empresa
        ↓
Backend valida Cargo
        ↓
Salva abrangência
        ↓
Registra histórico
        ↓
Registra auditoria
~~~

---

# 31. Workflow — Supervisor com Lojas Específicas

Exemplo:

~~~text
Supervisor
        ↓
Loja A
Loja B
Loja C
        ↓
lojas_supervisionadas = [A, B, C]
todas_lojas_da_empresa = false
~~~

---

# 32. Workflow — Supervisor com Todas as Lojas

Fluxo:

~~~text
Supervisor
        ↓
Usuário seleciona Todas as lojas
        ↓
todas_lojas_da_empresa = true
        ↓
Abrangência operacional = Empresa inteira
~~~

A implementação deve manter coerência com a estrutura de lojas selecionadas conforme regra corrente.

---

# 33. Workflow — Cargo sem Multi-Loja

Fluxo:

~~~text
Cargo.permite_multiplas_lojas = false
        ↓
Usuário tenta selecionar várias lojas
        ↓
Frontend deve impedir/orientar
        ↓
Backend valida
        ↓
Operação recusada ou regularizada
~~~

Backend é autoridade final.

---

# 34. Workflow — Trocar Supervisor para Cargo Comum

Fluxo:

~~~text
Funcionário
Cargo atual: Supervisor
Abrangência: Loja A + Loja B
        ↓
Usuário troca Cargo
        ↓
Novo Cargo não permite múltiplas lojas
        ↓
Sistema regulariza abrangência
        ↓
Não mantém estado incompatível
        ↓
Registra histórico
        ↓
Registra auditoria
~~~

---

# 35. Workflow — Participação em Vendas

Fluxo:

~~~text
Cargo permite contexto comercial
        ↓
Funcionário configurado com participa_vendas
        ↓
Funcionário ATIVO
        ↓
Pode ser considerado em seleções de vendedor
~~~

A disponibilidade final depende também da operação de Vendas.

---

# 36. Workflow — Funcionário que Não Participa de Vendas

~~~text
participa_vendas = false
        ↓
Não deve aparecer normalmente como vendedor
~~~

Isso não impede que seu Usuário possua acesso ao módulo Vendas por motivo administrativo.

---

# 37. Workflow — Configurar Comissão

Fluxo:

~~~text
Cargo permite comissão
        ↓
Usuário marca Comissionado
        ↓
Informa percentual
        ↓
Backend valida Cargo
        ↓
Salva comissionado
        ↓
Salva comissão_percentual
        ↓
Registra auditoria
~~~

---

# 38. Workflow — Cargo sem Comissão

~~~text
Cargo.permite_comissao = false
        ↓
Usuário tenta marcar Comissionado
        ↓
Frontend deve impedir/orientar
        ↓
Backend valida
        ↓
Estado incoerente recusado
~~~

---

# 39. Workflow — Comissão de Vendedor

Exemplo:

~~~text
Cargo: Vendedor
permite_comissao = true
        ↓
Funcionário:
comissionado = true
comissao_percentual = 2,00
~~~

---

# 40. Workflow — Comissão de Gerente

Fluxo cadastral:

~~~text
Cargo: Gerente
permite_comissao = true
        ↓
Funcionário pode ser marcado como comissionado
        ↓
Percentual básico pode ser informado
~~~

O cadastro não calcula comissão sobre faturamento da Loja nesta fase.

---

# 41. Workflow — Comissão de Supervisor

Fluxo cadastral:

~~~text
Cargo: Supervisor
permite_comissao = true
        ↓
Funcionário pode ser comissionado
        ↓
Abrangência operacional já existe
~~~

A regra futura de cálculo sobre várias Lojas pertence ao módulo de Planejamento/Ação de Vendas.

---

# 42. Workflow — Alterar Comissão

Fluxo:

~~~text
Funcionário possui comissão anterior
        ↓
Usuário autorizado edita
        ↓
Backend valida Cargo
        ↓
Atualiza percentual
        ↓
Audit Central registra alteração
~~~

A alteração não deve reescrever silenciosamente histórico de vendas.

---

# 43. Workflow — Funcionário sem Usuário

Fluxo válido:

~~~text
Novo Funcionário
        ↓
Usuário vinculado = Nenhum
        ↓
Cadastro salvo
~~~

Exemplos:

- vendedor que não opera terminal;
- auxiliar de produção;
- conferente;
- estoquista sem login próprio.

---

# 44. Workflow — Vincular Funcionário a Usuário

Fluxo:

~~~text
Usuário edita Funcionário
        ↓
Seleciona Usuário vinculado
        ↓
Frontend envia usuario_id
        ↓
Backend consulta User
        ↓
Valida mesma Empresa
        ↓
Valida OneToOne
        ↓
Cria vínculo
        ↓
Registra auditoria
~~~

---

# 45. Workflow — Usuário de Outra Empresa

~~~text
Funcionário Empresa A
        ↓
usuario_id Empresa B
        ↓
Backend detecta divergência
        ↓
Vínculo recusado
~~~

---

# 46. Workflow — Usuário Já Vinculado

~~~text
Usuário já está ligado ao Funcionário A
        ↓
Tentativa de ligar ao Funcionário B
        ↓
Backend recusa
~~~

A cardinalidade é um para um.

---

# 47. Workflow — Remover Vínculo com Usuário

Fluxo:

~~~text
Funcionário possui Usuário
        ↓
Usuário seleciona Nenhum
        ↓
Frontend envia usuario = null
        ↓
Backend remove vínculo
        ↓
Usuário continua existindo
        ↓
Funcionário continua existindo
        ↓
Auditoria registra desvínculo
~~~

---

# 48. Workflow — Vínculo Não Muda Permissão

Após vincular:

~~~text
Cargo permanece igual
Perfil permanece igual
Permissões permanecem iguais
Overrides permanecem iguais
User.lojas permanece independente
~~~

O relacionamento apenas conecta as identidades.

---

# 49. Workflow — Novo Funcionário com Dados Complementares

Campos opcionais:

- apelido;
- telefone;
- WhatsApp;
- e-mail;
- data de nascimento;
- endereço;
- observações.

Fluxo:

~~~text
Usuário preenche ou deixa vazio
        ↓
Frontend valida formatos aplicáveis
        ↓
Backend valida novamente
        ↓
Salva
~~~

Campos opcionais vazios não impedem o cadastro.

---

# 50. Workflow — Telefone

Fluxo:

~~~text
Usuário informa telefone
        ↓
Frontend aplica máscara
        ↓
API recebe valor
        ↓
Backend normaliza/valida
        ↓
Persiste conforme padrão do projeto
~~~

---

# 51. Workflow — WhatsApp

Segue lógica semelhante ao telefone.

Pode ser:

- igual ao telefone;
- diferente;
- vazio.

---

# 52. Workflow — E-mail

~~~text
E-mail vazio
        ↓
Aceito

E-mail válido
        ↓
Aceito

E-mail inválido
        ↓
Recusado
~~~

---

# 53. Workflow — Editar Funcionário

Fluxo:

~~~text
Usuário seleciona Funcionário
        ↓
Clica Editar
        ↓
Frontend carrega dados
        ↓
Usuário altera campos
        ↓
Frontend envia alteração
        ↓
Backend valida regras
        ↓
Identifica mudanças relevantes
        ↓
Atualiza Funcionário
        ↓
Gera histórico quando aplicável
        ↓
Gera auditoria
        ↓
Retorna registro atualizado
~~~

---

# 54. Workflow — Alterações que Geram Histórico

Mudanças como:

- Cargo;
- Loja Principal;
- abrangência;
- afastamento;
- retorno;
- desligamento;
- recontratação;

devem preservar trajetória operacional.

---

# 55. Workflow — Alterações que Geram Auditoria

Além das alterações de histórico, Audit Central registra ações administrativas relevantes como:

- criação;
- atualização;
- comissão;
- vínculo de Usuário;
- desvínculo;
- exclusão;
- exclusão negada.

---

# 56. Workflow — Consultar Funcionário

Fluxo:

~~~text
Usuário seleciona registro
        ↓
Clica Consultar
        ↓
Frontend obtém detalhes
        ↓
Apresenta modo somente leitura
        ↓
Exibe:
- Dados cadastrais
- Comercial
- Abrangência
- Acesso
- Histórico
~~~

Consulta não deve permitir gravação acidental.

---

# 57. Workflow — Consultar Histórico

Fluxo:

~~~text
Consulta do Funcionário
        ↓
Frontend solicita histórico
        ↓
Backend valida Empresa/permissão
        ↓
Consulta FuncionarioHistorico
        ↓
Ordena cronologicamente
        ↓
Retorna eventos
        ↓
Frontend apresenta
~~~

---

# 58. Workflow — Afastar Funcionário

Pré-condição principal:

`Funcionário ATIVO`

Fluxo:

~~~text
Usuário seleciona Afastar
        ↓
Frontend solicita confirmação/dados
        ↓
POST afastar
        ↓
Backend valida Funcionário
        ↓
Backend valida transição
        ↓
situacao = AFASTADO
        ↓
Cria histórico
        ↓
Registra auditoria
        ↓
Frontend atualiza tela
~~~

---

# 59. Workflow — Uso após Afastamento

Após:

~~~text
situacao = AFASTADO
~~~

o Funcionário:

- permanece consultável;
- permanece nos registros antigos;
- não deve estar disponível normalmente para nova operação.

---

# 60. Workflow — Retornar Funcionário Afastado

Pré-condição:

`AFASTADO`

Fluxo:

~~~text
Usuário seleciona Retornar
        ↓
Backend valida estado
        ↓
situacao = ATIVO
        ↓
Cria histórico
        ↓
Registra auditoria
        ↓
Funcionário volta à disponibilidade operacional
~~~

---

# 61. Workflow — Desligar Funcionário

Fluxo:

~~~text
Funcionário ATIVO
        ↓
Usuário seleciona Desligar
        ↓
Informa dados necessários
        ↓
POST desligar
        ↓
Backend valida
        ↓
situacao = DESLIGADO
        ↓
Registra data de desligamento
        ↓
Cria histórico
        ↓
Registra auditoria
        ↓
Funcionário deixa novas operações
~~~

---

# 62. Workflow — Dados Preservados no Desligamento

Desligar não remove:

- ID;
- CPF;
- matrícula;
- vendas;
- histórico;
- auditoria;
- Cargo histórico;
- demais referências.

---

# 63. Workflow — Recontratar Funcionário

Pré-condição:

`DESLIGADO`

Fluxo:

~~~text
Usuário seleciona Recontratar
        ↓
Backend valida estado
        ↓
Reutiliza mesmo registro
        ↓
situacao = ATIVO
        ↓
Atualiza dados aplicáveis
        ↓
Preserva matrícula
        ↓
Preserva CPF
        ↓
Cria histórico
        ↓
Registra auditoria
~~~

---

# 64. Workflow — Recontratação Incorreta

Não fazer:

~~~text
Funcionário desligado
        ↓
Criar novo Funcionário com mesmo CPF
~~~

Isso deve ser bloqueado pela unicidade.

Fluxo correto:

~~~text
Funcionário desligado
        ↓
Recontratar
~~~

---

# 65. Workflow — Situação e Usuário

Afastar ou desligar Funcionário não executa automaticamente:

~~~text
User.is_active = false
~~~

Fluxo atual:

~~~text
Funcionário muda de situação
        ↓
User permanece independente
~~~

Qualquer automatismo futuro precisa de decisão funcional específica.

---

# 66. Workflow — Salário para Usuário Autorizado

Fluxo:

~~~text
Usuário possui permissão funcionario.salario
        ↓
Consulta Funcionário
        ↓
Backend inclui salário
        ↓
Frontend apresenta valor
~~~

Na edição:

~~~text
Usuário autorizado altera salário
        ↓
Backend aceita alteração
        ↓
Auditoria registra
~~~

---

# 67. Workflow — Salário para Usuário Não Autorizado

Fluxo:

~~~text
Usuário não possui funcionario.salario
        ↓
Consulta Funcionário
        ↓
Backend protege valor
        ↓
Frontend não apresenta salário
~~~

Tentativa manual de alteração:

~~~text
Requisição manipulada
        ↓
Backend verifica permissão
        ↓
Alteração recusada/ignorada conforme regra implementada
~~~

Segurança não depende do Angular.

---

# 68. Workflow — Excluir Funcionário Novo

Fluxo permitido:

~~~text
Funcionário criado
        ↓
Nunca utilizado operacionalmente
        ↓
Usuário seleciona Excluir
        ↓
Backend verifica dependências
        ↓
Nenhuma dependência impeditiva
        ↓
Exclui
        ↓
Registra auditoria
~~~

---

# 69. Workflow — Excluir Funcionário Utilizado

Fluxo:

~~~text
Usuário seleciona Excluir
        ↓
Backend verifica dependências
        ↓
Funcionário possui uso operacional
        ↓
Exclusão recusada
        ↓
Audit Central registra tentativa negada
        ↓
Frontend apresenta orientação
~~~

Mensagem:

~~~text
Funcionário já utilizado em operações. Desligue o funcionário em vez de excluí-lo.
~~~

---

# 70. Workflow — Preservação Histórica

Funcionário utilizado segue:

~~~text
ATIVO
        ↓
DESLIGADO
        ↓
permanece no banco
~~~

e não:

~~~text
ATIVO
        ↓
DELETE
        ↓
perda histórica
~~~

---

# 71. Workflow — Funcionário em Venda

Fluxo conceitual:

~~~text
PDV inicia venda
        ↓
Solicita vendedores elegíveis
        ↓
Funcionário deve:
- pertencer à Empresa
- estar ATIVO
- participar de vendas
- ser compatível com Loja
        ↓
Usuário seleciona vendedor
        ↓
VendaPdv.vendedor = Funcionário
~~~

---

# 72. Workflow — Operador da Venda

Separadamente:

~~~text
Usuário autenticado opera PDV
        ↓
Venda é gravada
        ↓
VendaPdv.criado_por = User
~~~

Portanto:

~~~text
VendaPdv.vendedor != necessariamente VendaPdv.criado_por
~~~

---

# 73. Workflow — Vendedor Afastado

~~~text
Funcionário passa para AFASTADO
        ↓
Não deve permanecer disponível para nova venda
        ↓
Vendas históricas continuam ligadas a ele
~~~

---

# 74. Workflow — Vendedor Desligado

~~~text
Funcionário passa para DESLIGADO
        ↓
Não aparece normalmente em nova venda
        ↓
Venda histórica preserva referência
~~~

---

# 75. Workflow — Comissão na Venda Atual

A estrutura existente pode utilizar:

`comissao_percentual`

do Funcionário conforme integrações atuais.

Esse comportamento é compatibilidade da Fase 1.

---

# 76. Workflow Futuro — Comissão Histórica

Arquitetura desejada:

~~~text
Venda acontece
        ↓
Motor determina política aplicável
        ↓
Calcula percentual/base
        ↓
Grava snapshot da regra
        ↓
Alterações futuras no Funcionário não alteram venda antiga
~~~

Esse fluxo ainda não pertence à Fase 1.

---

# 77. Workflow — Alteração de Cargo e Histórico

~~~text
Cargo anterior: Vendedor
        ↓
Novo Cargo: Gerente
        ↓
Backend atualiza Cargo
        ↓
FuncionarioHistorico:
tipo = CARGO
valor_anterior = Vendedor
valor_novo = Gerente
        ↓
Audit Central registra ação
~~~

---

# 78. Workflow — Alteração de Abrangência

~~~text
Supervisor:
Loja A + Loja B
        ↓
Usuário acrescenta Loja C
        ↓
Backend valida todas da Empresa
        ↓
Atualiza abrangência
        ↓
Historico registra mudança
        ↓
Auditoria registra
~~~

---

# 79. Workflow — Tentativa Cross-Tenant

Em qualquer operação:

~~~text
Usuário Empresa A
        ↓
Tenta informar:
Cargo Empresa B
Loja Empresa B
User Empresa B
        ↓
Backend revalida relações
        ↓
Operação recusada
~~~

Nunca confiar apenas nos combos do frontend.

---

# 80. Workflow — Audit Central

Fluxo geral:

~~~text
Operação de Funcionário
        ↓
Backend valida
        ↓
Executa ou recusa
        ↓
AuditService registra evento
        ↓
AuditLog recebe:
- Empresa
- Usuário
- ação
- entidade
- resultado
- contexto permitido
- data/hora
~~~

---

# 81. Eventos Auditáveis

Entre os eventos:

~~~text
EMPLOYEE_CREATED
EMPLOYEE_UPDATED
EMPLOYEE_ROLE_CHANGED
EMPLOYEE_STORE_CHANGED
EMPLOYEE_SCOPE_CHANGED
EMPLOYEE_LEAVE
EMPLOYEE_RETURNED
EMPLOYEE_TERMINATED
EMPLOYEE_REHIRED
EMPLOYEE_COMMISSION_CHANGED
EMPLOYEE_USER_LINKED
EMPLOYEE_USER_UNLINKED
EMPLOYEE_DELETE_DENIED
EMPLOYEE_DELETED
~~~

---

# 82. Workflow — Histórico Operacional

Fluxo geral:

~~~text
Evento operacional relevante
        ↓
Backend identifica mudança
        ↓
Cria FuncionarioHistorico
        ↓
Registra:
- tipo
- data/hora
- valor anterior
- valor novo
- motivo
- observação
- responsável
~~~

---

# 83. Histórico Não Substitui Auditoria

Para uma mudança de Cargo, podem existir:

~~~text
FuncionarioHistorico
        +
AuditLog
~~~

O primeiro representa trajetória funcional.

O segundo representa rastreabilidade de segurança.

---

# 84. Workflow — Consulta após Recontratação

Exemplo histórico:

~~~text
01/02/2025 — Admissão
10/10/2025 — Afastamento
20/10/2025 — Retorno
15/03/2026 — Desligamento
12/08/2026 — Recontratação
~~~

O Funcionário atual aparece:

~~~text
Situação: ATIVO
~~~

mas seu histórico preserva todos os eventos anteriores.

---

# 85. Workflow — Cargo e Perfil de Acesso

Fluxo correto:

~~~text
Funcionário recebe Cargo
        ↓
Cargo define função operacional
~~~

Separadamente:

~~~text
User recebe Perfil/Permissões
        ↓
Accounts define acesso
~~~

Não deve existir sincronização automática.

---

# 86. Workflow — Gerente sem Usuário

Cenário válido:

~~~text
Funcionário:
Cargo = Gerente

Usuário vinculado:
Nenhum
~~~

O Cargo continua válido.

Cargo não pressupõe login.

---

# 87. Workflow — Usuário com Perfil Diferente do Cargo

Cenário válido:

~~~text
Funcionário:
Cargo = Assistente Financeiro

User:
Perfil = Perfil personalizado
Permissões = Financeiro VIEW
~~~

Outro Assistente Financeiro pode ter:

~~~text
Financeiro EDIT
~~~

Isso confirma a separação dos domínios.

---

# 88. Workflow — Cargo Inativado em Uso

Fluxo conceitual:

~~~text
Cargo possui Funcionários vinculados
        ↓
Cargo é inativado
        ↓
Funcionários históricos permanecem relacionados
        ↓
Cargo deixa de ser opção normal para novas atribuições
~~~

Inativação é preferível à exclusão quando houver uso.

---

# 89. Workflow — Excluir Cargo sem Uso

~~~text
Cargo criado por engano
        ↓
Nenhum Funcionário utiliza
        ↓
Usuário exclui
        ↓
Backend valida dependências
        ↓
Exclui
        ↓
Auditoria registra
~~~

---

# 90. Workflow — Excluir Cargo em Uso

~~~text
Cargo possui Funcionário relacionado
        ↓
Usuário tenta excluir
        ↓
Backend detecta dependência
        ↓
Exclusão recusada
        ↓
Auditoria registra tentativa
~~~

A alternativa deve ser inativação quando aplicável.

---

# 91. Workflow — Dados Legados

Ao encontrar Funcionário antigo:

~~~text
categoria textual
ativo legado
meta legado
idloja legado
~~~

a nova implementação deve:

1. preservar compatibilidade;
2. utilizar estruturas novas como fonte preferencial;
3. não inventar dados;
4. não remover campo sem analisar consumidores.

---

# 92. Workflow — Categoria Legada

Fluxo de evolução:

~~~text
categoria antiga
        ↓
Migration 0026
        ↓
Cargo estruturado correspondente
        ↓
funcionario.cargo
~~~

Novas funcionalidades usam:

`cargo`

e não `categoria`.

---

# 93. Workflow — Meta Legada

Fluxo:

~~~text
Campo meta existe no banco
        ↓
Frontend novo não apresenta
        ↓
Novas APIs funcionais não dependem dele
        ↓
Futuro módulo de Planejamento assume responsabilidade
~~~

---

# 94. Workflow — Segurança de Dados

Toda entrada de API deve ser tratada como não confiável.

Backend deve validar novamente:

- tenant;
- Cargo;
- Loja;
- abrangência;
- CPF;
- matrícula;
- Usuário;
- comissão;
- salário;
- lifecycle;
- exclusão.

---

# 95. Workflow — Falha de Validação

Fluxo esperado:

~~~text
Requisição inválida
        ↓
Backend identifica regra violada
        ↓
Não grava estado parcial
        ↓
Retorna erro funcional
        ↓
Frontend apresenta mensagem
~~~

Operações de múltiplas alterações devem utilizar atomicidade quando necessário.

---

# 96. Workflow — Operação Bem-Sucedida

Fluxo:

~~~text
Requisição válida
        ↓
Backend grava
        ↓
Registra histórico quando necessário
        ↓
Registra auditoria
        ↓
Retorna resposta
        ↓
Frontend atualiza estado
~~~

---

# 97. Workflow — Fase 1 e RH/DP

Ao surgir uma nova solicitação como:

~~~text
Calcular férias
~~~

não acrescentar diretamente ao cadastro de Funcionários.

Fluxo correto:

~~~text
Nova necessidade
        ↓
Avaliar domínio
        ↓
Pertence a RH/DP?
        ↓
Sim
        ↓
Projetar módulo específico
        ↓
Referenciar Funcionário
~~~

---

# 98. Workflow — Fase 1 e Metas

Solicitação:

~~~text
Definir meta mensal do vendedor
~~~

Fluxo correto:

~~~text
Não salvar em Funcionarios.meta
        ↓
Planejamento/Ação de Vendas
        ↓
Criar estrutura temporal própria
        ↓
Referenciar Funcionário
~~~

---

# 99. Workflow — Fase 1 e Campanhas

Solicitação:

~~~text
Comissão de 5% durante campanha
~~~

Não alterar simplesmente:

`funcionario.comissao_percentual`

para representar regra temporária.

Fluxo futuro:

~~~text
Campanha
        ↓
Política de comissão
        ↓
Período
        ↓
Elegibilidade
        ↓
Funcionários/Cargos/Lojas
        ↓
Venda
        ↓
Snapshot da regra aplicada
~~~

---

# 100. Workflow — Alçada Comercial

Solicitação:

~~~text
Gerente pode autorizar desconto de 15%
~~~

Não implementar como propriedade genérica de Cargo em Funcionários.

Fluxo correto pertence a Vendas:

~~~text
Operação solicita desconto
        ↓
Regra de alçada
        ↓
Permissão/autorizador
        ↓
Workflow comercial
~~~

---

# 101. Workflow — Supervisor e Acesso ao Sistema

Supervisor pode supervisionar:

~~~text
Loja A
Loja B
Loja C
~~~

mas seu Usuário pode ter acesso apenas a:

~~~text
Loja A
Loja B
~~~

Esses dados não devem ser automaticamente sincronizados sem regra explícita.

---

# 102. Workflow — Usuário sem Funcionário

Também é possível existir:

~~~text
User
        ↓
sem Funcionário vinculado
~~~

Exemplo:

- superusuário da plataforma;
- usuário técnico;
- conta administrativa específica.

Não forçar vínculo universal.

---

# 103. Workflow — Superusuário

Superusuário da plataforma possui regras próprias de acesso e licenciamento.

Não deve ser transformado automaticamente em Funcionário de uma Empresa.

Funcionários é um cadastro tenant-operacional.

---

# 104. Workflow — Alteração de Dados Simples

Exemplo:

~~~text
Telefone antigo
        ↓
Usuário edita telefone
        ↓
Backend valida
        ↓
Atualiza cadastro
        ↓
Auditoria registra atualização
~~~

Não é necessário criar `FuncionarioHistorico` para cada alteração cadastral trivial se não fizer parte dos eventos funcionais definidos.

---

# 105. Workflow — Alteração de Cargo

Por ser mudança operacional importante:

~~~text
Editar Cargo
        ↓
Atualiza Funcionário
        ↓
FuncionarioHistorico
        ↓
AuditLog
~~~

---

# 106. Workflow — Alteração de Loja

Também é evento operacional relevante:

~~~text
Loja Principal A
        ↓
Loja Principal B
        ↓
FuncionarioHistorico
        ↓
AuditLog
~~~

---

# 107. Workflow — Alteração de Usuário Vinculado

~~~text
User A
        ↓
User B
~~~

deve gerar rastreabilidade de:

- desvínculo;
- novo vínculo;

conforme ações de auditoria implementadas.

---

# 108. Workflow — Alteração de Salário

~~~text
Usuário autorizado
        ↓
Altera salário
        ↓
Backend valida permissão
        ↓
Salva
        ↓
Audit Central registra
~~~

Usuário não autorizado não deve conseguir reproduzir a mesma requisição com sucesso.

---

# 109. Workflow — Recarregar Formulário Editado

Após salvar:

~~~text
API retorna Funcionário
        ↓
Frontend fecha/recarrega
        ↓
Nova consulta
        ↓
Campos devem manter valores persistidos
~~~

Isso foi especialmente validado para dados complementares.

---

# 110. Workflow — Indicadores da Tela

Fluxo:

~~~text
Tela abre
        ↓
Frontend solicita indicadores
        ↓
Backend restringe Empresa
        ↓
Calcula totais
        ↓
Retorna
        ↓
Frontend apresenta
~~~

Não calcular indicadores carregando toda a tabela no navegador.

---

# 111. Workflow — Paginação após Filtro

~~~text
Usuário está na página 5
        ↓
Aplica novo filtro
        ↓
Frontend volta para página adequada, normalmente 1
        ↓
Solicita API
        ↓
Backend retorna conjunto filtrado
~~~

Evita páginas vazias inconsistentes.

---

# 112. Workflow — Limpar Filtros

~~~text
Usuário clica Limpar
        ↓
Frontend remove parâmetros
        ↓
Volta à primeira página
        ↓
Consulta API novamente
        ↓
Lista geral da Empresa é apresentada
~~~

---

# 113. Workflow — Ordenação

~~~text
Usuário escolhe ordenação
        ↓
Frontend envia parâmetro
        ↓
Backend ordena queryset
        ↓
Aplica paginação
        ↓
Retorna página consistente
~~~

Ordenar depois da paginação produziria resultado incorreto e deve ser evitado.

---

# 114. Workflow — Concorrência de Matrícula

Em eventual criação simultânea:

~~~text
Requisição A tenta 000010
Requisição B tenta 000010
        ↓
Constraint de banco
        ↓
Apenas uma pode persistir
~~~

A constraint continua sendo camada final de integridade.

---

# 115. Workflow — Concorrência de CPF

Da mesma forma:

~~~text
Duas requisições
Mesmo CPF
Mesma Empresa
        ↓
Constraint empresa + CPF
        ↓
Uma duplicidade não deve persistir
~~~

---

# 116. Workflow — Operação Transacional

Quando uma ação envolve:

- atualizar Funcionário;
- criar histórico;
- atualizar abrangência;
- registrar relações;

o processo deve evitar estado parcial.

Exemplo de estado inválido:

~~~text
Funcionário alterado para Supervisor
mas abrangência parcialmente salva
~~~

A transação deve preservar consistência quando necessário.

---

# 117. Workflow — Histórico Cronológico

A consulta deve apresentar os eventos de forma que a trajetória possa ser compreendida.

Exemplo:

~~~text
01/01 — Admissão
15/03 — Mudança de Loja
01/05 — Promoção para Gerente
10/06 — Afastamento
20/06 — Retorno
15/12 — Desligamento
~~~

---

# 118. Workflow — Auditoria de Exclusão Negada

~~~text
Usuário tenta excluir Funcionário utilizado
        ↓
Backend recusa
        ↓
Nenhum dado é apagado
        ↓
AuditLog recebe EMPLOYEE_DELETE_DENIED
~~~

Tentativa negada também é informação de segurança.

---

# 119. Workflow — Auditoria de Cargo

Fluxos de Cargo também devem gerar auditoria:

~~~text
Criar Cargo
Editar Cargo
Excluir Cargo
Tentativa de exclusão negada
~~~

Esses eventos são separados dos eventos de Funcionário.

---

# 120. Workflow — Homologação da Fase 1

A sequência manual validada foi:

~~~text
Tela
 ↓
Paginação
 ↓
Filtros
 ↓
Cargos
 ↓
Funcionário administrativo
 ↓
CPF
 ↓
Matrícula
 ↓
Ciclo operacional
 ↓
Loja Principal
 ↓
Supervisor multi-loja
 ↓
Comissão
 ↓
Usuário vinculado
 ↓
Histórico
 ↓
Exclusão
 ↓
Salário
 ↓
Dados complementares
 ↓
Regressão geral
~~~

Resultado:

~~~text
17/17 OK
~~~

---

# 121. Correções Durante a Homologação

Foram encontrados três pontos relevantes.

## Cargos

Fluxo original transmitia uma lista muito comercial.

Correção:

~~~text
Cargo passa a ser explicitamente livre
        ↓
Novos cargos administrativos e operacionais
        ↓
Novo Cargo disponível dinamicamente
~~~

## Comissão

Correção:

~~~text
GERENTE.permite_comissao = true
SUPERVISOR.permite_comissao = true
~~~

## Usuário Vinculado

Correção:

~~~text
Backend já possuía relação
        ↓
Frontend recebe combo de Usuário
        ↓
Vínculo e desvínculo passam a ser operáveis
~~~

---

# 122. Workflow Consolidado do Funcionário

~~~text
Empresa
   ↓
Cria/possui Cargos
   ↓
Novo Funcionário
   ↓
CPF válido
   ↓
Matrícula única
   ↓
Cargo
   ↓
Loja Principal quando exigida
   ↓
Abrangência quando permitida
   ↓
Participação em vendas
   ↓
Comissão quando permitida
   ↓
Usuário opcional
   ↓
ATIVO
   │
   ├── Editar
   ├── Mudar Cargo
   ├── Mudar Loja
   ├── Alterar abrangência
   ├── Alterar comissão
   ├── Vincular/Desvincular User
   │
   ├── Afastar
   │      ↓
   │   AFASTADO
   │      ↓
   │   Retornar
   │      ↓
   │    ATIVO
   │
   └── Desligar
          ↓
      DESLIGADO
          ↓
      Recontratar
          ↓
        ATIVO

Todas as mudanças relevantes
        ↓
FuncionarioHistorico
        +
AuditLog
~~~

---

# 123. Regras que Não Devem ser Quebradas

Nas próximas evoluções:

~~~text
Não duplicar Funcionário na recontratação.

Não reutilizar matrícula.

Não aceitar CPF duplicado na mesma Empresa.

Não utilizar Cargo como Perfil.

Não usar User como substituto de Funcionário.

Não sincronizar lojas operacionais e lojas de acesso automaticamente.

Não permitir comissão quando o Cargo proíbe.

Não manter multi-loja em Cargo incompatível.

Não utilizar meta legada.

Não apagar Funcionário utilizado.

Não permitir cross-tenant.

Não usar percentual atual para reescrever comissão histórica.
~~~

---

# 124. Estado Final dos Workflows

Status:

~~~text
IMPLEMENTADOS
TESTADOS
HOMOLOGADOS MANUALMENTE
APROVADOS
~~~

Resultado:

~~~text
17/17
~~~

Os workflows da Fase 1 estão aptos ao uso operacional conforme o escopo aprovado.

---

# 125. Documentos Relacionados

Mapa Técnico:

`[[10 Projetos/Sysvar/Contexto do Projeto/Mapa Técnico - Cadastros - Funcionários|Mapa Técnico - Cadastros - Funcionários]]`

Modelo de Domínio:

`[[10 Projetos/Sysvar/Contexto do Projeto/Modelo de Domínio - Cadastros - Funcionários|Modelo de Domínio - Cadastros - Funcionários]]`

Homologação:

`[[10 Projetos/Sysvar/Homologações/Homologação - Cadastros - Funcionários|Homologação - Cadastros - Funcionários]]`

Riscos e Cuidados:

`[[10 Projetos/Sysvar/Contexto do Projeto/Riscos e Cuidados - Cadastros - Funcionários|Riscos e Cuidados - Cadastros - Funcionários]]`

Projeto:

`[[10 Projetos/Sysvar/Sysvar|Sysvar]]`