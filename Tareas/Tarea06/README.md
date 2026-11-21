# Tarea Corta 6 - Juego de Nave

## Descripción
Esta tarea es la continuación del juego de naves Polymorphs de la Tarea Corta 5, desarrollado en Processing (modo Java). El objetivo es aplicar el **patrón de diseño Strategy** para que el comportamiento de los enemigos ya no dependa de la herencia, sino de objetos intercambiables: una estrategia de **bordes** (qué pasa cuando la nave llega al borde de la pantalla) y una estrategia de **movimiento** (cómo se mueve el enemigo cada vez que decide moverse). Combinando las estrategias se obtienen cuatro tipos de enemigos distintos. El juego permite:
- Mover la nave del jugador a la izquierda y a la derecha, y disparar proyectiles
- Enfrentar cuatro tipos de enemigos, cada uno con su propia combinación de estrategias
- Recibir mejoras por cada enemigo eliminado (más daño, más velocidad y curación)
- Ganar al eliminar a todos los enemigos, o perder cuando la vida del jugador llega a cero
- Reiniciar la partida en cualquier momento

## Cambios respecto a la Tarea Corta 5
- Se crean las interfaces `BorderStrategy` y `MoveStrategy`, con sus implementaciones concretas.
- `Ship` ya no tiene el rebote en bordes escrito dentro: lo delega en una `BorderStrategy`.
- `EnemyShip` ya no obliga a las subclases a implementar `move()`: lo delega en una `MoveStrategy`.
- `GameObject` agrega `getPos()` y `getVel()`, y `Ship` agrega `getStep()`, para que las estrategias puedan trabajar sobre el objeto.
- Se agregan dos enemigos nuevos (`WrapZigzagEnemy` y `WrapRandomEnemy`).
- `SniperEnemy` pasa a configurarse con estrategias (`BumpBorder` + `CustomMove`) en lugar de sobrescribir `move()`.
- `PolymorphsControl` crea los cuatro tipos de enemigos con nuevos parámetros de configuración.

## Requisitos del problema

### BorderStrategy (interfaz)
- Define cómo interactúa una nave con los bordes de la pantalla
- **apply(o: GameObject)**: Se invoca en cada ciclo, después de actualizar la física

### BumpBorder
- Estrategia de bordes **Bump**: el objeto rebota en los cuatro bordes y siempre permanece dentro de la pantalla
- Es el comportamiento original del juego

### WrapBorder
- Estrategia de bordes **Wrap**: si el objeto sale por el borde izquierdo o derecho, reaparece por el lado opuesto
- Los bordes superior e inferior no hacen wrap (según el enunciado); ahí el objeto rebota para no escaparse de la pantalla

### MoveStrategy (interfaz)
- Define cómo se mueve un enemigo cada vez que decide moverse (cada `stepFreq` ciclos)
- **move(e: EnemyShip)**: Realiza un movimiento aplicando fuerzas al enemigo

### RandomWalkMove
- Movimiento **Random walk**: elige al azar una de las cuatro direcciones (derecha, izquierda, abajo, arriba) y empuja al enemigo
- Es el movimiento original del juego

### ZigzagMove
- Movimiento **Zigzag**: el enemigo se empuja horizontalmente hacia un lado durante cierta cantidad de movimientos y luego hacia el lado contrario
- Un contador indica cuántos empujes quedan en la dirección actual; al llegar a cero se invierte la dirección y se genera una nueva duración aleatoria entre `minTime` y `maxTime`
- Guarda estado (dirección y contador), por lo que **cada enemigo necesita su propia instancia**

### CustomMove
- Movimiento **Custom**: el movimiento propio del francotirador de la tarea anterior
- Se empuja lentamente de lado a lado, con la dirección (izquierda o derecha) escogida al azar

### GameObject (clase abstracta)
- Posición, velocidad, aceleración, velocidad máxima, tamaño y color
- **update()**, **addForce()**, **collidesWith()** y el método abstracto **display()**
- **getPos()** y **getVel()**: retornan las referencias a los vectores, que las estrategias de bordes modifican directamente

### Ship (clase abstracta)
- Hereda de `GameObject`; agrega vida, daño, disparo con enfriamiento y amortiguamiento de velocidad
- Contiene una `BorderStrategy` y la invoca en cada `update()`
- **setBorderStrategy()**: Permite cambiar la estrategia incluso en tiempo de ejecución
- **getStep()**: Retorna la fuerza de empuje de la nave (la usan las estrategias de movimiento)
- **display()**: Método plantilla; cada nave define su dibujo en `drawBody()`

