#!/usr/bin/env ruby
# frozen_string_literal: true

LINES = ARGF.readlines

OUTCOMES = {
  %w[A X] => 0, %w[B Y] => 0, %w[C Z] => 0,
  %w[A Y] => 1, %w[A Z] => -1,
  %w[B X] => -1, %w[B Z] => 1,
  %w[C X] => 1, %w[C Y] => -1
}.freeze

SCORES = { -1 => 0, 0 => 3, 1 => 6 }.freeze

RESOLVES = {
  ?A => { -1 => ?Z, 0 => ?X, 1 => ?Y },
  ?B => { -1 => ?X, 0 => ?Y, 1 => ?Z },
  ?C => { -1 => ?Y, 0 => ?Z, 1 => ?X }
}.freeze

def score(t, u) = SCORES[OUTCOMES[[t, u]]] + (u.ord - 87)
def resolve(t, c) = score(t, RESOLVES[t][c.ord - 89])

puts LINES.sum { |l| score(*l.split) }
puts LINES.sum { |l| resolve(*l.split) }
