#!/usr/bin/env ruby
# frozen_string_literal: true

GRID = ARGF.map { _1.chomp.chars }

NEEDLES = [
  [
    [[0, 0], ?X], [[1, 0], ?M], [[2, 0], ?A], [[3, 0], ?S]
  ],
  [
    [[0, 0], ?S], [[1, 0], ?A], [[2, 0], ?M], [[3, 0], ?X]
  ],
  [
    [[0, 0], ?X], [[0, 1], ?M], [[0, 2], ?A], [[0, 3], ?S]
  ],
  [
    [[0, 0], ?S], [[0, 1], ?A], [[0, 2], ?M], [[0, 3], ?X]
  ],
  [
    [[0, 0], ?X], [[1, 1], ?M], [[2, 2], ?A], [[3, 3], ?S]
  ],
  [
    [[0, 0], ?S], [[1, 1], ?A], [[2, 2], ?M], [[3, 3], ?X]
  ],
  [
    [[0, 0], ?X], [[1, -1], ?M], [[2, -2], ?A], [[3, -3], ?S]
  ],
  [
    [[0, 0], ?S], [[1, -1], ?A], [[2, -2], ?M], [[3, -3], ?X]
  ]
].freeze

NEEDLES_2 = [
  [
    [[1, 1], ?A],
    [[0, 0], ?M], [[2, 0], ?S],
    [[0, 2], ?M], [[2, 2], ?S]
  ],
  [
    [[1, 1], ?A],
    [[0, 0], ?S], [[2, 0], ?M],
    [[0, 2], ?S], [[2, 2], ?M]
  ],
  [
    [[1, 1], ?A],
    [[0, 0], ?M], [[2, 0], ?M],
    [[0, 2], ?S], [[2, 2], ?S]
  ],
  [
    [[1, 1], ?A],
    [[0, 0], ?S], [[2, 0], ?S],
    [[0, 2], ?M], [[2, 2], ?M]
  ]
].freeze

HEIGHT = GRID.size
WIDTH = GRID.first.size

count = 0
count2 = 0

HEIGHT.times.each do |row|
  WIDTH.times.each do |col|
    count += NEEDLES.count do |needle|
      needle.all? do |(dx, dy), c|
        x = col + dx
        y = row + dy
        next false if x < 0 || x >= WIDTH || y < 0 || y >= HEIGHT
        GRID[y][x] == c
      end
    end

    count2 += NEEDLES_2.count do |needle|
      needle.all? do |(dx, dy), c|
        x = col + dx
        y = row + dy
        next false if x < 0 || x > WIDTH || y < 0 || y >= HEIGHT
        GRID[y][x] == c
      end
    end
  end
end

puts count
puts count2
