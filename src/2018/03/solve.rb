#!/usr/bin/env ruby
# frozen_string_literal: true

coords = Hash.new { |h, k| h[k] = [] }

File.readlines('input.txt').map do |l|
  match = /^\#(\d+) @ (\d+),(\d+): (\d+)x(\d+)$/.match l
  id = match[1].to_i
  x = match[2].to_i
  y = match[3].to_i
  w = match[4].to_i
  h = match[5].to_i
  (x...(x + w)).each do |x|
    (y...(y + h)).each do |y|
      coords["#{x},#{y}"] << id
    end
  end
end

puts "Part 1: #{coords.count { |_k, v| v.size > 1 }}"

counts = coords.values.each_with_object(Hash.new(0)) do |e, h|
  e.each { |i| h[i] = e.size unless h[i] > e.size }
end

puts "Part 2: #{counts.find { |_k, v| v == 1 }.first}"
