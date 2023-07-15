import parse, get_lowest_cost, get_highest_cost from require 'game'

for line in io.lines 'input.txt', '*l'
    parse line

print get_lowest_cost!
print get_highest_cost!
