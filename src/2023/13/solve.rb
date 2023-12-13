#!/usr/bin/env ruby
# frozen_string_literal: true

patterns = ARGF.read.split("\n\n").map { _1.lines(chomp: true).map(&:chars) }

def diff(a, b)
  (0...a.size).count { a[_1] != b[_1] }
end

def diffs(pattern, m)
  r = [nil, nil]
  (0...pattern.size - 1).each do |i|
    diffs = 0
    i.downto(0).each do |j|
      o = 2 * i - j + 1
      break if o == pattern.size
      diffs += diff(pattern[j], pattern[o])
    end
    r[0] = (i + 1) * m if diffs == 0
    r[1] = (i + 1) * m if diffs == 1
    break unless r[0].nil? || r[1].nil?
  end

  r
end

def solve(pattern)
  r = diffs pattern, 100

  if r.any?(nil)
    alt = diffs pattern.transpose, 1
    r[0] ||= alt[0]
    r[1] ||= alt[1]
  end

  r
end

puts patterns.reduce([0, 0]) { [_1, solve(_2)].transpose.map(&:sum) }
