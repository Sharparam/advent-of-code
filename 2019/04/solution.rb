#!/usr/bin/env ruby

require 'set'

INPUT = ARGV.first || '356261-846303'

MIN, MAX = INPUT.split '-'

values = (MIN..MAX).to_a

valid_count = 0
part2_count = 0

values.each do |value|
  previous_f = 0
  previous_s = 0
  has_double = false
  exacts_set = Set.new
  valid = true
  value.chars.each_cons(2) do |(first, second)|
    f = first.to_i
    s = second.to_i

    if s < f
      valid = false
    elsif f == s
      has_double = true

      if f == previous_f && f == previous_s
        exacts_set.delete f
      else
        exacts_set.add f
      end
    end

    previous_f = f
    previous_s = s
  end

  if has_double && valid
    valid_count += 1
    if exacts_set.any?
      part2_count += 1
    end
  end
end

puts "Part 1: #{valid_count}"
puts "Part 2: #{part2_count}"
