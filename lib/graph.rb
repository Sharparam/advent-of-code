# Implementations from https://github.com/msayson/weighted_graph
# Licensed under the MIT License.
# Copyright (c) 2017 Mark Sayson

# Some parts modified with input from
# https://www.redblobgames.com/pathfinding/a-star/implementation.html

require 'set'

class WeightedGraph
  def initialize(edges = Hash.new(0))
    @edges = edges
  end

  def add_edge(source, destination, weight)
    if @edges.key? source
      @edges[source][destination] = weight
    else
      @edges[source] = { destination => weight }
    end
  end

  def add_undirected_edge(vertex_a, vertex_b, weight)
    add_edge(vertex_a, vertex_b, weight)
    add_edge(vertex_b, vertex_a, weight)
  end

  def remove_edge(source, destination)
    @edges[source].delete(destination) if @edges.key?(source)
  end

  def remove_undirected_edge(vertex_a, vertex_b)
    remove_edge(vertex_a, vertex_b)
    remove_edge(vertex_b, vertex_a)
  end

  def contains_edge?(source, destination)
    @edges.key?(source) && @edges[source].key?(destination)
  end

  def cost(source, destination)
    if contains_edge?(source, destination)
      @edges[source][destination]
    else
      Float::INFINITY
    end
  end

  def neighbors(source)
    adjacent = []
    if @edges.key?(source)
      adjacent = @edges[source].map { |dst, _weight| dst }
    end
    Set.new(adjacent)
  end
end
