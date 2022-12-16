#!/usr/bin/env ruby
# frozen_string_literal: true

require 'set'

require 'pry'

valves = {}

ARGF.readlines.each do |line|
  if line =~ /\b([A-Z]{2})\b.+?(\d+).+?((?:[A-Z]{2}(?:, )?)+)/
    valves[$1.to_sym] = {
      rate: $2.to_i,
      tunnels: $3.split(', ').map(&:to_sym).to_a
    }
  end
end

def solve(valves, memory, mins, current, score, visited, opened)
  key = [mins, current, score]
  return memory[key] if memory.key?(key)

  return score if mins <= 0 || visited.size == valves.keys.size

  remaining = valves.keys.reject { visited.include? _1 }
  return score if remaining.all? { valves[_1][:rate] == 0 }

  visited = visited.dup
  visited.add current

  valve = valves[current]
  rate = valve[:rate]

  max = score

  tovisit = valve[:tunnels]
  tovisit.each do |tunnel|
    simple = solve(valves, memory, mins - 1, tunnel, score, visited, opened)
    max = simple if simple > max
    if rate > 0 && !opened.include?(current)
      added = rate * (mins - 1)
      new_opened = opened.dup
      new_opened.add current
      complex = solve(valves, memory, mins - 2, tunnel, score + added, visited, new_opened)
      max = complex if complex > max
    end
  end

  memory[key] = max

  return max
end

puts solve(valves, {}, 30, :AA, 0, Set.new, Set.new)

# binding.pry
