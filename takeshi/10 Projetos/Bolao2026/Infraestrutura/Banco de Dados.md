---
type: documentation
status: active
project: Bolao2026
category: infraestrutura
created: 2026-08-10
updated: 2026-08-10
tags:
  - bolao2026
  - infraestrutura
  - mysql
  - banco-de-dados
  - migracao
  - backup
---

# Banco de Dados

## Objetivo

Esta nota documenta o banco de dados utilizado pelo **Bolao2026** no ambiente de produção atual, incluindo:

- estrutura geral;
- container MySQL;
- banco utilizado;
- comunicação com o backend Django;
- processo de migração da KingHost;
- comandos de verificação;
- cuidados operacionais;
- backup;
- diagnóstico.

---

# Banco utilizado

Banco de produção:

```text
bolao2026
```

Servidor de banco:

```text
mysql
```

Porta:

```text
3306
```

Container Docker:

```text
mysql
```

Imagem:

```text
mysql:8.0
```

Rede Docker:

```text
infra
```

---

# Localização lógica

O MySQL não executa diretamente no Ubuntu.

Ele executa dentro de um container Docker.

O backend do Bolao2026 acessa o banco através da rede Docker:

```text
bolao-backend
        ↓
      infra
        ↓
      mysql
        ↓
    bolao2026
```

O hostname utilizado pelo Django é:

```text
mysql
```

e não:

```text
localhost
```

---

# Por que não utilizar localhost

Dentro do container:

```text
bolao-backend
```

o endereço:

```text
localhost
```

representa o próprio container backend.

Portanto, para acessar o container MySQL, o Django deve utilizar:

```text
HOST = mysql
```

O Docker resolve automaticamente o nome:

```text
mysql
```

para o IP interno atual do container.

---

# Configuração conceitual no Django

A configuração do banco possui esta estrutura:

```python
DATABASES = {
    "default": {
        "ENGINE": "django.db.backends.mysql",
        "NAME": "bolao2026",
        "USER": "bolao_user",
        "PASSWORD": "NAO_REGISTRAR_AQUI",
        "HOST": "mysql",
        "PORT": "3306",
        "OPTIONS": {
            "charset": "utf8mb4",
            "init_command": "SET sql_mode='STRICT_TRANS_TABLES'",
        },
    }
}
```

A senha real não deve ser registrada nesta documentação.

---

# Usuário da aplicação

Usuário lógico utilizado pelo Django:

```text
bolao_user
```

Esse usuário deve possuir acesso ao banco:

```text
bolao2026
```

O acesso deve ser limitado ao necessário para a aplicação.

---

# Charset

O banco foi criado utilizando:

```text
utf8mb4
```

Collation utilizado durante a criação no Viper-II:

```text
utf8mb4_unicode_ci
```

Esse charset permite armazenamento adequado de caracteres Unicode.

---

# Criação do banco no Viper-II

Durante a migração foi criado:

```text
bolao2026
```

no MySQL já existente no servidor.

Conceitualmente:

```sql
CREATE DATABASE IF NOT EXISTS bolao2026
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;
```

---

# Criação do usuário

Foi criado o usuário:

```text
bolao_user
```

com acesso ao banco:

```text
bolao2026
```

Estrutura conceitual:

```sql
CREATE USER IF NOT EXISTS 'bolao_user'@'%'
IDENTIFIED BY 'SENHA_NAO_DOCUMENTADA';

GRANT ALL PRIVILEGES
ON bolao2026.*
TO 'bolao_user'@'%';

FLUSH PRIVILEGES;
```

A senha utilizada não deve ser registrada no Obsidian.

---

# Banco anterior na KingHost

Antes da migração, o banco também se chamava:

```text
bolao2026
```

Ele executava no MySQL da VPS KingHost.

Servidor antigo:

```text
177.153.38.27
```

Hostname:

```text
murashimavps
```

Backend antigo:

```text
/home/deploy/copa/backend
```

A configuração antiga utilizava:

```text
HOST = localhost
```

porque Django e MySQL executavam no mesmo servidor.

---

# Migração do banco

A migração foi realizada através de dump lógico MySQL.

Não foram copiados diretamente arquivos internos do MySQL.

Essa decisão reduz riscos relacionados a:

```text
InnoDB
versões do MySQL
estado dos arquivos
permissões
corrupção
```

