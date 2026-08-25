---
type: reference
status: active
project: Sysvar
source: "C:/SysvarProjeto"
created: 2026-08-03
updated: 2026-08-25
tags:
  - sysvar
  - arquitetura
  - backend
  - frontend
  - segurança
  - operacional
  - cadastros
  - produtos
  - produto-venda
  - produto-uso-consumo
  - insumos
  - cadastros-auxiliares
  - compras
  - pedido-de-compra
  - cotacao
  - almoxarifado
  - ti
  - manutencao
  - ordem-de-servico
  - requisicoes
  - financeiro
  - fiscal
  - estoque
  - produção
  - auditoria
  - multiempresa
  - homologado
---

# Arquitetura

## 1. Objetivo

A arquitetura do SYSVAR foi projetada para suportar um ERP SaaS voltado principalmente ao varejo e à indústria de moda.

Seus principais objetivos são:

- segurança;
- isolamento entre Empresas;
- isolamento por Estabelecimento quando aplicável;
- modularização;
- escalabilidade;
- rastreabilidade;
- integridade transacional;
- separação de responsabilidades;
- evolução incremental;
- compatibilidade com MySQL;
- manutenção simplificada;
- preservação histórica;
- reutilização de infraestruturas centrais.

Toda nova funcionalidade deve reutilizar as estruturas já existentes antes da criação de mecanismos paralelos.

---

# 2. Princípios Arquiteturais

O SYSVAR segue os seguintes princípios:

- backend como autoridade final;
- frontend como camada de apresentação e interação;
- default deny;
- Permissões efetivas;
- isolamento multiempresa obrigatório;
- isolamento por Estabelecimento quando aplicável;
- módulos contratados;
- operações críticas transacionais;
- serviços centrais;
- Auditoria centralizada;
- dados sensíveis protegidos;
- migrations obrigatórias;
- integridade histórica;
- exclusão protegida;
- paginação server-side;
- filtros server-side quando aplicável;
- testes proporcionais ao risco;
- documentação versionada;
- decisões arquiteturais registradas por ADR;
- separação entre cadastro e processo operacional.

Regra fundamental:

~~~text
FRONTEND
→ apresenta e facilita

BACKEND
→ valida e decide
~~~

Ocultar botão, menu, campo ou rota no frontend não substitui validação no backend.

---

# 3. Camadas Principais

A arquitetura é dividida em:

1. Frontend;
2. Backend;
3. Banco de Dados;
4. Infraestruturas Transversais;
5. Módulos de Negócio;
6. Infraestrutura de Execução;
7. Documentação.

Visão conceitual:

~~~text
USUÁRIO
   ↓
FRONTEND ANGULAR
   ↓
API REST
   ↓
BACKEND DJANGO
   ↓
REGRAS DE NEGÓCIO
   ↓
BANCO MYSQL
~~~

Infraestruturas transversais atuam em todo o fluxo:

~~~text
Autenticação
Permissões
Multiempresa
Sessões
Licenciamento
Auditoria
~~~

---

# 4. Frontend

Tecnologia principal:

~~~text
Angular 17 Standalone
TypeScript
~~~

Responsabilidades:

- navegação;
- formulários;
- filtros;
- listagens;
- paginação;
- indicadores;
- seleção;
- modais;
- sobretelas;
- feedback ao usuário;
- disponibilidade visual de ações;
- integração com API;
- contexto autenticado;
- heartbeat;
- tratamento de erros.

O frontend não deve duplicar regras críticas do backend como fonte de verdade.

---

# 5. Backend

Tecnologias principais:

~~~text
Python
Django
Django REST Framework
~~~

Responsabilidades:

- autenticação;
- autorização;
- tenant;
- regras de negócio;
- validações;
- persistência;
- integridade referencial;
- transações;
- lifecycle;
- filtros;
- paginação;
- serviços;
- Auditoria;
- integração entre módulos.

---

# 6. Banco de Dados

Banco principal:

~~~text
MySQL
~~~

A arquitetura deve considerar MySQL como referência para:

- constraints;
- migrations;
- índices;
- transações;
- concorrência;
- integridade.

SQLite pode ser utilizado em contextos de desenvolvimento quando apropriado, mas não deve gerar premissas incompatíveis com MySQL.

---

# 7. Migrations

Toda alteração estrutural persistente deve possuir migration.

Não alterar migration já aplicada como forma normal de evolução.

Fluxo:

~~~text
Alteração de Model
        ↓
Migration nova
        ↓
Revisão
        ↓
Teste
        ↓
Aplicação
~~~

Data migrations devem considerar:

- banco com dados;
- valores nulos legados;
- multiempresa;
- ambiguidade;
- volume;
- compatibilidade com MySQL.

---

# 8. Empresa como Tenant

A Empresa é o principal limite lógico de dados.

~~~text
PLATAFORMA
   ↓
EMPRESA
   ↓
DADOS PRIVADOS
~~~

A Empresa deve delimitar, conforme o domínio:

- Usuários;
- Perfis;
- Clientes;
- Fornecedores;
- Funcionários;
- Produtos;
- Cadastros Auxiliares;
- Compras;
- Estoques;
- documentos;
- Financeiro;
- Produção;
- Auditoria.

---

# 9. Proteção Multiempresa

Não basta filtrar listagens.

O backend deve validar também relacionamentos.

Exemplo:

~~~text
Produto Empresa A
+
Grupo Empresa B
=
INVÁLIDO
~~~

Outro:

~~~text
Pedido Empresa A
+
Fornecedor Empresa B
=
INVÁLIDO
~~~

A proteção deve considerar:

- QuerySets;
- serializers;
- services;
- actions;
- commands;
- imports;
- exports;
- ForeignKeys;
- operações em lote.

---

# 10. Estabelecimentos

Empresa pode possuir múltiplos Estabelecimentos.

Tipos operacionais atualmente previstos incluem:

~~~text
LOJA
MATRIZ
FÁBRICA
~~~

Relacionamento:

~~~text
Empresa 1:N Estabelecimento
~~~

Estabelecimento representa localização ou contexto operacional.

Não representa tenant independente.

---

# 11. Segurança e Acesso

A arquitetura de acesso considera:

~~~text
Usuário
+
Empresa
+
Contrato
+
Módulos
+
Perfil
+
Overrides
=
Acesso Efetivo
~~~

Frontend consulta e utiliza o resultado.

Backend permanece autoridade.

---

# 12. Default Deny

Ausência de autorização significa bloqueio.

~~~text
Sem Permissão
→ Não Executar
~~~

Não criar fallback permissivo baseado em:

