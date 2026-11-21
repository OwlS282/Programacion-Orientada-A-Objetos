/*
Instituto Tecnologico de Costa Rica

Nombre : Owel Jafet Gutierrez Ortiz

Carnet : 2026800869

Profesor : Mauricio Aviles Cisneros

Semana 16 : Tarea Corta 6 - Juego de Nave

Fecha de entrega : 19 / 11 / 2026
*/

/*
Clase : ZigzagMove
	Estrategia de movimiento "Zigzag": el enemigo se empuja continuamente hacia
	un lado durante cierto tiempo y luego hacia el lado contrario. Un contador
	indica cuantos empujes quedan en la direccion actual; al llegar a cero se invierte
	la direccion y se genera aleatoriamente un nuevo tiempo (entre minTime y maxTime).
	Cada enemigo necesita su propia instancia porque la estrategia guarda estado.
*/

// Estrategia de movimiento: zigzag horizontal con duraciones aleatorias.
public class ZigzagMove implements MoveStrategy {

  // Rango (en cantidad de movimientos) de la duracion de cada tramo.
  private int minTime;
  private int maxTime;

  // Direccion actual: 1 = derecha, -1 = izquierda.
  private int direction;

  // Contador de movimientos restantes en la direccion actual.
  private int counter;


  // Constructor: escoge una direccion inicial y una duracion aleatoria.
  public ZigzagMove(int minTime, int maxTime) {
    this.minTime = minTime;
    this.maxTime = maxTime;
    this.direction = (random(1) < 0.5) ? 1 : -1;
    this.counter = randomTime();
  }


  // Genera la duracion aleatoria del siguiente tramo.
  private int randomTime() {
    return (int)random(minTime, maxTime + 1);
  }


  public void move(EnemyShip e) {

    // Si termino el tramo actual, invierte la direccion y genera un nuevo tiempo.
    if (counter <= 0) {
      direction *= -1;
      counter = randomTime();
    }

    // Empuja al enemigo en la direccion actual y avanza el contador.
    e.addForce(new PVector(direction * e.getStep(), 0));
    counter--;
  }
}
