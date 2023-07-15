#!/usr/bin/env ruby

INPUT = ARGV[0] || '0,20,7,16,1,18,15'
NUMS = INPUT.split(',').map(&:to_i)

def solve(turns)
  data = [-1] * turns
  NUMS[..-2].each_with_index { data[_1] = _2 + 1 }

  last, turn = NUMS.last, NUMS.size

  while turn < turns
    first, data[last] = data[last], turn
    last = first == -1 ? 0 : turn - first
    turn += 1
  end

  last
end

if ARGV[1]
  puts solve2(ARGV[1].to_i)
else
  puts solve(2020)
  puts solve(30_000_000)
end
