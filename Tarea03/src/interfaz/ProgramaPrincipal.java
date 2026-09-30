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
	Programa Principal: Aplicacion de consola para administrar blogs, publicaciones y comentarios.
	Se encarga de mostrar el menu, leer los datos del usuario, invocar los
	metodos de la clase Control y mostrar los resultados o errores.
*/

package interfaz;

import java.util.Map;
import java.util.Scanner;

import control.Control;


// Ciclo principal: muestra el menu y ejecuta la opcion hasta que el usuario elige 0.
// El try/catch esta DENTRO del ciclo: si una operacion falla (por ejemplo, un blog
// que no existe), se imprime el error y el menu vuelve a aparecer en lugar
// de cerrar el programa.
// Solo se atrapa IllegalArgumentException porque es la que lanzan Control y la logica.
public class ProgramaPrincipal {
	private static Scanner scanner = new Scanner(System.in);
	private static Control control = new Control();

	public static void main(String[] args) {
		int opcion = -1;
		while (opcion != 0) {
			mostrarMenu();
			opcion = leerEntero("Opcion: ");
			try {
				switch (opcion) {
				case 1:
					crearBlog();
					break;
				case 2:
					borrarBlog();
					break;
				case 3:
					listarBlogs();
					break;
				case 4:
					crearPublicacion();
					break;
				case 5:
					listarPublicaciones();
					break;
				case 6:
					verPublicacion();
					break;
				case 7:
					agregarComentario();
					break;
				case 8:
					borrarComentario();
					break;
				case 0:
					System.out.println("Hasta luego!");
					break;
				default:
					System.out.println("Opcion invalida.");
				}
			} catch (IllegalArgumentException e) {
				System.out.println("Error: " + e.getMessage());
			}
		}
	}

	private static void mostrarMenu() {
		System.out.println("\n-------- Sistema de Blogs --------");
		System.out.println("1. Crear blog");
		System.out.println("2. Borrar blog");
		System.out.println("3. Listar blogs");
		System.out.println("4. Crear publicacion");
		System.out.println("5. Listar publicaciones de un blog");
		System.out.println("6. Ver una publicacion");
		System.out.println("7. Agregar comentario");
		System.out.println("8. Borrar comentario");
		System.out.println("0. Salir");
	}

	private static String leerTexto(String mensaje) {
		System.out.print(mensaje);
		return scanner.nextLine();
	}

	
	// Lee un numero entero de forma segura. Se lee toda la linea con nextLine()
	// (en lugar de nextInt()) para no dejar un salto de linea pendiente en el
	// buffer, lo que causa que la siguiente lectura de texto salga vacia.
	// Si el usuario escribe algo que no es numero, parseInt lanza NumberFormatException,
	// se avisa y el ciclo while(true) vuelve a pedir el dato hasta que sea valido.
	private static int leerEntero(String mensaje) {
		while (true) {
			System.out.print(mensaje);
			String linea = scanner.nextLine();
			try {
				return Integer.parseInt(linea.trim());
			} catch (NumberFormatException e) {
				System.out.println("Error: debe ingresar un numero entero.");
			}
		}
	}

	private static void crearBlog() {
		System.out.println("\n--- Crear blog ---");
		String nombre = leerTexto("Nombre: ");
		String descripcion = leerTexto("Descripcion: ");
		control.crearBlog(nombre, descripcion);
		System.out.println("Blog creado correctamente.");
	}

	private static void borrarBlog() {
		System.out.println("\n--- Borrar blog ---");
		int codigo = leerEntero("Codigo del blog: ");
		control.borrarBlog(codigo);
		System.out.println("Blog borrado correctamente.");
	}

	
	// Recorre el Map que devuelve Control. entrySet() da cada pareja llave-valor
	// (Map.Entry): getKey() es el codigo del blog y getValue() es su nombre.
	// Antes del ciclo se avisa si el Map esta vacio.
	private static void listarBlogs() {
		System.out.println("\n--- Blogs ---");
		Map<Integer, String> blogs = control.obtenerBlogs();
		if (blogs.isEmpty()) {
			System.out.println("No hay blogs creados.");
		}
		for (Map.Entry<Integer, String> entrada : blogs.entrySet()) {
			System.out.println(entrada.getKey() + ". " + entrada.getValue());
		}
	}

	private static void crearPublicacion() {
		System.out.println("\n--- Crear publicacion ---");
		int codigo = leerEntero("Codigo del blog: ");
		String titulo = leerTexto("Titulo: ");
		String texto = leerTexto("Texto: ");
		String creador = leerTexto("Nombre del creador: ");
		control.crearPublicacion(codigo, titulo, texto, creador);
		System.out.println("Publicacion creada correctamente.");
	}

	private static void listarPublicaciones() {
		System.out.println("\n--- Publicaciones ---");
		int codigo = leerEntero("Codigo del blog: ");
		Map<Integer, String> publicaciones = control.obtenerPublicaciones(codigo);
		if (publicaciones.isEmpty()) {
			System.out.println("El blog no tiene publicaciones.");
		}
		for (Map.Entry<Integer, String> entrada : publicaciones.entrySet()) {
			System.out.println(entrada.getKey() + ". " + entrada.getValue());
		}
	}

	private static void verPublicacion() {
		System.out.println("\n--- Ver publicacion ---");
		int codigo = leerEntero("Codigo del blog: ");
		int numero = leerEntero("Numero de publicacion: ");
		System.out.println();
		System.out.println(control.obtenerPublicacion(codigo, numero));
	}

	private static void agregarComentario() {
		System.out.println("\n--- Agregar comentario ---");
		int codigo = leerEntero("Codigo del blog: ");
		int numero = leerEntero("Numero de publicacion: ");
		String email = leerTexto("Email: ");
		String ip = leerTexto("Direccion IP: ");
		String texto = leerTexto("Comentario: ");
		control.agregarComentario(codigo, numero, email, ip, texto);
		System.out.println("Comentario agregado correctamente.");
	}

	private static void borrarComentario() {
		System.out.println("\n--- Borrar comentario ---");
		int codigo = leerEntero("Codigo del blog: ");
		int numero = leerEntero("Numero de publicacion: ");
		int posicion = leerEntero("Posicion del comentario: ");
		control.borrarComentario(codigo, numero, posicion);
		System.out.println("Comentario borrado correctamente.");
	}
}