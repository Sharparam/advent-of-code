#!/usr/bin/env ruby
# frozen_string_literal: true

equations = ARGF.map { _1.scan(/\d+/).map(&:to_i) }

class Integer
  def c(other)
    "#{self}#{other}".to_i
  end
end

def validate(t, values, ops, head)
  return ops.any? { t == head.send(_1, values[0]) } if values.size == 1

  ops.any? { validate t, values[1..], ops, head.send(_1, values[0]) }
end

PART1_OPS = %i[+ *].freeze
PART2_OPS = %i[+ * c].freeze

failed = []

part1 = equations.filter {
  result = validate(_1[0], _1[2..], PART1_OPS, _1[1])
  next result if result
  failed << _1
  false
}.sum { _1[0] }
puts part1
puts failed.filter { validate(_1[0], _1[2..], PART2_OPS, _1[1]) }.sum { _1[0] } + part1
