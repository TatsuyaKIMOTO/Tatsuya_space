all_guests = {'アリス': {'リンゴ':5, 'プレッツェル':12}, 
              'ボブ':{'ハムサンド':3,'リンゴ':2},
              'キャロル':{'コップ':3, 'アップルパイ':1}}

def total_bought(guests, item):
    num_brought = 0
    for k, v in guests.items(): #all_guestsのkeyをk, valueをvに入れる。参加者の名前がkey:kで持ち物の辞書がvalue:vに入る。
        num_brought = num_brought + v.get(item, 0) #getメソッドでkeyをとりだす。第2引数の0はkeyがないときの指定値。対象のkeyはitemという名のkeyを指す。
    return num_brought

print('持ち物の数: ')
print(' - リンゴ ' + str (total_bought(all_guests, 'リンゴ')))#total_brought関数を使用する。guestsはall_guests, itemはリンゴ
print(' - コップ ' + str (total_bought(all_guests, 'コップ')))
print(' - ケーキ ' + str (total_bought(all_guests, 'ケーキ')))#ケーキはvの持ち物辞書に存在しない。get()メソッドで取り出せないkeyなのでgetメソッドで指定した第2引数の0が入る。
print(' - ハムサンド ' + str (total_bought(all_guests, 'ハムサンド')))
print(' - アップルパイ ' + str (total_bought(all_guests, 'アップルパイ')))