---
type: domain-model
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
  - domínio
  - multiempresa
  - comissão
  - usuários
  - lojas
  - auditoria
  - homologado
---

# Modelo de Domínio - Cadastros - Funcionários

## 1. Identificação

- **Projeto:** Sysvar
- **Módulo:** Cadastros
- **Funcionalidade:** Funcionários
- **Escopo:** Fase 1 — Gestão Operacional
- **Situação:** IMPLEMENTADO E HOMOLOGADO
- **Homologação manual:** 17/17 itens aprovados
- **Data da homologação:** 12/08/2026

---

# 2. Objetivo do Modelo de Domínio

O domínio de Funcionários representa as pessoas que participam operacionalmente das atividades das empresas atendidas pelo Sysvar.

Seu objetivo é permitir que outros módulos identifiquem corretamente:

- quem é o funcionário;
- a qual empresa pertence;
- qual Cargo exerce;
- qual sua matrícula;
- qual sua situação operacional;
- qual sua Loja Principal;
- quais lojas estão sob sua responsabilidade;
- se participa de vendas;
- se pode receber comissão;
- qual sua comissão básica;
- se possui Usuário vinculado;
- quais alterações ocorreram em sua trajetória operacional.

O domínio não representa, nesta fase, um sistema de Recursos Humanos ou Departamento Pessoal.

---

# 3. Agregado Principal

A entidade central do domínio é:

`Funcionarios`

Relacionamentos principais:

~~~text
Empresa
  ↓
Funcionarios
  ├── Cargo
  ├── Loja Principal
  ├── Lojas Supervisionadas
  ├── Usuario
  ├── FuncionarioHistorico
  ├── VendaPdv
  └── AuditLog
~~~

O Funcionário é a raiz do agregado operacional.

---

# 4. Separações Fundamentais

O domínio depende da separação de conceitos que não podem ser confundidos:

~~~text
Funcionário != Usuário
Cargo != Perfil de Acesso
Cargo != Permissão
Loja supervisionada != Loja permitida do Usuário
Situação do Funcionário != Status de login
Comissão básica != Motor completo de comissão
Histórico operacional != Auditoria técnica
~~~

Essas separações são princípios permanentes da arquitetura.

---

# 5. Empresa

Todo Funcionário pertence a uma Empresa.

Relacionamento:

`Empresa 1:N Funcionarios`

Regra:

> Um Funcionário operacional nunca deve existir fora do contexto de uma Empresa.

Consequências:

- matrícula é controlada por Empresa;
- CPF é único por Empresa;
- Cargo deve pertencer à mesma Empresa;
- Loja Principal deve pertencer à mesma Empresa;
- lojas supervisionadas devem pertencer à mesma Empresa;
- Usuário vinculado deve pertencer à mesma Empresa;
- histórico deve respeitar a mesma Empresa;
- consultas devem respeitar o tenant.

---

# 6. Isolamento Multiempresa

A identidade operacional do Funcionário sempre deve ser interpretada dentro de sua Empresa.

Não existe Funcionário global compartilhado entre tenants.

Exemplo:

~~~text
Empresa A
CPF: 52998224725
Matrícula: 000001

Empresa B
CPF: 52998224725
Matrícula: 000001
~~~

Esse cenário é permitido.

Dentro da mesma Empresa, CPF ou matrícula duplicados não são permitidos.

---

# 7. Funcionário

Entidade:

`Funcionarios`

Representa uma pessoa que exerce uma função operacional dentro da empresa.

Pode representar, entre outros:

- Vendedor;
- Caixa;
- Gerente;
- Supervisor;
- Comprador;
- Assistente Financeiro;
- Auxiliar Administrativo;
- Estoquista;
- Almoxarife;
- Conferente;
- Recebedor;
- Costureira;
- Auxiliar de Produção.

O modelo não é restrito a funcionários de loja.

---

# 8. Identificação do Funcionário

A identificação principal utiliza:

- Empresa;
- matrícula;
- nome;
- CPF.

A combinação de regras garante identificação operacional e isolamento de tenant.

---

# 9. Matrícula

Atributo:

`matricula`

Regra:

> Todo novo Funcionário deve possuir matrícula única dentro de sua Empresa.

A matrícula:

- é obrigatória;
- pode ser automática;
- pode ser manual;
- deve ser única por Empresa;
- permanece estável;
- não é reutilizada;
- não muda em afastamento;
- não muda em desligamento;
- não muda em recontratação.

---

# 10. Matrícula Automática

Quando o usuário não informa matrícula, o sistema pode gerar uma sequência automática.

