#!/usr/bin/env ruby
# frozen_string_literal: true

def angle(dx, dy)
  Math::PI + Math.atan2(-dx, -dy)
end

def test(text, dx, dy)
  result = angle(dx, dy)
  print '(%4d, %4d)' % [dx, dy]
  puts " #{text}: #{result}"
end

test ' ^', 0, 10
test '/>', -10, 10
test ' >', -10, 0
test '\\>', -10, -10
test '\\/', 0, -10
test '</', 10, -10
test ' <', 10, 0
test '<\\', 10, 10

test '<<', 1, 10

test '1', -1, 1
test '2', -2, 2
test '3', -3, 3
