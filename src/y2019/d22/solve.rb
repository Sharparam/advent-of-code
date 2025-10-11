#!/usr/bin/env ruby
# frozen_string_literal: true

PATH = ARGV.first || 'input'
SIZE = ARGV[1]&.to_i || 10_007
DEBUG = ENV.fetch('DEBUG', nil)

deck = (0...SIZE).to_a

File.readlines(PATH).each do |instruction|
  case instruction
  when /new stack/
    deck.reverse!
  when /cut (-?\d+)/
    n = $1.to_i
    deck = deck[n..] + deck[0..n - 1]
  when /deal with increment (\d+)/
    inc = $1.to_i
    t = []
    i = -inc
    deck.each { |card| t[(i += inc) % SIZE] = card }
    deck = t
  end
end

puts deck.join if DEBUG
puts "Part 1: #{deck.find_index 2019}"
