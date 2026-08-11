# Mapa Técnico - Cadastros - Fornecedores

## 1. Identificação

- **Projeto:** Sysvar
- **Módulo:** Cadastros
- **Funcionalidade:** Fornecedores
- **Escopo documentado:** Fase 1 — Cadastro e Gestão Operacional
- **Situação:** IMPLEMENTADO E HOMOLOGADO
- **Homologação manual:** 30/30 itens aprovados

---

# 2. Objetivo Técnico

O cadastro de Fornecedores centraliza a identificação, classificação, contatos, endereços, dados fiscais, dados comerciais, dados contábeis, dados financeiros, dados bancários, ciclo de vida, histórico e integração operacional dos fornecedores utilizados pelo SISVAR.

A arquitetura deve preservar obrigatoriamente:

- isolamento multiempresa;
- integridade histórica;
- proteção de dados bancários;
- compatibilidade com estruturas legadas;
- utilização operacional somente de fornecedores válidos;
- rastreabilidade por auditoria;
- separação entre cadastro operacional e futura inteligência de fornecedores.

---

# 3. Backend

## 3.1. Aplicação principal

A funcionalidade está concentrada principalmente no app Django:

`cadastros`

Arquivos centrais:

- `cadastros/models.py`
- `cadastros/serializers.py`
- `cadastros/views.py`
- `cadastros/urls.py`
- `cadastros/tests.py`

Também existem integrações com:

- `financeiro`
- `compras`
- `auditoria`
- `accounts`

---

# 4. Modelo Principal

## 4.1. Fornecedor

Model:

`cadastros.models.Fornecedor`

Responsabilidades principais:

- identificação do fornecedor;
- associação obrigatória com empresa;
- PF/PJ;
- documento;
- dados cadastrais;
- dados fiscais;
- dados comerciais;
- padrões financeiros;
- padrões contábeis;
- dados bancários;
- situação ativa/inativa;
- bloqueio operacional.

---

# 5. Isolamento Multiempresa

Todo fornecedor pertence obrigatoriamente a uma empresa.

Campo estrutural:

`empresa`

A arquitetura deve considerar sempre a combinação:

`empresa + entidade`

Regras multiempresa críticas:

- documento único por empresa;
- prazo padrão da mesma empresa;
- conta contábil da mesma empresa;
- natureza financeira da mesma empresa;
- contatos da mesma empresa;
- endereços da mesma empresa;
- compras da mesma empresa;
- financeiro da mesma empresa;
- indicadores da mesma empresa.

Nenhum ID recebido do frontend deve ser considerado seguro sem validação da empresa no backend.

---

# 6. Tipo de Pessoa

Valores internos:

- `PF`
- `PJ`

Constantes:

- `TIPO_PESSOA_FISICA`
- `TIPO_PESSOA_JURIDICA`

Choices:

`TIPO_PESSOA_CHOICES`

Regras:

- PF com documento informado exige CPF válido;
- PJ com documento informado exige CNPJ válido;
- documento é opcional.

---

# 7. Documento Funcional

Campo atual:

`documento`

O documento é normalizado para somente dígitos.

O campo legado:

`cnpj`

ainda existe por compatibilidade.

Para PJ, o sistema mantém compatibilidade entre:

- `documento`
- `cnpj`

A evolução futura deve preferir sempre `documento` como campo funcional.

---

# 8. Unicidade do Documento

Constraint:

`uq_empresa_fornecedor_documento`

Regra:

`empresa + documento`

Portanto:

- duplicidade dentro da mesma empresa é impedida;
- mesmo documento em empresas diferentes é permitido;
- documento nulo continua permitido.

Índice relacionado:

`idx_forn_empresa_doc`

---

# 9. Índices Relevantes

Entre os índices existentes estão:

- empresa + documento;
- empresa + nome do fornecedor;
- empresa + ativo;
- empresa + bloqueio;
- empresa + tipo de pessoa;
- cidade + estado;
- categoria;
- bloqueio;
- ativo;
- data de cadastro.

