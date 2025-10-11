import add_node, add_edge, shortest_path from require 'graph'

for line in io.lines 'input.txt'
    source, dest, cost = line\match '(%w+) to (%w+) = (%d+)'
    add_node source
    add_node dest
    add_edge source, dest, cost
    add_edge dest, source, cost

print shortest_path!
