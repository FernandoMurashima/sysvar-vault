---
type: risks-and-care
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
  - riscos
  - multiempresa
  - comissão
  - usuários
  - lojas
  - auditoria
  - homologado
---

# Riscos e Cuidados - Cadastros - Funcionários

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

Este documento registra os principais riscos técnicos, funcionais, operacionais e arquiteturais relacionados ao cadastro de Funcionários.

Deve ser consultado antes de alterações relevantes em:

- models;
- serializers;
- views;
- endpoints;
- migrations;
- frontend;
- Cargo;
- Loja;
- Usuários;
- permissões;
- vendas;
- comissão;
- histórico;
- auditoria;
- relatórios;
- integrações futuras.

O objetivo é evitar que evoluções futuras quebrem regras já implementadas e homologadas.

---

# 3. Classificação de Impacto

Os riscos deste documento utilizam as classificações:

~~~text
CRÍTICO
ALTO
MÉDIO
BAIXO
~~~

Critérios gerais:

## CRÍTICO

Pode causar:

- vazamento entre empresas;
- perda de histórico;
- exposição de dados sensíveis;
- inconsistência grave de identidade;
- corrupção de relações;
- quebra de segurança.

## ALTO

Pode causar:

- comportamento funcional incorreto;
- quebra de regras homologadas;
- dados inconsistentes;
- operações comerciais incorretas.

## MÉDIO

Pode causar:

- inconsistência operacional limitada;
- dificuldade de manutenção;
- UX incorreta;
- dívida técnica relevante.

## BAIXO

Impacto reduzido, normalmente ligado a:

- apresentação;
- clareza;
- melhoria futura;
- conveniência operacional.

---

# 4. Risco — Quebra do Isolamento Multiempresa

Este é um dos riscos mais importantes da funcionalidade.

Todo Funcionário pertence a uma Empresa.

Devem respeitar a mesma Empresa:

- Funcionário;
- Cargo;
- Loja Principal;
- lojas supervisionadas;
- Usuário vinculado;
- histórico;
- vendas relacionadas;
- auditoria.

Risco:

um usuário da Empresa A conseguir relacionar ou visualizar dados pertencentes à Empresa B.

Impacto:

**CRÍTICO**

Cuidados:

- validar tenant no backend;
- nunca confiar em IDs enviados pelo frontend;
- filtrar querysets pela Empresa;
- validar ForeignKeys;
- validar ManyToMany;
- manter testes cross-tenant.

---

# 5. Risco — Confiar nos Combos do Frontend

O fato de a interface apresentar somente Cargos, Lojas ou Usuários da Empresa não é garantia de segurança.

Uma requisição HTTP pode ser manipulada.

Exemplo:

~~~text
funcionario.empresa = Empresa A
cargo_id = Cargo da Empresa B
~~~

Impacto:

**CRÍTICO**

Cuidados:

- revalidar todas as relações no backend;
- nunca assumir que um ID recebido é seguro;
- manter frontend apenas como primeira camada de UX.

---

# 6. Risco — Tornar CPF Globalmente Único

A regra correta é:

~~~text
Empresa + CPF
~~~

O mesmo CPF pode existir em empresas diferentes.

Risco:

criar `unique=True` global sobre CPF.

Impacto:

**ALTO**

Consequência:

uma pessoa que trabalhe em duas empresas clientes do Sysvar ficaria impedida de ser cadastrada.

---

# 7. Risco — Permitir CPF Duplicado na Mesma Empresa

O risco oposto também existe.

Na mesma Empresa não devem existir dois Funcionários distintos com o mesmo CPF.

Impacto:

**ALTO**

Pode causar:

- duplicidade de identidade;
- vendas associadas ao cadastro errado;
- histórico fragmentado;
- recontratação incorreta;
- relatórios inconsistentes.

Cuidados:

- manter validação no serializer;
- manter constraint de banco;
- preservar testes.

---

# 8. Risco — Remover Obrigatoriedade do CPF

Na Fase 1, CPF foi definido como obrigatório para novos Funcionários.

Risco:

uma futura alteração voltar a permitir Funcionários sem CPF sem decisão funcional.

Impacto:

**ALTO**

Cuidados:

- manter obrigatoriedade na API nova;
- distinguir registros legados de novos registros;
- não flexibilizar silenciosamente a regra.

---

# 9. Risco — Inventar CPF para Registro Legado

A migration preserva registros antigos quando não possui informação válida.

Não criar CPF fictício.

Exemplos incorretos:

~~~text
00000000000
11111111111
99999999999
~~~

Impacto:

**ALTO**

Pode causar:

- identidade falsa;
- colisão;
- problemas em futuras integrações;
- impossibilidade de distinguir pessoas.

Regra:

> ausência histórica de dado deve permanecer ausência, e não virar dado inventado.

---

# 10. Risco — Reutilizar Matrícula

A matrícula é estável e não deve ser reutilizada para outra pessoa.

Impacto:

**ALTO**

Risco:

Funcionário A é desligado e sua matrícula é atribuída depois ao Funcionário B.

Consequências:

- confusão histórica;
- relatórios incorretos;
- referências ambíguas;
- falha em integrações futuras.

---

# 11. Risco — Alterar Matrícula em Recontratação

Recontratação utiliza o mesmo Funcionário.

Fluxo correto:

~~~text
DESLIGADO
    ↓
RECONTRATAR
    ↓
ATIVO
    ↓
mesma matrícula
~~~

Impacto se quebrado:

**ALTO**

Não gerar nova matrícula automaticamente durante recontratação.

---

# 12. Risco — Duplicar Funcionário na Recontratação

Erro conceitual grave:

~~~text
Funcionário desligado
        ↓
Cadastrar novamente
        ↓
Novo ID
~~~

Impacto:

**ALTO**

Consequências:

- histórico dividido;
- duas identidades para a mesma pessoa;
- vendas espalhadas entre registros;
- comissões fragmentadas;
- relatórios incorretos.

Fluxo correto:

~~~text
Funcionário desligado
        ↓
Recontratar
~~~

---

# 13. Risco — Transformar Cargo em Enumeração Fechada

Cargo é cadastro aberto por Empresa.

Não voltar a implementar:

~~~text
VENDEDOR
CAIXA
GERENTE
~~~

como únicas opções possíveis.

Impacto:

**ALTO**

Isso impediria funções como:

- Assistente Financeiro;
- Comprador;
- Estoquista;
- Almoxarife;
- Analista;
- funções de produção;
- cargos particulares da empresa.

---

# 14. Risco — Hardcode de Cargo no Frontend

Não utilizar arrays como:

~~~text
['Vendedor', 'Caixa', 'Gerente']
~~~

Impacto:

**ALTO**

