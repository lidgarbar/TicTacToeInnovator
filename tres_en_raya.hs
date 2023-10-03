-- Lidia García y Antonio Pecellín
-- Tres en raya escrito en Haskell
-- Creacioó de dos tipos algebraicos y uso de estos : Tablero y Movimiento
-- Creación de un módulo: TablerosMovimientos.hs
-- Uso de dos tipos abrastractos o librerías: Matriz y Array y Colas
-- 2 funciones básicas de prelude y Data.List: todo el proyecto
-- 2 funciones recursivas: juegoBucle, main y reinicio
-- 2 funciones por patrones:  separa, tableroLleno
-- 2 usos de guardas: muestraHistorial y hazMovimiento
-- 2 usos de case of: main y reinicio
-- 2 usos de listas por comprensión: tableroVacio, diagP y diagS
-- 2 usos de orden superior: listaMatriz y strrArr
-- uso declaraciones de tipos para todas las funciones definidas: en todo el modulo
import Data.Char
import Data.List
import Data.Array

-- Hacemos la importación del módulo creado para el manejo de tableros y movimientos
import TablerosMovimientos
--Hacemos la importación del módulo de colas que se usará para crear el tipo Historial
import ColaConListas

--Creamos una serie de tableros de ejemplos que nos servirán mas tarde para los ejemplos de las funciones
-- Tablero Vacio 
tVacio = [[V,V,V],[V,V,V],[V,V,V]]
-- Tablero Lleno Empatado
tLlenoEmpatado= [[X,O,X],[O,O,X],[X,X,O]]
histLlenoEmpatado = foldr actualizaHistorial vacia [(2,1),(2,2),(1,1),(1,2),(2,0),(0,1),(0,2),(1,0),(0,0)]
-- Tablero Ganador X
tGanadorX= [[X,X,X],[O,V,O],[V,V,V]]
histGanadorX =  foldr actualizaHistorial vacia [(0,0),(1,0),(0,1),(1,2),(0,2)]
--Tablero no ganador
tNoGanador = [[X,O,V],[V,V,V],[V,V,V]]
histNoGanador= actualizaHistorial (0,1) $ actualizaHistorial (0,0) vacia
--Tablero Casi Ganador a falta del movimiento (0,0) por el jugador X
tCasiGanadorX= [[V,X,X],[O,V,O],[V,V,V]]

-- Definiremos la funcion main. En ella llamaremos a un bucle que creará un 
-- tablero vacío inicial. Meteremos algunos mensajes de explicación del juego y una bienvenida
main = do
  putStrLn $ take 20 $ repeat '\n'
  putStrLn "\nBienvenido a nuestro miniproyecto!\n"
  putStrLn "Para hacer un movimiento, simplemente escribe 'LN' la L representa una letra mayuscula y será la columna mientras que la N es un numero del 0 al 9 y representará la fila.\n"
  putStrLn "Si quieres dejar de jugar puedes escribir 'salir'.\n"
  putStrLn "¿Quieres jugar? (s): "
  input <- getLine
  case input of
    -- Si el valor recibido es 's' hacemos llamada a la función bucle
    "s" -> juegoBucle tableroVacio X historialVacio
    -- Si recibimos un "salir" entonces no haremos llamada a nuestra funcion que inicializa el juego en cualquier momento
    "salir" -> return ()
    -- Si recibimos cualquier otra cosa debemos mostrar un mensaje de error y hacer llamada otra vez al main
    -- para que el jugador haga una elección correcta
    _ -> do 
              putStrLn "Input incorrecto. Porfavor escriba 's' si desea jugar. Si no quiere jugar escriba 'salir'. Gracias"
              main

-- Creamos un tipo Historial que será una cola de movimientos encargada de almacenarlos
-- a medida que avance el juego 
type Historial = Cola Movimiento

--Creamos un historial vacío que nos hará falta más adelante
historialVacio :: Historial
historialVacio = vacia

