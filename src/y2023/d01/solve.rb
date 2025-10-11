#!/usr/bin/env ruby
# frozen_string_literal: true

lines = ARGF.read.lines

puts lines.sum { _1.scan(/\d/).then { |m| [m[0], m[-1]].join.to_i } }

re = /(?=(\d|one|two|three|four|five|six|seven|eight|nine))/
map = {
  'one' => 1,
  'two' => 2,
  'three' => 3,
  'four' => 4,
  'five' => 5,
  'six' => 6,
  'seven' => 7,
  'eight' => 8,
  'nine' => 9
}

digits = lines.map { _1.scan(re).flatten.map { |d| map[d] || d.to_i } }
puts digits.sum { |d| [d[0], d[-1]].join.to_i }
