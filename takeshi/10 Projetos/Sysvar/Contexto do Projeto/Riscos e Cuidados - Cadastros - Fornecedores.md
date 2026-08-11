# Riscos e Cuidados - Cadastros - Fornecedores

## 1. Identificação

- **Projeto:** Sysvar
- **Módulo:** Cadastros
- **Funcionalidade:** Fornecedores
- **Escopo:** Fase 1 — Cadastro e Gestão Operacional
- **Situação:** IMPLEMENTADO E HOMOLOGADO
- **Homologação manual:** 30/30 itens aprovados

---

# 2. Objetivo

Este documento registra riscos técnicos, funcionais, operacionais e de evolução relacionados ao cadastro de Fornecedores.

Ele deve ser consultado antes de qualquer alteração relevante em:

- models;
- serializers;
- views;
- endpoints;
- permissões;
- frontend;
- compras;
- financeiro;
- produção/facção;
- auditoria;
- migrations.

O objetivo é evitar regressões em regras já homologadas.

---

# 3. Risco — Quebra de Isolamento Multiempresa

Este é um dos riscos mais críticos.

Fornecedor pertence obrigatoriamente a uma empresa.

Nunca confiar apenas em IDs recebidos do frontend.

Devem ser validados no backend:

- fornecedor;
- prazo;
- conta contábil;
- natureza financeira;
- contato;
- endereço;
- compra;
- título financeiro.

Risco:

um usuário da Empresa A conseguir referenciar ou visualizar entidade da Empresa B.

Impacto:

**CRÍTICO**

Cuidados:

- sempre filtrar por empresa;
- validar FKs recebidas;
- criar testes de tentativa cruzada;
- nunca confiar apenas em filtros do frontend.

---

# 4. Risco — Documento Globalmente Único

A regra correta é:

`empresa + documento`

Não transformar CPF/CNPJ em unicidade global.

Risco:

impedir que empresas diferentes cadastrem o mesmo fornecedor.

Impacto:

**ALTO**

Regra preservada:

- mesmo documento pode existir em empresas diferentes;
- não pode repetir dentro da mesma empresa.

---

# 5. Risco — Tornar Documento Obrigatório

Fornecedor sem documento é permitido por regra de negócio.

Risco:

alguma futura tela ou serializer passar a exigir CPF/CNPJ.

Impacto:

**ALTO**

Consequências:

- quebra do cadastro simplificado;
- quebra de compras com fornecedores ainda sem documentação completa;
- incompatibilidade com a homologação.

Cuidados:

- documento deve continuar opcional;
- quando informado, deve ser validado.

---

# 6. Risco — Documento Artificial

Não criar CPF/CNPJ fictício para fornecedor sem documento.

Risco:

- colisão;
- inconsistência fiscal;
- registros falsos;
- problemas futuros com integrações.

Impacto:

**ALTO**

Regra:

fornecedor sem documento deve permanecer com documento nulo.

---

# 7. Risco — Duplicidade por Nome como Bloqueio

Nome semelhante é apenas aviso.

Não transformar em regra rígida.

Risco:

impedir cadastro de fornecedores legítimos com nomes parecidos.

Impacto:

**MÉDIO**

Regra:

- CPF/CNPJ = regra rígida;
- nome/apelido = alerta não bloqueante.

---

# 8. Risco — Voltar para Categoria Única

O fornecedor pode ter múltiplas categorias.

Estrutura funcional:

`FornecedorCategoria`

Risco:

alguma futura implementação usar somente o campo legado `categoria`.

Impacto:

**ALTO**

Consequência:

perda de classificação múltipla.

Cuidados:

- preferir estrutura normalizada;
- manter legado apenas por compatibilidade.

---

# 9. Risco — Usar Categoria como Bloqueio Universal

Categoria deve servir principalmente para:

- classificação;
- filtro;
- priorização;
- contexto.

Risco:

transformar toda categoria em autorização rígida.

Impacto:

**MÉDIO**

Exemplo incorreto:

Fornecedor não é REVENDA → bloquear qualquer compra universalmente.

O bloqueio só deve existir quando a operação realmente exigir aquela categoria.

---

# 10. Risco — Perda de Contatos Históricos

