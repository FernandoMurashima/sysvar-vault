# Modelo de Domínio - Cadastros - Fornecedores

## 1. Identificação

- **Projeto:** Sysvar
- **Módulo:** Cadastros
- **Funcionalidade:** Fornecedores
- **Escopo:** Fase 1 — Cadastro e Gestão Operacional
- **Situação:** IMPLEMENTADO E HOMOLOGADO
- **Homologação manual:** 30/30 itens aprovados

---

# 2. Objetivo do Modelo de Domínio

O domínio de Fornecedores representa todas as informações necessárias para identificar, classificar, selecionar, controlar, consultar e auditar fornecedores utilizados pelo SISVAR.

O modelo deve suportar:

- múltiplas empresas;
- Pessoa Física e Pessoa Jurídica;
- fornecedor com ou sem documento;
- múltiplas categorias;
- múltiplos contatos;
- múltiplos endereços;
- dados fiscais;
- dados comerciais;
- padrões financeiros;
- padrões contábeis;
- dados bancários;
- proteção por permissão;
- lifecycle;
- compras;
- financeiro;
- histórico;
- auditoria.

O modelo também deve servir como base para a futura Fase 2 de avaliação e inteligência de fornecedores.

---

# 3. Agregado Principal

O agregado principal do domínio é:

`Fornecedor`

Ele representa a entidade central a partir da qual as demais informações são relacionadas.

Relacionamentos principais:

`Empresa`
↓
`Fornecedor`
↓
- Categorias
- Contatos
- Endereços
- Compras
- Financeiro
- Histórico
- Dados fiscais
- Padrões financeiros
- Padrões contábeis
- Dados bancários

---

# 4. Empresa

Todo fornecedor pertence obrigatoriamente a uma Empresa.

Entidade:

`Empresa`

Relacionamento:

`Empresa 1:N Fornecedor`

Regra:

> Um fornecedor nunca existe fora do contexto de uma empresa.

Consequências:

- documentos são únicos dentro da empresa;
- consultas são filtradas por empresa;
- padrões financeiros devem pertencer à mesma empresa;
- conta contábil deve pertencer à mesma empresa;
- natureza deve pertencer à mesma empresa;
- contatos e endereços devem pertencer à mesma empresa;
- compras e títulos financeiros devem respeitar a empresa.

---

# 5. Fornecedor

Entidade:

`Fornecedor`

É a raiz do agregado operacional.

Principais grupos de atributos:

## Identificação

- empresa;
- tipo de pessoa;
- documento;
- nome;
- apelido.

## Fiscal

- inscrição estadual;
- inscrição municipal;
- contribuinte ICMS.

## Comercial

- site;
- prazo padrão;
- observações comerciais.

## Contábil

- conta contábil padrão;
- natureza financeira padrão.

## Bancário

- banco;
- agência;
- conta;
- tipo de conta;
- chave PIX;
- favorecido;
- documento do favorecido;
- observação bancária.

## Lifecycle

- ativo;
- bloqueio;
- motivo do bloqueio;
- observação;
- data/hora do bloqueio;
- usuário responsável.

---

# 6. Tipo de Pessoa

O fornecedor possui atributo:

`tipo_pessoa`

Valores:

- PF
- PJ

Regra:

- PF representa Pessoa Física;
- PJ representa Pessoa Jurídica.

O tipo de pessoa determina qual regra de documento deve ser aplicada quando o documento é informado.

---

# 7. Documento

A identificação fiscal funcional utiliza:

`documento`

Para PF:

- CPF.

Para PJ:

- CNPJ.

Regra de domínio:

> O documento é opcional, porém, quando informado, deve ser válido para o tipo de pessoa selecionado.

---

# 8. Fornecedor sem Documento

Fornecedor pode existir sem documento.

Essa possibilidade faz parte do domínio e não é exceção técnica.

Regras:

- documento pode ser nulo;
- múltiplos fornecedores sem documento podem existir;
- nome não se torna chave única;
- possível duplicidade de nome gera aviso;
- fornecedor continua operacionalmente válido quando ativo e não bloqueado.

---

# 9. Unicidade

A regra de unicidade é:

`Empresa + Documento`

Não existe unicidade global de CPF/CNPJ.

Exemplo:

Empresa A:

Fornecedor X
CNPJ 11.111.111/0001-11

Empresa B:

Fornecedor X
CNPJ 11.111.111/0001-11

Resultado:

permitido.

Dentro da mesma empresa:

não permitido.

---

# 10. Duplicidade por Nome

Nome e apelido não são identificadores rígidos.

Fornecedor pode possuir nome semelhante a outro.

Nesse cenário:

- sistema pode avisar;
- usuário pode confirmar;
- cadastro não é bloqueado obrigatoriamente.

Regra:

> Similaridade de nome é sinal de atenção, não prova de duplicidade.

---

# 11. Categoria de Fornecedor

Entidade:

`FornecedorCategoria`

Relacionamento:

`Fornecedor 1:N FornecedorCategoria`

Cada associação representa uma categoria atribuída ao fornecedor.

Categorias disponíveis:

- Matéria-prima;
- Aviamento;
- Produto de revenda;
- Facção;
- Prestador de serviço;
- Transportadora;
- Outros.

---

# 12. Multiplicidade de Categorias

Um fornecedor pode possuir várias categorias simultaneamente.

Exemplo:

Fornecedor ABC:

- Matéria-prima;
- Aviamento;
- Prestador de serviço.

Não existe obrigação de escolher apenas uma categoria.

---

# 13. Semântica da Categoria

Categoria possui função de:

- classificação;
- segmentação;
- filtro;
- priorização;
- seleção contextual.

A categoria não deve ser interpretada automaticamente como autorização exclusiva.

Exemplo:

Fornecedor FACCAO deve ser priorizado em operações de facção.

Isso não significa necessariamente que todo fornecedor de outra categoria deva ser universalmente bloqueado em todos os contextos.

---

# 14. Contato

Entidade:

`FornecedorContato`

Relacionamento:

`Fornecedor 1:N FornecedorContato`

Um fornecedor pode possuir qualquer quantidade de contatos.

A entidade contato representa uma pessoa ou canal de relacionamento associado ao fornecedor.

---

# 15. Atributos do Contato

Principais atributos:

- nome;
- cargo/função;
- tipo;
- telefone;
- WhatsApp;
- e-mail;
- observação;
- principal;
- ativo;
- data de cadastro;
- data de atualização.

---

# 16. Tipo de Contato

Tipos:

- Comercial;
- Financeiro;
- Fiscal;
- Produção/Facção;
- Logística;
- Outro.

Esses tipos ajudam a identificar quem deve ser contatado em cada contexto operacional.

---

# 17. Contato Principal

Um contato pode ser marcado como:

`principal = true`

Regra:

> Só pode existir um contato principal ativo por tipo.

Exemplo:

Dois contatos comerciais:

- João;
- Maria.

Apenas um deles pode ser o principal Comercial ao mesmo tempo.

---

# 18. Ciclo de Vida do Contato

Contato pode estar:

- ativo;
- inativo.

Contato inativo:

- não é apagado;
- permanece no histórico;
- continua associado ao fornecedor.

A inativação é preferível à exclusão quando existe valor histórico.

---

# 19. Telefone do Contato

Telefone e WhatsApp são dados opcionais.

Regra estrutural:

- vazio é válido;
- 10 dígitos é válido;
- 11 dígitos é válido.

A máscara visual não faz parte da identidade do dado.

Persistência preferida:

somente dígitos.

---

# 20. Endereço

Entidade:

`FornecedorEndereco`

Relacionamento:

`Fornecedor 1:N FornecedorEndereco`

Fornecedor pode possuir múltiplos endereços.

---

# 21. Tipos de Endereço

Tipos funcionais:

- Fiscal;
- Comercial;
- Cobrança;
- Retirada/Coleta;
- Entrega;
- Unidade Fabril;
- Outro.

---

# 22. Atributos do Endereço

Principais atributos:

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

# 23. Endereço Principal

Regra:

> Só pode existir um endereço principal ativo por tipo.

É permitido possuir vários endereços do mesmo tipo, desde que apenas um seja o principal.

---

# 24. Ciclo de Vida do Endereço

Endereço pode estar:

- ativo;
- inativo.

Endereço inativo permanece associado ao fornecedor.

A inativação preserva histórico.

---

# 25. Inscrição Estadual

Atributo:

`inscricao_estadual`

Situação na Fase 1:

- opcional;
- texto livre;
- sem validação por UF.

Trata-se de decisão de escopo.

---

# 26. Inscrição Municipal

Atributo:

`inscricao_municipal`

Situação na Fase 1:

- opcional;
- texto livre;
- sem validação municipal específica.

Também é decisão de escopo.

---

# 27. Contribuinte ICMS

