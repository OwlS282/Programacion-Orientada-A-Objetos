# Proyecto 0 - Sistema de Barbería

## Descripción
Este proyecto consiste en la implementación de un sistema de gestión para una barbería utilizando Programación Orientada a Objetos en Java, con una interfaz gráfica hecha en Swing. El sistema permite:
- Registrar y administrar clientes
- Registrar y administrar los tipos de servicio que ofrece la barbería
- Definir el horario de atención de cada día de la semana
- Crear, consultar, modificar, cancelar y confirmar citas
- Consultar el calendario de citas de un rango de fechas
- Enviar por correo electrónico las confirmaciones de las citas del día siguiente
- Administrar una lista de espera de clientes (primero en llegar, primero en salir)
- Guardar y cargar todos los datos en disco mediante serialización

## Requisitos del problema

### Cliente
- **Id**: Identificador de texto único, asignado de forma consecutiva ("1", "2", ...)
- **Nombre**: Nombre del cliente (no puede estar vacío)
- **Teléfono**: Número con formato válido (por ejemplo, `8888-8888`)
- **Email**: Correo electrónico (debe tener un formato válido)

### Servicio
- **Nombre**: Identifica el servicio dentro del sistema (por ejemplo, un corte) y es el que se elige al crear o modificar una cita

### Horario
- **Día**: Día de la semana (`DayOfWeek`)
- **Hora de inicio**: Hora en que empieza la atención
- **Hora de fin**: Hora en que termina la atención (no puede ser anterior a la de inicio)

### Cita
- **Fecha y hora**: Momento de la cita; identifica de forma única a la cita en el sistema
- **Servicio**: Servicio que se va a realizar
- **Cliente**: Cliente que reservó la cita
- **Estado**: NO_CONFIRMADA o CONFIRMADA

### EstadoCita (enumeración)
- **NO_CONFIRMADA**: Estado inicial de toda cita nueva
- **CONFIRMADA**: La cita ya fue confirmada con el cliente

### Barberia
- Clase única (Singleton) que administra los clientes, servicios, citas, horarios y la lista de espera
- Valida los datos y aplica las reglas del negocio
- Envía las notificaciones de confirmación por correo
- Guarda y carga los datos en el archivo `DataBarberia.dat`

### Interfaz gráfica (paquete `GUI`)
- **ControlPanel**: Ventana principal y punto de inicio (`main`), con un menú lateral (Clientes, Citas, Espera y Admin)
- **ContentPanel**: Clase abstracta base de las secciones; obliga a definir `onDisplay()`
- **ContentDialog**: Clase abstracta base de los diálogos; cada hijo define `initialize()` y `onConfirm()`
- **ClientsPanel**: Tabla de clientes con los botones crear, modificar, borrar y consultar
- **CitasPanel**: Tabla de citas con filtro por fechas, pendientes de mañana y envío de confirmaciones
- **EsperaPanel**: Lista de espera con su posición; agregar, retirar al primero o retirar uno seleccionado
- **AdminPanel**: Pestañas de administración (`ServicesPanel` y `HorariosPanel`)
- **Diálogos**: `CreateClientDialog`, `ModificarClientDialog`, `ConsultarClientDialog`, `CitaDialog`, `AgregarEsperaDialog` y `ServicioDialog`

## Reglas del negocio

### Clientes
- El nombre del cliente es obligatorio.
- El email debe tener un formato válido (por ejemplo, `ana@correo.com`).
- El teléfono debe tener 8 dígitos, con un guion o espacio opcional en medio (por ejemplo, `8888-8888`).
- El id del cliente se asigna de forma automática y consecutiva.
- No se puede borrar un cliente que tenga citas programadas en el futuro.
- No se puede borrar un cliente que se encuentre en la lista de espera.

### Servicios
- No pueden existir dos servicios con el mismo nombre.
- El nombre del servicio no puede estar vacío (se valida en `ServicioDialog`).
- Al consultar un servicio se indica si está siendo utilizado en alguna cita.

### Horarios
- Cada día de la semana tiene como máximo un horario; al guardar uno nuevo se reemplaza el anterior.
- La hora de fin no puede ser anterior a la hora de inicio.
- Un día sin horario configurado se considera fuera del horario de atención.
- Una hora está dentro del horario si es igual o posterior al inicio e igual o anterior al fin.