Esses índices apoiam:

- filtros;
- busca;
- seleção operacional;
- paginação;
- isolamento multiempresa.

---

# 10. Categorias

Categorias disponíveis:

- `MATERIA_PRIMA`
- `AVIAMENTO`
- `REVENDA`
- `FACCAO`
- `PRESTADOR`
- `TRANSPORTADORA`
- `OUTROS`

A estrutura atual possui compatibilidade com o campo legado:

`categoria`

e estrutura múltipla através de:

`FornecedorCategoria`

---

# 11. FornecedorCategoria

Model:

`cadastros.models.FornecedorCategoria`

Responsabilidade:

permitir associação N:N lógica entre fornecedor e categorias.

Campos relevantes:

- fornecedor;
- empresa;
- categoria;
- data_cadastro.

Constraint:

um mesmo fornecedor não deve receber a mesma categoria duas vezes.

A empresa da categoria deve coincidir com a empresa do fornecedor.

---

# 12. Uso das Categorias

As categorias não devem ser utilizadas como regra rígida universal.

Uso esperado:

- filtro;
- sugestão;
- priorização;
- limitação contextual quando a operação exigir.

Exemplos:

- Facção → `FACCAO`
- Compra de revenda → `REVENDA`
- Matéria-prima → `MATERIA_PRIMA`
- Transporte → `TRANSPORTADORA`

---

# 13. Contatos

Model:

`cadastros.models.FornecedorContato`

Relacionamentos:

- fornecedor;
- empresa.

Campos principais:

- nome;
- cargo_funcao;
- tipo;
- telefone;
- whatsapp;
- email;
- observacao;
- principal;
- ativo;
- data_cadastro;
- data_atualizacao.

---

# 14. Tipos de Contato

Valores:

- `COMERCIAL`
- `FINANCEIRO`
- `FISCAL`
- `PRODUCAO_FACCAO`
- `LOGISTICA`
- `OUTRO`

A arquitetura permite múltiplos contatos do mesmo tipo.

---

# 15. Regra de Contato Principal

A regra funcional é:

> somente um contato ativo pode ser principal por tipo.

A aplicação utiliza transação para preservar consistência ao alterar o contato principal.

O comportamento deve permanecer protegido contra concorrência.

---

# 16. Normalização de Telefone

Telefone e WhatsApp são persistidos preferencialmente somente com dígitos.

Frontend:

- aplica máscara de apresentação;
- valida 10 ou 11 dígitos.

Formato visual:

`(21) 3324-4000`

`(21) 99008-7565`

Backend:

- recebe/persiste versão normalizada;
- valida através da infraestrutura existente de telefone.

---

# 17. Endereços

Model:

`cadastros.models.FornecedorEndereco`

Relacionamentos:

- fornecedor;
- empresa.

Tipos funcionais:

- Fiscal;
- Comercial;
- Cobrança;
- Retirada/Coleta;
- Entrega;
- Unidade Fabril;
- Outro.

Campos esperados:

- tipo;
- logradouro;
- endereço;
- número;
- complemento;
- CEP;
- bairro;
- cidade;
- UF;
- principal;
- ativo;
- observação.

---

# 18. Regra de Endereço Principal

A regra funcional é:

> somente um endereço ativo pode ser principal por tipo.

Alterações devem ser feitas de forma transacional para preservar consistência.

---

# 19. Dados Fiscais

Campos relevantes:

- `inscricao_estadual`
- `inscricao_municipal`
- `contribuinte_icms`

---

# 20. Contribuinte ICMS

Choices:

- `SIM`
- `NAO`
- `ISENTO`

Campo vazio/null:

não informado.

O frontend deve trabalhar com opções amigáveis e nunca exigir que o usuário conheça os códigos internos.

---

# 21. Inscrição Estadual

Situação atual:

- campo opcional;
- texto livre;
- sem validação específica por UF.

Essa decisão foi mantida conscientemente na Fase 1.

---

