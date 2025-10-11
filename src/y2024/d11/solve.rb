#!/usr/bin/env ruby
# frozen_string_literal: true

stones = ARGF.readline.split.map(&:to_i).tally

75.times do |i|
  new_stones = Hash.new 0
  stones.each do |stone, count|
    if stone == 0
      new_stones[1] += count
    else
      digits = stone.digits.reverse
      if digits.size.even?
        left = digits[..(digits.size / 2) - 1].join.to_i
        right = digits[digits.size / 2..].join.to_i
        new_stones[left] += count
        new_stones[right] += count
      else
        new_stones[stone * 2024] += count
      end
    end
  end
  stones = new_stones
  puts stones.values.sum if i == 24
end

puts stones.values.sum