Contatos podem ser inativados.

Não excluir automaticamente contatos antigos.

Risco:

perder histórico de relacionamento.

Impacto:

**MÉDIO**

Regra:

preferir inativação.

---

# 11. Risco — Mais de um Contato Principal por Tipo

Regra:

somente um contato ativo principal por tipo.

Risco:

concorrência ou atualização parcial gerar dois principais.

Impacto:

**ALTO**

Cuidados:

- manter transação;
- revisar select_for_update quando necessário;
- preservar testes de concorrência lógica.

---

# 12. Risco — Mais de um Endereço Principal por Tipo

Regra equivalente aos contatos.

Impacto:

**ALTO**

Cuidados:

- manter alteração transacional;
- evitar lógica somente no frontend;
- garantir consistência no backend.

---

# 13. Risco — Validação de Telefone por Máscara

Problema já ocorreu.

Validação antiga dependia de formato rígido.

Isso fazia o botão parecer não funcionar.

Risco:

reintroduzir regex baseada em pontuação.

Impacto:

**MÉDIO**

Regra correta:

- validar apenas quantidade de dígitos;
- 10 ou 11 dígitos;
- máscara apenas visual.

---

# 14. Risco — Retorno Silencioso em Formulário Inválido

Outro problema já identificado.

Evitar padrões como:

~~~text
if (form.invalid) return;
~~~

sem feedback.

Risco:

usuário clicar Salvar e nada acontecer.

Impacto:

**MÉDIO**

Cuidados:

- markAllAsTouched;
- apresentar mensagens claras;
- nunca ocultar erro de validação.

---

# 15. Risco — Exposição de Dados Bancários

Dados bancários são sensíveis.

Risco:

frontend esconder dados, mas API continuar retornando.

Impacto:

**CRÍTICO**

Regra:

a proteção deve ocorrer no backend.

Permissão:

`fornecedor.dados_bancarios`

Usuário não autorizado não deve receber valores sensíveis.

---

# 16. Risco — Registrar Dados Bancários em AuditLog

Auditoria não deve virar cópia dos dados bancários.

Risco:

- exposição;
- retenção indevida;
- vazamento por consulta de logs.

Impacto:

**CRÍTICO**

Cuidados:

- registrar ação;
- não registrar valores sensíveis completos.

---

# 17. Risco — Usuário sem Permissão Editar Dados Bancários

Mesmo que campos apareçam vazios, usuário sem permissão não deve conseguir alterá-los via API.

Impacto:

**CRÍTICO**

Cuidados:

- validar permissão no serializer/view;
- ignorar/rejeitar payload indevido;
- testar manipulação direta.

---

# 18. Risco — UX Bancária Confusa

Situação homologada:

usuário sem permissão pode ver os campos vazios.

Isso é seguro, mas pode gerar dúvida.

Impacto:

**BAIXO**

Melhoria futura:

- ocultar seção;
- ou mostrar “Dados bancários — acesso restrito”.

Não é falha de segurança.

---

# 19. Risco — Banco como Texto Livre

Banco ainda não é estruturado.

Risco:

variações como:

- Itaú;
- Itau;
- Banco Itaú;
- 341.

Impacto:

**MÉDIO**

Pendência futura:

cadastro oficial de bancos.

Não tentar resolver parcialmente sem definir padrão.

---

# 20. Risco — Escolha Errada do Identificador Bancário

Na futura integração BACEN, não assumir automaticamente que apenas COMPE ou apenas ISPB resolve todos os casos.

Impacto:

**MÉDIO**

Cuidados:

- avaliar fonte oficial;
- definir estratégia;
- documentar identificador interno.

---

# 21. Risco — Validação Incompleta de IE

Inscrição Estadual não possui validação por UF.

Isso é conhecido e aceito nesta fase.

Impacto atual:

**BAIXO/MÉDIO**

Não adicionar validação genérica incorreta.

Uma validação errada pode ser pior que nenhuma.

---

# 22. Risco — Validação Municipal Genérica

Inscrição Municipal varia por município.

Não criar regra nacional fictícia.

Impacto:

**MÉDIO**

Quando priorizado:

avaliar abrangência e custo-benefício.

---

