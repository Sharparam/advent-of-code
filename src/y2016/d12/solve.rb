#!/usr/bin/env ruby
# frozen_string_literal: true

class CPU
  def initialize(instructions)
    @regs = {
      a: 0,
      b: 0,
      c: 0,
      d: 0
    }

    @instructions = instructions
    @pc = 0
  end

  def self.number?(arg)
    arg =~ /^\d+$/
  end

  def step!
    return false if @pc == @instructions.size
    instruction = @instructions[@pc]
    # puts '%2d %10s [%s]' % [@pc, instruction.join(' '), dump_regs.join(' ')]
    send(*instruction)
    @pc += 1
    true
  end

  def [](reg)
    @regs[reg]
  end

  def []=(reg, value)
    @regs[reg] = value.to_i
  end

  def cpy(source, destination)
    if self.class.number? source # rubocop:disable Style/ConditionalAssignment
      self[destination.to_sym] = source
    else
      self[destination.to_sym] = self[source.to_sym]
    end
  end

  def inc(register)
    self[register.to_sym] += 1
  end

  def dec(register)
    self[register.to_sym] -= 1
  end

  def jnz(register, target)
    value = self.class.number?(register) ? register : self[register.to_sym]
    return if value == 0
    @pc += target.to_i - 1
  end

  private

  def dump_regs
    @regs.map { |_r, v| '%3d' % [v] }
  end
end

instructions = $stdin.readlines.map { |line| line.strip.split }

cpu = CPU.new instructions

while cpu.step!; end

puts "(1): #{cpu[:a]}"

cpu = CPU.new instructions.unshift %w[cpy 1 c]

while cpu.step!; end

puts "(2): #{cpu[:a]}"