Atributo:

`contribuinte_icms`

Estados possíveis:

- Não informado;
- Sim;
- Não;
- Isento.

Valores internos:

- SIM;
- NAO;
- ISENTO.

---

# 28. Prazo de Pagamento Padrão

Entidade relacionada:

`PrazoPagamento`

Relacionamento:

`Fornecedor N:1 PrazoPagamento`

Campo funcional:

`prazo_padrao_pagamento_ref`

O fornecedor pode possuir um prazo padrão sugerido para novas operações.

---

# 29. Regra do Prazo Padrão

O prazo:

- deve pertencer à mesma empresa;
- deve estar válido/ativo para novas seleções;
- é uma sugestão operacional;
- não deve impedir alteração da condição em uma operação específica quando permitido.

---

# 30. Compatibilidade do Prazo

Campo legado:

`prazo_padrao_pagamento`

permanece temporariamente.

O domínio atual deve tratar:

`prazo_padrao_pagamento_ref`

como referência estruturada preferencial.

---

# 31. Conta Contábil Padrão

Entidade relacionada:

`PlanoContabil`

Relacionamento:

`Fornecedor N:1 PlanoContabil`

Campo:

`conta_contabil_padrao`

Representa a conta contábil sugerida para operações relacionadas ao fornecedor.

---

# 32. Regra da Conta Contábil

A conta selecionada deve:

- pertencer à mesma empresa;
- estar ativa;
- ser analítica.

Conta sintética não deve ser utilizada para lançamento operacional.

---

# 33. Compatibilidade da Conta Contábil

Campo legado:

`conta_contabil`

permanece temporariamente.

A referência estruturada:

`conta_contabil_padrao`

é a direção arquitetural preferencial.

---

# 34. Natureza Financeira Padrão

Entidade relacionada:

`Nat_Lancamento`

Relacionamento:

`Fornecedor N:1 Nat_Lancamento`

Campo:

`natureza_padrao`

Representa a natureza financeira sugerida para operações do fornecedor.

---

# 35. Regra da Natureza

Natureza selecionada deve:

- pertencer à mesma empresa;
- estar ativa;
- ser válida para utilização conforme regras existentes do módulo financeiro.

---

# 36. Padrões não são Travamentos

Prazo, conta contábil e natureza financeira são padrões.

Regra conceitual:

> Padrão significa sugestão inicial, não necessariamente bloqueio obrigatório.

Uma operação pode permitir alteração posterior conforme suas próprias regras.

---

# 37. Dados Bancários

Dados bancários pertencem ao agregado Fornecedor.

Principais atributos:

- banco;
- agência;
- conta;
- tipo de conta;
- chave PIX;
- favorecido;
- documento favorecido;
- observação.

---

# 38. Tipo de Conta

Estados válidos:

- Conta corrente;
- Conta poupança;
- Conta de pagamento;
- Outra.

Valores internos:

- CORRENTE;
- POUPANCA;
- PAGAMENTO;
- OUTRA.

---

# 39. Banco

Na Fase 1, banco ainda é um dado textual.

Não existe ainda entidade estruturada:

`Banco`

como cadastro oficial do SISVAR.

Isso é uma pendência futura.

---

# 40. Confidencialidade Bancária

Dados bancários possuem nível de sensibilidade maior que dados cadastrais comuns.

Regra:

> O simples direito de visualizar um fornecedor não implica automaticamente direito de visualizar seus dados bancários.

Existe permissão específica.

---

# 41. Permissão Bancária

Permissão funcional:

`fornecedor.dados_bancarios`

Usuário autorizado:

- pode visualizar dados bancários;
- pode editar conforme demais permissões.

Usuário não autorizado:

- não recebe valores sensíveis;
- não deve conseguir inferi-los por API.

---

# 42. Situação do Fornecedor

O fornecedor possui dois eixos operacionais relevantes:

## Atividade

- Ativo;
- Inativo.

## Bloqueio

- Não bloqueado;
- Bloqueado.

Esses estados são relacionados, mas independentes.

---

# 43. Fornecedor Ativo

Fornecedor ativo:

- permanece disponível para operações;
- desde que não esteja bloqueado;
- e respeite as regras do contexto.

---

# 44. Fornecedor Inativo

Fornecedor inativo:

- permanece cadastrado;
- permanece no histórico;
- não pode ser utilizado em novas operações.

---

# 45. Fornecedor Bloqueado

Fornecedor bloqueado:

