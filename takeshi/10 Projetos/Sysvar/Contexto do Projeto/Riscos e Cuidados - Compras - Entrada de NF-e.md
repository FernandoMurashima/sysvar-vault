---
type: risks-and-care
status: approved
project: Sysvar
group: Compras
module: Entrada de NF-e
phase: Fase 1
created: 2026-08-18
updated: 2026-08-18
tags:
  - sysvar
  - compras
  - entrada-nfe
  - nota-fiscal
  - recebimento
  - estoque
  - financeiro
  - custos
  - revenda
  - uso-consumo
  - insumo
  - riscos
  - auditoria
  - multiempresa
  - homologado
---

# Riscos e Cuidados - Compras - Entrada de NF-e

## 1. Identificação

- **Projeto:** [[Sysvar]]
- **Módulo:** Compras
- **Funcionalidade:** Entrada de NF-e
- **Tipos contemplados:** Revenda, Uso/Consumo e Insumo
- **Situação:** IMPLEMENTADO E HOMOLOGADO
- **Data da homologação:** 18/08/2026

### Documentos relacionados

- [[Sysvar]]
- [[Mapa Técnico - Compras - Pedido de Compra]]
- [[Modelo de Domínio - Compras - Pedido de Compra]]
- [[Workflows - Compras - Pedido de Compra]]
- [[Mapa Técnico - Compras - Entrada de NF-e]]
- [[Modelo de Domínio - Compras - Entrada de NF-e]]
- [[Workflows - Compras - Entrada de NF-e]]
- [[Homologação - Compras - Entrada de NF-e]]

---

# 2. Objetivo

Este documento registra riscos técnicos, funcionais, operacionais e arquiteturais da Entrada de NF-e.

Deve ser consultado antes de alterações relevantes em:

- `NotaFiscalEntrada`;
- `NotaFiscalEntradaItem`;
- serializers;
- viewsets;
- fechamento;
- cancelamento;
- estoque;
- custos;
- financeiro;
- recebimento;
- frontend da Entrada de NF-e;
- integração com Pedido de Compra.

O objetivo é evitar regressões em uma funcionalidade já homologada.

---

# 3. Risco — recriar Notas Lançadas como funcionalidade separada

A funcionalidade oficial é:

**Entrada de NF-e**

A própria listagem contém as notas já registradas.

Não recriar uma segunda entrada chamada:

**Notas Lançadas**

sem nova decisão funcional explícita.

Isso criaria:

- duplicidade de navegação;
- duplicidade de manutenção;
- risco de telas divergentes;
- confusão operacional.

---

# 4. Risco — exigir módulo Fiscal para acessar Entrada de NF-e

A Entrada de NF-e pertence funcionalmente ao módulo:

~~~text
compras
~~~

Não exigir simultaneamente:

~~~text
compras + fiscal
~~~

O acesso deve continuar respeitando:

~~~text
Compras + VIEW
→ consulta

Compras + EDIT
→ operação
~~~

Usuário somente com Fiscal não recebe acesso à funcionalidade.

---

# 5. Risco — confiar no frontend para segurança

O frontend não é a fronteira de segurança.

Mesmo que opções sejam escondidas ou desabilitadas, o backend precisa continuar protegendo:

- Empresa;
- Pedido;
- itens;
- permissões;
- status;
- fechamento;
- cancelamento;
- filtros;
- indicadores.

Chamadas diretas à API devem encontrar as mesmas validações.

---

# 6. Risco — quebra de isolamento multiempresa

Esse é um risco crítico.

Uma falha pode permitir:

~~~text
Empresa A
→ acessar NF da Empresa B
~~~

Toda alteração deve preservar isolamento em:

- listagem;
- detalhe;
- itens;
- Pedido;
- filtros;
- indicadores;
- estoque;
- financeiro.

---

# 7. Risco — criar NF com Pedido de outra Empresa

Não aceitar `pedido_compra` apenas porque o ID existe.

O Pedido deve pertencer ao tenant autorizado.

Também não aceitar itens vinculados a Pedido de outra Empresa.

---

