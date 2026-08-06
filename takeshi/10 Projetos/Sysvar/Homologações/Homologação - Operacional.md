
---
type: homologation
status: approved
project: Sysvar
group: Operacional
created: 2026-08-06
updated: 2026-08-06
tags:
  - sysvar
  - homologação
  - operacional
  - empresas
  - estabelecimentos
  - usuários
  - perfis
  - sessões
  - licenciamento
  - auditoria
  - aprovado
---

# Homologação - Operacional

## Objetivo

Este documento registra a homologação funcional e manual do grupo Operacional do SISVAR.

A homologação foi realizada após:

- análise funcional;
- revisão do código real;
- implementação pelo Codex;
- revisão dos commits;
- testes automatizados;
- correções técnicas;
- testes manuais no navegador;
- validação dos resultados;
- atualização da documentação.

---

# Grupo Homologado

Estrutura do menu:

```text
Operacional
├── Empresas
├── Estabelecimento
├── Usuários
├── Perfis de acesso
└── Auditoria
```

Status final:

```text
IMPLEMENTADO
TESTADO AUTOMATICAMENTE
HOMOLOGADO MANUALMENTE
DOCUMENTADO
APROVADO
```

---

# Escopo da Homologação

Foram considerados parte do grupo Operacional:

- empresas;
- contratos;
- módulos contratados;
- usuário master;
- superusuário da plataforma;
- suspensão;
- reativação;
- estabelecimentos;
- usuários;
- perfis;
- permissões;
- overrides;
- permissões efetivas;
- sessões;
- tokens;
- licenciamento simultâneo;
- administração de sessões;
- redefinição administrativa de senha;
- troca obrigatória de senha;
- Auditoria Central.

---

# Ambiente Utilizado

A homologação manual utilizou:

- Google Chrome;
- Microsoft Edge;
- usuários diferentes;
- superusuário da plataforma;
- empresa New Modas;
- limite de duas sessões simultâneas.

Usuários utilizados nos testes:

```text
João
Fernando
takeshi
```

O nome `takeshi` representa o superusuário utilizado nos testes administrativos.

---

# Regra de Licenciamento Homologada

O SISVAR utiliza:

```text
Sessões simultâneas
```

O SISVAR não utiliza:

```text
Quantidade de usuários cadastrados
```

Regras aprovadas:

- criar usuário não consome licença;
- manter usuário ativo sem login não consome licença;
- login válido consome uma licença;
- logout libera uma licença;
- encerramento administrativo libera licença;
- timeout libera licença;
- suspensão da empresa libera todas as licenças;
- login acima do limite é bloqueado;
- superusuário não consome licença da empresa;
- usuários diferentes podem utilizar o mesmo dispositivo;
- o mesmo usuário no mesmo dispositivo substitui somente sua sessão anterior.

---

# Cenário 1 - Superusuário sem Consumir Licença

## Preparação

1. Nenhum usuário cliente permaneceu logado.
2. O superusuário `takeshi` realizou login.
3. O superusuário abriu a consulta da empresa New Modas.

## Resultado Esperado

```text
Sessões ativas da empresa: 0
```

## Resultado Obtido

```text
Sessões ativas da empresa: 0
```

## Conclusão

O superusuário:

- criou sua própria sessão;
- criou seu próprio token;
- permaneceu sem empresa cliente vinculada à sessão;
- não entrou no contador da New Modas;
- não consumiu licença da New Modas;
- não consumiu licença de nenhuma outra empresa.

Resultado:

```text
APROVADO
```

---

# Cenário 2 - Primeiro Login da Empresa

## Execução

1. João realizou login no Chrome.
2. O acesso foi autorizado.
3. A empresa foi consultada pelo superusuário.

## Resultado Esperado

```text
Limite contratado: 2
Sessões ativas: 1
Acessos disponíveis: 1
```

## Resultado Obtido

```text
Limite contratado: 2
Sessões ativas: 1
Acessos disponíveis: 1
```

Resultado:

```text
APROVADO
```

---

# Cenário 3 - Segundo Login da Empresa

## Execução

1. João permaneceu logado no Chrome.
2. Fernando realizou login no Edge.
3. O acesso foi autorizado.
4. A empresa foi consultada novamente.

## Resultado Esperado

```text
Limite contratado: 2
Sessões ativas: 2
Acessos disponíveis: 0
```

## Resultado Obtido