- permanece cadastrado;
- preserva histórico;
- não pode ser utilizado em novas operações.

O bloqueio registra contexto administrativo.

---

# 46. Bloqueio

Informações relacionadas:

- motivo;
- observação;
- data/hora;
- usuário responsável.

O bloqueio é uma ação controlada.

Não deve ser tratado apenas como edição direta de campo.

---

# 47. Fornecedor Utilizável

Conceito derivado:

`FornecedorUtilizavel`

Um fornecedor é utilizável quando:

- pertence à empresa atual;
- está ativo;
- não está bloqueado;
- atende ao contexto da operação.

Representação conceitual:

~~~text
FornecedorUtilizavel =
    empresa correta
    AND ativo
    AND NOT bloqueado
    AND contexto operacional válido
~~~

---

# 48. Exclusão Física

Fornecedor pode ser fisicamente excluído somente quando não possui dependências históricas impeditivas.

Regra:

> Histórico existente prevalece sobre conveniência de exclusão.

---

# 49. Fornecedor com Vínculo

Fornecedor vinculado a operações:

- não deve ser excluído;
- deve ser inativado quando não for mais utilizado.

Exemplos de vínculos:

- compras;
- financeiro;
- notas;
- produção;
- facção;
- demais processos.

---

# 50. Compra

Entidade externa ao agregado:

`Compra/Pedido de Compra`

Relacionamento conceitual:

`Fornecedor 1:N Compra`

Fornecedor pode possuir várias compras.

---

# 51. Compra Válida

Para indicadores comerciais, compra válida é aquela considerada concluída conforme regra operacional.

Não entram:

- rascunhos;
- abertas não concluídas;
- canceladas.

---

# 52. Histórico de Compras

A aba Compras pode exibir registros em vários estados.

Isso não significa que todos esses registros componham os indicadores.

Separação importante:

- histórico de consulta;
- base de cálculo de indicadores.

---

# 53. Indicadores Comerciais

Indicadores pertencem conceitualmente à visão agregada do fornecedor.

São dados derivados.

Principais indicadores:

- última compra;
- total comprado;
- quantidade de compras;
- ticket médio;
- saldo a pagar.

---

# 54. Última Compra

Representa:

a compra válida mais recente.

Não deve ser baseada simplesmente no último registro criado.

---

# 55. Total Comprado

Representa:

soma líquida das compras válidas do fornecedor.

Operações canceladas não entram.

Devoluções e ajustes efetivos podem reduzir o valor conforme regra de negócio.

---

# 56. Quantidade de Compras

Representa:

quantidade de compras válidas consideradas no cálculo.

---

# 57. Ticket Médio

Valor derivado:

~~~text
Ticket Médio =
    Total Comprado
    /
    Quantidade de Compras Válidas
~~~

Quando quantidade for zero:

o domínio deve retornar valor neutro/coerente.

---

# 58. Título Financeiro

Entidade externa:

`Pagar/PagarItem`

Relacionamento conceitual:

`Fornecedor 1:N Título Financeiro`

Fornecedor pode possuir múltiplos títulos.

---

# 59. Saldo Financeiro

Cada título pode possuir:

- valor original;
- valor pago;
- saldo.

Saldo conceitual:

~~~text
Saldo =
    Valor Original
    -
    Valor Pago
~~~

respeitando status e regras financeiras.

---

# 60. Saldo a Pagar do Fornecedor

Valor derivado:

~~~text
Saldo a Pagar =
    soma dos saldos abertos válidos
~~~

Não entram:

- títulos cancelados;
- parcelas integralmente pagas.

Pagamento parcial entra apenas pelo saldo restante.

---

# 61. Histórico Financeiro

Títulos pagos podem continuar visíveis.

A permanência no histórico não significa composição do saldo.

Separação:

- histórico;
- saldo atual.

---

# 62. Histórico do Fornecedor

O domínio possui visão histórica própria.

Eventos relevantes:

- criação;
- edição;
- ativação;
- inativação;
- bloqueio;
- desbloqueio;
- contatos;
- endereços;
- mudanças de principal;
- outras alterações relevantes.

---

# 63. Auditoria

Entidade externa:

`AuditLog`

Relacionamento conceitual:

`Fornecedor 1:N AuditLog`

A auditoria registra eventos administrativos relevantes.

---

# 64. Dados Sensíveis na Auditoria

Regra:

> Dados bancários sensíveis não devem ser expostos desnecessariamente no conteúdo do log.

