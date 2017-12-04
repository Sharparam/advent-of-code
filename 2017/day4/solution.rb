#!/usr/bin/env ruby

d = $<.readlines.map(&:split)
p d.count { |e| e.uniq == e }
p d.map { |l| l.map { |w| w.chars.sort }}.count { |e| e.uniq == e }
