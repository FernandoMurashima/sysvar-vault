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
    
- autenticação
    
- sessões
    
- licenciamento
    
- auditoria
    

---

# Workflows

## Objetivo

Este documento descreve os principais fluxos transversais do SISVAR.

Os fluxos de autenticação, sessões, licenciamento e Auditoria Central representam funcionalidades implementadas, testadas e homologadas.

Os fluxos dos módulos de negócio ainda deverão ser detalhados durante a revisão específica de cada módulo.

---

# Autenticação, contrato e permissões

1. O usuário informa username e senha no frontend.
    
2. O frontend obtém o identificador persistente do dispositivo por meio do `DeviceService`.
    
3. O frontend envia as credenciais e o `device_id` ao backend.
    
4. O backend autentica o usuário.
    
5. O backend valida se o usuário está ativo.
    
6. Para usuários de empresa, o backend valida:
    
    - vínculo com empresa;
        
    - situação da empresa;
        
    - existência do contrato;
        
    - situação do contrato;
        
    - vigência;
        
    - módulos contratados;
        
    - perfil de acesso, exceto para o master;
        
    - limite de sessões simultâneas.
        
7. Quando o login é aceito, o backend cria uma sessão.
    
8. Um token opaco é emitido e vinculado à sessão.
    
9. Somente o hash do token é persistido.
    
10. O backend devolve:
    
    - token;
        
    - identificador da sessão;
        
    - usuário;
        
    - empresa;
        
    - contrato;
        
    - módulos disponíveis;
        
    - permissões efetivas;
        
    - contexto da sessão.
        
11. O frontend armazena o token e o identificador da sessão no `sessionStorage`.
    
12. O frontend monta menus, rotas e operações conforme as permissões efetivas.
    
13. O frontend inicia o heartbeat.
    
14. O evento de login é enviado à Auditoria Central.
    
15. Em cada requisição autenticada, o backend volta a validar:
    
    - token;
        
    - sessão;
        
    - usuário;
        
    - empresa;
        
    - contrato;
        
    - módulo;
        
    - nível de acesso;
        
    - empresa e loja dos dados acessados.
        

A ocultação de menus no frontend não substitui as validações do backend.

---

# Login com controle de sessões simultâneas

1. O backend autentica as credenciais.
    
2. Quando as credenciais forem inválidas:
    
    - nenhuma sessão é criada;
        
    - a resposta apropriada é retornada;
        
    - o evento `USER_LOGIN_DENIED` é registrado;
        
    - senha e token não são incluídos na Auditoria.
        
3. Sessões expiradas da empresa são encerradas.
    
4. O contrato é bloqueado dentro da transação.
    
5. O backend procura uma sessão ativa do mesmo usuário no mesmo dispositivo.
    
6. Quando encontra uma sessão anterior:
    
    - a sessão anterior é encerrada;
        
    - o motivo é `REPLACED`;
        
    - o token anterior é revogado;
        
    - o evento `SESSION_REPLACED` é registrado.
        
7. O backend conta as sessões ativas e válidas da empresa.
    
8. O total é comparado com `limite_sessoes_simultaneas`.
    
9. Quando existe vaga:
    
    - uma sessão é criada;
        
    - um token é emitido;
        
    - o login é concluído;
        
    - o evento `USER_LOGIN` é registrado.
        
10. Quando o limite já foi atingido:
    
    - nenhuma nova sessão é criada;
        
    - o login é bloqueado;
        
    - o código `CONCURRENT_SESSION_LIMIT_REACHED` é retornado;
        
    - o evento `SESSION_LIMIT_REACHED` é registrado;
        
    - a Auditoria recebe o limite e a quantidade de sessões ativas.
        

Usuários cadastrados ou ativos sem sessão aberta não consomem acesso simultâneo.

---

# Sessão no mesmo dispositivo

1. O navegador mantém um `device_id` persistente no `localStorage`.
    
2. Novas abas do mesmo navegador compartilham esse identificador.
    
3. Um novo login do mesmo usuário e dispositivo não ocupa uma vaga adicional.
    
4. A sessão anterior é encerrada.
    
5. O token anterior é revogado.
    
6. A nova sessão passa a representar o usuário naquele dispositivo.
    
7. O evento de substituição é registrado na Auditoria.
    

O identificador do dispositivo é um UUID gerado pelo frontend.

Não utiliza fingerprint invasivo.

---

