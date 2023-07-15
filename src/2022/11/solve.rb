#!/usr/bin/env ruby
# frozen_string_literal: true

require 'pry'

RE = /^  [^\d]+([^\n]+).+?: ([^\n]+).+?(\d+).+?(\d+).+?(\d+)/im

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
    match = RE.match(str)
    items = match[1].split(',').map(&:to_i)
    divisor = match[3].to_i
    t, f = match[4].to_i, match[5].to_i
    Monkey.new(items, match[2], divisor, t, f)
  end

  def self.from_strings(strs)
    strs.split("\n\n").map { self.from_string _1 }
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
