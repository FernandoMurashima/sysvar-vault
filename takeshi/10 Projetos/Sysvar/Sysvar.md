---
type: project
status: active
project: Sysvar
source: "C:/SysvarProjeto"
created: 2026-08-03
updated: 2026-08-12
tags:
  - projeto
  - sysvar
  - homologado
  - operacional
  - cadastros
  - clientes
  - fornecedores
  - funcionários
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
- fornecedores;
- ciclo de vida de fornecedores;
- contatos de fornecedores;
- endereços de fornecedores;
- funcionários;
- cargos;
- mudanças de cargo;
- mudanças de loja de funcionário;
- abrangência operacional;
- afastamentos;
- retornos;
- desligamentos;
- recontratações;
- alterações de comissão;
- vínculo e desvínculo entre Funcionário e Usuário;
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
- ausência de duplicação intencional de eventos;
- dados bancários sensíveis não devem ser replicados indevidamente nos logs;
- salário e demais dados pessoais sensíveis de funcionários não devem ser replicados indevidamente nos logs.

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

1. Clientes — CONCLUÍDO;
2. Fornecedores — CONCLUÍDO;
3. Funcionários — CONCLUÍDO;
4. demais cadastros da barra lateral — A DEFINIR.

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

# Testes Automatizados Registrados - Clientes

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

- [[10 Projetos/Sysvar/Contexto do Projeto/Modelo de Domínio - Cadastros - Cliente|Modelo de Domínio - Cadastros - Cliente]]

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

# Cadastros - Fornecedores

Status:

~~~text
IMPLEMENTADO
TESTADO AUTOMATICAMENTE
HOMOLOGADO MANUALMENTE
DOCUMENTADO
APROVADO
~~~

O cadastro de Fornecedores é o segundo módulo concluído do grupo Cadastros.

A Fase 1 contempla cadastro, gestão operacional, integração com compras e financeiro, ciclo de vida, segurança bancária, histórico e auditoria.

---

# Escopo Concluído de Fornecedores

Foram concluídos:

- Pessoa Física;
- Pessoa Jurídica;
- fornecedor sem documento;
- CPF/CNPJ validado quando informado;
- documento único por empresa;
- mesmo documento permitido em empresas distintas;
- alerta de possível duplicidade por nome/apelido;
- múltiplas categorias;
- múltiplos contatos;
- múltiplos endereços;
- contato principal por tipo;
- endereço principal por tipo;
- inativação e reativação de contatos;
- inativação e reativação de endereços;
- telefone e WhatsApp com máscara brasileira;
- dados fiscais;
- contribuinte ICMS estruturado;
- dados comerciais;
- prazo padrão estruturado;
- conta contábil padrão estruturada;
- natureza financeira padrão;
- dados bancários;
- tipo de conta bancária estruturado;
- proteção específica de dados bancários;
- ativação;
- inativação;
- bloqueio;
- desbloqueio;
- exclusão protegida;
- integração operacional;
- restrição de fornecedor inativo;
- restrição de fornecedor bloqueado;
- consulta detalhada;
- Compras;
- Financeiro;
- Histórico;
- indicadores comerciais;
- Audit Central;
- isolamento multiempresa;
- paginação server-side;
- filtros server-side.

---

# Regras Centrais de Fornecedores

## Empresa

Todo Fornecedor pertence obrigatoriamente a uma Empresa.

Regra conceitual:

~~~text
fornecedor.empresa_id == empresa atual
~~~

Não existe fornecedor global.

---

## Tipo de Pessoa

Tipos:

~~~text
PF
PJ
~~~

Quando o documento é informado:

- PF → CPF válido;
- PJ → CNPJ válido.

---

## Documento Funcional

Campo preferencial:

~~~text
documento
~~~

Campo legado temporário:

~~~text
cnpj
~~~

O documento pode ser nulo.

---

## Unicidade

Regra:

~~~text
empresa + documento
~~~

Consequências:

- documento duplicado na mesma empresa é rejeitado;
- o mesmo documento em empresa diferente é permitido;
- vários fornecedores sem documento são permitidos.

---

# Fornecedor sem Documento

Fornecedor sem CPF/CNPJ é permitido.

Não deve ser criado documento artificial.

A ausência de documento, isoladamente, não impede novas operações.

Para utilização, o fornecedor deve estar:

~~~text
ATIVO
E
NÃO BLOQUEADO
E
PERTENCER À EMPRESA
~~~

além de atender ao contexto operacional aplicável.

---

# Possível Duplicidade por Nome

Nome e apelido semelhantes geram aviso.

Não são bloqueio rígido.

Fluxo:

~~~text
Possível duplicidade
→ Avisar
→ Usuário pode cancelar
OU
→ Confirmar e continuar
~~~

Documento, quando informado, continua sendo o critério rígido.

---

# Categorias de Fornecedor

Categorias:

~~~text
MATERIA_PRIMA
AVIAMENTO
REVENDA
FACCAO
PRESTADOR
TRANSPORTADORA
OUTROS
~~~

Um fornecedor pode possuir múltiplas categorias simultaneamente.

Estrutura preferencial:

~~~text
FornecedorCategoria
~~~

O campo legado `categoria` não deve ser usado como base para novas expansões.

---

# Uso Operacional das Categorias

Categorias servem principalmente para:

- classificação;
- filtro;
- sugestão;
- priorização;
- contexto.

Exemplos:

~~~text
Facção → FACCAO
Compra de revenda → REVENDA
Matéria-prima → MATERIA_PRIMA
Transporte → TRANSPORTADORA
~~~

Não transformar categoria em bloqueio universal sem regra específica da operação.

---

# Contatos de Fornecedor

O fornecedor possui múltiplos contatos.

Tipos:

