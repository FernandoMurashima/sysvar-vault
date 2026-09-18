---
type: reference
status: active
project: Sysvar
source: "FernandoMurashima/sysvarbackend@28d090e856ef72fdf8de091c4bfd4133af043237"
created: 2026-09-18
updated: 2026-09-18
tags:
  - sysvar
  - sysvar-hub
  - vendedores
  - integracao
  - snapshot
---

# Mapa Técnico - Sysvar Hub - Vendedores

## Objetivo

Documentar o snapshot de vendedores exposto pelo Sysvar Central para o [[Sysvar Hub]].

## Endpoint

~~~text
GET /api/hub/vendedores/
Authorization: Hub <TOKEN>
~~~

## Escopo

O endpoint deriva o contexto exclusivamente do Hub autenticado:

~~~text
Hub
→ Loja
→ Empresa
~~~

Parâmetros enviados pelo cliente não podem trocar Empresa ou Loja do snapshot.

## Fonte de dados

A origem é o cadastro `Funcionarios` do Sysvar Central.

Critérios de elegibilidade vigentes:

- mesma Empresa do Hub;
- mesma Loja do Hub;
- `ativo=True`;
- situação `ATIVO`;
- `participa_vendas=True`.

Não basta possuir cadastro de funcionário para aparecer como vendedor do PDV.

## Contrato

A resposta versão 1 contém metadados do snapshot:

- `vendedores_versao = 1`;
- `gerado_em`;
- Hub;
- Empresa;
- Loja;
- lista `vendedores`.

Cada vendedor expõe somente o conjunto operacional necessário:

- id;
- matrícula;
- nome;
- apelido;
- cargo;
- comissionado;
- percentual de comissão;
- ativo;
- situação;
- participa_vendas.

## Cargo

Quando existir cargo, o snapshot pode informar:

- id;
- código;
- descrição.

## Dados que não devem sair

O endpoint não deve expor dados pessoais/administrativos sem necessidade operacional, incluindo:

- CPF;
- salário;
- telefone;
- WhatsApp;
- email;
- endereço;
- credenciais;
- senha/hash;
- dados bancários.

## Performance

A consulta usa relacionamento carregado de forma controlada para evitar problema N+1 no snapshot.

A ordenação deve ser determinística para que o Hub receba fotografia estável.

## Autoridade

O Sysvar Central permanece autoridade dos vendedores.

O snapshot existe para permitir operação local do Hub sem transformar o Hub em cadastro mestre de funcionários.

## Commit de referência

- `28d090e856ef72fdf8de091c4bfd4133af043237` — `feat: expoe vendedores ao Sysvar Hub`.

## Relacionados

- [[Sysvar Hub]]
- [[Mapa Técnico - Sysvar Hub - Tipos de Despesa PDV]]
- [[Mapa Técnico - Sysvar Hub - Sincronização Hub para Central]]
- [[Mapa Técnico - Cadastros - Funcionários]]