# Mesmo usuário em dispositivos diferentes

1. Cada navegador ou instalação possui seu próprio `device_id`.
    
2. O mesmo usuário pode autenticar em mais de um dispositivo.
    
3. Cada dispositivo mantém uma sessão independente.
    
4. Cada sessão ativa consome uma vaga do contrato.
    
5. O limite é aplicado ao total de sessões da empresa.
    

Exemplo:

```text
Computador da loja = uma sessão
Notebook = outra sessão
Outro navegador = outra sessão
```

---

# Heartbeat e atividade da sessão

1. Após o login, o frontend inicia o `SessionService`.
    
2. O frontend envia heartbeat periodicamente.
    
3. O heartbeat chama a ação correspondente no backend.
    
4. O backend identifica a sessão pelo token.
    
5. O backend valida:
    
    - sessão ativa;
        
    - sessão não expirada;
        
    - usuário ativo;
        
    - contrato válido.
        
6. O backend atualiza `ultima_atividade_em` quando necessário.
    
7. A resposta informa:
    
    - `session_id`;
        
    - situação;
        
    - última atividade;
        
    - `permissions_version`.
        
8. O frontend mantém somente um temporizador.
    
9. Quando o heartbeat identifica sessão inválida:
    
    - interrompe o temporizador;
        
    - limpa a autenticação local;
        
    - direciona o usuário ao login.
        

A autenticação pode atualizar a última atividade com limitação para evitar gravação em todas as requisições.

---

# Expiração por inatividade

1. O timeout padrão é de 30 minutos.
    
2. A sessão expira quando `ultima_atividade_em` ultrapassa o limite de inatividade.
    
3. A expiração pode ser identificada:
    
    - durante o login;
        
    - durante uma requisição autenticada;
        
    - pelo comando de encerramento de sessões expiradas.
        
4. Quando a sessão expira:
    
    - `ativa` passa para falso;
        
    - `encerrada_em` é preenchido;
        
    - o motivo é `TIMEOUT`;
        
    - o token é revogado;
        
    - a vaga é liberada;
        
    - o evento `SESSION_TIMEOUT` é registrado.
        
5. Nova tentativa com o token expirado é rejeitada.
    

Comando disponível:

```powershell
python manage.py encerrar_sessoes_expiradas
```

---

# Validação do token

1. O cliente envia o token no cabeçalho de autenticação.
    
2. O backend calcula o hash.
    
3. O backend procura um `SessionToken` não revogado.
    
4. O token deve estar ligado a uma `SessaoUsuario`.
    
5. O backend valida:
    
    - token existente;
        
    - token não revogado;
        
    - sessão ativa;
        
    - sessão não expirada;
        
    - usuário ativo;
        
    - empresa válida;
        
    - contrato válido.
        
6. Quando o usuário está inativo:
    
    - a sessão é encerrada;
        
    - o token é revogado;
        
    - o acesso é negado.
        
7. Quando a sessão expirou:
    
    - a sessão é encerrada;
        
    - o token é revogado;
        
    - o acesso é negado.
        
8. Quando tudo está válido:
    
    - o usuário é associado à requisição;
        
    - a sessão é disponibilizada no contexto;
        
    - a atividade pode ser atualizada;
        
    - o contexto pode ser utilizado pela Auditoria.
        

Token sem sessão válida não autentica o usuário.

---

# Logout

1. O frontend solicita logout.
    
2. O backend identifica a sessão vinculada ao token.
    
3. A sessão é encerrada.
    
4. O motivo é `LOGOUT`.
    
5. `encerrada_em` é preenchido.
    
6. O token é revogado.
    
7. A vaga é liberada imediatamente.
    
8. O evento `USER_LOGOUT` é registrado.
    
9. O frontend remove:
    
    - token;
        
    - identificador da sessão;
        
    - usuário em memória;
        
    - contexto do contrato;
        
    - permissões.
        
10. O heartbeat é interrompido.
    
11. O frontend publica um evento de logout no `localStorage`.
    
12. Outras abas encerram o contexto local.
    

---

# Inativação de usuário

1. Um usuário autorizado solicita a inativação.
    
2. O backend verifica:
    
    - empresa;
        
    - permissão;
        
    - se o usuário não é o master.
        
3. O usuário passa para inativo.
    
4. Todas as sessões ativas são encerradas.
    
5. Os tokens são revogados.
    
6. As vagas são liberadas.
    