- nome do Perfil;
- Cargo;
- rota;
- menu;
- `is_staff`.

---

# 13. Perfis e Permissões

Perfis organizam acesso por módulo.

Overrides individuais podem ajustar o acesso.

Valores conceituais:

~~~text
NONE
VIEW
EDIT
~~~

Override:

~~~text
HERDAR
NONE
VIEW
EDIT
~~~

`HERDAR` representa ausência de override específico.

---

# 14. Funcionário não é Usuário

Separação arquitetural:

~~~text
Funcionário
→ identidade operacional

Usuário
→ identidade de autenticação
~~~

Também:

~~~text
Cargo != Perfil
Cargo != Permissão
~~~

Esse limite deve ser preservado em futuras integrações com Vendas, Produção ou outros módulos.

---

# 15. Contratos

Contrato define direito de utilização do sistema.

Pode controlar:

- situação;
- vigência;
- módulos;
- limite de sessões;
- Usuário master;
- suspensão;
- reativação.

A autenticação deve considerar o estado contratual.

---

# 16. Sessões

A arquitetura utiliza sessões autenticadas vinculadas a token.

~~~text
Usuário
   ↓
Sessão
   ↓
Token
~~~

A validade da sessão deve ser determinada pela infraestrutura central.

---

# 17. Licenciamento

O modelo homologado utiliza:

~~~text
SESSÕES SIMULTÂNEAS
~~~

Regra:

~~~text
Usuário cadastrado
→ não consome licença

Sessão válida
→ consome licença
~~~

Não retornar à contagem baseada em Usuários ativos.

---

# 18. Fonte Única de Validade de Sessão

Login, contador, disponibilidade e administração de sessões devem utilizar a mesma definição central.

Não criar consultas paralelas que interpretem uma sessão apenas por:

~~~text
ativa = true
~~~

Sessão marcada ativa pode já estar expirada ou inválida.

---

# 19. Concorrência

Operações sujeitas a concorrência devem utilizar proteção transacional apropriada.

Exemplo:

~~~text
última vaga de licença
~~~

Fluxo deve impedir duas requisições simultâneas de consumirem a mesma vaga lógica.

---

# 20. Auditoria Central

Auditoria é infraestrutura transversal.

~~~text
AÇÃO
   ↓
CONTEXTO
   ↓
AUDITORIA CENTRAL
~~~

Pode registrar:

- autenticação;
- sessões;
- Empresas;
- Contratos;
- Usuários;
- Perfis;
- Permissões;
- Estabelecimentos;
- Clientes;
- Fornecedores;
- Funcionários;
- Produtos;
- Compras;
- lifecycle;
- ações críticas.

---

# 21. Auditoria versus Histórico Funcional

Não são equivalentes.

Exemplo:

~~~text
ProdutoVendaHistorico
→ Histórico Funcional

AuditLog
→ Auditoria Central
~~~

Uma estrutura não deve ser removida apenas porque a outra existe.

---

# 22. Operações Críticas

Operações críticas podem exigir:

~~~text
transaction.atomic
+
alteração
+
Auditoria obrigatória
+
commit
~~~

Falha em etapa obrigatória deve impedir estado parcial.

A aprovação de Pedido de Compra é exemplo de operação que exige consistência entre:

- Pedido;
- parcelas;
- Financeiro;
- status;
- Auditoria.

---

# 23. Dados Sensíveis

Nunca persistir em Auditoria ou logs:

- senha;
- token bruto;
- cookie de autenticação;
- Authorization;
- certificado;
- chave privada;
- segredo;
- credenciais temporárias.

---

# 24. Organização dos Módulos

Visão funcional:

~~~text
SYSVAR
│
├── Operacional
├── Cadastros
├── Produtos
├── Compras
├── Estoque
├── Produção
├── Distribuição
├── Vendas / PDV
├── Fiscal
├── Financeiro
├── Contabilidade
├── Relatórios
└── Auditoria
~~~

Cada módulo deve preservar sua fronteira de responsabilidade.

---

# 25. Grupo Operacional

Situação:

~~~text
CONCLUÍDO
HOMOLOGADO
DOCUMENTADO
APROVADO
~~~

Abrange:

- Empresas;
- Contratos;
- Estabelecimentos;
- Usuários;
- Perfis;
- Permissões;
- Overrides;
- Sessões;
- Licenciamento;
- administração de sessões;
- suspensão;
- reativação;
- senhas;
- Auditoria Central.

---

# 26. Grupo Cadastros

O escopo prioritário revisado está concluído.

~~~text
Clientes
→ 23/23

Fornecedores
→ 30/30

Funcionários
→ 17/17
~~~

Todos estão homologados e documentados.

---

# 27. Clientes

Princípios arquiteturais:

- Empresa obrigatória;
- documento único por Empresa quando preenchido;
- múltiplos Clientes sem documento permitidos;
- Consumidor Final por Empresa;
- lifecycle;
- exclusão protegida;
- Auditoria.

Não criar Cliente global entre tenants.

---

# 28. Fornecedores

Fornecedor integra com diferentes processos.

~~~text
Fornecedor
   ├── Compras
   ├── Financeiro
   ├── Fiscal
   └── Produção / Facção
~~~

Categorias não devem ser confundidas com autorização.

Dados sensíveis devem possuir proteção adequada.

---

# 29. Funcionários

Funcionário é cadastro operacional leve.

Não transformar o SYSVAR em sistema de RH/DP completo sem projeto específico.

Lifecycle:

~~~text
ATIVO
AFASTADO
DESLIGADO
~~~

Recontratação reutiliza a identidade histórica.

---

# 30. Grupo Produtos

O ciclo cadastral atual está concluído.

~~~text
Produto Venda
→ tipos 1 e 3
→ HOMOLOGADO

Produto Uso/Consumo
→ tipo 2
→ HOMOLOGADO

Insumos
→ tipo 4
→ HOMOLOGADO

Cadastros Auxiliares
→ HOMOLOGADOS
~~~

---

# 31. Produto como Estrutura Compartilhada

A entidade Produto atende domínios diferentes.

~~~text
Produto
   ├── tipo 1 → Revenda
   ├── tipo 2 → Uso/Consumo
   ├── tipo 3 → Fabricação Própria
   └── tipo 4 → Insumo
~~~

Risco arquitetural principal:

~~~text
MODEL COMPARTILHADO
não significa
REGRA FUNCIONAL COMPARTILHADA
~~~

Toda alteração global em Produto deve avaliar os quatro tipos.

---

# 32. Produto Venda

Produto Venda engloba:

