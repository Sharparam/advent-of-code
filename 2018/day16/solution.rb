#!/usr/bin/env ruby

REGS = [0] * 4

OPCODES = {
  addr: -> (r, a, b, c) { r[c] = r[a] + r[b] },
  addi: -> (r, a, b, c) { r[c] = r[a] + b },
  mulr: -> (r, a, b, c) { r[c] = r[a] * r[b] },
  muli: -> (r, a, b, c) { r[c] = r[a] * b },
  banr: -> (r, a, b, c) { r[c] = r[a] & r[b] },
  bani: -> (r, a, b, c) { r[c] = r[a] & b },
  borr: -> (r, a, b, c) { r[c] = r[a] | r[b] },
  bori: -> (r, a, b, c) { r[c] = r[a] | b },
  setr: -> (r, a, _, c) { r[c] = r[a] },
  seti: -> (r, a, _, c) { r[c] = a },
  gtir: -> (r, a, b, c) { r[c] = a > r[b] ? 1 : 0 },
  gtri: -> (r, a, b, c) { r[c] = r[a] > b ? 1 : 0 },
  gtrr: -> (r, a, b, c) { r[c] = r[a] > r[b] ? 1 : 0 },
  eqir: -> (r, a, b, c) { r[c] = a == r[b] ? 1 : 0 },
  eqri: -> (r, a, b, c) { r[c] = r[a] == b ? 1 : 0 },
  eqrr: -> (r, a, b, c) { r[c] = r[a] == r[b] ? 1 : 0 }
}.freeze

input_part1, input_part2 = File.read('input.txt').split("\n\n\n").map(&:strip)

part1 = input_part1
.split("\n\n")
.map { |b| b.lines.map { |l| l.scan(/\d+/).map(&:to_i) } }.count do |(regs, code, regs_after)|
  op, a, b, c = code
  matching_ops = OPCODES.keys.select do |key|
    r = regs.dup
    OPCODES[key].call r, a, b, c
    r == regs_after
  end
  matching_ops.size >= 3
end

puts "Part 1: #{part1}"
