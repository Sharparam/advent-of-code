#!/usr/bin/env ruby
# frozen_string_literal: true

OPPOSITE_TYPE = {
  generator: :microchip,
  microchip: :generator
}.freeze

START_FLOOR = 0
TARGET_FLOOR = 3

Item = Struct.new('Item', :type, :element) do
  def compatible?(other)
    type == OPPOSITE_TYPE[other.type] && element == other.element
  end

  def to_s
    "#{element} #{type}"
  end

  def inspect
    "#{element} #{type}"
  end
end

State = Struct.new('State', :items, :elevator)

floors = ARGF.map do |line|
  line.scan(/([a-z]+)(?:-compatible)? (generator|microchip)/).map { |e, t| Item.new t.to_sym, e.to_sym }
end

# state: elevator position, elevator contents, floor contents

p floors

require 'pry'
binding.pry
