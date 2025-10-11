#!/usr/bin/env ruby
# frozen_string_literal: true

memory = $<.readline.split.map(&:to_i)

configs = Set.new
redists = 0

def redistribute(array)
  blocks = array.max
  index = array.index blocks
  array[index] = 0
  while blocks > 0
    index = (index + 1) % array.size
    array[index] += 1
    blocks -= 1
  end
end

until configs.include? memory
  configs.add memory.clone
  redistribute memory
  redists += 1
end

p redists

state = memory.clone

steps = 1
redistribute memory
while memory != state
  redistribute memory
  steps += 1
end

p steps