Exemplo:

~~~text
000001
000002
000003
~~~

A sequência pertence à Empresa.

Não existe sequência global obrigatória entre todos os tenants.

---

# 11. Matrícula Manual

O usuário pode informar uma matrícula manual.

Exemplo:

~~~text
FUNC-001
~~~

desde que respeite as regras aceitas pela implementação e não exista outro Funcionário com a mesma matrícula na Empresa.

---

# 12. Imutabilidade Conceitual da Matrícula

A matrícula representa a identidade interna histórica do Funcionário.

Por isso, a regra de domínio é:

> não criar uma nova matrícula simplesmente porque o Funcionário foi afastado, desligado ou recontratado.

A trajetória pertence ao mesmo Funcionário.

---

# 13. CPF

Atributo:

`cpf`

CPF é obrigatório para Funcionários na Fase 1.

Regra:

> Um novo Funcionário operacional deve possuir CPF válido.

O CPF é normalizado pelo backend.

A máscara visual não faz parte do valor persistido.

---

# 14. Unicidade do CPF

A regra é:

~~~text
Empresa + CPF
~~~

Consequências:

- CPF duplicado na mesma Empresa: recusado;
- mesmo CPF em outra Empresa: permitido.

Não existe unicidade global entre empresas do SaaS.

---

# 15. CPF Legado

A migração da Fase 1 preserva registros antigos quando não existe informação segura para corrigi-los.

Não deve ser criado CPF artificial para registros legados.

Regra:

> preservar um dado legado incompleto é preferível a inventar uma identidade fiscal.

Novos cadastros seguem a regra atual de obrigatoriedade.

---

# 16. Nome

Atributo principal:

`nomefuncionario`

Representa o nome utilizado para identificação do Funcionário.

Nome não é chave única.

Duas pessoas podem possuir o mesmo nome.

---

# 17. Apelido

Atributo:

`apelido`

É opcional.

Serve como identificação operacional ou nome usual.

Não participa de regra de unicidade.

---

# 18. Cargo

Entidade relacionada:

`Cargo`

Relacionamento:

`Cargo 1:N Funcionarios`

Todo Funcionário deve possuir um Cargo funcionalmente válido na operação nova.

Cargo representa a função exercida.

---

# 19. Cargo é Cadastro Aberto

Cargo não é enumeração fixa.

A Empresa pode criar Cargos próprios.

Exemplos:

~~~text
Analista Financeiro
Analista de Operações
Coordenador de Estoque
Modelista
Encarregado de Produção
~~~

Nenhuma alteração de código deve ser necessária para criar essas funções.

---

# 20. Cargo e Empresa

Todo Cargo pertence a uma Empresa.

Regra:

~~~text
funcionario.empresa == cargo.empresa
~~~

Cargo de outro tenant não pode ser atribuído.

---

# 21. Código do Cargo

Cada Cargo possui código.

Regra de unicidade:

~~~text
Empresa + Código do Cargo
~~~

O mesmo código pode existir em empresas diferentes.

---

# 22. Cargo Não é Perfil

Cargo responde:

> Qual função operacional essa pessoa exerce?

Perfil responde:

> O que esse Usuário pode acessar e executar no sistema?

Não existe equivalência automática entre os dois.

---

# 23. Cargo Não Concede Permissão

Exemplo:

~~~text
Cargo: Assistente Financeiro
~~~

não significa automaticamente:

~~~text
Financeiro = EDIT
~~~

O acesso continua controlado por:

- Usuário;
- Perfil;
- Permissões;
- Overrides;
- módulos contratados;
- demais regras da infraestrutura de segurança.

---

# 24. Características do Cargo

Cargo possui características operacionais.

Entre elas:

- ativo;
- participa de vendas;
- permite comissão;
- autoridade operacional de loja;
- permite múltiplas lojas;
- gerencial.

Essas características ajudam o domínio a validar Funcionários.

---

# 25. Cargo Ativo

Cargo ativo pode ser utilizado em novas atribuições.

Cargo inativo deve permanecer disponível para preservar relações históricas existentes, mas não deve ser oferecido normalmente para novos Funcionários ou novas atribuições.

---

# 26. Cargos Básicos

O Sysvar cria um conjunto inicial de Cargos.

Entre eles:

- Vendedor;
- Caixa;
- Gerente;
- Supervisor;
- Assistente;
- Auxiliar;
- Auxiliar Administrativo;
- Assistente Administrativo;
- Assistente Financeiro;
- Auxiliar Financeiro;
- Comprador;
- Estoquista;
- Almoxarife;
- Conferente;
- Recebedor;
- Costureira;
- Auxiliar de Produção.

