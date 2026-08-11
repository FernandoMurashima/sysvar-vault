# Homologação - Cadastros - Fornecedores

## 1. Identificação

- **Projeto:** Sysvar
- **Módulo:** Cadastros
- **Funcionalidade:** Fornecedores
- **Fase:** Fase 1 — Cadastro e Gestão Operacional
- **Data de encerramento da homologação:** 11/08/2026
- **Situação:** APROVADO
- **Resultado:** 30 de 30 itens homologados manualmente
- **Próxima fase funcional:** Fase 2 — Avaliação e Inteligência de Fornecedores

---

# 2. Resultado Final

> **APROVADO**

A Fase 1 do cadastro de Fornecedores foi implementada, testada e homologada manualmente.

Foram homologados:

- cadastro PF e PJ;
- fornecedor com e sem documento;
- controle de duplicidade;
- múltiplas categorias;
- múltiplos contatos;
- múltiplos endereços;
- contato principal por tipo;
- endereço principal por tipo;
- inativação e reativação de contatos;
- inativação e reativação de endereços;
- dados fiscais;
- dados comerciais;
- dados contábeis padrão;
- dados financeiros padrão;
- dados bancários;
- controle de permissão sobre dados bancários;
- exclusão protegida;
- ativação e inativação;
- bloqueio e desbloqueio;
- restrição de fornecedores inativos ou bloqueados em novas operações;
- histórico;
- integração com Audit Central;
- indicadores comerciais;
- consulta de compras;
- consulta financeira;
- detecção de possíveis duplicidades;
- utilização contextual das categorias;
- fornecedores sem documento em operações normais;
- regressão geral da funcionalidade.

Nenhuma pendência encontrada durante a homologação impede o uso operacional da Fase 1.

---

# 3. Escopo Homologado

## 3.1. Identificação do fornecedor

O cadastro aceita fornecedores dos tipos:

- Pessoa Física — PF;
- Pessoa Jurídica — PJ.

O campo funcional para identificação fiscal é:

- `documento`.

O campo legado `cnpj` permanece temporariamente por compatibilidade com partes anteriores do sistema.

### Pessoa Física

Quando o fornecedor for PF:

- o documento informado é tratado como CPF;
- quando informado, o CPF deve ser válido.

### Pessoa Jurídica

Quando o fornecedor for PJ:

- o documento informado é tratado como CNPJ;
- quando informado, o CNPJ deve ser válido.

---

# 4. Documento Opcional

Foi homologada a possibilidade de cadastrar fornecedor sem CPF ou CNPJ.

Regras:

- documento não é obrigatório;
- podem existir vários fornecedores sem documento dentro da mesma empresa;
- não é criado documento artificial;
- fornecedor sem documento pode participar normalmente das operações permitidas;
- quando o documento for informado, passa a valer a validação correspondente a PF ou PJ.

Esta regra é necessária principalmente para situações em que o cadastro inicial do fornecedor é realizado antes do recebimento completo de seus dados fiscais.

---

# 5. Unicidade do Documento

A unicidade é controlada por:

**empresa + documento**

Portanto:

- o mesmo CPF/CNPJ não pode existir duas vezes dentro da mesma empresa;
- o mesmo CPF/CNPJ pode existir em empresas diferentes;
- fornecedores sem documento não sofrem bloqueio de duplicidade pelo campo documento.

A regra foi homologada em ambiente multiempresa.

---

# 6. Possível Duplicidade por Nome ou Apelido

Quando não existe documento para realizar a identificação objetiva, o sistema pode detectar fornecedores com nomes ou apelidos semelhantes.

A regra homologada é:

- nome semelhante não bloqueia automaticamente o cadastro;
- o sistema apresenta aviso de possível duplicidade;
- o usuário pode cancelar;
- o usuário autorizado pode confirmar e continuar;
- a decisão não substitui a regra rígida de documento quando CPF/CNPJ estiver informado.

O objetivo é reduzir cadastros duplicados sem impedir fornecedores legitimamente distintos com nomes semelhantes.

---

# 7. Categorias de Fornecedor

Um fornecedor pode possuir múltiplas categorias simultaneamente.

