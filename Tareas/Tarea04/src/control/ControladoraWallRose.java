/*
Instituto Tecnologico de Costa Rica

Nombre : Owel Jafet Gutierrez Ortiz

Carnet : 2026800869

Profesor : Mauricio Aviles Cisneros

Semana 12 : Tarea Corta 4 - Tienda WallRose

Fecha de entrega : 22 / 10 / 2026

*/

/*
Clase ControladoraWallRose:
	Clase controladora del sistema, implementada como Singleton. Administra
	los clientes, productos y ordenes, valida los datos y las reglas del
	negocio, y guarda y carga los datos en disco mediante serializacion.
*/

package control;

import logica.Cliente;
import logica.EstadoOrden;
import logica.LineaOrden;
import logica.Orden;
import logica.Producto;

import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;

public class ControladoraWallRose implements Serializable {
	private static final long serialVersionUID = 1L;
	private static ControladoraWallRose instance = null;
	private Map<String, Cliente> clientes = new TreeMap<>();
	private Map<Integer, Orden> ordenes = new TreeMap<>();
	private Map<Integer, Producto> productos = new TreeMap<>();
	private Integer consecutivoOrden = 1;
	private Integer consecutivoProducto = 1;
	private Double IV = 0.13;

	private ControladoraWallRose() {}

	public static ControladoraWallRose getInstance() {
		if (instance == null) {
			instance = new ControladoraWallRose();
		}
		return instance;
	}

	public List<Cliente> obtenerListadoClientes() {
		return new ArrayList<>(clientes.values());
	}


	private void verificarClienteExistente(String idCliente) {
		if (!clientes.containsKey(idCliente)) {
			throw new IllegalArgumentException("Error, el cliente no existe");
		}
	}

	private void verificarClienteNoExistente(String idCliente) {
		if (clientes.containsKey(idCliente)) {
			throw new IllegalArgumentException("Error, el cliente ya existe");
		}
	}

	private boolean esEmailValido(String email) {
		return email != null && email.matches("^[\\w.+-]+@[\\w-]+(\\.[\\w-]+)+$");
	}

	private void verificarEmail(String email) {
		if (!esEmailValido(email)) {
			throw new IllegalArgumentException("Error, el email no es válido");
		}
	}

	private void verificarProductoExistente(Integer codigoProducto) {
		if (!productos.containsKey(codigoProducto)) {
			throw new IllegalArgumentException("Error, el producto no existe");
		}
	}

	private void verificarOrdenExistente(Integer numeroOrden) {
		if (!ordenes.containsKey(numeroOrden)) {
			throw new IllegalArgumentException("Error, la orden no existe");
		}
	}

	private void verificarOrdenIniciada(Orden orden) {
		if (orden.getEstado() != EstadoOrden.INICIADA) {
			throw new IllegalStateException("Error, la orden ya no se puede modificar");
		}
	}

	private void verificarCantidad(Double cantidad) {
		if (cantidad == null || cantidad <= 0) {
			throw new IllegalArgumentException("Error, la cantidad debe ser mayor que cero");
		}
	}

	private void verificarDatosProducto(String nombre, Double existencias, String unidad, Double precio) {
		if (nombre == null || nombre.isBlank() || unidad == null || unidad.isBlank()) {
			throw new IllegalArgumentException("Error, nombre y unidad son obligatorios");
		}
		if (existencias == null || existencias < 0 || precio == null || precio < 0) {
			throw new IllegalArgumentException("Error, existencias y precio no pueden ser negativos");
		}
	}

	//Clientes metodos
	
	public Cliente obtenerCliente(String idCliente) {
		verificarClienteExistente(idCliente);
		return clientes.get(idCliente);
	}

	public List<Orden> obtenerListadoOrdenesCliente(String idCliente) {
		return new ArrayList<>(obtenerCliente(idCliente).getOrdenes().values());
	}

	private List<Orden> obtenerListadoOrdenesPorEstado(String idCliente, EstadoOrden estado) {
		List<Orden> resultado = new ArrayList<>();
		for (Orden orden : obtenerListadoOrdenesCliente(idCliente)) {
			if (orden.getEstado() == estado) {
				resultado.add(orden);
			}
		}
		return resultado;
	}

	public List<Orden> obtenerListadoOrdenesIniciadasCliente(String idCliente) {
		return obtenerListadoOrdenesPorEstado(idCliente, EstadoOrden.INICIADA);
	}

	public List<Orden> obtenerListadoOrdenesPendientesCliente(String idCliente) {
		return obtenerListadoOrdenesPorEstado(idCliente, EstadoOrden.PENDIENTE);
	}

	public List<Orden> obtenerListadoOrdenesTerminadasCliente(String idCliente) {
		return obtenerListadoOrdenesPorEstado(idCliente, EstadoOrden.TERMINADA);
	}

	public void crearCliente(String idCliente, String nombre, String email) {
		verificarClienteNoExistente(idCliente);
		verificarEmail(email);
		clientes.put(idCliente, new Cliente(idCliente, nombre, email));
	}

	public void actualizarCliente(String idCliente, String nombre, String email) {
		Cliente cliente = obtenerCliente(idCliente);
		verificarEmail(email);
		cliente.setNombre(nombre);
		cliente.setEmail(email);
	}

	public void borrarCliente(String idCliente) {
		Cliente cliente = obtenerCliente(idCliente);
		if (!cliente.getOrdenes().isEmpty()) {
			throw new IllegalStateException("Error, el cliente tiene órdenes asociadas");
		}
		clientes.remove(idCliente);
	}