7. A versão das permissões é atualizada.
    
8. O evento `USER_INACTIVATED` é registrado.
    
9. O usuário não consegue iniciar nova sessão.
    

Ativar um usuário não consome licença.

O consumo ocorre somente após login válido.

---

# Ativação de usuário

1. Um usuário autorizado solicita a ativação.
    
2. O backend valida empresa e permissão.
    
3. O usuário passa para ativo.
    
4. A versão das permissões é atualizada.
    
5. O evento `USER_ACTIVATED` é registrado.
    
6. Nenhuma licença é consumida nesse momento.
    

---

# Exclusão administrativa de usuário

1. O executor solicita a exclusão.
    
2. O backend valida:
    
    - autorização;
        
    - empresa;
        
    - se o usuário não é master;
        
    - dependências aplicáveis.
        
3. A operação ocorre dentro de uma transação.
    
4. A Auditoria obrigatória registra:
    
    - executor;
        
    - usuário excluído;
        
    - empresa;
        
    - estado anterior.
        
5. Se a Auditoria obrigatória falhar:
    
    - a exclusão sofre rollback.
        
6. Se tudo for confirmado:
    
    - o usuário é excluído;
        
    - o evento permanece registrado.
        

---

# Consulta de sessões

## Superusuário

Pode:

- consultar todas as empresas;
    
- filtrar por empresa.
    

## Master

Pode:

- consultar sessões da própria empresa;
    
- consultar todas as lojas da empresa.
    

## Usuário comum

Pode consultar somente as próprias sessões, conforme regra atual.

Dados podem incluir:

- usuário;
    
- empresa;
    
- loja;
    
- dispositivo;
    
- IP;
    
- user-agent;
    
- início;
    
- última atividade;
    
- encerramento;
    
- motivo;
    
- situação.
    

---

# Encerramento administrativo de sessão

1. O usuário autorizado seleciona a sessão.
    
2. O backend carrega a sessão dentro do escopo permitido.
    
3. O encerramento é permitido para:
    
    - superusuário;
        
    - master da empresa;
        
    - próprio usuário, quando aplicável.
        
4. Tentativa sem autorização é negada.
    
5. Quando master ou superusuário encerra:
    
    - o motivo é `ADMIN_TERMINATED`.
        
6. Quando o próprio usuário encerra:
    
    - o motivo é `SELF_TERMINATED`.
        
7. A sessão passa para inativa.
    
8. O token é revogado.
    
9. A vaga é liberada.
    
10. O evento `SESSION_CLOSED` é registrado.
    
11. Tentativas negadas podem gerar `SESSION_CLOSE_DENIED`.
    

---

# Redução do limite simultâneo

1. O superusuário altera o limite no contrato.
    
2. A alteração ocorre dentro de uma transação.
    
3. A Auditoria obrigatória registra antes e depois.
    
4. O sistema compara o novo limite com as sessões ativas.
    
5. Quando o novo limite fica abaixo do total ativo:
    
    - as sessões permanecem abertas;
        
    - nenhuma sessão é encerrada automaticamente;
        
    - novos logins são bloqueados.
        
6. O excesso diminui por:
    
    - logout;
        
    - timeout;
        
    - inativação;
        
    - encerramento administrativo.
        
7. Novos logins voltam a ser permitidos quando o total fica abaixo do limite.
    

---

# Mudança de permissões durante a sessão

1. Contrato, módulos, perfis ou permissões são alterados.
    
2. A operação atualiza `permissions_version`.
    
3. Alterações críticas usam Auditoria obrigatória.
    
4. O heartbeat retorna a versão atual.
    
5. O frontend compara com a versão armazenada.
    
6. Quando identifica mudança:
    
    - recarrega o contexto;
        
    - atualiza permissões efetivas;
        
    - remonta menus;
        
    - reavalia a rota.
        
7. Antes mesmo da atualização visual, o backend já aplica as novas permissões.
    

---

# Transferência de master

1. O executor solicita a transferência.
    
2. O backend valida:
    
    - se o executor é superusuário ou master atual;
        
    - se o novo master pertence à empresa;
        
    - se o novo master está ativo;
        
    - se o novo master não é superusuário.
        
3. O contrato é bloqueado dentro da transação.
    
4. O master anterior é identificado.
    
5. O novo master é definido.
    
6. A versão das permissões é incrementada.
    
7. A Auditoria obrigatória registra:
    
    - executor;
        
    - empresa;
        
    - master anterior;
        
    - novo master.
        