-- Dependiendo del input que reciba se reiniciará el juego o no
-- También damos la opción de visualizar el historial de la partida jugada o retomarla en algun punto
reinicio :: Historial -> IO()
reinicio hist = do
  putStrLn "¿Quieres iniciar otro juego, ver el historial de la partida o retomarla en algun punto ? (s/n/ver/retomar)"
  otraVez <- getLine
  case otraVez of 
    -- Si recibimos una 's' significa que quiere seguir jugando, por tanto haremos llamada a la funcion main
    "s" -> do 
            putStrLn $ take 20 $ repeat '\n'      
            main
    -- Si recibimos una 'n' es que ya no quiere jugar más, no deberemos devolver nada entonces
    "n" -> return ()
    -- Si queremos ver el historial recibiremos un "ver" y haremos llamada a la función encargada
    -- Tras esto volveremos a ejecutar reinicio por si desea volver a jugar
    "ver" -> do 
              putStrLn $ muestraHistorial hist 1
              reinicio hist
    -- Si recibimos retomar mostramos el historial de los moovimiento apra que elija el punto desde el que jugar de nuevo
    "retomar" -> do
                  putStrLn $ muestraHistorial hist 1
                  putStrLn $ "Indique desde que movimiento quiere retomarlo, escriba el numero de dicho movimiento"
                  movimiento <- getLine
                  --Miramos si ha dado un parametro valido 
                  let valido = esValido hist movimiento
                  case valido of
                    --En caso de que sea valido hacemos llamada a retomar 
                    True -> do retomar hist ((ord (movimiento!!0))-48)
                    -- Sino le informamos del error y hacemos otra vez llamada a reinicio
                    _ -> do 
                          putStrLn "Input erroneo. Porfavor escriba un número de movimiento válido "
                          reinicio hist

    -- Si recibimos cualquier otra cosa lanzaremos un error y haremos llamada a reinicio de nuevo para
    -- que haga la seleccion correcta
    _ -> do 
                putStrLn "Input erroneo. Porfavor escriba 's' , 'n' o 'ver' si desea visualizar el historial "
                reinicio hist

-- Esta funcion nos permite al final de la partida retomar el juego a partir de un momento
-- El historial que recibe es el de la partida entera y el entero el punto desde el que 
-- desea retomar la partida. Tras hayar los parametros actualizados hacemos llamada a juegoBucle
retomar:: Historial -> Int -> IO()
retomar hist n = juegoBucle tablero jugador historial
  where tablero = obtieneTableroHistorial tableroVacio hist n X
        jugador = if odd n then O else X
        historial = desapilaNHistorial hist n


-- La función bucleJuego es la que crea y administra el juego como tal
-- La variable queJugador nos indica a quien le toca jugar (si X u O)
-- en cada turno y la variable tablero nos dice como se halla el tablero
-- en dicho momento.
-- Como haskell no hace uso de bucles deberemos actualizar el estado del tablero 
--   pasandolo recursivamente a esta función que actuará como un bucle
juegoBucle :: Tablero -> Casilla -> Historial -> IO()
juegoBucle tablero jugadorChar historial = do
    
    -- Mostramos el tablero por pantalla y notificamos al usuario para que haga un movimiento
    putStrLn $ "\n" ++ (tableroStr tablero) ++ "\n"
    putStrLn $ "Jugador " ++ show[jugadorChar] ++ ", porfavor introduzca un movimiento: "
    line <- getLine
    -- Imprimimos 20 lineas vacias en la terminal
    putStrLn $ take 20 $ repeat '\n'
    --Si recibimos un 'salir' en mitad del juego, debemos terminar
    if "salir" == line then
      return ()
    else do
      --En cuaalquier otro caso, parseamos el movimiento del jugador
      let movimiento = parseaMovimiento line
      -- Si el movimiento es válido, recibiremos un True en la segunda posición de la tupla 'movimiento'
      if snd movimiento then do
        --Lo metemos en el historial 
        let historialAct = actualizaHistorial (fst movimiento) historial
        -- Lo aplicamos al tablero
        let tuplaNuevoTablero = hazMovimiento tablero (fst movimiento) jugadorChar
        -- Si el segundo elemento de la tupla 'tuplaNuevoTablero' es True es que todo ha ido bien
        if snd tuplaNuevoTablero then do
          -- Creamos la variable nuevoTablero que es el primer elemento de la tupla 'tuplaNuevoTablero'
          let nuevoTablero = fst tuplaNuevoTablero
          -- Miramos si ese movimiento fue ganador y si lo es lo notificamos y hacemos llamada a la funcion reinicio 
          if (esGanador nuevoTablero (fst movimiento)) then do
            putStrLn $ tableroStr nuevoTablero
            putStrLn $ "Jugador " ++ show[jugadorChar] ++ " es el ganador!"
            reinicio historialAct
          -- Miramos si hay un empate y si lo hay lo notificamos y hacemos llamada a la funcion reinicio
          else if tableroLleno nuevoTablero then do
            putStrLn $ tableroStr nuevoTablero
            putStrLn $ "Empate!"
            reinicio historialAct
          -- Si no hay un ganador ni un empate, seguiremos el juego
          else
            juegoBucle nuevoTablero (sigChar jugadorChar) historialAct

        -- En caso de que el movimiento se parseará correctamente pero no fuese ejecutado
        -- Significaría que no es un movimiento válido, ya sea porque esta fuera de los limites o porque dicha
        -- casilla estuviese ya ocupada, por tanto lo notificamos y volvemos a llamar a la funcion bucle
        else do
          putStrLn "Fuera de los limites! / Un jugador ya ha cogiddo esa posición!"
          putStrLn "Introduzca otro movimiento."
          juegoBucle tablero jugadorChar historial
      -- Si el movimiento fuese invalido, es decir, ni se pudo parsear, lo comunicamos y hacemos llamada a la funcion bucle
      else do
        putStrLn "Movimiento erroneo.\nPorfavor introduzca un movimiento valido del tipo LN."
        juegoBucle tablero jugadorChar historial

