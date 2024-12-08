#!/usr/bin/env ruby
# frozen_string_literal: true

coords = File.read('input.txt').scan(/(\d+), (\d+)/).map { |ns| ns.map(&:to_i) }

xmin, xmax = coords.map(&:first).minmax
ymin, ymax = coords.map(&:last).minmax

counts = [0] * coords.size
invalids = [false] * coords.size

part2 = 0

(xmin..xmax).each do |x|
  x_edge = x == xmin || x == xmax
  x_dists = coords.map { |cx, _| (x - cx).abs }
  (ymin..ymax).each do |y|
    y_edge = y == ymin || y == ymax
    best_i = nil
    best_dist = 1.0 / 0.0
    dist_total = 0
    coords.each_with_index do |(_, cy), i|
      dist = x_dists[i] + (y - cy).abs
      if dist < best_dist
        best_dist = dist
        best_i = i
      elsif dist == best_dist
        best_i = nil
      end
      dist_total += dist
    end

    part2 += 1 if dist_total < 10000

    next unless best_i

    if x_edge || y_edge
      invalids[best_i] = true
    else
      counts[best_i] += 1
    end
  end
end

puts "Part 1: #{counts.zip(invalids).reject(&:last).map(&:first).max}"
puts "Part 2: #{part2}"
