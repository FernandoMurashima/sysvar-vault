---

type: reference  
status: active  
project: Sysvar  
source: "C:/SysvarProjeto"  
created: 2026-08-03  
updated: 2026-08-05  
tags:

- sysvar
    
- contexto
    
- negocio
    
- arquitetura
    
- auditoria
    
- saas
    

---

# Visão Geral

## O que é o SISVAR

O SISVAR é um ERP SaaS voltado ao varejo e à indústria de moda.

O sistema foi projetado para atender empresas com:

- uma ou várias lojas;
    
- estoque central;
    
- compras;
    
- produção própria;
    
- facções;
    
- distribuição para lojas;
    
- vendas;
    
- PDV;
    
- controle fiscal;
    
- controle financeiro;
    
- gestão contábil;
    
- relatórios e dashboards.
    

A arquitetura suporta múltiplas empresas no mesmo sistema, mantendo os dados completamente isolados.

---

# Objetivo do produto

O objetivo do SISVAR é centralizar as operações de empresas do ramo de moda em uma única plataforma.

O sistema deve permitir acompanhar o fluxo completo:

```text
Cadastro
→ Produto
→ Compra ou Produção
→ Entrada no Estoque
→ Distribuição
→ Venda
→ Fiscal
→ Financeiro
→ Contabilidade
→ Relatórios
→ Auditoria
```

O foco do produto é oferecer controle operacional, financeiro e gerencial sem exigir que o cliente compre ou utilize módulos que não necessita.

---

# Público-alvo

O SISVAR é direcionado principalmente a:

- pequenas e médias lojas de roupas;
    
- redes de lojas;
    
- empresas com estoque central;
    
- empresas que compram produtos para revenda;
    
- empresas com produção própria;
    
- empresas que utilizam facções;
    
- empresas que distribuem mercadorias para várias lojas;
    
- empresas que precisam operar PDV online e offline.
    

---

# Modelo SaaS

Cada cliente é representado por uma empresa dentro da plataforma.

A empresa possui:

- contrato;
    
- módulos contratados;
    
- limite de acessos simultâneos;
    
- lojas;
    
- usuários;
    
- perfis;
    
- permissões;
    
- sessões;
    
- dados próprios;
    
- registros de auditoria.
    

A contratação pode incluir:

- licença básica;
    
- módulos adicionais;
    
- plano completo;
    
- quantidade de acessos simultâneos.
    

---

# Multiempresa

O SISVAR opera com múltiplas empresas.

Cada empresa possui isolamento completo dos seus dados.

Um usuário cliente não pode:

- visualizar outra empresa;
    
- consultar registros de outra empresa;
    
- alterar registros de outra empresa;
    
- utilizar loja de outra empresa;
    
- utilizar perfil de outra empresa;
    
- consultar sessões de outra empresa;
    
- consultar auditoria de outra empresa;
    
- exportar dados de outra empresa.
    

Esse isolamento é validado no backend.

---

# Multilojas

Uma empresa pode possuir várias lojas.

Cada loja pode possuir:

- estoque;
    
- usuários;
    
- caixas;
    
- vendas;
    
- sessões;
    
- movimentações;
    
- documentos fiscais;
    
- distribuição;
    
- auditoria.
    

Usuários comuns podem ser limitados a determinadas lojas.

O usuário master pode acessar todas as lojas da própria empresa.

---

# Usuários do sistema

## Superusuário da plataforma

Responsável pela administração global.

Pode:

- cadastrar empresas;
    
- configurar contratos;
    
- definir módulos;
    
- definir limites;
    
- consultar sessões globais;
    
- consultar auditoria global;
    
- realizar manutenção administrativa.
    

---

## Usuário master da empresa

É o administrador principal do cliente.

Pode administrar:

- usuários;
    
- perfis;
    
- permissões;
    
- sessões;
    
- lojas;
    
- auditoria;
    
- configurações liberadas.
    

O master possui acesso aos módulos contratados pela empresa.

---

## Usuários comuns

Recebem acesso conforme:

- empresa;
    
- lojas permitidas;
    
- perfil;
    
- módulos contratados;
    
- permissões efetivas.
    

Os níveis atuais de permissão são:

```text
NONE
VIEW
EDIT
```

O nome do perfil não concede acesso automaticamente.

O backend calcula o acesso efetivo.

---

# Licenciamento

O licenciamento é baseado em sessões simultâneas.

Não é baseado na quantidade de usuários cadastrados.

Regras:

