#!/usr/bin/env ruby
# frozen_string_literal: true

MODULES = {} # rubocop:disable Style/MutableConstant

class ComModule
  attr_reader :id, :destinations

  def initialize(id, destinations)
    @id = id
    @destinations = destinations
  end

  def label
    id
  end

  def inspect
    "#{label} -> #{destinations.join(', ')}"
  end

  def receive(pulse, _source)
    destinations.map { [id, _1, pulse] }
  end
end

class FlipFlop < ComModule
  def initialize(id, destinations)
    super(id, destinations)
    @state = false
  end

  def label
    "%#{id}(#{@state ? 'on' : 'off'})"
  end

  def receive(pulse, _source)
    return [] if pulse
    @state = !@state
    destinations.map { [id, _1, @state] }
  end
end

class Conjunction < ComModule
  def initialize(id, destinations)
    super(id, destinations)
    @memory = Hash.new false
  end

  def init_ids(ids)
    ids.each { @memory[_1] = false }
  end

  def label
    mem = @memory.map { |k, v| "#{k}(#{v})" }.join ', '
    "&#{id}{#{mem}}"
  end

  def receive(pulse, source)
    @memory[source] = pulse
    new_pulse = @memory.values.all?(true) ? false : true
    destinations.map { [id, _1, new_pulse] }
  end
end

TYPES = { '%' => FlipFlop, '&' => Conjunction }.tap { _1.default = ComModule }

ARGF.readlines(chomp: true).each do |line|
  source, dests = line.split ' -> '
  type = TYPES[source[0]]
  source = source[1..] if /[%&]/ === source[0]

  source = source.to_sym
  dests = dests.split(', ').map(&:to_sym)

  MODULES[source] = type.new(source, dests)
end

conjunctions = MODULES.values.select { _1.is_a? Conjunction }
conjunctions.each do |conjunction|
  sources = MODULES.values.select { _1.destinations.include?(conjunction.id) }
  conjunction.init_ids(sources.map(&:id))
end

rx_source = MODULES.select { |_k, m| m.destinations.include?(:rx) }
abort 'unsolveable if rx does not exist as a destination' if rx_source.empty?
abort 'unsolveable if rx has more than 1 source' if rx_source.size > 1
rx_source = rx_source.values[0]
abort 'unsolveable if rx source is not a conjunction' unless rx_source.is_a? Conjunction
rx_source_sources_count = MODULES.count { |_, v| v.destinations.include?(rx_source.id) }

DEBUG = false

n = 0
firsts = {}
seconds = {}
counts = { false => 0, true => 0 }

loop do
  queue = [[:button, :broadcaster, false]]
  n += 1

  until queue.empty?
    source, target, pulse = queue.shift
    counts[pulse] += 1
    puts "#{source} -#{pulse ? 'high' : 'low'}-> #{target}" if DEBUG
    if target == :df && pulse == true
      if !firsts.key?(source)
        puts "high from #{source} to df for the first time on press #{n}" if DEBUG
        firsts[source] = n
      elsif !seconds.key?(source)
        puts "high from #{source} to df for the second time on press #{n}" if DEBUG
        seconds[source] = n
      end
    end
    mod = MODULES[target]
    queue.concat mod.receive(pulse, source) if mod
  end

  if firsts.size == rx_source_sources_count && seconds.size == firsts.size
    puts "all cycles found at n #{n}" if DEBUG
    firsts.each do |k, v|
      size = seconds[k] - v
      puts "#{k}'s cycle starts on #{v} and ends on #{seconds[k]}, size #{size}" if DEBUG
    end

    sizes = firsts.map { |k, v| seconds[k] - v }
    lcm = sizes.reduce(&:lcm)

    puts lcm

    break
  end

  puts counts.values.reduce(:*) if n == 1000
end
