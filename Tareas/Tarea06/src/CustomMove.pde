/*
Instituto Tecnologico de Costa Rica

Nombre : Owel Jafet Gutierrez Ortiz

Carnet : 2026800869

Profesor : Mauricio Aviles Cisneros

Semana 16 : Tarea Corta 6 - Juego de Nave

Fecha de entrega : 19 / 11 / 2026
*/

/*
Clase : CustomMove
	Estrategia de movimiento "Custom": el movimiento propio del enemigo nuevo de
	la tarea anterior (el francotirador). Se empuja lentamente de lado a lado, con
	direccion izquierda o derecha escogida al azar.
*/

// Estrategia de movimiento: desplazamiento lateral aleatorio del francotirador.
public class CustomMove implements MoveStrategy {

  public void move(EnemyShip e) {

    // Aplica una fuerza horizontal aleatoria hacia la izquierda o derecha.
    float step = e.getStep();
    e.addForce(new PVector(random(1) < 0.5 ? step : -step, 0));
  }
}
