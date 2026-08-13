---
type: risks-and-care
status: approved
project: Sysvar
group: Produtos
module: Produto Venda
phase: Fase 1
created: 2026-08-13
updated: 2026-08-13
tags:
  - sysvar
  - produtos
  - produto-venda
  - revenda
  - fabricação-própria
  - sku
  - ean
  - grade
  - cores
  - estoque
  - fiscal
  - imagens
  - riscos
  - auditoria
  - multiempresa
  - homologado
---

# Riscos e Cuidados - Produtos - Produto Venda

## 1. Identificação

- **Projeto:** [[Sysvar]]
- **Módulo:** Produtos
- **Funcionalidade:** Produto Venda
- **Tipos contemplados:** Revenda e Fabricação Própria
- **Escopo:** Fase 1 — Cadastro e gestão estrutural
- **Situação:** IMPLEMENTADO E HOMOLOGADO
- **Homologação manual:** 19/19 itens aprovados
- **Data da homologação:** 13/08/2026

### Documentos relacionados

- [[Sysvar]]
- [[Homologação - Produtos - Produto Venda]]
- [[Mapa Técnico - Produtos - Produto Venda]]
- [[Workflows - Produtos - Produto Venda]]
- [[Modelo de Domínio - Produtos - Produto Venda]]

---

# 2. Objetivo

Este documento registra os principais riscos técnicos, funcionais, operacionais e arquiteturais relacionados ao Produto Venda do [[Sysvar]].

Deve ser consultado antes de alterações relevantes em:

- `Produto`;
- `ProdutoDetalhe`;
- serializers;
- views;
- endpoints;
- migrations;
- geração de Referência;
- geração de EAN;
- Grade;
- Cores;
- SKUs;
- Estoque;
- Preços;
- Dados fiscais;
- imagens;
- Histórico Funcional;
- Auditoria Central;
- Compras;
- Produção;
- PDV;
- permissões;
- frontend de Produto Venda.

O objetivo é impedir que evoluções futuras destruam ou modifiquem silenciosamente regras já implementadas e homologadas.

As regras de domínio correspondentes estão documentadas em:

[[Modelo de Domínio - Produtos - Produto Venda]]

Os fluxos completos estão em:

[[Workflows - Produtos - Produto Venda]]

---

# 3. Classificação de Impacto

Os riscos deste documento utilizam as classificações:

~~~text
CRÍTICO
ALTO
MÉDIO
BAIXO
~~~

## CRÍTICO

Pode causar:

- vazamento entre empresas;
- corrupção de identidade de Produto/SKU;
- duplicação de EAN;
- perda de histórico;
- inconsistência grave de Estoque;
- quebra de segurança;
- associação cross-tenant;
- alteração indevida de registros já movimentados.

## ALTO

Pode causar:

- quebra de regra homologada;
- SKU incorreto;
- venda de Produto indevido;
- saldo incorreto;
- custos inconsistentes;
- problemas fiscais;
- perda de rastreabilidade.

## MÉDIO

Pode causar:

- comportamento operacional inadequado;
- UX confusa;
- informação incompleta;
- manutenção difícil;
- dívida técnica relevante.

## BAIXO

Normalmente relacionado a:

- apresentação;
- conveniência;
- otimizações;
- melhorias futuras sem comprometimento imediato da integridade.

---

# 4. Risco — Quebra do Isolamento Multiempresa

Todo Produto Venda pertence a uma Empresa.

Devem respeitar o mesmo contexto empresarial:

- Produto;
- Grupo;
- Subgrupo;
- Coleção;
- Unidade;
- Grade;
- Cores aplicáveis;
- Lojas;
- SKUs;
- Estoque;
- preços;
- imagens;
- Histórico Funcional;
- demais relações empresariais.

Risco:

~~~text
Produto da Empresa A
+
Loja ou relação da Empresa B
~~~

Impacto:

**CRÍTICO**

Cuidados:

- aplicar tenant no backend;
- filtrar QuerySets pela Empresa;
- validar ForeignKeys;
- validar IDs recebidos;
- nunca confiar somente nos combos do frontend;
- manter testes cross-tenant.

---

# 5. Risco — Confiar no Frontend para Isolamento

A interface apresentar apenas dados da Empresa atual não garante segurança.

Uma requisição pode ser manipulada.

Exemplo:

~~~text
produto.empresa = Empresa A
loja_id = Loja da Empresa B
~~~

Impacto:

**CRÍTICO**

Cuidados:

- revalidar no backend;
- não aceitar IDs como seguros;
- manter frontend como camada de UX;
- backend permanece autoridade.

---

# 6. Risco — Misturar Produto Venda e Uso e Consumo

Produto Venda contempla nesta fase:

~~~text
1 = Revenda
3 = Fabricação Própria
~~~

Uso e Consumo é fluxo separado.

Risco:

reutilizar regras de Produto Venda indiscriminadamente em Uso e Consumo.

Impacto:

**ALTO**

Pode causar:

- exigência indevida de Grade;
- geração indevida de SKUs;
- geração indevida de EAN;
- obrigatoriedades incorretas;
- relações comerciais erradas.

Cuidado:

não assumir que todo `Produto` possui as mesmas regras funcionais.

---

# 7. Risco — Alterar o Tipo após Criação

O tipo do Produto Venda é imutável.

Não permitir:

~~~text
Revenda → Fabricação Própria
~~~

ou:

~~~text
Fabricação Própria → Revenda
~~~

Impacto:

**CRÍTICO**

Pode comprometer:

- Compras;
- Produção;
- custos;
- Estoque;
- histórico;
- integrações futuras.

