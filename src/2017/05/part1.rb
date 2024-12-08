#!/usr/bin/env ruby
# frozen_string_literal: true

offsets = STDIN.readlines.map(&:to_i)
index = 0
steps = 0
while index >= 0 && index < offsets.size
  index += (offsets[index] += 1) - 1
    steps += 1
end

p steps
