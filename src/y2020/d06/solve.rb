#!/usr/bin/env ruby
# frozen_string_literal: true

groups = ARGF.read.split("\n\n").map { _1.split.map(&:chars) }
puts %i[| &].map { |m| groups.sum { _1.reduce(m).size } }