### Citas
- Una cita solo se puede crear o modificar dentro del horario de atención.
- No pueden existir dos citas en la misma fecha y hora.
- Toda cita nueva inicia como NO_CONFIRMADA.
- Al modificar una cita se puede cambiar la fecha, la hora y el servicio, pero no el cliente.
- Solo se pueden confirmar las citas que están NO_CONFIRMADA.
- Las notificaciones se envían únicamente a las citas de mañana que estén NO_CONFIRMADA y dentro del horario de atención.
- Si no hay citas pendientes para el día siguiente, se muestra un error.

### Lista de espera
- Funciona como una cola: el primero en llegar es el primero en la lista.
- Un cliente no puede estar dos veces en la lista de espera.
- Solo se pueden agregar clientes que ya estén registrados.

## Conceptos POO implementados

- **Encapsulamiento**: Atributos privados, getters y setters
- **Asociaciones**: Relaciones entre Cita, Cliente y Servicio
- **Enumeración**: EstadoCita define los estados posibles de una cita
- **Patrón Singleton**: Barberia tiene una única instancia
- **Herencia**: Los paneles heredan de `ContentPanel` y los diálogos de `ContentDialog`
- **Clases abstractas y polimorfismo**: `onDisplay()`, `initialize()` y `onConfirm()` se definen en cada clase hija
- **Persistencia**: Serialización de objetos (`Serializable`) para guardar y cargar los datos
- **Validación**: Verificaciones con excepciones en las clases de la lógica y en la clase de control
- **Colecciones**: `HashMap` para clientes, servicios, citas y horarios; `ArrayDeque` (como `Queue`) para la lista de espera; `ArrayList` para los listados
- **Interfaz gráfica**: Swing con `JTable`, `JTabbedPane`, `CardLayout` y diálogos modales
- **Expresiones regulares**: Validación del email y del teléfono

## Requisitos técnicos
- Java 11 o superior
- Biblioteca **Jakarta Mail** (`jakarta.mail`) para el envío de correos, junto con su implementación (por ejemplo, Angus Mail) y la dependencia de activación si la versión elegida la requiere
- IDE: Eclipse, IntelliJ IDEA o Visual Studio Code
- Conexión a internet y una cuenta de Gmail con contraseña de aplicación (solo para enviar las confirmaciones)

## Estructura del proyecto

```
Barberia/
└── src/
    ├── Control/
    │   └── Barberia.java            - Clase de control (Singleton)
    ├── Logica/
    │   ├── Cliente.java
    │   ├── Servicio.java
    │   ├── Horario.java
    │   ├── Cita.java
    │   └── EstadoCita.java          - Enumeración
    └── GUI/
        ├── ControlPanel.java        - Ventana principal (main)
        ├── ContentPanel.java        - Base abstracta de las secciones
        ├── ContentDialog.java       - Base abstracta de los diálogos
        ├── ClientsPanel.java
        ├── CitasPanel.java
        ├── EsperaPanel.java
        ├── AdminPanel.java
        ├── ServicesPanel.java
        ├── HorariosPanel.java
        ├── CreateClientDialog.java
        ├── ModificarClientDialog.java
        ├── ConsultarClientDialog.java
        ├── CitaDialog.java
        ├── AgregarEsperaDialog.java
        └── ServicioDialog.java
```

Al cerrar la aplicación se crea (o se actualiza) el archivo `DataBarberia.dat` en la carpeta raíz del proyecto.

## Configuración del correo

El envío de confirmaciones usa Gmail (`smtp.gmail.com`, puerto 587 con STARTTLS). La cuenta remitente se define en las constantes `CORREO_LOCAL` y `CLAVE_CORREO` de `Barberia.java`.

1. Activar la verificación en dos pasos en la cuenta de Gmail que se usará.
2. Generar una **contraseña de aplicación** desde la configuración de seguridad de la cuenta.
3. Reemplazar los valores de `CORREO_LOCAL` y `CLAVE_CORREO` en `Barberia.java`.

> **Importante:** no se debe subir una contraseña real a un repositorio público. Si una clave quedó expuesta, se debe revocar y generar una nueva.

## Compilación y ejecución

