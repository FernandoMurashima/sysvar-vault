---
type: technical-map
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
  - multiempresa
  - usuários
  - comissão
  - auditoria
  - homologado
---

# Mapa Técnico - Cadastros - Funcionários

## 1. Identificação

- **Projeto:** Sysvar
- **Módulo:** Cadastros
- **Funcionalidade:** Funcionários
- **Escopo documentado:** Fase 1 — Gestão Operacional
- **Situação:** IMPLEMENTADO E HOMOLOGADO
- **Homologação manual:** 17/17 itens aprovados
- **Data da homologação:** 12/08/2026

---

# 2. Objetivo Técnico

O cadastro de Funcionários representa as pessoas que participam da operação das empresas atendidas pelo Sysvar.

A arquitetura da Fase 1 foi construída para separar claramente quatro conceitos:

1. Funcionário;
2. Cargo;
3. Usuário;
4. Perfil e Permissões.

Funcionário representa a pessoa dentro da estrutura operacional.

Cargo representa a função operacional exercida.

Usuário representa a identidade utilizada para acessar o Sysvar.

Perfil e Permissões determinam o que o Usuário pode fazer dentro do sistema.

A arquitetura deve preservar obrigatoriamente:

- isolamento multiempresa;
- integridade histórica;
- separação Funcionário × Usuário;
- separação Cargo × Perfil;
- rastreabilidade;
- compatibilidade com vendas existentes;
- suporte a funcionários administrativos e operacionais;
- suporte a cargos configuráveis;
- suporte a funcionários comissionados;
- suporte a Supervisor multi-loja;
- proteção de exclusão de funcionários já utilizados;
- proteção de campos sensíveis;
- evolução futura sem transformar Funcionários em módulo de RH/DP.

---

# 3. Backend

## 3.1. Aplicação principal

A funcionalidade está concentrada principalmente no app Django:

`cadastros`

Arquivos centrais:

- `cadastros/models.py`
- `cadastros/serializers.py`
- `cadastros/views.py`
- `cadastros/urls.py`
- `cadastros/services.py`
- `cadastros/signals.py`
- `cadastros/tests.py`

Integrações relevantes:

- `accounts`
- `auditoria`
- `fiscal`
- `dashboard`

---

# 4. Models Principais

A Fase 1 utiliza três estruturas centrais:

- `Cargo`
- `Funcionarios`
- `FuncionarioHistorico`

Cada uma possui responsabilidade própria.

---

# 5. Model Cargo

Model:

`cadastros.models.Cargo`

Cargo representa uma função operacional existente dentro de uma empresa.

Exemplos:

- Vendedor;
- Caixa;
- Gerente;
- Supervisor;
- Assistente Financeiro;
- Comprador;
- Estoquista;
- Almoxarife;
- Costureira;
- qualquer outro Cargo criado pela empresa.

Cargo não é enumeração fechada.

---

# 6. Campos Principais de Cargo

Campos estruturais:

- `empresa`
- `codigo`
- `descricao`
- `ativo`
- `participa_vendas`
- `permite_comissao`
- `autoridade_operacional_loja`
- `permite_multiplas_lojas`
- `gerencial`
- `data_cadastro`
- `data_atualizacao`

---

# 7. Isolamento do Cargo

Cada Cargo pertence a uma Empresa.

Relacionamento:

`Cargo.empresa`

Regra de unicidade:

`empresa + codigo`

Constraint:

`uq_empresa_cargo_codigo`

Consequências:

- o mesmo código não pode ser duplicado na mesma empresa;
- empresas diferentes podem possuir cargos com o mesmo código;
- Cargo não é global;
- Cargo de outra empresa não pode ser associado ao Funcionário.

---

# 8. Cargo Não é Perfil de Acesso

Essa separação é estrutural.

Cargo:

`cadastros.Cargo`

Perfil:

`accounts.PerfilAcesso`

Permissões:

- `PerfilModuloPermissao`
- `UserModulePermission`
- demais estruturas de acesso do app `accounts`.

Não deve existir lógica semelhante a:

~~~text
cargo == "Assistente Financeiro"
    liberar módulo Financeiro
~~~

Essa arquitetura é proibida.

