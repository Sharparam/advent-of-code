#!/usr/bin/env ruby
# encoding: utf-8
# frozen_string_literal: true

input = STDIN.readline.strip

def solve(input, second = false)
  if !input.include? '('
    return [input.size] * 2
  end

  length = 0
  index = 0

  while index < input.size
    if input[index] != '('
      length += 1
      index += 1
      next
    end

    marker, count, repeat = input[index..-1].match(/^\((\d+)x(\d+)\)/).to_a
    count = count.to_i
    repeat = repeat.to_i

    if second
      d_length, d_index = solve(input[index + marker.size..index + marker.size + count - 1], second)
    else
      d_length = count
      d_index = count
    end

    length += d_length * repeat
    index += marker.size + d_index
  end

  [length, index]
end

puts "(1) #{solve(input).first}"
puts "(2) #{solve(input, true).first}"
