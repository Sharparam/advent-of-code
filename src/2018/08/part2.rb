#!/usr/bin/env ruby
# frozen_string_literal: true

class Node
  attr_accessor :children, :metadata

  def initialize
    @children = []
    @metadata = []
  end

  def leaf?; @children.empty?; end

  def value
    leaf? ? @metadata.sum : @metadata.map { |i| @children[i - 1]&.value }.compact.sum
  end
end

data = File.read('input.txt').split.map(&:to_i)

def build(d)
  a = d.shift 2
  node = Node.new
  node.children.concat a[0].times.map { build d }
  node.tap { |n| n.metadata.concat d.shift a[1] }
end

puts "Part 2: #{build(data).value}"
