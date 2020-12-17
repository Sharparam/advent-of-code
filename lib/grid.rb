require 'matrix'
require 'set'

require 'pp'

class Grid
  attr_reader :width
  attr_reader :height

  def initialize(width, height, walls = nil)
    @width = width
    @height = height
    @walls = Set.new
    self.walls = walls if walls
  end

  def in_bounds?(pos)
    x, y = pos.to_a
    x >= 0 && x < width && y >= 0 && y < height
  end

  def passable?(pos)
    !@walls.include? pos
  end

  def add_wall(pos)
    @walls.add pos
  end

  def walls=(positions)
    positions.each { add_wall _1 }
  end

  def neighbors(pos)
    x, y = pos.to_a
    adjacent = [[x + 1, y], [x - 1, y], [x, y - 1], [x, y + 1]].map { Vector[*_1] }
    adjacent.reverse! if (x + y) % 2 == 0
    adjacent.select { in_bounds?(_1) && passable?(_1) }
  end

  def draw(**opts)
    puts "___" * width
    (0...height).each do |y|
      (0...width).each do |x|
        print draw_tile(Vector[x, y], opts)
      end
      puts
    end
    puts "~~~" * width
  end

  private

  def draw_tile(pos, opts)
    return '###' unless passable?(pos)
    return ' Z ' if opts.key?(:goal) && opts[:goal] == pos
    return ' A ' if opts.key?(:start) && opts[:start] == pos
    return ' @ ' if opts.key?(:path) && opts[:path].include?(pos)
    if opts.key?(:point_to) && !opts[:point_to][pos].nil?
      x1, y1 = pos.to_a
      x2, y2 = opts[:point_to][pos].to_a
      return ' ↑ ' if y2 == y1 - 1
      return ' ↓ ' if y2 == y1 + 1
      return ' ← ' if x2 == x1 - 1
      return ' → ' if x2 == x1 + 1
    end
    return sprintf(' %-2d', opts[:number][pos]) if opts.key?(:number) && opts[:number].key?(pos)
    ' . '
  end
end

class GridWithWeights < Grid
  def initialize(width, height, walls = nil)
    super(width, height, walls)
    @weights = Hash.new(1)
  end

  def add_weight(pos, weight)
    @weights[pos] = weight
  end

  def cost(source, destination)
    @weights[destination]
  end
end
