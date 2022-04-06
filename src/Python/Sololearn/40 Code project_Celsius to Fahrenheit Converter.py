celsius = int(input())

def conv(c):
    #your code goes here
    x=c*9/5+32
    return x

fahrenheit = conv(celsius)
print(fahrenheit)