~~~text
1 = Revenda
3 = Fabricação Própria
~~~

Estruturas principais:

- Produto;
- Referência;
- Grupo;
- Subgrupo;
- Coleção;
- Unidade;
- Grade;
- Cores;
- SKUs;
- EAN;
- Dados Fiscais;
- imagens;
- custos;
- preços;
- Estoque relacionado;
- Histórico Funcional.

Documentação:

- [[Homologação - Produtos - Produto Venda]]
- [[Mapa Técnico - Produtos - Produto Venda]]
- [[Workflows - Produtos - Produto Venda]]
- [[Modelo de Domínio - Produtos - Produto Venda]]
- [[Riscos e Cuidados - Produtos - Produto Venda]]

---

# 33. Produto e SKU

Separação:

~~~text
Produto
→ identidade principal

SKU
→ Produto + Cor + Tamanho
~~~

A camada de Produto não deve substituir a granularidade de SKU onde ela é necessária.

---

# 34. EAN

EAN pertence ao SKU.

~~~text
Produto
→ Referência

SKU
→ EAN
~~~

EAN deve permanecer estável.

Reativação de SKU não deve gerar identidade nova.

---

# 35. Grade e SKU

Produto Venda utiliza:

~~~text
Grade
   ↓
Tamanhos

Produto
+
Cor
+
Tamanho
=
SKU
~~~

Após existirem SKUs, Grade é estrutura sensível e deve ser protegida no backend.

---

# 36. Lifecycle do Produto Venda

Dois estados independentes:

~~~text
ATIVO / INATIVO
~~~

e:

~~~text
LIBERADO / BLOQUEADO PARA VENDA
~~~

Não reduzir os dois conceitos a um único booleano.

---

# 37. Produto Uso/Consumo

Tipo:

~~~text
2
~~~

Possui domínio simplificado.

Não deve receber automaticamente:

- Grade;
- Cor × Tamanho;
- SKU comercial;
- Coleção;
- Pack;
- Promoção;
- Tabela de Preço comercial.

Documentação:

- [[Homologação - Produtos - Produto Uso e Consumo]]
- [[Mapa Técnico - Produtos - Produto Uso e Consumo]]
- [[Workflows - Produtos - Produto Uso e Consumo]]
- [[Modelo de Domínio - Produtos - Produto Uso e Consumo]]
- [[Riscos e Cuidados - Produtos - Produto Uso e Consumo]]

---

# 38. Uso/Consumo e Estoque

Produto Uso/Consumo possui natureza de Estoque.

Mas:

~~~text
Cadastro de Produto
!=
Local de Estoque
~~~

Não existe localização fixa obrigatória no cadastro.

A operação define onde o item está.

O estoque operacional homologado de Produto Uso/Consumo utiliza estruturas próprias:

~~~text
ProdutoUsoConsumoEstoque
ProdutoUsoConsumoMovimentacao
~~~

Produto:

~~~text
tipo_produto = '2'
~~~

deve utilizar esse estoque dedicado independentemente da origem da compra.

Não direcionar Produto tipo 2 para o ledger genérico de Produto Venda.

No fluxo de Requisições Internas, o estoque físico utilizado no atendimento é determinado pelo setor central configurado.

~~~text
Loja solicitante
→ origem da necessidade

Setor de atendimento
→ responsável operacional

Setor de atendimento.loja
→ localização física do estoque
~~~

---

# Requisições Internas e Ordens de Serviço

A Requisição representa uma necessidade interna originada por uma Loja e um Setor.

Tipos homologados:

~~~text
USO_CONSUMO
MANUTENCAO
TI
~~~

A arquitetura separa três responsabilidades:

~~~text
Origem da necessidade
!=
Responsável pelo atendimento
!=
Responsável pela aquisição
~~~

Essa separação é resolvida pela Matriz de Responsabilidade.

---

## Matriz de Responsabilidade

A estrutura central considera:

- Empresa;
- Tipo de Requisição;
- Setor de Atendimento;
- Setor de Aquisição;
- situação ativa.

Conceitualmente:

~~~text
Empresa + Tipo
        ↓
Matriz de Responsabilidade
        ↓
Setor de Atendimento
+
Setor de Aquisição
~~~

A ausência de configuração válida bloqueia o fluxo que depende dela.

Não inferir arbitrariamente responsáveis.

---

## Loja e Setor da Requisição

A Loja representa a unidade onde surgiu a necessidade.

O Setor solicitante deve pertencer à Loja selecionada.

~~~text
Requisição.loja
→ limita
Requisição.setor
~~~

Frontend filtra para experiência do usuário.

Backend valida a relação como autoridade final.

---

## Ciclo pré-operacional da Requisição

A preparação deve permanecer separada da execução.

~~~text
RASCUNHO
→ edição

AGUARDANDO_APROVACAO
→ decisão

APROVAÇÃO
→ início operacional
~~~

Salvar cabeçalho ou itens não inicia atendimento.

Para Manutenção e TI:

~~~text
RASCUNHO
→ NÃO cria OS

AGUARDANDO_APROVACAO
→ NÃO cria OS

APROVAÇÃO
→ cria/garante exatamente uma OS
~~~

---

## Uso/Consumo

Para Uso/Consumo, a Requisição pode ser atendida pelo estoque central.

~~~text
Requisição
→ Matriz
→ Setor de Atendimento
→ Loja física do Almoxarifado
→ Estoque Uso/Consumo
~~~

Se houver saldo suficiente:

~~~text
Estoque
→ Atendimento
→ Baixa
→ Conclusão
~~~

Se não houver:

~~~text
Necessidade
→ Cotação
→ Pedido de Compra
→ Entrada de NF-e
→ Estoque
→ Atendimento
~~~

---

## Ordem de Serviço

Para Manutenção e TI, a Ordem de Serviço representa a execução operacional.

~~~text
Requisição
→ necessidade

Ordem de Serviço
→ execução
~~~

Depois da criação da OS, ela é a fonte operacional do estado de atendimento.

Estados operacionais da OS mantêm a Requisição em atendimento.

~~~text
OS CONCLUIDA
→ Requisição CONCLUIDA
~~~

Cancelar OS não cancela automaticamente a Requisição.

---

## Materiais da Ordem de Serviço

Materiais necessários à execução pertencem diretamente à OS.

~~~text
OrdemServico
   ↓
OrdemServicoMaterial
~~~

Não criar uma segunda Requisição para o material da mesma OS.

Estados principais:

~~~text
PENDENTE
DISPONIVEL
EM_COMPRA
ATENDIDA
CANCELADA
~~~

`DISPONIVEL` significa que existe material para atendimento.

