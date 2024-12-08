#!/usr/bin/env ruby
# frozen_string_literal: true

PLAYER_1 = ARGF.readline.split(':')[1].to_i - 1
PLAYER_2 = ARGF.readline.split(':')[1].to_i - 1

player_1_score = 0
player_2_score = 0

die = 0
die_rolls = 0

player1 = PLAYER_1
player2 = PLAYER_2

(0..).each do |n|
  die_value = die + 1
  die = (die + 1) % 100
  die_value += die + 1
  die = (die + 1) % 100
  die_value += die + 1
  die = (die + 1) % 100
  die_rolls += 3
  if n.even?
    player1 = (player1 + die_value) % 10
    player_1_score += player1 + 1
  else
    player2 = (player2 + die_value) % 10
    player_2_score += player2 + 1
  end
  break if player_1_score >= 1000 || player_2_score >= 1000
end

puts (player_1_score > player_2_score ? player_2_score : player_1_score) * die_rolls

OUTCOMES = [1, 2, 3].repeated_permutation(3).map(&:sum).tally
CACHE = {} # rubocop:disable Style/MutableConstant

def dirac(flag = true, p1 = 0, p2 = 0, p1_score = 0, p2_score = 0) # rubocop:disable Style/OptionalBooleanParameter
  cache_key = [flag, p1, p2, p1_score, p2_score]
  return CACHE[cache_key] if CACHE.key? cache_key

  return [1, 0] if p1_score >= 21
  return [0, 1] if p2_score >= 21

  result = [0, 0]

  if flag
    OUTCOMES.each do |outcome, count|
      p1_o = (p1 + outcome) % 10
      p1_o_s = p1_score + p1_o + 1
      o_r = dirac(false, p1_o, p2, p1_o_s, p2_score)
      result[0] += o_r[0] * count
      result[1] += o_r[1] * count
    end
  else
    OUTCOMES.each do |outcome, count|
      p2_o = (p2 + outcome) % 10
      p2_o_s = p2_score + p2_o + 1
      o_r = dirac(true, p1, p2_o, p1_score, p2_o_s)
      result[0] += o_r[0] * count
      result[1] += o_r[1] * count
    end
  end

  CACHE[cache_key] = result

  result
end

puts dirac(true, PLAYER_1, PLAYER_2).max
