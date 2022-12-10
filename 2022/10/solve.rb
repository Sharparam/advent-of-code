#!/usr/bin/env ruby
# frozen_string_literal: true

require 'pry'

cycles = [1]
x = 1

ARGF.readlines.each do |l|
  case l
  when /^noop/
    cycles.push x
  when /^addx (-?\d+)/
    v = $1.to_i
    cycles += [x, x+= v]
  end
end

puts 19.step(cycles.size, 40).map { cycles[_1] * (_1 + 1) }.sum

crt = 240.times.map do |i|
  h = i % 40
  v = cycles[i]
  pixel = (v - 1..v + 1)
  lit = pixel.include?(h)
  lit ? '#' : ':'
end

puts crt.each_slice(40).map(&:join).join("\n")
