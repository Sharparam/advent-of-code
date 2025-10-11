#!/usr/bin/env ruby
# frozen_string_literal: true

strings = ARGF.read.chomp.split(',')

def hash(str)
  str.chars.reduce(0) { |a, c| ((a + c.ord) * 17) % 256 }
end

puts strings.sum { hash _1 }

boxes = 256.times.map { [] }

strings.each do |str|
  case str
  when /(\w+)=(\d+)/
    box = boxes[hash $1]
    existing = box.find { _1[0] == $1 }
    if existing
      existing[1] = $2.to_i
    else
      box.push [$1, $2.to_i]
    end
  when /(\w+)-/
    boxes[hash $1].delete_if { _1[0] == $1 }
  end
end

puts boxes.each_with_index.sum { |b, i| b.each_with_index.sum { |l, j| (1 + i) * (j + 1) * l[1] } }
