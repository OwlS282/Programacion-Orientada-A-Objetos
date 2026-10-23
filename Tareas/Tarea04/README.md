# Tarea Corta 4 - Tienda WallRose

## Descripción
Esta tarea consiste en la implementación de un sistema de gestión para la tienda WallRose utilizando Programación Orientada a Objetos en Java. El sistema permite:
- Registrar y administrar clientes
- Registrar y administrar productos con su inventario y precio
- Crear órdenes de compra para un cliente, con varias líneas de producto
- Calcular el monto, el impuesto (13%) y el monto total de cada orden
- Controlar el estado de cada orden (iniciada, pendiente o terminada)
- Guardar y cargar todos los datos en disco mediante serialización

## Requisitos del problema

### Cliente
- **Id**: Identificador de texto único (por ejemplo, la cédula)
- **Nombre**: Nombre del cliente
- **Email**: Correo electrónico (debe tener un formato válido)
- **Órdenes**: Mapa de las órdenes del cliente, indexado por número de orden

### Producto
- **Código**: Identificador numérico único, asignado de forma consecutiva
- **Nombre**: Nombre del producto
- **Existencias**: Cantidad disponible
- **Unidad**: Unidad de medida (unidad, metro, carrete, etc.)
- **Precio**: Precio por unidad

### Orden
- **Número**: Identificador numérico único, asignado de forma consecutiva
- **Fecha**: Fecha de creación de la orden (la del día en que se crea)
- **Estado**: INICIADA, PENDIENTE o TERMINADA
- **Cliente**: Cliente al que pertenece la orden
- **Líneas**: Lista ordenada de líneas de la orden (se numeran desde 1)

### LineaOrden
- **Producto**: Producto solicitado
- **Cantidad**: Cantidad solicitada del producto
- **Costo**: Se calcula como cantidad por precio del producto

### EstadoOrden (enumeración)
- **INICIADA**: La orden se acaba de crear y todavía se puede modificar
- **PENDIENTE**: La orden está lista y a la espera de ser terminada
- **TERMINADA**: La orden ya fue completada

### ControladoraWallRose
- Clase única (Singleton) que administra los clientes, productos y órdenes
- Valida los datos y aplica las reglas del negocio
- Guarda y carga los datos en el archivo `DatosWallRose.dat`

## Reglas del negocio
- No se puede crear un cliente con un id que ya existe.
- El email de un cliente debe tener un formato válido (por ejemplo, `ana@correo.com`).
- El nombre y la unidad de un producto son obligatorios, y las existencias y el precio no pueden ser negativos.
- La cantidad de una línea de orden debe ser mayor que cero.
- Solo se pueden agregar, modificar o borrar líneas de una orden en estado INICIADA.
- Una orden solo puede pasar a PENDIENTE si está INICIADA y tiene al menos una línea.
- Una orden solo puede pasar a TERMINADA si está PENDIENTE.
- No se puede borrar una orden TERMINADA.
- No se puede borrar un cliente que tenga órdenes asociadas.
- No se puede borrar un producto que esté siendo utilizado en alguna orden.
- El impuesto es del 13% sobre el monto de la orden.

## Conceptos POO implementados

- **Encapsulamiento**: Atributos privados, getters y setters
- **Asociaciones**: Relaciones 1 a muchos entre Cliente, Orden, LineaOrden y Producto
- **Composición**: Una Orden contiene sus LineaOrden
- **Enumeración**: EstadoOrden define los estados posibles de una orden
- **Patrón Singleton**: ControladoraWallRose tiene una única instancia
- **Persistencia**: Serialización de objetos (`Serializable`) para guardar y cargar los datos
- **Validación**: Verificaciones con excepciones en la controladora
- **Colecciones**: `TreeMap` para clientes, productos y órdenes; `HashMap` para las órdenes de cada cliente; `ArrayList` para las líneas

## Requisitos técnicos
- Java 11 o superior (se usa `String.isBlank()`)
- IDE: Eclipse, IntelliJ IDEA o Visual Studio Code

