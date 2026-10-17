---
type: project
status: planned
project: Sysvar
source: "FernandoMurashima/sysvarbackend + FernandoMurashima/sysvarfrontend + FernandoMurashima/sysvarhub-backend + FernandoMurashima/sysvarhub-frontend + FernandoMurashima/sysvar-vault"
created: 2026-10-17
updated: 2026-10-17
tags:
  - sysvar
  - centro-de-operacoes
  - suporte
  - monitoramento
  - hub
  - pdv
  - backup
  - sincronizacao
  - sessoes
  - ativacao
  - planejamento
  - prompts
---

# Planejamento — Centro de Operações e Suporte Sysvar

> **Documento de referência para retomada do projeto.** Decisões funcionais e experiência desejada aprovadas como direção em 17/10/2026. Implementação do novo painel **NÃO INICIADA**. A sequência de prompts abaixo é uma estimativa inicial, sujeita ao inventário do Prompt 01.

## 1. Identificação e decisão

**Nome funcional:** Centro de Operações e Suporte Sysvar (também chamado de **Painel de Operações** ou **Centro de Operações**).

**Produto:** Sysvar Central, com monitoramento e administração da Central, dos Sysvar Hubs instalados nas lojas e dos terminais PDV.

**Público principal:** técnico/analista de suporte Sysvar operando em monitor amplo durante todo o expediente. Público secundário: administrador da empresa, com visão e operações restritas às próprias unidades e permissões.

**Decisão:** o produto comercial **não pode depender de PowerShell, SSH, Docker, MySQL, comandos manuais nem edição de arquivos de configuração pelo suporte**. Esses mecanismos podem existir internamente, mas as rotinas operacionais devem estar empacotadas, pré-configuradas, autenticadas, com resultado legível e acionáveis por interfaces do Sysvar Central.

**Objetivo de uso:** abrir o Centro de Operações, perceber imediatamente o que não está saudável e chegar, em poucos cliques, ao diagnóstico e à ação administrativa adequada. Não é simplesmente um dashboard de indicadores; é uma estação de trabalho para **monitorar, investigar, atuar e auditar**.

**Decisão visual aprovada:** **um painel grande, visualmente coeso e com alta densidade de informação, acrescido de sobretelas operacionais amplas e contextuais**. Evitar mini-tabelas e quadros fragmentados, navegação desnecessária e rolagem horizontal.

## 2. Resultados esperados

1. Enxergar todas as empresas no escopo do suporte, quantas lojas possuem, quais estão online, quais Hubs e PDVs estão conectados e quais situações exigem ação.
2. Diferenciar rigorosamente **Hub online**, **PDV conectado**, **sessão de caixa aberta/fechada** e **sessão de licenciamento ocupada/livre**.
3. Mostrar por empresa **quantas sessões simultâneas foram contratadas, quantas estão ativas, quem as utiliza e quantas restam**. Permitir encerrar uma sessão travada com autorização, confirmação e auditoria.
4. Saber quando uma venda ou outro evento ficou pendente no Hub, falhou no envio, foi rejeitado ou ainda aguarda confirmação da Central.
5. Saber quando ocorreu falha de pagamento, caixa, operação fiscal ou outro erro operacional relevante no PDV/Hub, mesmo que o Hub tenha de enviar a ocorrência somente após a reconexão.
6. Supervisionar último backup FULL/incremental, captura, transmissão, recebimento confirmado pela Central, pendências, integridade e histórico de falhas.
7. Administrar ativação de Hubs, terminais, configuração, pareamento, política e programação de backups, sincronização, incidentes e sessões usando operações específicas na interface.
8. Informar sempre a **última atualização** e não confundir informação desatualizada com estado normal.
9. Operar com múltiplas empresas/lojas, respeitando licenciamento, limites de contrato e separação de dados.
10. Preservar as funcionalidades de Central/Hub existentes e as homologações já concluídas.

## 3. Experiência visual e interação obrigatória

### 3.1 Tela principal — o "painelzão"

