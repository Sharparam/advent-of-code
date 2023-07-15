#!/usr/bin/env ruby
# frozen_string_literal: true

eval(ARGF.read.gsub(/(?<=\d)\b/, '.0').gsub(/(\w+): (.+)\n?/) do
  if $1 == 'root'
    "def #{$1}; #{$2}; end; def #{$1}2; #{$2.scan(/\w+/).join(' - ')}; end;"
  else
    "def #{$1}; #{$2}; end;"
  end
end)

puts root().to_i

part2 = (0..100_000_000_000_000).bsearch { |n| eval("def humn; #{n}; end"); root2() <=> 0 }
part2 = (0..100_000_000_000_000).bsearch { |n| eval("def humn; #{n}; end"); 0 <=> root2() } unless part2

puts part2