Eles são somente configuração inicial.

---

# 27. Configuração dos Cargos Básicos

Os defaults facilitam o início da operação.

A Empresa continua livre para:

- criar;
- editar;
- configurar;
- inativar;

seus próprios Cargos dentro das regras permitidas.

---

# 28. Vendedor

Default funcional:

- participa de vendas: Sim;
- permite comissão: Sim;
- autoridade de loja: Sim;
- múltiplas lojas: Não;
- gerencial: Não.

---

# 29. Caixa

Default funcional:

- participa de vendas: Não;
- permite comissão: Não;
- autoridade de loja: Sim;
- múltiplas lojas: Não;
- gerencial: Não.

Isso representa configuração inicial, não definição universal e imutável de negócio.

---

# 30. Gerente

Default funcional:

- participa de vendas diretamente: Não;
- permite comissão: Sim;
- autoridade de loja: Sim;
- múltiplas lojas: Não;
- gerencial: Sim.

A possibilidade de comissão foi validada durante a homologação.

---

# 31. Supervisor

Default funcional:

- participa de vendas diretamente: Não;
- permite comissão: Sim;
- autoridade de loja: Sim;
- múltiplas lojas: Sim;
- gerencial: Sim.

Supervisor é o principal exemplo atual de Cargo com abrangência operacional multi-loja.

---

# 32. Categoria Legada

O modelo antigo possuía:

`categoria`

como texto.

A Fase 1 introduziu:

`cargo`

como referência estruturada.

Regra de evolução:

> novos recursos devem utilizar Cargo como fonte funcional.

`categoria` permanece somente por compatibilidade enquanto necessário.

---

# 33. Situação Operacional

Atributo:

`situacao`

Estados:

- ATIVO;
- AFASTADO;
- DESLIGADO.

A situação representa o ciclo operacional do Funcionário.

---

# 34. Funcionário Ativo

Estado:

`ATIVO`

Significa que o Funcionário está disponível para atividades compatíveis com:

- Cargo;
- Empresa;
- Loja;
- participação em vendas;
- demais regras da operação.

---

# 35. Funcionário Afastado

Estado:

`AFASTADO`

O Funcionário:

- continua cadastrado;
- mantém CPF;
- mantém matrícula;
- mantém Cargo e histórico;
- não deve participar normalmente de novas operações.

O afastamento não apaga dados.

---

# 36. Funcionário Desligado

Estado:

`DESLIGADO`

O Funcionário:

- permanece cadastrado;
- preserva histórico;
- preserva operações antigas;
- preserva matrícula;
- preserva CPF;
- não deve participar de novas operações normais.

---

# 37. Retorno

Transição:

~~~text
AFASTADO → ATIVO
~~~

O retorno reutiliza o mesmo agregado.

Não cria novo Funcionário.

---

# 38. Recontratação

Transição:

~~~text
DESLIGADO → ATIVO
~~~

A recontratação:

- reutiliza o mesmo Funcionário;
- mantém matrícula;
- mantém CPF;
- preserva histórico anterior.

---

# 39. Ciclo de Vida Completo

Fluxo permitido pela Fase 1:

~~~text
ATIVO
  ↓
AFASTADO
  ↓
ATIVO
  ↓
DESLIGADO
  ↓
ATIVO
~~~

Cada transição relevante deve ser rastreável.

---

# 40. Campo Ativo Legado

O modelo possuía anteriormente:

`ativo`

A Fase 1 introduziu situação estruturada.

Não criar nova regra de negócio que produza dois ciclos de vida independentes.

A direção funcional é utilizar:

`situacao`

como referência operacional principal.

---

# 41. Data de Admissão

Campo:

`inicio`

Representa funcionalmente a data de admissão/início operacional.

É obrigatória na definição da Fase 1 para novos Funcionários.

---

# 42. Data de Desligamento

Campo:

`fim`

Pode representar a data de desligamento.

Ao recontratar, o histórico anterior deve permanecer preservado mesmo que o estado corrente volte a ATIVO.

O histórico não deve depender apenas desse campo.

---

# 43. Loja Principal

Relacionamento existente:

`idloja`

Functionalmente:

**Loja Principal**

Relacionamento:

`Loja 1:N Funcionarios`

Apesar do nome técnico legado, o conceito atual é Loja Principal do Funcionário.

---

# 44. Regra da Loja Principal

A Loja deve pertencer à mesma Empresa.

~~~text
funcionario.empresa == loja.empresa
~~~