Uma única superfície operacional profissional, adequada a monitor grande, com:

- cabeçalho de contexto (plataforma/empresa selecionada, filtro, atualização, estado geral);
- indicadores grandes e **clicáveis**: empresas monitoradas, lojas online/sem contato, Hubs, PDVs conectados, incidentes abertos, backups atrasados e sincronizações pendentes;
- bloco de **licenciamento da empresa selecionada**: contratadas, utilizadas, livres, proporção utilizada;
- resumo de operações das lojas: Hub, PDVs, caixas abertos/fechados, sincronização, backup e alertas;
- fila de ocorrências ordenada por severidade, impacto e idade;
- sinalização visual clara, sem exagerar cores ou transformar caixa fechado em erro;
- atualização automática e indicação de dados possivelmente obsoletos.

**Todo indicador, linha, incidente ou estado relevante deve ser acionável.** Clicar não deve jogar o usuário em páginas dispersas: abre-se uma **sobretela de trabalho** sobre o painel.

### 3.2 Sobretelas operacionais — regra de UX

Sobretela grande (cerca de 80% a 95% da área útil, variável pelo conteúdo); fundo do painel ainda reconhecível; cabeçalho com título, contexto e fechamento; filtros, busca, paginação e ações; acessibilidade de teclado, foco e saída; scroll do conteúdo da sobretela, **não** rolagem horizontal da página; responsividade para notebook.

Sobretelas propostas:

| Clique no painel | Conteúdo operacional na sobretela |
|---|---|
| Empresas monitoradas | Empresas no escopo, contrato, módulos, lojas, situação, seleção de empresa |
| Lojas online / sem comunicação | Lista de lojas, Hub, último contato, terminais, caixa, backup e operações |
| PDVs conectados | Lista por empresa/loja, terminal, pareamento, online, última atividade e situação do caixa |
| Sessões contratadas / em uso | Total contratado, ativos, livres; usuário, dispositivo, hora, contexto, encerramento autorizado |
| Incidentes abertos | Filtros, severidade, causa, impacto, histórico, responsável, diagnóstico, tratamento |
| Sincronização | Fila, eventos, documento/venda, status, tentativas, erro, confirmação Central e reenvio seguro |
| Backups | FULL, incrementais, captura, recebimento, validação, atraso, configuração, comandos e histórico |
| Ativação / suporte | Hubs sem ativação, códigos com validade, terminais, configuração, pareamento, comandos e retorno |

**Interação em profundidade:** painel → sobretela → detalhe contextual dentro da mesma área de trabalho. Evitar pilhas descontroladas de modais; o componente deve ter hierarquia/breadcrumb e voltar ao estado anterior sem perder filtros ou seleção.

**Botões operacionais:** situação inicial, solicitação, execução pendente, sucesso, erro, timeout; confirmação para ações sensíveis; indicação explícita de que um Hub offline executará a solicitação quando possível ou de que a ação não está disponível.

### 3.3 Conceitos que não podem ser misturados

**Licenciamento:** o contrato da empresa limita sessões simultâneas. Exemplo funcional: 18 contratadas, 13 ocupadas, 5 disponíveis; quantidade de lojas **não** representa licenças. A empresa com 5 lojas e 2 caixas por loja precisa dimensionar capacidade para 10 postos PDV mais acessos administrativos. **Prompt 01 deve conferir no código atual se e como a sessão/ocupação do PDV participa da mesma cota antes de apresentar soma unificada como fato técnico.**

**Terminais:** um Hub pode atender múltiplos terminais PDV, cada um com seu estado de pareamento e conexão. "2/2 PDVs conectados" não implica dois caixas abertos.

**Caixa:** aberto ou fechado é estado operacional independente. **PDV conectado + caixa fechado é normal** e não deve disparar alerta só por isso. Se Hub ficar sem comunicação, estado atual do caixa torna-se **desconhecido**; mostrar última informação e sua data, sem inferir caixa fechado.

**Sincronização:** "processado na Central" só quando houver confirmação. Venda finalizada no Hub sem confirmação tem estado pendente ou com erro, não concluída.