~~~text
COMERCIAL
FINANCEIRO
FISCAL
PRODUCAO_FACCAO
LOGISTICA
OUTRO
~~~

Cada contato pode possuir:

- nome;
- função;
- telefone;
- WhatsApp;
- e-mail;
- observação;
- principal;
- ativo/inativo.

---

# Contato Principal

Regra:

~~~text
Somente um contato ativo principal por tipo
~~~

A alteração do principal é protegida transacionalmente.

---

# Endereços de Fornecedor

O fornecedor possui múltiplos endereços.

Tipos funcionais:

- Fiscal;
- Comercial;
- Cobrança;
- Retirada/Coleta;
- Entrega;
- Unidade Fabril;
- Outro.

Regra:

~~~text
Somente um endereço ativo principal por tipo
~~~

---

# Telefones

A validação utiliza quantidade de dígitos, não pontuação rígida.

Aceitos:

~~~text
10 dígitos
11 dígitos
vazio
~~~

Exemplos visuais:

~~~text
(21) 3324-4000
(21) 99008-7565
~~~

Persistência/envio preferencial:

~~~text
2133244000
21990087565
~~~

---

# Dados Fiscais de Fornecedor

Campos:

- Inscrição Estadual;
- Inscrição Municipal;
- Contribuinte ICMS.

Contribuinte ICMS:

~~~text
SIM
NAO
ISENTO
~~~

A interface apresenta:

- Sim;
- Não;
- Isento;
- Não informado.

---

# Inscrição Estadual

Situação:

~~~text
PENDÊNCIA CONHECIDA
NÃO BLOQUEIA FASE 1
~~~

Atualmente:

- opcional;
- texto livre;
- sem validação específica por UF.

---

# Inscrição Municipal

Situação:

~~~text
PENDÊNCIA CONHECIDA
NÃO BLOQUEIA FASE 1
~~~

Atualmente:

- opcional;
- texto livre;
- sem validação municipal específica.

---

# Prazo Padrão do Fornecedor

Estrutura:

~~~text
financeiro.PrazoPagamento
~~~

Campo funcional:

~~~text
prazo_padrao_pagamento_ref
~~~

Campo legado:

~~~text
prazo_padrao_pagamento
~~~

Regra:

- prazo da mesma empresa;
- prazo ativo para nova seleção.

---

# Conta Contábil Padrão

Estrutura:

~~~text
cadastros.PlanoContabil
~~~

Campo funcional:

~~~text
conta_contabil_padrao
~~~

Campo legado:

~~~text
conta_contabil
~~~

A conta deve ser:

- da mesma empresa;
- ativa;
- analítica.

---

# Natureza Financeira Padrão

Estrutura:

~~~text
cadastros.Nat_Lancamento
~~~

Campo:

~~~text
natureza_padrao
~~~

A natureza deve:

- pertencer à mesma empresa;
- estar ativa.

---

# Regra dos Padrões

Prazo, conta e natureza são padrões sugeridos.

Não devem ser interpretados automaticamente como travamentos universais.

A operação específica define se o valor pode ser alterado.

---

# Dados Bancários

Campos homologados:

- Banco;
- Agência;
- Conta;
- Tipo de conta;
- Chave PIX;
- Favorecido;
- Documento do favorecido;
- Observação bancária.

---

# Tipo de Conta

Valores internos:

~~~text
CORRENTE
POUPANCA
PAGAMENTO
OUTRA
~~~

Interface:

- Conta corrente;
- Conta poupança;
- Conta de pagamento;
- Outra.

---

# Segurança Bancária

Permissão específica:

~~~text
fornecedor.dados_bancarios
~~~

Usuário autorizado:

- recebe;
- visualiza;
- pode editar conforme demais permissões.

Usuário não autorizado:

- não recebe os valores sensíveis;
- não deve conseguir recuperá-los por chamada manual da API.

Proteção obrigatoriamente no backend.

---

# Banco Oficial

Situação:

~~~text
PENDENTE
NÃO BLOQUEIA FASE 1
~~~

Ainda não existe cadastro oficial BACEN integrado.

Futuramente deverá ser analisado:

- código COMPE;
- ISPB;
- nome oficial;
- atualização da lista;
- identificador interno definitivo.

---

# Ciclo de Vida de Fornecedores

Ações:

~~~text
Ativar
Inativar
Bloquear
Desbloquear
~~~

Os campos de lifecycle não devem virar simples checkboxes livres no formulário.

---

# Fornecedor Ativo

Pode ser utilizado quando:

- não bloqueado;
- pertence à empresa;
- atende ao contexto operacional.

---

# Fornecedor Inativo

- permanece cadastrado;
- preserva histórico;
- não pode participar de nova operação;
- pode ser reativado.

---

# Fornecedor Bloqueado

- permanece cadastrado;
- preserva histórico;
- não pode participar de nova operação;
- registra motivo;
- registra observação;
- registra usuário;
- registra data/hora;
- pode ser desbloqueado.

---

# Fornecedor Utilizável

Regra conceitual:

~~~text
Fornecedor utilizável =
empresa correta
AND ativo
AND não bloqueado
AND contexto operacional válido
~~~

A segurança não pode depender apenas do frontend.

---

# Exclusão de Fornecedor

## Sem Vínculos

Pode ser excluído fisicamente.

## Com Vínculos

Não pode ser excluído.

Mensagem funcional:

~~~text
Este fornecedor possui compras ou outros registros vinculados e não pode ser excluído. Utilize a inativação.
~~~

A preservação histórica possui prioridade sobre exclusão física.

---

# Consulta do Fornecedor

Abas:

~~~text
Dados cadastrais
Compras
Financeiro
Histórico
~~~

A consulta é somente leitura.

---

# Indicadores Comerciais do Fornecedor

Indicadores homologados:

