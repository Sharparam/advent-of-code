#!/usr/bin/env ruby
# frozen_string_literal: true

inventories = ARGF.read.split("\n\n").map { |l| l.split.map(&:to_i).sum }.sort

puts inventories.last
puts inventories.last(3).sum
