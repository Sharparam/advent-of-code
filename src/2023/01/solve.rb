#!/usr/bin/env ruby
# frozen_string_literal: true

cals = ARGF.read.lines
digits = cals.map { |cal| cal.scan(/\d/).to_a.map(&:to_i) }
pairs = digits.map { |digits| [digits.first, digits.last] }
nums = pairs.map { |pair| "#{pair.first}#{pair.last}".to_i }
puts nums.sum

re = /\d|one|two|three|four|five|six|seven|eight|nine/
rre = /\d|eno|owt|eerht|ruof|evif|xis|neves|thgie|enin/

digmap = {
  one: 1,
  two: 2,
  three: 3,
  four: 4,
  five: 5,
  six: 6,
  seven: 7,
  eight: 8,
  nine: 9
}
revdigmap = Hash[digmap.map { |k, v| [k.to_s.reverse.to_sym, v] }]

nums = cals.map do |line|
  firsts = line.scan(re).map { |d| digmap[d.to_sym] || d.to_i }
  first = firsts.first
  seconds = line.reverse.scan(rre).map { |d| revdigmap[d.to_sym] || d.to_i }
  second = seconds.first

  "#{first}#{second}".to_i
end

p nums.sum
