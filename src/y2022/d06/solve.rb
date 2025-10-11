#!/usr/bin/env ruby
# frozen_string_literal: true

input = ARGF.readline.chomp.chars

puts input.each_cons(4).with_index.find { _1[0].uniq.size == 4 }[1] + 4
puts input.each_cons(14).with_index.find { _1[0].uniq.size == 14 }[1] + 14