**Backup:** captura local, envio, recebimento e possibilidade de restauração são marcos diferentes. "RECEBIDO_CENTRAL" não prova, isoladamente, restauração funcional.

## 4. Escopo funcional por domínio

### 4.1 Empresas, contratos e sessões

- Visão global somente para perfil de suporte da plataforma devidamente autorizado; administrador empresarial só enxerga a própria empresa.
- Mostrar situação contratual, limite de sessões simultâneas e contagem efetivamente válida.
- Sobretela de sessões: usuário, empresa, origem, dispositivo (conforme registros disponíveis), início, última atividade, estado, identificação da sessão, encerramento individual e trilha de auditoria.
- Evitar encerrar em massa ou liberar consumo sem revogar a sessão/token correspondente.
- Se licenciamento do PDV tiver mecanismo distinto, **não somar artificialmente**: mapear diferença no Prompt 01 e definir integração de forma explícita antes do Prompt 10.
- Erro por limite atingido deve ser rastreável como ocorrência de licenciamento quando aplicável, sem exposição de dados desnecessários.

### 4.2 Lojas, Hubs, PDVs e caixas

- Empresa → lojas → Hub → terminais → caixa/sessão de caixa.
- Hub: ativado, inativo, desativado, sem credencial, conectado, sem contato, versão, último heartbeat.
- Terminal: cadastrado, pareado, ativo, conectado/desconectado, última conexão, caixa vinculado.
- Caixa: aberto/fechado/sem caixa/desconhecido, responsável e horário apenas quando disponibilizados no contrato de telemetria.
- Se snapshot antigo: mostrar "última informação em ..." e estado inconclusivo.
- Erros e diagnósticos precisam apontar a loja, o Hub, o terminal e a operação, quando identificáveis.

### 4.3 Sincronização e eventos comerciais

- Filas Central ↔ Hub, pendências, retries, status, última comunicação, histórico e erro.
- Caso exemplar: "Venda finalizada no PDV, ainda não recebida pela Central". Exibir documento, horário, identificador, tentativas e resultado; reprocessar **idempotentemente**, sem recriar venda/pagamento.
- Apresentar os eventos relevantes de vendas, devoluções, recebimentos, cashback, vales e operações fiscais sem expor detalhes internos ao operador.
- Falha na sincronização é incidente; período offline exige estado próprio, não afirmar que uma venda se perdeu.
- Documentos comerciais devem usar os identificadores oficiais existentes.

### 4.4 Backups, transmissão e continuidade

- Consolidação de FULL e incrementais, criação local, integridade, recebimento Central, status do encadeamento, último sucesso e atraso.
- Mostrar configuração: envio habilitado/desabilitado, agendamento, última execução, último erro, fila de transferência, intervenção de suporte.
- Gerenciamento visual da **ativação automática**: habilitar/desabilitar transmissão, verificar pré-requisitos, solicitar backup autorizado e observar resultado. Não limitar o fluxo a alterar um booleano; instalação, serviço agendado e credenciais devem ser preparados pelo instalador/agente comercial.
- **Não disponibilizar execução arbitrária de PowerShell.** O Hub executa um catálogo fechado de ações assinadas/validadas; Central solicita, Hub busca pela conexão autenticada, responde status e registra auditoria.
- Restauração: exibir pontos de recuperação e estado de prontidão; execução real de restauração, potencialmente destrutiva, só com fluxo separado de autorização, validações, exclusividade e homologação específica.
- Proteger armazenamento criptografado e configuração segura do receptor Central. Não publicar chaves, tokens, arquivos .env ou comandos que revelem segredos.

### 4.5 Ativação, configuração e pareamento

