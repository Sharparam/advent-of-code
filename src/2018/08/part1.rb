#!/usr/bin/env ruby
# frozen_string_literal: true

def f d, s; (c, m) = d.shift 2; s + c.times.map { f d, s }.sum + d.shift(m).sum end
puts f File.read('input.txt').split.map(&:to_i), 0
