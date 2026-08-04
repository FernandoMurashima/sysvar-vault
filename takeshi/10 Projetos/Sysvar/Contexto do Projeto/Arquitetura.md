---

type: reference  
status: active  
project: Sysvar  
source: "C:/SysvarProjeto"  
created: 2026-08-03  
updated: 2026-08-04  
tags:

- sysvar
    
- arquitetura
    

---

# Arquitetura

## Objetivo

A arquitetura do SISVAR foi projetada para suportar um ERP SaaS voltado ao varejo de moda, com foco em segurança, isolamento entre empresas, escalabilidade e modularização.

Toda decisão arquitetural busca garantir que novos módulos possam ser adicionados sem comprometer os existentes.

---

# Princípios da arquitetura

O sistema é baseado nos seguintes princípios:

- isolamento completo entre empresas;
    
- autenticação centralizada;
    
- autorização por permissões efetivas;
    
- arquitetura modular;
    
- regras de negócio concentradas no backend;
    
- frontend como camada de apresentação;
    
- auditoria de operações críticas;
    
- documentação técnica versionada.
    

---

# Arquitetura lógica

O sistema é dividido em quatro grandes camadas.

## Frontend

Responsável por:

- interface do usuário;
    
- navegação;
    
- componentes;
    
- formulários;
    
- dashboards;
    
- experiência do usuário.
    

Tecnologia:

- Angular 17 Standalone.
    

O frontend nunca é responsável por decidir permissões.

Menus, botões e telas são ocultados conforme as permissões efetivas, porém toda autorização é novamente validada pelo backend.

---

## Backend

Responsável por:

- autenticação;
    
- autorização;
    
- regras de negócio;
    
- validações;
    
- integrações;
    
- APIs REST;
    
- auditoria;
    
- isolamento entre empresas.
    

Tecnologia:

- Django;
    
- Django REST Framework.
    

Toda regra crítica permanece exclusivamente no backend.

---

## Banco de dados

Tecnologia principal:

- MySQL.
    

Responsável por:

- persistência;
    
- integridade referencial;
    
- índices;
    
- histórico;
    
- contratos;
    
- sessões;
    
- auditoria.
    

---

## Documentação

Toda decisão arquitetural deve ser refletida no Vault do Obsidian.

Nenhuma funcionalidade é considerada concluída sem atualização da documentação técnica.

---

# Multiempresa

O SISVAR é multiempresa desde sua fundação.

Cada empresa possui:

- usuários;
    
- lojas;
    
- contratos;
    
- módulos;
    
- perfis;
    
- permissões;
    
- sessões;
    
- dados completamente isolados.
    

Nenhum usuário pode acessar registros pertencentes a outra empresa.

Esse isolamento é obrigatório mesmo quando parâmetros são manipulados manualmente.

---

# Contratos

Cada empresa possui um contrato ativo.

O contrato controla:

- situação;
    
- vigência;
    
- módulos contratados;
    
- quantidade de acessos simultâneos;
    
- versão das permissões.
    

Todas essas validações acontecem durante a autenticação.

---

# Módulos

O sistema possui arquitetura modular.

Cada funcionalidade pertence a um módulo do sistema.

O contrato determina quais módulos ficam disponíveis para cada empresa.

Consequências:

- menus ocultados;
    
- rotas protegidas;
    
- endpoints protegidos;
    
- operações bloqueadas quando o módulo não foi contratado.
    

Mesmo que uma chamada seja feita diretamente à API, o backend valida o módulo antes da execução.

---

# Usuários

Existem dois grandes grupos de usuários.

## Superusuário da plataforma

Possui acesso administrativo global.

Pode:

- administrar empresas;
    
- administrar contratos;
    
- administrar módulos;
    
- consultar sessões;
    
- realizar manutenção da plataforma.
    

Não está sujeito ao limite de acessos simultâneos das empresas.

---

