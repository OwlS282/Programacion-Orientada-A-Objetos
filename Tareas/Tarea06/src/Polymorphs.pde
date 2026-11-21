/*
Instituto Tecnologico de Costa Rica

Nombre : Owel Jafet Gutierrez Ortiz

Carnet : 2026800869

Profesor : Mauricio Aviles Cisneros

Semana 16 : Tarea Corta 6 - Juego de Nave

Fecha de entrega : 19 / 11 / 2026
*/

/*
Clase : Polymorphs
	Programa principal (interfaz con el usuario). Crea la controladora, lee las
	teclas con un arreglo de booleanos para permitir varias a la vez y, en cada
	ciclo de draw(), ejecuta las acciones, actualiza y dibuja el juego.
*/

// Importa las clases necesarias para trabajar con listas, iteradores y mapas.
import java.util.List;
import java.util.LinkedList;
import java.util.Iterator;
import java.util.Map;


// Variable que almacena la controladora encargada del funcionamiento del juego.
PolymorphsControl control;

// Arreglo que permite saber cuales teclas estan presionadas.
Boolean[] keyStatus;


// Enumeracion que contiene las teclas utilizadas para controlar el juego.
enum Keys { LEFT, RIGHT, FIRE, RESTART }


// Configura e inicializa el juego.
void setup() {

  // Establece el ancho y alto de la ventana.
  size(800, 600);

  // Crea la controladora que administra los elementos del juego.
  control = new PolymorphsControl();

  // Crea el arreglo con una posicion para cada tecla de la enumeracion.
  keyStatus = new Boolean[Keys.values().length];

  // Inicializa todas las teclas como no presionadas.
  for (int i = 0; i < Keys.values().length; i++)
    keyStatus[i] = false;
}


// Se ejecuta continuamente para actualizar y dibujar el juego.
void draw() {

  // Limpia la pantalla y establece el fondo negro.
  background(0);

  // Comprueba si la tecla izquierda esta presionada y mueve al jugador.
  if (keyStatus[Keys.LEFT.ordinal()])
    control.moveLeftAction();

  // Comprueba si la tecla derecha esta presionada y mueve al jugador.
  if (keyStatus[Keys.RIGHT.ordinal()])
    control.moveRightAction();

  // Comprueba si la tecla de espacio esta presionada y realiza un disparo.
  if (keyStatus[Keys.FIRE.ordinal()])
    control.fireAction();

  // Comprueba si la tecla de reinicio esta presionada.
  if (keyStatus[Keys.RESTART.ordinal()])
    control.restartAction();

  // Actualiza los movimientos y el estado de los objetos del juego.
  control.update();

  // Dibuja los elementos del juego en la pantalla.
  control.display();
}


// Detecta cuando el usuario presiona una tecla.
void keyPressed() {

  // Si se presiona la barra espaciadora, registra la accion de disparar.
  if (key == ' ') keyStatus[Keys.FIRE.ordinal()] = true;

  // Si se presiona R o r, registra la accion de reiniciar.
  if (key == 'r' || key == 'R') keyStatus[Keys.RESTART.ordinal()] = true;

  // Comprueba si se presiono una tecla especial, como las flechas.
  if (key == CODED) {

    // Registra cuando se presiona la flecha izquierda.
    if (keyCode == LEFT) keyStatus[Keys.LEFT.ordinal()] = true;

    // Registra cuando se presiona la flecha derecha.
    if (keyCode == RIGHT) keyStatus[Keys.RIGHT.ordinal()] = true;
  }
}


// Detecta cuando el usuario deja de presionar una tecla.
void keyReleased() {

  // Si se suelta la barra espaciadora, desactiva la accion de disparar.
  if (key == ' ') keyStatus[Keys.FIRE.ordinal()] = false;

  // Si se suelta R o r, desactiva la accion de reiniciar.
  if (key == 'r' || key == 'R') keyStatus[Keys.RESTART.ordinal()] = false;

  // Comprueba si se libero una tecla especial, como las flechas.
  if (key == CODED) {

    // Registra que la flecha izquierda ya no esta presionada.
    if (keyCode == LEFT) keyStatus[Keys.LEFT.ordinal()] = false;

    // Registra que la flecha derecha ya no esta presionada.
    if (keyCode == RIGHT) keyStatus[Keys.RIGHT.ordinal()] = false;
  }
}