# 22. Inscrição Municipal

Situação atual:

- campo opcional;
- texto livre;
- sem validação específica municipal.

Essa decisão foi mantida conscientemente na Fase 1.

---

# 23. Dados Comerciais

Campos relevantes:

- `site`
- `prazo_padrao_pagamento`
- `prazo_padrao_pagamento_ref`
- `observacoes_comerciais`

---

# 24. Prazo Padrão de Pagamento

Estrutura atual:

`prazo_padrao_pagamento_ref`

ForeignKey para:

`financeiro.PrazoPagamento`

O campo anterior:

`prazo_padrao_pagamento`

permanece temporariamente como legado/compatibilidade.

Ao existir referência estruturada, o backend mantém o legado espelhado conforme a implementação atual.

---

# 25. Validação do Prazo

Regras:

- prazo deve pertencer à mesma empresa do fornecedor;
- prazo inativo não deve ser aceito para nova seleção;
- frontend deve listar preferencialmente prazos ativos;
- backend deve validar novamente o ID enviado.

---

# 26. Conta Contábil Padrão

Campo estruturado:

`conta_contabil_padrao`

ForeignKey para:

`cadastros.PlanoContabil`

Campo legado:

`conta_contabil`

permanece temporariamente por compatibilidade.

---

# 27. Validação da Conta Contábil

Para utilização como padrão do fornecedor, a conta deve ser:

- da mesma empresa;
- ativa;
- analítica.

A conta contábil não deve ser aceita somente porque o frontend a apresentou.

A validação final é responsabilidade do backend.

---

# 28. Natureza Financeira Padrão

Campo:

`natureza_padrao`

ForeignKey para:

`cadastros.Nat_Lancamento`

Regras:

- mesma empresa;
- ativa;
- seleção estruturada;
- exibição amigável por código e descrição.

---

# 29. Dados Bancários

Campos principais:

- `banco`
- `agencia`
- `conta`
- `tipo_conta`
- `chave_pix`
- `favorecido`
- `documento_favorecido`
- `observacao_bancaria`

Esses campos devem ser tratados como dados sensíveis.

---

# 30. Tipo de Conta

Choices backend:

- `CORRENTE`
- `POUPANCA`
- `PAGAMENTO`
- `OUTRA`

Descrições:

- Conta corrente
- Conta poupança
- Conta de pagamento
- Outra

Frontend deve utilizar SELECT.

---

# 31. Banco

Situação atual:

`banco` permanece texto livre.

Não existe ainda cadastro oficial integrado ao BACEN.

Pendência futura:

- tabela de bancos;
- fonte oficial;
- definição de identificador;
- código COMPE/ISPB conforme desenho definitivo.

---

# 32. Segurança Bancária

Permissão funcional:

`fornecedor.dados_bancarios`

A proteção deve acontecer no backend.

Regras:

- usuário autorizado recebe dados;
- usuário não autorizado não recebe valores sensíveis;
- frontend não deve ser a única barreira de segurança.

A resposta da API deve sinalizar quando os dados estão ocultos quando necessário.

Campo utilizado pela interface:

`dados_bancarios_ocultos`

---

# 33. Serializer Principal

Serializer:

`FornecedorSerializer`

Responsabilidades relevantes:

- serialização dos dados principais;
- validação multiempresa;
- indicadores;
- descrições amigáveis;
- proteção bancária;
- compatibilidade com campos estruturados e legados.

Campos adicionais de apresentação incluem, conforme implementação atual:

- `contribuinte_icms_descricao`
- `prazo_padrao_codigo`
- `prazo_padrao_descricao`
- `conta_contabil_codigo`
- `conta_contabil_descricao`
- `natureza_padrao_codigo`
- `natureza_padrao_descricao`
- `tipo_conta_descricao`
- `dados_bancarios_ocultos`

---

# 34. Validações no Serializer

O serializer deve preservar as validações de:

- empresa;
- natureza financeira;
- prazo;
- conta contábil;
- status de cadastros auxiliares;
- campos protegidos de lifecycle;
- permissões de dados bancários.

