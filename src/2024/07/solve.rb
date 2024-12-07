#!/usr/bin/env ruby
# frozen_string_literal: true

equations = ARGF.map { _1.scan(/\d+/).map(&:to_i) }

class Integer
  def c(other)
    "#{self}#{other}".to_i
  end
end

def validate(eq, ops)
  t, *values = eq
  ops = ops.repeated_permutation(values.size - 1).to_a
  t if ops.any? { |o|
    values.each_with_index.reduce { |(a, _), (e, i)|
      a.send(o[i - 1], e)
    } == t
  }
end

PART1_OPS = %i[+ *].freeze
PART2_OPS = %i[+ * c].freeze

failed = []

part1 = equations.filter_map {
  result = validate(_1, PART1_OPS)
  next result if result
  failed << _1
  nil
}.sum
puts part1
puts failed.filter_map { validate(_1, PART2_OPS) }.sum + part1
