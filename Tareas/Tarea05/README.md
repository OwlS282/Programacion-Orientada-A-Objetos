# Tarea Corta 5 - Juego de Nave (Polymorphs)

## Descripción
Esta tarea consiste en la implementación de un juego de naves en Processing (modo Java) utilizando Programación Orientada a Objetos, con énfasis en herencia, clases abstractas y polimorfismo. El jugador controla una nave en la parte inferior de la pantalla y debe eliminar a todos los enemigos antes de perder su vida. El juego permite:
- Mover la nave del jugador a la izquierda y a la derecha, y disparar proyectiles
- Enfrentar dos tipos de enemigos con comportamientos distintos: enemigos aleatorios y francotiradores
- Recibir mejoras por cada enemigo eliminado (más daño, más velocidad y curación)
- Detectar colisiones entre naves y proyectiles
- Ganar al eliminar a todos los enemigos, o perder cuando la vida del jugador llega a cero
- Reiniciar la partida en cualquier momento

## Requisitos del problema

### GameObject (clase abstracta)
- **Posición, velocidad y aceleración**: Se manejan con `PVector`
- **Velocidad máxima, ancho, alto y color**: Atributos comunes a todo objeto del juego
- **update()**: Aplica la física básica (suma la aceleración, limita la velocidad y mueve el objeto)
- **addForce()**: Agrega una fuerza a la aceleración
- **collidesWith()**: Colisión rectángulo contra rectángulo
- **display()**: Método abstracto que cada subclase debe implementar

### Ship (clase abstracta)
- Hereda de `GameObject` y representa a las naves (jugador y enemigos)
- **Vida y daño**: `lifePoints`, `damage()`, `isDead()`
- **Disparo con enfriamiento**: `fire()` y `canFire()`
- **Amortiguamiento**: La velocidad disminuye en cada ciclo
- **Rebote en bordes**: La nave rebota y no puede salir de la pantalla
- **display()**: Método plantilla; cada nave define su dibujo en el método abstracto `drawBody()`

### PlayerShip
- Nave del jugador, dibujada como un caza con motor animado
- Se mueve con `moveLeft()` y `moveRight()`
- **heal()**: Recupera vida sin superar la vida inicial
- **setSpeedStats()**: Aplica las mejoras de velocidad
- Si muere, deja de actualizarse y de dibujarse

### EnemyShip (clase abstracta)
- Hereda de `Ship` y agrega la decisión periódica de moverse (`stepFreq` y `randomness`)
- **move()**: Método abstracto; cada enemigo define su patrón de movimiento
- **firesProjectiles()**: Indica si el enemigo dispara proyectiles normales

### RandomEnemy
- Enemigo básico, dibujado como un alienígena tipo Space Invaders con patas animadas
- Cada cierto tiempo se empuja en una dirección al azar (derecha, izquierda, abajo o arriba)
- Dispara proyectiles normales hacia abajo

### SniperEnemy
- Enemigo francotirador que no dispara proyectiles normales
- Funciona como una máquina de estados: **descanso** (`REST`), **carga** (`CHARGE`) y **rayo** (`BEAM`)
- Durante la carga muestra una línea de aviso que sigue al jugador y, en los últimos ciclos, bloquea la mira
- Al terminar la carga lanza un rayo instantáneo que daña al jugador solo si está sobre la línea
- Usa el algoritmo de Liang-Barsky para detectar si el rayo intersecta al jugador

### Projectile
- Hereda de `GameObject`
- Agrega el daño que causa al chocar, su dibujo y `outOfScreen()` para detectar cuando sale de la pantalla

### PolymorphsControl
- Controladora del juego: crea al jugador, los enemigos y las listas de proyectiles
- Actualiza y dibuja todos los objetos, revisa las colisiones y atiende las acciones del usuario
- Aplica las mejoras por baja y dispara los proyectiles enemigos
- Contiene todos los parámetros de configuración del juego

### Polymorphs (programa principal)
- Sketch de Processing: define `setup()`, `draw()`, `keyPressed()` y `keyReleased()`
- Usa un arreglo de booleanos y la enumeración `Keys` para permitir varias teclas a la vez

