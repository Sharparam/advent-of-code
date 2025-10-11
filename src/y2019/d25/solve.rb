#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../../../lib/aoc/intcode/cpu'

PATH = ARGV.first || 'input'
DEBUG = ENV.fetch('DEBUG', nil)

cpu = AoC::Intcode::CPU.new.print_output!(false).load!(PATH)

loop do
  cpu.run!
  output = cpu.output.map(&:chr).join
  puts output
  cpu.clear_output!
  break unless output =~ /Command\?/i
  input = $stdin.readline
  break if input =~ /exit/
  cpu.input! input
end
