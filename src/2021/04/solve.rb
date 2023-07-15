#!/usr/bin/env ruby
# frozen_string_literal: true

require 'set'

numbers = ARGF.readline.split(',').map(&:to_i)
boards = ARGF.read.split("\n\n").map { |b| b.strip.split("\n").map { _1.split.map(&:to_i) } }

marked = Set.new
winners = []

numbers.each do |number|
  marked << number

  winner, boards = boards.partition do |board|
    (board + board.transpose).any? { |l| l.all? { marked.include? _1 } }
  end

  winner = winner.first

  next unless winner

  winners << [winner, number, marked.dup]

  break if boards.empty?
end

fb, fn, fm = winners.first
lb, ln, lm = winners.last

puts fb.flatten.select { |n| !fm.include? n }.sum * fn
puts lb.flatten.select { |n| !lm.include? n }.sum * ln