Um Assistente Financeiro pode possuir permissões diferentes de outro Assistente Financeiro.

---

# 9. Características Operacionais do Cargo

Os campos do Cargo informam características da função.

## participa_vendas

Indica se aquela função normalmente participa diretamente do processo comercial.

## permite_comissao

Indica se funcionários naquele Cargo podem ser configurados como comissionados.

Não define percentual.

## autoridade_operacional_loja

Na interface atual também representa a necessidade operacional de Loja Principal.

## permite_multiplas_lojas

Habilita abrangência operacional sobre múltiplas lojas.

É utilizada principalmente em funções como Supervisor.

## gerencial

Identifica função gerencial para uso funcional futuro.

Não concede permissões automaticamente.

---

# 10. Cargos Livres

Cada empresa pode cadastrar seus próprios Cargos.

Não existe lista fechada no backend ou frontend.

O sistema permite criar, por exemplo:

~~~text
Código: ANALISTA
Descrição: Analista Financeiro
~~~

sem alteração no código-fonte.

O novo Cargo passa a poder ser utilizado no cadastro de Funcionários.

---

# 11. Cargos Básicos

O sistema cria um conjunto inicial de Cargos por empresa.

Códigos atualmente previstos:

- `VENDEDOR`
- `CAIXA`
- `GERENTE`
- `SUPERVISOR`
- `ASSISTENTE`
- `AUXILIAR`
- `AUXADM`
- `ASSADM`
- `ASSFIN`
- `AUXFIN`
- `COMPRADOR`
- `ESTOQUISTA`
- `ALMOX`
- `CONFERENTE`
- `RECEBEDOR`
- `COSTUREIRA`
- `AUXPROD`

São defaults iniciais.

Não constituem enumeração fechada.

---

# 12. Serviço de Cargos Básicos

Serviço:

`CargoInicialService`

Local:

`cadastros/services.py`

Responsabilidade:

garantir os Cargos básicos de uma Empresa.

A implementação utiliza criação protegida por:

`empresa + codigo`

Não deve:

- duplicar cargos;
- sobrescrever Cargo existente;
- transformar Cargo em cadastro global.

---

# 13. Empresas Existentes

A migration:

`0027_cargos_funcionarios_basicos.py`

cria os Cargos básicos para empresas já existentes.

A operação utiliza criação segura para evitar duplicidade.

---

# 14. Empresas Novas

Para empresas criadas após a migration, o sistema utiliza a infraestrutura de criação da Empresa para garantir os Cargos básicos.

Integração:

`cadastros/signals.py`

O signal utiliza:

`CargoInicialService`

Assim empresas existentes e futuras seguem a mesma estrutura funcional.

---

# 15. Comissão dos Cargos Básicos

Após a correção de homologação, os defaults relevantes são:

## Vendedor

- participa de vendas: Sim;
- permite comissão: Sim;
- exige loja principal: Sim;
- múltiplas lojas: Não;
- gerencial: Não.

## Caixa

- participa de vendas: Não;
- permite comissão: Não;
- exige loja principal: Sim;
- múltiplas lojas: Não;
- gerencial: Não.

## Gerente

- participa de vendas: Não por padrão;
- permite comissão: Sim;
- exige loja principal: Sim;
- múltiplas lojas: Não;
- gerencial: Sim.

## Supervisor

- participa de vendas: Não por padrão;
- permite comissão: Sim;
- exige loja principal: Sim;
- múltiplas lojas: Sim;
- gerencial: Sim.

---

# 16. Migration de Comissão

Migration:

`0028_corrige_comissao_gerente_supervisor.py`

Responsabilidade:

corrigir empresas existentes para que:

~~~text
GERENTE.permite_comissao = true
SUPERVISOR.permite_comissao = true
~~~

Também foi alterado `CargoInicialService` para aplicar a regra em empresas futuras.

---

# 17. Model Funcionarios

Model:

`cadastros.models.Funcionarios`

É a entidade operacional central da funcionalidade.

Representa a pessoa que trabalha ou participa da operação da empresa.

---

# 18. Campos Estruturais de Funcionarios

Campos principais atuais incluem:

