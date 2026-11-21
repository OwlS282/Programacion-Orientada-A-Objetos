/*
Instituto Tecnologico de Costa Rica

Nombre : Owel Jafet Gutierrez Ortiz

Carnet : 2026800869

Profesor : Mauricio Aviles Cisneros

Semana 16 : Tarea Corta 6 - Juego de Nave

Fecha de entrega : 19 / 11 / 2026
*/

/*
Interfaz : BorderStrategy
	Estrategia (patron Strategy) que define la interaccion de una nave con los
	bordes de la pantalla. Se invoca en cada ciclo, despues de actualizar la fisica.
*/

// Interfaz que implementan todas las estrategias de bordes.
public interface BorderStrategy {

  // Aplica la regla de bordes sobre el objeto indicado.
  void apply(GameObject o);
}
