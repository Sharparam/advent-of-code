#!/usr/bin/env ruby
# frozen_string_literal: true

OPCODES = {
  addr: ->(r, a, b, c) { r[c] = r[a] + r[b] },
  addi: ->(r, a, b, c) { r[c] = r[a] + b },
  mulr: ->(r, a, b, c) { r[c] = r[a] * r[b] },
  muli: ->(r, a, b, c) { r[c] = r[a] * b },
  banr: ->(r, a, b, c) { r[c] = r[a] & r[b] },
  bani: ->(r, a, b, c) { r[c] = r[a] & b },
  borr: ->(r, a, b, c) { r[c] = r[a] | r[b] },
  bori: ->(r, a, b, c) { r[c] = r[a] | b },
  setr: ->(r, a, _, c) { r[c] = r[a] },
  seti: ->(r, a, _, c) { r[c] = a },
  gtir: ->(r, a, b, c) { r[c] = a > r[b] ? 1 : 0 },
  gtri: ->(r, a, b, c) { r[c] = r[a] > b ? 1 : 0 },
  gtrr: ->(r, a, b, c) { r[c] = r[a] > r[b] ? 1 : 0 },
  eqir: ->(r, a, b, c) { r[c] = a == r[b] ? 1 : 0 },
  eqri: ->(r, a, b, c) { r[c] = r[a] == b ? 1 : 0 },
  eqrr: ->(r, a, b, c) { r[c] = r[a] == r[b] ? 1 : 0 }
}.freeze

input = File.readlines('input.txt')
IP_REG = input.shift.split.last.to_i
PROGRAM = input.join.scan(/([a-z]+) (\d+) (\d+) (\d+)/).map { |op, a, b, c| [op.to_sym, a.to_i, b.to_i, c.to_i] }.freeze

def run(regs)
  ip = 0
  while ip < PROGRAM.size
    regs[IP_REG] = ip
    print "ip=#{ip} [#{regs.join ', '}]"
    op, a, b, c = PROGRAM[ip]
    print " #{op} #{a} #{b} #{c}"
    OPCODES[op].call regs, a, b, c
    puts "[#{regs.join ', '}]"
    ip = regs[IP_REG]
    ip += 1
  end
  regs
end

puts "Part 1: #{run([0] * 6)[0]}"

# Part 2 cannot be solved like this, takes too long to run
exit
puts "Part 2: #{run(([0] * 6).tap { |r| r[0] = 1 })[0]}" # rubocop:disable Lint/UnreachableCode

require 'pry'
binding.pry
