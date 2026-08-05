---

type: reference  
status: active  
project: Sysvar  
source: "C:/SysvarProjeto"  
created: 2026-08-03  
updated: 2026-08-05  
tags:

- sysvar
    
- riscos
    
- arquitetura
    
- segurança
    
- auditoria
    
- multiempresa
    

---

# Riscos e Cuidados

## Objetivo

Este documento reúne os principais riscos técnicos, funcionais e arquiteturais do SISVAR.

Ele deve ser utilizado como referência durante:

- novas implementações;
    
- correções;
    
- refatorações;
    
- revisão de módulos;
    
- criação de migrations;
    
- alterações de segurança;
    
- integrações;
    
- homologações.
    

A existência de uma infraestrutura implementada não elimina o risco de regressão.

Sempre que uma regra estrutural for alterada, este documento deve ser revisado.

---

# Regra geral

Nunca considerar uma funcionalidade segura apenas porque funcionou no frontend.

Toda operação relevante deve ser validada no backend.

Nunca confiar isoladamente em:

- JavaScript;
    
- LocalStorage;
    
- SessionStorage;
    
- query parameters;
    
- payload;
    
- URL;
    
- IDs enviados pelo cliente;
    
- campos ocultos;
    
- menus ocultos;
    
- validações do formulário.
    

O backend é a autoridade final.

---

# Multiempresa

## Isolamento de dados

Todo dado pertencente a um cliente deve possuir empresa identificável.

O backend deve impedir que um usuário de uma empresa consiga:

- listar dados de outra empresa;
    
- consultar dados de outra empresa;
    
- alterar dados de outra empresa;
    
- excluir dados de outra empresa;
    
- vincular objetos de outra empresa;
    
- usar loja de outra empresa;
    
- usar perfil de outra empresa;
    
- consultar sessões de outra empresa;
    
- consultar auditoria de outra empresa;
    
- exportar dados de outra empresa.
    

O risco não está apenas no queryset.

Também existe risco em:

- serializers;
    
- validações de ForeignKey;
    
- actions customizadas;
    
- commands;
    
- serviços;
    
- imports;
    
- exports;
    
- tarefas automáticas;
    
- integrações;
    
- consultas SQL diretas.
    

---

## Querysets

Todo queryset de dados empresariais deve ser filtrado pela empresa do usuário ou por contexto administrativo autorizado.

Nunca utilizar:

```python
Model.objects.all()
```

em endpoint de usuário cliente sem aplicar isolamento posterior de forma garantida.

A ausência do filtro pode causar vazamento entre clientes.

---

## Objetos enviados no payload

Mesmo quando o queryset principal está filtrado, o usuário pode tentar enviar IDs de objetos pertencentes a outra empresa.

Exemplos:

- loja;
    
- fornecedor;
    
- cliente;
    
- produto;
    
- perfil;
    
- natureza financeira;
    
- conta contábil;
    
- forma de pagamento;
    
- pedido;
    
- sessão.
    

Todo relacionamento deve ser validado.

---

## Superusuário

O superusuário possui acesso global, mas esse acesso deve ser explícito.

Não transformar automaticamente usuários `is_staff` em administradores globais do SISVAR.

As permissões internas do Django não substituem as regras da plataforma.

---

# Multilojas

## Isolamento por loja

Quando o domínio depende de loja, o backend deve validar:

- se a loja pertence à empresa;
    
- se o usuário possui acesso à loja;
    
- se o registro pertence à loja;
    
- se a sessão está vinculada à loja correta;
    
- se a operação aceita contexto sem loja.
    

Não confiar apenas no filtro visual do frontend.

---

## Eventos sem loja

Nem todo evento pertence a uma loja.

Exemplos:

- contrato;
    
- perfil;
    
- permissão;
    
- configuração da empresa.
    

Não inventar uma loja para preencher contexto.

Loja deve permanecer nula quando não se aplica.

---

## Loja principal

Não utilizar automaticamente a loja principal do usuário quando a operação possui outra fonte confiável.