### PlayerShip
- Nave del jugador, dibujada como un caza con motor animado
- Usa `BumpBorder`, por lo que rebota en los bordes y no puede salir de la pantalla
- **heal()** recupera vida sin superar la inicial; **setSpeedStats()** aplica las mejoras de velocidad

### EnemyShip (clase abstracta)
- Hereda de `Ship`; agrega la decisión periódica de moverse (`stepFreq` y `randomness`)
- Contiene una `MoveStrategy`; **move()** delega en ella
- **setMoveStrategy()**: Permite cambiar la estrategia incluso en tiempo de ejecución
- Cada subclase concreta solo escoge la combinación de estrategias que usa

### Enemigos

| # | Clase | Bordes | Movimiento | Apariencia | Dispara |
|---|-------|--------|------------|------------|---------|
| 1 | `RandomEnemy` | `BumpBorder` | `RandomWalkMove` | Alienígena tipo Space Invaders (rojo) | Proyectiles |
| 2 | `WrapZigzagEnemy` | `WrapBorder` | `ZigzagMove` | Platillo volador con luces (naranja) | Proyectiles |
| 3 | `WrapRandomEnemy` | `WrapBorder` | `RandomWalkMove` | Fantasma con base ondulante (rosa) | Proyectiles |
| 4 | `SniperEnemy` | `BumpBorder` | `CustomMove` | Ojo con púas (morado) | Rayo |

### SniperEnemy
- Enemigo francotirador; no dispara proyectiles normales
- Funciona como una máquina de estados: **descanso** (`REST`), **carga** (`CHARGE`) y **rayo** (`BEAM`)
- Durante la carga muestra una línea de aviso que sigue al jugador y, en los últimos ciclos, bloquea la mira
- Al terminar la carga lanza un rayo instantáneo que daña al jugador solo si está sobre la línea (algoritmo de Liang-Barsky)

### Projectile
- Hereda de `GameObject`; agrega el daño que causa al chocar, su dibujo y `outOfScreen()`

### PolymorphsControl
- Controladora del juego: crea al jugador, los cuatro tipos de enemigos y las listas de proyectiles
- Actualiza y dibuja todos los objetos, revisa colisiones, aplica mejoras y atiende las acciones del usuario
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
- La partida comienza con **23 enemigos**, ubicados al azar en el tercio superior de la pantalla:
  - 8 enemigos aleatorios (Bump + Random walk)
  - 6 enemigos platillo (Wrap + Zigzag)
  - 6 enemigos fantasma (Wrap + Random walk)
  - 3 francotiradores (Bump + Custom)
- El jugador comienza con 300 puntos de vida; cada enemigo tiene 50 (80 el francotirador).
- Si cualquier enemigo toca al jugador, este pierde toda su vida.
- Los proyectiles enemigos quitan 12 puntos de vida; el rayo del francotirador quita 50.
- Los enemigos con proyectiles disparan con una probabilidad de 1% por ciclo, siempre que su enfriamiento lo permita (90 ciclos).
- Cada enemigo eliminado (baja) mejora al jugador:
  - **Daño**: +0.5 por baja, hasta un máximo de 30 (empieza en 10)
  - **Velocidad**: +2% por baja, hasta un máximo de 175%
  - **Vida**: recupera 8 puntos, sin superar su vida inicial
- Si el jugador elimina a todos los enemigos, gana (`YOU WON!`); si su vida llega a cero, pierde (`GAME OVER`).
- En pantalla se muestra el contador de bajas, el daño actual y la velocidad actual.

## Conceptos POO implementados

