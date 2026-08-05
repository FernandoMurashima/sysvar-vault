---

type: project  
status: active  
project: Sysvar  
source: "C:/SysvarProjeto"  
created: 2026-08-03  
updated: 2026-08-05  
tags:

- projeto
    
- sysvar
    

---

# Sysvar

## O que é

O Sysvar é um ERP para o varejo de moda desenvolvido em Django REST Framework, Angular 17 e MySQL.

O sistema foi concebido para operar em ambiente SaaS, suportando múltiplas empresas, múltiplas lojas por empresa, módulos contratáveis, controle de acesso por perfis, licenciamento por sessões simultâneas e auditoria central das operações.

Seu desenvolvimento segue uma arquitetura modular, permitindo evolução contínua sem comprometer os módulos já consolidados.

---

# Objetivos do projeto

O objetivo do Sysvar é fornecer uma plataforma única para administrar as operações de uma empresa do ramo de moda, contemplando cadastros, produtos, compras, estoque, vendas, fiscal, financeiro, produção, distribuição e indicadores gerenciais.

O projeto prioriza:

- simplicidade operacional;
    
- segurança;
    
- isolamento entre empresas;
    
- isolamento por loja;
    
- escalabilidade;
    
- padronização de interface;
    
- auditoria das operações críticas;
    
- documentação técnica continuamente atualizada.
    

---

# Áreas principais

O sistema contempla os seguintes grandes módulos e áreas:

- Administração
    
- Empresas
    
- Contratos
    
- Lojas
    
- Usuários
    
- Perfis e Permissões
    
- Sessões e Licenciamento
    
- Cadastros Gerais
    
- Produtos
    
- Compras
    
- Fiscal
    
- Estoque
    
- Produção
    
- Distribuição
    
- PDV
    
- Vendas
    
- Financeiro
    
- Contabilidade
    
- Dashboards
    
- Relatórios
    
- Auditoria
    

---

# Arquitetura funcional

A arquitetura do Sysvar está baseada nos seguintes pilares.

## Segurança

O controle de acesso considera:

- usuário;
    
- empresa;
    
- loja;
    
- contrato;
    
- módulos contratados;
    
- perfil;
    
- permissões efetivas;
    
- sessão;
    
- limite de acessos simultâneos.
    

O backend é a autoridade final para autenticação, autorização e regras de negócio.

Ocultar menu, botão ou rota no frontend não substitui a validação do backend.

---

## Multiempresa

Cada empresa possui isolamento dos seus dados.

Nenhum usuário cliente pode visualizar, consultar ou alterar informações pertencentes a outra empresa.

O isolamento deve permanecer válido mesmo quando houver:

- manipulação de URL;
    
- alteração de parâmetros;
    
- chamada direta à API;
    
- envio de IDs pertencentes a outra empresa;
    
- tentativa de filtrar dados de outro cliente.
    

---

## Multilojas

Quando uma operação depende de loja, o backend verifica:

- se a loja pertence à empresa;
    
- se o usuário possui acesso à loja;
    
- se o registro pertence ao contexto permitido.
    

Usuários comuns acessam apenas as lojas permitidas.

O usuário master acessa todas as lojas da própria empresa.

---

## Modularização

Cada funcionalidade pertence a um módulo do sistema.

Os módulos contratados determinam quais:

- menus;
    
- telas;
    
- rotas;
    
- endpoints;
    
- operações;
    

ficam disponíveis para a empresa.

Módulos não contratados permanecem bloqueados no frontend e no backend.

---

## Serviços centrais

Regras transversais são mantidas em serviços centrais.

Exemplos:

- autenticação;
    
- contratos;
    
- módulos;
    
- permissões efetivas;
    
- sessões;
    
- licenciamento;
    
- transferência de master;
    
- auditoria.
    

Novos módulos não devem criar mecanismos paralelos para essas responsabilidades.

---

## Auditoria

A Auditoria Central registra operações críticas e eventos de segurança.

Ela mantém contexto como:

- empresa;
    
- loja;
    
- usuário;
    
- sessão;
    
- dispositivo;
    
- IP;
    
- request ID;
    
- ação;
    
- categoria;
    
- resultado;
    
- severidade;
    
- objeto;
    
- valores anteriores;
    
- valores posteriores;
    
- data e hora.
    

Os logs são somente leitura, imutáveis e isolados por empresa e loja.

---

# Situação atual

## Infraestrutura concluída

- Autenticação multiempresa.
    