## Controles

| Tecla | Acción |
|-------|--------|
| ← (flecha izquierda) | Mover la nave a la izquierda |
| → (flecha derecha) | Mover la nave a la derecha |
| Barra espaciadora | Disparar |
| R | Reiniciar la partida |

## Reglas del juego
- La partida comienza con 20 enemigos aleatorios y 3 francotiradores, ubicados al azar en el tercio superior de la pantalla.
- El jugador comienza con 300 puntos de vida; cada enemigo tiene 50 (aleatorio) u 80 (francotirador).
- Si cualquier enemigo toca al jugador, este pierde toda su vida.
- Los proyectiles enemigos quitan 12 puntos de vida; el rayo del francotirador quita 50.
- Los enemigos aleatorios disparan con una probabilidad de 1% por ciclo, siempre que su enfriamiento lo permita (90 ciclos).
- Cada enemigo eliminado (baja) mejora al jugador:
  - **Daño**: +0.5 por baja, hasta un máximo de 30 (empieza en 10)
  - **Velocidad**: +2% por baja, hasta un máximo de 175%
  - **Vida**: recupera 8 puntos, sin superar su vida inicial
- Si el jugador elimina a todos los enemigos, gana (`YOU WON!`).
- Si la vida del jugador llega a cero, pierde (`GAME OVER`).
- En pantalla se muestra el contador de bajas, el daño actual y la velocidad actual.

## Conceptos POO implementados

- **Encapsulamiento**: Atributos `private` y `protected`, con getters para lectura
- **Herencia**: Jerarquía `GameObject` → `Ship` → `PlayerShip` / `EnemyShip` → `RandomEnemy` / `SniperEnemy`, y `GameObject` → `Projectile`
- **Clases abstractas**: `GameObject`, `Ship` y `EnemyShip` no se pueden instanciar y obligan a las subclases a implementar `display()`, `drawBody()` y `move()`
- **Polimorfismo**: La lista `List<EnemyShip>` guarda enemigos de distintos tipos; al llamar `update()`, `display()`, `move()` o `firesProjectiles()` se ejecuta la versión de cada subclase
- **Patrón método plantilla**: `Ship.display()` define los pasos (dibujar cuerpo y vida) y delega el dibujo en `drawBody()`
- **Sobrescritura y `super`**: Los métodos `update()`, `display()`, `lifeTextY()` y `firesProjectiles()` se redefinen y reutilizan el comportamiento de la superclase
- **Genéricos con comodines**: `displayAll(List<? extends GameObject>)` dibuja enemigos y proyectiles con un mismo método
- **Enumeración**: `Keys` define las acciones del teclado (`LEFT`, `RIGHT`, `FIRE`, `RESTART`)
- **Máquina de estados**: `SniperEnemy` cambia entre `REST`, `CHARGE` y `BEAM`
- **Asociaciones**: `PolymorphsControl` contiene al jugador, los enemigos y los proyectiles; `SniperEnemy` mantiene una referencia a `PlayerShip` como objetivo
- **Colecciones**: `LinkedList` (a través de la interfaz `List`) con `Iterator` para eliminar elementos de forma segura mientras se recorren

## Requisitos técnicos
- Processing 3 o superior (se recomienda Processing 4), en modo Java
- No requiere librerías externas

## Estructura del proyecto

```
Polymorphs/
├── Polymorphs.pde            - Programa principal (setup, draw y teclado)
├── PolymorphsControl.pde     - Controladora del juego y configuración
├── GameObject.pde            - Superclase abstracta de todo objeto del juego
├── Ship.pde                  - Superclase abstracta de las naves
├── PlayerShip.pde            - Nave del jugador
├── EnemyShip.pde             - Superclase abstracta de los enemigos
├── RandomEnemy.pde           - Enemigo de movimiento aleatorio
├── SniperEnemy.pde           - Enemigo francotirador
└── Projectile.pde            - Proyectiles
```