IDs enviados pelo frontend devem ser revalidados no backend.

---

# 45. Cargo e Necessidade de Loja

Cargo pode indicar:

`autoridade_operacional_loja`

Na Fase 1, essa característica determina a necessidade de Loja Principal para a função.

Exemplos típicos:

- Vendedor;
- Caixa;
- Gerente;
- Estoquista;
- Almoxarife.

---

# 46. Funcionário sem Loja Principal

Cargos administrativos podem não exigir Loja Principal.

Exemplos iniciais:

- Assistente Administrativo;
- Assistente Financeiro;
- Auxiliar Financeiro;
- Comprador.

Isso permite funcionários corporativos ou de escritório.

---

# 47. Abrangência Operacional

Funcionário pode possuir responsabilidade operacional sobre mais de uma Loja quando seu Cargo permitir.

Estruturas:

- `lojas_supervisionadas`;
- `todas_lojas_da_empresa`.

---

# 48. Lojas Supervisionadas

Relacionamento:

`Funcionarios N:N Loja`

através de:

`lojas_supervisionadas`

Representa responsabilidade operacional.

Não representa automaticamente permissão de acesso.

---

# 49. Todas as Lojas da Empresa

Atributo:

`todas_lojas_da_empresa`

Quando verdadeiro, indica que o Funcionário possui abrangência operacional sobre todas as lojas do tenant.

Exemplo típico:

Supervisor regional ou geral.

---

# 50. Regra de Múltiplas Lojas

Somente Cargo configurado com:

`permite_multiplas_lojas = true`

pode manter abrangência multi-loja.

Caso contrário, a relação deve ser rejeitada ou regularizada.

---

# 51. Mudança de Cargo

Ao trocar um Funcionário de Cargo multi-loja para Cargo comum, não pode permanecer uma abrangência incompatível.

Regra:

> os relacionamentos dependentes precisam continuar coerentes com o novo Cargo.

---

# 52. Abrangência Operacional Não é Acesso

As estruturas:

`Funcionarios.lojas_supervisionadas`

e:

`User.lojas`

possuem significados diferentes.

A primeira representa responsabilidade operacional.

A segunda representa acesso permitido no sistema.

Uma não deve copiar ou substituir automaticamente a outra.

---

# 53. Participação em Vendas

Atributo:

`participa_vendas`

Indica se o Funcionário pode participar diretamente de operações comerciais.

É diferente de possuir acesso ao módulo Vendas.

---

# 54. Participação em Vendas × Permissão

Um Funcionário pode:

~~~text
participa_vendas = true
~~~

mas seu Usuário pode não possuir acesso ao PDV.

Da mesma forma, um Usuário pode operar o PDV sem ser o vendedor comercial da operação, dependendo do processo.

---

# 55. Comissionado

Atributo:

`comissionado`

Indica se o Funcionário utiliza comissão básica.

A configuração deve ser compatível com:

`cargo.permite_comissao`

---

# 56. Permite Comissão

Atributo do Cargo:

`permite_comissao`

Significa:

> funcionários deste Cargo podem ser configurados como comissionados.

Não significa:

> todos recebem comissão automaticamente.

---

# 57. Percentual de Comissão

Atributo:

`comissao_percentual`

É individual do Funcionário.

Exemplo:

~~~text
Vendedor A: 2,00%
Vendedor B: 2,50%
~~~

O Cargo não define o percentual individual.

---

# 58. Comissão Básica

A comissão da Fase 1 é uma informação operacional simples.

Não é um motor completo de remuneração variável.

O cadastro deve apenas fornecer a configuração básica necessária às operações atuais.

---

# 59. Comissão de Gerente

Gerente pode ser:

`comissionado = true`

A regra futura pode utilizar:

- vendas da Loja;
- faturamento;
- atingimento de meta;
- margem;
- resultado.

Essas regras não pertencem ao agregado Funcionário da Fase 1.

---

# 60. Comissão de Supervisor

Supervisor também pode ser comissionado.

A regra futura poderá considerar:

- lojas supervisionadas;
- todas as lojas;
- metas regionais;
- resultado agregado.

A abrangência atual fornece informação estrutural para esse desenvolvimento futuro.

---

# 61. Meta Legada

Campo existente:

`meta`

Não faz mais parte do domínio funcional de Funcionários.

Não utilizar `meta` em novos recursos dessa funcionalidade.

Metas pertencem a domínio futuro de:

**Planejamento/Ação de Vendas**

---

# 62. Planejamento/Ação de Vendas

Futuro domínio responsável por:

