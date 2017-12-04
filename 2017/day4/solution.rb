#!/usr/bin/env ruby

input = STDIN.readlines.map { |l| l.strip.split }
p input.count { |e| e.uniq == e }
p input.map { |l| l.map { |w| w.chars.sort }}.count { |e| e.uniq == e }
