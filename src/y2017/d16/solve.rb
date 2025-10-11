#!/usr/bin/env ruby
# frozen_string_literal: true

PROGRAMS = (:a..:p).to_a

def s(n) = PROGRAMS.unshift(*PROGRAMS.pop(n))

def x(a, b)
  PROGRAMS[a], PROGRAMS[b] = PROGRAMS[b], PROGRAMS[a]
end

def p(a, b) = x(PROGRAMS.index(a), PROGRAMS.index(b))

code = ARGF.read.gsub(/([sxp])([^,]+)/) { "#{$1} #{$2.gsub(/[a-p]/, ':\0')}" }.split(',').join("\n").gsub('/', ', ')

eval code

seen = []
seen.push PROGRAMS.join

puts seen.first

# subtract one for the initial dance
ITERATIONS = 1_000_000_000 - 1
size = -1

ITERATIONS.times do |n|
  eval code
  joined = PROGRAMS.join
  if seen.include? joined
    size = n + 1
    break
  end
  seen.push joined
end

# The first dance is index 0, so the billionth dance is at index 999 999 999
puts seen[ITERATIONS % size]
