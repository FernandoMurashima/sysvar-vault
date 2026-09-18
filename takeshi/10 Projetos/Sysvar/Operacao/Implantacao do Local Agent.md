---
type: runbook
status: active
project: Sysvar
source: "FernandoMurashima/sysvarbackend/local_agent"
created: 2026-09-18
updated: 2026-09-18
tags:
  - sysvar
  - local-agent
  - implantacao
  - nfe
  - xml
  - windows
  - fiscal
---

# Implantação do Local Agent

## Finalidade

Este runbook define **onde o Sysvar Local Agent deve ser instalado, como escolher a máquina correta e como homologar a instalação**.

O Local Agent existe para monitorar os XMLs de NF-e no ambiente da empresa e comunicar ao Sysvar os metadados necessários para o fluxo fiscal.

## Regra principal

O agente deve ser instalado na **máquina Windows que recebe ou possui acesso permanente aos XMLs usados na rotina de entrada de NF-e**.

O cenário preferencial é a mesma estação em que a equipe de Compras/Fiscal:

- recebe ou baixa os XMLs dos fornecedores;
- mantém a pasta de XMLs;
- realiza ou acompanha os lançamentos de NF-e de entrada no Sysvar.

Não é obrigatório que a máquina seja exclusiva para o agente.

Ela pode continuar sendo utilizada normalmente para outras atividades.

## Arquitetura operacional

~~~text
Fornecedor / origem do XML
        ↓
Máquina Windows da rotina fiscal
        ↓
pasta de XMLs
        ↓
Sysvar Local Agent
        ↓
Internet / API
        ↓
Sysvar central no Ubuntu
        ↓
tratamento da NF-e no sistema
~~~

## Onde não instalar por padrão

Não instalar o agente no servidor Ubuntu apenas porque o Sysvar está hospedado nele.

O servidor Ubuntu executa os serviços centrais do Sysvar.

O Local Agent deve permanecer próximo da origem real dos XMLs.

Também não instalar automaticamente em todas as estações da empresa.

A quantidade de instalações depende dos pontos físicos/lógicos em que existem pastas de XML independentes.

## Relação com a Empresa

Cada agente é ativado no contexto de uma Empresa do Sysvar.

Uma mesma Empresa pode possuir mais de um agente quando necessário.

Exemplos:

- matriz e filial com redes separadas;
- duas unidades com pastas locais diferentes;
- duas estações fiscais independentes;
- uma máquina dedicada a uma pasta de rede específica.

Não criar um agente por usuário.

O critério é a necessidade de monitorar fontes de XML distintas.

## Como escolher a máquina

A máquina escolhida deve atender a todos os requisitos abaixo:

1. Windows suportado pelo instalador do Local Agent;
2. acesso à pasta onde os XMLs realmente chegam;
3. disponibilidade durante a rotina fiscal;
4. acesso à internet ou rede necessária para alcançar o Sysvar;
5. permissão para instalar e executar serviço Windows;
6. possibilidade de inicialização automática do serviço;
7. acesso estável ao diretório configurado.

Preferencialmente, a estação deve ser a mesma utilizada pelo responsável por entrada de NF-e quando essa estação também é o ponto de recebimento dos XMLs.

## Cenário 1 — XML em pasta local

É o cenário recomendado para a implantação inicial.

Exemplo:

~~~text
C:\Sysvar\XML\Fornecedores
~~~

Fluxo:

~~~text
Usuário recebe XML
        ↓
salva em C:\Sysvar\XML\Fornecedores
        ↓
Local Agent detecta
        ↓
Sysvar recebe os metadados
        ↓
NF-e aparece no fluxo de documentos detectados
~~~

## Cenário 2 — XML em pasta de rede

Se os XMLs forem centralizados em outro computador ou servidor, escolher uma máquina Windows que tenha acesso permanente ao compartilhamento.

Evitar depender de letras de unidade mapeadas do usuário, como:

~~~text
X:\XML
~~~

O serviço Windows pode não enxergar esse mapeamento.

Preferir caminho UNC:

~~~text
\\servidor\compartilhamento\XML
~~~

Quando necessário, executar o serviço com conta apropriada que possua permissão sobre o compartilhamento.

## Procedimento de implantação

### 1. Identificar a rotina fiscal

Confirmar com a empresa:

- quem recebe os XMLs;
- em qual máquina isso ocorre;
- onde os arquivos são armazenados;
- quem realiza os lançamentos de NF-e;
- se o diretório é local ou de rede.

### 2. Definir a máquina do agente

Escolher a estação que tenha acesso direto e permanente à pasta.

Se a própria máquina que lança as notas também recebe os XMLs, ela é o ponto preferencial de instalação.

### 3. Preparar a pasta

Definir a pasta oficial de XMLs.

Exemplo:

~~~text
C:\Sysvar\XML\Fornecedores
~~~

Evitar espalhar XMLs entre várias pastas sem necessidade.

### 4. Validar acesso ao Sysvar

Na máquina escolhida, confirmar acesso ao endereço do Sysvar.

Exemplo:

~~~text
https://sysvar.com.br
~~~

### 5. Instalar o Local Agent

Executar o instalador Windows.

Binários:

~~~text
C:\Program Files\Sysvar\LocalAgent
~~~

Dados persistentes:

~~~text
C:\ProgramData\Sysvar\LocalAgent
~~~

