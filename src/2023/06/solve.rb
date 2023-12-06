#!/usr/bin/env ruby
# frozen_string_literal: true

times, distances = ARGF.read.lines.map { _1.scan(/\d+/).map(&:to_i) }

puts times.zip(distances).reduce(1) { |total, (time, distance)|
  total * (0..time).count { |t|
    remain = time - t
    dist = remain * t
    dist > distance
  }
}

time = times.join.to_i
distance = distances.join.to_i

puts (0..time).count { |t|
  remain = time - t
  dist = remain * t
  dist > distance
}
