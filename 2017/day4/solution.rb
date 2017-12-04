#!/usr/bin/env ruby

input = STDIN.readlines.map { |l| l.strip.split }
puts input.reject { |e| e.uniq.size != e.size }.size
puts input.map { |l| l.map { |w| w.chars.sort }}.reject { |e| e.uniq.size != e.size }.size
