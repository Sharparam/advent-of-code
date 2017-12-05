#!/usr/bin/env ruby

offsets = STDIN.readlines.map(&:to_i)
index = 0
steps = 0

while index >= 0 && index < offsets.size
    change = offsets[index] >= 3 ? -1 : 1
    index += (offsets[index] += change) - change
    steps += 1
end

p steps