# 23. Risco — Remover Campo Legado Prematuramente

Campos legados:

- `cnpj`
- `categoria`
- `prazo_padrao_pagamento`
- `conta_contabil`

Risco:

quebrar partes antigas do sistema.

Impacto:

**ALTO**

Cuidados:

1. pesquisar dependências;
2. migrar consumidores;
3. testar;
4. só depois remover.

---

# 24. Risco — Usar Campo Legado como Fonte Principal

O risco inverso também existe.

Não continuar expandindo funcionalidades em cima dos campos legados quando já existe estrutura normalizada.

Preferir:

- `documento`;
- `FornecedorCategoria`;
- `prazo_padrao_pagamento_ref`;
- `conta_contabil_padrao`.

---

# 25. Risco — Prazo de Outra Empresa

`prazo_padrao_pagamento_ref`

deve pertencer à mesma empresa.

Impacto:

**ALTO**

Não confiar apenas no select frontend.

Backend deve rejeitar ID cruzado.

---

# 26. Risco — Conta Contábil de Outra Empresa

Mesmo risco.

Impacto:

**CRÍTICO**

Além da empresa, a conta deve ser:

- ativa;
- analítica.

---

# 27. Risco — Conta Sintética como Padrão

Conta sintética não deve ser usada para lançamentos operacionais.

Impacto:

**ALTO**

Cuidados:

filtrar e validar `analitica = true`.

---

# 28. Risco — Natureza Financeira de Outra Empresa

Natureza deve pertencer à mesma empresa.

Impacto:

**ALTO**

Além disso, deve estar ativa.

---

# 29. Risco — Transformar Padrões em Travamentos

Prazo, natureza e conta contábil são padrões sugeridos.

Risco:

travar uma operação inteira por causa do padrão cadastrado.

Impacto:

**MÉDIO**

Regra:

o contexto operacional decide se o valor pode ser alterado.

---

# 30. Risco — Fornecedor Inativo Disponível em Nova Operação

Fornecedor inativo não pode participar de nova operação.

Impacto:

**ALTO**

Proteção deve existir:

- frontend;
- backend.

---

# 31. Risco — Fornecedor Bloqueado Disponível em Nova Operação

Mesma criticidade.

Impacto:

**ALTO**

Mesmo que o frontend o esconda, backend deve rejeitar ID enviado manualmente.

---

# 32. Risco — Misturar Inativo com Bloqueado

São estados diferentes.

Inativo:

decisão de lifecycle.

Bloqueado:

restrição administrativa/operacional.

Risco:

usar um único campo para representar ambos.

Impacto:

**MÉDIO**

Preservar separação.

---

# 33. Risco — Alteração Direta de Lifecycle

Não transformar:

- ativo;
- bloqueio;

em simples checkboxes livres.

Impacto:

**ALTO**

Utilizar ações controladas:

- Ativar;
- Inativar;
- Bloquear;
- Desbloquear.

---

# 34. Risco — Bloqueio sem Motivo

Bloqueio deve manter contexto.

Impacto:

**MÉDIO**

Preservar:

- motivo;
- observação;
- usuário;
- timestamp.

---

# 35. Risco — Exclusão de Fornecedor com Histórico

Fornecedor vinculado não deve ser apagado.

Impacto:

**CRÍTICO**

Pode quebrar:

- compras;
- títulos;
- notas;
- produção;
- facção;
- auditoria.

Regra:

usar inativação.

---

# 36. Risco — Dependências não Mapeadas na Exclusão

Conforme novos módulos forem surgindo, novas dependências podem precisar ser adicionadas à proteção de exclusão.

Impacto:

**ALTO**

Ao criar módulo que referencia fornecedor:

avaliar imediatamente a exclusão protegida.

---

# 37. Risco — Indicadores Calculados no Frontend

Os indicadores comerciais devem vir do backend.

Impacto:

**ALTO**

Risco de:

- cálculo divergente;
- paginação incompleta;
- filtros incorretos;
- dados parciais.

---

# 38. Risco — Compra Cancelada no Total Comprado

Não incluir operações canceladas.

Impacto:

**ALTO**

Mesma regra para:

- quantidade;
- ticket médio;
- última compra.

---

