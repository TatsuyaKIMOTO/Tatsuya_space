import random

def get_answer(answer_number):
    if answer_number == 1:
        return "確かにそうだ"
    elif answer_number == 2:
        return "間違いなくそうだ"
    elif answer_number == 3:
        return "はい"
    elif answer_number == 4:
        return "なんとも。もう一度やってみて"
    elif answer_number == 5:
        return "後でもう一度聞いてみて"
    elif answer_number == 6:
        return "集中してもう一度聞いてみて"
    elif answer_number == 7:
        return "私の答えはノーです"
    elif answer_number == 8:        
        return "見通しはそれほど良くない"
    elif answer_number == 9:
        return "とても疑わしい"

r = random.randint(1,9)
fortune = get_answer(r)
print(fortune)
