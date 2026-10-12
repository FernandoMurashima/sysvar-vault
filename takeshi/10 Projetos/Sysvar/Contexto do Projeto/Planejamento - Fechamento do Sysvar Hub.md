---
type: project
status: active
project: Sysvar
source: "FernandoMurashima/sysvarhub-backend + FernandoMurashima/sysvarhub-frontend + FernandoMurashima/sysvarbackend + FernandoMurashima/sysvarfrontend"
created: 2026-10-12
updated: 2026-10-12
tags:
  - sysvar
  - hub
  - planejamento
  - fechamento
  - prompts
  - homologacao
---

# Planejamento — Fechamento do Sysvar Hub

## Objetivo

Organizar o fechamento funcional do Sysvar Hub em tarefas pequenas, objetivas e rastreáveis, evitando prompts grandes para o Codex.

Este documento detalha os itens do Hub registrados em [[Planejamento, Pendências e Homologação]] e deve ser atualizado à medida que cada bloco for implementado, revisado, homologado e aprovado.

## Regras desta etapa

- um prompt deve ter um objetivo principal;
- preferir um único repositório por prompt;
- tempo esperado por prompt: aproximadamente 5 a 15 minutos;
- se o escopo ameaçar ultrapassar cerca de 20 minutos, dividir antes de enviar;
- durante implementação, executar somente testes diretamente relevantes;
- homologação funcional final deve ser feita pela interface sempre que possível;
- não reabrir Devolução ou Vale-Troca sem defeito novo;
- Cashback e Promoções devem ser investigados antes de nova implementação, porque há registros anteriores de implementação/aprovação;
- homologação real da NFC-e com SEFAZ/A1 válido fica fora deste fechamento;
- TEF/Pinpad fica fora deste fechamento e será tratado futuramente.

## Resultado esperado

Ao concluir este plano, o Sysvar Hub poderá ser considerado funcionalmente fechado no escopo atual, restando fora do fechamento apenas:

- homologação externa real da NFC-e/SEFAZ;
- TEF/Pinpad;
- evoluções futuras explicitamente aprovadas.

---

# Visão geral

Quantidade máxima prevista:

**10 prompts**

Quantidade provável:

**8 prompts**, caso Cashback e Promoções já estejam completos e exijam somente homologação.

~~~text
Recebimento de Loja
→ Cashback
→ Promoções
→ Versionamento
→ Compatibilidade
→ Atualização
→ Backup
→ Restauração
→ Homologação final integrada
~~~

A homologação final integrada não é um prompt de implementação. Ela será conduzida como bateria funcional pelo usuário. Erros encontrados nessa etapa geram prompts cirúrgicos separados.

---

# Bloco 1 — Recebimento de Loja

## Prompt 1 — Central: contrato do Recebimento de Loja

Status: PENDENTE

Raciocínio recomendado: **Alto**

Objetivo:

- analisar o fluxo de recebimento já existente na Central;
- reaproveitar o que já existe;
- disponibilizar ao Hub somente o contrato necessário para identificar mercadorias/NF-e destinadas à Loja;
- receber posteriormente o resultado do recebimento realizado no Hub;
- preservar regras atuais de estoque, fiscal e distribuição;
- não criar tela;
- não implementar lógica duplicada no Hub se a Central já for autoridade da informação.

Escopo preferencial:

- Central Backend.

Resultado esperado:

Contrato mínimo e seguro Central ↔ Hub para suportar o recebimento local.

Homologação após o prompt:

- validar contrato e dados disponibilizados;
- não avançar para frontend antes de revisar o commit.

---

## Prompt 2 — Hub Backend: domínio local do Recebimento de Loja

Status: PENDENTE

Raciocínio recomendado: **Alto**

Objetivo:

- implementar/completar a persistência local necessária;
- sincronizar recebimentos disponíveis;
- consultar uma entrega/NF-e;
- registrar conferência;
- efetivar entrada no estoque local;
- gerar evento de sincronização de retorno;
- garantir idempotência;
- preservar funcionamento offline.

Escopo preferencial:

- Hub Backend.

Resultado esperado:

Recebimento funcional no backend local sem depender da interface.

Homologação após o prompt:

- validar endpoints/contratos necessários;
- validar persistência e efeito em estoque;
- validar operação offline no nível técnico necessário.

---

## Prompt 3 — Hub Frontend: tela Recebimento de Loja

Status: PENDENTE

Raciocínio recomendado: **Médio**

Objetivo:

- retirar o quadro independente de Vale-Troca da navegação;
- adicionar o quadro Recebimento de Loja;
- implementar fluxo:
  - listar recebimentos;
  - selecionar;
  - consultar;
  - conferir;
  - Tudo recebido;
  - Zerar;
  - Lançar no estoque;
