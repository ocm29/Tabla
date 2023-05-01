problema =  "fbdeciahg"\
            "eaigbhfcd"\
            "hcgfadbie"\
            "adchfegbi"\
            "iehbdgcfa"\
            "gfbciadeh"\
            "cgaiefhdb"\
            "difahbegc"\
            "bhedgciaf"

"""
    Convierte un problema en formato cadena a matriz
    :parametro problema: Una cadena de 81 digitos.
    :return: Una matriz (lista de listas)
    """
def str_sudoku(problema):
    
    
    matriz = []
    for fila in range(9):
        matriz.append(list(problema[fila * 9: (fila + 1) * 9]))
    return matriz
"""
    Imprime un sudoku
    :param sudoku: La matriz (lista de listas)
    """



def print_sudoku(sudoku):
    
    for fila in sudoku:
        for columna in fila:
            print(columna, end=" ")
        print()
    print()

def cerrada(lista):
    m = len(lista) 
    i = 0
    n = 0
    while not(i>=m):
            if  not lista[i].isalpha():
                return False
                
            i=i+1  
    
    return True


    

def revisar9(lista):
    
    return len(set(lista)) == 9
 
    """
    Revisa que la lista contenga los digitos 1-9
    sin faltar.
    :param lista: Una lista de 9 enteros
    :return: True si la lista contiene todos los
    digitos de 1 a 9.
    """
    
 

def extraer_caja(sudoku, numero):
    """
    Extrae la caja y la convierte en lista
    :param sudoku: La matriz (lista de listas)
    :param numero: 0, 1, 2, ... 8, el número de la caja
    :return: Una lista con los 9 elementos dentro de la caja
    """
    lista = []
    #   Calcular la fila y columna de la esquina
    #   superior izquierda de la caja.
    fila = 3 * (numero // 3)
    columna = 3 * (numero % 3)
    #   Extraer los 9 digitos de la caja y
    #   ponerlos en una lista.
    for row in range(fila, fila + 3):
        lista.extend(sudoku[row][columna:columna + 3])
        
    return lista



 
    

    

def revisar(sudoku):
    """
    Revisa la corrección de la solución

    :param sudoku: La matriz (lista de listas)
    :return: True si el sudoku está bien resuelto
    """
    for fila in sudoku:
       if cerrada(fila)==0:
            return False   
            
    #   Revisar por filas.
    for fila in sudoku:
        if not revisar9(fila):
            return False
    #   Revisar por columnas
    for columna in range(9):
        col = []
        #   Reunir los digitos en la columna
        for fila in range(9):
            col.append(sudoku[fila][columna])
        #   Revisar los digitos.
        if not revisar9(col):
            return False
    #   Revisar por cajas
    for caja in range(9):
        #   Extraer los digitos de la caja
        box = extraer_caja(sudoku, caja)
        #   Revisar los digitos.
        if not revisar9(box):
            return False
    #   A estas alturas, la solución es correcta.
    return True


sudoku = str_sudoku(problema)
print_sudoku(sudoku)
if (revisar(sudoku)):
    print("Correcto")
else:
    print("Incorrecto")
