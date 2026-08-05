
---

type: adr  
status: approved  
project: Sysvar  
adr: 002  
created: 2026-08-05  
updated: 2026-08-05  
tags:

- sysvar
    
- adr
    
- arquitetura
    
- segurança
    
- desenvolvimento
    
- documentação
    

---

# ADR-002 - Princípios Arquiteturais do SISVAR

## Status

Aprovada.

Aplicável a todas as novas implementações, correções e revisões do SISVAR.

---

# Contexto

O SISVAR é um ERP SaaS multiempresa e multilojas voltado ao varejo de moda.

O sistema possui diversos módulos integrados, incluindo:

- administração;
    
- cadastros;
    
- produtos;
    
- compras;
    
- estoque;
    
- vendas;
    
- PDV;
    
- fiscal;
    
- financeiro;
    
- contabilidade;
    
- produção;
    
- distribuição;
    
- relatórios;
    
- dashboards;
    
- auditoria.
    

À medida que o sistema cresce, aumenta o risco de cada módulo implementar regras próprias de autenticação, autorização, isolamento de dados, auditoria, tratamento de erros e interface.

Isso poderia gerar:

- regras duplicadas;
    
- comportamentos inconsistentes;
    
- falhas de segurança;
    
- vazamento de dados entre empresas;
    
- dificuldade de manutenção;
    
- regressões;
    
- documentação desatualizada;
    
- dependência excessiva de conhecimento informal.
    

Por esse motivo, o projeto precisa possuir princípios arquiteturais oficiais e obrigatórios.

---

# Decisão

O desenvolvimento do SISVAR seguirá os princípios definidos nesta ADR.

Esses princípios devem orientar:

- novas funcionalidades;
    
- correções;
    
- refatorações;
    
- revisões de módulos;
    
- criação de APIs;
    
- criação de telas;
    
- alterações de banco;
    
- integrações;
    
- testes;
    
- documentação.
    

Nenhuma implementação poderá contrariar esses princípios sem que uma nova ADR seja criada para substituir ou complementar esta decisão.

---

# 1. Backend como autoridade final

O backend é a autoridade final para todas as regras críticas do sistema.

O frontend não pode ser responsável por decidir:

- permissões;
    
- módulo contratado;
    
- empresa do registro;
    
- loja permitida;
    
- contrato válido;
    
- limite de sessões;
    
- valores financeiros;
    
- movimentações de estoque;
    
- aprovação;
    
- cancelamento;
    
- emissão fiscal;
    
- regras contábeis;
    
- regras de auditoria.
    

O frontend pode antecipar validações para melhorar a experiência do usuário, mas o backend sempre deve validar novamente.

---

# 2. Segurança não depende da interface

Ocultar:

- menu;
    
- botão;
    
- campo;
    
- rota;
    
- ação;
    

não representa proteção suficiente.

Toda operação precisa ser protegida no backend.

Mesmo quando o usuário:

- manipula a URL;
    
- altera o JavaScript;
    
- envia requisição manual;
    
- modifica o payload;
    
- tenta acessar diretamente um endpoint;
    

o backend deve negar a operação quando ela não for permitida.

---

# 3. Default deny

Ausência de permissão significa acesso negado.

O sistema não deve liberar acesso com base em:

- tipo genérico de usuário;
    
- nome do perfil;
    
- role antiga;
    
- fallback permissivo;
    
- ausência de configuração;
    
- suposição.
    

O acesso somente é permitido quando existir autorização efetiva.

Níveis atuais:

- `NONE`;
    
- `VIEW`;
    
- `EDIT`.
    

---

# 4. Isolamento multiempresa obrigatório

Toda informação pertencente a um cliente deve estar associada à empresa correspondente.

O backend deve garantir que um usuário de uma empresa não consiga:

- listar dados de outra empresa;
    
- consultar registros de outra empresa;
    
- alterar dados de outra empresa;
    
- vincular objetos de outra empresa;
    
- enviar IDs de outra empresa no payload;
    
- utilizar perfil de outra empresa;
    
- utilizar loja de outra empresa;
    
- consultar sessões de outra empresa;
    
- acessar relatórios de outra empresa.
    

O frontend nunca pode determinar sozinho a empresa utilizada em uma operação.

Quando o usuário pertence a uma empresa, o backend deve aplicar ou validar a empresa automaticamente.

