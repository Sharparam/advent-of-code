#!/usr/bin/env ruby
# frozen_string_literal: true

class Map
  def initialize
    @entries = []
  end

  def add(dest, source, length)
    source_range = (source...source + length)
    dest_range = (dest...dest + length)
    offset = dest - source
    @entries << { dst: dest_range, src: source_range, offset: offset }
  end

  def sort!
    @entries.sort_by! { _1[:src].min }
  end

  def map(id)
    @entries.each do |entry|
      return id + entry[:offset] if entry[:src].include? id
    end

    id
  end

  def map_range(source)
    result = []

    min, max = source.minmax

    @entries.each do |entry|
      src, offset = entry[:src], entry[:offset]
      break if src.min > max
      next if min > src.max || max < src.min

      result << (min..src.min - 1) if min < src.min
      result << ([min, src.min].max + offset..[max, src.max].min + offset)
      min = [min, src.max + 1].max
    end

    result << (min..max) if min <= max

    result
  end
end

seeds = []
maps = []

ARGF.read.lines(chomp: true).each do |line|
  case line
  when /^seeds:/
    seeds = line.scan(/\d+/).map(&:to_i)
  when /map:$/
    maps << Map.new
  when /^(\d+) (\d+) (\d+)/
    maps[-1].add $1.to_i, $2.to_i, $3.to_i
  end
end

maps.each { _1.sort! }

puts seeds.map { |s| maps.reduce(s) { _2.map _1 } }.min

ranges = seeds.each_slice(2).map { (_1...(_1 + _2)) }
puts maps.reduce(ranges) { |a, e| a.flat_map { e.map_range _1 } }.sort_by(&:min)[0].min