O combo deve sempre consumir o cadastro de Cargos da Empresa.

Cargo novo deve aparecer sem alteração do código Angular.

---

# 15. Risco — Reutilizar categoria como Fonte de Verdade

Campo legado:

`categoria`

Fonte funcional atual:

`cargo`

Risco:

nova funcionalidade voltar a consultar `categoria` para determinar função do Funcionário.

Impacto:

**ALTO**

Cuidados:

- utilizar `cargo`;
- preservar `categoria` apenas por compatibilidade;
- pesquisar consumidores antes de removê-la.

---

# 16. Risco — Remover categoria Prematuramente

O fato de `cargo` ser a fonte atual não significa que o campo legado possa ser apagado imediatamente.

Impacto:

**ALTO**

Pode quebrar:

- código antigo;
- relatórios;
- integrações;
- scripts;
- migrations históricas.

Cuidados:

1. pesquisar dependências;
2. migrar consumidores;
3. testar;
4. remover somente em mudança planejada.

---

# 17. Risco — Cargo Conceder Permissão

Cargo e Perfil de Acesso são conceitos separados.

Erro:

~~~text
Cargo = Gerente
    ↓
dar automaticamente todas as permissões
~~~

Impacto:

**CRÍTICO**

Isso pode causar escalada de privilégio.

Permissões devem continuar sob responsabilidade de:

- User;
- PerfilAcesso;
- PerfilModuloPermissao;
- overrides;
- infraestrutura de permissões.

---

# 18. Risco — Confundir Cargo com Role Legada de Usuário

O sistema possui conceitos históricos de tipos/roles em outras áreas.

Cargo de Funcionário não deve ser confundido com esses mecanismos.

Impacto:

**ALTO**

Cuidados:

- tratar `Cargo` como domínio de Cadastros;
- tratar Perfil/Permissão como domínio de `accounts`;
- evitar decisões baseadas no texto do Cargo.

---

# 19. Risco — Dependência do Nome do Cargo

Não criar lógica como:

~~~text
if cargo.descricao == "Supervisor"
~~~

ou:

~~~text
if cargo.codigo == "GERENTE"
    liberar módulo
~~~

quando a funcionalidade pode ser derivada de propriedades estruturadas.

Impacto:

**ALTO**

Preferir características como:

- `participa_vendas`;
- `permite_comissao`;
- `autoridade_operacional_loja`;
- `permite_multiplas_lojas`;
- `gerencial`.

---

# 20. Risco — Sobrescrever Configuração de Cargos Básicos

`CargoInicialService` utiliza os Cargos básicos como configuração inicial.

Risco:

uma futura execução do serviço sobrescrever alterações feitas pela Empresa.

Impacto:

**ALTO**

Regra:

> defaults servem para criação inicial, não para imposição permanente.

Cuidados:

- manter `get_or_create`;
- não atualizar Cargo existente automaticamente sem decisão explícita.

---

# 21. Risco — Duplicar Cargos Básicos

Empresas existentes recebem Cargos através de migration.

Empresas futuras recebem através do serviço/signal.

Risco:

duplicar registros em execuções repetidas.

Impacto:

**MÉDIO/ALTO**

Cuidados:

- preservar unicidade `empresa + codigo`;
- manter operações idempotentes.

---

# 22. Risco — Cargo Inativo em Nova Atribuição

Cargo inativo deve preservar Funcionários antigos, mas não deve ser normalmente utilizado em nova atribuição.

Impacto:

**ALTO**

Proteções:

- frontend não oferecer;
- backend revalidar;
- não confiar apenas no filtro do combo.

---

# 23. Risco — Excluir Cargo em Uso

Cargo com Funcionários vinculados representa informação histórica.

Impacto:

**ALTO**

Risco:

- quebrar Funcionários;
- perder contexto;
- gerar inconsistência histórica.

Regra:

preferir inativação.

---

# 24. Risco — Remover Possibilidade de Comissão de Gerente

Durante homologação foi corrigido:

~~~text
GERENTE.permite_comissao = true
~~~

Risco:

regressão futura voltar para `false`.

Impacto:

**ALTO**

Gerente pode ser comissionado conforme política futura da Empresa.

---

# 25. Risco — Remover Possibilidade de Comissão de Supervisor

Regra homologada:

~~~text
SUPERVISOR.permite_comissao = true
~~~

Impacto de regressão:

**ALTO**

Supervisor pode futuramente receber comissão relacionada às lojas sob sua responsabilidade.

---

# 26. Risco — Interpretar permite_comissao como Comissão Obrigatória

`Cargo.permite_comissao = true`

não significa:

~~~text
todos os Funcionários deste Cargo são comissionados
~~~

Impacto:

**MÉDIO**

A configuração individual continua em:

`Funcionario.comissionado`

---

# 27. Risco — Guardar Percentual no Cargo

O percentual básico pertence ao Funcionário.

Não mover indiscriminadamente para Cargo.

Impacto:

**ALTO**

Funcionários do mesmo Cargo podem possuir percentuais diferentes.

Exemplo:

~~~text
Vendedor A = 2%
Vendedor B = 2,5%
~~~

---

# 28. Risco — Utilizar Comissão Atual para Recalcular Histórico

Este é um risco importante para evolução de vendas e comissões.

Se uma venda antiga consulta sempre:

`funcionario.comissao_percentual`

então alterar o percentual atual pode mudar a interpretação histórica.

Impacto futuro:

**ALTO**

Direção correta:

- preservar percentual/regra aplicada;
- criar snapshot no momento apropriado;
- não recalcular passado com configuração atual.

---

# 29. Risco — Implementar Motor de Comissão Dentro de Funcionários

Funcionários possui apenas configuração básica.

Não incluir diretamente:

- faixas;
- campanhas;
- metas;
- bônus;
- regras progressivas;
- comissão por produto;
- comissão por grupo;
- comissão por coleção.

Impacto:

**ALTO**

Isso aumentaria acoplamento e destruiria a separação de domínio.

Essas regras pertencem ao futuro módulo de Planejamento/Ação de Vendas.

---

# 30. Risco — Voltar a Usar o Campo meta

Campo legado:

`meta`

Foi retirado funcionalmente da Fase 1.

Impacto:

**ALTO**

Não utilizar em:

- formulário;
- filtro;
- cálculo;
- relatório novo;
- comissão nova.

Metas precisam de estrutura temporal própria.

---

# 31. Risco — Remover meta sem Analisar Dependências

Embora funcionalmente legado, não remover fisicamente sem pesquisa.

Impacto:

**MÉDIO/ALTO**

Cuidados:

- localizar usos;
- migrar consumidores;
- testar;
- remover em etapa específica.

---

# 32. Risco — Confundir Situação com ativo Legado

