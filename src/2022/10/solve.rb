#!/usr/bin/env ruby
# frozen_string_literal: true

cycles = [1]
x = 1

ARGF.readlines.each do |l|
  case l
  when /^noop/
    cycles.push x
  when /^addx (-?\d+)/
    cycles += [x, x+= $1.to_i]
  end
end

puts 19.step(cycles.size, 40).map { cycles[_1] * (_1 + 1) }.sum

crt = 240.times.map do |i|
  v = cycles[i]
  (v - 1..v + 1).include?(i % 40) ? '##' : '  '
end

puts crt.each_slice(40).map(&:join).join("\n")
