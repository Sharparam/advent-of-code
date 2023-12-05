#!/usr/bin/env ruby
# frozen_string_literal: true

class Map
  attr_reader :source, :dest

  def initialize(source, dest)
    @source = source
    @dest = dest
    @overrides = []
  end

  def add(dest_start, source_start, length)
    checker = -> (s_id) { s_id >= source_start && s_id <= source_start + length - 1 }
    converter = -> (s_id) {
      offset = s_id - source_start
      dest_start + offset
    }
    @overrides << [checker, converter]
  end

  def resolve(id)
    @overrides.each do |checker, converter|
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

ARGF.read.lines(chomp: true).each do |line|
  case line
  when /^seeds:/
    seeds = line.scan(/\d+/).map(&:to_i)
  when /^(\w+)-to-(\w+) map/
    $source = $1.to_sym
    maps[$source] = Map.new $1.to_sym, $2.to_sym
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

