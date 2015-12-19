import parse, step, get_counts from require 'grid'

for line in io.lines 'input.txt', '*l'
    parse line

print get_counts!

for n = 1, 100
    step!

print (get_counts!)
