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
    
- workflows
    
- operacional
    
- autenticação
    
- sessões
    
- licenciamento
    
- auditoria
    

---

# Workflows

## Objetivo

Este documento descreve os principais fluxos transversais e operacionais do SISVAR.

Os fluxos de autenticação, contratos, sessões, licenciamento, permissões e Auditoria Central estão implementados e validados por testes automatizados.

O grupo Operacional também está tecnicamente implementado.

A homologação manual completa dos novos fluxos do Operacional ainda permanece pendente.

---

# Grupo Operacional

Estrutura atual:

```text
Operacional
├── Empresas
├── Estabelecimento
├── Usuários
├── Perfis de acesso
└── Auditoria
```

Os fluxos desse grupo abrangem:

- contrato;
    
- suspensão e reativação;
    
- estabelecimentos;
    
- usuários;
    
- perfis;
    
- permissões;
    
- sessões;
    
- senhas;
    
- Auditoria.
    

---

# Autenticação, contrato e permissões

1. O usuário informa username e senha.
    
2. O frontend obtém o `device_id`.
    
3. O frontend envia as credenciais e o dispositivo ao backend.
    
4. O backend autentica o usuário.
    
5. O backend valida:
    
    - usuário ativo;
        
    - empresa;
        
    - contrato;
        
    - status do contrato;
        
    - vigência;
        
    - módulos contratados;
        
    - perfil;
        
    - permissões;
        
    - limite simultâneo;
        
    - dispositivo.
        
6. Quando o contrato está suspenso:
    
    - nenhuma sessão é criada;
        
    - o login é bloqueado;
        
    - o código `CONTRACT_SUSPENDED` é retornado.
        
7. Quando o login é aceito:
    
    - a sessão é criada;
        
    - o token é emitido;
        
    - somente o hash do token é persistido;
        
    - o contexto efetivo é retornado.
        
8. O frontend recebe:
    
    - token;
        
    - sessão;
        
    - usuário;
        
    - empresa;
        
    - contrato;
        
    - módulos;
        
    - permissões;
        
    - `deve_trocar_senha`.
        
9. O frontend monta a interface conforme o contexto.
    
10. O heartbeat é iniciado.
    
11. O login é auditado.
    

---

# Login com limite de sessões simultâneas

1. O backend autentica as credenciais.
    
2. Sessões expiradas são encerradas.
    
3. O contrato é bloqueado dentro da transação.
    
4. O backend procura sessão ativa do mesmo usuário e dispositivo.
    
5. Quando encontra:
    
    - encerra a sessão anterior;
        
    - revoga o token anterior;
        
    - registra substituição.
        
6. O backend conta as sessões ativas da empresa.
    
7. Quando existe vaga:
    
    - cria sessão;
        
    - cria token;
        
    - confirma login.
        
8. Quando não existe vaga:
    
    - não cria sessão;
        
    - retorna `CONCURRENT_SESSION_LIMIT_REACHED`;
        
    - registra o bloqueio na Auditoria.
        

Usuário cadastrado não consome licença.

Somente sessão ativa consome vaga.

---

# Contrato suspenso durante uma sessão

1. O usuário possui sessão ativa.
    
2. Um superusuário suspende a empresa.
    
3. O contrato passa para `SUSPENSO`.
    
4. Todas as sessões da empresa são encerradas.
    
5. Todos os tokens são revogados.
    
6. As vagas são liberadas.
    
7. O heartbeat seguinte é rejeitado.
    
8. Qualquer requisição com token antigo é rejeitada.
    
9. O frontend limpa o contexto local.
    
10. O usuário é direcionado para o login.
    
11. Novo login permanece bloqueado enquanto o contrato estiver suspenso.
    

Mensagem pública:

```text
O acesso da empresa está temporariamente suspenso. Entre em contato com o suporte.
```

---

# Suspensão administrativa da empresa

1. O superusuário acessa a empresa.
    
2. O sistema mostra:
    
    - status do contrato;
        
    - quantidade de sessões ativas;
        
    - impacto da suspensão.
        