# 39. Risco — Pedido Aberto como Compra Concluída

Pedido aberto/rascunho não deve aumentar indicadores de compras realizadas.

Impacto:

**ALTO**

Distinguir intenção de compra de compra efetivamente válida.

---

# 40. Risco — Ticket Médio com Divisão por Zero

Quando não houver compras:

não dividir por zero.

Impacto:

**BAIXO**

Mas pode quebrar API/consulta.

---

# 41. Risco — Saldo a Pagar Incorreto

Saldo deve representar apenas valor aberto real.

Impacto:

**CRÍTICO**

Não incluir:

- títulos cancelados;
- parcelas já pagas integralmente.

Pagamento parcial:

somente saldo restante.

---

# 42. Risco — Confundir Histórico Financeiro com Saldo

Título pago continua histórico, mas saldo zero.

Impacto:

**ALTO**

Não remover título pago apenas para simplificar a consulta.

---

# 43. Risco — Dados Financeiros de Outra Empresa

A aba Financeiro deve respeitar empresa.

Impacto:

**CRÍTICO**

Nunca consultar apenas por `fornecedor_id` sem empresa.

---

# 44. Risco — Compras de Outra Empresa

Mesma regra para aba Compras.

Impacto:

**CRÍTICO**

---

# 45. Risco — Auditoria Incompleta

Eventos administrativos importantes devem ser auditados.

Impacto:

**ALTO**

Eventos relevantes:

- bloquear;
- desbloquear;
- inativar;
- reativar;
- alterações de contato/endereço;
- mudanças de principal;
- exclusão negada quando aplicável.

---

# 46. Risco — AuditLog sem Contexto

Registrar apenas “UPDATE” pode ser pouco útil.

Impacto:

**MÉDIO**

O evento deve permitir entender:

- entidade;
- ação;
- usuário;
- data;
- contexto mínimo.

Sem expor dados sensíveis.

---

# 47. Risco — Consulta Exigir EDIT

Problema já ocorreu em contatos/endereço.

Leitura não deve exigir permissão de edição.

Impacto:

**ALTO**

Regra:

VIEW deve permitir consulta das informações autorizadas.

---

# 48. Risco — Permissões Amplas Demais

Não conceder permissão de edição só para permitir lookup.

Impacto:

**ALTO**

Prazos, naturezas e plano contábil devem poder ser consultados para seleção sem necessariamente conceder manutenção desses cadastros.

---

# 49. Risco — Lookup Carregar Milhares de Registros

Evitar estratégias como:

`page_size=2000`

Impacto:

**MÉDIO/ALTO**

À medida que base cresce:

- latência;
- memória;
- tráfego;
- UX.

Preferir:

- busca server-side;
- autocomplete;
- paginação.

---

# 50. Risco — Paginação Client-Side Reintroduzida

Lista de fornecedores é server-side.

Não voltar a carregar tudo e paginar no navegador.

Impacto:

**ALTO**

---

# 51. Risco — Filtro Client-Side sobre Página Parcial

Se backend retorna 20 registros, filtrar esses 20 localmente não representa a base inteira.

Impacto:

**ALTO**

Filtros principais devem ir ao backend.

---

# 52. Risco — Duplicar Cadastros Auxiliares

Não criar novos cadastros de:

- prazo;
- plano contábil;
- natureza;

só para fornecedores.

Impacto:

**ALTO**

Reutilizar entidades já existentes.

---

# 53. Risco — Migration sem Compatibilidade

Alterações em Fornecedor podem afetar base existente.

Impacto:

**ALTO**

Antes de migration:

- revisar dados antigos;
- preservar nullability quando necessário;
- avaliar data migration;
- executar `makemigrations --check`.

---

# 54. Risco — Migration não Aplicada em Produção

Ao criar migration nova:

garantir que ela faça parte do processo de deploy.

Impacto:

**CRÍTICO**

Frontend novo contra backend sem migration pode falhar.

---

# 55. Risco — Alteração Backend sem Atualizar Frontend

Campos estruturados dependem de contratos claros.

Impacto:

**ALTO**

Exemplos:

- `prazo_padrao_pagamento_ref`
- `conta_contabil_padrao`
- descrições amigáveis.

---

