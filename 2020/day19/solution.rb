#!/usr/bin/env ruby

RULE_TEXTS, MESSAGES = ARGF.read.split("\n\n").map { _1.split ?\n }

RULES = Hash[RULE_TEXTS.map do |rule|
  idx, content = rule.split ': '
  [idx.to_i, content.delete(?")]
end]

def build(rules, key)
  rule = rules[key].strip

  return -> _ { rule } if rule =~ /^[^\d]$/

  -> d do
    result = ['(']

    rule.split.each do |item|
      if item == '|'
        result << '|'
      else
        result << d[item.to_i][d]
      end
    end

    result << ')'
    result.join
  end
end

BUILDERS = Hash[RULES.map do |k, _|
  [k, build(RULES, k)]
end]

part1_re = /^#{BUILDERS[0][BUILDERS]}$/

puts MESSAGES.count { part1_re === _1 }

BUILDERS[8] = -> d { "((#{d[42][d]})+)" }
BUILDERS[11] = -> d do
  a = d[42][d]
  b = d[31][d]
  "(?<r11>#{a}#{b}|#{a}\\g<r11>#{b})"
end

part2_re = /^#{BUILDERS[0][BUILDERS]}$/
puts MESSAGES.count { part2_re === _1 }