- metas;
- campanhas;
- bônus;
- faixas;
- políticas de comissão;
- metas por funcionário;
- metas por loja;
- metas regionais;
- regras de Gerente;
- regras de Supervisor.

Funcionários fornece identidade e contexto, não executa essas regras.

---

# 63. Usuário

Entidade relacionada:

`accounts.User`

Relacionamento:

~~~text
Funcionarios 0..1 : 0..1 User
~~~

O vínculo é opcional.

---

# 64. Funcionário sem Usuário

Cenário válido:

~~~text
Funcionário: Estoquista
Usuário vinculado: Nenhum
~~~

A pessoa pode participar da operação sem acessar diretamente o Sysvar.

---

# 65. Funcionário com Usuário

Quando a função exige acesso ao sistema, pode ser realizado vínculo com um Usuário existente.

Regra:

~~~text
funcionario.empresa == usuario.empresa
~~~

---

# 66. Cardinalidade do Vínculo

Um Usuário só pode estar vinculado a um Funcionário.

Um Funcionário só pode possuir um Usuário vinculado.

A relação atual é OneToOne.

---

# 67. Vínculo não Cria Permissões

Ao vincular um Usuário:

não alterar automaticamente:

- Perfil;
- módulos;
- permissões;
- overrides;
- tipo;
- Loja permitida;
- sessões;
- contrato.

---

# 68. Desvínculo

O vínculo pode ser removido.

Resultado:

~~~text
funcionario.usuario = null
~~~

Isso não exclui o Usuário.

Também não exclui o Funcionário.

---

# 69. Situação do Funcionário e Usuário

Afastar ou desligar Funcionário não desativa automaticamente:

`User.is_active`

Essa independência foi preservada na Fase 1.

Caso exista no futuro uma política automática, ela deve ser uma regra explícita e documentada.

---

# 70. Salário

Atributo:

`salario`

Permanece no modelo por necessidade cadastral/compatibilidade.

Não transforma o módulo em RH.

---

# 71. Salário como Informação Sensível

Visualização e alteração do salário exigem proteção específica.

Permissão:

`funcionario.salario`

Regra:

> acesso normal ao cadastro de Funcionários não implica automaticamente acesso ao salário.

---

# 72. RH e Departamento Pessoal

A Fase 1 não implementa:

- folha de pagamento;
- férias;
- ponto;
- benefícios;
- encargos;
- PIS;
- CTPS;
- dependentes;
- INSS;
- FGTS;
- rescisão trabalhista;
- cálculo de horas;
- banco de horas.

Esses elementos não devem ser adicionados incidentalmente ao domínio atual.

---

# 73. Dados Complementares

Funcionário pode possuir:

- telefone;
- WhatsApp;
- e-mail;
- data de nascimento;
- endereço;
- observações.

São dados cadastrais opcionais.

---

# 74. Telefone

Telefone é informação opcional.

Persistência deve utilizar forma normalizada conforme infraestrutura de validação do projeto.

Máscara pertence à apresentação.

---

# 75. WhatsApp

WhatsApp é independente de telefone.

Pode possuir:

- mesmo número;
- número diferente;
- valor vazio.

Não é obrigatório.

---

# 76. E-mail

E-mail é opcional.

Quando informado, deve respeitar validação de formato.

Não é utilizado como identificador único do Funcionário.

---

# 77. Data de Nascimento

Campo opcional:

`data_nascimento`

Possui finalidade cadastral.

Não foi criado cálculo de idade ou regra trabalhista a partir dele.

---

# 78. Endereço

Campo simples:

`endereco`

Na Fase 1 não foi criado agregado complexo de múltiplos endereços de Funcionário.

Essa simplicidade é intencional.

---

# 79. Observações

Campo:

`observacoes`

Permite registrar informação cadastral operacional.

Não deve virar prontuário de RH ou armazenamento indiscriminado de dados sensíveis.

---

# 80. Histórico Operacional

Entidade:

`FuncionarioHistorico`

Relacionamento:

`Funcionarios 1:N FuncionarioHistorico`

Seu objetivo é registrar mudanças relevantes da trajetória operacional.

---

# 81. Tipos de Histórico

Eventos previstos incluem:

- CARGO;
- LOJA;
- ABRANGENCIA;
- AFASTAMENTO;
- RETORNO;
- DESLIGAMENTO;
- RECONTRATACAO.

---

# 82. Mudança de Cargo

Ao alterar Cargo, o histórico deve permitir identificar:

- Cargo anterior;
- Cargo novo;
- data/hora;
- responsável;
- observações quando aplicáveis.

