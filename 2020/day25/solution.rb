#!/usr/bin/env ruby

DIV, v = 20201227, 1
CARD, DOOR = ARGF.readlines.map(&:to_i)

puts DOOR.pow((1..).find { (v = (v * 7) % DIV) == CARD }, DIV)
