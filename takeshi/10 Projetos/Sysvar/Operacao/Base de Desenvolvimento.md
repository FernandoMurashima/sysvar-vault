type: runbook  
status: active  
project: Sysvar  
source: "C:/SysvarProjeto/Backend/sysvar_devtools/dev_base.py"  
created: 2026-09-09  
updated: 2026-09-10  
tags:

- sysvar
    
- operacao
    
- devtools
    
- base-desenvolvimento
    
- auditoria
    
- agente-local
    

---

# Base de Desenvolvimento

## Finalidade

A Base de Desenvolvimento oficial do Sysvar é a massa estrutural usada para desenvolvimento, teste funcional e homologação controlada.

Ela não representa uma base vazia. Ela representa:

```
base estrutural completa
+
cadastros e configurações necessárias
+
estoque estrutural com saldo zero
+
nenhuma operação de negócio anterior
```

## Base limpa versus base vazia

Base vazia é um banco sem dados.

Base limpa, no contexto do Sysvar DevTools, é um banco reconstruído com a estrutura funcional necessária para operar o sistema em desenvolvimento, mas sem histórico operacional anterior.

## Estruturas preservadas e recriadas

O rebuild recria a estrutura oficial a partir dos seeds de `sysvar_devtools/seeds`, incluindo:

- Empresa;
    
- Estabelecimentos;
    
- contrato e módulos contratados;
    
- usuários, perfis e permissões;
    
- cargos, funcionários, clientes e fornecedores;
    
- plano contábil, naturezas e centros de custo;
    
- setores e matriz de responsabilidade;
    
- categorias e finalidades de aquisição;
    
- formas e prazos de pagamento;
    
- contas bancárias, caixas e tipos de despesa de PDV;
    
- ConfigFinanceira;
    
- CashbackConfig;
    
- unidades, NCM, grupos, subgrupos, coleções, materiais, grades, tamanhos e cores;
    
- tabelas de preço;
    
- produtos de venda, uso/consumo e insumos;
    
- SKUs e EANs;
    
- Produto x Fornecedor;
    
- packs;
    
- fichas técnicas;
    
- estrutura fiscal;
    
- perfis de distribuição;
    
- estrutura de estoque SKU x Loja;
    
- estrutura de estoque Uso/Consumo x Loja.
    

## Operações eliminadas

O rebuild remove operações anteriores da base de desenvolvimento, incluindo:

- sessões e tokens;
    
- requisições, cotações, ordens de serviço e pedidos de compra;
    
- entradas e saídas fiscais;
    
- NF-e e XMLs operacionais de fornecedores;
    
- recebimentos de mercadoria e suas conferências;
    
- vendas PDV, devoluções e NFC-e;
    
- distribuições executadas, pedidos de distribuição e mercadoria em trânsito;
    
- ordens de produção;
    
- inventários executados;
    
- movimentações de estoque;
    
- movimentações de Uso/Consumo;
    
- contas a pagar e a receber operacionais;
    
- movimentações financeiras;
    
- antecipações;
    
- movimentos de Cashback;
    
- Vale-Troca e movimentos de Vale-Troca;
    
- AuditLog anterior;
    
- Agente Local Sysvar cadastrado;
    
- ativações do Agente Local;
    
- configurações locais de pastas XML do Agente Local.
    

## Estoque estrutural zerado

A rotina mantém as estruturas de estoque necessárias para desenvolvimento:

- `Estoque` por SKU x Loja;
    
- `ProdutoUsoConsumoEstoque` por Produto x Loja.
    

Essas estruturas devem terminar com:

```
saldo físico = 0
reserva = 0
saldo de uso/consumo = 0
```

A existência da linha estrutural de estoque não representa entrada física.

## ConfigFinanceira

`ConfigFinanceira` é removida durante o rebuild e recriada a partir do seed oficial:

```
sysvar_devtools/seeds/config_financeira.json
```

A recriação respeita a Empresa da base e vincula as naturezas financeiras oficiais já carregadas.

A relação é uma configuração única por Empresa.

## CashbackConfig

`CashbackConfig` é removida durante o rebuild e recriada a partir do seed oficial:

```
sysvar_devtools/seeds/cashback_config.json
```

A recriação respeita a Empresa da base e mantém a regra padrão oficial de Cashback para desenvolvimento.

Rebuilds repetidos não devem duplicar a configuração.

## Auditoria no rebuild

Durante a operação normal do Sysvar, `AuditLog` é imutável.

Essa política não deve ser enfraquecida:

- criação normal direta é bloqueada;
    
- update normal é bloqueado;
    
- delete normal é bloqueado.
    

No fluxo destrutivo da reconstrução da Base de Desenvolvimento, a auditoria antiga deve ser removida pelo mecanismo oficial de exclusão controlada:

```
hard_delete_for_retention()
```

A limpeza deve ocorrer ao final do rebuild para garantir que a base reconstruída seja entregue com:

```
AuditLog = 0
```

Isso evita manter histórico de uma base anterior e evita logs artificiais gerados durante a própria reconstrução.

## Agente Local Sysvar

O Agente Local é uma configuração operacional do ambiente e não faz parte da massa estrutural recriada pelo rebuild.

Ao reconstruir a Base de Desenvolvimento, são eliminados:

- cadastro do Agente Local;
    
- ativações anteriores;
    
- token vinculado ao cadastro anterior;
    
