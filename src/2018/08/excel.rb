#!/usr/bin/env ruby
# frozen_string_literal: true

# For @Tim#5138 on the AoC discord

LETTERS = ('A'..'Z').to_a.freeze

def to_excel(n)
  return LETTERS[n] if n < LETTERS.size
  q, r = n.divmod LETTERS.size
  to_excel(q - 1) + LETTERS[r]
end

def pe(n); printf("%4d == %4s\n", n, to_excel(n)); end

pe 0
pe 1
pe 20
pe 25
pe 26
pe 27

#  AA   AA    Z   A
pe (26 * 26) + 25 + 1
