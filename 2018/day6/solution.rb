#!/usr/bin/env ruby

PART2_THRESHOLD = 10000

coords = File.read('input.txt').scan(/(\d+), (\d+)/).map { |ns| ns.map(&:to_i) }
width = coords.map(&:first).max + 1
height = coords.map(&:last).max + 1
areas = Hash.new { |h, k| h[k] = [] }

def dist(a, b); (a[0] - b[0]).abs + (a[1] - b[1]).abs; end
def find(coords, i)
  dists = Hash[coords.map { |c| [c, dist(i, c)] }]
  min = dists.values.min
  filtered = dists.select { |k, v| v == min }
  filtered.size > 1 ? nil : filtered.keys.first
end

part2_area = 0

(0...width).each do |x|
  (0...height).each do |y|
    point = [x, y]
    closest = find(coords, point)
    part2_dist = coords.map { |c| dist(c, point) }.sum
    part2_area += 1 if part2_dist < PART2_THRESHOLD
    next unless closest
    areas[closest] << point
  end
end

largest = areas.reject do |k, v|
  v.any? { |e| e.first == 0 || e.first == width - 1 || e.last == 0 || e.last == height - 1 }
end.max { |a, b| a.last.size <=> b.last.size }.last.size

puts "Part 1: #{largest}"
puts "Part 2: #{part2_area}"

# require 'pry'
# binding.pry