8. Se a Auditoria falhar:
    
    - a transferência sofre rollback.
        
9. Se tudo for confirmado:
    
    - o novo master passa a administrar a empresa.
        

Tentativa sem autorização gera acesso negado auditado.

---

# Alteração de contrato

1. O superusuário cria ou altera o contrato.
    
2. O backend captura os valores anteriores.
    
3. A operação ocorre dentro de uma transação.
    
4. São alterados, conforme o caso:
    
    - status;
        
    - vigência;
        
    - limite de sessões;
        
    - plano completo;
        
    - módulos;
        
    - master.
        
5. A versão das permissões é incrementada.
    
6. Flags legadas compatíveis são sincronizadas.
    
7. A Auditoria obrigatória registra antes e depois.
    
8. Se a Auditoria falhar:
    
    - a alteração sofre rollback.
        
9. Quando confirmado:
    
    - o novo contrato passa a valer nos acessos posteriores.
        

---

# Alteração de módulos contratados

1. O superusuário altera a disponibilidade de um módulo.
    
2. O backend valida empresa e módulo.
    
3. A operação ocorre dentro de transação.
    
4. A versão das permissões é incrementada.
    
5. O frontend passará a refletir a nova disponibilidade.
    
6. O backend bloqueia ou libera o módulo conforme o novo contrato.
    
7. A Auditoria obrigatória registra:
    
    - módulo;
        
    - situação anterior;
        
    - situação posterior;
        
    - empresa;
        
    - executor.
        
8. Falha da Auditoria provoca rollback.
    

---

# Alteração de perfil e permissões

1. O administrador autorizado altera um perfil ou override.
    
2. O backend valida:
    
    - empresa;
        
    - módulo contratado;
        
    - nível de acesso;
        
    - escopo do executor.
        
3. A operação ocorre dentro de transação quando necessário.
    
4. As permissões são atualizadas.
    
5. `permissions_version` é incrementada.
    
6. A Auditoria obrigatória registra:
    
    - perfil ou usuário afetado;
        
    - módulo;
        
    - nível anterior;
        
    - nível posterior;
        
    - executor.
        
7. Se a Auditoria obrigatória falhar:
    
    - a mudança sofre rollback.
        
8. Sessões abertas passam a receber a nova versão pelo heartbeat.
    

---

# Perfil padrão

1. O administrador autorizado escolhe o perfil padrão.
    
2. O backend bloqueia os perfis relevantes da empresa.
    
3. Perfis anteriormente padrão deixam de ser padrão.
    
4. O perfil escolhido passa a ser padrão.
    
5. A versão das permissões é incrementada.
    
6. A Auditoria obrigatória registra a alteração.
    
7. Falha da Auditoria provoca rollback.
    
8. A regra de apenas um perfil padrão ativo permanece garantida pela aplicação.
    

---

# Contexto da Auditoria

1. A requisição entra no backend.
    
2. O `AuditContextMiddleware` gera ou valida:
    
    - `request_id`;
        
    - `correlation_id`.
        
3. O middleware obtém:
    
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
    
5. O request ID é devolvido no header:
    

```text
X-Request-ID
```

6. Quando aplicável, o correlation ID é devolvido em:
    

```text
X-Correlation-ID
```

7. Ao final da requisição, o contexto é limpo.
    

Isso impede vazamento de contexto entre requisições.

---

# Registro de evento comum

1. Uma operação de baixa ou média criticidade é concluída.
    
2. O serviço de negócio chama:
    

```python
AuditService.on_commit(...)
```

ou método equivalente.

3. O callback aguarda a confirmação da transação.
    
4. Quando o commit é realizado:
    
    - o contexto é resolvido;
        
    - os dados são sanitizados;
        
    - snapshots são criados;
        
    - o evento é persistido.
        
5. Quando a transação sofre rollback:
    
    - o evento de sucesso não é criado.
        
6. Quando a Auditoria falha depois do commit:
    
    - a falha é registrada no logger;
        
    - a operação já confirmada não é desfeita.
        

---

# Registro de evento obrigatório

1. Uma operação crítica é iniciada dentro de `transaction.atomic()`.
    
2. A alteração principal é executada.
    
3. Antes do commit final, o sistema chama:
    

```python
AuditService.required_success(...)
```

4. O evento é validado.
    
5. Os dados são sanitizados.
    
