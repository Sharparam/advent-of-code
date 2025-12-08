#!/usr/bin/env ruby
# frozen_string_literal: true

require 'matrix'

class Vector
  def to_s
    "#{self[0]},#{self[1]},#{self[2]}"
  end
end

STEPS = ENV['STEPS']&.then(&:to_i) || 1000

def dist(a, b)
  Math.sqrt(((a[0] - b[0])**2) + ((a[1] - b[1])**2) + ((a[2] - b[2])**2))
end

boxes = ARGF.map { Vector[*_1.split(',').map(&:to_i)] }

distances = boxes.combination(2).map { |a, b| [a, b, dist(a, b)] }.sort_by { _1[2] }

# distances.each do |a, b, d|
#   puts "#{a} -> #{b} = #{d}"
# end

circuits = []

# counter = 0

STEPS.times do
  a, b, d = distances.shift
  existing = circuits.select { _1.include?(a) || _1.include?(b) }
  abort 'should never match more than 2' if existing.size > 2
  if existing.size == 2
    existing[0].merge existing[1]
    circuits.delete existing[1]
  end
  existing = existing[0]
  if existing
    # next if existing.include?(a) && existing.include?(b)
    # puts "adding #{a} and #{b} to existing circuit"
    existing.add a
    existing.add b
  else
    # puts "creating new circuit with #{a} and #{b}"
    circuit = Set.new
    circuit.add a
    circuit.add b
    circuits.push circuit
  end
  # counter += 1
  # circuits.each do |circuit|
  #   puts "#{circuit.join(' - ')}: #{circuit.size}"
  # end
  # puts "\n"
end

# p circuits.map(&:size)

# circuits.each do |circuit|
#   puts "#{circuit.join(' - ')}: #{circuit.size}"
# end

puts circuits.map(&:size).sort[-3..].reduce(:*)
