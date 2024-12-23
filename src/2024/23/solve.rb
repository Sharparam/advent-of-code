#!/usr/bin/env ruby
# frozen_string_literal: true

graph = Hash.new { _1[_2] = Set.new }

ARGF.map { _1.chomp.split('-') }.each do |a, b|
  graph[a] << b
  graph[b] << a
end

part1 = Set.new

graph.keys.select { _1.start_with?('t') }.each do |start|
  adj = graph[start].to_a
  adj.combination(2) do |a, b|
    next unless graph[a].include?(start) && graph[b].include?(start) && graph[a].include?(b)
    part1 << [start, a, b].sort
  end
end

puts part1.size

groups = Set.new

graph.each_key do |start|
  group = [start].to_set
  adjs = graph[start].to_a
  until adjs.empty?
    adj = adjs.shift
    group << adj if adjs.all? { graph[_1].include?(adj) }
  end
  groups << group.sort
end

puts groups.max_by(&:size).join(',')