3. O superusuário solicita a suspensão.
    
4. O frontend exige:
    
    - motivo;
        
    - observação, quando aplicável;
        
    - confirmação explícita.
        
5. O backend valida:
    
    - executor;
        
    - empresa;
        
    - contrato;
        
    - status;
        
    - motivo;
        
    - confirmação.
        
6. O contrato é bloqueado com `select_for_update`.
    
7. A operação ocorre dentro de `transaction.atomic`.
    
8. O status passa para `SUSPENSO`.
    
9. São preenchidos:
    
    - motivo;
        
    - observação;
        
    - data;
        
    - executor.
        
10. Todas as sessões ativas da empresa são encerradas.
    
11. Todos os tokens são revogados.
    
12. A versão das permissões é incrementada.
    
13. A Auditoria obrigatória registra:
    

- executor;
    
- empresa;
    
- status anterior;
    
- status posterior;
    
- motivo;
    
- quantidade de sessões encerradas.
    

14. Quando a Auditoria funciona:
    

- a transação é confirmada.
    

15. Quando a Auditoria falha:
    

- o contrato volta ao estado anterior;
    
- sessões permanecem ativas;
    
- tokens permanecem válidos;
    
- toda a operação sofre rollback.
    

---

# Reativação da empresa

1. O superusuário acessa uma empresa suspensa.
    
2. O sistema apresenta a ação `Reativar acesso`.
    
3. O backend valida:
    
    - executor;
        
    - contrato;
        
    - status atual.
        
4. O contrato é bloqueado.
    
5. A operação ocorre em transação.
    
6. O status passa para `ATIVO`.
    
7. São preenchidos:
    
    - data da reativação;
        
    - executor.
        
8. A versão das permissões é incrementada.
    
9. A Auditoria obrigatória registra a reativação.
    
10. A transação é confirmada.
    
11. Sessões antigas permanecem encerradas.
    
12. Usuários precisam realizar novo login.
    

---

# Redução do limite simultâneo

1. O superusuário altera o limite do contrato.
    
2. A operação ocorre em transação.
    
3. A Auditoria obrigatória registra antes e depois.
    
4. O sistema compara o novo limite com as sessões ativas.
    
5. Quando o total ativo é maior que o novo limite:
    
    - sessões existentes permanecem;
        
    - novos logins são bloqueados;
        
    - nenhuma sessão é encerrada automaticamente.
        
6. O excesso diminui por:
    
    - logout;
        
    - timeout;
        
    - inativação;
        
    - encerramento administrativo.
        
7. Novos logins voltam a ser permitidos quando o total ativo fica abaixo do limite.
    

---

# Sessão no mesmo dispositivo

1. O navegador mantém um `device_id`.
    
2. Um novo login do mesmo usuário e dispositivo é solicitado.
    
3. O backend localiza a sessão anterior.
    
4. A sessão anterior é encerrada.
    
5. O token anterior é revogado.
    
6. A nova sessão é criada.
    
7. Apenas uma vaga permanece consumida.
    
8. O evento `SESSION_REPLACED` é registrado.
    

---

# Mesmo usuário em dispositivos diferentes

1. Cada dispositivo possui `device_id` próprio.
    
2. O mesmo usuário pode autenticar em vários dispositivos.
    
3. Cada dispositivo gera uma sessão independente.
    
4. Cada sessão ativa consome uma vaga.
    
5. O limite é aplicado à empresa, não ao usuário.
    

---

# Heartbeat

1. O frontend inicia o heartbeat após o login.
    
2. O heartbeat envia a sessão atual.
    
3. O backend valida:
    
    - token;
        
    - sessão;
        
    - expiração;
        
    - usuário;
        
    - empresa;
        
    - contrato;
        
    - suspensão;
        
    - troca obrigatória de senha.
        
4. O backend atualiza a última atividade quando necessário.
    
5. Retorna:
    
    - situação da sessão;
        
    - última atividade;
        
    - `permissions_version`;
        
    - contexto necessário.
        
