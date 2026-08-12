## 1. Identificação

**Projeto:** Sysvar  
**Módulo:** Cadastros  
**Cadastro:** Funcionários  
**Fase:** Fase 1 — Operacional  
**Situação:** HOMOLOGADO  
**Data de conclusão da homologação:** 12/08/2026  
**Resultado:** 17/17 itens aprovados

---

## 2. Objetivo

O cadastro de Funcionários do Sysvar tem como objetivo representar as pessoas que participam da operação da empresa.

Nesta fase, Funcionário é uma entidade operacional e não um cadastro de Recursos Humanos ou Departamento Pessoal.

O cadastro deve permitir representar, entre outros:

- vendedores;
    
- caixas;
    
- gerentes;
    
- supervisores;
    
- assistentes;
    
- auxiliares;
    
- funcionários administrativos;
    
- funcionários financeiros;
    
- compradores;
    
- estoquistas;
    
- almoxarifes;
    
- conferentes;
    
- funcionários de produção.
    

O cadastro de Funcionários não substitui o cadastro de Usuários do sistema.

São conceitos distintos:

- **Funcionário:** pessoa e função operacional dentro da empresa;
    
- **Usuário:** identidade utilizada para acessar o Sysvar;
    
- **Cargo:** função operacional exercida pelo funcionário;
    
- **Perfil e permissões:** direitos de acesso e execução dentro do sistema.
    

---

## 3. Princípios funcionais aprovados

### 3.1 Funcionário não é Usuário

Um Funcionário pode existir sem possuir acesso ao Sysvar.

Quando for necessário acesso ao sistema, poderá ser vinculado a um Usuário existente.

O vínculo entre Funcionário e Usuário:

- é opcional;
    
- deve ocorrer dentro da mesma empresa;
    
- não cria permissões automaticamente;
    
- não altera perfil de acesso;
    
- não altera Cargo;
    
- não altera automaticamente a loja do Usuário;
    
- não altera automaticamente o tipo do Usuário;
    
- não desativa automaticamente o Usuário em caso de afastamento ou desligamento.
    

Cada Usuário pode estar vinculado a no máximo um Funcionário.

---

## 4. Cargo estruturado

O antigo conceito de categoria textual do funcionário foi substituído funcionalmente por um cadastro estruturado de **Cargos**.

Cargo pertence à empresa e é configurável.

Cargo não é uma enumeração fechada.

Cada empresa pode criar livremente os cargos adequados à sua operação.

### 4.1 Campos principais do Cargo

Cada Cargo possui:

- código;
    
- descrição;
    
- ativo/inativo;
    
- participa de vendas;
    
- permite comissão;
    
- exige loja principal / autoridade operacional de loja;
    
- permite atuação em múltiplas lojas;
    
- indicação de cargo gerencial.
    

### 4.2 Cargo e permissão

Cargo não concede permissão no sistema.

Exemplo:

Um funcionário pode possuir Cargo:

**Assistente Financeiro**

e receber através do seu Usuário e Perfil de Acesso permissão para:

- contas a pagar;
    
- contas a receber;
    
- conciliação bancária;
    
- relatórios financeiros.
    

Outro funcionário com o mesmo Cargo pode possuir permissões diferentes.

Não existe regra do tipo:

`Cargo = Assistente Financeiro → liberar automaticamente Financeiro`.

Permissões continuam sendo responsabilidade de:

- Usuário;
    
- Perfil de Acesso;
    
- Permissões por módulo;
    
- Permissões específicas de campo ou operação.
    

---

## 5. Cargos básicos iniciais

O sistema disponibiliza cargos básicos para cada empresa, sem impedir a criação de outros.

Cargos iniciais:

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
    

A empresa pode:

- criar novos cargos;
    
- editar cargos;
    
- inativar cargos;
    
- definir características operacionais;
    
- utilizar nomenclaturas próprias.
    

Durante a homologação foi validada a criação de cargos adicionais não existentes originalmente, comprovando que a estrutura não está limitada a Caixa, Gerente e Vendedor.

---

## 6. Regras iniciais de comissão por Cargo

O Cargo define se aquela função **permite** comissão.

Isso não significa que o Cargo determine a regra ou o percentual da comissão.

### Vendedor

- participa de vendas: Sim;
    
- permite comissão: Sim;
    
- exige loja principal: Sim;
    
