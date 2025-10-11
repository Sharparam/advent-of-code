#!/usr/bin/env ruby
# frozen_string_literal: true

reports = ARGF.map { |line| line.split.map(&:to_i) }

def validate(report)
  diffs = report.each_cons(2).map { _2 - _1 }
  diffs.all? { (1..3) === _1 } || diffs.all? { (-3..-1) === _1 }
end

def validate2(report)
  report.combination(report.size - 1).any? { validate _1 }
end

puts reports.count { validate _1 }
puts reports.count { validate2 _1 }
