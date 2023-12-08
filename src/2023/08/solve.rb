#!/usr/bin/env ruby
# frozen_string_literal: true

require 'set'

steps = []
nodes = {}

ARGF.readlines(chomp: true).each do |line|
  case line
  when /^[LR]+$/
    steps = line.chars.map { _1 == ?L ? 0 : 1 }
  when /^(\w{3}) = \((\w{3}), (\w{3})\)$/
    nodes[$1.to_sym] = [$2.to_sym, $3.to_sym]
  end
end

count = 0
current = :AAA

steps.cycle.each do |s|
  break if current == :ZZZ
  count += 1
  current = nodes[current][s]
end

puts count

starts = nodes.keys.select { _1.to_s[-1] == ?A }.to_set
goals = nodes.keys.select { _1.to_s[-1] == ?Z }.to_set

cycles = starts.map { [_1, {}] }.to_h

starts.each do |start|
  current = start
  count = 0
  steps.cycle.each do |s|
    if goals.include? current
      if cycles[start][:first]
        cycles[start][:length] = count - cycles[start][:first]
        break
      else
        cycles[start][:first] = count
      end
    end
    count += 1
    current = nodes[current][s]
  end
end

puts cycles.values.map { _1[:length] }.reduce(&:lcm)
