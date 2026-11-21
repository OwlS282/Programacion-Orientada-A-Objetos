/*
Instituto Tecnologico de Costa Rica

Nombre : Owel Jafet Gutierrez Ortiz

Carnet : 2026800869

Profesor : Mauricio Aviles Cisneros

Semana 16 : Tarea Corta 6 - Juego de Nave

Fecha de entrega : 19 / 11 / 2026
*/

/*
Clase : EnemyShip
	Superclase abstracta de los enemigos. Agrega la decision periodica de moverse
	(stepFreq y randomness). El patron de movimiento se delega en una MoveStrategy y
	la interaccion con los bordes en una BorderStrategy (patron Strategy); cada
	subclase concreta solo escoge la combinacion de estrategias que usa.
	firesProjectiles() indica si usa proyectiles normales.
*/

// Clase abstracta que representa a los enemigos del juego.
public abstract class EnemyShip extends Ship {

  // Define cada cuantos ciclos del juego el enemigo decide moverse.
  protected int stepFreq;

  // Almacena un valor aleatorio para variar el momento en que se mueve cada enemigo.
  protected int randomness;

  // Estrategia que define como se mueve el enemigo cada vez que decide moverse.
  protected MoveStrategy moveStrategy;


  // Constructor: inicializa las caracteristicas del enemigo.
  public EnemyShip(float x, float y, float w, float h,
      float maxSpeed, float step, int stepFreq, float speedDamp,
      float lifePoints, int fireCooldown, color c,
      BorderStrategy borderStrategy, MoveStrategy moveStrategy) {

    // Llama al constructor de Ship para inicializar los atributos heredados.
    // Tambien establece el color de los proyectiles en blanco y la estrategia de bordes.
    super(x, y, w, h, maxSpeed, step, speedDamp, lifePoints, fireCooldown, c, color(255),
      borderStrategy);

    // Guarda la estrategia de movimiento del enemigo.
    this.moveStrategy = moveStrategy;

    // Guarda la frecuencia con la que el enemigo decide moverse.
    this.stepFreq = stepFreq;

    // Genera un valor aleatorio para que los enemigos no se muevan todos al mismo tiempo.
    this.randomness = (int)random(1000);
  }


  // Actualiza el estado y movimiento del enemigo.
  public void update() {

    // Ejecuta primero la actualizacion de la clase Ship.
    super.update();

    // Comprueba si llego el momento de realizar un nuevo movimiento.
    if ((frameCount + randomness) % stepFreq == 0) move();
  }


  // Realiza un movimiento delegando en la estrategia de movimiento.
  public void move() {
    moveStrategy.move(this);
  }


  // Permite cambiar la estrategia de movimiento incluso en tiempo de ejecucion.
  public void setMoveStrategy(MoveStrategy moveStrategy) {
    this.moveStrategy = moveStrategy;
  }


  // Indica si el enemigo utiliza proyectiles normales para disparar.
  public boolean firesProjectiles() {
    return true;
  }
}