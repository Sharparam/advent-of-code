#!/usr/bin/env ruby

input = ARGF.readlines.map &:to_i
puts [2, 3].map { |s| input.combination(s).find { _1.sum == 2020 }.reduce :* }
