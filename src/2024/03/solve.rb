#!/usr/bin/env ruby
# frozen_string_literal: true

puts ARGF.read.scan(/(mul)\((\d+),(\d+)\)|(do(?:n't)?)\(\)/).reduce([0, 0, true]) { |(p1, p2, e), i|
  case i
  in ["mul", a, b, *]
    [p1 + a.to_i * b.to_i, e ? p2 + a.to_i * b.to_i : p2, e]
  in [*, "do"] then [p1, p2, true]
  in [*, "don't"] then [p1, p2, false]
  end
}[0..1]