---

# Dump utilizado

Foi criado na KingHost:

```text
/home/deploy/bolao2026_migracao_20260810.sql
```

O arquivo tinha aproximadamente:

```text
264 KB
```

no momento da migração.

---

# Comando utilizado no dump

Foi utilizado `mysqldump` com as opções:

```text
--single-transaction
--routines
--triggers
--events
--no-tablespaces
```

Estrutura conceitual:

```bash
mysqldump \
  --single-transaction \
  --routines \
  --triggers \
  --events \
  --no-tablespaces \
  bolao2026 > bolao2026_migracao_20260810.sql
```

---

# Motivo do --no-tablespaces

A primeira tentativa de dump apresentou problema relacionado a privilégio:

```text
PROCESS
```

O parâmetro:

```text
--no-tablespaces
```

evitou a necessidade desse privilégio para o dump.

---

# Transferência para o Viper-II

O arquivo foi transferido para:

```text
/tmp/bolao2026_migracao_20260810.sql
```

no Viper-II.

A transferência foi realizada a partir do notebook servidor puxando o arquivo da KingHost.

---

# Restauração no Viper-II

Depois de criar o banco, o dump foi restaurado no container MySQL.

Estrutura utilizada:

```bash
docker exec -i mysql mysql \
  -uroot \
  -p'SENHA_ROOT' \
  bolao2026 \
  < /tmp/bolao2026_migracao_20260810.sql
```

A senha real não deve ser registrada.

---

# Validação da restauração

Foi utilizado:

```bash
docker exec mysql mysql \
  -uroot \
  -p'SENHA_ROOT' \
  -e "USE bolao2026; SHOW TABLES;"
```

A restauração foi confirmada pelas tabelas existentes.

---

# Tabelas confirmadas após restauração

```text
accounts_robinho
accounts_user
accounts_user_groups
accounts_user_user_permissions
auth_group
auth_group_permissions
auth_permission
authtoken_token
copa_bet
copa_extrabet
copa_extraresult
copa_match
copa_matchevent
copa_player
copa_stage
copa_team
copa_tournament
django_admin_log
django_content_type
django_migrations
django_session
```

---

# Grupos principais de tabelas

## Usuários e autenticação

```text
accounts_user
accounts_user_groups
accounts_user_user_permissions
authtoken_token
auth_group
auth_group_permissions
auth_permission
django_session
```

---

## Estrutura da competição

```text
copa_tournament
copa_stage
copa_team
copa_player
copa_match
copa_matchevent
```

---

## Palpites e resultados

```text
copa_bet
copa_extrabet
copa_extraresult
```

---

## Controle Django

```text
django_admin_log
django_content_type
django_migrations
django_session
```

---

# Migrations Django

Depois de atualizar o backend, deve ser executado:

```bash
docker exec bolao-backend python manage.py migrate
```

Isso aplica ao banco as migrations existentes no código atualizado.

---

# Verificar migrations

```bash
docker exec bolao-backend python manage.py showmigrations
```

---

# Verificar se existem migrations pendentes

Pode ser utilizado:

```bash
docker exec bolao-backend python manage.py migrate --check
```

Se não houver migrations pendentes, o comando deve terminar sem necessidade de alteração no banco.

---

# Regra importante de deploy

No ambiente de desenvolvimento:

```text
makemigrations
```

deve normalmente ser executado durante o desenvolvimento.

Os arquivos gerados devem ser versionados no Git.

No servidor de produção, o procedimento normal é:

```text
git pull
docker build
recriar container
python manage.py migrate
```

---

# Acessar o MySQL manualmente

No Viper-II:

```bash
docker exec -it mysql mysql -uroot -p
```

Depois informar a senha quando solicitado.

Dentro do MySQL:

```sql
USE bolao2026;
```

Listar tabelas:

```sql
SHOW TABLES;
```

Sair:

```sql
exit;
```

---

# Verificar bancos existentes

Dentro do MySQL:

```sql
SHOW DATABASES;
```

---

# Verificar usuário do Bolao2026

Dentro do MySQL:

```sql
SELECT User, Host
FROM mysql.user
WHERE User = 'bolao_user';
```

---

# Verificar permissões

```sql
SHOW GRANTS FOR 'bolao_user'@'%';
```

