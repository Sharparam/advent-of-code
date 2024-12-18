#!/usr/bin/env ruby
# frozen_string_literal: true

valves = {}

ARGF.readlines.each do |line|
  next unless line =~ /\b([A-Z]{2})\b.+?(\d+).+?((?:[A-Z]{2}(?:, )?)+)/
  valves[$1.to_sym] = {
    rate: $2.to_i,
    tunnels: $3.split(', ').map(&:to_sym).to_a
  }
end

HAS_FLOW = valves.reject { _2[:rate] == 0 }.to_set { |k, _| k }

def solve(valves, memory, mins, current, score, visited, opened)
  key = [mins, current, score]
  return memory[key] if memory.key?(key)

  return [score, opened] if mins <= 0
  return [score, opened] if HAS_FLOW.all? { opened.include? _1 }

  visited = visited.dup
  visited.add current

  valve = valves[current]
  rate = valve[:rate]

  max = score
  max_opened = opened

  tovisit = valve[:tunnels]
  tovisit.each do |tunnel|
    simple_max, simple_o = solve(valves, memory, mins - 1, tunnel, score, visited, opened)
    if simple_max > max
      max = simple_max
      max_opened = simple_o
    end
    next unless rate > 0 && !opened.include?(current)
    added = rate * (mins - 1)
    new_opened = opened.dup
    new_opened.add current
    complex_max, complex_o = solve(valves, memory, mins - 2, tunnel, score + added, visited, new_opened)
    if complex_max > max
      max = complex_max
      max_opened = complex_o
    end
  end

  memory[key] = [max, max_opened]

  [max, max_opened]
end

part1, _opened = solve(valves, {}, 30, :AA, 0, Set.new, Set.new)

puts part1

part2_human, opened2_human = solve(valves, {}, 26, :AA, 0, Set.new, Set.new)
opened2_human.each { valves[_1][:rate] = 0 }
part2_elephant, opened2_elephant = solve(valves, {}, 26, :AA, 0, Set.new, Set.new)

warn 'PART 2:'
warn "Human score: #{part2_human} (opened #{opened2_human})"
warn "Elephant score: #{part2_elephant} (opened #{opened2_elephant})"

puts part2_human + part2_elephant