6. Quando a sessão está inválida:
    
    - o frontend interrompe o heartbeat;
        
    - limpa a autenticação;
        
    - direciona para o login.
        
7. Quando existe troca obrigatória de senha:
    
    - o frontend mantém o usuário no fluxo de alteração.
        

---

# Expiração por inatividade

1. A sessão ultrapassa o limite de inatividade.
    
2. O backend identifica a expiração.
    
3. A sessão passa para inativa.
    
4. O motivo é `TIMEOUT`.
    
5. O token é revogado.
    
6. A vaga é liberada.
    
7. O evento é auditado.
    
8. Nova tentativa com o token é rejeitada.
    

Comando de apoio:

```powershell
python manage.py encerrar_sessoes_expiradas
```

---

# Logout

1. O frontend solicita logout.
    
2. O backend identifica a sessão.
    
3. A sessão é encerrada.
    
4. O token é revogado.
    
5. A vaga é liberada.
    
6. O evento `USER_LOGOUT` é registrado.
    
7. O frontend remove:
    
    - token;
        
    - sessão;
        
    - usuário;
        
    - empresa;
        
    - contrato;
        
    - permissões.
        
8. O heartbeat é interrompido.
    
9. Outras abas recebem o evento de logout.
    

---

# Criação de estabelecimento

1. O usuário acessa Estabelecimentos.
    
2. O backend valida `operacional=EDIT`, master ou superusuário.
    
3. O formulário informa:
    
    - empresa, quando superusuário;
        
    - identificação;
        
    - tipo de unidade;
        
    - endereço;
        
    - contato;
        
    - operação;
        
    - configuração fiscal;
        
    - numeração.
        
4. Para usuário cliente:
    
    - a empresa vem do contexto;
        
    - não pode ser alterada.
        
5. O backend valida:
    
    - empresa obrigatória;
        
    - CNPJ;
        
    - tipo de unidade;
        
    - datas;
        
    - configuração fiscal;
        
    - séries;
        
    - próximos números.
        
6. O estabelecimento é criado.
    
7. O campo legado `Matriz` é sincronizado com `tipo_unidade`.
    
8. O evento `STORE_CREATED` é registrado.
    

---

# Consulta de estabelecimentos

## Superusuário

Pode:

- consultar todas as empresas;
    
- filtrar por empresa;
    
- criar e alterar estabelecimentos.
    

## Master

Pode:

- consultar todos os estabelecimentos da própria empresa;
    
- criar e alterar, conforme a regra efetiva.
    

## Usuário com VIEW

Pode:

- consultar os estabelecimentos permitidos;
    
- visualizar dados;
    
- não alterar.
    

## Usuário com EDIT

Pode:

- consultar;
    
- criar;
    
- editar;
    
- executar ações permitidas.
    

## Usuário com NONE

- não vê o menu;
    
- não acessa a rota;
    
- recebe bloqueio do backend.
    

---

# Inativação de estabelecimento

1. O usuário autorizado solicita a inativação.
    
2. O backend valida:
    
    - empresa;
        
    - permissão;
        
    - situação atual.
        
3. O backend verifica impedimentos:
    
    - sessões ativas;
        
    - usuários com loja principal;
        
    - usuários vinculados;
        
    - operações pendentes;
        
    - outras dependências existentes.
        
4. Quando existem impedimentos:
    
    - a operação é bloqueada;
        
    - a lista de impedimentos é retornada;
        
    - o evento negado pode ser auditado.
        
5. Quando não existem impedimentos:
    
    - o estabelecimento passa para inativo;
        
    - o evento `STORE_DEACTIVATED` é registrado.
        

---

# Encerramento de estabelecimento

1. O usuário autorizado solicita o encerramento.
    
2. Informa:
    
    - data;
        
    - motivo;
        
    - confirmação.
        
3. O backend valida dependências.
    
4. O estabelecimento é marcado como encerrado.
    
5. A data de encerramento é preenchida.
    
