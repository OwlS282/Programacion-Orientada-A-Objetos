# Tarea Corta 2 - Sistema de Tiquetes

## Descripción
Esta tarea consiste en la implementación de un sistema de tiquetes de atención utilizando Programación Orientada a Objetos y el manejo de colecciones en Java. El sistema permite:
- Registrar clientes en un diccionario, validando su ID
- Generar tiquetes de atención para clientes existentes
- Mantener una cola de tiquetes pendientes (el primero en llegar es el primero en atenderse)
- Atender el siguiente tiquete y guardarlo en un historial
- Descartar el siguiente tiquete sin guardarlo en el historial
- Limpiar el historial de tiquetes atendidos
- Interactuar con el usuario mediante un menú en consola

## Requisitos del problema

### Cliente
- **Id**: Identificador de texto único; solo puede contener números y guiones (por ejemplo, `1-1111-1111`)
- **Nombre**: Nombre del cliente

### Tiquete
- **Código**: Número consecutivo asignado automáticamente (el primero es el 100)
- **IdCliente**: Id del cliente que generó el tiquete

### SistemaTiquetes
- Clase que administra las tres colecciones del sistema
- **clientes**: Diccionario (`Map`) de clientes, indexado por su id
- **colaTiquetes**: Cola (`Queue`) de tiquetes pendientes de atención
- **historialTiquetes**: Lista (`List`) de tiquetes ya atendidos
- Contiene los métodos para agregar, atender, descartar y limpiar

### Principal
- Clase de interfaz de consola
- Muestra el estado del sistema y el menú, lee la opción del usuario y llama a los métodos de `SistemaTiquetes`
- Maneja los errores con `try/catch` para que el programa no se cierre inesperadamente

## Reglas del negocio
- El id de un cliente solo puede contener números y guiones, y no puede estar vacío.
- No se puede agregar un cliente con un id que ya existe.
- El nombre de un cliente no puede estar vacío.
- Solo se puede crear un tiquete para un cliente que ya esté registrado.
- Los tiquetes se atienden en el orden en que fueron creados (FIFO).
- Al atender un tiquete, este sale de la cola y se agrega al historial.
- Al descartar un tiquete, este sale de la cola y **no** se agrega al historial.
- No se puede atender ni descartar un tiquete si la cola está vacía.
- Limpiar el historial elimina todos los tiquetes atendidos, pero no afecta la cola ni los clientes.

## Conceptos POO implementados

- **Encapsulamiento**: Atributos privados, getters y setters
- **Asociaciones**: `SistemaTiquetes` contiene clientes y tiquetes; cada `Tiquete` se relaciona con un cliente mediante su id
- **Atributo estático**: `Tiquete.consecutivo` genera el código de cada tiquete
- **Validación**: Verificaciones con expresiones regulares y excepciones
- **Manejo de excepciones**: Uso de `throw`, `throws` y `try/catch`
- **Colecciones**: `HashMap` para clientes, `LinkedList` como `Queue` para la cola y `LinkedList` como `List` para el historial
- **Separación en capas**: Paquete `logica` (reglas del sistema) y paquete `interfaz` (consola)

## Requisitos técnicos
- Java 8 o superior
- IDE: Eclipse, IntelliJ IDEA o Visual Studio Code

## Estructura del proyecto

```
TiquetesTarea/
└── src/
    ├── interfaz/
    │   └── Principal.java          - Clase principal (menú de consola)
    └── logica/
        ├── Cliente.java
        ├── Tiquete.java
        └── SistemaTiquetes.java    - Administra las colecciones
```

## Compilación y ejecución

### En Eclipse:
1. Importar o crear el proyecto con las carpetas `interfaz` y `logica` dentro de `src`.
2. Clic derecho sobre `Principal.java` → **Run As → Java Application**.
3. Interactuar con el menú en la pestaña **Console**.

### Por terminal:
```bash
javac -d bin src/logica/*.java src/interfaz/*.java
java -cp bin interfaz.Principal
```

## Menú del programa

```
MENÚ PRINCIPAL
1. Agregar cliente
2. Agregar tiquete a la cola
3. Atender siguiente tiquete
4. Descartar siguiente tiquete
5. Limpiar historial
6. Salir
```

Antes de mostrar el menú, el programa imprime siempre el estado actual de los clientes, la cola de atención y el historial.

