#!/usr/bin/env ruby

DIV, v = 20201227, 1
CARD, DOOR = ARGF.readlines.map(&:to_i)

puts (1..).find { (v = (v * 7) % DIV) == CARD }.times.reduce(1) { |a, _| (a * DOOR) % DIV }
