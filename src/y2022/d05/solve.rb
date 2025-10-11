#!/usr/bin/env ruby
# frozen_string_literal: true

layout, moves = ARGF.read.split("\n\n").map { |b| b.lines.map(&:chomp) }

moves = moves.map { |m| m.scan(/\d+/).map(&:to_i).then { |(q, f, t)| [q, f - 1, t - 1] } }
cranes = layout.map(&:chars).transpose.map(&:reverse).select { _1[0] =~ /\d/ }.map { |l| l[1..].reject { _1 == ' ' } }
cranes2 = cranes.map(&:dup)

moves.each do |(q, f, t)|
  cranes[t].push(*cranes[f].pop(q).reverse)
  cranes2[t].push(*cranes2[f].pop(q))
end

puts cranes.map(&:last).join
puts cranes2.map(&:last).join
