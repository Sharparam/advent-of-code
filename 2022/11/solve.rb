#!/usr/bin/env ruby
# frozen_string_literal: true

require 'pry'

MONKEY_RE = %r{
  \s*Monkey\ (?<i>\d+):\n
  \s+Starting\ items:\ (?<items>[^\n]+)\n
  \s+Operation:\ (?<op>[^\n]+)\n
  \s+Test:\ divisible\ by\ (?<divisor>\d+)\n
  \s+If\ true:\ throw\ to\ monkey\ (?<t>\d+)\n
  \s+If\ false:\ throw\ to\ monkey\ (?<f>\d+)
}imx

class Monkey
  attr_reader :true_target, :false_target, :inspect_count
  attr_reader :divisor

  def initialize(items, op, divisor, true_target, false_target)
    @items = items
    @divisor = divisor
    @true_target = true_target
    @false_target = false_target
    @inspect_count = 0

    instance_eval <<~OP
      def op(old)
        #{op.sub('new = ', '')}
      end
    OP
  end

  def self.from_string(str)
    match = MONKEY_RE.match(str)
    index = match['i'].to_i
    items = match['items'].split(',').map(&:to_i)
    divisor = match['divisor'].to_i
    t, f = match['t'].to_i, match['f'].to_i
    [index, Monkey.new(items, match['op'], divisor, t, f)]
  end

  def self.from_strings(strs)
    monkeys = []
    strs.split("\n\n").each do |str|
      i, m = self.from_string(str)
      monkeys[i] = m
    end
    monkeys
  end

  def test(worry)
    worry % @divisor == 0
  end

  def process!(divide, cum)
    result = []
    @items.size.times do
      result.push process_item!(divide, cum)
    end
    result
  end

  def process_item!(divide, cum)
    item = @items.shift
    @inspect_count += 1
    item = op item
    if divide
      item /= 3
    else
      item %= cum
    end
    result = test item
    new_i = result ? @true_target : @false_target
    [item, new_i]
  end

  def add!(item)
    @items.push item
  end

  def to_s
    @items.join ', '
  end
end

input = ARGF.read
monkeys = Monkey.from_strings(input)
monkeys2 = Monkey.from_strings(input)
cum = monkeys2.map(&:divisor).reduce(:*)
indices = (0...monkeys.size).to_a

10_000.times do |n|
  indices.each do |i|
    monkeys[i].process!(true, nil).each { monkeys[_2].add!(_1) } if n < 20
    monkeys2[i].process!(false, cum).each { monkeys2[_2].add!(_1) }
  end
end

puts monkeys.map(&:inspect_count).sort.reverse.take(2).reduce(:*)
puts monkeys2.map(&:inspect_count).sort.reverse.take(2).reduce(:*)
