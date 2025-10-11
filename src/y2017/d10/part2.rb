#!/usr/bin/env ruby
# frozen_string_literal: true

def knot_hash(str)
  list = (0..255).to_a
  index = 0
  skip = 0

  lengths = str.strip.chars.map(&:ord).push(17, 31, 73, 47, 23)

  64.times do
    lengths.each do |length|
      stop = index + length - 1

      if stop < list.size
        list.insert index, *list.slice!(index..stop).reverse
      else
        end_index = list.size - 1
        stop %= list.size
        reversed = list.slice!(index, length).push(*list.slice!(0..stop)).reverse
        list.push(*reversed[0..end_index - index])
        list.unshift(*reversed[end_index - index + 1..])
      end

      index = (index + length + skip) % list.size
      skip += 1
    end
  end

  list.each_slice(16).map { |s| s.reduce(&:^).to_s(16).rjust(2, '0') }.join
end

return unless $PROGRAM_NAME == __FILE__

input = $<.readline

puts knot_hash(input)
