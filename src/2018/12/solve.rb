#!/usr/bin/env ruby
# frozen_string_literal: true

initial, rules = ARGF.read.split("\n\n")

pots = initial.split(": ")[1].chars.map.with_index { |p, i| p == ?# ? i : nil }.compact

rules = rules.lines.map { |line|
  current, result = line.split(" => ").map(&:chomp)
  result = result == ?#
  state = current.chars.map.with_index { |c, i| [i - 2, c == ?#] }.to_h
  [state, result]
}.to_h

def transform(pots)
  new_pots = []
  min_i, max_i = pots.minmax
  min_i -= 2
  max_i += 2
  (min_i..max_i).each do |i|
    rule = rules.find { |s, r| s.all? { |d, c| pots.include?(i + d) == c } }
    new_pots.push(i) if (rule && rule[1]) || pots[i] == true
  end

  new_pots
end

final_pots = 20.times.reduce(pots) do |pots, i|
  transform(pots)
end

puts final_pots.sum

delta = nil
delta_count = 0

part2_pots = 50_000_000_000.times.reduce(pots) do |pots, i|
  old_sum = pots.sum
  new_pots = transform(pots)
  new_sum = new_pots.sum
  new_delta = new_sum - old_sum
  if new_delta == delta
    delta_count += 1
  else
    delta_count = 1
  end
  if delta_count == 3
    remaining = 50_000_000_000 - i - 1
    final_result = new_sum + remaining * delta
    puts final_result
    exit
  end

  delta = new_delta
  new_pots
end
