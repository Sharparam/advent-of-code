#!/usr/bin/env ruby
# frozen_string_literal: true

PATH = ARGV.first || 'input'
FUEL = ARGV[1]&.to_i || 1

Recipe = Struct.new :requires, :produces

class Node
  attr_reader :label, :parents, :children

  def initialize(label)
    @label = label
    @parents = Set.new
    @children = Set.new
    @required = label == :FUEL ? FUEL : nil
    @recipes = {}
  end

  def add_parent!(parent)
    @parents.add parent
  end

  def add_parents!(parents)
    @parents.merge parents
  end

  def add_child!(child)
    @children.add child
  end

  def add_children!(children)
    @children.merge children
  end

  def add_recipe!(label, requires, produces)
    @recipes[label] = Recipe.new requires, produces
  end

  def required
    return @required if @required

    @required = 0
    @children.each do |child|
      required = child.required
      recipe = @recipes[child.label]
      batches = (required.to_f / recipe.produces).ceil
      @required += batches * recipe.requires
    end

    @required
  end

  def eql?(other)
    @label == other.label
  end

  def hash
    @label.hash
  end
end

lines = File.readlines(PATH)

nodes = {}

lines.each do |line|
  parsed = line.scan(/(\d+)\s+(\w+)/).map do |(a, b)|
    label = b.to_sym
    node = nodes[label] ||= Node.new label
    [a.to_i, node]
  end

  current = parsed.pop
  produces = current.first
  child = current.last

  parsed.each do |parsed|
    requires = parsed.first
    parent = parsed.last
    child.add_parent! parent
    parent.add_child! child
    parent.add_recipe! child.label, requires, produces
  end
end

root = nodes[:ORE]

puts "Part 1: #{root.required}"

# require 'pry'
# binding.pry
