#!/usr/bin/env ruby
# frozen_string_literal: true

require 'pry'

EXPLODE_REGEXP = /^\[/

def reduce(number)

end

def magnitude(number)
  return magnitude(eval(number)) if number.is_a? String
  return number if number.is_a? Numeric
  magnitude(number[0]) * 3 + magnitude(number[1]) * 2
end

lines = ARGF.readlines.map(&:strip)

reduced = lines[0]

lines[1..].each do |line|
  added = "[#{reduced},#{line}]"
end

binding.pry
