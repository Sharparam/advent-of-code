#!/usr/bin/env ruby
# frozen_string_literal: true

HEIGHT = ARGV.first == 't' ? 400_000 : 40

class Row
  def initialize(tiles)
    @tiles = tiles
  end

  def width
    @tiles.size
  end

  def trap?(index)
    return false if index < 0 || index >= @tiles.size
    @tiles[index]
  end

  def left?(index)
    trap? index - 1
  end

  def right?(index)
    trap? index + 1
  end

  def center?(index)
    trap? index
  end

  def count_safe
    @tiles.reduce(0) { |a, e| a + (e ? 0 : 1) }
  end

  def to_s
    @tiles.map { |t| t ? '^' : '.' }.join
  end
end

class Room
  def initialize(row)
    @rows = [Row.new(row.map { |t| t == '^' })]
  end

  def row_count
    @rows.size
  end

  def make_row
    previous = @rows.last
    data = previous.width.times.map do |index|
      (previous.left?(index) && previous.center?(index) && !previous.right?(index)) ||
        (!previous.left?(index) && previous.center?(index) && previous.right?(index)) ||
        (previous.left?(index) && !previous.center?(index) && !previous.right?(index)) ||
        (!previous.left?(index) && !previous.center?(index) && previous.right?(index))
    end
    @rows << Row.new(data)
  end

  def count_safe
    @rows.reduce(0) { |a, e| a + e.count_safe }
  end

  def to_s
    @rows.map(&:to_s).join "\n"
  end
end

input = $stdin.readline.strip.chars

room = Room.new input

(HEIGHT - 1).times { room.make_row }

puts room.count_safe
