import timeit
import time



def mide_tiempo(funcion):
    def funcion_medida(*args, **kwargs):
        inicio = time.time()
        c = funcion(*args, **kwargs)
        print(time.time() - inicio)
        return c
    return funcion_medida


@mide_tiempo
def find_numbers(n):
    result = []
    for i in range(1, n):
        
    
        if (mcd(i,n) == 1 ):
         
  
            result.append(i)
    return len(result)
def mcd(a, b):
    """
    Returns the MCD/GCD of two numbers using the Euclidean algorithm
    """
    while b != 0:
        temp = b
        b = a % b
        a = temp
    return a

n = int(input("Enter a value for n: "))


print(find_numbers(n))
