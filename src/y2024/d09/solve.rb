#!/usr/bin/env ruby
# frozen_string_literal: true

input = ARGF.readline.chomp.chars.map(&:to_i)

id = -1
disk = input.flat_map.with_index { |s, i|
  [i.even? ? id += 1 : nil] * s
}

def checksum(disk)
  disk.each_with_index.sum { |b, i| b.nil? ? 0 : b * i }
end

def part1(disk)
  left = disk.index nil
  right = disk.size - 1

  until left >= disk.size || left >= right
    disk[left] = disk[right]
    disk[right] = nil
    right -= 1 while disk[right].nil?
    left += 1 until disk[left].nil?
  end

  checksum disk
end

def map_free(disk)
  map = {}
  current_i = 0
  in_free = false
  free_size = 0
  disk.each_with_index do |block, i|
    if block.nil? && !in_free
      current_i = i
      in_free = true
      free_size = 1
    elsif block.nil? && in_free
      free_size += 1
    elsif !block.nil? && in_free
      map[current_i] = free_size
      in_free = false
    end
  end

  map
end

def part2(disk)
  map = map_free disk
  right = disk.size - 1
  ids = disk.compact.uniq

  while (current = ids.pop)
    left = disk.index current
    right = left
    right += 1 while disk[right + 1] == current
    size = right - left + 1
    space = map.find { |i, s| s >= size && i < left }
    next unless space

    free_i = space[0]
    (left..right).each do |i|
      disk[free_i] = disk[i]
      disk[i] = nil
      free_i += 1
    end

    map = map_free disk
  end

  checksum disk
end

puts part1 disk.dup
puts part2 disk
