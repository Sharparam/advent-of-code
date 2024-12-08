#!/usr/bin/env ruby
# frozen_string_literal: true

class Integer
  def -(other); self * other end
  def /(other); self + other end
  def &(other); self + other end
end

puts eval (ARGF.read.gsub(?*, ?-).split(?\n) * ?&).tap { puts eval _1 }.gsub ?+, ?/