6. O estabelecimento passa para inativo.
    
7. Novas sessões relacionadas à unidade são bloqueadas.
    
8. O histórico é preservado.
    
9. O evento `STORE_CLOSED` é registrado.
    

---

# Reabertura de estabelecimento

1. O usuário autorizado solicita a reabertura.
    
2. O backend valida:
    
    - empresa;
        
    - contrato;
        
    - situação do estabelecimento.
        
3. O estabelecimento volta a ficar ativo.
    
4. O histórico do encerramento é preservado conforme a modelagem.
    
5. O evento `STORE_REOPENED` é registrado.
    

---

# Consulta de usuários vinculados à loja

1. O usuário acessa o detalhe do estabelecimento.
    
2. O frontend solicita os usuários vinculados.
    
3. O backend valida empresa e permissão.
    
4. Retorna:
    
    - usuário;
        
    - nome;
        
    - perfil;
        
    - loja principal;
        
    - loja permitida;
        
    - status;
        
    - sessão ativa.
        
5. Nenhum dado sensível é retornado.
    

---

# Criação de usuário

1. O administrador acessa Usuários.
    
2. Informa:
    
    - username;
        
    - nome;
        
    - email;
        
    - tipo funcional;
        
    - perfil;
        
    - loja principal;
        
    - lojas permitidas;
        
    - senha inicial.
        
3. O backend valida:
    
    - empresa;
        
    - perfil da mesma empresa;
        
    - perfil ativo;
        
    - módulos contratados;
        
    - lojas da mesma empresa;
        
    - loja principal incluída nas permitidas;
        
    - senha.
        
4. O usuário é criado.
    
5. Nenhuma licença é consumida.
    
6. As permissões efetivas são calculadas.
    
7. O evento `USER_CREATED` é registrado.
    

---

# Edição de usuário

1. O administrador abre o usuário.
    
2. O backend retorna:
    
    - perfil;
        
    - tipo funcional;
        
    - lojas;
        
    - permissões do perfil;
        
    - overrides;
        
    - permissões efetivas.
        
3. O frontend apresenta a matriz:
    

|Módulo|Perfil|Override|Efetivo|
|---|---|---|---|

4. O administrador altera os dados permitidos.
    
5. O backend impede:
    
    - empresa diferente;
        
    - perfil de outra empresa;
        
    - loja de outra empresa;
        
    - módulo não contratado;
        
    - elevação da própria permissão;
        
    - alteração de campos internos.
        
6. As mudanças são persistidas.
    
7. `permissions_version` é atualizada quando necessário.
    
8. A Auditoria registra:
    
    - perfil alterado;
        
    - lojas alteradas;
        
    - overrides alterados;
        
    - dados cadastrais alterados.
        

---

# Override HERDAR

1. O usuário possui override individual.
    
2. O administrador seleciona `HERDAR`.
    
3. O frontend envia a remoção do override.
    
4. O backend exclui o registro individual correspondente.
    
5. A permissão efetiva volta a utilizar o perfil.
    
6. A versão das permissões é atualizada.
    
7. A alteração é auditada.
    

---

# Ativação de usuário

1. Um usuário autorizado solicita a ativação.
    
2. O backend valida:
    
    - empresa;
        
    - permissão;
        
    - proteção do master.
        
3. O usuário passa para ativo.
    
4. Nenhuma sessão é criada.
    
5. Nenhuma licença é consumida.
    
6. O evento `USER_ACTIVATED` é registrado.
    

---

# Inativação de usuário

1. Um usuário autorizado solicita a inativação.
    
2. O backend valida:
    
    - empresa;
        
    - permissão;
        
    - se o usuário não é master.
        
3. O usuário passa para inativo.
    
4. Sessões ativas são encerradas.
    
5. Tokens são revogados.
    
6. Vagas são liberadas.
    
7. A versão das permissões é atualizada.
    
8. O evento `USER_INACTIVATED` é registrado.
    
9. O usuário não consegue realizar novo login.
    

