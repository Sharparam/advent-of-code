#!/usr/bin/env ruby
# frozen_string_literal: true

# fucking what
trib_cache = [0, 1, 1]
trib = -> n {
  trib_cache[n] ||= trib[n - 1] + trib[n - 2] + trib[n - 3]
}

adapters = ARGF.readlines.map(&:to_i).sort
DEVICE = adapters.max + 3

diffs = Hash.new 0
diffs[adapters.min - 0] += 1
diffs[3] += 1

adapters.each_cons(2) do |low, high|
  diffs[high - low] += 1
end

puts diffs[1] * diffs[3]

withends = [0] + adapters + [DEVICE]
oneseqs = []
start = withends.first
previous = withends.first
withends.drop(1).each do |jolt|
  if jolt - previous > 1
    oneseqs << previous - start + 1
    start = jolt
  end
  previous = jolt
end

puts oneseqs.map(&trib).reduce(:*)
