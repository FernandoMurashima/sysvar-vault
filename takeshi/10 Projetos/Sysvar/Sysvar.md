---
type: project
status: active
project: Sysvar
source: "C:/SysvarProjeto"
created: 2026-08-03
updated: 2026-08-06
tags:
  - projeto
  - sysvar
  - homologado
  - operacional
  - cadastros
  - clientes
  - auditoria
  - multiempresa
---

# Sysvar

## O que é

O Sysvar é um ERP SaaS para o varejo e a indústria de moda, desenvolvido com backend Django REST Framework, frontend Angular 17 e banco de dados MySQL.

O sistema foi concebido para atender empresas com uma ou múltiplas lojas, estoque central, produção própria, facções, distribuição, compras, vendas, financeiro, fiscal, contabilidade, auditoria e BI.

---

# Objetivo

Centralizar toda a operação da empresa em uma única plataforma, mantendo:

- isolamento entre empresas;
- controle por estabelecimentos;
- segurança baseada em perfis e permissões;
- auditoria completa;
- arquitetura preparada para crescimento modular;
- integridade entre os módulos;
- rastreabilidade das operações;
- experiência visual padronizada;
- regras de negócio validadas no backend.

---

# Tecnologias Principais

## Backend

- Python;
- Django;
- Django REST Framework;
- MySQL.

## Frontend

- Angular 17 Standalone;
- TypeScript.

## Infraestrutura e Versionamento

- Git;
- GitHub;
- Ubuntu Server;
- Docker;
- Nginx Proxy Manager;
- Portainer;
- Uptime Kuma.

## Documentação

- Obsidian;
- Markdown;
- repositório Git dedicado ao vault.

---

# Áreas Principais

## Operacional

- Empresas;
- Contratos;
- Estabelecimentos;
- Usuários;
- Perfis;
- Permissões;
- Sessões;
- Licenciamento;
- Auditoria.

## Cadastros

- Clientes;
- Fornecedores;
- Funcionários;
- Lojas;
- Naturezas de lançamento;
- Formas de pagamento;
- demais cadastros auxiliares.

## Produtos

- Produtos de revenda;
- produtos de uso e consumo;
- SKUs;
- cores;
- tamanhos;
- grades;
- packs;
- coleções;
- grupos;
- subgrupos;
- NCM;
- unidades;
- tabelas de preço.

## Compras

- pedidos de compra;
- pedidos de revenda;
- pedidos de uso e consumo;
- aprovação;
- cancelamento;
- parcelas;
- integração financeira;
- entrada de nota fiscal.

## Fiscal

- vendas;
- NFC-e;
- devoluções;
- documentos fiscais;
- impostos;
- regras tributárias.

## Estoque

- entradas;
- saídas;
- transferências;
- saldos;
- estoque por empresa;
- estoque por estabelecimento;
- estoque por SKU.

## Distribuição

- fábrica para lojas;
- distribuição manual;
- distribuição percentual;
- perfis de distribuição;
- distribuição por grade;
- distribuição de produto próprio;
- distribuição de produto de revenda.

## Produção

- ficha técnica;
- ordem de produção;
- facção;
- matéria-prima;
- retorno de produção;
- custo de produção.

## Vendas e PDV

- abertura de caixa;
- fechamento de caixa;
- vendas;
- pagamentos;
- clientes;
- descontos;
- NFC-e;
- operação online;
- futura operação offline.

## Financeiro

- contas a pagar;
- contas a receber;
- formas de pagamento;
- parcelas;
- rateios;
- plano financeiro;
- natureza de lançamento.

## Relatórios e Dashboards

- vendas;
- estoque;
- compras;
- financeiro;
- indicadores comerciais;
- acompanhamento gerencial.

---

# Fonte do Projeto

Código-fonte:

~~~text
C:\SysvarProjeto
~~~

Backend:

~~~text
C:\SysvarProjeto\Backend
~~~

Frontend:

~~~text
C:\SysvarProjeto\Frontend\sysvar
~~~

Documentação no projeto:

~~~text
C:\SysvarProjeto\docs
~~~

Vault do Obsidian:

~~~text
C:\takeshi\takeshi
~~~

---

# Repositórios

Backend:

~~~text
FernandoMurashima/sysvarbackend
~~~

Frontend:

~~~text
FernandoMurashima/sysvarfrontend
~~~