# 8. Risco — permitir item de outro Pedido

Regra estrutural:

~~~text
NotaFiscalEntrada.pedido_compra
=
NotaFiscalEntradaItem.pedido_item.pedido
~~~

Nunca aceitar:

~~~text
NF do Pedido A
+
item do Pedido B
~~~

Mesmo que ambos sejam da mesma Empresa.

---

# 9. Risco — voltar a usar Pedido na identidade da NF

O Pedido não participa da regra de duplicidade documental.

A identidade homologada é:

~~~text
Empresa
+ Fornecedor
+ Modelo
+ Série
+ Número
~~~

Não reintroduzir:

~~~text
Pedido + Modelo + Série + Número
~~~

como regra de unicidade.

---

# 10. Risco — considerar somente o número da NF

O número da NF sozinho não é identidade suficiente.

Documentos distintos podem possuir o mesmo número quando diferem em:

- Fornecedor;
- Série;
- Empresa.

Não bloquear documentos válidos apenas porque `numero` coincide.

---

# 11. Risco — permitir chave duplicada

Quando `chave_acesso` estiver preenchida:

- deve possuir 44 dígitos;
- DV deve ser válido;
- deve ser única.

Cancelamento não libera a chave para reutilização.

---

# 12. Risco — aceitar chave malformada

Não confiar apenas em tamanho visual do campo.

Backend deve validar:

~~~text
44 dígitos
+
somente números
+
DV válido
~~~

---

# 13. Risco — usar número comercial como identificador de estoque

Não utilizar apenas:

~~~text
numero da NF
~~~

para identificar movimentação.

O identificador homologado é:

~~~text
NFE:<id>:ENTRADA
~~~

e para cancelamento:

~~~text
NFE:<id>:CANCEL
~~~

Isso evita colisão entre documentos diferentes.

---

# 14. Risco — duplicar movimento de entrada

Fechar a mesma NF mais de uma vez não pode gerar entradas repetidas.

A movimentação deve permanecer idempotente.

---

# 15. Risco — duplicar movimento de cancelamento

Uma NF já cancelada não pode gerar novo estorno.

Não criar múltiplos:

~~~text
NFE:<id>:CANCEL
~~~

para o mesmo documento.

---

# 16. Risco — permitir DELETE físico

DELETE direto de NF deve permanecer bloqueado.

A operação correta para desfazer uma NF efetivada é:

**Cancelar NF**

Excluir fisicamente destruiria:

- histórico;
- rastreabilidade;
- vínculos;
- auditoria;
- referência financeira;
- referência de estoque.

---

# 17. Risco — tratar cancelamento como simples mudança de status

Cancelar não significa apenas:

~~~text
FE → CA
~~~

O cancelamento envolve:

- estoque;
- custos;
- financeiro;
- recebimento do Pedido;
- auditoria.

Alterar somente o status produziria inconsistência grave.

---

# 18. Risco — cancelamento não atômico

Cancelamento deve continuar transacional.

Se qualquer etapa crítica falhar:

~~~text
ROLLBACK
~~~

Não deixar estado parcial em:

- NF;
- estoque;
- custos;
- financeiro;
- Pedido.

---

# 19. Risco — fechamento não atômico

O fechamento também atravessa múltiplos subsistemas.

Fluxo:

~~~text
AB
→ estoque
→ custos
→ financeiro
→ recebimento
→ FE
~~~

Falha em qualquer etapa crítica deve impedir conclusão parcial.

---

# 20. Risco — cancelar NF e afetar outra NF do mesmo Pedido

Um Pedido pode possuir várias NFs.

Cada NF deve manter seus próprios efeitos.

Exemplo:

~~~text
Pedido
├── NF 1
├── NF 2
└── NF 3
~~~

Cancelar NF 2 não deve remover efeitos de NF 1 ou NF 3.

---

# 21. Risco — recalcular recebimento sem excluir NF cancelada

NF CA não deve continuar compondo quantidade recebida.

Depois do cancelamento, o Pedido precisa ser recalculado apenas com NFs válidas e fechadas.

---

# 22. Risco — deixar Pedido AT após perda de recebimento

