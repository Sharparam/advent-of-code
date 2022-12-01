#!/usr/bin/env ruby
# frozen_string_literal: true

inventories = ARGF.read.split("\n\n").map { |l| l.split.map(&:to_i).sum }

puts inventories.max
puts inventories.sort.reverse.take(3).sum
