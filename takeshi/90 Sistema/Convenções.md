---
type: system
status: active
project: ""
source: ""
created: 2026-07-29
updated: 2026-07-29
tags:
  - sistema
  - convencoes
---

# Convenções

## Propriedades YAML

Todas as notas novas devem usar:

```yaml
type:
status:
project:
source:
created:
updated:
tags: []
```

## Valores recomendados

- `type`: `project`, `runbook`, `reference`, `decision`, `log`, `system`, `inbox`.
- `status`: `inbox`, `active`, `review`, `archived`.
- `project`: nome do projeto quando aplicável, por exemplo `Webfoto`.
- `source`: URL ou caminho local da fonte original.
- `tags`: poucas tags estáveis, em minúsculas.

## Escrita

- Escrever em português por padrão.
- Preferir notas curtas, linkáveis e reutilizáveis.
- Usar wikilinks para projetos, decisões e referências relacionadas.
- Evitar duplicar segredos, senhas, tokens e chaves em notas derivadas.
- Antes de sobrescrever uma nota existente, ler o conteúdo completo.

## Nomes

- Pastas principais começam com número para manter ordem.
- Notas usam títulos humanos e estáveis.
- Runbooks devem descrever o procedimento, não apenas guardar comandos crus.
