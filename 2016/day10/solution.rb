#!/usr/bin/env ruby
# encoding: utf-8
# frozen_string_literal: true

require 'ostruct'

require_relative 'bot'

VALUE_PATTERN = /^value (\d+) goes to bot (\d+)$/
BOT_PATTERN = /^bot (\d+) gives low to ([a-z]+) (\d+) and high to ([a-z]+) (\d+)$/

SEARCH = [17, 61]

input = STDIN.readlines.map(&:strip)

bots = Hash.new { |h, k| h[k] = Bot.new }

outputs = {}

def can_process?(bots)
  bots.values.any? { |b| b.count == 2 }
end

def solved?(bots)
  bots.values.any? { |b| b.responsible? *SEARCH }
end

def process(bots, outputs)
  bots.select { |k, b| b.count == 2 }.each do |id, bot|
    low = bot.low
    high = bot.high

    #puts 'bot %3d gives  low %3d to %6s %3d' % [id, low, bot.low_target.type, bot.low_target.id]
    if bot.low_target.type == :bot
      bots[bot.low_target.id].add low
    else
      outputs[bot.low_target.id] = low
    end

    #puts 'bot %3d gives high %3d to %6s %3d' % [id, high, bot.high_target.type, bot.high_target.id]
    if bot.high_target.type == :bot
      bots[bot.high_target.id].add high
    else
      outputs[bot.high_target.id] = high
    end
  end
end

input.select { |line| line.start_with? 'value' }.each do |line|
  value, target = line.match(VALUE_PATTERN).to_a[1..2].map(&:to_i)
  bots[target].add value
end

input.select { |line| line.start_with? 'bot' }.each do |line|
  source, low_type, low_target, high_type, high_target = line.match(BOT_PATTERN).to_a[1..-1]
  source = source.to_i

  low_target = OpenStruct.new type: low_type.to_sym, id: low_target.to_i
  high_target = OpenStruct.new type: high_type.to_sym, id: high_target.to_i

  bots[source].low_target = low_target
  bots[source].high_target = high_target
end

while can_process?(bots)
  process bots, outputs
end

puts "(1) #{bots.find { |k, b| b.responsible? *SEARCH }.first}"
puts "(2) #{outputs[0] * outputs[1] * outputs[2] }"