6. O registro é criado dentro da mesma transação.
    
7. Quando a Auditoria funciona:
    
    - a transação é confirmada;
        
    - operação e log permanecem.
        
8. Quando a Auditoria falha:
    
    - a exceção é propagada;
        
    - a operação sofre rollback;
        
    - o usuário recebe mensagem segura.
        

---

# Registro de acesso negado

1. O usuário tenta executar operação não autorizada.
    
2. O backend identifica o motivo.
    
3. O `AuditService.denied()` registra:
    
    - usuário;
        
    - empresa;
        
    - loja;
        
    - ação;
        
    - endpoint;
        
    - status 403;
        
    - contexto seguro.
        
4. A API retorna `403 Forbidden`.
    
5. Dados do recurso não autorizado não são revelados.
    

Na própria API de Auditoria existe proteção contra recursão.

A tentativa deve gerar somente um evento.

---

# Sanitização da Auditoria

1. O `AuditService` recebe:
    
    - before;
        
    - after;
        
    - metadata;
        
    - erro;
        
    - contexto.
        
2. O sanitizador percorre recursivamente:
    
    - objetos;
        
    - dicionários;
        
    - listas;
        
    - strings.
        
3. Campos proibidos são removidos ou substituídos por:
    

```text
[REDACTED]
```

4. Exemplos bloqueados:
    
    - senha;
        
    - token;
        
    - cookie;
        
    - Authorization;
        
    - secret;
        
    - certificado;
        
    - chave privada;
        
    - hash de token.
        
5. Conteúdo excessivo é truncado.
    
6. O evento sanitizado é persistido.
    

---

# Criação e alteração auditada de objeto simples

1. O objeto pertence a um model registrado no `AuditRegistry`.
    
2. O signal identifica criação, alteração ou exclusão.
    
3. O registry informa:
    
    - categoria;
        
    - campos ignorados;
        
    - campos sensíveis;
        
    - empresa;
        
    - loja;
        
    - representação.
        
4. O sistema calcula:
    
    - estado anterior;
        
    - estado posterior;
        
    - campos alterados.
        
5. O evento é enviado ao `AuditService`.
    
6. O serviço sanitiza e persiste após commit, quando aplicável.
    

Signals são usados apenas para CRUD simples.

---

# Ação explícita de negócio

1. O serviço responsável executa uma ação com significado próprio.
    
2. O código não depende apenas de signals.
    
3. O serviço chama o `AuditService` com uma ação específica.
    

Exemplo:

```python
AuditService.success(
    action="PURCHASE_ORDER_APPROVED",
    category="PURCHASE",
    instance=pedido,
    before={"status": "AB"},
    after={"status": "AP"},
)
```

4. O evento representa a ação de negócio, não apenas uma alteração genérica de tabela.
    
5. O mesmo padrão deverá ser aplicado a:
    
    - aprovar;
        
    - cancelar;
        
    - reabrir;
        
    - baixar;
        
    - estornar;
        
    - faturar;
        
    - emitir;
        
    - distribuir;
        
    - finalizar;
        
    - sincronizar.
        

---

# Consulta da Auditoria

1. O usuário acessa:
    

```text
/config/auditoria
```

2. O frontend verifica a permissão efetiva do módulo `auditoria`.
    
3. O backend continua sendo a autoridade final.
    
4. Regras:
    
    - superusuário: todas as empresas;
        
    - master: própria empresa e todas as lojas;
        
    - VIEW: própria empresa e lojas permitidas;
        
    - EDIT: mesma consulta e possibilidade de exportação;
        
    - NONE: bloqueado.
        
5. O frontend envia os filtros.
    
6. O backend aplica primeiro o isolamento obrigatório.
    
7. Depois aplica os filtros permitidos.
    
8. A API retorna dados paginados.
    
9. A tela apresenta:
    
    - indicadores;
        
    - tabela;
        
    - total;
        
    - intervalo;
        
    - detalhe;
        
    - antes e depois.
        

---

# Tentativa de consultar outra empresa

1. Um usuário cliente envia filtro de outra empresa.
    
2. O backend identifica a divergência.
    
3. O evento `AUDIT_ACCESS_DENIED` é registrado.
    
4. A API retorna `403`.
    
5. Nenhum dado da empresa solicitada é retornado.
    
6. A proteção de recursão impede eventos duplicados.
    

---

# Tentativa de consultar loja não permitida

