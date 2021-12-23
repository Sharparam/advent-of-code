#!/usr/bin/env ruby
# frozen_string_literal: true

require 'set'
require 'pry'

WALL_CHAR = '█'

HALLWAY_SIZE = 11
HALLWAY_LEGAL_INDICES = [0, 1, 3, 5, 7, 9, 10].to_set.freeze
ROOM_SIZE = 4
ROOM_LEGAL_INDICES = [0, 1, 2, 3].to_set.freeze

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

def solved_room?(i, room)
  room.size == 4 && room.all?(ROOM_AMPHIPOD[i])
end

def solved_rooms?(rooms)
  rooms.each_with_index do |room, i|
    return false unless solved_room? i, room
  end
  true
end

def can_enter?(amphipod, room, i)
  i == AMPHIPOD_ROOM[amphipod] && room.size < 4 && room.all?(amphipod)
end

def dup_rooms(rooms)
  rooms.map(&:dup)
end

def room_to_hallway_cost(room, room_index, hallway_index, amphipod)
  exit_index = ROOM_HALLWAY_INDEX[room_index]
  hallway_distance = (exit_index - hallway_index).abs
  room_exit_cost(room, amphipod) + (1 + hallway_distance) * AMPHIPOD_MOVE_COSTS[amphipod]
end

def hallway_to_room_cost(hallway_index, room, room_index, amphipod)
  enter_index = ROOM_HALLWAY_INDEX[room_index]
  hallway_distance = (enter_index - hallway_index).abs
  room_enter_cost(room, amphipod) + (1 + hallway_distance) * AMPHIPOD_MOVE_COSTS[amphipod]
end

def room_exit_cost(room, amphipod)
  (4 - room.size) * AMPHIPOD_MOVE_COSTS[amphipod]
end

def room_enter_cost(room, amphipod)
  (3 - room.size) * AMPHIPOD_MOVE_COSTS[amphipod]
end

def room_vis_index(room, index)
  index - (4 - room.size)
end

def room_vis(room, index)
  vis_index = room_vis_index(room, index)
  return '.' if vis_index < 0
  room[vis_index]
end

class State
  attr_accessor :hallway, :rooms, :cost

  def initialize(hallway = nil, rooms = nil, cost = 0)
    @hallway = hallway || {}
    @rooms = rooms || [[], [], [], []]
    @cost = cost || 0
  end

  def solved?
    solved_rooms? @rooms
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
      next unless can_enter? amphipod, target_room, target_room_index
      cost = hallway_to_room_cost hallway_index, target_room, target_room_index, amphipod
      new_state = self.dup
      new_state.cost += cost
      new_state.hallway.delete hallway_index
      new_state.rooms[target_room_index].unshift amphipod
      cached_cost = cache[new_state.cache_key]
      next unless cached_cost.nil? || cached_cost > new_state.cost
      cache[new_state.cache_key] = new_state.cost
      new_states << new_state
    end

    @rooms.each_with_index do |room, room_index|
      next if room.empty?
      amphipod = room[0]
      next if room_index == AMPHIPOD_ROOM[amphipod] && room.all?(amphipod)
      target_hallway_indices = valid_exit_indices room_index
      next if target_hallway_indices.empty?
      target_hallway_indices.each do |target_hallway_index|
        cost = room_to_hallway_cost room, room_index, target_hallway_index, amphipod
        new_state = self.dup
        new_state.cost += cost
        new_state.hallway[target_hallway_index] = amphipod
        new_state.rooms[room_index].shift
        cached_cost = cache[new_state.cache_key]
        next unless cached_cost.nil? || cached_cost > new_state.cost
        cache[new_state.cache_key] = new_state.cost
        new_states << new_state
      end
    end

    new_states
  end

  def dup
    self.class.new(@hallway.dup, dup_rooms(@rooms), @cost)
  end

  def eql?(other)
    @hallway == other.hallway && @rooms == other.rooms && @cost == other.cost
  end

  def ==(other)
    eql? other
  end

  def hash
    [@hallway, @rooms, @cost].hash
  end

  def cache_key
    [@hallway, @rooms].hash
  end

  def to_s
    <<~STATE
      #{WALL_CHAR * 13}
      #{WALL_CHAR}#{(0...HALLWAY_SIZE).map { @hallway[_1] || '.' }.join}#{WALL_CHAR}
      #{WALL_CHAR * 3}#{room_vis(@rooms[0], 0)}#{WALL_CHAR}#{room_vis(@rooms[1], 0)}#{WALL_CHAR}#{room_vis(@rooms[2], 0)}#{WALL_CHAR}#{room_vis(@rooms[3], 0)}#{WALL_CHAR * 3}
        #{WALL_CHAR}#{room_vis(@rooms[0], 1)}#{WALL_CHAR}#{room_vis(@rooms[1], 1)}#{WALL_CHAR}#{room_vis(@rooms[2], 1)}#{WALL_CHAR}#{room_vis(@rooms[3], 1)}#{WALL_CHAR}
        #{WALL_CHAR}#{room_vis(@rooms[0], 2)}#{WALL_CHAR}#{room_vis(@rooms[1], 2)}#{WALL_CHAR}#{room_vis(@rooms[2], 2)}#{WALL_CHAR}#{room_vis(@rooms[3], 2)}#{WALL_CHAR}
        #{WALL_CHAR}#{room_vis(@rooms[0], 3)}#{WALL_CHAR}#{room_vis(@rooms[1], 3)}#{WALL_CHAR}#{room_vis(@rooms[2], 3)}#{WALL_CHAR}#{room_vis(@rooms[3], 3)}#{WALL_CHAR}
        #{WALL_CHAR * 9}
    STATE
  end
end

input = ARGF.read.scan(/\w/).map(&:to_sym).each_slice(4).to_a

input.insert 1, %i[D C B A]
input.insert 2, %i[D B A C]

state = State.new(nil, input.transpose)

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

puts successful.map(&:cost).min