---

# 5. Isolamento por loja

Quando a operação depender de loja, o backend deve validar:

- se a loja pertence à empresa;
    
- se o usuário possui acesso à loja;
    
- se a loja é compatível com a operação;
    
- se o registro pertence à loja ou ao contexto permitido.
    

Apenas filtrar dados no frontend não é suficiente.

---

# 6. Contrato e módulos contratados

Toda empresa cliente depende de contrato válido.

O backend deve validar:

- empresa ativa;
    
- existência do contrato;
    
- status do contrato;
    
- data inicial;
    
- data final;
    
- módulo contratado;
    
- plano completo, quando aplicável.
    

Módulos não contratados devem permanecer bloqueados no frontend e no backend.

Relatórios específicos podem depender do módulo de relatórios e também do módulo de origem.

Exemplo:

```text
Relatório financeiro = Relatórios + Financeiro
```

---

# 7. Licenciamento por sessões simultâneas

O SISVAR utiliza licenciamento por sessões simultâneas ativas.

Usuários cadastrados ou ativos não consomem licença.

O consumo ocorre somente quando existe sessão autenticada e válida.

A implementação deve preservar:

- controle por empresa;
    
- concorrência transacional;
    
- token vinculado à sessão;
    
- `device_id`;
    
- heartbeat;
    
- timeout;
    
- logout;
    
- encerramento administrativo;
    
- revogação de token;
    
- isolamento de sessões por empresa.
    

A decisão completa está registrada em:

- [[10 Projetos/Sysvar/Decisões Técnicas/ADR-001 - Licenciamento por Sessões Simultâneas|ADR-001 - Licenciamento por Sessões Simultâneas]]
    

---

# 8. Serviços centrais

Regras transversais devem ser implementadas em serviços centrais.

Exemplos:

- autenticação;
    
- permissões efetivas;
    
- contratos;
    
- módulos;
    
- sessões;
    
- licenciamento;
    
- transferência de usuário master;
    
- auditoria;
    
- geração de documentos;
    
- movimentação de estoque;
    
- integrações.
    

Não criar cópias da mesma regra em vários serializers, views ou componentes.

Quando uma regra for utilizada por vários módulos, ela deve possuir uma única fonte principal.

---

# 9. Operações críticas devem ser transacionais

Operações que alterem múltiplos registros relacionados devem utilizar transação.

Exemplos:

- login ocupando a última sessão;
    
- transferência de master;
    
- aprovação de pedido;
    
- entrada de nota;
    
- movimentação de estoque;
    
- geração de financeiro;
    
- emissão fiscal;
    
- distribuição;
    
- produção;
    
- baixa financeira;
    
- cancelamentos;
    
- estornos.
    

Não registrar sucesso antes da confirmação da transação.

Quando necessário, utilizar:

```python
transaction.atomic()
```

e bloqueios como:

```python
select_for_update()
```

---

# 10. Auditoria centralizada

A auditoria deve ser uma infraestrutura transversal.

Não deve depender de cada módulo criar logs de forma diferente.

A arquitetura de auditoria deverá registrar, conforme o tipo de operação:

- empresa;
    
- loja;
    
- usuário;
    
- snapshots históricos do usuário;
    
- ação;
    
- categoria;
    
- resultado;
    
- severidade;
    
- objeto afetado;
    
- valores anteriores;
    
- valores posteriores;
    
- IP;
    
- user-agent;
    
- request ID;
    
- endpoint;
    
- método HTTP;
    
- data e hora.
    

Logs de auditoria devem ser imutáveis para usuários clientes.

Nunca registrar:

- senha;
    
- token;
    
- cookie;
    
- chave privada;
    
- certificado;
    
- segredo de API;
    
- Authorization header;
    
- dados sensíveis desnecessários.
    

---

# 11. Regras de negócio no domínio correto

Cada regra deve permanecer no módulo ou serviço responsável pelo domínio.

Exemplos:

- estoque controla saldo e movimentação;
    
- financeiro controla títulos e baixas;
    
- fiscal controla documentos e eventos fiscais;
    
- compras controla pedidos e recebimentos;
    
- produção controla ficha técnica e ordens;
    
- distribuição controla alocação entre unidades.
    

Um módulo pode chamar outro serviço, mas não deve duplicar a regra do outro domínio.

