#!/usr/bin/env ruby

RULES = Hash[ARGF.readlines.map { |line|
  parts = line.split 'bags contain'
  type = parts.first.strip
  contains = Hash[parts.last.scan(/(\d+) (\w+ \w+) bags?/).map { [_2, _1.to_i].freeze }]
  [type.freeze, contains.freeze].freeze
}].freeze

OUR_BAG = 'shiny gold'.freeze

def count(type, rules, inside = nil)
  result = 0

  if inside.nil?
    rules.each do |k, v|
      next if k == OUR_BAG
      if v.key?(type)
        result += 1 if v[type] > 0
      else
        rest = rules.dup.tap { _1.delete k }
        result += count(type, rest, v.keys)
      end
    end
  else
    subrules = rules.select { inside.include? _1 }
    subrules.each do |k, v|
      if v.key?(type)
        return 1
      else
        rest = rules.dup.tap { _1.delete k }
        return 1 if count(type, rest, v.keys) > 0
      end
    end
  end

  result
end

def bags(type, rules, root = false)
  my_rules = rules[type]
  return 1 if my_rules.empty?
  (root ? 0 : 1) + my_rules.sum {
    bags(_1, rules) * _2
  }
end

puts count(OUR_BAG, RULES)
puts bags(OUR_BAG, RULES, true)
