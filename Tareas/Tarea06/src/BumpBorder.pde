/*
Instituto Tecnologico de Costa Rica

Nombre : Owel Jafet Gutierrez Ortiz

Carnet : 2026800869

Profesor : Mauricio Aviles Cisneros

Semana 16 : Tarea Corta 6 - Juego de Nave

Fecha de entrega : 19 / 11 / 2026
*/

/*
Clase : BumpBorder
	Estrategia de bordes "Bump": el objeto rebota en los cuatro bordes y
	permanece siempre dentro de la pantalla. Es el comportamiento original del juego.
*/

// Estrategia de bordes: rebote.
public class BumpBorder implements BorderStrategy {

  public void apply(GameObject o) {

    // Obtiene las referencias a la posicion y velocidad del objeto.
    PVector pos = o.getPos();
    PVector vel = o.getVel();
    float w = o.getW(), h = o.getH();

    // Invierte la velocidad en el eje correspondiente al tocar un borde.
    if (pos.x <= 0) vel.x *= -1;
    if (pos.x >= width - w) vel.x *= -1;
    if (pos.y <= 0) vel.y *= -1;
    if (pos.y >= height - h) vel.y *= -1;

    // Mantiene el objeto dentro de la pantalla.
    pos.x = constrain(pos.x, 0, width - w);
    pos.y = constrain(pos.y, 0, height - h);
  }
}