A ordem de resolução deve respeitar o objeto e a sessão.

---

# Autenticação

## Serviço central

Toda autenticação deve utilizar o fluxo central existente.

É proibido criar login paralelo em módulos específicos.

Toda autenticação deve considerar:

- credenciais;
    
- usuário ativo;
    
- empresa;
    
- situação da empresa;
    
- contrato;
    
- vigência;
    
- perfil;
    
- módulos contratados;
    
- sessão;
    
- dispositivo;
    
- limite simultâneo.
    

---

## Tokens

Nunca armazenar token bruto no banco.

Persistir somente hash.

Nunca registrar em auditoria:

- token;
    
- hash do token;
    
- Authorization header;
    
- cookie;
    
- access token;
    
- refresh token.
    

Token revogado ou sem sessão válida não pode autenticar.

---

## Credenciais inválidas

Eventos de login negado devem ser auditados sem registrar:

- senha;
    
- payload integral;
    
- token;
    
- dados sensíveis desnecessários.
    

A mensagem ao usuário não deve facilitar enumeração de contas.

---

# Sessões simultâneas

## Consumo de licença

Licença é consumida por sessão ativa.

Não é consumida por:

- usuário cadastrado;
    
- usuário ativo;
    
- perfil;
    
- loja;
    
- dispositivo sem login.
    

Nunca voltar ao controle por quantidade de usuários ativos.

---

## Concorrência

Dois logins podem disputar a última vaga.

A contagem e a criação da sessão devem permanecer na mesma transação.

O contrato deve ser bloqueado quando necessário.

Nunca fazer:

1. contar sessões;
    
2. sair da transação;
    
3. criar sessão depois.
    

Isso permite excesso de acessos simultâneos.

---

## Mesmo dispositivo

Novo login do mesmo usuário e dispositivo deve:

- encerrar a sessão anterior;
    
- revogar o token anterior;
    
- criar ou assumir a nova sessão;
    
- manter apenas uma vaga consumida.
    

Dispositivos diferentes representam sessões independentes.

---

## Timeout

Sessões abandonadas não podem ocupar vaga indefinidamente.

O timeout deve:

- encerrar a sessão;
    
- revogar o token;
    
- registrar motivo;
    
- liberar a vaga;
    
- gerar auditoria quando aplicável.
    

---

## Heartbeat

O heartbeat não pode ser tratado como única validação da sessão.

Cada requisição autenticada ainda deve validar:

- token;
    
- sessão;
    
- expiração;
    
- usuário;
    
- contrato.
    

Evitar gravação excessiva a cada requisição.

---

## Redução do limite

Reduzir o limite abaixo das sessões ativas não deve encerrar sessões automaticamente.

O sistema deve:

- manter sessões existentes;
    
- bloquear novos logins;
    
- liberar acesso gradualmente por logout ou timeout.
    

Alterações futuras nessa regra exigem nova ADR.

---

# Contratos

## Validação

Toda autenticação de usuário cliente depende de contrato válido.

Validar:

- existência;
    
- situação;
    
- vigência;
    
- módulos;
    
- limite de sessões;
    
- usuário master.
    

---

## Alterações críticas

São operações críticas:

- criar contrato;
    
- alterar status;
    
- alterar vigência;
    
- alterar limite;
    
- alterar plano completo;
    
- alterar módulos;
    
- transferir master.
    

Essas operações devem utilizar:

- transação;
    
- auditoria obrigatória;
    
- atualização da versão das permissões;
    
- testes de regressão.
    

---

## Falha de auditoria obrigatória

Quando uma operação crítica depende de auditoria obrigatória, a falha da auditoria deve impedir o commit.

Não utilizar `transaction.on_commit()` esperando desfazer uma transação já confirmada.

---

# Módulos contratados

## Frontend e backend

Módulo não contratado deve ser bloqueado em dois níveis:

- frontend;
    
- backend.
    

Não permitir acesso apenas porque a rota existe.

---