---

# 83. Mudança de Loja

Ao alterar Loja Principal, o histórico deve preservar:

- Loja anterior;
- Loja nova;
- momento da alteração;
- responsável.

Isso evita depender somente do valor corrente.

---

# 84. Mudança de Abrangência

Alterações nas lojas sob responsabilidade de um Funcionário multi-loja devem gerar contexto histórico.

O objetivo é permitir compreender sua abrangência operacional ao longo do tempo.

---

# 85. Afastamento no Histórico

O evento de afastamento deve preservar:

- data/hora;
- situação anterior;
- nova situação;
- motivo quando informado;
- usuário responsável.

---

# 86. Retorno no Histórico

O retorno cria novo evento.

Não deve apagar o evento anterior de afastamento.

Histórico é acumulativo.

---

# 87. Desligamento no Histórico

O desligamento é evento histórico permanente.

Recontratação posterior não remove o desligamento anterior.

---

# 88. Recontratação no Histórico

A recontratação registra uma nova etapa da vida operacional do mesmo Funcionário.

Esse comportamento permite reconstruir a trajetória.

---

# 89. Histórico Não é RH

`FuncionarioHistorico` não representa:

- prontuário médico;
- advertências trabalhistas;
- documentos admissionais;
- folha;
- férias;
- benefícios.

Seu escopo é operacional.

---

# 90. Audit Central

Entidade:

`AuditLog`

Complementa o histórico funcional.

A Auditoria registra ações como:

- criação;
- edição;
- mudança de Cargo;
- mudança de Loja;
- alteração de abrangência;
- afastamento;
- retorno;
- desligamento;
- recontratação;
- comissão;
- vínculo de Usuário;
- desvínculo;
- exclusão;
- exclusão negada.

---

# 91. Histórico × Auditoria

Diferença:

## Histórico

Orientado ao Funcionário.

~~~text
O que aconteceu com este funcionário?
~~~

## Auditoria

Orientada à rastreabilidade.

~~~text
Quem executou?
Quando?
Em qual empresa?
Qual foi a ação?
Qual foi o resultado?
~~~

As duas estruturas devem coexistir.

---

# 92. Exclusão

Funcionário sem uso operacional pode ser excluído.

Funcionário com vínculos históricos ou operacionais deve ser preservado.

Regra:

> histórico operacional tem prioridade sobre conveniência de exclusão física.

---

# 93. Exclusão Protegida

Quando existirem dependências, a operação deve ser recusada.

Mensagem funcional:

~~~text
Funcionário já utilizado em operações. Desligue o funcionário em vez de excluí-lo.
~~~

---

# 94. Desligamento em vez de Exclusão

Para Funcionário já utilizado:

~~~text
Excluir
    ✗

Desligar
    ✓
~~~

Isso preserva:

- vendas;
- histórico;
- relatórios;
- auditoria;
- referências antigas.

---

# 95. VendaPdv

Entidade relacionada:

`fiscal.VendaPdv`

Relacionamento:

~~~text
VendaPdv.vendedor → Funcionarios
~~~

O vendedor comercial continua sendo Funcionário.

---

# 96. Operador da Venda

Venda também possui:

`criado_por`

relacionado ao Usuário.

Conceitos:

~~~text
vendedor = quem realizou a venda comercialmente
criado_por = quem operou o sistema
~~~

Podem representar pessoas diferentes.

---

# 97. Funcionário Disponível para Venda

Para nova operação comercial, o Funcionário deve respeitar as regras aplicáveis.

Conceitualmente:

- mesma Empresa;
- situação ATIVO;
- participa de vendas;
- Loja compatível.

Afastados e desligados não devem ser novos vendedores.

---

# 98. Comissão e Venda Histórica

A implementação atual ainda possui pontos em que relatórios podem consultar:

`funcionario.comissao_percentual`

Esse modelo não é suficiente para comissão histórica definitiva.

---

# 99. Snapshot Futuro de Comissão

Uma venda histórica deve futuramente preservar:

- política aplicada;
- percentual aplicado;
- base de cálculo;
- regra;
- campanha quando existir.

Assim, alterar o Funcionário no futuro não modifica a interpretação de uma venda passada.

---

# 100. Consulta de Funcionários

A consulta pode apresentar grupos como:

- Dados cadastrais;
- Comercial;
- Abrangência;
- Acesso;
- Histórico.

Cada grupo corresponde a conceitos existentes neste domínio.

---

# 101. Dados Cadastrais

Contêm:

- matrícula;
- nome;
- apelido;
- CPF;
- Cargo;
- Loja Principal;
- situação;
- admissão;
- desligamento;
- dados complementares.

---

# 102. Comercial

Contém:

- participa de vendas;
- comissionado;
- comissão percentual.

Não contém motor avançado de metas ou campanhas.

---

# 103. Abrangência

Quando aplicável:

- Loja Principal;
- lojas supervisionadas;
- todas as lojas da Empresa.

---

# 104. Acesso

Apresenta o vínculo opcional com:

`User`

Não exibe Cargo como Perfil e não mistura as responsabilidades.

---

# 105. Histórico

Apresenta a trajetória operacional registrada em:

`FuncionarioHistorico`

e pode ser complementado pela Auditoria Central conforme finalidade da consulta.

---

# 106. Busca

O domínio permite pesquisa por dados de identificação como:

- matrícula;
- nome;
- apelido;
- CPF.

A implementação utiliza busca server-side.

---

# 107. Filtros

Filtros funcionais incluem:

- Cargo;
- Loja;
- situação;
- participa de vendas;
- comissionado.

Filtros devem respeitar a Empresa corrente.

---

# 108. Paginação

Funcionários utiliza paginação server-side.

O domínio deve suportar grande quantidade de registros sem obrigar o frontend a carregar toda a Empresa para pesquisar.

---

# 109. Fonte da Verdade

Para regras críticas, a fonte da verdade é o backend.

O frontend pode:

- ocultar opções;
- filtrar combos;
- desabilitar botões;
- orientar o usuário.

Mas o backend deve novamente validar:

- Empresa;
- CPF;
- matrícula;
- Cargo;
- Loja;
- abrangência;
- Usuário;
- comissão;
- exclusão;
- transições.

---

# 110. Invariantes do Domínio

As seguintes regras devem permanecer verdadeiras:

~~~text
Funcionário pertence a exatamente uma Empresa operacional.

Matrícula é única dentro da Empresa.

CPF é único dentro da Empresa.

Cargo pertence à mesma Empresa.

Loja Principal pertence à mesma Empresa.

Lojas supervisionadas pertencem à mesma Empresa.

Usuário vinculado pertence à mesma Empresa.

Usuário não pode estar ligado a mais de um Funcionário.

Cargo sem múltiplas lojas não mantém abrangência multi-loja.

Cargo que não permite comissão não deve produzir Funcionário comissionado incoerente.

Afastado não deve participar de nova operação normal.

Desligado não deve participar de nova operação normal.

Recontratação preserva o mesmo Funcionário.

Funcionário utilizado não deve ser fisicamente excluído.
~~~

---

# 111. Fronteira com Accounts

O domínio `accounts` é responsável por:

- autenticação;
- Usuário;
- Perfil;
- permissões;
- sessões;
- tokens;
- acesso por módulo.

Funcionários apenas referencia opcionalmente um Usuário.

---

# 112. Fronteira com Vendas

O domínio de Vendas é responsável por:

- venda;
- autorização;
- descontos;
- cancelamentos;
- regras comerciais;
- documentos;
- pagamentos.

Funcionários fornece:

- vendedor;
- Cargo;
- Loja;
- situação;
- participação comercial;
- comissão básica.

---

# 113. Fronteira com Planejamento de Vendas

Planejamento/Ação de Vendas deverá possuir:

- metas;
- campanhas;
- políticas;
- regras de comissão;
- atingimento;
- premiações.

Funcionários apenas fornece as pessoas e sua estrutura operacional.

---

# 114. Fronteira com RH/DP

Caso RH/DP seja desenvolvido futuramente, deverá constituir domínio próprio.

Pode referenciar Funcionário, mas não deve transformar indiscriminadamente o agregado operacional atual.

---

# 115. Estrutura Conceitual Consolidada

~~~text
Empresa
│
├── Cargo
│     ├── participa_vendas
│     ├── permite_comissao
│     ├── autoridade_operacional_loja
│     ├── permite_multiplas_lojas
│     └── gerencial
│
├── Loja
│
└── Funcionarios
      ├── matricula
      ├── cpf
      ├── cargo
      ├── situacao
      ├── loja_principal
      ├── lojas_supervisionadas
      ├── todas_lojas
      ├── participa_vendas
      ├── comissionado
      ├── comissao_percentual
      ├── usuario
      ├── salario protegido
      └── dados complementares
             │
             └── FuncionarioHistorico

Funcionarios
      │
      ├── VendaPdv.vendedor
      │
      └── AuditLog

User
      │
      ├── Perfil
      ├── Permissões
      ├── Sessões
      └── Lojas de acesso