# 56. Risco — Alteração Frontend sem Compatibilidade de API

Mesmo risco inverso.

Não enviar campos arbitrários que backend não conhece.

---

# 57. Risco — Exibir IDs ao Usuário

Usuário não deve precisar entender IDs internos.

Impacto:

**BAIXO/MÉDIO**

Preferir:

- código + descrição;
- rótulo amigável.

---

# 58. Risco — Exibir Choices Internos

Não mostrar:

- CORRENTE;
- POUPANCA;
- SIM;
- NAO;

como única informação visual.

Mostrar descrição amigável.

---

# 59. Risco — Perder Valores ao Editar Parcialmente

Ao editar um campo simples, não apagar:

- prazo;
- conta;
- natureza;
- categorias;
- dados bancários.

Impacto:

**ALTO**

PATCH e formulários devem preservar valores não alterados.

---

# 60. Risco — Salvar Campo Bancário Vazio por Falta de Permissão

Usuário sem permissão pode receber campos ocultos/vazios.

Esses vazios não devem sobrescrever dados reais ao salvar outras alterações.

Impacto:

**CRÍTICO**

Esse cuidado é especialmente importante em serializers.

---

# 61. Risco — Criar Anexos sem Estratégia de Armazenamento

Anexos foram retirados da Fase 1.

Motivo principal:

custo e responsabilidade de armazenamento no SaaS.

Impacto potencial:

**ALTO**

Não implementar anexos antes de definir:

- storage;
- limites;
- retenção;
- backup;
- cobrança;
- segurança.

---

# 62. Risco — Implementar Fase 2 Dentro da Fase 1

Não misturar score/avaliação no núcleo já homologado sem desenho específico.

Impacto:

**ALTO**

Fase 2 deve ser incremental.

---

# 63. Risco — Score Bloquear Fornecedor Automaticamente

Planejamento atual:

score ruim gera alerta, não bloqueio automático.

Impacto se implementado incorretamente:

**ALTO**

Bloqueio continua sendo decisão operacional.

---

# 64. Risco — Score Geral Apagar Diferenças por Categoria

Fornecedor pode ser bom em uma categoria e ruim em outra.

Impacto:

**MÉDIO**

Preservar:

- score geral;
- score por categoria.

---

# 65. Risco — Recalcular Histórico de Score

Quando pesos mudarem no futuro:

score atual pode ser recalculado.

Mas histórico de avaliações não deve perder o contexto original.

Impacto:

**ALTO**

---

# 66. Risco — Pesos Não Somarem 100%

Fase 2 deverá validar:

~~~text
Soma dos pesos = 100%
~~~

Impacto:

**ALTO**

---

# 67. Risco — Recência Mal Normalizada

Se houver menos de cinco avaliações, pesos de recência deverão ser normalizados.

Impacto:

**MÉDIO**

Não aplicar simplesmente 35/25/20/12/8 com avaliações inexistentes.

---

# 68. Risco — Misturar Avaliação com Dados Comerciais

Indicadores objetivos e avaliação subjetiva devem permanecer conceitos separados.

Exemplo:

- total comprado = dado objetivo;
- qualidade = avaliação.

Impacto:

**MÉDIO**

---

# 69. Risco — Alteração em Compras Quebrar Indicadores

Qualquer mudança de status de Pedido de Compra deve ser revisada contra indicadores de fornecedor.

Impacto:

**ALTO**

Se novos status forem criados:

revisar regra de compra válida.

---

# 70. Risco — Alteração Financeira Quebrar Saldo

Mudanças em:

- Pagar;
- PagarItem;
- pagamentos;
- cancelamentos;

podem afetar saldo a pagar.

Impacto:

**CRÍTICO**

Sempre executar regressão do fornecedor após alterações relevantes no financeiro.

---

# 71. Risco — Produção/Facção Ignorar Lifecycle

Operações de facção também devem respeitar fornecedor utilizável.

Impacto:

**ALTO**

Não aplicar regra apenas em Compras.

---

# 72. Risco — Entrada de Nota Ignorar Lifecycle

Entrada de Nota futura deve respeitar:

- empresa;
- fornecedor;
- status;
- bloqueio.

Impacto:

**ALTO**