A auditoria deve informar o evento sem transformar o AuditLog em repositório paralelo de dados confidenciais.

---

# 65. Consulta do Fornecedor

A consulta é uma projeção do agregado.

Áreas:

- Dados cadastrais;
- Compras;
- Financeiro;
- Histórico.

A consulta não deve alterar o estado do domínio.

---

# 66. Padrão Read-Only

Operação:

`Consultar`

deve ser somente leitura.

Editar é uma ação separada.

Essa separação é importante para:

- segurança;
- UX;
- auditoria;
- permissões.

---

# 67. Invariantes do Domínio

As invariantes abaixo não devem ser quebradas.

## Invariante 1

Fornecedor sempre pertence a uma empresa.

## Invariante 2

Documento informado deve ser válido para o tipo de pessoa.

## Invariante 3

Documento não pode repetir dentro da mesma empresa.

## Invariante 4

Contato pertence à mesma empresa do fornecedor.

## Invariante 5

Endereço pertence à mesma empresa do fornecedor.

## Invariante 6

Somente um contato principal ativo por tipo.

## Invariante 7

Somente um endereço principal ativo por tipo.

## Invariante 8

Prazo padrão deve pertencer à mesma empresa.

## Invariante 9

Conta contábil padrão deve pertencer à mesma empresa.

## Invariante 10

Natureza padrão deve pertencer à mesma empresa.

## Invariante 11

Fornecedor inativo não pode ser usado em nova operação.

## Invariante 12

Fornecedor bloqueado não pode ser usado em nova operação.

## Invariante 13

Fornecedor vinculado não deve ser fisicamente excluído.

## Invariante 14

Dados bancários não podem ser expostos a usuário sem autorização.

---

# 68. Regras de Transição de Estado

## Ativar

~~~text
INATIVO
  ↓
ATIVO
~~~

## Inativar

~~~text
ATIVO
  ↓
INATIVO
~~~

## Bloquear

~~~text
NÃO BLOQUEADO
  ↓
BLOQUEADO
~~~

## Desbloquear

~~~text
BLOQUEADO
  ↓
NÃO BLOQUEADO
~~~

Atividade e bloqueio são dimensões diferentes.

---

# 69. Estado Operacional Combinado

Exemplos:

## Ativo + Não bloqueado

Utilizável.

## Ativo + Bloqueado

Não utilizável.

## Inativo + Não bloqueado

Não utilizável.

## Inativo + Bloqueado

Não utilizável.

Representação:

~~~text
Utilizável somente quando:

ATIVO = SIM
e
BLOQUEADO = NÃO
~~~

---

# 70. Dependências de Domínio

Fornecedor se relaciona com:

- Empresa;
- Categoria;
- Contato;
- Endereço;
- PrazoPagamento;
- PlanoContabil;
- Nat_Lancamento;
- Compras;
- Financeiro;
- Auditoria;
- Usuário.

Essas dependências não devem ser duplicadas em novas estruturas paralelas.

---

# 71. Campos Legados

Atualmente existem campos mantidos por compatibilidade.

Entre eles:

- `cnpj`
- `categoria`
- `prazo_padrao_pagamento`
- `conta_contabil`

Eles não representam a direção ideal do domínio.

A direção preferencial é:

- `documento`
- `FornecedorCategoria`
- `prazo_padrao_pagamento_ref`
- `conta_contabil_padrao`

---

# 72. Estratégia para Legado

Nunca remover campo legado diretamente.

Processo correto:

1. localizar dependências;
2. criar estrutura nova;
3. espelhar quando necessário;
4. migrar consumidores;
5. testar;
6. só depois avaliar remoção.

---

# 73. Entidades Não Criadas na Fase 1

Não fazem parte ainda do domínio implementado:

- FornecedorAvaliacao;
- FornecedorScore;
- Banco oficial;
- FornecedorDocumento/Anexo;
- FornecedorPreferencial.

---

# 74. Fase 2

A Fase 2 deverá ampliar o domínio com inteligência de fornecedor.

Conceitos planejados:

- Avaliação;
- Critério de Avaliação;
- Peso;
- Score Geral;
- Score por Categoria;
- Classificação;
- Histórico de Score;
- Comparação.

---

# 75. Avaliação Planejada

Entidade conceitual futura:

`FornecedorAvaliacao`

Relacionamento:

`Fornecedor 1:N FornecedorAvaliacao`

Cada avaliação poderá estar associada a:

