#!/usr/bin/env ruby
# frozen_string_literal: true

components = ARGF.readlines(chomp: true).map do |line|
  left, right = line.split ':'
  rights = right.split
  [left, rights]
end.to_h

lines = [
  "digraph {"
]

components.keys.each { lines.push("  #{_1};") }

components.each do |k, v|
  v.each do |n|
    lines.push("  #{k} -> #{n};")
  end
end

lines.push("}")
text = lines.join("\n")

File.write "graph.dot", text, mode: 'w'

# Plug the graph output into https://viz-js.com/
# Select the "sfdp" renderer
# Manually inspect which edges to remove
# For my input, it's:
# pzq -> rrz
# znv -> ddj
# mtq -> jtr

components['pzq'].delete 'rrz'
components['znv'].delete 'ddj'
components['mtq'].delete 'jtr'

graph = {}
components.each do |k, nodes|
  graph[k] ||= Set.new
  nodes.each do |node|
    graph[node] ||= Set.new
    graph[k].add node
    graph[node].add k
  end
end

def bfs(start, graph)
  visited = Set.new [start]
  queue = graph[start].to_a

  until queue.empty?
    current = queue.shift
    visited.add current
    queue.concat graph[current].reject { visited.include? _1 }
  end

  visited
end

a = bfs('pzq', graph).size
b = bfs('rrz', graph).size

puts a * b
