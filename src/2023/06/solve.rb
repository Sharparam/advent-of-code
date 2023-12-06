#!/usr/bin/env ruby
# frozen_string_literal: true

times, distances = ARGF.readlines.map { _1.scan(/\d+/).map(&:to_i) }

puts times.zip(distances).reduce(1) { |total, (time, distance)|
  total * (0..time).count { (time - _1) * _1 > distance }
}

time = times.join.to_i
distance = distances.join.to_i

puts (0..time).find { (time - _1) * _1 > distance }.then { time - 2 * _1 + 1 }