## Relatórios compostos

Alguns relatórios dependem de mais de um módulo.

Exemplo:

```text
Relatórios + Financeiro
```

Não liberar um relatório apenas porque o módulo de Relatórios foi contratado.

---

## Chaves estáveis

As chaves dos módulos não devem ser renomeadas sem análise de impacto.

Elas podem estar referenciadas em:

- banco;
    
- migrations;
    
- backend;
    
- frontend;
    
- testes;
    
- perfis;
    
- contratos;
    
- documentação.
    

---

# Usuário Master

## Exclusão e inativação

O master não pode ser excluído ou inativado sem transferência prévia.

A transferência deve:

- validar empresa;
    
- validar novo usuário;
    
- impedir superusuário como master da empresa;
    
- garantir usuário ativo;
    
- utilizar transação;
    
- gerar auditoria obrigatória.
    

---

## Escopo

O master administra apenas a própria empresa.

Ser master não concede acesso global à plataforma.

---

# Perfis e Permissões

## Default deny

Ausência de permissão significa bloqueio.

Não criar fallback permissivo.

---

## Nome do perfil

Não conceder acesso com base no nome do perfil.

Exemplos perigosos:

```text
Admin
Gerente
Master
```

O acesso deve depender da permissão efetiva.

---

## Role antiga

Evitar verificações antigas baseadas apenas em:

```text
roles: ['Admin']
```

Quando o recurso já utiliza módulos e permissões efetivas.

Esse problema já ocorreu na rota de Auditoria e foi corrigido.

Novas telas devem verificar o padrão atual.

---

## Perfil padrão

A regra de perfil padrão único por empresa precisa continuar garantida pela aplicação, pois o MySQL pode não aplicar constraints condicionais do Django.

Alterações devem utilizar:

- transação;
    
- bloqueio;
    
- validação;
    
- auditoria obrigatória;
    
- testes concorrentes quando necessário.
    

---

## Alteração de permissão

Alterar permissão pode afetar vários usuários imediatamente.

Deve:

- incrementar `permissions_version`;
    
- gerar auditoria;
    
- atualizar o contexto do frontend;
    
- impedir vínculo cruzado entre empresas.
    

---

# Auditoria Central

## Infraestrutura única

O app oficial é:

```text
auditoria
```

O serviço oficial é:

```text
AuditService
```

Não criar:

- outra tabela paralela;
    
- outro middleware concorrente;
    
- outro serviço de logs;
    
- gravação direta espalhada.
    

---

## Criação de eventos

Novos eventos devem utilizar o `AuditService`.

Não utilizar diretamente:

```python
AuditLog.objects.create(...)
```

A criação direta é bloqueada.

---

## Imutabilidade

Logs não podem ser alterados ou excluídos por operações comuns.

Estão bloqueados:

- `save()` em registro existente;
    
- `delete()`;
    
- `QuerySet.update()`;
    
- `QuerySet.delete()`;
    
- `bulk_create()`;
    
- `bulk_update()`;
    
- `update_or_create()`;
    
- `get_or_create()`.
    

Não criar atalhos que contornem esses bloqueios.

---

## Signals

Signals são auxiliares.

Não devem ser usados como única solução para ações de negócio.

Signals não compreendem corretamente operações como:

- aprovar;
    
- cancelar;
    
- baixar;
    
- estornar;
    
- faturar;
    
- emitir;
    
- distribuir;
    
- finalizar.
    

Esses eventos devem ser explícitos.

---

## Duplicidade

Uma mesma operação não pode gerar dois eventos equivalentes por combinação de:

- signal;
    
- serializer;
    
- view;
    
- service;
    
- wrapper legado.
    

Sempre verificar contagem exata de eventos nos testes.

---

## Auditoria após commit

Eventos comuns de sucesso devem usar `transaction.on_commit()` quando dependerem da confirmação da operação.

Não registrar sucesso antes do commit.

---

## Auditoria obrigatória

Somente operações realmente críticas devem utilizar modo obrigatório.

