#!/usr/bin/env ruby
# frozen_string_literal: true

LENGTH = !ARGV.empty? && ARGV.first[0] == 't' ? 35_651_584 : 272

input = $stdin.readline.strip.chars.map(&:to_i)

def dragon_curve(data)
  len = data.size
  (data << 0).concat data.first(len).reverse.map { |v| (v + 1) % 2 }
end

def checksum(data)
  data.each_slice(2).map { |p| p.reduce(&:==) ? 1 : 0 }
end

dragon_curve(input) while input.size < LENGTH

input = input.first(LENGTH)

check = checksum input

check = checksum check while check.size.even?

puts check.join
