#!/usr/bin/env ruby
# frozen_string_literal: true

cards = ARGF.read.scan(/^[^\d]+(\d+): ([\d\ ]+) \| (.+)$/).to_h do
  [_1.to_i, [_2.split.map(&:to_i), _3.split.map(&:to_i)]]
end

win_count = {}

puts cards.sum { |i, (w, n)|
  c = n.count { w.include? _1 }
  win_count[i] = c
  c == 0 ? 0 : 2**(c - 1)
}

total_count = win_count.keys.to_h { [_1, 1] }
ids = cards.keys

ids.each do |id|
  next if win_count[id] == 0
  c_ids = ids[id..(id + win_count[id] - 1)]
  e = (total_count[id] * win_count[id]) / c_ids.size
  c_ids.each { total_count[_1] += e }
end

puts total_count.values.sum