Estados atuais:

~~~text
ATIVO
AFASTADO
DESLIGADO
~~~

Campo legado:

`ativo`

Risco:

dois ciclos de vida independentes produzirem estados contraditórios.

Exemplo:

~~~text
situacao = DESLIGADO
ativo = true
~~~

Impacto:

**ALTO**

Cuidados:

- utilizar `situacao` como referência funcional;
- preservar compatibilidade conscientemente;
- evitar novas regras baseadas somente em `ativo`.

---

# 33. Risco — Permitir Transições Arbitrárias

Ações de lifecycle foram criadas para controlar transições.

Não substituir por edição livre do campo `situacao`.

Impacto:

**ALTO**

Ações:

- Afastar;
- Retornar;
- Desligar;
- Recontratar.

Elas também garantem:

- histórico;
- auditoria;
- validações;
- datas.

---

# 34. Risco — Funcionário Afastado em Nova Operação

Funcionário AFASTADO deve permanecer histórico, mas não estar normalmente disponível para nova operação.

Impacto:

**ALTO**

Pode afetar:

- PDV;
- venda;
- seleção de vendedor;
- processos futuros.

Proteção deve existir no backend das operações consumidoras.

---

# 35. Risco — Funcionário Desligado em Nova Operação

Mesmo princípio.

Impacto:

**ALTO**

Não basta esconder no frontend.

Qualquer endpoint de operação que receba `funcionario_id` deve validar sua situação quando a regra exigir Funcionário ativo.

---

# 36. Risco — Desligamento Apagar Histórico

Desligar não significa apagar.

Impacto:

**CRÍTICO**

Devem permanecer:

- vendas;
- movimentações;
- matrícula;
- CPF;
- histórico;
- auditoria;
- relações antigas.

---

# 37. Risco — Afastamento Desativar Usuário Automaticamente

Na Fase 1, situação do Funcionário e status do Usuário são independentes.

Não executar automaticamente:

~~~text
funcionario.situacao = AFASTADO
    ↓
user.is_active = false
~~~

Impacto:

**ALTO**

Qualquer automação desse tipo precisa de decisão funcional própria.

---

# 38. Risco — Desligamento Desativar Usuário Automaticamente sem Regra

Mesma preocupação.

Pode parecer intuitivo, mas não foi definido como regra da Fase 1.

Impacto:

**ALTO**

Uma política futura pode ser criada, mas deve considerar:

- segurança;
- workflows;
- data de desligamento;
- acesso administrativo;
- exceções;
- auditoria.

---

# 39. Risco — Confundir User.is_active com Situação do Funcionário

São eixos independentes.

~~~text
Funcionario.situacao
~~~

representa estado operacional.

~~~text
User.is_active
~~~

representa possibilidade de autenticação.

Impacto de confusão:

**ALTO**

---

# 40. Risco — Vincular Usuário de Outra Empresa

Relacionamento:

~~~text
Funcionario.usuario
~~~

deve respeitar:

~~~text
funcionario.empresa == usuario.empresa
~~~

Impacto:

**CRÍTICO**

Pode gerar vazamento de tenant e identidade cruzada.

---

# 41. Risco — Vincular o Mesmo Usuário a Dois Funcionários

Relacionamento é OneToOne.

Impacto:

**ALTO**

Pode causar:

- ambiguidade de identidade;
- auditoria inconsistente;
- atribuição errada em operações.

Manter constraint e validação.

---

# 42. Risco — Criar Usuário Automaticamente para Todo Funcionário

Funcionário pode existir sem login.

Não impor relação obrigatória.

Impacto:

**ALTO**

Consequências:

- aumento desnecessário de contas;
- gestão de segurança incorreta;
- confusão entre pessoa e identidade de acesso.

---

# 43. Risco — Excluir Usuário ao Desvincular

Desvincular significa:

~~~text
funcionario.usuario = null
~~~

Não significa:

~~~text
DELETE User
~~~

Impacto:

**CRÍTICO**

As entidades têm ciclos de vida separados.

---

# 44. Risco — Alterar Perfil ao Mudar Cargo

Exemplo incorreto:

~~~text
Cargo muda para Gerente
        ↓
Perfil muda automaticamente para Gerente
~~~

Impacto:

**CRÍTICO**

Isso pode conceder privilégios sem autorização.

Cargo nunca deve determinar automaticamente Perfil.

---

# 45. Risco — Sincronizar Lojas Supervisionadas com User.lojas

São domínios diferentes.

`lojas_supervisionadas`:

responsabilidade operacional.

`User.lojas`:

escopo de acesso.

Impacto:

**CRÍTICO/ALTO**

Sincronização automática pode:

- conceder acesso indevido;
- retirar acesso necessário;
- misturar estrutura organizacional com segurança.

---

# 46. Risco — Loja Principal de Outra Empresa

A Loja Principal deve pertencer à mesma Empresa.

Impacto:

**CRÍTICO**

Backend deve validar independentemente do frontend.

---

# 47. Risco — Tornar Loja Obrigatória para Todos

Nem todo Funcionário é de Loja.

Exemplos:

- Assistente Financeiro;
- Comprador;
- Auxiliar Administrativo;
- função corporativa.

Impacto:

**ALTO**

A obrigatoriedade depende da característica do Cargo.

---

# 48. Risco — Não Exigir Loja para Cargo que Precisa

Risco inverso.

Exemplo:

Vendedor sem Loja Principal quando Cargo exige contexto de Loja.

Impacto:

**ALTO**

Pode causar:

- seleção comercial ambígua;
- relatórios incorretos;
- problemas de PDV;
- falta de contexto operacional.

---

# 49. Risco — Multi-Loja em Cargo Incompatível

Somente Cargo com:

`permite_multiplas_lojas = true`

deve manter abrangência multi-loja.

Impacto:

**ALTO**

Exemplo inconsistente:

~~~text
Cargo = Caixa
permite_multiplas_lojas = false
lojas_supervisionadas = [A, B, C]
~~~

---

# 50. Risco — Troca de Cargo sem Limpar Abrangência Incompatível

Funcionário:

~~~text
Supervisor
Loja A + Loja B
~~~

muda para:

~~~text
Caixa
~~~

Se as lojas supervisionadas permanecerem, o estado fica incoerente.

Impacto:

**ALTO**

A troca deve regularizar a abrangência.

---

# 51. Risco — Lojas Supervisionadas de Outra Empresa

Todas as lojas da abrangência precisam pertencer ao mesmo tenant.

Impacto:

**CRÍTICO**

Validar cada ID no backend.

---

# 52. Risco — Interpretação Errada de todas_lojas_da_empresa

Campo:

`todas_lojas_da_empresa`

significa responsabilidade operacional sobre todas as lojas da Empresa.