Cuidados:

- manter proteção no backend;
- manter campo bloqueado no frontend;
- não criar endpoint alternativo para contornar a regra.

---

# 8. Risco — Mudar a Regra de Referência sem Avaliação

Produto Venda utiliza Referência automática:

~~~text
AA-BB-CCDDD
~~~

Alterações futuras na Referência podem afetar:

- pesquisa;
- identificação comercial;
- integrações;
- relatórios;
- documentos;
- processos externos.

Impacto:

**ALTO**

Cuidados:

- não alterar formato silenciosamente;
- não gerar Referência paralela no frontend;
- não permitir edição livre sem decisão funcional;
- qualquer mudança deve considerar registros existentes.

---

# 9. Risco — Concorrência na Geração da Referência

A sequência utilizada para Referência não pode produzir duplicidade em operações concorrentes.

Impacto:

**CRÍTICO**

Cuidado:

preservar mecanismo transacional/seguro existente para obtenção da sequência.

Não implementar:

~~~text
max(sequencia) + 1
~~~

sem proteção adequada de concorrência.

---

# 10. Risco — Alterar a Grade após Existirem SKUs

Grade torna-se estrutural depois da criação das variações.

Impacto:

**CRÍTICO**

Exemplo perigoso:

~~~text
Produto possui:
P / M / G

Usuário muda Grade para:
36 / 38 / 40
~~~

Isso deixaria SKUs anteriores semanticamente incompatíveis.

Cuidados:

- manter Grade imutável após SKU;
- não liberar o campo apenas no frontend;
- manter validação no backend.

---

# 11. Risco — Tratar Cor como Campo Meramente Visual

Cor participa da identidade do SKU.

~~~text
Produto + Cor + Tamanho = SKU
~~~

Impacto:

**ALTO**

Alterar seleção de Cores interfere em:

- ProdutoDetalhe;
- EAN;
- Estoque;
- histórico.

Cuidados:

- manter sincronização central;
- não manipular somente lista visual;
- tratar alteração como operação estrutural.

---

# 12. Risco — Excluir SKU ao Remover Cor

A regra homologada é:

~~~text
Cor removida
    ↓
SKU inativado
~~~

e não:

~~~text
Cor removida
    ↓
DELETE SKU
~~~

Impacto:

**CRÍTICO**

Excluir SKU pode causar:

- perda de EAN;
- perda de histórico;
- quebra de movimentos;
- quebra de Estoque;
- inconsistência em documentos anteriores.

---

# 13. Risco — Não Tratar Lista de Cores Vazia

A remoção da última Cor é permitida.

Uma implementação futura não deve fazer:

~~~text
if cores.length == 0:
    return
~~~

antes de sincronizar os SKUs existentes.

Impacto:

**ALTO**

Isso impediria a inativação dos SKUs da última Cor.

Esse problema já foi identificado e corrigido durante o desenvolvimento.

---

# 14. Risco — Criar Novo SKU ao Reintroduzir Cor

Quando uma Cor retirada retorna, os SKUs anteriores devem ser reativados.

Não criar novos.

Impacto:

**CRÍTICO**

Consequências possíveis:

- SKU duplicado;
- EAN duplicado ou abandonado;
- histórico fragmentado;
- Estoque separado incorretamente.

Regra:

~~~text
Encontrou Produto + Cor + Tamanho existente?
    ↓
Reativar
~~~

---

# 15. Risco — Reciclar EAN

EAN permanece associado ao SKU.

SKU inativado não libera seu EAN para outro SKU.

Impacto:

**CRÍTICO**

Um EAN reutilizado pode fazer:

- leitor identificar mercadoria errada;
- venda baixar SKU incorreto;
- Estoque movimentar Produto incorreto;
- integração externa interpretar Produto errado.

Regra permanente:

~~~text
mesmo SKU
=
mesmo EAN
~~~

---

# 16. Risco — Gerar Novo EAN na Reativação

Ao reativar SKU existente:

**não gerar novo EAN**.

Impacto:

**ALTO**

A reativação deve reutilizar:

- SKU;
- identificador;
- EAN;
- histórico.

---

# 17. Risco — Criar Segundo Gerador de EAN

O [[Sysvar]] já possui estrutura para geração de EAN.

Produto Venda não deve criar outro algoritmo independente.

Impacto:

**CRÍTICO**

Pode resultar em:

- colisões;
- sequências divergentes;
- duplicidade;
- dificuldade de auditoria.

---

# 18. Risco — Concorrência na Geração de EAN

Duas operações simultâneas não podem receber o mesmo item sequencial.

Impacto:

**CRÍTICO**

Cuidados:

- preservar `select_for_update` ou mecanismo equivalente existente;
- manter geração no backend;
- não gerar EAN no navegador;
- não usar cálculo sem proteção transacional.

---

# 19. Risco — Confundir Produto e SKU

Produto representa a referência principal.

SKU representa a variação.

Exemplo:

~~~text
Produto:
Vestido

SKUs:
Vestido Preto P
Vestido Preto M
Vestido Azul P
Vestido Azul M
~~~

Impacto de confundir os conceitos:

**CRÍTICO**

Pode afetar:

- Estoque;
- Venda;
- custo;
- EAN;
- relatórios.

---

# 20. Risco — Controlar Estoque Somente no Produto

A granularidade homologada é:

~~~text
Loja × SKU
~~~

Não:

~~~text
Produto = saldo único
~~~

Impacto:

**CRÍTICO**

Uma referência pode possuir:

- Cores diferentes;
- Tamanhos diferentes;
- saldo diferente por Loja.

---

