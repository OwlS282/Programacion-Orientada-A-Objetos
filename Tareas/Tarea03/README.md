# Tarea 3 - Sistema de Blogs

## Descripción
Esta tarea consiste en la implementación de un sistema de blogs utilizando Programación Orientada a Objetos en Java, organizado en tres capas (interfaz, control y lógica). El sistema permite:
- Crear, borrar y listar blogs
- Crear publicaciones dentro de un blog y listarlas
- Ver el contenido completo de una publicación, con sus comentarios
- Agregar comentarios a una publicación (con email, dirección IP y texto)
- Borrar comentarios de una publicación
- Interactuar con el usuario mediante un menú en consola

## Requisitos del problema

### Blog
- **Código**: Identificador numérico único, asignado de forma consecutiva (empieza en 1)
- **Nombre**: Nombre del blog (obligatorio)
- **Descripción**: Descripción del blog (obligatoria)
- **Fecha de creación**: Fecha y hora en que se crea el blog
- **Publicaciones**: Lista de publicaciones, numeradas desde 1 en el orden en que se crean

### Publicacion
- **Título**: Título de la publicación (obligatorio)
- **Texto**: Contenido de la publicación (obligatorio)
- **Nombre del creador**: Nombre de quien la publica (obligatorio)
- **Fecha de publicación**: Fecha y hora en que se crea
- **Comentarios**: Lista de comentarios, numerados desde 1 en el orden en que se agregan

### Comentario
- **Fecha de creación**: Fecha y hora en que se crea el comentario
- **Email**: Correo electrónico del autor (obligatorio)
- **IP**: Dirección IP desde la que se comenta (obligatoria)
- **Texto**: Contenido del comentario (obligatorio)

### Control
- Clase controladora que administra la colección de blogs y el consecutivo de sus códigos
- Encapsula las funcionalidades del sistema
- Retorna únicamente `String` o colecciones de `String`, nunca referencias a objetos de la capa de lógica

### ProgramaPrincipal
- Aplicación de consola: muestra el menú, lee los datos del usuario, invoca los métodos de `Control` y muestra los resultados o los errores

## Reglas del negocio
- El nombre y la descripción de un blog no pueden ser nulos, vacíos ni contener solo espacios.
- El título, el texto y el nombre del creador de una publicación son obligatorios.
- El email, la IP y el texto de un comentario son obligatorios.
- El email de un comentario debe tener un formato válido (por ejemplo, `ana@correo.com`).
- Solo se puede trabajar con blogs existentes; si el código no existe se lanza un error.
- El número de publicación debe estar entre 1 y la cantidad de publicaciones del blog.
- La posición de un comentario debe estar entre 1 y la cantidad de comentarios de la publicación.
- El código de un blog borrado no se reutiliza, porque el consecutivo nunca baja.
- Si la creación de un blog falla por datos inválidos, el consecutivo no se gasta.
- Borrar un blog elimina también sus publicaciones y comentarios.

## Conceptos POO implementados

- **Encapsulamiento**: Atributos privados, getters y setters
- **Arquitectura en capas**: `interfaz` (consola), `control` (controladora) y `logica` (clases del dominio)
- **Asociaciones**: Relaciones 1 a muchos entre Blog, Publicacion y Comentario
- **Composición**: Un Blog contiene sus Publicacion y una Publicacion contiene sus Comentario
- **Validación**: Verificaciones con excepciones (`IllegalArgumentException`) y expresión regular para el email
- **Protección de la capa de lógica**: `Control` devuelve copias (`Map` nuevos) y `String`, no objetos internos
- **Sobrescritura de `toString()`**: `Publicacion` y `Comentario` generan su propia representación en texto
- **Colecciones**: `LinkedHashMap` para los blogs y para los listados; `ArrayList` para publicaciones y comentarios

## Requisitos técnicos
- Java 8 o superior (se usa `java.time`)
- IDE: Eclipse, IntelliJ IDEA o Visual Studio Code

## Estructura del proyecto

```
SistemaBlogs/
└── src/
    ├── interfaz/
    │   └── ProgramaPrincipal.java   - Clase principal (menú de consola)
    ├── control/
    │   └── Control.java             - Controladora del sistema
    └── logica/
        ├── Blog.java
        ├── Publicacion.java
        └── Comentario.java
```