> En Processing, el nombre de la carpeta debe coincidir con el del archivo principal (`Polymorphs/Polymorphs.pde`). Los demás archivos `.pde` aparecen como pestañas del mismo sketch.

## Ejecución

### En el IDE de Processing:
1. Abrir `Polymorphs.pde` (se cargan automáticamente todas las pestañas de la carpeta).
2. Presionar el botón **Run** (▶) o usar `Ctrl + R` (`Cmd + R` en macOS).
3. Se abre una ventana de 800 x 600 píxeles con el juego.

## Parámetros de configuración

Todos los valores se definen como atributos en `PolymorphsControl`, de modo que se puede cambiar la dificultad sin tocar las demás clases.

| Elemento | Parámetro | Valor |
|----------|-----------|-------|
| Jugador | Tamaño | 20 x 40 |
| Jugador | Vida inicial | 300 |
| Jugador | Velocidad máxima / paso | 2.5 / 0.5 |
| Jugador | Enfriamiento de disparo | 10 ciclos |
| Enemigo aleatorio | Cantidad | 20 |
| Enemigo aleatorio | Tamaño | 20 x 20 |
| Enemigo aleatorio | Vida | 50 |
| Enemigo aleatorio | Frecuencia de movimiento | cada 70 ciclos |
| Francotirador | Cantidad | 3 |
| Francotirador | Tamaño | 24 x 24 |
| Francotirador | Vida | 80 |
| Francotirador | Carga / bloqueo de mira | 100 / 30 ciclos |
| Francotirador | Duración del rayo / descanso | 10 / 240 ciclos |
| Francotirador | Daño del rayo | 50 |
| Proyectil del jugador | Tamaño / velocidad | 5 x 20 / 10 |
| Proyectil del jugador | Daño inicial / máximo | 10 / 30 |
| Proyectil enemigo | Daño / velocidad | 12 / 4 |

---

# DIAGRAMA CONCEPTUAL

## Jerarquía de herencia

```
                    ┌──────────────────────┐
                    │ GameObject           │
                    │ <<abstract>>         │
                    └──────────┬───────────┘
                               │
              ┌────────────────┴────────────────┐
              │                                 │
   ┌──────────▼───────────┐          ┌──────────▼───────────┐
   │ Ship                 │          │ Projectile           │
   │ <<abstract>>         │          └──────────────────────┘
   └──────────┬───────────┘
              │
     ┌────────┴──────────────┐
     │                       │
┌────▼─────────┐   ┌─────────▼────────────┐
│ PlayerShip   │   │ EnemyShip            │
└──────────────┘   │ <<abstract>>         │
                   └─────────┬────────────┘
                             │
                    ┌────────┴─────────┐
                    │                  │
             ┌──────▼───────┐   ┌──────▼───────┐
             │ RandomEnemy  │   │ SniperEnemy  │
             └──────────────┘   └──────────────┘
```

## Diagrama de asociaciones

```
Polymorphs (1) ──── control (1) ──── PolymorphsControl

PolymorphsControl (1) ──── player (1) ──── PlayerShip
PolymorphsControl (1) ──── enemies (0..*) ──── EnemyShip
PolymorphsControl (1) ──── playerProjectiles (0..*) ──── Projectile
PolymorphsControl (1) ──── enemyProjectiles (0..*) ──── Projectile

SniperEnemy (0..*) ──── target (1) ──── PlayerShip
        El francotirador conoce al jugador para apuntarle
```

---

# DIAGRAMA DE CLASES COMPLETO

