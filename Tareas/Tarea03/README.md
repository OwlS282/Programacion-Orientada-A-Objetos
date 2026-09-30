# Tarea POO - Sistema de Blog

## Descripción
Esta tarea consiste en la implementación de un sistema de gestión de blogs utilizando Programación Orientada a Objetos en Java. El sistema permite:
- Crear blogs con propiedades específicas
- Agregar publicaciones a los blogs
- Incluir comentarios en las publicaciones
- Gestionar la información de usuarios comentaristas

## Requisitos del problema

### Blog
- **Código**: Identificador numérico único
- **Nombre**: Título del blog
- **Descripción**: Información adicional del blog
- **Fecha de creación**: Cuándo se creó el blog
- **Publicaciones**: Colección ordenada de publicaciones

### Publicación
- **Título**: Nombre de la publicación
- **Texto**: Contenido de la publicación
- **Nombre del creador**: Autor de la publicación
- **Fecha de publicación**: Cuándo se publicó
- **Posición**: Número de orden en el blog (según creación)
- **Comentarios**: Lista de comentarios asociados

### Comentario
- **Fecha de creación**: Cuándo se hizo el comentario
- **Email del autor**: Correo del comentarista
- **Dirección IP**: IP del comentarista
- **Texto**: Contenido del comentario

## Conceptos POO implementados

- **Encapsulamiento**: Atributos privados, getters y setters
- **Herencia**: Estructura de clases relacionadas
- **Composición**: Blog contiene Publicaciones, Publicación contiene Comentarios
- **Asociaciones**: Relaciones 1 a muchos
- **Validación**: En setters y constructores
- **Colecciones**: ArrayList para publicaciones y comentarios

## Requisitos técnicos
- Java 8 o superior
- IDE: IntelliJ IDEA, Eclipse o Visual Studio Code
- Maven o Gradle (opcional)

## Estructura del proyecto

src/main/java/com/universidad/
├── Main.java - Punto de entrada del programa
├── Blog.java - Clase Blog
├── Publicacion.java - Clase Publicación
├── Comentario.java - Clase Comentario
└── excepciones/
├── BlogInvalidoException.java
├── PublicacionInvalidaException.java
└── ComentarioInvalidoException.java


## Compilación y ejecución

### Sin herramienta de compilación:
```bash
javac -d bin src/*.java
javac -d bin src/*.java
```

### Con Maven:
```bash
mvn clean compile
```

### Con Gradle:
```bash
gradle build
gradle run
```

El programa muestra un menú interactivo para:
1. Crear blogs
2. Agregar publicaciones
3. Agregar comentarios
4. Visualizar contenido
5. Buscar información

---

# DIAGRAMA CONCEPTUAL

## Representación ASCII

┌─────────────────────────────────┐
│ BLOG                            │
├─────────────────────────────────┤
│ - codigo: int                   │
│ - nombre: String                │
│ - descripcion: String           │
│ - fechaCreacion: LocalDateTime  │
└──────────────┬──────────────────┘
               │
               │ 1..*
               │ publicaciones
               │
               ▼
┌─────────────────────────────────┐
│ PUBLICACION                     │
├─────────────────────────────────┤
│ - titulo: String                │
│ - texto: String                 │
│ - nombreCreador: String         │
│ - fechaPublicacion: LocalDateTime
│ - posicion: int                 │
└──────────────┬──────────────────┘
               │
               │ 1..*
               │ comentarios
               │
               ▼
┌─────────────────────────────────┐
│ COMENTARIO                      │
├─────────────────────────────────┤
│ - fechaCreacion: LocalDateTime  │
│ - emailAutor: String            │
│ - direccionIP: String           │
│ - texto: String                 │
└─────────────────────────────────┘


## Diagrama de asociaciones

Blog (1) ──── publicaciones (0..) ──── Publicacion
▲                              │
│                              │
└─ Navegabilidad bidireccional │
                               │
Publicacion (1) ──── comentarios (0..) ──── Comentario
▲
│
└─ Navegabilidad bidireccional


---

# DIAGRAMA DE CLASES COMPLETO

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
║ + agregarPublicacion(pub: Publicacion): void           ║
║ + obtenerPublicacion(posicion: int): Publicacion       ║
║ + eliminarPublicacion(posicion: int): boolean          ║
║ + obtenerPublicaciones(): List<Publicacion>            ║
║ + contienePublicaciones(): boolean                     ║
║ + obtenerCantidadPublicaciones(): int                  ║
║ + obtenerUltimaPublicacion(): Publicacion              ║
║                                                        ║
║ + getCodigo(): int                                     ║
║ + getNombre(): String                                  ║
║ + setNombre(nombre: String): void                      ║
║ + getDescripcion(): String                             ║
║ + setDescripcion(desc: String): void                   ║
║ + getFechaCreacion(): LocalDateTime                    ║
║ + toString(): String                                   ║
╚════════════════════════════════════════════════════════╝

