#!/usr/bin/env ruby

require 'set'

input = File.read('test.txt').strip

part1 = input.split('')

def react(str)
  arr = str.split('')
  replaced = true

  while replaced
    replaced = false

    bad_indices = Set.new

    arr.each.with_index do |e, i|
      n = arr[i..i+1]
      if n.map(&:upcase).uniq.size == 1 && n.uniq.size == 2
        bad_indices.add i
        bad_indices.add i + 1
        replaced = true
      end
    end

    arr.reject!.with_index { |_, i| bad_indices.include? i }
  end

  arr
end

part1 = react input

puts "Part 1: #{part1.size}"

letters = input.upcase.split('').uniq

puts letters

smallest = input.size

letters.each.with_index do |letter, index|
  puts "Testing with letter #{letter} (#{index + 1} / #{letters.size})"
  new_input = input.gsub /#{letter}/i, ''
  reacted = react new_input
  smallest = reacted.size if reacted.size < smallest
end

puts "Part 2: #{smallest}"
