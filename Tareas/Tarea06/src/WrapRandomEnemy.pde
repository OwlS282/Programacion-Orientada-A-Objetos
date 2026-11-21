/*
Instituto Tecnologico de Costa Rica

Nombre : Owel Jafet Gutierrez Ortiz

Carnet : 2026800869

Profesor : Mauricio Aviles Cisneros

Semana 16 : Tarea Corta 6 - Juego de Nave

Fecha de entrega : 19 / 11 / 2026
*/

/*
Clase : WrapRandomEnemy
	Enemigo 3: Wrap + Random walk. Atraviesa los bordes laterales apareciendo por
	el lado opuesto y camina al azar en las 4 direcciones. Se dibuja como un fantasma.
*/

// Enemigo 3: estrategia de bordes Wrap + estrategia de movimiento Random walk.
public class WrapRandomEnemy extends EnemyShip {

  public WrapRandomEnemy(float x, float y, float w, float h,
      float maxSpeed, float step, int stepFreq, float speedDamp,
      float lifePoints, int fireCooldown, color c) {

    // Combina las estrategias: aparece por el lado opuesto (Wrap) y camina al azar (Random walk).
    super(x, y, w, h, maxSpeed, step, stepFreq, speedDamp, lifePoints, fireCooldown, c,
      new WrapBorder(), new RandomWalkMove());

    // Aplica un primer movimiento aleatorio al crear el enemigo.
    move();
  }


  // Dibuja un fantasma con la parte inferior ondulante.
  protected void drawBody() {

    float x = pos.x, y = pos.y;
    fill(c);

    // Cabeza y torso.
    ellipse(x + w/2, y + h*0.4, w, h*0.8);
    rect(x, y + h*0.4, w, h*0.4);

    // Picos inferiores que se desplazan cada 15 cuadros para animarlo.
    float off = ((frameCount / 15) % 2 == 0) ? 0 : w/6;
    triangle(x,         y + h*0.8, x + w/3,     y + h*0.8, x + w/6 + off - w/12, y + h);
    triangle(x + w/3,   y + h*0.8, x + 2*w/3,   y + h*0.8, x + w/2 + off - w/12, y + h);
    triangle(x + 2*w/3, y + h*0.8, x + w,       y + h*0.8, x + 5*w/6 + off - w/12, y + h);

    // Ojos.
    fill(255);
    ellipse(x + w*0.3, y + h*0.38, w*0.25, h*0.25);
    ellipse(x + w*0.7, y + h*0.38, w*0.25, h*0.25);
    fill(0);
    ellipse(x + w*0.3, y + h*0.4, w*0.1, h*0.1);
    ellipse(x + w*0.7, y + h*0.4, w*0.1, h*0.1);
  }
}