Nunca confiar somente em filtros da interface.

---

# 35. Ciclo de Vida

Campos principais:

- `ativo`
- `bloqueio`
- `motivo_bloqueio`
- `observacao_bloqueio`
- `bloqueado_em`
- `bloqueado_por`

O usuário comum não deve alterar livremente os campos de lifecycle como simples edição de formulário.

São utilizadas ações específicas.

---

# 36. Ações de Lifecycle

Ações funcionais:

- Ativar
- Inativar
- Bloquear
- Desbloquear

Essas ações devem:

- validar permissão;
- preservar empresa;
- registrar auditoria;
- preservar histórico;
- impedir estado inconsistente.

---

# 37. Fornecedor Utilizável

Conceitualmente, fornecedor utilizável para nova operação é aquele que está:

- ativo;
- não bloqueado;
- pertencente à empresa corrente;
- adequado ao contexto da operação.

Fornecedor inativo ou bloqueado:

- continua existindo;
- preserva histórico;
- não pode ser utilizado em novas operações.

---

# 38. Exclusão

A exclusão física só deve ocorrer quando não existem dependências históricas impeditivas.

Fornecedor vinculado a operações deve permanecer no banco.

Alternativa operacional:

inativação.

Mensagem funcional padronizada:

`Este fornecedor possui compras ou outros registros vinculados e não pode ser excluído. Utilize a inativação.`

---

# 39. Compras do Fornecedor

A consulta possui integração com compras.

A API deve retornar apenas operações:

- da empresa atual;
- do fornecedor solicitado.

A consulta pode incluir estados diversos para fins históricos.

Indicadores, porém, devem considerar somente operações válidas conforme regra de negócio.

---

# 40. Indicadores Comerciais

Indicadores:

- última compra;
- total comprado;
- quantidade de compras;
- ticket médio;
- saldo a pagar.

A lógica pertence ao backend.

O frontend não deve recalcular esses indicadores independentemente.

---

# 41. Regra dos Indicadores de Compra

Devem ser excluídos do cálculo:

- cancelados;
- rascunhos;
- operações ainda abertas quando não consideradas concluídas.

Quando existirem devoluções ou ajustes efetivos, devem reduzir os valores conforme o processo operacional correspondente.

---

# 42. Ticket Médio

Fórmula conceitual:

`total comprado / quantidade de compras válidas`

Tratamento obrigatório para quantidade zero.

---

# 43. Financeiro do Fornecedor

A consulta financeira deve considerar apenas:

- títulos do fornecedor;
- títulos da empresa atual.

Informações apresentadas conforme disponibilidade:

- documento/origem;
- emissão;
- vencimento;
- valor original;
- valor pago;
- saldo;
- status;
- natureza;
- loja.

---

# 44. Saldo a Pagar

O saldo deve ser calculado no backend.

Regras:

- aberto → entra;
- parcialmente pago → entra somente saldo restante;
- pago → saldo zero;
- cancelado → não compõe saldo.

---

# 45. Histórico

A funcionalidade possui consulta de histórico próprio do fornecedor.

Eventos relevantes incluem:

- edição;
- ativação;
- inativação;
- bloqueio;
- desbloqueio;
- alterações de contato;
- alterações de endereço;
- mudanças de principal.

---

# 46. Audit Central

A funcionalidade integra com:

`auditoria`

Eventos administrativos relevantes devem gerar `AuditLog`.

A auditoria não deve armazenar indevidamente valores bancários sensíveis.

---

# 47. Frontend

Componente principal:

`FornecedoresComponent`

Caminho atual:

`src/app/features/fornecedores/fornecedores.component.ts`

Template:

`src/app/features/fornecedores/fornecedores.component.html`

Estilos:

`src/app/features/fornecedores/fornecedores.component.css`

Testes:

`src/app/features/fornecedores/fornecedores.component.spec.ts`

---

# 48. Serviço Frontend

