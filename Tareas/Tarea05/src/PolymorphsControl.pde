/*
Instituto Tecnologico de Costa Rica

Nombre : Owel Jafet Gutierrez Ortiz

Carnet : 2026800869

Profesor : Mauricio Aviles Cisneros

Semana 15 : Tarea Corta 5 - Juego de Nave

Fecha de entrega : 12 / 11 / 2026

*/

/*
Clase : PolymorphsControl
	Controladora del juego. Crea al jugador, los enemigos y las listas de proyectiles,
	actualiza y dibuja todo, revisa las colisiones, aplica las mejoras por baja
	(daño, velocidad y curacion), dispara los proyectiles enemigos y atiende las
	acciones del usuario. Contiene todos los parametros de configuracion.
*/

// Clase encargada de controlar los elementos y funcionamiento del juego.
public class PolymorphsControl {

  // Objeto que representa al jugador.
  private PlayerShip player;

  // Lista que almacena todos los enemigos del juego.
  private List<EnemyShip> enemies;

  // Listas que almacenan los proyectiles del jugador y de los enemigos.
  private List<Projectile> playerProjectiles;
  private List<Projectile> enemyProjectiles;


  // CONFIGURACION DEL JUGADOR

  // Define la posicion inicial del jugador en la pantalla.
  private float playerStartX = width / 2;
  private float playerStartY = height - 20;

  // Define las dimensiones y velocidad del jugador.
  private float playerW = 20;
  private float playerH = 40;
  private float playerMaxSpeed = 2.5;
  private float playerStep = 0.5;
  private float playerSpeedDamp = 0.05;

  // Define la cantidad inicial de vida y el tiempo entre disparos.
  private float playerLifePoints = 300;
  private int playerFireCooldown = 10;

  // Define el color con el que se dibuja el jugador.
  private color playerColor = color(0, 255, 0);


  //  MEJORAS DEL JUGADOR 

  // Almacena la cantidad de enemigos que ha eliminado el jugador.
  private int kills = 0;

  // Define cuanto aumenta el daño de los proyectiles por cada baja.
  private float damageGainPerKill = 0.5;

  // Establece el daño maximo que pueden causar los proyectiles.
  private float maxProjectileDamage = 30;

  // Define el aumento de velocidad por cada enemigo eliminado.
  private float speedGainPerKill = 0.02;

  // Establece el limite maximo de aumento de velocidad.
  private float maxSpeedMultiplier = 1.75;

  // Define la cantidad de vida que recupera el jugador por cada baja.
  private float healPerKill = 8;


  //  CONFIGURACION DE LOS ENEMIGOS 

  // Define la cantidad de enemigos normales y francotiradores.
  private int numberOfEnemies = 20;
  private int numberOfSnipers = 3;

  // Define los limites donde pueden aparecer los enemigos.
  private float enemyStartMinX = 0;
  private float enemyStartMaxX = width;
  private float enemyStartMinY = 0;
  private float enemyStartMaxY = height / 3;

  // Define las dimensiones y velocidad de los enemigos normales.
  private float enemyW = 20;
  private float enemyH = 20;
  private float enemyMaxSpeed = 2;
  private float enemyStep = 2.5;
  private int enemyStepFreq = 70;
  private float enemySpeedDamp = 0.01;

  // Define la vida, color y tiempo entre disparos de los enemigos.
  private float enemyLifePoints = 50;
  private color enemyColor = color(255, 0, 0);
  private int enemyFireCooldown = 90;

  // Define la probabilidad de que un enemigo realice un disparo.
  private float enemyFireChance = 0.01;


  //  CONFIGURACION DE LOS FRANCOTIRADORES 

  // Define las dimensiones y velocidad de movimiento del francotirador.
  private float sniperW = 24;
  private float sniperH = 24;
  private float sniperStep = 1;
  private int sniperStepFreq = 120;

  // Define la cantidad de vida y el color del francotirador.
  private float sniperLifePoints = 80;
  private color sniperColor = color(170, 80, 255);

  // Define el tiempo que necesita para cargar y bloquear su objetivo.
  private int sniperChargeTime = 100;
  private int sniperLockTime = 30;

  // Define cuanto tiempo permanece visible el rayo.
  private int sniperBeamDuration = 10;

  // Define el tiempo de descanso entre cada disparo.
  private int sniperRestTime = 240;

  // Define el daño que causa el rayo del francotirador.
  private float sniperBeamDamage = 50;


  //  CONFIGURACION DE LOS PROYECTILES 

  // Define las dimensiones y velocidad maxima de los proyectiles.
  private float projectileW = 5;
  private float projectileH = 20;
  private float projectileMaxSpeed = 100;

  // Define el daño, color y velocidad inicial de los proyectiles.
  private float projectileDamage = 10;
  private color projectileColor = color(0, 255, 255);
  private float projectileDefaultSpeed = 10;


  //  PROYECTILES ENEMIGOS 

  // Define el daño, velocidad y color de los proyectiles enemigos.
  private float enemyProjectileDamage = 12;
  private float enemyProjectileSpeed = 4;
  private color enemyProjectileColor = color(255, 255, 0);


