#pyautoguiを使用するにはコマンドでpip install pyautoguiでインストールしてください

import pyautogui

pyautogui.alert(text="終了するにはCtrl+cを押してください",title='注意',button='OK')
try:
    while True:
        pyautogui.moveTo(930,540,1)
        pyautogui.moveTo(990,540,1)
except KeyboardInterrupt:
    pyautogui.alert(text="終了しました",title='終了',button='OK')
