#フィボナッチ数を求める
a=1
b=1
print(a)
print(b)
for _ in range(30):
    print(a+b)
    tmp=a #aを一次避難させる
    a=b #次のaはbの値を入れる
    b=tmp+b #一次避難させてたa（前のa）にbを加えたものを次のbとする