Uso excessivo pode indisponibilizar operações por falhas secundárias.

Uso insuficiente pode permitir operação crítica sem rastreabilidade.

A classificação deve ser explícita.

---

## Acesso negado

Tentativas de acessar outra empresa ou loja devem:

- retornar 403;
    
- gerar um único evento;
    
- evitar recursão;
    
- não revelar dados do recurso solicitado.
    

---

## Dados sensíveis

Nunca registrar:

- senha;
    
- token;
    
- cookie;
    
- Authorization;
    
- certificado;
    
- chave privada;
    
- client secret;
    
- hash de token;
    
- XML integral sem necessidade;
    
- dados bancários completos.
    

A sanitização deve continuar recursiva.

---

## Snapshots

Snapshots devem utilizar campos reais dos models.

Não depender exclusivamente de ForeignKeys atuais.

Não inventar contexto histórico quando não houver fonte confiável.

---

## Logs antigos

O campo legado `changes` ainda existe por compatibilidade.

Novos eventos não devem depender dele.

A remoção futura exige:

- nova migration;
    
- verificação do frontend;
    
- verificação de exportações;
    
- verificação de dados antigos.
    

---

## Crescimento da tabela

A tabela de auditoria tende a crescer continuamente.

Riscos:

- consultas lentas;
    
- índices insuficientes;
    
- armazenamento elevado;
    
- exportações pesadas;
    
- backups maiores.
    

Cuidados:

- paginação;
    
- filtros por período;
    
- índices;
    
- limite de exportação;
    
- política futura de retenção;
    
- monitoramento de tamanho.
    

---

## Retenção

A retenção automatizada ainda não foi implementada.

Não apagar logs manualmente.

Uma política futura deve considerar:

- prazo legal;
    
- categorias;
    
- fiscal;
    
- financeiro;
    
- segurança;
    
- arquivamento;
    
- auditoria da própria exclusão.
    

---

## Falha interna da Auditoria

Falhas comuns devem ser registradas no logger.

Não usar permanentemente:

```python
except Exception:
    pass
```

Eventos de baixa criticidade podem não derrubar a operação principal.

Eventos obrigatórios devem impedir a operação.

---

# Banco de Dados

## Migrations

Toda alteração estrutural precisa de migration.

Não alterar o banco manualmente como solução definitiva.

---

## Data migrations

Utilizar:

```python
apps.get_model()
```

Não importar models atuais diretamente.

Considerar:

- banco vazio;
    
- banco com dados;
    
- MySQL;
    
- reexecução lógica;
    
- volume;
    
- memória;
    
- dados nulos;
    
- reversão.
    

---

## Constraints

Não confiar em constraints não suportadas pelo MySQL.

Sempre verificar mensagens emitidas pelo Django durante migrations.

---

## Exclusões

ForeignKeys podem impedir exclusões.

Não desligar constraints apenas para “resolver” rapidamente.

Analisar:

- dependências;
    
- hierarquia;
    
- registros filhos;
    
- histórico;
    
- auditoria.
    

---

# Performance

## Consultas

Evitar:

- N+1;
    
- queries globais;
    
- consultas sem índices;
    
- joins desnecessários;
    
- filtros em JSON para campos frequentes;
    
- tabelas inteiras no frontend.
    

Utilizar quando aplicável:

- `select_related`;
    
- `prefetch_related`;
    
- paginação;
    
- agregações;
    
- índices compostos.
    

---

## Auditoria

Não registrar todas as consultas GET indiscriminadamente.

Auditar:

- consultas sensíveis;
    
- exportações;
    
- acessos negados;
    
- operações críticas.
    

---

## Exportação

Toda exportação deve possuir limite.

Não gerar arquivos gigantes em memória sem estratégia.

Registrar:

- filtros;
    
- quantidade;
    
- limite;
    
- usuário;
    
- empresa;
    
- loja.
    

---

# Frontend

## Autoridade

O frontend é responsável por interface e experiência.

