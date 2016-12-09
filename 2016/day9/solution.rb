#!/usr/bin/env ruby
# encoding: utf-8
# frozen_string_literal: true

input = STDIN.readline.strip

def solve(input)
  i_size = input.size

  if !input.include? '('
    return [i_size, i_size]
  end

  part_1 = 0
  part_2 = 0
  index = 0

  while index < i_size
    if input[index] != '('
      part_1 += 1
      part_2 += 1
      index += 1
      next
    end

    m_end = input.index ')', index
    x_i = input.index 'x', index

    count = input[index + 1..x_i - 1].to_i
    repeat = input[x_i + 1..m_end - 1].to_i

    data_end = m_end + count

    _, d_length = solve(input[m_end + 1..data_end])

    part_1 += count * repeat
    part_2 += d_length * repeat
    index = data_end
  end

  [part_1, part_2]
end

solve(input).each.with_index { |r, i| puts "(#{i + 1}) #{r}" }
