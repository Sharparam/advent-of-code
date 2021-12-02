#!/usr/bin/env ruby
# frozen_string_literal: true

$position = $depth = $depth2 = 0

def forward(n)
  $position += n
  $depth2 += $depth * n
end

def down(n) = $depth += n
def up(n) = $depth -= n

eval ARGF.read

puts $position * $depth, $position * $depth2