---

# 12. APIs devem ser aditivas e compatíveis

Sempre que possível, alterações de API devem preservar consumidores existentes.

Antes de alterar:

- endpoint;
    
- serializer;
    
- nome de campo;
    
- formato de resposta;
    
- status HTTP;
    

é obrigatório localizar:

- usos no frontend;
    
- testes;
    
- integrações;
    
- scripts;
    
- comandos;
    
- documentação.
    

Breaking changes inevitáveis devem ser documentadas.

---

# 13. Migrações seguras

Toda alteração de banco deve possuir migration.

Antes de criar migration, verificar:

- dados existentes;
    
- banco vazio;
    
- banco com produção;
    
- dependências;
    
- valores nulos;
    
- defaults;
    
- reversibilidade;
    
- constraints compatíveis com MySQL;
    
- impacto em serializers e services.
    

Data migrations devem usar:

```python
apps.get_model()
```

e evitar dependência direta de models atuais.

Não alterar banco de produção manualmente como substituto de migration.

---

# 14. Compatibilidade com MySQL

Recursos utilizados no Django devem ser conferidos quanto ao suporte real do MySQL.

Não confiar em constraints que o MySQL ignora.

Quando não houver suporte nativo, utilizar:

- estrutura alternativa;
    
- validação de aplicação;
    
- transação;
    
- serviço central;
    
- teste específico.
    

A garantia mais forte deve ser preferida.

---

# 15. Performance desde a implementação

Toda nova funcionalidade deve considerar:

- paginação;
    
- índices;
    
- `select_related`;
    
- `prefetch_related`;
    
- filtros obrigatórios;
    
- limites de consulta;
    
- prevenção de N+1;
    
- tamanho de payload;
    
- volume futuro.
    

Não carregar tabelas inteiras no frontend sem necessidade.

Operações de alto volume devem possuir estratégia adequada.

---

# 16. Tratamento de erros explícito

Não utilizar:

```python
except Exception:
    pass
```

como solução permanente.

Erros devem ser:

- registrados;
    
- classificados;
    
- tratados;
    
- retornados com mensagem segura;
    
- testados.
    

Falhas secundárias não devem necessariamente interromper a operação principal, mas também não podem ser ocultadas indefinidamente.

---

# 17. Dados sensíveis

Nunca expor ou registrar sem necessidade:

- senha;
    
- token;
    
- cookies;
    
- chaves privadas;
    
- certificados digitais;
    
- client secret;
    
- credenciais bancárias;
    
- dados completos de cartão;
    
- documentos pessoais completos;
    
- XMLs integrais sem necessidade.
    

Serializers devem impedir mass assignment de campos críticos.

Usuários clientes nunca podem alterar:

- `is_staff`;
    
- `is_superuser`;
    
- grupos internos do Django;
    
- permissões internas do Django;
    
- empresa;
    
- usuário master;
    
- campos de controle da plataforma.
    

---

# 18. Padrão visual obrigatório

As telas do SISVAR devem seguir o padrão visual definido:

1. Barra Principal.
    
2. Barra do Título.
    
3. Barra de Indicadores.
    
4. Barra de Filtros.
    
5. Barra de Ações.
    
6. Área de Resultados.
    

As barras devem ser configuráveis conforme a necessidade da tela.

Botões inexistentes para determinada funcionalidade devem ser ocultados.

A área de resultados deve preservar:

- seleção;
    
- paginação;
    
- quantidade de registros;
    
- indicação de intervalo;
    
- ações coerentes.
    

---

# 19. Angular 17 standalone

O frontend do SISVAR utiliza Angular 17 standalone.

Novos componentes devem respeitar esse padrão.

Não introduzir `NgModule` sem justificativa arquitetural aprovada.

A lógica de autenticação, sessão e permissões deve permanecer centralizada em services e guards.

---

# 20. Testes obrigatórios

Toda implementação deve possuir testes proporcionais ao seu risco.

Tipos de teste:

- unitário;
    
- integração;
    
- API;
    
- banco;
    
- concorrência;
    
- frontend;
    
- regressão;
    
- validação manual.
    

Não afirmar que testes passaram sem executá-los.

O comando geral de testes deve realmente descobrir e executar testes.

---

# 21. Revisão técnica obrigatória