Não deve ser autoridade para:

- permissão;
    
- empresa;
    
- loja;
    
- contrato;
    
- módulos;
    
- valores críticos;
    
- estoque;
    
- financeiro;
    
- fiscal.
    

---

## Angular Standalone

Novos componentes devem seguir Angular 17 standalone.

Não introduzir `NgModule` sem decisão arquitetural.

---

## Rotas e menus

Rotas e menus devem utilizar permissões efetivas.

Não duplicar regras incompatíveis entre:

- guard;
    
- menu;
    
- componente;
    
- backend.
    

---

## Tratamento de 401 e 403

401:

- sessão inválida;
    
- token inválido;
    
- sessão expirada;
    
- logout local quando aplicável.
    

403:

- usuário autenticado sem permissão;
    
- empresa não autorizada;
    
- loja não autorizada;
    
- módulo bloqueado.
    

Não tratar 403 como sessão expirada automaticamente.

---

# Segurança

## Mass assignment

Serializers devem impedir alteração de campos críticos.

Usuário cliente não pode alterar:

- `is_staff`;
    
- `is_superuser`;
    
- grupos internos;
    
- permissões internas do Django;
    
- empresa;
    
- contrato;
    
- usuário master;
    
- campos de controle da plataforma.
    

---

## Dados pessoais

Expor somente o necessário.

Listagens, logs e exports devem aplicar mascaramento quando necessário.

---

## Erros

Não devolver stack trace ou detalhes internos ao frontend.

Registrar detalhes técnicos no logger e retornar mensagem segura.

---

# Integração entre Módulos

Uma operação pode afetar vários domínios.

Exemplo:

```text
Entrada de Nota Fiscal
→ Compras
→ Estoque
→ Fiscal
→ Financeiro
→ Contabilidade
→ Auditoria
```

Não implementar apenas uma parte sem verificar os efeitos laterais.

---

## Serviços de domínio

Cada módulo deve manter suas próprias regras.

Exemplos:

- estoque movimenta saldo;
    
- financeiro cria e baixa títulos;
    
- fiscal emite documentos;
    
- compras controla pedidos;
    
- auditoria registra eventos.
    

Um módulo pode chamar outro serviço, mas não duplicar sua regra.

---

# Testes

## Testes obrigatórios

Toda funcionalidade deve ter testes proporcionais ao risco.

Exemplos:

- isolamento;
    
- permissão;
    
- transação;
    
- rollback;
    
- concorrência;
    
- migration;
    
- frontend;
    
- API;
    
- regressão.
    

---

## Suíte geral

O comando geral precisa descobrir testes reais.

Resultado “0 testes” não é aprovação.

---

## Testes manuais

Testes automatizados não substituem totalmente homologação visual e funcional.

Telas novas devem ser validadas no navegador.

---

# Documentação

Nenhuma funcionalidade é considerada concluída sem:

- implementação;
    
- testes;
    
- revisão técnica;
    
- homologação;
    
- atualização do Obsidian;
    
- commit do código;
    
- commit da documentação.
    

Não documentar como concluído algo apenas planejado.

---

# ADRs

Toda decisão arquitetural duradoura deve gerar ADR.

Decisões atuais:

- ADR-001 — Licenciamento por Sessões Simultâneas;
    
- ADR-002 — Princípios Arquiteturais do SISVAR;
    
- ADR-003 — Auditoria Central do SISVAR.
    

Mudança relevante em decisão aprovada exige nova ADR.

---

# Riscos mitigados atualmente

Foram tratados:

- autenticação centralizada;
    
- isolamento multiempresa;
    
- isolamento da Auditoria por empresa;
    
- isolamento da Auditoria por loja;
    
- contratos;
    
- módulos contratados;
    
- usuário master;
    
- perfis;
    
- permissões efetivas;
    
- licenciamento por sessões;
    
- concorrência da última vaga;
    
- heartbeat;
    
- timeout;
    
- encerramento administrativo;
    
- Auditoria Central;
    
