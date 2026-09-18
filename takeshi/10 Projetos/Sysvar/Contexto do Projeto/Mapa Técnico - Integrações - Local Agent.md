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

## Regra de implantação operacional

O Sysvar Local Agent **não deve ser instalado no servidor Ubuntu apenas porque o Sysvar está hospedado nele**.

O padrão de implantação é instalar o agente em uma **máquina Windows do ambiente da empresa que participe da rotina de entrada de documentos fiscais e tenha acesso direto à pasta onde os XMLs de NF-e são recebidos**.

Na operação normal, essa máquina será preferencialmente a estação em que o usuário:

- recebe ou baixa os XMLs dos fornecedores;
- mantém a pasta utilizada para armazenar esses XMLs;
- realiza ou acompanha os lançamentos de NF-e de entrada no Sysvar;
- permanece ligada durante a rotina de recebimento fiscal;
- possui acesso à internet para comunicação com a API do Sysvar.

O agente não precisa de uma máquina exclusiva. A mesma estação pode continuar sendo utilizada normalmente para Compras, Fiscal, Financeiro, entrada de notas ou outras atividades do usuário.

Regra resumida:

~~~text
MÁQUINA WINDOWS DA ROTINA FISCAL
    ↓
recebe ou acessa os XMLs
    ↓
Sysvar Local Agent monitora a pasta
    ↓
metadados são enviados ao Sysvar
    ↓
usuário trata a NF-e no Sysvar
~~~

## Onde o agente deve ficar

### Cenário recomendado

Instalar o agente na estação Windows responsável pela entrada de NF-e da empresa.

Essa estação deve ter acesso ao mesmo local em que os XMLs chegam.

Exemplo:

~~~text
Estação Fiscal / Compras
C:\Sysvar\XML\Fornecedores
        ↓
Sysvar Local Agent
        ↓
https://sysvar.com.br
~~~

### Máquina não exclusiva

Não é necessário reservar um computador somente para o agente.

O serviço roda em segundo plano e pode coexistir com o uso normal da estação.

O requisito é operacional, e não de exclusividade:

- a máquina precisa estar disponível durante a rotina;
- o serviço precisa estar em execução;
- a pasta configurada precisa estar acessível;
- a máquina precisa conseguir alcançar o Sysvar pela rede/internet.

### Servidor Ubuntu do Sysvar

O Ubuntu hospeda o backend, frontend e banco do Sysvar, mas **não é o local padrão de instalação do Local Agent**.

O agente existe para aproximar o Sysvar das pastas locais do cliente. Portanto, instalar o agente no Ubuntu só faria sentido se os XMLs estivessem efetivamente disponíveis nesse ambiente e existisse uma distribuição suportada para ele, o que não corresponde ao desenho atual.

No desenho vigente:

~~~text
Windows do cliente
    ↓
Local Agent
    ↓
API Sysvar
    ↓
Ubuntu / servidor Sysvar
~~~

## Relação com Empresa e Loja

O agente é cadastrado vinculado a uma **Empresa**.

Uma empresa pode possuir mais de um agente quando houver necessidade operacional, por exemplo:

- mais de uma unidade física;
- mais de uma estação fiscal;
- pastas fisicamente separadas;
- redes locais distintas.

As pastas monitoradas podem ser configuradas com escopo de Empresa ou Loja conforme a estrutura cadastrada no Sysvar.

Isso significa que não se instala um agente por usuário nem obrigatoriamente um agente por computador da empresa.

A instalação deve refletir os pontos reais em que os XMLs estão disponíveis.

## Critério para escolher a máquina

Antes de instalar, confirmar:

1. qual máquina Windows recebe ou acessa os XMLs;
2. qual pasta contém os XMLs de fornecedores;
3. se a estação permanece ligada durante a rotina de entrada;
4. se o usuário responsável pelos lançamentos de NF-e trabalha nessa estação ou possui acesso operacional ao mesmo fluxo;
5. se a máquina consegue acessar `https://sysvar.com.br`;
6. se o serviço Windows pode permanecer iniciado automaticamente;
7. se a pasta é local ou de rede.

Se a máquina escolhida não tiver acesso à pasta real dos XMLs, o agente não cumprirá sua função mesmo que esteja corretamente instalado e autenticado.

## Pasta local versus pasta de rede

### Pasta local

É o cenário mais simples e recomendado para a implantação inicial.

Exemplo:

~~~text
C:\Sysvar\XML\Fornecedores
~~~

