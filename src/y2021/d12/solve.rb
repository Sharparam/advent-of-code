#!/usr/bin/env ruby
# frozen_string_literal: true

MAZE = {} # rubocop:disable Style/MutableConstant
ARGF.readlines.map { _1.strip.split('-') }.each do |a, b|
  MAZE[a] ||= []
  MAZE[a] << b
  next if a == 'start' || b == 'end'
  MAZE[b] ||= []
  MAZE[b] << a
end

def solve(current, visited, twice)
  visited.add current if current =~ /^[a-z]+$/
  return 1 if current == 'end'
  MAZE[current].sum do |node|
    seen = visited.include? node
    next 0 if seen && (twice || node == 'start' || node == 'end')
    solve(node, visited.dup, twice || seen)
  end
end

puts solve('start', Set.new, true)
puts solve('start', Set.new, false)
