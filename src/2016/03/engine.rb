# encoding: utf-8
# frozen_string_literal: true

# Function courtesy of http://stackoverflow.com/a/3852809
def invert(arr, values)
  counts = values.inject(Hash.new(0)) { |h, v| h[v] += 1; h }
  arr.reject { |e| counts[e] -= 1 unless counts[e].zero? }
end

def count_triangles(list)
  list.reduce(0) do |a, e|
    a + (e.permutation(2).all? { |perm| perm.inject(&:+) > invert(e, perm).first } ? 1 : 0)
  end
end