```
╔════════════════════════════════════════════════════════╗
║ <<abstract>> GAMEOBJECT                                ║
╠════════════════════════════════════════════════════════╣
║ Atributos:                                             ║
║ # pos: PVector                                         ║
║ # vel: PVector                                         ║
║ # acc: PVector                                         ║
║ # maxSpeed: float                                      ║
║ # w: float                                             ║
║ # h: float                                             ║
║ # c: color                                             ║
╠════════════════════════════════════════════════════════╣
║ Constructores:                                         ║
║ + GameObject(x, y, w, h: float, maxSpeed: float,       ║
║ c: color)                                              ║
╠════════════════════════════════════════════════════════╣
║ Métodos:                                               ║
║ + update(): void                                       ║
║ + display(): void (abstracto)                          ║
║ + addForce(f: PVector): void                           ║
║ + collidesWith(o: GameObject): boolean                 ║
║ + getX(): float                                        ║
║ + getY(): float                                        ║
║ + getW(): float                                        ║
║ + getH(): float                                        ║
╚════════════════════════════════════════════════════════╝

╔════════════════════════════════════════════════════════╗
║ <<abstract>> SHIP                       (extends       ║
║                                          GameObject)   ║
╠════════════════════════════════════════════════════════╣
║ Atributos:                                             ║
║ # step: float                                          ║
║ # speedDamp: float                                     ║
║ # lifePoints: float                                    ║
║ # fireCooldown: int                                    ║
║ # fireCounter: int                                     ║
║ # textColor: color                                     ║
╠════════════════════════════════════════════════════════╣
║ Constructores:                                         ║
║ + Ship(x, y, w, h, maxSpeed, step, speedDamp,          ║
║ lifePoints: float, fireCooldown: int, c: color,        ║
║ textColor: color)                                      ║
╠════════════════════════════════════════════════════════╣
║ Métodos:                                               ║
║ + update(): void                                       ║
║ # borders(): void                                      ║
║ + display(): void                                      ║
║ # drawBody(): void (abstracto)                         ║
║ # lifeTextY(): float                                   ║
║ # drawLife(): void                                     ║
║ + addLifePoints(i: float): void                        ║
║ + getLifePoints(): float                               ║
║ + damage(d: float): void                               ║
║ + isDead(): boolean                                    ║
║ + fire(): void                                         ║
║ + canFire(): boolean                                   ║
╚════════════════════════════════════════════════════════╝

╔════════════════════════════════════════════════════════╗
║ PLAYERSHIP                              (extends Ship) ║
╠════════════════════════════════════════════════════════╣
║ Atributos:                                             ║
║ - maxLifePoints: float                                 ║
╠════════════════════════════════════════════════════════╣
║ Constructores:                                         ║
║ + PlayerShip(x, y, w, h, maxSpeed, step, speedDamp,    ║
║ lifePoints: float, fireCooldown: int, c: color)        ║
╠════════════════════════════════════════════════════════╣
║ Métodos:                                               ║
║ + update(): void                                       ║
║ + display(): void                                      ║
║ # drawBody(): void                                     ║
║ # lifeTextY(): float                                   ║
║ + moveRight(): void                                    ║
║ + moveLeft(): void                                     ║
║ + heal(amount: float): void                            ║
║ + setSpeedStats(maxSpeed: float, step: float): void    ║
╚════════════════════════════════════════════════════════╝

╔════════════════════════════════════════════════════════╗
║ <<abstract>> ENEMYSHIP                  (extends Ship) ║
╠════════════════════════════════════════════════════════╣
║ Atributos:                                             ║
║ # stepFreq: int                                        ║
║ # randomness: int                                      ║
╠════════════════════════════════════════════════════════╣
║ Constructores:                                         ║
║ + EnemyShip(x, y, w, h, maxSpeed, step: float,         ║
║ stepFreq: int, speedDamp, lifePoints: float,           ║
║ fireCooldown: int, c: color)                           ║
╠════════════════════════════════════════════════════════╣
║ Métodos:                                               ║
║ + update(): void                                       ║
║ + move(): void (abstracto)                             ║
║ + firesProjectiles(): boolean                          ║
╚════════════════════════════════════════════════════════╝

╔════════════════════════════════════════════════════════╗
║ RANDOMENEMY                         (extends EnemyShip)║
╠════════════════════════════════════════════════════════╣
║ Constructores:                                         ║
║ + RandomEnemy(x, y, w, h, maxSpeed, step: float,       ║
║ stepFreq: int, speedDamp, lifePoints: float,           ║
║ fireCooldown: int, c: color)                           ║
╠════════════════════════════════════════════════════════╣
║ Métodos:                                               ║
║ + move(): void                                         ║
║ # drawBody(): void                                     ║
╚════════════════════════════════════════════════════════╝

╔════════════════════════════════════════════════════════╗
║ SNIPERENEMY                         (extends EnemyShip)║
╠════════════════════════════════════════════════════════╣
║ Atributos:                                             ║
║ - REST: int (constante, 0)                             ║
║ - CHARGE: int (constante, 1)                           ║
║ - BEAM: int (constante, 2)                             ║
║ - target: PlayerShip                                   ║
║ - state: int                                           ║
║ - timer: int                                           ║
║ - chargeTime: int                                      ║
║ - lockTime: int                                        ║
║ - beamDuration: int                                    ║
║ - restTime: int                                        ║
║ - beamDamage: float                                    ║
║ - aimX, aimY: float                                    ║
╠════════════════════════════════════════════════════════╣
║ Constructores:                                         ║
║ + SniperEnemy(x, y, w, h, maxSpeed, step: float,       ║
║ stepFreq: int, speedDamp, lifePoints: float,           ║
║ fireCooldown: int, c: color, target: PlayerShip,       ║
║ chargeTime, lockTime, beamDuration, restTime: int,     ║
║ beamDamage: float)                                     ║
╠════════════════════════════════════════════════════════╣
║ Métodos:                                               ║
║ + move(): void                                         ║
║ + firesProjectiles(): boolean                          ║
║ + update(): void                                       ║
║ + display(): void                                      ║
║ # drawBody(): void                                     ║
║ - aim(): void                                          ║
║ - centerX(): float                                     ║
║ - centerY(): float                                     ║
║ - beamEnd(): PVector                                   ║
║ - beamHitsTarget(): boolean                            ║
║ - segmentHitsRect(x0, y0, x1, y1, rx, ry, rw, rh:      ║
║ float): boolean                                        ║
╚════════════════════════════════════════════════════════╝

╔════════════════════════════════════════════════════════╗
║ PROJECTILE                          (extends GameObject)║
╠════════════════════════════════════════════════════════╣
║ Atributos:                                             ║
║ - damage: float                                        ║
╠════════════════════════════════════════════════════════╣
║ Constructores:                                         ║
║ + Projectile(x, y, w, h, maxSpeed, damage: float,      ║
║ c: color)                                              ║
╠════════════════════════════════════════════════════════╣
║ Métodos:                                               ║
║ + display(): void                                      ║
║ + outOfScreen(): boolean                               ║
║ + getDamage(): float                                   ║
╚════════════════════════════════════════════════════════╝

╔════════════════════════════════════════════════════════╗
║ <<enumeration>> KEYS                                   ║
╠════════════════════════════════════════════════════════╣
║ LEFT                                                   ║
║ RIGHT                                                  ║
║ FIRE                                                   ║
║ RESTART                                                ║
╚════════════════════════════════════════════════════════╝

╔════════════════════════════════════════════════════════╗
║ POLYMORPHSCONTROL                                      ║
╠════════════════════════════════════════════════════════╣
║ Atributos principales:                                 ║
║ - player: PlayerShip                                   ║
║ - enemies: List<EnemyShip>                             ║
║ - playerProjectiles: List<Projectile>                  ║
║ - enemyProjectiles: List<Projectile>                   ║
║ - kills: int                                           ║
║ - (parámetros de configuración del jugador,            ║
║ enemigos, francotiradores, proyectiles y mejoras)      ║
╠════════════════════════════════════════════════════════╣
║ Constructores:                                         ║
║ + PolymorphsControl()                                  ║
╠════════════════════════════════════════════════════════╣
║ Métodos:                                               ║
║ - init(): void                                         ║
║ + update(): void                                       ║
║ - updateEnemies(): void                                ║
║ - updateProjectiles(list: List<Projectile>): void      ║
║ + display(): void                                      ║
║ - displayAll(list: List<? extends GameObject>): void   ║
║ - showMessage(msg: String): void                       ║
║ - checkCollisions(): void                              ║
║ - enemyFire(e: EnemyShip): void                        ║
║ - currentPlayerDamage(): float                         ║
║ - currentSpeedMultiplier(): float                      ║
║ - applySpeedUpgrade(): void                            ║
║ + moveRightAction(): void                              ║
║ + moveLeftAction(): void                               ║
║ + fireAction(): void                                   ║
║ + restartAction(): void                                ║
╚════════════════════════════════════════════════════════╝

╔════════════════════════════════════════════════════════╗
║ POLYMORPHS (sketch principal)                          ║
╠════════════════════════════════════════════════════════╣
║ Variables globales:                                    ║
║ control: PolymorphsControl                             ║
║ keyStatus: Boolean[]                                   ║
╠════════════════════════════════════════════════════════╣
║ Funciones:                                             ║
║ setup(): void                                          ║
║ draw(): void                                           ║
║ keyPressed(): void                                     ║
║ keyReleased(): void                                    ║
╚════════════════════════════════════════════════════════╝
```

