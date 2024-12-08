#!/usr/bin/env ruby
# frozen_string_literal: true

offsets = STDIN.readlines.map(&:to_i)
index = 0
steps = 0

while index >= 0 && index < offsets.size
    index += (offsets[index] += (change = offsets[index] >= 3 ? -1 : 1)) - change
    steps += 1
end

p steps
