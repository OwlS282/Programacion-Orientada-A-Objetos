/*
Instituto Tecnologico de Costa Rica

Nombre : Owel Jafet Gutierrez Ortiz

Carnet : 2026800869

Profesor : Mauricio Aviles Cisneros

Semana 15 : Tarea Corta 5 - Juego de Nave

Fecha de entrega : 12 / 11 / 2026

*/

/*
Clase : Projectile
	Proyectil disparado por el jugador o por los enemigos. Hereda la fisica de
	GameObject y agrega el daño que causa al chocar, el dibujo y la deteccion de
	salida de pantalla (outOfScreen).
*/

// Clase que representa los proyectiles del juego.
public class Projectile extends GameObject {

  // Almacena la cantidad de daño que causa el proyectil al impactar.
  private float damage;


  // Constructor: inicializa el proyectil con sus caracteristicas.
  public Projectile(float x, float y, float w, float h, float maxSpeed, float damage, color c) {

    // Llama al constructor de GameObject para inicializar sus atributos.
    super(x, y, w, h, maxSpeed, c);

    // Guarda el daño que causara el proyectil.
    this.damage = damage;
  }


  // Dibuja el proyectil en la pantalla.
  public void display() {

    // Evita que se dibuje el borde de la figura.
    noStroke();

    // Establece el color del proyectil.
    fill(c);

    // Dibuja un rectangulo utilizando su posicion y dimensiones.
    rect(pos.x, pos.y, w, h);
  }


  // Comprueba si el proyectil se encuentra fuera de la pantalla.
  public boolean outOfScreen() {

    // Comprueba si salio por el lado izquierdo o derecho.
    if (pos.x + w <= 0 || pos.x >= width) return true;

    // Comprueba si salio por la parte superior o inferior.
    if (pos.y + h <= 0 || pos.y >= height) return true;

    // Si no cumple ninguna condicion, sigue dentro de la pantalla.
    return false;
  }


  // Retorna la cantidad de daño que causa el proyectil.
  public float getDamage() {
    return damage;
  }
}