## Ejemplo de ejecución

Salida esperada al iniciar el programa (el orden de los clientes puede variar, ya que se almacenan en un `HashMap`):

```
Clientes registrados:
{}
Cola de atención:
[]
Historial de tiquetes:
[]

MENÚ PRINCIPAL
1. Agregar cliente
...
Seleccione una opción: 1
Ingrese el ID del cliente: 1-1111-1111
Ingrese el nombre del cliente: Ana Mora
Cliente agregado.
```

Después de agregar dos tiquetes para Ana y atender el primero (opción 3):

```
Atendiendo: Tiquete(100, 1-1111-1111)
Tiquete agregado al historial.

Clientes registrados:
{1-1111-1111=Cliente(1-1111-1111, Ana Mora)}
Cola de atención:
[Tiquete(101, 1-1111-1111)]
Historial de tiquetes:
[Tiquete(100, 1-1111-1111)]
```

Ejemplos de errores controlados:

```
Error: Error, ID debe contener solo números y guiones.
Error: Error, cliente no encontrado.
Error: Error, la cola de tiquetes está vacía.
Error: Error, debe ingresar un número válido.
```

---

# DIAGRAMA CONCEPTUAL

## Representación ASCII

```
┌─────────────────────────────────┐
│ SISTEMATIQUETES                 │
└───────┬───────────────┬─────────┘
        │               │
        │ 0..*          │ 0..*
        │ clientes      │ colaTiquetes / historialTiquetes
        ▼               ▼
┌───────────────────┐ ┌───────────────────┐
│ CLIENTE           │ │ TIQUETE           │
├───────────────────┤ ├───────────────────┤
│ - id: String      │ │ - codigo: int     │
│ - nombre: String  │ │ - idCliente:String│
└───────────────────┘ └───────────────────┘
```

## Diagrama de asociaciones

```
SistemaTiquetes (1) ──── clientes (0..*) ──── Cliente
SistemaTiquetes (1) ──── colaTiquetes (0..*) ──── Tiquete
SistemaTiquetes (1) ──── historialTiquetes (0..*) ──── Tiquete

Tiquete (0..*) ──── idCliente ──── Cliente (1)
        Asociación por id (no hay referencia directa al objeto)

Principal (1) ──── sistema (1) ──── SistemaTiquetes
```

---

# DIAGRAMA DE CLASES COMPLETO

```
╔════════════════════════════════════════════════════════╗
║ CLIENTE                                                ║
╠════════════════════════════════════════════════════════╣
║ Atributos:                                             ║
║ - id: String                                           ║
║ - nombre: String                                       ║
╠════════════════════════════════════════════════════════╣
║ Constructores:                                         ║
║ + Cliente(id: String, nombre: String)                  ║
╠════════════════════════════════════════════════════════╣
║ Métodos:                                               ║
║ + getId(): String                                      ║
║ + setId(id: String): void                              ║
║ + getNombre(): String                                  ║
║ + setNombre(nombre: String): void                      ║
║ - esIdValido(id: String): boolean                      ║
║ + toString(): String                                   ║
╚════════════════════════════════════════════════════════╝

╔════════════════════════════════════════════════════════╗
║ TIQUETE                                                ║
╠════════════════════════════════════════════════════════╣
║ Atributos:                                             ║
║ - codigo: int                                          ║
║ - idCliente: String                                    ║
║ - consecutivo: int (estático, inicia en 100)           ║
╠════════════════════════════════════════════════════════╣
║ Constructores:                                         ║
║ + Tiquete(idCliente: String)                           ║
╠════════════════════════════════════════════════════════╣
║ Métodos:                                               ║
║ + getCodigo(): int                                     ║
║ + setCodigo(codigo: int): void                         ║
║ + getIdCliente(): String                               ║
║ + setIdCliente(idCliente: String): void                ║
║ - esIdValido(id: String): boolean                      ║
║ + toString(): String                                   ║
╚════════════════════════════════════════════════════════╝

╔════════════════════════════════════════════════════════╗
║ SISTEMATIQUETES                                        ║
╠════════════════════════════════════════════════════════╣
║ Atributos:                                             ║
║ - clientes: Map<String, Cliente>                       ║
║ - colaTiquetes: Queue<Tiquete>                         ║
║ - historialTiquetes: List<Tiquete>                     ║
╠════════════════════════════════════════════════════════╣
║ Constructores:                                         ║
║ + SistemaTiquetes()                                    ║
╠════════════════════════════════════════════════════════╣
║ Métodos:                                               ║
║ + agregarCliente(id: String, nombre: String): void     ║
║ + agregarTiquete(idCliente: String): void             ║
║ + atenderTiquete(): Tiquete                            ║
║ + descartarTiquete(): Tiquete                          ║
║ + limpiarHistorial(): void                             ║
║                                                        ║
║ + getClientes(): Map<String, Cliente>                  ║
║ + getColaTiquetes(): Queue<Tiquete>                    ║
║ + getHistorialTiquetes(): List<Tiquete>                ║
║ + mostrarClientes(): String                            ║
║ + mostrarColaTiquetes(): String                        ║
║ + mostrarHistorial(): String                           ║
║ + toString(): String                                   ║
╚════════════════════════════════════════════════════════╝

╔════════════════════════════════════════════════════════╗
║ PRINCIPAL                                              ║
╠════════════════════════════════════════════════════════╣
║ Atributos:                                             ║
║ - sistema: SistemaTiquetes                             ║
║ - scanner: Scanner                                     ║
╠════════════════════════════════════════════════════════╣
║ Constructores:                                         ║
║ + Principal()                                          ║
╠════════════════════════════════════════════════════════╣
║ Métodos:                                               ║
║ + iniciar(): void                                      ║
║ - mostrarEstado(): void                                ║
║ - mostrarMenu(): void                                  ║
║ - obtenerOpcion(): int                                 ║
║ - agregarCliente(): void                               ║
║ - agregarTiquete(): void                               ║
║ - atenderTiquete(): void                               ║
║ - descartarTiquete(): void                             ║
║ - limpiarHistorial(): void                             ║
║ + main(args: String[]): void (estático)                ║
╚════════════════════════════════════════════════════════╝
```

