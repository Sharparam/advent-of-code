#!/usr/bin/env ruby
# frozen_string_literal: true

class Machine
  attr_reader :target, :buttons, :lights

  def initialize(target, buttons, lights = 0)
    @target = target
    @buttons = buttons
    @lights = lights
  end

  def push(button)
    Machine.new(target, buttons, lights ^ button)
  end

  def push!(button)
    @lights ^= button
  end
end

machines = ARGF.map do |line|
  parts = line.split
  target = parts[0][1...-1].reverse.tr('.#', '01').to_i(2)
  buttons = parts[1...-1].map { |part| part[1...-1].split(',').map(&:to_i).reduce(0) { |a, e| a | (1 << e) } }
  Machine.new target, buttons
end

part1 = machines.sum do |machine|
  q = [[0, 0]] # machine.buttons.map { [_1, 1] }
  best = Float::INFINITY

  until q.empty?
    lights, steps = q.shift

    next if steps > best

    if lights == machine.target
      best = steps if steps < best
      next
    end

    machine.buttons.each do |button|
      q.push [lights ^ button, steps + 1]
    end
  end

  best
end

puts part1