Service:

`FornecedoresService`

Responsabilidades:

- listar;
- consultar;
- criar;
- editar;
- excluir;
- lifecycle;
- indicadores;
- contatos;
- endereços;
- compras;
- financeiro;
- histórico;
- duplicidades.

---

# 49. Paginação

A paginação da lista é server-side.

Parâmetros típicos:

- `page`
- `page_size`

A interface não deve buscar milhares de fornecedores para paginar localmente.

---

# 50. Filtros

Filtros são enviados ao backend.

Entre os parâmetros suportados conforme implementação da Fase 1 estão:

- search;
- ordering;
- categoria;
- utilizável;
- tipo de pessoa;
- documento;
- cidade;
- estado;
- ativo;
- bloqueio.

---

# 51. Consulta

A consulta utiliza abas:

- Dados cadastrais
- Compras
- Financeiro
- Histórico

O modo consulta é somente leitura.

---

# 52. Contatos no Frontend

A interface possui:

- formulário de contato;
- lista de contatos cadastrados;
- novo contato;
- edição;
- inativação;
- reativação;
- principal.

Depois de criar/alterar contato, a lista deve ser recarregada.

---

# 53. Endereços no Frontend

A interface possui:

- formulário de endereço;
- lista de endereços cadastrados;
- novo endereço;
- edição;
- inativação;
- reativação;
- principal.

Depois de criar/alterar endereço, a lista deve ser recarregada.

---

# 54. Máscara de Telefone no Frontend

Funções relevantes incluem:

- `formatPhone`
- `onPhoneInput`
- `onContatoPhoneInput`
- `phoneValidator`

Regra:

validar quantidade de dígitos e não pontuação rígida.

---

# 55. Seletores Estruturados

O frontend utiliza estruturas já existentes para:

## Prazo

Service relacionado ao cadastro financeiro de prazos.

Endpoint atual utilizado:

`/api/financeiro/prazos/`

## Plano Contábil

Service de Plano Contábil.

## Natureza

Service de Natureza de Lançamento.

Esses cadastros não devem ser duplicados dentro do módulo de fornecedores.

---

# 56. Formulário Principal

O formulário deve manter referências estruturadas como:

- `prazo_padrao_pagamento_ref`
- `conta_contabil_padrao`
- `natureza_padrao`

Campos legados não devem ser enviados como substitutos quando as referências novas estiverem sendo utilizadas.

---

# 57. Duplicidade por Nome

Existe recurso para verificar possíveis duplicidades.

A análise por nome/apelido é:

- aviso;
- não bloqueante.

A regra rígida permanece sendo documento quando informado.

---

# 58. Permissões

As operações devem respeitar o sistema de permissões do SISVAR.

Entre as capacidades relacionadas:

- VIEW;
- EDIT;
- DELETE;
- lifecycle;
- dados bancários.

A leitura de contatos e endereços não deve exigir indevidamente permissão de edição.

Esse problema ocorreu durante a homologação e foi corrigido.

---

# 59. Migration da Estrutura Fiscal/Financeira

Migration criada:

`cadastros/migrations/0025_fornecedor_conta_contabil_padrao_and_more.py`

Alterações principais:

- adiciona `conta_contabil_padrao`;
- adiciona `prazo_padrao_pagamento_ref`;
- estrutura choices de `contribuinte_icms`.

---

# 60. Compatibilidade Legada

Campos legados ainda existentes incluem:

- `cnpj`
- `categoria`
- `prazo_padrao_pagamento`
- `conta_contabil`

Eles não devem ser removidos sem análise de dependências.

A direção arquitetural é migrar progressivamente para estruturas normalizadas.

---

# 61. Testes Backend

A suíte específica da Fase 1 cobre, entre outros:

- PF/PJ;
- documento;
- multiempresa;
- categorias;
- contatos;
- endereços;
- principal;
- padrões fiscais;
- prazo;
- conta contábil;
- natureza;
- segurança;
- indicadores.