- múltiplas lojas: Não;
    
- gerencial: Não.
    

### Caixa

- participa de vendas: Não por padrão;
    
- permite comissão: Não por padrão;
    
- exige loja principal: Sim;
    
- múltiplas lojas: Não;
    
- gerencial: Não.
    

### Gerente

- participa de vendas diretamente: Não por padrão;
    
- permite comissão: Sim;
    
- exige loja principal: Sim;
    
- múltiplas lojas: Não;
    
- gerencial: Sim.
    

### Supervisor

- participa de vendas diretamente: Não por padrão;
    
- permite comissão: Sim;
    
- exige loja principal: Sim;
    
- múltiplas lojas: Sim;
    
- gerencial: Sim.
    

A regra de comissão de Gerentes e Supervisores será tratada futuramente no módulo de Planejamento/Ação de Vendas.

Exemplos futuros:

- Gerente com comissão sobre faturamento da loja;
    
- Supervisor com comissão sobre todas as lojas;
    
- Supervisor com comissão somente sobre lojas sob sua responsabilidade;
    
- comissão por faixa de meta;
    
- bônus;
    
- campanhas;
    
- comissão diferenciada por produto, grupo ou coleção.
    

Essas regras não pertencem ao cadastro de Funcionários.

---

## 7. Matrícula

Todo Funcionário possui matrícula.

### Regras

- obrigatória;
    
- única dentro da empresa;
    
- estável;
    
- nunca reutilizada por outro funcionário;
    
- permanece durante afastamento;
    
- permanece após desligamento;
    
- permanece em eventual recontratação.
    

O sistema pode gerar automaticamente matrículas sequenciais por empresa.

Exemplo:

- 000001;
    
- 000002;
    

Também é permitida matrícula informada manualmente, desde que não exista outra igual na mesma empresa.

A matrícula foi validada na homologação quanto a:

- geração automática;
    
- não repetição;
    
- matrícula manual;
    
- bloqueio de duplicidade;
    
- preservação durante edição.
    

---

## 8. CPF

CPF é obrigatório no cadastro de Funcionários.

### Regras

- não permitir Funcionário sem CPF;
    
- validar CPF;
    
- rejeitar sequências inválidas;
    
- rejeitar CPF zerado;
    
- normalizar o valor no backend;
    
- CPF deve ser único dentro da empresa;
    
- o mesmo CPF pode existir em empresas diferentes.
    

O CPF foi homologado com:

- ausência de CPF;
    
- CPF inválido;
    
- CPF duplicado;
    
- CPF válido.
    

Todas as regras funcionaram conforme esperado.

---

## 9. Empresa e isolamento multiempresa

Todo Funcionário pertence a uma empresa.

As seguintes relações devem respeitar a mesma empresa:

- Funcionário;
    
- Cargo;
    
- loja principal;
    
- lojas supervisionadas;
    
- Usuário vinculado.
    

Não é permitido relacionar Funcionário com dados de outra empresa.

O backend é responsável pela validação.

O frontend não é considerado autoridade para isolamento de tenant.

---

## 10. Situação operacional

O Funcionário possui situação operacional estruturada.

Situações disponíveis:

- ATIVO;
    
- AFASTADO;
    
- DESLIGADO.
    

### 10.1 Ativo

Funcionário disponível normalmente para novas operações.

### 10.2 Afastado

Funcionário:

- permanece cadastrado;
    
- mantém histórico;
    
- não deve ser utilizado normalmente em novas operações.
    

### 10.3 Desligado

Funcionário:

- permanece cadastrado;
    
- mantém histórico;
    
- não deve ser utilizado em novas operações;
    
- mantém sua matrícula;
    
- mantém seu CPF;
    
- mantém histórico operacional.
    

### 10.4 Retorno

Um Funcionário afastado pode retornar à situação ATIVO.

### 10.5 Recontratação

Um Funcionário desligado pode ser recontratado.

A recontratação:

- reutiliza o mesmo cadastro;
    
- mantém o CPF;
    
- mantém a matrícula;
    
- preserva o histórico anterior;
    
- retorna o funcionário para situação ATIVO.
    

O ciclo:

ATIVO → AFASTADO → ATIVO → DESLIGADO → ATIVO

foi validado durante a homologação.

---

## 11. Loja principal

