#!/usr/bin/env ruby
# frozen_string_literal: true

banks = ARGF.map { |l| l.chomp.chars }

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

puts banks.sum { |bank|
  first, i = max(bank[...-1])
  second, = max(bank[(i + 1)..])
  "#{first}#{second}".to_i
}
