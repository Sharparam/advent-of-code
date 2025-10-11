#!/usr/bin/env ruby
# frozen_string_literal: true

NUMS = ARGF.readlines.map(&:to_i).freeze
LEN = NUMS.size
MOD = LEN - 1

def mix(nums, indices)
  LEN.times do |original_i|
    current_i = indices.index original_i
    indices.delete_at current_i
    indices.insert (current_i + nums[original_i]) % MOD, original_i
  end
end

def solve(nums, n)
  indices = LEN.times.to_a
  n.times { mix(nums, indices) }
  zero_i = indices.index nums.index 0
  [1000, 2000, 3000].sum { |n| nums[indices[(zero_i + n) % LEN]] }
end

puts solve(NUMS, 1)

KEY = 811_589_153
NUMS2 = NUMS.map { _1 * KEY }

puts solve(NUMS2, 10)
