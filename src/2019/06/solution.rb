#!/usr/bin/env ruby

CENTER = :COM

class Node
  attr_reader :value
  attr_reader :children
  attr_accessor :parent

  def initialize(value, parent = nil)
    @value = value
    @children = []
    @parent = parent
  end

  def root?
    @value == :COM || @parent.nil?
  end

  def add_child!(node)
    @children << node
  end

  def to_s
    @value.to_s
  end
end

nodes = {}

pairs = File.readlines(ARGV.first || 'input.txt').map { |l| l.split(')').map { |o| o.strip.to_sym } }

pairs.each do |pair|
  center = pair.first
  orbiter = pair.last
  center = (nodes[center] ||= Node.new center)
  orbiter = (nodes[orbiter] ||= Node.new orbiter, center)
  center.add_child! orbiter
  orbiter.parent = center
end

root = nodes[:COM]
santa = nodes[:SAN]
me = nodes[:YOU]

def part1(node, accum = 0)
  accum + node.children.sum { |n| part1 n, accum + 1 }
end

puts "Part 1: #{part1 root}"

def com_path(node)
  return [] if node.root?
  [node.value].concat com_path node.parent
end

my_path = com_path me.parent
santa_path = com_path santa.parent

part2 = ((my_path - santa_path) | (santa_path - my_path)).size

puts "Part 2: #{part2}"
