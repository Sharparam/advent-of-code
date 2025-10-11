#!/usr/bin/env ruby
# frozen_string_literal: true

class CPU
  attr_reader :recovered_frequency, :send_count

  def initialize(send_queue = nil, recv_queue = nil)
    @send_queue = send_queue
    @recv_queue = recv_queue
    @registers = Hash.new 0
    @pc = 0
    @send_count = 0
  end

  def load(program)
    @program = program.map(&:split)
    self
  end

  def run_part1
    step while @pc >= 0 && @pc < @program.size && !recovered_frequency
    self
  end

  def run_part2
    @wait = false
    step while @pc >= 0 && @pc < @program.size && !@wait
  end

  def step
    instruction = @program[@pc]
    send(*instruction)
    @pc += 1
  end

  def snd(freq)
    freq = resolve(freq)
    @last_frequency = freq
    return unless @send_queue
    @send_queue.enq freq
    @send_count += 1
  end

  def set(reg, value)
    @registers[reg] = resolve(value)
  end

  def add(reg, value)
    @registers[reg] += resolve(value)
  end

  def mul(reg, value)
    @registers[reg] *= resolve(value)
  end

  def mod(reg, value)
    @registers[reg] %= resolve(value)
  end

  def rcv(value)
    @recovered_frequency = @last_frequency unless resolve(value) == 0
    return if @recv_queue.nil?
    if @recv_queue.empty?
      @pc -= 1
      @wait = true
      return
    end
    @registers[value] = @recv_queue.deq
  end

  def jgz(value, offset)
    return if resolve(value) <= 0
    @pc += resolve(offset) - 1
  end

  private

  def resolve(value)
    n = value.to_i
    n.to_s == value ? n : @registers[value]
  end
end

PROGRAM = ARGF.readlines

puts CPU.new.load(PROGRAM).run_part1.recovered_frequency

a_to_b = Queue.new
b_to_a = Queue.new

a = CPU.new(a_to_b, b_to_a).load(PROGRAM)
a.set 'p', '0'

b = CPU.new(b_to_a, a_to_b).load(PROGRAM)
b.set 'p', '1'

a.run_part2
b.run_part2

while !a_to_b.empty? || !b_to_a.empty?
  a.run_part2
  b.run_part2
end

puts b.send_count