~~~text
Última compra
Total comprado
Quantidade de compras
Ticket médio
Saldo a pagar
~~~

Os cálculos são responsabilidade do backend.

---

# Compras do Fornecedor

A aba Compras pode apresentar registros:

- concluídos;
- abertos;
- cancelados.

O status deve estar identificado.

Para os indicadores:

- cancelados não entram;
- rascunhos não entram;
- abertos não concluídos não entram;
- somente operações válidas participam.

---

# Ticket Médio de Fornecedor

Regra:

~~~text
Ticket médio =
Total comprado
/
Quantidade de compras válidas
~~~

Deve existir tratamento para quantidade zero.

---

# Financeiro do Fornecedor

A aba Financeiro apresenta, quando aplicável:

- documento/origem;
- emissão;
- vencimento;
- valor original;
- valor pago;
- saldo;
- status;
- natureza;
- loja.

Somente registros:

~~~text
do fornecedor
+
da empresa atual
~~~

---

# Saldo a Pagar

Regras:

- título aberto entra;
- pagamento parcial entra pelo saldo restante;
- título totalmente pago fica com saldo zero;
- título cancelado não compõe o saldo.

Histórico e saldo atual são conceitos diferentes.

---

# Histórico de Fornecedor

Eventos incluem:

- criação;
- edição;
- ativação;
- inativação;
- bloqueio;
- desbloqueio;
- contatos;
- endereços;
- alteração de principal;
- demais eventos relevantes.

---

# Auditoria de Fornecedor

Eventos relevantes também aparecem na Audit Central.

A auditoria deve preservar:

- empresa;
- usuário;
- data/hora;
- ação;
- contexto.

Não deve armazenar desnecessariamente dados bancários sensíveis.

---

# Paginação e Filtros de Fornecedor

A paginação é:

~~~text
SERVER-SIDE
~~~

Os filtros principais também são processados pelo backend.

Não reintroduzir:

~~~text
page_size=2000
~~~

como estratégia de listagem.

---

# Homologação Manual de Fornecedores

Foram concluídos:

~~~text
30 ITENS
~~~

Resultado:

~~~text
30/30 APROVADOS
~~~

Itens homologados:

1. abertura da tela;
2. paginação server-side;
3. filtros server-side;
4. cadastro PF;
5. cadastro PJ;
6. fornecedor sem documento;
7. documento inválido;
8. documento duplicado na mesma empresa;
9. mesmo documento em empresas diferentes;
10. múltiplas categorias;
11. múltiplos contatos;
12. múltiplos endereços;
13. endereço principal por tipo;
14. contato principal por tipo;
15. inativação/reativação de contato;
16. inativação/reativação de endereço;
17. dados fiscais, comerciais, contábeis e financeiros;
18. dados bancários e permissões;
19. exclusão protegida;
20. ativação/inativação;
21. bloqueio/desbloqueio;
22. restrição operacional de inativo/bloqueado;
23. Histórico e Audit Central;
24. indicadores comerciais;
25. aba Compras;
26. aba Financeiro;
27. possível duplicidade por nome/apelido;
28. uso operacional das categorias;
29. fornecedor sem documento em operação;
30. regressão final.

---

# Testes Automatizados Registrados - Fornecedores

Resultado mais recente registrado na Fase 1:

## Backend

~~~text
manage.py check: OK
makemigrations --check --dry-run: OK
FornecedorFase1Tests: 14 OK
Cadastros: 56 OK
Auditoria: 21 OK
Suíte geral: 111 OK
~~~

## Frontend

~~~text
TypeScript: OK
Karma: 114 SUCCESS
Build development: OK
~~~

Esses números são resultados registrados durante a implementação e não representam nova execução após a documentação.

---

# Commits Homologados de Fornecedores

## Implementação parcial inicial

Backend:

~~~text
0454e49318a15613d45de1c09d745b9406925c25
~~~

Frontend:

~~~text
fdcf7770c17dbe1034f69039f79223ea97979d27
~~~

## Conclusão da Fase 1

Backend:

~~~text
993f473ca793193a7590327964b4f3a20e5780e7
~~~

Frontend:

~~~text
a573d068e8bb031ea7aae0ebc0196c9bbf7ad78c
~~~

## Correção de Contatos e Endereços

Backend:

~~~text
c65e0e737a725741907cc298e52c314cf93efab8
~~~

Frontend:

~~~text
8e767bda4e70efd826497526dea70aaf903e860c
~~~

## Correção de Telefones

Frontend:

~~~text
a3fe7235f5999652d47cb54589000b59a6b5da5b
~~~

## Padrões Fiscais e Financeiros

Backend:

~~~text
a2b192b60a31b0f38db2e2ab4b0c9c9aca3c10ee
~~~

Frontend:

~~~text
37e68377bcecfc4ef35032cbb942d7a463ab58c6
~~~

---

# Migration de Referência - Fornecedores

Migration criada durante os ajustes fiscais e financeiros:

~~~text
cadastros/migrations/0025_fornecedor_conta_contabil_padrao_and_more.py
~~~

Inclui:

- conta contábil padrão;
- prazo padrão estruturado;
- choices de contribuinte ICMS.

Migrations já aplicadas não devem ser editadas.

Novas alterações exigem nova migration.

---

# Documentação Específica de Fornecedores

## Homologação

- [[10 Projetos/Sysvar/Homologações/Homologação - Cadastros - Fornecedores|Homologação - Cadastros - Fornecedores]]

## Mapa Técnico

- [[10 Projetos/Sysvar/Contexto do Projeto/Mapa Técnico - Cadastros - Fornecedores|Mapa Técnico - Cadastros - Fornecedores]]

## Modelo de Domínio