```text
Limite contratado: 2
Sessões ativas: 2
Acessos disponíveis: 0
```

Resultado:

```text
APROVADO
```

---

# Cenário 4 - Tentativa Acima do Limite

## Execução

1. João permaneceu logado no Chrome.
2. Fernando permaneceu logado no Edge.
3. Uma nova tentativa de login foi realizada.
4. A empresa já possuía duas sessões válidas.

## Resultado Esperado

- login bloqueado;
- mensagem de limite atingido;
- nenhuma nova sessão válida;
- nenhum token utilizável;
- contador permanece em dois;
- disponibilidade permanece em zero.

Código esperado:

```text
CONCURRENT_SESSION_LIMIT_REACHED
```

## Resultado Obtido

O sistema bloqueou o novo login porque o limite havia sido atingido.

O contador permaneceu:

```text
Sessões ativas: 2
```

Resultado:

```text
APROVADO
```

---

# Cenário 5 - Logout Liberando Licença

## Execução

1. João realizou logout.
2. O backend recebeu o token atual.
3. A sessão de João foi encerrada.
4. O token foi revogado.
5. A empresa foi consultada novamente.

## Resultado Esperado

```text
Sessões ativas: 1
Acessos disponíveis: 1
```

## Resultado Obtido

```text
Sessões ativas: 1
Acessos disponíveis: 1
```

Resultado:

```text
APROVADO
```

---

# Cenário 6 - Novo Login Após Liberação

## Execução

1. A empresa permaneceu com uma sessão ativa.
2. João tentou realizar novo login.
3. Existia uma licença disponível.

## Resultado Esperado

- login autorizado;
- nova sessão criada;
- novo token criado;
- contador retorna para dois;
- disponibilidade retorna para zero.

## Resultado Obtido

O sistema permitiu o novo login de João.

Resultado:

```text
Sessões ativas: 2
Acessos disponíveis: 0
```

Resultado final:

```text
APROVADO
```

---

# Cenário 7 - Ordem Correta do Logout

## Problema Encontrado

O frontend anteriormente limpava o token local antes de chamar o backend.

Consequências:

- o backend não conseguia identificar a sessão;
- a sessão permanecia válida;
- a vaga não era liberada;
- o contador permanecia incorreto;
- novos logins podiam ser bloqueados indevidamente.

## Correção

A ordem foi alterada para:

```text
frontend mantém token
→ chama backend
→ backend encerra sessão
→ backend revoga token
→ backend libera vaga
→ frontend limpa token
→ frontend interrompe heartbeat
→ frontend redireciona
```

## Resultado da Homologação

O logout passou a liberar imediatamente a licença.

Resultado:

```text
APROVADO
```

---

# Cenário 8 - Fonte Única de Validade das Sessões

## Problema Encontrado

Existiam contagens utilizando critérios diferentes, como:

```text
ativa = true
```

Esse critério isolado não garantia:

- token existente;
- token não revogado;
- sessão não encerrada;
- usuário ativo;
- contrato válido;
- sessão não expirada.

## Correção

Foi centralizada a regra no serviço:

```text
ConcurrentSessionService
```

Métodos principais:

```text
valid_sessions_queryset
active_sessions_queryset
count_active_sessions
session_validity
is_session_valid
```

## Resultado

A mesma regra passou a ser utilizada por:

- login;
- bloqueio por limite;
- contador;
- disponibilidade;
- heartbeat;
- listagem;
- administração;
- diagnóstico;
- reconciliação.

Resultado:

```text
APROVADO
```

---

# Cenário 9 - Modal Ver Sessões

## Problema Inicial

A tela da empresa mostrava:

```text
Sessões ativas: 1
```

Ao abrir `Ver Sessões`, o modal apresentava:

```text
Contador e listagem divergem: contador 1, linhas 1.
```

e também:

```text
Nenhuma sessão ocupando licença.
```

Esse comportamento era inconsistente.

## Causa

O frontend interpretava ou filtrava incorretamente a resposta da API.

Existia diferença entre:

- resposta direta;
- resposta paginada;
- quantidade recebida;
- quantidade exibida;
- condição da mensagem de divergência;
- condição do estado vazio.

## Correção

O frontend passou a:

- tratar array direto;
- tratar objeto paginado com `results`;
- normalizar a resposta no service;
- não refiltrar sessões válidas;
- exibir divergência somente quando os números forem diferentes;
- exibir estado vazio somente quando não houver linhas.

