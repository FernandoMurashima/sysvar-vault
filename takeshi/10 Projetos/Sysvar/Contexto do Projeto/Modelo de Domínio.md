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
  - dominio
---

# Modelo de Domínio

## Domínios funcionais

- Administração e segurança: usuários, permissões, módulos, campos e auditoria.
- Estabelecimentos: empresas, lojas, matriz, fábrica, centros e vínculos operacionais.
- Cadastros gerais: clientes, fornecedores, funcionários e naturezas.
- Produtos: produtos, SKUs, grades, cores, coleções, packs, materiais e tabelas.
- Compras: pedidos de revenda e uso/consumo, entregas, parcelas e entrada fiscal.
- Fiscal: CFOP, NCM, tributos, regras, NF-e, NFC-e, notas e devoluções.
- Estoque: saldos, movimentações, inventário e disponibilidade.
- Produção: ficha técnica, ordem de produção e produto acabado.
- Distribuição: perfis, matriz, reserva, pedidos, trânsito e recebimento.
- Loja/PDV: venda presencial, caixa, offline, devoluções, vale-troca e NFC-e.
- Financeiro/contábil: pagar, receber, caixas, bancos, movimentações, lançamentos, DRE e antecipações.
- Relatórios: dashboards e consultas gerenciais.

## Regras transversais

- Multiempresa e multilojas são conceitos centrais.
- Permissões dependem de usuário, módulo, empresa/loja e, em alguns casos, campo.
- Operações comerciais podem afetar estoque, fiscal, financeiro, contábil e dashboards.
- Distribuição e produção dependem de disponibilidade de estoque e papel do estabelecimento.
- PDV e devoluções têm impacto fiscal, financeiro, estoque e auditoria.

## Pontos de atenção funcional

- A divisão técnica atual não corresponde perfeitamente à divisão funcional desejada.
- `produto`, `financeiro` e `fiscal` concentram responsabilidades de vários domínios.
- `distribuicao`, `PDV`, `MODULO_LOJA`, `CONTABIL` e `ESTABELECIMENTOS` aparecem como módulos funcionais importantes na proposta.
- Antes de perfis definitivos, mapear rota, endpoint, módulo funcional, estabelecimento compatível e permissão.

## Última atualização

2026-08-03

## Limitações do contexto

Algumas regras precisam validação funcional com o usuário antes de implementação, especialmente permissões, estabelecimento e divisão modular.