- `empresa`
- `matricula`
- `nomefuncionario`
- `apelido`
- `cpf`
- `inicio`
- `fim`
- `cargo`
- `categoria`
- `situacao`
- `participa_vendas`
- `comissionado`
- `comissao_percentual`
- `salario`
- `idloja`
- `lojas_supervisionadas`
- `todas_lojas_da_empresa`
- `usuario`
- `telefone`
- `whatsapp`
- `email`
- `data_nascimento`
- `endereco`
- `observacoes`
- `meta`
- `ativo`
- `data_cadastro`
- `data_atualizacao`

Alguns campos permanecem por compatibilidade histórica.

---

# 19. Empresa do Funcionário

Relacionamento:

`Funcionarios.empresa`

Todo novo Funcionário operacional deve pertencer a uma Empresa.

A API impede criação normal sem empresa válida.

Para usuário comum, a empresa é determinada pelo tenant autenticado.

Superusuário deve informar uma empresa quando aplicável.

---

# 20. Matrícula

Campo:

`matricula`

Características:

- obrigatória funcionalmente;
- única por empresa;
- estável;
- utilizada como identificador interno do funcionário.

Constraint:

`uq_empresa_funcionario_matricula`

Índice:

`idx_func_emp_matricula`

---

# 21. Geração Automática de Matrícula

Quando não informada, a matrícula é gerada automaticamente dentro da empresa.

Formato inicial:

~~~text
000001
000002
000003
...
~~~

A sequência é independente por Empresa.

Também é permitida matrícula manual desde que não exista na mesma empresa.

---

# 22. Matrícula e Ciclo de Vida

A matrícula não muda quando o Funcionário:

- é afastado;
- retorna;
- é desligado;
- é recontratado.

Recontratação utiliza o mesmo registro do Funcionário.

Não deve ser criado outro cadastro para representar a mesma pessoa somente por causa do retorno.

---

# 23. CPF

Campo:

`cpf`

CPF é obrigatório funcionalmente para Funcionários.

O backend:

- normaliza;
- valida;
- impede vazio em criação/edição operacional normal;
- impede sequências inválidas;
- impede duplicidade na mesma empresa.

---

# 24. Unicidade do CPF

Constraint:

`uq_empresa_funcionario_cpf`

Regra:

`empresa + cpf`

Consequências:

- CPF duplicado na mesma empresa é recusado;
- mesmo CPF pode existir em empresas diferentes.

Índice relacionado:

`idx_func_emp_cpf`

---

# 25. Registros Legados sem CPF

A migration da Fase 1 não inventa CPF.

Registros antigos sem CPF podem ser preservados para compatibilidade de dados.

Entretanto:

novas criações e alterações operacionais devem respeitar a obrigatoriedade definida na Fase 1.

Nunca gerar CPF artificial.

---

# 26. Situação Operacional

Campo:

`situacao`

Valores:

- `ATIVO`
- `AFASTADO`
- `DESLIGADO`

Índice:

`idx_func_emp_situacao`

Esse campo passa a representar o ciclo de vida operacional do Funcionário.

---

# 27. Campo ativo Legado

O model já possuía:

`ativo`

antes da criação de `situacao`.

A nova arquitetura utiliza `situacao` como estrutura funcional principal do ciclo de vida.

O campo legado não deve ser usado para criar nova lógica independente do estado operacional.

Compatibilidade deve ser preservada até eventual remoção planejada.

---

# 28. Datas Operacionais

Campos existentes:

- `inicio`
- `fim`

Uso funcional:

`inicio`

representa Data de Admissão.

`fim`

é utilizado como Data de Desligamento quando aplicável.

Não foram criados models de contrato trabalhista.

---

# 29. Ações de Ciclo de Vida

O ViewSet oferece ações operacionais específicas:

- `afastar`
- `retornar`
- `desligar`
- `recontratar`

Essas operações são preferíveis à alteração indiscriminada do status diretamente pelo formulário.

---

# 30. Afastamento

Fluxo:

~~~text
ATIVO
  ↓
AFASTADO
~~~

O Funcionário:

- permanece cadastrado;
- mantém matrícula;
- mantém CPF;
- mantém histórico;
- deixa de estar normalmente disponível para novas operações.

