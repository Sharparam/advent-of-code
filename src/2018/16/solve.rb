#!/usr/bin/env ruby
# frozen_string_literal: true

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

part2 = []

part1 = input_part1
.split("\n\n")
.map { |b| b.lines.map { |l| l.scan(/\d+/).map(&:to_i) } }.count do |(regs, code, regs_after)|
  op, a, b, c = code
  matching_ops = OPCODES.keys.select do |key|
    r = regs.dup
    OPCODES[key].call r, a, b, c
    r == regs_after
  end

  if part2[op]
    part2[op] &= matching_ops
  else
    part2[op] = matching_ops
  end

  matching_ops.size >= 3
end

puts "Part 1: #{part1}"

resolved = []
res_count = 0

part2.cycle.with_index do |ops, c|
  i = c % part2.size
  break if res_count == OPCODES.size

  if ops.size > 1
    part2[i] -= resolved
    next
  end

  next if resolved[i]

  resolved[i] = ops.first
  res_count += 1
end

input_part2.scan(/(\d+) (\d+) (\d+) (\d+)/).map { |l| l.map(&:to_i) }.each do |op, a, b, c|
  OPCODES[resolved[op]].call REGS, a, b, c
end

puts "Part 2: #{REGS[0]}"
