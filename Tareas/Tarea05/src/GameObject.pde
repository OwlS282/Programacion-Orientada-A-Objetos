/*
Instituto Tecnologico de Costa Rica

Nombre : Owel Jafet Gutierrez Ortiz

Carnet : 2026800869

Profesor : Mauricio Aviles Cisneros

Semana 15 : Tarea Corta 5 - Juego de Nave

Fecha de entrega : 12 / 11 / 2026

*/

/*
Clase : GameObject
	Superclase abstracta de todo lo que existe en el juego (naves y proyectiles).
	Concentra posicion, velocidad, aceleracion, velocidad maxima, tamaño y color,
	la fisica basica (update), addForce y la colision rectangulo contra rectangulo
	(collidesWith). Obliga a las subclases a implementar display().
*/


// Clase abstracta de la que heredan los objetos del juego.
public abstract class GameObject {

  // Almacena la posicion actual del objeto en la pantalla.
  protected PVector pos;

  // Almacena la velocidad y direccion del movimiento.
  protected PVector vel;

  // Almacena la aceleracion que se aplica al objeto.
  protected PVector acc;

  // Define la velocidad maxima que puede alcanzar el objeto.
  protected float maxSpeed;

  // Define el ancho y alto del objeto.
  protected float w;
  protected float h;

  // Almacena el color con el que se dibuja el objeto.
  protected color c;


  // Constructor: inicializa los valores del objeto.
  public GameObject(float x, float y, float w, float h, float maxSpeed, color c) {

    // Calcula la posicion inicial tomando como referencia el centro del objeto.
    this.pos = new PVector(x - w/2, y - h/2);

    // Inicializa la velocidad y aceleracion en cero.
    this.vel = new PVector(0, 0);
    this.acc = new PVector(0, 0);

    // Guarda la velocidad maxima, el ancho, el alto y el color.
    this.maxSpeed = maxSpeed;
    this.w = w;
    this.h = h;
    this.c = c;
  }


  // Actualiza el movimiento del objeto en cada ciclo del juego.
  public void update() {

    // Suma la aceleracion a la velocidad actual.
    vel.add(acc);

    // Limita la velocidad para que no supere el maximo permitido.
    vel.limit(maxSpeed);

    // Actualiza la posicion utilizando la velocidad.
    pos.add(vel);

    // Reinicia la aceleracion para el siguiente ciclo.
    acc.setMag(0);
  }


  // Metodo abstracto que deben implementar las clases hijas
  // para definir como se muestra cada objeto en pantalla.
  public abstract void display();


  // Agrega una fuerza al objeto, modificando su aceleracion.
  public void addForce(PVector f) {
    acc.add(f);
  }


  // Comprueba si dos objetos se estan tocando o se superponen.
  // Para esto compara sus posiciones, anchos y altos.
  public boolean collidesWith(GameObject o) {

    // Comprueba si existe una superposicion horizontal.
    boolean collisionX = pos.x + w >= o.pos.x && o.pos.x + o.w >= pos.x;

    // Comprueba si existe una superposicion vertical.
    boolean collisionY = pos.y + h >= o.pos.y && o.pos.y + o.h >= pos.y;

    // Si ambas condiciones se cumplen, existe una colision.
    return collisionX && collisionY;
  }


  // Metodos para obtener la posicion y las dimensiones del objeto.

  // Retorna la posicion horizontal.
  public float getX() { return pos.x; }

  // Retorna la posicion vertical.
  public float getY() { return pos.y; }

  // Retorna el ancho del objeto.
  public float getW() { return w; }

  // Retorna el alto del objeto.
  public float getH() { return h; }
}