Categorias homologadas:

- Matéria-prima;
- Aviamento;
- Produto de revenda;
- Facção;
- Prestador de serviço;
- Transportadora;
- Outros.

Valores internos atualmente utilizados:

- `MATERIA_PRIMA`
- `AVIAMENTO`
- `REVENDA`
- `FACCAO`
- `PRESTADOR`
- `TRANSPORTADORA`
- `OUTROS`

---

# 8. Uso Operacional das Categorias

As categorias são utilizadas como:

- classificação;
- filtro;
- priorização;
- apoio à seleção contextual de fornecedores.

Elas não devem ser interpretadas automaticamente como bloqueios universais.

Exemplos:

- operação de facção deve priorizar fornecedor `FACCAO`;
- compra de produto para revenda deve priorizar `REVENDA`;
- compra de matéria-prima deve priorizar `MATERIA_PRIMA`;
- operação relacionada a transporte pode utilizar `TRANSPORTADORA`.

A homologação confirmou o comportamento contextual das categorias.

---

# 9. Múltiplos Contatos

O fornecedor pode possuir quantidade ilimitada de contatos.

Dados previstos para cada contato:

- nome;
- cargo ou função;
- tipo;
- telefone;
- WhatsApp;
- e-mail;
- observação;
- principal;
- ativo/inativo.

Tipos de contato:

- Comercial;
- Financeiro;
- Fiscal;
- Produção/Facção;
- Logística;
- Outro.

Valores internos:

- `COMERCIAL`
- `FINANCEIRO`
- `FISCAL`
- `PRODUCAO_FACCAO`
- `LOGISTICA`
- `OUTRO`

---

# 10. Contato Principal

É permitido possuir vários contatos do mesmo tipo.

Porém:

> somente um contato ativo pode ser principal para cada tipo.

Exemplo:

Pode existir:

- João — Comercial;
- Maria — Comercial;
- Carlos — Financeiro.

Mas somente João **ou** Maria pode ser o contato Comercial principal simultaneamente.

Ao definir outro contato do mesmo tipo como principal, a regra de unicidade é preservada.

A regra foi homologada manualmente.

---

# 11. Telefone e WhatsApp dos Contatos

Durante a homologação foi identificado e corrigido um problema de validação.

Anteriormente, o frontend exigia uma máscara rígida semelhante a:

`(21)-99008-7565`

Isso fazia o formulário ficar inválido e impedia silenciosamente o envio do POST quando o usuário digitava telefone em formato normal.

A correção foi implementada.

Atualmente:

- telefone vazio é permitido;
- WhatsApp vazio é permitido;
- 10 dígitos representam telefone estruturalmente válido;
- 11 dígitos representam celular estruturalmente válido;
- a validação utiliza os dígitos e não a pontuação da máscara.

Formato visual:

`(21) 3324-4000`

ou:

`(21) 99008-7565`

Payload enviado à API:

`2133244000`

ou:

`21990087565`

Também foram corrigidos os campos:

- telefone1;
- telefone2.

---

# 12. Ciclo dos Contatos

Foram homologadas as operações:

- criar;
- consultar;
- editar;
- inativar;
- reativar;
- definir como principal.

Contato inativo:

- permanece associado ao fornecedor;
- continua disponível para histórico;
- não é tratado como contato operacional ativo.

---

# 13. Múltiplos Endereços

O fornecedor pode possuir múltiplos endereços.

Tipos previstos:

- Fiscal;
- Comercial;
- Cobrança;
- Retirada/Coleta;
- Entrega;
- Unidade Fabril;
- Outro.

Dados previstos por endereço:

- tipo;
- logradouro/endereço;
- número;
- complemento;
- CEP;
- bairro;
- cidade;
- UF;
- principal;
- ativo/inativo;
- observação.

---

# 14. Endereço Principal

É permitido possuir vários endereços do mesmo tipo.

Porém:

> somente um endereço ativo pode ser principal para cada tipo.

A alteração do endereço principal preserva automaticamente essa regra.

A funcionalidade foi homologada manualmente.

---

# 15. Ciclo dos Endereços

