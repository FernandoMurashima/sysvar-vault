---
name: sysvar-contexto
description: Monta o contexto vigente de um módulo do Sysvar (Central e/ou Hub) a partir do cofre Obsidian e do código atual. Use ao iniciar ou retomar qualquer tarefa do Sysvar — análise, definição de regras, prompt para Codex, revisão ou documentação.
---

# Contexto Sysvar

Objetivo: reconstruir o estado real de um módulo lendo **só o necessário**, sem depender da memória de conversas e sem pedir ao usuário caminhos que já estão registrados aqui.

## Fontes

| Fonte | Local | Repositório |
|---|---|---|
| Cofre (documentação oficial) | `C:\Takeshi\takeshi` → `10 Projetos/Sysvar` | `FernandoMurashima/sysvar-vault` (`main`) |
| Central Backend (Django) | `C:\SysvarProjeto\Backend` | `FernandoMurashima/sysvarbackend` (`main`) |
| Central Frontend (Angular) | `C:\SysvarProjeto\Frontend\sysvar` | `FernandoMurashima/sysvarfrontend` (`main`) |
| Hub Backend (Django) | `C:\SysvarHub\Backend` | `FernandoMurashima/sysvarhub-backend` (`main`) |
| Hub Frontend (Angular) | `C:\SysvarHub\Frontend` | `FernandoMurashima/sysvarhub-frontend` (`main`) |

Sem acesso local, use os repositórios no GitHub. Nunca abra nem copie `.env`, tokens, dumps `.sql` ou XMLs de clientes.

## Passo 1 — Identificar módulo e camada

- **Área**: Cadastros, Compras, Produtos, Estoque, Fiscal, Financeiro, Produção, Distribuição, Plataforma/Auditoria ou Sysvar Hub.
- **Submódulo**: ex.: Clientes, Pedido de Compra, Entrada de NF-e, Insumos, NFC-e.
- **Camada**: Central, Hub ou ambos. Envolve o Hub quando a tarefa toca loja, PDV, caixa, operador, pareamento, terminal, sincronização, contingência, venda local, devolução/troca, vale-troca ou emissão fiscal disparada pela loja. O Hub faz parte do Sysvar, não é outro projeto.

Se a área não estiver clara, pergunte uma única vez.

## Passo 2 — Montar o pacote de documentos do módulo

As notas seguem o padrão `Contexto do Projeto/<Tipo> - <Área> - <Submódulo>.md`. Liste a pasta e selecione pelo nome do submódulo, nesta ordem:

1. `Estado Atual - <Área>.md` — curto, tem data de referência; leia primeiro.
2. `Modelo de Domínio - <Área> - <Submódulo>.md`
3. `Workflows - <Área> - <Submódulo>.md`
4. `Riscos e Cuidados - <Área> - <Submódulo>.md`
5. `Mapa Técnico - <Área> - <Submódulo>.md`
6. `Homologações/Homologação - <Área> - <Submódulo>.md`
7. `Decisões Técnicas/ADR-*.md` relacionados (ADR-002 Princípios Arquiteturais e ADR-003 Auditoria valem para quase tudo).
8. `Planejamento, Pendências e Homologação.md` — fonte única de roadmap e pendências. É grande (~86 KB): **busque a seção do módulo**, não leia inteiro.

Notas gerais grandes (`Sysvar.md`, `Arquitetura.md`, `Visão Geral.md`, `Mapa Técnico.md`, `Modelo de Domínio.md`, `Workflows.md`, `Riscos e Cuidados.md`, `Sysvar Hub.md`, 35–75 KB cada): busque trechos pelo nome do módulo. Leia inteiras só se o submódulo não tiver nota própria.

**Dependências cruzadas** — inclua o `Estado Atual` das áreas afetadas:
- Compras → Produtos, Estoque, Financeiro, Fiscal, Fornecedores, Auditoria
- Vendas → Produtos, Estoque, Financeiro, Fiscal, Clientes, Hub
- Produção → Produtos, Insumos, Ficha Técnica, Estoque, Distribuição
- Hub → Vendas, Financeiro, Fiscal, Clientes, Usuários, Caixa, Sincronização

Documentos de processo (`90 Sistema/`): consulte só quando a tarefa tocar o processo — prompt para Codex → `Padrao de Prompts para Codex.md`; alteração de documentação → `Convenções.md` e `Protocolo de Trabalho com IA.md` (Fase 9).

## Passo 3 — Conferir o código

- Central Backend: apps `accounts`, `auditoria`, `cadastros`, `compras`, `dashboard`, `distribuicao`, `financeiro`, `fiscal`, `hub`, `produto`, `local_agent`; configuração em `Varejo/`; docs acopladas em `docs/`.
- Hub Backend: `core/` (operação local), `integracao/` (comunicação com a Central), `sysvarhub/` (config), `docs/`.
- Frontends: `src/app/`.

Confirme que models, endpoints, services e telas citados na documentação existem. Veja a atividade recente: `git log --oneline -15 -- <caminho do app>`.

## Passo 4 — Resolver divergências

Hierarquia de autoridade:

1. decisão nova explicitamente aprovada na tarefa atual;
2. documentação vigente e não histórica;
3. código vigente;
4. histórico e checkpoints;
5. inferência.

Seções datadas e checkpoints são histórico, não estado atual. Se uma nota escrita como "estado atual" contradiz o código, registre como divergência; não escolha sozinho qual está certo quando isso mudar regra de negócio.

## Passo 5 — Entregar o resumo de contexto

Curto, sem copiar a documentação:

- **Módulo / camada / repositórios envolvidos**
- **Documentos lidos** (com a data `updated` do YAML)
- **Regras vigentes relevantes à tarefa** — numeradas, cada uma com a fonte
- **Riscos e cuidados aplicáveis**
- **Estado do código** — o que existe; commits recentes relevantes
- **Divergências documentação × código**
- **Dúvidas de negócio em aberto** — só as que dependem de decisão do usuário

## Regras

- Não inventar regra de negócio; o que não estiver definido vira dúvida.
- Não reabrir decisão aprovada sem motivo concreto (defeito, conflito, novo requisito, risco não considerado).
- Multiempresa (tenant/empresa/loja) e regras críticas ficam no backend.
