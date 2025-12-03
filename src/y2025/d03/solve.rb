#!/usr/bin/env ruby
# frozen_string_literal: true

banks = ARGF.map { |l| l.chomp.chars }

def f(bank, index = 0)
  max = bank[index]
  bank[(index + 1)..].each_with_index do |batt, i|
    if batt > max
      max = batt
      index = i + 1
    end
  end

  # puts "#{bank} max #{max} at #{index}"

  [max, index]
end

puts banks.sum { |bank|
  first, i = f(bank[...-1])
  second, = f(bank[(i + 1)..])
  "#{first}#{second}".to_i
}
