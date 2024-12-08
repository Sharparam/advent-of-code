#!/usr/bin/env ruby
# frozen_string_literal: true

d = $<.readlines.map(&:split)
p d.count { |e| e.uniq == e }
p d.map { |l| l.map { |w| w.chars.sort } }.count { |e| e.uniq == e }
