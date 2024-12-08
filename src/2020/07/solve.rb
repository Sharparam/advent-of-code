#!/usr/bin/env ruby
# frozen_string_literal: true

RULES = Hash[ARGF.readlines.map { |line|
  parts = line.split 'bags contain'
  type = parts.first.strip
  contains = Hash[parts.last.scan(/(\d+) (\w+ \w+) bags?/).map { [_2, _1.to_i].freeze }]
  [type.freeze, contains.freeze].freeze
}].freeze

OUR_BAG = 'shiny gold'

def count(inside = nil)
  result = 0

  (inside || RULES.keys).each do |key|
    next if key == OUR_BAG
    rule = RULES[key]
    if (rule[OUR_BAG] || 0) > 0
      return 1 if inside
      result += 1
    elsif count(rule.keys) > 0
      return 1 if inside
      result += 1
    end
  end

  result
end

def bags(type, root: false)
  my_rules = RULES[type]
  return 1 if my_rules.empty?
  (root ? 0 : 1) + my_rules.sum { bags(_1) * _2 }
end

puts count
puts bags(OUR_BAG, true)