- O fluxo oficial de instalação e ativação do Hub deve aparecer integralmente no painel: loja sem Hub → gerar ativação → Hub ativado → sincronização inicial → configurar terminal/caixa → gerar pareamento → terminal pareado → operacional.
- Consultar código pendente, validade, expirado, revogado, usado; gerar novo código quando permitido; ativar, reativar, desativar ou desvincular com permissão e confirmação.
- Visão de terminais, caixas vinculados, versão compatível, resultado dos comandos e erros.
- Aproveitar as rotas e o processamento de comandos administrativos já existentes; não criar um segundo subsistema de pareamento.

### 4.6 Incidentes e diagnóstico

- Gerar ocorrências para falhas relevantes de venda, pagamento, caixa, sincronização, fiscal, Hub/PDV, backup, ativação, sessão e infraestrutura monitorada.
- Incidentes têm identidade estável, severidade, classe, origem, timestamps, estado, contagem, deduplicação, histórico e correlação com operação.
- Fluxo de atendimento: novo → reconhecido/em análise → resolvido; permitir observações e responsável, com auditoria.
- Severidade por impacto real: venda sem confirmação e Hub indisponível normalmente mais urgentes que um aviso informativo; thresholds configuráveis e homologados.
- Eventos locais relevantes persistem offline e são enviados após reconexão; indicar claramente **horário do acontecimento** e **horário em que a Central recebeu**.
- Atrasos são apurados também do lado Central (ex.: heartbeat ausente ou backup não recebido). Sem conexão, não prometer telemetria instantânea.
- Cuidar de privacidade, volume, saturação e deduplicação para não produzir tempestade de alertas.

## 5. Inventário técnico consultado em 17/10/2026

**Estado verificado nos repositórios remotos main (leitura), não nos clones locais do notebook.** O Prompt 01 deverá atualizar este inventário contra o código da data de execução.

| Domínio | Recurso existente | Direção |
|---|---|---|
| Sessões Central | accounts/services/sessions.py, accounts/views.py; SessaoUsuario e EmpresaContrato, limite_sessoes_simultaneas, listagem e encerramento | Reutilizar como autoridade de licenciamento; verificar cota PDV |
| Administração Hub | hub/urls.py, hub/views.py; ativação, revogação, desativação/reativação/desvínculo | Integrar no Centro de Operações |
| Sincronização | hub/sincronizacao.py; solicitações e acompanhamento; interface Angular hub-sincronizacao | Reutilizar serviços; ampliar diagnóstico e interface |
| Telemetria Hub/PDV | heartbeat envia snapshot_operacional com terminais, estado e sessão de caixa | Ampliar apresentação e avaliação de frescor |
| Snapshot local | core/services/snapshot_operacional.py; online TTL local, caixa aberto/fechado | Respeitar semântica de status e timestamps |
| Backup Central | hub/backup_views.py, backup_recovery_views.py, HubBackup e armazenamento criptografado | Criar API administrativa segura e apresentação |
| Backup Hub | deploy/windows/backup-run.ps1, mysql-backup-transmission.ps1, mysql-backup-task.ps1, serviço transmissor Python | Integrar ao instalador e catálogo de comandos do Hub |
| Comandos do Hub | hub/commands/serviços administrativos e resposta no heartbeat | Estender com comandos específicos, autorização e auditoria |
| Frontend Central | app.routes.ts, shell.component.ts, hub-sincronizacao.component.* | Novo módulo visual e reutilização das chamadas existentes |

**Backup homologado em 17/10/2026:** Loja Centro com captura incremental agendada a cada 15 minutos, envio habilitado de forma permanente, execução do transmissor comprovada em ciclo natural, retorno RECEBIDO_CENTRAL, zero pendências; 15 arquivos transmitidos em teste e conferidos quanto à integridade no recebimento. **Não equivale a restauração integral homologada.**

**Alerta técnico prévio conhecido:** o antigo deploy-viper-ii.sh precisa adequação para preservar mounts/configuração segura do receptor de backups antes de futuro deploy. Correções comerciais de Windows feitas durante homologação devem ser incorporadas ao código-fonte e ao instalador, não depender de scripts avulsos no computador do cliente.

