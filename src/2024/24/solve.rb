#!/usr/bin/env ruby
# frozen_string_literal: true

state_str, funcs_str = ARGF.read.split("\n\n")

state = state_str.lines.to_h { |line|
  k, v = line.split(': ')
  # [k, v.to_i]
  n = v.to_i
  [k, -> { n }]
}

def mkf(s, a, b, op)
  case op
  when 'AND'
    -> { s[a][] & s[b][] }
  when 'OR'
    -> { s[a][] | s[b][] }
  when 'XOR'
    -> { s[a][] ^ s[b][] }
  else
    raise "unknown op #{op}"
  end
end

funcs_str.lines.each do |func_str|
  a, op, b, c = func_str.scan(/[A-Za-z0-9]+/)
  state[c] = mkf(state, a, b, op)
end

puts state.keys.select { _1.start_with? 'z' }.sort.map { state[_1][] }.reverse.join.to_i(2)

x = state.keys.select { _1.start_with? 'x' }.sort.map { state[_1][] }.reverse.join.to_i(2)
y = state.keys.select { _1.start_with? 'y' }.sort.map { state[_1][] }.reverse.join.to_i(2)
z = x + y
z_digits = z.to_s(2).chars.map(&:to_i).reverse

def valid(state, digits)
  digits.each_with_index do |digit, i|
    k = "z#{i.to_s.rjust(2, '0')}"
    # next if state[k][] == digit
    # raise "mismatch at #{k}: expected #{digit} but was #{state[k][]}"
    return false unless state[k][] == digit
  end

  true
end

dyn_keys = state.keys.reject { _1.start_with?('x') || _1.start_with?('y') }

groups = dyn_keys.permutation(8)

puts "#{groups.size} groups"