## Estructura del proyecto

```
WallRose/
└── src/
    ├── control/
    │   ├── WallRose.java               - Clase principal (programa de demostración)
    │   └── ControladoraWallRose.java   - Controladora Singleton
    └── logica/
        ├── Cliente.java
        ├── Producto.java
        ├── Orden.java
        ├── LineaOrden.java
        └── EstadoOrden.java            - Enumeración
```

Al guardar los datos se crea el archivo `DatosWallRose.dat` en la carpeta raíz del proyecto.

## Compilación y ejecución

### En Eclipse:
1. Importar o crear el proyecto con las carpetas `control` y `logica` dentro de `src`.
2. Clic derecho sobre `WallRose.java` → **Run As → Java Application**.
3. El resultado se muestra en la pestaña **Console**.

### Por terminal:
```bash
javac -d bin src/logica/*.java src/control/*.java
java -cp bin control.WallRose
```

## Programa de demostración

La clase `WallRose` crea tres clientes y tres productos de ejemplo, crea una orden con tres líneas y la pasa a pendiente. Después guarda los datos en disco, los vuelve a cargar y los imprime para comprobar que la persistencia funciona.

Salida esperada (el formato de los decimales puede variar según la configuración regional, y la fecha es la del día de ejecución):

```
Datos guardados en disco.
Datos cargados de disco.

Agregamos Clientes: 
1 | Ana Mora | ana@correo.com | pendiente: 40341.00
2 | Luis Rojas | luis@correo.com | pendiente: 0.00
3 | Sofía Vargas | sofia@correo.com | pendiente: 0.00

Agregamos Productos: 
1 | Camiseta | 50.00 unidad | 8500.00
2 | Tela de algodón | 120.50 metro | 3200.00
3 | Hilo | 300.00 carrete | 750.00

Agregamos a la orden: 
Orden 1 | 2026-10-22 | PENDIENTE | cliente 1 - Ana Mora
  1. 1 | Camiseta | 2.00 unidad | costo 17000.00
  2. 2 | Tela de algodón | 3.50 metro | costo 11200.00
  3. 3 | Hilo | 10.00 carrete | costo 7500.00
  Monto: 35700.00 | Impuesto: 4641.00 | Total: 40341.00

Monto total pendiente: 40341.00
```

---

# DIAGRAMA CONCEPTUAL

## Representación ASCII

```
┌─────────────────────────────────┐
│ CLIENTE                         │
├─────────────────────────────────┤
│ - id: String                    │
│ - nombre: String                │
│ - email: String                 │
└──────────────┬──────────────────┘
               │
               │ 0..*
               │ ordenes
               │
               ▼
┌─────────────────────────────────┐
│ ORDEN                           │
├─────────────────────────────────┤
│ - numero: Integer               │
│ - fecha: LocalDate              │
│ - estado: EstadoOrden           │
└──────────────┬──────────────────┘
               │
               │ 0..*
               │ lineas
               │
               ▼
┌─────────────────────────────────┐
│ LINEAORDEN                      │
├─────────────────────────────────┤
│ - cantidad: double              │
└──────────────┬──────────────────┘
               │
               │ 1
               │ producto
               │
               ▼
┌─────────────────────────────────┐
│ PRODUCTO                        │
├─────────────────────────────────┤
│ - codigo: Integer               │
│ - nombre: String                │
│ - existencias: Double           │
│ - unidad: String                │
│ - precio: Double                │
└─────────────────────────────────┘
```

## Diagrama de asociaciones