Foram homologadas:

- criação;
- edição;
- consulta;
- inativação;
- reativação;
- definição de principal.

O endereço inativo permanece registrado para preservação histórica.

---

# 16. Dados Fiscais

Foram disponibilizados os seguintes dados fiscais:

- Inscrição Estadual;
- Inscrição Municipal;
- Contribuinte ICMS.

## 16.1. Contribuinte ICMS

O campo é estruturado.

Opções disponíveis:

- Não informado;
- Sim;
- Não;
- Isento.

Valores internos:

- `SIM`
- `NAO`
- `ISENTO`

O usuário não precisa conhecer os valores internos.

---

# 17. Inscrição Estadual — Decisão Temporária

A Inscrição Estadual permanece, nesta fase:

- opcional;
- texto livre;
- sem validação específica conforme a UF.

Isso foi deliberadamente mantido durante a homologação.

Não constitui falha da Fase 1.

## Pendência futura

Implementar validação de Inscrição Estadual de acordo com as regras específicas de cada estado quando esta necessidade for priorizada.

---

# 18. Inscrição Municipal — Decisão Temporária

A Inscrição Municipal permanece:

- opcional;
- texto livre;
- sem validação municipal específica.

Isso foi deliberadamente mantido durante a homologação.

## Pendência futura

Avaliar estratégia de validação conforme disponibilidade e necessidade operacional, considerando que as regras dependem dos municípios.

---

# 19. Dados Comerciais

Foram homologados:

- site;
- prazo padrão de pagamento;
- observações comerciais.

---

# 20. Prazo Padrão de Pagamento

O prazo padrão deixou de ser apenas um número digitado livremente.

A implementação utiliza o cadastro existente:

`financeiro.PrazoPagamento`

O fornecedor possui referência estruturada através de:

`prazo_padrao_pagamento_ref`

O campo legado:

`prazo_padrao_pagamento`

foi preservado temporariamente para compatibilidade.

A interface apresenta os prazos já cadastrados.

Exemplos:

- À vista;
- 30 dias;
- 30/60;
- 30/60/90.

A seleção respeita a empresa atual.

Fornecedor de uma empresa não pode utilizar prazo pertencente a outra empresa.

---

# 21. Conta Contábil Padrão

A conta contábil padrão passou a utilizar o Plano Contábil existente no SISVAR.

Modelo:

`cadastros.PlanoContabil`

Campo estruturado:

`conta_contabil_padrao`

O campo legado:

`conta_contabil`

permanece temporariamente para compatibilidade.

Na interface, as contas são apresentadas preferencialmente no formato:

`CÓDIGO - DESCRIÇÃO`

Exemplo:

`2.1.01.001 - Fornecedores Nacionais`

Somente contas:

- da empresa atual;
- ativas;
- analíticas;

podem ser utilizadas como conta contábil padrão do fornecedor.

---

# 22. Natureza Financeira Padrão

A natureza padrão utiliza a estrutura já existente:

`cadastros.Nat_Lancamento`

Campo:

`natureza_padrao`

A interface utiliza seleção baseada nas naturezas cadastradas.

São respeitadas:

- empresa atual;
- situação ativa;
- regras existentes do cadastro de Natureza de Lançamento.

Fornecedor não pode utilizar natureza pertencente a outra empresa.

Na consulta é exibido código e descrição, evitando a apresentação de IDs internos ao usuário.

---

# 23. Dados Bancários

Foram homologados os seguintes campos:

- Banco;
- Agência;
- Conta;
- Tipo de conta;
- Chave PIX;
- Favorecido;
- Documento do favorecido;
- Observação bancária.

---

# 24. Tipo de Conta Bancária

O tipo de conta não é mais entrada de texto livre.

Opções estruturadas:

- Conta corrente;
- Conta poupança;
- Conta de pagamento;
- Outra.

Valores internos:

- `CORRENTE`
- `POUPANCA`
- `PAGAMENTO`
- `OUTRA`

Dessa forma, o usuário não precisa conhecer códigos internos como `CORRENTE`.

---

# 25. Cadastro Oficial de Bancos — Pendência Futura

