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
Clase Tiquete:
	Representa un tiquete de atención. Guarda su código (número consecutivo autoasignado) y el ID del cliente que lo generó.
*/

package logica;

public class Tiquete {
	private int codigo;
	private String idCliente;
	private static int consecutivo = 100;

	public Tiquete(String idCliente) throws Exception {
		if (!esIdValido(idCliente)) {
			throw new Exception("Error, ID del cliente es inválido.");
		}
		this.codigo = consecutivo;
		consecutivo++;
		this.idCliente = idCliente;
	}

	//getters and setters
	
	public int getCodigo() {
		return codigo;
	}

	public void setCodigo(int codigo) {
		this.codigo = codigo;
	}

	public String getIdCliente() {
		return idCliente;
	}

	public void setIdCliente(String idCliente) throws Exception {
		if (!esIdValido(idCliente)) {
			throw new Exception("Error, ID del cliente es inválido.");
		}
		this.idCliente = idCliente;
	}
	
	//metodo para validar id
	private boolean esIdValido(String id) {
		return id != null && id.matches("^[0-9-]+$") && !id.isEmpty();
	}

	@Override
	public String toString() {
		return "Tiquete(" + codigo + ", " + idCliente + ")";
	}
	
}
