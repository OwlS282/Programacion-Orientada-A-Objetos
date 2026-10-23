/*
Instituto Tecnologico de Costa Rica

Nombre : Owel Jafet Gutierrez Ortiz

Carnet : 2026800869

Profesor : Mauricio Aviles Cisneros

Semana 12 : Tarea Corta 4 - Tienda WallRose

Fecha de entrega : 22 / 10 / 2026

*/

/*
Clase Orden:
	Clase que representa una orden de compra de un cliente. Tiene numero,
	fecha, estado y una lista de lineas. Calcula el monto, el impuesto (13%)
	y el monto total, y administra sus lineas (agregar, obtener y borrar).
*/

package logica;

import java.io.Serializable;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class Orden implements Serializable {
	private static final long serialVersionUID = 1L;
	private static final double IMPUESTO = 0.13;
	private Integer numero;
	private LocalDate fecha;
	private EstadoOrden estado;
	private Cliente cliente;
	private List<LineaOrden> lineas = new ArrayList<>();

	public Orden(Integer numero, Cliente cliente) {
		this.numero = numero;
		//this.fecha = fecha;
		this.cliente = cliente;
		this.fecha = LocalDate.now();
		this.estado = EstadoOrden.INICIADA;
	}

	public Integer getNumero() {
		return numero;
	}

	public void setNumero(Integer numero) {
		this.numero = numero;
	}

	public LocalDate getFecha() {
		return fecha;
	}

	public void setFecha(LocalDate fecha) {
		this.fecha = fecha;
	}

	public EstadoOrden getEstado() {
		return estado;
	}

	public void setEstado(EstadoOrden estado) {
		this.estado = estado;
	}

	public Cliente getCliente() {
		return cliente;
	}

	public void setCliente(Cliente cliente) {
		this.cliente = cliente;
	}

	public List<LineaOrden> getLineas() {
		return lineas;
	}

	public void setLineas(List<LineaOrden> lineas) {
		this.lineas = lineas;
	}

	public double calcularMonto() {
		double monto = 0.0;
		for (LineaOrden linea : lineas) {
			monto += linea.calcularCosto();
		}
		return monto;
	}
	
	public double calcularMontoImpuesto() {
		return calcularMonto() * IMPUESTO;
	}
	
	public double calcularMontoTotal() {
		return calcularMonto() + calcularMontoImpuesto();
	}
	
	public void agregarLinea(LineaOrden linea) {
		lineas.add(linea);
	}
	
	public void borrarLinea(Integer numeroLinea) {
		validarNumeroLinea(numeroLinea);
		lineas.remove(numeroLinea - 1);
	}
	
	public Integer cantidadLineas() {
		return lineas.size();
	}
	
	public LineaOrden getLinea(Integer numeroLinea) {
		validarNumeroLinea(numeroLinea);
		return lineas.get(numeroLinea - 1);
	}
	
	private void validarNumeroLinea(Integer numeroLinea) {
		if (numeroLinea == null || numeroLinea < 1 || numeroLinea > lineas.size()) {
			throw new IllegalArgumentException("La línea " + numeroLinea + " no existe en la orden " + numero);
		}
	}
}
