#!/usr/bin/env ruby
# frozen_string_literal: true

DEFAULT_WIDTH = 25
DEFAULT_HEIGHT = 6

PATH = ARGV[0] || 'input'
WIDTH = ARGV[1]&.to_i || DEFAULT_WIDTH
HEIGHT = ARGV[2]&.to_i || DEFAULT_HEIGHT

LAYER_SIZE = WIDTH * HEIGHT

data = File.read(PATH).strip
layers = data.scan(%r{.{#{LAYER_SIZE}}}).map { |s| s.chars.map(&:to_i) }

part1_slice = layers.min_by { |s| s.count { |d| d == 0 } }
part1_ones = part1_slice.count { |d| d == 1 }
part1_twos = part1_slice.count { |d| d == 2 }
part1 = part1_ones * part1_twos

part2 = [2] * LAYER_SIZE

layers.each do |layer|
  layer.each_with_index do |d, i|
    if part2[i] == 2 && d != 2
      part2[i] = d
    end
  end
end

puts "Part 1: #{part1}"

puts 'Part 2:'

def print_pixel(pixel)
  print pixel == 0 ? ' ' : '█'
end

(0...HEIGHT).each do |y|
  (0...WIDTH).each do |x|
    pixel = part2[y * WIDTH + x]
    print_pixel pixel
  end
  puts
end
