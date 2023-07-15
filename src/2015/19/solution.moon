import parse, count_molecules, make_molecule from require 'generator'

for line in io.lines 'input.txt', '*l'
    parse line

print count_molecules!

print make_molecule!
