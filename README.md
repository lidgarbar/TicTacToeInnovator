# TicTacToeInnovator
COMPILACION DEL JUEGO:
En la ruta del mismo hay que ejecutar el comando ghc -o tres_en_raya tres_en_raya.hs y 
posteriormente ejecutar el comando .\tres_en_raya. Despues de eso hacemos lo siguiente desde el main

1-Comando para compilar y jugar:
    *Main> main

2-A continuación aparecerá el siguiente mensaje:
"
    Bienvenido a nuestro miniproyecto!

    Para hacer un movimiento, simplemente escribe 'LN' la L representa una letra mayuscula y será la columna mientras que la N es un numero del 0 al 9 y representará la fila.

    Si quieres dejar de jugar puedes escribir 'salir'.

    ¿Quieres jugar? (s):
"

3-Iniciamos una partida escribiendo 's':
    s

4-Vemos por pantalla el siguiente mensaje:
"
        A     B     C

    0  [ ] | [ ] | [ ]
   ----+-----+----
    1  [ ] | [ ] | [ ]
   ----+-----+----
    2  [ ] | [ ] | [ ]

    Jugador [X], porfavor introduzca un movimiento:
"

5.-Ya estaría listo para jugar, experimente con el juego.

PRUEBA DE LAS FUNCIONES DEL MODULO:
Funcion "hazMovimiento":
    Prueba haciendo un movimiento invalido
    *Main> hazMovimiento tNoGanador (0,0) O
    ([[X,O, ],[ , , ],[ , , ]],False)
    Prueba haciendo un movimiento valido
    *Main> hazMovimiento tNoGanador (0,2) O
    ([[X,O,O],[ , , ],[ , , ]],True)

Funcion "parseaMovimiento":
    Pruebas parseando movimientos invalidos
    *Main> parseaMovimiento "ZD"
    ((0,0),False)
    *Main> parseaMovimiento "55"
    ((0,0),False)
    Prueba parseando un movimiento valido
    *Main> parseaMovimiento "B1"
    ((1,1),True)

Funcion "tableroStr":
    Prueba parseando un tablero valido
    *Main> tableroStr tGanadorX 
    "    A     B     C\n\n0  [X] | [X] | [X]\n   ----+-----+----\n1  [O] | [ ] | [O]\n   ----+-----+----\n2  [ ] | [ ] | [ ]"

Funcion "esGanador":
    Prueba mirando un movimiento ganador en un tablero valido
    *Main> esGanador tGanadorX (0,0)    
    True
    Prueba mirando un movimiento no ganador en un tablero valido
    *Main> esGanador tCasiGanadorX (1,0)
    False

Funcion "tableroLleno":
    Prueba ejecutando la funcion en un tablero lleno:
    *Main> tableroLleno tLlenoEmpatado
    True
    Pruebas ejecutando la funcion en tableros que no estám llenos:
    *Main> tableroLleno tVacio        
    False
    *Main> tableroLleno tGanadorX
    False

PRUEBA DE LAS FUNCIONES DE HISTORIAL:
Funcion "actualizaHistorial":
    Prueba ejecutando la funcion con un movimiento valido:
    *Main> actualizaHistorial (0,0) histEj 
    C [(1,0),(2,0),(0,0)]

Funcion "muestraHistorial":
    Prueba con un historial valido
    *Main> muestraHistorial histEj 1
    "\nMovimiento 1, Jugador X: A1\nMovimiento 2, Jugador O: A2\nMovimiento 3, Jugador X: A3"

Funcion "obtieneTableroHistorial"
    Prueba con un historial y parametros validos
    *Main> obtieneTableroHistorial tVacio histLlenoEmpatado 3 X
    [[X, ,X],[O, , ],[ , , ]]

Funcion "esValido"
    Prueba con los parametros validos
    *Main> esValido histGanadorX "4"
    True
    Pruebas con un String invalido
    *Main> esValido histGanadorX "X"
    False
    *Main> esValido histGanadorX "55"
    False

Funcion "longitudHistorial"
    Prueba con historiales validos
    *Main> longitudHistorial histGanadorX
    5
    *Main> longitudHistorial histNoGanador   
    2   
    *Main> longitudHistorial histLlenoEmpatado
    9

Funcion "desapilaNHistorial"
    Pruebas con parametros validos 
    *Main> desapilaNHistorial histNoGanador 1
    C [(0,0)]
    *Main> desapilaNHistorial histGanadorX 3
    C [(0,2),(1,2),(0,1)]
    Prueba con un entero mayor que la longitud del historial (de aqui la necesidad de esValido)
    *Main> desapilaNHistorial histNoGanador 4
    C [(0,0),(0,1),*** Exception: primero: cola vacia
    CallStack (from HasCallStack):
    error, called at .\ColaConListas.hs:44:21 in main:ColaConListas
