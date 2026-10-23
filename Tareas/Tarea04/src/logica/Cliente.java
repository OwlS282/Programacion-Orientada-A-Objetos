/*
Instituto Tecnologico de Costa Rica

Nombre : Owel Jafet Gutierrez Ortiz

Carnet : 2026800869

Profesor : Mauricio Aviles Cisneros

Semana 12 : Tarea Corta 4 - Tienda WallRose

Fecha de entrega : 22 / 10 / 2026

*/

/*
Clase Cliente:
	Clase que representa a un cliente de la tienda. Guarda su id, nombre y
	email, y mantiene las ordenes de compra asociadas a el en un mapa
	indexado por numero de orden.
*/
package logica;

import java.io.Serializable;
import java.util.HashMap;
import java.util.Map;

public class Cliente implements Serializable {
	private static final long serialVersionUID = 1L;
	private String id;
	private String nombre;
	private String email;
	private Map<Integer, Orden> ordenes = new HashMap<>();
	
	public Cliente(String id, String nombre, String email) {
		this.id = id;
		this.nombre = nombre;
		this.email = email;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getNombre() {
		return nombre;
	}

	public void setNombre(String nombre) {
		this.nombre = nombre;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}
	
	public Map<Integer, Orden> getOrdenes() {
		return ordenes;
	}
	
	public void agregarOrden(Orden orden) {
		ordenes.put(orden.getNumero(), orden);
	}
	
	public void borrarOrden(Orden orden) {
		ordenes.remove(orden.getNumero());
	}
}
