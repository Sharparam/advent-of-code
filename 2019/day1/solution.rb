#!/usr/bin/env ruby

def calc(mass)
  fuel = mass / 3 - 2

  return 0 if fuel <= 0

  return fuel + calc(fuel)
end

masses = File.readlines('input.txt').map(&:to_i)
fuels = masses.map { |m| m / 3 - 2 }
part2 = masses.map { |m| calc(m) }

puts "Part 1: #{fuels.sum}"
puts "Part 2: #{part2.sum}"