## Compilación y ejecución

### En Eclipse:
1. Importar o crear el proyecto con las carpetas `interfaz`, `control` y `logica` dentro de `src`.
2. Clic derecho sobre `ProgramaPrincipal.java` → **Run As → Java Application**.
3. Interactuar con el menú en la pestaña **Console**.

### Por terminal:
```bash
javac -d bin src/logica/*.java src/control/*.java src/interfaz/*.java
java -cp bin interfaz.ProgramaPrincipal
```

## Menú del programa

```
-------- Sistema de Blogs --------
1. Crear blog
2. Borrar blog
3. Listar blogs
4. Crear publicacion
5. Listar publicaciones de un blog
6. Ver una publicacion
7. Agregar comentario
8. Borrar comentario
0. Salir
```

## Ejemplo de ejecución

Después de crear un blog, una publicación y un comentario, la opción 6 (ver una publicación) muestra algo como esto (las fechas son las del momento de ejecución):

```
--- Ver publicacion ---
Codigo del blog: 1
Numero de publicacion: 1

Titulo: Mi primer post
Creador: Ana Mora
Fecha de publicacion: 29/09/2026 10:15
Texto: Hola a todos, este es mi primer post.
Comentarios (1):
  1. [29/09/2026 10:20] luis@correo.com (IP: 192.168.0.1): Muy buen post!
```

Si la publicación no tiene comentarios:

```
Comentarios (0):
  (sin comentarios)
```

Ejemplos de errores controlados:

```
Error: El blog con codigo 5 no existe.
Error: El nombre del blog no puede ser nulo o vacio.
Error: El numero de publicacion 3 no es valido.
Error: El email no tiene un formato valido.
Error: La posicion de comentario 2 no es valida.
Error: debe ingresar un numero entero.
```

---

# DIAGRAMA CONCEPTUAL

## Representación ASCII

```
┌─────────────────────────────────┐
│ CONTROL                         │
└──────────────┬──────────────────┘
               │
               │ 0..*
               │ blogs
               ▼
┌─────────────────────────────────┐
│ BLOG                            │
├─────────────────────────────────┤
│ - codigo: int                   │
│ - nombre: String                │
│ - descripcion: String           │
│ - fechaCreacion: LocalDateTime  │
└──────────────┬──────────────────┘
               │
               │ 0..*
               │ publicaciones
               ▼
┌─────────────────────────────────┐
│ PUBLICACION                     │
├─────────────────────────────────┤
│ - titulo: String                │
│ - texto: String                 │
│ - nombreCreador: String         │
│ - fechaPublicacion: LocalDateTime│
└──────────────┬──────────────────┘
               │
               │ 0..*
               │ comentarios
               ▼
┌─────────────────────────────────┐
│ COMENTARIO                      │
├─────────────────────────────────┤
│ - fechaCreacion: LocalDateTime  │
│ - email: String                 │
│ - ip: String                    │
│ - texto: String                 │
└─────────────────────────────────┘
```

## Diagrama de asociaciones

```
Control (1) ──── blogs (0..*) ──── Blog
Blog (1) ──── publicaciones (0..*) ──── Publicacion
Publicacion (1) ──── comentarios (0..*) ──── Comentario

ProgramaPrincipal (1) ──── control (1) ──── Control
        Navegabilidad unidireccional (de arriba hacia abajo)
```

---

# DIAGRAMA DE CLASES COMPLETO