---

# Encerramento de uma sessão

1. O usuário autorizado seleciona uma sessão.
    
2. O backend valida o escopo.
    
3. A sessão é encerrada.
    
4. O token é revogado.
    
5. A vaga é liberada.
    
6. O evento `SESSION_CLOSED` é registrado.
    

---

# Encerramento de todas as sessões de um usuário

1. O administrador solicita `Encerrar todas as sessões`.
    
2. O backend inicia `transaction.atomic`.
    
3. O usuário é bloqueado.
    
4. As sessões ativas são carregadas com `select_for_update`.
    
5. Cada sessão é encerrada.
    
6. Os tokens são revogados.
    
7. Um evento consolidado é criado:
    

```text
USER_SESSIONS_CLOSED
```

8. A metadata informa:
    
    - quantidade encerrada;
        
    - motivo;
        
    - executor.
        
9. Quando a Auditoria obrigatória funciona:
    
    - a transação é confirmada.
        
10. Quando a Auditoria falha:
    

- sessões permanecem ativas;
    
- tokens permanecem válidos;
    
- toda a operação sofre rollback.
    

---

# Redefinição administrativa de senha

1. O administrador acessa o usuário.
    
2. Seleciona `Redefinir senha`.
    
3. Informa:
    
    - nova senha;
        
    - confirmação;
        
    - se deseja encerrar sessões.
        
4. O backend valida:
    
    - autorização;
        
    - empresa;
        
    - senha;
        
    - confirmação.
        
5. A operação inicia transação.
    
6. O usuário é bloqueado.
    
7. A nova senha é definida.
    
8. `deve_trocar_senha` passa para verdadeiro.
    
9. Sessões são encerradas, quando solicitado.
    
10. Tokens são revogados.
    
11. A Auditoria obrigatória registra:
    

```text
USER_PASSWORD_RESET
```

12. Quando a Auditoria funciona:
    

- a transação é confirmada.
    

13. Quando a Auditoria falha:
    

- senha anterior permanece;
    
- flag anterior permanece;
    
- sessões permanecem;
    
- tokens permanecem.
    

A senha nunca é registrada.

---

# Login com troca obrigatória de senha

1. O usuário autentica com a senha temporária.
    
2. O backend valida as credenciais.
    
3. A sessão é criada normalmente.
    
4. O contexto retorna:
    

```json
{
  "deve_trocar_senha": true
}
```

5. O frontend identifica a flag.
    
6. O usuário é redirecionado para:
    

```text
/change-password-required
```

7. O usuário não pode acessar os módulos normais.
    
8. Tentativa de acessar `/home` é interceptada pelo guard.
    
9. Tentativa direta à API retorna:
    

```text
PASSWORD_CHANGE_REQUIRED
```

---

# Bloqueio enquanto a troca está pendente

Enquanto `deve_trocar_senha=true`, o backend permite apenas:

- `/api/me/`;
    
- troca de senha;
    
- logout;
    
- heartbeat necessário.
    

Outros endpoints são bloqueados.

O evento de tentativa negada pode ser registrado como:

```text
PASSWORD_CHANGE_REQUIRED_ACCESS_DENIED
```

---

# Troca obrigatória de senha

1. O usuário informa:
    
    - senha atual;
        
    - nova senha;
        
    - confirmação.
        
2. O backend valida:
    
    - sessão;
        
    - senha atual;
        
    - nova senha diferente;
        
    - confirmação;
        
    - validadores do Django.
        
3. A operação ocorre em transação.
    
4. A nova senha é persistida.
    
5. `deve_trocar_senha` passa para falso.
    
6. Outras sessões são encerradas.
    
7. A sessão atual permanece válida.
    
8. O evento é registrado:
    

```text
USER_PASSWORD_CHANGED
```

9. O frontend chama novamente `/api/me/`.
    
10. O contexto é atualizado.
    
11. O acesso ao sistema é liberado.
    

Senhas e hashes não são auditados.

---

# Exclusão administrativa de usuário

