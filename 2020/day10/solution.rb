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

puts ([0] + adapters + [DEVICE]).each_cons(2).reduce([1]) { |a, (f, l)|
  (l - f == 1) ? a.tap { a[a.size - 1] += 1 } : a << 1
}.map(&trib).reduce(:*)
