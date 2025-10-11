import parse, find_match from require 'mfcsam'

for line in io.lines 'input.txt', '*l' do parse line

wanted =
    children: 3, cats: 7, samoyeds: 2, pomeranians: 3, akitas: 0
    vizslas: 0, goldfish: 5, trees: 3, cars: 2, perfumes: 1

print find_match wanted, (a, b) -> a == b
print find_match wanted