Não significa:

- acesso irrestrito no sistema;
- Perfil administrativo;
- permissão global;
- acesso a outras empresas.

Impacto:

**ALTO**

---

# 53. Risco — Participa de Vendas Conceder Acesso ao PDV

`participa_vendas = true`

não é permissão de sistema.

Impacto:

**CRÍTICO**

Não utilizar esse campo para autorizar rota ou endpoint.

Acesso ao PDV continua dependente de permissões.

---

# 54. Risco — Usuário com PDV Virar Vendedor Automaticamente

O caminho inverso também não é correto.

Possuir acesso ao PDV não transforma automaticamente o Funcionário em vendedor.

Impacto:

**ALTO**

Vendedor comercial e operador de sistema podem ser pessoas diferentes.

---

# 55. Risco — Misturar VendaPdv.vendedor com criado_por

Conceitos:

~~~text
VendaPdv.vendedor
~~~

Funcionário responsável comercialmente.

~~~text
VendaPdv.criado_por
~~~

Usuário que operou o sistema.

Impacto de mistura:

**ALTO**

Pode quebrar:

- comissão;
- auditoria;
- desempenho comercial;
- rastreamento da operação.

---

# 56. Risco — Substituir ForeignKey de Vendedor por User

A relação atual com Funcionários deve ser preservada.

Impacto:

**ALTO**

User não é identidade comercial equivalente ao Funcionário.

---

# 57. Risco — Exclusão de Funcionário Utilizado

Funcionário com uso operacional não deve ser apagado.

Impacto:

**CRÍTICO**

Pode quebrar:

- vendas;
- relatórios;
- comissão;
- auditoria;
- referências futuras;
- integridade histórica.

Mensagem funcional:

~~~text
Funcionário já utilizado em operações. Desligue o funcionário em vez de excluí-lo.
~~~

---

# 58. Risco — Proteção de Exclusão Desatualizada

À medida que novos módulos passarem a referenciar Funcionários, a lógica de exclusão protegida deve ser revisada.

Impacto:

**ALTO**

Sempre que surgir nova ForeignKey para Funcionário:

> avaliar imediatamente se ela deve impedir exclusão.

---

# 59. Risco — Tratar Histórico como Dependência que Nunca Permite Exclusão de Cadastro Criado por Engano

A exclusão funcional deve distinguir:

- cadastro realmente sem uso operacional;
- cadastro já utilizado.

Impacto:

**MÉDIO**

Não tornar a exclusão impossível para um registro criado por engano apenas por causa de rastreabilidade técnica que possa ser tratada adequadamente.

Preservar a regra homologada.

---

# 60. Risco — Perder FuncionarioHistorico

Mudanças relevantes devem preservar trajetória.

Impacto:

**ALTO**

Eventos importantes:

- Cargo;
- Loja;
- abrangência;
- afastamento;
- retorno;
- desligamento;
- recontratação.

Não substituir histórico apenas pelo valor atual do model.

---

# 61. Risco — Apagar Histórico na Recontratação

Recontratação acrescenta evento.

Não deve remover:

- desligamento;
- afastamentos anteriores;
- mudanças de Cargo;
- mudanças de Loja.

Impacto:

**ALTO**

Histórico é acumulativo.

---

# 62. Risco — Histórico Virar Prontuário de RH

`FuncionarioHistorico` foi criado para eventos operacionais.

Não armazenar indiscriminadamente:

- problemas médicos;
- advertências trabalhistas;
- documentos pessoais sensíveis;
- informações de saúde;
- prontuário de RH.

Impacto:

**ALTO**

Pode criar riscos de:

- privacidade;
- LGPD;
- segurança;
- escopo.

---

# 63. Risco — Confundir Histórico com AuditLog

São estruturas distintas.

`FuncionarioHistorico`:

trajetória funcional.

`AuditLog`:

rastreabilidade técnica e de segurança.

Impacto:

**MÉDIO/ALTO**

Não eliminar uma estrutura supondo que a outra a substitui.

---

# 64. Risco — Falta de Auditoria em Alterações Relevantes

Eventos importantes devem continuar auditados.

Entre eles:

- criação;
- edição;
- Cargo;
- Loja;
- abrangência;
- lifecycle;
- comissão;
- vínculo de Usuário;
- desvínculo;
- exclusão;
- exclusão negada.

Impacto:

**ALTO**

---

# 65. Risco — AuditLog com Dados Sensíveis

Auditoria deve registrar contexto suficiente sem reproduzir dados sensíveis desnecessariamente.

Especial atenção:

- salário;
- CPF;
- dados pessoais;
- futuras informações de RH.

Impacto:

**CRÍTICO**

Cuidados:

- evitar payload bruto;
- mascarar quando apropriado;
- registrar somente o necessário.

---

# 66. Risco — Exposição de Salário

Salário é informação protegida.

Permissão:

`funcionario.salario`

Impacto:

**CRÍTICO**

Risco:

frontend ocultar o campo, mas backend continuar retornando.

Proteção precisa existir na API.

---

# 67. Risco — Alteração de Salário via Payload Manipulado

Usuário sem permissão pode tentar enviar:

~~~text
salario = 10000
~~~

diretamente para a API.

Impacto:

**CRÍTICO**

Backend deve impedir alteração indevida.

---

# 68. Risco — Salário na Listagem Padrão

Salário não deve ser exposto indiscriminadamente em listagem geral.

Impacto:

**ALTO**

Mesmo usuários autorizados podem não precisar ter valores exibidos em telas compartilhadas constantemente.

Preservar padrão homologado.

---

# 69. Risco — Transformar Funcionários em RH/DP

Este é um risco de evolução arquitetural.

A Fase 1 é operacional.

Não adicionar diretamente:

- folha;
- férias;
- benefícios;
- ponto;
- banco de horas;
- encargos;
- rescisões;
- documentos de admissão;
- dependentes.

Impacto:

**ALTO**

Essas necessidades devem ser tratadas em domínio próprio.

---

# 70. Risco — Acumular Dados Pessoais Desnecessários

Quanto mais dados pessoais forem armazenados, maior:

- superfície de segurança;
- responsabilidade de acesso;
- impacto de vazamento;
- necessidade de governança.

Impacto:

**ALTO**

Princípio:

> armazenar apenas o que possui finalidade definida.

---

# 71. Risco — Observações com Dados Sensíveis

Campo:

`observacoes`

é texto livre.

Risco:

usuários inserirem conteúdo inadequadamente sensível.

Impacto:

**MÉDIO/ALTO**

Orientação:

usar para contexto operacional e não como prontuário pessoal.

---

# 72. Risco — Validação de Telefone Baseada em Máscara

Máscara é apresentação.

