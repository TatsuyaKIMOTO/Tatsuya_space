import random
# 1から75までの値リストを用意
nums = list(range(1, 75+1))
# シャッフル
random.shuffle(nums)
nums[12] = "*" #ワイルドカードを指定
# カードを表示
for y in range (0,5):
    for x in range(0,5):
        print("{:>3},".format(nums[y*5+x]),end="") #y行目x列を表示する。yとxは０スタート。５列表示するまで改行しないようend=""
    print("")#上記printで５列表示したら改行させる（何も記載しない。標準でprintは改行される。