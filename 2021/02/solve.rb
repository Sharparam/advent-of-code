#!/usr/bin/env ruby
# frozen_string_literal: true

instructions = ARGF.readlines.map(&:split).map { |i, n| [i.to_sym, n.to_i] }

$position = 0
$depth = 0 # also aim
$depth2 = 0

def forward(n)
  $position += n
  $depth2 += $depth * n
end

def down(n) = $depth += n
def up(n) = $depth -= n

instructions.each { send(*_1) }

puts $position * $depth
puts $position * $depth2