## Usuários das empresas

Pertencem exatamente a uma empresa.

São classificados como:

- usuário master;
    
- usuários comuns.
    

O usuário master administra:

- usuários;
    
- perfis;
    
- permissões;
    
- sessões da própria empresa.
    

---

# Perfis e permissões

As permissões são calculadas pelo backend.

O acesso efetivo considera:

- empresa;
    
- contrato;
    
- módulos contratados;
    
- perfil principal;
    
- permissões adicionais;
    
- situação do usuário.
    

O frontend apenas utiliza esse resultado para montar a interface.

---

# Autenticação

Toda autenticação é centralizada.

O login valida:

- usuário;
    
- senha;
    
- situação do usuário;
    
- empresa;
    
- contrato;
    
- perfil;
    
- limite de acessos simultâneos.
    

Quando aprovado:

- uma sessão é criada;
    
- um token é emitido;
    
- o token fica vinculado à sessão.
    

---

# Sessões simultâneas

O licenciamento do SISVAR utiliza sessões simultâneas.

Princípios:

- usuário cadastrado não consome licença;
    
- usuário ativo não consome licença;
    
- somente sessão ativa consome licença;
    
- logout libera licença;
    
- timeout libera licença;
    
- encerramento administrativo libera licença.
    

O mesmo usuário pode possuir mais de uma sessão quando utiliza dispositivos diferentes.

Cada sessão ativa corresponde a um acesso simultâneo.

---

# Segurança

A segurança está baseada em múltiplas validações.

Cada requisição autenticada verifica:

- token;
    
- sessão;
    
- usuário;
    
- empresa;
    
- contrato;
    
- permissões;
    
- módulo solicitado.
    

A ocultação de telas no frontend nunca substitui as validações do backend.

---

# Auditoria

A arquitetura prevê uma camada única de auditoria.

Toda operação crítica deverá registrar:

- usuário;
    
- empresa;
    
- data e hora;
    
- operação;
    
- entidade afetada;
    
- valores alterados;
    
- endereço IP;
    
- dispositivo quando aplicável.
    

A implementação completa da auditoria será o próximo grande módulo do sistema.

---

# Escalabilidade

A arquitetura foi desenhada para permitir crescimento contínuo.

Novos módulos devem seguir o mesmo padrão de:

- autenticação;
    
- autorização;
    
- auditoria;
    
- isolamento;
    
- padronização visual;
    
- documentação.
    

Nenhum módulo deve implementar mecanismos próprios de autenticação ou controle de acesso.

---

# Tecnologias

Backend

- Python
    
- Django
    
- Django REST Framework
    

Frontend

- Angular 17 Standalone
    
- TypeScript
    

Banco de Dados

- MySQL
    

Versionamento

- Git
    
- GitHub
    

Documentação

- Obsidian
    

---

# Situação atual da arquitetura

Implementado e validado:

- autenticação centralizada;
    
- isolamento multiempresa;
    
- contratos;
    
- módulos contratados;
    
- usuário master;
    
- perfis de acesso;
    
- permissões efetivas;
    
- sessões simultâneas;
    
- licenciamento por sessões;
    
- heartbeat;
    
- timeout;
    
- encerramento de sessões;
    
- proteção de endpoints.
    

Próxima evolução arquitetural:

- módulo central de Auditoria.
    

---

# Notas relacionadas

- [[10 Projetos/Sysvar/Sysvar|Sysvar]]
    
- [[10 Projetos/Sysvar/Contexto do Projeto/Modelo de Domínio|Modelo de Domínio]]
    
- [[10 Projetos/Sysvar/Contexto do Projeto/Workflows|Workflows]]
    
- [[10 Projetos/Sysvar/Contexto do Projeto/Riscos e Cuidados|Riscos e Cuidados]]
    
- [[10 Projetos/Sysvar/Contexto do Projeto/Mapa Técnico|Mapa Técnico]]