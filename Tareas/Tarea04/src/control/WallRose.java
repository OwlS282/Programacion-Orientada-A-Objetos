/*
Instituto Tecnologico de Costa Rica

Nombre : Owel Jafet Gutierrez Ortiz

Carnet : 2026800869

Profesor : Mauricio Aviles Cisneros

Semana 12 : Tarea Corta 4 - Tienda WallRose

Fecha de entrega : 22 / 10 / 2026

*/

/*
Clase WallRose:
	Clase principal. Programa de demostracion en consola que agrega clientes
	y productos de ejemplo, crea una orden con varias lineas, guarda y carga
	los datos de disco, e imprime la informacion para comprobar que funciona.
*/


package control;

import java.io.IOException;

import logica.Cliente;
import logica.LineaOrden;
import logica.Orden;
import logica.Producto;

public class WallRose {

	public static void main(String[] args) {
		try {
			ControladoraWallRose controladora = ControladoraWallRose.getInstance();

			// Clientes de ejemplo
			controladora.crearCliente("1", "Ana Mora", "ana@correo.com");
			controladora.crearCliente("2", "Luis Rojas", "luis@correo.com");
			controladora.crearCliente("3", "Sofía Vargas", "sofia@correo.com");

			// Productos de ejemplo
			controladora.crearProducto("Camiseta", 50.0, "unidad", 8500.0);
			controladora.crearProducto("Tela de algodón", 120.5, "metro", 3200.0);
			controladora.crearProducto("Hilo", 300.0, "carrete", 750.0);

			// Orden de compra con varias líneas
			Integer numeroOrden = controladora.crearOrdenVacia("1");
			controladora.agregarLineaOrden(numeroOrden, 1, 2.0);
			controladora.agregarLineaOrden(numeroOrden, 2, 3.5);
			controladora.agregarLineaOrden(numeroOrden, 3, 10.0);
			controladora.establecerOrdenPendiente(numeroOrden);

			// Guardar datos en disco
			ControladoraWallRose.guardarDatos();
			System.out.println("Datos guardados en disco.");

			// Cargar datos de disco
			ControladoraWallRose.cargarDatos();
			controladora = ControladoraWallRose.getInstance();
			System.out.println("Datos cargados de disco.");

			// Imprimir datos para comprobar
			imprimirDatos(controladora);

		} catch (IOException | ClassNotFoundException e) {
			System.out.println("Error de persistencia: " + e.getMessage());
		} catch (RuntimeException e) {
			System.out.println(e.getMessage());
		}
	}

	private static void imprimirDatos(ControladoraWallRose controladora) {
		System.out.println();
		System.out.println("Agregamos Clientes: ");
		for (Cliente c : controladora.obtenerListadoClientes()) {
			double totalPendiente = 0.0;
			for (Orden o : controladora.obtenerListadoOrdenesPendientesCliente(c.getId())) {
				totalPendiente += o.calcularMontoTotal();
			}
			System.out.printf("%s | %s | %s | pendiente: %.2f%n",
					c.getId(), c.getNombre(), c.getEmail(), totalPendiente);
		}

		System.out.println();
		System.out.println("Agregamos Productos: ");
		for (Producto p : controladora.obtenerListadoProductos()) {
			System.out.printf("%d | %s | %.2f %s | %.2f%n",
					p.getCodigo(), p.getNombre(), p.getExistencias(), p.getUnidad(), p.getPrecio());
		}

		System.out.println();
		System.out.println("Agregamos a la orden: ");
		for (Orden o : controladora.obtenerListadoOrdenes()) {
			System.out.printf("Orden %d | %s | %s | cliente %s - %s%n",
					o.getNumero(), o.getFecha(), o.getEstado(), o.getCliente().getId(), o.getCliente().getNombre());
			int n = 1;
			for (LineaOrden l : controladora.obtenerLineasOrden(o.getNumero())) {
				System.out.printf("  %d. %d | %s | %.2f %s | costo %.2f%n",
						n++, l.getProducto().getCodigo(), l.getProducto().getNombre(),
						l.getCantidad(), l.getProducto().getUnidad(), l.calcularCosto());
			}
			System.out.printf("  Monto: %.2f | Impuesto: %.2f | Total: %.2f%n",
					o.calcularMonto(), o.calcularMontoImpuesto(), o.calcularMontoTotal());
		}
		System.out.printf("%nMonto total pendiente: %.2f%n", controladora.obtenerMontoTotalPendiente());
	}
}