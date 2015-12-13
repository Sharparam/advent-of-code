import parse, get_max_happiness, add_self from require 'manager'

for line in io.lines 'input.txt', '*l'
    parse line

print get_max_happiness!
add_self!
print get_max_happiness!
