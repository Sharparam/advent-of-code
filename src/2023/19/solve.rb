#!/usr/bin/env ruby
# frozen_string_literal: true

workflows, parts = ARGF.read.split("\n\n")

WORKFLOWS = Hash[workflows.scan(/(\w+)\{([^\}]+)\}/).map { |id, body|
  conds = body.split ','
  default = conds.pop
  conds = conds.map { |cond|
    c, d = cond.split ':'
    k, o, v = c[0], c[1].to_sym, c[2..].to_i
    [k, o, v, d]
  }
  f = -> (part) {
    matching = conds.find { |c| part[c[0]].send(c[1], c[2]) }
    return matching[3] unless matching.nil?
    default
  }
  [id, f]
}]

PARTS = parts.lines.map { |part|
  Hash[part.scan(/(\w+)=(\d+)/).map { |k, v| [k, v.to_i] }]
}

def resolve(part)
  key = 'in'
  until key == 'A' || key == 'R'
    key = WORKFLOWS[key].call(part)
  end
  key == 'A'
end

accepted = PARTS.select { resolve(_1) }

puts accepted.map { _1.values.sum }.sum
