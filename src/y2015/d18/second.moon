import parse, set, get_dimensions, step, get_counts from require 'grid'

for line in io.lines 'input.txt', '*l'
    parse line

rows, columns = get_dimensions!

set rows, 1, true

for n = 1, 100
    step true

print (get_counts!)