  // Constructor: inicia el juego llamando al metodo init().
  public PolymorphsControl() {
    init();
  }


  // Inicializa los objetos y valores necesarios para comenzar el juego.
  private void init() {

    // Reinicia el contador de enemigos eliminados.
    kills = 0;

    // Crea al jugador con los valores de configuracion establecidos.
    player = new PlayerShip(
      playerStartX, playerStartY, playerW, playerH,
      playerMaxSpeed, playerStep, playerSpeedDamp,
      playerLifePoints, playerFireCooldown, playerColor);

    // Crea una lista vacia para almacenar los enemigos.
    enemies = new LinkedList<EnemyShip>();

    // Crea los enemigos normales y los agrega a la lista.
    for (int i = 0; i < numberOfEnemies; i++) {
      enemies.add(new RandomEnemy(
        random(enemyStartMinX, enemyStartMaxX), random(enemyStartMinY, enemyStartMaxY),
        enemyW, enemyH, enemyMaxSpeed, enemyStep, enemyStepFreq, enemySpeedDamp,
        enemyLifePoints, enemyFireCooldown, enemyColor));
    }

    // Crea los francotiradores y los agrega a la misma lista de enemigos.
    for (int i = 0; i < numberOfSnipers; i++) {
      enemies.add(new SniperEnemy(
        random(enemyStartMinX, enemyStartMaxX), random(enemyStartMinY, enemyStartMaxY),
        sniperW, sniperH, enemyMaxSpeed, sniperStep, sniperStepFreq, enemySpeedDamp,
        sniperLifePoints, enemyFireCooldown, sniperColor,
        player, sniperChargeTime, sniperLockTime, sniperBeamDuration,
        sniperRestTime, sniperBeamDamage));
    }

    // Crea las listas que almacenaran los proyectiles de cada bando.
    playerProjectiles = new LinkedList<Projectile>();
    enemyProjectiles = new LinkedList<Projectile>();
  }


  // Actualiza el estado de los objetos del juego.
  public void update() {

    // Actualiza el movimiento y estado del jugador.
    player.update();

    // Actualiza los enemigos y comprueba si alguno fue eliminado.
    updateEnemies();

    // Actualiza los proyectiles disparados por el jugador.
    updateProjectiles(playerProjectiles);

    // Actualiza los proyectiles disparados por los enemigos.
    updateProjectiles(enemyProjectiles);

    // Comprueba si existen colisiones entre los objetos.
    checkCollisions();
  }


  // Actualiza los enemigos y controla sus acciones.
  private void updateEnemies() {

    // Crea un iterador para recorrer la lista de enemigos.
    Iterator<EnemyShip> it = enemies.iterator();

    while (it.hasNext()) {

      // Obtiene el siguiente enemigo de la lista.
      EnemyShip e = it.next();

      // Comprueba si el enemigo ya no tiene vida.
      if (e.isDead()) {

        // Elimina al enemigo de la lista.
        it.remove();

        // Aumenta el contador de bajas.
        kills++;

        // Aplica la mejora de velocidad correspondiente.
        applySpeedUpgrade();

        // Recupera vida del jugador por eliminar al enemigo.
        player.heal(healPerKill);

      } else {

        // Actualiza el movimiento y comportamiento del enemigo.
        e.update();

        // Comprueba si puede disparar, si el jugador sigue vivo
        // y si se cumple la probabilidad de realizar un disparo.
        if (e.firesProjectiles() && !player.isDead() && e.canFire() && random(1) < enemyFireChance) enemyFire(e);
      }
    }
  }


  // Actualiza todos los proyectiles de una lista.
  private void updateProjectiles(List<Projectile> list) {

    // Crea un iterador para recorrer los proyectiles.
    Iterator<Projectile> it = list.iterator();

    while (it.hasNext()) {

      // Obtiene el siguiente proyectil.
      Projectile p = it.next();

      // Comprueba si el proyectil salio de los limites de la pantalla.
      if (p.outOfScreen()) it.remove();

      // Si sigue dentro de la pantalla, actualiza su movimiento.
      else p.update();
    }
  }


  // Dibuja los elementos del juego en la pantalla.
  public void display() {

    // Dibuja al jugador.
    player.display();

    // Dibuja todos los enemigos y proyectiles.
    displayAll(enemies);
    displayAll(playerProjectiles);
    displayAll(enemyProjectiles);

    // Muestra un mensaje si el jugador pierde o si elimina a todos los enemigos.
    if (player.isDead()) showMessage("GAME OVER\n\npress R for restart");
    else if (enemies.isEmpty()) showMessage("¡YOU WON!\n\npress R for restart");

    // Muestra en pantalla las bajas, el daño y la velocidad actuales.
    fill(255);
    textAlign(LEFT);
    textSize(14);
    text("Bajas: " + kills + "   Daño: " + nf(currentPlayerDamage(), 0, 1)
      + "   Vel: " + nf(currentSpeedMultiplier() * 100, 0, 0) + "%", 10, 20);
  }