- [[10 Projetos/Sysvar/Contexto do Projeto/Modelo de Domínio - Cadastros - Fornecedores|Modelo de Domínio - Cadastros - Fornecedores]]

## Workflows

- [[10 Projetos/Sysvar/Contexto do Projeto/Workflows - Cadastros - Fornecedores|Workflows - Cadastros - Fornecedores]]

## Riscos e Cuidados

- [[10 Projetos/Sysvar/Contexto do Projeto/Riscos e Cuidados - Cadastros - Fornecedores|Riscos e Cuidados - Cadastros - Fornecedores]]

---

# Limitações e Pendências Conhecidas de Fornecedores

## Inscrição Estadual

~~~text
PENDENTE
~~~

Futuramente avaliar validação por UF.

## Inscrição Municipal

~~~text
PENDENTE
~~~

Futuramente avaliar estratégia de validação.

## Cadastro Oficial de Bancos

~~~text
PENDENTE
~~~

Futuramente integrar estrutura padronizada baseada em fonte oficial.

## UX de Dados Bancários Restritos

~~~text
MELHORIA FUTURA
~~~

Atualmente os valores são protegidos, mas a estrutura dos campos pode permanecer visível vazia para usuário sem permissão.

Essas pendências não impedem o estado homologado da Fase 1.

---

# Fornecedores - Fase 2

A Fase 2 está reservada para inteligência e avaliação.

Não faz parte da Fase 1 concluída.

Escopo planejado:

- avaliações estruturadas;
- avaliação por categoria;
- histórico de avaliações;
- pesos configuráveis;
- Score Geral;
- Score por Categoria;
- peso de recência;
- classificação;
- alertas;
- filtro por score;
- ordenação por score;
- comparação de fornecedores.

---

# Critérios Planejados para Avaliação

Escala prevista:

~~~text
1 a 5
~~~

Critérios:

- Qualidade;
- Prazo;
- Custo-benefício;
- Atendimento;
- Confiabilidade;
- Qualidade da entrega;
- Problemas/Devoluções.

Pesos padrão planejados:

~~~text
Qualidade: 25%
Prazo: 20%
Confiabilidade: 15%
Custo-benefício: 15%
Qualidade da entrega: 10%
Atendimento: 10%
Problemas/Devoluções: 5%
~~~

Soma:

~~~text
100%
~~~

---

# Score Planejado

Faixa:

~~~text
0 a 100
~~~

Classificação prevista:

~~~text
90–100 → Excelente
75–89 → Bom
60–74 → Regular
<60 → Ruim
~~~

Sem avaliação:

~~~text
Não avaliado
~~~

Score ruim não deve bloquear automaticamente o fornecedor.

---

# Peso de Recência Planejado

Últimas cinco avaliações:

~~~text
1ª mais recente → 35%
2ª → 25%
3ª → 20%
4ª → 12%
5ª → 8%
~~~

Quando existirem menos avaliações, os pesos deverão ser normalizados.

---

# Separação entre Score e Lifecycle

Regra arquitetural futura:

~~~text
Score ≠ Bloqueio
~~~

Score representa desempenho.

Bloqueio representa decisão operacional/administrativa.

Fornecedor com score ruim poderá gerar:

- alerta;
- confirmação adicional;

mas não deve ser bloqueado automaticamente apenas pelo score.

---

# Cadastros - Funcionários

Status:

~~~text
IMPLEMENTADO
TESTADO
HOMOLOGADO MANUALMENTE
DOCUMENTADO
APROVADO
~~~

O cadastro de Funcionários é o terceiro módulo concluído do grupo Cadastros.

A Fase 1 representa o Funcionário como entidade operacional da empresa.

Não representa um módulo de RH ou Departamento Pessoal.

Resultado da homologação manual:

~~~text
17/17 ITENS APROVADOS
~~~

---

# Objetivo de Funcionários

Funcionários identifica as pessoas que participam operacionalmente da empresa.

A funcionalidade permite representar:

- Vendedores;
- Caixas;
- Gerentes;
- Supervisores;
- Assistentes;
- Auxiliares;
- Compradores;
- Estoquistas;
- Almoxarifes;
- Conferentes;
- Recebedores;
- funcionários administrativos;
- funcionários financeiros;
- funcionários de produção;
- demais funções definidas pela empresa.

---

# Separações Fundamentais de Funcionários

A arquitetura homologada estabelece:

~~~text
Funcionário ≠ Usuário

Cargo ≠ Perfil de Acesso

Cargo ≠ Permissão

Loja supervisionada ≠ Loja permitida do Usuário

Situação do Funcionário ≠ User.is_active

Comissão básica ≠ Motor completo de comissão

Histórico operacional ≠ AuditLog
~~~

Essas separações devem ser preservadas.

---

# Empresa do Funcionário

Todo Funcionário pertence a uma Empresa.

Regra conceitual:

~~~text
funcionario.empresa_id == empresa atual
~~~

Também devem pertencer à mesma Empresa:

- Cargo;
- Loja Principal;
- lojas supervisionadas;
- Usuário vinculado.

Não existe Funcionário global.

---

# CPF do Funcionário

CPF é obrigatório funcionalmente para novos Funcionários.

Regras:

- obrigatório;
- validado;
- normalizado;
- único dentro da Empresa;
- mesmo CPF permitido em empresas diferentes.

Regra:

~~~text
empresa + cpf
~~~

Registros legados sem CPF podem ser preservados.

Não devem ser criados CPFs artificiais.

---

# Matrícula

Todo Funcionário possui matrícula.

Regras:

- obrigatória;
- única por Empresa;
- pode ser gerada automaticamente;
- pode ser informada manualmente;
- permanece estável;
- não é reutilizada;
- não muda em afastamento;
- não muda em desligamento;
- não muda em recontratação.

Sequência automática inicial:

~~~text
000001
000002
000003
...
~~~

---

# Cargo

Funcionários utiliza Cargo estruturado.

Estrutura:

~~~text
cadastros.Cargo
~~~

Cargo pertence à Empresa.

Regra:

~~~text
funcionario.empresa == cargo.empresa
~~~

Cargo é cadastro aberto.

Não é enumeração fechada.

---

# Cargos Básicos

O sistema disponibiliza configuração inicial contendo:

~~~text
VENDEDOR
CAIXA
GERENTE
SUPERVISOR
ASSISTENTE
AUXILIAR
AUXADM
ASSADM
ASSFIN
AUXFIN
COMPRADOR
ESTOQUISTA
ALMOX
CONFERENTE
RECEBEDOR
COSTUREIRA
AUXPROD
~~~

Esses Cargos não representam limite funcional.

Cada Empresa pode cadastrar outros.

Exemplos:

~~~text
Analista Financeiro
Analista de Operações
Coordenador de Estoque
Modelista
Encarregado de Produção
~~~

---

# Cargo e Permissões

Cargo representa função operacional.

Não concede acesso ao sistema.

Exemplo:

~~~text
Cargo:
Assistente Financeiro
~~~

não significa automaticamente:

~~~text
Financeiro = EDIT
~~~

Permissões permanecem controladas por:

- Usuário;
- Perfil de Acesso;
- permissões de módulo;
- overrides;
- demais regras do app `accounts`.

---

# Características de Cargo

Cargo possui características estruturadas como:

- participa de vendas;
- permite comissão;
- autoridade operacional de loja;
- permite múltiplas lojas;
- gerencial;
- ativo.

Novas regras devem preferir características estruturadas e não comparar apenas o texto da descrição do Cargo.

---

# Vendedor

Configuração inicial:

~~~text
participa_vendas = true
permite_comissao = true
autoridade_operacional_loja = true
permite_multiplas_lojas = false
gerencial = false
~~~

---

# Caixa

Configuração inicial:

~~~text
participa_vendas = false
permite_comissao = false
autoridade_operacional_loja = true
permite_multiplas_lojas = false
gerencial = false
~~~

---

# Gerente

Configuração inicial homologada:

~~~text
participa_vendas = false
permite_comissao = true
autoridade_operacional_loja = true
permite_multiplas_lojas = false
gerencial = true
~~~

Gerente pode ser comissionado.

A regra de cálculo avançada não pertence a Funcionários.

---

# Supervisor

Configuração inicial homologada:

~~~text
participa_vendas = false
permite_comissao = true
autoridade_operacional_loja = true
permite_multiplas_lojas = true
gerencial = true
~~~

Supervisor pode ser comissionado e pode possuir abrangência multi-loja.

---

# Categoria Legada

Campo legado:

~~~text
categoria
~~~

Fonte funcional atual:

~~~text
cargo
~~~

Novas funcionalidades não devem voltar a utilizar `categoria` como definição principal de função.

O campo legado deve ser removido somente após análise completa de dependências.

---

# Situação Operacional do Funcionário

Estados:

~~~text
ATIVO
AFASTADO
DESLIGADO
~~~

A situação é a referência funcional de lifecycle.

---

# Funcionário Ativo

Pode participar de novas operações compatíveis com:

- Empresa;
- Cargo;
- Loja;
- participação em vendas;
- demais regras da operação.

---

# Funcionário Afastado

- permanece cadastrado;
- preserva matrícula;
- preserva CPF;
- preserva histórico;
- não deve participar normalmente de novas operações;
- pode retornar.

---

# Funcionário Desligado

- permanece cadastrado;
- preserva matrícula;
- preserva CPF;
- preserva vendas;
- preserva histórico;
- não deve participar de novas operações;
- pode ser recontratado.

---

# Ciclo Operacional

Fluxo homologado:

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

Ações:

~~~text
Afastar
Retornar
Desligar
Recontratar
~~~

---

# Recontratação

Recontratação reutiliza o mesmo Funcionário.

Não deve criar outro cadastro.

Preserva:

- ID;
- matrícula;
- CPF;
- histórico;
- vínculos anteriores.

---

# Campo ativo Legado

O model possui campo legado:

~~~text
ativo
~~~

A direção funcional atual utiliza:

~~~text
situacao
~~~

Não criar dois ciclos de vida independentes.

---

# Loja Principal

Campo técnico legado:

~~~text
idloja
~~~

Funcionalmente representa:

~~~text
Loja Principal
~~~

A Loja deve pertencer à mesma Empresa.

---

# Obrigatoriedade de Loja

A necessidade de Loja Principal depende da característica do Cargo.

Não deve ser baseada apenas no texto do nome do Cargo.

Cargos administrativos podem existir sem Loja Principal quando configurados dessa forma.

---

# Abrangência Multi-Loja

Estruturas:

~~~text
lojas_supervisionadas
todas_lojas_da_empresa
~~~

Representam responsabilidade operacional do Funcionário.

Supervisor é o principal caso atual.

---

# Regra Multi-Loja

Somente Cargo com:

~~~text
permite_multiplas_lojas = true
~~~

pode manter abrangência de múltiplas lojas.

Todas as Lojas devem pertencer à mesma Empresa.

---

# Abrangência Operacional versus Acesso

Não confundir:

~~~text
Funcionarios.lojas_supervisionadas
~~~

com:

~~~text
User.lojas
~~~

A primeira representa responsabilidade operacional.

A segunda representa autorização de acesso do Usuário.

Não devem ser sincronizadas automaticamente.

---

# Participação em Vendas

Campo:

~~~text
participa_vendas
~~~

Indica participação comercial do Funcionário.

Não concede permissão de acesso ao módulo Vendas.

---

# Funcionário Comissionado

Campo:

~~~text
comissionado
~~~

Indica se o Funcionário utiliza comissão básica.

O Cargo precisa permitir comissão.

---

# Comissão Básica

Campo:

~~~text
comissao_percentual
~~~

O percentual pertence ao Funcionário.

Cargo apenas informa:

~~~text
permite_comissao
~~~

Funcionários do mesmo Cargo podem possuir percentuais diferentes.

---

# Comissão de Gerente e Supervisor

Regra homologada:

~~~text
GERENTE.permite_comissao = true

SUPERVISOR.permite_comissao = true
~~~

A forma efetiva de cálculo será responsabilidade futura do módulo de Planejamento/Ação de Vendas.

---

# Meta Legada

Campo existente:

~~~text
meta
~~~

não faz mais parte do cadastro funcional de Funcionários.

Não deve ser utilizado em:

- formulário;
- filtro;
- nova regra de comissão;
- novo relatório;
- novas funcionalidades.

Metas pertencem ao futuro módulo de Planejamento/Ação de Vendas.

---

# Vínculo Funcionário × Usuário

Relacionamento:

~~~text
Funcionarios.usuario
~~~

é opcional e OneToOne com:

~~~text
accounts.User
~~~

O Funcionário pode existir sem Usuário.

---

# Regras do Vínculo com Usuário

O Usuário:

- deve pertencer à mesma Empresa;
- não pode estar vinculado a outro Funcionário;
- pode ser vinculado;
- pode ser substituído;
- pode ser desvinculado.

Vincular não altera automaticamente:

- Cargo;
- Perfil;
- permissões;
- tipo do Usuário;
- lojas de acesso;
- sessões.

---

# Situação do Funcionário versus Login

Afastar ou desligar Funcionário não executa automaticamente:

~~~text
User.is_active = false
~~~

Essa independência foi mantida conscientemente na Fase 1.

Uma política automática futura exigirá decisão funcional específica.

---

# Dados Complementares

Campos opcionais homologados incluem:

- apelido;
- telefone;
- WhatsApp;
- e-mail;
- data de nascimento;
- endereço;
- observações.

Esses dados são cadastrais.

Não representam módulo de RH.

---

# Salário

Campo:

~~~text
salario
~~~

foi preservado.

Não existe folha de pagamento na Fase 1.

O valor é uma informação protegida.

Permissão:

~~~text
funcionario.salario
~~~

O backend deve proteger visualização e alteração.

---

# Funcionários Não é RH/DP

Não pertencem à Fase 1:

- folha de pagamento;
- férias;
- benefícios;
- ponto;
- banco de horas;
- CTPS;
- PIS;
- dependentes;
- encargos;
- rescisão trabalhista detalhada;
- prontuário de RH;
- documentos de pessoal.

Caso sejam necessários futuramente, devem compor domínio próprio.

---

# Histórico Operacional de Funcionário

Estrutura:

~~~text
FuncionarioHistorico
~~~

Eventos incluem:

- mudança de Cargo;
- mudança de Loja;
- mudança de abrangência;
- afastamento;
- retorno;
- desligamento;
- recontratação.

O histórico preserva a trajetória operacional do Funcionário.

---

# Histórico versus Auditoria

~~~text
FuncionarioHistorico
→ histórico funcional

AuditLog
→ rastreabilidade técnica e de segurança
~~~

As duas estruturas são complementares.

---

# Exclusão de Funcionário

## Sem Uso Operacional

Pode ser excluído quando não existem vínculos impeditivos.

## Com Uso Operacional

Não pode ser fisicamente excluído.

Mensagem homologada:

~~~text
Funcionário já utilizado em operações. Desligue o funcionário em vez de excluí-lo.
~~~

A tentativa negada deve permanecer auditável.

---

# Integração com VendaPdv

Venda mantém:

~~~text
VendaPdv.vendedor
→ Funcionarios
~~~

Também mantém:

~~~text
VendaPdv.criado_por
→ User
~~~

Os conceitos são diferentes.

---

# Vendedor versus Operador

~~~text
vendedor
= pessoa responsável comercialmente pela venda

criado_por
= usuário que operou o sistema
~~~

Podem representar pessoas diferentes.

Essa separação deve ser preservada.

---

# Funcionário Elegível para Nova Venda

Conceitualmente deve:

~~~text
pertencer à Empresa
AND estar ATIVO
AND participar de vendas
AND ser compatível com a Loja
~~~

Funcionário AFASTADO ou DESLIGADO não deve ser utilizado normalmente em nova venda.

---

# Comissão Histórica

A implementação atual ainda possui pontos que consultam:

~~~text
funcionario.comissao_percentual
~~~

Isso não é suficiente para um motor definitivo de comissão histórica.

Futuramente a venda/apuração deverá preservar a regra efetivamente aplicada.

---

# Paginação e Filtros de Funcionários

A listagem utiliza:

~~~text
PAGINAÇÃO SERVER-SIDE
~~~

Filtros também são processados no backend.

Busca inclui informações como:

- matrícula;
- nome;
- apelido;
- CPF.

Filtros incluem:

- Cargo;
- Loja;
- situação;
- participa de vendas;
- comissionado.

Não reintroduzir carregamento massivo para filtragem Angular.

---

# Homologação Manual de Funcionários

Foram concluídos:

~~~text
17 ITENS
~~~

Resultado:

~~~text
17/17 APROVADOS
~~~

Itens:

1. abertura e estrutura da tela;
2. paginação server-side;
3. filtros server-side;
4. Cargos;
5. Funcionário com Cargo administrativo;
6. CPF;
7. matrícula;
8. ciclo operacional;
9. Loja Principal;
10. Supervisor e multi-loja;
11. comissão básica;
12. Funcionário × Usuário;
13. histórico operacional;
14. exclusão protegida;
15. salário protegido;
16. dados complementares;
17. regressão e fechamento geral.

