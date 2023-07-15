#!/usr/bin/env ruby

require_relative '../../intcode/cpu'

PATH = ARGV.first || 'input'
DEBUG = ENV['DEBUG']

cpu = Intcode::CPU.new.print_output!(false).load!(PATH)

loop do
  cpu.run!
  output = cpu.output.map(&:chr).join
  puts output
  cpu.clear_output!
  break unless output =~ /Command\?/i
  input = STDIN.readline
  break if input =~ /exit/
  cpu.input! input
end