Vault:

~~~text
FernandoMurashima/sysvar-vault
~~~

Branch principal:

~~~text
main
~~~

---

# Situação Geral Atual

## Infraestrutura Estrutural

Status:

~~~text
IMPLEMENTADA
TESTADA
EM EVOLUÇÃO CONTROLADA
~~~

Inclui:

- autenticação;
- isolamento multiempresa;
- isolamento por estabelecimento;
- contratos;
- módulos contratados;
- usuário master;
- superusuário da plataforma;
- perfis;
- permissões efetivas;
- overrides;
- heartbeat;
- tokens;
- sessões;
- timeout;
- device ID;
- licenciamento simultâneo;
- Auditoria Central;
- proteção de troca obrigatória de senha.

---

# Grupo Operacional

Status:

~~~text
CONCLUÍDO
TESTADO AUTOMATICAMENTE
HOMOLOGADO MANUALMENTE
DOCUMENTADO
APROVADO
~~~

Itens concluídos:

- Empresas;
- Contratos;
- Módulos contratados;
- Suspensão;
- Reativação;
- Estabelecimentos;
- Usuários;
- Perfis;
- Permissões;
- Overrides;
- Sessões;
- Tokens;
- Administração de sessões;
- Diagnóstico de sessões;
- Reconciliação de sessões;
- Licenciamento simultâneo;
- Redefinição administrativa de senha;
- Troca obrigatória de senha;
- Auditoria Central.

Documento de homologação:

~~~text
10 Projetos\Sysvar\Homologações\Homologação - Operacional.md
~~~

---

# Licenciamento

Status:

~~~text
HOMOLOGADO MANUALMENTE
~~~

O SISVAR utiliza exclusivamente:

~~~text
Sessões simultâneas
~~~

O SISVAR não utiliza a quantidade de usuários cadastrados como consumo de licença.

Regras homologadas:

- criar usuário não consome licença;
- ativar usuário não consome licença;
- manter usuário cadastrado não consome licença;
- login válido consome licença;
- logout libera licença;
- timeout libera licença;
- encerramento administrativo libera licença;
- suspensão da empresa libera todas as vagas;
- superusuário da plataforma não consome licença de nenhuma empresa;
- usuários diferentes podem utilizar o mesmo dispositivo;
- o mesmo usuário no mesmo dispositivo substitui apenas sua própria sessão;
- login acima do limite contratado é recusado;
- contador e listagem utilizam a mesma regra central.

---

# Administração de Sessões

Status:

~~~text
IMPLEMENTADA
TESTADA
HOMOLOGADA
~~~

É possível:

- visualizar sessões por empresa;
- visualizar sessões por usuário;
- identificar navegador;
- identificar dispositivo;
- identificar sistema operacional;
- visualizar IP;
- visualizar início;
- visualizar última atividade;
- visualizar tempo conectado;
- visualizar status;
- encerrar uma sessão;
- encerrar todas as sessões;
- diagnosticar inconsistências;
- reconciliar sessões inválidas.

O contador de sessões e a listagem utilizam a mesma regra central de validação.

---

# Auditoria Central

Status:

~~~text
IMPLEMENTADA
TESTADA
HOMOLOGADA
DOCUMENTADA
~~~

A Auditoria registra eventos relacionados a:

- autenticação;
- logout;
- sessões;
- contratos;
- empresas;
- usuários;
- permissões;
- estabelecimentos;
- perfis;
- módulos;
- bloqueios;
- suspensão;
- reativação;
- administração de sessões;
- clientes;
- ciclo de vida de clientes;
- exclusões realizadas;
- exclusões negadas.

Princípios:

- backend como autoridade;
- registro de empresa;
- registro de usuário;
- resultado da operação;
- origem;
- correlação quando disponível;
- proteção de dados sensíveis;
- ausência de tokens brutos;
- ausência de stack trace para usuários;
- ausência de duplicação intencional de eventos.

Documento técnico:

~~~text
10 Projetos\Sysvar\Decisões Técnicas\ADR-003 - Auditoria Central do SISVAR.md
~~~

---

# Grupo Cadastros

Status atual:

~~~text
EM ANDAMENTO
~~~

Sequência de revisão:

1. Clientes;
2. Fornecedores;
3. Funcionários;
4. demais cadastros da barra lateral.

---

# Cadastros - Clientes

Status:

