#!/usr/bin/env ruby
# frozen_string_literal: true

require 'matrix'

require 'pairing_heap'

splitters = Set.new
start = Vector[0, 0]
height = 0

ARGF.each_line(chomp: true).with_index do |line, row|
  line.chars.each_with_index do |char, col|
    if char == ?^
      splitters.add Vector[col, row]
    elsif char == ?S
      start = Vector[col, row]
    end
  end
  height += 1
end

beams = Set.new
beams.add start

DOWN = Vector[0, 1]
LEFT = Vector[-1, 0]
RIGHT = Vector[1, 0]

splits = 0

counters = Hash.new 0
counters[start[0]] = 1

height.times do
  new_beams = Set.new
  beams.each do |beam|
    if splitters.include? beam
      new_beams.add(beam + LEFT + DOWN)
      new_beams.add(beam + RIGHT + DOWN)
      splits += 1

      counters[beam[0] - 1] += counters[beam[0]]
      counters[beam[0] + 1] += counters[beam[0]]
      counters[beam[0]] = 0
    else
      new_beams.add(beam + DOWN)
    end
  end
  beams = new_beams
end

puts splits
puts counters.values.sum
