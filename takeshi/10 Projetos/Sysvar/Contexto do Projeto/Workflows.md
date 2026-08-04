
---

type: reference  
status: active  
project: Sysvar  
source: "C:/SysvarProjeto"  
created: 2026-08-03  
updated: 2026-08-04  
tags:

- sysvar
    
- contexto
    
- workflows
    
- autenticação
    
- sessões
    
- licenciamento
    

---

# Workflows

## Autenticação, contrato e permissões

1. O usuário informa username e senha no frontend.
    
2. O frontend obtém o identificador persistente do dispositivo por meio do `DeviceService`.
    
3. O frontend envia as credenciais e o `device_id` ao backend.
    
4. O backend autentica o usuário.
    
5. O backend valida se o usuário está ativo.
    
6. Para usuários de empresa, o backend valida:
    
    - vínculo com empresa;
        
    - situação da empresa;
        
    - existência e situação do contrato;
        
    - vigência do contrato;
        
    - perfil de acesso, exceto para o usuário master.
        
7. O backend verifica o limite de sessões simultâneas contratado.
    
8. Quando o login é aceito, o backend cria uma sessão e um token vinculado a ela.
    
9. O backend devolve:
    
    - token;
        
    - identificador da sessão;
        
    - usuário;
        
    - empresa;
        
    - contrato;
        
    - módulos disponíveis;
        
    - permissões efetivas;
        
    - contexto da sessão.
        
10. O frontend armazena o token e o identificador da sessão no `sessionStorage`.
    
11. O frontend monta menus, rotas e operações conforme as permissões efetivas.
    
12. O frontend inicia o heartbeat da sessão.
    
13. Em cada requisição autenticada, o backend volta a validar:
    

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

## Login com controle de sessões simultâneas

1. O backend autentica as credenciais.
    
2. Sessões expiradas da empresa são encerradas.
    
3. O contrato da empresa é bloqueado dentro de uma transação.
    
4. O backend procura uma sessão ativa do mesmo usuário no mesmo dispositivo.
    
5. Quando encontra uma sessão anterior no mesmo dispositivo:
    
    - a sessão anterior é encerrada;
        
    - o motivo registrado é `REPLACED`;
        
    - o token anterior é revogado.
        
6. O backend conta as sessões ativas e ainda válidas da empresa.
    
7. O total é comparado com `limite_sessoes_simultaneas`.
    
8. Quando existe vaga:
    
    - um token opaco é gerado;
        
    - apenas o hash do token é persistido;
        
    - uma nova `SessaoUsuario` é criada;
        
    - um `SessionToken` é vinculado à sessão;
        
    - o login é concluído.
        
9. Quando o limite já foi atingido:
    
    - nenhuma nova sessão é criada;
        
    - o login é bloqueado;
        
    - o backend retorna o código `CONCURRENT_SESSION_LIMIT_REACHED`;
        
    - a resposta informa o limite e a quantidade de sessões ativas.
        

Usuários cadastrados ou ativos sem sessão aberta não consomem acesso simultâneo.

---

## Sessão no mesmo dispositivo

1. O navegador mantém um `device_id` persistente no `localStorage`.
    
2. Novas abas do mesmo navegador compartilham esse identificador.
    
3. Um novo login do mesmo usuário e dispositivo não deve ocupar uma vaga adicional.
    
4. A sessão anterior é encerrada e substituída pela nova sessão.
    
5. O token anterior deixa de ser válido.
    
6. A nova sessão passa a representar aquele usuário naquele dispositivo.
    

O identificador do dispositivo não utiliza fingerprint invasivo. Ele é um UUID gerado pelo frontend.

---

## Mesmo usuário em dispositivos diferentes

1. Cada navegador ou instalação possui seu próprio `device_id`.
    
2. O mesmo usuário pode autenticar em mais de um dispositivo.
    
3. Cada dispositivo possui uma sessão independente.
    
4. Cada sessão ativa consome uma vaga do contrato.
    
5. O limite é aplicado ao total de sessões da empresa, e não ao total de usuários distintos.
    

Exemplo:

- mesmo usuário no computador da loja: uma sessão;
    
- mesmo usuário em um notebook: outra sessão;
    
- mesmo usuário em outro navegador ou instalação: outra sessão.
    

---

## Heartbeat e atividade da sessão

1. Após o login, o frontend inicia o `SessionService`.
    
2. O frontend envia heartbeat a cada 120 segundos.
    
3. O heartbeat chama a ação `heartbeat` do recurso de sessões.
    
4. O backend identifica a sessão pelo token autenticado.
    
5. O backend atualiza `ultima_atividade_em`.
    
6. A resposta informa:
    
    - `session_id`;
        
    - situação ativa;
        
    - última atividade;
        
    - `permissions_version`.
        
