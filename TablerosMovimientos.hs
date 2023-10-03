module TablerosMovimientos
    (Casilla(..),
     Matriz,
     Tablero,
     Movimiento,
     tableroVacio,
     hazMovimiento,
     parseaMovimiento,
     tableroStr,
     esGanador,
     tableroLleno,
     sigChar
        
    )where


import Data.Char
import Data.List
import Data.Array


-- Necesitamos definir un nuevo dato algebraico casilla
-- Este será la pieza mínima de nuestro tablero, los valores posibles a tomar son:
--  'X' si esta ocupada por el jugador x
--  'O' si esta ocupada por el jugador con dicha letra asignada
--  'V' si no está ocupada por ninguno de los jugadores
data Casilla = X | O | V deriving (Eq)
instance Show Casilla where
  show X = "X"
  show O = "O"
  show V = " "

--Definimos tipo Matriz para facilitar la obtención de determinadas posiciones del tablero.
type Matriz = Array (Int,Int) Casilla

-- Crearemos un tablero para representar el juego 
-- Un tablero será una lista de listas de caractereres
-- Con esos caractéres representaremos las posiciones de cada jugador:
--   los jugadores marcarán sus casillas con la 'X' y la 'O'
--   las casillas que no están ocupadas serán ocupadas por la casilla vacia 'V'
type Tablero = [[Casilla]]

-- Crearemos un tipo movimiento que será un par de enteros,
-- donde el primero será la columna y el segundo la fila
type Movimiento = (Int, Int)

-- El tablero vacío comienza con todos lodos los caracteres vacíos,
-- Para ello crearemos esta función básica que recibe un entero y devuelve un tablero vacío 3x3
tableroVacio :: Tablero
tableroVacio = [[V | _ <- [1..3]] | _ <- [1..3]]

-- Esta función devuelve el estado del tablero tras 
--   hacer un movimiento. Si este es inválido, el tablero      
--   original es devuelto sin efectuar ningún cambio y el valor booleano se pondrá a          
--   falso indicando que el movimiento inválido, en caso contraio se devulve el tablero
--   modificado y el valor booleano será True indicando que es válido              
hazMovimiento :: Tablero -> Movimiento -> Casilla -> (Tablero, Bool)
hazMovimiento b m jugadorChar
    | y < 0 || x < 0 || x >= w || y >= h  = (b, False) -- Fuera de los límites
    | coge2d x y mb /= V                  = (b, False) -- Casilla llena, puesto que no es 'V'
    | otherwise                           = (tf, True) -- Eoc será valido 
  where
    tf =  matrizTablero(pon2d x y jugadorChar mb)
    mb = listaMatriz b
    x = fst m           -- coordenada x
    y = snd m           -- coordenada y
    w = length $ head b -- ancho del tablero
    h = length b        -- alto del tablero

-- Parsea un string de movimiento (ej: "A2") a un Movimiento del tipo (Int, Int)
-- Además devuelve un flag booleano para comprobar si es válido o no, es decir,
-- si recibimos un movimiento del tipo "AA" o "99" o "C22" el valor booleano se pondrá a falso
-- mientras que si recibimos un movimiento válido se pondrá a verdadero
parseaMovimiento :: String -> (Movimiento, Bool)
parseaMovimiento str
    | length str /= 2                             = malMovimiento -- Más de 2 caracteres
    | (elem l ['A'..'Z']) && (elem n ['0'..'9'])  = ( ((ord n)-48,(ord l)-65), True )
    | otherwise                                   = malMovimiento -- Movimiento inválido
  where
    l = str!!0 -- Letra
    n = str!!1 -- Numero
    malMovimiento = ((0,0), False)


-- Convierte un tablero de tamaño NxN en un string representativo 
tableroStr :: Tablero -> String
tableroStr tablero =
  -- Junta todo lo hecho en el where
  -- Primero hacemos la fila con las separaciones del tablero
  -- Tras esto las enumeramos y las intercalamos con la separaciones necesarias
  -- Por ultimo le añadimos al incio las letras de las columnas junto con un salto de linea  
  letraColumna ++ "\n\n" ++ (intercalate filaSep $ enumeraFilaStr $ map filaStr tablero)

  where
    -- La anchura será cuanto mide en tablero pasado por parámetro, (aqui miramos la primera fila porque es cuadrado)
    anchura = length $ head tablero
    -- Coloca lineas verticales entre las casillas para separar cada una
    filaStr  = intercalate " | " . map (\x -> show[x])
    -- Añade de 1 a n junto a las filas, asi nos aseguramos de enumerarlas para que el jugador sepa donde hacer los movimientos deseados
    -- Lo que hacemos es iterar por cada fila y le añadimos el indice, un espacio y la fila cogida de la lista de filas
    enumeraFilaStr s = [(show n) ++ "  " ++ x | n <- [0..(length s)-1], x <- [s!!n]]
    -- Añade de la A..Z en n columnas como cabecera
    letraColumna  = "    " ++ (intercalate "     " $ strArr $ take anchura ['A'..])
    -- Genera los separadores de filas ("-----+-----+-----")
    -- Basicamente lo que hace es que por cada columna le añadimos '-' según su tamaño
    -- Más tarde cuando hemos acabado con la columna añadimos la separación entre columnas '+'
    -- Esto por cada columna hasta completar la fila, tras esto le añadimos el salto de linea al incio y final
    filaSep = "\n   " ++ (tail $ init $ intercalate "+" $ take anchura $ repeat "-----") ++ "\n"

