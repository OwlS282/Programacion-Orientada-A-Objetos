/*
Instituto Tecnologico de Costa Rica

Nombre : Owel Jafet Gutierrez Ortiz

Carnet : 2026800869

Profesor : Mauricio Aviles Cisneros

Semana 12 : Tarea Corta 4 - Tienda WallRose

Fecha de entrega : 22 / 10 / 2026

*/

/*
Clase Producto:
	Clase que representa un producto de la tienda con su codigo, nombre,
	existencias, unidad de medida y precio.
*/

package logica;

import java.io.Serializable;

public class Producto implements Serializable {
	private static final long serialVersionUID = 1L;
	private Integer codigo;
	private String nombre;
	private Double existencias;
	private String unidad;
	private Double precio;
	
	public Producto(Integer codigo, String nombre, Double existencias, String unidad, Double precio) {
		this.codigo = codigo;
		this.nombre = nombre;
		this.existencias = existencias;
		this.unidad = unidad;
		this.precio = precio;
	}

	public Integer getCodigo() {
		return codigo;
	}

	public void setCodigo(Integer codigo) {
		this.codigo = codigo;
	}

	public String getNombre() {
		return nombre;
	}

	public void setNombre(String nombre) {
		this.nombre = nombre;
	}

	public Double getExistencias() {
		return existencias;
	}

	public void setExistencias(Double existencias) {
		this.existencias = existencias;
	}

	public String getUnidad() {
		return unidad;
	}

	public void setUnidad(String unidad) {
		this.unidad = unidad;
	}

	public Double getPrecio() {
		return precio;
	}

	public void setPrecio(Double precio) {
		this.precio = precio;
	}

}