# 21. Risco — Confundir Inicialização de Estoque com Entrada

Selecionar Lojas no cadastro apenas prepara registros de Estoque.

Não significa recebimento físico.

Regra:

~~~text
Inicialização
=
Loja × SKU com saldo inicial zero
~~~

Impacto de criar quantidade artificial:

**CRÍTICO**

Nunca registrar entrada física apenas porque uma Loja foi selecionada.

---

# 22. Risco — Bloquear Exclusão por Estoque Zero Estrutural

Produto novo pode possuir registros de Estoque zero criados apenas para estrutura.

Esses registros, isoladamente, não devem transformar automaticamente um Produto nunca utilizado em Produto histórico.

Impacto:

**MÉDIO**

Cuidados:

- diferenciar estrutura vazia de movimentação;
- permitir limpeza segura quando a exclusão for válida;
- não excluir movimentos reais.

---

# 23. Risco — Excluir Produto Utilizado

Produto com movimento ou relacionamento histórico relevante deve ser preservado.

Impacto:

**CRÍTICO**

Pode causar:

- Foreign Keys quebradas;
- vendas históricas inconsistentes;
- relatórios incompletos;
- perda de rastreabilidade.

Alternativas corretas:

- Inativar;
- Bloquear venda.

---

# 24. Risco — Confundir Inativação e Exclusão

Inativar:

~~~text
preserva Produto
~~~

Excluir:

~~~text
remove fisicamente
~~~

Impacto:

**ALTO**

Nunca implementar inativação como `DELETE`.

---

# 25. Risco — Confundir Bloqueio de Venda e Inativação

São estados independentes.

É possível:

~~~text
ativo = true
bloqueado_venda = true
~~~

Impacto:

**ALTO**

O Produto pode continuar válido cadastralmente e estar temporariamente impedido de vender.

---

# 26. Risco — Venda Considerar Apenas Produto Ativo

`ativo = true` não significa venda automaticamente autorizada.

O processo comercial também precisa considerar fatores como:

- `bloqueado_venda`;
- SKU ativo;
- Estoque;
- preço;
- regras do PDV.

Impacto:

**ALTO**

Produto Venda não deve ser usado para eliminar validações do módulo de Vendas.

---

# 27. Risco — SKU Inativo Continuar Vendável

Um Produto pode estar ativo enquanto determinado SKU está inativo.

Impacto:

**ALTO**

Exemplo:

~~~text
Produto ativo
Cor Preta retirada
SKU Preto M inativo
~~~

O SKU inativo não deve ser tratado como variação normal disponível para nova operação comercial.

---

# 28. Risco — Alterar Custos Diretamente sem Origem

Custos podem vir de:

- Compras;
- recebimento;
- Produção;
- movimentos próprios.

Impacto:

**ALTO**

Não criar atualizações arbitrárias de:

- custo original;
- última compra;
- custo médio.

Produto Venda não deve substituir os motores próprios de custo.

---

# 29. Risco — Quebrar Propagação de Custos da Produção

Para Fabricação Própria, a Ordem de Produção participa da determinação dos custos.

Impacto:

**ALTO**

Cuidados:

- não sobrescrever valores produzidos por Produção;
- manter responsabilidade no módulo correto;
- revisar integração antes de alterar campos de custo.

---

# 30. Risco — Criar Preço por SKU sem Decisão

O modelo atual trabalha comercialmente com preço relacionado ao Produto/Tabela de Preço.

Não foi aprovada regra obrigatória de preço individual por Cor/Tamanho.

Impacto:

**ALTO**

Criar preço de SKU isoladamente pode produzir dois motores concorrentes de preço.

---

# 31. Risco — Criar Tabela de Preço por Loja

Não existe regra atual:

~~~text
1 Loja = 1 Tabela obrigatória
~~~

Impacto:

**MÉDIO/ALTO**

Preço e Loja são conceitos diferentes.

Não introduzir associação obrigatória sem decisão funcional.

---

# 32. Risco — Fazer Frontend Virar Autoridade de Preço

Preço apresentado pelo frontend não deve se tornar autoridade comercial definitiva por simples cálculo local.

Impacto:

**CRÍTICO** em processos de Venda.

As regras finais devem permanecer no backend/processos responsáveis.

---

# 33. Risco — Remover Editabilidade Fiscal

Dados fiscais podem mudar.

Impacto:

**ALTO**

Não bloquear permanentemente:

- NCM;
- Origem;
- CST/CSOSN;
- alíquotas;
- CFOP;
- PIS;
- COFINS;
- IPI.

Alterações devem ser permitidas e rastreadas.

---

# 34. Risco — Alterar Fiscal sem Histórico

Dados fiscais possuem impacto operacional e tributário.

Impacto:

**CRÍTICO**

Alterações relevantes devem gerar:

- `ProdutoVendaHistorico`;
- Auditoria Central.

Não alterar silenciosamente.

---

# 35. Risco — Duplicar Histórico e Auditoria

`ProdutoVendaHistorico` e `AuditLog` possuem responsabilidades diferentes.

Não devem ser fundidos.

Também não devem gerar eventos redundantes sem alteração real.

Impacto:

**MÉDIO**

Cuidados:

- histórico funcional para leitura operacional;
- AuditLog para rastreabilidade técnica;
- comparar before/after;
- registrar apenas mudança efetiva quando aplicável.

---

# 36. Risco — Retirar Auditoria Central

ProdutoVendaHistorico não substitui Auditoria Central.

Impacto:

**ALTO**

A arquitetura geral do [[Sysvar]] depende da Auditoria Central para rastreabilidade consistente entre módulos.

---