```
╔════════════════════════════════════════════════════════╗
║ BLOG                                                   ║
╠════════════════════════════════════════════════════════╣
║ Atributos:                                             ║
║ - codigo: int                                          ║
║ - nombre: String                                       ║
║ - descripcion: String                                  ║
║ - fechaCreacion: LocalDateTime                         ║
║ - publicaciones: List<Publicacion>                     ║
╠════════════════════════════════════════════════════════╣
║ Constructores:                                         ║
║ + Blog(codigo: int, nombre: String,                    ║
║ descripcion: String)                                   ║
╠════════════════════════════════════════════════════════╣
║ Métodos:                                               ║
║ + crearPublicacion(titulo: String, texto: String,      ║
║ nombreCreador: String): void                           ║
║ + obtenerPublicacion(numeroPublicacion: int): String   ║
║ + obtenerTitulosPublicaciones(): Map<Integer, String>  ║
║ + agregarComentario(numeroPublicacion: int,            ║
║ email: String, ip: String, texto: String): void        ║
║ + borrarComentario(numeroPublicacion: int,             ║
║ posicion: int): void                                   ║
║ - buscarPublicacion(numeroPublicacion: int):           ║
║ Publicacion                                            ║
║ - validarTexto(valor: String, campo: String): void     ║
║                                                        ║
║ + getCodigo(): int                                     ║
║ + setCodigo(codigo: int): void                         ║
║ + getNombre(): String                                  ║
║ + setNombre(nombre: String): void                      ║
║ + getDescripcion(): String                             ║
║ + setDescripcion(descripcion: String): void            ║
║ + getFechaCreacion(): LocalDateTime                    ║
║ + setFechaCreacion(fecha: LocalDateTime): void         ║
╚════════════════════════════════════════════════════════╝

╔════════════════════════════════════════════════════════╗
║ PUBLICACION                                            ║
╠════════════════════════════════════════════════════════╣
║ Atributos:                                             ║
║ - titulo: String                                       ║
║ - texto: String                                        ║
║ - nombreCreador: String                                ║
║ - fechaPublicacion: LocalDateTime                      ║
║ - comentarios: List<Comentario>                        ║
╠════════════════════════════════════════════════════════╣
║ Constructores:                                         ║
║ + Publicacion(titulo: String, texto: String,           ║
║ nombreCreador: String)                                 ║
╠════════════════════════════════════════════════════════╣
║ Métodos:                                               ║
║ + agregarComentario(email: String, ip: String,         ║
║ texto: String): void                                   ║
║ + borrarComentario(posicion: int): void                ║
║ - validarTexto(valor: String, campo: String): void     ║
║ + toString(): String                                   ║
║                                                        ║
║ + getTitulo(): String                                  ║
║ + setTitulo(titulo: String): void                      ║
║ + getTexto(): String                                   ║
║ + setTexto(texto: String): void                        ║
║ + getNombreCreador(): String                           ║
║ + setNombreCreador(nombreCreador: String): void        ║
║ + getFechaPublicacion(): LocalDateTime                 ║
║ + setFechaPublicacion(fecha: LocalDateTime): void      ║
╚════════════════════════════════════════════════════════╝

╔════════════════════════════════════════════════════════╗
║ COMENTARIO                                             ║
╠════════════════════════════════════════════════════════╣
║ Atributos:                                             ║
║ - fechaCreacion: LocalDateTime                         ║
║ - email: String                                        ║
║ - ip: String                                           ║
║ - texto: String                                        ║
╠════════════════════════════════════════════════════════╣
║ Constructores:                                         ║
║ + Comentario(email: String, ip: String, texto: String) ║
╠════════════════════════════════════════════════════════╣
║ Métodos:                                               ║
║ - validarTexto(valor: String, campo: String): void     ║
║ + toString(): String                                   ║
║                                                        ║
║ + getFechaCreacion(): LocalDateTime                    ║
║ + setFechaCreacion(fecha: LocalDateTime): void         ║
║ + getEmail(): String                                   ║
║ + setEmail(email: String): void                        ║
║ + getIp(): String                                      ║
║ + setIp(ip: String): void                              ║
║ + getTexto(): String                                   ║
║ + setTexto(texto: String): void                        ║
╚════════════════════════════════════════════════════════╝

╔════════════════════════════════════════════════════════╗
║ CONTROL                                                ║
╠════════════════════════════════════════════════════════╣
║ Atributos:                                             ║
║ - blogs: Map<Integer, Blog>                            ║
║ - consecutivoBlog: int                                 ║
╠════════════════════════════════════════════════════════╣
║ Constructores:                                         ║
║ + Control()                                            ║
╠════════════════════════════════════════════════════════╣
║ Métodos privados:                                      ║
║ - buscarBlog(codigoBlog: int): Blog                    ║
║ - emailValido(email: String): boolean                  ║
║                                                        ║
║ Blogs:                                                 ║
║ + crearBlog(nombre: String, descripcion: String): void ║
║ + borrarBlog(codigoBlog: int): void                    ║
║ + obtenerBlogs(): Map<Integer, String>                 ║
║                                                        ║
║ Publicaciones:                                         ║
║ + crearPublicacion(codigoBlog: int, titulo: String,    ║
║ texto: String, nombreCreador: String): void            ║
║ + obtenerPublicaciones(codigoBlog: int):               ║
║ Map<Integer, String>                                   ║
║ + obtenerPublicacion(codigoBlog: int,                  ║
║ numeroPublicacion: int): String                        ║
║                                                        ║
║ Comentarios:                                           ║
║ + agregarComentario(codigoBlog: int,                   ║
║ numeroPublicacion: int, email: String, ip: String,     ║
║ texto: String): void                                   ║
║ + borrarComentario(codigoBlog: int,                    ║
║ numeroPublicacion: int, posicion: int): void           ║
╚════════════════════════════════════════════════════════╝

╔════════════════════════════════════════════════════════╗
║ PROGRAMAPRINCIPAL                                      ║
╠════════════════════════════════════════════════════════╣
║ Atributos:                                             ║
║ - scanner: Scanner (estático)                          ║
║ - control: Control (estático)                          ║
╠════════════════════════════════════════════════════════╣
║ Métodos:                                               ║
║ + main(args: String[]): void (estático)                ║
║ - mostrarMenu(): void                                  ║
║ - leerTexto(mensaje: String): String                   ║
║ - leerEntero(mensaje: String): int                     ║
║ - crearBlog(): void                                    ║
║ - borrarBlog(): void                                   ║
║ - listarBlogs(): void                                  ║
║ - crearPublicacion(): void                             ║
║ - listarPublicaciones(): void                          ║
║ - verPublicacion(): void                               ║
║ - agregarComentario(): void                            ║
║ - borrarComentario(): void                             ║
╚════════════════════════════════════════════════════════╝
```

