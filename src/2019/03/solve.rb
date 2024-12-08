#!/usr/bin/env ruby
# frozen_string_literal: true

require 'matrix'

def dist(v1, v2)
  (v1[0] - v2[0]).abs + (v1[1] - v2[1]).abs
end

paths = File.readlines(ARGV.first || 'input.txt').map(&:strip)
paths = paths.map { |l| l.split ',' }

origin = Vector[0, 0]

visited = [Set.new, Set.new]

# key: Vector[x, y], val: { first_steps: 123, second_steps: 123 }
intersections = {}

first = paths.first
second = paths.last

pos = origin

def make_vel(dir)
  case dir
  when :L
    Vector[-1, 0]
  when :D
    Vector[0, -1]
  when :U
    Vector[0, 1]
  when :R
    Vector[1, 0]
  end
end

first.each do |op|
  dir = op[0].to_sym
  steps = op[1..].to_i

  vel = make_vel dir

  steps.times do |_n|
    pos += vel
    visited.first.add pos
  end
end

pos = origin

second_steps = 0
second.each do |op|
  dir = op[0].to_sym
  steps = op[1..].to_i

  vel = make_vel dir

  steps.times do |_n|
    second_steps += 1
    pos += vel
    visited.last.add pos
    intersections[pos] = { second_steps: second_steps } if visited.first.include?(pos) && !intersections.key?(pos)
  end
end

pos = origin

first_steps = 0
first.each do |op|
  dir = op[0].to_sym
  steps = op[1..].to_i

  vel = make_vel dir

  steps.times do |_n|
    first_steps += 1
    pos += vel
    if visited.last.include? pos
      intersections[pos][:first_steps] ||= first_steps
      intersections[pos][:sum_steps] = intersections[pos][:first_steps] + intersections[pos][:second_steps]
    end
  end
end

dists = intersections.map { |(k, _)| dist(origin, k) }
part1 = dists.min

puts "Part 1: #{part1}"

step_counts = intersections.map { |(_, v)| v[:sum_steps] }
part2 = step_counts.min

puts "Part 2: #{part2}"
