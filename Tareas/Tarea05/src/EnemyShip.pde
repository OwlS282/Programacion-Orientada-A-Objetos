/*
Instituto Tecnologico de Costa Rica

Nombre : Owel Jafet Gutierrez Ortiz

Carnet : 2026800869

Profesor : Mauricio Aviles Cisneros

Semana 15 : Tarea Corta 5 - Juego de Nave

Fecha de entrega : 12 / 11 / 2026

*/

/*
Clase : EnemyShip
	Superclase abstracta de los enemigos. Agrega la decision periodica de moverse
	(stepFreq y randomness) y deja el patron de movimiento a las subclases mediante
	el metodo abstracto move(). firesProjectiles() indica si usa proyectiles normales.
*/

// Clase abstracta que representa a los enemigos del juego.
public abstract class EnemyShip extends Ship {

  // Define cada cuantos ciclos del juego el enemigo decide moverse.
  protected int stepFreq;

  // Almacena un valor aleatorio para variar el momento en que se mueve cada enemigo.
  protected int randomness;


  // Constructor: inicializa las caracteristicas del enemigo.
  public EnemyShip(float x, float y, float w, float h,
      float maxSpeed, float step, int stepFreq, float speedDamp,
      float lifePoints, int fireCooldown, color c) {

    // Llama al constructor de Ship para inicializar los atributos heredados.
    // Tambien establece el color de los proyectiles en blanco.
    super(x, y, w, h, maxSpeed, step, speedDamp, lifePoints, fireCooldown, c, color(255));

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


  // Metodo abstracto que cada tipo de enemigo debe implementar.
  // Define el patron de movimiento que tendra cada enemigo.
  public abstract void move();


  // Indica si el enemigo utiliza proyectiles normales para disparar.
  public boolean firesProjectiles() {
    return true;
  }
}