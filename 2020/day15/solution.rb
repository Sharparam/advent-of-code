#!/usr/bin/env ruby

INPUT = ARGV[0] || '0,20,7,16,1,18,15'
NUMS = INPUT.split(',').map(&:to_i)

def solve(turns)
  data = Hash[NUMS.map.with_index { [_1, [_2 + 1]] }]

  last = NUMS.last
  turn = NUMS.size

  while turn < turns
    turn += 1

    if data[last].size < 2
      last = 0
    else
      last = data[last].last - data[last].shift
    end

    (data[last] ||= []) << turn
  end

  last
end

if ARGV[1]
  puts solve(ARGV[1].to_i)
else
  puts solve(2020)
  puts solve(30_000_000)
end