```
Cliente (1) ──── ordenes (0..*) ──── Orden
   ▲                                   │
   └──── cliente (1) ──────────────────┘
        Navegabilidad bidireccional

Orden (1) ──── lineas (0..*) ──── LineaOrden

LineaOrden (0..*) ──── producto (1) ──── Producto

Orden ──── estado (1) ──── <<Enumeration>> EstadoOrden

ControladoraWallRose (1) ──── clientes (0..*) ──── Cliente
ControladoraWallRose (1) ──── ordenes (0..*) ──── Orden
ControladoraWallRose (1) ──── productos (0..*) ──── Producto
ControladoraWallRose (1) ──── instance (1) ──── ControladoraWallRose
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
║ - email: String                                        ║
║ - ordenes: Map<Integer, Orden>                         ║
╠════════════════════════════════════════════════════════╣
║ Constructores:                                         ║
║ + Cliente(id: String, nombre: String, email: String)   ║
╠════════════════════════════════════════════════════════╣
║ Métodos:                                               ║
║ + agregarOrden(orden: Orden): void                     ║
║ + borrarOrden(orden: Orden): void                      ║
║ + getOrdenes(): Map<Integer, Orden>                    ║
║                                                        ║
║ + getId(): String                                      ║
║ + setId(id: String): void                              ║
║ + getNombre(): String                                  ║
║ + setNombre(nombre: String): void                      ║
║ + getEmail(): String                                   ║
║ + setEmail(email: String): void                        ║
╚════════════════════════════════════════════════════════╝

╔════════════════════════════════════════════════════════╗
║ PRODUCTO                                               ║
╠════════════════════════════════════════════════════════╣
║ Atributos:                                             ║
║ - codigo: Integer                                      ║
║ - nombre: String                                       ║
║ - existencias: Double                                  ║
║ - unidad: String                                       ║
║ - precio: Double                                       ║
╠════════════════════════════════════════════════════════╣
║ Constructores:                                         ║
║ + Producto(codigo: Integer, nombre: String,            ║
║ existencias: Double, unidad: String, precio: Double)   ║
╠════════════════════════════════════════════════════════╣
║ Métodos:                                               ║
║ + getCodigo(): Integer                                 ║
║ + setCodigo(codigo: Integer): void                     ║
║ + getNombre(): String                                  ║
║ + setNombre(nombre: String): void                      ║
║ + getExistencias(): Double                             ║
║ + setExistencias(existencias: Double): void            ║
║ + getUnidad(): String                                  ║
║ + setUnidad(unidad: String): void                      ║
║ + getPrecio(): Double                                  ║
║ + setPrecio(precio: Double): void                      ║
╚════════════════════════════════════════════════════════╝

╔════════════════════════════════════════════════════════╗
║ ORDEN                                                  ║
╠════════════════════════════════════════════════════════╣
║ Atributos:                                             ║
║ - numero: Integer                                      ║
║ - fecha: LocalDate                                     ║
║ - estado: EstadoOrden                                  ║
║ - cliente: Cliente                                     ║
║ - lineas: List<LineaOrden>                             ║
║ - IMPUESTO: double (constante, 0.13)                   ║
╠════════════════════════════════════════════════════════╣
║ Constructores:                                         ║
║ + Orden(numero: Integer, cliente: Cliente)             ║
╠════════════════════════════════════════════════════════╣
║ Métodos:                                               ║
║ + calcularMonto(): double                              ║
║ + calcularMontoImpuesto(): double                      ║
║ + calcularMontoTotal(): double                         ║
║ + agregarLinea(linea: LineaOrden): void                ║
║ + borrarLinea(numeroLinea: Integer): void              ║
║ + cantidadLineas(): Integer                            ║
║ + getLinea(numeroLinea: Integer): LineaOrden           ║
║ - validarNumeroLinea(numeroLinea: Integer): void       ║
║                                                        ║
║ + getNumero(): Integer                                 ║
║ + setNumero(numero: Integer): void                     ║
║ + getFecha(): LocalDate                                ║
║ + setFecha(fecha: LocalDate): void                     ║
║ + getEstado(): EstadoOrden                             ║
║ + setEstado(estado: EstadoOrden): void                 ║
║ + getCliente(): Cliente                                ║
║ + setCliente(cliente: Cliente): void                   ║
║ + getLineas(): List<LineaOrden>                        ║
║ + setLineas(lineas: List<LineaOrden>): void            ║
╚════════════════════════════════════════════════════════╝

╔════════════════════════════════════════════════════════╗
║ LINEAORDEN                                             ║
╠════════════════════════════════════════════════════════╣
║ Atributos:                                             ║
║ - producto: Producto                                   ║
║ - cantidad: double                                     ║
╠════════════════════════════════════════════════════════╣
║ Constructores:                                         ║
║ + LineaOrden(producto: Producto, cantidad: Double)     ║
╠════════════════════════════════════════════════════════╣
║ Métodos:                                               ║
║ + calcularCosto(): double                              ║
║ + getProducto(): Producto                              ║
║ + setProducto(producto: Producto): void                ║
║ + getCantidad(): double                                ║
║ + setCantidad(cantidad: double): void                  ║
╚════════════════════════════════════════════════════════╝

╔════════════════════════════════════════════════════════╗
║ <<Enumeration>> ESTADOORDEN                            ║
╠════════════════════════════════════════════════════════╣
║ INICIADA                                               ║
║ PENDIENTE                                              ║
║ TERMINADA                                              ║
╚════════════════════════════════════════════════════════╝

╔════════════════════════════════════════════════════════╗
║ <<Singleton>> CONTROLADORAWALLROSE                     ║
╠════════════════════════════════════════════════════════╣
║ Atributos:                                             ║
║ - instance: ControladoraWallRose (estático)            ║
║ - clientes: Map<String, Cliente>                       ║
║ - ordenes: Map<Integer, Orden>                         ║
║ - productos: Map<Integer, Producto>                    ║
║ - consecutivoOrden: Integer                            ║
║ - consecutivoProducto: Integer                         ║
║ - IV: Double                                           ║
╠════════════════════════════════════════════════════════╣
║ Constructores:                                         ║
║ - ControladoraWallRose()                               ║
╠════════════════════════════════════════════════════════╣
║ Métodos generales:                                     ║
║ + getInstance(): ControladoraWallRose                  ║
║ + guardarDatos(): void (estático)                      ║
║ + cargarDatos(): void (estático)                       ║
║                                                        ║
║ Verificaciones (privados):                             ║
║ - verificarClienteExistente(idCliente: String)         ║
║ - verificarClienteNoExistente(idCliente: String)       ║
║ - esEmailValido(email: String): boolean                ║
║ - verificarEmail(email: String)                        ║
║ - verificarProductoExistente(codigoProducto: Integer)  ║
║ - verificarOrdenExistente(numeroOrden: Integer)        ║
║ - verificarOrdenIniciada(orden: Orden)                 ║
║ - verificarCantidad(cantidad: Double)                  ║
║ - verificarDatosProducto(nombre: String,               ║
║ existencias: Double, unidad: String, precio: Double)   ║
║                                                        ║
║ Clientes:                                              ║
║ + obtenerListadoClientes(): List<Cliente>              ║
║ + obtenerCliente(idCliente: String): Cliente           ║
║ + crearCliente(idCliente: String, nombre: String,      ║
║ email: String): void                                   ║
║ + actualizarCliente(idCliente: String, nombre: String, ║
║ email: String): void                                   ║
║ + borrarCliente(idCliente: String): void               ║
║ + obtenerListadoOrdenesCliente(idCliente: String):     ║
║ List<Orden>                                            ║
║ - obtenerListadoOrdenesPorEstado(idCliente: String,    ║
║ estado: EstadoOrden): List<Orden>                      ║
║ + obtenerListadoOrdenesIniciadasCliente(idCliente)     ║
║ + obtenerListadoOrdenesPendientesCliente(idCliente)    ║
║ + obtenerListadoOrdenesTerminadasCliente(idCliente)    ║
║                                                        ║
║ Productos:                                             ║
║ + obtenerListadoProductos(): List<Producto>            ║
║ + crearProducto(nombre: String, existencias: Double,   ║
║ unidad: String, precio: Double): void                  ║
║ + obtenerProducto(codigoProducto: Integer): Producto   ║
║ + actualizarProducto(codigoProducto: Integer,          ║
║ nombre: String, existencias: Double, unidad: String,   ║
║ precio: Double): void                                  ║
║ + borrarProducto(codigoProducto: Integer): void        ║
║ + esProductoUtilizado(codigoProducto: Integer): Boolean║
║                                                        ║
║ Órdenes:                                               ║
║ + obtenerListadoOrdenes(): List<Orden>                 ║
║ + obtenerMontoTotalPendiente(): Double                 ║
║ + crearOrdenVacia(idCliente: String): Integer          ║
║ + obtenerOrden(numeroOrden: Integer): Orden            ║
║ + obtenerLineasOrden(numeroOrden: Integer):            ║
║ List<LineaOrden>                                       ║
║ + establecerOrdenPendiente(numeroOrden: Integer): void ║
║ + establecerOrdenTerminada(numeroOrden: Integer): void ║
║ + agregarLineaOrden(numeroOrden: Integer,              ║
║ codigoProducto: Integer, cantidad: Double): void       ║
║ + actualizarLineaOrden(numeroOrden: Integer,           ║
║ numeroLinea: Integer, codigoProducto: Integer,         ║
║ cantidad: Double): void                                ║
║ + borrarLineaOrden(numeroOrden: Integer,               ║
║ numeroLinea: Integer): void                            ║
║ + borrarOrden(numeroOrden: Integer): void              ║
╚════════════════════════════════════════════════════════╝
```

