#!/usr/bin/env ruby
# frozen_string_literal: true

banks = ARGF.map { |l| l.chomp.chars.map(&:to_i) }

def max(bank, index = 0)
  max = bank[index]
  bank[(index + 1)..].each_with_index do |batt, i|
    if batt > max
      max = batt
      index = i + 1
    end
  end

  [max, index]
end

def max2(bank, size, current = 0)
  return current if size.zero?
  index = 0
  max = bank[0]
  bank.each_with_index do |batt, i|
    if batt > max && (bank.size - i) >= size
      max = batt
      index = i
    end
  end

  max2(bank[(index + 1)..], size - 1, (current * 10) + max)
end

puts banks.reduce([0, 0]) { |(p1, p2), bank|
  first, i = max(bank[...-1])
  second, = max(bank[(i + 1)..])

  m2 = max2(bank, 12)

  [p1 + "#{first}#{second}".to_i, p2 + m2]
}
