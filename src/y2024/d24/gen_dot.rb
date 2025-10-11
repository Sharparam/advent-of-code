#!/usr/bin/env ruby
# frozen_string_literal: true

graph_lines = [
  'digraph G {'
]

nodes = Set.new
edges = []

ARGF.each do |line|
  case line
  # when /^(\w+): (\d+)$/
  #   next
  when /^(\w+) (\w+) (\w+) -> (\w+)$/
    left = $1
    right = $3
    op = $2
    op_id = "#{$1}_#{$2}_#{$3}"
    out = $4
    nodes << "#{left} [label=\"#{left}\",shape=diamond]"
    nodes << "#{right} [label=\"#{right}\",shape=diamond]"
    nodes << "#{out} [label=\"#{out}\",shape=diamond]"
    nodes << "#{op_id} [label=\"#{op}\",shape=box]"
    edges << "#{left} -> #{op_id}"
    edges << "#{right} -> #{op_id}"
    edges << "#{op_id} -> #{out}"
  end
end

nodes.each { graph_lines << _1 }
edges.each { graph_lines << _1 }

graph_lines << "}\n"

File.write('graph.dot', graph_lines.join("\n"))
