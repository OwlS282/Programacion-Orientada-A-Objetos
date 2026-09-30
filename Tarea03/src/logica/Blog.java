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
	Blog: Representa un blog con codigo, nombre, descripcion y fecha de creacion.
	Administra la lista de publicaciones del blog, las cuales se guardan en el
	orden en que se crean y se identifican por su posicion (empezando en 1).
*/

package logica;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class Blog {
	private int codigo;
	private String nombre;
	private String descripcion;
	private LocalDateTime fechaCreacion;
	private List<Publicacion> publicaciones;
	
	public Blog(int codigo, String nombre, String descripcion) {
		validarTexto(nombre, "El nombre del blog");
		validarTexto(descripcion, "La descripcion del blog");
		this.codigo = codigo;
		this.nombre = nombre;
		this.descripcion = descripcion;
		this.fechaCreacion = LocalDateTime.now();
		this.publicaciones = new ArrayList<Publicacion>();
	}
	
	/*
	Revisa que un texto no sea null ni vacio (ni solo espacios).
	trim() quita los espacios de los extremos, asi "   " tambien se rechaza.
	Se lanza IllegalArgumentException porque es un error del dato recibido.
	*/
	private static void validarTexto(String valor, String campo) {
		if (valor == null || valor.trim().isEmpty()) {
			throw new IllegalArgumentException(campo + " no puede ser nulo o vacio.");
		}
	}
	
	/*
	Busca una publicacion por su numero. El usuario cuenta desde 1,
	pero la lista (ArrayList) cuenta desde 0, por eso se usa numero - 1.
	Si el numero esta fuera del rango 1..cantidad de publicaciones, lanza error.
	Todos los metodos que reciben un numero de publicacion pasan por aqui,
	asi la validacion queda en un solo lugar.
	*/
	private Publicacion buscarPublicacion(int numeroPublicacion) {
		if (numeroPublicacion < 1 || numeroPublicacion > publicaciones.size()) {
			throw new IllegalArgumentException("El numero de publicacion " + numeroPublicacion + " no es valido.");
		}
		return publicaciones.get(numeroPublicacion - 1);
	}

	public int getCodigo() {
		return codigo;
	}

	public void setCodigo(int codigo) {
		this.codigo = codigo;
	}

	public String getNombre() {
		return nombre;
	}

	public void setNombre(String nombre) {
		validarTexto(nombre, "El nombre del blog");
		this.nombre = nombre;
	}

	public String getDescripcion() {
		return descripcion;
	}

	public void setDescripcion(String descripcion) {
		validarTexto(descripcion, "La descripcion del blog");
		this.descripcion = descripcion;
	}

	public LocalDateTime getFechaCreacion() {
		return fechaCreacion;
	}

	public void setFechaCreacion(LocalDateTime fechaCreacion) {
		this.fechaCreacion = fechaCreacion;
	}
	
	public void crearPublicacion(String titulo, String texto, String nombreCreador) {
		publicaciones.add(new Publicacion(titulo, texto, nombreCreador));
	}
	
	public String obtenerPublicacion(int numeroPublicacion) {
		return buscarPublicacion(numeroPublicacion).toString();
	}
	
	/*
	Devuelve un Map con numero de publicacion (llave) y titulo (valor).
	Se usa LinkedHashMap para que el Map conserve el orden en que se insertan
	los datos (un HashMap normal podria devolverlos en desorden).
	Se crea un Map nuevo para no entregar referencias a los objetos internos.
	*/
	public Map<Integer, String> obtenerTitulosPublicaciones() {
		Map<Integer, String> titulos = new LinkedHashMap<Integer, String>();
		for (int i = 0; i < publicaciones.size(); i++) {
			titulos.put(i + 1, publicaciones.get(i).getTitulo());
		}
		return titulos;
	}
	
	/*
	Este metodo solo busca la publicacion (validando el numero)
	y le pide a esa publicacion que agregue el comentario.
	*/
	public void agregarComentario(int numeroPublicacion, String email, String ip, String texto) {
		buscarPublicacion(numeroPublicacion).agregarComentario(email, ip, texto);
	}
	
	public void borrarComentario(int numeroPublicacion, int posicion) {
		buscarPublicacion(numeroPublicacion).borrarComentario(posicion);
	}
	
	
}