### En Eclipse:
1. Importar o crear el proyecto con las carpetas `Control`, `Logica` y `GUI` dentro de `src`.
2. Agregar al *build path* las bibliotecas de Jakarta Mail (archivos `.jar`).
3. Clic derecho sobre `ControlPanel.java` → **Run As → Java Application**.
4. Se abre la ventana principal de la barbería.

### Por terminal:
```bash
javac -cp "lib/*" -d bin src/Logica/*.java src/Control/*.java src/GUI/*.java
java -cp "bin:lib/*" GUI.ControlPanel
```
(En Windows se usa `;` en lugar de `:` en el classpath. La carpeta `lib` contiene los `.jar` de Jakarta Mail.)

## Uso de la aplicación

La ventana principal tiene un menú lateral con cuatro secciones:

| Sección | Qué permite hacer |
|---------|-------------------|
| **Clientes** | Crear, modificar, borrar y consultar clientes |
| **Citas** | Consultar el calendario por rango de fechas, ver las pendientes de mañana, crear, consultar, modificar, cancelar y confirmar citas, y enviar las confirmaciones por correo |
| **Espera** | Agregar un cliente al final, retirar al primero o retirar uno seleccionado |
| **Admin** | Pestaña *Servicios* (crear, modificar, borrar y consultar) y pestaña *Horarios* (establecer el horario de un día y comprobar si una fecha y hora están dentro de la atención) |

Orden recomendado para una primera prueba:
1. En **Admin → Horarios**, configurar el horario de los días de atención.
2. En **Admin → Servicios**, crear al menos un servicio.
3. En **Clientes**, registrar al menos un cliente.
4. En **Citas**, crear una cita dentro del horario configurado.
5. Cerrar la ventana para que los datos se guarden en `DataBarberia.dat`.

---

# DIAGRAMA CONCEPTUAL

## Representación ASCII

```
┌─────────────────────────────────┐
│ CLIENTE                         │
├─────────────────────────────────┤
│ - idCliente: String             │
│ - nombre: String                │
│ - telefono: String              │
│ - email: String                 │
└─────────────────────────────────┘
               │
               │ 0..*
               │ citas (cada cita apunta a un cliente)
               │
               ▼
┌─────────────────────────────────┐
│ CITA                            │
├─────────────────────────────────┤
│ - fechaHora: LocalDateTime      │
│ - estado: EstadoCita            │
└─────────────────────────────────┘
               │
               │ 1
               │ servicio
               │
               ▼
┌─────────────────────────────────┐
│ SERVICIO                        │
├─────────────────────────────────┤
│ - nombre: String                │
└─────────────────────────────────┘

┌─────────────────────────────────┐
│ HORARIO                         │
├─────────────────────────────────┤
│ - dia: DayOfWeek                │
│ - horaInicio: LocalTime         │
│ - horaFin: LocalTime            │
└─────────────────────────────────┘
(un horario por día de la semana, guardado en Barberia)
```

## Diagrama de asociaciones

```
Cita (0..*) ──── cliente (1) ──── Cliente

Cita (0..*) ──── servicio (1) ──── Servicio

Cita ──── estado (1) ──── <<Enumeration>> EstadoCita

Barberia (1) ──── clientes (0..*) ──── Cliente
Barberia (1) ──── servicios (0..*) ──── Servicio
Barberia (1) ──── citas (0..*) ──── Cita
Barberia (1) ──── horarios (0..7) ──── Horario
Barberia (1) ──── espera (0..*) ──── Cliente
Barberia (1) ──── instance (1) ──── Barberia
```

---

# DIAGRAMA DE CLASES COMPLETO

## Capa de lógica