Validação não deve depender de:

- parênteses;
- espaço;
- hífen.

Impacto:

**MÉDIO**

Preferir validação do número normalizado.

---

# 73. Risco — E-mail Inválido Persistido

E-mail é opcional, mas, quando informado, deve possuir formato válido.

Impacto:

**MÉDIO**

Pode prejudicar futuras notificações e integrações.

---

# 74. Risco — Data de Nascimento Gerar Regra de RH Acidentalmente

Data de nascimento é apenas informação cadastral nesta fase.

Não derivar automaticamente:

- benefícios;
- idade trabalhista;
- aposentadoria;
- políticas de RH.

Impacto:

**BAIXO/MÉDIO**

---

# 75. Risco — idloja Ser Interpretado como Campo Novo sem Legado

O nome técnico:

`idloja`

é legado.

Funcionalmente representa:

**Loja Principal**

Impacto:

**MÉDIO**

Não renomear diretamente no banco sem analisar:

- serializers;
- frontend;
- vendas;
- relatórios;
- scripts;
- migrations.

---

# 76. Risco — Remover Campos Legados em Uma Única Migration

Campos como:

- `categoria`;
- `meta`;
- `ativo`;
- `idloja`;

podem possuir consumidores antigos.

Impacto:

**ALTO**

Processo correto:

1. mapear usos;
2. migrar código;
3. criar compatibilidade;
4. testar;
5. remover em fase posterior.

---

# 77. Risco — Continuar Criando Funcionalidade Nova sobre Campos Legados

O risco inverso também existe.

Não usar legado como atalho para novos recursos.

Impacto:

**ALTO**

Preferir:

~~~text
cargo
situacao
lojas_supervisionadas
todas_lojas_da_empresa
usuario
comissionado
~~~

---

# 78. Risco — Paginação Voltar a Ser Client-Side

A tela anterior carregava grande quantidade de registros.

Não voltar ao padrão:

~~~text
page_size = 2000
~~~

para depois filtrar no Angular.

Impacto:

**ALTO**

Consequências:

- lentidão;
- uso excessivo de memória;
- resultados incompletos;
- pior escalabilidade SaaS.

---

# 79. Risco — Indicadores Calculados a partir da Página Atual

Se a tela possui paginação, não calcular totais apenas com os registros da página carregada.

Impacto:

**ALTO**

Indicadores devem ser calculados no backend sobre o conjunto correto.

---

# 80. Risco — Filtros Somente no Frontend

Filtros precisam funcionar no servidor.

Impacto:

**ALTO**

Caso contrário:

- páginas futuras não participam da busca;
- resultados ficam incompletos;
- desempenho piora.

---

# 81. Risco — Ordenar Depois da Paginação

A ordem correta é:

~~~text
queryset
    ↓
filtros
    ↓
ordenação
    ↓
paginação
~~~

Não:

~~~text
paginação
    ↓
ordenação da página
~~~

Impacto:

**MÉDIO/ALTO**

---

# 82. Risco — Perder Índices de Busca

Matrícula, CPF, situação e outros campos utilizados em filtros possuem relevância de performance.

Impacto:

**MÉDIO**

Ao alterar models ou migrations:

- revisar índices;
- observar planos de consulta quando volume crescer.

---

# 83. Risco — Concorrência na Geração de Matrícula

Duas criações simultâneas podem tentar obter a mesma próxima matrícula.

Impacto:

**ALTO**

A constraint de banco deve permanecer como última defesa.

Quando necessário, revisar atomicidade do gerador.

---

# 84. Risco — Confiar Só na Validação do Serializer para Unicidade

Validação de aplicação é importante, mas não substitui constraint de banco.

Impacto:

**ALTO**

Concorrência pode passar por duas validações simultaneamente.

Manter:

- validação amigável;
- constraint de integridade.

---

# 85. Risco — Migration Destrutiva em Dados Legados

Migration `0026` foi desenhada para evolução segura.

Não criar futura migration que:

- invente Empresa;
- invente CPF;
- descarte categoria antes da hora;
- substitua dados sem evidência.

Impacto:

**CRÍTICO**

---

# 86. Risco — Alterar Defaults Históricos de Cargo sem Controle

Migration `0028` corrigiu Gerente e Supervisor.

Novas alterações de defaults precisam distinguir:

- empresas novas;
- cargos ainda no padrão;
- cargos já customizados pelo cliente.

Impacto:

**ALTO**

Não sobrescrever configuração empresarial indiscriminadamente.

---

# 87. Risco — Mudança de Cargo sem Auditoria

Troca de Cargo pode representar mudança operacional relevante.

Impacto:

**ALTO**

Deve continuar gerando:

- histórico funcional;
- auditoria.

---

# 88. Risco — Mudança de Loja sem Histórico

Mudança de Loja Principal também possui relevância operacional.

Impacto:

**ALTO**

Sem histórico, relatórios futuros podem não saber onde a pessoa atuava em determinado período.

---

# 89. Risco — Abrangência sem Histórico

Alterações de lojas supervisionadas podem afetar futuras regras de comissão ou gestão.

Impacto:

**ALTO**

Preservar eventos de abrangência.

---

# 90. Risco — Usar Abrangência Atual para Reinterpretar Passado

No futuro, um Supervisor pode mudar de lojas.

Se relatórios históricos utilizarem somente a abrangência atual:

podem atribuir resultado passado a lojas erradas.

Impacto futuro:

**ALTO**

Direção:

regras históricas devem preservar contexto temporal quando necessário.

---

# 91. Risco — Comissão de Supervisor baseada Apenas na Abrangência Atual

Mesmo problema.

Exemplo:

~~~text
Janeiro:
Supervisor → Lojas A e B

Março:
Supervisor → Lojas C e D
~~~

Uma apuração histórica de janeiro não pode usar automaticamente C e D.

Impacto:

**ALTO**

Deve ser resolvido no futuro módulo de comissão.

---

# 92. Risco — Misturar Meta com Cadastro Permanente

Meta é temporal.

Funcionário é cadastro relativamente permanente.

Impacto:

**ALTO**

Exemplo correto futuro:

~~~text
Meta
- período
- loja
- funcionário
- valor
- campanha
~~~

e não um único campo eterno dentro de Funcionário.

---

# 93. Risco — Colocar Campanhas em Cargo

Cargo também não deve armazenar campanhas comerciais temporárias.

Impacto:

**ALTO**

Cargo representa função, não política comercial temporal.

---

# 94. Risco — Colocar Alçada Comercial em Cargo sem Domínio Próprio

Exemplo:

~~~text
Gerente pode desconto até 20%
~~~

Isso parece relacionado ao Cargo, mas é regra de Vendas/autorização.

Impacto:

**ALTO**

