my_pets = ["Zophie", "Pooka", "Fat-tail"]
print("ペットの名前を入力してください：")
name = input()
if name not in my_pets:
    print(str(name) + "という名前のペットは飼っていません。")
else:
    print(str(name) + "は私のペットです。")
    
