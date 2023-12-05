#!/usr/bin/env ruby
# frozen_string_literal: true

class Map
  attr_reader :source, :dest

  def initialize(source, dest)
    @source = source
    @dest = dest
    @overrides = []
    @rev_overrides = []
  end

  def add(dest_start, source_start, length)
    checker = -> (s_id) { s_id >= source_start && s_id <= source_start + length - 1 }
    converter = -> (s_id) {
      offset = s_id - source_start
      dest_start + offset
    }
    @overrides << [checker, converter]

    rev_checker = -> (d_id) { d_id >= dest_start && d_id <= dest_start + length - 1 }
    rev_converter = -> (d_id) {
      offset = d_id - dest_start
      source_start + offset
    }
    @rev_overrides << [rev_checker, rev_converter]
  end

  def resolve(id)
    @overrides.each do |checker, converter|
      return converter.(id) if checker.(id)
    end

    id
  end

  def rev_resolve(id)
    @rev_overrides.each do |checker, converter|
      return converter.(id) if checker.(id)
    end

    id
  end

  def to_s
    "map from #{@source} to #{@dest}"
  end
end

seeds = []
maps = {}
rev_maps = {}

ARGF.read.lines(chomp: true).each do |line|
  case line
  when /^seeds:/
    seeds = line.scan(/\d+/).map(&:to_i)
  when /^(\w+)-to-(\w+) map/
    $source = $1.to_sym
    $dest = $2.to_sym
    maps[$source] = Map.new $source, $dest
    rev_maps[$dest] = maps[$source]
  when /^(\d+) (\d+) (\d+)/
    maps[$source].add $1.to_i, $2.to_i, $3.to_i
  end
end

lowest = []

seeds.each do |seed|
  source = :seed
  until source == :location
    mapper = maps[source]
    seed = mapper.resolve(seed)
    source = mapper.dest
  end

  lowest << seed
end

puts lowest.min

ranges = seeds.each_slice(2).map { (_1..(_1 + _2 - 1)) }

(0..).each do |final|
  current = rev_maps[:location]
  value = final
  while current.source != :seed
    new_val = current.rev_resolve(value)
    value = new_val
    current = rev_maps[current.source]
  end
  value = maps[:seed].rev_resolve(value)
  if ranges.any? { |r| r.include?(value) }
    puts final
    exit
  end
end
