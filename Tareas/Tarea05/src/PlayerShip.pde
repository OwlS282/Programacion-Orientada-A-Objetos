/*
Instituto Tecnologico de Costa Rica

Nombre : Owel Jafet Gutierrez Ortiz

Carnet : 2026800869

Profesor : Mauricio Aviles Cisneros

Semana 15 : Tarea Corta 5 - Juego de Nave

Fecha de entrega : 12 / 11 / 2026

*/

/*
Clase : PlayerShip
	Nave del jugador. Se mueve a la izquierda y derecha segun el input, se dibuja
	como un caza con motor, puede curarse (heal) sin pasar de su vida inicial y
	recibe mejoras de velocidad (setSpeedStats). Si muere, deja de actualizarse
	y de dibujarse.
*/

// Clase que representa la nave del jugador.
public class PlayerShip extends Ship {

  // Almacena la cantidad maxima de vida que puede recuperar el jugador.
  private float maxLifePoints;


  // Constructor: inicializa las caracteristicas de la nave del jugador.
  public PlayerShip(float x, float y, float w, float h,
      float maxSpeed, float step, float speedDamp,
      float lifePoints, int fireCooldown, color c) {

    // Llama al constructor de Ship para inicializar los atributos heredados.
    // Establece el color de los proyectiles del jugador en negro.
    super(x, y, w, h, maxSpeed, step, speedDamp, lifePoints, fireCooldown, c, color(0));

    // Guarda la cantidad inicial de vida como limite maximo de curacion.
    this.maxLifePoints = lifePoints;
  }


  // Actualiza el movimiento de la nave mientras el jugador siga vivo.
  public void update() {

    // Comprueba que el jugador no haya sido eliminado antes de actualizarlo.
    if (!isDead()) super.update();
  }


  // Dibuja la nave mientras el jugador siga vivo.
  public void display() {

    // Comprueba que el jugador no haya sido eliminado antes de dibujarlo.
    if (!isDead()) super.display();
  }


  // Dibuja las diferentes partes de la nave del jugador.
  protected void drawBody() {

    // Obtiene la posicion actual de la nave.
    float x = pos.x, y = pos.y;


    //  MOTOR DE LA NAVE 

    // Dibuja la llama exterior del motor utilizando un triangulo.
    // Su altura cambia aleatoriamente para simular movimiento.
    fill(255, 140, 0);
    triangle(x + w*0.25, y + h, x + w*0.75, y + h, x + w/2, y + h + random(6, 14));

    // Dibuja la llama interior del motor con un color amarillo.
    fill(255, 230, 80);
    triangle(x + w*0.4, y + h, x + w*0.6, y + h, x + w/2, y + h + random(2, 7));


    //  ALAS DE LA NAVE 

    // Oscurece el color original de la nave para dibujar las alas.
    fill(red(c)*0.6, green(c)*0.6, blue(c)*0.6);

    // Dibuja el ala izquierda utilizando un triangulo.
    triangle(x - w*0.5, y + h, x + w*0.2, y + h*0.5, x + w*0.2, y + h);

    // Dibuja el ala derecha utilizando un triangulo.
    triangle(x + w*1.5, y + h, x + w*0.8, y + h*0.5, x + w*0.8, y + h);


    //  FUSELAJE DE LA NAVE 

    // Establece el color principal de la nave.
    fill(c);

    // Comienza a crear la figura del cuerpo de la nave.
    beginShape();

    // Define los puntos que forman el fuselaje.
    vertex(x + w/2, y);
    vertex(x + w*0.85, y + h*0.45);
    vertex(x + w*0.85, y + h);
    vertex(x + w*0.15, y + h);
    vertex(x + w*0.15, y + h*0.45);

    // Cierra la figura para completar el cuerpo de la nave.
    endShape(CLOSE);


    //  CABINA DE LA NAVE 

    // Establece el color celeste de la cabina.
    fill(0, 200, 255);

    // Dibuja la cabina utilizando una elipse.
    ellipse(x + w/2, y + h*0.38, w*0.45, h*0.2);
  }


  // Define la posicion vertical donde se muestra la vida del jugador.
  protected float lifeTextY() {

    // Ubica el texto dentro del fuselaje de la nave.
    return pos.y + h * 0.82;
  }


  // Aplica una fuerza hacia la derecha para mover la nave.
  public void moveRight() {
    addForce(new PVector(step, 0));
  }

  // Aplica una fuerza hacia la izquierda para mover la nave.
  public void moveLeft() {
    addForce(new PVector(-step, 0));
  }


  // Recupera una cantidad de vida sin superar el limite establecido.
  public void heal(float amount) {

    // Comprueba que el jugador siga vivo antes de recuperar vida.
    if (!isDead()) lifePoints = min(maxLifePoints, lifePoints + amount);
  }


  // Actualiza los valores de velocidad del jugador para aplicar mejoras.
  public void setSpeedStats(float maxSpeed, float step) {

    // Actualiza la velocidad maxima permitida.
    this.maxSpeed = maxSpeed;

    // Actualiza la fuerza utilizada para mover la nave.
    this.step = step;
  }
}