#!/usr/bin/env ruby
# frozen_string_literal: true

# Shamelessly ported from https://notes.dt.in.th/20211224T121217Z7595

input = ARGF.readlines.map(&:chomp)
block_size = input.size / 14
slices = input.each_slice(block_size).to_a
adds = slices.map { |s| [s[5], s[15]].map { _1.split.last.to_i } }
x_adds = adds.map(&:first)
y_adds = adds.map(&:last)
divs = input.map(&:split).select { _1[0] == 'div' }.map { _1.last.to_i }
results = []

find = -> w, i, zz, path {
  if i == 14
    results << path.join[0...14].to_i
    return
  end
  dx = x_adds[i]
  dy = y_adds[i]
  div = divs[i]
  if div == 26
    return if w - dx != zz.last
    next_zz = zz[0...-1]
    9.downto 1 do |next_w|
      find[next_w, i + 1, next_zz, [*path, next_w]]
    end
  else
    next_zz = [*zz, w + dy]
    9.downto 1 do |next_w|
      find[next_w, i + 1, next_zz, [*path, next_w]]
    end
  end
}

9.downto 1 do |w|
  find[w, 0, [], [w], results]
end

puts results.max
puts results.min
