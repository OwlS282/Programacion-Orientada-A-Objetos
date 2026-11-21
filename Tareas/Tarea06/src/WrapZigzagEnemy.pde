/*
Instituto Tecnologico de Costa Rica

Nombre : Owel Jafet Gutierrez Ortiz

Carnet : 2026800869

Profesor : Mauricio Aviles Cisneros

Semana 16 : Tarea Corta 6 - Juego de Nave

Fecha de entrega : 19 / 11 / 2026
*/

/*
Clase : WrapZigzagEnemy
	Enemigo 2: Wrap + Zigzag. Atraviesa los bordes laterales apareciendo por el
	lado opuesto y se mueve en zigzag horizontal. Se dibuja como un platillo volador.
*/

// Enemigo 2: estrategia de bordes Wrap + estrategia de movimiento Zigzag.
public class WrapZigzagEnemy extends EnemyShip {

  public WrapZigzagEnemy(float x, float y, float w, float h,
      float maxSpeed, float step, int stepFreq, float speedDamp,
      float lifePoints, int fireCooldown, color c,
      int zigzagMinTime, int zigzagMaxTime) {

    // Combina las estrategias: aparece por el lado opuesto (Wrap) y zigzaguea (Zigzag).
    super(x, y, w, h, maxSpeed, step, stepFreq, speedDamp, lifePoints, fireCooldown, c,
      new WrapBorder(), new ZigzagMove(zigzagMinTime, zigzagMaxTime));

    // Aplica un primer movimiento al crear el enemigo.
    move();
  }


  // Dibuja un platillo volador con luces parpadeantes.
  protected void drawBody() {

    float x = pos.x, y = pos.y;

    // Cupula de cristal.
    fill(170, 230, 255);
    ellipse(x + w/2, y + h*0.35, w*0.5, h*0.55);

    // Plato del platillo.
    fill(c);
    ellipse(x + w/2, y + h*0.65, w, h*0.45);

    // Luces que se alternan cada 15 cuadros.
    boolean on = (frameCount / 15) % 2 == 0;
    fill(on ? color(255, 255, 0) : color(60));
    ellipse(x + w*0.25, y + h*0.65, w*0.12, h*0.12);
    ellipse(x + w*0.75, y + h*0.65, w*0.12, h*0.12);
    fill(on ? color(60) : color(255, 255, 0));
    ellipse(x + w*0.5, y + h*0.7, w*0.12, h*0.12);
  }
}
