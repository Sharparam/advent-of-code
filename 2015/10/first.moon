import transform from require 'lookandsay'

input = '1321131112'

start = os.time!

for i = 1, 40
    input = transform input

print "#{#input} after #{os.time! - start} seconds"