- Isolamento entre empresas.
    
- Isolamento por loja.
    
- Contratos por empresa.
    
- Controle de módulos contratados.
    
- Usuário master.
    
- Perfis de acesso.
    
- Permissões efetivas.
    
- Controle de acesso no frontend.
    
- Proteção de endpoints no backend.
    
- Licenciamento por sessões simultâneas.
    
- Token vinculado à sessão.
    
- Device ID.
    
- Heartbeat.
    
- Timeout de sessão.
    
- Encerramento administrativo de sessões.
    
- Auditoria Central.
    
- Tela de consulta da Auditoria.
    
- Indicadores da Auditoria.
    
- Exportação CSV da Auditoria.
    
- Imutabilidade dos logs.
    
- Sanitização de dados sensíveis.
    
- Snapshots históricos de empresa, loja e usuário.
    
- Auditoria obrigatória para operações críticas definidas.
    

---

## Cenários validados

Foram testados com sucesso:

- criação de empresa;
    
- criação do usuário master;
    
- criação de usuários;
    
- perfis;
    
- permissões;
    
- isolamento entre empresas;
    
- isolamento por loja;
    
- login;
    
- logout;
    
- sessões simultâneas;
    
- bloqueio pelo limite contratado;
    
- substituição da sessão no mesmo dispositivo;
    
- liberação da vaga no logout;
    
- liberação da vaga no timeout;
    
- acesso à Auditoria pelo master;
    
- acesso à Auditoria com permissão `VIEW`;
    
- exportação disponível com permissão `EDIT`;
    
- bloqueio com permissão `NONE`;
    
- consulta de logs da própria empresa;
    
- bloqueio de consulta de outra empresa;
    
- bloqueio de loja não permitida;
    
- exibição de usuário, empresa, ação e data;
    
- comparação entre valores anteriores e posteriores;
    
- bloqueio de edição e exclusão de logs;
    
- sanitização de senha, token e outros segredos;
    
- recuperação de contexto histórico de logs antigos quando existe fonte confiável.
    

---

# Modelo de licenciamento

O Sysvar utiliza licenciamento por sessões simultâneas.

As licenças não são consumidas pela quantidade de usuários cadastrados.

Uma empresa pode possuir vários usuários cadastrados.

O consumo ocorre somente quando existe uma sessão ativa e válida.

Regras:

- criar usuário não consome licença;
    
- ativar usuário não consome licença;
    
- login cria uma sessão;
    
- cada sessão ativa consome uma vaga;
    
- logout libera imediatamente a vaga;
    
- timeout libera a vaga;
    
- inativação do usuário encerra suas sessões;
    
- login no mesmo dispositivo substitui a sessão anterior;
    
- dispositivos diferentes utilizam sessões independentes;
    
- login acima do limite contratado é bloqueado;
    
- redução do limite não encerra sessões automaticamente;
    
- novos logins ficam bloqueados enquanto o limite estiver excedido.
    

---

# Auditoria Central

A primeira fase da Auditoria Central está concluída, testada, revisada e homologada.

## Estrutura

O model central registra:

- identificador do evento;
    
- identificador da requisição;
    
- identificador de correlação;
    
- empresa;
    
- loja;
    
- usuário;
    
- sessão;
    
- dispositivo;
    
- ação;
    
- categoria;
    
- resultado;
    
- severidade;
    
- origem;
    
- entidade;
    
- objeto;
    
- antes;
    
- depois;
    
- campos alterados;
    
- metadata;
    
- contexto HTTP;
    
- erro;
    
- data e hora.
    

## Consulta

A API disponibiliza:

```text
GET /api/auditoria/logs/
GET /api/auditoria/logs/{id}/
GET /api/auditoria/logs/indicadores/
GET /api/auditoria/logs/exportar/
```

## Permissões

- superusuário consulta todas as empresas;
    
- master consulta toda a própria empresa;
    
- `auditoria=VIEW` permite consulta;
    
- `auditoria=EDIT` permite consulta e exportação;
    
- `auditoria=NONE` bloqueia menu, rota e API.
    

Nenhum usuário pode alterar ou excluir logs.

## Integrações atuais

A Auditoria Central já está integrada a:

- autenticação;
    
- login;
    
- login negado;
    
- logout;
    
- sessões;
    
- timeout;
    
- substituição de sessão;
    
- limite simultâneo;
    
- contratos;
    
- módulos contratados;
    
- transferência de master;
    
- perfis;
    