A resposta do Codex não será considerada prova suficiente de conclusão.

Após a implementação, deve ser realizada revisão do código real commitado.

A revisão deve verificar:

- aderência à regra de negócio;
    
- segurança;
    
- multiempresa;
    
- permissões;
    
- transações;
    
- migrations;
    
- frontend;
    
- testes;
    
- riscos;
    
- regressões.
    

---

# 22. Documentação obrigatória

Nenhuma funcionalidade será considerada concluída sem atualização do Obsidian.

A documentação deve refletir o que foi realmente implementado.

Não documentar como concluído algo que esteja apenas planejado.

Documentos que podem precisar de atualização:

- página principal do projeto;
    
- arquitetura;
    
- modelo de domínio;
    
- workflows;
    
- riscos;
    
- mapa técnico;
    
- módulo correspondente;
    
- changelog;
    
- ADR.
    

---

# 23. ADRs obrigatórias para decisões relevantes

Toda decisão arquitetural com impacto duradouro deverá gerar uma ADR.

Uma ADR deve registrar:

- contexto;
    
- problema;
    
- decisão;
    
- alternativas;
    
- consequências;
    
- riscos;
    
- situação da implementação.
    

Não alterar silenciosamente uma decisão aprovada.

Quando uma decisão mudar, criar nova ADR que substitua a anterior.

---

# 24. Processo oficial de desenvolvimento

Toda tarefa seguirá este fluxo:

1. Definição funcional.
    
2. Análise arquitetural.
    
3. Verificação do código atual.
    
4. Prompt de implementação.
    
5. Implementação pelo Codex.
    
6. Testes técnicos.
    
7. Testes funcionais.
    
8. Revisão técnica.
    
9. Correções.
    
10. Atualização do Obsidian.
    
11. Criação ou atualização de ADR.
    
12. Commit do código.
    
13. Commit da documentação.
    

Uma tarefa somente será considerada encerrada quando os itens aplicáveis forem concluídos.

---

# 25. Papéis no projeto

## Dono do produto

Responsável por:

- regras de negócio;
    
- prioridades;
    
- validação funcional;
    
- decisão comercial;
    
- aprovação final.
    

## Codex

Responsável por:

- implementação;
    
- refatoração;
    
- correções;
    
- testes técnicos;
    
- migrations;
    
- compilação;
    
- relatório de alterações.
    

## Arquitetura e revisão

Responsável por:

- arquitetura;
    
- segurança;
    
- consistência;
    
- revisão técnica;
    
- riscos;
    
- prompts;
    
- documentação;
    
- ADRs;
    
- organização do Vault.
    

---

# Consequências

## Positivas

- maior segurança;
    
- menor risco de vazamento entre empresas;
    
- menos regras duplicadas;
    
- melhor manutenção;
    
- onboarding mais rápido;
    
- documentação confiável;
    
- evolução modular;
    
- redução de regressões;
    
- melhor controle técnico do produto.
    

## Negativas

- tarefas exigem mais revisão;
    
- documentação precisa ser atualizada;
    
- decisões importantes demandam ADR;
    
- implementações rápidas podem exigir mais disciplina;
    
- algumas mudanças necessitam refatoração antes de continuar.
    

Esses custos são aceitos porque reduzem riscos maiores no futuro.

---

# Resultado

Esta ADR passa a definir os princípios oficiais de desenvolvimento do SISVAR.

Novos módulos, correções e refatorações devem seguir estas regras.

Qualquer exceção relevante deverá ser documentada e aprovada por nova ADR.

---

# Notas relacionadas

- [[10 Projetos/Sysvar/Sysvar|Sysvar]]
    
- [[10 Projetos/Sysvar/Contexto do Projeto/Arquitetura|Arquitetura]]
    
- [[10 Projetos/Sysvar/Contexto do Projeto/Modelo de Domínio|Modelo de Domínio]]
    
- [[10 Projetos/Sysvar/Contexto do Projeto/Workflows|Workflows]]
    
- [[10 Projetos/Sysvar/Contexto do Projeto/Riscos e Cuidados|Riscos e Cuidados]]
    
- [[10 Projetos/Sysvar/Decisões Técnicas/ADR-001 - Licenciamento por Sessões Simultâneas|ADR-001 - Licenciamento por Sessões Simultâneas]]