#!/usr/bin/env ruby
# frozen_string_literal: true

input = File.read('input.txt').chomp
ords = input.chars.map(&:ord)

def react(os)
  res = [0]

  os.each do |o|
    if res[-1] ^ o == 32
      res.pop
    else
      res << o
    end
  end

  res[1..]
end

part1 = react ords
puts "Part 1: #{part1.size}"

exit

part2 = (?a.ord..?z.ord).map { |l| react(part1.reject { |e| e == l || e == l + 32 }).size }.min # rubocop:disable Lint/UnreachableCode
puts "Part 2: #{part2}"
