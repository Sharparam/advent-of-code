#!/usr/bin/env ruby
# frozen_string_literal: true

input = $<.read.strip.gsub(/!./, '').gsub(/<[^>]*>/, '').gsub(/(?<=[^}]),/, '')

def score(data, index = 0, level = 0, accum = 0)
  return accum if index >= data.size
  return score(data, index + 1, level + 1, accum) if data[index] == '{'
  return score(data, index + 1, level - 1, accum + level) if data[index] == '}'
  score(data, index + 1, level, accum)
end

puts score input