### 6. Gerar código de ativação

No Sysvar, dentro da Empresa correta, acessar o cadastro do Agente Local e gerar um código temporário de ativação.

### 7. Ativar a instalação

A ativação pode ocorrer pelo instalador ou pelo executável:

~~~text
SysvarLocalAgent.exe activate
~~~

O código temporário é trocado por um token definitivo.

O token não deve ser copiado manualmente para documentação, chat ou script.

### 8. Confirmar vínculo da Empresa

Após a ativação, confirmar no Sysvar:

- agente cadastrado;
- Empresa correta;
- identificador esperado;
- hostname da estação;
- último contato/heartbeat.

### 9. Cadastrar a pasta monitorada

No Sysvar, cadastrar a pasta real que será monitorada.

Informar:

- Agente Local correspondente;
- Empresa/Loja conforme o escopo;
- caminho da pasta;
- configuração ativa.

### 10. Iniciar o serviço

Confirmar que o serviço está em execução.

Nome técnico:

~~~text
SysvarLocalAgent
~~~

Resultado esperado:

~~~text
Running
~~~

### 11. Validar o heartbeat

Atualizar a tela do Agente Local no Sysvar.

Confirmar contato recente.

Heartbeat confirma comunicação do agente, mas não substitui o teste de XML.

### 12. Homologar a detecção

Colocar um XML válido de teste na pasta monitorada.

Confirmar:

1. o agente detectou o arquivo;
2. não moveu, renomeou ou apagou o XML;
3. o documento apareceu no Sysvar;
4. os metadados estão vinculados à Empresa/Loja correta;
5. o usuário consegue seguir o fluxo de tratamento da NF-e.

## Teste operacional obrigatório

Uma implantação só deve ser considerada concluída após o teste ponta a ponta:

~~~text
XML chega na pasta
        ↓
Local Agent detecta
        ↓
API recebe
        ↓
NF-e detectada aparece no Sysvar
        ↓
usuário abre o documento
        ↓
segue o lançamento fiscal
~~~

## Rotina diária esperada

Depois da implantação, o usuário não precisa abrir manualmente o agente.

O serviço deve iniciar automaticamente com o Windows.

A rotina passa a ser:

1. receber ou salvar XML na pasta oficial;
2. Local Agent detectar automaticamente;
3. acessar o Sysvar;
4. abrir a área de NF-e detectadas;
5. realizar o tratamento fiscal/entrada correspondente.

## Máquina compartilhada com outras atividades

A estação pode ser utilizada para:

- Compras;
- Fiscal;
- Financeiro;
- entrada de NF-e;
- navegação e outras rotinas administrativas.

O agente é um serviço de fundo e não exige estação exclusiva.

O cuidado é não desligar a máquina durante períodos em que se espera receber XMLs sem aceitar atraso na detecção.

## Quando a máquina pode ficar desligada

Se a estação ficar desligada, o agente não monitora a pasta naquele período.

Quando a estação for ligada novamente e o serviço iniciar, os arquivos presentes na pasta poderão ser detectados no próximo ciclo de varredura, desde que continuem disponíveis.

Para operação que exige detecção contínua, escolher uma máquina que permaneça ligada durante o horário operacional.

## Mudança de máquina

Se a empresa trocar a estação fiscal:

1. instalar o agente na nova máquina;
2. ativar a nova instalação na Empresa correta;
3. configurar a pasta acessível pela nova máquina;
4. homologar com XML de teste;
5. somente depois desativar/remover a instalação anterior quando não for mais necessária.

Não reutilizar token de outra instalação.

## Mudança da pasta de XML

Se a origem dos XMLs mudar:

1. atualizar a configuração no Sysvar;
2. confirmar que o serviço consegue acessar o novo caminho;
3. colocar XML de teste;
4. confirmar detecção;
5. só depois considerar a migração concluída.

## Reinstalação e upgrade

O instalador preserva, quando aplicável:

- `config.json`;
- fila SQLite;
- logs;
- identificador/token válido.

Após upgrade, confirmar:

- serviço `Running`;
- heartbeat;
- acesso à pasta;
- detecção de XML.

## Diagnóstico básico

Se XML não aparecer no Sysvar, verificar nesta ordem:

1. serviço está `Running`;
2. máquina possui internet/rede;
3. heartbeat aparece no Sysvar;
4. pasta cadastrada está correta;
5. arquivo XML realmente está na pasta;
6. serviço possui permissão para ler o caminho;
7. log do agente não apresenta erro;
8. configuração está vinculada à Empresa/Loja correta.

## Regras críticas

- instalar onde os XMLs existem ou são acessíveis;
- preferir a estação da rotina de entrada de NF-e;
- não exigir máquina exclusiva;
- não instalar no Ubuntu por padrão;
- não instalar em todas as estações indiscriminadamente;
- não reutilizar token entre instalações;
- não usar pasta inacessível ao serviço;
- não considerar heartbeat como prova de leitura da pasta;
- sempre homologar com XML real de teste;
- sempre confirmar Empresa e Loja corretas.

## Relacionados

- [[Mapa Técnico - Integrações - Local Agent]]
- [[Mapa Técnico - Fiscal - XML de Fornecedor e NF-e de Entrada]]
- [[Mapa Técnico - Compras - Recebimento de Mercadoria]]
- [[Base de Desenvolvimento]]
- [[Sysvar]]