# 37. Risco — Colocar Dados Sensíveis Desnecessários em AuditLog

Mesmo em Produto, Auditoria deve registrar apenas informações necessárias.

Impacto:

**MÉDIO**

Cuidados:

- não registrar arquivos binários;
- não registrar senha;
- não registrar tokens;
- evitar payloads gigantes;
- registrar campos relevantes.

---

# 38. Risco — Permitir Ação Sensível Apenas por `is_staff`

O Produto Venda já apresentou esse problema.

O Admin funcional do [[Sysvar]] não deve depender de `is_staff` do Django Admin para operar normalmente o ERP.

Impacto:

**ALTO**

Permissão correta utiliza o modelo funcional do sistema.

Conceito:

~~~text
EffectiveAccessService(user)
    ↓
Produtos
    ↓
EDIT
~~~

---

# 39. Risco — Remover Validação de Permissão porque Existe Senha

Senha e permissão são controles diferentes.

Não assumir:

~~~text
senha válida
=
usuário autorizado
~~~

Impacto:

**CRÍTICO**

Fluxo correto:

~~~text
Usuário autenticado
        ↓
Tem permissão?
        ↓
Validação de motivo/senha
        ↓
Executar
~~~

---

# 40. Risco — Remover Senha porque Usuário Tem Permissão

O inverso também é errado.

Quando determinada ação exige senha:

~~~text
EDIT
+
senha válida
+
motivo quando obrigatório
~~~

Impacto:

**ALTO**

A correção de autorização não deve enfraquecer a confirmação da operação.

---

# 41. Risco — Remover Motivo de Ações Sensíveis

Motivo foi definido para ações como:

- Inativar;
- Bloquear venda.

Impacto:

**MÉDIO/ALTO**

O motivo auxilia:

- auditoria;
- rastreabilidade;
- análise operacional.

---

# 42. Risco — Confiar no `*ngIf` como Segurança

Ocultar botão no Angular não impede chamada direta à API.

Impacto:

**CRÍTICO**

Toda ação protegida deve ser validada novamente no backend.

---

# 43. Risco — Permitir Quarta Imagem

Limite homologado:

~~~text
0..3 imagens
~~~

Impacto:

**MÉDIO**

A proteção deve existir:

- no frontend;
- no backend.

Não confiar apenas no bloqueio visual.

---

# 44. Risco — Mais de Uma Imagem Principal

Regra:

~~~text
Produto
→ no máximo 1 principal
~~~

Impacto:

**MÉDIO**

Pode gerar comportamento inconsistente em:

- catálogo;
- consulta;
- futuras integrações;
- e-commerce.

---

# 45. Risco — Criar Imagem por Cor sem Nova Decisão

Regra atual:

~~~text
Imagem → Produto
~~~

Não:

~~~text
Imagem → Cor
~~~

Impacto:

**MÉDIO/ALTO**

Isso alteraria significativamente o domínio e a interface.

---

# 46. Risco — Criar Imagem por SKU sem Nova Decisão

Da mesma forma:

~~~text
Imagem != ProdutoDetalhe
~~~

Impacto:

**MÉDIO/ALTO**

Seria necessária nova decisão funcional e técnica.

---

# 47. Risco — Inventar Parâmetros de Imagem Reduzida

Ainda não foram aprovados:

- largura;
- altura;
- resolução;
- formato;
- compressão;
- qualidade.

Impacto:

**MÉDIO**

Não escolher valores arbitrários.

Regra atual:

~~~text
se imagem_reduzida_url existir:
    usar reduzida
senão:
    usar imagem_url
~~~

---

# 48. Risco — Armazenar Imagens de Forma Ineficiente

Embora o padrão de redução ainda não esteja definido, imagens podem crescer significativamente em volume.

Impacto:

**MÉDIO**

Antes de ampliar uso de imagens, avaliar:

- armazenamento;
- tamanho médio;
- backup;
- tráfego;
- cache;
- limpeza de arquivos removidos.

Isso deve ser uma decisão técnica específica futura.

---

# 49. Risco — Paginação Voltar a Ser Client-Side

A listagem foi consolidada como server-side.

Impacto:

**ALTO**

Carregar todos os Produtos da Empresa pode causar:

- lentidão;
- uso excessivo de memória;
- tráfego elevado;
- filtros inconsistentes.

Preservar:

~~~text
page
page_size
count
results
~~~

---

# 50. Risco — Misturar Referência e Código na Busca Geral

Referência e Código possuem filtros próprios.

Um problema anterior concatenava filtros de forma inadequada.

Impacto:

**MÉDIO**

Cuidados:

- manter parâmetros independentes;
- combinar filtros no backend;
- preservar semântica de cada critério.

---

# 51. Risco — Perder Filtros ao Trocar Página

Paginação e filtros devem funcionar juntos.

Impacto:

**MÉDIO**

Ao avançar:

~~~text
filtros atuais
+
nova página
~~~

devem continuar na requisição.

---

# 52. Risco — Ordenação Somente no Frontend

Com paginação server-side, ordenar apenas os registros visíveis gera resultado falso.

Impacto:

**MÉDIO**

Ordenação deve ocorrer no backend antes da paginação.

---

# 53. Risco — Consulta Alterar Dados

A operação Consultar é somente leitura.

Impacto:

**MÉDIO**

Cuidados:

- desabilitar edição;
- não reutilizar eventos de alteração indevidamente;
- não disparar PATCH durante simples consulta;
- não permitir upload/exclusão de imagens em modo consulta.

---

# 54. Risco — Ocultar SKU Inativo na Consulta Estrutural

SKU inativo continua sendo parte da história do Produto.

