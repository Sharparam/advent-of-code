#!/usr/bin/env ruby
# frozen_string_literal: true

def mix(secret, value)
  secret ^ value
end

def prune(value)
  value % 16_777_216
end

def evolve(secret)
  secret = prune(mix(secret, secret * 64))
  secret = prune(mix(secret, secret / 32))
  prune(mix(secret, secret * 2048))
end

INITIALS = ARGF.map(&:to_i).freeze

BUYERS = INITIALS.map do |init|
  secrets = [init]
  2000.times { secrets << evolve(secrets[-1]) }
  prices = secrets.map { _1.digits[0] }
  changes = {}
  old = prices[0]
  change = []
  prices[1..].each do |price|
    diff = price - old
    old = price
    change.push diff
    next if change.size < 4
    changes[change.dup] ||= price
    change.shift
  end

  {
    secrets: secrets,
    prices: prices,
    changes: changes
  }
end

puts BUYERS.sum { _1[:secrets][-1] }

changes = BUYERS.map { _1[:changes].keys }.flatten(1).to_set

puts changes.map { |change|
  BUYERS.sum { |buyer|
    buyer[:changes][change] || 0
  }
}.max
