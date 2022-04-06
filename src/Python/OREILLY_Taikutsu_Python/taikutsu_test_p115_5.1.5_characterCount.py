message = "It was a bright cold day in April, and the clocks were striking thirteen."
count = {}

for character in message: #messageに入ってるstr文字を頭から順にcharacter変数に入れる
    count.setdefault(character,0) #character変数に現在入ってる文字をsetdefaultで追加していく。setdefaultなので既に登録されてる文字は追加されない。初期値0
    count[character]=count[character]+1 #characterに現在入ってる文字をカウントして1追加する

print(count)