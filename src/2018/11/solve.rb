#!/usr/bin/env ruby
# frozen_string_literal: true

require 'pry'

SIZE = 300
SERIAL = ARGV[0]&.to_i || 7400

def powerlevel(x, y)
  id = x + 10
  (id * y + SERIAL) * id / 100 % 10 - 5
end

POWERS = (0..SIZE).map do |y|
  (0..SIZE).map do |x|
    id = x + 10
    (id * y + SERIAL) * id / 100 % 10 - 5
  end.freeze
end.freeze

nums = (1..SIZE - 2).to_a
coords = nums.product(nums)

puts "Part 1: #{coords.max_by { |(x, y)| POWERS[y, 3].sum { |r| r[x, 3].sum } }.join ?,}"

# binding.pry
# exit

# sizes = (1..300)
# puts "Part 2: #{coords.product((1..300).to_a).max_by { |((x, y), s)| power x, y, s }.join ?,}"

SUMS = Array.new(SIZE) { Array.new(SIZE).unshift 0 }
SUMS.unshift [0] * (SIZE + 1)

(1..SIZE).each do |y|
  (1..SIZE).each do |x|
    SUMS[y][x] = POWERS[y][x] + SUMS[y][x - 1] + SUMS[y - 1][x] - SUMS[y - 1][x - 1]
  end
end

def power(x, y, s)
  SUMS[y + s - 1][x + s - 1] + SUMS[y - 1][x - 1] - SUMS[y - 1][x + s - 1] - SUMS[y + s - 1][x - 1]
end

max = -(1.0 / 0.0)
part2 = []
(1..SIZE).each do |s|
  valid_pos = (1..SIZE - s + 1)
  valid_pos.each do |y|
    valid_pos.each do |x|
      p = power x, y, s
      if p > max
        part2 = [x, y, s]
        max = p
      end
    end
  end
end

puts "Part 2: #{part2.join ?,}"