- usar os dados reais do backend;
- não alterar a lógica interna de Vale-Troca usada por Devolução e Venda.

Escopo preferencial:

- Hub Frontend.

Resultado esperado:

Fluxo completo de Recebimento de Loja pela interface.

Homologação após o prompt:

- executar bateria funcional do recebimento pela interface;
- somente após aprovação marcar P5/P10 como concluídos.

---

# Bloco 2 — Cashback

## Verificação prévia obrigatória

Antes de gerar novo prompt, ChatGPT deve analisar documentação e código atuais.

Há documentação anterior registrando Cashback como implementado/aprovado, enquanto o documento principal mais recente o mantém como pendente.

A investigação deve responder:

- snapshot da configuração existe?
- geração local existe?
- uso offline seguro existe?
- estorno/cancelamento existe?
- sincronização Hub → Central existe?
- idempotência existe?
- qual é exatamente a lacuna atual, se houver?

## Prompt 4 — Cashback: correção da lacuna encontrada

Status: CONDICIONAL

Raciocínio recomendado: **Alto**

Executar somente se a investigação confirmar lacuna real.

Objetivo:

- corrigir exclusivamente o ponto faltante;
- não reimplementar Cashback completo;
- preservar tudo que já estiver homologado;
- manter política segura para saldo offline entre lojas.

Escopo:

- definido após investigação;
- preferir um repositório por prompt;
- se a lacuna atravessar Central e Hub de forma relevante, dividir este prompt em dois.

Se nenhuma lacuna for encontrada:

- não enviar Prompt 4;
- seguir diretamente para homologação do Cashback;
- atualizar documentação após aprovação.

---

# Bloco 3 — Promoções

## Verificação prévia obrigatória

Antes de gerar novo prompt, verificar no código atual:

- sincronização Central → Hub;
- escopos de promoção;
- vigência;
- prioridade;
- preço/desconto aplicado;
- atualização de quantidade;
- snapshot da promoção na Venda;
- expiração;
- comportamento offline;
- integração com Cashback quando `acumula_cashback` for aplicável.

## Prompt 5 — Promoções: correção da lacuna encontrada

Status: CONDICIONAL

Raciocínio recomendado: **Médio**

Executar somente se a investigação apontar algo incompleto ou incorreto.

Objetivo:

- corrigir apenas a lacuna encontrada;
- não reconstruir o motor de Promoções;
- preservar regras existentes e homologadas.

Se nenhuma lacuna for encontrada:

- não enviar Prompt 5;
- homologar Promoções diretamente;
- atualizar documentação após aprovação.

---

# Bloco 4 — Atualização e versionamento

## Prompt 6 — Identidade de versão do Hub

Status: PENDENTE

Raciocínio recomendado: **Médio**

Objetivo:

- definir versão do Hub Backend;
- definir versão compatível do Hub Frontend;
- expor versão instalada de forma verificável;
- reaproveitar infraestrutura existente de build/instalação;
- não implementar atualização automática ainda.

Escopo preferencial:

- começar pelo repositório que já concentra instalação/versionamento;
- dividir se backend e frontend exigirem alterações independentes relevantes.

Resultado esperado:

Cada instalação sabe claramente qual versão está executando.

---

## Prompt 7 — Compatibilidade Central ↔ Hub

Status: PENDENTE

Raciocínio recomendado: **Médio**

Objetivo:

- definir regra objetiva de compatibilidade entre Central e Hub;
- impedir operação/atualização incompatível quando necessário;
- fornecer diagnóstico claro;
- evitar bloqueio desnecessário quando versões forem compatíveis;
- não implementar o processo completo de atualização ainda.

Resultado esperado:

Contrato de compatibilidade versionado e verificável.

---

## Prompt 8 — Processo de atualização do Hub

Status: PENDENTE

Raciocínio recomendado: **Alto**

Objetivo:

- implementar atualização de uma instalação existente;
- preservar configuração local;
- preservar banco;
- preservar filas/eventos pendentes;
- preservar documentos/XML locais;
- preservar identidade do Hub;
- atualizar frontend/backend de forma coerente;
- impedir atualização incompatível;
- prever falha/retorno seguro.

Resultado esperado:

Atualização real de uma versão para outra sem reinstalação limpa e sem perda operacional.

Homologação:

- executar atualização real em ambiente controlado;
- validar dados antes/depois;
- validar serviços;
- validar Hub/PDV após atualização.

---

# Bloco 5 — Backup e restauração

## Prompt 9 — Backup do Hub

Status: PENDENTE

Raciocínio recomendado: **Médio**

Objetivo:

- identificar o que precisa ser preservado;
- criar procedimento/rotina de backup;
- incluir banco local;
- incluir configuração necessária;
- preservar filas/eventos;
- preservar documentos/XML quando aplicável;
- não copiar segredos de forma insegura;
- validar integridade mínima do backup.

Resultado esperado:

Backup reproduzível e operacional do Hub instalado.

---

## Prompt 10 — Restauração do Hub

Status: PENDENTE

Raciocínio recomendado: **Alto**

Objetivo:

- restaurar instalação a partir do backup;
- validar compatibilidade do backup;
- recuperar banco/configuração/filas/documentos;
- evitar restauração parcial silenciosa;
- preservar identidade e consistência;
- validar serviços após recuperação.

Resultado esperado:

Procedimento de restauração testável e seguro.

Homologação:

- produzir backup;
- alterar ou isolar ambiente;
- restaurar;
- confirmar dados e funcionamento;
- confirmar sincronização pendente quando houver.

---

# Bloco 6 — Homologação final integrada do Hub

Status: PENDENTE

Esta etapa não começa com prompt de implementação.

A bateria final deve validar pela interface e pelo comportamento real, conforme aplicável:

- ativação;
- Hub vinculado à Loja;
- Terminal pareado;
- Operador;
- Caixa;
- catálogo;
- estoque;
- Fotos de Produto;
- cliente;
- vendedor;
- carrinho;
- venda;
- pagamentos;
- Consulta de Vendas F12;
- Recebimento de Loja;
- Cashback;
- Promoções;
- Devolução como regressão;
- Vale-Troca como regressão;
- sincronização Central → Hub;
- sincronização Hub → Central;
- internet desligada;
- reconexão;
- retry;
- idempotência;
- ausência de duplicidades;
- reinício do Hub quando aplicável;
- atualização/versionamento;
- backup/restauração.

Fora da bateria de fechamento atual:

- homologação real da NFC-e com SEFAZ/A1;
- TEF/Pinpad.

Problemas encontrados:

- cada erro deve gerar investigação;
- depois, se necessário, um prompt pequeno e cirúrgico;
- não criar um prompt geral de “corrigir homologação inteira”.

---

# Ordem de execução

~~~text
PROMPT 1
Central — contrato Recebimento
↓
REVISAR

PROMPT 2
Hub Backend — Recebimento
↓
REVISAR

PROMPT 3
Hub Frontend — Recebimento
↓
HOMOLOGAR RECEBIMENTO

INVESTIGAR CASHBACK
↓
PROMPT 4 somente se necessário
↓
HOMOLOGAR CASHBACK

INVESTIGAR PROMOÇÕES
↓
PROMPT 5 somente se necessário
↓
HOMOLOGAR PROMOÇÕES

PROMPT 6
Versionamento
↓
PROMPT 7
Compatibilidade
↓
PROMPT 8
Atualização
↓
HOMOLOGAR ATUALIZAÇÃO

PROMPT 9
Backup
↓
PROMPT 10
Restauração
↓
HOMOLOGAR RECUPERAÇÃO

HOMOLOGAÇÃO FINAL INTEGRADA DO HUB
↓
APROVAÇÃO
↓
DOCUMENTAÇÃO
↓
HUB FUNCIONALMENTE FECHADO
~~~

---

# Controle de execução

| Item | Status |
|---|---|
| Prompt 1 — Central / contrato Recebimento | PENDENTE |
| Prompt 2 — Hub Backend / Recebimento | PENDENTE |
| Prompt 3 — Hub Frontend / Recebimento | PENDENTE |
| Investigação Cashback | PENDENTE |
| Prompt 4 — Cashback | CONDICIONAL |
| Homologação Cashback | PENDENTE |
| Investigação Promoções | PENDENTE |
| Prompt 5 — Promoções | CONDICIONAL |
| Homologação Promoções | PENDENTE |
| Prompt 6 — Versionamento | PENDENTE |
| Prompt 7 — Compatibilidade | PENDENTE |
| Prompt 8 — Atualização | PENDENTE |
| Prompt 9 — Backup | PENDENTE |
| Prompt 10 — Restauração | PENDENTE |
| Homologação final integrada | PENDENTE |
| Fechamento documental do Hub | PENDENTE |

---

# Critério de fechamento

O Hub será considerado funcionalmente fechado quando:

- Recebimento de Loja estiver implementado e homologado;
- Cashback estiver confirmado/homologado;
- Promoções estiverem confirmadas/homologadas;
- versionamento e compatibilidade estiverem definidos;
- atualização estiver implementada e homologada;
- backup estiver implementado;
- restauração estiver testada;
- homologação final integrada for aprovada;
- documentação final estiver atualizada.

Pendências explicitamente externas ao fechamento:

- homologação real NFC-e/SEFAZ;
- TEF/Pinpad.
