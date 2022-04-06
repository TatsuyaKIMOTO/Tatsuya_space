#P107 4.10 演習プロジェクト
#4.10.1 カンマつけ
spam=["apples", "bananas", "tofu" ,"cat"]

#上記のようなリストの最後の要素の接頭にand をつける。上記spamのリストの場合だと最後の"cat"を"and cat"に変更する。

#現状のリスト内容確認
print(spam)

#spmaリストの最後の要素を取り出す。要素は0スタートなので-1をする。接頭に"and"をつけて+で加算して、spamリストの最後の要素に代入する。
#ちなみにspam[len(spam)-1]+="and "としては、"and"が後ろにつけられてしまうので"catand"となってしまう
spam[len(spam)-1]="and " + spam[len(spam)-1]

#置き換えができているかの確認
print(spam)

#オブジェクトだけを展開するために*演算子を用いてprintする
print(*spam, sep = ",")