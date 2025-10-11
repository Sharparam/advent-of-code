#!/usr/bin/env ruby
# frozen_string_literal: true

class Keypad
  MOVEMENT = {
    u: -> { [0, -1] },
    d: -> { [0,  1] },
    l: -> { [-1, 0] },
    r: -> { [1, 0] }
  }.freeze

  attr_reader :x, :y

  def initialize(layout)
    @layout = layout

    @y = @layout.index { |row| row.include? 5 }
    @x = @layout[@y].index 5
  end

  def x=(val)
    @x = val if val >= 0 && val < @layout[@y].size
  end

  def y=(val)
    return unless val >= 0 && val < @layout.size
    new_x = translate_x val
    return unless new_x >= 0 && new_x < @layout[val].size
    @y = val
    @x = new_x
  end

  def move(direction)
    dx, dy = MOVEMENT[direction].call

    # X and Y never change at the same time
    self.x += dx
    self.y += dy
  end

  def current
    @layout[@y][@x]
  end

  private

  def translate_x(y)
    return @x if @layout[@y].size == @layout[y].size
    @x - ((@layout[@y].size - @layout[y].size) / 2)
  end
end

input = $stdin.readlines.map { |l| l.strip.chars.map { |d| d.downcase.to_sym } }

pad = Keypad.new [
  [1, 2, 3],
  [4, 5, 6],
  [7, 8, 9]
]

code = []

input.each do |row|
  row.map { |dir| pad.move dir }
  code << pad.current
end

puts "(1) #{code.map { |d| d.to_s(16) }.join}"

# rubocop:disable Layout/FirstArrayElementIndentation, Layout/ArrayAlignment
pad = Keypad.new [
            [0x1],
       [0x2, 0x3, 0x4],
  [0x5, 0x6, 0x7, 0x8, 0x9],
       [0xA, 0xB, 0xC],
            [0xD]
]
# rubocop:enable Layout/FirstArrayElementIndentation, Layout/ArrayAlignment

code = []

input.each do |row|
  row.map { |dir| pad.move dir }
  code << pad.current
end

puts "(2) #{code.map { |d| d.to_s(16).upcase }.join}"
