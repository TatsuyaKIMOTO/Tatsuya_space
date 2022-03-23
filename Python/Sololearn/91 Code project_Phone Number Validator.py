import re
#your code goes here
pattern = r"^[189][0-9]{7}$"

if re.match(pattern, input()):
    print("Valid")
else:
    print("Invalid")