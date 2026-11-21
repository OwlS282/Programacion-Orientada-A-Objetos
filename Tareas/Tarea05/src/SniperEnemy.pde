/*
Instituto Tecnologico de Costa Rica

Nombre : Owel Jafet Gutierrez Ortiz

Carnet : 2026800869

Profesor : Mauricio Aviles Cisneros

Semana 15 : Tarea Corta 5 - Juego de Nave

Fecha de entrega : 12 / 11 / 2026

*/

/*
Clase : SniperEnemy
	Enemigo francotirador. Pasa por tres estados: descanso, carga
	(linea de aviso que sigue al jugador y luego bloquea la mira) y rayo instantaneo
	que da al jugador si esta en la linea. No dispara proyectiles normales.
*/

// Clase que representa al enemigo francotirador.
public class SniperEnemy extends EnemyShip {

  // Constantes que representan los diferentes estados del enemigo.
  private final int REST = 0;
  private final int CHARGE = 1;
  private final int BEAM = 2;


  // Referencia al jugador, que sera el objetivo del francotirador.
  private PlayerShip target;

  // Almacena el estado actual del enemigo.
  private int state;

  // Controla el tiempo restante del estado actual.
  private int timer;

  // Define el tiempo que necesita el enemigo para cargar su ataque.
  private int chargeTime;

  // Define los ultimos ciclos de carga durante los cuales la mira queda bloqueada.
  private int lockTime;

  // Define cuanto tiempo permanece visible el rayo.
  private int beamDuration;

  // Define el tiempo de descanso entre cada disparo.
  private int restTime;

  // Almacena el daño que causa el rayo al jugador.
  private float beamDamage;

  // Almacena las coordenadas del punto hacia donde apunta el enemigo.
  private float aimX, aimY;


  // Constructor: inicializa las caracteristicas del francotirador.
  public SniperEnemy(float x, float y, float w, float h,
      float maxSpeed, float step, int stepFreq, float speedDamp,
      float lifePoints, int fireCooldown, color c,
      PlayerShip target, int chargeTime, int lockTime,
      int beamDuration, int restTime, float beamDamage) {

    // Llama al constructor de EnemyShip para inicializar los atributos heredados.
    super(x, y, w, h, maxSpeed, step, stepFreq, speedDamp, lifePoints, fireCooldown, c);

    // Guarda la referencia al jugador que sera el objetivo del ataque.
    this.target = target;

    // Guarda los tiempos necesarios para controlar el ataque.
    this.chargeTime = chargeTime;
    this.lockTime = lockTime;
    this.beamDuration = beamDuration;
    this.restTime = restTime;

    // Guarda el daño que causara el rayo.
    this.beamDamage = beamDamage;

    // Inicializa el enemigo en el estado de descanso.
    this.state = REST;

    // Asigna un tiempo de descanso aleatorio para evitar que todos los francotiradores disparen al mismo tiempo.
    this.timer = (int)random(1, restTime + 1);
  }


  // Permite que el francotirador se mueva lentamente de lado a lado.
  public void move() {

    // Aplica una fuerza horizontal aleatoria hacia la izquierda o derecha.
    addForce(new PVector(random(1) < 0.5 ? step : -step, 0));
  }


  // Indica que este enemigo no utiliza proyectiles normales.
  // Su ataque se realiza mediante un rayo.
  public boolean firesProjectiles() {
    return false;
  }