Não significa que a baixa já ocorreu.

A baixa acontece em ação explícita de atendimento.

---

## Necessidades de Compra

Requisição e OS compartilham a mesma fila conceitual de necessidades de aquisição.

Origens:

~~~text
REQ
→ item de Requisição de Uso/Consumo

OS
→ material de Ordem de Serviço
~~~

Para Manutenção e TI com OS, o item original da Requisição não deve gerar necessidade de material paralela.

Isso evita:

~~~text
REQ + OS
→ duplicidade de compra
~~~

---

## Integração com Cotação e Pedido

A necessidade interna não cria uma infraestrutura paralela de Compras.

Fluxo:

~~~text
Necessidade
→ Cotação
→ Pedido de Compra
→ Entrada de NF-e
~~~

Devem ser reutilizados os domínios já existentes de:

- Fornecedor;
- Cotação;
- Pedido de Compra;
- Forma de Pagamento;
- Prazo de Pagamento;
- Entrada de NF-e;
- Financeiro;
- Estoque.

---

## Sincronização pós-NF

A Entrada de NF-e é o evento físico de recebimento.

Depois da entrada:

~~~text
Produto tipo 2
→ Estoque Uso/Consumo
~~~

e as necessidades relacionadas devem ser recalculadas.

Exemplos:

~~~text
Material OS EM_COMPRA
→ DISPONIVEL
~~~

~~~text
Requisição aguardando aquisição
→ estoque disponível
→ retorna ao atendimento
~~~

---

## Estados finais

Requisição e OS concluídas são registros históricos operacionais.

~~~text
CONCLUIDA
→ consultável
→ não editável operacionalmente
~~~

A proteção deve existir no backend.

Frontend apenas reflete essa regra ocultando ou desabilitando ações incompatíveis.

Documentação de homologação:

[[Homologação - Compras - Requisições e Ordens de Serviço]]

---
# 39. Insumos

Tipo:

~~~text
4
~~~

Insumos representam componentes produtivos.

Podem utilizar:

- Unidade;
- Material opcional;
- Fiscal;
- custos;
- Estoque;
- Compras;
- Ficha Técnica.

Documentação:

- [[Homologação - Produtos - Insumos]]
- [[Mapa Técnico - Produtos - Insumos]]
- [[Workflows - Produtos - Insumos]]
- [[Modelo de Domínio - Produtos - Insumos]]
- [[Riscos e Cuidados - Produtos - Insumos]]

---

# 40. Insumo e Material

Separação:

~~~text
Material
→ classificação

Insumo
→ item operacional
~~~

Material não deve ser usado diretamente como objeto de:

- Compra;
- Estoque;
- Ficha Técnica;
- consumo produtivo.

---

# 41. Insumo e Estoque

Não existe campo homologado:

~~~text
controla_estoque
~~~

O Insumo possui natureza de Estoque.

Localização física deriva de movimentos.

---

# 42. Insumo e Ficha Técnica

Relação:

~~~text
Produto Fabricado
        ↓
Ficha Técnica
        ↓
Item
        ↓
Insumo + Quantidade
~~~

Quantidade pertence ao relacionamento.

Não ao cadastro principal do Insumo.

---

# 43. Ordem de Produção

No estado atual da arquitetura:

~~~text
Criar OP
!=
Baixar Insumo
~~~

e:

~~~text
Criar OP
!=
Reservar automaticamente Insumo
~~~

Esses eventos serão definidos no módulo Produção/Estoque.

---

# 44. Cadastros Auxiliares de Produtos

Conjunto consolidado:

- Grupos;
- Subgrupos;
- Grades;
- Tamanhos;
- Coleções;
- Packs;
- Itens;
- Unidades;
- Cores;
- Material.

Documentação:

- [[Homologação - Produtos - Cadastros Auxiliares]]
- [[Mapa Técnico - Produtos - Cadastros Auxiliares]]
- [[Workflows - Produtos - Cadastros Auxiliares]]
- [[Modelo de Domínio - Produtos - Cadastros Auxiliares]]
- [[Riscos e Cuidados - Produtos - Cadastros Auxiliares]]

---

# 45. Princípio dos Cadastros Auxiliares

~~~text
Cadastro Auxiliar
→ fornece estrutura

Produto
→ utiliza estrutura

Processo
→ utiliza Produto
~~~

Não transformar cadastro auxiliar em módulo operacional.

---

# 46. Master-Detail

Estruturas consolidadas:

~~~text
Grupo
→ Subgrupos

Grade
→ Tamanhos

Pack
→ Itens
~~~

Detalhes devem ser carregados no contexto do mestre selecionado.

---

# 47. Padrão de Interface dos Auxiliares

Padrão homologado:

~~~text
Checkbox
+
Seleção única
+
Linha destacada
+
Barra de ações
~~~

Nas telas modernizadas, não usar simultaneamente:

~~~text
Barra de ações
+
Coluna Ações
+
Menu ⋮
~~~

---

# 48. Consulta em Sobretela

Quando adotado o padrão atual:

~~~text
Selecionar registro
        ↓
Consultar
        ↓
Modal / Sobretela
        ↓
Somente leitura
        ↓
Fechar
        ↓
Preservar listagem
~~~

---

# 49. Paginação

Listagens de volume relevante devem utilizar paginação server-side.

~~~text
Frontend
→ page
→ page_size
→ filtros
→ ordering
        ↓
Backend
        ↓
count + results
~~~

Não carregar toda a base para paginar no navegador.

---

# 50. Filtros

Filtros devem ser processados sobre o conjunto completo autorizado.

Não somente sobre a página visível.

Sempre preservar:

- Empresa;
- domínio;
- tipo;
- Permissões;
- critérios da consulta.

---

# 51. Exclusão Protegida

Regra arquitetural geral:

~~~text
Registro nunca utilizado
→ exclusão pode ser possível

Registro utilizado
→ preservar
~~~

Preservação pode ocorrer por:

- Inativação;
- Bloqueio;
- Desligamento;
- Encerramento;
- Cancelamento;

conforme o domínio.

No Pedido de Compra:

~~~text
AB
→ pode ser excluído conforme as regras

AP / AT / CA
→ preservar histórico
~~~

---

# 52. Integridade Histórica

Mudanças cadastrais não devem reinterpretar o passado.

Exemplos:

~~~text
CodigoRef do Grupo mudou
→ Referência antiga permanece

Pack mudou
→ Pedido antigo permanece

Unidade mudou
→ movimento histórico permanece

Cor foi removida
→ SKU histórico permanece
~~~

