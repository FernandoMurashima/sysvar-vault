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
  - workflows
---

# Workflows

## Autenticação e permissões

1. Usuário autentica pelo backend.
2. Backend retorna contexto de usuário/permissões.
3. Frontend usa guard/shell para liberar rotas.
4. Backend valida acesso por módulo, empresa e regra de viewset.

## Venda PDV

1. Caixa/vendedor inicia venda.
2. Itens, pagamentos, cashback e NFC-e são processados.
3. Estoque é movimentado.
4. Financeiro e contabilidade recebem reflexos.
5. Dashboards consolidam indicadores.

## Devolução de venda

1. Operador inicia devolução a partir de venda finalizada.
2. Sistema valida quantidades e valores.
3. Estoque recebe entrada de retorno.
4. Financeiro é ajustado ou estornado.
5. CMV e auditoria registram o evento.

## Distribuição entre lojas

1. Distribuição é criada a partir do estoque da origem.
2. Perfis/destinos definem alocação.
3. Confirmação reserva estoque e gera pedidos.
4. NF-e de transferência pode ser emitida.
5. Estoque e financeiro são atualizados na origem e destino.

## Pagamento e recebimento

1. Título nasce de compra, venda, transferência ou lançamento manual.
2. Baixa gera movimentação financeira.
3. Lançamento contábil é criado ou estornado conforme natureza.
4. Dashboard usa os dados consolidados.

## Produção e estoque

1. Ficha técnica define composição.
2. Ordem de produção consome insumos.
3. Finalização movimenta estoque.
4. Produção pode alimentar distribuição, venda e financeiro.

## Última atualização

2026-08-03

## Limitações do contexto

Os fluxos são transversais e devem ser testados por integração. Evitar mexer em apenas um app sem checar efeitos fiscais, financeiros e de estoque.
