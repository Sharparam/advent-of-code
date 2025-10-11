#!/usr/bin/env ruby
# frozen_string_literal: true

PRIOS = (?a..?z).to_a.concat((?A..?Z).to_a).map.with_index { |l, i| [l, i + 1] }.to_h

contents = ARGF.readlines.map { |l| l.chomp.chars.map { |c| PRIOS[c] } }

puts contents.map { |l| l.each_slice(l.size / 2).reduce(&:intersection)[0] }.sum
puts contents.each_slice(3).map { |g| g.reduce(&:intersection)[0] }.sum
