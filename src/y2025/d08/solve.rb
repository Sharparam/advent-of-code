#!/usr/bin/env ruby
# frozen_string_literal: true

require 'matrix'

STEPS = ENV['STEPS']&.then(&:to_i) || 1000

def dist(a, b)
  Math.sqrt(((a[0] - b[0])**2) + ((a[1] - b[1])**2) + ((a[2] - b[2])**2))
end

boxes = ARGF.map { Vector[*_1.split(',').map(&:to_i)] }

distances = boxes.combination(2).map { |a, b| [a, b, dist(a, b)] }.sort_by { _1[2] }

circuits = []

counter = 0
loop do
  a, b, = distances.shift
  existing = circuits.select { _1.include?(a) || _1.include?(b) }
  abort 'should never match more than 2' if existing.size > 2
  if existing.size == 2
    existing[0].merge existing[1]
    circuits.delete existing[1]
  end
  existing = existing[0]
  if existing
    existing.add a
    existing.add b
  else
    circuit = Set.new
    circuit.add a
    circuit.add b
    circuits.push circuit
  end

  counter += 1
  puts circuits.map(&:size).sort[-3..].reduce(:*) if counter == STEPS

  next unless existing && boxes.all? { existing.include? _1 }
  puts a[0] * b[0]
  break
end