O campo Banco continua temporariamente sem integração com cadastro oficial BACEN.

Foi decidido não implementar esta integração durante a Fase 1.

## Direção futura

Criar cadastro padronizado de instituições bancárias utilizando fonte oficial.

A interface deverá futuramente apresentar algo semelhante a:

`341 - Itaú Unibanco`

`237 - Bradesco`

O identificador bancário definitivo utilizado internamente deverá ser definido quando essa funcionalidade for implementada.

A escolha entre código COMPE, ISPB ou combinação apropriada deverá ser analisada na implementação futura.

---

# 26. Segurança dos Dados Bancários

Os dados bancários possuem proteção específica por permissão.

Permissão utilizada no projeto:

`fornecedor.dados_bancarios`

Usuário autorizado:

- visualiza os dados bancários;
- pode editar conforme suas demais permissões.

Usuário sem autorização:

- não recebe os valores sensíveis;
- não visualiza os dados bancários reais.

Durante a homologação foi observado que a interface pode manter os campos bancários visualmente presentes, porém vazios, quando o usuário não possui permissão.

Essa situação foi aceita na Fase 1 porque os valores permanecem protegidos.

## Melhoria futura de UX

Avaliar substituir os campos vazios por:

`Dados bancários — acesso restrito`

ou ocultar completamente a seção para usuários sem permissão.

Isso é uma melhoria de experiência de uso e não uma falha de segurança identificada na homologação.

---

# 27. Exclusão Protegida

A exclusão física é permitida somente quando o fornecedor não possui registros históricos vinculados.

Fornecedor sem vínculos:

- pode ser fisicamente excluído.

Fornecedor com vínculos:

- não pode ser excluído;
- deve ser inativado.

Mensagem funcional esperada:

> Este fornecedor possui compras ou outros registros vinculados e não pode ser excluído. Utilize a inativação.

São preservados vínculos históricos relacionados, entre outros, a:

- compras;
- financeiro;
- entradas;
- produção;
- facção;
- demais operações que dependam do fornecedor.

A regra foi homologada.

---

# 28. Ativação e Inativação

O status do fornecedor não deve ser alterado diretamente como simples edição de campo.

São utilizadas ações específicas:

- Ativar;
- Inativar.

Fornecedor inativo:

- permanece cadastrado;
- preserva histórico;
- não pode ser utilizado em novas operações.

Fornecedor reativado:

- volta a ficar disponível para novas operações, respeitadas as demais regras.

O ciclo completo foi homologado.

---

# 29. Bloqueio e Desbloqueio

São utilizadas ações específicas:

- Bloquear;
- Desbloquear.

O bloqueio registra informações relacionadas à ação.

Entre elas:

- motivo;
- observação;
- data/hora;
- usuário responsável.

Fornecedor bloqueado:

- permanece cadastrado;
- preserva histórico;
- não pode participar de novas operações.

O desbloqueio restaura sua utilização operacional, desde que esteja ativo.

---

# 30. Restrições Operacionais

Foi homologado que fornecedores:

- inativos;
- bloqueados;

não podem ser utilizados em novas operações.

As operações devem:

- ocultar fornecedores não utilizáveis quando apropriado;

ou:

- rejeitar a utilização no backend.

A proteção não pode depender exclusivamente da interface.

O histórico existente permanece íntegro.

---

# 31. Histórico do Fornecedor

A consulta do fornecedor possui aba:

**Histórico**

Foram homologados registros relacionados a:

- edição;
- bloqueio;
- desbloqueio;
- inativação;
- reativação;
- alterações de contatos;
- alterações de endereços;
- alterações de principal;
- demais eventos auditáveis da Fase 1.

Os eventos permitem identificar:

- ação;
- data/hora;
- usuário responsável;
- informação suficiente para rastrear a alteração.

---

# 32. Audit Central

Os eventos relevantes também são registrados na Audit Central.

A homologação confirmou a rastreabilidade do fornecedor entre:

- histórico próprio;
- auditoria central.

Essa integração é obrigatória para operações administrativas relevantes.

---

# 33. Consulta do Fornecedor

A consulta está organizada em abas:

