---
type: adr
status: approved
project: Sysvar
adr: 001
created: 2026-08-04
updated: 2026-08-04
tags:
  - sysvar
  - adr
  - arquitetura
  - licenciamento
  - autenticação
---

# ADR-001 - Licenciamento por Sessões Simultâneas

## Status

Aprovada.

Implementada.

Validada em ambiente de desenvolvimento.

---

# Contexto

Durante o desenvolvimento do SISVAR foi discutido qual deveria ser o modelo de licenciamento da plataforma.

A primeira proposta consistia em limitar a quantidade de usuários ativos cadastrados por empresa.

Após análise funcional e comercial concluiu-se que esse modelo não representa corretamente o uso do sistema.

Uma empresa pode possuir dezenas de usuários cadastrados e apenas alguns deles utilizarem o sistema simultaneamente.

O objetivo comercial do SISVAR é limitar o uso simultâneo da plataforma, e não o número de cadastros.

---

# Decisão

O SISVAR utilizará licenciamento baseado em sessões simultâneas.

O consumo da licença ocorre exclusivamente quando existe uma sessão autenticada e ativa.

Usuários cadastrados não consomem licença.

Usuários ativos não consomem licença.

Somente sessões válidas consomem acesso simultâneo.

---

# Regras

O sistema deverá obedecer às seguintes regras.

## Cadastro

Criar usuários nunca consome licença.

Editar usuários nunca consome licença.

Ativar usuários nunca consome licença.

Inativar usuários encerra suas sessões.

---

## Login

Um login válido cria uma nova sessão.

Cada sessão ocupa uma licença.

O login somente é permitido quando existir vaga disponível no contrato.

Caso contrário o backend retorna:

```
CONCURRENT_SESSION_LIMIT_REACHED
```

---

## Mesmo dispositivo

Quando o mesmo usuário autenticar novamente utilizando o mesmo dispositivo:

- a sessão anterior será encerrada;
- o token anterior será revogado;
- a nova sessão assumirá o controle.

Esse processo não aumenta a quantidade de acessos simultâneos.

---

## Dispositivos diferentes

O mesmo usuário pode utilizar vários dispositivos.

Cada dispositivo mantém sua própria sessão.

Cada sessão consome uma licença.

---

## Logout

Logout encerra imediatamente a sessão.

A licença é liberada imediatamente.

---

## Timeout

Sessões inativas expiram automaticamente.

A expiração:

- encerra a sessão;
- revoga o token;
- libera a licença.

---

## Encerramento administrativo

O usuário master poderá encerrar sessões da própria empresa.

O superusuário poderá encerrar qualquer sessão.

O encerramento revoga o token e libera imediatamente a licença.

---

# Benefícios

O modelo escolhido apresenta as seguintes vantagens.

- representa o uso real da plataforma;
- elimina cobrança por usuários que nunca utilizam o sistema;
- permite cadastro de todos os funcionários;
- simplifica a gestão comercial;
- melhora a experiência do cliente;
- reduz problemas de licenciamento.

---

# Impacto na arquitetura

A decisão introduziu os seguintes componentes.

- EmpresaContrato
- SessaoUsuario
- SessionToken
- ConcurrentSessionService
- DeviceService
- SessionService

Também foram alterados:

- autenticação;
- frontend;
- heartbeat;
- logout;
- validação de permissões.

---

# Riscos

Sessões abandonadas.

Mitigação:

- timeout.

Concorrência.

Mitigação:

- transação durante o login.

Tokens reutilizados.

Mitigação:

- revogação e armazenamento apenas do hash.

---

# Resultado

A decisão foi implementada.

Todos os testes planejados foram aprovados.

O modelo passa a fazer parte da arquitetura oficial do SISVAR.

Alterações futuras deverão preservar esta decisão ou gerar uma nova ADR substituindo esta.

---

# Relacionamentos

Relaciona-se diretamente com:

- [[Sysvar]]
- [[Arquitetura]]
- [[Modelo de Domínio]]
- [[Workflows]]
- [[Riscos e Cuidados]]