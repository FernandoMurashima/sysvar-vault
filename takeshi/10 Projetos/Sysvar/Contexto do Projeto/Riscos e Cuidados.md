---
type: reference
status: active
project: Sysvar
source: "C:/SysvarProjeto"
created: 2026-08-03
updated: 2026-08-14
tags:
  - sysvar
  - riscos
  - arquitetura
  - segurança
  - operacional
  - cadastros
  - produtos
  - produto-venda
  - produto-uso-consumo
  - insumos
  - cadastros-auxiliares
  - estoque
  - produção
  - auditoria
  - multiempresa
  - sessões
  - licenciamento
  - homologado
---

# Riscos e Cuidados

## Objetivo

Este documento reúne os principais riscos técnicos, funcionais e arquiteturais do [[Sysvar]].

Deve ser consultado durante:

- novas implementações;
- correções;
- refatorações;
- migrations;
- revisão de módulos;
- alterações de segurança;
- homologações;
- integrações;
- deploys.

Uma funcionalidade implementada e homologada continua sujeita a regressões.

Toda alteração em regra estrutural deve ser acompanhada de:

~~~text
ANÁLISE
↓
IMPLEMENTAÇÃO
↓
TESTES
↓
REVISÃO
↓
HOMOLOGAÇÃO
↓
DOCUMENTAÇÃO
~~~

---

# 1. Estado Atual

## Operacional

~~~text
IMPLEMENTADO
TESTADO
HOMOLOGADO
DOCUMENTADO
APROVADO
~~~

## Cadastros Prioritários

~~~text
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
~~~

## Produtos

~~~text
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

CADASTROS AUXILIARES
→ CONCLUÍDOS
→ HOMOLOGADOS
→ DOCUMENTADOS
~~~

---

# 2. Regra Geral de Segurança

Nunca considerar uma funcionalidade segura apenas porque funcionou no frontend.

Toda operação relevante deve ser validada novamente no backend.

Não confiar isoladamente em:

- JavaScript;
- LocalStorage;
- SessionStorage;
- query parameters;
- payload;
- URL;
- IDs enviados pelo cliente;
- campos ocultos;
- botões ocultos;
- menus ocultos;
- validações do formulário;
- informações mantidas no navegador.

Regra:

~~~text
FRONTEND
→ experiência

BACKEND
→ autoridade
~~~

---

# 3. Multiempresa

## 3.1 Empresa como limite de dados

Todo dado pertencente a cliente deve possuir contexto empresarial identificável.

O backend deve impedir que um usuário de uma Empresa consiga:

- listar dados de outra Empresa;
- consultar dados de outra Empresa;
- alterar dados de outra Empresa;
- excluir dados de outra Empresa;
- utilizar Estabelecimento de outra Empresa;
- utilizar Perfil de outra Empresa;
- utilizar Fornecedor de outra Empresa;
- utilizar Cliente de outra Empresa;
- utilizar Produto de outra Empresa;
- utilizar Grupo de outra Empresa;
- utilizar Grade de outra Empresa;
- utilizar Pack de outra Empresa;
- utilizar Insumo de outra Empresa;
- consultar sessões de outra Empresa;
- consultar Auditoria de outra Empresa;
- exportar dados de outra Empresa;
- vincular objetos de Empresas diferentes.

---

## 3.2 QuerySets

Todo QuerySet empresarial deve ser limitado pela Empresa do usuário ou por contexto administrativo global autorizado.

Evitar endpoints de usuário cliente baseados diretamente em:

~~~python
Model.objects.all()
~~~

sem aplicação garantida do tenant.

---

## 3.3 ForeignKeys

Mesmo com QuerySet filtrado, um usuário pode enviar manualmente um ID pertencente a outra Empresa.

Validar:

- Empresa do objeto principal;
- Empresa da ForeignKey;
- Empresa do Estabelecimento;
- Empresa do Perfil;
- Empresa do Usuário;
- Empresa do Cliente;
- Empresa do Fornecedor;
- Empresa do Produto;
- Empresa do Grupo;
- Empresa da Grade;
- Empresa do Pack;
- Empresa do Insumo.

Regra:

~~~text
MESMO ID VÁLIDO
não significa
MESMO TENANT VÁLIDO
~~~

---

# 4. Superusuário

O acesso global deve depender da regra oficial da plataforma.

Não transformar automaticamente qualquer `is_staff` em administrador global do SYSVAR.

Superusuário:

- possui sessão própria;
- não pertence a Empresa cliente;
- não consome licença de Empresa cliente;
- não deve aparecer consumindo licença da Empresa.

Não confundir:

~~~text
SUPERUSUÁRIO DA PLATAFORMA
!=
USUÁRIO MASTER DA EMPRESA
~~~

---

# 5. Estabelecimentos

## 5.1 Empresa obrigatória

Todo Estabelecimento pertence a uma Empresa.

Não voltar a permitir Estabelecimento empresarial sem Empresa.

Isso vale para:

- API;
- admin;
- command;
- import;
- migration;
- testes;
- scripts.

---

## 5.2 Contexto de Estabelecimento

Quando o domínio depender de Estabelecimento, validar:

- Empresa;
- acesso do Usuário;
- Estabelecimentos permitidos;
- Estabelecimento principal;
- contexto da sessão;
- objeto manipulado.

Não confiar apenas no seletor do frontend.

---

## 5.3 Eventos sem Estabelecimento

Nem toda operação pertence a um Estabelecimento.

Exemplos:

- contrato;
- Perfil;
- Permissão;
- suspensão da Empresa;
- configuração global.

Não inventar Estabelecimento para preencher Auditoria.

---

# 6. Contratos

Toda autenticação de Usuário cliente depende de contrato válido.

Validar:

- existência;
- status;
- vigência;
- Empresa;
- módulos;
- limite de sessões;
- Usuário master;
- suspensão;
- cancelamento.