1. O usuário informa uma loja fora do seu escopo.
    
2. O backend verifica:
    
    - empresa;
        
    - vínculo da loja;
        
    - acesso do usuário.
        
3. O evento `AUDIT_ACCESS_DENIED` é registrado.
    
4. A API retorna `403`.
    
5. Nenhum dado da loja é retornado.
    

O master pode consultar todas as lojas da própria empresa.

---

# Indicadores da Auditoria

1. O frontend envia o período e filtros.
    
2. O backend aplica o mesmo isolamento da listagem.
    
3. Uma agregação calcula:
    
    - total;
        
    - sucessos;
        
    - falhas;
        
    - negados;
        
    - críticos.
        
4. A resposta é devolvida ao frontend.
    
5. Os indicadores não são recalculados localmente pela tabela.
    

Endpoint:

```text
GET /api/auditoria/logs/indicadores/
```

---

# Exportação da Auditoria

1. O usuário solicita exportação.
    
2. O backend valida:
    
    - superusuário;
        
    - master;
        
    - ou `auditoria=EDIT`.
        
3. Usuário com `VIEW` não pode exportar.
    
4. O backend aplica:
    
    - empresa;
        
    - loja;
        
    - período;
        
    - filtros;
        
    - limite de registros.
        
5. O arquivo CSV é gerado.
    
6. A resposta é devolvida ao frontend.
    
7. O evento `AUDIT_EXPORT` é registrado.
    
8. A metadata inclui:
    
    - formato;
        
    - filtros;
        
    - quantidade exportada;
        
    - limite;
        
    - limite atingido;
        
    - empresa;
        
    - loja;
        
    - status HTTP.
        

Endpoint:

```text
GET /api/auditoria/logs/exportar/
```

---

# Detalhe de evento

1. O usuário seleciona um evento.
    
2. O frontend solicita o detalhe.
    
3. O backend aplica o mesmo isolamento da listagem.
    
4. A resposta pode conter:
    
    - evento;
        
    - contexto;
        
    - usuário;
        
    - empresa;
        
    - loja;
        
    - sessão;
        
    - dispositivo;
        
    - objeto;
        
    - before;
        
    - after;
        
    - campos alterados;
        
    - metadata;
        
    - requisição;
        
    - erro.
        
5. O frontend apresenta diferenças em formato legível.
    
6. Não existem ações de editar ou excluir.
    

---

# Migração dos logs antigos

1. A migration adiciona os novos campos.
    
2. Cada log recebe `event_id`.
    
3. O campo legado `changes` é analisado.
    
4. Quando possível:
    
    - criação vira `after_data`;
        
    - alteração é separada em before e after;
        
    - exclusão vira `before_data`;
        
    - evento livre vira metadata.
        
5. Uma migration posterior tenta recuperar:
    
    - empresa;
        
    - loja;
        
    - snapshots do usuário.
        
6. A recuperação utiliza apenas fontes confiáveis:
    
    - usuário;
        
    - objeto;
        
    - vínculo seguro.
        
7. Quando não existe fonte confiável:
    
    - o campo permanece nulo.
        
8. Nenhum log antigo é apagado.
    

---

# Venda PDV

1. Caixa ou vendedor inicia a venda.
    
2. Itens, pagamentos, descontos e NFC-e são processados.
    
3. O estoque é movimentado.
    
4. Financeiro e contabilidade recebem os reflexos previstos.
    
5. A Auditoria deve registrar os eventos críticos.
    
6. Dashboards consolidam os indicadores.
    

Esse fluxo ainda deverá ser confrontado com o código real durante a revisão do módulo de Vendas e PDV.

---

# Devolução de venda

1. O operador inicia a devolução a partir de uma venda finalizada.
    
2. O sistema valida quantidades e valores.
    
3. O estoque recebe a entrada de retorno.
    
4. O financeiro é ajustado ou estornado.
    
5. CMV é ajustado.
    
6. A Auditoria registra a operação.
    

Esse fluxo ainda deverá ser detalhado na revisão do módulo de Vendas.

---

# Distribuição entre lojas

1. A distribuição é criada a partir do estoque da origem.
    
2. Perfis e destinos definem a alocação.
    
3. A confirmação reserva estoque.
    
4. Pedidos por loja podem ser gerados.
    
5. A NF-e de transferência pode ser emitida.
    
6. Estoque de origem e destino é atualizado conforme o processo.
    