Pedido de Compra também deve preservar os dados da operação realizada.

A alteração futura de um Pack não deve recalcular silenciosamente a quantidade histórica de Pedido já realizado.

---

# 53. Grupo Compras

Responsabilidade arquitetural:

~~~text
AQUISIÇÃO
~~~

O primeiro domínio formalmente encerrado do grupo é:

**Pedido de Compra**

Situação:

~~~text
IMPLEMENTADO
TESTADO
HOMOLOGADO
APROVADO
DOCUMENTADO
~~~

Compras controla:

- Fornecedor;
- Pedido;
- itens;
- tipo de compra;
- quantidades;
- Pack quando aplicável;
- preços;
- descontos;
- frete;
- Forma de Pagamento;
- Prazo;
- parcelas planejadas;
- aprovação;
- Natureza financeira;
- integração Financeira;
- acompanhamento do recebimento.

Produto fornece a identidade dos itens.

Fiscal permanece responsável pelo recebimento documental e operacional.

Estoque permanece responsável pela quantidade física e localização.

---

# 54. Arquitetura do Pedido de Compra Unificado

A arquitetura homologada possui uma única funcionalidade:

~~~text
PEDIDO DE COMPRA
~~~

Não existem como processos independentes:

~~~text
Pedido de Revenda
Pedido de Uso/Consumo
Pedido de Insumo
~~~

Tipos participantes:

~~~text
1 = Revenda
2 = Uso/Consumo
4 = Insumo
~~~

Tipo não participante:

~~~text
3 = Fabricação Própria
→ Produção
~~~

O usuário não informa manualmente o tipo.

Fluxo:

~~~text
Pedido novo
tipo = ''
        ↓
Primeiro item
        ↓
Produto.tipo_produto
        ↓
Pedido.tipo
        ↓
Demais itens devem ser do mesmo tipo
~~~

A regra de homogeneidade precisa permanecer protegida no backend.

---

# 55. Agregado de Pedido de Compra

A estrutura central utiliza:

~~~text
PedidoCompra
├── PedidoCompraItem
│   └── PedidoCompraEntrega
└── PedidoCompraParcela
~~~

Responsabilidades:

`PedidoCompra`

- cabeçalho;
- Empresa;
- Loja;
- Fornecedor;
- tipo;
- status;
- totais;
- condições gerais.

`PedidoCompraItem`

- Produto;
- quantidade;
- preço;
- desconto;
- informações específicas do tipo.

`PedidoCompraParcela`

- planejamento financeiro anterior à geração definitiva em Financeiro.

`PedidoCompraEntrega`

- acompanhamento de atendimento/recebimento dos itens.

Não criar estruturas paralelas para cada tipo de Pedido.

---

# 56. Arquitetura dos Tipos em Compras

## Revenda

~~~text
Produto tipo 1
        ↓
Cor
        ↓
Pack
        ↓
Número de Packs
        ↓
Quantidade calculada
~~~

Quantidade:

~~~text
n_packs
×
soma das quantidades dos itens do Pack
=
qtd
~~~

Revenda não utiliza quantidade fracionária.

## Uso/Consumo

~~~text
Produto tipo 2
        ↓
Unidade
        ↓
Quantidade direta
~~~

## Insumo

~~~text
Produto tipo 4
        ↓
Unidade
        ↓
Quantidade direta
~~~

Para tipos 2 e 4, quantidade decimal depende de:

~~~text
Unidade.permite_decimal
~~~

---

# 57. Estado do Pedido

Estados homologados:

~~~text
AB = Aberto
AP = Aprovado
AT = Atendido
CA = Cancelado
~~~

Responsabilidades por estado:

~~~text
AB
→ manutenção

AP
→ compromisso aprovado e aguardando atendimento

AT
→ atendimento integral

CA
→ histórico cancelado
~~~

Itens e cabeçalho estrutural não devem continuar livremente editáveis depois da aprovação.

---

# 58. Pedido sem Itens

Pedido novo pode existir com:

~~~text
tipo = ''
~~~

Ao remover o último item de Pedido AB:

~~~text
0 itens
        ↓
tipo = ''
~~~

Isso permite que um Pedido vazio receba posteriormente um novo primeiro item de outro tipo válido.

---

# 59. Totais de Compras

Cálculo conceitual do item:

~~~text
bruto =
quantidade × preço_unitário

total_item =
bruto - desconto_item
~~~

Cálculo do Pedido:

~~~text
total_pedido =
total_itens
- total_desconto
+ frete
~~~

Backend permanece autoridade dos cálculos.

Não confiar em totais calculados somente no frontend.

---

# 60. Planejamento Financeiro do Pedido

O Pedido utiliza:

~~~text
PedidoCompraParcela
~~~

para representar o planejamento das parcelas.

Estados relevantes:

~~~text
PLAN
GERADA
CANC
~~~

Forma de Pagamento e Prazo podem gerar o planejamento.

Invariante necessária antes da aprovação:

~~~text
soma das parcelas
=
total do Pedido
~~~

Alterações do total enquanto AB devem manter o planejamento coerente.

---

# 61. PedidoCompraParcela não é PagarItem

Separação arquitetural:

~~~text
PedidoCompraParcela
→ planejamento da compra

PagarItem
→ parcela da obrigação financeira
~~~

Não fundir automaticamente essas duas responsabilidades.

A aprovação é o ponto de transição entre planejamento e obrigação.

---

# 62. Aprovação do Pedido de Compra

Fluxo arquitetural:

~~~text
Pedido AB
        ↓
validar itens
        ↓
validar tipo
        ↓
validar total
        ↓
validar Forma/Prazo
        ↓
validar parcelas
        ↓
selecionar Natureza
        ↓
gerar Financeiro
        ↓
AP
~~~

A operação deve preservar atomicidade.

Resultado financeiro:

~~~text
PedidoCompra
        ↓
Pagar
        ↓
PagarItem
~~~

Não deixar estado parcial como:

- Pedido AP sem obrigação quando ela deveria ter sido criada;
- `Pagar` criado com aprovação falhada;
- parcelas parcialmente geradas;
- status divergente.

---

# 63. Natureza de Lançamento

A Natureza financeira é escolhida no momento da aprovação.

Ela não precisa ser armazenada como elemento de preenchimento permanente da tela principal do Pedido.

A Natureza utilizada precisa respeitar a Empresa.

---

# 64. Compras não Movimenta Estoque na Aprovação

Princípio obrigatório:

~~~text
Pedido aprovado
!=
Mercadoria recebida
~~~

Fluxo incorreto:

~~~text
Aprovação
→ Entrada de Estoque
~~~

