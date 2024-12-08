#!/usr/bin/env ruby
# frozen_string_literal: true

class Integer
  def - _; self * _ end
  def / _; self + _ end
  def & _; self + _ end
end

puts eval (ARGF.read.gsub(?*,?-).split(?\n) * ?&).tap{puts eval _1}.gsub ?+,?/