  // Actualiza el movimiento y el comportamiento del francotirador.
  public void update() {

    // Ejecuta primero la actualizacion heredada de EnemyShip.
    super.update();

    // Comprueba si el jugador ya fue eliminado.
    if (target.isDead()) {

      // Si el jugador murio, el enemigo vuelve al estado de descanso.
      state = REST;

      // Reinicia el tiempo de descanso.
      timer = restTime;
      return;
    }

    // Reduce el tiempo restante del estado actual.
    timer--;


    //  ESTADO DE DESCANSO 

    if (state == REST) {

      // Comprueba si termino el tiempo de descanso.
      if (timer <= 0) {

        // Cambia al estado de carga.
        state = CHARGE;

        // Establece el tiempo necesario para cargar el disparo.
        timer = chargeTime;

        // Apunta inicialmente hacia la posicion actual del jugador.
        aim();
      }


    //  ESTADO DE CARGA 

    } else if (state == CHARGE) {

      // Mientras no llegue el momento de bloquear la mira,
      // actualiza la posicion del objetivo para seguir al jugador.
      if (timer > lockTime) aim();

      // Comprueba si termino el tiempo de carga.
      if (timer <= 0) {

        // Cambia al estado del rayo.
        state = BEAM;

        // Establece cuanto tiempo permanecera visible el rayo.
        timer = beamDuration;

        // Comprueba si el rayo alcanza al jugador y aplica el daño.
        if (beamHitsTarget()) target.damage(beamDamage);
      }


    //  ESTADO DEL RAYO 

    } else if (state == BEAM) {

      // Comprueba si termino el tiempo durante el cual se muestra el rayo.
      if (timer <= 0) {

        // Regresa al estado de descanso.
        state = REST;

        // Reinicia el tiempo de espera para el siguiente ataque.
        timer = restTime;
      }
    }
  }


  // Actualiza las coordenadas del punto al que apunta el francotirador.
  private void aim() {

    // Obtiene el centro horizontal del jugador.
    aimX = target.getX() + target.getW() / 2;

    // Obtiene el centro vertical del jugador.
    aimY = target.getY() + target.getH() / 2;
  }


  // Retorna la coordenada horizontal del centro del francotirador.
  private float centerX() {
    return pos.x + w / 2;
  }

  // Retorna la coordenada vertical del centro del francotirador.
  private float centerY() {
    return pos.y + h / 2;
  }


  // Calcula el punto final del rayo a partir de la posicion del enemigo
  // y la direccion hacia la que apunta.
  private PVector beamEnd() {

    // Calcula un vector que indica la direccion hacia el objetivo.
    PVector dir = new PVector(aimX - centerX(), aimY - centerY());

    // Si el vector no tiene direccion, establece una direccion hacia abajo.
    if (dir.mag() == 0) dir.set(0, 1);

    // Extiende el vector para que el rayo sobrepase los limites de la pantalla.
    dir.setMag(max(width, height) * 2);

    // Retorna las coordenadas del punto final del rayo.
    return new PVector(centerX() + dir.x, centerY() + dir.y);
  }


  // Comprueba si el rayo alcanza al jugador.
  private boolean beamHitsTarget() {

    // Obtiene el punto final del rayo.
    PVector e = beamEnd();

    // Comprueba si el segmento del rayo intersecta el rectangulo del jugador.
    return segmentHitsRect(centerX(), centerY(), e.x, e.y,
      target.getX(), target.getY(), target.getW(), target.getH());
  }


  // Comprueba si un segmento de linea intersecta un rectangulo.
  // Utiliza el algoritmo Liang-Barsky para detectar la interseccion.
  private boolean segmentHitsRect(float x0, float y0, float x1, float y1,
      float rx, float ry, float rw, float rh) {

    // Define los limites iniciales y finales del segmento.
    float t0 = 0, t1 = 1;

    // Calcula la diferencia entre las coordenadas iniciales y finales.
    float dx = x1 - x0, dy = y1 - y0;

    // Almacena los valores utilizados para comprobar los limites del rectangulo.
    float[] p = { -dx, dx, -dy, dy };
    float[] q = { x0 - rx, rx + rw - x0, y0 - ry, ry + rh - y0 };

    // Recorre los cuatro limites del rectangulo.
    for (int i = 0; i < 4; i++) {

      // Comprueba si el segmento es paralelo al limite actual.
      if (p[i] == 0) {

        // Si esta fuera del limite, no existe interseccion.
        if (q[i] < 0) return false;

      } else {

        // Calcula el punto de interseccion con el limite actual.
        float r = q[i] / p[i];

        // Actualiza el limite inicial del segmento.
        if (p[i] < 0) {

          // Si la interseccion queda fuera del segmento, no existe impacto.
          if (r > t1) return false;

          // Actualiza el inicio del segmento cuando corresponde.
          if (r > t0) t0 = r;

        } else {

          // Si la interseccion queda fuera del segmento, no existe impacto.
          if (r < t0) return false;

          // Actualiza el final del segmento cuando corresponde.
          if (r < t1) t1 = r;
        }
      }
    }

    // Si supera todas las comprobaciones, existe una interseccion.
    return true;
  }


