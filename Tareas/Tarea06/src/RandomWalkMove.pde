/*
Instituto Tecnologico de Costa Rica

Nombre : Owel Jafet Gutierrez Ortiz

Carnet : 2026800869

Profesor : Mauricio Aviles Cisneros

Semana 16 : Tarea Corta 6 - Juego de Nave

Fecha de entrega : 19 / 11 / 2026
*/

/*
Clase : RandomWalkMove
	Estrategia de movimiento "Random walk": cada vez que se invoca elige al azar
	una de las 4 direcciones (derecha, izquierda, abajo, arriba) y empuja al enemigo.
	Es el movimiento original del juego.
*/

// Estrategia de movimiento: caminata aleatoria.
public class RandomWalkMove implements MoveStrategy {

  public void move(EnemyShip e) {

    // Genera un numero aleatorio entre 0 y 3.
    int r = (int)random(4);

    // Obtiene la fuerza de empuje del enemigo.
    float step = e.getStep();

    // Aplica una fuerza en la direccion escogida.
    if (r == 0) e.addForce(new PVector(step, 0));
    if (r == 1) e.addForce(new PVector(-step, 0));
    if (r == 2) e.addForce(new PVector(0, step));
    if (r == 3) e.addForce(new PVector(0, -step));
  }
}
