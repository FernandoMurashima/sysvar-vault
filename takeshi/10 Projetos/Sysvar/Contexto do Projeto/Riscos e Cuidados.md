---

type: reference  
status: active  
project: Sysvar  
source: "C:/SysvarProjeto"  
created: 2026-08-03  
updated: 2026-08-04  
tags:

- sysvar
    
- riscos
    
- arquitetura
    

---

# Riscos e Cuidados

## Objetivo

Este documento reúne os principais riscos técnicos e funcionais identificados durante o desenvolvimento do SISVAR.

Ele serve como guia para evitar regressões, falhas de segurança e inconsistências entre módulos.

Sempre que uma nova arquitetura ou regra importante for criada, este documento deverá ser revisado.

---

# Multiempresa

## Isolamento de dados

Todo registro pertence obrigatoriamente a uma empresa.

Jamais confiar:

- parâmetros enviados pelo frontend;
    
- IDs informados pela URL;
    
- filtros enviados pelo usuário.
    

O backend sempre deve validar se o usuário pertence à empresa proprietária dos dados.

---

## Consultas

Todo queryset deve ser filtrado pela empresa do usuário.

A ausência desse filtro pode permitir vazamento de informações entre clientes.

---

# Autenticação

Toda autenticação deve passar pelos serviços centrais.

É proibido criar autenticação paralela em qualquer módulo.

Toda validação deve considerar:

- usuário;
    
- empresa;
    
- contrato;
    
- perfil;
    
- módulos contratados;
    
- sessão;
    
- permissões efetivas.
    

---

# Sessões simultâneas

## Consumo de licença

Licença não é consumida por usuário cadastrado.

Licença é consumida exclusivamente por sessão ativa.

Jamais utilizar quantidade de usuários ativos para controlar licenciamento.

---

## Concorrência

Dois logins simultâneos podem disputar a última vaga disponível.

O controle deve permanecer protegido por transação.

Nunca contar sessões fora da transação responsável pela criação da nova sessão.

---

## Timeout

Sessões abandonadas não podem permanecer ocupando acessos simultâneos indefinidamente.

O timeout deve sempre liberar a licença.

---

## Mesmo dispositivo

Quando o mesmo usuário autenticar novamente utilizando o mesmo dispositivo:

- a sessão anterior deve ser encerrada;
    
- o token anterior deve ser revogado;
    
- apenas uma sessão deve permanecer ativa.
    

---

## Tokens

Nunca armazenar tokens em texto puro.

Persistir apenas o hash.

Sempre invalidar tokens revogados.

Nunca aceitar token sem sessão válida.

---

# Permissões

O frontend nunca define permissões.

Menus ocultos não representam segurança.

Toda autorização deve ser novamente validada pelo backend.

---

# Contratos

Toda autenticação depende de contrato válido.

Sempre validar:

- existência;
    
- vigência;
    
- situação;
    
- módulos contratados.
    

---

# Usuário Master

Cada empresa possui apenas um usuário master.

Antes de excluir ou inativar um master deve existir transferência para outro usuário.

---

# Módulos

Nunca permitir acesso apenas porque existe uma rota no frontend.

O backend deve validar:

- módulo contratado;
    
- permissão do usuário;
    
- empresa;
    
- contrato.
    

---

# Auditoria

Toda operação crítica deverá gerar auditoria.

Especial atenção para:

- login;
    
- logout;
    
- encerramento de sessão;
    
- alteração de permissões;
    
- alteração de contratos;
    
- alteração de usuários;
    
- exclusões;
    
- aprovações;
    
- cancelamentos;
    
- alterações financeiras;
    
- alterações fiscais.
    

---

# Banco de Dados

Toda alteração estrutural deve possuir migration.

Nunca alterar banco manualmente em produção.

---

# Performance

Evitar:

- consultas sem índices;
    
- N+1 queries;
    
- joins desnecessários;
    
- atualização excessiva de sessão.
    

Heartbeat deve atualizar a última atividade apenas quando necessário.

---

# Frontend

O frontend é responsável apenas por:

- interface;
    
- experiência do usuário;
    
- navegação;
    
- validações simples.
    

Toda regra crítica pertence ao backend.

---

# Segurança

Nunca confiar em:

- JavaScript;
    
- LocalStorage;
    
- SessionStorage;
    
- parâmetros enviados pelo navegador.
    

Tudo deve ser validado novamente no servidor.

---

# Integração entre módulos

Uma alteração em um módulo pode afetar:

- financeiro;
    
- estoque;
    
- fiscal;
    
- auditoria;
    
- dashboards;
    
- relatórios.
    

Toda alteração relevante deve ser testada de forma integrada.

---

# Documentação

Nenhuma funcionalidade será considerada concluída sem:

- implementação;
    
- testes;
    
- revisão técnica;
    
- atualização do Obsidian;
    
- versionamento da documentação.
    

A documentação deve refletir exatamente o comportamento implementado.

---

# Situação atual

Riscos mitigados:

- isolamento multiempresa;
    
- autenticação centralizada;
    
- permissões efetivas;
    
- contratos;
    
- módulos contratados;
    
- licenciamento por sessões simultâneas;
    
- heartbeat;
    
- timeout;
    
- encerramento administrativo de sessões.
    

Próximo risco a ser tratado:

Implementação da auditoria central para garantir rastreabilidade completa das operações críticas.

---

# Notas relacionadas

- [[10 Projetos/Sysvar/Sysvar|Sysvar]]
    
- [[10 Projetos/Sysvar/Contexto do Projeto/Arquitetura|Arquitetura]]
    
- [[10 Projetos/Sysvar/Contexto do Projeto/Modelo de Domínio|Modelo de Domínio]]
    
- [[10 Projetos/Sysvar/Contexto do Projeto/Workflows|Workflows]]