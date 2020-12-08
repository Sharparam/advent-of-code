#!/usr/bin/env ruby
# frozen_string_literal: true

require 'set'

PROGRAM = ARGF.readlines.map(&:split).map { [_1.to_sym, _2.to_i] }

def test(program)
  acc = 0
  pc = 0
  seen = Set.new
  loop do
    return [true, acc] if pc >= program.size
    op, val = program[pc]
    return [false, acc] unless seen.add? pc
    case op
    when :acc
      acc += val
    when :jmp
      pc += val - 1
    end

    pc += 1
  end
end

puts test(PROGRAM).last

INVERT = { jmp: :nop, nop: :jmp }.freeze
switch_idxs = PROGRAM.each_index.select { %i[jmp nop].include? PROGRAM[_1][0] }
switch_idxs.each do |idx|
  prog = PROGRAM.map(&:dup).tap { _1[idx][0] = INVERT[_1[idx][0]] }
  result, val = test(prog)
  if result
    puts val
    break
  end
end
