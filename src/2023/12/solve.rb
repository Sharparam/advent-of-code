#!/usr/bin/env ruby
# frozen_string_literal: true

class NilClass; def empty?; true; end; def size; 0; end; end

def valids(records, counts, row_size, cache = {}, skip_cache: false)
  key = records.size + (counts.size * row_size)
  return cache[key] if cache.key?(key) && !skip_cache
  return 1 if records.empty? && counts.none?
  return 0 if records.empty? && counts.any?
  return 0 if records[0] == ?# && counts.none?
  return cache[key] = valids(records[1..], counts, row_size, cache) if records[0] == ?.
  if records[0] == ??
    rest = records[1..]
    return cache[key] = valids(rest, counts, row_size, cache) + valids("##{rest}", counts, row_size, cache, true)
  end
  return 0 if records.size < counts[0]
  return 0 if records[..counts[0] - 1].include? ?.
  return 0 if records.size >= counts[0] && records[counts[0]] == ?#

  cache[key] = valids(records[counts[0] + 1..], counts[1..], row_size, cache)
end

puts ARGF.readlines.each_with_index.reduce([0, 0]) { |a, (line, _i)|
  records, counts = line.split
  counts = counts.split(',').map(&:to_i)
  records2, counts2 = ([records] * 5).join(??), counts * 5
  p1 = valids records, counts, records.size
  p2 = valids records2, counts2, records2.size

  [a[0] + p1, a[1] + p2]
}
