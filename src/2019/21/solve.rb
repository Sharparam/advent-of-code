#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../../intcode/cpu'

PATH = ARGV.first || 'input'
DEBUG = ENV.fetch('DEBUG', nil)

script = <<~SCRIPT
  NOT A J
  NOT B T
  AND D T
  OR T J
  NOT C T
  OR T J
  AND D J
  WALK
SCRIPT

cpu = Intcode::CPU.new.print_output!(false).load!(PATH).input!(script)

cpu.run!

if cpu.output[-1] > 255
  puts "Part 1: #{cpu.output[-1]}"
else
  puts cpu.output.map(&:chr).join
end

cpu.reset!

script = <<~SCRIPT
  NOT A J
  NOT B T
  AND D T
  OR T J
  NOT C T
  OR T J
  NOT A T
  OR T J
  AND H J
  OR E J
  AND D J
  RUN
SCRIPT

cpu.input!(script).run!

if cpu.output[-1] > 255
  puts "Part 2: #{cpu.output[-1]}"
else
  puts cpu.output.map(&:chr).join
end