-----------------------------------------------------------------------------
--------------------------[Funciones con historial]--------------------------
-----------------------------------------------------------------------------
--Historial de ejemplo
histEj = actualizaHistorial (3,0) $ actualizaHistorial (2,0) $ actualizaHistorial (1,0) vacia 

--Esta función es la encargada de mantener actualizado el historial de movimientos 
actualizaHistorial:: Movimiento -> Historial -> Historial 
actualizaHistorial mov hist = inserta mov hist

-- Hacemos una función que nuestre el historial completo enumerando cada movimiento
muestraHistorial:: Historial -> Int -> String
muestraHistorial hist n
  | hist==historialVacio = ""
  | otherwise = "\n"++ "Movimiento " ++ show(n) ++ ", " ++ jugador ++": " ++ [letra] ++ show(l )  ++  muestraHistorial (resto hist) (n+1)
  where jugador = if (odd n) then "Jugador X" else "Jugador O"
        l = fst (primero hist)
        num = snd (primero hist)
        letra = chr(num + 65)

--Esta función obtiene el historial retorcediendo n numero de pasos
--Siempre recibe un tablero vacio en el cual se imprimen los n movimientos desados del historial
obtieneTableroHistorial ::Tablero -> Historial -> Int -> Casilla-> Tablero
obtieneTableroHistorial t hist n jugador
  | n==0 || hist==historialVacio = t
  | otherwise = obtieneTableroHistorial (fst (hazMovimiento t movimiento jugador)) (resto hist) (n-1) nuevojugador
  where movimiento = primero hist
        nuevojugador = sigChar jugador

-- Esta función comprueba que la entrada una vez escrito 'retomar' sea válida.
-- Es decir, que sea un número y que esté dentro del historial
esValido:: Historial -> String -> Bool
esValido hist strN = (elem sn ['0'..'9']) && (longitudHistorial hist)>((ord sn)-48) && ((ord sn)-48)>=0
  where sn = strN!!0

-- Esta función devuelve la longitud del historial.
longitudHistorial :: Historial -> Int
longitudHistorial hist 
    | esVacia hist = 0
    | otherwise = 1 + longitudHistorial rhist
    where rhist = resto hist

--Esta función es como la función desapila de pilas pero aplicado a colas.
--Es una recursión final por lo tanto tiene la primera función con la llamada y caso base
--Y la función auxiliar con el acumulador.
desapilaNHistorial:: Historial -> Int -> Historial
desapilaNHistorial hist n = if n==0 then hist else  (desapilaNHistorial' hist n historialVacio)

desapilaNHistorial':: Historial ->Int -> Historial ->Historial
desapilaNHistorial' histViejo n histNuevo = if n==0 then histNuevo else
   desapilaNHistorial' (resto histViejo) (n-1) (actualizaHistorial (primero histViejo) histNuevo )