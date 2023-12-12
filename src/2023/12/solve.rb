#!/usr/bin/env ruby
# frozen_string_literal: true

class NilClass; def empty?; true; end; end

CACHE = {}

def valids(records, counts)
  key = [records, counts].hash
  return CACHE[key] if CACHE.key? key
  return 1 if records.empty? && !counts.any?
  return 0 if records.empty? && counts.any?
  return 0 if records[0] == ?# && !counts.any?
  return CACHE[key] = valids(records[1..], counts) if records[0] == ?.
  if records[0] == ??
    rest = records[1..]
    return CACHE[key] = valids(rest, counts) + valids("##{rest}", counts)
  end
  return 0 if records.size < counts[0]
  return 0 if records[..counts[0] - 1].include? ?.
  return 0 if records.size >= counts[0] && records[counts[0]] == ?#

  CACHE[key] = valids(records[counts[0] + 1..], counts[1..])
end

puts ARGF.readlines.each_with_index.reduce([0, 0]) { |a, (line, i)|
  records, counts = line.split ' '
  counts = counts.split(',').map(&:to_i)
  p1 = valids records, counts
  p2 = valids ([records] * 5).join(??), counts * 5

  [a[0] + p1, a[1] + p2]
}
