#!/usr/bin/env ruby
# frozen_string_literal: true

program = File.read('input.txt').split(',').map(&:to_i)

def run(program, noun, verb)
  memory = program.dup
  memory[1] = noun
  memory[2] = verb

  run = true
  pc = 0

  while run
    opcode = memory[pc]

    case opcode
    when 1
      a = memory[pc + 1]
      b = memory[pc + 2]
      c = memory[pc + 3]
      memory[c] = memory[a] + memory[b]
      pc += 4
    when 2
      a = memory[pc + 1]
      b = memory[pc + 2]
      c = memory[pc + 3]
      memory[c] = memory[a] * memory[b]
      pc += 4
    when 99
      run = false
    end
  end

  memory
end

part1 = run program, 12, 2
puts "Part 1: #{part1[0]}"

PART2_TARGET = 19690720

part2 = (0..99).to_a.repeated_permutation(2).find do |(noun, verb)|
  result = run program, noun, verb
  result[0] == PART2_TARGET
end

puts "Part 2: #{100 * part2[0] + part2[1]}"
