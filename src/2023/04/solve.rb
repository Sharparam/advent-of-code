#!/usr/bin/env ruby
# frozen_string_literal: true

cards = Hash[ARGF.read.lines.map do |line|
  t, l = line.split(':')
  id = t.scan(/\d+/)[0].to_i
  w, n = l.split('|').map { _1.split(' ').map(&:to_i) }
  [id, [w, n]]
end]

win_count = {}

puts cards.sum { |i, (w, n)|
  c = n.count { w.include? _1 }
  win_count[i] = c
  if c == 0
    0
  else
    s = 1
    (c - 1).times { s *= 2 }
    s
  end
}

total_count = Hash[win_count.keys.map { [_1, 1] }]
ids = cards.keys

ids.each do |id|
  next if win_count[id] == 0
  c_ids = ids[id..(id + win_count[id] - 1)]
  e = (total_count[id] * win_count[id]) / c_ids.size
  c_ids.each { total_count[_1] += e }
end

puts total_count.values.sum
