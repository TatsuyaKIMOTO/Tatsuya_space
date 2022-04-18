#Pythonでシーザー暗号に変換する関数
def encrypt(text, shift):
    #AとZの文字コードを得る
    #ord関数でUnicodeポイントを取り出す。
    code_a = ord("A")
    code_z = ord("Z")
    #結果を代入する変数を用意。
    result = ""
    #一文字ずつ繰り返す。
    for ch in text:
        #文字コードに変換する。    
        code = ord(ch)
        #AからZの間か？
        if code_a <= code <= code_z:
            #shift文だけ並びをずらす。ずらしたあとにZを超えるとAに戻したいので26で割ったあまりを使用
            code = (code - code_a + shift + 26) %26 + code_a
        #文字コードからchr関数を使って文字に戻してfor追記していく。
        result += chr(code)
    return result

#関数を呼び出す
enc = encrypt("I LOVE YOU", 3)
dec = encrypt(enc, -3)
print(enc, "=>" , dec)


