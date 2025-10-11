#!/usr/bin/env ruby
# frozen_string_literal: true

state_str, funcs_str = ARGF.read.split("\n\n")

x = []
y = []

state = state_str.lines.to_h { |line|
  k, v = line.split(': ')
  l, i = k[0], k[1..].to_i
  a = l == 'x' ? x : y
  n = v.to_i
  a[i] = n
  [k, -> { a[i] }]
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

funcs_str.lines.grep_v(/^#/).each do |func_str|
  a, op, b, c = func_str.scan(/[A-Za-z0-9]+/)
  state[c] = mkf(state, a, b, op)
end

puts state.keys.select { _1.start_with? 'z' }.sort.map { state[_1][] }.reverse.join.to_i(2)

def zs(state)
  state.keys.select { _1.start_with? 'z' }.sort.map { state[_1][] }
end

def format_bits(bits)
  bits.each_slice(4).map { _1.reverse.join }.reverse.join ' '
end

def vis_add(state, x, y, pre = '')
  warn "#{pre}   #{format_bits(x)}"
  warn "#{pre}+  #{format_bits(y)}"
  warn "#{pre}= #{format_bits(zs(state))}"
end

x.each_with_index { |_, i| x[i] = 0 }
y.each_with_index { |_, i| y[i] = 0 }

def valid?(state, x, y, e_x, e_y, e_z, log: false)
  valid = true
  45.times do |i|
    x[i] = e_x
    y[i] = e_y
    z = zs(state)

    unless z[i] == e_z
      return false unless log
      valid = false
      warn "MISMATCH FOUND at #{i}:"
      warn "  Expected #{x[i]} + #{y[i]} to produce #{e_z} at #{i} but was #{z[i]}"
      vis_add(state, x, y, '    ')
    end

    x[i] = 0
    y[i] = 0
  end

  valid
end

valid? state, x, y, 1, 1, 0, log: true
valid? state, x, y, 1, 0, 1, log: true
