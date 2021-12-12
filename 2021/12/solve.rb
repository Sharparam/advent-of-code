#!/usr/bin/env ruby
# frozen_string_literal: true

require 'matrix'
require 'set'
require 'pp'

MAZE = {}
ARGF.readlines.map { _1.strip.split('-') }.each do |a, b|
  MAZE[a] ||= []
  MAZE[a] << b
  next if a == 'start' || b == 'end'
  MAZE[b] ||= []
  MAZE[b] << a
end

def search(current, visited, paths, path)
  visited << current if current =~ /^[a-z]+$/
  path << current
  if current == 'end'
    paths << path
    return
  end
  avail = MAZE[current].reject { visited.include? _1 }
  return if avail.empty?
  avail.each do |a|
    search(a, visited.dup, paths, path.dup)
  end
end

def search2(current, visited, paths, path, twice)
  is_lower = current =~ /^[a-z]+$/
  visited[current] += 1 if is_lower
  path << current
  if current == 'end'
    paths << path
    return
  end
  MAZE[current].each do |node|
    next if node == 'start'
    next search2(node, visited.dup, paths, path.dup, twice.dup) if node == 'end' || node =~ /^[A-Z]+$/
    next search2(node, visited.dup, paths, path.dup, twice.dup) if twice[node] == true && visited[node] < 2
    if twice.values.any?(true) || twice[node] == false
      search2(node, visited.dup, paths, path.dup, twice.dup) if visited[node] < 1
      next
    end
    first = twice.dup
    second = twice.dup
    first[node] = true
    second[node] = false
    search2(node, visited.dup, paths, path.dup, first)
    search2(node, visited.dup, paths, path.dup, second)
  end
end

paths = []
search('start', Set.new, paths, [])
puts paths.size

paths2 = []
search2('start', Hash.new(0), paths2, [], {})
puts paths2.uniq.size # TODO: Figure out why we get duplicate paths
