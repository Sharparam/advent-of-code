#!/usr/bin/env ruby
# frozen_string_literal: true

require 'matrix'

class Vector
  def x = self[0]
  def y = self[1]
end

WIDTH = 101
HEIGHT = 103

# WIDTH = 11
# HEIGHT = 7

QUADRANTS = [
  { # Top left
    x: (0..(WIDTH / 2) - 1),
    y: (0..(HEIGHT / 2) - 1)
  },
  { # Top right
    x: ((WIDTH / 2) + 1..WIDTH - 1),
    y: (0..(HEIGHT / 2) - 1)
  },
  { # Bottom left
    x: (0..(WIDTH / 2) - 1),
    y: ((HEIGHT / 2) + 1..HEIGHT - 1)
  },
  { # Bottom right
    x: ((WIDTH / 2) + 1..WIDTH - 1),
    y: ((HEIGHT / 2) + 1..HEIGHT - 1)
  }
].tap { |qs|
  qs.each { |q|
    q[:p] = q[:x].to_a.product(q[:y].to_a).map { |x, y| Vector[x, y] }
  }
}.freeze

robots = ARGF.map { |line|
  p, v = line.scan(/-?\d+/).map(&:to_i).each_slice(2).map { |p| Vector[*p] }
  { p: p, v: v }
}

# p robots

def display(robots, f = nil)
  f.puts '=' * WIDTH
  HEIGHT.times do |y|
    WIDTH.times do |x|
      p = Vector[x, y]
      c = robots.count { |r| r[:p] == p }
      c = '.' if c.zero?
      f.print c
    end
    f.puts
  end
  f.puts '=' * WIDTH
end

File.open('output', 'w') do |f|
  # f.puts 'i = 0'
  # display(robots, f)

  (1..).each do |i|
    # $stderr.puts "i = #{i}"
    pos = Hash.new 0
    robots.each do |robot|
      p, v = robot[:p], robot[:v]
      n_p = Vector[(p.x + v.x) % WIDTH, (p.y + v.y) % HEIGHT]
      robot[:p] = n_p
      pos[n_p] += 1
    end

    if i == 100
      # warn "Step 100, printing part 1"
      puts QUADRANTS.map { |q|
        q[:p].sum { |p| robots.count { |r| r[:p] == p } }
      }.reduce(:*)
    end

    next unless pos.values.all? { _1 == 1 }
    # $stderr.puts "FOUND(?) AT #{i}"
    puts i
    f.puts "i = #{i}"
    display(robots, f)
    break
  end
end

# p QUADRANTS