Fluxo correto:

~~~text
Aprovação
→ AP
→ Nota Fiscal de Entrada
→ Recebimento
→ Estoque
~~~

---

# 65. Recebimento de Compras

O recebimento operacional permanece integrado ao Fiscal.

Fluxo:

~~~text
Pedido AP
        ↓
Nota Fiscal de Entrada
        ↓
Recebimento
        ↓
Movimento de Estoque
        ↓
Atualização do atendimento
~~~

A tela de Pedido pode apresentar recebimentos.

Não deve criar processo paralelo de entrada física.

---

# 66. Atendimento Parcial e Integral

Recebimento parcial:

~~~text
Pedido permanece AP
~~~

Recebimento integral:

~~~text
AP → AT
~~~

AT significa atendimento integral.

Não significa apenas que existe alguma NF ou alguma quantidade recebida.

---

# 67. Cancelamento Fiscal

Cancelamento de Nota Fiscal relacionada ao recebimento deve ser considerado no estado do Pedido.

Se quantidades anteriormente válidas deixarem de compor o recebimento:

~~~text
recalcular atendimento
~~~

Um Pedido anteriormente AT pode voltar para AP quando deixar de estar integralmente atendido.

A integração precisa permanecer coerente também com Estoque.

---

# 68. Sobretelas do Pedido

A arquitetura visual homologada mantém a tela principal compacta.

Estruturas subordinadas:

- Itens;
- Forma de Pagamento;
- Recebimentos;
- aprovação/Natureza.

Fluxo:

~~~text
Tela principal
        ↓
Selecionar Pedido
        ↓
Ação
        ↓
Sobretela
        ↓
Operação ou Consulta
        ↓
Fechar
        ↓
Preservar contexto
~~~

Não voltar a expandir todas as estruturas subordinadas permanentemente na tela principal sem nova decisão funcional.

---

# 69. Frontend do Pedido de Compra

Rota canônica:

~~~text
/compras/pedidos
~~~

Feature principal:

~~~text
src/app/features/pedidos-compra
~~~

O frontend adapta a interface de itens conforme:

~~~text
tipo = ''
tipo = 1
tipo = 2
tipo = 4
~~~

A existência dessa adaptação visual não substitui validações do backend.

Rotas antigas de fluxos separados devem permanecer apenas como compatibilidade/redirecionamento quando ainda necessárias.

---

# 70. Integração Compras × Produtos

Compras reutiliza o domínio Produto.

~~~text
Pedido
   ↓
Produto
   ↓
tipo_produto
   ↓
Regra de Compra
~~~

Revenda reutiliza:

- Produto;
- Cor;
- Pack;
- PackItem.

Uso/Consumo e Insumos reutilizam:

- Produto;
- Unidade;
- `permite_decimal`.

Não duplicar essas estruturas no app Compras.

---

# 71. Integração Compras × Financeiro

Fluxo:

~~~text
Pedido AB
   ↓
Forma / Prazo
   ↓
PedidoCompraParcela
   ↓
Aprovação + Natureza
   ↓
Pagar
   ↓
PagarItem
~~~

Financeiro continua responsável por:

- obrigação;
- vencimentos efetivos;
- baixas;
- pagamentos;
- juros;
- descontos financeiros.

Compras não deve implementar Contas a Pagar paralelo.

---

# 72. Integração Compras × Fiscal

Compras registra:

~~~text
o que foi solicitado
~~~

Fiscal registra:

~~~text
o que efetivamente entrou
+
documento fiscal
+
tributação
~~~

A integração deve permitir acompanhar o atendimento sem duplicar o recebimento.

---

# 73. Integração Compras × Estoque

Separação:

~~~text
Pedido
→ intenção de aquisição

Recebimento
→ ocorrência física

Estoque
→ quantidade e localização
~~~

A aprovação por si só não altera saldo.

---

# 74. Estoque

Responsabilidade:

~~~text
Quantidade
+
Localização
+
Movimentos
~~~

Produto define **o que é**.

Estoque define **quanto existe e onde está**.

---

# 75. Estoque de Produto Venda

Granularidade consolidada:

~~~text
Loja × SKU
~~~

Inicialização de estrutura com zero não significa entrada física.

---

# 76. Estoque de Uso/Consumo e Insumos

Para esses domínios:

~~~text
Produto / Insumo
+
Local determinado pela operação
=
posição de Estoque
~~~

Não fixar localização no cadastro principal.

---

# 77. Movimentos de Estoque

Saldo deve ser derivado de eventos operacionais.

Exemplos:

- recebimento;
- venda;
- transferência;
- ajuste;
- inventário;
- produção;
- devolução;
- distribuição.

Não alterar saldo diretamente por cadastro de Produto.

---

# 78. Produção

Fluxo conceitual:

~~~text
Produto Venda tipo 3
        ↓
Ficha Técnica
        ↓
Insumos tipo 4
        ↓
Ordem de Produção
        ↓
Produção
        ↓
Produto Acabado
~~~

Produção deve preservar separação entre:

- previsto;
- reservado;
- separado;
- consumido;
- perdido;
- produzido.

Essas etapas ainda exigem definição funcional completa.

Produto tipo 3 não deve ser incluído em Pedido de Compra.

---

# 79. Facção

Produção terceirizada deve ser modelada por eventos operacionais.

Não representar localização transitória apenas com campo fixo no Produto ou Insumo.

Fluxo conceitual:

~~~text
Estoque Empresa
        ↓
Envio para Facção
        ↓
Material em poder de terceiro
        ↓
Produção
        ↓
Retorno
~~~

---

# 80. Distribuição

Distribuição representa movimentação de mercadoria entre origem e Lojas.

~~~text
Origem
   ↓
Distribuição
   ↓
Destinos
   ↓
Movimentos de Estoque
~~~

Pode envolver:

- Produto Venda;
- referência;
- SKU;
- Grade;
- Tamanho;
- percentuais;
- quantidades.

Não deve ser implementada como simples alteração direta de saldo.

---

# 81. Vendas e PDV

Venda utiliza principalmente Produto Venda/SKU.

~~~text
Produto
+
SKU
+
Preço
+
Estoque
+
Cliente
+
Vendedor
+
Pagamento
+
Fiscal
=
Venda
~~~

Uso/Consumo e Insumos não devem aparecer como Produtos comerciais normais.

---

# 82. PDV Offline

A arquitetura futura deve permitir operação de Loja sem internet.

Conceitualmente:

~~~text
SYSVAR CENTRAL
        ↓
Sincronização
        ↓
BASE LOCAL PDV
        ↓
