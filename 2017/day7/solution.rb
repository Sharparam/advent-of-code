#!/usr/bin/env ruby

require 'ostruct'

data = {}

$<.each_line do |l|
    data[$1] = OpenStruct.new name: $1, weight: $2.to_i, nodes: [], children: $3.nil? ? nil : $3.split(', ') if l =~ /([a-z]+) \((\d+)\)(?: -> ([a-z, ]+))?/
end

while data.any? { |name, node| node.children.nil? }
    data.find_all { |name, node| node.children.nil? }.map(&:first).each do |child_name|
        node = data.delete child_name
        node.total ||= node.weight
        parent = data.find { |name, node| !node.children.nil? && node.children.include?(child_name) }
        if parent.nil?
            data = node
            break
        end
        parent_node = parent.last
        parent_node.children.delete child_name
        parent_node.children = nil if parent_node.children.empty?
        parent_node.nodes.push node
        parent_node.total = parent_node.weight if parent_node.total.nil?
        parent_node.total += node.total || node.weight
    end
end

p data.name

def get_unbalanced(node)
    return node if node.nodes.nil? || node.nodes.empty?
    groups = node.nodes.group_by { |n| n.total }
    return node if groups.size == 1
    weight = (groups = groups.sort { |k, v| v.size }).first.first
    unbalanced = node.nodes.find { |n| n.total == weight }
    result = get_unbalanced unbalanced
    return result if result.is_a? Numeric
    if result == unbalanced
        others = groups.last.first
        diff = weight - others
        result = unbalanced.weight - diff
    end
    result
end

p get_unbalanced data