Impacto:

**MÉDIO**

A tabela deve permitir identificar claramente:

- Ativo;
- Inativo.

Não deixar usuário acreditar que o SKU desapareceu.

---

# 55. Risco — Usar Apenas Cor Visual para Status

Status precisa possuir texto.

Não usar apenas:

- verde;
- vermelho;
- cinza.

Impacto:

**BAIXO/MÉDIO**

Motivos:

- clareza;
- acessibilidade;
- impressão;
- interpretação operacional.

---

# 56. Risco — Recolocar Margem Monetária e Remover Status

A decisão homologada foi:

- manter Margem %;
- mostrar Status;
- retirar Margem monetária da tabela principal de SKUs.

Impacto:

**BAIXO/MÉDIO**

Qualquer mudança deve preservar visibilidade do Status.

---

# 57. Risco — Produto Venda Absorver Compras

Produto Venda fornece o cadastro.

Compras controla aquisição.

Não mover para Produto responsabilidades como:

- aprovação de Pedido;
- parcelas;
- fornecedor;
- recebimento;
- financeiro.

Impacto:

**ALTO**

---

# 58. Risco — Produto Venda Absorver Produção

Fabricação Própria não significa que Produto Venda deva executar a Produção.

Não mover para Produto:

- criação/controle de OP;
- apontamentos;
- facção;
- consumo de matéria-prima;
- encerramento;
- custo completo.

Impacto:

**ALTO**

Produto apenas se relaciona com essas estruturas.

---

# 59. Risco — Alterar Produção porque Consulta Mostra OP

A consulta consolidada apresenta Ficha Técnica e OP.

Isso não dá à tela Produto Venda autoridade sobre essas entidades.

Impacto:

**ALTO**

Consulta é informativa.

---

# 60. Risco — Produto Venda Absorver Estoque

Cadastro não deve executar livremente:

- entradas;
- saídas;
- transferências;
- ajustes.

Impacto:

**CRÍTICO**

O único comportamento cadastral específico é a inicialização estrutural em zero prevista.

---

# 61. Risco — Produto Venda Absorver PDV

Produto Venda fornece dados ao PDV.

Não mover para ele:

- fechamento de Venda;
- pagamento;
- emissão NFC-e;
- contingência;
- baixa comercial;
- sincronização offline.

Impacto:

**CRÍTICO**

---

# 62. Risco — Produto Venda Absorver Fiscal

Manter Dados fiscais do Produto não significa executar emissão fiscal.

Impacto:

**ALTO**

Fiscal permanece responsável pelos documentos e regras operacionais de emissão.

---

# 63. Risco — Alterar Origem de Abastecimento

Tipos possuem origem operacional distinta:

~~~text
Revenda
→ Compras
~~~

~~~text
Fabricação Própria
→ Produção
~~~

Impacto:

**ALTO**

Não misturar os fluxos sem decisão funcional.

---

# 64. Risco — Alterar Código Interno dos Tipos

Códigos homologados:

~~~text
1 = Revenda
3 = Fabricação Própria
~~~

Impacto:

**CRÍTICO**

Não trocar valores apenas para adequar nomenclatura visual.

A interface pode mudar texto sem alterar o código interno.

---

# 65. Risco — Voltar a Usar “Produto Próprio”

A nomenclatura aprovada é:

**Fabricação Própria**

Impacto:

**BAIXO**

Porém gera inconsistência entre:

- interface;
- documentação;
- treinamento;
- suporte.

Preservar nomenclatura oficial.

---

# 66. Risco — Voltar a Nomear a Funcionalidade como “Produtos Revenda”

O módulo consolidado contempla dois tipos.

Nome correto:

**Produto Venda**

Impacto:

**MÉDIO**

“Produtos Revenda” exclui conceitualmente Fabricação Própria e pode induzir novos desenvolvimentos incorretos.

---

# 67. Risco — Quebrar Grupo/Subgrupo

Subgrupo deve ser coerente com Grupo.

Impacto:

**ALTO**

Não confiar somente no filtro visual do combo.

O backend deve validar.

---

# 68. Risco — Tornar Subgrupo Opcional

Subgrupo foi homologado como obrigatório em Produto Venda.

Impacto:

**MÉDIO/ALTO**

Não flexibilizar silenciosamente.

---

# 69. Risco — Tornar Unidade Opcional

Unidade é obrigatória.

Impacto:

**MÉDIO/ALTO**

Pode comprometer:

- Compras;
- Estoque;
- Fiscal;
- relatórios.

---

# 70. Risco — Remover Obrigatoriedade da Descrição Reduzida

Descrição reduzida foi definida como obrigatória.

Limite:

~~~text
60 caracteres
~~~

Impacto:

**MÉDIO**

Não alterar sem decisão funcional.

---

# 71. Risco — Transformar Material em Obrigatório

Material permanece opcional.

Impacto:

**MÉDIO**

Não impedir cadastro de Produto Venda por ausência de Material.

---

# 72. Risco — Confundir Material com Componente de Produção

Material classificatório do Produto não substitui matéria-prima/componente da Ficha Técnica.

Impacto:

**ALTO**

---

# 73. Risco — Criar Estoque por Empresa sem Loja

O controle operacional definido é:

~~~text
Loja × SKU
~~~

Um saldo global de Empresa não deve substituir essa granularidade.

Impacto:

**CRÍTICO**

---

# 74. Risco — Calcular Disponível de Forma Divergente

Conceito atual:

~~~text
Disponível = Físico - Reserva
~~~

Impacto:

**ALTO**

Se o conceito evoluir, deve existir uma regra central.

