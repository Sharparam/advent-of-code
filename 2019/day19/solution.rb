#!/usr/bin/env ruby

require 'matrix'
require 'pry'

require_relative '../intcode/cpu'

DEBUG = ENV['DEBUG']

PATH = ARGV.first || 'input'

def calc(x, y)
  cpu = Intcode::CPU.new.print_output!(false).load!(PATH)
  cpu.input!(x)
  cpu.input!(y)
  cpu.run!
  cpu.output[-1]
end

x = 0
y = 0
start_x = 0
sum = 0
lines = Queue.new

loop do
  x = start_x
  last_x = x
  last = 0
  line_sum = 0
  loop do
    value = calc x, y
    line_sum += value
    start_x = x if last == 0 && value == 1
    last_x = x if value == 1
    break if (last == 1 && value == 0) || (y < 50 && x > y)
    last = value
    x += 1
  end

  sum += line_sum

  puts "#{y}: #{line_sum}" if DEBUG

  current_line = [start_x, last_x]
  lines.enq current_line

  lines.deq while lines.size > 100

  puts "Part 1: #{sum}" if y == 49

  if lines.size == 100
    previous_line = lines.deq
    current_start_x = current_line.first
    previous_end_x = previous_line.last

    if current_start_x + 99 <= previous_end_x
      puts "Part 2: #{(previous_end_x - 99) * 10000 + (y - 99)}"
      break
    end
  end

  y += 1
end
