error 'Requires Lua 5.2' unless _VERSION\find 'Lua 5.2'

emulator = require 'emulator'

input = io.open 'input.txt', 'r'

for line in input\lines '*l'
    emulator.parse line

input\close!

emulator.set 'b', emulator.get 'a'

print "The value of wire a is #{emulator.get 'a'}"
