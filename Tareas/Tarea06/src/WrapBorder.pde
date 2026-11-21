/*
Instituto Tecnologico de Costa Rica

Nombre : Owel Jafet Gutierrez Ortiz

Carnet : 2026800869

Profesor : Mauricio Aviles Cisneros

Semana 16 : Tarea Corta 6 - Juego de Nave

Fecha de entrega : 19 / 11 / 2026
*/

/*
Clase : WrapBorder
	Estrategia de bordes "Wrap": si el objeto cruza el borde izquierdo o derecho
	aparece por el borde opuesto. Los bordes superior e inferior no hacen wrap
	(segun el enunciado); para que el objeto no se escape de la pantalla ahi rebota.
*/

// Estrategia de bordes: aparece por el lado opuesto (solo izquierda y derecha).
public class WrapBorder implements BorderStrategy {

  public void apply(GameObject o) {

    // Obtiene las referencias a la posicion y velocidad del objeto.
    PVector pos = o.getPos();
    PVector vel = o.getVel();
    float w = o.getW(), h = o.getH();

    // Si sale completamente por la izquierda, reaparece entrando por la derecha.
    if (pos.x + w < 0) pos.x = width;

    // Si sale completamente por la derecha, reaparece entrando por la izquierda.
    else if (pos.x > width) pos.x = -w;

    // Bordes superior e inferior: rebote para mantener al enemigo en pantalla.
    if (pos.y <= 0) vel.y *= -1;
    if (pos.y >= height - h) vel.y *= -1;
    pos.y = constrain(pos.y, 0, height - h);
  }
}
