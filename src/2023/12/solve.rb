#!/usr/bin/env ruby
# frozen_string_literal: true

def gen(chars, i = 0, result = [''])
  return result if i == chars.size

  c = chars[i]

  if c != ??
    return gen chars, i + 1, result.map { _1 + c }
  end

  new = result.flat_map { [_1 + ?., _1 + ?#] }
  gen chars, i + 1, new
end

puts ARGF.readlines(chomp: true).sum { |line|
  records, counts = line.split ' '
  counts = counts.split(',').map(&:to_i)
  m = counts.map { "\#{#{_1}}" }.join "\\.+"
  re = /^\.*#{m}\.*$/

  gen(records).count { re.match? _1 }
}