-- Comprueba si hay un ganador
-- Como el tablero se actualiza en el lugar del último movimiento
--   es suficiente con comprobar la fila y columna donde tiene lugar
--   además, comprobamos las diagonales
esGanador :: Tablero -> Movimiento -> Bool
esGanador b m = horiz|| vert || diagPrincipal || diagSecundaria
  where
    dP             = diagP (listaMatriz b) -- Diagonal principal
    dS             = diagS (listaMatriz b) -- Diagonal secundaria
    --Comprueba si las diagonales, fila o columna contiene los mismos caracteres y asi un ganador
    horiz            = (todosIguales ( b !! (fst m) )) && (not $ all (== V) (b !! (fst m) ))
    vert           = (todosIguales ( map (!! (snd m)) b)) && (not $ all (== V) ( map (!! (snd m)) b))
    diagPrincipal   = (not $ all (== V) dP) && (todosIguales dP)
    diagSecundaria  = (not $ all (== V) dS) && (todosIguales dS)


-- Comprueba si ya no quedan espacios libres, es decir, casillas Vacias
tableroLleno :: Tablero -> Bool
--La lista vacia da false 
tableroLleno [] = False
--Miramos la primera lista
tableroLleno [[V,_,_],_,_] = False
tableroLleno [[_,V,_],_,_] = False
tableroLleno [[_,_,V],_,_] = False
--Miramos la segunda lista
tableroLleno [_,[V,_,_],_] = False
tableroLleno [_,[_,V,_],_] = False
tableroLleno [_,[_,_,V],_] = False
--Miramos la ultima lista
tableroLleno [_,_,[V,_,_]] = False
tableroLleno [_,_,[_,V,_]] = False
tableroLleno [_,_,[_,_,V]] = False
--Si no se cumple ninguna es verdadero
tableroLleno [_,_,_] = True



---------------------------------
-----[Funciones auxiliares]------
---------------------------------
-- Metemos un nuevo elemento a un array
pon :: Int -> a -> [a]-> [a]
pon pos nuevoVal list = take pos list ++ nuevoVal : drop (pos+1) list

-- Metemos un nuevo elemento a un array de dos dimensiones (2d) 
pon2d :: Int -> Int -> Casilla -> Matriz -> Matriz
pon2d x y nuevoVal m = m // [((x+1,y+1), nuevoVal)]

-- Cogido de la practica 8.1
separa :: Int -> [Casilla] -> Tablero
separa _ []  = []
separa n xs = take n xs : separa n (drop n xs)

--Pasar de matriz a tablero
matrizTablero :: Matriz -> Tablero
matrizTablero m = separa c (elems m)
  where c = (snd . snd) (bounds m)

-- Cogemos un elemento de un array de dos dimensiones (2d) 
coge2d :: Int -> Int -> Matriz -> Casilla
coge2d x y m = m!(x+1,y+1)

-- Convertimos un array de caracteres en un array de de strings 
strArr :: String -> [String]
strArr = map (\x -> [x])

-- sigChar X = O y vicerversa 
-- Alternamos el turno de los jugadores, si estaba jugando 'x' le toca a 'o' y viceversa
sigChar :: Casilla -> Casilla
sigChar actual = if actual == X then O else X

-- Mira si todos los elementos de un array son iguales 
todosIguales ::  [Casilla] -> Bool
todosIguales (x:xs) = all (==x) xs

-- Si tenemos una matriz cuadrada 
-- Coge la diagonal principal de la matriz
diagP :: Matriz -> [Casilla]
diagP p = elems $ array (1,n) [(i,p!(i,j))|i<-[1..n],j<-[1..n],i==j]
    where n = (fst . snd) (bounds p)

-- Si tenemos una matriz cuadrada 
-- Cogemos la diagonal secundaria de la matriz
diagS :: Matriz -> [Casilla]
diagS p =elems $ array (1,n) [(i,p!(i,n+1-i)) | i <- [1..n]]
  where n = (fst . snd) (bounds p)

--Funcion pasar de tablero a matriz
listaMatriz :: Tablero -> Matriz
listaMatriz xss = array ((1,1),(length xss, length $ head xss)) $ concat $ zipWith f [1..] xss
  where
    f i xs = zipWith g (zip [1..] xs) (repeat i)
    g (j,x) i = ((i,j),x)