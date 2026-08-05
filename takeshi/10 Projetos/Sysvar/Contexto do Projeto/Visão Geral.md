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
    
- operacional
    
- auditoria
    
- saas
    

---

# Visão Geral

## O que é o SISVAR

O SISVAR é um ERP SaaS voltado ao varejo e à indústria de moda.

O sistema foi projetado para atender empresas com:

- uma ou várias lojas;
    
- matriz;
    
- fábrica;
    
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
    
- relatórios;
    
- dashboards;
    
- auditoria.
    

A arquitetura suporta várias empresas na mesma plataforma, mantendo os dados isolados por empresa e, quando aplicável, por estabelecimento.

---

# Objetivo do Produto

O objetivo do SISVAR é centralizar as operações de empresas do ramo de moda em uma única plataforma.

O sistema deve permitir acompanhar o fluxo completo:

```text
Administração
→ Cadastros
→ Produtos
→ Compra ou Produção
→ Estoque
→ Distribuição
→ Venda
→ Fiscal
→ Financeiro
→ Contabilidade
→ Relatórios
→ Auditoria
```

O produto deve oferecer controle operacional, financeiro e gerencial sem obrigar o cliente a contratar módulos que não utiliza.

---

# Público-Alvo

O SISVAR é direcionado principalmente a:

- pequenas e médias lojas de roupas;
    
- redes de lojas;
    
- empresas com estoque central;
    
- empresas que compram produtos para revenda;
    
- empresas com produção própria;
    
- empresas que trabalham com facções;
    
- empresas que distribuem mercadorias para várias lojas;
    
- empresas que precisam operar PDV online e offline.
    

---

# Modelo SaaS

Cada cliente é representado por uma empresa dentro da plataforma.

A empresa possui:

- contrato;
    
- módulos contratados;
    
- usuário master;
    
- limite de acessos simultâneos;
    
- estabelecimentos;
    
- usuários;
    
- perfis;
    
- permissões;
    
- sessões;
    
- dados operacionais;
    
- registros de auditoria.
    

A contratação pode incluir:

- licença básica;
    
- módulos adicionais;
    
- plano completo;
    
- quantidade de acessos simultâneos.
    

O licenciamento é baseado em sessões simultâneas, e não na quantidade de usuários cadastrados.

---

# Multiempresa

O SISVAR opera com múltiplas empresas.

Cada empresa possui isolamento dos seus dados.

Um usuário cliente não pode:

- visualizar outra empresa;
    
- consultar registros de outra empresa;
    
- alterar registros de outra empresa;
    
- utilizar estabelecimento de outra empresa;
    
- utilizar perfil de outra empresa;
    
- consultar sessões de outra empresa;
    
- consultar auditoria de outra empresa;
    
- exportar dados de outra empresa;
    
- criar vínculos entre empresas diferentes.
    

Esse isolamento é validado no backend.

A empresa enviada pelo frontend não é considerada fonte de verdade isoladamente.

---

# Multilojas e Estabelecimentos

Uma empresa pode possuir vários estabelecimentos.

Tipos atuais:

```text
LOJA
MATRIZ
FABRICA
```

Todo estabelecimento pertence obrigatoriamente a uma empresa.

Antes de tornar o vínculo obrigatório, foi executado o diagnóstico:

```text
lojas_sem_empresa = 0
```

Nenhum saneamento foi necessário.

Cada estabelecimento pode possuir:

- usuários vinculados;
    
- sessões;
    
- estoque;
    
- caixas;
    
- vendas;
    
- movimentações;
    
- documentos fiscais;
    
- distribuição;
    
- configurações fiscais;
    
- registros de auditoria.
    

Usuários comuns podem ser limitados a determinadas lojas.

O usuário master pode acessar todos os estabelecimentos da própria empresa.

---

# Grupo Operacional

O primeiro grupo revisado integralmente foi:

```text
Operacional
├── Empresas
├── Estabelecimento
├── Usuários
├── Perfis de acesso
└── Auditoria
```

A implementação técnica do grupo foi concluída.

Foram realizados:

- análise do código real;
    
- definição das regras;
    
- implementação;
    
- migrations;
    
- testes backend;
    
- testes frontend;
    
- revisão técnica dos commits;
    
