#!/usr/bin/env ruby

require_relative '../../intcode/cpu'

PATH = ARGV.first || 'input.txt'

phase_arrangements = [5, 6, 7, 8, 9].permutation(5)

def run(phases)
  puts "Testing #{phases}"
  base = Intcode::CPU.new.load!(PATH)
  cpus = phases.map { |p| base.dup.input! p }

  input = 0

  while cpus.all? { |cpu| !cpu.halted? }
    puts 'Running'
    cpus.each do |cpu|
      cpu.input! input
      cpu.run!
      input = cpu.output.last.to_i
    end
  end

  cpus.last.output.last.to_i
end

values = phase_arrangements.map { |a| run a }

puts values.max
