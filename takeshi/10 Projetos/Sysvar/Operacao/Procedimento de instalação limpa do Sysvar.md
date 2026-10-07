---
type: runbook
status: active
project: Sysvar
category: operacao
source: "Homologação manual em 2026-10-06 e reexecução validada em 2026-10-07; FernandoMurashima/sysvarbackend; FernandoMurashima/sysvarhub-backend"
created: 2026-10-06
updated: 2026-10-07
tags:
  - sysvar
  - operacao
  - instalacao
  - homologacao
  - local-agent
  - sysvar-hub
  - pdv
  - windows
---

# Procedimento de instalação limpa do Sysvar

## Finalidade

Este runbook registra o procedimento homologado para deixar a máquina em estado equivalente a uma instalação inicial do Sysvar, remover instalações e dados locais anteriores, reconstruir a Base DEV oficial, reinstalar e ativar o Sysvar Local Agent, preparar o Sysvar Hub DEV, configurar e parear o terminal e disponibilizar um usuário para uso no PDV.

O procedimento é destrutivo no ambiente local de desenvolvimento/homologação descrito abaixo.

Não gerar backup durante esta rotina.

A correção dos seeds oficiais, incluindo dados estruturais como o código IBGE das lojas, deve estar previamente incorporada ao código. Alterações pontuais de seed não fazem parte deste procedimento repetível.

---

# Parte 1 — Limpeza do ambiente DEV e recriação do banco local do Hub

## Separação obrigatória dos ambientes

Este procedimento trata do ambiente de desenvolvimento e homologação.

O Sysvar Hub DEV fica em:

```text
C:\SysvarHub
```

e usa:

```text
Backend DEV:
http://127.0.0.1:8100

Frontend DEV:
http://localhost:4300

Runtime DEV:
C:\SysvarHub\Backend\.runtime-dev

Banco local DEV:
sysvarhub_db em 127.0.0.1:3306
```

A instalação distribuída do Sysvar Hub é outro ambiente:

```text
C:\Program Files\Sysvar Hub
C:\ProgramData\SysvarHub
Serviços Windows:
SysvarHub
SysvarHubMySQL
```

**Não desinstalar o Sysvar Hub instalado e não apagar `C:\SysvarHub` como parte desta rotina DEV.**
O Hub DEV deve apenas ser parado, ter seu runtime DEV limpo e seu banco DEV recriado.

## 1. Parar o serviço do Sysvar Local Agent

Abrir PowerShell como Administrador.

```powershell
Stop-Service SysvarLocalAgent -Force -ErrorAction SilentlyContinue
```

## 2. Desinstalar o Sysvar Local Agent pelo desinstalador oficial

```powershell
$uninstaller = "C:\Program Files\Sysvar\LocalAgent\unins000.exe"

if (Test-Path $uninstaller) {
    Start-Process $uninstaller -Wait
}
```

## 3. Apagar os resíduos do Sysvar Local Agent

```powershell
Remove-Item "C:\ProgramData\Sysvar\LocalAgent" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item "C:\Program Files\Sysvar\LocalAgent" -Recurse -Force -ErrorAction SilentlyContinue
```

## 4. Validar a remoção completa do Sysvar Local Agent

```powershell
Get-Service SysvarLocalAgent -ErrorAction SilentlyContinue

Test-Path "C:\Program Files\Sysvar\LocalAgent"
Test-Path "C:\ProgramData\Sysvar\LocalAgent"
```

Resultado esperado:

```text
False
False
```

O serviço `SysvarLocalAgent` não deve mais existir.

## 5. Parar completamente o ambiente Hub DEV

Encerrar com `Ctrl+C`:

```text
Backend Hub DEV
127.0.0.1:8100

Frontend Hub DEV
http://localhost:4300

SyncWorker
manage.py run_sync_worker
```

Não remover a pasta `C:\SysvarHub`.

## 6. Entrar no diretório do Backend do Hub DEV

```powershell
cd C:\SysvarHub\Backend
```

## 7. Limpar e definir o runtime DEV do Hub

```powershell
Remove-Item ".runtime-dev" -Recurse -Force -ErrorAction SilentlyContinue

$env:SYSVARHUB_PROGRAMDATA = (Join-Path (Get-Location) ".runtime-dev")

Test-Path ".runtime-dev"
```

Antes de o Hub ser iniciado novamente, o resultado esperado do `Test-Path` é:

```text
False
```

## 8. Apagar o banco local `sysvarhub_db` e recriá-lo vazio

```powershell
.\.venv\Scripts\python.exe manage.py shell -c "import MySQLdb; from django.conf import settings; db=settings.DATABASES['default']; c=MySQLdb.connect(host=db['HOST'], user=db['USER'], passwd=db['PASSWORD'], port=int(db['PORT'])); cur=c.cursor(); cur.execute('DROP DATABASE IF EXISTS sysvarhub_db'); cur.execute('CREATE DATABASE sysvarhub_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci'); c.close(); print('sysvarhub_db recriado do zero')"
```