```
╔════════════════════════════════════════════════════════════════╗
║ CLIENTE                                                        ║
╠════════════════════════════════════════════════════════════════╣
║ Atributos:                                                     ║
║ - idCliente: String                                            ║
║ - nombre: String                                               ║
║ - telefono: String                                             ║
║ - email: String                                                ║
╠════════════════════════════════════════════════════════════════╣
║ Constructores:                                                 ║
║ + Cliente(idCliente: String, nombre: String, telefono: String, ║
║  email: String) throws Exception                               ║
╠════════════════════════════════════════════════════════════════╣
║ Métodos:                                                       ║
║ + validarEmail(email: String): boolean                         ║
║ + validarTelefono(telefono: String): boolean                   ║
║                                                                ║
║ + getIdCliente(): String                                       ║
║ + setIdCliente(idCliente: String): void                        ║
║ + getNombre(): String                                          ║
║ + setNombre(nombre: String): void                              ║
║ + getTelefono(): String                                        ║
║ + setTelefono(telefono: String): void                          ║
║ + getEmail(): String                                           ║
║ + setEmail(email: String): void                                ║
║ + toString(): String                                           ║
╚════════════════════════════════════════════════════════════════╝

╔════════════════════════════════════════════════════════════════╗
║ SERVICIO                                                       ║
╠════════════════════════════════════════════════════════════════╣
║ Atributos:                                                     ║
║ - nombre: String                                               ║
╠════════════════════════════════════════════════════════════════╣
║ Constructores:                                                 ║
║ + Servicio(nombre: String)                                     ║
╠════════════════════════════════════════════════════════════════╣
║ Métodos:                                                       ║
║ + getNombre(): String                                          ║
║ + setNombre(nombre: String): void                              ║
║ + toString(): String                                           ║
╚════════════════════════════════════════════════════════════════╝

╔════════════════════════════════════════════════════════════════╗
║ HORARIO                                                        ║
╠════════════════════════════════════════════════════════════════╣
║ Atributos:                                                     ║
║ - dia: DayOfWeek                                               ║
║ - horaInicio: LocalTime                                        ║
║ - horaFin: LocalTime                                           ║
╠════════════════════════════════════════════════════════════════╣
║ Constructores:                                                 ║
║ + Horario(dia: DayOfWeek, horaInicio: LocalTime, horaFin:      ║
║  LocalTime) throws Exception                                   ║
╠════════════════════════════════════════════════════════════════╣
║ Métodos:                                                       ║
║ + enRango(hora: LocalTime): boolean                            ║
║                                                                ║
║ + getDia(): DayOfWeek                                          ║
║ + setDia(dia: DayOfWeek): void                                 ║
║ + getHoraInicio(): LocalTime                                   ║
║ + setHoraInicio(horaInicio: LocalTime): void                   ║
║ + getHoraFin(): LocalTime                                      ║
║ + setHoraFin(horaFin: LocalTime): void                         ║
║ + toString(): String                                           ║
╚════════════════════════════════════════════════════════════════╝

╔════════════════════════════════════════════════════════════════╗
║ CITA                                                           ║
╠════════════════════════════════════════════════════════════════╣
║ Atributos:                                                     ║
║ - fechaHora: LocalDateTime                                     ║
║ - servicio: Servicio                                           ║
║ - cliente: Cliente                                             ║
║ - estado: EstadoCita                                           ║
╠════════════════════════════════════════════════════════════════╣
║ Constructores:                                                 ║
║ + Cita(fechaHora: LocalDateTime, servicio: Servicio, cliente:  ║
║  Cliente)                                                      ║
╠════════════════════════════════════════════════════════════════╣
║ Métodos:                                                       ║
║ + getFechaHora(): LocalDateTime                                ║
║ + setFechaHora(fechaHora: LocalDateTime): void                 ║
║ + getServicio(): Servicio                                      ║
║ + setServicio(servicio: Servicio): void                        ║
║ + getCliente(): Cliente                                        ║
║ + setCliente(cliente: Cliente): void                           ║
║ + getEstado(): EstadoCita                                      ║
║ + setEstado(estado: EstadoCita): void                          ║
║ + toString(): String                                           ║
╚════════════════════════════════════════════════════════════════╝

╔════════════════════════════════════════════════════════════════╗
║ <<Enumeration>> ESTADOCITA                                     ║
╠════════════════════════════════════════════════════════════════╣
║ NO_CONFIRMADA                                                  ║
║ CONFIRMADA                                                     ║
╠════════════════════════════════════════════════════════════════╣
║ Métodos:                                                       ║
║ + toString(): String                                           ║
╚════════════════════════════════════════════════════════════════╝
```

## Capa de control

