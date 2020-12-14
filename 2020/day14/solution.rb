#!/usr/bin/env ruby

require 'pp'

MEMORY = Hash.new(0)
MEMORY2 = Hash.new(0)

INPUT = ARGF.readlines

def apply_mask(bits, mask)
  bits = [0] * (mask.size - bits.size) + bits
  bits.map.with_index do |bit, index|
    mask[index] == ?X ? bit :  mask[index].to_i
  end
end

def apply_mask2(bits, mask)
  bits = [0] * (mask.size - bits.size) + bits
  bits.map.with_index do |bit, index|
    mask[index] == ?X ? :X : (bit | mask[index].to_i)
  end
end

def gen(template)
  return [template] unless template.include? :X
  i = template.index :X
  gen(template.dup.tap { |d| d[i] = 0 }) + gen(template.dup.tap { |d| d[i] = 1 })
end

INPUT.each do |line|
  case line
  when /^mask = ([01X]+)$/
    $mask = $1.split('')
  when /^mem\[(\d+)\] = (\d+)$/
    index = $1.to_i
    value = $2.to_i
    bits, bits2 = [value, index].map { _1.to_s(2).split('').map(&:to_i) }
    masked = apply_mask bits, $mask
    masked2 = apply_mask2 bits2, $mask
    indices = gen(masked2)
    MEMORY[index] = masked.join.to_i(2)
    indices.each { |i| MEMORY2[i] = value }
  end
end

puts MEMORY.values.sum
puts MEMORY2.values.sum