7. A Auditoria registra confirmação, cancelamento e transferências.
    

Esse fluxo ainda deverá ser validado contra o código durante a revisão do módulo de Distribuição.

---

# Pagamento e recebimento

1. O título nasce de compra, venda, transferência ou lançamento manual.
    
2. A baixa gera movimentação financeira.
    
3. O lançamento contábil é criado ou estornado conforme a natureza.
    
4. A Auditoria registra baixa, cancelamento, reabertura e estorno.
    
5. O dashboard utiliza os dados consolidados.
    

Esse fluxo será detalhado na revisão dos módulos Financeiro e Contábil.

---

# Produção e estoque

1. A ficha técnica define a composição.
    
2. A ordem de produção consome insumos.
    
3. A finalização movimenta o estoque.
    
4. O produto acabado fica disponível.
    
5. A produção pode alimentar distribuição e venda.
    
6. A Auditoria registra início, consumo, retorno, finalização e cancelamento.
    

Esse fluxo ainda deverá ser validado na revisão de Produção.

---

# Entrada de Nota Fiscal

Fluxo conceitual ainda não implementado integralmente:

1. O usuário inicia uma entrada:
    
    - a partir de pedido;
        
    - ou de forma avulsa.
        
2. O sistema identifica:
    
    - empresa;
        
    - loja;
        
    - fornecedor;
        
    - documento;
        
    - itens.
        
3. Os itens são conciliados com produtos e SKUs.
    
4. Quantidades, valores e impostos são validados.
    
5. O sistema impede duplicidade do documento.
    
6. A confirmação deve ocorrer de forma transacional.
    
7. A operação pode gerar:
    
    - recebimento de compra;
        
    - movimentação de estoque;
        
    - documento fiscal;
        
    - contas a pagar;
        
    - lançamentos contábeis;
        
    - auditoria.
        
8. Em falha:
    
    - nenhuma integração parcial deve permanecer.
        
9. Cancelamento ou estorno devem possuir fluxo próprio e auditado.
    

Esse será um dos próximos fluxos a ser analisado no código real.

---

# Última atualização

```text
2026-08-05
```

---

# Situação dos fluxos

## Implementados, testados e homologados

- autenticação;
    
- contrato e permissões;
    
- login;
    
- sessões simultâneas;
    
- substituição no mesmo dispositivo;
    
- heartbeat;
    
- timeout;
    
- token;
    
- logout;
    
- ativação e inativação de usuário;
    
- encerramento administrativo;
    
- redução do limite;
    
- mudança de permissões;
    
- transferência de master;
    
- alteração de contrato;
    
- alteração de módulos;
    
- perfil padrão;
    
- contexto da Auditoria;
    
- auditoria comum;
    
- auditoria obrigatória;
    
- acesso negado;
    
- sanitização;
    
- consulta da Auditoria;
    
- indicadores;
    
- exportação;
    
- detalhe;
    
- migração de logs antigos.
    

## Ainda pendentes de revisão detalhada

- Entrada de Nota Fiscal;
    
- Compras;
    
- Estoque;
    
- Financeiro;
    
- Fiscal;
    
- Vendas;
    
- PDV;
    
- Produção;
    
- Distribuição;
    
- Contabilidade;
    
- Relatórios.
    

---

# Notas relacionadas

- [[10 Projetos/Sysvar/Sysvar|Sysvar]]
    
- [[10 Projetos/Sysvar/Contexto do Projeto/Arquitetura|Arquitetura]]
    
- [[10 Projetos/Sysvar/Contexto do Projeto/Modelo de Domínio|Modelo de Domínio]]
    
- [[10 Projetos/Sysvar/Contexto do Projeto/Riscos e Cuidados|Riscos e Cuidados]]
    
- [[10 Projetos/Sysvar/Contexto do Projeto/Mapa Técnico|Mapa Técnico]]
    
- [[10 Projetos/Sysvar/Decisões Técnicas/ADR-001 - Licenciamento por Sessões Simultâneas|ADR-001 - Licenciamento por Sessões Simultâneas]]
    
- [[10 Projetos/Sysvar/Decisões Técnicas/ADR-002 - Princípios Arquiteturais do SISVAR|ADR-002 - Princípios Arquiteturais do SISVAR]]
    
- [[10 Projetos/Sysvar/Decisões Técnicas/ADR-003 - Auditoria Central do SISVAR|ADR-003 - Auditoria Central do SISVAR]]