- correções de endurecimento;
    
- atualização da documentação.
    

A homologação manual completa no navegador ainda permanece pendente.

---

# Empresas e Contratos

A empresa representa o cliente da plataforma.

O contrato controla:

- situação;
    
- vigência;
    
- módulos contratados;
    
- plano completo;
    
- limite simultâneo;
    
- usuário master;
    
- versão das permissões;
    
- suspensão;
    
- reativação.
    

Estados possíveis incluem:

```text
PENDENTE
ATIVO
SUSPENSO
VENCIDO
CANCELADO
```

---

# Suspensão Administrativa

Foi implementado o bloqueio administrativo de uma empresa.

A suspensão pode ocorrer por motivos como:

```text
INADIMPLENCIA
SOLICITACAO_CLIENTE
RISCO_SEGURANCA
ENCERRAMENTO_CONTRATO
BLOQUEIO_ADMINISTRATIVO
OUTRO
```

Inadimplência é o motivo.

O estado operacional do contrato é `SUSPENSO`.

## Efeito da Suspensão

Ao suspender uma empresa:

1. o contrato é bloqueado em transação;
    
2. o status passa para `SUSPENSO`;
    
3. motivo, observação, data e executor são registrados;
    
4. todas as sessões ativas são encerradas;
    
5. todos os tokens são revogados;
    
6. todas as vagas simultâneas são liberadas;
    
7. a versão das permissões é atualizada;
    
8. a Auditoria obrigatória registra a operação.
    

Se a Auditoria obrigatória falhar, toda a operação sofre rollback.

## Acesso Bloqueado

Uma empresa suspensa não consegue:

- realizar novos logins;
    
- continuar utilizando sessões antigas;
    
- utilizar tokens anteriores;
    
- utilizar o heartbeat;
    
- acessar endpoints protegidos.
    

Código retornado:

```text
CONTRACT_SUSPENDED
```

Mensagem pública:

```text
O acesso da empresa está temporariamente suspenso. Entre em contato com o suporte.
```

O motivo comercial detalhado não é exposto ao usuário comum.

---

# Reativação

A reativação:

- retorna o contrato para `ATIVO`;
    
- preserva o histórico da suspensão;
    
- registra data e executor;
    
- atualiza a versão das permissões;
    
- não reativa sessões antigas;
    
- exige novo login;
    
- utiliza Auditoria obrigatória.
    

---

# Usuários do Sistema

## Superusuário da Plataforma

É o administrador global.

Pode:

- cadastrar empresas;
    
- configurar contratos;
    
- suspender e reativar empresas;
    
- definir módulos;
    
- definir limites;
    
- transferir master;
    
- consultar sessões globais;
    
- consultar auditoria global;
    
- realizar manutenção administrativa.
    

O superusuário não está sujeito ao limite de sessões das empresas clientes.

---

## Usuário Master

É o administrador principal da empresa cliente.

Pode administrar, dentro da própria empresa:

- estabelecimentos;
    
- usuários;
    
- perfis;
    
- permissões;
    
- sessões;
    
- auditoria;
    
- configurações permitidas.
    

O master não pode ser:

- excluído;
    
- inativado;
    
- movido para outra empresa;
    
- rebaixado por edição comum.
    

A transferência utiliza fluxo específico, transação e Auditoria obrigatória.

---

## Usuários Comuns

Recebem acesso conforme:

- empresa;
    
- estabelecimentos permitidos;
    
- perfil;
    
- módulos contratados;
    
- override individual;
    
- permissões efetivas.
    

Níveis atuais:

```text
NONE
VIEW
EDIT
```

O nome do perfil ou o tipo funcional não concede acesso automaticamente.

O backend calcula o acesso efetivo.

---

# Tipo Funcional

O usuário ainda pode possuir classificações como:

```text
Regular
Vendedor
Caixa
Gerente
Diretor
Admin
Auxiliar
Assistente
AssistenteReceber
AssistentePagar
```

O tipo funcional pode ser utilizado por regras operacionais específicas.

Ele não deve:

- conceder módulo;
    
- remover módulo;
    
- substituir perfil;
    
- criar override;
    
- definir a permissão efetiva.
    

---

# Perfis e Permissões

A regra oficial é:

```text
Perfil principal
+ Override individual
+ Contrato
+ Módulos contratados
= Permissão efetiva
```

## Perfil

O perfil:

- pertence a uma empresa;
    
- pode ser ativo ou inativo;
    
- possui permissões por módulo;
    
- pode ser definido como padrão;
    
- não pode habilitar módulo não contratado;
    
- deve respeitar dependências entre módulos.
    

## Override

Valores apresentados ao usuário:

```text
HERDAR
NONE
VIEW
EDIT
```

`HERDAR` significa remover a permissão individual e voltar a utilizar o perfil.

## Matriz de Permissões

A tela de usuários utiliza:

|Módulo|Perfil|Override|Efetivo|
|---|---|---|---|
|Compras|VIEW|EDIT|EDIT|
|Financeiro|NONE|HERDAR|NONE|
|Auditoria|VIEW|HERDAR|VIEW|

O valor efetivo é calculado pelo backend.

## Perfil Padrão

A regra de apenas um perfil padrão por empresa é garantida pela aplicação.

Utiliza:

```text
transaction.atomic()
select_for_update()
```

Não depende de constraint condicional incompatível com MySQL.

---

# Estabelecimentos

A tela de Estabelecimentos utiliza o módulo:

```text
operacional
```

Regras:

```text
NONE
→ sem acesso

VIEW
→ consulta

EDIT
→ criação e alteração
```

A rota não depende mais exclusivamente dos tipos antigos:

```text
Diretor
Gerente
```

## Ciclo de Vida

Foram implementadas ações explícitas:

```text
Ativar
Inativar
Encerrar
Reabrir
```

O encerramento não exclui o histórico.

Antes de inativar ou encerrar, o backend pode verificar impedimentos como:

- sessões ativas;
    
- usuários vinculados;
    
- loja principal de usuários;
    
- operações pendentes;
    
- dependências operacionais.
    

## Usuários Vinculados

A consulta do estabelecimento pode apresentar:

- usuário;
    
- nome;
    
- perfil;
    
- loja principal;
    
- loja permitida;
    
- situação;
    
- sessão ativa.
    

---

# Ciclo de Vida dos Usuários

As operações foram separadas em:

```text
Criar
Consultar
Editar
Ativar
Inativar
Redefinir senha
Encerrar sessão
Encerrar todas as sessões
Excluir administrativamente
Transferir administração
```

Regras principais:

- criar usuário não consome licença;
    
- ativar usuário não consome licença;
    
- inativar encerra sessões;
    
- inativar libera vagas;
    
- master não pode ser inativado;
    
- master não pode ser excluído;
    
- exclusão deve ser excepcional;
    
- usuário não pode elevar a própria permissão;
    
- usuário não pode alterar sua própria empresa;
    
- usuário não pode ampliar suas próprias lojas.
    

---

# Sessões do Usuário

A tela de usuários pode consultar:

- dispositivo;
    
- IP;
    
- estabelecimento;
    
- início;
    
- última atividade;
    
- situação;
    
- motivo do encerramento.
    

Ações disponíveis:

```text
Encerrar sessão
Encerrar todas as sessões
```

O encerramento de todas as sessões é transacional.

Se a Auditoria obrigatória falhar:

- as sessões permanecem ativas;
    
- os tokens permanecem válidos;
    
- nenhuma alteração parcial é confirmada.
    

Evento consolidado:

```text
USER_SESSIONS_CLOSED
```

---

# Redefinição Administrativa de Senha

Um administrador autorizado pode redefinir a senha de um usuário.

A operação:

- valida a senha;
    
- marca `deve_trocar_senha`;
    
- pode encerrar todas as sessões;
    
- revoga tokens;
    
- exige novo login;
    
- registra Auditoria obrigatória.
    

Evento:

```text
USER_PASSWORD_RESET
```

A senha nunca é registrada na Auditoria.

A operação é transacional.

Se a Auditoria falhar:

- a senha anterior permanece;
    
- a flag anterior permanece;
    
- as sessões permanecem;
    
- os tokens permanecem.
    

---

# Troca Obrigatória de Senha

Quando:

```text
deve_trocar_senha = true
```

o usuário consegue autenticar, mas não consegue acessar os módulos normais.

O backend permite somente os recursos mínimos:

- `/api/me/`;
    
- troca de senha;
    
- logout;
    
- heartbeat necessário.
    

Outros endpoints retornam:

```text
PASSWORD_CHANGE_REQUIRED
```

Mensagem:

```text
Você precisa alterar sua senha antes de continuar.
```

## Frontend

Rota específica:

```text
/change-password-required
```

O guard:

- redireciona o usuário;
    
- bloqueia acesso direto ao `/home`;
    
- impede bypass por URL;
    
- mantém logout disponível;
    
- libera o sistema após a troca.
    

Após a alteração:

- `deve_trocar_senha` passa para falso;
    
- outras sessões são encerradas;
    
- a sessão atual permanece;
    
- `/api/me/` é atualizado;
    
- o acesso aos módulos é liberado.
    

Evento:

```text
USER_PASSWORD_CHANGED
```

---

# Licenciamento

O licenciamento é baseado em sessões simultâneas.

Não é baseado na quantidade de usuários cadastrados.

Regras:

- cadastrar usuário não consome licença;
    
- ativar usuário não consome licença;
    
- login cria sessão;
    
- sessão ativa consome vaga;
    
- logout libera vaga;
    
- timeout libera vaga;
    
- inativação libera vaga;
    
- suspensão da empresa libera todas as vagas;
    
- redefinição de senha pode encerrar sessões;
    
- dispositivos diferentes consomem vagas diferentes;
    
- login no mesmo dispositivo substitui a sessão anterior;
    
- login acima do limite é bloqueado.
    

---

# Segurança

A segurança considera:

- usuário;
    
- empresa;
    
- estabelecimento;
    
- contrato;
    
- status do contrato;
    
- módulos;
    
- perfil;
    
- override;
    
- permissão efetiva;
    
- sessão;
    
- token;
    
- dispositivo;
    
- troca obrigatória de senha.
    

O backend é a autoridade final.

O frontend pode ocultar menus, rotas e botões, mas todas as operações são validadas novamente no servidor.

O sistema utiliza:

- token opaco;
    
- hash do token no banco;
    
- sessão vinculada ao token;
    
- device ID;
    
- heartbeat;
    
- timeout;
    
- revogação;
    
- default deny;
    
- bloqueio central de senha pendente;
    
- Auditoria obrigatória em operações críticas.
    

---

# Auditoria Central

A Auditoria Central está implementada, testada, revisada e homologada.

Ela registra eventos relacionados a:

- login;
    
- login negado;
    
- logout;
    
- sessões;
    
- timeout;
    
- limite simultâneo;
    
- contratos;
    
- suspensão;
    
- reativação;
    
- módulos;
    
- master;
    
- estabelecimentos;
    
- perfis;
    
- permissões;
    
- usuários;
    
- senhas;
    
- acessos negados;
    
- consulta da Auditoria;
    
- exportação.
    

Os eventos podem registrar:

- empresa;
    
- estabelecimento;
    
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

# Principais Grupos do Menu

## Operacional

Abrange:

- empresas;
    
- contratos;
    
- estabelecimentos;
    
- usuários;
    
- perfis;
    
- permissões;
    
- sessões;
    
- auditoria.
    

Status:

```text
Implementado
Validado automaticamente
Homologação manual pendente
```

---

## Cadastros

Primeiros itens:

- Clientes;
    
- Fornecedores;
    
- Funcionários.
    

Esse será o próximo grupo revisado após a homologação manual do Operacional.

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
    

A Entrada de Nota Fiscal será analisada dentro do momento correto da revisão de Compras e Fiscal.

Ela não está definida como próximo item imediato.

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

## Produção

Deverá abranger:

- ficha técnica;
    
- matéria-prima;
    
- ordem de produção;
    
- consumo;
    
- facção;
    
- retorno;
    
- produto acabado.
    

---

## Vendas e Módulo Loja

Abrangem ou deverão abranger:

- orçamento;
    
- pedido;
    
- venda;
    
- itens;
    
- pagamentos;
    
- descontos;
    
- caixa;
    
- NFC-e;
    
- devoluções;
    
- PDV;
    
- PDV Offline.
    

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
    

O acesso depende:

- da empresa;
    
- do estabelecimento;
    