1. Dados cadastrais;
2. Compras;
3. Financeiro;
4. Histórico.

A consulta é somente leitura.

---

# 34. Indicadores Comerciais

No topo da consulta são apresentados:

- Última compra;
- Total comprado;
- Quantidade de compras;
- Ticket médio;
- Saldo a pagar.

---

# 35. Regra da Última Compra

Considera a compra válida mais recente do fornecedor.

Operações canceladas ou ainda não concluídas não devem distorcer o indicador comercial.

---

# 36. Total Comprado

Representa o total líquido das compras consideradas válidas.

Não entram no indicador:

- compras canceladas;
- pedidos em aberto;
- rascunhos.

Ajustes, devoluções ou reversões concluídas devem reduzir o valor quando aplicável ao processo correspondente.

---

# 37. Quantidade de Compras

Representa a quantidade de compras válidas/concluídas consideradas para os indicadores comerciais.

Não entram:

- canceladas;
- abertas;
- rascunhos.

---

# 38. Ticket Médio

Regra:

**Ticket médio = Total comprado / Quantidade de compras**

Quando não existem compras válidas, o sistema deve evitar divisão inválida e apresentar comportamento coerente com ausência de histórico.

---

# 39. Saldo a Pagar

Representa somente o saldo financeiro efetivamente aberto relacionado ao fornecedor.

Regras homologadas:

- título aberto entra no saldo;
- pagamento parcial reduz o saldo;
- título totalmente pago possui saldo zero;
- título cancelado não compõe o saldo a pagar;
- título pago pode continuar aparecendo no histórico financeiro.

---

# 40. Aba Compras

A aba Compras apresenta o histórico de compras do fornecedor.

Podem ser apresentados registros:

- concluídos;
- abertos;
- cancelados;

desde que seus respectivos status estejam identificados.

Somente compras pertencentes:

- ao fornecedor consultado;
- à empresa atual;

podem ser exibidas.

Compras abertas ou canceladas podem aparecer na consulta histórica, porém não alteram indevidamente os indicadores comerciais.

---

# 41. Aba Financeiro

A aba Financeiro apresenta títulos relacionados ao fornecedor.

Quando aplicável, são apresentados:

- documento/origem;
- data de emissão;
- vencimento;
- valor original;
- valor pago;
- saldo;
- status;
- natureza financeira;
- loja.

Somente dados:

- do fornecedor consultado;
- da empresa atual;

podem ser exibidos.

Títulos pagos:

- permanecem no histórico;
- apresentam saldo zero.

Títulos cancelados:

- podem permanecer visíveis historicamente;
- não compõem o saldo a pagar.

Pagamentos parciais:

- apresentam o saldo restante.

---

# 42. Multiempresa

Fornecedor pertence obrigatoriamente a uma empresa.

As principais regras da Fase 1 respeitam isolamento multiempresa.

Entre elas:

- documento;
- categorias;
- compras;
- financeiro;
- prazo padrão;
- conta contábil padrão;
- natureza financeira padrão;
- contatos;
- endereços;
- indicadores.

Não deve existir acesso cruzado indevido entre empresas.

---

# 43. Itens Homologados

## Item 1 — Abertura da tela de Fornecedores

**Resultado:** OK

Tela carregada corretamente.

---

## Item 2 — Paginação server-side

**Resultado:** OK

Paginação validada.

---

## Item 3 — Filtros server-side

**Resultado:** OK

Busca e filtros validados.

---

## Item 4 — Cadastro de fornecedor PF

**Resultado:** OK

Cadastro de Pessoa Física homologado.

---

## Item 5 — Cadastro de fornecedor PJ

**Resultado:** OK

Cadastro de Pessoa Jurídica homologado.

---

## Item 6 — Fornecedor sem documento

**Resultado:** OK

Cadastro sem CPF/CNPJ permitido conforme regra definida.

---

## Item 7 — Validação de documento inválido

**Resultado:** OK

CPF/CNPJ inválidos são rejeitados quando informados.

---

## Item 8 — Documento duplicado na mesma empresa

**Resultado:** OK

Duplicidade impedida.

---