## Asociaciones y multiplicidades

```
Control ────────────────────── Blog
1                              0..*
(Mapa: blogs, llave = código del blog)

Blog ────────────────────── Publicacion
1                           0..*
(Composición: las publicaciones pertenecen al blog)

Publicacion ────────────────────── Comentario
1                                  0..*
(Composición: los comentarios pertenecen a la publicación)

ProgramaPrincipal ────────────────────── Control
1                                        1
```

---

## Características implementadas

### Encapsulamiento
- Todos los atributos son privados
- Getters para lectura y setters para modificación
- Los métodos auxiliares (`buscarBlog`, `buscarPublicacion`, `validarTexto`, `emailValido`) son privados y evitan repetir validaciones

### Colecciones
- `LinkedHashMap<Integer, Blog>` para los blogs: búsqueda directa por código y orden de creación al listar
- `ArrayList<Publicacion>` para las publicaciones de cada blog (se identifican por su posición, desde 1)
- `ArrayList<Comentario>` para los comentarios de cada publicación (se identifican por su posición, desde 1)
- `LinkedHashMap<Integer, String>` para los listados que devuelve `Control` (código o número y nombre o título)

### Validación
- Textos obligatorios: se rechazan valores nulos, vacíos o con solo espacios (con `trim()`)
- Formato del email con la expresión regular `^[\w.+-]+@[\w-]+(\.[\w-]+)+$`
- Verificación de que el blog exista y de que el número de publicación y la posición del comentario estén en rango
- Lectura segura de enteros en la interfaz: si el usuario escribe algo que no es un número, se avisa y se vuelve a pedir
- Excepciones `IllegalArgumentException` con mensajes claros, capturadas dentro del ciclo del menú

### Programa principal
- Cicla el menú hasta que el usuario elige la opción 0
- El `try/catch` está dentro del ciclo, así un error no cierra el programa
- Lee con `nextLine()` para evitar saltos de línea pendientes en el buffer

## Notas importantes
- El código de los blogs es consecutivo, empieza en 1 y nunca se reutiliza, aunque el blog se borre.
- Las publicaciones y los comentarios se identifican por su posición (desde 1); al borrar un comentario, los siguientes se renumeran.
- Los datos no se guardan en disco: al cerrar el programa se pierde toda la información.
- `Control` nunca devuelve objetos de la capa de lógica, solo `String` y `Map` nuevos.
- Los mensajes del programa se escriben sin tildes.
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
29/09/2026

## Institución
Instituto Tecnológico de Costa Rica
Escuela de Computación
Bachillerato en Ingeniería en Computación
