#!/usr/bin/env ruby
# frozen_string_literal: true

fish = ARGF.read.split(',').map(&:to_i).tally.tap { _1.default = 0 }

256.times do |n|
  temp = fish.dup
  fish = Hash[temp.reject { _1 == 0 }.map { [_1 - 1, _2] }].tap { _1.default = 0 }
  fish[6] += temp[0]
  fish[8] += temp[0]
  puts fish.values.sum if n == 79
end

puts fish.values.sum
