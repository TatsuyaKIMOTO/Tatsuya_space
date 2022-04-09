#PythonでFizzBuzz問題を解く
#1から100までを繰り返す
for i in range(1,101):
    #条件を1つずつ判定する
    if i % 3 == 0 and i % 5 == 0:
        print("FizzBuzz")
    elif i % 3 == 0:
        print ("Fizz")
    elif i % 5 == 0:
        print("Buzz")
    else:
        print(i)
        