import parse, get_combinations, get_combinations_minimum from require 'engine'

for line in io.lines 'input.txt', '*l'
    parse line

print get_combinations 150
print get_combinations_minimum 150
