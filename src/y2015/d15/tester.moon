import parse, calc from require 'engine'

for line in io.lines 'test_input.txt', '*l'
    parse line

io.write '> '
input = io.read!

while input
    counts = [tonumber num for num in input\gmatch '%d+']
    print calc counts
    io.write '> '
    input = io.read!
