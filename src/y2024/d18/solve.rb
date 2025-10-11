#!/usr/bin/env ruby
# frozen_string_literal: true

require 'bundler/setup'
require 'matrix'
require 'pairing_heap'

WIDTH = 71
HEIGHT = 71

BYTES = ARGF.read.scan(/\d+/).map(&:to_i).each_slice(2).map { Vector[*_1] }

DIRS = [
  Vector[1, 0], # Right
  Vector[0, 1], # Down
  Vector[-1, 0], # Left
  Vector[0, -1] # Up
].freeze

def neighbors(pos)
  DIRS.map { pos + _1 }.reject { _1[0] < 0 || _1[0] >= WIDTH || _1[1] < 0 || _1[1] >= HEIGHT }
end

START = Vector[0, 0]
GOAL = Vector[WIDTH - 1, HEIGHT - 1]

def dijkstra(bytes)
  dist = Hash.new Float::INFINITY
  dist[START] = 0
  heap = PairingHeap::MinPriorityQueue.new
  heap.push START, 0

  until heap.empty?
    u = heap.extract_min
    neighbors(u).each do |v|
      next if bytes.include? v
      alt = dist[u] + 1
      next unless alt < dist[v]
      dist[v] = alt
      heap.push v, alt
    end
  end

  dist
end

puts dijkstra(BYTES[..1024].to_set)[GOAL]

puts BYTES[(1025...BYTES.size).bsearch { |i|
  dijkstra(BYTES[..i].to_set)[GOAL] == Float::INFINITY
}].to_a.join ','
