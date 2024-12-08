#!/usr/bin/env ruby
# frozen_string_literal: true

DIRECTIONS = [:up, :right, :down, :left].freeze

class Tile
  attr_reader :id
  attr_reader :grid
  attr_reader :width
  attr_reader :height

  def initialize(id, grid)
    @id = id
    @grid = grid
    @width = @grid[0].size
    @height = @grid.size
  end

  def [](x, y)
    @grid[y][x]
  end

  def ==(other)
    id == other.id
  end

  def eql?(other)
    hash == other.hash
  end

  def hash
    id.hash
  end

  def to_s
    "ID #{id}"
  end

  def rows
    @grid
  end

  def row(y)
    @grid[y]
  end

  def columns
    @grid.transpose
  end

  def column(x)
    @grid.map { _1[x] }
  end

  def rotate()
    self.class.new @id, @grid.transpose.map(&:reverse)
  end

  def flip_horizontal()
    self.class.new @id, @grid.map(&:reverse)
  end

  def flip_vertical()
    self.class.new @id, @grid.reverse
  end

  def shave
    new_grid = rows[1..-2].map { _1[1..-2] }
    self.class.new id, new_grid
  end

  def combine(other, direction, new_id: 0)
    case direction
    when :up
      self.class.new new_id, other.grid + @grid
    when :right
      self.class.new new_id, @grid.map.with_index { |r, i| r + other.grid[i] }
    when :down
      self.class.new new_id, @grid + other.grid
    when :left
      self.class.new new_id, other.grid.map.with_index { |r, i| r + @grid[i] }
    end
  end

  def arrangements
    r = rotate
    r2 = r.rotate
    f = flip_horizontal
    fr = f.rotate
    fr2 = fr.rotate

    [
      self, r, r2, r2.rotate,
      f, fr, fr2, fr2.rotate
    ]
  end

  def draw(include_id: false, cell_width: 2)
    width = @grid[0].size
    puts '_' * width * cell_width
    puts "ID: #{id}" if include_id
    block = '█' * cell_width
    open = ' ' * cell_width
    @grid.each do |row|
      puts row.map { |c| c == 1 ? block : open }.join
    end
    puts '~' * width * cell_width
    self
  end

  def matches(other)
    as = self.arrangements
    bs = other.arrangements
    cs = as.product bs
    cs.flat_map do |a, b|
      DIRECTIONS.map do |dir|
        [a, dir, b] if a.test_edge b, dir
      end.compact
    end
  end

  # returns nil if it doesn't fit
  # returns [direction, tile] if it does
  def test(other)
    other.arrangements.each do |arr|
      DIRECTIONS.each do |dir|
        return [dir, arr] if test_edge arr, dir
      end
    end
    nil
  end

  def test_all(other)
    other.arrangements.flat_map do |arr|
      DIRECTIONS.map do |dir|
        [dir, arr] if test_edge arr, dir
      end.compact
    end
  end

  def test_edge(other, edge)
    case edge
    when :up # compare self's upper edge to other's bottom edge
      return true if row(0) == other.row(other.height - 1)
    when :right # compare self's right edge to other's left edge
      return true if column(width - 1) == other.column(0)
    when :down # compare self's bottom edge to other's upper edge
      return true if row(height - 1) == other.row(0)
    when :left # compare self's left edge to other's right edge
      return true if column(0) == other.column(other.width - 1)
    end
    false
  end

  def count_shape(shape)
    count = 0
    shape_width = shape[0].size
    xs = (0..width - shape_width).to_a
    ys = (0..height - shape.size).to_a
    poses = xs.product ys
    poses.each do |x, y|
      valid = true
      shape.each_with_index do |shape_row, shape_y|
        shape_row.each_with_index do |shape_cell, shape_x|
          gx, gy = x + shape_x, y + shape_y
          next if shape_cell == 0
          if @grid[gy][gx] != 1
            valid = false
            break
          end
        end
        break unless valid
      end
      count += 1 if valid
    end
    count
  end
end

tiles = Hash[ARGF.read.split("\n\n").map do |data|
  lines = data.split("\n")
  id = lines[0].split[1].chop.to_i
  grid = lines.drop(1).map do |l|
    l.chars.map { _1 == '#' ? 1 : 0 }
  end
  [id, Tile.new(id, grid)]
end]

match_count = Hash.new 0
tiles.values.each do |tile|
  others = tiles.values - [tile]
  others.each do |other|
    match = tile.test other
    match_count[tile.id] += 1 unless match.nil?
  end
end

corners = match_count.select { _2 == 2 }.map { |id, _| tiles[id] }

part1 = corners.map(&:id).reduce(:*)

puts part1

width = Float::INFINITY
height = Float::INFINITY
corners_found = 1
map_rows = [[corners.first]]
is_first = true
current_row = map_rows[0]

while corners_found < 4
  current_tile = current_row.first
  search_dir = :right
  while current_row.size < width do
    remaining_tiles = tiles.values - map_rows.flatten
    remaining_tiles.each do |tile|
      results = current_tile.test_all tile
      if is_first
        valid = results.select { |dir, _| dir == :left || dir == :right }
        abort 'Found matches to left and right of a corner' if valid.size > 1
        dir, result = valid.first
        if result
          search_dir = dir
          is_first = false
        end
      else
        _, result = results.find { |dir, _| dir == search_dir }
      end
      next unless result
      if search_dir == :right
        current_row << result
      else
        current_row.unshift result
      end
      current_tile = result
      if match_count[result.id] == 2
        corners_found += 1
        width = current_row.size
      end
      break
    end
  end
  break if corners_found >= 4
  current_tile = current_row.first
  found_next_row = false
  remaining_tiles = tiles.values - map_rows.flatten
  remaining_tiles.each do |tile|
    results = current_tile.test_all tile
    next unless results
    valid = results.select { |dir, _| dir == :down || dir == :up }
    abort "Found matches above and below #{current_tile.id}" if valid.size > 1
    dir, result = valid.first
    next unless result
    current_row = [result]
    if dir == :down
      map_rows << current_row
    else
      map_rows.unshift current_row
    end
    found_next_row = true
    # if this is a corner, update the height
    if match_count[result.id] == 2
      height = map_rows.size
      corners_found += 1
    end
    break
  end
  unless found_next_row
    abort "FAILED to find next row for tile #{current_tile.id}"
  end
end

joined_rows = map_rows.map do |row|
  first = row.shift.shave
  row.reduce(first) { |a, e| a.combine(e.shave, :right) }
end

first_row = joined_rows.shift
map = joined_rows.reduce(first_row) { |a, e| a.combine(e, :down) }

MONSTER_ASCII = [
  '                  # ',
  '#    ##    ##    ###',
  ' #  #  #  #  #  #   '
]

MONSTER = MONSTER_ASCII.map { |l| l.chars.map { |c| c == '#' ? 1 : 0 } }

map.arrangements.each do |arr|
  count = arr.count_shape MONSTER
  next if count == 0
  # part 2
  puts arr.grid.flatten.sum - MONSTER.flatten.sum * count
  break
end