- **Patrón Strategy**: `BorderStrategy` y `MoveStrategy` encapsulan familias de algoritmos intercambiables que la nave usa sin conocer su implementación
- **Composición sobre herencia**: En lugar de crear una subclase por cada combinación de bordes y movimiento, las naves *tienen* una estrategia de cada tipo
- **Interfaces**: Contratos que implementan varias clases distintas (`BumpBorder`, `WrapBorder`, `RandomWalkMove`, `ZigzagMove`, `CustomMove`)
- **Polimorfismo**: `ship.borderStrategy.apply(this)` y `moveStrategy.move(this)` ejecutan la versión de la estrategia concreta; la lista `List<EnemyShip>` mezcla los cuatro tipos de enemigos
- **Inyección por constructor**: Cada enemigo concreto pasa sus estrategias al constructor de la superclase
- **Cambio de comportamiento en tiempo de ejecución**: `setBorderStrategy()` y `setMoveStrategy()`
- **Estado dentro de una estrategia**: `ZigzagMove` guarda su dirección y contador, por eso cada enemigo recibe su propia instancia
- **Principio abierto/cerrado**: Para agregar un nuevo comportamiento basta con crear una nueva estrategia, sin modificar `Ship` ni `EnemyShip`
- **Clases abstractas y método plantilla**: `GameObject`, `Ship` y `EnemyShip`; `Ship.display()` delega el dibujo en `drawBody()`
- **Herencia**: `GameObject` → `Ship` → `PlayerShip` / `EnemyShip` → enemigos concretos, y `GameObject` → `Projectile`
- **Máquina de estados**: `SniperEnemy` cambia entre `REST`, `CHARGE` y `BEAM`
- **Enumeración**: `Keys` define las acciones del teclado
- **Colecciones**: `LinkedList` (a través de `List`) con `Iterator` para eliminar elementos de forma segura

## Requisitos técnicos
- Processing 3 o superior (se recomienda Processing 4), en modo Java
- No requiere librerías externas

## Estructura del proyecto

```
Polymorphs/
├── Polymorphs.pde            - Programa principal (setup, draw y teclado)
├── PolymorphsControl.pde     - Controladora del juego y configuración
│
├── GameObject.pde            - Superclase abstracta de todo objeto del juego
├── Ship.pde                  - Superclase abstracta de las naves
├── PlayerShip.pde            - Nave del jugador
├── Projectile.pde            - Proyectiles
│
├── EnemyShip.pde             - Superclase abstracta de los enemigos
├── RandomEnemy.pde           - Enemigo 1: Bump + Random walk
├── WrapZigzagEnemy.pde       - Enemigo 2: Wrap + Zigzag
├── WrapRandomEnemy.pde       - Enemigo 3: Wrap + Random walk
├── SniperEnemy.pde           - Enemigo 4: Bump + Custom (francotirador)
│
├── BorderStrategy.pde        - Interfaz de estrategias de bordes
├── BumpBorder.pde            - Estrategia: rebote
├── WrapBorder.pde            - Estrategia: aparece por el lado opuesto
│
├── MoveStrategy.pde          - Interfaz de estrategias de movimiento
├── RandomWalkMove.pde        - Estrategia: caminata aleatoria
├── ZigzagMove.pde            - Estrategia: zigzag horizontal
└── CustomMove.pde            - Estrategia: movimiento lateral del francotirador
```

> En Processing, el nombre de la carpeta debe coincidir con el del archivo principal (`Polymorphs/Polymorphs.pde`). Los demás archivos `.pde` aparecen como pestañas del mismo sketch.

## Ejecución

### En el IDE de Processing:
1. Abrir `Polymorphs.pde` (se cargan automáticamente todas las pestañas de la carpeta).
2. Presionar el botón **Run** (▶) o usar `Ctrl + R` (`Cmd + R` en macOS).
3. Se abre una ventana de 800 x 600 píxeles con el juego.

## Parámetros de configuración

Todos los valores se definen como atributos en `PolymorphsControl`.

| Elemento | Parámetro | Valor |
|----------|-----------|-------|
| Jugador | Tamaño | 20 x 40 |
| Jugador | Vida inicial | 300 |
| Jugador | Velocidad máxima / paso | 2.5 / 0.5 |
| Jugador | Enfriamiento de disparo | 10 ciclos |
| Enemigos 1, 2 y 3 | Cantidad | 8 / 6 / 6 |
| Enemigos 1, 2 y 3 | Tamaño | 20 x 20 |
| Enemigos 1, 2 y 3 | Vida | 50 |
| Enemigos 1, 2 y 3 | Frecuencia de movimiento | cada 70 ciclos |
| Enemigo 2 (Zigzag) | Duración de cada tramo | 2 a 5 movimientos |
| Francotirador | Cantidad | 3 |
| Francotirador | Tamaño | 24 x 24 |
| Francotirador | Vida | 80 |
| Francotirador | Frecuencia de movimiento | cada 120 ciclos |
| Francotirador | Carga / bloqueo de mira | 100 / 30 ciclos |
| Francotirador | Duración del rayo / descanso | 10 / 240 ciclos |
| Francotirador | Daño del rayo | 50 |
| Proyectil del jugador | Tamaño / velocidad | 5 x 20 / 10 |
| Proyectil del jugador | Daño inicial / máximo | 10 / 30 |
| Proyectil enemigo | Daño / velocidad | 12 / 4 |

