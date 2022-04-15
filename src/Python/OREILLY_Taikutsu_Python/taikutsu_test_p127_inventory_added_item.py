#追加されるアイテムのリストから現状のアイテム辞書に追加する関数を作成
def add_to_inventory(inventory, added_items):
    for i in added_items:#変数iにadded_itemsのリストを順に入れていく
        inventory.setdefault(i, 0)#inventory辞書のkyeにiがなければそのkeyを追加し、初期値を0と設定する。
        inventory[i]=inventory[i]+1#inventoryの辞書にiを1追加する。
#アイテムのトータル数を表示する関数を作成
def display_inventory(inventory):
    print("持ち物リスト:")
    item_total = 0
    for k, v in inventory.items():
        print(str(v) + " " + str(k))
        item_total = item_total + v
    print("アイテム総数: " + str(item_total))

inv = {"金貨": 42, "ロープ": 1}
dragon_loot = ["金貨", "手裏剣", "金貨", "金貨", "ルビー"]
add_to_inventory(inv, dragon_loot)
display_inventory(inv)