Deve considerar:

- permissão;
- política;
- Loja;
- período;
- exceções;
- auditoria.

Não simplificar excessivamente dentro de Cargo.

---

# 95. Risco — Excesso de Responsabilidade no Model Funcionarios

Funcionarios deve permanecer entidade operacional.

Impacto:

**ALTO**

Evitar transformar o model em recipiente para:

- RH;
- comissão avançada;
- metas;
- segurança;
- permissões;
- regras de vendas;
- folha.

---

# 96. Risco — Excesso de Lógica no Frontend

Angular deve orientar e validar UX.

Não deve ser a única implementação de regras como:

- tenant;
- comissão;
- Cargo;
- Loja;
- lifecycle;
- exclusão;
- salário.

Impacto:

**CRÍTICO/ALTO**

---

# 97. Risco — Mensagens de Erro Silenciosas

Evitar:

~~~text
if (form.invalid) return;
~~~

sem feedback visual.

Impacto:

**MÉDIO**

Usuário interpreta como botão quebrado.

Cuidados:

- marcar campos inválidos;
- exibir mensagem;
- indicar qual regra precisa ser corrigida.

---

# 98. Risco — Erro 500 para Regra de Negócio

Duplicidade, Cargo incompatível ou exclusão protegida não devem produzir erro interno genérico.

Impacto:

**MÉDIO/ALTO**

Preferir respostas funcionais claras.

---

# 99. Risco — Expor Stack Trace ao Usuário

Falha interna nunca deve retornar informações técnicas sensíveis.

Impacto:

**ALTO**

AuditLog pode registrar contexto técnico adequado, mas frontend deve receber mensagem segura.

---

# 100. Risco — AuditAction ROLE Ser Confundida com Perfil

Eventos internos de Cargo podem utilizar nomenclatura `ROLE_*`.

Impacto:

**MÉDIO**

Documentação e novos desenvolvimentos devem deixar claro:

neste contexto, `ROLE` está associado ao Cargo operacional e não a Perfil de Acesso.

Evitar expandir essa ambiguidade.

---

# 101. Risco — Testes Muito Restritos

Mudanças em Funcionários podem afetar:

- Cadastros;
- Vendas;
- PDV;
- Auditoria;
- Accounts;
- Dashboard.

Impacto:

**ALTO**

Utilizar testes direcionados durante pequenas alterações e testes mais amplos nos checkpoints de módulo.

---

# 102. Risco — Executar Apenas Testes Frontend

Como diversas regras estão no backend, passar em TypeScript/build não garante integridade funcional.

Impacto:

**ALTO**

Sempre avaliar testes Django relevantes.

---

# 103. Risco — Executar Apenas Testes Backend

Também é possível quebrar:

- formulário;
- filtros;
- combo;
- ações;
- visibilidade;
- navegação.

Impacto:

**MÉDIO/ALTO**

Alterações de contrato de API precisam de validação frontend.

---

# 104. Risco — Alterar Contrato da API sem Compatibilidade

Renomear campos como:

- `idloja`;
- `cargo`;
- `situacao`;
- `usuario`;

sem coordenar frontend pode quebrar a tela.

Impacto:

**ALTO**

Preferir evolução aditiva quando possível.

---

# 105. Risco — Alterar Choices sem Migration/Compatibilidade

Estados e códigos persistidos não devem ser alterados apenas na camada visual.

Impacto:

**ALTO**

Exemplo:

~~~text
ATIVO
AFASTADO
DESLIGADO
~~~

são valores de domínio persistidos.

---

# 106. Risco — Usar Descrição como Identificador

Descrição do Cargo pode mudar.

Não utilizar:

`descricao`

como chave técnica.

Impacto:

**MÉDIO/ALTO**

Utilizar ID/código conforme contexto.

---

# 107. Risco — Mudança de Código de Cargo Básico sem Análise

Códigos como:

- GERENTE;
- SUPERVISOR;
- VENDEDOR;

podem ser utilizados em migrations e defaults.

Impacto:

**ALTO**

Antes de alterar código:

- pesquisar dependências;
- analisar migrations;
- considerar dados existentes.

---

# 108. Risco — Dados de Funcionário em Cache sem Invalidação

Se futuramente houver cache de vendedores ou Funcionários elegíveis, mudanças de:

- situação;
- Loja;
- participa_vendas;
- Cargo;

devem invalidar adequadamente.

Impacto futuro:

**ALTO**

Funcionário desligado não pode continuar aparecendo por cache antigo.

---

# 109. Risco — PDV Offline com Funcionário Desatualizado

No futuro PDV offline, Funcionários/vendedores poderão estar em base local.

Risco:

um Funcionário desligado no servidor continuar sendo utilizado offline indefinidamente.

Impacto futuro:

**ALTO**

Será necessário definir:

- sincronização;
- versão;
- atualização de situação;
- política de contingência.

---

# 110. Risco — Regras Temporais sem Data de Vigência

Comissão avançada, metas e abrangências futuras podem exigir vigência.

Impacto futuro:

**ALTO**

Não representar política temporal apenas sobrescrevendo valor corrente.

---

# 111. Risco — Auditoria sem Empresa

Todo evento tenant-operacional deve ser associado à Empresa correta quando aplicável.

Impacto:

**CRÍTICO**

Sem isso, a Auditoria Central perde isolamento e capacidade de consulta confiável.

---

# 112. Risco — Auditoria sem Usuário Responsável

Quando a ação possui usuário autenticado, ele deve ser identificado.

Impacto:

**ALTO**

Principalmente em:

- alteração de Cargo;
- salário;
- comissão;
- lifecycle;
- exclusão.

---

# 113. Risco — Exclusão Negada sem Auditoria

Tentativa de apagar Funcionário utilizado é evento relevante.

Impacto:

**MÉDIO/ALTO**

Preservar:

`EMPLOYEE_DELETE_DENIED`

---

# 114. Risco — Perda do Vínculo com Vendas Antigas

Não modificar relações de forma que vendas históricas percam o vendedor.

Impacto:

**CRÍTICO**

Desligamento não deve remover relações antigas.

---

# 115. Risco — Exclusão em Cascata de Histórico sem Avaliar Regra

`FuncionarioHistorico` possui relação com Funcionário.

Ao alterar regras de exclusão ou `on_delete`, avaliar cuidadosamente:

- funcionário sem uso;
- funcionário utilizado;
- preservação necessária.

Impacto:

**ALTO**

Não mudar comportamento de cascata isoladamente.

---

# 116. Risco — Excesso de Campos na Listagem

Funcionários possui dados operacionais e sensíveis.

A tabela principal deve continuar enxuta.

Impacto:

**MÉDIO**

Não transformar listagem em exposição massiva de:

