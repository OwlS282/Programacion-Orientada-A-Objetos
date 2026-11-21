/*
Instituto Tecnologico de Costa Rica

Nombre : Owel Jafet Gutierrez Ortiz

Carnet : 2026800869

Profesor : Mauricio Aviles Cisneros

Semana 16 : Tarea Corta 6 - Juego de Nave

Fecha de entrega : 19 / 11 / 2026
*/

/*
Clase : Ship
	Superclase abstracta de las naves (jugador y enemigos). Agrega vida, dano,
	disparo con cooldown y amortiguamiento de velocidad. La interaccion con los
	bordes de la pantalla se delega en una BorderStrategy (patron Strategy).
	display() es un metodo plantilla: cada nave define su dibujo en drawBody().
*/

// Superclase abstracta de las naves (jugador y enemigos):
// agrega vida, disparo con cooldown y amortiguamiento.
// El comportamiento en los bordes se delega en una BorderStrategy.
// display() es un método plantilla: cada nave define su dibujo en drawBody().
public abstract class Ship extends GameObject {
  protected float step;
  protected float speedDamp;
  protected float lifePoints;
  protected int fireCooldown;
  protected int fireCounter;
  protected color textColor;

  // Estrategia que define que pasa cuando la nave llega a un borde de la pantalla.
  protected BorderStrategy borderStrategy;

  public Ship(float x, float y, float w, float h,
      float maxSpeed, float step, float speedDamp,
      float lifePoints, int fireCooldown, color c, color textColor,
      BorderStrategy borderStrategy) {
    super(x, y, w, h, maxSpeed, c);
    this.step = step;
    this.speedDamp = speedDamp;
    this.lifePoints = lifePoints;
    this.fireCooldown = fireCooldown;
    this.fireCounter = 0;
    this.textColor = textColor;
    this.borderStrategy = borderStrategy;
  }
  public void update() {
    super.update();
    borderStrategy.apply(this);
    vel.setMag(max(0, vel.mag() - speedDamp));
    fireCounter = max(0, fireCounter - 1);
  }

  // Permite cambiar la estrategia de bordes incluso en tiempo de ejecucion.
  public void setBorderStrategy(BorderStrategy borderStrategy) {
    this.borderStrategy = borderStrategy;
  }

  // Retorna la fuerza con la que la nave se empuja (la usan las estrategias de movimiento).
  public float getStep() { return step; }
  public void display() {
    noStroke();
    drawBody();
    drawLife();
  }
  // Dibujo propio de cada nave (la caja de colisión sigue siendo el rectángulo pos, w, h)
  protected abstract void drawBody();

  protected float lifeTextY() {
    return pos.y - 4;
  }
  protected void drawLife() {
    fill(textColor);
    textAlign(CENTER);
    textSize(12);
    text((int)lifePoints, pos.x + w/2, lifeTextY());
  }
  public void addLifePoints(float i) { lifePoints += i; }
  public float getLifePoints() { return lifePoints; }
  public void damage(float d) { lifePoints -= d; }
  public boolean isDead() { return lifePoints <= 0; }
  public void fire() { fireCounter = fireCooldown; }
  public boolean canFire() { return fireCounter <= 0; }
}
