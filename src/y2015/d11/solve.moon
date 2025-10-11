import is_valid, get_next from require 'password'

input = 'hxbxwxba'

while not is_valid input
    input = get_next input

print "Part 1: #{input}"

input = get_next input

while not is_valid input
    input = get_next input

print "Part 2: #{input}"
