#!/usr/bin/env ruby
# frozen_string_literal: true

input = $stdin.readline.strip

def solve(input)
  i_size = input.size

  return [i_size, i_size] unless input.include? '('

  part1 = 0
  part2 = 0
  index = 0

  while index < i_size
    if input[index] != '('
      part1 += 1
      part2 += 1
      index += 1
      next
    end

    m_end = input.index ')', index
    x_i = input.index 'x', index

    count = input[index + 1..x_i - 1].to_i
    repeat = input[x_i + 1..m_end - 1].to_i

    data_end = m_end + count

    _, d_length = solve(input[m_end + 1..data_end])

    part1 += count * repeat
    part2 += d_length * repeat
    index = data_end
  end

  [part1, part2]
end

solve(input).each_with_index { |r, i| puts "(#{i + 1}) #{r}" }