Resultado mais recente registrado durante a Fase 1:

- `FornecedorFase1Tests` — 14 OK
- `cadastros` — 56 OK
- `auditoria` — 21 OK
- suíte geral — 111 OK

Esses números são resultados registrados e não uma execução atual.

---

# 62. Testes Frontend

Testes cobrem, entre outros:

- paginação;
- filtros;
- contatos;
- endereços;
- telefone;
- selects estruturados;
- edição;
- consulta;
- segurança dos dados bancários.

Resultado mais recente registrado:

- TypeScript — OK
- Karma — 114 SUCCESS
- Build Angular development — OK

Esses números são resultados registrados e não uma execução atual.

---

# 63. Commits de Referência

## Conclusão da Fase 1

Backend:

`993f473ca793193a7590327964b4f3a20e5780e7`

Frontend:

`a573d068e8bb031ea7aae0ebc0196c9bbf7ad78c`

---

## Contatos e Endereços

Backend:

`c65e0e737a725741907cc298e52c314cf93efab8`

Frontend:

`8e767bda4e70efd826497526dea70aaf903e860c`

---

## Telefones

Frontend:

`a3fe7235f5999652d47cb54589000b59a6b5da5b`

---

## Padrões fiscais e financeiros

Backend:

`a2b192b60a31b0f38db2e2ab4b0c9c9aca3c10ee`

Frontend:

`37e68377bcecfc4ef35032cbb942d7a463ab58c6`

---

# 64. Pendências Técnicas Conhecidas

## Inscrição Estadual

Falta validação por UF.

## Inscrição Municipal

Falta estratégia de validação municipal.

## Banco

Falta cadastro oficial de instituições bancárias.

## UX bancária

Usuário sem permissão pode visualizar estrutura dos campos vazios.

## Fase 2

Não existem ainda:

- avaliações;
- score;
- comparação;
- pesos configuráveis;
- classificação de desempenho.

---

# 65. Cuidados para Alterações Futuras

Antes de modificar `Fornecedor`:

1. verificar compatibilidade com campos legados;
2. verificar compras;
3. verificar financeiro;
4. verificar produção/facção;
5. verificar serializers;
6. verificar permissões;
7. verificar multiempresa;
8. verificar auditoria;
9. verificar migrations;
10. executar regressão da Fase 1.

---

# 66. Regra de Segurança

Nunca implementar proteção de dados bancários apenas com:

`*ngIf`

ou outra regra exclusivamente frontend.

O backend deve determinar o que pode ser retornado.

---

# 67. Regra Multiempresa

Nunca aceitar IDs de:

- prazo;
- conta;
- natureza;
- contato;
- endereço;

sem validar a empresa correspondente.

---

# 68. Regra de Histórico

Não remover fornecedor vinculado somente para simplificar fluxo.

A preservação histórica tem prioridade sobre exclusão física.

---

# 69. Regra de Lifecycle

Não transformar:

- ativo;
- bloqueio;

em simples checkboxes editáveis indiscriminadamente.

Utilizar ações controladas.

---

# 70. Regra de Indicadores

Não migrar cálculos comerciais para o frontend.

O backend deve ser a fonte de verdade.

---

# 71. Regra de Cadastros Auxiliares

Não recriar dentro do módulo de fornecedores cadastros já existentes como:

- PrazoPagamento;
- PlanoContabil;
- Nat_Lancamento.

Fornecedor apenas referencia essas entidades.

---

# 72. Estado Final da Fase 1

A arquitetura atual de Fornecedores está homologada para:

- cadastro;
- classificação;
- contatos;
- endereços;
- lifecycle;
- compras;
- financeiro;
- auditoria;
- dados fiscais;
- padrões contábeis/financeiros;
- dados bancários protegidos;
- operação multiempresa.

Status:

> **FASE 1 HOMOLOGADA**

Homologação manual:

> **30/30 ITENS APROVADOS**

A Fase 2 deve ser construída sobre esta base sem quebrar as garantias registradas neste mapa técnico.