Se o Pedido estava totalmente atendido e uma NF for cancelada:

~~~text
AT
→ AP
~~~

quando voltar a existir saldo pendente.

---

# 23. Risco — forçar AT com recebimento parcial

Enquanto houver saldo:

~~~text
Pedido = AP
~~~

Não marcar AT apenas porque existe uma NF fechada.

---

# 24. Risco — impedir múltiplas NFs legítimas

O domínio suporta recebimento parcelado.

Não criar validação que force:

~~~text
1 Pedido = 1 NF
~~~

O comportamento correto é:

~~~text
1 Pedido
→ várias NFs
~~~

quando necessário.

---

# 25. Risco — quantidade acima do saldo

A quantidade desta NF deve considerar recebimentos válidos anteriores.

Não aceitar:

~~~text
Nesta NF > saldo pendente
~~~

---

# 26. Risco — contar NF cancelada no saldo já recebido

O cálculo de:

- Já recebida;
- Saldo pendente;

não deve considerar quantidade de NF cancelada como recebimento válido.

---

# 27. Risco — permitir quantidade negativa

Quantidade negativa não representa estorno operacional.

Cancelamento possui fluxo próprio.

Não utilizar valores negativos como atalho para corrigir entrada.

---

# 28. Risco — ignorar regra de Pack em Revenda

Para Revenda, o recebimento precisa preservar a composição do Pack.

Não permitir quantidade que produza distribuição inválida pelos tamanhos/SKUs.

---

# 29. Risco — alterar SKU errado em Revenda

Entrada e cancelamento precisam atingir exatamente os SKUs correspondentes a:

- Produto;
- Cor;
- Pack;
- tamanhos.

Erro nessa associação afeta diretamente o estoque comercial.

---

# 30. Risco — aplicar lógica de Pack em Uso/Consumo ou Insumo

Uso/Consumo e Insumo utilizam quantidade direta.

Não introduzir:

- Pack;
- `n_packs`;
- distribuição por tamanhos;

nesses tipos.

---

# 31. Risco — perder suporte a quantidade decimal

Uso/Consumo e Insumo podem utilizar quantidades decimais conforme a Unidade.

Não converter toda quantidade para inteiro.

---

# 32. Risco — desconto maior que valor bruto

Regra:

~~~text
valor_bruto =
qtd_recebida × preco_unit_nf
~~~

Deve permanecer:

~~~text
0 <= desconto_item <= valor_bruto
~~~

---

# 33. Risco — usar desconto negativo como acréscimo

Desconto negativo não deve ser usado para representar acréscimo.

Se houver necessidade futura de acréscimo, deve existir conceito próprio.

---

# 34. Risco — permitir total negativo

Invariantes:

~~~text
total_item >= 0
~~~

~~~text
valor_total >= 0
~~~

Não remover essas proteções.

---

# 35. Risco — confiar em total enviado pelo frontend

O frontend pode mostrar totais para UX.

O backend continua sendo autoridade para cálculo e validação.

Não aceitar valor calculado pela tela como verdade definitiva.

---

# 36. Risco — permitir entrada anterior à emissão

Invariante:

~~~text
dt_entrada >= dt_emissao
~~~

Não remover essa validação durante refatorações de formulário.

---

# 37. Risco — usar checkbox apenas como estado visual

Na interface homologada:

~~~text
checkbox marcado
= NotaFiscalEntradaItem persistido
~~~

Não transformar o checkbox em uma marca local sem correspondência no backend.

---

# 38. Risco — marcar checkbox antes do sucesso do backend

Ao confirmar item:

~~~text
marcar
→ salvar
→ sucesso
→ permanecer marcado
~~~

Em erro, deve permanecer desmarcado.

Isso evita que a tela indique recebimento que não existe.

---

# 39. Risco — desmarcar visualmente antes de remover no backend

Para item persistido:

~~~text
desmarcar
→ confirmar remoção
→ backend remove
→ sucesso
→ checkbox desmarcado
~~~

Se falhar, deve permanecer marcado.

---

# 40. Risco — confundir seleção de linha com confirmação

