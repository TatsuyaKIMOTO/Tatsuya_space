#collatz関数を定義する。パラメータはnumber
def collatz(number):
    #もしnumbeが偶数ならnumberを2で割る
    if number%2==0:
        number=number/2
    #もしnumberが1ならpassで処理を実行しない
    elif number==1:
        pass
    #それ以外（奇数なら）numberを3倍にして1を足す
    else:
        number=number*3+1
    #戻り値としてnumberを整数intにして返す。
    return int(number)

#なにか整数を入れてくださいと英語で表示する。
print("input integer number")

#入力した数字を整数intにして変数xに入れる。
x=int(input())

#変数xが1でない限り、collatz定義を実行し、結果をxに入れ、その結果を表示する。
while x!=1:
    x=(collatz(x))
    print(x)