**Estado das fontes remotas consultadas:** sysvarbackend main 6b6f310457fb; sysvarfrontend main 7312bdaab9f5; sysvarhub-backend main 1cfb2b2fc829; sysvarhub-frontend main cecd3daed614. Referências apenas de inventário, não travas para implementação futura.

## 6. Arquitetura de integração proposta

**Central é a autoridade** de contratos, permissões, sessões corporativas, empresas, lojas, recebimento de backups e acompanhamento global. **Hub é a autoridade** da operação local, inclusive quando offline; PDV é interface operacional do terminal.

Fluxos conceituais:

    HUB/PDV -> registra eventos, snapshots e falhas localmente
    HUB -> heartbeat autenticado + fila de eventos -> CENTRAL
    CENTRAL -> persiste estados, confirma eventos, agrega incidentes
    SUPORTE -> abre painel e sobretela -> solicita ação permitida
    CENTRAL -> cria comando idempotente e auditável
    HUB -> recebe comando via canal autenticado -> executa operação aprovada
    HUB -> devolve andamento/resultado -> CENTRAL -> atualiza a sobretela

Regras:
- Não exigir que a Central abra acesso de entrada ao Windows de cada loja.
- Não executar shell genérico nem código remoto recebido por requisição.
- **Catálogo explícito** de operações, versão mínima do Hub, idempotência por identificador, prazo, autorização, proteção contra repetição e trilha de auditoria.
- Modelo de estados: online / offline / desconhecido / atrasado / pendente / erro, com frescor e critérios claros.
- Transmissão de erros por lotes limitados, com retenção local e confirmação idempotente, sem comprometer o fechamento de venda/PDV se a Central cair.
- API de painel: agregação e paginação server-side; consultas indexadas, sem N+1; evolução futura para SSE/WebSocket se justificável, sem necessidade de implantação prematura.

## 7. Planejamento de execução — 24 prompts em cinco blocos

### Regras de tamanho e execução

- **24 prompts inicialmente previstos**, não textos enormes. Se inventário revelar recurso pronto, reduzir/suprimir o prompt correspondente.
- Cada prompt trata **um objetivo principal**, preferencialmente **um repositório**. Se mais de um for inevitável, separar backend e frontend.
- Limite prático de escopo: tarefas de aproximadamente 5–15 minutos; dividir qualquer prompt que ameaçar mais de ~20 minutos de implementação focalizada.
- Níveis: **Leve**, **Médio** e **Alto** referem-se à necessidade de raciocínio do Codex; não à quantidade de mudanças liberadas.
- Ao executar: informar **caminho do repositório**, comportamento esperado, fora do escopo, testes direcionados, checagem de diff, commit e push. Saída objetiva, sem longas narrativas.
- Não editar o roadmap nem outros documentos automaticamente durante implementação. Atualização do cofre apenas após conferência do estado Git e aprovação.
- Não executar migrações destrutivas, alterar credenciais de produção ou recriar bases de teste/produção no pretexto de desenvolver o painel.

### Bloco 1 — Fundação, inventário e segurança (Prompts 01–04)

| Nº | Nível | Repositório preferencial | Objetivo delimitado |
|---|---|---|---|
| **01** | Médio | Central Backend e Hub Backend, **somente leitura** | Inventariar endpoints, entidades, licenciamento real do PDV, comandos, snapshots, alertas e lacunas. Desenhar contratos e dependências. **Não alterar código.** |
| **02** | Alto | Central Backend / deploy Viper-II | Tornar deploy seguro para montagens, backend de recepção de backups, armazenamento privado e rollback. Preflight e testes sem tocar banco nem instalações paralelas. |
| **03** | Médio | Hub Backend / deploy Windows | Incorporar correções homologadas do agendamento e transmissão nos artefatos comerciais; instalação idempotente, execução SYSTEM, política protegida e verificações pós-instalação. |
| **04** | Médio | Central Backend | Autorização do Centro de Operações: papéis de suporte versus empresa, escopo por tenant, permissões por ação, auditoria e testes de negação. |

**Homologação 1:** preflight de deploy preservado; rotina comercial Windows reproduzível; dados de contrato/segurança definidos; zero alteração indevida em instalações existentes.