- salário;
- endereço;
- observações;
- dados pessoais desnecessários.

---

# 117. Risco — Consulta Virar Edição

Modo Consultar deve permanecer somente leitura.

Impacto:

**MÉDIO**

Usuário não deve modificar dados acidentalmente numa operação de consulta.

---

# 118. Risco — Ação Disponível em Estado Incorreto

Exemplos:

- Retornar em Funcionário ATIVO;
- Recontratar em Funcionário ATIVO;
- Afastar Funcionário DESLIGADO sem regra;
- Desligar novamente.

Impacto:

**MÉDIO/ALTO**

Frontend deve orientar.

Backend deve bloquear transições inválidas.

---

# 119. Risco — Dependência Excessiva dos Defaults de Cargo

As características dos Cargos básicos são configurações iniciais.

Não assumir que toda Empresa manterá exatamente os mesmos defaults.

Impacto:

**MÉDIO/ALTO**

Novas funcionalidades devem observar os campos estruturados atuais do Cargo.

---

# 120. Risco — Customização de Cargo Quebrar Código Baseado em Código Fixo

Se uma Empresa customizar um Cargo, funcionalidades que verificam apenas códigos básicos podem se tornar incorretas.

Impacto:

**ALTO**

Sempre perguntar:

> esta regra depende realmente do Cargo específico ou de uma característica operacional?

Preferir características quando adequado.

---

# 121. Risco — Falta de Documentação em Mudanças de Domínio

Funcionários possui diversas decisões arquiteturais importantes.

Impacto:

**MÉDIO/ALTO**

Alterações relevantes devem atualizar:

- Mapa Técnico;
- Modelo de Domínio;
- Workflows;
- Riscos e Cuidados;
- Homologação quando aplicável;
- Sysvar.md.

---

# 122. Risco — Implementação sem Consultar Homologação

A homologação registra comportamento efetivamente aprovado.

Impacto:

**ALTO**

Código futuro não deve ser alterado apenas com base na aparência atual da tela.

Consultar:

`Homologação - Cadastros - Funcionários.md`

---

# 123. Risco — Regressão dos Pontos Corrigidos Durante Homologação

Três problemas já foram encontrados e corrigidos.

## Cargos livres

Não voltar a aparência ou comportamento de lista restrita.

## Comissão

Não remover comissão de Gerente e Supervisor.

## Vínculo com Usuário

Não retirar o campo do frontend ou quebrar a relação.

Impacto:

**ALTO**

---

# 124. Risco — Divergência entre Backend e Frontend de Usuário Vinculado

O backend possui a autoridade OneToOne.

O frontend atualmente ajuda filtrando opções.

Risco:

frontend acreditar que sua lista é suficiente para garantir unicidade.

Impacto:

**MÉDIO/ALTO**

Constraint e validação backend devem permanecer.

---

# 125. Risco — Limite Fixo de Usuários no Combo

A implementação atual pode carregar quantidade limitada de Usuários para o combo.

Em empresas muito grandes, isso pode se tornar insuficiente.

Impacto atual:

**BAIXO/MÉDIO**

Impacto futuro:

**MÉDIO**

Evolução possível:

- autocomplete server-side;
- busca paginada;
- seleção remota.

Não é impeditivo da Fase 1 homologada.

---

# 126. Risco — Dados de Cargo e Funcionário Fora de Sincronia

Cargo contém defaults/características e Funcionário possui flags próprias.

Impacto:

**MÉDIO/ALTO**

Ao alterar Cargo de um Funcionário, revisar coerência de:

- participa_vendas;
- comissionado;
- comissão;
- Loja;
- abrangência.

Não deixar combinações incompatíveis.

---

# 127. Risco — Alterar Cargo e Preservar Comissão Inválida

Exemplo:

~~~text
Cargo antigo permite comissão
Funcionário comissionado = true

Novo Cargo não permite comissão
~~~

Impacto:

**ALTO**

A operação precisa regularizar ou recusar o estado.

---

# 128. Risco — Alterar Cargo e Preservar Participação em Vendas Incoerente

Mudanças de Cargo podem exigir revisão de `participa_vendas`.

Impacto:

**MÉDIO/ALTO**

A regra precisa permanecer explícita e consistente com o modelo atual.

---

# 129. Risco — Regra de Loja Baseada em Texto do Cargo

Não implementar:

~~~text
if cargo.descricao in ["Vendedor", "Caixa", "Gerente"]:
    exigir_loja()
~~~

Impacto:

**ALTO**

Utilizar a propriedade estruturada correspondente.

---

# 130. Risco — Auditoria Duplicada

Não registrar o mesmo evento várias vezes por:

- signal;
- serializer;
- view;
- service;

sem necessidade.

Impacto:

**MÉDIO**

Audit Central deve preservar rastreabilidade sem ruído artificial.

---

# 131. Risco — Falha Parcial em Operação de Lifecycle

Exemplo:

~~~text
situacao alterada
mas histórico não criado
~~~

Impacto:

**ALTO**

Operações compostas devem utilizar transação quando necessário.

---

# 132. Risco — Falha Parcial em Mudança Multi-Loja

Exemplo:

~~~text
Cargo atualizado
algumas lojas atualizadas
outras falharam
~~~

Impacto:

**ALTO**

Preservar atomicidade adequada.

---

# 133. Risco — Motivo/Observação Perdidos

Ações como afastamento e desligamento podem receber contexto.

Quando informado, esse contexto deve ser preservado conforme estrutura atual.

Impacto:

**MÉDIO**

Evitar guardar somente o estado final.

---

# 134. Risco — Implementar RH dentro de Observações

Campo de observações não deve ser usado como solução improvisada para ausência de módulo de RH.

Impacto:

**MÉDIO/ALTO**

Não armazenar estruturas importantes em texto livre para “resolver depois”.

---

# 135. Risco — Confundir Data de Cadastro com Data de Admissão

São conceitos distintos.

`data_cadastro`:

quando o registro entrou no sistema.

`inicio`:

data operacional de admissão/início.

Impacto:

**MÉDIO**

Relatórios não devem intercambiar os dois campos.

---

# 136. Risco — Confundir Data de Atualização com Histórico

`data_atualizacao` mostra última alteração.

Não substitui trajetória.

Impacto:

**MÉDIO**

Para sequência de eventos, utilizar Histórico/Auditoria.

---

# 137. Risco — Relatórios sem Filtro de Situação Adequado

Relatórios atuais e futuros devem decidir explicitamente se desejam:

- somente ativos;
- todos;
- situação na data;
- histórico.

Impacto:

**ALTO**

Não aplicar `ATIVO` universalmente sem entender finalidade histórica.

---

# 138. Risco — Relatórios Históricos Usarem Estado Atual

