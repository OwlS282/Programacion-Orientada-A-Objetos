/*
Instituto Tecnologico de Costa Rica

Nombre : Owel Jafet Gutierrez Ortiz

Carnet : 2026800869

Profesor : Mauricio Aviles Cisneros

Semana 16 : Tarea Corta 6 - Juego de Nave

Fecha de entrega : 19 / 11 / 2026
*/

/*
Clase : RandomEnemy
	Enemigo basico. Cada cierto tiempo se empuja en una direccion al azar
	(derecha, izquierda, abajo o arriba). Se dibuja como un alienigena tipo
	Space Invaders con patas animadas.
*/

// Enemigo original: cada cierto tiempo se empuja en una dirección al azar.
// Se dibuja como un alienígena tipo Space Invaders.
public class RandomEnemy extends EnemyShip {

  // Constructor que recibe la posicion, dimensiones, velocidad,
  // configuracion de movimiento, vida, tiempo de disparo y color del enemigo.
  public RandomEnemy(float x, float y, float w, float h,
      float maxSpeed, float step, int stepFreq, float speedDamp,
      float lifePoints, int fireCooldown, color c) {

    // Inicializa los atributos heredados de EnemyShip y sus clases superiores.
    super(x, y, w, h, maxSpeed, step, stepFreq, speedDamp, lifePoints, fireCooldown, c,
  new BumpBorder(), new RandomWalkMove());
    // Aplica un primer movimiento aleatorio al crear el enemigo.
    move();
  }

  // Selecciona una de las cuatro direcciones posibles para mover al enemigo.
  public void move() {

    // Genera un numero aleatorio entre 0 y 3.
    int r = (int)random(4);

    // Aplica una fuerza hacia la derecha.
    if (r == 0) addForce(new PVector(step, 0));

    // Aplica una fuerza hacia la izquierda.
    if (r == 1) addForce(new PVector(-step, 0));

    // Aplica una fuerza hacia abajo.
    if (r == 2) addForce(new PVector(0, step));

    // Aplica una fuerza hacia arriba.
    if (r == 3) addForce(new PVector(0, -step));
  }
  
  // Dibuja la apariencia del enemigo utilizando figuras geometricas.
  protected void drawBody() {

    // Obtiene la posicion actual del enemigo.
    float x = pos.x, y = pos.y;

    // Establece el color del enemigo.
    fill(c);

    // Dibuja las dos antenas.
    rect(x + w*0.2, y,         w*0.1, h*0.25);
    rect(x + w*0.7, y,         w*0.1, h*0.25);

    // Dibuja la cabeza.
    rect(x + w*0.3, y + h*0.1, w*0.4, h*0.2);

    // Dibuja el cuerpo.
    rect(x + w*0.15, y + h*0.25, w*0.7, h*0.5);

    // Dibuja los brazos.
    rect(x,          y + h*0.4,  w*0.15, h*0.3);
    rect(x + w*0.85, y + h*0.4,  w*0.15, h*0.3);

    // Alterna la posicion de las patas para crear una animacion.
    // El desplazamiento cambia cada 15 cuadros.
    float off = ((frameCount / 15) % 2 == 0) ? 0 : w*0.1;

    // Dibuja las dos patas aplicando el desplazamiento de la animacion.
    rect(x + w*0.15 + off, y + h*0.75, w*0.15, h*0.25);
    rect(x + w*0.7  - off, y + h*0.75, w*0.15, h*0.25);

    // Cambia el color a negro para dibujar los ojos.
    fill(0);

    // Dibuja los dos ojos del enemigo.
    rect(x + w*0.3,  y + h*0.38, w*0.14, h*0.14);
    rect(x + w*0.56, y + h*0.38, w*0.14, h*0.14);
  }
}