### Bloco 2 — Telemetria, eventos e alertas (Prompts 05–09)

| Nº | Nível | Repositório preferencial | Objetivo delimitado |
|---|---|---|---|
| **05** | Médio | Hub Backend | Normalizar/enriquecer telemetria de Hub, terminal, PDV e caixa, aproveitando snapshot/heartbeat e evitando payload excessivo. |
| **06** | Médio | Hub Frontend | Instrumentar captura controlada de falhas operacionais relevantes do PDV e envio ao backend Hub, sem afetar venda offline. |
| **07** | Alto | Hub Backend | Persistir ocorrências, receber erros do PDV, transmitir eventos com fila/retry, limites, idempotência e retomada após reconexão. |
| **08** | Médio | Central Backend | Receber, autenticar, validar, guardar e correlacionar ocorrências por empresa/loja/Hub/terminal/operação, sem vazamento de dados. |
| **09** | Alto | Central Backend | Classificar e deduplicar incidentes; detectar silêncio de heartbeat, pendência, erro e atraso de backup; definir resolução e severidade auditáveis. |

**Homologação 2:** reproduzir erros controlados de operação, desativar temporariamente a conexão em ambiente seguro e confirmar recepção posterior sem duplicidade; testar perdas de contato e alerta de atraso.

### Bloco 3 — Consultas e comandos operacionais (Prompts 10–17)

| Nº | Nível | Repositório preferencial | Objetivo delimitado |
|---|---|---|---|
| **10** | Médio | Central Backend | Agregação de contratos e sessões simultâneas, detalhe de usuário/dispositivo e encerramento autorizado, **conforme regra PDV validada no Prompt 01**. |
| **11** | Médio | Central Backend | API de situação das empresas/lojas/Hub/PDV/caixas usando snapshot existente com TTL e informação de última atualização. |
| **12** | Médio | Central Backend | Diagnóstico detalhado da sincronização e de vendas/eventos pendentes; reprocessamento idempotente e rastreável. |
| **13** | Médio | Central Backend | Consulta administrativa segura de histórico de backups, cadeia, status, integridade, atrasos e pontos de recuperação sem expor segredo. |
| **14** | Alto | Hub Backend | Catálogo seguro de comandos de backup: consultar política/agendamento, habilitar ou suspender transmissão e solicitar backup, retornando status. Sem shell remoto genérico. |
| **15** | Alto | Central Backend | Enfileirar, autenticar, auditar e acompanhar comandos de backup enviados ao Hub; estados de espera, timeout e resultado. |
| **16** | Médio | Central Backend | Consolidar ativação, geração/revogação de código, configuração, pareamento, desativação/reativação/desvinculação usando comandos existentes. |
| **17** | Médio | Central Backend | API de atendimento de incidentes: listagem/filtros, responsável, histórico, comentários, reconhecimento e resolução segura. |

**Homologação 3:** ações por API e perfis adequados, testes de isolamento multitenant, Hub offline, repetição segura, expiração, ações concorrentes e auditoria completa.

### Bloco 4 — Interface premium e sobretelas (Prompts 18–23)

| Nº | Nível | Repositório preferencial | Objetivo delimitado |
|---|---|---|---|
| **18** | Alto | Central Frontend | Fundação visual do Centro de Operações: identidade, layout largo, navegação, **sobretela contextual reutilizável**, acessibilidade, responsividade e estados de carga/erro. |
| **19** | Alto | Central Frontend | **Painel principal grande** com indicadores clicáveis, filtro de empresa, resumo da operação, alertas e atualização automática; todas as entradas abrem sobretela. |
| **20** | Médio | Central Frontend | Sobretela **Empresas / Contratos / Sessões**, incluindo licenças contratadas, ocupação, detalhe e encerramento autorizado. |
| **21** | Médio | Central Frontend | Sobretela **Lojas / Hubs / PDVs / Caixas** distinguindo terminais conectados, pareamento, caixa aberto/fechado e dados desconhecidos. |
| **22** | Médio | Central Frontend | Sobretela **Incidentes / Sincronização** com diagnóstico, filtros, eventos/vendas pendentes, tratamento e reprocessamento seguro. |
| **23** | Médio | Central Frontend | Sobretela **Backups / Ativação / Suporte** com histórico FULL/incremental, política, agendamento, ativação, comandos e feedback de execução. |