7. O frontend mantém apenas um temporizador de heartbeat.
    
8. Se o heartbeat falhar porque a sessão não é mais válida:
    
    - o temporizador é interrompido;
        
    - a autenticação local é limpa;
        
    - o usuário é direcionado ao login.
        

Além do heartbeat, a autenticação pode atualizar a última atividade, com limitação para evitar gravação desnecessária em todas as requisições.

---

## Expiração por inatividade

1. O timeout padrão é de 30 minutos.
    
2. Uma sessão é considerada expirada quando `ultima_atividade_em` fica anterior ao limite calculado pelo timeout.
    
3. A expiração pode ser identificada:
    
    - durante o login;
        
    - durante a autenticação de uma requisição;
        
    - pelo comando de encerramento de sessões expiradas.
        
4. Quando a sessão expira:
    
    - `ativa` passa para falso;
        
    - `encerrada_em` é preenchido;
        
    - o motivo é definido como `TIMEOUT`;
        
    - o token é revogado;
        
    - a vaga simultânea é liberada.
        
5. Uma nova tentativa com o token expirado é rejeitada.
    

Comando disponível:

```powershell
python manage.py encerrar_sessoes_expiradas
```

---

## Validação do token de sessão

1. O cliente envia o token no cabeçalho de autenticação.
    
2. O backend calcula o hash do token recebido.
    
3. O backend procura um `SessionToken` não revogado.
    
4. O token deve estar ligado a uma `SessaoUsuario`.
    
5. O backend valida:
    
    - token existente;
        
    - token não revogado;
        
    - sessão ativa;
        
    - sessão não expirada;
        
    - usuário ativo;
        
    - contrato ativo, quando o usuário pertence a uma empresa.
        
6. Quando o usuário está inativo:
    
    - a sessão é encerrada;
        
    - o motivo é `USER_INACTIVE`;
        
    - o acesso é negado.
        
7. Quando a sessão expirou:
    
    - a sessão é encerrada;
        
    - o token é revogado;
        
    - o acesso é negado.
        
8. Quando tudo está válido:
    
    - o usuário é associado à requisição;
        
    - a sessão é disponibilizada como contexto da requisição;
        
    - a última atividade pode ser atualizada.
        

Tokens sem sessão válida não autenticam o usuário.

---

## Logout

1. O frontend solicita o logout com o token atual.
    
2. O backend identifica a sessão vinculada ao token.
    
3. A sessão é encerrada.
    
4. O motivo é registrado como `LOGOUT`.
    
5. `encerrada_em` é preenchido.
    
6. O token da sessão é revogado.
    
7. A vaga simultânea é liberada imediatamente.
    
8. O frontend remove:
    
    - token;
        
    - identificador da sessão;
        
    - usuário em memória;
        
    - contexto de contrato;
        
    - permissões.
        
9. O heartbeat é interrompido.
    
10. O frontend publica um evento de logout no `localStorage`.
    
11. Outras abas abertas recebem o evento e encerram o contexto local.
    

---

## Inativação de usuário

1. Um usuário autorizado solicita a inativação.
    
2. O backend verifica se o usuário não é o master da empresa.
    
3. O usuário passa para inativo.
    
4. Todas as sessões ativas daquele usuário são localizadas.
    
5. Cada sessão é encerrada com o motivo `USER_INACTIVE`.
    
6. Os tokens correspondentes são revogados.
    
7. As vagas simultâneas são liberadas.
    
8. A versão das permissões da empresa é atualizada.
    
9. O usuário inativo não consegue iniciar nova sessão.
    

A ativação de um usuário não consome licença. O consumo ocorre somente quando ele realiza login e cria uma sessão.

---

## Consulta de sessões

O recurso de sessões permite consultar sessões conforme o nível do usuário.

### Superusuário da plataforma

- Pode consultar sessões de todas as empresas.
    
- Pode filtrar por empresa.
    

### Usuário master da empresa

- Pode consultar as sessões da própria empresa.
    
- Não pode consultar sessões de outra empresa.
    

### Usuário comum

- Consulta somente suas próprias sessões.
    

A consulta pode ser filtrada por situação ativa ou inativa.

Dados de sessão incluem, conforme o serializer e a permissão aplicada:

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

## Encerramento administrativo de sessão

1. O usuário autorizado seleciona uma sessão.
    
2. O backend carrega a sessão dentro do conjunto permitido para o usuário.
    
3. O encerramento é permitido para:
    
    - superusuário da plataforma;
        
    - master da empresa da sessão;
        
    - próprio usuário da sessão.
        
4. Tentativas de encerrar sessão sem autorização são negadas.
    
5. Quando um master ou superusuário encerra sessão de outra pessoa:
    
    - o motivo é `ADMIN_TERMINATED`.
        