Não reduzir os diferentes estados de contrato a um único booleano.

---

# 7. Suspensão Administrativa

Suspender Empresa é operação crítica.

Deve exigir:

- superusuário autorizado;
- motivo;
- confirmação;
- transação;
- encerramento das sessões;
- revogação dos tokens;
- Auditoria obrigatória.

Não permitir suspensão por simples edição genérica de `status`.

---

# 8. Atomicidade da Suspensão

Na mesma transação devem ocorrer, conforme arquitetura vigente:

1. alteração do contrato;
2. gravação do motivo;
3. encerramento das sessões;
4. revogação dos tokens;
5. liberação das vagas;
6. atualização das estruturas de acesso;
7. Auditoria obrigatória.

Não aceitar estado parcial.

---

# 9. Reativação da Empresa

Reativação não deve:

- reabrir sessão antiga;
- restaurar token revogado;
- reutilizar sessão encerrada;
- apagar histórico da suspensão.

Usuários devem realizar novo login.

---

# 10. Autenticação

Não criar autenticação paralela.

Toda autenticação deve considerar:

- credenciais;
- Usuário ativo;
- Empresa;
- contrato;
- Perfil;
- módulos;
- sessão;
- token;
- dispositivo;
- limite simultâneo;
- troca obrigatória de senha.

---

# 11. Tokens

Nunca registrar ou expor:

- token bruto;
- `Authorization`;
- cookie de autenticação;
- access token;
- refresh token;
- segredo;
- credencial temporária.

Token revogado ou sem sessão válida não autentica.

---

# 12. Sessões Simultâneas

Licença é consumida por:

~~~text
SESSÃO VÁLIDA
~~~

Não por:

- Usuário cadastrado;
- Usuário ativo;
- Perfil;
- Estabelecimento;
- dispositivo sem login.

Nunca retornar ao controle de licenças pela quantidade de Usuários ativos.

---

# 13. Fonte Única de Verdade das Sessões

Login, contador, disponibilidade, heartbeat e listagem devem utilizar a mesma regra central.

Não criar consulta paralela baseada somente em:

~~~python
SessaoUsuario.objects.filter(ativa=True)
~~~

Sessão marcada ativa pode já estar funcionalmente inválida.

---

# 14. Concorrência da Última Vaga

Contagem e criação da sessão devem permanecer no mesmo contexto transacional.

Não executar:

~~~text
contar
↓
encerrar transação
↓
criar sessão depois
~~~

Isso permite ultrapassar o limite contratado.

---

# 15. Login Bloqueado por Limite

Quando o limite for atingido:

- não criar sessão válida;
- não criar token utilizável;
- não aumentar contador;
- registrar evento adequado;
- frontend não deve assumir autenticação.

Código funcional:

~~~text
CONCURRENT_SESSION_LIMIT_REACHED
~~~

---

# 16. Mesmo Usuário e Mesmo Dispositivo

Regra homologada:

~~~text
mesmo Usuário
+
mesmo device_id
→ substituição da própria sessão anterior
~~~

Não consumir duas vagas para essa substituição.

---

# 17. Usuários Diferentes no Mesmo Dispositivo

Regra:

~~~text
Usuários diferentes
+
mesmo device_id
→ sessões independentes
~~~

Não encerrar sessão de outro Usuário apenas porque compartilha o dispositivo.

---

# 18. Timeout

Sessão abandonada não deve ocupar licença indefinidamente.

Timeout deve tratar:

- encerramento;
- token;
- liberação da vaga;
- motivo;
- Auditoria quando aplicável.

---

# 19. Heartbeat

Heartbeat não substitui validação normal de requisição.

Cada chamada autenticada continua sujeita à validação de:

- token;
- sessão;
- Usuário;
- Empresa;
- contrato;
- suspensão;
- troca obrigatória de senha.

---

# 20. Redução de Limite

A regra homologada não encerra automaticamente sessões válidas quando o limite contratado é reduzido abaixo da ocupação atual.

Nesse cenário:

~~~text
preservar sessões existentes
+
bloquear novos logins
~~~

até redução natural por:

- logout;
- timeout;
- encerramento administrativo.

---

# 21. Logout

Ordem correta no frontend:

1. manter o token;
2. chamar o backend;
3. aguardar resposta;
4. interromper heartbeat;
5. limpar contexto;
6. redirecionar.

Não remover o token antes da chamada de logout.

---

# 22. Administração de Sessões

Contador e listagem devem utilizar a mesma definição de sessão válida.

Regra:

~~~text
CONTADOR
=
QUANTIDADE DE SESSÕES VÁLIDAS EXIBIDAS
~~~

Não aplicar filtros adicionais no frontend que alterem essa definição.

---

# 23. Encerramento Administrativo

Encerrar sessão deve:

- validar Empresa;
- validar executor;
- validar Permissão;
- revogar token;
- liberar vaga;
- registrar motivo;
- auditar;
- atualizar contador e listagem.

Encerramento consolidado deve evitar duplicação desnecessária de eventos de Auditoria.

---

# 24. Diagnóstico e Reconciliação

Commands de diagnóstico não devem exibir token bruto.

Reconciliação deve:

- preservar histórico;
- encerrar sessões inválidas;
- revogar tokens;
- não apagar registros.

---

# 25. Usuários

Usuário cliente deve pertencer à Empresa correta.

Não permitir por payload comum:

- troca de Empresa;
- elevação a master;
- alteração de `is_superuser`;
- alteração de `is_staff`;
- alteração de grupos Django;
- alteração de Permissões internas;
- manipulação de token;
- manipulação de sessão.

---

# 26. Usuário Master

Master da Empresa não deve ser:

- excluído;
- inativado sem tratamento;
- movido de Empresa;
- rebaixado arbitrariamente;
- privado do acesso essencial.

Transferência de administração deve ocorrer pelo processo oficial.

---

# 27. Perfis e Permissões

