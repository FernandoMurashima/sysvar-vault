---
type: reference
status: active
project: Sysvar
source: "C:/SysvarProjeto"
created: 2026-08-03
updated: 2026-08-03
tags:
  - sysvar
  - contexto
  - mapa-tecnico
---

# Mapa Técnico

## Inventário

- Projeto analisado: `C:\SysvarProjeto`.
- Arquivos relevantes no inventário: 858.
- Diretórios ignorados: `venv`, `venv_antigo_quebrado`, `node_modules`, `dist`, `.angular`, caches, `.git`, builds e arquivos binários.

## Comando de inventário

```powershell
C:\Users\ferna\.cache\codex-runtimes\codex-primary-runtime\dependencies\python\python.exe C:\Users\ferna\.codex\skills\project-context-pack\scripts\inventory_project.py --project-root C:\SysvarProjeto --format markdown
```

## Entrypoints

- Backend: `Backend\manage.py`.
- Projeto Django: `Backend\Varejo`.
- Backend requirements: `Backend\requirements.txt`.
- Frontend: `Frontend\sysvar`.
- Frontend package: `Frontend\sysvar\package.json`.
- Documentação existente: `docs`.

## Rotas backend

Prefixos principais:

- `/api/accounts/`
- `/api/cadastros/`
- `/api/auditoria/`
- `/api/produto/`
- `/api/financeiro/`
- `/api/compras/`
- `/api/fiscal/`
- `/api/distribuicao/`
- `/api/dashboard/`
- `/api/docs/` e `/api/redoc/`

## Rotas frontend

Rotas principais cobrem login, home, cadastros, produtos, vendas, dashboards, fiscal, compras, produção, financeiro, estoque, distribuição, loja e configurações.

## Onde mexer por tipo de feature

- Permissões/usuários: `Backend\accounts`, services de auth/permission e rota `/config/usuarios`.
- Cadastros e estabelecimentos: `Backend\cadastros`, telas de empresas/lojas/clientes/fornecedores/funcionários.
- Produtos/estoque/produção: `Backend\produto`, features de produtos, estoque, ficha técnica e OP.
- Compras: `Backend\compras`, features de pedidos e notas de entrada.
- Fiscal/PDV/devoluções: `Backend\fiscal`, telas de PDV, faturamento, devoluções e NFC-e.
- Financeiro/contábil: `Backend\financeiro`, telas de pagar, receber, caixa, contas, movimentações, DRE e lançamentos.
- Distribuição: `Backend\distribuicao`, features de distribuição e pedidos de venda.
- Indicadores: `Backend\dashboard` e features de dashboard.

## Última atualização

2026-08-03

## Limitações do contexto

O inventário é amplo. Para tarefas específicas, procurar primeiro nos docs por domínio e depois abrir `models.py`, `serializers.py`, `views.py`, `urls.py` e service Angular correspondente.
