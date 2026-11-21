/*
Instituto Tecnologico de Costa Rica

Nombre : Owel Jafet Gutierrez Ortiz

Carnet : 2026800869

Profesor : Mauricio Aviles Cisneros

Semana 16 : Tarea Corta 6 - Juego de Nave

Fecha de entrega : 19 / 11 / 2026
*/

/*
Interfaz : MoveStrategy
	Estrategia (patron Strategy) que define como se mueve un enemigo cada vez que
	decide moverse (cada stepFreq ciclos). Cada implementacion aplica fuerzas al enemigo.
*/

// Interfaz que implementan todas las estrategias de movimiento.
public interface MoveStrategy {

  // Realiza un movimiento del enemigo indicado.
  void move(EnemyShip e);
}