- configurações de pastas XML monitoradas.
    

O executável e o serviço instalados no Windows permanecem instalados.

Por isso, o serviço deve ser parado antes do rebuild e o agente deve ser reativado depois que a nova base estiver pronta.

## Proteção contra produção

O rebuild é destrutivo e deve continuar protegido por `assert_not_production()`.

Não executar o rebuild em produção.

Não ampliar manualmente os bancos considerados seguros.

Não alterar `DEBUG` ou settings para forçar execução.

## Comando oficial

Executar somente em ambiente de desenvolvimento apropriado:

```
python manage.py sysvar_dev_base --rebuild
```

O comando `--reset` permanece como alias de rebuild quando usado pela rotina vigente.

## Procedimento oficial completo de reconstrução

### 1. Parar o Agente Local

Abrir o PowerShell como Administrador.

```
& "C:\Program Files\Sysvar\LocalAgent\SysvarLocalAgent.exe" stop
```

### 2. Entrar no backend

```
cd C:\SysvarProjeto\Backend
.\venv\Scripts\Activate.ps1
```

### 3. Reconstruir a Base de Desenvolvimento

```
python manage.py sysvar_dev_base --rebuild
```

### 4. Confirmar o resultado

```
BASE DE DESENVOLVIMENTO: VÁLIDA
```

### 5. Validar novamente a base

```
python manage.py sysvar_dev_base --validate
```

### 6. Confirmar novamente

```
BASE DE DESENVOLVIMENTO: VÁLIDA
```

### 7. Iniciar o Sysvar

- iniciar o backend;
    
- iniciar o frontend;
    
- entrar no Sysvar.
    

### 8. Gerar nova ativação do Agente Local

Acessar:

```
Cadastros → Agente Local Sysvar
```

Gerar um novo código de ativação.

### 9. Definir o arquivo de configuração do Agente Local

Abrir o PowerShell como Administrador.

```
$env:SYSVAR_AGENT_CONFIG="C:\ProgramData\Sysvar\LocalAgent\config.json"
```

### 10. Reativar o Agente Local

```
& "C:\Program Files\Sysvar\LocalAgent\SysvarLocalAgent.exe" activate
```

Informar o código de ativação gerado no Sysvar.

Confirmar:

```
Local Agent ativado com sucesso.
```

Confirmar também o identificador e o hostname apresentados pelo agente.

### 11. Iniciar o serviço do Agente Local

```
& "C:\Program Files\Sysvar\LocalAgent\SysvarLocalAgent.exe" start
```

### 12. Confirmar o serviço

```
Get-Service SysvarLocalAgent
```

Resultado esperado:

```
Running
```

### 13. Confirmar o agente no Sysvar

Voltar para:

```
Cadastros → Agente Local Sysvar
```

Atualizar a tela e confirmar que o Agente Local aparece cadastrado.

### 14. Recriar a pasta monitorada

Criar novamente a configuração da pasta monitorada.

Selecionar:

- Agente Local correspondente;
    
- estabelecimento correspondente ou `Empresa inteira`;
    
- pasta local dos XMLs;
    
- configuração ativa.
    

Exemplo de pasta:

```
C:\Sysvar\XML\Fornecedores
```

Salvar.

### 15. Validar a pasta monitorada

Confirmar que a configuração aparece cadastrada na tela do Agente Local.

### 16. Conferir o log do Agente Local

```
Get-Content "C:\ProgramData\Sysvar\LocalAgent\logs\sysvar-agent.log" -Tail 30
```

Confirmar:

- ausência de erros de autenticação;
    
- heartbeat funcionando normalmente;
    
- agente operacional.
    

## Validação

A validação técnica esperada inclui:

```
python manage.py check
python manage.py test cadastros.tests_dev_base
```

A rotina também possui validação interna por `SysvarDevBaseService().validate()`, que deve confirmar:

- estruturas oficiais recriadas;
    
- ConfigFinanceira existente;
    
- CashbackConfig existente;
    
- ausência de operações anteriores;
    
- estoque estrutural zerado;
    
- ausência de `AuditLog`;
    
- ausência de Agente Local antigo;
    
- ausência de ativações antigas;
    
- ausência de configurações XML locais antigas;
    
- idempotência do rebuild.
    

A validação operacional após o rebuild deve confirmar:

```
agentes locais = 0
ativações agente local = 0
audit logs = 0
configuração financeira > 0
configurações cashback > 0
configurações xml fornecedor = 0
recebimentos mercadoria = 0
tabelas operacionais com dados = 0
xmls fornecedor = 0
BASE DE DESENVOLVIMENTO: VÁLIDA
```

## Regra operacional obrigatória

Sempre que a Base de Desenvolvimento for reconstruída:

1. parar o serviço do Agente Local;
    
2. executar o rebuild;
    
3. executar o validate;
    
4. iniciar backend e frontend;
    
5. gerar novo código de ativação;
    
6. reativar o Agente Local;
    
7. iniciar o serviço;
    
8. confirmar `Running`;
    
9. recriar a configuração da pasta monitorada;
    
10. validar o log e o heartbeat.
    

## Cuidado operacional

Nunca executar:

```
python manage.py sysvar_dev_base --rebuild
```

contra produção ou contra banco persistente que contenha dados reais que devam ser preservados.

O rebuild real da base de desenvolvimento deve ser feito manualmente pelo responsável depois da revisão da alteração.