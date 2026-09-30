/*
Instituto Tecnologico de Costa Rica

Nombre : Owel Jafet Gutierrez Ortiz

Carnet : 2026800869

Profesor : Mauricio Aviles Cisneros

Semana 9 : Tarea 3 - Sistema de Blogs

Fecha de entrega : 29 / 09 / 2026

*/

/*
Clase:
	Control: Clase controladora del sistema. Administra la coleccion de blogs
	y el consecutivo para asignar sus codigos. Encapsula las funcionalidades
	del sistema y retorna solo Strings o colecciones de Strings, nunca
	referencias a los objetos de la capa de logica.
*/
package control;

import java.util.LinkedHashMap;
import java.util.Map;

import logica.Blog;

public class Control {
	private Map<Integer, Blog> blogs;
	private int consecutivoBlog;

	public Control() {
		blogs = new LinkedHashMap<Integer, Blog>();
		consecutivoBlog = 1;
	}

	// Atributos:
	// blogs: guarda los blogs usando el codigo como llave (busqueda directa por codigo).
	// Es LinkedHashMap para mantener el orden de creacion al listarlos.
	// consecutivoBlog: siguiente codigo a asignar; empieza en 1 y sube con cada blog creado.
	// Nunca baja, asi un codigo borrado no se reutiliza.
	
	// Busca un blog por codigo. Si no existe, lanza error.
	// Todos los metodos de Control pasan por aqui, asi la validacion
	// "el blog existe" se escribe una sola vez.
	private Blog buscarBlog(int codigoBlog) {
		Blog blog = blogs.get(codigoBlog);
		if (blog == null) {
			throw new IllegalArgumentException("El blog con codigo " + codigoBlog + " no existe.");
		}
		return blog;
	}

	
	// Valida el formato del email con una expresion regular (regex).
	// Doble barra \\ porque en Java la barra invertida se escribe doble dentro de un String.
	// ^                inicio del texto
	// [\w.+-]+         una o mas letras, numeros, _ . + o - (la parte antes de @)
	// @                el arroba obligatorio
	// [\w-]+           el nombre del dominio (ej: gmail)
	// (\.[\w-]+)+      uno o mas grupos de punto + texto (ej: .com, .co.cr)
	// $                fin del texto
	private boolean emailValido(String email) {
		return email != null && email.matches("^[\\w.+-]+@[\\w-]+(\\.[\\w-]+)+$");
	}

	
	// Crea el blog con el consecutivo actual como codigo.
	// Blog valida nombre y descripcion; si lanza error, la linea de blogs.put
	// y el incremento no se ejecutan, asi el consecutivo no se gasta en blogs invalidos.
	public void crearBlog(String nombre, String descripcion) {
		// Blog valida que nombre y descripcion no sean nulos o vacios
		Blog blog = new Blog(consecutivoBlog, nombre, descripcion);
		blogs.put(consecutivoBlog, blog);
		consecutivoBlog++;
	}

	public void borrarBlog(int codigoBlog) {
		buscarBlog(codigoBlog);
		blogs.remove(codigoBlog);
	}

	// Retorna solo codigo y nombre en un Map nuevo. No se retorna la coleccion de
	// blogs ni los objetos Blog, porque el enunciado prohibe que Control
	// devuelva referencias a objetos de la capa de logica.
	public Map<Integer, String> obtenerBlogs() {
		Map<Integer, String> resultado = new LinkedHashMap<Integer, String>();
		for (Blog blog : blogs.values()) {
			resultado.put(blog.getCodigo(), blog.getNombre());
		}
		return resultado;
	}

	public void crearPublicacion(int codigoBlog, String titulo, String texto, String nombreCreador) {
		buscarBlog(codigoBlog).crearPublicacion(titulo, texto, nombreCreador);
	}

	public Map<Integer, String> obtenerPublicaciones(int codigoBlog) {
		return buscarBlog(codigoBlog).obtenerTitulosPublicaciones();
	}

	public String obtenerPublicacion(int codigoBlog, int numeroPublicacion) {
		return buscarBlog(codigoBlog).obtenerPublicacion(numeroPublicacion);
	}
	
	// Primero se comprueba que el blog exista y luego el formato del email.
	// El resto de validaciones (numero de publicacion, ip y texto no vacios)
	// las hace la capa de logica, por eso no se repiten aqui.
	public void agregarComentario(int codigoBlog, int numeroPublicacion, String email, String ip, String texto) {
		Blog blog = buscarBlog(codigoBlog);
		if (!emailValido(email)) {
			throw new IllegalArgumentException("El email no tiene un formato valido.");
		}
		blog.agregarComentario(numeroPublicacion, email, ip, texto);
	}

	public void borrarComentario(int codigoBlog, int numeroPublicacion, int posicion) {
		buscarBlog(codigoBlog).borrarComentario(numeroPublicacion, posicion);
	}
}