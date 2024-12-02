#!/usr/bin/env ruby
# frozen_string_literal: true

reports = ARGF.map { |line| line.split.map(&:to_i) }

def validate(report)
  slices = report.each_cons(2)
  diffs = slices.map { _2 - _1 }
  dirs = diffs.map { _1 == 0 ? 0 : _1 / _1.abs }

  same_dir = dirs.uniq.size == 1

  return false unless same_dir && dirs.uniq[0] != 0

  abs = diffs.map(&:abs)

  abs.all? { (1..3).cover? _1 }
end

def validate2(report)
  return true if validate(report)
  report.size.times do |index|
    r = report.dup
    r.delete_at index
    return true if validate r
  end
  false
end

def count(reports, part2 = false)
  reports.count { |report|
    if part2
      validate2 report
    else
      validate report
    end
  }
end

puts count(reports)
puts count(reports, true)
