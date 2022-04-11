#Pythonで九九の表（行末のカンマを削ったもの）
for y in range(1,10):
    a = ["{:3}".format(x*y) for x in range(1,10)] #結果をリスト化して変数aに入れる。
    print(",".join(a)) #リストaの中身をjointメソッド使って間に","を入れて連結させる。