## Item 9 — Mesmo documento em empresas diferentes

**Resultado:** OK

Permitido conforme arquitetura multiempresa.

---

## Item 10 — Múltiplas categorias

**Resultado:** OK

Fornecedor pode possuir várias categorias.

---

## Item 11 — Múltiplos contatos

**Resultado:** OK

Persistência, consulta e correção da máscara de telefone homologadas.

---

## Item 12 — Múltiplos endereços

**Resultado:** OK

Cadastro e consulta homologados.

---

## Item 13 — Endereço principal por tipo

**Resultado:** OK

Somente um principal ativo por tipo.

---

## Item 14 — Contato principal por tipo

**Resultado:** OK

Somente um principal ativo por tipo.

---

## Item 15 — Inativar e reativar contato

**Resultado:** OK

Ciclo de contato homologado.

---

## Item 16 — Inativar e reativar endereço

**Resultado:** OK

Ciclo de endereço homologado.

---

## Item 17 — Dados fiscais, comerciais, contábeis e financeiros padrão

**Resultado:** OK

Homologados:

- Contribuinte ICMS;
- Prazo padrão;
- Conta contábil padrão;
- Natureza financeira padrão;
- Tipo de conta.

Decisões adiadas:

- validação IE;
- validação IM;
- cadastro BACEN.

---

## Item 18 — Dados bancários e permissões

**Resultado:** OK

Usuário autorizado visualiza e edita.

Usuário sem autorização não visualiza os valores sensíveis.

Observação de UX:

- campos podem permanecer visíveis vazios para usuário sem permissão;
- melhoria visual foi adiada.

---

## Item 19 — Exclusão protegida

**Resultado:** OK

Fornecedor sem vínculo pode ser excluído.

Fornecedor com histórico não pode ser excluído.

---

## Item 20 — Ativar/Inativar

**Resultado:** OK

Ciclo homologado.

---

## Item 21 — Bloquear/Desbloquear

**Resultado:** OK

Ciclo homologado.

---

## Item 22 — Restrição operacional para inativo/bloqueado

**Resultado:** OK

Fornecedor não utilizável foi impedido em novas operações.

---

## Item 23 — Histórico e Audit Central

**Resultado:** OK

Rastreabilidade homologada.

---

## Item 24 — Indicadores comerciais

**Resultado:** OK

Homologados:

- última compra;
- total comprado;
- quantidade;
- ticket médio;
- saldo a pagar.

---

## Item 25 — Aba Compras

**Resultado:** OK

Histórico de compras homologado.

---

## Item 26 — Aba Financeiro

**Resultado:** OK

Histórico financeiro e saldo homologados.

---

## Item 27 — Possível duplicidade por nome/apelido

**Resultado:** OK

Aviso não bloqueante homologado.

---

## Item 28 — Categorias no uso operacional

**Resultado:** OK

Comportamento contextual homologado.

---

## Item 29 — Fornecedor sem documento em operação normal

**Resultado:** OK

Fornecedor sem documento pode participar das operações quando ativo, desbloqueado e adequado à operação.

---

## Item 30 — Regressão final

**Resultado:** OK

Não foram identificadas regressões nas funcionalidades homologadas anteriormente.

---

# 44. Correções Realizadas Durante a Homologação

## 44.1. Persistência e consulta de contatos e endereços

Foi identificado inicialmente que contatos e endereços não estavam sendo apresentados adequadamente na consulta.

A correção passou a apresentar explicitamente:

- Contatos cadastrados;
- Endereços cadastrados;
- estados vazios;
- edição;
- inativação;
- reativação;
- principal;
- atualização após salvamento.

Também foi ajustado o controle de permissão de leitura dos registros filhos.

---

# 45. Correção da Validação de Telefones

Foi identificado que o frontend utilizava validação dependente de máscara rígida.

Problema:

- formulário ficava inválido;
- `salvarContato()` retornava sem enviar POST;
- usuário não recebia explicação clara.

Correção:

- validação por quantidade de dígitos;
- máscara brasileira correta;
- erro visível;
- formatação automática;
- envio somente de dígitos.

Commit frontend:

`a3fe7235f5999652d47cb54589000b59a6b5da5b`

Mensagem:

`Corrige validacao de telefones de fornecedores`

---

# 46. Correção dos Padrões Fiscais e Financeiros

Foram estruturados:

- Contribuinte ICMS;
- Prazo padrão;
- Conta contábil padrão;
- Natureza financeira padrão;
- Tipo de conta.

Foi criada migration:

`cadastros/migrations/0025_fornecedor_conta_contabil_padrao_and_more.py`

Commit backend:

`a2b192b60a31b0f38db2e2ab4b0c9c9aca3c10ee`

Mensagem:

`Ajusta padroes fiscais e financeiros de fornecedores`

Commit frontend:

`37e68377bcecfc4ef35032cbb942d7a463ab58c6`

Mensagem:

`Ajusta seletores fiscais e financeiros de fornecedores`

---

# 47. Principais Commits da Fase 1

## Implementação inicial parcial

Backend:

`0454e49318a15613d45de1c09d745b9406925c25`

Frontend:

`fdcf7770c17dbe1034f69039f79223ea97979d27`

---

## Conclusão da Fase 1

Backend:

`993f473ca793193a7590327964b4f3a20e5780e7`

Mensagem:

`Conclui fase 1 do cadastro de fornecedores`

Frontend:

`a573d068e8bb031ea7aae0ebc0196c9bbf7ad78c`

Mensagem:

`Conclui fase 1 da interface de fornecedores`

---

## Correção de contatos e endereços

Backend:

`c65e0e737a725741907cc298e52c314cf93efab8`

Mensagem:

`Corrige contatos e enderecos de fornecedores`

Frontend:

`8e767bda4e70efd826497526dea70aaf903e860c`

Mensagem:

`Corrige consulta de contatos e enderecos de fornecedores`

---

## Correção de telefones

Frontend:

`a3fe7235f5999652d47cb54589000b59a6b5da5b`

Mensagem:

`Corrige validacao de telefones de fornecedores`

Backend:

não alterado nessa correção.

---

## Ajustes fiscais e financeiros

Backend:

`a2b192b60a31b0f38db2e2ab4b0c9c9aca3c10ee`

Mensagem:

`Ajusta padroes fiscais e financeiros de fornecedores`

Frontend:

`37e68377bcecfc4ef35032cbb942d7a463ab58c6`

Mensagem:

`Ajusta seletores fiscais e financeiros de fornecedores`

---

# 48. Testes Automatizados Registrados

Os números abaixo correspondem aos resultados registrados durante a conclusão/correções da Fase 1.

## Backend — conclusão inicial da Fase 1

Registrado:

- `manage.py check` — OK
- `manage.py makemigrations --check --dry-run` — OK
- `cadastros.tests.FornecedorFase1Tests` — 12 OK
- `cadastros` — 54 OK
- `auditoria accounts` — 55 OK
- suíte geral — 109 OK

---

## Correção de contatos/endereço

Registrado:

- `FornecedorFase1Tests` — 13 OK
- `cadastros` — 55 OK
- `auditoria` — 21 OK
- suíte geral — 110 OK

---

## Ajustes fiscais/financeiros — resultado mais recente registrado

Backend:

- `manage.py check` — OK
- `manage.py makemigrations --check --dry-run` — OK
- `cadastros.tests.FornecedorFase1Tests` — 14 OK
- `manage.py test cadastros` — 56 OK
- `manage.py test auditoria` — 21 OK
- `manage.py test` — 111 OK

Frontend:

- TypeScript — OK
- Karma — 114 SUCCESS
- Angular development build — OK

Esses resultados representam testes automatizados registrados durante a implementação.

A aprovação final desta homologação também dependeu dos 30 testes manuais executados posteriormente.

---

# 49. Pendências Conhecidas

As pendências abaixo foram conscientemente deixadas fora da Fase 1.

## 49.1. Validação de Inscrição Estadual

Implementar futuramente validação conforme UF.

Status:

**PENDENTE — NÃO BLOQUEIA FASE 1**

---

## 49.2. Validação de Inscrição Municipal

Avaliar estratégia futura.

Status:

