import reencode, get_code_length from require 'helper'

input = io.open 'input.txt', 'r'

total = 0

for line in input\lines '*l'
    total += get_code_length(reencode line) - get_code_length line

print "The total delta is #{total}"