- imutabilidade dos logs;
    
- sanitização;
    
- snapshots históricos;
    
- controle de acesso à Auditoria;
    
- exportação controlada;
    
- auditoria obrigatória em operações críticas definidas.
    

---

# Riscos ainda abertos

## Integração da Auditoria com módulos de negócio

A infraestrutura está pronta, mas ainda falta revisar detalhadamente eventos específicos de:

- Cadastros;
    
- Produtos;
    
- Compras;
    
- Estoque;
    
- Financeiro;
    
- Fiscal;
    
- Vendas;
    
- PDV;
    
- Produção;
    
- Distribuição;
    
- Relatórios.
    

---

## Entrada de Nota Fiscal

É uma operação transversal e deve ser projetada antes da implementação.

Riscos:

- duplicidade de entrada;
    
- divergência com pedido;
    
- estoque incorreto;
    
- financeiro duplicado;
    
- impostos incorretos;
    
- vínculo fiscal incompleto;
    
- rollback parcial;
    
- auditoria insuficiente.
    

---

## Produção

Riscos:

- consumo incorreto de matéria-prima;
    
- saldo negativo;
    
- finalização parcial;
    
- custo incorreto;
    
- divergência com facção;
    
- falta de rastreabilidade.
    

---

## Distribuição

Riscos:

- alocação acima do estoque;
    
- arredondamento incorreto;
    
- transferência duplicada;
    
- origem e destino inconsistentes;
    
- faturamento sem recebimento;
    
- diferença por tamanho;
    
- falta de auditoria do processo completo.
    

---

## PDV Offline

Riscos:

- conflito de sincronização;
    
- venda duplicada;
    
- numeração fiscal;
    
- certificado local;
    
- estoque divergente;
    
- preço desatualizado;
    
- usuário offline sem permissão atual;
    
- sessão e auditoria offline;
    
- reconciliação posterior.
    

---

## Retenção da Auditoria

Ainda não existe política automatizada.

Deve ser projetada antes do crescimento de produção.

---

## Backups

A estratégia de backup MySQL ainda precisa ser formalizada com:

- frequência;
    
- retenção;
    
- cópia offsite;
    
- criptografia;
    
- teste de restauração;
    
- monitoramento.
    

Backup sem teste de restauração não é garantia.

---

# Próxima prioridade recomendada

O próximo módulo deve ser escolhido considerando impacto transversal.

A principal candidata é:

```text
Entrada de Nota Fiscal
```

Antes de implementar, deve ser realizada análise completa de:

- pedido existente;
    
- entrada avulsa;
    
- XML;
    
- fornecedor;
    
- itens;
    
- impostos;
    
- estoque;
    
- financeiro;
    
- fiscal;
    
- contabilidade;
    
- auditoria;
    
- cancelamento;
    
- estorno;
    
- duplicidade.
    

---

# Notas relacionadas

- [[10 Projetos/Sysvar/Sysvar|Sysvar]]
    
- [[10 Projetos/Sysvar/Contexto do Projeto/Arquitetura|Arquitetura]]
    
- [[10 Projetos/Sysvar/Contexto do Projeto/Modelo de Domínio|Modelo de Domínio]]
    
- [[10 Projetos/Sysvar/Contexto do Projeto/Workflows|Workflows]]
    
- [[10 Projetos/Sysvar/Contexto do Projeto/Mapa Técnico|Mapa Técnico]]
    
- [[10 Projetos/Sysvar/Decisões Técnicas/ADR-001 - Licenciamento por Sessões Simultâneas|ADR-001 - Licenciamento por Sessões Simultâneas]]
    
- [[10 Projetos/Sysvar/Decisões Técnicas/ADR-002 - Princípios Arquiteturais do SISVAR|ADR-002 - Princípios Arquiteturais do SISVAR]]
    
- [[10 Projetos/Sysvar/Decisões Técnicas/ADR-003 - Auditoria Central do SISVAR|ADR-003 - Auditoria Central do SISVAR]]