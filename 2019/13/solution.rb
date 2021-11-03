#!/usr/bin/env ruby

require 'curses'
require 'matrix'

require_relative '../intcode/cpu'

class Vector
  def x; self[0]; end
  def y; self[1]; end
end

DEBUG = ENV['DEBUG']

PATH = ARGV.first || 'input'

TILE_TYPES = {
  0 => :empty,
  1 => :wall,
  2 => :block,
  3 => :paddle,
  4 => :ball
}

# TILE_SPRITES = {
#   empty: ' ',
#   wall: '█',
#   block: '▒',
#   paddle: '━',
#   ball: '●'
# }

TILE_SPRITES = {
  empty: ' ',
  wall: '#',
  block: 'O',
  paddle: '-',
  ball: '*'
}

grid = {}
bounds = Struct.new(:top, :bottom, :left, :right).new(0, 0, 0, 0)

class Game
  attr_reader :grid
  attr_reader :score

  def initialize(cpu, play = false)
    @cpu = cpu
    @bounds = Struct.new(:top, :bottom, :left, :right).new(0, 0, 0, 0)
    @grid = Hash.new :empty
    @score = 0
    @play = play
    @cpu.memory[0] = 2 if play
  end

  def run!
    Curses.clear

    step!

    return unless @play

    while count(:block) > 0
      step!
    end
  end

  def step!
    @cpu.run!
    update!
    draw
  end

  def update!
    @cpu.output.each_slice(3).each do |(x, y, value)|
      pos = Vector[x, y]

      if x == -1 && y == 0
        @score = value
      else
        tile = TILE_TYPES[value]
        @grid[pos] = tile
        update_bounds! pos
        @ball_pos = pos if tile == :ball
        @paddle_pos = pos if tile == :paddle
      end
    end

    @cpu.clear_output!
    @cpu.input! @ball_pos.x <=> @paddle_pos.x
  end

  def update_bounds!(pos)
    @bounds.top = pos.y if pos.y < @bounds.top
    @bounds.bottom = pos.y if pos.y > @bounds.bottom
    @bounds.left = pos.x if pos.x < @bounds.left
    @bounds.right = pos.x if pos.x > @bounds.right
  end

  def draw
    Curses.setpos 0, 0
    Curses.addstr "SCORE: #{@score}"
    (@bounds.top..@bounds.bottom).each do |y|
      (@bounds.left..@bounds.right).each do |x|
        pos = Vector[x, y]
        raise 'Pos is null' if pos.nil?
        tile = @grid[pos]
        raise "Tile is null at #{pos}" if tile.nil?
        sprite = TILE_SPRITES[tile]
        raise "Sprite for #{tile} is null at #{pos}" if sprite.nil?
        Curses.setpos y + 1, x
        Curses.addch sprite
      end
    end

    Curses.refresh
    #sleep 0.5
    #Curses.getch
  end

  def count(type)
    @grid.values.count(type)
  end
end

cpu = Intcode::CPU.new.print_output!(false).load!(PATH)
cpu2 = cpu.dup

Curses.init_screen
begin
  Curses.noecho
  Curses.cbreak
  Curses.curs_set 0

  game = Game.new cpu
  game.run!

  game2 = Game.new cpu2, true
  game2.run!
ensure
  Curses.close_screen
end

puts "Part 1: #{game.count :block}"
puts "Part 2: #{game2.score}"

# require 'pry'
# binding.pry