Ausência de Permissão significa bloqueio.

Não conceder acesso apenas pelo nome do Perfil:

~~~text
Admin
Gerente
Diretor
Master
~~~

A autoridade é o cálculo de Permissão efetiva.

---

# 28. Roles Antigas

Não reintroduzir decisões de acesso baseadas exclusivamente em listas como:

~~~text
roles: ['Admin']
roles: ['Diretor', 'Gerente']
~~~

A arquitetura utiliza Permissões funcionais.

---

# 29. Perfil Padrão

A regra de Perfil padrão por Empresa deve continuar protegida contra concorrência e inconsistência.

Não confiar somente em restrição que o MySQL não garante.

---

# 30. Dependências de Módulos

Não permitir módulo dependente em:

~~~text
VIEW
ou
EDIT
~~~

quando uma dependência obrigatória estiver:

~~~text
NONE
~~~

A fonte das dependências é o backend.

---

# 31. Overrides

Valores conceituais:

~~~text
HERDAR
NONE
VIEW
EDIT
~~~

`HERDAR` representa ausência de override específico.

Não criar valores redundantes.

---

# 32. Redefinição Administrativa de Senha

Operação deve preservar:

- atomicidade;
- encerramento das sessões quando previsto;
- revogação de tokens;
- `deve_trocar_senha`;
- Auditoria.

Nunca registrar senha em Auditoria.

---

# 33. Troca Obrigatória de Senha

Quando:

~~~text
deve_trocar_senha = true
~~~

Usuário não deve acessar módulos normais.

Proteção deve existir no backend.

Não depender somente do Angular.

---

# 34. Auditoria Central

O app oficial é:

~~~text
auditoria
~~~

O serviço oficial é:

~~~text
AuditService
~~~

Não criar:

- tabela paralela;
- middleware paralelo;
- serviço paralelo;
- gravação manual espalhada sem necessidade.

---

# 35. Imutabilidade da Auditoria

Logs concluídos não devem ser tratados como cadastro editável.

Não permitir mecanismos que comprometam a imutabilidade histórica.

---

# 36. Auditoria e Transação

Eventos que representam sucesso não devem ser gravados antes da confirmação da operação.

Quando Auditoria for obrigatória para operação crítica:

~~~text
ALTERAÇÃO
+
AUDITORIA
=
MESMA GARANTIA TRANSACIONAL
~~~

---

# 37. Dados Sensíveis na Auditoria

Nunca registrar:

- senha;
- token;
- cookie;
- certificado;
- chave privada;
- segredo;
- hash de token;
- payload completo de autenticação.

---

# 38. Duplicidade de Auditoria

Uma única ação funcional não deve gerar eventos equivalentes desnecessariamente por:

- signal;
- serializer;
- view;
- service;
- wrapper legado.

---

# 39. Clientes

Status:

~~~text
HOMOLOGADO 23/23
~~~

Riscos específicos detalhados em:

- [[Homologação - Cadastros - Clientes]]
- [[Mapa Técnico - Cadastros - Clientes]]
- [[Workflows - Cadastros - Clientes]]
- [[Modelo de Domínio - Cadastros - Clientes]]
- [[Riscos e Cuidados - Cadastros - Clientes]]

---

# 40. Cliente — Multiempresa

Unicidade funcional do documento deve considerar Empresa.

~~~text
Empresa + documento
~~~

Não transformar documento em chave global entre todos os tenants.

---

# 41. Cliente sem Documento

Mais de um Cliente sem documento pode existir.

Não criar constraint que transforme:

~~~text
documento vazio
~~~

em falsa duplicidade.

---

# 42. Consumidor Final

Cada Empresa possui seu próprio Consumidor Final.

Não criar Consumidor Final global.

Não permitir no Cliente padrão:

- exclusão;
- inativação;
- bloqueio;
- mudança indevida de documento;
- mudança indevida de Tipo;
- remoção da condição de padrão.

---

# 43. Cliente Utilizado

Cliente com vínculos históricos não deve ser fisicamente removido.

Utilizar lifecycle adequado.

Não quebrar:

- vendas;
- fiscal;
- financeiro;
- histórico;
- indicadores.

---

# 44. Fornecedores

Status:

~~~text
HOMOLOGADO 30/30
~~~

Documentação específica deve continuar sendo referência para alterações.

---

# 45. Fornecedor — Categorias

Fornecedor pode possuir múltiplas categorias.

Categoria orienta contexto.

Não transformar categoria em bloqueio universal de processo sem regra formal daquele módulo.

---

# 46. Fornecedor — Dados Bancários

Dados bancários possuem proteção específica.

Usuário sem Permissão não deve receber valores sensíveis nem por chamada direta à API.

Ocultar campo visualmente não é suficiente.

---

# 47. Fornecedor Utilizado

Fornecedor com vínculos em:

- Compras;
- Financeiro;
- Fiscal;
- documentos;

deve ser preservado.

Preferir Inativação a exclusão destrutiva.

---

# 48. Funcionários

Status:

~~~text
HOMOLOGADO 17/17
~~~

Separações fundamentais:

~~~text
Funcionário != Usuário
Cargo != Perfil
Cargo != Permissão
Loja supervisionada != Loja permitida
Situação do Funcionário != User.is_active
FuncionarioHistorico != AuditLog
~~~

---

# 49. Funcionário e Usuário

Vínculo com Usuário não deve alterar automaticamente:

- Cargo;
- Perfil;
- Permissões;
- Lojas permitidas;
- sessões.

---

# 50. Funcionário e Cargo

Cargo é entidade operacional.

Não utilizar Cargo como mecanismo automático de autorização.

~~~text
Cargo
!=
Permissão
~~~

---

# 51. Funcionário e Situação

Estados:

~~~text
ATIVO
AFASTADO
DESLIGADO
~~~

Não mapear diretamente esses estados para `User.is_active`.

