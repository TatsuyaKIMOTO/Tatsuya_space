file = open("/usercode/files/books.txt", "r")

#your code goes here

Book_names = file.readlines()
for line in Book_names:
    if line[-1] == "\n":
        print (line[0] + str(len(line)-1))
    else:
        print (line[0] + str(len(line)))
file.close()