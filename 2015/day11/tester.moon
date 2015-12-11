import is_valid, get_next from require 'password'

io.write '> '
input = io.read!

while input
    print is_valid(input) and 'Valid!' or 'Invalid!'
    print "Next: #{get_next input}"
    io.write '> '
    input = io.read!