Resultado esperado:

```text
sysvarhub_db recriado do zero
```

---

# Parte 2 — Reconstrução da Base DEV, instalação, ativação e pareamento

## 9. Recriar fisicamente o banco `varejo_db` da Central

No MySQL Workbench conectado ao MySQL usado pela Central DEV, executar:

```sql
DROP DATABASE IF EXISTS varejo_db;

CREATE DATABASE varejo_db
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;
```

Esta etapa deve ocorrer **antes** das migrations e do `sysvar_dev_base --rebuild`.

Não executar o `--rebuild` diretamente sobre uma Base DEV antiga e populada. A limpeza interna é feita tabela a tabela e pode ser bloqueada por relacionamentos com `on_delete=PROTECT`, como a dependência entre recebíveis e pagamentos de venda.

## 10. Aplicar as migrations da Central no banco vazio

```powershell
cd C:\SysvarProjeto\Backend

.\venv\Scripts\python.exe manage.py migrate
```

## 11. Reconstruir a Base DEV oficial da Central

Depois das migrations:

```powershell
cd C:\SysvarProjeto\Backend

.\venv\Scripts\python.exe manage.py sysvar_dev_base --rebuild
```

Usar `--rebuild`, e não `--create`.

As migrations históricas podem criar dados legados, incluindo a empresa `CISVAR Base Atual`. O `--rebuild` remove esses dados e então carrega os seeds oficiais. Com `--create`, esses registros permanecem e a validação da Base DEV pode terminar como inválida por divergência dos JSONs.

Confirmar ao final:

```text
BASE DE DESENVOLVIMENTO: VÁLIDA
```

Validar também que os cadastros estruturais necessários, incluindo os dados fiscais das lojas, foram recriados corretamente pelos seeds oficiais.

## 12. Aplicar as migrations no banco novo do Sysvar Hub DEV

```powershell
cd C:\SysvarHub\Backend

$env:SYSVARHUB_PROGRAMDATA = (Join-Path (Get-Location) ".runtime-dev")

.\.venv\Scripts\python.exe manage.py migrate
```

## 13. Iniciar os ambientes de desenvolvimento

Usar os batches já configurados.

Iniciar o backend da Central.

Iniciar o Hub.

Endereços esperados:

```text
Central Frontend:
http://localhost:4200

Central API:
http://localhost:8001

Hub DEV Frontend:
http://localhost:4300
```

O batch do Hub deve iniciar os componentes necessários do ambiente DEV, incluindo backend, frontend e SyncWorker.

## 14. Gerar um código de ativação para o Sysvar Local Agent

Na Central:

```text
Cadastros
→ Agente Local Sysvar
→ Gerar novo código
```

O código é temporário e de uso único.

Usar sempre o código recém-gerado durante a instalação.

## 15. Criar a configuração DEV do Sysvar Local Agent

Abrir PowerShell como Administrador.

```powershell
New-Item -ItemType Directory -Force "C:\ProgramData\Sysvar\LocalAgent" | Out-Null

@'
{
  "api_base_url": "http://localhost:8001",
  "token": "",
  "identificador": "",
  "poll_interval_seconds": 15,
  "heartbeat_interval_seconds": 60,
  "request_timeout_seconds": 15,
  "min_file_age_seconds": 3,
  "database_path": "data/agent.db",
  "log_file": "logs/sysvar-agent.log"
}
'@ | Set-Content "C:\ProgramData\Sysvar\LocalAgent\config.json" -Encoding UTF8
```

## 16. Instalar e ativar o Sysvar Local Agent

Instalador esperado no ambiente de desenvolvimento:

```text
C:\SysvarProjeto\Backend\local_agent\installer\output\SysvarLocalAgent-Setup-0.2.0.exe
```

Executar o instalador.

Quando solicitado, informar o código temporário gerado no item anterior.

A configuração DEV deve apontar para:

```text
http://localhost:8001
```

**Não executar o instalador antes de criar o `config.json` do item anterior.** O arquivo de exemplo distribuído com o instalador usa `127.0.0.1:8000`; no ambiente DEV a Central está em `localhost:8001`. Se o instalador for executado sem a configuração DEV prévia, a ativação falhará por tentar acessar a porta incorreta.

## 17. Adicionar a pasta monitorada pelo Local Agent

Na Central:

```text
Cadastros
→ Agente Local Sysvar
→ Adicionar pasta
```

Cadastrar:

```text
Pasta:
C:\SysvarXML

Status:
Ativo
```

## 18. Validar o funcionamento do Sysvar Local Agent

```powershell
Get-Service SysvarLocalAgent

Get-Content "C:\ProgramData\Sysvar\LocalAgent\logs\sysvar-agent.log" -Tail 20
```

Confirmar:

```text
Status: Running
Configurações carregadas: 1
Heartbeat enviado.
```

## 19. Gerar o código de ativação do Sysvar Hub para a Loja Barra

Na Central:

```text
Administração do Sysvar Hub
→ Loja Barra
→ Gerar código de ativação
```

Usar o código temporário recém-gerado.

## 20. Ativar o Sysvar Hub DEV da Loja Barra

Abrir:

```text
http://localhost:4300/ativacao
```

Preencher:

```text
URL da Central:
http://localhost:8001

Código de ativação:
usar o código gerado no item 19
```

Clicar em:

```text
Ativar Sysvar Hub
```

## 21. Confirmar a primeira sincronização automática

Na Central, abrir a Administração do Sysvar Hub e atualizar a página.

Na linha `Loja Barra`, confirmar:

```text
Situação:
Sincronizado

Hub:
Sysvar Hub

Ativação:
Ativado
```

## 22. Configurar o terminal do Hub

Na linha `Loja Barra`, clicar em `Configurar`.

Preencher:

```text
Código do terminal:
PDV-01

Nome do terminal:
PDV 01

Caixa:
CX-BARRA - Caixa Loja Barra

Hostname opcional:
deixar em branco
```

Clicar em `Enviar`.

Após a conclusão, atualizar a tela caso o estado visual ainda apareça como `Não configurado`.

Confirmar:

```text
Configuração:
Configurado
```

## 23. Gerar o código de pareamento do terminal

Na Central:

```text
Administração do Sysvar Hub
→ Loja Barra
→ Gerar código de pareamento
```

O código é temporário.

Usar o código recém-gerado.

## 24. Parear o terminal no Hub DEV

Abrir:

```text
http://localhost:4300/pareamento
```

Informar o código gerado no item anterior e concluir o pareamento do terminal `PDV-01`.

## 25. Confirmar o pareamento na Central

Na Central, atualizar a Administração do Sysvar Hub.

Na linha `Loja Barra`, confirmar:

```text
Configuração:
Configurado

Pareamento:
Pareado
```

## 26. Cadastrar o usuário que utilizará o PDV na Central

Na Central:

```text
Cadastros
→ Usuários
```

ou acessar:

```text
http://localhost:4200/config/usuarios
```

Clicar em:

```text
+ Novo Usuário
```

Preencher os dados do operador.

Campos principais:

```text
Usuário:
login do operador

Nome e sobrenome:
dados do operador

Tipo:
Caixa

Empresa:
empresa da Loja Barra

Loja principal:
Loja Barra

Lojas permitidas:
Loja Barra

Perfil principal:
Caixa

Senha:
senha de acesso à Central

Confirmar senha:
repetir a senha
```

Salvar o usuário.

## 27. Criar a Credencial PDV do usuário

Na lista de usuários:

1. selecionar o usuário;
2. clicar em `Credencial PDV`;
3. informar a senha que será usada no PDV;
4. confirmar a senha;
5. salvar.

A senha PDV deve possuir entre 8 e 64 caracteres.

Confirmar que a coluna `PDV` do usuário passa a indicar:

```text
Configurada
```

## 28. Sincronizar novamente a Loja Barra para enviar o operador ao Hub

Na Central:

```text
Administração do Sysvar Hub
→ Loja Barra
→ Sincronizar
```

Aguardar a conclusão.

Confirmar:

```text
Situação:
Sincronizado
```

Após a sincronização, o usuário ativo vinculado à Loja Barra e com Credencial PDV habilitada deve estar disponível no Hub para login no PDV.

---

## Resultado final esperado

Ao concluir todo o procedimento:

- instalação anterior do Sysvar Local Agent removida e reinstalada;
- Sysvar Hub DEV preservado em `C:\SysvarHub`;
- instalação distribuída do Sysvar Hub mantida fora do escopo desta rotina DEV;
- runtime `.runtime-dev` do Hub DEV limpo;
- `sysvarhub_db` recriado do zero;
- `varejo_db` recriado fisicamente;
- migrations da Central aplicadas sobre banco vazio;
- Base DEV oficial reconstruída com `sysvar_dev_base --rebuild`;
- migrations do Hub aplicadas sobre banco limpo;
- Central DEV em execução;
- Hub DEV em execução;
- Local Agent instalado, ativado e com heartbeat;
- pasta `C:\SysvarXML` ativa;
- Hub da Loja Barra ativado;
- primeira sincronização concluída;
- terminal `PDV-01` configurado;
- terminal pareado;
- usuário do PDV cadastrado na Central;
- Credencial PDV configurada;
- operador sincronizado com o Hub;
- ambiente pronto para iniciar os testes operacionais do PDV.

## Relacionados

- [[Base de Desenvolvimento]]
- [[Implantação do Local Agent]]
- [[Sysvar Hub]]
- [[Estado Atual - Sysvar Hub]]
- [[Sysvar]]
