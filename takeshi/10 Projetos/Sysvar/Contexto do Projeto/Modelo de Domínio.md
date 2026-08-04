---

type: reference  
status: active  
project: Sysvar  
source: "C:/SysvarProjeto"  
created: 2026-08-03  
updated: 2026-08-04  
tags:

- sysvar
    
- domínio
    
- modelo
    

---

# Modelo de Domínio

## Objetivo

O Modelo de Domínio descreve as principais entidades do SISVAR e seus relacionamentos.

Ele representa a visão funcional do sistema, independente da implementação física do banco de dados.

---

# Organização do domínio

O domínio está dividido em grandes grupos:

- Plataforma
    
- Empresas
    
- Segurança
    
- Cadastros
    
- Produtos
    
- Compras
    
- Estoque
    
- Produção
    
- Distribuição
    
- Vendas
    
- Fiscal
    
- Financeiro
    
- Contabilidade
    
- Auditoria
    

---

# Plataforma

## Empresa

Representa um cliente do SISVAR.

Cada empresa possui:

- contrato;
    
- lojas;
    
- usuários;
    
- perfis;
    
- módulos contratados;
    
- sessões;
    
- cadastros próprios;
    
- documentos próprios.
    

Todo o restante do domínio pertence exatamente a uma empresa.

---

## Contrato

Representa o contrato comercial da empresa.

Responsável por controlar:

- situação;
    
- vigência;
    
- módulos contratados;
    
- quantidade máxima de acessos simultâneos;
    
- versão das permissões.
    

Toda autenticação depende da validação do contrato.

---

## Módulo do Sistema

Representa uma funcionalidade comercializável.

Exemplos:

- Produtos;
    
- Compras;
    
- Estoque;
    
- Financeiro;
    
- Fiscal;
    
- Produção;
    
- Distribuição.
    

O contrato determina quais módulos ficam disponíveis para cada empresa.

---

# Segurança

## Usuário

Representa uma pessoa autorizada a utilizar o sistema.

Cada usuário pertence a uma empresa.

Um usuário pode possuir:

- perfil principal;
    
- permissões adicionais;
    
- uma ou mais sessões.
    

---

## Usuário Master

É o administrador da empresa.

Pode administrar:

- usuários;
    
- perfis;
    
- permissões;
    
- sessões;
    
- configurações da empresa.
    

Existe apenas um master por empresa.

---

## Perfil de Acesso

Representa um conjunto reutilizável de permissões.

O perfil determina quais operações o usuário poderá executar.

As permissões efetivas são calculadas pelo backend considerando:

- contrato;
    
- módulos;
    
- perfil;
    
- permissões adicionais;
    
- situação do usuário.
    

---

## Sessão de Usuário

Representa uma utilização simultânea do sistema.

Uma sessão contém:

- empresa;
    
- usuário;
    
- loja;
    
- dispositivo;
    
- token;
    
- endereço IP;
    
- user-agent;
    
- início;
    
- última atividade;
    
- encerramento;
    
- motivo do encerramento.
    

Uma sessão ativa consome exatamente um acesso simultâneo.

---

## Token

Cada sessão possui um token exclusivo.

O token:

- identifica a sessão;
    
- é validado em todas as requisições;
    
- pode ser revogado;
    
- nunca é armazenado em texto puro.
    

---

# Cadastros

Grupo responsável pelos cadastros básicos do ERP.

Inclui:

- clientes;
    
- fornecedores;
    
- funcionários;
    
- natureza financeira;
    
- plano financeiro;
    
- plano contábil;
    
- formas de pagamento;
    
- tabelas auxiliares.
    

Todos pertencem à empresa.

---

# Produtos

Representa toda a estrutura comercial dos produtos.

Inclui:

- produto;
    
- SKU;
    
- grade;
    
- cor;
    
- tamanho;
    
- coleção;
    
- grupo;
    
- subgrupo;
    
- NCM;
    
- tabela de preço;
    
- pack.
    

---

# Compras

Representa:

- pedidos;
    
- recebimentos;
    
- entrada de mercadorias.
    

As compras alimentam:

- estoque;
    
- financeiro;
    
- fiscal.
    

---

# Estoque

Controla toda movimentação física.

Origens:

- compras;
    
- produção;
    
- vendas;
    
- devoluções;
    
- distribuição;
    
- ajustes.
    

---

# Produção

Controla:

- ficha técnica;
    
- ordem de produção;
    
- consumo de matéria-prima;
    
- produção finalizada.
    

---

# Distribuição

Controla a distribuição entre matriz e lojas.

Permite:

- reserva;
    
- separação;
    
- transferência;
    
- faturamento;
    
- recebimento.
    

---

# Vendas

Representa:

- orçamento;
    
- pedido;
    
- venda;
    
- PDV;
    
- NFC-e;
    
- devolução.
    

---

# Fiscal

Responsável por:

- documentos fiscais;
    
- tributos;
    
- integrações fiscais.
    

---

# Financeiro

Responsável por:

- contas a pagar;
    
- contas a receber;
    
- caixa;
    
- bancos;
    
- fluxo de caixa.
    

---

# Contabilidade

Responsável por:

- plano contábil;
    
- lançamentos;
    
- integração financeira.
    

---

# Auditoria

Responsável por registrar operações críticas.

Cada registro de auditoria deverá conter:

- empresa;
    
- usuário;
    
- entidade;
    
- operação;
    
- valores alterados;
    
- data;
    
- IP;
    
- dispositivo.
    

---

# Relacionamentos principais

Empresa

→ Contrato

→ Usuários

→ Perfis

→ Sessões

→ Cadastros

→ Produtos

→ Compras

→ Estoque

→ Produção

→ Distribuição

→ Vendas

→ Financeiro

→ Fiscal

→ Auditoria

Usuário

→ Perfil

→ Sessões

→ Permissões efetivas

Contrato

→ Empresa

→ Módulos

→ Limite de sessões

Sessão

→ Usuário

→ Empresa

→ Token

---

# Situação atual

Implementado:

- Empresa
    
- Contrato
    
- Usuário
    
- Usuário Master
    
- Perfis
    
- Permissões
    
- Sessões
    
- Tokens
    
- Licenciamento por sessões
    
- Produtos
    
- Compras
    
- Financeiro
    

Em evolução:

- Auditoria central
    
- Produção
    
- Distribuição
    
- Entrada de Nota Fiscal
    

---

# Notas relacionadas

- [[10 Projetos/Sysvar/Sysvar|Sysvar]]
    
- [[10 Projetos/Sysvar/Contexto do Projeto/Arquitetura|Arquitetura]]
    
- [[10 Projetos/Sysvar/Contexto do Projeto/Workflows|Workflows]]
    
- [[10 Projetos/Sysvar/Contexto do Projeto/Riscos e Cuidados|Riscos e Cuidados]]