#!/usr/bin/env ruby
# frozen_string_literal: true

DEBUG = false

(player_count, last_marble) = (ARGV.empty? ? DATA.read : ARGV.first).scan(/\d+/).map(&:to_i)

def print_circle(c, ci, p = '-')
  return unless DEBUG
  printf '[%3s] ', p
  c.each_with_index do |m, i|
    if i == ci
      printf '(%2d)', m
    else
      printf ' %2d ', m
    end
  end
  puts
end

def solve(pc, lm)
  circle = [0]
  current_marble = 1
  current_marble_index = 0
  scores = Hash.new(0)

  print_circle circle, current_marble_index

  (1..pc).cycle do |p|
    break if current_marble > lm

    a, b = (current_marble_index + 1) % circle.size, (current_marble_index + 2) % circle.size

    if current_marble % 23 == 0
      current_marble_index = (current_marble_index - 7) % circle.size
      scores[p] += current_marble + circle.delete_at(current_marble_index)
    elsif a == b || (a == circle.size - 1 && b == 0)
      circle << current_marble
      current_marble_index = circle.size - 1
    else
      circle.insert a + 1, current_marble
      current_marble_index = a + 1
    end

    print_circle circle, current_marble_index, p
    current_marble += 1
  end

  scores.values.max
end

puts "Part 1: #{solve player_count, last_marble}"
puts "Part 2: #{solve(player_count, last_marble * 100)}"

__END__
423 players; last marble is worth 71944 points