O Funcionário pode possuir uma Loja Principal.

Determinados cargos exigem Loja Principal.

Exemplos:

- Vendedor;
    
- Caixa;
    
- Gerente;
    
- Estoquista;
    
- Almoxarife;
    
- Conferente;
    
- Recebedor.
    

A necessidade de loja é definida pelas características estruturadas do Cargo.

Não deve depender exclusivamente do texto do nome do Cargo.

### Regras

- loja deve pertencer à mesma empresa;
    
- Cargo que exige loja não pode ser salvo sem loja;
    
- mudança de loja é permitida;
    
- mudança deve ser registrada no histórico;
    
- loja de outra empresa deve ser rejeitada.
    

Todas essas situações foram homologadas.

---

## 12. Supervisor e abrangência multi-loja

O Supervisor pode possuir abrangência operacional sobre mais de uma loja.

O sistema permite:

- selecionar lojas específicas;
    
- selecionar todas as lojas da empresa.
    

Essa abrangência pertence ao Funcionário.

Ela não deve ser confundida com:

`accounts.User.lojas`

A relação `User.lojas` representa acesso do usuário.

A abrangência do Funcionário representa responsabilidade operacional.

### Regras

- apenas Cargo configurado para múltiplas lojas pode usar abrangência;
    
- todas as lojas devem pertencer à mesma empresa;
    
- pode selecionar várias lojas;
    
- pode selecionar todas as lojas da empresa;
    
- Cargo comum não pode manter abrangência multi-loja;
    
- ao abandonar Cargo multi-loja, a abrangência deve ser regularizada.
    

A funcionalidade foi homologada com sucesso.

---

## 13. Participação em vendas

O Funcionário possui indicação:

**Participa de vendas**

Esse campo informa se o Funcionário pode atuar comercialmente como vendedor em processos que utilizem essa informação.

Cargo pode fornecer uma característica inicial, porém o cadastro do Funcionário mantém a configuração operacional necessária.

---

## 14. Comissão básica

O Funcionário possui:

- indicação de Comissionado;
    
- percentual básico de comissão.
    

O percentual pertence ao Funcionário, não ao Cargo.

Cargo apenas determina se aquela função permite comissão.

Exemplos:

### Vendedor

Pode possuir:

- Comissionado: Sim;
    
- Comissão básica: 2%.
    

### Gerente

Pode possuir:

- Comissionado: Sim;
    
- Comissão básica: conforme política da empresa.
    

### Supervisor

Pode possuir:

- Comissionado: Sim;
    
- Comissão básica: conforme política da empresa.
    

A comissão avançada será responsabilidade de módulo futuro.

O cadastro atual não implementa:

- metas;
    
- faixas;
    
- campanhas;
    
- bônus;
    
- comissão por produto;
    
- comissão por coleção;
    
- comissão por grupo;
    
- comissão progressiva.
    

---

## 15. Campo Meta

O campo `meta` existia no cadastro antigo de Funcionários.

Foi decidido que Meta não pertence funcionalmente ao Funcionário.

O campo pode permanecer fisicamente por compatibilidade com dados legados, mas:

- não aparece na tela nova;
    
- não é utilizado como regra operacional;
    
- não é filtro funcional;
    
- não participa da nova lógica;
    
- não deve ser usado em desenvolvimentos futuros.
    

Metas serão tratadas pelo futuro módulo de Planejamento/Ação de Vendas.

A ausência de Meta na operação de Funcionários foi homologada.

---

## 16. Vínculo Funcionário ↔ Usuário

O formulário de Funcionários permite selecionar:

**Usuário vinculado**

As opções são carregadas utilizando o serviço existente de Usuários.

O vínculo pode ser:

- criado;
    
- alterado;
    
- removido;
    
- mantido vazio.
    

A opção:

**Nenhum**

representa funcionário sem acesso ao sistema.

### Regras

- usuário deve pertencer à mesma empresa;
    
- um usuário não pode ser vinculado a vários funcionários;
    
- vínculo não modifica Cargo;
    
- vínculo não modifica Perfil;
    
- vínculo não modifica permissões;
    
- vínculo não altera login;
    
- vínculo não é obrigatório.
    

Na consulta do funcionário, o Usuário vinculado também é apresentado.

A funcionalidade foi inicialmente identificada como ausente no frontend durante a homologação, foi corrigida e posteriormente aprovada.

