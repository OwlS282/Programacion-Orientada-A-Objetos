/*
Instituto Tecnológico de Costa Rica

Nombre : Owel Jafet Gutiérrez Ortiz

Carnet : 2026800869

Profesor : Mauricio Avilés Cisneros

Curso : Programación Orientada a Objetos

Semana 6 : Tarea Corta 2 – Manejo de Colecciones

Fecha de entrega : 08 / 09 / 2026

*/

/*
Clase Cliente:
	Representa a un cliente del sistema. Guarda su ID y nombre, valida que el ID solo contenga números y guiones.
*/

package logica;

public class Cliente {
	private String id;
	private String nombre;
	
    public Cliente(String id, String nombre) throws Exception {
    	
        if (!esIdValido(id)) {
            throw new Exception("Error, ID debe contener solo números y guiones.");
        }
        this.id = id;
        this.nombre = nombre;
        
    }

    //getters and setters
    
	public String getId() {
		return id;
	}

	public void setId(String id) throws Exception {
		if (!esIdValido(id)) {
			throw new Exception("Error, ID debe contener solo números y guiones.");
		}
		this.id = id;
	}

	public String getNombre() {
		return nombre;
	}

	public void setNombre(String nombre) {
		this.nombre = nombre;
	}
	
	//validacion de id
	private boolean esIdValido(String id) {
		return id != null && id.matches("^[0-9-]+$") && !id.isEmpty();
	}

	@Override
	public String toString() {
		return "Cliente(" + id + ", " + nombre + ")";
	}

	
}
