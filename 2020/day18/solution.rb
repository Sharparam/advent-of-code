#!/usr/bin/env ruby

class Integer
  def - _; self * _; end
  def / _; self + _; end
end

INPUT = ARGF.readlines.map { _1.gsub(?*, ?-) }

puts INPUT.map(&method(:eval)).sum
puts INPUT.map { eval _1.gsub(?+, ?/) }.sum