```
╔════════════════════════════════════════════════════════════════╗
║ <<Singleton>> BARBERIA                                         ║
╠════════════════════════════════════════════════════════════════╣
║ Atributos:                                                     ║
║ - instance: Barberia (estático)                                ║
║ - dataFileName: String (constante, "DataBarberia.dat")         ║
║ - CORREO_LOCAL: String (constante)                             ║
║ - CLAVE_CORREO: String (constante)                             ║
║ - clientLastId: int                                            ║
║ - clientes: Map<String, Cliente>                               ║
║ - servicios: Map<String, Servicio>                             ║
║ - citas: Map<LocalDateTime, Cita>                              ║
║ - horarios: Map<DayOfWeek, Horario>                            ║
║ - espera: Queue<Cliente>                                       ║
╠════════════════════════════════════════════════════════════════╣
║ Constructores:                                                 ║
║ - Barberia()                                                   ║
╠════════════════════════════════════════════════════════════════╣
║ Métodos generales:                                             ║
║ + getInstance(): Barberia (estático)                           ║
║ + cargarDatosDisco(): void                                     ║
║ + guardarDatosDisco(): void                                    ║
║                                                                ║
║ Clientes:                                                      ║
║ + crearCliente(nombre: String, tel: String, email: String):    ║
║  Cliente                                                       ║
║ + consultarCliente(id: String): Cliente                        ║
║ + modificarCliente(id: String, nombre: String, telefono:       ║
║  String, email: String): void                                  ║
║ + borrarCliente(id: String): boolean                           ║
║ + getListaClientes(): ArrayList<Cliente>                       ║
║ + clienteEnSistema(cliente: Cliente): boolean                  ║
║                                                                ║
║ Servicios:                                                     ║
║ + crearServicio(nombre: String): Servicio                      ║
║ + consultarServicio(nombre: String): Servicio                  ║
║ + modificarServicio(oldNombre: String, nombre: String):        ║
║  boolean                                                       ║
║ + borrarServicio(nombre: String): boolean                      ║
║ + getListaServicio(): ArrayList<Servicio>                      ║
║ + servicioEnUso(servicio: Servicio): boolean                   ║
║                                                                ║
║ Citas:                                                         ║
║ + crearCita(idCliente: String, servicio: Servicio, fechaHora:  ║
║  LocalDateTime): Cita                                          ║
║ + consultarCita(fechaHora: LocalDateTime): Cita                ║
║ + modificarCita(oldFechaHora: LocalDateTime, fechaHora:        ║
║  LocalDateTime, servicio: Servicio): boolean                   ║
║ + borrarCita(fechaHora: LocalDateTime): boolean                ║
║ + confirmarCita(fechaHora: LocalDateTime): boolean             ║
║ + getCalendarioCitas(desde: LocalDate, hasta: LocalDate):      ║
║  ArrayList<Cita>                                               ║
║ + enviarNotificacion(fechaHora: LocalDateTime): boolean        ║
║ + enviarNotificacionesConfirmacion(): ArrayList<Cita>          ║
║                                                                ║
║ Lista de espera:                                               ║
║ + agregarClienteListaEspera(idCliente: String): boolean        ║
║ + borrarClienteListaEspera(): boolean                          ║
║ + borrarClienteListaEspera(idCliente: String): boolean         ║
║ + getListaEspera(): Queue<Cliente>                             ║
║                                                                ║
║ Horarios:                                                      ║
║ + establecerHorario(dia: DayOfWeek, horaInicio: LocalTime,     ║
║  horaFinal: LocalTime): void                                   ║
║ + getHorario(dia: DayOfWeek): Horario                          ║
║ + enHorarioDeAtencion(fechaHora: LocalDateTime): boolean       ║
║ - validarHorarioAtencion(fechaHora: LocalDateTime): void       ║
╚════════════════════════════════════════════════════════════════╝
```

## Capa de interfaz gráfica

```
JFrame
└── ControlPanel                 - Ventana principal y main

JPanel
└── <<abstract>> ContentPanel    - getRootFrame(), showBasicError(), onDisplay()
    ├── ClientsPanel
    ├── CitasPanel
    ├── EsperaPanel
    ├── AdminPanel               - contiene ServicesPanel y HorariosPanel
    ├── ServicesPanel
    └── HorariosPanel

JDialog
└── <<abstract>> ContentDialog   - initialize(), onConfirm(), showErrorMessage()
    ├── CreateClientDialog
    ├── ModificarClientDialog
    ├── ConsultarClientDialog
    ├── CitaDialog
    ├── AgregarEsperaDialog
    └── ServicioDialog
```

## Asociaciones y multiplicidades