1. O executor solicita a exclusão.
    
2. O backend valida:
    
    - empresa;
        
    - autorização;
        
    - master;
        
    - dependências.
        
3. A operação ocorre em transação.
    
4. A Auditoria obrigatória registra o estado anterior.
    
5. Se a Auditoria falhar:
    
    - a exclusão sofre rollback.
        
6. Se a operação for confirmada:
    
    - o usuário é excluído;
        
    - o evento permanece.
        

A inativação deve ser preferida sempre que possível.

---

# Criação de perfil

1. O administrador acessa Perfis.
    
2. Informa:
    
    - nome;
        
    - descrição;
        
    - status;
        
    - permissões por módulo.
        
3. O backend valida:
    
    - empresa;
        
    - nome único;
        
    - módulos contratados;
        
    - dependências;
        
    - níveis válidos.
        
4. O perfil é criado.
    
5. A Auditoria registra a criação.
    

---

# Alteração de perfil

1. O administrador altera as permissões.
    
2. O backend valida:
    
    - empresa;
        
    - módulo contratado;
        
    - dependências;
        
    - nível.
        
3. A operação ocorre em transação quando necessário.
    
4. As permissões são atualizadas.
    
5. `permissions_version` é incrementada.
    
6. A Auditoria obrigatória registra antes e depois.
    
7. Sessões abertas recebem a nova versão pelo heartbeat.
    

---

# Definição de perfil padrão

1. O administrador seleciona o perfil padrão.
    
2. O backend inicia transação.
    
3. Os perfis da empresa são bloqueados.
    
4. O padrão anterior é removido.
    
5. O novo perfil é marcado como padrão.
    
6. A versão das permissões é atualizada.
    
7. A Auditoria obrigatória é registrada.
    
8. Apenas um perfil padrão permanece ativo.
    

---

# Dependência entre módulos do perfil

1. O administrador tenta habilitar um módulo.
    
2. O backend consulta `ModuloSistema.dependencias`.
    
3. Quando a dependência está disponível:
    
    - a alteração pode prosseguir.
        
4. Quando a dependência está em `NONE`:
    
    - a configuração é bloqueada;
        
    - mensagem clara é retornada.
        
5. O frontend apresenta a dependência ao usuário.
    

---

# Mudança de permissões durante uma sessão

1. Perfil, override, contrato ou módulos são alterados.
    
2. `permissions_version` é incrementada.
    
3. O heartbeat retorna a nova versão.
    
4. O frontend compara com a versão atual.
    
5. Quando identifica diferença:
    
    - recarrega `/api/me/`;
        
    - atualiza permissões;
        
    - remonta menus;
        
    - reavalia a rota.
        
6. O backend já aplica a nova permissão antes da atualização visual.
    

---

# Transferência de master

1. O executor solicita a transferência.
    
2. O backend valida:
    
    - executor;
        
    - empresa;
        
    - novo usuário;
        
    - status;
        
    - vínculo.
        
3. O contrato é bloqueado.
    
4. A operação ocorre em transação.
    
5. O novo master é definido.
    
6. A versão das permissões é incrementada.
    
7. A Auditoria obrigatória registra:
    
    - master anterior;
        
    - novo master;
        
    - executor.
        
8. Falha da Auditoria provoca rollback.
    

---

# Contexto da Auditoria

1. A requisição entra no backend.
    
2. O middleware gera ou obtém:
    
    - request ID;
        
    - correlation ID.
        
3. O contexto recebe:
    
    - usuário;
        
    - empresa;
        
    - loja;
        
    - sessão;
        
    - dispositivo;
        
    - IP;
        
    - user-agent;
        
    - método;
        
    - endpoint.
        
4. O contexto é disponibilizado ao `AuditService`.
    
5. Ao final da requisição, ele é limpo.
    

---

# Auditoria comum

1. Uma operação comum é concluída.
    
2. O serviço usa `AuditService.on_commit`.
    
3. O callback aguarda o commit.
    
