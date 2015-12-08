helper = require 'helper'

input = io.open 'input.txt', 'r'

total = 0

for line in input\lines '*l'
    total += helper.get_delta line

print "The total delta is #{total}"
