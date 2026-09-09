---
type: runbook
status: active
project: Sysvar
source: "C:/SysvarProjeto/Backend/sysvar_devtools/dev_base.py"
created: 2026-09-09
updated: 2026-09-09
tags:
  - sysvar
  - operacao
  - devtools
  - base-desenvolvimento
  - auditoria
---

# Base de Desenvolvimento

## Finalidade

A Base de Desenvolvimento oficial do Sysvar é a massa estrutural usada para desenvolvimento, teste funcional e homologação controlada.

Ela não representa uma base vazia. Ela representa:

```text
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
- AuditLog anterior.

## Estoque estrutural zerado

A rotina mantém as estruturas de estoque necessárias para desenvolvimento:

- `Estoque` por SKU x Loja;
- `ProdutoUsoConsumoEstoque` por Produto x Loja.

Essas estruturas devem terminar com:

```text
saldo físico = 0
reserva = 0
saldo de uso/consumo = 0
```

A existência da linha estrutural de estoque não representa entrada física.

## ConfigFinanceira

`ConfigFinanceira` é removida durante o rebuild e recriada a partir do seed oficial:

```text
sysvar_devtools/seeds/config_financeira.json
```

A recriação respeita a Empresa da base e vincula as naturezas financeiras oficiais já carregadas.

A relação é uma configuração única por Empresa.

## CashbackConfig

`CashbackConfig` é removida durante o rebuild e recriada a partir do seed oficial:

```text
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

```text
hard_delete_for_retention()
```

A limpeza deve ocorrer ao final do rebuild para garantir que a base reconstruída seja entregue com:

```text
AuditLog = 0
```

Isso evita manter histórico de uma base anterior e evita logs artificiais gerados durante a própria reconstrução.

## Proteção contra produção

O rebuild é destrutivo e deve continuar protegido por `assert_not_production()`.

Não executar o rebuild em produção.

Não ampliar manualmente os bancos considerados seguros.

Não alterar `DEBUG` ou settings para forçar execução.

## Comando oficial

Executar somente em ambiente de desenvolvimento apropriado:

```powershell
python manage.py sysvar_dev_base --rebuild
```

O comando `--reset` permanece como alias de rebuild quando usado pela rotina vigente.

## Validação

A validação técnica esperada inclui:

```powershell
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
- idempotência do rebuild.

## Cuidado operacional

Nunca executar:

```powershell
python manage.py sysvar_dev_base --rebuild
```

contra produção ou contra banco persistente que contenha dados reais que devam ser preservados.

O rebuild real da base de desenvolvimento deve ser feito manualmente pelo responsável depois da revisão da alteração.