---

## 17. Histórico operacional

O sistema mantém histórico operacional do Funcionário.

Eventos registrados incluem:

- mudança de Cargo;
    
- mudança de Loja;
    
- alteração de abrangência;
    
- afastamento;
    
- retorno;
    
- desligamento;
    
- recontratação.
    

O histórico deve permitir identificar, conforme a operação:

- tipo do evento;
    
- data/hora;
    
- usuário responsável;
    
- valor anterior;
    
- valor novo;
    
- motivo;
    
- observação.
    

O histórico não representa prontuário de RH.

Seu objetivo é preservar contexto operacional.

A exibição e persistência do histórico foram homologadas.

---

## 18. Auditoria

Funcionários está integrado à Audit Central.

São auditáveis, entre outros:

- criação;
    
- atualização;
    
- mudança de Cargo;
    
- mudança de Loja;
    
- mudança de abrangência;
    
- afastamento;
    
- retorno;
    
- desligamento;
    
- recontratação;
    
- alteração de comissão;
    
- vínculo de Usuário;
    
- desvínculo de Usuário;
    
- exclusão;
    
- tentativa de exclusão negada.
    

Histórico operacional e Audit Central têm finalidades distintas.

### Histórico

Visão funcional da trajetória do Funcionário.

### Audit Central

Rastreabilidade técnica e de segurança.

---

## 19. Exclusão

Funcionário que nunca foi utilizado em operação pode ser excluído.

Funcionário já utilizado deve ser preservado.

Exemplos de vínculos que podem impedir exclusão:

- vendas;
    
- histórico;
    
- comissão;
    
- operações financeiras;
    
- demais relações protegidas existentes.
    

Quando não for permitida a exclusão, o sistema deve orientar o usuário a utilizar desligamento.

Mensagem funcional adotada:

> Funcionário já utilizado em operações. Desligue o funcionário em vez de excluí-lo.

Foram homologados:

- funcionário sem operação → exclusão permitida;
    
- funcionário utilizado → exclusão bloqueada.
    

---

## 20. Salário

O campo Salário existente foi mantido.

O Sysvar não executará nesta fase:

- folha de pagamento;
    
- encargos;
    
- cálculo trabalhista;
    
- benefícios;
    
- férias;
    
- rescisões;
    
- rotinas de Departamento Pessoal.
    

Salário é apenas uma informação protegida.

### Regras

- campo opcional;
    
- protegido pela permissão específica `funcionario.salario`;
    
- usuário autorizado pode visualizar e alterar;
    
- usuário não autorizado não visualiza;
    
- usuário não autorizado não altera;
    
- não aparece como coluna padrão da listagem;
    
- alteração deve ser auditável.
    

As regras foram homologadas.

---

## 21. Dados pessoais e complementares

Além dos campos operacionais principais, o Funcionário pode possuir:

- apelido;
    
- telefone;
    
- WhatsApp;
    
- e-mail;
    
- data de nascimento;
    
- endereço;
    
- observações.
    

Esses campos são opcionais.

Foram homologados:

- gravação;
    
- edição;
    
- permanência dos dados;
    
- validação de telefone;
    
- validação de e-mail;
    
- utilização dos campos em branco.
    

---

## 22. Dados que não pertencem à Fase 1

Não fazem parte desta fase:

- PIS;
    
- CTPS;
    
- dependentes;
    
- estado civil obrigatório;
    
- título de eleitor;
    
- dados previdenciários;
    
- férias;
    
- benefícios;
    
- jornada;
    
- ponto;
    
- folha de pagamento;
    
- rescisão trabalhista detalhada;
    
- documentos trabalhistas;
    
- contrato de trabalho estruturado;
    
- prontuário de RH.
    

Esses assuntos poderão compor futuramente um módulo específico de RH/DP, caso necessário.

---

## 23. Consulta e filtros

A listagem de Funcionários passou a utilizar paginação e filtros server-side.

Não deve carregar milhares de registros para realizar filtro no Angular.

Filtros disponíveis incluem:

- busca textual;
    
- matrícula;
    
- nome;
    
- apelido;
    
- CPF;
    
- Cargo;
    
- Loja;
    
- Situação;
    
- participa de vendas;
    
- comissionado.
    

A paginação server-side foi homologada.

Também foram homologados:

- quantidade por página;
    