  // Dibuja el cuerpo del francotirador utilizando figuras geometricas.
  protected void drawBody() {

    // Obtiene las coordenadas del centro del enemigo.
    float cx = centerX(), cy = centerY();

    // Establece el color principal del enemigo.
    fill(c);

    // Dibuja las puas laterales e inferiores del cuerpo.
    triangle(cx - w*0.75, cy, cx - w*0.35, cy - h*0.25, cx - w*0.35, cy + h*0.25);
    triangle(cx + w*0.75, cy, cx + w*0.35, cy - h*0.25, cx + w*0.35, cy + h*0.25);
    triangle(cx, cy - h*0.75, cx - w*0.25, cy - h*0.35, cx + w*0.25, cy - h*0.35);
    triangle(cx, cy + h*0.75, cx - w*0.25, cy + h*0.35, cx + w*0.25, cy + h*0.35);

    // Dibuja el cuerpo principal utilizando una elipse.
    ellipse(cx, cy, w*0.9, h*0.9);

    // Dibuja la parte oscura que representa la cuenca del ojo.
    fill(30, 0, 60);
    ellipse(cx, cy, w*0.6, h*0.6);

    // Cambia el color del ojo dependiendo del estado del enemigo.
    if (state == REST) fill(255, 200, 0);
    else if (state == CHARGE) fill(255, 60, 60);
    else fill(255);

    // Dibuja el ojo principal del francotirador.
    ellipse(cx, cy, w*0.38, h*0.38);

    // Establece el color negro para dibujar la pupila.
    fill(0);

    // Dibuja la pupila en el centro del ojo.
    ellipse(cx, cy, w*0.14, h*0.14);
  }


  // Dibuja el francotirador y los efectos visuales de su ataque.
  public void display() {

    // Dibuja el cuerpo del enemigo utilizando el metodo de la clase padre.
    super.display();


    //  VISUALIZACION DURANTE LA CARGA 

    if (state == CHARGE) {

      // Calcula el progreso de la carga del disparo.
      float progress = 1 - (float)timer / chargeTime;

      // Obtiene el punto final del rayo.
      PVector e = beamEnd();

      // Si la mira esta bloqueada, muestra una linea blanca.
      if (timer <= lockTime) stroke(255, 255, 255, 220);

      // Mientras sigue apuntando al jugador, muestra una linea con transparencia.
      else stroke(red(c), green(c), blue(c), 40 + progress * 150);

      // Aumenta el grosor de la linea conforme avanza la carga.
      strokeWeight(1 + progress * 3);

      // Dibuja la linea de aviso desde el centro del enemigo hasta el objetivo.
      line(centerX(), centerY(), e.x, e.y);


    //  VISUALIZACION DEL RAYO 

    } else if (state == BEAM) {

      // Obtiene el punto final del rayo.
      PVector e = beamEnd();

      // Dibuja la parte exterior del rayo en color celeste.
      stroke(0, 200, 255, 200);
      strokeWeight(10);
      line(centerX(), centerY(), e.x, e.y);

      // Dibuja una linea blanca en el centro para darle mayor detalle.
      stroke(255);
      strokeWeight(3);
      line(centerX(), centerY(), e.x, e.y);
    }

    // Restablece el grosor de las lineas y desactiva el borde de las figuras.
    strokeWeight(1);
    noStroke();
  }
}