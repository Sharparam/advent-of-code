#!/usr/bin/env ruby
# frozen_string_literal: true

require 'matrix'

reactor = {}

ARGF.each_line do |line|
  puts "Processing: #{line}"
  op, ranges = line.split
  next if ranges.nil? || ranges == ''
  op = op == 'on'
  xrange, yrange, zrange = ranges.scan(/-?\d+\.\.-?\d+/).map { eval(_1) }
  xrange.each do |x|
    next if x < -50 || x > 50
    yrange.each do |y|
      next if y < -50 || y > 50
      zrange.each do |z|
        next if z < -50 || z > 50
        pos = Vector[x, y, z]
        reactor[pos] = op
      end
    end
  end
end

puts reactor.values.count(true)
