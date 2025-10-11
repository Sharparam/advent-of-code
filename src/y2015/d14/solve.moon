import parse, get_winner from require 'race'

for line in io.lines 'input.txt', '*l'
    parse line

distance, points = get_winner 2503

print distance
print points
