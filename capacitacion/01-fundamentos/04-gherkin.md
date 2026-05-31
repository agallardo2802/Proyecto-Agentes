# 04 - Gherkin

## Objetivos del Capitulo

Al finalizar este capitulo entendras:
- Que es Gherkin y para que sirve
- La estructura de un escenario en Gherkin
- Como escribir criterios de aceptacion en espanol

---

## Que es Gherkin

Gherkin es el lenguaje de especificacion por comportamiento (BDD). Permite escribir especificaciones que son ejecutables como tests y legible por cualquier persona del equipo.

Esta basado en palabras clave simples y legibles en espanol (Dado, Cuando, Entonces).

---

## Estructura Basica

```gherkin
Funcionalidad: Titulo de la funcionalidad

  Antecedentes:  # Optional — preconditions compartidas
    Dado que el usuario esta autenticado
    Y existe un producto en el carrito

  Escenario: Un escenario descriptivo
    Dado que el usuario tiene items en el carrito
    Cuando hace clic en "Finalizar compra"
    Entonces se muestra el resumen del pedido
    Y se habilita el boton de pago
```

---

## Palabras Clave

| ES | EN | Uso |
|----|----|-----|
| **Funcionalidad** | Feature | Titulo de la capacidad |
| **Antecedentes** | Background | Precondiciones compartidas por varios escenarios |
| **Escenario** | Scenario | Caso de uso especifico |
| **Dado/a/os/as** | Given | Contexto inicial |
| **Cuando** | When | Accion del usuario o evento |
| **Entonces** | Then | Resultado esperado |
| **Y** | And | Continua el paso anterior |
| **Pero** | But | Negacion del resultado |
| **Ejemplos** | Examples | Tabla de datos para escenarios |

---

## Ejemplo Completo

```gherkin
Funcionalidad: Login de usuarios

  Escenario: Login exitoso
    Dado un usuario registrado con email "test@ggsoluciones.com"
    Cuando ingreso mis credenciales validas
    Entonces el sistema me redirecciona al dashboard
    Y muestra mi nombre en la barra superior

  Escenario: Login con contrasena incorrecta
    Dado un usuario registrado con email "test@ggsoluciones.com"
    Cuando ingreso una contrasena incorrecta
    Entonces el sistema muestra mensaje de error
    Y permanece en la pagina de login

  Escenario: Login con usuario no registrado
    Dado que no existe un usuario con email "noexiste@ggsoluciones.com"
    Cuando intento iniciar sesion
    Entonces el sistema muestra "Usuario no encontrado"
```

---

## Ejemplos con Tablas

Cuando un escenario tiene multiples valores de entrada, usar tablas:

```gherkin
  Escenario: Descuentos por tipo de cliente
    Dado un producto con precio base de 1000
    Cuando el cliente tiene tipo "<tipo>"
    Entonces el precio final es "<precio>"

    Ejemplos:
      | tipo      | precio |
      | standard  | 1000   |
      | premium   | 900    |
      | vip       | 800    |
```

---

## Reglas para Buenos Escenarios

### Buenos escenarios son:

- **Declarativos**: Describen el QUE, no el COMO
- **Independientes**: No dependen de otros escenarios
- **Consisos**: Un escenario = un comportamiento
- **Legibles**: Entendibles por cualquier persona del equipo

### Evitar:

- Steps demasiado largos o con detalles de implementacion
- Escenarios que prueban multiples cosas
- Lenguaje tecnico en lugar de lenguaje de negocio

### Ejemplo de MALO:

```gherkin
# MALO - demasiado tecnico, mezcla varias cosas
Escenario: Login
  Dado que tengo un objeto User con email "test@test.com" y password "123456"
  Y la base de datos tiene una tabla users con ese registro
  Cuando hago POST a /api/login con JSON {"email": "test@test.com", "password": "123456"}
  Entonces el servidor devuelve 200
  Y el JSON tiene token
  Y guardo el token en localStorage
```

### Ejemplo de BUENO:

```gherkin
# BUENO - declarativo, legible, de negocio
Escenario: Login exitoso con credenciales validas
  Dado un usuario registrado en el sistema
  Cuando ingreso mis credenciales correctas
  Entonces puedo acceder al sistema
  Y mi sesion queda activa
```

---

## Gherkin en los Agentes GGS

En el workflow GGS, los criterios de aceptacion (AC) se escriben en Gherkin en la fase de `sdd-spec`.

El agente `equipo/producto/analista` es el responsable de escribir los AC en Gherkin antes de pasar a implementacion.

---

## Resumen

| Concepto | Punto clave |
|----------|-------------|
| Gherkin | Lenguaje de specs ejecutables |
| Dado/Cuando/Entonces | Estructura basica |
| Funcionalidad | Agrupador de escenarios |
| Escenario | Un caso de uso especifico |
| Tablas | Para multiples valores de entrada |

---

## Siguiente Capitulo

Continuar con: [05-TDD-en-Practica](../02-desarrollo-estandares/01-tdd-practica.md)

## Recursos

- Referencia completa: `reglas/gherkin/AGENT.md`
- Mas ejemplos: `reglas/sdd-tdd/AGENT.md`