```
Cita ────────────────────── Cliente
0..*                         1
(Navegabilidad de Cita hacia Cliente)

Cita ────────────────────── Servicio
0..*                         1
(Navegabilidad de Cita hacia Servicio)

Cita ────────────────────── EstadoCita
*                            1

Barberia ────────────────── Cliente / Servicio / Cita / Horario
1                            0..*
(Mapas: clientes, servicios, citas, horarios)

Barberia ────────────────── Cliente
1                            0..*
(Cola: espera)

ControlPanel ────────────── Paneles (Clientes, Citas, Espera, Admin)
1                            4
(CardLayout: se muestra una sección a la vez)

AdminPanel ──────────────── ServicesPanel / HorariosPanel
1                            1 / 1
(JTabbedPane)

GUI ─────────────────────── Barberia
(Los paneles y diálogos solo se comunican con la lógica a través de Barberia)
```

---

## Características implementadas

### Encapsulamiento
- Todos los atributos son privados
- Getters para lectura y setters para modificación
- Los setters de `Cliente` validan el nombre, el teléfono y el email

### Asociaciones
- Una Cita referencia a su Cliente y a su Servicio
- La clase de control administra todas las entidades mediante mapas y una cola

### Colecciones
- `HashMap` para clientes (por id), servicios (por nombre), citas (por fecha y hora) y horarios (por día)
- `ArrayDeque` como `Queue` para la lista de espera
- `ArrayList` para los listados que devuelve la clase de control

### Validación
- Validación del formato del email y del teléfono con expresiones regulares
- Validación del nombre del cliente y del servicio
- Verificación del horario de atención al crear o modificar citas
- Verificación de citas duplicadas en la misma fecha y hora
- Excepciones con mensajes claros, mostrados en la interfaz con `JOptionPane`
- Validación del formato de fechas (`aaaa-MM-dd`) y horas (`HH:mm`) en los campos de texto

### Persistencia
- Todas las clases de la lógica y de control implementan `Serializable`
- `guardarDatosDisco()` escribe el objeto `Barberia` completo en `DataBarberia.dat`
- `cargarDatosDisco()` restaura clientes, servicios, citas, horarios y lista de espera
- Los datos se cargan al iniciar y se guardan al cerrar la ventana principal

### Notificaciones por correo
- `enviarNotificacion()` envía un correo de confirmación a una cita mediante Jakarta Mail y Gmail
- `enviarNotificacionesConfirmacion()` devuelve las citas pendientes de mañana
- En la interfaz, si un envío falla se puede **reintentar**, **continuar** con la siguiente o **abortar**

### Interfaz gráfica
- Menú lateral con `CardLayout` para cambiar entre secciones
- Cada sección se actualiza con `onDisplay()` cada vez que se muestra
- Botones que dependen de una fila seleccionada se activan solo cuando hay una
- Diálogos modales que muestran el error y no se cierran si los datos no son válidos

## Notas importantes
- El id de los clientes se asigna de forma consecutiva con `clientLastId`.
- Los formatos de fecha y hora en la interfaz son `aaaa-MM-dd` y `HH:mm`.
- La consulta de **Pendientes de Mañana** en `CitasPanel` solo muestra las citas; los correos se envían con el botón **Enviar Confirmaciones**.
- El correo enviado pide al cliente comunicarse con el local para confirmar; la cita se confirma manualmente con el botón **Confirmar Cita**.
- Un servicio se puede borrar aunque esté siendo usado en citas; `servicioEnUso()` solo se usa al consultarlo.
- Al borrar un cliente solo se revisan las citas futuras; las citas pasadas no bloquean el borrado.
- Las credenciales del correo están escritas en el código; deben reemplazarse por las de la cuenta que se use.
- Se siguieron las convenciones de nomenclatura de Java en métodos y atributos.

## Autores
Owel Jafet Gutiérrez Ortiz - 2026800869
Miranda Jiménez Alvarado - 2026008616
Keishiro Gabriel Cubero Abe - 2026091245
Eduardo Alfonso Moreno Pérez - 2025080891

## Profesor
Mauricio Avilés Cisneros

## Fecha de entrega
09/11/2026

## Institución
Instituto Tecnológico de Costa Rica
Escuela de Computación
Bachillerato en Ingeniería en Computación