## Asociaciones y multiplicidades

```
SistemaTiquetes ────────────────────── Cliente
1                                      0..*
(Mapa: clientes, llave = id del cliente)

SistemaTiquetes ────────────────────── Tiquete
1                                      0..*
(Cola: colaTiquetes, FIFO)

SistemaTiquetes ────────────────────── Tiquete
1                                      0..*
(Lista: historialTiquetes)

Tiquete ────────────────────────────── Cliente
0..*                                   1
(Asociación por idCliente)

Principal ──────────────────────────── SistemaTiquetes
1                                      1
```

---

## Características implementadas

### Encapsulamiento
- Todos los atributos son privados
- Getters para lectura y setters para modificación
- Los métodos de validación (`esIdValido`) son privados

### Colecciones
- `Map` con implementación `HashMap` para buscar clientes rápidamente por su id
- `Queue` con implementación `LinkedList` para respetar el orden de llegada (`add` y `poll`)
- `List` con implementación `LinkedList` para guardar el historial de tiquetes atendidos

### Validación
- El id del cliente y el del tiquete se validan con la expresión regular `^[0-9-]+$`
- Verificación de clientes duplicados y de clientes inexistentes
- Verificación de cola vacía al atender o descartar
- Verificación de nombre vacío y de opción numérica en el menú
- Excepciones con mensajes claros, capturadas en `Principal`

### Programa principal
- Muestra el estado completo del sistema antes de cada menú
- Cicla el menú hasta que el usuario elige la opción 6
- Captura cualquier error sin cerrar el programa

## Notas importantes
- El código de los tiquetes es consecutivo y se asigna automáticamente a partir de 100; el contador es estático y no se reinicia mientras el programa esté en ejecución.
- Los datos no se guardan en disco: al cerrar el programa se pierden los clientes, la cola y el historial.
- El orden en que se muestran los clientes depende del `HashMap`, por lo que puede no coincidir con el orden en que se agregaron.
- Descartar un tiquete lo elimina de la cola sin dejar registro en el historial.
- Se siguieron las convenciones de nomenclatura de Java.

## Autor
Owel Jafet Gutiérrez Ortiz

## Carnet
2026800869

## Profesor
Mauricio Avilés Cisneros

## Curso
Programación Orientada a Objetos

## Fecha de entrega
08/09/2026

## Institución
Instituto Tecnológico de Costa Rica
Escuela de Computación
Bachillerato en Ingeniería en Computación
