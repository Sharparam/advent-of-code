# encoding: utf-8
# frozen_string_literal: true

class Screen
  WIDTH = 50

  HEIGHT = 6

  OPS = {
    %r{^rect (\d+)x(\d+)$} => ->(w, h) { [:rect, w.to_i, h.to_i] },
    %r{^rotate row y=(\d+) by (\d+)$} => ->(y, c) { [:rot_row, y.to_i, c.to_i] },
    %r{^rotate column x=(\d+) by (\d+)$} => ->(x, c) { [:rot_col, x.to_i, c.to_i] }
  }.freeze

  def initialize
    @display = Array.new(HEIGHT) { Array.new(WIDTH, '.') }
  end

  def lit_count
    @display.reduce(0) do |a, e|
      a + e.reduce(0) { |a, e| a + (e == '.' ? 0 : 1) }
    end
  end

  def rect(width, height)
    height.times do |y|
      width.times do |x|
        @display[y][x] = '#'
      end
    end
  end

  def rot_row(y, count)
    count %= WIDTH
    @display[y].rotate! -count
  end

  def rot_col(x, count)
    count %= HEIGHT

    column = @display.map { |row| row[x] }.rotate -count
    @display.each.with_index { |row, i| row[x] = column[i] }
  end

  def process(instruction)
    op = OPS.find { |k, _| instruction =~ k }
    params = op.last.call *instruction.match(op.first).to_a[1..-1]
    send(*params)
  end

  def to_s
    @display.map(&:join).join "\n"
  end
end