---

# 52. Funcionário Utilizado

Funcionário utilizado em operações deve ser preservado.

Não excluir vendedor histórico de uma Venda para limpar cadastro.

---

# 53. Produtos — Separação dos Tipos

A entidade Produto atende domínios diferentes:

~~~text
1 = Revenda
2 = Uso/Consumo
3 = Fabricação Própria
4 = Insumo
~~~

Risco crítico:

aplicar uma regra de um tipo a todos os Produtos.

---

# 54. Produto Venda

Tipos:

~~~text
1 = Revenda
3 = Fabricação Própria
~~~

Documentação específica:

- [[Homologação - Produtos - Produto Venda]]
- [[Mapa Técnico - Produtos - Produto Venda]]
- [[Workflows - Produtos - Produto Venda]]
- [[Modelo de Domínio - Produtos - Produto Venda]]
- [[Riscos e Cuidados - Produtos - Produto Venda]]

---

# 55. Tipo de Produto Venda Imutável

Não converter:

~~~text
Revenda
→ Fabricação Própria
~~~

nem:

~~~text
Fabricação Própria
→ Revenda
~~~

após criação.

Isso pode comprometer:

- histórico;
- Compras;
- Produção;
- Estoque;
- custos.

---

# 56. Referência de Produto Venda

Formato:

~~~text
AA-BB-CCDDD
~~~

Onde:

~~~text
AA = ano da Coleção
BB = Estação
CC = CodigoRef do Grupo
DDD = sequência
~~~

Não regenerar Referências históricas por alteração posterior de Grupo ou Coleção.

---

# 57. Produto versus SKU

Separação obrigatória:

~~~text
Produto != SKU
~~~

SKU representa:

~~~text
Produto + Cor + Tamanho
~~~

Não armazenar Estoque comercial granular apenas no Produto.

---

# 58. Grade de Produto Venda

Grade é estrutural para os SKUs.

Após existirem SKUs:

~~~text
GRADE IMUTÁVEL
~~~

Não permitir mudança apenas porque o frontend disponibilizou o campo.

A proteção deve existir no backend.

---

# 59. Remoção de Cor

Regra homologada:

~~~text
REMOVER COR
→ INATIVAR SKUs
→ NÃO EXCLUIR
~~~

Preservar:

- ID;
- Cor;
- Tamanho;
- EAN;
- Estoque;
- histórico.

---

# 60. Última Cor

A retirada da última Cor é permitida.

Resultado:

~~~text
todos os SKUs correspondentes
→ INATIVOS
~~~

Produto permanece cadastrado.

---

# 61. Reativação de Cor

Ao reincluir Cor:

~~~text
localizar SKU anterior
→ reativar
→ preservar ID
→ preservar EAN
~~~

Não criar SKU duplicado.

---

# 62. EAN

EAN pertence ao SKU.

Regras:

- gerado no backend;
- único;
- preservado;
- não reciclado;
- reativação não gera novo EAN.

---

# 63. Estoque de Produto Venda

Granularidade:

~~~text
Loja × SKU
~~~

Não substituir por saldo global de Produto.

Inicialização em zero não representa entrada física.

---

# 64. Disponível

Conceito:

~~~text
Disponível = Físico - Reserva
~~~

Produto pode apresentar essa informação.

Movimentações e reservas pertencem ao domínio de Estoque/Vendas.

---

# 65. Custos de Produto Venda

Para Revenda:

~~~text
Compra
→ Recebimento
→ Estoque
→ Custos
~~~

Para Fabricação Própria:

~~~text
Ficha Técnica
→ Produção
→ Custos
~~~

Não criar atualização arbitrária de custo no cadastro.

---

# 66. Fiscal de Produto Venda

Alterações fiscais devem respeitar:

- validação;
- rastreabilidade;
- Histórico Funcional quando aplicável;
- Auditoria.

Não ocultar silenciosamente campos fiscais já existentes na interface.

---

# 67. ProdutoVendaHistorico versus AuditLog

~~~text
ProdutoVendaHistorico
→ visão funcional

AuditLog
→ Auditoria Central
~~~

Não substituir uma estrutura pela outra.

---

# 68. Imagens

Produto Venda permite:

~~~text
0..3 imagens
~~~

Regras:

- opcionais;
- máximo três;
- somente uma principal;
- pertencem ao Produto;
- não pertencem à Cor;
- não pertencem ao SKU.

Não inventar parâmetros técnicos de miniatura ainda não definidos.

---

# 69. Lifecycle de Produto Venda

Estado cadastral:

~~~text
ATIVO
INATIVO
~~~

Estado comercial independente:

~~~text
LIBERADO
BLOQUEADO
~~~

Portanto:

~~~text
ATIVO
!=
LIBERADO PARA VENDA
~~~

---

# 70. Exclusão de Produto Venda

Produto utilizado deve ser preservado.

Alternativas:

- Inativar;
- Bloquear Venda.

Não transformar lifecycle em exclusão física.

---

# 71. Permissões de Produto Venda

Ações sensíveis devem utilizar Permissão funcional do SYSVAR.

Não retornar a regras baseadas somente em:

~~~text
is_staff
~~~

Quando motivo e senha forem exigidos, continuam requisitos independentes.

---

# 72. Produto Uso/Consumo

Tipo:

~~~text
tipo_produto = '2'
~~~

Documentação:

- [[Homologação - Produtos - Produto Uso e Consumo]]
- [[Mapa Técnico - Produtos - Produto Uso e Consumo]]
- [[Workflows - Produtos - Produto Uso e Consumo]]
- [[Modelo de Domínio - Produtos - Produto Uso e Consumo]]
- [[Riscos e Cuidados - Produtos - Produto Uso e Consumo]]

---

# 73. Uso/Consumo não é Produto Venda

Não adicionar automaticamente:

- Grade;
- Tamanho comercial;
- Cor × Tamanho;
- SKU comercial;
- Coleção;
- Tabela de Preço;
- Promoção;
- Bloqueio de Venda.

---

# 74. Uso/Consumo não é Insumo

Separação:

~~~text
Uso/Consumo
→ utilização interna não produtiva

Insumo
→ componente da fabricação
~~~

Não disponibilizar tipo 2 em Ficha Técnica apenas porque possui Estoque.

---

# 75. Uso/Consumo e Estoque

Produto Uso/Consumo possui natureza de Estoque.

Não existe regra homologada:

~~~text
controla_estoque = Sim/Não
~~~

Não reintroduzir esse campo.

---

# 76. Uso/Consumo e Localização

Cadastro não define localização fixa.

Não reintroduzir:

~~~text
Uso/Consumo
→ somente Matriz
~~~

A localização pertence à operação.

---

# 77. Uso/Consumo e Fiscal

NCM pode ser opcional no cadastro conforme a regra homologada.

Situação:

~~~text
Fiscal Completo
Fiscal Incompleto
~~~

Fiscal Incompleto não significa Produto cadastralmente inválido.

A operação fiscal valida o necessário.

---

# 78. Uso/Consumo no PDV

Tipo 2 não deve aparecer como Produto normal de venda.

Proteção deve existir no backend dos processos comerciais.

---

# 79. Uso/Consumo e Custos

Custos devem ser provenientes de eventos reais.

Não preencher valores artificiais apenas para completar a consulta.

---

# 80. Insumos

Tipo:

~~~text
tipo_produto = '4'
~~~

Documentação:

- [[Homologação - Produtos - Insumos]]
- [[Mapa Técnico - Produtos - Insumos]]
- [[Workflows - Produtos - Insumos]]
- [[Modelo de Domínio - Produtos - Insumos]]
- [[Riscos e Cuidados - Produtos - Insumos]]

---

# 81. Insumo não é Uso/Consumo

Não misturar:

~~~text
consumo administrativo
~~~

com:

~~~text
consumo produtivo
~~~

A Ficha Técnica utiliza Insumos.

---

# 82. Material Opcional

Material permanece opcional para Insumos.

Não transformar essa classificação em campo obrigatório sem nova decisão funcional.

---

# 83. Material não é Insumo

~~~text
Material
→ classificação

Insumo
→ item operacional
~~~

Não movimentar Material diretamente em:

- Compras;
- Estoque;
- Ficha Técnica;
- Produção.

---

# 84. Unidade dos Insumos

Processos devem respeitar:

~~~text
permite_decimal
~~~

Exemplo:

~~~text
Tecido
1,75 M
~~~

Não arredondar arbitrariamente quantidades produtivas.

---

# 85. Insumos e Estoque

Não existe campo homologado:

~~~text
controla_estoque
~~~

Não fixar localização no cadastro.

Material pode estar:

- fábrica;
- almoxarifado;
- outro Estabelecimento;
- futuramente em poder de terceiro.

Essa informação é operacional.

---

# 86. Ficha Técnica

Quantidade necessária pertence à relação:

~~~text
Ficha Técnica × Insumo
~~~

Não ao cadastro principal do Insumo.

O mesmo Insumo pode ser utilizado em vários Produtos com quantidades diferentes.

---

# 87. Ordem de Produção e Baixa

Não presumir:

~~~text
CRIAR OP
=
BAIXAR INSUMOS
~~~

Essa regra não foi homologada.

---

# 88. Ordem de Produção e Reserva

Também não presumir:

~~~text
CRIAR OP
=
RESERVAR INSUMOS
~~~

Reserva deverá ser definida no processo de Produção/Estoque.

---

# 89. Previsto versus Real

Separação:

~~~text
Ficha Técnica
→ consumo previsto

Produção
→ consumo real
~~~

Misturar os conceitos compromete:

- Estoque;
- custos;
- perdas;
- produtividade.

---

# 90. Facção

Fluxos futuros com facção devem controlar materiais por movimentos.

Não criar campo fixo no Insumo como:

~~~text
faccao_atual
~~~

para representar localização transitória.

---

# 91. Cadastros Auxiliares de Produtos

Documentação:

- [[Homologação - Produtos - Cadastros Auxiliares]]
- [[Mapa Técnico - Produtos - Cadastros Auxiliares]]
- [[Workflows - Produtos - Cadastros Auxiliares]]
- [[Modelo de Domínio - Produtos - Cadastros Auxiliares]]
- [[Riscos e Cuidados - Produtos - Cadastros Auxiliares]]

---

# 92. Grupo — Código de Referência

Formato:

~~~text
2 dígitos numéricos
~~~

Deve ser único por Empresa.

Não aceitar:

~~~text
1
001
AB
A1
~~~

---

# 93. Alteração do CodigoRef

CodigoRef participa da Referência do Produto Venda.

Não fazer:

~~~text
Grupo alterado
↓
regenerar Referências históricas
~~~

---

# 94. Subgrupo

Subgrupo pertence ao Grupo.

Não criar Subgrupo órfão.

Não associar Grupo e Subgrupo de Empresas diferentes.

---

# 95. Grade

Grade possui Tamanhos.

Alterações em Grade já utilizada podem afetar:

- Produto;
- SKU;
- Pack.

Proteger integridade.

---

# 96. Tamanho

Tamanho pertence a Grade.

Não mover arbitrariamente Tamanho já utilizado para outra Grade.

---

# 97. Coleção

Valores de Estação homologados:

~~~text
01
02
03
04
~~~

Status:

~~~text
CR
PD
AT
EN
AR
~~~

Não criar novos estados silenciosamente.

---

# 98. Contador da Coleção

O contador é interno.

Não disponibilizar edição manual.

Manipulação do contador pode provocar colisão de Referência.

---

# 99. Unidade

Código deve possuir unicidade.

Não alterar Unidade já utilizada sem avaliar impacto histórico.

