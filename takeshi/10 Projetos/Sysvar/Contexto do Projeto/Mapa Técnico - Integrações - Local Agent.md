---
type: reference
status: active
project: Sysvar
source: "FernandoMurashima/sysvarbackend/local_agent"
created: 2026-09-18
updated: 2026-09-18
tags:
  - sysvar
  - local-agent
  - nfe
  - xml
  - windows
  - integracao
---

# Mapa Técnico - Integrações - Local Agent

## Objetivo

Documentar o **Sysvar Local Agent**, responsável por detectar XML de NF-e em pastas locais do cliente e comunicar a detecção ao [[Sysvar]].

## Princípio de segurança

O XML original é lido localmente.

O agente envia ao backend somente os metadados necessários ao fluxo.

Regra:

~~~text
XML original
→ permanece no ambiente local

Metadados extraídos
→ enviados à API Sysvar
~~~

O agente não deve mover, apagar, renomear ou editar os XMLs encontrados.

## Autenticação

O agente autentica usando:

~~~text
Authorization: Agent <TOKEN>
~~~

O token definitivo é obtido por ativação e deve permanecer fora de logs, argumentos de linha de comando e documentação com valor real.

## Ativação

A ativação utiliza código temporário gerado pelo Sysvar.

O executável possui comando:

~~~text
SysvarLocalAgent.exe activate
~~~

O código pode ser fornecido interativamente ou pela variável temporária:

~~~text
SYSVAR_AGENT_ACTIVATION_CODE
~~~

O código temporário não é persistido.

O `identificador` do agente é criado uma vez e preservado nas reativações.

## Configuração

Arquivo persistente:

~~~text
C:\ProgramData\Sysvar\LocalAgent\config.json
~~~

O agente obtém do backend as pastas que deve monitorar.

Endpoint de configuração:

~~~text
GET /api/fiscal/agente-local/configuracoes/
~~~

## Detecção de XML

O scanner:

- consulta apenas as pastas configuradas;
- procura `*.xml` no diretório informado;
- não percorre subdiretórios por padrão;
- lê XML com biblioteca padrão;
- extrai metadados fiscais;
- envia detecção ao backend.

Endpoint:

~~~text
POST /api/fiscal/agente-local/xml-detectado/
~~~

Respostas com `created=true` ou `created=false` são consideradas processadas com sucesso pela fila local.

## Fila local

O agente usa SQLite local para preservar a fila:

~~~text
data\agent.db
~~~

A fila diferencia XMLs:

- pendentes;
- enviados;
- com erro.

Falhas transitórias de internet/backend preservam a fila e usam retry/backoff simples.

Erros HTTP 400 são registrados como erro e não entram em retry infinito.

## Heartbeat

O agente envia heartbeat periódico para informar que a instalação continua ativa.

Heartbeat não deve ser confundido com processamento de XML.

## Serviço Windows

Nome técnico:

~~~text
SysvarLocalAgent
~~~

Nome exibido:

~~~text
Sysvar Local Agent
~~~

A instalação configura inicialização automática.

O serviço reutiliza o mesmo núcleo do agente de desenvolvimento:

- configuração;
- cliente HTTP;
- fila SQLite;
- scanner;
- runner.

## Distribuição standalone

A distribuição Windows é empacotada com PyInstaller em modo `onedir`.

Executável:

~~~text
local_agent\dist\SysvarLocalAgent\SysvarLocalAgent.exe
~~~

O executável standalone não depende de Python instalado na máquina cliente.

## Instalador Windows

O instalador é criado com Inno Setup.

Binários:

~~~text
C:\Program Files\Sysvar\LocalAgent
~~~

Dados persistentes:

~~~text
C:\ProgramData\Sysvar\LocalAgent
~~~

Em reinstalação/upgrade/desinstalação padrão são preservados:

- `config.json`;
- `data\agent.db`;
- logs.

Em instalação nova, o wizard pode solicitar o código de ativação e executar a ativação antes de iniciar o serviço.

## Parada do Windows

Ao receber stop do Windows, o serviço deve:

- sinalizar encerramento;
- concluir o loop em andamento de forma controlada;
- fechar SQLite;
- preservar fila, logs e configuração.

## Diretórios de rede

Serviço executado como LocalSystem normalmente não enxerga letras de unidade mapeadas do usuário.

Para compartilhamentos de rede, a solução futura deve usar:

- caminho UNC;
- conta de serviço com permissão apropriada.

## Regras críticas

- não enviar XML original ao backend;
- não versionar config com token;
- não passar token em argumento de linha de comando;
- não apagar fila em falha de comunicação;
- não fazer retry infinito de erro funcional 400;
- não depender do diretório corrente do processo;
- preservar configuração e fila em upgrade.

## Fonte operacional

O próprio repositório de código possui README técnico em:

~~~text
local_agent/README.md
~~~

## Relacionados

- [[Sysvar]]
- [[Mapa Técnico - Fiscal - XML de Fornecedor e NF-e de Entrada]]
- [[Mapa Técnico - Compras - Recebimento de Mercadoria]]
- [[Base de Desenvolvimento]]
