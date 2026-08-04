---
type: adr
status: approved
project: Sysvar
created: 2026-08-04
updated: 2026-08-04
tags:
  - sysvar
  - arquitetura
  - licenciamento
  - autenticação
  - sessões
---

# ADR-001 - Licenciamento por Sessões Simultâneas

## Status

Aprovado e em implementação.

## Contexto

O SISVAR é comercializado por quantidade de licenças contratadas por empresa.

Inicialmente, o sistema foi implementado considerando que cada usuário ativo cadastrado consumiria uma licença.

Essa regra foi descartada.

Uma empresa pode possuir vários usuários cadastrados e várias lojas, sem que todos estejam utilizando o sistema simultaneamente.

O controle comercial deve considerar quantos acessos estão ocorrendo ao mesmo tempo.

## Decisão

A licença do SISVAR será controlada por sessão simultânea ativa.

A empresa poderá possuir qualquer quantidade de usuários cadastrados.

O limite contratado define quantas sessões podem permanecer ativas simultaneamente.

Exemplo:

- Empresa com 20 usuários cadastrados.
- Empresa com 5 lojas.
- Empresa com 3 licenças contratadas.
- No máximo 3 sessões simultâneas ativas.
- O quarto login simultâneo deverá ser bloqueado.

## Regras

- Usuário apenas cadastrado não consome licença.
- Usuário ativo sem sessão aberta não consome licença.
- Usuário inativo não pode iniciar sessão.
- Cada navegador, computador, dispositivo ou instalação ativa consome uma licença.
- O mesmo usuário em dois dispositivos consome duas licenças.
- Várias abas do mesmo navegador utilizam a mesma sessão.
- Quantidade de lojas não consome licença diretamente.
- Superusuário interno do SISVAR não consome licença da empresa.
- Sessão encerrada não consome licença.
- Sessão expirada não consome licença.
- Logout libera imediatamente a licença.
- Timeout por inatividade libera a licença.
- Encerramento administrativo libera a licença.

## Controle de concorrência

A abertura de sessão deve ser protegida por transação no backend.

Ao tentar iniciar uma sessão:

1. Validar usuário.
2. Validar empresa.
3. Validar contrato.
4. Encerrar sessões expiradas.
5. Bloquear o contrato durante a contagem.
6. Contar sessões simultâneas válidas.
7. Comparar com o limite contratado.
8. Criar a sessão somente se houver licença disponível.

Dois logins concorrentes não podem ocupar a mesma última licença.

## Identificação de dispositivo

O frontend deverá gerar um identificador aleatório e persistente por navegador ou instalação.

Esse identificador não deverá utilizar fingerprint invasivo.

O mesmo usuário no mesmo dispositivo poderá substituir ou reutilizar a sessão anterior sem consumir uma licença adicional indevidamente.

## Sessão

A implementação deverá manter uma entidade de sessão contendo, no mínimo:

- empresa;
- usuário;
- loja ativa;
- identificador da sessão;
- identificador do dispositivo;
- vínculo seguro com o token;
- IP;
- user-agent;
- início;
- última atividade;
- encerramento;
- motivo do encerramento;
- situação ativa ou inativa.

## Token

O token deverá estar vinculado a uma sessão específica.

O token bruto não deverá ser armazenado em logs ou auditoria.

Tokens antigos sem sessão vinculada deverão ser invalidados e exigir novo login.

## Heartbeat

O frontend deverá enviar heartbeat periódico para manter a sessão ativa.

Configuração inicial proposta:

- Heartbeat a cada 2 minutos.
- Expiração após 30 minutos sem atividade.

Esses valores poderão ser alterados por configuração.

## Redução do limite

Se a empresa possuir mais sessões abertas do que o novo limite:

- sessões existentes não serão encerradas automaticamente;
- a empresa ficará acima do limite;
- novos logins serão bloqueados;
- o excesso será reduzido por logout, timeout ou encerramento administrativo.

## Administração

O usuário master da empresa poderá:

- visualizar as sessões da própria empresa;
- visualizar usuário, loja, dispositivo, IP e última atividade;
- encerrar sessões da própria empresa.

O master não poderá visualizar sessões de outra empresa.

## Consequências

### Positivas

- Modelo comercial mais flexível.
- Empresa pode cadastrar todos os seus funcionários.
- O controle corresponde ao uso real do sistema.
- Evita cobrança por usuário que raramente utiliza o sistema.
- Permite utilização em várias lojas respeitando o limite contratado.

### Riscos

- Sessões abandonadas podem ocupar licença.
- Falta de heartbeat pode causar expiração indevida.
- Controle concorrente precisa ser transacional.
- Tokens precisam ser vinculados corretamente às sessões.
- Encerramento do navegador não garante logout imediato.

## Mitigações

- Heartbeat periódico.
- Timeout por inatividade.
- Limpeza durante login e autenticação.
- Comando periódico para encerrar sessões expiradas.
- Tela administrativa de sessões.
- Encerramento manual pelo master.
- Testes concorrentes para a última licença.

## Situação da implementação

Em implementação pelo Codex.

A documentação deverá ser atualizada após a conclusão com:

- nomes finais dos models;
- migration criada;
- endpoints;
- autenticação utilizada;
- frequência final do heartbeat;
- timeout final;
- comportamento de tokens antigos;
- testes executados;
- limitações restantes.

## Notas relacionadas

- [[10 Projetos/Sysvar/Sysvar|Sysvar]]
- [[10 Projetos/Sysvar/Contexto do Projeto/Arquitetura|Arquitetura]]
- [[10 Projetos/Sysvar/Contexto do Projeto/Modelo de Domínio|Modelo de Domínio]]
- [[10 Projetos/Sysvar/Contexto do Projeto/Workflows|Workflows]]
- [[10 Projetos/Sysvar/Contexto do Projeto/Riscos e Cuidados|Riscos e Cuidados]]