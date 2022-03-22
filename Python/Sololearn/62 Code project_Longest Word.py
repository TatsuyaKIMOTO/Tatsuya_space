txt = input()

#your code goes here
words = txt.split(" ")
longest = ""

for word in words:
    if len(word) > len(longest):
        longest = word
print(longest)