O resultado deve apresentar acesso ao banco:

```text
bolao2026
```

---

# Testar acesso utilizando o usuário da aplicação

Pode ser testado a partir do container MySQL:

```bash
docker exec -it mysql mysql \
  -ubolao_user \
  -p \
  bolao2026
```

A senha será solicitada.

Depois:

```sql
SHOW TABLES;
```

---

# Testar conexão pelo Django

Executar:

```bash
docker exec bolao-backend python manage.py check
```

Se a aplicação estiver corretamente configurada e não houver erro de banco, o comando deve concluir normalmente.

---

# Verificar logs relacionados ao banco

```bash
docker logs bolao-backend --tail 100
```

Erros comuns:

```text
Access denied
Can't connect to MySQL server
Unknown database
Unknown MySQL server host
OperationalError
```

---

# Erro: Unknown MySQL server host mysql

Verificar se backend e MySQL estão conectados à rede:

```bash
docker network inspect infra
```

Devem aparecer:

```text
bolao-backend
mysql
```

---

# Erro: Can't connect to MySQL server

Verificar:

```bash
docker ps | grep mysql
```

Depois:

```bash
docker logs mysql --tail 100
```

---

# Erro: Access denied

Pode indicar:

```text
senha incorreta
usuário incorreto
Host incorreto no usuário MySQL
permissões incorretas
```

Verificar:

```sql
SHOW GRANTS FOR 'bolao_user'@'%';
```

---

# Persistência do banco

Os dados do MySQL são persistidos através do volume Docker:

```text
mysql_data
```

Isso significa que remover o container:

```text
mysql
```

não deve apagar os dados, desde que o volume seja preservado e o novo container utilize o mesmo volume.

---

# Volume crítico

Volume:

```text
mysql_data
```

Nunca remover sem backup.

Não executar:

```bash
docker volume rm mysql_data
```

sem certeza absoluta e backup confirmado.

---

# Verificar volume

```bash
docker volume inspect mysql_data
```

---

# Backup manual do Bolao2026

Um dump manual pode ser criado com:

```bash
docker exec mysql mysqldump \
  -uroot \
  -p'SENHA_ROOT' \
  --single-transaction \
  --routines \
  --triggers \
  --events \
  --no-tablespaces \
  bolao2026 \
  > bolao2026_backup.sql
```

A senha real não deve ser inserida em documentação compartilhada.

---

# Melhor forma de evitar senha no histórico

Sempre que possível, preferir autenticação interativa ou mecanismo seguro de credenciais.

Evitar deixar senhas diretamente em:

```text
shell history
scripts versionados
Obsidian
GitHub
logs
```

---

# Backup automatizado futuro

O banco:

```text
bolao2026
```

deve fazer parte da política geral de backup do Viper-II.

A rotina deverá contemplar:

```text
backup diário
retenção
compressão
cópia externa
registro de logs
validação periódica de restauração
```

---

# Estrutura sugerida para backups

Diretório geral já previsto:

```text
/srv/backups
```

Sugestão futura:

```text
/srv/backups/mysql/bolao2026
```

Exemplo de nomenclatura:

```text
bolao2026_20260810_020000.sql.gz
```

---

# Backup não é igual a volume

O volume:

```text
mysql_data
```

garante persistência local.

Ele não substitui backup.

Se ocorrer:

```text
falha física do SSD
corrupção
remoção acidental
problema no servidor
criptografia por malware
```

o volume pode ser perdido.

Por isso é necessário backup externo.

---

# Cuidados antes de grandes alterações

Antes de:

```text
migration estrutural importante
mudança de versão do MySQL
alteração em massa
delete em grande quantidade
deploy crítico
```

é recomendado criar um dump atualizado.

---

# Verificar quantidade de tabelas

Dentro do MySQL:

```sql
SELECT COUNT(*)
FROM information_schema.tables
WHERE table_schema = 'bolao2026';
```

---

# Ver tamanho do banco

```sql
SELECT
    table_schema AS banco,
    ROUND(SUM(data_length + index_length) / 1024 / 1024, 2) AS tamanho_mb
FROM information_schema.tables
WHERE table_schema = 'bolao2026'
GROUP BY table_schema;
```

---

# Ver tamanho por tabela