- navegação entre páginas;
    
- total de registros;
    
- filtros combinados;
    
- limpeza de filtros.
    

---

## 24. Consulta do Funcionário

A consulta apresenta informações organizadas do funcionário.

Entre elas:

### Dados cadastrais

- matrícula;
    
- nome;
    
- apelido;
    
- CPF;
    
- Cargo;
    
- Loja Principal;
    
- Situação;
    
- admissão;
    
- desligamento, quando aplicável.
    

### Comercial

- participa de vendas;
    
- comissionado;
    
- comissão básica.
    

### Abrangência

Quando aplicável:

- lojas supervisionadas;
    
- todas as lojas.
    

### Acesso

- Usuário vinculado;
    
- ou indicação de Nenhum.
    

### Histórico

- eventos operacionais registrados.
    

Indicadores avançados de desempenho não fazem parte desta fase.

---

## 25. Compatibilidade com Vendas

O sistema de Vendas já diferencia:

- vendedor;
    
- usuário que executou a operação.
    

`VendaPdv.vendedor` continua relacionado a `Funcionarios`.

`VendaPdv.criado_por` continua relacionado ao Usuário.

Isso permite registrar separadamente:

- quem realizou comercialmente a venda;
    
- quem estava operando o sistema.
    

Essa separação deve ser preservada.

---

## 26. Observação futura sobre comissão histórica

No código anterior, relatórios podiam utilizar o percentual atual de comissão do funcionário.

Essa abordagem não é suficiente para um motor definitivo de comissão histórica.

No futuro módulo de Planejamento/Ação de Vendas, a regra efetivamente aplicada deverá ser preservada no contexto da venda ou da apuração.

Isso evitará que uma alteração posterior no percentual do Funcionário modifique interpretações históricas.

Essa mudança não pertence à Fase 1 de Funcionários.

---

## 27. Autorizações comerciais

Não pertencem ao cadastro de Funcionários:

- autorização de desconto;
    
- autorização de cancelamento;
    
- autorização especial de venda;
    
- aprovação de exceções;
    
- workflow de Gerente;
    
- workflow de Supervisor.
    

Essas regras deverão ser tratadas no módulo de Vendas.

Cargo poderá servir como informação operacional, mas não substituirá permissões e workflows específicos.

---

## 28. Implementação backend inicial

Commit principal da Fase 1:

`056dfdee7545b725f94f6396bb5bff2f58be2397`

Mensagem:

`Conclui fase 1 do cadastro de funcionarios`

Principais áreas alteradas:

- auditoria;
    
- models de Cadastros;
    
- serializers;
    
- views;
    
- URLs;
    
- testes;
    
- dashboard;
    
- integração com Venda PDV.
    

Migration principal:

`cadastros/migrations/0026_cargo_funcionariohistorico_funcionarios_comissionado_and_more.py`

---

## 29. Implementação frontend inicial

Commit principal:

`7fd39d0c86d070bc92ff8ff38dee99cc723b23dc`

Mensagem:

`Conclui fase 1 da interface de funcionarios`

Principais alterações:

- model de Funcionário;
    
- model de Cargo;
    
- serviço de Funcionários;
    
- serviço de Cargos;
    
- tela de Funcionários;
    
- tela de Cargos;
    
- rotas;
    
- integração necessária com PDV.
    

---

## 30. Correção — Cargos administrativos e operacionais

Durante a homologação foi identificado que a apresentação inicial dos cargos poderia transmitir a ideia de que o sistema estava limitado a:

- Caixa;
    
- Gerente;
    
- Vendedor.
    

A regra foi corrigida.

Cargo passou a ser explicitamente tratado como cadastro aberto por empresa.

Foram adicionados cargos básicos administrativos e operacionais.

### Backend

Commit:

`2ba369f3c1cb076b65bdd6b625fa051e8dd7f351`

Mensagem:

`Amplia cadastro de cargos de funcionarios`

Migration:

`cadastros/migrations/0027_cargos_funcionarios_basicos.py`

Também foi criado mecanismo para garantir cargos básicos em empresas futuras sem duplicar os existentes.

### Frontend

Commit:

`d847d20b2dcbb94f8f0f450c53e308e4ba0afd7a`

Mensagem:

`Permite cargos livres no cadastro de funcionarios`

A tela passou a deixar explícita a ação:

**Novo Cargo**

e que os cargos podem ser cadastrados livremente pela empresa.

---

## 31. Correção — Comissão de Gerente e Supervisor

Durante a homologação foi identificado que Gerente e Supervisor estavam inicialmente configurados como cargos que não permitiam comissão.

A regra foi corrigida.

Gerente e Supervisor podem ser comissionados.

A forma de cálculo continuará sendo definida futuramente.

### Backend

Commit:

`b7b10bf5d5095d49ec9cbe1a7329f46c3efa6331`

Mensagem:

`Corrige comissao de gerente e supervisor`

Migration:

`cadastros/migrations/0028_corrige_comissao_gerente_supervisor.py`

A correção estabeleceu:

- GERENTE → `permite_comissao = true`;
    
- SUPERVISOR → `permite_comissao = true`.
    

---

## 32. Correção — Vínculo Funcionário ↔ Usuário no frontend

Durante a homologação foi identificado que o backend possuía o vínculo com Usuário, mas o frontend não disponibilizava o campo no formulário.

Foi adicionada a seleção:

**Usuário vinculado**

### Frontend

Commit:

`0a71c638a7c6b1db324fa978ff69e035c4fc51dc`

Mensagem:

`Adiciona vinculo de usuario ao funcionario`

Foi utilizado o serviço de Usuários já existente.

A tela passou a permitir:

- vincular;
    
- trocar;
    
- remover;
    
- consultar o Usuário relacionado.
    

Após a correção, o Item 12 da homologação foi aprovado.

---

## 33. Resultado dos testes automatizados registrados

Durante a implementação inicial foram registrados:

### Backend

- `manage.py check`: OK;
    
- `manage.py makemigrations --check`: OK;
    
- testes direcionados de Funcionários: OK;
    
- conjunto relacionado de testes de Cadastros: OK.
    

Na implementação inicial foram registrados 40 testes no conjunto combinado informado pelo Codex.

Nas correções seguintes, os testes direcionados de Funcionários continuaram aprovados.

### Frontend

Foram registrados:

- `tsc -p tsconfig.app.json --noEmit`: OK;
    
- `ng build --configuration development`: OK.
    

Esses resultados representam os testes executados durante as respectivas implementações e correções.

---

## 34. Homologação manual

A homologação foi realizada funcionalmente, item por item.

### Item 1 — Abertura e estrutura da tela

**Resultado:** OK

Validado:

- abertura da tela;
    
- listagem;
    
- novas informações;
    
- retirada funcional de Meta;
    
- ausência de erro visível.
    

### Item 2 — Paginação server-side

**Resultado:** OK

Validado:

- total;
    
- navegação;
    
- quantidade por página;
    
- funcionamento server-side.
    

### Item 3 — Filtros server-side

**Resultado:** OK

Validado:

- nome;
    
- CPF;
    
- matrícula;
    
- Cargo;
    
- Loja;
    
- Situação;
    
- vendas;
    
- comissão.
    

### Item 4 — Cargos

**Resultado inicial:** Necessitou correção

Foi identificado que o cadastro precisava deixar explícito que não estava limitado a cargos comerciais.

Após correção:

**Resultado final:** OK

Validado:

- cargos administrativos;
    
- cargos operacionais;
    
- criação de Cargo livre;
    
- utilização do Cargo criado no Funcionário.
    

### Item 5 — Funcionário com Cargo administrativo

**Resultado:** OK

Validado funcionário administrativo sem comportamento indevido de vendedor, caixa ou gerente.

### Item 6 — CPF

**Resultado:** OK

Validado:

- obrigatório;
    
- inválido;
    
- duplicado;
    
- válido.
    

### Item 7 — Matrícula

**Resultado:** OK

Validado:

- geração automática;
    
- sequência;
    
- matrícula manual;
    
- duplicidade;
    
- preservação.
    

### Item 8 — Situação operacional

**Resultado:** OK

Validado:

- afastar;
    
- retornar;
    
- desligar;
    
- recontratar;
    
- preservar CPF;
    
- preservar matrícula;
    
- registrar histórico.
    

### Item 9 — Loja principal

**Resultado:** OK

Validado:

- obrigatoriedade por Cargo;
    
- mesma empresa;
    
- mudança de loja;
    
- histórico.
    

### Item 10 — Supervisor e multi-loja