---

# 31. Retorno

Fluxo:

~~~text
AFASTADO
  ↓
ATIVO
~~~

O retorno:

- reutiliza o mesmo Funcionário;
- preserva relações;
- registra histórico;
- registra auditoria.

---

# 32. Desligamento

Fluxo:

~~~text
ATIVO
  ↓
DESLIGADO
~~~

O desligamento:

- preserva o cadastro;
- preserva matrícula;
- preserva CPF;
- registra data de desligamento;
- preserva vínculos históricos;
- impede uso operacional normal em novas operações.

---

# 33. Recontratação

Fluxo:

~~~text
DESLIGADO
  ↓
ATIVO
~~~

Não cria um novo Funcionário.

Deve preservar:

- ID do funcionário;
- matrícula;
- CPF;
- histórico;
- referências anteriores.

---

# 34. Cargo do Funcionário

Relacionamento:

`Funcionarios.cargo`

ForeignKey para:

`cadastros.Cargo`

A nova arquitetura utiliza `cargo` como fonte funcional.

Cargo deve:

- pertencer à mesma empresa;
- estar ativo para novas atribuições.

---

# 35. Campo categoria Legado

Campo anterior:

`categoria`

Permanece por compatibilidade.

A migration da Fase 1 converte valores existentes de categoria em Cargos estruturados quando possível.

Nova lógica não deve utilizar `categoria` como fonte de verdade.

Fonte de verdade atual:

`cargo`

---

# 36. Migration de Categoria para Cargo

Migration principal:

`0026_cargo_funcionariohistorico_funcionarios_comissionado_and_more.py`

Durante a migração:

- categorias existentes são analisadas por empresa;
- Cargos correspondentes são criados;
- Funcionários são associados aos novos Cargos;
- o texto legado é preservado.

Não apagar `categoria` de forma destrutiva nesta fase.

---

# 37. Loja Principal

Campo atual:

`idloja`

ForeignKey para:

`cadastros.Loja`

Apesar do nome legado, funcionalmente representa:

**Loja Principal**

Não foi realizada renomeação destrutiva para evitar regressões.

---

# 38. Validação da Loja Principal

A Loja Principal deve:

- pertencer à mesma Empresa;
- ser compatível com o Cargo;
- existir no tenant correto.

Cargo com:

`autoridade_operacional_loja = true`

exige Loja Principal segundo a regra atual da Fase 1.

---

# 39. Funcionários Administrativos sem Loja

Cargos administrativos podem ser configurados com:

`autoridade_operacional_loja = false`

Exemplos:

- Assistente;
- Auxiliar Administrativo;
- Assistente Financeiro;
- Comprador.

Nesses casos, Loja Principal não é obrigatória por padrão.

A empresa pode alterar a configuração do Cargo conforme sua necessidade.

---

# 40. Abrangência Multi-Loja

Relacionamento:

`lojas_supervisionadas`

Tipo:

ManyToMany com `Loja`.

Campo complementar:

`todas_lojas_da_empresa`

Essas estruturas representam abrangência operacional.

---

# 41. Regra Multi-Loja

Apenas Cargo com:

`permite_multiplas_lojas = true`

pode manter abrangência de múltiplas lojas.

Exemplo típico:

Supervisor.

Cargo comum não deve manter relação multi-loja.

---

# 42. Todas as Lojas

Campo:

`todas_lojas_da_empresa`

Quando verdadeiro, representa abrangência sobre todas as lojas da Empresa.

Não deve ser confundido com a seleção de lojas permitidas do Usuário.

---

# 43. Funcionário Multi-Loja × User.lojas

São conceitos diferentes.

## Funcionarios.lojas_supervisionadas

Responsabilidade operacional.

## User.lojas

Escopo de acesso do Usuário no sistema.

Uma relação não deve substituir automaticamente a outra.

---

# 44. Mudança de Cargo Multi-Loja

Quando um Funcionário deixa um Cargo que permite múltiplas lojas e passa para um Cargo comum:

a abrangência anterior deve ser regularizada.

Não permitir estado incoerente em que:

~~~text
cargo.permite_multiplas_lojas = false