**Homologação 4:** navegação painel → sobretela → detalhe; abrir/fechar sem perder contexto; dados reais; atualização não interrompe a investigação; acessibilidade e responsividade; nenhum controle visual sem ação real.

### Bloco 5 — Homologação integrada (Prompt 24)

| Nº | Nível | Repositório preferencial | Objetivo delimitado |
|---|---|---|---|
| **24** | Alto | Central + Hub, testes específicos | Criar/ajustar **somente** testes de integração faltantes e checklist de homologação ponta a ponta; registrar defeitos encontrados para correções cirúrgicas **separadas**. Não empilhar correções heterogêneas nesse prompt. |

**Homologação final do usuário:** execução assistida pela interface, não por comandos; aprovação explícita após demonstrar alertas, sessões, PDV/caixa, backup, sincronismo e ativação. Erros novos geram prompts pequenos adicionais; **24 é o plano-base, não um limite artificial de correções**.

## 8. Matriz funcional de aceite

| Cenário para demonstrar | Resultado exigido |
|---|---|
| Empresa contratou N sessões; M ocupadas | Painel exibe N/M/N−M corretamente e lista sessões válidas |
| Sessão travada | Suporte autorizado encerra uma sessão, recebe confirmação e vê quota liberada |
| 2 PDVs online, 0 caixas abertos | Exibir 2 conectados e caixas fechados **sem incidente indevido** |
| PDV sem comunicação | Informar último contato, estado desconhecido de caixa se não houver snapshot recente |
| Venda finalizada no Hub, não confirmada pela Central | Ocorrência rastreável com estado correto; reenvio idempotente |
| Falha operacional no PDV/Hub | Evento aparece no painel com loja/terminal/operação e prioridade |
| Hub offline durante falha | Central alerta falta de comunicação; recebe evento quando Hub retorna |
| Backup local criado e ainda não enviado | Mostrar captura local e pendência de transmissão como estados distintos |
| Backup chegou à Central | Mostrar confirmação e integridade conhecida; não anunciar restauração testada |
| Falha/atraso no backup | Alerta e diagnóstico clicável na sobretela |
| Loja sem Hub ativado | Fluxo de geração de código, ativação e acompanhamento disponível |
| Terminal sem parear | Suporte acompanha configuração e código de pareamento sem linha de comando |
| Ativar envio automático de backup | Operação autorizada e acompanhada, persistência confirmada, execução natural comprovada |
| Usuário empresarial tentando outra empresa | Acesso negado e auditado |
| Suporte aplica ação sensível | Confirmação, permissão, trilha e idempotência |
| Navegação em tela ampla | Indicadores clicáveis abrem sobretudo contexto na sobretela; sem páginas fragmentadas nem rolagem horizontal |

## 9. Riscos e salvaguardas

1. **Integridade de vendas:** reenvio jamais pode duplicar venda, pagamento, vale, cashback ou documento fiscal.
2. **Segurança multitenant:** qualquer endpoint agregado deve filtrar empresas desde a consulta; suporte global requer papel próprio validado no backend, não apenas ocultação visual.
3. **Sessões:** não presumir que PDV e navegador já compartilham o mesmo controle de cota; definir autoridade do licenciamento antes de construir indicadores.
4. **Operação offline:** não prometer detecção instantânea de erro local quando não há conexão; exibir desconexão e idade do dado.
5. **Backup e restauração:** confirmação de transferência não substitui simulação/restauração validada; ações de recuperação destrutivas exigem projeto/homologação específicos.
6. **Deploy:** preservar mounts/segredos do receptor no Viper-II, outros serviços do servidor e bases existentes. Sem reset de banco nem substituição destrutiva.
7. **Telemetria:** evitar dados sensíveis, segredos, payloads grandes, tempestades de alertas ou travamento do PDV.
8. **Ergonomia:** sobretela para operação; não empilhar modais sem orientação; ações com feedback claro, inclusive offline/timeout.
9. **Compatibilidade de versões:** Hubs antigos devem indicar recurso não suportado, nunca exibir funcionalidade inexistente como disponível.