---

# 73. Risco — Contexto de Categoria Inconsistente

Cada módulo pode precisar de filtro diferente.

Exemplo:

- facção → FACCAO;
- revenda → REVENDA;
- matéria-prima → MATERIA_PRIMA.

Impacto:

**MÉDIO**

Documentar a regra de cada processo.

---

# 74. Risco — Testes Automatizados Virarem Única Homologação

Automação não substitui teste funcional.

Impacto:

**MÉDIO**

O módulo foi aprovado com:

- testes automatizados;
- 30 testes manuais.

Manter combinação dos dois.

---

# 75. Risco — Executar Suíte Completa em Toda Correção Pequena

Não é risco funcional, mas risco de produtividade e consumo de recursos.

Foi observado consumo relevante de tokens do Codex.

Para pequenas correções:

- investigar antes;
- alterar somente arquivos necessários;
- executar testes específicos;
- reservar suíte ampla para checkpoints.

Impacto:

**MÉDIO**

---

# 76. Risco — Usar Codex para Investigação Já Resolvida

Evitar prompts como:

“investigue todo o projeto e descubra o problema”

quando a causa já foi localizada.

Impacto:

- maior consumo;
- maior tempo;
- mais risco de alterações laterais.

Novo procedimento:

- análise e arquitetura antes;
- Codex focado em implementação.

---

# 77. Divisão de Responsabilidade de Desenvolvimento

Procedimento adotado:

## Usuário

- decisão funcional;
- homologação manual.

## ChatGPT

- análise;
- investigação;
- leitura GitHub;
- arquitetura;
- definição da correção;
- revisão de commits.

## Codex

- implementação;
- testes necessários;
- commit.

Objetivo:

reduzir consumo sem reduzir segurança.

---

# 78. Risco — Prompt Muito Aberto

Prompts amplos fazem o agente explorar mais código.

Impacto:

**MÉDIO**

Preferir:

- arquivos conhecidos;
- causa conhecida;
- escopo fechado;
- critérios objetivos.

---

# 79. Risco — Prompt Excessivamente Restritivo em Mudança Grande

O inverso também existe.

Mudanças arquiteturais podem exigir investigação.

Impacto:

**MÉDIO**

Usar escopo proporcional:

- correção pequena → prompt cirúrgico;
- mudança estrutural → investigação controlada.

---

# 80. Risco — Commit sem Revisão

Não considerar resposta do Codex como prova suficiente.

Impacto:

**ALTO**

Procedimento:

1. Codex informa SHA;
2. revisar commit/diff;
3. homologar;
4. só então aprovar.

---

# 81. Risco — Alterar Obsidian Antes da Homologação

Documentar como concluído algo ainda não aprovado cria divergência.

Impacto:

**MÉDIO**

Procedimento:

- implementar;
- testar;
- homologar;
- documentar.

---

# 82. Risco — Código e Obsidian Divergirem

Toda decisão relevante deve ser refletida na documentação final.

Impacto:

**ALTO**

Documentos relacionados:

- Homologação;
- Mapa Técnico;
- Modelo de Domínio;
- Workflows;
- Riscos e Cuidados;
- Sysvar.md.

---

# 83. Risco — Não Registrar Pendências Aceitas

Itens conscientemente adiados devem permanecer visíveis.

Pendências atuais:

- validação IE;
- validação IM;
- banco oficial;
- melhoria UX bancária.

Não tratar essas decisões como “esquecidas”.

---

# 84. Pendência — Inscrição Estadual

Status:

**ADIADA**

Não bloqueia Fase 1.

---

# 85. Pendência — Inscrição Municipal

Status:

**ADIADA**

Não bloqueia Fase 1.

---

# 86. Pendência — Banco Oficial

Status:

**ADIADA**

Não bloqueia Fase 1.

---

# 87. Pendência — UX de Dados Bancários

Status:

**MELHORIA FUTURA**

Não bloqueia Fase 1.

---

# 88. Risco — Regressão de Telefones

Commit de referência:

`a3fe7235f5999652d47cb54589000b59a6b5da5b`

Esse commit corrigiu a validação de telefone.

Ao alterar máscaras futuras:

executar regressão.

---