Não criar fórmulas divergentes entre:

- Produto;
- PDV;
- Estoque;
- relatórios.

---

# 75. Risco — Alterar Estoque Negativo no Cadastro de Produto

A permissão de Estoque negativo pertence ao domínio próprio de Estoque/operação.

Impacto:

**ALTO**

Não criar campo ou regra concorrente em Produto Venda.

---

# 76. Risco — Criar Reserva dentro do Cadastro

Reserva pertence a processos operacionais.

Produto Venda pode exibir saldo reservado, mas não deve criar um motor de reserva próprio.

Impacto:

**ALTO**

---

# 77. Risco — Remover Testes de Regressão dos Pontos Críticos

Mudanças futuras devem preservar testes para:

- tipo imutável;
- Grade imutável;
- sincronização de Cores;
- última Cor;
- reativação;
- EAN;
- exclusão;
- tenant;
- imagens;
- fiscal;
- permissões;
- filtros;
- paginação.

Impacto:

**ALTO**

Esses testes protegem regras que já apresentaram risco real durante desenvolvimento.

---

# 78. Risco — Rodar Apenas Testes do Frontend

Grande parte da autoridade está no backend.

Impacto:

**ALTO**

Uma tela funcionando não comprova:

- tenant;
- permissão;
- integridade;
- proteção de exclusão;
- concorrência;
- auditoria.

---

# 79. Risco — Rodar Apenas Testes do Backend

Também não é suficiente.

Impacto:

**MÉDIO**

Frontend precisa preservar:

- campos obrigatórios;
- nomenclatura;
- Status;
- imagens;
- filtros;
- paginação;
- fluxos de segurança;
- UX homologada.

---

# 80. Risco — Migration Desnecessária

A correção de interface ou regra que já utiliza campos existentes não deve criar migration sem motivo.

Impacto:

**MÉDIO**

Antes de criar migration:

1. conferir model;
2. conferir migration atual;
3. confirmar necessidade real.

---

# 81. Risco — Migration Destrutiva

Mudanças de Produto podem afetar grande quantidade de dados históricos.

Impacto:

**CRÍTICO**

Evitar migrations que:

- apaguem EANs;
- recriem SKUs;
- modifiquem Referências em massa;
- alterem tipos silenciosamente;
- eliminem registros históricos;
- preencham dados fiscais inventados.

---

# 82. Risco — Inventar Dados em Migração

Quando informação não é conhecida:

não inventar.

Impacto:

**ALTO**

Exemplos perigosos:

- NCM fictício;
- EAN fictício;
- Cor artificial;
- Tamanho artificial;
- tipo arbitrário.

---

# 83. Risco — Reprocessar Todos os SKUs sem Necessidade

Operações em massa podem gerar:

- reativação indevida;
- duplicação;
- mudança de EAN;
- custo elevado;
- locks.

Impacto:

**CRÍTICO**

Reprocessamentos devem possuir critério claro e testes prévios.

---

# 84. Risco — Alterar ProdutoDetalhe para Resolver Problema de Tela

ProdutoDetalhe é entidade estrutural.

Não modificar model ou banco apenas para facilitar uma apresentação visual sem avaliar impactos.

Impacto:

**ALTO**

---

# 85. Risco — Expor ID Interno como Identidade Comercial

IDs internos são técnicos.

A identidade comercial utiliza conceitos como:

- Referência;
- SKU;
- EAN.

Impacto:

**MÉDIO**

Não transformar PK em código comercial sem decisão.

---

# 86. Risco — Histórico Crescer sem Paginação

ProdutoVendaHistorico pode crescer ao longo do tempo.

Impacto:

**MÉDIO**

Em evoluções futuras, considerar paginação quando volume justificar.

Não apagar histórico antigo como solução de desempenho.

---

# 87. Risco — Consulta Consolidada Fazer Chamadas Excessivas

A consulta agrega:

- Produto;
- SKUs;
- Estoque;
- imagens;
- histórico;
- Produção.

Impacto:

**MÉDIO**

Com crescimento do volume, observar:

- N+1 queries;
- chamadas sequenciais excessivas;
- payload muito grande.

Otimizar sem alterar o comportamento funcional.

---

# 88. Risco — Imagens Pesadas Prejudicarem Listagem

Não carregar imagens originais grandes desnecessariamente em listagens extensas.

Impacto:

**MÉDIO**

A definição de miniaturas deve ser feita posteriormente com parâmetros aprovados.

---

# 89. Risco — Misturar Histórico Funcional com Histórico de Estoque

ProdutoVendaHistorico registra eventos cadastrais/funcionais.

Movimentação de Estoque possui domínio próprio.

Impacto:

**MÉDIO**

Não copiar toda movimentação de Estoque para ProdutoVendaHistorico.

---

# 90. Risco — Misturar Histórico Funcional com Histórico de Preço

Alterações de preço pertencem ao domínio de Preços.

ProdutoVendaHistorico não deve virar tabela genérica de tudo que acontece com Produto.

Impacto:

**MÉDIO**

---

# 91. Risco — Fazer Produto Venda Dependente de Produção para Revenda

Revenda não precisa possuir Ficha Técnica ou OP.

Impacto:

**ALTO**

Não tornar essas relações obrigatórias para `tipo_produto = '1'`.

---

# 92. Risco — Permitir Fabricação Própria sem Respeitar Produção

Produto tipo `3` pode existir cadastralmente, mas processos produtivos devem respeitar o módulo de Produção.

Impacto:

**ALTO**

Não criar atalhos de entrada produzida diretamente no cadastro apenas por ser Fabricação Própria.

---

