#!/usr/bin/env ruby
# frozen_string_literal: true

require 'bundler/setup'
require 'pairing_heap'

$program = ARGF.read.scan(/\d+/).map(&:to_i)
registers = $program.shift 3

def combo(regs, v)
  return v if v <= 3
  regs[v - 4]
end

def run(regs)
  ip = 0
  output = []
  loop do
    break if ip < 0
    instr = $program[ip]
    oper = $program[ip + 1]
    ip += 2
    break if instr.nil?

    case instr
    when 0 # adv
      regs[0] = regs[0] / (2**combo(regs, oper))
    when 1 # bxl
      regs[1] = regs[1] ^ oper
    when 2 # bst
      regs[1] = combo(regs, oper) % 8
    when 3 # jnz
      ip = oper if regs[0] != 0
    when 4 # bxz
      regs[1] = regs[1] ^ regs[2]
    when 5 # out
      output << (combo(regs, oper) % 8)
    when 6 # bdv
      regs[1] = regs[0] / (2**combo(regs, oper))
    when 7 # cdv
      regs[2] = regs[0] / (2**combo(regs, oper))
    end
  end
  output
end

puts run(registers.dup).join ','

heap = PairingHeap::SimplePairingHeap.new
heap.push [[0, 0, 0], $program.size - 1], 0

until heap.empty?
  regs, i = heap.pop
  target = $program[i]
  (0..0b111).each do |a|
    regs[0] = (regs[0] & (~0b111)) | a
    result = run(regs)
  end
end

# puts (0..).find { |a| run(a) == $program }