- dos módulos contratados;
    
- da permissão efetiva;
    
- das dependências entre módulos.
    

---

# Situação Atual

## Infraestrutura Concluída

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
    
- auditoria obrigatória.
    

## Operacional Implementado

- Empresas;
    
- Contratos;
    
- suspensão;
    
- reativação;
    
- Estabelecimentos;
    
- empresa obrigatória no estabelecimento;
    
- ciclo de vida do estabelecimento;
    
- Usuários;
    
- Perfil/Override/Efetivo;
    
- sessões do usuário;
    
- redefinição administrativa de senha;
    
- troca obrigatória de senha;
    
- Perfis de acesso;
    
- perfil padrão;
    
- dependências de módulos;
    
- Auditoria integrada.
    

## Validação Automatizada

Backend:

```text
50 testes aprovados
```

Frontend:

```text
33 testes aprovados
```

Comandos executados:

```text
python manage.py check
python manage.py makemigrations --check --dry-run
python manage.py migrate
python manage.py test -v 2 --noinput

npx tsc -p tsconfig.app.json --noEmit
ng build --configuration development
ng test --watch=false --browsers=ChromeHeadless
```

## Homologação Manual Pendente

Ainda devem ser testados no navegador:

- suspensão com sessões abertas;
    
- reativação;
    
- invalidação de tokens antigos;
    
- troca obrigatória de senha;
    
- bloqueio por URL;
    
- usuário VIEW;
    
- usuário EDIT;
    
- ciclo completo de Estabelecimento;
    
- matriz Perfil/Override/Efetivo;
    
- dependências entre módulos;
    
- eventos novos na Auditoria.
    

---

# Processo de Evolução

Cada grupo ou módulo deve seguir:

```text
Definição funcional
→ Análise do código real
→ Análise arquitetural
→ Prompt para o Codex
→ Implementação
→ Testes técnicos
→ Revisão técnica
→ Correções
→ Homologação funcional
→ Atualização do Obsidian
→ ADR, quando necessária
→ Commit final
```

Uma funcionalidade não deve ser marcada como homologada apenas porque os testes automatizados passaram.

---

# Próxima Etapa

A etapa imediata é concluir a homologação manual do grupo Operacional.

Depois disso, a revisão seguirá a ordem real da barra lateral.

Próximo grupo:

```text
Cadastros
```

Primeiros itens:

- Clientes;
    
- Fornecedores;
    
- Funcionários.
    

A análise deverá verificar:

- isolamento;
    
- permissões;
    
- validações;
    
- layout;
    
- paginação;
    
- auditoria;
    
- integrações;
    
- testes;
    
- melhorias funcionais.
    

---

# Código e Documentação

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

Commits finais do grupo Operacional:

Backend:

```text
3955ea48c721afc7b15520a7afd6ec32f8374af6
```

Frontend:

```text
bf66e81e6f1c0d58255a135d9339a34b95ef332f
```

---

# Última Atualização

```text
2026-08-05
```

---

# Notas Relacionadas

- [[10 Projetos/Sysvar/Sysvar|Sysvar]]
    
- [[10 Projetos/Sysvar/Contexto do Projeto/Arquitetura|Arquitetura]]
    
- [[10 Projetos/Sysvar/Contexto do Projeto/Modelo de Domínio|Modelo de Domínio]]
    
- [[10 Projetos/Sysvar/Contexto do Projeto/Workflows|Workflows]]
    
- [[10 Projetos/Sysvar/Contexto do Projeto/Riscos e Cuidados|Riscos e Cuidados]]
    
- [[10 Projetos/Sysvar/Contexto do Projeto/Mapa Técnico|Mapa Técnico]]
    
- [[10 Projetos/Sysvar/Decisões Técnicas/ADR-001 - Licenciamento por Sessões Simultâneas|ADR-001 - Licenciamento por Sessões Simultâneas]]
    
- [[10 Projetos/Sysvar/Decisões Técnicas/ADR-002 - Princípios Arquiteturais do SISVAR|ADR-002 - Princípios Arquiteturais do SISVAR]]
    
- [[10 Projetos/Sysvar/Decisões Técnicas/ADR-003 - Auditoria Central do SISVAR|ADR-003 - Auditoria Central do SISVAR]]