  // Recorre una lista de objetos y dibuja cada uno de ellos.
  private void displayAll(List<? extends GameObject> list) {
    for (GameObject o : list) o.display();
  }


  // Muestra un mensaje centrado en la pantalla.
  private void showMessage(String msg) {

    // Establece el color blanco para el texto.
    fill(255);

    // Centra el texto horizontalmente.
    textAlign(CENTER);

    // Define el tamano del texto.
    textSize(24);

    // Dibuja el mensaje en el centro de la pantalla.
    text(msg, width/2, height/2);
  }


  // Comprueba las colisiones entre el jugador, enemigos y proyectiles.
  private void checkCollisions() {

    // Si el jugador ya fue eliminado, no es necesario revisar colisiones.
    if (player.isDead()) return;

    // Comprueba si alguno de los enemigos choca directamente con el jugador.
    for (EnemyShip enemy : enemies) {
      if (enemy.collidesWith(player)) {

        // Si una nave toca al jugador, le quita toda su vida.
        player.damage(player.getLifePoints());
        return;
      }
    }

    // Comprueba las colisiones entre los proyectiles del jugador y los enemigos.
    for (EnemyShip enemy : enemies) {

      // Utiliza un iterador para recorrer los proyectiles del jugador.
      Iterator<Projectile> it = playerProjectiles.iterator();

      while (it.hasNext()) {

        // Obtiene el siguiente proyectil.
        Projectile proj = it.next();

        // Comprueba si el proyectil golpea al enemigo.
        if (enemy.collidesWith(proj)) {

          // Reduce la vida del enemigo segun el daño del proyectil.
          enemy.damage(proj.getDamage());

          // Elimina el proyectil despues del impacto.
          it.remove();
        }
      }
    }

    // Comprueba las colisiones entre los proyectiles enemigos y el jugador.
    Iterator<Projectile> it = enemyProjectiles.iterator();

    while (it.hasNext()) {

      // Obtiene el siguiente proyectil enemigo.
      Projectile proj = it.next();

      // Comprueba si el proyectil golpea al jugador.
      if (proj.collidesWith(player)) {

        // Reduce la vida del jugador segun el daño recibido.
        player.damage(proj.getDamage());

        // Elimina el proyectil despues del impacto.
        it.remove();
      }
    }
  }


  // Crea y dispara un proyectil desde la posicion de un enemigo.
  private void enemyFire(EnemyShip e) {

    // Crea el proyectil debajo de la posicion del enemigo.
    Projectile p = new Projectile(
      e.getX() + e.getW()/2, e.getY() + e.getH(),
      projectileW, projectileH, projectileMaxSpeed,
      enemyProjectileDamage, enemyProjectileColor);

    // Aplica una fuerza hacia abajo para que el proyectil avance.
    p.addForce(new PVector(0, enemyProjectileSpeed));

    // Registra que el enemigo realizo un disparo.
    e.fire();

    // Agrega el proyectil a la lista de proyectiles enemigos.
    enemyProjectiles.add(p);
  }


  // Calcula el daño actual de los proyectiles del jugador.
  private float currentPlayerDamage() {

    // Aumenta el daño segun las bajas, sin superar el limite establecido.
    return min(maxProjectileDamage, projectileDamage + kills * damageGainPerKill);
  }


  // Calcula el multiplicador de velocidad actual del jugador.
  private float currentSpeedMultiplier() {

    // Aumenta la velocidad por cada baja, sin superar el limite establecido.
    return min(maxSpeedMultiplier, 1 + kills * speedGainPerKill);
  }


  // Aplica la mejora de velocidad al jugador despues de cada baja.
  private void applySpeedUpgrade() {

    // Obtiene el multiplicador de velocidad actual.
    float m = currentSpeedMultiplier();

    // Actualiza la velocidad maxima y el paso de movimiento del jugador.
    player.setSpeedStats(playerMaxSpeed * m, playerStep * m);
  }


  //  ACCIONES DEL JUGADOR 

  // Ejecuta el movimiento del jugador hacia la derecha.
  public void moveRightAction() {
    player.moveRight();
  }

  // Ejecuta el movimiento del jugador hacia la izquierda.
  public void moveLeftAction() {
    player.moveLeft();
  }


  // Controla la accion de disparar del jugador.
  public void fireAction() {

    // Comprueba que el jugador siga vivo y que pueda realizar otro disparo.
    if (!player.isDead() && player.canFire()) {

      // Crea un nuevo proyectil en la posicion del jugador.
      Projectile p = new Projectile(
        player.getX() + player.getW()/2, player.getY(),
        projectileW, projectileH, projectileMaxSpeed,
        currentPlayerDamage(), projectileColor);

      // Aplica una fuerza hacia arriba para que el proyectil avance.
      p.addForce(new PVector(0, -projectileDefaultSpeed));

      // Registra que el jugador realizo un disparo.
      player.fire();

      // Agrega el proyectil a la lista de proyectiles del jugador.
      playerProjectiles.add(p);
    }
  }


  // Reinicia el juego llamando nuevamente al metodo de inicializacion.
  public void restartAction() {
    init();
  }
}