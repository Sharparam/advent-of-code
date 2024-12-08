#!/usr/bin/env ruby
# frozen_string_literal: true

require 'matrix'

def md(a, b)
  (a[0] - b[0]).abs + (a[1] - b[1]).abs
end

def wmd(a, b)
  ax, ay = a[0], a[1]
  d = md(a, b)
  x_min, x_max, y_min, y_max = a[0] - d, a[0] + d, a[1] - d, a[1] + d

  (x_min..x_max).map do |x|
    xd = (ax - x).abs
    yf, yt = y_min + xd, y_max - xd
    [Vector[x, yf], Vector[x, yt]]
  end
end

pairs = ARGF.read.scan(/-?\d+/).map(&:to_i).each_slice(4).map { [Vector[_1, _2], Vector[_3, _4]] }

beacons = Set[*pairs.map(&:last)]
invalid = Set[]

Y = 2_000_000

pairs.each do |s, b|
  cols = wmd(s, b).to_a
  cols.each do |c|
    if (c[0][1]..c[1][1]).include?(Y)
      invalid.add(c[0][0]) unless beacons.include?(Vector[c[0][0], Y])
    end
  end
end

puts invalid.size

def perimiter(s, b)
  d = md(s, b)

  left = s[0] - d
  steps = (1..d).to_a
  steps = steps + [nil] + steps.reverse

  result = []

  ((s[0] - d)..(s[0] + d)).each do |x|
    y_step = steps[x - left]
    if !y_step.nil?
      result.push Vector[x, s[1] + y_step]
      result.push Vector[x, s[1] - y_step]
    end
  end

  result
end

distances = pairs.map { |s, b| [s, md(s, b)] }

MAX = 4_000_000

pairs.each do |sensor, beacon|
  perims = perimiter(sensor, beacon).reject { |v| v[0] < 0 || v[0] > MAX || v[1] < 0 || v[1] > MAX }
  others = distances.reject { |s, _| s == sensor }

  perims.each do |v|
    if others.all? { |o, d| md(o, v) > d }
      puts v[0] * MAX + v[1]
      exit
    end
  end
end