## Asociaciones y multiplicidades

```
PolymorphsControl ────────────────────── PlayerShip
1                                        1

PolymorphsControl ────────────────────── EnemyShip
1                                        0..*
(Lista polimórfica: RandomEnemy y SniperEnemy)

PolymorphsControl ────────────────────── Projectile
1                                        0..* (dos listas: jugador y enemigos)

SniperEnemy ──────────────────────────── PlayerShip
0..*                                     1
(Navegabilidad de SniperEnemy hacia PlayerShip)
```

---

## Características implementadas

### Encapsulamiento
- Los atributos de configuración de la controladora son privados
- Los atributos de las jerarquías (`pos`, `vel`, `lifePoints`, etc.) son `protected` para que las subclases los usen
- Los detalles internos del francotirador (estados, mira, geometría del rayo) son privados

### Polimorfismo
- `enemies` es una `List<EnemyShip>` que mezcla `RandomEnemy` y `SniperEnemy`
- La controladora los trata a todos igual: `e.update()`, `e.firesProjectiles()` y `display()`
- Cada tipo de enemigo responde a su manera: movimiento aleatorio, o francotirador que carga y dispara un rayo

### Física y colisiones
- Movimiento con fuerzas: la aceleración se suma a la velocidad, esta se limita y se suma a la posición
- Amortiguamiento de velocidad y rebote en los bordes de la pantalla
- Colisión por rectángulos (`collidesWith`) para naves y proyectiles
- Intersección segmento-rectángulo (Liang-Barsky) para el rayo del francotirador