```sql
SELECT
    table_name,
    ROUND((data_length + index_length) / 1024 / 1024, 2) AS tamanho_mb
FROM information_schema.tables
WHERE table_schema = 'bolao2026'
ORDER BY (data_length + index_length) DESC;
```

---

# Ver número de registros de uma tabela

Exemplo:

```sql
SELECT COUNT(*)
FROM copa_match;
```

Outro exemplo:

```sql
SELECT COUNT(*)
FROM copa_bet;
```

---

# Não alterar banco diretamente sem necessidade

Sempre que uma alteração fizer parte da lógica do sistema, preferir:

```text
Django migrations
Admin
API
procedimento oficial da aplicação
```

Alterações manuais via SQL devem ser utilizadas com cautela.

---

# Produção e desenvolvimento

O banco de produção:

```text
bolao2026
```

no Viper-II não deve ser usado como banco de desenvolvimento.

Alterações experimentais devem ser realizadas no ambiente local.

---

# Fluxo após alteração de models

No desenvolvimento:

```text
Alterar models.py
        ↓
python manage.py makemigrations
        ↓
testar migration localmente
        ↓
git add
        ↓
git commit
        ↓
git push
```

No Viper-II:

```text
git pull
        ↓
docker build
        ↓
recriar bolao-backend
        ↓
python manage.py migrate
```

---

# Validação após migration

Depois de:

```bash
docker exec bolao-backend python manage.py migrate
```

verificar:

```bash
docker logs bolao-backend --tail 50
```

Depois testar:

```text
https://fernandomurashima.com.br
```

Realizar login e validar funcionalidades afetadas pela migration.

---

# Reiniciar MySQL

Se realmente necessário:

```bash
docker restart mysql
```

ATENÇÃO:

O container MySQL é compartilhado por outras aplicações do servidor.

Reiniciar o MySQL pode causar indisponibilidade temporária em:

```text
Bolao2026
WebFoto
outros sistemas que utilizem o mesmo MySQL
```

Portanto, evitar reinício sem necessidade.

---

# Ver logs do MySQL

```bash
docker logs mysql --tail 100
```

Em tempo real:

```bash
docker logs -f mysql
```

---

# Ver status do container MySQL

```bash
docker ps | grep mysql
```

---

# Teste rápido do banco

```bash
docker exec mysql mysql \
  -ubolao_user \
  -p \
  -e "USE bolao2026; SHOW TABLES;"
```

A senha será solicitada se o comando for executado de forma interativa adequada.

---

# Segurança do banco

Itens que devem ser protegidos:

```text
senha root MySQL
senha bolao_user
dumps de produção
dados pessoais
tokens eventualmente armazenados nas tabelas
```

Dumps de produção devem ser tratados como arquivos sensíveis.

---

# Não armazenar credenciais no Git

Arquivos contendo:

```text
senha do banco
SECRET_KEY
tokens
```

não devem ser enviados para repositório público ou compartilhado.

---

# Melhoria futura

O `settings.py` deve futuramente utilizar variáveis de ambiente.

Exemplo conceitual:

```python
"NAME": os.getenv("DB_NAME"),
"USER": os.getenv("DB_USER"),
"PASSWORD": os.getenv("DB_PASSWORD"),
"HOST": os.getenv("DB_HOST", "mysql"),
"PORT": os.getenv("DB_PORT", "3306"),
```

Assim, credenciais deixam de ficar diretamente no código-fonte.

---

# Situação atual

```text
Banco: bolao2026
Servidor: Viper-II
Container: mysql
Imagem: mysql:8.0
Rede: infra
Porta: 3306
Usuário da aplicação: bolao_user
Hostname utilizado pelo Django: mysql
Volume persistente: mysql_data
Migração: concluída
Status: operacional
```

---

# Documentos relacionados

- [[Bolao2026]]
- [[Contexto do Projeto/Visao Geral]]
- [[Decisões Técnicas/Arquitetura de Producao]]
- [[Infraestrutura/Servidor Viper-II]]
- [[Infraestrutura/Docker]]
- [[Infraestrutura/Nginx Proxy Manager]]
- [[Infraestrutura/Cloudflare e DNS]]
- [[Migração KingHost/Migracao KingHost para Viper-II]]
- [[Operação/Operacao do Bolao]]
- [[Operação/Atualizacao Backend]]
- [[Operação/Atualizacao Frontend]]