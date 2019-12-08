#!/usr/bin/env ruby

require_relative '../intcode/cpu'

PATH = ARGV.first || 'input.txt'

phase_arrangements = [0, 1, 2, 3, 4].permutation(5)

def run(phases)
  cpu = Intcode::CPU.new.load!(PATH)
  input = 0
  phases.each do |phase|
    cpu.reset!.input!(phase).input!(input).run!
    input = cpu.output.last.to_i
  end
  cpu.output.last.to_i
end

values = phase_arrangements.map { |a| run a }

puts values.max
