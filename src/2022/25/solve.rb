#!/usr/bin/env ruby
# frozen_string_literal: true

require 'pry'

MAP = {
  '2' => 2,
  '1' => 1,
  '0' => 0,
  '-' => -1,
  '=' => -2
}

def from_snafu(s)
  s.chars.reduce(0) { |a, c| a * 5 + MAP[c] }
end

def to_snafu(d)
  r = []

  while d > 0
    rem = d % 5
    if rem == 0
      r.unshift '0'
      d /= 5
    elsif rem == 1
      r.unshift '1'
      d = (d - 1) / 5
    elsif rem == 2
      r.unshift '2'
      d = (d - 2) / 5
    elsif rem == 3
      r.unshift '='
      d = (d + 2) / 5
    elsif rem == 4
      r.unshift '-'
      d = (d + 1) / 5
    end
  end

  r.join
end

TOTAL = ARGF.readlines.map { from_snafu(_1.strip) }.sum
snafu = to_snafu(TOTAL)

puts snafu
