#!/usr/bin/env ruby
# frozen_string_literal: true

workflows, parts = ARGF.read.split("\n\n")

WORKFLOWS = Hash[workflows.scan(/(\w+)\{([^\}]+)\}/).map { |id, body|
  rules = body.split ','
  default = rules.pop
  rules.map! { |rule|
    cond, dest = rule.split ':'
    k, op, value = cond[0], cond[1].to_sym, cond[2..].to_i
    [k, op, value, dest]
  }
  f = -> (part) {
    matching = rules.find { |r| part[r[0]].send(r[1], r[2]) }
    return matching[3] unless matching.nil?
    default
  }
  [id, { rules: rules, default: default, f: f }]
}]

PARTS = parts.lines.map { |part|
  Hash[part.scan(/(\w+)=(\d+)/).map { |k, v| [k, v.to_i] }]
}

def valid?(part)
  id = 'in'
  until id == 'A' || id == 'R'
    id = WORKFLOWS[id][:f].call(part)
  end
  id == 'A'
end

puts PARTS.select { valid?(_1) }.sum { _1.values.sum }

IDX = { 'x' => 0, 'm' => 1, 'a' => 2, 's' => 3 }

def split_ranges(ranges, key, op, value)
  return [ranges, nil] if op.nil?
  idx = IDX[key]

  if op == :<
    return [nil, ranges] if ranges[idx].min >= value
    return [ranges, nil] if ranges[idx].max < value

    valid = ranges.map.with_index { |r, i|
      next r unless i == idx
      (r.min ... value)
    }
    invalid = ranges.map.with_index { |r, i|
      next r unless i == idx
      (value .. r.max)
    }

    return [valid, invalid]
  end

  return [nil, ranges] if ranges[idx].max <= value
  return [ranges, nil] if ranges[idx].min > value

  valid = ranges.map.with_index { |r, i|
    next r unless i == idx
    ((value + 1) .. r.max)
  }
  invalid = ranges.map.with_index { |r, i|
    next r unless i == idx
    (r.min .. value)
  }

  [valid, invalid]
end

valid = 0
map = { [(1..4000)] * 4 => 'in' }

until map.empty?
  new_map = {}
  map.each do |ranges, id|
    next valid += ranges.reduce(1) { |a, r| a * r.size } if id == 'A'
    next if id == 'R'
    workflow = WORKFLOWS[id]
    remaining = ranges
    rules = workflow[:rules]
    rules.push [nil, nil, nil, workflow[:default]]
    rules.each do |key, op, value, dest|
      pass, remaining = split_ranges remaining, key, op, value
      new_map[pass] = dest unless pass.nil?
      break if remaining.nil?
    end
  end
  map = new_map
end

puts valid
