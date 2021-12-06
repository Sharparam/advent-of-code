#!/usr/bin/env ruby
# frozen_string_literal: true

fish = ARGF.read.split(',').map(&:to_i).tally
fish.default = 0

256.times do |n|
  temp = fish.dup
  fish = Hash.new 0
  (0..8).each do |l|
    t = l.zero? ? 6 : l - 1
    fish[t] += temp[l]
  end
  fish[8] += temp[0]
  puts fish.values.sum if n == 79
end

puts fish.values.sum