~~~text
IMPLEMENTADO
TESTADO AUTOMATICAMENTE
HOMOLOGADO MANUALMENTE
DOCUMENTADO
APROVADO
~~~

O cadastro de Clientes foi o primeiro módulo concluído do grupo Cadastros.

---

## Escopo Concluído de Clientes

Foram concluídos:

- cadastro de Pessoa Física;
- cadastro de Pessoa Jurídica;
- cadastro sem documento;
- validação de CPF;
- validação de CNPJ;
- documento funcional único;
- compatibilidade temporária com campo legado;
- unicidade por empresa;
- mesmo documento permitido em empresas diferentes;
- cliente padrão por empresa;
- Consumidor Final;
- pesquisa;
- filtros;
- indicadores da listagem;
- paginação;
- consulta detalhada;
- Dados cadastrais;
- Compras;
- Histórico;
- indicadores comerciais;
- ativação;
- inativação;
- bloqueio;
- desbloqueio;
- exclusão sem vínculos;
- exclusão negada com vínculos;
- permissões VIEW e EDIT;
- integração com o PDV;
- integração com vendas;
- integração com devoluções;
- integração com a Auditoria Central;
- isolamento multiempresa.

---

# Regras Centrais de Clientes

## Empresa

Todo Cliente pertence a uma Empresa.

Regra:

~~~text
cliente.empresa_id == empresa atual
~~~

O cadastro de Cliente não é global.

---

## Tipo de Pessoa

Tipos permitidos:

~~~text
PF
PJ
~~~

O tipo é explícito e determina a validação do documento.

---

## Documento Funcional

Campo oficial:

~~~text
documento
~~~

Campo legado temporário:

~~~text
cpf
~~~

O frontend utiliza apenas `documento`.

O campo legado não deve ser reutilizado em novos recursos.

---

## Unicidade

Regra:

~~~text
empresa + documento
~~~

Consequências:

- documento duplicado na mesma empresa é recusado;
- mesmo documento em outra empresa é permitido;
- mais de um cliente sem documento é permitido.

---

## Cliente Sem Documento

Cliente comum pode existir sem CPF ou CNPJ.

O sistema não deve:

- preencher documento artificialmente;
- utilizar `00000000000`;
- transformar o cliente em Consumidor Final;
- bloquear um segundo cliente sem documento.

---

# Cliente Padrão

Cada empresa possui exatamente um:

~~~text
Consumidor Final
~~~

Dados funcionais:

~~~text
Tipo: PF
Documento: 00000000000
cliente_padrao: true
~~~

Não existe Consumidor Final global.

---

## Proteções do Cliente Padrão

O Cliente padrão não pode ser:

- excluído;
- inativado;
- bloqueado;
- transferido;
- convertido em PJ;
- ter o documento alterado;
- perder a marcação de cliente padrão;
- ser criado em duplicidade manualmente.

---

# Ciclo de Vida de Clientes

O ciclo de vida utiliza ações próprias:

~~~text
Ativar
Inativar
Bloquear
Desbloquear
~~~

Não deve existir alteração direta dos estados pelo formulário comum.

---

## Cliente Ativo

Pode ser utilizado no PDV quando não estiver bloqueado.

## Cliente Inativo

- permanece cadastrado;
- preserva vínculos;
- não pode ser utilizado em nova venda;
- pode ser reativado.

## Cliente Bloqueado

- permanece cadastrado;
- exige motivo;
- pode possuir observação;
- não pode ser utilizado em nova venda;
- pode ser desbloqueado.

---

# Consulta do Cliente

A consulta está organizada em:

~~~text
Dados cadastrais
Compras
Histórico
~~~

## Dados Cadastrais

Apresenta:

- identificação;
- documento;
- contatos;
- endereço;
- situação;
- bloqueio;
- indicadores comerciais.

## Compras

Origem:

~~~text
fiscal.VendaPdv
~~~

Apresenta:

- data;
- venda;
- documento;
- loja;
- vendedor;
- itens;
- valores;
- forma de pagamento;
- situação;
- paginação;
- filtros.

## Histórico

Origem:

~~~text
AuditLog
~~~

Apresenta ações administrativas sobre o cadastro.

Compras e Histórico são domínios distintos.

---

# Indicadores Comerciais do Cliente

Indicadores homologados:

~~~text
Última compra
Total comprado
Quantidade de compras
Ticket médio
~~~

Regras:

- somente vendas válidas participam;
- vendas canceladas permanecem na consulta, mas não entram nos indicadores;
- devoluções finalizadas reduzem o total;
- os cálculos são realizados no backend;
- o frontend apenas apresenta os valores;
- os cálculos respeitam a empresa;
- os joins não podem duplicar valores.

---

# Integração com o PDV

## Venda Sem Cliente Identificado

O PDV utiliza:

~~~text
Consumidor Final da empresa atual
~~~

A venda não fica sem cliente.

## Venda com Cliente Identificado

O cliente selecionado substitui o Consumidor Final.

A venda:

- pertence ao cliente selecionado;
- aparece em Compras;
- atualiza os indicadores;
- não atualiza o Consumidor Final.

## Cliente Bloqueado ou Inativo

O PDV deve recusar o uso.

O sistema não deve:

- criar a venda para o cliente;
- trocar silenciosamente para Consumidor Final;
- ignorar o estado;
- alterar indicadores.

## Cliente de Outra Empresa

A operação deve ser recusada.

---

# Exclusão de Clientes

## Cliente Sem Vínculos

Pode ser excluído, desde que:

- não seja cliente padrão;
- não possua vendas;
- não possua devoluções;
- não possua vínculos financeiros;
- não possua outros relacionamentos protegidos.

## Cliente com Vínculos

Não pode ser excluído fisicamente.

Mensagem homologada:

~~~text
Este cliente possui vendas ou outros registros vinculados e não pode ser excluído. Utilize a inativação.
~~~

Após a negativa:

- cliente permanece;
- vínculos permanecem;
- modal fecha;
- seleção permanece;
- botão Inativar continua disponível;
- Auditoria registra a negativa;
- Histórico apresenta Exclusão negada.

---

# Permissões de Clientes

## VIEW

Permite:

- listar;
- pesquisar;
- filtrar;
- consultar;
- visualizar Compras;
- visualizar Histórico.

## EDIT

Permite, respeitando as regras de negócio:

- criar;
- editar;
- ativar;
- inativar;
- bloquear;
- desbloquear;
- excluir quando permitido.

O backend é a autoridade final.

---

# Homologação Manual de Clientes

Foram concluídos 23 itens de homologação:

1. abertura da tela;
2. cadastro de Pessoa Física;
3. CPF duplicado;
4. cadastro de Pessoa Jurídica;
5. CNPJ duplicado;
6. proteções do cliente padrão;
7. bloqueio e desbloqueio;
8. inativação e reativação;
9. Histórico;
10. pesquisa e filtros;
11. paginação;
12. Compras e indicadores;
13. exclusão;
14. cliente sem documento;
15. documentos inválidos;
16. mesmo documento em empresas diferentes;
17. permissão VIEW;
18. cliente padrão no PDV;
19. cliente identificado no PDV;
20. cliente bloqueado ou inativo no PDV;
21. Auditoria Central;
22. consistência dos indicadores;
23. regressão final.

Resultado:

~~~text
APROVADO
~~~

---

# Testes Automatizados Registrados

## Backend

Resultado informado após as correções:

~~~text
Cadastros: 42/42
Auditoria: 21/21
Suíte geral: 97/97
Falhas: 0
Ignorados: 0
~~~

## Frontend

Resultado informado:

~~~text
Karma: 90/90
Falhas: 0
Ignorados: 0
TypeScript: aprovado
Build development: aprovado
~~~

Esses números representam o estado homologado registrado.

Qualquer nova alteração exige nova execução.

---

# Commits Homologados de Clientes

## Implementação Inicial

Backend:

~~~text
df9e955b9bc5b39903647232a1072f8a9964508e
~~~

Frontend:

~~~text
73db1f96cfac11accccff2616685161a2553e6e6
~~~

## Documento Funcional

Backend:

~~~text
ef3e5ddb08d27063d3420f567974fe529e53e915
~~~

Frontend:

~~~text
5fe3a5f78a076d831f752f86d23c852cb7c0b460
~~~

## Ciclo de Vida e Histórico

Backend:

~~~text
c81053b05d0949ccb945f873ff7e416255b9a406
~~~

Frontend:

~~~text
9ea4abd975982c5d0df58229ff7934836ae197f2
~~~

## Compras e Indicadores

Backend:

~~~text
c95323f041dc87d617ebdaaeabaa8d094e55b4f8
~~~

Frontend:

~~~text
d8175e91c74e19b9c799a7e939a9812daf283ac0
~~~

## Exclusão Negada

Backend:

~~~text
82608d6c578b37336dec162fa186da11f3350823
~~~

Frontend:

~~~text
7881c54b35a2fadc0c7089fcc283a0a65bf1d5e9
~~~

---

# Documentação Específica de Clientes

## Homologação

- [[10 Projetos/Sysvar/Homologações/Homologação - Cadastros - Clientes|Homologação - Cadastros - Clientes]]

## Mapa Técnico

- [[10 Projetos/Sysvar/Contexto do Projeto/Mapa Técnico - Cadastros - Clientes|Mapa Técnico - Cadastros - Clientes]]

## Modelo de Domínio

- [[10 Projetos/Sysvar/Contexto do Projeto/Modelo de Domínio - Cadastros - Clientes|Modelo de Domínio - Cadastros - Clientes]]

## Workflows

- [[10 Projetos/Sysvar/Contexto do Projeto/Workflows - Cadastros - Clientes|Workflows - Cadastros - Clientes]]

## Riscos e Cuidados

- [[10 Projetos/Sysvar/Contexto do Projeto/Riscos e Cuidados - Cadastros - Clientes|Riscos e Cuidados - Cadastros - Clientes]]

---

# Limitações Conhecidas de Clientes

Permanecem como evoluções futuras:

- criação de rota frontend consolidada para consultar o detalhe completo da venda;
- remoção planejada do campo legado `cpf`;
- expansão de testes manuais para todos os vínculos fiscais;
- expansão de testes manuais para todos os vínculos financeiros;
- definição futura do comportamento de clientes bloqueados no PDV offline;
- eventual extração dos indicadores para serviço dedicado.

Essas limitações não impedem o estado homologado atual.

---

# Próxima Etapa

Próximo item do grupo Cadastros:

~~~text
Fornecedores
~~~

O processo seguirá o mesmo padrão utilizado em Clientes:

1. análise funcional;
2. revisão arquitetural;
3. revisão do backend;
4. revisão do frontend;
5. revisão de layout;
6. revisão de permissões;
7. revisão da Auditoria;
8. análise de vínculos;
9. implementação pelo Codex;
10. revisão dos commits;
11. testes automatizados;
12. homologação manual;
13. documentação completa no Obsidian.

---

# Regra de Continuidade

Nenhum item deve ser considerado concluído apenas por estar visualmente funcionando.

Para conclusão, deve existir:

~~~text
ANÁLISE
IMPLEMENTAÇÃO
TESTES
REVISÃO
HOMOLOGAÇÃO
DOCUMENTAÇÃO
APROVAÇÃO
~~~

---

# Notas Gerais Relacionadas

- [[10 Projetos/Sysvar/Contexto do Projeto/Visão Geral|Visão Geral]]
- [[10 Projetos/Sysvar/Contexto do Projeto/Arquitetura|Arquitetura]]
- [[10 Projetos/Sysvar/Contexto do Projeto/Modelo de Domínio|Modelo de Domínio]]
- [[10 Projetos/Sysvar/Contexto do Projeto/Workflows|Workflows]]
- [[10 Projetos/Sysvar/Contexto do Projeto/Mapa Técnico|Mapa Técnico]]
- [[10 Projetos/Sysvar/Contexto do Projeto/Riscos e Cuidados|Riscos e Cuidados]]
- [[10 Projetos/Sysvar/Decisões Técnicas/ADR-001 - Licenciamento por Sessões Simultâneas|ADR-001 - Licenciamento por Sessões Simultâneas]]
- [[10 Projetos/Sysvar/Decisões Técnicas/ADR-002 - Princípios Arquiteturais do SISVAR|ADR-002 - Princípios Arquiteturais do SISVAR]]
- [[10 Projetos/Sysvar/Decisões Técnicas/ADR-003 - Auditoria Central do SISVAR|ADR-003 - Auditoria Central do SISVAR]]

---

# Estado Atual Consolidado

~~~text
GRUPO OPERACIONAL
→ CONCLUÍDO

CADASTROS > CLIENTES
→ CONCLUÍDO

CADASTROS > FORNECEDORES
→ PRÓXIMO ITEM
~~~