- cadastrar usuário não consome licença;
    
- ativar usuário não consome licença;
    
- login cria uma sessão;
    
- sessão ativa consome uma vaga;
    
- logout libera a vaga;
    
- timeout libera a vaga;
    
- inativação encerra sessões;
    
- dispositivos diferentes consomem vagas diferentes;
    
- novo login no mesmo dispositivo substitui a sessão anterior;
    
- login acima do limite é bloqueado.
    

---

# Segurança

A segurança considera:

- usuário;
    
- empresa;
    
- loja;
    
- contrato;
    
- módulos;
    
- perfil;
    
- permissões;
    
- sessão;
    
- token;
    
- dispositivo.
    

O backend é a autoridade final.

O frontend pode ocultar menus, rotas e botões, mas toda operação é validada novamente no servidor.

O sistema utiliza:

- token opaco;
    
- hash do token no banco;
    
- sessão vinculada ao token;
    
- device ID;
    
- heartbeat;
    
- timeout;
    
- revogação;
    
- default deny.
    

---

# Auditoria Central

A primeira fase da Auditoria Central está implementada, testada, revisada e homologada.

A Auditoria registra eventos relacionados a:

- login;
    
- login negado;
    
- logout;
    
- sessões;
    
- timeout;
    
- limite simultâneo;
    
- contratos;
    
- módulos;
    
- master;
    
- perfis;
    
- permissões;
    
- usuários;
    
- acessos negados;
    
- consulta da Auditoria;
    
- exportação.
    

Cada evento pode registrar:

- empresa;
    
- loja;
    
- usuário;
    
- sessão;
    
- dispositivo;
    
- IP;
    
- user-agent;
    
- request ID;
    
- correlation ID;
    
- ação;
    
- categoria;
    
- resultado;
    
- severidade;
    
- origem;
    
- objeto;
    
- estado anterior;
    
- estado posterior;
    
- campos alterados;
    
- metadata;
    
- endpoint;
    
- status HTTP;
    
- erro;
    
- data e hora.
    

Os registros são:

- imutáveis;
    
- somente leitura;
    
- sanitizados;
    
- isolados por empresa;
    
- isolados por loja;
    
- consultáveis por permissão efetiva.
    

---

# Principais módulos

## Administração

Abrange:

- empresas;
    
- contratos;
    
- módulos;
    
- usuários;
    
- perfis;
    
- permissões;
    
- sessões;
    
- auditoria;
    
- configurações.
    

---

## Cadastros

Abrange:

- lojas;
    
- clientes;
    
- fornecedores;
    
- funcionários;
    
- naturezas de lançamento;
    
- plano financeiro;
    
- plano contábil;
    
- formas de pagamento;
    
- tabelas auxiliares.
    

---

## Produtos

Abrange:

- produtos;
    
- SKUs;
    
- grades;
    
- tamanhos;
    
- cores;
    
- coleções;
    
- grupos;
    
- subgrupos;
    
- NCM;
    
- unidades;
    
- tabelas de preço;
    
- packs.
    

---

## Compras

Abrange:

- pedidos;
    
- itens;
    
- packs;
    
- parcelas;
    
- aprovação;
    
- cancelamento;
    
- reabertura;
    
- recebimento.
    

A Entrada de Nota Fiscal será revisada como próxima grande frente.

---

## Estoque

Abrange:

- saldos;
    
- movimentações;
    
- entradas;
    
- saídas;
    
- transferências;
    
- ajustes;
    
- inventários;
    
- reservas.
    

---

## Produção

Deverá abranger:

- ficha técnica;
    
- matéria-prima;
    
- ordem de produção;
    
- consumo;
    
- facção;
    
- retorno;
    
- produto acabado.
    

A implementação existente ainda será revisada detalhadamente.

---

## Distribuição

Deverá controlar:

- estoque de origem;
    
- lojas de destino;
    
- perfis percentuais;
    
- quantidades por tamanho;
    
- reserva;
    
- separação;
    
- pedidos por loja;
    
- transferências;
    
- faturamento;
    
- recebimento.
    

---

## Vendas e PDV

Abrange ou deverá abranger:

- orçamento;
    
- pedido;
    
- venda;
    
- itens;
    
- pagamentos;
    
- descontos;
    
- caixa;
    
- NFC-e;
    
- devoluções;
    
- PDV Offline.
    

---

## Fiscal

Abrange:

- NF-e;
    
- NFC-e;
    
- documentos fiscais;
    
- impostos;
    
- emissão;
    
