# Standards GGS

Este directorio contiene estándares de empresa que las skills pueden referenciar sin cargar documentación larga en runtime.

## Regla de uso

- Si el estándar debe guiar a la IA en cada ejecución, resumilo en una skill.
- Si el estándar es largo, conceptual o de consulta humana, dejalo acá y enlazalo desde la skill.
- No dupliques contenido entre `standards/` y `skills/`: la skill contiene reglas compactas; el standard contiene explicación y contexto.

## Catálogo inicial

| Archivo futuro | Uso previsto |
|---|---|
| `arquitectura-2026.md` | Decisiones tecnológicas de referencia para portales internos |
| `seguridad-web.md` | Criterios de seguridad aplicables a UI/API/auth |
| `naming.md` | Convenciones de nombres para código, rutas, módulos y docs |
| `testing.md` | Estrategia de pruebas por tipo de cambio |
| `azure-devops.md` | Reglas de boards, PRs, branches y trazabilidad |

## Estado

Agentes v2 arranca con este índice para separar estándares largos de skills runtime. Los archivos se completan durante la migración de `reglas/` y `guilds/`.
