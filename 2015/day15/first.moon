import parse, best_score from require 'engine'

for line in io.lines 'input.txt', '*l'
    parse line

print best_score!