**Resultado inicial:** Necessitou correção

Foi identificado que Supervisor e Gerente precisavam permitir comissão.

Após correção:

**Resultado final:** OK

Validado:

- comissão permitida;
    
- várias lojas;
    
- todas as lojas;
    
- regularização ao trocar Cargo;
    
- isolamento entre empresas.
    

### Item 11 — Comissão básica

**Resultado:** OK

Validado:

- Vendedor;
    
- Gerente;
    
- Supervisor;
    
- percentual básico;
    
- cargo não comissionável;
    
- alteração de comissão.
    

### Item 12 — Funcionário ↔ Usuário

**Resultado inicial:** Necessitou correção

O vínculo existia no backend, mas não estava disponível na tela.

Após correção:

**Resultado final:** OK

Validado:

- Funcionário sem Usuário;
    
- vínculo;
    
- troca;
    
- remoção;
    
- preservação de Cargo;
    
- preservação de Perfil;
    
- preservação de permissões.
    

### Item 13 — Histórico operacional

**Resultado:** OK

Validado histórico das mudanças e ciclos operacionais.

### Item 14 — Exclusão protegida

**Resultado:** OK

Validado:

- funcionário sem uso pode ser excluído;
    
- funcionário utilizado não pode ser apagado.
    

### Item 15 — Salário protegido

**Resultado:** OK

Validado:

- usuário autorizado;
    
- usuário não autorizado;
    
- ausência na coluna padrão;
    
- alteração sem interferência em outros dados.
    

### Item 16 — Dados complementares

**Resultado:** OK

Validado:

- apelido;
    
- telefone;
    
- WhatsApp;
    
- e-mail;
    
- nascimento;
    
- endereço;
    
- observações.
    

### Item 17 — Fechamento geral

**Resultado:** OK

Validado conjunto geral da Fase 1 e ausência de regressões visíveis.

---

## 35. Resultado final

**Funcionários — Fase 1: HOMOLOGADO**

Resultado:

**17/17 itens aprovados.**

Correções surgidas durante a homologação também foram implementadas e homologadas:

1. cargos livres administrativos e operacionais;
    
2. Gerente e Supervisor com possibilidade de comissão;
    
3. vínculo Funcionário ↔ Usuário disponível no frontend.
    

---

## 36. Fora do escopo e próximos desenvolvimentos relacionados

Ficam expressamente para etapas futuras:

### Planejamento/Ação de Vendas

- metas por loja;
    
- metas regionais;
    
- distribuição de metas por vendedor;
    
- faixas de comissão;
    
- bônus;
    
- campanhas;
    
- comissão por produto;
    
- comissão por grupo;
    
- comissão por coleção;
    
- regras específicas para Gerente;
    
- regras específicas para Supervisor;
    
- preservação da regra histórica aplicada à venda.
    

### Vendas

- autorizações de desconto;
    
- autorização de cancelamento;
    
- níveis de alçada;
    
- Gerente autorizador;
    
- Supervisor autorizador;
    
- workflows comerciais.
    

### RH/DP

Somente se o projeto futuramente decidir implementar:

- folha;
    
- férias;
    
- benefícios;
    
- ponto;
    
- documentos trabalhistas;
    
- obrigações de Departamento Pessoal.
    

---

## 37. Decisão consolidada

O cadastro de Funcionários do Sysvar deve permanecer simples, operacional e integrado aos demais módulos.

A arquitetura consolidada é:

**Empresa**  
→ possui **Funcionários**

**Funcionário**  
→ possui **Cargo**

**Funcionário**  
→ possui **Loja Principal**

**Funcionário Supervisor**  
→ pode possuir **Abrangência de Lojas**

**Funcionário**  
→ pode possuir **Comissão Básica**

**Funcionário**  
→ pode opcionalmente possuir **Usuário**

**Usuário**  
→ possui **Perfil e Permissões**

**Funcionário**  
→ participa de **Vendas e Operações**

**Histórico**  
→ preserva movimentações operacionais

**Audit Central**  
→ preserva rastreabilidade técnica e de segurança

Essa separação deve ser mantida nas próximas evoluções do Sysvar.

---

## 38. Status

**Status final:** HOMOLOGADO  
**Fase:** Funcionários — Fase 1  
**Homologação manual:** 17/17 OK  
**Data:** 12/08/2026