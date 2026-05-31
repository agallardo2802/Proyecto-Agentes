---
name: gherkin-espanol
description: >
  Reglas para escribir Criterios de Aceptación usando Gherkin en español.
  Formato: Escenario, Dado, Cuando, Entonces.
license: Apache-2.0
metadata:
  author: Alejandro Gallardo
  version: "1.0"
  type: rule
---

## Gherkin en Español

Para escribir Criterios de Aceptación claros y ejecutables, usá este formato:

### Estructura

```gherkin
Escenario: [Título descriptivo]

Dado [contexto inicial]
Cuando [acción o evento]
Entonces [resultado esperado]
```

### Ejemplo

```gherkin
Escenario: Usuario inicia sesión con Google

Dado que el usuario tiene cuenta de Google registrada
Cuando hace clic en "Iniciar sesión con Google"
Entonces se redirige al dashboard sin pedir contraseña
```

### Palabras clave RFC 2119 en Español

| Inglés | Español | Significado |
|--------|---------|------------|
| MUST | DEBE | Obligatorio |
| MUST NOT | NO DEBE | Prohibido |
| SHOULD | DEBERIA | Recomendado |
| MAY | PUEDE | Opcional |

### Reglas de escritura

- Dado: estado, no acción. "el usuario está autenticado", no "el usuario inicia sesión"
- Cuando: una sola acción por escenario
- Entonces: resultado observable desde afuera del sistema
- No usar "debería" ni "podría". Usar "muestra", "registra", "redirige", "bloquea"

### Múltiples condiciones

```gherkin
Escenario: Carrito con descuento aplica solo si hay mínimo

Dado que el carrito tiene productos por $500
Cuando se aplica el código de descuento "DESCUENTO20"
Entonces el total muestra 20% de descuento
```

---

**Nota**: Esta regla centraliza el formato Gherkin. Los demás agentes deben referenciarla, no duplicarla.