## 10. Procedimento de execução e versionamento

Para cada prompt aprovado:

1. Confirmar estágio atual e dependências, consultar este plano e o repositório em main.
2. **Verificar igualdade entre cópia local e remoto** (branch, commit e alterações pendentes), antes de alterar documentação ou executar operações Git com risco de sobrescrever trabalho.
3. Informar caminho correto (Central Backend: C:\SysvarProjeto\Backend; Central Frontend: C:\SysvarProjeto\Frontend\sysvar; Hub Backend DEV: C:\SysvarHub\Backend; Hub Frontend DEV: C:\SysvarHub\Frontend).
4. Executar somente o escopo autorizado; manter comandos silenciosos e saída curta.
5. Executar testes dirigidos (Django check/test, Angular build/test conforme módulo), conferir diff e dados sensíveis.
6. Fazer commit e push do repositório alterado, com árvore limpa.
7. Homologar pelo painel/fluxo real, aprovar e **só então** registrar conclusão no documento de controle de roadmap.
8. Não presumir que ambiente de desenvolvimento Windows, Hub comercial Loja Centro e Central Viper-II são a mesma instalação.
9. Documentação central no cofre; docs técnicos acoplados ao código somente quando estritamente necessários. Não replicar o plano inteiro nos repositórios.

**Nota de atualização local:** a inspeção GitHub confirma os commits remotos, mas não comprova estado dos clones do notebook. Antes de puxar qualquer atualização no Windows, verificar os clones locais; evitar comandos que descartem mudanças.

## 11. Retomada em nova conversa

Quando voltar amanhã ou segunda-feira, solicitar:

> **"Abra no sysvar-vault o documento Planejamento — Centro de Operações e Suporte Sysvar, leia-o integralmente e vamos começar o Prompt 01. Confira os repositórios e respeite o escopo somente de diagnóstico. Não avance para os próximos prompts sem minha aprovação."**

Localização oficial:

**Repositório:** FernandoMurashima/sysvar-vault (main)

**Arquivo:** takeshi/10 Projetos/Sysvar/Contexto do Projeto/Planejamento - Centro de Operacoes e Suporte Sysvar.md

**Documento de controle do andamento:** [[Planejamento, Pendências e Homologação]] (não duplicar sua função).

**Primeira ação futura:** Prompt 01 — inventário técnico e consolidação das lacunas **somente leitura**, com especial atenção à contagem de sessões de licenciamento nos PDVs e à instalação comercial dos backups.

**Status em 17/10/2026:** documento de planejamento criado; **nenhum dos 24 prompts de implementação executado**; nenhuma alteração de código do Sysvar autorizada neste ato.

## 12. Documento de contexto, skill ou agente?

A forma correta de preservar **escopo, decisão funcional, UX, ordem de trabalho e regras comerciais** é um **documento de contexto/planejamento no sysvar-vault**, acessível em qualquer novo chat e nos agentes que consultem o cofre.

Uma **skill** futura só será útil se houver um procedimento repetitivo padronizado (por exemplo, executar checklist de um prompt, testes, revisão e relatório). Ela deve apontar para este documento, não carregar cópia divergente de toda a especificação.

Um **agente** separado não é necessário para guardar este planejamento. O próprio Codex/assistente pode executá-lo em etapas, com autorização humana entre prompts e leitura do estado atual.

**Hierarquia:** plano no cofre = fonte do escopo e UX; código main = estado real da implementação; [[Planejamento, Pendências e Homologação]] = controle de progresso e pendências; testes/homologações = prova de conclusão.