4. Quando a transação confirma:
    
    - o evento é persistido.
        
5. Quando existe rollback:
    
    - o evento de sucesso não é criado.
        
6. Falha da Auditoria depois do commit é registrada no logger.
    

---

# Auditoria obrigatória

1. Uma operação crítica inicia uma transação.
    
2. A alteração principal é executada.
    
3. Antes do commit, o serviço chama `AuditService.required_success`.
    
4. O evento é criado na mesma transação.
    
5. Quando a Auditoria funciona:
    
    - operação e evento são confirmados.
        
6. Quando a Auditoria falha:
    
    - toda a operação sofre rollback.
        

---

# Consulta da Auditoria

1. O usuário acessa `/config/auditoria`.
    
2. O frontend verifica o módulo `auditoria`.
    
3. O backend aplica o isolamento.
    
4. Regras:
    
    - superusuário: todas as empresas;
        
    - master: própria empresa;
        
    - VIEW: consulta;
        
    - EDIT: consulta e exporta;
        
    - NONE: bloqueado.
        
5. A tela apresenta:
    
    - indicadores;
        
    - filtros;
        
    - tabela;
        
    - detalhe;
        
    - antes e depois.
        

---

# Situação dos fluxos

## Implementados e validados automaticamente

- autenticação;
    
- licenciamento simultâneo;
    
- sessões;
    
- heartbeat;
    
- logout;
    
- timeout;
    
- suspensão;
    
- reativação;
    
- bloqueio de contrato;
    
- Estabelecimentos;
    
- ativação;
    
- inativação;
    
- encerramento;
    
- reabertura;
    
- Usuários;
    
- Perfil/Override/Efetivo;
    
- sessões do usuário;
    
- encerramento consolidado;
    
- redefinição administrativa de senha;
    
- troca obrigatória de senha;
    
- Perfis;
    
- perfil padrão;
    
- dependências de módulos;
    
- Auditoria Central.
    

## Testes automatizados

Backend:

```text
50 testes aprovados
```

Frontend:

```text
33 testes aprovados
```

## Homologação manual pendente

Ainda devem ser executados no navegador:

- suspensão com duas sessões;
    
- reativação;
    
- bloqueio de tokens antigos;
    
- troca obrigatória de senha;
    
- bloqueio por URL;
    
- usuário VIEW;
    
- usuário EDIT;
    
- ciclo completo de Estabelecimento;
    
- matriz Perfil/Override/Efetivo;
    
- dependências de módulos;
    
- novos eventos na Auditoria.
    

---

# Próximo grupo

Após a homologação manual do Operacional:

```text
Cadastros
```

Itens iniciais:

- Clientes;
    
- Fornecedores;
    
- Funcionários.
    

---

# Notas relacionadas

- [[10 Projetos/Sysvar/Sysvar|Sysvar]]
    
- [[10 Projetos/Sysvar/Contexto do Projeto/Visão Geral|Visão Geral]]
    
- [[10 Projetos/Sysvar/Contexto do Projeto/Arquitetura|Arquitetura]]
    
- [[10 Projetos/Sysvar/Contexto do Projeto/Modelo de Domínio|Modelo de Domínio]]
    
- [[10 Projetos/Sysvar/Contexto do Projeto/Riscos e Cuidados|Riscos e Cuidados]]
    
- [[10 Projetos/Sysvar/Contexto do Projeto/Mapa Técnico|Mapa Técnico]]
    
- [[10 Projetos/Sysvar/Decisões Técnicas/ADR-001 - Licenciamento por Sessões Simultâneas|ADR-001 - Licenciamento por Sessões Simultâneas]]
    
- [[10 Projetos/Sysvar/Decisões Técnicas/ADR-002 - Princípios Arquiteturais do SISVAR|ADR-002 - Princípios Arquiteturais do SISVAR]]
    
- [[10 Projetos/Sysvar/Decisões Técnicas/ADR-003 - Auditoria Central do SISVAR|ADR-003 - Auditoria Central do SISVAR]]