#!/usr/bin/env ruby
# frozen_string_literal: true

require 'matrix'

# 7 for example
# 200000000000000 for input
START = 200000000000000
# 27 for example
# 400000000000000 for input
STOP = 400000000000000

HAILSTONES = ARGF.readlines(chomp: true).map do |line|
  pos, vel = line.split('@').map { _1.split(',').map(&:to_i) }

  m = vel[1] / vel[0].to_f

  # y = mx + b
  # b = y - mx
  # b = pos[1] - m * pos[0]

  b = pos[1] - m * pos[0]

  # puts "y = #{m} * x + #{b}"

  {
    pos: pos,
    vel: vel,
    m: m,
    b: b
  }
end

def collide(a, b)
  ma, ba = a[:m], a[:b]
  mb, bb = b[:m], b[:b]

  return nil if ma == mb

  # y = ma * x + ba
  # y = mb * x + bb
  #
  # ma * x + ba = mb * x + bb
  # ma * x - mb * x = bb - ba
  # x(ma - mb) = bb - ba
  # x = (bb - ba) / (ma - mb)
  #
  # y = ma * ((bb - ba) / (ma - mb)) + ba

  x = (bb - ba) / (ma - mb)
  y = ma * x + ba

  [x, y]
end

count = 0

HAILSTONES.combination(2).each do |a, b|
  # as = "y = #{a[:m]} * x + #{a[:b]}"
  # bs = "y = #{b[:m]} * x + #{b[:b]}"
  c = collide(a, b)
  if c.nil?
    # puts "#{as} and #{bs} don't collide"
  else
    # puts "#{as} and #{bs} collide at (#{c[0]}, #{c[1]})"
    if c[0] >= START && c[0] <= STOP && c[1] >= START && c[1] <= STOP
      # puts "  collision is inside area"
      valid_ax = (c[0] > a[:pos][0] && a[:vel][0] > 0) || (c[0] < a[:pos][0] && a[:vel][0] < 0)
      valid_bx = (c[0] > b[:pos][0] && b[:vel][0] > 0) || (c[0] < b[:pos][0] && b[:vel][0] < 0)
      valid_ay = (c[1] > a[:pos][1] && a[:vel][1] > 0) || (c[1] < a[:pos][1] && a[:vel][1] < 0)
      valid_by = (c[1] > b[:pos][1] && b[:vel][1] > 0) || (c[1] < b[:pos][1] && b[:vel][1] < 0)
      if valid_ax && valid_bx && valid_ay && valid_ax
        # puts "    collision is in future, adding 1"
        count += 1
      end
    end
  end
end

puts count