---

# Correções Surgidas na Homologação de Funcionários

## Cargos Livres

Inicialmente a interface poderia transmitir a ideia de que os Cargos estavam restritos a funções comerciais.

Foi corrigido para deixar explícito que Cargo é cadastro livre por Empresa.

---

## Cargos Administrativos e Operacionais

Foram incluídos defaults adicionais como:

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

---

## Comissão de Gerente e Supervisor

Foi corrigida a configuração para permitir comissão em:

~~~text
GERENTE
SUPERVISOR
~~~

---

## Usuário Vinculado

O relacionamento já existia no backend.

Durante homologação foi identificada ausência do campo correspondente no frontend.

A interface passou a permitir:

- vincular;
- trocar;
- remover;
- consultar;

o Usuário relacionado.

---

# Testes Automatizados Registrados - Funcionários

Durante a implementação foram registrados:

## Backend

~~~text
manage.py check: OK
manage.py makemigrations --check: OK
FuncionariosFase1Tests: OK
Conjunto relacionado inicial: 40 testes OK
Correções posteriores: testes direcionados OK
~~~

Esses resultados correspondem às execuções registradas durante a implementação e correções.

Não representam uma nova suíte integral executada durante a documentação.

## Frontend

~~~text
TypeScript: OK
Build development: OK
~~~

As verificações foram repetidas nas correções relevantes.

---

# Commits Homologados de Funcionários

## Implementação Backend

~~~text
056dfdee7545b725f94f6396bb5bff2f58be2397
Conclui fase 1 do cadastro de funcionarios
~~~

## Implementação Frontend

~~~text
7fd39d0c86d070bc92ff8ff38dee99cc723b23dc
Conclui fase 1 da interface de funcionarios
~~~

## Ampliação dos Cargos

Backend:

~~~text
2ba369f3c1cb076b65bdd6b625fa051e8dd7f351
Amplia cadastro de cargos de funcionarios
~~~

Frontend:

~~~text
d847d20b2dcbb94f8f0f450c53e308e4ba0afd7a
Permite cargos livres no cadastro de funcionarios
~~~

## Comissão de Gerente e Supervisor

Backend:

~~~text
b7b10bf5d5095d49ec9cbe1a7329f46c3efa6331
Corrige comissao de gerente e supervisor
~~~

## Vínculo de Usuário no Frontend

Frontend:

~~~text
0a71c638a7c6b1db324fa978ff69e035c4fc51dc
Adiciona vinculo de usuario ao funcionario
~~~

---

# Migrations de Referência - Funcionários

## Estrutura Principal

~~~text
cadastros/migrations/0026_cargo_funcionariohistorico_funcionarios_comissionado_and_more.py
~~~

Inclui:

- Cargo;
- FuncionarioHistorico;
- matrícula;
- situação;
- comissão;
- multi-loja;
- vínculo com Usuário;
- dados complementares;
- migração de categoria;
- normalização necessária;
- constraints;
- índices.

## Cargos Básicos

~~~text
cadastros/migrations/0027_cargos_funcionarios_basicos.py
~~~

Cria Cargos básicos em empresas existentes.

## Comissão de Gerente e Supervisor

~~~text
cadastros/migrations/0028_corrige_comissao_gerente_supervisor.py
~~~

Corrige:

~~~text
GERENTE.permite_comissao = true
SUPERVISOR.permite_comissao = true
~~~

Migrations aplicadas não devem ser modificadas.

Novas mudanças exigem nova migration.

---

# Documentação Específica de Funcionários

## Homologação

- [[10 Projetos/Sysvar/Homologações/Homologação - Cadastros - Funcionários|Homologação - Cadastros - Funcionários]]

## Mapa Técnico

- [[10 Projetos/Sysvar/Contexto do Projeto/Mapa Técnico - Cadastros - Funcionários|Mapa Técnico - Cadastros - Funcionários]]

## Modelo de Domínio

- [[10 Projetos/Sysvar/Contexto do Projeto/Modelo de Domínio - Cadastros - Funcionários|Modelo de Domínio - Cadastros - Funcionários]]

## Workflows

- [[10 Projetos/Sysvar/Contexto do Projeto/Workflows - Cadastros - Funcionários|Workflows - Cadastros - Funcionários]]

## Riscos e Cuidados

- [[10 Projetos/Sysvar/Contexto do Projeto/Riscos e Cuidados - Cadastros - Funcionários|Riscos e Cuidados - Cadastros - Funcionários]]

---

# Limitações e Evoluções Futuras de Funcionários

## Comissão Histórica

~~~text
EVOLUÇÃO FUTURA
~~~

A regra aplicada à venda deverá futuramente possuir snapshot histórico adequado.

## Planejamento/Ação de Vendas

~~~text
FUTURO MÓDULO
~~~

Deverá tratar:

- metas;
- campanhas;
- bônus;
- faixas;
- políticas de comissão;
- comissão de Gerente;
- comissão de Supervisor;
- comissão por produto;
- comissão por grupo;
- comissão por coleção;
- regras temporais.

## Combo de Usuários

~~~text
MELHORIA FUTURA DE ESCALABILIDADE
~~~

Em empresas muito grandes poderá ser necessário substituir carregamento amplo por:

- autocomplete;
- busca remota;
- paginação.

## Campos Legados

Permanecem para compatibilidade:

- `categoria`;
- `meta`;
- `ativo`;
- `idloja` com nomenclatura legada.

A remoção deverá ser planejada somente depois da migração de todos os consumidores.

## RH/DP

~~~text
FORA DO ESCOPO ATUAL
~~~

Não existe decisão atual de desenvolver:

- folha;
- férias;
- benefícios;
- ponto;
- DP.

