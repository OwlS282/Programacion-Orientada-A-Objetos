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
Clase Principal:
	Es la clase de interfaz de consola. Se encarga de mostrar el menú, leer lo que escribe el usuario, y traducir esas acciones en llamadas a SistemaTiquetes.
	También maneja los errores con try/catch para que el programa nunca se cierre inesperadamente.
*/


package interfaz;

import logica.Tiquete;
import logica.SistemaTiquetes;
import java.util.Scanner;

public class Principal {
	private SistemaTiquetes sistema;
	private Scanner scanner;
	
	public Principal() {
		super();
		this.sistema = new SistemaTiquetes();
		this.scanner = new Scanner(System.in);
	}
	
	//ciclamos el menu
	public void iniciar() {
		boolean salir = false;
		
		while (!salir) {
			mostrarEstado();
			mostrarMenu();
			
			try {
				int opcion = obtenerOpcion();
				
				switch (opcion) {
					case 1:
						agregarCliente();
						break;
					case 2:
						agregarTiquete();
						break;
					case 3:
						atenderTiquete();
						break;
					case 4:
						descartarTiquete();
						break;
					case 5:
						limpiarHistorial();
						break;
					case 6:
						salir = true;
						System.out.println("¡Hasta luego!");
						break;
					default:
						System.out.println("Error: Opción inválida. Intente de nuevo.");
						System.out.println(" ");
				}
			} catch (Exception e) {
				//agarramos el error y lo mostramos
				System.out.println("Error: " + e.getMessage() + "\n");
			}
		}
		
		scanner.close();
	}
	
	//muestra el estado actual de los clientes, cola tiquetes y mostrar historial
	private void mostrarEstado() {
		System.out.println(sistema.mostrarClientes());
		System.out.println(sistema.mostrarColaTiquetes());
		System.out.println(sistema.mostrarHistorial());
	}
	
	private void mostrarMenu() {
		
		System.out.println("\nMENÚ PRINCIPAL");
		System.out.println("1. Agregar cliente");
		System.out.println("2. Agregar tiquete a la cola");
		System.out.println("3. Atender siguiente tiquete");
		System.out.println("4. Descartar siguiente tiquete");
		System.out.println("5. Limpiar historial");
		System.out.println("6. Salir");
		System.out.print("Seleccione una opción: ");
	}
	
	//leemos la opcion y la convertimos a numero
	private int obtenerOpcion() throws Exception {
		try {
			int opcion = Integer.parseInt(scanner.nextLine().trim());
			return opcion;
		} catch (NumberFormatException e) {
			throw new Exception("Error, debe ingresar un número válido.");
		}
	}
	
	//pedimos el id, nombre y lo guardamos
	private void agregarCliente() throws Exception {
		System.out.print("Ingrese el ID del cliente: ");
		String id = scanner.nextLine().trim();
		
		System.out.print("Ingrese el nombre del cliente: ");
		String nombre = scanner.nextLine().trim();
		
		if (nombre.isEmpty()) {
			throw new Exception("El nombre no puede estar vacío.");
		}
		
		sistema.agregarCliente(id, nombre);
		System.out.println("Cliente agregado.\n");
	}
	
	//pedimos el id para crear un tiquete
	private void agregarTiquete() throws Exception {
		System.out.print("Ingrese el ID del cliente: ");
		String idCliente = scanner.nextLine().trim();
		
		sistema.agregarTiquete(idCliente);
		System.out.println("Tiquete agregado a la cola.\n");
	}
	
	//atendemos el siguiente tiquete de la cola y lo mostramos en pantalla
	private void atenderTiquete() throws Exception {
		Tiquete tiquete = sistema.atenderTiquete();
		System.out.println("Atendiendo: " + tiquete.toString());
		System.out.println("Tiquete agregado al historial.\n");
	}
	
	//descartamos el siguiente tiquete de la cola lo mostramos
	private void descartarTiquete() throws Exception {
		Tiquete tiquete = sistema.descartarTiquete();
		System.out.println("Tiquete descartado: " + tiquete.toString());
		System.out.println("Este tiquete NO fue agregado al historial.\n");
	}
	
	//vaciamos el historial de tiquetes
	private void limpiarHistorial() throws Exception {
		sistema.limpiarHistorial();
		System.out.println("Historial de tiquetes limpiado.\n");
	}
	
	public static void main(String[] args) {
		Principal principal = new Principal();
		principal.iniciar();
	}
}
