/*
Instituto Tecnologico de Costa Rica

Nombre : Owel Jafet Gutierrez Ortiz

Carnet : 2026800869

Profesor : Mauricio Aviles Cisneros

Semana 12 : Tarea Corta 4 - Tienda WallRose

Fecha de entrega : 22 / 10 / 2026

*/

/*
Clase LineaOrden:
	Clase que representa una linea de una orden de compra, formada por un
	producto y la cantidad solicitada. Calcula el costo de la linea
	(cantidad por precio del producto).
*/

package logica;

import java.io.Serializable;

public class LineaOrden implements Serializable {

	private static final long serialVersionUID = 1L;
	private Producto producto;
	private double cantidad;
	
	public LineaOrden(Producto producto, Double cantidad){
		this.producto = producto;
		this.cantidad = cantidad;
	}

	public Producto getProducto() {
		return producto;
	}

	public void setProducto(Producto producto) {
		this.producto = producto;
	}

	public double getCantidad() {
		return cantidad;
	}

	public void setCantidad(double cantidad) {
		this.cantidad = cantidad;
	}
	
	public double calcularCosto() {
		return cantidad * producto.getPrecio();
	}
}
