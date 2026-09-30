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
	Comentario: Representa un comentario de un usuario en una publicacion,
	con fecha de creacion, email del autor, direccion IP y texto.
*/

package logica;
 
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class Comentario {
	private LocalDateTime fechaCreacion;
	private String email;
	private String ip;
	private String texto;
	
	public Comentario(String email, String ip, String texto) {
		validarTexto(email, "El email");
		validarTexto(ip, "La direccion IP");
		validarTexto(texto, "El texto del comentario");
		this.fechaCreacion = LocalDateTime.now();
		this.email = email;
		this.ip = ip;
		this.texto = texto;
	}
	
	private static void validarTexto(String valor, String campo) {
		if (valor == null || valor.trim().isEmpty()) {
			throw new IllegalArgumentException(campo + " no puede ser nulo o vacio.");
		}
	}
	
	
	public LocalDateTime getFechaCreacion() {
		return fechaCreacion;
	}
	
	public void setFechaCreacion(LocalDateTime fechaCreacion) {
		this.fechaCreacion = fechaCreacion;
	}
	
	public String getEmail() {
		return email;
	}
	
	public void setEmail(String email) {
		this.email = email;
	}
	
	public String getIp() {
		return ip;
	}
	
	public void setIp(String ip) {
		this.ip = ip;
	}
	
	public String getTexto() {
		return texto;
	}
	
	public void setTexto(String texto) {
		this.texto = texto;
	}
	
	// Devuelve el comentario en una sola linea con este formato:
	// [30/09/2026 03:27] correo@ejemplo.com (IP: 192.168.0.1): texto del comentario
	// Publicacion.toString() llama a este metodo para cada comentario de su lista.
	@Override
	public String toString() {
		DateTimeFormatter formato = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
		return "[" + fechaCreacion.format(formato) + "] " + email + " (IP: " + ip + "): " + texto;
	}
}
