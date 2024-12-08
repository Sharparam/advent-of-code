#!/usr/bin/env ruby
# frozen_string_literal: true

DIV, v = 20_201_227, 1
CARD, DOOR = ARGF.readlines.map(&:to_i)

puts DOOR.pow((1..).find { (v = (v * 7) % DIV) == CARD }, DIV)