Essas limitações não impedem o estado homologado da Fase 1.

---

# Regra de Ouro de Funcionários

Preservar:

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

Comissão básica não é o motor completo de comissão.
~~~

---

# Estratégia de Uso do Codex

Durante a homologação dos Cadastros foi identificado consumo relevante de tokens em tarefas amplas.

A estratégia foi revista.

## Responsabilidade do Usuário

- decisão funcional;
- teste manual;
- homologação.

## Responsabilidade do ChatGPT

- análise;
- leitura do GitHub;
- investigação;
- arquitetura;
- localização da causa;
- definição da correção;
- criação do prompt;
- revisão do commit.

## Responsabilidade do Codex

- implementação;
- alteração dos arquivos;
- testes necessários;
- commit.

---

# Regra de Economia de Codex

Para correção localizada:

~~~text
ANALISAR ANTES
LOCALIZAR CAUSA
DEFINIR ARQUIVOS
ENVIAR PROMPT CIRÚRGICO
EXECUTAR TESTES ESPECÍFICOS
HOMOLOGAR
~~~

Evitar solicitar ao Codex:

~~~text
Investigue todo o projeto
~~~

quando a causa já puder ser determinada anteriormente.

---

# Estratégia de Testes

Correção pequena:

- testes específicos;
- validação técnica necessária;
- homologação manual.

Checkpoint relevante:

- suíte ampla;
- build;
- regressão;
- homologação.

Fechamento de módulo:

- testes automatizados relevantes;
- regressão;
- homologação completa;
- documentação.

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

# Próxima Etapa

Os três primeiros cadastros revisados foram concluídos:

~~~text
CLIENTES
FORNECEDORES
FUNCIONÁRIOS
~~~

O próximo cadastro do grupo ainda deve ser definido conforme:

- ordem da barra lateral;
- dependências funcionais;
- impacto sobre outros módulos;
- prioridade do produto.

Status:

~~~text
PRÓXIMO CADASTRO
A DEFINIR
~~~

Antes de implementação deverá ocorrer:

1. análise funcional;
2. levantamento das regras atuais;
3. leitura do backend;
4. leitura do frontend;
5. análise dos vínculos existentes;
6. análise multiempresa;
7. análise de permissões;
8. análise de auditoria;
9. definição do escopo funcional;
10. somente então implementação.

O método de economia de Codex deve continuar sendo utilizado.

---

# Próximos Cadastros

Ordem atual:

~~~text
1. Clientes → CONCLUÍDO
2. Fornecedores → CONCLUÍDO
3. Funcionários → CONCLUÍDO
4. Demais cadastros → A DEFINIR
~~~

A ordem dos demais cadastros deverá ser definida conforme dependências funcionais.

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
→ HOMOLOGADO
→ DOCUMENTADO

CADASTROS > CLIENTES
→ CONCLUÍDO
→ 23/23 ITENS HOMOLOGADOS
→ DOCUMENTADO

CADASTROS > FORNECEDORES
→ CONCLUÍDO
→ FASE 1 HOMOLOGADA
→ 30/30 ITENS APROVADOS
→ DOCUMENTADO

CADASTROS > FUNCIONÁRIOS
→ CONCLUÍDO
→ FASE 1 HOMOLOGADA
→ 17/17 ITENS APROVADOS
→ DOCUMENTADO

PRÓXIMO CADASTRO
→ A DEFINIR
~~~

---

# Estado do Projeto em 12/08/2026

A estrutura operacional central está concluída e homologada.

O grupo Cadastros possui atualmente três módulos formalmente encerrados:

~~~text
CLIENTES
FORNECEDORES
FUNCIONÁRIOS
~~~

Resultados:

~~~text
CLIENTES
23/23 HOMOLOGADOS

FORNECEDORES
30/30 HOMOLOGADOS

FUNCIONÁRIOS
17/17 HOMOLOGADOS
~~~

O próximo cadastro deverá ser definido antes de iniciar uma nova implementação.

O desenvolvimento deve continuar preservando:

- isolamento multiempresa;
- regras de tenant no backend;
- perfis e permissões;
- Auditoria Central;
- integridade histórica;
- proteção de dados sensíveis;
- separação dos domínios;
- paginação e filtros server-side;
- compatibilidade com integrações existentes;
- documentação estruturada no Obsidian;
- homologação item a item;
- uso econômico do Codex.

---

# Estado Documental do Grupo Cadastros

## Clientes

~~~text
Homologação
Mapa Técnico
Modelo de Domínio
Workflows
Riscos e Cuidados
Sysvar.md atualizado
~~~

Status:

~~~text
DOCUMENTAÇÃO CONCLUÍDA
~~~

## Fornecedores

~~~text
Homologação
Mapa Técnico
Modelo de Domínio
Workflows
Riscos e Cuidados
Sysvar.md atualizado
~~~

Status:

~~~text
DOCUMENTAÇÃO CONCLUÍDA
~~~

## Funcionários

~~~text
Homologação
Mapa Técnico
Modelo de Domínio
Workflows
Riscos e Cuidados
Sysvar.md atualizado
~~~

Status:

~~~text
DOCUMENTAÇÃO CONCLUÍDA
~~~

---

# Marco Atual

Em 12/08/2026 o projeto atingiu o seguinte marco:

~~~text
INFRAESTRUTURA OPERACIONAL
CONCLUÍDA E HOMOLOGADA

CLIENTES
CONCLUÍDO E HOMOLOGADO

FORNECEDORES
FASE 1 CONCLUÍDA E HOMOLOGADA

FUNCIONÁRIOS
FASE 1 CONCLUÍDA E HOMOLOGADA
~~~

O grupo Cadastros permanece em andamento até que os demais cadastros relevantes sejam revisados.