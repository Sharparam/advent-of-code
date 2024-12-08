#!/usr/bin/env ruby
# frozen_string_literal: true

RULE_TEXTS, MESSAGES = ARGF.read.split("\n\n").map { _1.split ?\n }

rules = Hash[RULE_TEXTS.map do |rule|
  idx, content = rule.split ': '
  [idx.to_i, content.delete(?")]
end]

def build(rules, key)
  rule = rules[key].strip

  return ->(_) { rule } if rule =~ /^[^\d]$/

  ->(d) do
    result = ['(']

    rule.split.each do |item|
      if item == '|' # rubocop:disable Style/ConditionalAssignment
        result << '|'
      else
        result << d[item.to_i][d]
      end
    end

    result << ')'
    result.join
  end
end

BUILDERS = Hash[rules.map do |k, _|
  [k, build(rules, k)]
end]

part1_re = /^#{BUILDERS[0][BUILDERS]}$/

puts MESSAGES.count { part1_re === _1 }

BUILDERS[8] = ->(d) { "((#{d[42][d]})+)" }
BUILDERS[11] = ->(d) { "(?<r11>#{d[42][d]}\\g<r11>*#{d[31][d]})" }

part2_re = /^#{BUILDERS[0][BUILDERS]}$/
puts MESSAGES.count { part2_re === _1 }
