---
type: reference
status: active
project: Sysvar
source: "FernandoMurashima/sysvarfrontend/sysvar/src/app/layout/shell/shell.component.ts"
created: 2026-09-18
updated: 2026-09-18
tags:
  - sysvar
  - frontend
  - menu
  - navegacao
  - permissoes
---

# Mapa Técnico - Interface - Menu Principal

## Objetivo

Registrar a organização vigente do menu principal do [[Sysvar]].

A reorganização foi de navegação e não altera por si só regras funcionais dos módulos.

## Estrutura principal

A árvore atual possui os grupos de primeiro nível:

1. Dashboard;
2. Cadastros;
3. Produtos;
4. Compras;
5. Estoque;
6. Distribuição;
7. Produção;
8. Vendas;
9. Loja;
10. Financeiro;
11. Fiscal / Contábil.

## Dashboard

Dashboard permanece como grupo principal próprio e concentra:

- Visão Geral;
- Executivo;
- Vendas;
- Produtos;
- Estoque;
- Financeiro;
- Margem / CMV.

O submenu de dashboards foi preservado após a reorganização.

## Cadastros

`Operacional` foi movido para dentro de Cadastros.

Estrutura de Operacional inclui:

- Empresas;
- Estabelecimentos;
- Usuários;
- Perfis de Acesso;
- Agente;
- Auditoria.

Cadastros também agrupa Pessoas e Organização e cadastros de Compras/Materiais.

## Estoque

Estoque foi separado em áreas de consulta, movimentação e operação.

Itens relevantes:

- Consulta por Referência;
- Consulta por Referência Uso/Consumo;
- Consulta por Coleção/Estação;
- Movimentação por Referência;
- Movimentação Uso/Consumo;
- Movimentações;
- Recebimento de Almoxarifado;
- NF-e;
- Inventário;
- Etiquetas.

`Recebimento de Mercadoria` do estoque central foi renomeado no menu para **Recebimento de Almoxarifado**, preservando a rota:

~~~text
/estoque/recebimentos-mercadoria
~~~

## Loja

Loja concentra operações locais da unidade.

Itens vigentes:

- PDV;
- Recebimento de Mercadoria;
- Consulta de Vendas;
- Devolução de Venda;
- Consulta de Estoque.

O PDV mantido no menu de Loja utiliza:

~~~text
/loja/pdv-offline
~~~

A entrada duplicada de PDV fora do grupo Loja foi removida.

## Separação dos recebimentos

Não confundir:

~~~text
Estoque → Recebimento de Almoxarifado
```
com
```text
Loja → Recebimento de Mercadoria
~~~

O primeiro trata recebimento central/almoxarifado.

O segundo trata mercadoria chegando à Loja.

## Permissões

A árvore continua submetida aos mecanismos existentes de:

- `roles`;
- `moduloEmpresa`;
- `processoAnyOf`;
- filtragem por `PermissionService`.

Reorganização visual não concede acesso novo a usuário que não possua permissão.

## Rotas e escopos da barra superior

O `ShellComponent` mantém mapeamento entre rotas e escopos usados pelos controles globais de:

- indicadores;
- filtros;
- restaurar visualização.

Ao criar ou mover uma rota operacional, verificar também esse mapeamento.

## Arquivo de autoridade

A árvore de navegação está definida em:

~~~text
sysvar/src/app/layout/shell/shell.component.ts
~~~

Testes correspondentes ficam em:

~~~text
sysvar/src/app/layout/shell/shell.component.spec.ts
~~~

## Regra de manutenção

Ao reorganizar o menu:

- mover navegação sem alterar rota quando não houver necessidade;
- preservar regras de permissão;
- evitar atalhos duplicados para a mesma função sem motivo funcional;
- manter terminologia coerente entre Estoque e Loja;
- atualizar documentação quando a estrutura principal mudar.

## Commits de referência

- `0064fef9` — Reorganiza menu principal do Sysvar.
- `5224229a` — Restaura submenu de dashboards.

## Relacionados

- [[Sysvar]]
- [[Visão Geral]]
- [[Arquitetura]]
- [[Mapa Técnico - Estoque - Consultas e Movimentações]]
- [[Mapa Técnico - Compras - Recebimento de Mercadoria]]
