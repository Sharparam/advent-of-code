#!/usr/bin/env ruby
# frozen_string_literal: true

LINES = ARGF.readlines

OUTCOMES = {
  [?A, ?X] => 0, [?B, ?Y] => 0, [?C, ?Z] => 0,
  [?A, ?Y] => 1, [?A, ?Z] => -1,
  [?B, ?X] => -1, [?B, ?Z] => 1,
  [?C, ?X] => 1, [?C, ?Y] => -1
}

SCORES = { -1 => 0, 0 => 3, 1 => 6 }

RESOLVES = {
  ?A => { -1 => ?Z, 0 => ?X, 1 => ?Y },
  ?B => { -1 => ?X, 0 => ?Y, 1 => ?Z },
  ?C => { -1 => ?Y, 0 => ?Z, 1 => ?X }
}

def score(t, u) = SCORES[OUTCOMES[[t, u]]] + (u.ord - 87)
def resolve(t, c) = score(t, RESOLVES[t][c.ord - 89])

puts LINES.sum { |l| score(*l.split(' ')) }
puts LINES.sum { |l| resolve(*l.split(' ')) }