Venda Offline
        ↓
Fila Local
        ↓
Sincronização Posterior
        ↓
SYSVAR CENTRAL
~~~

Deverá existir controle de conflitos e reprocessamento.

---

# 83. Fiscal

Produto mantém dados fiscais cadastrais.

Fiscal processa a operação.

~~~text
CADASTRO FISCAL
!=
OPERAÇÃO FISCAL
~~~

O módulo Fiscal é responsável por:

- validação da operação;
- aplicação tributária;
- emissão;
- contingência;
- documentos;
- Nota Fiscal de Entrada;
- cancelamento fiscal.

---

# 84. Financeiro

Financeiro representa obrigações e direitos.

~~~text
Compra
→ Contas a Pagar

Venda
→ Contas a Receber
~~~

Integração não deve causar duplicidade de origem.

---

# 85. Integração entre Módulos

Os módulos devem trocar referências e eventos sem absorver indevidamente responsabilidades.

Exemplo de Compras:

~~~text
Produto
→ fornece identidade

Compras
→ formaliza aquisição

Fiscal
→ registra recebimento documental

Estoque
→ registra movimento físico

Financeiro
→ registra obrigação
~~~

---

# 86. Serviços Centrais

Quando uma regra é transversal ou complexa, deve existir ponto de implementação central apropriado.

Evitar duplicação da mesma regra em:

- view;
- serializer;
- signal;
- component;
- service paralelo.

Uma única regra com múltiplas implementações tende a divergir.

---

# 87. Transações

Utilizar atomicidade quando várias alterações precisam representar um único evento funcional.

Exemplo:

~~~text
Operação A
+
Operação B
+
Auditoria
=
uma unidade lógica
~~~

Não persistir metade da operação.

A aprovação do Pedido de Compra é exemplo direto dessa necessidade.

---

# 88. Concorrência de Identificadores

Geradores sequenciais e alocações únicas devem considerar concorrência.

Exemplos:

- EAN;
- Referência;
- sessões;
- numeradores;
- sequências fiscais.

Não utilizar simples:

~~~text
max + 1
~~~

sem proteção quando duas requisições simultâneas puderem ocorrer.

---

# 89. API REST

A API deve expor contratos previsíveis.

Responsabilidades:

- autenticação;
- tenant;
- validação;
- serialização;
- filtros;
- paginação;
- mensagens funcionais;
- códigos coerentes de erro.

Frontend não deve precisar conhecer detalhes internos do banco.

---

# 90. Mensagens de Erro

Quando uma regra conhecida impedir a operação, retornar mensagem funcional útil.

Exemplo preferível:

~~~text
Este Tamanho já existe no Pack.
~~~

Em Compras:

~~~text
Pedido de Compra não permite misturar produtos de tipos diferentes.
~~~

em vez de apenas:

~~~text
Erro ao salvar.
~~~

Não expor:

- stack trace;
- SQL;
- segredo;
- detalhes sensíveis.

---

# 91. Frontend e Estado

Cuidado com dados mantidos em memória.

Após mutações relevantes:

~~~text
Salvar
        ↓
Backend confirma
        ↓
Frontend recarrega estado necessário
~~~

Evitar indicadores e listagens baseados em snapshots antigos.

No Pedido de Compra isso é especialmente relevante após:

- inclusão de item;
- exclusão de item;
- alteração de total;
- aplicação de Forma/Prazo;
- aprovação;
- atualização de recebimento.

---

# 92. Consulta por ID

Quando disponível, consultas detalhadas devem preferir dados atuais do backend.

~~~text
Selecionar
        ↓
ID
        ↓
Backend
        ↓
Dados atuais
~~~

Não depender apenas do objeto resumido da listagem.

---

# 93. Segurança de Rotas

Guardas e menus aumentam a qualidade da experiência.

Não são proteção final.

~~~text
Angular Guard
+
Menu
+
Botão
→ UX

Backend
→ Segurança
~~~

---

# 94. Performance

Evitar:

- N+1;
- QuerySets globais;
- paginação client-side em grandes listas;
- filtros locais sobre página parcial;
- payloads excessivos;
- chamadas redundantes.

Utilizar quando apropriado:

- índices;
- `select_related`;
- `prefetch_related`;
- agregações;
- paginação;
- endpoints específicos.

---

# 95. Testes

A estratégia de testes é proporcional ao risco.

Correção localizada:

~~~text
Teste direcionado
+
Homologação
~~~

Mudança estrutural:

~~~text
Testes do domínio
+
Integrações relevantes
+
Build
+
Regressão necessária
~~~

Fechamento de módulo:

~~~text
Testes
+
Revisão
+
Homologação
+
Documentação
~~~

O fechamento do Pedido de Compra unificado registrou testes específicos do módulo de Compras.

Alterações envolvendo cancelamento real de Nota Fiscal devem validar também o módulo Fiscal.

---

# 96. Estratégia de Implementação

O processo geral deve seguir:

[[Protocolo de Trabalho com IA]]

Fluxo:

~~~text
DECISÃO FUNCIONAL
        ↓
ANÁLISE
        ↓
IMPACTO
        ↓
SOLUÇÃO
        ↓
IMPLEMENTAÇÃO
        ↓
TESTES
        ↓
REVISÃO
        ↓
HOMOLOGAÇÃO
        ↓
DOCUMENTAÇÃO
~~~

Não implementar arquitetura definitiva para regra funcional ainda indefinida.

---

# 97. Evolução Incremental

O sistema deve evoluir por domínios fechados.

~~~text
Definir
→ Implementar
→ Homologar
→ Documentar
→ Integrar
~~~

Evitar grandes reestruturações simultâneas sem necessidade.

O Pedido de Compra passa a ser referência de domínio fechado no grupo Compras.

---

# 98. Documentação como Parte da Arquitetura

Documentação é parte do projeto.

Estrutura central:

- [[Sysvar]]
- [[Visão Geral]]
- [[Arquitetura]]
- [[Mapa Técnico]]
- [[Modelo de Domínio]]
- [[Workflows]]
- [[Riscos e Cuidados]]

Documentos específicos registram decisões por domínio.

---

# 99. Documentação de Produto Venda

- [[Homologação - Produtos - Produto Venda]]
- [[Mapa Técnico - Produtos - Produto Venda]]
- [[Workflows - Produtos - Produto Venda]]
- [[Modelo de Domínio - Produtos - Produto Venda]]
- [[Riscos e Cuidados - Produtos - Produto Venda]]

---

# 100. Documentação de Produto Uso/Consumo

