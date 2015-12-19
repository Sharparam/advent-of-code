import parse, step, get_counts from require 'grid'

for line in *{'.#.#.#', '...##.', '#....#', '..#...', '#.#..#', '####..'}
    parse line

print get_counts!

step!
step!
step!
step!

print get_counts!