---

# DIAGRAMA CONCEPTUAL

## Patrón Strategy

```
                  ┌───────────────────────┐
                  │ <<interface>>         │
                  │ BorderStrategy        │
                  │ + apply(o)            │
                  └───────────▲───────────┘
                              │ implementa
                  ┌───────────┴───────────┐
                  │                       │
            ┌─────┴──────┐          ┌─────┴──────┐
            │ BumpBorder │          │ WrapBorder │
            └────────────┘          └────────────┘

┌───────────────┐  borderStrategy (1)
│     Ship      │──────────────────────▶ BorderStrategy
└───────┬───────┘
        │ hereda
┌───────┴───────┐  moveStrategy (1)
│  EnemyShip    │──────────────────────▶ MoveStrategy
└───────────────┘

                  ┌───────────────────────┐
                  │ <<interface>>         │
                  │ MoveStrategy          │
                  │ + move(e)             │
                  └───────────▲───────────┘
                              │ implementa
         ┌────────────────────┼────────────────────┐
         │                    │                    │
  ┌──────┴───────┐     ┌──────┴──────┐      ┌──────┴──────┐
  │RandomWalkMove│     │ ZigzagMove  │      │ CustomMove  │
  └──────────────┘     └─────────────┘      └─────────────┘
```

## Combinaciones de estrategias por enemigo

```
                      │ RandomWalkMove │ ZigzagMove │ CustomMove
──────────────────────┼────────────────┼────────────┼────────────
        BumpBorder    │  RandomEnemy   │     -      │ SniperEnemy
        WrapBorder    │ WrapRandomEnemy│WrapZigzag  │     -
                      │                │  Enemy     │
```

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
        ┌──────────────┬─────┴────────┬──────────────┐
        │              │              │              │
 ┌──────▼──────┐┌──────▼───────┐┌─────▼────────┐┌────▼────────┐
 │ RandomEnemy ││WrapZigzagEnemy││WrapRandomEnemy││ SniperEnemy │
 └─────────────┘└──────────────┘└──────────────┘└─────────────┘
```

## Diagrama de asociaciones

```
Polymorphs (1) ──── control (1) ──── PolymorphsControl

PolymorphsControl (1) ──── player (1) ──── PlayerShip
PolymorphsControl (1) ──── enemies (0..*) ──── EnemyShip
PolymorphsControl (1) ──── playerProjectiles (0..*) ──── Projectile
PolymorphsControl (1) ──── enemyProjectiles (0..*) ──── Projectile

Ship (1) ──── borderStrategy (1) ──── BorderStrategy
EnemyShip (1) ──── moveStrategy (1) ──── MoveStrategy

SniperEnemy (0..*) ──── target (1) ──── PlayerShip
```

---

# DIAGRAMA DE CLASES COMPLETO

```
╔════════════════════════════════════════════════════════╗
║ <<interface>> BORDERSTRATEGY                           ║
╠════════════════════════════════════════════════════════╣
║ + apply(o: GameObject): void                           ║
╚════════════════════════════════════════════════════════╝

╔════════════════════════════════════════════════════════╗
║ BUMPBORDER                  (implements BorderStrategy)║
╠════════════════════════════════════════════════════════╣
║ + apply(o: GameObject): void                           ║
╚════════════════════════════════════════════════════════╝

╔════════════════════════════════════════════════════════╗
║ WRAPBORDER                  (implements BorderStrategy)║
╠════════════════════════════════════════════════════════╣
║ + apply(o: GameObject): void                           ║
╚════════════════════════════════════════════════════════╝

╔════════════════════════════════════════════════════════╗
║ <<interface>> MOVESTRATEGY                             ║
╠════════════════════════════════════════════════════════╣
║ + move(e: EnemyShip): void                             ║
╚════════════════════════════════════════════════════════╝

╔════════════════════════════════════════════════════════╗
║ RANDOMWALKMOVE                (implements MoveStrategy)║
╠════════════════════════════════════════════════════════╣
║ + move(e: EnemyShip): void                             ║
╚════════════════════════════════════════════════════════╝

