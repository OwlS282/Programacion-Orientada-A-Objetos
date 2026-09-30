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
	Publicacion: Representa una publicacion de un blog con titulo, texto,
	nombre del creador y fecha de publicacion.
	Administra la lista de comentarios asociados a la publicacion.
*/
package logica;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

public class Publicacion {
	private String titulo;
	private String texto;
	private String nombreCreador;
	private LocalDateTime fechaPublicacion;
	private List<Comentario> comentarios;
	
	public Publicacion(String titulo, String texto, String nombreCreador) {
		validarTexto(titulo, "El titulo");
		validarTexto(texto, "El texto");
		validarTexto(nombreCreador, "El nombre del creador");
		this.titulo = titulo;
		this.texto = texto;
		this.nombreCreador = nombreCreador;
		this.fechaPublicacion = LocalDateTime.now();
		this.comentarios = new ArrayList<Comentario>();
	}
	
	private static void validarTexto(String valor, String campo) {
		if (valor == null || valor.trim().isEmpty()) {
			throw new IllegalArgumentException(campo + " no puede ser nulo o vacio.");
		}
	}
	
	public String getTitulo() {
		return titulo;
	}
	
	public void setTitulo(String titulo) {
		this.titulo = titulo;
	}
	
	public String getTexto() {
		return texto;
	}
	
	public void setTexto(String texto) {
		this.texto = texto;
	}
	
	public String getNombreCreador() {
		return nombreCreador;
	}
	
	public void setNombreCreador(String nombreCreador) {
		this.nombreCreador = nombreCreador;
	}
	
	public LocalDateTime getFechaPublicacion() {
		return fechaPublicacion;
	}
	
	public void setFechaPublicacion(LocalDateTime fechaPublicacion) {
		this.fechaPublicacion = fechaPublicacion;
	}
	
	/*
	Construye un String legible con toda la informacion de la publicacion.
	StringBuilder es mas eficiente que concatenar Strings con + dentro de un ciclo.
	El formato "dd/MM/yyyy HH:mm" convierte la fecha a algo como 30/09/2026 03:27.
	 */
	@Override
	public String toString() {
		DateTimeFormatter formato = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
		StringBuilder resultado = new StringBuilder();
		resultado.append("Titulo: ").append(titulo).append("\n");
		resultado.append("Creador: ").append(nombreCreador).append("\n");
		resultado.append("Fecha de publicacion: ").append(fechaPublicacion.format(formato)).append("\n");
		resultado.append("Texto: ").append(texto).append("\n");
		resultado.append("Comentarios (").append(comentarios.size()).append("):");
		// Si no hay comentarios se muestra un mensaje en lugar de dejarlo en blanco
		if (comentarios.isEmpty()) {
			resultado.append("\n  (sin comentarios)");
		}
		
		// Se numeran los comentarios desde 1, igual que la posicion que se pide
		// al borrar, asi el usuario sabe que numero escribir.
		for (int i = 0; i < comentarios.size(); i++) {
			resultado.append("\n  ").append(i + 1).append(". ").append(comentarios.get(i));
		}
		return resultado.toString();
	}
	
	public void agregarComentario(String email, String ip, String texto) {
		comentarios.add(new Comentario(email, ip, texto));
	}
	
	// Borra el comentario en la posicion indicada (contando desde 1).
	// Se valida el rango antes de borrar y se resta 1 para obtener el indice real.
	public void borrarComentario(int posicion) {
		if (posicion < 1 || posicion > comentarios.size()) {
			throw new IllegalArgumentException("La posicion de comentario " + posicion + " no es valida.");
		}
		comentarios.remove(posicion - 1);
	}
	
}