São conceitos independentes:

~~~text
seleção
= contexto visual

checkbox
= persistência do item
~~~

Não usar seleção de linha para determinar se o item pertence à NF.

---

# 41. Risco — reintroduzir botão Inserir sem necessidade

A solução homologada utiliza checkbox `OK`.

Os botões:

- Inserir;
- Remover;

foram retirados da barra de itens.

Não reintroduzir esse fluxo sem nova decisão funcional.

---

# 42. Risco — reintroduzir coluna Ações nos itens

A interface final não utiliza:

- coluna `Ações`;
- menu de três pontos;
- ações repetidas por linha.

A confirmação é feita pelo checkbox.

---

# 43. Risco — permitir alteração em FE ou CA

Itens e dados protegidos não devem continuar editáveis após fechamento/cancelamento.

Checkbox:

~~~text
AB → habilitado
FE → desabilitado
CA → desabilitado
~~~

---

# 44. Risco — atualizar custo de forma irreversível

Ao cancelar NF antiga, não simplesmente restaurar um snapshot antigo ignorando entradas posteriores.

Os custos precisam ser recalculados com base no histórico válido disponível.

---

# 45. Risco — considerar NF cancelada no custo

NF CA não deve compor o custo vigente como entrada válida.

---

# 46. Risco — destruir custo de entradas posteriores

Exemplo:

~~~text
NF 1
NF 2
NF 3
~~~

Cancelar NF 1 não pode apagar os efeitos corretos das NFs 2 e 3.

---

# 47. Risco — estornar estoque sem verificar saldo

Ao cancelar, o estoque precisa suportar a retirada correspondente.

Se a Loja não permite negativo e o saldo não for suficiente:

~~~text
cancelamento bloqueado
~~~

---

# 48. Risco — ignorar configuração de estoque negativo da Loja

Não aplicar regra única para todas as Lojas.

A configuração da Loja deve continuar sendo respeitada.

---

# 49. Risco — alterar estoque antes de validar todo o cancelamento

Não executar estorno irreversível antes de validar condições críticas.

A transação deve proteger o conjunto da operação.

---

# 50. Risco — duplicar financeiro

Múltiplas NFs de um Pedido não podem gerar:

- Pagar duplicado;
- PagarItem duplicado;
- previsão duplicada.

A integração precisa continuar distinguindo cada NF.

---

# 51. Risco — cancelar financeiro de outra NF

O cancelamento deve localizar e afetar somente registros financeiros correspondentes à NF cancelada.

---

# 52. Risco — cancelar título já pago silenciosamente

Se o financeiro já possui baixa incompatível com reversão automática:

~~~text
cancelamento bloqueado
~~~

O sistema não deve desfazer pagamento sem processo financeiro apropriado.

---

# 53. Risco — deixar previsão financeira incorreta após cancelamento

Depois de cancelar uma NF parcial, o saldo previsto do Pedido deve ser recalculado.

Não deixar:

- previsão menor que o saldo real;
- previsão duplicada;
- previsão inexistente quando ainda existe valor a realizar.

---

# 54. Risco — confundir previsão do Pedido com obrigação efetiva da NF

São conceitos relacionados, mas não equivalentes.

O Pedido representa planejamento.

A NF representa realização efetiva de parte ou total desse planejamento.

Não eliminar essa distinção.

---

# 55. Risco — paginação local sobre conjunto incompleto

A listagem deve continuar paginada pelo backend.

Não voltar a:

~~~text
page_size=1000
~~~

e paginar apenas no navegador.

Isso prejudica:

- desempenho;
- escalabilidade;
- indicadores;
- filtros.

---

# 56. Risco — calcular indicadores somente sobre a página

Indicadores devem usar o conjunto filtrado completo.

Não calcular:

~~~text
Abertas
Fechadas
Canceladas
Valor total
~~~

apenas sobre `results` da página atual.

---

# 57. Risco — aplicar filtros somente no frontend

Filtros principais pertencem ao backend.

Isso garante:

- consistência;
- paginação correta;
- tenant;
- indicadores corretos.