- perfil padrão;
    
- permissões;
    
- usuários;
    
- ativação;
    
- inativação;
    
- exclusão administrativa;
    
- consulta e exportação da própria Auditoria.
    

A integração detalhada com os eventos de negócio dos demais módulos ocorrerá durante a revisão individual de cada módulo.

---

# Decisões arquiteturais registradas

## ADR-001

Licenciamento por sessões simultâneas.

Usuários cadastrados não consomem licença.

Somente sessões ativas consomem vagas.

## ADR-002

Princípios arquiteturais do Sysvar.

Define, entre outros pontos:

- backend como autoridade final;
    
- default deny;
    
- isolamento multiempresa;
    
- isolamento por loja;
    
- serviços centrais;
    
- operações críticas transacionais;
    
- testes e documentação obrigatórios;
    
- uso de ADRs para decisões relevantes.
    

## ADR-003

Auditoria Central do Sysvar.

Define:

- infraestrutura única;
    
- logs estruturados;
    
- imutabilidade;
    
- sanitização;
    
- snapshots;
    
- permissões de consulta;
    
- isolamento;
    
- auditoria normal e obrigatória;
    
- integração gradual com os módulos.
    

---

# Processo oficial de desenvolvimento

Toda nova tarefa deve seguir, conforme aplicável:

1. definição funcional;
    
2. análise arquitetural;
    
3. leitura do código existente;
    
4. elaboração do prompt;
    
5. implementação;
    
6. testes técnicos;
    
7. testes funcionais;
    
8. revisão técnica;
    
9. correções;
    
10. atualização do Obsidian;
    
11. atualização ou criação de ADR;
    
12. commit do código;
    
13. commit da documentação.
    

Uma funcionalidade não é considerada concluída apenas porque foi implementada.

Ela precisa estar:

- testada;
    
- revisada;
    
- homologada;
    
- documentada;
    
- versionada.
    

---

# Próximas etapas

Com autenticação, licenciamento, permissões e Auditoria Central consolidados, as próximas frentes serão escolhidas por prioridade funcional.

Candidatos registrados:

1. Entrada de Nota Fiscal.
    
2. Revisão do módulo Cadastros.
    
3. Revisão do módulo Produtos.
    
4. Produção.
    
5. Distribuição.
    
6. PDV Offline.
    
7. Dashboards gerenciais.
    
8. Relatórios.
    
9. Otimizações de performance.
    
10. Revisão dos eventos de auditoria de cada módulo.
    

A Auditoria Central deverá ser integrada aos eventos específicos de cada módulo durante sua revisão.

---

# Fonte do projeto

Código-fonte:

- `C:\SysvarProjeto`
    

Backend:

- `C:\SysvarProjeto\Backend`
    

Frontend:

- `C:\SysvarProjeto\Frontend\sysvar`
    

Documentação existente:

- `C:\SysvarProjeto\docs`
    

Vault Obsidian:

- `C:\takeshi\takeshi`
    

Repositórios:

- `FernandoMurashima/sysvarbackend`
    
- `FernandoMurashima/sysvarfrontend`
    
- `FernandoMurashima/sysvar-vault`
    

---

# Notas relacionadas

- [[10 Projetos/Sysvar/Contexto do Projeto/Visão Geral|Visão Geral]]
    
- [[10 Projetos/Sysvar/Contexto do Projeto/Arquitetura|Arquitetura]]
    
- [[10 Projetos/Sysvar/Contexto do Projeto/Modelo de Domínio|Modelo de Domínio]]
    
- [[10 Projetos/Sysvar/Contexto do Projeto/Workflows|Workflows]]
    
- [[10 Projetos/Sysvar/Contexto do Projeto/Mapa Técnico|Mapa Técnico]]
    
- [[10 Projetos/Sysvar/Contexto do Projeto/Riscos e Cuidados|Riscos e Cuidados]]
    
- [[10 Projetos/Sysvar/Decisões Técnicas/ADR-001 - Licenciamento por Sessões Simultâneas|ADR-001 - Licenciamento por Sessões Simultâneas]]
    
- [[10 Projetos/Sysvar/Decisões Técnicas/ADR-002 - Princípios Arquiteturais do SISVAR|ADR-002 - Princípios Arquiteturais do SISVAR]]
    
- [[10 Projetos/Sysvar/Decisões Técnicas/ADR-003 - Auditoria Central do SISVAR|ADR-003 - Auditoria Central do SISVAR]]