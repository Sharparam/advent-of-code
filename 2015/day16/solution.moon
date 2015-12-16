import parse, find_match, find_real_match from require 'mfcsam'

for line in io.lines 'input.txt', '*l'
    parse line

wanted =
    children: 3
    cats: 7
    samoyeds: 2
    pomeranians: 3
    akitas: 0
    vizslas: 0
    goldfish: 5
    trees: 3
    cars: 2
    perfumes: 1

print find_match wanted
print find_real_match wanted
