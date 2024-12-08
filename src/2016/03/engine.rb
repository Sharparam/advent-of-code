# frozen_string_literal: true

# Function courtesy of http://stackoverflow.com/a/3852809
def invert(arr, values)
  counts = values.each_with_object(Hash.new(0)) { |v, h| h[v] += 1 }
  arr.reject { |e| counts[e] -= 1 unless counts[e].zero? }
end

def count_triangles(list)
  list.reduce(0) do |a, e|
    a + (e.permutation(2).all? { |perm| perm.inject(&:+) > invert(e, perm).first } ? 1 : 0)
  end
end