## Homologação

Com uma sessão ativa:

```text
Contador: 1
Linhas exibidas: 1
```

O modal:

- exibiu a sessão corretamente;
- não exibiu divergência falsa;
- não exibiu estado vazio;
- permitiu identificar o usuário;
- apresentou os detalhes da sessão.

Resultado:

```text
APROVADO
```

---

# Cenário 10 - Administração de Sessões

A administração de sessões foi disponibilizada por:

- empresa;
- usuário.

A listagem pode apresentar:

- usuário;
- perfil;
- empresa;
- estabelecimento;
- dispositivo;
- device ID;
- navegador;
- sistema operacional;
- IP;
- início;
- última atividade;
- tempo conectado;
- status;
- token válido;
- token revogado;
- motivo do encerramento;
- origem.

Ações disponíveis:

```text
Ver Sessões
Atualizar
Encerrar sessão
Encerrar todas as sessões
```

Resultado:

```text
APROVADO
```

---

# Cenário 11 - Encerramento Individual

## Regra Validada

Ao encerrar uma sessão:

1. o executor é validado;
2. a empresa é validada;
3. a sessão é localizada;
4. a sessão é encerrada;
5. o token é revogado;
6. a vaga é liberada;
7. a Auditoria é registrada;
8. a listagem é atualizada;
9. o contador é atualizado;
10. a disponibilidade é atualizada.

Resultado:

```text
APROVADO
```

---

# Cenário 12 - Encerramento de Todas as Sessões

## Regra Validada

O encerramento consolidado utiliza:

```text
transaction.atomic
select_for_update
AuditService.required_success
```

Evento consolidado:

```text
USER_SESSIONS_CLOSED
```

Se a Auditoria obrigatória falhar:

- sessões permanecem ativas;
- tokens permanecem válidos;
- nenhuma alteração parcial é confirmada.

Resultado:

```text
APROVADO TECNICAMENTE
```

---

# Cenário 13 - Diagnóstico de Sessões

Command disponível:

```powershell
python manage.py diagnosticar_sessoes_empresa --empresa-id <id>
```

O command permite identificar:

- sessão;
- usuário;
- empresa;
- dispositivo;
- situação;
- última atividade;
- token existente;
- token revogado;
- validade;
- motivo da não validade.

O command não expõe token bruto.

Resultado:

```text
APROVADO
```

---

# Cenário 14 - Reconciliação de Sessões

Commands disponíveis:

```powershell
python manage.py reconciliar_sessoes_ativas --empresa-id <id> --dry-run
python manage.py reconciliar_sessoes_ativas --empresa-id <id> --apply
```

O `dry-run`:

- analisa;
- informa;
- não altera dados.

O `apply`:

- preserva histórico;
- encerra sessões inválidas;
- revoga tokens restantes;
- não apaga registros.

Resultado:

```text
APROVADO
```

---

# Empresas e Contratos

Foram considerados concluídos:

- cadastro de empresa;
- contrato;
- módulos contratados;
- plano completo;
- limite simultâneo;
- usuário master;
- suspensão;
- reativação;
- indicadores;
- sessões da empresa.

---

# Suspensão da Empresa

A suspensão:

- exige superusuário;
- exige motivo;
- exige confirmação;
- altera o contrato para `SUSPENSO`;
- encerra sessões;
- revoga tokens;
- libera vagas;
- incrementa `permissions_version`;
- registra Auditoria obrigatória.

Código retornado aos usuários:

```text
CONTRACT_SUSPENDED
```

Mensagem:

```text
O acesso da empresa está temporariamente suspenso. Entre em contato com o suporte.
```

---

# Reativação da Empresa

A reativação:

- retorna o contrato para `ATIVO`;
- preserva o histórico;
- não reativa sessões antigas;
- não restaura tokens antigos;
- exige novo login;
- registra Auditoria obrigatória.

---

# Estabelecimentos

Foram considerados concluídos:

- vínculo obrigatório com empresa;
- diagnóstico de estabelecimentos sem empresa;
- tipo de unidade;
- Loja;
- Matriz;
- Fábrica;
- ativação;
- inativação;
- encerramento;
- reabertura;
- usuários vinculados;
- isolamento;
- permissões;
- Auditoria.

Diagnóstico executado:

```text
lojas_sem_empresa = 0
```

---

# Usuários

Foram considerados concluídos:

