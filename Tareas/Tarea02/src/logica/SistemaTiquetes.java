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
Clase SistemaTiquetes:
	Contiene las tres colecciones principales el diccionario de clientes (Map), la cola de tiquetes pendientes (Queue)
	y el historial de tiquetes atendidos (List) y todos los métodos para agregar, atender, descartar y limpiar.
*/

package logica;

import java.util.Map;        // diccionario de clientes
import java.util.HashMap;    // implementación de Map
import java.util.Queue;      // cola de tiquetes
import java.util.LinkedList; // implementación de Queue y List
import java.util.List;       // historial de tiquetes

public class SistemaTiquetes {
	//diccionario de clientes
	private Map<String, Cliente> clientes;
	//cola de tiquetes
	private Queue<Tiquete> colaTiquetes;
	// historialde tiquetes
	private List<Tiquete> historialTiquetes;
	
	public SistemaTiquetes() {
		this.clientes = new HashMap<>();
		this.colaTiquetes = new LinkedList<>();
		this.historialTiquetes = new LinkedList<>();
	}
	
	//metodo de agregar cliente nuevo al diccionario
	public void agregarCliente(String id, String nombre) throws Exception {
		if (clientes.containsKey(id)) {
			throw new Exception("Error, cliente ya existe en el sistema.");
		}
		Cliente nuevoCliente = new Cliente(id, nombre);
		clientes.put(id, nuevoCliente);
	}
	
	//creamos un tiquete para un clientes existente
	public void agregarTiquete(String idCliente) throws Exception {
		if (!clientes.containsKey(idCliente)) {
			throw new Exception("Error, cliente no encontrado.");
		}
		Tiquete nuevoTiquete = new Tiquete(idCliente);
		colaTiquetes.add(nuevoTiquete);
	}
	
	//sacamos el primer tiquete de la cola y lo agregamos al historial
	public Tiquete atenderTiquete() throws Exception {
		if (colaTiquetes.isEmpty()) {
			throw new Exception("Error, la cola de tiquetes está vacía.");
		}
		Tiquete tiquete = colaTiquetes.poll();
		historialTiquetes.add(tiquete);
		return tiquete;
	}
	
	//sacamos el primer tiquete de la cola y no se agrega al historial
	public Tiquete descartarTiquete() throws Exception {
		if (colaTiquetes.isEmpty()) {
			throw new Exception("Error, la cola de tiquetes está vacía.");
		}
		Tiquete tiquete = colaTiquetes.poll();
		return tiquete;
	}
	
	//eliminamos todos los tiquetes del historial
	public void limpiarHistorial() {
		historialTiquetes.clear();
	}
	
	public Map<String, Cliente> getClientes() {
		return clientes;
	}
	
	public Queue<Tiquete> getColaTiquetes() {
		return colaTiquetes;
	}
	
	public List<Tiquete> getHistorialTiquetes() {
		return historialTiquetes;
	}
	
	//metodo para mostrar los clientes
	public String mostrarClientes() {
		return "Clientes registrados:\n" + clientes.toString();
	}

	//metodo para mostrar la cola de tiquetes
	public String mostrarColaTiquetes() {
		return "Cola de atención:\n" + colaTiquetes.toString();
	}

	//metodo para mostrar el historial
	public String mostrarHistorial() {
		return "Historial de tiquetes:\n" + historialTiquetes.toString();
	}
	
	@Override
	public String toString() {
		return "SistemaTiquetes [clientes=" + clientes + ", colaTiquetes=" + colaTiquetes 
			+ ", historialTiquetes=" + historialTiquetes + "]";
	}
	
}
