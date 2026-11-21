/*
Instituto Tecnologico de Costa Rica

Nombre : Owel Jafet Gutierrez Ortiz

Carnet : 2026800869

Profesor : Mauricio Aviles Cisneros

Semana 15 : Tarea Corta 5 - Juego de Nave

Fecha de entrega : 12 / 11 / 2026

*/

/*
Clase : Ship
	Superclase abstracta de las naves (jugador y enemigos). Agrega vida, daño,
	disparo con cooldown, amortiguamiento de velocidad y rebote en los bordes.
	display() es un metodo plantilla: cada nave define su dibujo en drawBody().
*/

// Superclase abstracta de las naves (jugador y enemigos):
// agrega vida, disparo con cooldown, amortiguamiento y rebote en bordes.
// display() es un método plantilla: cada nave define su dibujo en drawBody().
public abstract class Ship extends GameObject {
  protected float step;
  protected float speedDamp;
  protected float lifePoints;
  protected int fireCooldown;
  protected int fireCounter;
  protected color textColor;

  public Ship(float x, float y, float w, float h,
      float maxSpeed, float step, float speedDamp,
      float lifePoints, int fireCooldown, color c, color textColor) {
    super(x, y, w, h, maxSpeed, c);
    this.step = step;
    this.speedDamp = speedDamp;
    this.lifePoints = lifePoints;
    this.fireCooldown = fireCooldown;
    this.fireCounter = 0;
    this.textColor = textColor;
  }
  public void update() {
    super.update();
    borders();
    vel.setMag(max(0, vel.mag() - speedDamp));
    fireCounter = max(0, fireCounter - 1);
  }
  protected void borders() {
    if (pos.x <= 0) vel.x *= -1;
    if (pos.x >= width - w) vel.x *= -1;
    if (pos.y <= 0) vel.y *= -1;
    if (pos.y >= height - h) vel.y *= -1;
    pos.x = constrain(pos.x, 0, width - w);
    pos.y = constrain(pos.y, 0, height - h);
  }
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
