import sum from require 'reader'

io.write '> '
input = io.read!

while input
    print sum input
    io.write '> '
    input = io.read!