Exemplo:

~~~text
100 M
~~~

não pode passar a significar:

~~~text
100 KG
~~~

por simples alteração cadastral.

---

# 100. Cor

Cor utilizada por SKU deve ser preservada historicamente.

Não excluir de modo que o SKU fique sem referência.

---

# 101. Material

Material utilizado deve preservar relacionamentos existentes.

Lifecycle Ativo/Inativo não deve destruir histórico.

---

# 102. Pack

Pack deve possuir Grade.

Item do Pack:

~~~text
Pack + Tamanho + Quantidade
~~~

Regras:

~~~text
Tamanho pertence à Grade

Tamanho não repete no mesmo Pack

Quantidade > 0
~~~

---

# 103. Pack Histórico

Alteração posterior do Pack não deve recalcular Pedido já gravado.

Regra:

~~~text
CONFIGURAÇÃO ATUAL
!=
OPERAÇÃO HISTÓRICA
~~~

---

# 104. Exclusão de Cadastros Auxiliares

Antes de excluir, verificar dependências.

Exemplos:

- Grupo usado por Produto;
- Subgrupo usado;
- Grade usada;
- Tamanho usado;
- Coleção usada;
- Unidade usada;
- Cor usada;
- Material usado;
- Pack usado em Pedido.

---

# 105. Padrão Visual dos Auxiliares

O padrão homologado utiliza:

~~~text
Checkbox
+
Seleção única
+
Linha destacada
+
Barra de ações
~~~

Não reintroduzir nas telas já modernizadas:

~~~text
Coluna Ações
+
Menu ⋮
~~~

sem nova decisão de padrão.

---

# 106. Master-Detail

Estruturas:

~~~text
Grupo
→ Subgrupos

Grade
→ Tamanhos

Pack
→ Itens
~~~

O detalhe deve permanecer no contexto do mestre correto.

---

# 107. Sobretelas

Consulta e detalhes que utilizam modal devem preservar o contexto da tela de origem.

Não transformar novamente consultas simples em navegação desnecessária para outra tela sem decisão de UX.

---

# 108. Paginação

Não carregar milhares de registros para paginar apenas no navegador.

Listagens homologadas devem continuar utilizando paginação server-side quando definido.

Preservar:

~~~text
Mostrando X–Y de Z
~~~

---

# 109. Filtros

Filtros server-side devem considerar:

- Empresa;
- domínio;
- tipo do Produto;
- critérios informados;
- ordenação.

Não filtrar apenas a página atualmente carregada.

---

# 110. Indicadores

Indicadores não devem ser calculados apenas sobre a página visível.

Devem respeitar o conjunto correspondente do backend.

---

# 111. Cache e Estado Local

Após operações que alteram dados relevantes, recarregar o necessário.

Cuidado com:

- `shareReplay`;
- objetos antigos em memória;
- filtros locais;
- indicadores calculados sobre resposta antiga;
- snapshots da linha.

---

# 112. Consulta por ID

Quando existir endpoint de detalhe:

~~~text
seleção
→ ID
→ backend
→ dado atual
~~~

é preferível a abrir consulta com snapshot potencialmente desatualizado da listagem.

---

# 113. Edição por ID

O mesmo princípio se aplica à edição.

Não editar dados críticos baseando-se apenas no objeto armazenado anteriormente na tabela.

---

# 114. Banco de Dados

Toda alteração estrutural deve possuir migration.

Não editar migration já aplicada em produção.

---

# 115. Data Migrations

Utilizar o model histórico fornecido pelo mecanismo de migrations.

Não presumir estrutura atual sobre banco antigo.

Considerar:

- banco vazio;
- banco com dados;
- MySQL;
- registros nulos;
- volume;
- rollback;
- dados ambíguos.

---

# 116. Saneamento de Dados

Nunca atribuir Empresa arbitrariamente para corrigir registro ambíguo.

Não usar automaticamente:

- primeira Empresa;
- Empresa mais antiga;
- Empresa do superusuário;
- Empresa padrão inventada.

Quando não houver fonte segura, interromper e analisar.

---

# 117. Constraints e MySQL

Antes de depender de constraint específica:

- confirmar suporte;
- verificar migrations;
- observar warnings;
- testar contra MySQL.

Não assumir comportamento idêntico entre SQLite e MySQL.

---

# 118. Mudanças em Models Compartilhados

`Produto` atende vários domínios.

Alterar campo, serializer ou regra compartilhada pode afetar:

~~~text
tipo 1
tipo 2
tipo 3
tipo 4
~~~

Antes da mudança, revisar todos os consumidores.

---

# 119. Performance

Evitar:

- N+1;
- QuerySets globais;
- consultas sem índice;
- paginação local;
- payload excessivo;
- filtros desnecessários em memória.

Utilizar quando apropriado:

- `select_related`;
- `prefetch_related`;
- índices;
- agregações;
- paginação;
- endpoints próprios para indicadores.

---

# 120. Frontend — Permissão Visual

Frontend deve esconder ações sem autorização.

Entretanto:

~~~text
BOTÃO OCULTO
!=
SEGURANÇA
~~~

Backend deve continuar bloqueando ação direta.

---

# 121. 401 e 403

Não tratar toda resposta `403` como logout automático.

Pode representar:

- falta de Permissão;
- contrato suspenso;
- troca obrigatória;
- Empresa incorreta;
- contexto inválido.

Interpretar o código funcional retornado.

---

# 122. Separação de Responsabilidades

Regra transversal:

~~~text
CADASTRO
→ identidade e parâmetros

COMPRAS
→ aquisição

ESTOQUE
→ quantidade e localização

FISCAL
→ aplicação tributária

PRODUÇÃO
→ transformação e consumo produtivo

PDV
→ venda

AUDITORIA
→ rastreabilidade
~~~

Evitar absorção indevida de responsabilidades entre módulos.

---

# 123. Compras e Produtos

