---
type: reference
status: active
project: Webfoto
source: "C:/webfoto"
created: 2026-07-29
updated: 2026-07-29
tags:
  - webfoto
  - contexto
  - negocio
---

# Visão Geral

## Negócio

O Webfoto é uma plataforma para a fotógrafa Mayara Murashima apresentar seu trabalho, receber pedidos de orçamento e entregar fotos de ensaios por uma área exclusiva para clientes.

## Usuários

- Visitante: navega pelo portfólio, páginas institucionais e formulário de orçamento.
- Administrador: cria álbuns/pastas, envia fotos ou ZIP pronto, cria usuários clientes, publica ou retira publicação de álbuns.
- Cliente: entra com login e senha, visualiza sua pasta liberada e baixa fotos ou ZIP.

## Capacidades atuais

- Site público em Angular com páginas de home, sobre, trabalhos, orçamento, contato e área de fotos.
- Área de fotos com painel de cliente e painel administrativo.
- Backend Node/Express com autenticação por token simples, persistência MySQL, upload de imagens, upload de ZIP em chunks, geração de ZIP e download protegido.
- Deploy em containers Docker com frontend `webfoto`, backend `webfoto-api` e MySQL.

## Fonte do projeto

- Código-fonte: `C:\webfoto`
- Contexto do cofre: [[Webfoto]]
- Runbook de produção: [[Atualização da Produção]]

## Última atualização

2026-07-29

## Limitações do contexto

Este resumo foi derivado de inventário estático e leitura seletiva dos arquivos principais. Não substitui leitura do código quando a mudança tocar segurança, upload, banco de dados ou deploy.