### Mejoras y balance
- Daño, velocidad y curación del jugador crecen con las bajas, con límites máximos para mantener el balance
- Los enemigos tienen un valor aleatorio (`randomness`) para no moverse todos al mismo tiempo

### Programa principal
- Lee las teclas con un arreglo de booleanos para permitir varias a la vez (por ejemplo, moverse y disparar)
- En cada ciclo de `draw()` ejecuta las acciones, actualiza y dibuja el juego

## Notas importantes
- `PolymorphsControl` se crea dentro de `setup()`, después de `size()`, por eso puede usar `width` y `height` al inicializar sus atributos.
- Los francotiradores también están en la lista de enemigos: se pueden eliminar a disparos, y si uno toca al jugador este pierde toda su vida.
- El rayo del francotirador solo hace daño en el instante en que termina la carga, y únicamente si el jugador está sobre la línea en ese momento.
- Al reiniciar (`R`) se vuelven a crear el jugador, los enemigos y los proyectiles, y el contador de bajas vuelve a cero.
- No se guardan datos en disco: toda la partida vive en memoria.
- Se siguieron las convenciones de nomenclatura de Java.

## Autor
Owel Jafet Gutiérrez Ortiz

## Carnet
2026800869

## Profesor
Mauricio Avilés Cisneros

## Curso
Programación Orientada a Objetos

## Fecha de entrega
12/11/2026

## Institución
Instituto Tecnológico de Costa Rica
Escuela de Computación
Bachillerato en Ingeniería en Computación