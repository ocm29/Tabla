import math


def bezou(a,b):

    gcd, x, y = math.gcd(a, b), 0, 1
    prev_x, prev_y = 1, 0
    
    while b:
        c = a // b
        a, b = b, a % b
        x, prev_x = prev_x - c * x, x
        y, prev_y = prev_y - c * y, y
    
    return gcd, prev_x, prev_y
    4
a = int(input("Enter a value for a: "))
b = int(input("Enter a value for b: "))

d,x,y= bezou(a,b)

print(f"El máximo común divisor de {a} y {b} es {d}")
print(f"Coeficientes x e y: x = {x}, y = {y}")
print(f"{a} * {x} + {b} * {y} = {d}")