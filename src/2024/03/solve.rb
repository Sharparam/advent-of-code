#!/usr/bin/env ruby
# frozen_string_literal: true

puts ARGF.read.scan(/(mul)\((\d+),(\d+)\)|(do(?:n't)?)\(\)/).reduce({ p1: 0, p2: 0, e: true }) { |s, i|
  case i
  in ["mul", a, b, *]
    s[:p1] += a.to_i * b.to_i
    s[:p2] += a.to_i * b.to_i if s[:e]
  in [*, "do"] then s[:e] = true
  in [*, "don't"] then s[:e] = false
  end
  s
}.then { [_1[:p1], _1[:p2]] }