╔════════════════════════════════════════════════════════╗
║ ZIGZAGMOVE                    (implements MoveStrategy)║
╠════════════════════════════════════════════════════════╣
║ Atributos:                                             ║
║ - minTime: int                                         ║
║ - maxTime: int                                         ║
║ - direction: int  (1 = derecha, -1 = izquierda)        ║
║ - counter: int                                         ║
╠════════════════════════════════════════════════════════╣
║ Constructores:                                         ║
║ + ZigzagMove(minTime: int, maxTime: int)               ║
╠════════════════════════════════════════════════════════╣
║ Métodos:                                               ║
║ + move(e: EnemyShip): void                             ║
║ - randomTime(): int                                    ║
╚════════════════════════════════════════════════════════╝

╔════════════════════════════════════════════════════════╗
║ CUSTOMMOVE                    (implements MoveStrategy)║
╠════════════════════════════════════════════════════════╣
║ + move(e: EnemyShip): void                             ║
╚════════════════════════════════════════════════════════╝

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
║ + getPos(): PVector                                    ║
║ + getVel(): PVector                                    ║
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
║ # borderStrategy: BorderStrategy                       ║
╠════════════════════════════════════════════════════════╣
║ Constructores:                                         ║
║ + Ship(x, y, w, h, maxSpeed, step, speedDamp,          ║
║ lifePoints: float, fireCooldown: int, c: color,        ║
║ textColor: color, borderStrategy: BorderStrategy)      ║
╠════════════════════════════════════════════════════════╣
║ Métodos:                                               ║
║ + update(): void                                       ║
║ + setBorderStrategy(b: BorderStrategy): void           ║
║ + getStep(): float                                     ║
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
║ (usa BumpBorder)                                       ║
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
║ # moveStrategy: MoveStrategy                           ║
╠════════════════════════════════════════════════════════╣
║ Constructores:                                         ║
║ + EnemyShip(x, y, w, h, maxSpeed, step: float,         ║
║ stepFreq: int, speedDamp, lifePoints: float,           ║
║ fireCooldown: int, c: color,                           ║
║ borderStrategy: BorderStrategy,                        ║
║ moveStrategy: MoveStrategy)                            ║
╠════════════════════════════════════════════════════════╣
║ Métodos:                                               ║
║ + update(): void                                       ║
║ + move(): void  (delega en moveStrategy)               ║
║ + setMoveStrategy(m: MoveStrategy): void               ║
║ + firesProjectiles(): boolean                          ║
╚════════════════════════════════════════════════════════╝

╔════════════════════════════════════════════════════════╗
║ RANDOMENEMY                         (extends EnemyShip)║
║ Bump + Random walk                                     ║
╠════════════════════════════════════════════════════════╣
║ Constructores:                                         ║
║ + RandomEnemy(x, y, w, h, maxSpeed, step: float,       ║
║ stepFreq: int, speedDamp, lifePoints: float,           ║
║ fireCooldown: int, c: color)                           ║
╠════════════════════════════════════════════════════════╣
║ Métodos:                                               ║
║ # drawBody(): void                                     ║
╚════════════════════════════════════════════════════════╝

╔════════════════════════════════════════════════════════╗
║ WRAPZIGZAGENEMY                     (extends EnemyShip)║
║ Wrap + Zigzag                                          ║
╠════════════════════════════════════════════════════════╣
║ Constructores:                                         ║
║ + WrapZigzagEnemy(x, y, w, h, maxSpeed, step: float,   ║
║ stepFreq: int, speedDamp, lifePoints: float,           ║
║ fireCooldown: int, c: color,                           ║
║ zigzagMinTime: int, zigzagMaxTime: int)                ║
╠════════════════════════════════════════════════════════╣
║ Métodos:                                               ║
║ # drawBody(): void                                     ║
╚════════════════════════════════════════════════════════╝

╔════════════════════════════════════════════════════════╗
║ WRAPRANDOMENEMY                     (extends EnemyShip)║
║ Wrap + Random walk                                     ║
╠════════════════════════════════════════════════════════╣
║ Constructores:                                         ║
║ + WrapRandomEnemy(x, y, w, h, maxSpeed, step: float,   ║
║ stepFreq: int, speedDamp, lifePoints: float,           ║
║ fireCooldown: int, c: color)                           ║
╠════════════════════════════════════════════════════════╣
║ Métodos:                                               ║
║ # drawBody(): void                                     ║
╚════════════════════════════════════════════════════════╝

