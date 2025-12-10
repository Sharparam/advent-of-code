#!/usr/bin/env ruby
# frozen_string_literal: true

class Machine
  attr_reader :target, :buttons, :joltage_target

  def initialize(target, buttons, joltage_target)
    @target = target
    @buttons = buttons
    @joltage_target = joltage_target
  end
end

machines = ARGF.map do |line|
  parts = line.split
  target = parts[0][1...-1].reverse.tr('.#', '01').to_i(2)
  buttons = parts[1...-1].map { |part| part[1...-1].split(',').map(&:to_i) }
  joltage_target = parts[-1][1...-1].split(',').map(&:to_i)
  Machine.new target, buttons, joltage_target
end

part1 = machines.sum do |machine|
  q = [[0, 0]]
  best = Float::INFINITY
  buttons = machine.buttons.map { _1.reduce(0) { |a, e| a | (1 << e) } }

  until q.empty?
    lights, steps = q.shift

    next if steps >= best

    if lights == machine.target
      best = steps if steps < best
      next
    end

    buttons.each do |button|
      q.push [lights ^ button, steps + 1]
    end
  end

  best
end

puts part1

# The below will never finish for real input
exit # Abandon all hope

part2 = machines.sum do |machine|
  q = [[[0] * machine.joltage_target.size, 0]]
  best = Float::INFINITY
  target = machine.joltage_target
  buttons = machine.buttons

  until q.empty?
    joltage, steps = q.shift

    next if steps >= best
    next if joltage.each_with_index.any? { |j, i| j > target[i] }

    if joltage == target
      best = steps if steps < best
      next
    end

    buttons.each do |button|
      j = joltage.dup
      button.each { j[_1] += 1 }
      q.push [j, steps + 1]
    end
  end

  # puts "Solved! #{best}"

  best
end

puts part2