6. Quando o próprio usuário encerra a sessão:
    
    - o motivo é `SELF_TERMINATED`.
        
7. A sessão passa para inativa.
    
8. O token é revogado.
    
9. A vaga simultânea é liberada.
    

---

## Redução do limite de acessos simultâneos

1. O superusuário altera `limite_sessoes_simultaneas` no contrato.
    
2. O sistema compara o novo limite com as sessões ativas.
    
3. Quando o novo limite fica abaixo da quantidade ativa:
    
    - as sessões existentes permanecem abertas;
        
    - o contrato fica com limite excedido;
        
    - nenhuma sessão é encerrada automaticamente;
        
    - novos logins são bloqueados.
        
4. O excesso diminui por:
    
    - logout;
        
    - timeout;
        
    - inativação do usuário;
        
    - encerramento administrativo.
        
5. Novos logins voltam a ser permitidos quando o total de sessões ativas fica abaixo do limite contratado.
    

---

## Mudança de permissões durante a sessão

1. Alterações em contrato, módulos, perfis ou permissões incrementam `permissions_version`.
    
2. O heartbeat retorna a versão atual.
    
3. O frontend pode comparar a versão recebida com a versão armazenada.
    
4. Quando identifica mudança:
    
    - recarrega o contexto do usuário;
        
    - atualiza permissões efetivas;
        
    - remonta menus;
        
    - reavalia a rota atual.
        
5. Mesmo antes da atualização visual, o backend continua sendo a autoridade para permitir ou negar operações.
    

---

## Venda PDV

1. Caixa ou vendedor inicia a venda.
    
2. Itens, pagamentos, cashback e NFC-e são processados.
    
3. O estoque é movimentado.
    
4. Financeiro e contabilidade recebem os reflexos previstos.
    
5. Dashboards consolidam os indicadores.
    

Este fluxo é transversal e deve ser revisto em conjunto com os módulos de vendas, fiscal, estoque e financeiro.

---

## Devolução de venda

1. Operador inicia a devolução a partir de uma venda finalizada.
    
2. O sistema valida quantidades e valores.
    
3. O estoque recebe a entrada de retorno.
    
4. O financeiro é ajustado ou estornado.
    
5. CMV e auditoria registram o evento.
    

Este fluxo permanece como visão funcional de alto nível e deverá ser detalhado durante a revisão do módulo de vendas.

---

## Distribuição entre lojas

1. A distribuição é criada a partir do estoque da origem.
    
2. Perfis e destinos definem a alocação.
    
3. A confirmação reserva estoque e gera pedidos.
    
4. A NF-e de transferência pode ser emitida.
    
5. Estoque e financeiro são atualizados na origem e no destino.
    

Este fluxo permanece como visão funcional de alto nível e deverá ser validado durante a revisão do módulo de distribuição.

---

## Pagamento e recebimento

1. O título nasce de compra, venda, transferência ou lançamento manual.
    
2. A baixa gera movimentação financeira.
    
3. O lançamento contábil é criado ou estornado conforme a natureza.
    
4. O dashboard utiliza os dados consolidados.
    

Este fluxo deverá ser confirmado em detalhes durante a revisão dos módulos financeiro e contábil.

---

## Produção e estoque

1. A ficha técnica define a composição.
    
2. A ordem de produção consome insumos.
    
3. A finalização movimenta o estoque.
    
4. A produção pode alimentar distribuição, venda e financeiro.
    

Este fluxo permanece como visão funcional de alto nível e deverá ser validado durante a revisão dos módulos de produção e estoque.

---

## Última atualização

2026-08-04

## Limitações do contexto

Os fluxos de autenticação, sessões simultâneas, heartbeat, timeout, logout e encerramento de sessão refletem a implementação commitada em 2026-08-04.

Os fluxos de PDV, devolução, distribuição, financeiro e produção permanecem como mapas funcionais resumidos do Vault. Eles ainda deverão ser confrontados com o código real durante a revisão individual de cada módulo.

Operações transversais devem ser testadas por integração. Evitar alterar apenas um app sem verificar efeitos em autenticação, permissões, auditoria, fiscal, financeiro, estoque e dashboards.

## Notas relacionadas

- [[10 Projetos/Sysvar/Sysvar|Sysvar]]
    
- [[10 Projetos/Sysvar/Contexto do Projeto/Arquitetura|Arquitetura]]
    
- [[10 Projetos/Sysvar/Contexto do Projeto/Modelo de Domínio|Modelo de Domínio]]
    
- [[10 Projetos/Sysvar/Contexto do Projeto/Riscos e Cuidados|Riscos e Cuidados]]
    
- [[10 Projetos/Sysvar/Decisões Técnicas/ADR-001 - Licenciamento por Sessões Simultâneas|ADR-001 - Licenciamento por Sessões Simultâneas]]