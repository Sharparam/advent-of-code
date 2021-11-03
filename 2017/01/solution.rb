#!/usr/bin/env ruby

input = STDIN.readline.strip.chars.map(&:to_i)
part1 = input.each_cons(2).to_a.push([input[0], input[-1]]).map(&:uniq).reduce(0) { |a, e| a + (e.size == 2 ? 0 : e.first) }
part2 = input.each.with_index.reduce(0) { |a, (e, i)| a + ((e == input[(i + input.size / 2) % input.size]) ? e : 0) }

puts "Part 1: #{part1}"
puts "Part 2: #{part2}"
