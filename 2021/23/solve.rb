#!/usr/bin/env ruby
# frozen_string_literal: true

require 'set'

HALLWAY_LEGAL_INDICES = [0, 1, 3, 5, 7, 9, 10].to_set.freeze

AMPHIPOD_MOVE_COSTS = {
  A: 1,
  B: 10,
  C: 100,
  D: 1000
}.freeze

AMPHIPOD_ROOM = {
  A: 0,
  B: 1,
  C: 2,
  D: 3
}.freeze

ROOM_AMPHIPOD = {
  0 => :A,
  1 => :B,
  2 => :C,
  3 => :D
}.freeze

ROOM_HALLWAY_INDEX = {
  0 => 2,
  1 => 4,
  2 => 6,
  3 => 8
}.freeze

class Room
  attr_reader :full_size
  attr_reader :room_index

  def initialize(full_size, room_index, amphipods = nil)
    @full_size = full_size
    @room_index = room_index
    @amphipods = amphipods || []
  end

  def [](i)
    @amphipods[i]
  end

  def desired_amphipod
    ROOM_AMPHIPOD[@room_index]
  end

  def hallway_index
    ROOM_HALLWAY_INDEX[@room_index]
  end

  def solved?
    @amphipods.size == @full_size && @amphipods.all?(desired_amphipod)
  end

  def shift!
    @amphipods.shift
  end

  def unshift!(amphipod)
    @amphipods.unshift amphipod
  end

  def can_enter?(amphipod)
    amphipod == desired_amphipod && @amphipods.size < @full_size && @amphipods.all?(desired_amphipod)
  end

  def can_exit?
    @amphipods[0] != desired_amphipod || !@amphipods.all?(desired_amphipod)
  end

  def exit_cost(to = nil)
    room_distance = @full_size - @amphipods.size + 1
    hallway_distance = to.nil? ? 0 : (to - ROOM_HALLWAY_INDEX[@room_index]).abs
    distance = room_distance + hallway_distance
    distance * AMPHIPOD_MOVE_COSTS[@amphipods[0]]
  end

  def enter_cost(amphipod, from = nil)
    hallway_distance = from.nil? ? 0 : (from - ROOM_HALLWAY_INDEX[@room_index]).abs
    room_distance = @full_size - @amphipods.size
    distance = hallway_distance + room_distance
    distance * AMPHIPOD_MOVE_COSTS[amphipod]
  end

  def empty?
    @amphipods.empty?
  end

  def hash
    [@full_size, @room_index, @amphipods].hash
  end

  def dup
    self.class.new(@full_size, @room_index, @amphipods.dup)
  end
end

class State
  attr_accessor :hallway, :rooms, :cost

  def initialize(hallway, rooms, cost)
    @hallway = hallway
    @rooms = rooms
    @cost = cost
  end

  def solved?
    @rooms.all?(&:solved?)
  end

  def can_reach_room?(hallway_index, room_index)
    enter_index = ROOM_HALLWAY_INDEX[room_index]
    return true if (hallway_index - enter_index).abs == 1
    if hallway_index < enter_index
      HALLWAY_LEGAL_INDICES.select { _1 > hallway_index && _1 < enter_index }.each do |i|
        return false unless @hallway[i].nil?
      end
    else
      HALLWAY_LEGAL_INDICES.select { _1 < hallway_index && _1 > enter_index }.each do |i|
        return false unless @hallway[i].nil?
      end
    end
    true
  end

  def can_reach_hallway?(room_index, hallway_index)
    return false unless HALLWAY_LEGAL_INDICES.include? hallway_index
    exit_index = ROOM_HALLWAY_INDEX[room_index]
    return @hallway[hallway_index].nil? if (hallway_index - exit_index).abs == 1
    if hallway_index < exit_index
      HALLWAY_LEGAL_INDICES.select { _1 >= hallway_index && _1 < exit_index }.each do |i|
        return false unless @hallway[i].nil?
      end
    else
      HALLWAY_LEGAL_INDICES.select { _1 <= hallway_index && _1 > exit_index }.each do |i|
        return false unless @hallway[i].nil?
      end
    end
    true
  end

  def can_amphipod_reach_room?(amphipod, hallway_index)
    room_index = AMPHIPOD_ROOM[amphipod]
    can_reach_room? hallway_index, room_index
  end

  def valid_exit_indices(room_index)
    HALLWAY_LEGAL_INDICES.select { can_reach_hallway? room_index, _1 }
  end

  def gen_states(cache)
    new_states = []

    @hallway.each do |hallway_index, amphipod|
      next if amphipod.nil?
      target_room_index = AMPHIPOD_ROOM[amphipod]
      target_room = @rooms[target_room_index]
      next unless can_amphipod_reach_room? amphipod, hallway_index
      next unless target_room.can_enter? amphipod
      cost = target_room.enter_cost amphipod, hallway_index
      new_state = self.dup
      new_state.cost += cost
      new_state.hallway.delete hallway_index
      new_state.rooms[target_room_index].unshift! amphipod
      cached_cost = cache[new_state.cache_key]
      next unless cached_cost.nil? || cached_cost > new_state.cost
      cache[new_state.cache_key] = new_state.cost
      new_states << new_state
    end

    @rooms.each_with_index do |room, room_index|
      next if room.empty?
      next unless room.can_exit?
      amphipod = room[0]
      target_hallway_indices = valid_exit_indices room_index
      next if target_hallway_indices.empty?
      target_hallway_indices.each do |target_hallway_index|
        cost = room.exit_cost target_hallway_index
        new_state = self.dup
        new_state.cost += cost
        new_state.hallway[target_hallway_index] = amphipod
        new_state.rooms[room_index].shift!
        cached_cost = cache[new_state.cache_key]
        next unless cached_cost.nil? || cached_cost > new_state.cost
        cache[new_state.cache_key] = new_state.cost
        new_states << new_state
      end
    end

    new_states
  end

  def dup
    self.class.new(@hallway.dup, @rooms.map(&:dup), @cost)
  end

  def cache_key
    [@hallway, @rooms].hash
  end
end

def solve(input)
  state = State.new({}, input.transpose.map.with_index { Room.new _1.size, _2, _1 }, 0)
  successful = []
  queue = [state]
  cache = { state.cache_key => state.cost }

  while queue.any?
    current_state = queue.shift
    if current_state.solved?
      successful << current_state
    else
      new_states = current_state.gen_states cache
      queue.unshift *new_states
    end
  end

  successful.map(&:cost).min
end

input = ARGF.read.scan(/\w/).map(&:to_sym).each_slice(4).to_a

puts solve(input)

input.insert 1, %i[D C B A]
input.insert 2, %i[D B A C]

puts solve(input)