- [[Homologação - Produtos - Produto Uso e Consumo]]
- [[Mapa Técnico - Produtos - Produto Uso e Consumo]]
- [[Workflows - Produtos - Produto Uso e Consumo]]
- [[Modelo de Domínio - Produtos - Produto Uso e Consumo]]
- [[Riscos e Cuidados - Produtos - Produto Uso e Consumo]]

---

# 101. Documentação de Insumos

- [[Homologação - Produtos - Insumos]]
- [[Mapa Técnico - Produtos - Insumos]]
- [[Workflows - Produtos - Insumos]]
- [[Modelo de Domínio - Produtos - Insumos]]
- [[Riscos e Cuidados - Produtos - Insumos]]

---

# 102. Documentação de Cadastros Auxiliares

- [[Homologação - Produtos - Cadastros Auxiliares]]
- [[Mapa Técnico - Produtos - Cadastros Auxiliares]]
- [[Workflows - Produtos - Cadastros Auxiliares]]
- [[Modelo de Domínio - Produtos - Cadastros Auxiliares]]
- [[Riscos e Cuidados - Produtos - Cadastros Auxiliares]]

---

# 103. Documentação de Compras

## Pedido de Compra

- [[Homologação - Compras - Pedido de Compra]]
- [[Mapa Técnico - Compras - Pedido de Compra]]
- [[Workflows - Compras - Pedido de Compra]]
- [[Modelo de Domínio - Compras - Pedido de Compra]]
- [[Riscos e Cuidados - Compras - Pedido de Compra]]

Situação:

~~~text
IMPLEMENTADO
TESTADO
HOMOLOGADO
APROVADO
DOCUMENTADO
~~~

---

# 104. ADRs

Decisões arquiteturais relevantes devem permanecer registradas em ADR.

Referências atuais:

- [[ADR-001 - Licenciamento por Sessões Simultâneas]]
- [[ADR-002 - Princípios Arquiteturais do SISVAR]]
- [[ADR-003 - Auditoria Central do SISVAR]]

Novas decisões estruturais significativas devem avaliar necessidade de novo ADR.

---

# 105. Estado Arquitetural Atual

Em 16/08/2026:

~~~text
INFRAESTRUTURA OPERACIONAL
→ CONCLUÍDA
→ HOMOLOGADA

CADASTROS PRIORITÁRIOS
→ CLIENTES
→ FORNECEDORES
→ FUNCIONÁRIOS
→ CONCLUÍDOS

PRODUTOS
→ PRODUTO VENDA
→ PRODUTO USO/CONSUMO
→ INSUMOS
→ CADASTROS AUXILIARES
→ CICLO CADASTRAL CONCLUÍDO

COMPRAS
→ PEDIDO DE COMPRA
→ UNIFICADO
→ TESTADO
→ HOMOLOGADO
→ APROVADO
→ DOCUMENTADO
~~~

---

# 106. Fronteiras que Devem Ser Preservadas

~~~text
Empresa
!=
Estabelecimento

Funcionário
!=
Usuário

Cargo
!=
Perfil

Perfil
!=
Permissão fixa

Produto
!=
SKU

Produto
!=
Estoque

Material
!=
Insumo

Uso/Consumo
!=
Insumo

Fabricação Própria
!=
Pedido de Compra

Cadastro Fiscal
!=
Operação Fiscal

Ficha Técnica
!=
Consumo Real

Pack
!=
Pedido de Compra

Pedido de Compra
!=
Nota Fiscal de Entrada

Pedido de Compra
!=
Movimento de Estoque

PedidoCompraParcela
!=
PagarItem

Aprovação
!=
Recebimento

Auditoria
!=
Histórico Funcional
~~~

---

# 107. Próximas Evoluções

Novos módulos devem seguir a mesma disciplina arquitetural.

Antes da implementação:

1. analisar o que já existe;
2. definir regra funcional;
3. identificar domínio responsável;
4. verificar integrações;
5. verificar multiempresa;
6. verificar Estabelecimento;
7. verificar Permissões;
8. verificar Auditoria;
9. verificar lifecycle;
10. verificar histórico;
11. verificar concorrência;
12. definir testes;
13. somente então alterar arquitetura ou código.

Não reabrir a arquitetura homologada do Pedido de Compra sem:

- novo requisito;
- defeito comprovado;
- conflito real;
- decisão funcional explícita.

---

# 108. Princípio Final

~~~text
A arquitetura do SYSVAR
deve crescer pela integração
entre domínios bem definidos,
não pela duplicação de regras.

Backend decide.

Frontend apresenta.

Empresa delimita.

Estabelecimento contextualiza.

Produto identifica.

Compras formalizam a aquisição.

Fiscal documenta o recebimento.

Estoque quantifica e localiza.

Produção transforma.

Distribuição movimenta.

Vendas comercializam.

Financeiro controla obrigações.

Auditoria preserva rastreabilidade.
~~~

---

# 109. Navegação Documental

## Projeto

- [[Sysvar]]
- [[Visão Geral]]
- [[Mapa Técnico]]
- [[Modelo de Domínio]]
- [[Workflows]]
- [[Riscos e Cuidados]]

## Produtos

- [[Mapa Técnico - Produtos - Produto Venda]]
- [[Mapa Técnico - Produtos - Produto Uso e Consumo]]
- [[Mapa Técnico - Produtos - Insumos]]
- [[Mapa Técnico - Produtos - Cadastros Auxiliares]]

## Compras

- [[Mapa Técnico - Compras - Pedido de Compra]]
- [[Modelo de Domínio - Compras - Pedido de Compra]]
- [[Workflows - Compras - Pedido de Compra]]
- [[Riscos e Cuidados - Compras - Pedido de Compra]]
- [[Homologação - Compras - Pedido de Compra]]

## Decisões Arquiteturais

- [[ADR-001 - Licenciamento por Sessões Simultâneas]]
- [[ADR-002 - Princípios Arquiteturais do SISVAR]]
- [[ADR-003 - Auditoria Central do SISVAR]]

## Governança de Desenvolvimento

- [[Protocolo de Trabalho com IA]]
- [[Padrao de Prompts para Codex]]
- [[Hierarquia de Fontes e Decisoes]]
- [[Fluxo de Desenvolvimento e Homologacao]]

---

# 110. Última Atualização

~~~text
16/08/2026
~~~

Este documento representa a arquitetura consolidada do SYSVAR após:

- fechamento do grupo Operacional;
- fechamento dos Cadastros prioritários;
- fechamento do ciclo cadastral atual de Produtos;
- implementação;
- testes;
- homologação;
- aprovação;
- documentação do Pedido de Compra unificado.