**PENDENTE — NÃO BLOQUEIA FASE 1**

---

## 49.3. Cadastro oficial de bancos

Implementar futuramente cadastro baseado em fonte oficial, considerando códigos bancários adequados ao SISVAR.

Status:

**PENDENTE — NÃO BLOQUEIA FASE 1**

---

## 49.4. UX de dados bancários restritos

Atualmente usuário sem permissão não recebe os valores, mas pode visualizar a estrutura dos campos vazios.

Avaliar futuramente:

- ocultar a seção;

ou:

- apresentar mensagem de acesso restrito.

Status:

**MELHORIA DE UX — NÃO BLOQUEIA FASE 1**

---

# 50. Itens Expressamente Fora da Fase 1

Não pertencem à Fase 1:

- anexos/documentos de fornecedor;
- validação completa de IE;
- validação completa de IM;
- integração BACEN;
- avaliação estruturada de fornecedores;
- score geral;
- score por categoria;
- comparação de fornecedores;
- pesos configuráveis;
- alertas de desempenho;
- fornecedor preferencial por categoria.

---

# 51. Fase 2 — Escopo Reservado

A próxima fase funcional de Fornecedores deverá tratar inteligência e avaliação.

Está reservada para a Fase 2:

- avaliações estruturadas;
- avaliação por categoria;
- histórico de avaliações;
- pesos configuráveis por empresa;
- recálculo do score atual;
- Score Geral de Fornecedor;
- Score por Categoria;
- peso maior para avaliações recentes;
- classificação Excelente / Bom / Regular / Ruim;
- alerta para fornecedor com desempenho ruim;
- utilização do score na seleção;
- filtros e ordenação por score;
- comparação entre fornecedores.

A Fase 2 não foi implementada nem homologada neste documento.

---

# 52. Critérios Planejados para Fase 2

Escala prevista:

1 a 5.

Critérios previstos:

- Qualidade;
- Prazo;
- Preço/Custo-benefício;
- Atendimento;
- Confiabilidade;
- Qualidade da entrega;
- Problemas/Devoluções.

Pesos padrão atualmente planejados:

- Qualidade — 25%;
- Prazo — 20%;
- Confiabilidade — 15%;
- Custo-benefício — 15%;
- Qualidade da entrega — 10%;
- Atendimento — 10%;
- Problemas/Devoluções — 5%.

Os pesos deverão ser configuráveis por empresa e totalizar 100%.

---

# 53. Score Planejado para Fase 2

Classificação prevista:

- 90 a 100 — Excelente;
- 75 a 89 — Bom;
- 60 a 74 — Regular;
- abaixo de 60 — Ruim.

Fornecedor sem avaliação:

**Não avaliado**

Fornecedor com score ruim:

- não será automaticamente bloqueado;
- poderá gerar alerta;
- eventual seleção poderá exigir confirmação.

A situação operacional continuará separada da avaliação.

---

# 54. Peso de Recência Planejado

Planejamento atual para as cinco avaliações mais recentes:

- mais recente — 35%;
- segunda — 25%;
- terceira — 20%;
- quarta — 12%;
- quinta — 8%.

Quando existirem menos de cinco avaliações, os pesos deverão ser normalizados.

Essas regras pertencem à Fase 2 e ainda precisarão ser confirmadas antes da implementação definitiva.

---

# 55. Conclusão

A Fase 1 de `Cadastros > Fornecedores` está:

> **IMPLEMENTADA, TESTADA E HOMOLOGADA**

Resultado manual:

**30/30 ITENS APROVADOS**

A funcionalidade está liberada para prosseguir dentro do desenvolvimento do SISVAR, respeitadas as pendências conhecidas e o escopo reservado para fases futuras.

A próxima atividade de documentação deverá registrar:

- Mapa Técnico — Cadastros — Fornecedores;
- Modelo de Domínio — Cadastros — Fornecedores;
- Workflows — Cadastros — Fornecedores;
- Riscos e Cuidados — Cadastros — Fornecedores;
- atualização do documento central `Sysvar.md`.

Somente depois do fechamento documental deve ser iniciado o próximo escopo funcional.