╔════════════════════════════════════════════════════════╗
║ PUBLICACION                                            ║
╠════════════════════════════════════════════════════════╣
║ Atributos:                                             ║
║ - titulo: String                                       ║
║ - texto: String                                        ║
║ - nombreCreador: String                                ║
║ - fechaPublicacion: LocalDateTime                      ║
║ - posicion: int                                        ║
║ - comentarios: List<Comentario>                        ║
║ - blog: Blog (referencia al blog padre)                ║
╠════════════════════════════════════════════════════════╣
║ Constructores:                                         ║
║ + Publicacion(titulo: String, texto: String,           ║
║ nombreCreador: String, posicion: int)                  ║
╠════════════════════════════════════════════════════════╣
║ Métodos:                                               ║
║ + agregarComentario(com: Comentario): void             ║
║ + obtenerComentario(indice: int): Comentario           ║
║ + eliminarComentario(indice: int): boolean             ║
║ + obtenerComentarios(): List<Comentario>               ║
║ + contieneComentarios(): boolean                       ║
║ + obtenerCantidadComentarios(): int                    ║
║                                                        ║
║ + getTitulo(): String                                  ║
║ + setTitulo(titulo: String): void                      ║
║ + getTexto(): String                                   ║
║ + setTexto(texto: String): void                        ║
║ + getNombreCreador(): String                           ║
║ + getFechaPublicacion(): LocalDateTime                 ║
║ + getPosicion(): int                                   ║
║ + getBlog(): Blog                                      ║
║ + setBlog(blog: Blog): void                            ║
║ + toString(): String                                   ║
╚════════════════════════════════════════════════════════╝

╔════════════════════════════════════════════════════════╗
║ COMENTARIO                                             ║
╠════════════════════════════════════════════════════════╣
║ Atributos:                                             ║
║ - fechaCreacion: LocalDateTime                         ║
║ - emailAutor: String                                   ║
║ - direccionIP: String                                  ║
║ - texto: String                                        ║
║ - publicacion: Publicacion (referencia padre)          ║
╠════════════════════════════════════════════════════════╣
║ Constructores:                                         ║
║ + Comentario(emailAutor: String, direccionIP: String,  ║
║ texto: String)                                         ║
╠════════════════════════════════════════════════════════╣
║ Métodos:                                               ║
║ + getFechaCreacion(): LocalDateTime                    ║
║ + getEmailAutor(): String                              ║
║ + setEmailAutor(email: String): void                   ║
║ + getDireccionIP(): String                             ║
║ + setDireccionIP(ip: String): void                     ║
║ + getTexto(): String                                   ║
║ + setTexto(texto: String): void                        ║
║ + getPublicacion(): Publicacion                        ║
║ + setPublicacion(pub: Publicacion): void               ║
║ + toString(): String                                   ║
╚════════════════════════════════════════════════════════╝


## Asociaciones y multiplicidades

Blog ────────────────────── Publicacion
1 0..*
│ contiene │ pertenece a
│ publicaciones │ blog
└────────────────────┘
(Navegabilidad bidireccional)

Publicacion ────────────────────── Comentario
1 0..*
│ contiene │ pertenece a
│ comentarios │ publicacion
└────────────────────────┘
(Navegabilidad bidireccional)


---

## Características implementadas

### Encapsulamiento
- Todos los atributos son privados
- Getters para lectura
- Setters con validación
- Control de acceso apropiado

### Composición
- Blog contiene Publicaciones
- Publicación contiene Comentarios
- Referencias bidireccionales
- Gestión automática de relaciones

### Colecciones
- ArrayList para publicaciones
- ArrayList para comentarios
- Métodos para agregar/eliminar
- Métodos para consultar

### Validación
- Validación en constructores
- Validación en setters
- Excepciones personalizadas
- Manejo de errores

### Programa principal
- Menú interactivo
- Creación de blogs
- Gestión de publicaciones
- Gestión de comentarios
- Visualización de datos
- Búsqueda y filtrado

## Notas importantes
- Se utilizó LocalDateTime para las fechas
- Se implementó composición fuerte (Blog → Publicación → Comentario)
- Se validó que los datos sean válidos
- Se usaron excepciones personalizadas
- Se siguieron convenciones de nomenclatura Java
- Se implementaron relaciones bidireccionales donde fue necesario

## Recomendaciones seguidas
1. Diagrama conceptual con cajas y asociaciones
2. Diagrama de clases completo con atributos y métodos
3. Multiplicidades correctas
4. Navegabilidad indicada
5. Encapsulamiento adecuado
6. Validación de datos
7. Manejo de excepciones
8. Estructura clara y modular

## Autor
Owel Jafet Gutiérrez Ortiz

## Profesor
Mauricio Avilés Cisneros

## Fecha de entrega
29/08/2026

## Institución
Instituto Tecnológico de Costa Rica
Escuela de Computación
Bachillerato en Ingeniería en Computación