Exemplo:

Venda ocorreu quando Funcionário era Vendedor.

Hoje ele é Gerente.

Um relatório histórico não deve necessariamente reclassificar aquela venda como venda de Gerente.

Impacto futuro:

**ALTO**

Algumas análises poderão exigir snapshot/contexto temporal.

---

# 139. Risco — Consultas Históricas Usarem Loja Atual

Mesmo problema.

Funcionário vendeu na Loja A e depois foi transferido para Loja B.

Impacto:

**ALTO**

Venda histórica deve utilizar a Loja da própria operação, não simplesmente `funcionario.idloja` atual.

---

# 140. Risco — Consultas Históricas Usarem Cargo Atual

Cargo atual não deve ser tratado automaticamente como Cargo histórico da operação.

Impacto:

**ALTO**

Quando a análise exigir Cargo no momento da operação, será necessário contexto temporal adequado.

---

# 141. Risco — Crescimento sem Separação de Domínios

Funcionários está no centro de várias áreas.

Risco:

todo módulo novo começar a adicionar campos diretamente em `Funcionarios`.

Impacto:

**ALTO**

Antes de adicionar campo, perguntar:

> esse dado pertence realmente à identidade operacional do Funcionário?

Se não, criar domínio próprio.

---

# 142. Checklist Antes de Alterar Funcionários

Antes de qualquer alteração relevante, verificar:

1. afeta isolamento multiempresa?
2. afeta CPF?
3. afeta matrícula?
4. afeta Cargo?
5. afeta Loja Principal?
6. afeta abrangência multi-loja?
7. afeta comissão?
8. afeta Usuário vinculado?
9. afeta lifecycle?
10. afeta histórico?
11. afeta salário?
12. afeta VendaPdv?
13. afeta Auditoria Central?
14. afeta campos legados?
15. exige migration?
16. exige ajuste frontend?
17. exige teste cross-tenant?
18. exige atualização documental?

---

# 143. Checklist para Nova Relação com Funcionário

Quando outro módulo passar a referenciar Funcionário:

1. definir `on_delete`;
2. definir se impede exclusão;
3. validar mesma Empresa;
4. definir se aceita AFASTADO;
5. definir se aceita DESLIGADO;
6. determinar necessidade de snapshot histórico;
7. avaliar Auditoria;
8. criar testes;
9. documentar integração.

---

# 144. Checklist para Nova Regra de Comissão

Antes de adicionar:

1. é realmente comissão básica?
2. possui período?
3. depende de Loja?
4. depende de meta?
5. depende de produto?
6. depende de campanha?
7. depende de Cargo?
8. precisa preservar regra histórica?

Se possuir temporalidade ou regra avançada:

> não pertence ao cadastro básico de Funcionários.

---

# 145. Checklist para Nova Informação de RH

Antes de adicionar:

1. é necessária para operação do ERP?
2. possui caráter trabalhista?
3. possui sensibilidade elevada?
4. exige controle de acesso específico?
5. exige histórico próprio?
6. pertence a folha, férias, benefícios ou ponto?

Caso positivo:

avaliar módulo de RH/DP em vez de ampliar Funcionários.

---

# 146. Prioridades de Proteção

As maiores prioridades permanentes são:

~~~text
1. Isolamento multiempresa
2. Identidade CPF/matrícula
3. Separação Cargo × Permissão
4. Preservação histórica
5. Exclusão protegida
6. Segurança do salário
7. Integridade da Loja/abrangência
8. Vínculo seguro com Usuário
9. Coerência de comissão
10. Compatibilidade com Vendas
~~~

---

# 147. Pontos Conhecidos para Evolução Futura

Não são falhas impeditivas da Fase 1, mas precisam ser lembrados.

## Comissão histórica

Criar snapshot/regra de apuração adequada.

## Planejamento de Vendas

Criar domínio de metas e campanhas.

## Combo de Usuários

Avaliar busca remota/paginada se o volume crescer.

## Campos legados

Planejar retirada somente após eliminação completa de dependências.

## PDV Offline

Definir sincronização de Funcionários e situações operacionais.

## RH/DP

Somente desenvolver se houver necessidade clara do produto.

---

# 148. Homologação

A Fase 1 foi homologada manualmente em:

~~~text
17/17 itens aprovados
~~~

A homologação validou:

- interface;
- paginação;
- filtros;
- Cargos;
- Funcionário administrativo;
- CPF;
- matrícula;
- lifecycle;
- Loja Principal;
- multi-loja;
- comissão;
- Usuário vinculado;
- histórico;
- exclusão;
- salário;
- dados complementares;
- regressão geral.

---

# 149. Correções que Devem Ser Preservadas

Durante a homologação foram corrigidos:

## Cargos livres

Backend e frontend devem continuar aceitando Cargos definidos pela Empresa.

## Gerente e Supervisor com Comissão

~~~text
GERENTE.permite_comissao = true
SUPERVISOR.permite_comissao = true
~~~

## Vínculo Funcionário × Usuário

O campo deve permanecer disponível na interface e protegido no backend.

---

# 150. Estado Final

Status:

~~~text
IMPLEMENTADO
TESTADO
HOMOLOGADO MANUALMENTE
APROVADO
~~~

Os riscos documentados não representam falhas impeditivas atuais.

Eles representam regras e pontos de atenção que precisam ser preservados nas próximas evoluções do Sysvar.

---

# 151. Regra de Ouro

Antes de qualquer alteração em Funcionários, preservar:

~~~text
Funcionário é identidade operacional.

Cargo é função operacional.

Usuário é identidade de acesso.

Perfil define permissão.

Loja Principal define contexto operacional.

Abrangência define responsabilidade operacional.

Situação define disponibilidade operacional.

Histórico preserva trajetória.

Auditoria preserva rastreabilidade.

Comissão básica não é motor completo de comissão.
~~~

---

# 152. Documentos Relacionados

Mapa Técnico:

`[[10 Projetos/Sysvar/Contexto do Projeto/Mapa Técnico - Cadastros - Funcionários|Mapa Técnico - Cadastros - Funcionários]]`

Modelo de Domínio:

`[[10 Projetos/Sysvar/Contexto do Projeto/Modelo de Domínio - Cadastros - Funcionários|Modelo de Domínio - Cadastros - Funcionários]]`

Workflows:

`[[10 Projetos/Sysvar/Contexto do Projeto/Workflows - Cadastros - Funcionários|Workflows - Cadastros - Funcionários]]`

Homologação:

`[[10 Projetos/Sysvar/Homologações/Homologação - Cadastros - Funcionários|Homologação - Cadastros - Funcionários]]`

Projeto:

`[[10 Projetos/Sysvar/Sysvar|Sysvar]]`