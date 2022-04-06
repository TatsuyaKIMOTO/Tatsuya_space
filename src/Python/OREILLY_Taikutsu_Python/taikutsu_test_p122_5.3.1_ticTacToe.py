the_board = {'top-L' : ' ', 'top-M' : ' ', 'top-R' : ' ',
             'mid-L' : ' ', 'mid-M' : ' ', 'mid-R' : ' ',
             'low-L' : ' ', 'low-M' : ' ', 'low-R' : ' '}

def print_board(board):
    print(board['top-L'] + '|' + board['top-M'] + '|' + board['top-R'])
    print('-+-+-')
    print(board['mid-L'] + '|' + board['mid-M'] + '|' + board['mid-R'])
    print('-+-+-')
    print(board['low-L'] + '|' + board['low-M'] + '|' + board['low-R'])


turn = 'X'
for i in range(9):
    print_board(the_board)  #駒を打つたびにボードを表示する
    print(turn + 'の番です。どこに打つ？')
    move = input()  #プレイヤが駒を打つ場所を取得する
    the_board[move] = turn  #ゲームボードを更新する

    if turn == 'X':
        turn = 'O'
    else:
        turn = 'X'

print_board(the_board)
