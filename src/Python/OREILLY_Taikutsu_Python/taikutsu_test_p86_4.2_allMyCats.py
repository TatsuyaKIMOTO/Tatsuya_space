cat_names = []
while True:
    print("猫" + str(len(cat_names) + 1) + "の名前を入力してください" + "(終了するにはEnterキーだけ押してください)")

    name = input()
    if name == "":
          break
    cat_names = cat_names + [name] #リストの連結
print("猫の名前は次の通り:")
for name in cat_names: #変数nameについて繰り返し以下の処理を繰り返す。繰り返しはcat_namesのリスト0から順に実施
    print(" " + name)
