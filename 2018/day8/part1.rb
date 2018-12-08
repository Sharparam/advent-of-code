#!/usr/bin/env ruby

def f d, s; a = d.shift 2; s + a[0].times.map { f d, s }.sum + d.shift(a[1]).sum end
puts f File.read('input.txt').split.map(&:to_i), 0
