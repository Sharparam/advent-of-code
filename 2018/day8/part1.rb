#!/usr/bin/env ruby

def part1(d, s = 0)
  a = d.shift 2; s + a[0].times.map { part1 d, s }.sum + d.shift(a[1]).sum
end

puts "Part 1: #{part1 File.read('input.txt').split.map(&:to_i)}"