Produto fornece identidade.

Compras define:

- Fornecedor;
- Pedido;
- quantidade;
- preço;
- aprovação;
- recebimento;
- parcelas;
- Financeiro.

Não implementar Compra dentro do cadastro de Produto.

---

# 124. Estoque e Produtos

Separação:

~~~text
Produto
→ o que é

Estoque
→ quanto existe e onde está
~~~

Não armazenar localização operacional como atributo fixo do Produto quando o domínio não exige isso.

---

# 125. Fiscal e Produtos

Produto armazena dados fiscais cadastrais.

O módulo Fiscal é responsável pela aplicação desses dados nos eventos fiscais.

Não confundir:

~~~text
cadastro fiscal
~~~

com:

~~~text
operação fiscal
~~~

---

# 126. Produção

Produto Venda tipo 3 representa o Produto acabado.

Insumo tipo 4 representa componente produtivo.

~~~text
Produto Venda tipo 3
        ↓
Ficha Técnica
        ↓
Insumo tipo 4
        ↓
Produção
~~~

Uso/Consumo tipo 2 não deve entrar automaticamente nesse fluxo.

---

# 127. Testes

Correção localizada:

- testes específicos;
- verificação técnica necessária;
- homologação manual.

Checkpoint estrutural:

- testes mais amplos;
- build;
- regressão relevante.

Não executar suítes enormes sem necessidade apenas como ritual.

Não deixar de executar testes essenciais quando o risco justificar.

---

# 128. Homologação

Uma feature não é considerada concluída apenas porque:

~~~text
compila
~~~

ou:

~~~text
teste automatizado passou
~~~

Quando a interface e regra operacional são relevantes, a homologação manual continua necessária.

---

# 129. Documentação

Após fechamento de escopo:

- atualizar documento específico;
- atualizar links;
- atualizar documentos centrais quando necessário;
- preservar nomenclatura;
- não criar documentos órfãos.

---

# 130. Obsidian

Alteração de nome de arquivo exige atenção aos links.

Documentos atuais de Produtos:

## Produto Venda

- [[Homologação - Produtos - Produto Venda]]
- [[Mapa Técnico - Produtos - Produto Venda]]
- [[Workflows - Produtos - Produto Venda]]
- [[Modelo de Domínio - Produtos - Produto Venda]]
- [[Riscos e Cuidados - Produtos - Produto Venda]]

## Produto Uso/Consumo

- [[Homologação - Produtos - Produto Uso e Consumo]]
- [[Mapa Técnico - Produtos - Produto Uso e Consumo]]
- [[Workflows - Produtos - Produto Uso e Consumo]]
- [[Modelo de Domínio - Produtos - Produto Uso e Consumo]]
- [[Riscos e Cuidados - Produtos - Produto Uso e Consumo]]

## Insumos

- [[Homologação - Produtos - Insumos]]
- [[Mapa Técnico - Produtos - Insumos]]
- [[Workflows - Produtos - Insumos]]
- [[Modelo de Domínio - Produtos - Insumos]]
- [[Riscos e Cuidados - Produtos - Insumos]]

## Cadastros Auxiliares

- [[Homologação - Produtos - Cadastros Auxiliares]]
- [[Mapa Técnico - Produtos - Cadastros Auxiliares]]
- [[Workflows - Produtos - Cadastros Auxiliares]]
- [[Modelo de Domínio - Produtos - Cadastros Auxiliares]]
- [[Riscos e Cuidados - Produtos - Cadastros Auxiliares]]

---

# 131. Riscos Ainda Abertos

## Licenciamento

Alterações futuras podem reintroduzir:

- contagem por `ativa=True`;
- logout sem token;
- sessão bloqueada criada;
- superusuário associado a Empresa;
- divergência entre contador e listagem.

---

## Campos Legados de Loja

Campos legados ainda devem ser tratados com cautela antes de eventual remoção.

Não remover sem análise de consumidores e migration.

---

## Tipos Funcionais Antigos

Campos antigos de classificação de Usuário não devem voltar a funcionar como fonte principal de Permissão.

---

## Automação de Suspensão

Suspensão automática por cobrança não pertence à fase homologada atual.

Qualquer automação futura exige projeto próprio.

---

## Recuperação Pública de Senha

Ainda necessita desenho próprio caso seja implementada.

Deve considerar:

- token temporário;
- expiração;
- prevenção de abuso;
- Auditoria;
- proteção de informações.

---

## Retenção da Auditoria

A política de retenção e crescimento precisa continuar sendo observada conforme o volume do sistema aumentar.

---

## Backups

Backup precisa possuir:

- frequência;
- retenção;
- cópia externa;
- proteção adequada;
- teste de restauração;
- monitoramento.

Backup que nunca foi restaurado em teste não comprova recuperabilidade.

---

## Imagens de Produto Venda

Continuam sem definição homologada:

- largura;
- altura;
- resolução;
- formato;
- compressão;
- qualidade da miniatura.

Não inventar parâmetros.

---

## Produção e Consumo de Insumos

Ainda não estão definidos dentro do cadastro de Insumos:

- momento de reserva;
- momento de baixa;
- consumo real;
- perda;
- sobra;
- retorno;
- materiais em facção;
- conversão avançada de Unidade;
- MRP.

Essas regras devem ser definidas no módulo Produção.

---

# 132. Riscos de Regressão do Grupo Produtos

Não reintroduzir:

1. mistura entre tipos 1, 2, 3 e 4;
2. Grade para Uso/Consumo;
3. Grade comercial automática para Insumo;
4. Uso/Consumo no PDV;
5. Insumo no PDV;
6. Uso/Consumo em Ficha Técnica;
7. `controla_estoque` em Uso/Consumo;
8. `controla_estoque` em Insumos;
9. Matriz obrigatória para Uso/Consumo;
10. localização fixa de Insumo;
11. baixa de Insumo ao criar OP;
12. reserva automática ao criar OP;
13. Material obrigatório para Insumos;
14. exclusão de Produto utilizado;
15. reciclagem de EAN;
16. recriação de SKU em vez de reativação;
17. alteração de Grade após SKU;
18. Reference histórica recalculada;
19. Pack histórico reinterpretado;
20. ações por linha redundantes nos auxiliares já padronizados.

