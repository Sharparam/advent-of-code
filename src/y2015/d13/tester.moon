import parse, get_max_happiness, permutations from require 'manager'

for line in io.lines 'test_input.txt', '*l'
    parse line

print get_max_happiness!
