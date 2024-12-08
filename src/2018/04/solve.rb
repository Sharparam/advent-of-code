#!/usr/bin/env ruby
# frozen_string_literal: true

require 'date'

guards = Hash.new { |h, k| h[k] = Hash.new(0) }
id = 0
awake = true
lastminute = 0

entries = File.readlines('input.txt').map do |line|
  time, data = line.split '] '
  [DateTime.parse(time[1..-1]), data]
end.sort_by { |e| e.first }

entries.each do |array|
  minute = array.first.minute

  case array.last
  when /^Guard \#(\d+) begins shift$/
    if id != 0 && !awake && lastminute < 60
      (lastminute...60).each { |m| guards[id][m] += 1 }
    end

    id = $1.to_i
    lastminute = 0
    awake = true
  when /^falls asleep$/
    guards[id][minute] += 1
    awake = false
    lastminute = minute + 1
  when /^wakes up$/
    (lastminute...minute).each { |m| guards[id][m] += 1 } unless awake
    awake = true
    lastminute = minute + 1
  end
end

result_id = 0
result_minute = guards.sort { |a, b| b.last.values.sum <=> a.last.values.sum }.first.tap { |a|
  result_id = a.first
}.last.sort { |a, b| b.last <=> a.last }.first.first

puts "Part 1: #{result_id * result_minute}"

p2_guard = guards.sort { |a, b| b.last.values.max <=> a.last.values.max }.first
puts "Part 2: #{p2_guard.first * p2_guard.last.sort { |a, b| b.last <=> a.last }.first.first}"