- criação;
- consulta;
- edição;
- ativação;
- inativação;
- perfil principal;
- estabelecimento principal;
- estabelecimentos permitidos;
- overrides;
- permissões efetivas;
- sessões;
- redefinição de senha;
- troca obrigatória de senha;
- proteção do master;
- autoproteção;
- Auditoria.

Criar ou ativar usuário não consome licença.

---

# Perfis e Permissões

Foram considerados concluídos:

- perfil por empresa;
- perfil ativo;
- perfil padrão;
- permissões por módulo;
- níveis `NONE`, `VIEW` e `EDIT`;
- override `HERDAR`;
- dependências entre módulos;
- cálculo efetivo;
- atualização de `permissions_version`;
- Auditoria obrigatória.

Regra:

```text
Perfil
+ Override
+ Contrato
+ Módulos contratados
= Permissão efetiva
```

---

# Auditoria Central

Foram considerados concluídos:

- `AuditLog`;
- `AuditService`;
- `AuditContextMiddleware`;
- ações oficiais;
- categorias;
- resultados;
- severidade;
- origem;
- snapshots;
- antes e depois;
- campos alterados;
- metadata;
- sanitização;
- imutabilidade;
- consulta;
- filtros;
- indicadores;
- exportação;
- isolamento por empresa;
- isolamento por estabelecimento;
- Auditoria obrigatória.

---

# Testes Automatizados

Rodadas registradas durante o fechamento:

```text
Backend: 59 testes aprovados na centralização das sessões
Frontend: 37 testes aprovados na centralização das sessões
```

Testes posteriores foram adicionados para:

- superusuário sem consumo de licença;
- sessões por empresa;
- sessões por usuário;
- encerramento individual;
- encerramento consolidado;
- resposta direta;
- resposta paginada;
- contador;
- estado vazio;
- modal `Ver Sessões`;
- atualização após encerramento.

Os totais atuais devem sempre ser confirmados novamente antes de uma nova declaração formal.

---

# Resultado Final

O grupo Operacional atende aos critérios definidos para encerramento:

- análise funcional concluída;
- arquitetura revisada;
- backend implementado;
- frontend implementado;
- migrations aplicadas;
- testes automatizados aprovados;
- commits realizados;
- correções revisadas;
- homologação manual realizada;
- documentação atualizada.

Resultado:

```text
GRUPO OPERACIONAL APROVADO
```

Data:

```text
2026-08-06
```

---

# Pendências Fora do Escopo

Os seguintes itens não impedem o fechamento do Operacional:

- automação de cobrança;
- suspensão automática por inadimplência;
- recuperação pública de senha;
- política de retenção da Auditoria;
- estratégia final de backup;
- revisão futura dos campos legados de Loja;
- remoção futura do campo funcional `type`;
- revisão dos demais grupos do menu.

Esses itens devem ser tratados em etapas próprias.

---

# Próximo Grupo

A próxima revisão seguirá a ordem da barra lateral.

Próximo grupo:

```text
Cadastros
```

Primeiros itens:

1. Clientes;
2. Fornecedores;
3. Funcionários.

---

# Notas Relacionadas

- [[10 Projetos/Sysvar/Sysvar|Sysvar]]
- [[10 Projetos/Sysvar/Contexto do Projeto/Visão Geral|Visão Geral]]
- [[10 Projetos/Sysvar/Contexto do Projeto/Arquitetura|Arquitetura]]
- [[10 Projetos/Sysvar/Contexto do Projeto/Modelo de Domínio|Modelo de Domínio]]
- [[10 Projetos/Sysvar/Contexto do Projeto/Workflows|Workflows]]
- [[10 Projetos/Sysvar/Contexto do Projeto/Riscos e Cuidados|Riscos e Cuidados]]
- [[10 Projetos/Sysvar/Contexto do Projeto/Mapa Técnico|Mapa Técnico]]
- [[10 Projetos/Sysvar/Decisões Técnicas/ADR-001 - Licenciamento por Sessões Simultâneas|ADR-001 - Licenciamento por Sessões Simultâneas]]
- [[10 Projetos/Sysvar/Decisões Técnicas/ADR-002 - Princípios Arquiteturais do SISVAR|ADR-002 - Princípios Arquiteturais do SISVAR]]
- [[10 Projetos/Sysvar/Decisões Técnicas/ADR-003 - Auditoria Central do SISVAR|ADR-003 - Auditoria Central do SISVAR]]