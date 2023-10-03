# TicTacToeInnovator
# Compilación del Juego

En la ruta del mismo hay que ejecutar el comando `ghc -o tres_en_raya tres_en_raya.hs` y posteriormente ejecutar el comando `./tres_en_raya`. Después de eso, hacemos lo siguiente desde el main:

1. **Comando para compilar y jugar:**
    - `Main> main`

2. A continuación aparecerá el siguiente mensaje:

    ```markdown
    Bienvenido a nuestro miniproyecto!

    Para hacer un movimiento, simplemente escribe 'LN' la L representa una letra mayúscula y será la columna mientras que la N es un número del 0 al 9 y representará la fila.

    Si quieres dejar de jugar puedes escribir 'salir'.

    ¿Quieres jugar? (s):
    ```

3. Iniciamos una partida escribiendo 's':

    ```markdown
    s
    ```

4. Vemos por pantalla el siguiente mensaje:

    ```markdown
        A     B     C

    0  [ ] | [ ] | [ ]
   ----+-----+----
    1  [ ] | [ ] | [ ]
   ----+-----+----
    2  [ ] | [ ] | [ ]

    Jugador [X], por favor introduzca un movimiento:
    ```

5. Ya estaría listo para jugar, experimenta con el juego.

# Prueba de las Funciones del Módulo

## Función "hazMovimiento"

- Prueba haciendo un movimiento inválido:
    - `Main> hazMovimiento tNoGanador (0,0) O` → `([[X,O, ],[ , , ],[ , , ]],False)`
- Prueba haciendo un movimiento válido:
    - `Main> hazMovimiento tNoGanador (0,2) O` → `([[X,O,O],[ , , ],[ , , ]],True)`

## Función "parseaMovimiento"

- Pruebas parseando movimientos inválidos:
    - `Main> parseaMovimiento "ZD"` → `((0,0),False)`
    - `Main> parseaMovimiento "55"` → `((0,0),False)`
- Prueba parseando un movimiento válido:
    - `Main> parseaMovimiento "B1"` → `((1,1),True)`

## Función "tableroStr"

- Prueba parseando un tablero válido:
    - `Main> tableroStr tGanadorX` →
        ```
            A     B     C

        0  [X] | [X] | [X]
       ----+-----+----
        1  [O] | [ ] | [O]
       ----+-----+----
        2  [ ] | [ ] | [ ]
        ```

## Función "esGanador"

- Prueba mirando un movimiento ganador en un tablero válido:
    - `Main> esGanador tGanadorX (0,0)` → `True`
- Prueba mirando un movimiento no ganador en un tablero válido:
    - `Main> esGanador tCasiGanadorX (1,0)` → `False`

## Función "tableroLleno"

- Prueba ejecutando la función en un tablero lleno:
    - `Main> tableroLleno tLlenoEmpatado` → `True`
- Pruebas ejecutando la función en tableros que no están llenos:
    - `Main> tableroLleno tVacio` → `False`
    - `Main> tableroLleno tGanadorX` → `False`

# Prueba de las Funciones de Historial

## Función "actualizaHistorial"

- Prueba ejecutando la función con un movimiento válido:
    - `Main> actualizaHistorial (0,0) histEj` → `C [(1,0),(2,0),(0,0)]`

## Función "muestraHistorial"

- Prueba con un historial válido:
    - `Main> muestraHistorial histEj 1` →
        ```
        Movimiento 1, Jugador X: A1
        Movimiento 2, Jugador O: A2
        Movimiento 3, Jugador X: A3
        ```

## Función "obtieneTableroHistorial"

- Prueba con un historial y parámetros válidos:
    - `Main> obtieneTableroHistorial tVacio histLlenoEmpatado 3 X` → `[[X, ,X],[O, , ],[ , , ]]`

## Función "esValido"

- Prueba con los parámetros válidos:
    - `Main> esValido histGanadorX "4"` → `True`
- Pruebas con un String inválido:
    - `Main> esValido histGanadorX "X"` → `False`
    - `Main> esValido histGanadorX "55"` → `False`

## Función "longitudHistorial"

- Prueba con historiales válidos:
    - `Main> longitudHistorial histGanadorX` → `5`
    - `Main> longitudHistorial histNoGanador` → `2`
    - `Main> longitudHistorial histLlenoEmpatado` → `9`

## Función "desapilaNHistorial"

- Pruebas con parámetros válidos:
    - `Main> desapilaNHistorial histNoGanador 1` → `C [(0,0)]`
    - `Main> desapilaNHistorial histGanadorX 3` → `C [(0,2),(1,2),(0,1)]`
    - Prueba con un entero mayor que la longitud del historial (de aquí la necesidad de `esValido`):
        - `Main> desapilaNHistorial histNoGanador 4` → `C [(0,0),(0,1),*** Exception: primero: cola vacía`
        - *CallStack (from HasCallStack):*
            `error, called at .\ColaConListas.hs:44:21 in main:ColaConListas`

