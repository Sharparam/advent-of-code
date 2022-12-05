#!/usr/bin/env ruby
# frozen_string_literal: true

require 'pry'

layout, moves = ARGF.read.split("\n\n").map { |b| b.lines.map(&:chomp) }

cranes = layout.pop.split.map { [] }
moves = moves.map { |m| m.scan(/\d+/).map(&:to_i).then { |(q, f, t)| [q, f - 1, t - 1] } }

layout.each do |l|
  cranes.each_with_index do |c, i|
    if l =~ /^.{#{i * 4}}\[([A-Z])\]/
      c.unshift $1
    end
  end
end

cranes_2 = cranes.map(&:dup)

moves.each do |(q, f, t)|
  cranes[t].push(*cranes[f].pop(q).reverse)
  cranes_2[t].push(*cranes_2[f].pop(q))
end

puts cranes.map(&:last).join
puts cranes_2.map(&:last).join
