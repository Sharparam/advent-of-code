#!/usr/bin/env ruby
# frozen_string_literal: true

banks = ARGF.map { |l| l.chomp.chars.map(&:to_i) }

def max(bank, size, current = 0)
  return current if size.zero?
  index = 0
  max = bank[0]
  bank.each_with_index do |batt, i|
    if batt > max && (bank.size - i) >= size
      max = batt
      index = i
    end
  end

  max(bank[(index + 1)..], size - 1, (current * 10) + max)
end

puts banks.reduce([0, 0]) { |(p1, p2), bank|
  m1 = max(bank, 2)
  m2 = max(bank, 12)

  [p1 + m1, p2 + m2]
}