╔════════════════════════════════════════════════════════╗
║ SNIPERENEMY                         (extends EnemyShip)║
║ Bump + Custom                                          ║
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
║ - numberOfRandomEnemies: int (8)                       ║
║ - numberOfWrapZigzagEnemies: int (6)                   ║
║ - numberOfWrapRandomEnemies: int (6)                   ║
║ - numberOfSnipers: int (3)                             ║
║ - zigzagMinTime, zigzagMaxTime: int (2, 5)             ║
║ - (demás parámetros de jugador, enemigos,              ║
║ francotiradores, proyectiles y mejoras)                ║
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
Ship ────────────────────────────── BorderStrategy
1                                   1
(Cada nave tiene una estrategia de bordes)

EnemyShip ───────────────────────── MoveStrategy
1                                   1
(Cada enemigo tiene una estrategia de movimiento;
 ZigzagMove no se comparte entre enemigos)

PolymorphsControl ───────────────── PlayerShip
1                                   1

PolymorphsControl ───────────────── EnemyShip
1                                   0..*
(Lista polimórfica con los cuatro tipos de enemigos)

PolymorphsControl ───────────────── Projectile
1                                   0..* (dos listas: jugador y enemigos)

SniperEnemy ─────────────────────── PlayerShip
0..*                                1
```

---

## Características implementadas

### Patrón Strategy
- Dos puntos de variación independientes: bordes y movimiento
- Cuatro enemigos distintos a partir de la combinación de dos estrategias de bordes y tres de movimiento
- Las estrategias de bordes operan sobre `GameObject` (a través de `getPos()` y `getVel()`) y las de movimiento sobre `EnemyShip` (a través de `addForce()` y `getStep()`)
- Las estrategias se pueden reemplazar en tiempo de ejecución con `setBorderStrategy()` y `setMoveStrategy()`

### Encapsulamiento
- Los atributos de configuración de la controladora son privados
- Los atributos de las jerarquías (`pos`, `vel`, `lifePoints`, etc.) son `protected`
- Los detalles internos de `ZigzagMove` y `SniperEnemy` son privados

### Polimorfismo
- `enemies` es una `List<EnemyShip>` que mezcla los cuatro tipos de enemigos
- La controladora los trata a todos igual (`update()`, `display()`, `firesProjectiles()`), y cada uno responde según sus estrategias y su dibujo

### Física y colisiones
- Movimiento con fuerzas: la aceleración se suma a la velocidad, esta se limita y se suma a la posición
- Amortiguamiento de velocidad, y rebote (`BumpBorder`) o aparición por el lado opuesto (`WrapBorder`) en los bordes
- Colisión por rectángulos (`collidesWith`) para naves y proyectiles
- Intersección segmento-rectángulo (Liang-Barsky) para el rayo del francotirador

### Programa principal
- Lee las teclas con un arreglo de booleanos para permitir varias a la vez
- En cada ciclo de `draw()` ejecuta las acciones, actualiza y dibuja el juego

## Notas importantes
- `ZigzagMove` guarda estado (dirección y contador), por eso cada `WrapZigzagEnemy` crea su propia instancia; compartirla haría que todos los enemigos zigzaguearan sincronizados.
- `WrapBorder` solo aplica wrap en los bordes izquierdo y derecho: arriba y abajo rebota para que el enemigo no salga de la pantalla.
- Los enemigos con `WrapBorder` pueden estar parcialmente fuera de la pantalla mientras cruzan el borde; en ese momento siguen pudiendo colisionar.
- `getPos()` y `getVel()` retornan las referencias a los vectores (no copias) de forma intencional, porque las estrategias de bordes necesitan modificarlos.
- El jugador siempre usa `BumpBorder`, por lo que no puede salir de la pantalla.
- Todos los enemigos cuentan en la misma lista y cualquiera que toque al jugador le quita toda su vida.
- Al reiniciar (`R`) se vuelven a crear el jugador, los enemigos (con estrategias nuevas) y los proyectiles, y el contador de bajas vuelve a cero.
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
19/11/2026

## Institución
Instituto Tecnológico de Costa Rica
Escuela de Computación
Bachillerato en Ingeniería en Computación