~~~

---

# 116. Dependências Conceituais

As dependências corretas são:

~~~text
Funcionário depende de Empresa.

Funcionário depende de Cargo.

Funcionário pode depender de Loja.

Funcionário pode depender de User.

Venda pode depender de Funcionário como vendedor.

Histórico depende de Funcionário.

Auditoria referencia eventos do Funcionário.
~~~

---

# 117. Dependências Proibidas

Evitar arquiteturas como:

~~~text
Cargo → concede permissão automaticamente

Cargo → determina Perfil

Funcionário afastado → desativa User sem regra explícita

Funcionário desligado → é excluído

Supervisor.lojas → sobrescreve User.lojas

comissao_percentual atual → reescreve comissão histórica

categoria textual → volta a substituir Cargo

meta → volta a ser regra de Funcionário
~~~

---

# 118. Compatibilidade Legada

A Fase 1 adotou evolução não destrutiva.

Campos antigos podem permanecer temporariamente enquanto integrações existentes forem migradas.

A existência física desses campos não significa que continuem sendo fonte funcional preferencial.

---

# 119. Campos Legados Relevantes

Entre os campos que exigem atenção:

- `categoria`;
- `meta`;
- `ativo`;
- `idloja`, cujo nome técnico antigo permanece, mas representa Loja Principal.

Não remover sem análise completa das integrações.

---

# 120. Princípio de Evolução Segura

Alterações futuras devem seguir:

1. identificar fonte funcional atual;
2. preservar tenant;
3. preservar histórico;
4. não quebrar vendas antigas;
5. não quebrar relatórios;
6. manter compatibilidade enquanto necessária;
7. migrar consumidores antes de remover campos legados.

---

# 121. Homologação

A Fase 1 foi homologada manualmente em:

**17/17 itens.**

Foram validados:

1. estrutura da tela;
2. paginação;
3. filtros;
4. Cargos livres;
5. Cargo administrativo;
6. CPF;
7. matrícula;
8. ciclo operacional;
9. Loja Principal;
10. Supervisor multi-loja;
11. comissão;
12. vínculo com Usuário;
13. histórico;
14. exclusão protegida;
15. salário protegido;
16. dados complementares;
17. fechamento geral.

---

# 122. Correções da Homologação

Durante a homologação, três pontos exigiram correção.

## Cargos

O sistema precisava deixar claro que Cargo é cadastro livre e não lista restrita a Vendedor, Caixa e Gerente.

## Comissão

Gerente e Supervisor passaram a permitir comissão.

## Usuário Vinculado

O vínculo já existente no backend foi disponibilizado no frontend.

---

# 123. Estado Atual

Status:

~~~text
IMPLEMENTADO
TESTADO
HOMOLOGADO MANUALMENTE
APROVADO
~~~

Nenhuma pendência identificada na homologação impede o uso operacional da Fase 1 de Funcionários.

---

# 124. Direção Futura

O domínio de Funcionários deve permanecer enxuto e operacional.

Sua função é responder:

~~~text
Quem é a pessoa?
Onde atua?
Qual sua função?
Qual sua situação?
Pode vender?
Pode receber comissão?
Quais lojas estão sob sua responsabilidade?
Possui acesso ao sistema?
Qual sua trajetória operacional?
~~~

Não deve tentar responder nesta fase:

~~~text
Quanto deve receber na folha?
Quantos dias de férias possui?
Quais benefícios recebe?
Qual sua jornada?
Qual é seu banco de horas?
Qual campanha comercial está vigente?
Quanto ganhou de bônus?
Qual regra completa de comissão foi aplicada?
~~~

Essas perguntas pertencem a outros domínios.

---

# 125. Documentos Relacionados

Mapa Técnico:

`[[10 Projetos/Sysvar/Contexto do Projeto/Mapa Técnico - Cadastros - Funcionários|Mapa Técnico - Cadastros - Funcionários]]`

Homologação:

`[[10 Projetos/Sysvar/Homologações/Homologação - Cadastros - Funcionários|Homologação - Cadastros - Funcionários]]`

Workflows:

`[[10 Projetos/Sysvar/Contexto do Projeto/Workflows - Cadastros - Funcionários|Workflows - Cadastros - Funcionários]]`

Riscos e Cuidados:

`[[10 Projetos/Sysvar/Contexto do Projeto/Riscos e Cuidados - Cadastros - Funcionários|Riscos e Cuidados - Cadastros - Funcionários]]`

Projeto:

`[[10 Projetos/Sysvar/Sysvar|Sysvar]]`