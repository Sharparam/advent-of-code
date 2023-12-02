#!/usr/bin/env ruby
# frozen_string_literal: true

input = ARGF.read.lines

games = input.map.with_index do |line, i|
  sets = line.split(':')[1].split(';').map do |set|
    Hash[set.split(',').map do |c|
      c.split.then { |(n, c)| [c[0].to_sym, n.to_i] }
    end].tap { _1.default = 0 }
  end
  { id: i + 1, sets: sets, mins: Hash.new(0) }
end

count = games.sum do |game|
  valid = true
  game[:sets].each do |set|
    set.each do |c, n|
      valid = false if (c == :r && n > 12) || (c == :g && n > 13) || (c == :b && n > 14)
      game[:mins][c] = n if n > game[:mins][c]
    end
  end
  game[:power] = game[:mins].values.reduce(:*)
  valid ? game[:id] : 0
end

puts count
puts games.sum { _1[:power] }
