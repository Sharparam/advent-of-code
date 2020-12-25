#!/usr/bin/env ruby

DIVISOR = 20201227
TRANSFORM_MEM = {}

def transform(count, subject: 7, value: 1)
  prev = [count - 1, subject]
  if TRANSFORM_MEM.key? prev
    value = (TRANSFORM_MEM[prev] * subject) % DIVISOR
  else
    count.times { value = (value * subject) % DIVISOR }
  end

  TRANSFORM_MEM[[count, subject]] = value
end

CARD_PUBKEY, DOOR_PUBKEY = ARGF.readlines.map(&:to_i)

CARD_LOOP_SIZE = (1..).find { transform(_1) == CARD_PUBKEY }

puts transform CARD_LOOP_SIZE, subject: DOOR_PUBKEY