	public List<Producto> obtenerListadoProductos() {
		return new ArrayList<>(productos.values());
	}

	public void crearProducto(String nombre, Double existencias, String unidad, Double precio) {
		verificarDatosProducto(nombre, existencias, unidad, precio);
		Integer codigo = consecutivoProducto++;
		productos.put(codigo, new Producto(codigo, nombre, existencias, unidad, precio));
	}

	public Producto obtenerProducto(Integer codigoProducto) {
		verificarProductoExistente(codigoProducto);
		return productos.get(codigoProducto);
	}

	public void actualizarProducto(Integer codigoProducto, String nombre, Double existencias, String unidad, Double precio) {
		Producto producto = obtenerProducto(codigoProducto);
		verificarDatosProducto(nombre, existencias, unidad, precio);
		producto.setNombre(nombre);
		producto.setExistencias(existencias);
		producto.setUnidad(unidad);
		producto.setPrecio(precio);
	}

	public void borrarProducto(Integer codigoProducto) {
		verificarProductoExistente(codigoProducto);
		if (esProductoUtilizado(codigoProducto)) {
			throw new IllegalStateException("Error, el producto está siendo utilizado en órdenes");
		}
		productos.remove(codigoProducto);
	}

	public Boolean esProductoUtilizado(Integer codigoProducto) {
		for (Orden orden : ordenes.values()) {
			for (LineaOrden linea : orden.getLineas()) {
				if (linea.getProducto().getCodigo().equals(codigoProducto)) {
					return true;
				}
			}
		}
		return false;
	}

	//Ordenes metodos

	public List<Orden> obtenerListadoOrdenes() {
		return new ArrayList<>(ordenes.values());
	}

	public Double obtenerMontoTotalPendiente() {
		double total = 0.0;
		for (Orden orden : ordenes.values()) {
			if (orden.getEstado() == EstadoOrden.PENDIENTE) {
				total += orden.calcularMontoTotal();
			}
		}
		return total;
	}

	public Integer crearOrdenVacia(String idCliente) {
		Cliente cliente = obtenerCliente(idCliente);
		Orden orden = new Orden(consecutivoOrden++, cliente);
		ordenes.put(orden.getNumero(), orden);
		cliente.agregarOrden(orden);
		return orden.getNumero();
	}

	public Orden obtenerOrden(Integer numeroOrden) {
		verificarOrdenExistente(numeroOrden);
		return ordenes.get(numeroOrden);
	}

	public List<LineaOrden> obtenerLineasOrden(Integer numeroOrden) {
		return obtenerOrden(numeroOrden).getLineas();
	}

	public void establecerOrdenPendiente(Integer numeroOrden) {
		Orden orden = obtenerOrden(numeroOrden);
		verificarOrdenIniciada(orden);
		if (orden.cantidadLineas() == 0) {
			throw new IllegalStateException("Error, la orden no tiene líneas");
		}
		orden.setEstado(EstadoOrden.PENDIENTE);
	}

	public void establecerOrdenTerminada(Integer numeroOrden) {
		Orden orden = obtenerOrden(numeroOrden);
		if (orden.getEstado() != EstadoOrden.PENDIENTE) {
			throw new IllegalStateException("Error, solo una orden pendiente puede terminarse");
		}
		orden.setEstado(EstadoOrden.TERMINADA);
	}

	public void agregarLineaOrden(Integer numeroOrden, Integer codigoProducto, Double cantidad) {
		Orden orden = obtenerOrden(numeroOrden);
		verificarOrdenIniciada(orden);
		Producto producto = obtenerProducto(codigoProducto);
		verificarCantidad(cantidad);
		orden.agregarLinea(new LineaOrden(producto, cantidad));
	}

	public void actualizarLineaOrden(Integer numeroOrden, Integer numeroLinea, Integer codigoProducto, Double cantidad) {
		Orden orden = obtenerOrden(numeroOrden);
		verificarOrdenIniciada(orden);
		Producto producto = obtenerProducto(codigoProducto);
		verificarCantidad(cantidad);
		LineaOrden linea = orden.getLinea(numeroLinea);
		linea.setProducto(producto);
		linea.setCantidad(cantidad);
	}

	public void borrarLineaOrden(Integer numeroOrden, Integer numeroLinea) {
		Orden orden = obtenerOrden(numeroOrden);
		verificarOrdenIniciada(orden);
		orden.borrarLinea(numeroLinea);
	}

	public void borrarOrden(Integer numeroOrden) {
		Orden orden = obtenerOrden(numeroOrden);
		if (orden.getEstado() == EstadoOrden.TERMINADA) {
			throw new IllegalStateException("Error, no se puede borrar una orden terminada");
		}
		orden.getCliente().borrarOrden(orden);
		ordenes.remove(numeroOrden);
	}

	//Persistencia metodos

	public static void guardarDatos() throws IOException {
		FileOutputStream file = new FileOutputStream("DatosWallRose.dat");
		ObjectOutputStream stream = new ObjectOutputStream(file);
		stream.writeObject(instance);
		stream.close();
		file.close();
	}

	public static void cargarDatos() throws IOException, ClassNotFoundException {
		FileInputStream file = new FileInputStream("DatosWallRose.dat");
		ObjectInputStream stream = new ObjectInputStream(file);
		instance = (ControladoraWallRose) stream.readObject();
		stream.close();
		file.close();
	}
}