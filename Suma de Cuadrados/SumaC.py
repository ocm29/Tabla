

import math

def suma_cuadrados(n):
    squares = []

    while n > 0:
        # Buscamos el número más grande que sea un cuadrado y que sea menor o igual a n
        x = int(math.sqrt(n))

        # Agregamos el cuadrado a la lista de cuadrados
        squares.append(x)

        # Restamos el cuadrado del número n
        n -= x**2

    # Devolvemos la lista de cuadrados
    return squares
 
    # Iteramos hasta que el número se reduzca a cero
   
   

n = int(input("Enter a value for n: "))
sum ="[" + "+".join(suma_cuadrados(n)) + "]"
print( sum)