---

# 58. Risco — esquecer tenant nos indicadores

O endpoint de indicadores também precisa respeitar Empresa.

Indicador não pode somar NFs de outros tenants.

---

# 59. Risco — seleção permanecer em registro fora da página

Quando a NF selecionada deixar de pertencer à página visível, a seleção deve ser limpa.

Isso evita operação sobre registro fora do contexto visual atual.

---

# 60. Risco — registrar auditoria antes da conclusão transacional

Auditoria de sucesso deve ocorrer somente após conclusão real.

Se houver rollback:

~~~text
não registrar operação como concluída
~~~

---

# 61. Risco — quebrar rastreabilidade

Deve continuar sendo possível navegar conceitualmente entre:

~~~text
Pedido
→ NF
→ itens
→ estoque
→ financeiro
→ recebimento
~~~

Alterações não devem eliminar identificadores necessários para essa reconstrução.

---

# 62. Risco — substituir `Pagar.nfe_id` sem migração planejada

No estado homologado, a integração financeira utiliza identificação existente por `nfe_id`.

Uma futura substituição por FK direta pode ser válida, mas exige análise de:

- migração;
- dados existentes;
- compatibilidade;
- cancelamento;
- múltiplas NFs;
- testes.

Não transformar isso em refatoração casual.

---

# 63. Risco — alterar mecanismo de custo sem modelar histórico suficiente

O recalculo atual utiliza o histórico disponível de NFs fechadas válidas.

Uma futura mudança para snapshots ou ledger específico de custo deve ser arquitetada conscientemente.

Não misturar mecanismos parciais.

---

# 64. Risco — reabrir módulo homologado sem evidência

A Entrada de NF-e foi homologada técnica e manualmente.

Não iniciar nova revisão ampla apenas para confirmar regras já corretas.

Nova revisão deve partir de:

- defeito comprovado;
- requisito novo;
- vulnerabilidade;
- integração nova;
- melhoria realmente necessária.

---

# 65. Cuidados em futuras alterações

Antes de modificar esta funcionalidade:

1. consultar [[Mapa Técnico - Compras - Entrada de NF-e]];
2. consultar [[Modelo de Domínio - Compras - Entrada de NF-e]];
3. consultar [[Workflows - Compras - Entrada de NF-e]];
4. consultar [[Homologação - Compras - Entrada de NF-e]];
5. verificar implementação atual;
6. identificar exatamente o problema ou requisito;
7. preservar regras não afetadas;
8. executar testes focados;
9. ampliar testes somente quando a alteração realmente atravessar integrações;
10. homologar novamente apenas o escopo impactado, salvo mudança ampla.

---

# 66. Áreas de maior criticidade

As áreas que merecem atenção especial são:

~~~text
MULTIEMPRESA
CANCELAMENTO
ESTOQUE
FINANCEIRO
CUSTOS
MÚLTIPLAS NFs
IDENTIDADE DOCUMENTAL
RECEBIMENTO PARCIAL
ATOMICIDADE
~~~

Uma regressão nessas áreas pode produzir inconsistência operacional ou financeira.

---

# 67. Estado final

~~~text
Entrada de NF-e:
HOMOLOGADA

Pendência crítica conhecida:
NENHUMA

Multiempresa:
PROTEGIDO

Recebimento parcial:
HOMOLOGADO

Múltiplas NFs:
HOMOLOGADO

Estoque:
INTEGRADO

Custos:
INTEGRADOS

Financeiro:
INTEGRADO

Cancelamento:
TRANSACIONAL

Checkbox de item:
HOMOLOGADO

DELETE:
BLOQUEADO
~~~

---

# 68. Regra de preservação

Este documento registra cuidados para uma funcionalidade já aprovada.

Não interpretar os riscos descritos como pendências atuais.

Eles representam pontos que devem ser preservados em futuras alterações.

Uma nova checklist de revisão deve conter somente:

- problema real;
- ausência;
- vulnerabilidade;
- melhoria necessária.

Regras já implementadas e funcionando corretamente não devem ser apresentadas como pendências apenas para serem preservadas.