O agente pode monitorar diretamente essa pasta enquanto o serviço Windows estiver em execução.

### Pasta de rede

Se os XMLs forem centralizados em outro computador ou servidor da empresa, o agente deve ser instalado em uma máquina que possua acesso permanente a esse compartilhamento.

Serviço executado como LocalSystem normalmente não enxerga letras de unidade mapeadas do usuário, como:

~~~text
X:\XML
~~~

Para compartilhamentos de rede, a implantação deve preferir:

- caminho UNC, por exemplo `\\servidor\compartilhamento\XML`;
- conta de serviço com permissão apropriada;
- validação explícita de acesso pelo contexto do serviço.

Não assumir que uma pasta de rede visível no Explorador do Windows também será automaticamente visível para o serviço.

## Procedimento de implantação na empresa

### 1. Definir a estação

Escolher a máquina Windows utilizada na rotina fiscal/entrada de NF-e ou uma máquina fixa que tenha acesso permanente à pasta de XMLs.

### 2. Definir a origem dos XMLs

Identificar o diretório em que os documentos realmente chegam.

Exemplo:

~~~text
C:\Sysvar\XML\Fornecedores
~~~

### 3. Confirmar conectividade

A estação deve conseguir acessar o endereço do Sysvar utilizado pela empresa.

Exemplo de produção/homologação remota:

~~~text
https://sysvar.com.br
~~~

### 4. Instalar o Local Agent

Executar o instalador Windows do Sysvar Local Agent na estação escolhida.

Binários:

~~~text
C:\Program Files\Sysvar\LocalAgent
~~~

Dados persistentes:

~~~text
C:\ProgramData\Sysvar\LocalAgent
~~~

### 5. Gerar a ativação no Sysvar

No Sysvar, dentro da empresa correta, gerar um código temporário de ativação para o agente.

### 6. Ativar o agente

O instalador pode executar a ativação durante a instalação ou o procedimento pode ser executado pelo comando:

~~~text
SysvarLocalAgent.exe activate
~~~

O agente recebe um token definitivo e fica associado à Empresa.

### 7. Configurar a pasta monitorada

No Sysvar, cadastrar a pasta que o agente deve monitorar e definir o escopo correto de Empresa/Loja.

A pasta cadastrada deve ser exatamente uma pasta que a máquina do agente consiga acessar.

### 8. Iniciar o serviço

Confirmar o serviço:

~~~text
SysvarLocalAgent
~~~

Estado esperado:

~~~text
Running
~~~

### 9. Validar heartbeat

Atualizar a tela de Agente Local no Sysvar e confirmar que o agente apresenta contato recente.

### 10. Homologar com XML real de teste

Colocar ou receber um XML válido na pasta monitorada e confirmar:

- arquivo detectado;
- metadados enviados;
- documento aparecendo no painel de NF-e detectadas;
- vínculo correto com Empresa/Loja;
- possibilidade de seguir o fluxo de lançamento fiscal.

## Quando instalar mais de um agente

Mais de um agente pode ser necessário quando a mesma Empresa possuir ambientes físicos independentes.

Exemplos:

~~~text
Matriz
  estação fiscal A
  pasta XML A
  agente A

Loja / unidade separada
  estação fiscal B
  pasta XML B
  agente B
~~~

Não criar vários agentes apenas porque existem vários usuários do Sysvar.

O critério é a existência de fontes/pastas de XML que precisem ser monitoradas de forma independente.

## O que não fazer

- não instalar o agente em todas as estações sem necessidade;
- não instalar no Ubuntu somente porque o backend está hospedado nele;
- não escolher uma máquina que normalmente fica desligada durante a rotina fiscal;
- não configurar uma pasta que o serviço não consiga acessar;
- não usar unidade de rede mapeada sem validar o contexto do serviço;
- não compartilhar token entre instalações diferentes;
- não cadastrar o agente na Empresa errada;
- não confundir instalação do agente com lançamento da NF-e: o agente detecta o XML, enquanto o tratamento fiscal continua sendo executado pelo Sysvar.

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

- instalar o agente na máquina que recebe ou acessa os XMLs usados na rotina fiscal;
- preferir a estação responsável pela entrada de NF-e quando ela também contém ou acessa a pasta de XMLs;
- não exigir máquina exclusiva;
- não instalar no servidor Ubuntu como padrão;
- não instalar em todas as estações sem necessidade;
- garantir que o serviço tenha acesso real à pasta configurada;
- vincular cada instalação à Empresa correta;
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
