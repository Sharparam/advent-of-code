#!/usr/bin/env ruby
# frozen_string_literal: true

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
    new nums[0], {
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

    make_geode = production[:obsidian] != 0 && stock[:ore] >= @costs[:geode][:ore] && stock[:obsidian] >= @costs[:geode][:obsidian]
    make_ore = !make_geode && production[:ore] < @caps[:ore] && stock[:ore] >= @costs[:ore][:ore]
    make_clay = !make_geode && production[:clay] < @caps[:clay] && stock[:ore] >= @costs[:clay][:ore]
    make_obsidian = !make_geode && production[:clay] != 0 && production[:obsidian] < @caps[:obsidian] && stock[:ore] >= @costs[:obsidian][:ore] && stock[:clay] >= @costs[:obsidian][:clay]

    stock[:ore] += production[:ore]
    stock[:clay] += production[:clay]
    stock[:obsidian] += production[:obsidian]
    stock[:geode] += production[:geode]

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

    remaining_potential = (production[:geode] * time_left) + (time_left * (time_left + 1) / 2)
    if stock[:geode] + remaining_potential <= maxes[0]
      memory[cache_key] = 0
      return 0
    end

    if make_geode
      new_prod = production.dup.tap { _1[:geode] += 1 }
      new_stock = stock.dup.tap do |h|
        h[:ore] -= @costs[:geode][:ore]
        h[:obsidian] -= @costs[:geode][:obsidian]
      end
      result = solve(time_left, new_stock, new_prod, maxes, memory)
      memory[cache_key] = result
      return result
    end

    max = 0

    if make_ore
      new_prod = production.dup.tap { _1[:ore] += 1 }
      new_stock = stock.dup.tap do |h|
        h[:ore] -= @costs[:ore][:ore]
      end
      result = solve(time_left, new_stock, new_prod, maxes, memory)
      max = result if result > max
    end

    if make_clay
      new_prod = production.dup.tap { _1[:clay] += 1 }
      new_stock = stock.dup.tap do |h|
        h[:ore] -= @costs[:clay][:ore]
      end
      result = solve(time_left, new_stock, new_prod, maxes, memory)
      max = result if result > max
    end

    if make_obsidian
      new_prod = production.dup.tap { _1[:obsidian] += 1 }
      new_stock = stock.dup.tap do |h|
        h[:ore] -= @costs[:obsidian][:ore]
        h[:clay] -= @costs[:obsidian][:clay]
      end
      result = solve(time_left, new_stock, new_prod, maxes, memory)
      max = result if result > max
    end

    result = solve(time_left, stock, production, maxes, memory)
    max = result if result > max

    memory[cache_key] = max
  end

  def print_stock(stock)
    warn "  STOCK: #{stock[:ore]} ore, #{stock[:clay]} clay, #{stock[:obsidian]} obsidian, #{stock[:geode]} geode"
  end
end

BLUEPRINTS = ARGF.read.scan(/\d+/).map(&:to_i).each_slice(7).map { Blueprint.from_array(_1) }.freeze

def part1
  BLUEPRINTS.sum do |blueprint|
    # STDERR.puts "=== TESTING BLUEPRINT #{blueprint.id}"
    blueprint.solve * blueprint.id
  end
end

def part2
  BLUEPRINTS.take(3).map do |blueprint|
    # STDERR.puts "=== TESTING BLUEPRINT #{blueprint.id}"
    blueprint.solve(32)
  end.reduce(:*)
end

puts part1
puts part2
