#!/usr/bin/env ruby
# frozen_string_literal: true

require 'set'

RESOURCES = %i[ore clay obsidian geode].freeze
TIME = 24

class Blueprint
  attr_reader :id

  def initialize(id, costs)
    @id = id
    @costs = costs
    @caps = {
      ore: [@costs[:ore][:ore], @costs[:clay][:ore], @costs[:obsidian][:ore], @costs[:geode][:ore]].max,
      clay: @costs[:obsidian][:clay],
      obsidian: @costs[:geode][:obsidian]
    }
  end

  def self.from_array(nums)
    self.new nums[0], {
      ore: {
        ore: nums[1]
      },
      clay: {
        ore: nums[2]
      },
      obsidian: {
        ore: nums[3],
        clay: nums[4]
      },
      geode: {
        ore: nums[5],
        obsidian: nums[6]
      }
    }
  end

  def solve(time_left = TIME, stock = Hash.new(0), production = Hash.new(0).tap { _1[:ore] = 1 }, maxes = { 0 => 0 }, memory = {})
    cache_key = [time_left, stock.hash, production.hash].hash
    if memory.key?(cache_key)
      # STDERR.puts "=== CACHE HIT ==="
      return memory[cache_key]
    end

    if time_left == 0
      if stock[:geode] > maxes[0]
        maxes[0] = stock[:geode]
        # STDERR.print "=== FINISHED ==="
        # print_stock(stock)
      end

      memory[cache_key] = stock[:geode]

      return stock[:geode]
    end

    paths = RESOURCES.select { |t| @costs[t].all? { |r, n| stock[r] >= n } }.to_set

    production.each { |t, n| stock[t] += n }

    if maxes.key?(time_left)
      if stock[:geode] < maxes[time_left]
        memory[cache_key] = maxes[time_left]
        return maxes[time_left]
      else
        maxes[time_left] = stock[:geode]
      end
    else
      maxes[time_left] = stock[:geode]
    end

    time_left -= 1

    n = time_left
    remaining_potential = production[:geode] * n + n * (n + 1) / 2
    if stock[:geode] + remaining_potential <= maxes[0]
      memory[cache_key] = 0
      return 0
    end

    paths -= [:ore] if production[:ore] >= @caps[:ore]
    paths -= [:clay] if production[:clay] >= @caps[:clay]
    paths -= [:obsidian] if production[:clay] == 0 || production[:obsidian] >= @caps[:obsidian]
    paths -= [:geode] if production[:obsidian] == 0

    paths -= %i[ore clay obsidian] if paths.include?(:geode)

    results = []

    paths.each do |path|
      costs = @costs[path]
      new_prod = production.dup.tap { _1[path] += 1}
      new_stock = stock.dup.tap { |h| costs.each { |r, n| h[r] -= n } }
      results.push solve(time_left, new_stock, new_prod, maxes, memory)
    end

    results.push(solve(time_left, stock, production, maxes, memory)) unless paths.include?(:geode)

    memory[cache_key] = results.max
  end

  def print_stock(stock)
    STDERR.puts "  STOCK: #{stock[:ore]} ore, #{stock[:clay]} clay, #{stock[:obsidian]} obsidian, #{stock[:geode]} geode"
  end
end

BLUEPRINTS = ARGF.read.scan(/\d+/).map(&:to_i).each_slice(7).map { Blueprint.from_array(_1) }.freeze

total = 0

BLUEPRINTS.each do |blueprint|
  # STDERR.puts "=== TESTING BLUEPRINT #{blueprint.id}"
  result = blueprint.solve()

  total += result * blueprint.id
end

puts total

part2_bps = BLUEPRINTS.take(3)
part2_geodes = part2_bps.map do |blueprint|
  # STDERR.puts "=== TESTING BLUEPRINT #{blueprint.id}"
  blueprint.solve(32)
end

puts part2_geodes.reduce(:*)
