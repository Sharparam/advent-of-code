#!/usr/bin/env ruby
# frozen_string_literal: true

files = Hash.new(0)

cwd = []

ARGF.readlines.map(&:chomp).each do |line|
  case line
  when /^\$ cd \/$/
    cwd.clear
  when /^\$ cd \.\.$/
    cwd.pop
  when /^\$ cd (.+)/
    cwd.push $1
  when /^(\d+) (.+)$/
    files["/#{cwd.join ?/}#{cwd.empty? ? '' : '/'}#{$2}"] = $1.to_i
  end
end

directories = Hash.new(0)

def record_size(h, path, size)
  dir = File.dirname(path)
  h[dir] += size

  return if dir == '/'

  record_size h, dir, size
end

files.each { |n, s| record_size directories, n, s }

puts directories.map { _2 }.select { _1 <= 100000 }.sum

min = directories[?/] - 40000000
puts directories.map { _2 }.sort.find { _1 >= min }