---

# 133. Checklist antes de Alterar Produto

Verificar:

1. qual tipo de Produto será afetado?
2. a regra deve valer para tipos 1, 2, 3 e 4?
3. Empresa continua protegida?
4. lifecycle continua coerente?
5. exclusão continua protegida?
6. Estoque continua separado do cadastro?
7. Fiscal continua separado da operação?
8. algum módulo consumidor será afetado?
9. existem migrations?
10. existem dados legados?

---

# 134. Checklist antes de Alterar Estoque

Verificar:

1. Produto correto?
2. SKU correto quando aplicável?
3. Empresa correta?
4. Estabelecimento/local correto?
5. Unidade correta?
6. movimento existe?
7. saldo resulta de movimentos?
8. existe risco de baixa duplicada?
9. reserva é distinta de saída?
10. histórico será preservado?

---

# 135. Checklist antes de Alterar Produção

Verificar:

1. Produto acabado é tipo 3?
2. componentes são Insumos válidos?
3. Ficha Técnica pertence à Empresa correta?
4. Unidade é compatível?
5. consumo previsto está separado do real?
6. criar OP provoca algum movimento?
7. esse movimento foi realmente aprovado?
8. reserva foi definida?
9. perda foi definida?
10. facção foi modelada adequadamente?

---

# 136. Checklist antes de Alterar Cadastros Auxiliares

Verificar:

1. registro já está em uso?
2. mudança altera significado histórico?
3. unicidade continua válida?
4. relação mestre-detalhe continua válida?
5. cross-tenant continua bloqueado?
6. exclusão continua protegida?
7. Produto consumidor será afetado?
8. padrão visual homologado foi preservado?

---

# 137. Checklist antes de Migration

Verificar:

1. migration é necessária?
2. banco possui dados?
3. MySQL suporta a mudança?
4. valores antigos são compatíveis?
5. há `null` legado?
6. existe constraint nova?
7. dados precisam de saneamento?
8. rollback é possível?
9. outros tipos do model compartilhado serão afetados?
10. testes foram executados?

---

# 138. Estado Consolidado dos Riscos

Os riscos centrais atualmente protegidos incluem:

- tenant;
- sessões;
- licenciamento;
- contratos;
- Permissões;
- Auditoria;
- Clientes;
- Fornecedores;
- Funcionários;
- Produto Venda;
- Produto Uso/Consumo;
- Insumos;
- Cadastros Auxiliares;
- Estoque;
- Fiscal;
- integrações futuras com Produção.

A existência de documentação específica não elimina a necessidade de consultar este documento central.

---

# 139. Regra de Continuidade

Antes de nova implementação:

~~~text
DEFINIR REGRA FUNCIONAL
        ↓
ANALISAR CÓDIGO ATUAL
        ↓
LOCALIZAR IMPACTO
        ↓
IMPLEMENTAR SOMENTE O NECESSÁRIO
        ↓
TESTAR
        ↓
REVISAR
        ↓
HOMOLOGAR
        ↓
DOCUMENTAR
~~~

Não antecipar arquitetura de módulos ainda não definidos.

---

# 140. Última Atualização

~~~text
14/08/2026
~~~

Marco atual:

~~~text
OPERACIONAL
→ CONCLUÍDO

CLIENTES
→ CONCLUÍDO

FORNECEDORES
→ CONCLUÍDO

FUNCIONÁRIOS
→ CONCLUÍDO

PRODUTO VENDA
→ CONCLUÍDO

PRODUTO USO/CONSUMO
→ CONCLUÍDO

INSUMOS
→ CONCLUÍDO

CADASTROS AUXILIARES DE PRODUTOS
→ CONCLUÍDOS
~~~

---

# 141. Notas Relacionadas

## Contexto Central

- [[10 Projetos/Sysvar/Sysvar|Sysvar]]
- [[10 Projetos/Sysvar/Contexto do Projeto/Visão Geral|Visão Geral]]
- [[10 Projetos/Sysvar/Contexto do Projeto/Arquitetura|Arquitetura]]
- [[10 Projetos/Sysvar/Contexto do Projeto/Modelo de Domínio|Modelo de Domínio]]
- [[10 Projetos/Sysvar/Contexto do Projeto/Workflows|Workflows]]
- [[10 Projetos/Sysvar/Contexto do Projeto/Mapa Técnico|Mapa Técnico]]

## Decisões Técnicas

- [[10 Projetos/Sysvar/Decisões Técnicas/ADR-001 - Licenciamento por Sessões Simultâneas|ADR-001 - Licenciamento por Sessões Simultâneas]]
- [[10 Projetos/Sysvar/Decisões Técnicas/ADR-002 - Princípios Arquiteturais do SISVAR|ADR-002 - Princípios Arquiteturais do SISVAR]]
- [[10 Projetos/Sysvar/Decisões Técnicas/ADR-003 - Auditoria Central do SISVAR|ADR-003 - Auditoria Central do SISVAR]]

## Produtos

- [[Homologação - Produtos - Produto Venda]]
- [[Riscos e Cuidados - Produtos - Produto Venda]]
- [[Homologação - Produtos - Produto Uso e Consumo]]
- [[Riscos e Cuidados - Produtos - Produto Uso e Consumo]]
- [[Homologação - Produtos - Insumos]]
- [[Riscos e Cuidados - Produtos - Insumos]]
- [[Homologação - Produtos - Cadastros Auxiliares]]
- [[Riscos e Cuidados - Produtos - Cadastros Auxiliares]]