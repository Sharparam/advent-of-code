#!/usr/bin/env ruby

groups = ARGF.read.split("\n\n").map { _1.split.map(&:chars) }
puts %i[| &].map { |m| groups.sum { _1.reduce(m).size } }