# 93. Risco — Alterar Regras Homologadas sem Atualizar Documentação

Quando uma regra funcional for deliberadamente alterada, os documentos relacionados devem ser atualizados.

Impacto:

**MÉDIO/ALTO**

Documentos relacionados:

- [[Sysvar]]
- [[Homologação - Produtos - Produto Venda]]
- [[Mapa Técnico - Produtos - Produto Venda]]
- [[Workflows - Produtos - Produto Venda]]
- [[Modelo de Domínio - Produtos - Produto Venda]]
- [[Riscos e Cuidados - Produtos - Produto Venda]]

Não permitir código e documentação divergirem por longo período.

---

# 94. Risco — Documentos Ficarem Isolados no Grafo

Os documentos do Produto Venda devem permanecer interligados através de links internos do Obsidian.

Impacto:

**BAIXO/MÉDIO**

Sem links:

- contexto fica fragmentado;
- Graph View cria ilhas;
- agentes e pessoas encontram menos relações;
- navegação piora.

Todo documento principal do módulo deve possuir links para:

- [[Sysvar]];
- Homologação;
- Mapa Técnico;
- Workflows;
- Modelo de Domínio;
- Riscos e Cuidados.

---

# 95. Risco — Remover Links ao Renomear Arquivos

Ao renomear documentos no vault, verificar os backlinks.

Impacto:

**MÉDIO**

Especial atenção a:

~~~text
[[Sysvar]]
[[Homologação - Produtos - Produto Venda]]
[[Mapa Técnico - Produtos - Produto Venda]]
[[Workflows - Produtos - Produto Venda]]
[[Modelo de Domínio - Produtos - Produto Venda]]
[[Riscos e Cuidados - Produtos - Produto Venda]]
~~~

---

# 96. Risco — Alterar o Escopo pelo Nome do Model

O model técnico `Produto` pode atender diferentes necessidades internas.

Isso não significa que toda regra funcional de Produto Venda deva ser aplicada a qualquer registro existente em `Produto`.

Impacto:

**ALTO**

Sempre avaliar `tipo_produto` e escopo funcional.

---

# 97. Risco — Duplicar Endpoint para Contornar Regra

Não criar endpoint paralelo apenas para ignorar validação de:

- tipo;
- Grade;
- tenant;
- permissão;
- exclusão;
- EAN;
- fiscal.

Impacto:

**CRÍTICO**

A regra deve permanecer central.

---

# 98. Risco — Criar “Jeitinho” no Frontend

Não resolver regra estrutural manipulando apenas:

- FormControl;
- CSS;
- valor local;
- array temporário.

Impacto:

**ALTO**

Se é regra de negócio, precisa existir no backend.

---

# 99. Risco — Alterar API sem Avaliar Consumidores

Produto é utilizado por múltiplos módulos.

Impacto:

**CRÍTICO**

Antes de alterar:

- nomes de campos;
- formato de resposta;
- filtros;
- EAN;
- identificadores;
- Status;

verificar consumidores como:

- Compras;
- Estoque;
- Produção;
- Fiscal;
- PDV;
- relatórios.

---

# 100. Risco — Remover Compatibilidade Necessária sem Análise

Alguns nomes e estruturas podem ainda possuir consumidores legados.

Impacto:

**ALTO**

Não remover campo ou endpoint apenas porque a nova tela não o utiliza sem antes verificar referências no projeto.

---

# 101. Risco — Escopo Crescer por Conveniência

Produto Venda é uma entidade central e tende a atrair funcionalidades.

Risco:

transformar a tela em:

- Estoque;
- Compras;
- Produção;
- Fiscal;
- PDV;
- Preços;
- Distribuição.

Impacto:

**ALTO**

O Produto deve permanecer uma raiz cadastral clara.

---

# 102. Checklist Antes de Alterar Produto Venda

Antes de qualquer mudança relevante, verificar:

### Identidade

- altera Referência?
- altera tipo?
- altera ProdutoDetalhe?
- altera EAN?

### Multiempresa

- tenant continua aplicado?
- alguma ForeignKey pode cruzar Empresa?

### SKU

- cria duplicidade?
- pode perder SKU histórico?
- preserva EAN?

### Estoque

- altera saldo?
- altera Loja × SKU?
- confunde inicialização com movimento?

### Fiscal

- alteração é rastreada?
- existe impacto em emissão?

### Segurança

- backend valida permissão?
- motivo e senha continuam onde exigidos?

### Histórico

- ProdutoVendaHistorico permanece?
- AuditLog permanece?

### Integrações

- Compras?
- Estoque?
- Produção?
- Fiscal?
- PDV?
- Preços?

### Documentação

- [[Homologação - Produtos - Produto Venda]]
- [[Mapa Técnico - Produtos - Produto Venda]]
- [[Workflows - Produtos - Produto Venda]]
- [[Modelo de Domínio - Produtos - Produto Venda]]
- este documento.

---

# 103. Checklist Antes de Migration

Antes de migration em Produto:

1. confirmar necessidade real;
2. verificar quantidade de registros afetados;
3. verificar EAN;
4. verificar ProdutoDetalhe;
5. verificar Estoque;
6. verificar histórico;
7. verificar tipos;
8. verificar Foreign Keys;
9. verificar impacto cross-tenant;
10. possuir estratégia de rollback quando aplicável;
11. executar testes direcionados;
12. não inventar dados.

---

# 104. Checklist Antes de Alterar Sincronização de Cores

Verificar obrigatoriamente:

- inclusão de Cor nova;
- inclusão de várias Cores;
- retirada de uma Cor;
- retirada da última Cor;
- reentrada de Cor;
- EAN preservado;
- SKU preservado;
- SKU ativo/inativo correto;
- Estoque não perdido;
- tenant preservado.

---

# 105. Checklist Antes de Alterar EAN

Verificar:

- sequência;
- transação;
- concorrência;
- unicidade;
- prefixo;
- dígito verificador;
- reativação;
- SKU já existente;
- ausência de reciclagem;
- impacto no PDV.

---

# 106. Checklist Antes de Alterar Exclusão

Verificar:

- Produto nunca utilizado;
- registros de Estoque zero;
- movimentos existentes;
- Compras;
- Produção;
- vendas;
- Fiscal;
- histórico;
- imagens;
- Foreign Keys;
- mensagem funcional de erro.

---

# 107. Checklist Antes de Alterar Permissões

Testar:

~~~text
Admin funcional com EDIT
→ autorizado
~~~

~~~text
Usuário comum com EDIT
→ conforme permissão funcional
~~~

~~~text
Usuário sem EDIT
→ 403
~~~

~~~text
Senha inválida
→ operação rejeitada
~~~

~~~text
Motivo ausente quando obrigatório
→ operação rejeitada
~~~

Não voltar a depender apenas de `is_staff`.

---

# 108. Checklist Antes de Alterar Imagens

Verificar:

- máximo de 3;
- imagem opcional;
- uma principal;
- incluir;
- remover;
- alterar principal;
- consulta sem imagem;
- fallback `imagem_url`;
- nenhum vínculo por Cor;
- nenhum vínculo por SKU.

---

# 109. Checklist Antes de Alterar Listagem

Verificar:

- backend paginado;
- `count`;
- filtros independentes;
- filtros combinados;
- ordenação;
- próxima página;
- página anterior;
- alteração de page size;
- indicador X–Y de Z;
- tenant.

---

# 110. Regras Críticas que Não Devem Regredir

1. Produto pertence a uma Empresa.
2. Produto Venda contempla Revenda e Fabricação Própria.
3. Tipo 1 = Revenda.
4. Tipo 3 = Fabricação Própria.
5. Tipo é imutável.
6. Referência é automática.
7. Grade é obrigatória.
8. Grade é imutável após SKU.
9. Grupo é obrigatório.
10. Subgrupo é obrigatório.
11. Unidade é obrigatória.
12. descrição reduzida é obrigatória.
13. SKU = Produto × Cor × Tamanho.
14. remover Cor inativa SKU.
15. remover última Cor também inativa.
16. reintroduzir Cor reativa SKU existente.
17. EAN é preservado.
18. EAN não é reciclado.
19. Estoque = Loja × SKU.
20. inicialização de Estoque não é entrada.
21. Produto utilizado não pode ser excluído.
22. Inativo não é excluído.
23. Bloqueio de venda não é Inativação.
24. SKU Inativo deve ser identificável.
25. Dados fiscais são editáveis.
26. alterações fiscais são rastreadas.
27. ProdutoVendaHistorico e AuditLog são distintos.
28. imagens são opcionais.
29. máximo de 3 imagens.
30. no máximo uma imagem principal.
31. imagem pertence ao Produto.
32. não existe imagem por Cor.
33. não existe imagem por SKU.
34. filtros são server-side.
35. paginação é server-side.
36. backend é autoridade.
37. permissões usam modelo funcional do Sysvar.
38. senha e motivo são preservados onde exigidos.
39. Revenda não deve depender de Produção.
40. Fabricação Própria não deve duplicar o módulo de Produção.

---

# 111. Itens Deliberadamente Não Definidos

Ainda não foram definidos nesta fase:

- parâmetros finais de imagem reduzida;
- motor avançado de preço;
- promoções;
- regras avançadas de reserva;
- PDV offline;
- Distribuição;
- cálculo completo de CMV;
- novas regras de Produção;
- regras fiscais operacionais completas de emissão.

Essas lacunas são intencionais.

Não devem ser preenchidas por suposição técnica.

---

# 112. Documentação de Referência

Projeto:

[[Sysvar]]

Homologação:

[[Homologação - Produtos - Produto Venda]]

Implementação técnica:

[[Mapa Técnico - Produtos - Produto Venda]]

Fluxos:

[[Workflows - Produtos - Produto Venda]]

Domínio:

[[Modelo de Domínio - Produtos - Produto Venda]]

Este documento:

[[Riscos e Cuidados - Produtos - Produto Venda]]

O conjunto deve permanecer interligado.

---

# 113. Commits Homologados de Referência

Backend:

`574f5badc79ab3a969bf24ffc67904215bdbc49a`

Frontend:

`1be513e4a5d7b3220ae239fee555594307115826`

Esses commits representam o fechamento atual do escopo homologado de Produto Venda.

---

# 114. Estado Atual

Produto Venda encontra-se:

~~~text
IMPLEMENTADO
TESTADO
HOMOLOGADO
DOCUMENTADO
~~~

Homologação manual:

**19/19 itens aprovados**

Qualquer evolução futura deve preservar as regras homologadas e consultar conjuntamente:

- [[Sysvar]]
- [[Homologação - Produtos - Produto Venda]]
- [[Mapa Técnico - Produtos - Produto Venda]]
- [[Workflows - Produtos - Produto Venda]]
- [[Modelo de Domínio - Produtos - Produto Venda]]
- [[Riscos e Cuidados - Produtos - Produto Venda]]

O objetivo principal é evoluir Produto Venda sem perder:

- identidade;
- integridade;
- histórico;
- isolamento multiempresa;
- compatibilidade entre módulos;
- segurança;
- rastreabilidade.