- rejeições;
    
- contingência;
    
- integrações.
    

---

## Financeiro

Abrange:

- contas a pagar;
    
- contas a receber;
    
- parcelas;
    
- baixas;
    
- cancelamentos;
    
- reaberturas;
    
- caixa;
    
- bancos;
    
- fluxo de caixa;
    
- rateios.
    

---

## Contabilidade

Abrange:

- plano contábil;
    
- contas;
    
- hierarquia;
    
- lançamentos;
    
- integração financeira;
    
- estornos.
    

---

## Relatórios e Dashboards

Devem consolidar informações de:

- vendas;
    
- estoque;
    
- compras;
    
- financeiro;
    
- fiscal;
    
- produção;
    
- distribuição;
    
- auditoria.
    

O acesso depende dos módulos contratados e da permissão efetiva.

---

# Situação atual

## Infraestrutura concluída

- autenticação centralizada;
    
- isolamento multiempresa;
    
- isolamento por loja;
    
- contratos;
    
- módulos contratados;
    
- usuário master;
    
- perfis;
    
- permissões efetivas;
    
- sessões;
    
- tokens;
    
- licenciamento simultâneo;
    
- device ID;
    
- heartbeat;
    
- timeout;
    
- encerramento administrativo;
    
- Auditoria Central;
    
- indicadores da Auditoria;
    
- exportação CSV;
    
- imutabilidade;
    
- sanitização;
    
- snapshots históricos;
    
- auditoria obrigatória em operações críticas definidas.
    

---

## Módulos existentes que ainda serão revisados

- Cadastros;
    
- Produtos;
    
- Compras;
    
- Estoque;
    
- Financeiro;
    
- Fiscal;
    
- Vendas;
    
- Dashboards;
    
- Produção;
    
- Distribuição.
    

A existência do módulo no código não significa que toda a sua arquitetura já foi validada.

Cada módulo será analisado individualmente.

---

# Processo de evolução

Cada módulo deverá seguir este fluxo:

```text
Definição funcional
→ Análise do código real
→ Análise arquitetural
→ Prompt para o Codex
→ Implementação
→ Testes técnicos
→ Testes funcionais
→ Revisão técnica
→ Correções
→ Atualização do Obsidian
→ ADR, quando necessária
→ Commit final
```

---

# Próxima prioridade recomendada

A próxima análise recomendada é:

```text
Entrada de Nota Fiscal
```

Essa funcionalidade deverá integrar:

- compras;
    
- fornecedor;
    
- produtos;
    
- SKUs;
    
- estoque;
    
- fiscal;
    
- financeiro;
    
- contabilidade;
    
- auditoria.
    

Antes da implementação será necessário verificar o que já existe no backend e frontend.

---

# Código e documentação

Código local:

```text
C:\SysvarProjeto
```

Backend:

```text
C:\SysvarProjeto\Backend
```

Frontend:

```text
C:\SysvarProjeto\Frontend\sysvar
```

Vault:

```text
C:\takeshi\takeshi
```

Repositórios:

```text
FernandoMurashima/sysvarbackend
FernandoMurashima/sysvarfrontend
FernandoMurashima/sysvar-vault
```

---

# Última atualização

```text
2026-08-05
```

---

# Notas relacionadas

- [[10 Projetos/Sysvar/Sysvar|Sysvar]]
    
- [[10 Projetos/Sysvar/Contexto do Projeto/Arquitetura|Arquitetura]]
    
- [[10 Projetos/Sysvar/Contexto do Projeto/Modelo de Domínio|Modelo de Domínio]]
    
- [[10 Projetos/Sysvar/Contexto do Projeto/Workflows|Workflows]]
    
- [[10 Projetos/Sysvar/Contexto do Projeto/Riscos e Cuidados|Riscos e Cuidados]]
    
- [[10 Projetos/Sysvar/Contexto do Projeto/Mapa Técnico|Mapa Técnico]]
    
- [[10 Projetos/Sysvar/Decisões Técnicas/ADR-001 - Licenciamento por Sessões Simultâneas|ADR-001 - Licenciamento por Sessões Simultâneas]]
    
- [[10 Projetos/Sysvar/Decisões Técnicas/ADR-002 - Princípios Arquiteturais do SISVAR|ADR-002 - Princípios Arquiteturais do SISVAR]]
    
- [[10 Projetos/Sysvar/Decisões Técnicas/ADR-003 - Auditoria Central do SISVAR|ADR-003 - Auditoria Central do SISVAR]]