## Asociaciones y multiplicidades

```
Cliente ────────────────────── Orden
1                              0..*
│ cliente                      │ ordenes
└──────────────────────────────┘
(Navegabilidad bidireccional)

Orden ────────────────────── LineaOrden
1                            0..*
(Composición: las líneas pertenecen a la orden)

LineaOrden ────────────────── Producto
0..*                          1
(Navegabilidad de LineaOrden hacia Producto)

Orden ────────────────────── EstadoOrden
*                            1

ControladoraWallRose ────────────────── Cliente / Orden / Producto
1                                       0..*
(Mapas: clientes, ordenes, productos)
```

---

## Características implementadas

### Encapsulamiento
- Todos los atributos son privados
- Getters para lectura y setters para modificación
- La constante del impuesto (`IMPUESTO`) es privada y estática

### Composición
- Una Orden contiene sus LineaOrden
- Una Orden y su Cliente se referencian entre sí
- La controladora administra todas las entidades mediante mapas

### Colecciones
- `TreeMap` para clientes, productos y órdenes (los listados salen ordenados por llave)
- `HashMap` para las órdenes de cada cliente
- `ArrayList` para las líneas de cada orden y para los listados que devuelve la controladora

### Validación
- Verificación de existencia de clientes, productos y órdenes
- Validación del formato del email
- Validación de datos del producto y de la cantidad de cada línea
- Validación de las transiciones de estado de una orden
- Excepciones (`IllegalArgumentException` e `IllegalStateException`) con mensajes claros

### Persistencia
- Todas las clases implementan `Serializable`
- `guardarDatos()` escribe la controladora completa en `DatosWallRose.dat`
- `cargarDatos()` restaura la controladora, incluyendo clientes, productos, órdenes y sus relaciones

### Programa principal
- Crea clientes y productos de ejemplo
- Crea una orden con varias líneas y la pasa a pendiente
- Guarda y carga los datos de disco
- Imprime clientes, productos, órdenes y el monto total pendiente

## Notas importantes
- El número de orden y el código de producto se asignan de forma consecutiva y automática.
- Las fechas de las órdenes se asignan con `LocalDate.now()` al crearlas.
- El atributo `IV` de la controladora está en el diagrama, pero el cálculo del impuesto lo hace la clase `Orden` con su constante `IMPUESTO` (0.13).
- Las existencias de un producto no se descuentan al terminar una orden.
- Se siguieron las convenciones de nomenclatura de Java.

## Autor
Owel Jafet Gutiérrez Ortiz

## Carnet
2026800869

## Profesor
Mauricio Avilés Cisneros

## Fecha de entrega
22/10/2026

## Institución
Instituto Tecnológico de Costa Rica
Escuela de Computación
Bachillerato en Ingeniería en Computación
