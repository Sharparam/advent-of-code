#!/usr/bin/env ruby
# frozen_string_literal: true

def calc(mass)
  fuel = (mass / 3) - 2
  fuel <= 0 ? 0 : fuel + calc(fuel)
end

masses = File.readlines('input.txt').map(&:to_i)
fuels = masses.map { |m| (m / 3) - 2 }
part2 = masses.map { |m| calc(m) }

puts "Part 1: #{fuels.sum}"
puts "Part 2: #{part2.sum}"
