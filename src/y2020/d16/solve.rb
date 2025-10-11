#!/usr/bin/env ruby
# frozen_string_literal: true

SECTIONS = ARGF.read.split "\n\n"

rules = SECTIONS[0].lines.map do |l|
  name, ranges = l.split ?:
  ranges = ranges.split(' or ').map { s, e = _1.split(?-).map(&:to_i); (s..e) }
  [name, ranges]
end

TICKETS = SECTIONS[2].lines.drop(1).map { _1.split(?,).map(&:to_i) }

INVALID_VALUES = TICKETS.flatten.select do |v|
  rules.all? { |_, r| r.none? { _1.include? v } }
end

puts INVALID_VALUES.sum

VALID_TICKETS = TICKETS.select do |t|
  t.all? { |v| rules.any? { |_, r| r.any? { _1.include? v } } }
end

indices_valid_for = {}

(0..rules.size - 1).each do |index|
  indices_valid_for[index] = rules.select do |_, ranges|
    VALID_TICKETS.all? do |ticket|
      ranges.any? { _1.include? ticket[index] }
    end
  end.map { _1[0] }
end

while indices_valid_for.any? { _2.size > 1 }
  singles = indices_valid_for.select { _2.size == 1 }.map { |_, f| f[0] }
  indices_valid_for.select { _2.size > 1 }.each_value do |v|
    v.reject! { singles.include? _1 }
  end
end

MY_TICKET = SECTIONS[1].lines[1].split(?,).map.with_index do |value, index|
  [indices_valid_for[index][0], value.to_i]
end

puts MY_TICKET.select { _1[0].start_with? 'departure' }.map { _2 }.reduce(:*)
