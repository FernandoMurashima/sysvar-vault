---
type: technical-map
status: active
project: Sysvar
source: "FernandoMurashima/sysvarbackend/produto + FernandoMurashima/sysvarfrontend"
created: 2026-09-30
updated: 2026-09-30
tags:
  - sysvar
  - producao
  - estoque
  - estado-atual
---

# Estado Atual - Produção e Estoque

## Data de referência

30/09/2026.

## Fronteira técnica vigente

Produção e Estoque aparecem como áreas próprias na navegação do sistema, mas **não possuem apps backend Django independentes**.

A autoridade técnica atual de ambos está em:

`sysvarbackend/produto/`

Portanto, documentação que trate `producao/` ou `estoque/` como apps backend atuais deve ser interpretada como organização funcional, não como estrutura real do código.

---

# Produção

## Estruturas principais

A implementação atual possui:

- `FichaTecnica`;
- `FichaTecnicaItem`;
- `OrdemProducao`;
- `OrdemProducaoItem`;
- `OrdemProducaoGrade`;
- vínculo de itens de ordem com facção quando aplicável.

As migrations históricas do app `produto` registram a evolução dessas estruturas, incluindo ficha técnica, ordem, SKU final, grade e facção.

## Rotas

As APIs ficam sob `/api/produto/`, entre elas:

- `ficha-tecnica`;
- `ficha-tecnica-item`;
- `ordem-producao`;
- `ordem-producao-item`.

## Dependências

Produção se relaciona principalmente com:

- Produto Venda;
- Insumos;
- SKUs e grades;
- Estoque;
- fornecedores/facções quando aplicável;
- Distribuição após disponibilidade do produto acabado.

---

# Estoque

## Estruturas e rotas vigentes

O app `produto` expõe:

- `estoque`;
- `estoque-movimentacao`;
- `produto-uso-consumo-estoque`;
- `produto-uso-consumo-movimentacao`;
- `inventario-estoque`;
- `inventario-estoque-item`.

Movimentos de estoque carregam origem para rastrear o processo gerador conforme a implementação vigente.

## Origens integradas

O saldo pode ser afetado por fluxos de outros domínios, incluindo:

- Entrada/Recebimento de Mercadoria;
- Venda PDV;
- Devolução;
- Produção;
- Distribuição;
- inventário e ajustes permitidos.

Esses módulos originam eventos ou movimentos, mas a documentação não deve criar uma segunda fonte de verdade de estoque.

## Inventário

Inventário faz parte do domínio técnico de `produto/`, mesmo quando apresentado funcionalmente no menu de Estoque.

## Regra documental

Ao revisar Produção ou Estoque:

1. consultar esta nota;
2. consultar `produto/models.py`, `produto/views.py` e `produto/urls.py`;
3. consultar os módulos de origem envolvidos;
4. preservar a distinção entre organização de menu e autoridade backend.