# 89. Risco — Regressão de Contatos e Endereços

Commits de referência:

Backend:

`c65e0e737a725741907cc298e52c314cf93efab8`

Frontend:

`8e767bda4e70efd826497526dea70aaf903e860c`

Esses commits corrigiram problemas importantes de consulta/permissão.

---

# 90. Risco — Regressão dos Padrões Financeiros

Commits:

Backend:

`a2b192b60a31b0f38db2e2ab4b0c9c9aca3c10ee`

Frontend:

`37e68377bcecfc4ef35032cbb942d7a463ab58c6`

Ao alterar:

- prazo;
- conta;
- natureza;
- contribuinte ICMS;
- tipo de conta;

executar regressão específica.

---

# 91. Migration Crítica da Fase 1

Migration:

`0025_fornecedor_conta_contabil_padrao_and_more.py`

Cuidados:

- não editar migration já aplicada;
- criar nova migration para novas mudanças;
- preservar dados existentes.

---

# 92. Checklist antes de Alterar Fornecedor

Antes de modificar o módulo:

1. A mudança afeta multiempresa?
2. Afeta campos legados?
3. Afeta compras?
4. Afeta financeiro?
5. Afeta lifecycle?
6. Afeta auditoria?
7. Afeta dados bancários?
8. Afeta contatos?
9. Afeta endereços?
10. Exige migration?
11. Exige novo teste?
12. Exige atualização do Obsidian?

---

# 93. Checklist antes de Alterar Compras

Se a mudança afetar status ou fornecedor:

1. revisar fornecedores utilizáveis;
2. revisar indicadores;
3. revisar aba Compras;
4. revisar exclusão protegida;
5. revisar histórico.

---

# 94. Checklist antes de Alterar Financeiro

1. revisar saldo a pagar;
2. revisar títulos pagos;
3. revisar cancelados;
4. revisar pagamentos parciais;
5. revisar aba Financeiro;
6. revisar indicadores.

---

# 95. Checklist antes de Alterar Permissões

1. VIEW continua funcionando?
2. EDIT está separado?
3. dados bancários continuam protegidos?
4. contatos/endereço podem ser consultados?
5. lookup não exige permissão excessiva?
6. API protege mesmo com chamada manual?

---

# 96. Checklist antes de Deploy

Quando houver mudança relevante em Fornecedores:

1. migrations aplicadas;
2. `manage.py check`;
3. testes relevantes backend;
4. TypeScript;
5. testes frontend relevantes;
6. build;
7. verificar variáveis/configurações;
8. smoke test;
9. validar permissões;
10. validar empresa correta.

---

# 97. Prioridade dos Riscos

## Críticos

- vazamento multiempresa;
- vazamento bancário;
- exclusão com histórico;
- saldo financeiro incorreto;
- migration não aplicada;
- edição bancária sem autorização.

## Altos

- documento incorreto;
- lifecycle quebrado;
- categorias múltiplas perdidas;
- principal duplicado;
- compra de outra empresa;
- conta/natureza/prazo de outra empresa;
- indicadores incorretos.

## Médios

- UX;
- máscaras;
- banco texto livre;
- IE/IM;
- duplicidade por nome;
- performance de lookup.

---

# 98. Regra de Preservação

A Fase 1 está homologada.

Qualquer mudança futura deve partir da premissa:

> comportamento homologado não deve ser alterado silenciosamente.

Se uma regra precisar mudar:

1. registrar decisão;
2. alterar código;
3. atualizar testes;
4. homologar novamente;
5. atualizar documentação.

---

# 99. Estado Final

A Fase 1 de Fornecedores foi homologada com:

**30/30 itens aprovados**

As pendências conhecidas não impedem utilização operacional.

---

# 100. Conclusão

O cadastro de Fornecedores é uma entidade transversal do SISVAR e impacta diversos módulos.

Por isso, alterações aparentemente pequenas podem afetar:

- compras;
- financeiro;
- fiscal;
- produção;
- facção;
- auditoria;
- segurança;
- multiempresa.

Este documento deve ser considerado referência obrigatória antes de modificações relevantes.

Status:

> **RISCOS E CUIDADOS — FORNECEDORES FASE 1 — DOCUMENTADOS**