- fornecedor;
- empresa;
- categoria;
- data;
- avaliador;
- critérios;
- notas;
- observação.

---

# 76. Critérios Planejados

Critérios previstos:

- Qualidade;
- Prazo;
- Custo-benefício;
- Atendimento;
- Confiabilidade;
- Qualidade da entrega;
- Problemas/Devoluções.

Escala prevista:

1 a 5.

---

# 77. Pesos Planejados

Pesos padrão previstos:

- Qualidade — 25%;
- Prazo — 20%;
- Confiabilidade — 15%;
- Custo-benefício — 15%;
- Qualidade da entrega — 10%;
- Atendimento — 10%;
- Problemas/Devoluções — 5%.

Regra futura:

> soma dos pesos = 100%.

---

# 78. Score Planejado

Faixa:

0 a 100.

Classificações planejadas:

- 90–100 — Excelente;
- 75–89 — Bom;
- 60–74 — Regular;
- abaixo de 60 — Ruim.

Sem avaliação:

`Não avaliado`

---

# 79. Recência Planejada

As avaliações mais recentes terão peso maior.

Planejamento atual:

- 1ª mais recente — 35%;
- 2ª — 25%;
- 3ª — 20%;
- 4ª — 12%;
- 5ª — 8%.

Quando houver menos avaliações, os pesos devem ser normalizados.

---

# 80. Separação entre Score e Lifecycle

Regra futura importante:

> Score ruim não significa fornecedor automaticamente bloqueado.

Score:

indicador de desempenho.

Bloqueio:

decisão operacional/administrativa.

Um fornecedor com score ruim poderá:

- gerar alerta;
- exigir confirmação;

mas não deverá ser automaticamente bloqueado apenas pelo score.

---

# 81. Score por Categoria

Fornecedor poderá possuir desempenho diferente conforme categoria.

Exemplo:

Fornecedor ABC:

- Matéria-prima: 92;
- Facção: 68.

O domínio futuro deve permitir essa diferença.

---

# 82. Score Geral

O Score Geral deverá representar visão consolidada do fornecedor.

Não deve eliminar o Score por Categoria.

Os dois conceitos precisam coexistir.

---

# 83. Comparação de Fornecedores

Funcionalidade futura:

comparar dois ou mais fornecedores da mesma categoria.

Critérios possíveis:

- score;
- qualidade;
- prazo;
- preço;
- confiabilidade;
- indicadores comerciais.

Não faz parte da Fase 1.

---

# 84. Anexos

Anexos/documentos do fornecedor foram deliberadamente retirados da Fase 1.

Motivo:

- custo de armazenamento;
- complexidade operacional;
- prioridade atual.

Uma eventual entidade futura deve considerar política de armazenamento do SaaS.

---

# 85. Banco Oficial

Entidade futura possível:

`Banco`

Atributos a definir:

- código;
- ISPB;
- nome;
- nome reduzido;
- ativo.

A fonte deverá ser oficial.

Não implementar sem definição da estratégia de identificação bancária.

---

# 86. Inscrição Estadual Futura

Validação futura deve considerar UF.

Não existe uma única regra nacional simples.

O domínio deverá associar validação ao estado quando essa funcionalidade for priorizada.

---

# 87. Inscrição Municipal Futura

Validação municipal possui maior variabilidade.

A implementação futura deve considerar custo-benefício antes de tentar suportar todos os municípios.

---

# 88. Regra de Evolução

Qualquer expansão futura deve preservar:

- isolamento multiempresa;
- histórico;
- segurança bancária;
- lifecycle;
- compatibilidade;
- auditoria;
- indicadores já homologados.

---

# 89. Estado Atual

O modelo de domínio da Fase 1 contempla:

- identificação;
- documento;
- categorias;
- contatos;
- endereços;
- fiscal;
- comercial;
- contábil;
- financeiro;
- bancário;
- lifecycle;
- compras;
- títulos;
- indicadores;
- auditoria;
- multiempresa.

---

# 90. Homologação

A Fase 1 foi homologada manualmente em:

**30 de 30 itens.**

Resultado:

> **APROVADO**

---

# 91. Conclusão

O domínio de Fornecedores da Fase 1 constitui a base operacional estável para utilização do fornecedor em todo o SISVAR.

As expansões futuras devem ocorrer sobre esse modelo, evitando estruturas paralelas e preservando as invariantes registradas neste documento.

Status final:

> **MODELO DE DOMÍNIO — FORNECEDORES FASE 1 — HOMOLOGADO**