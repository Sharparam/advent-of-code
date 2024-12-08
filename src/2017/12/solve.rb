#!/usr/bin/env ruby
# frozen_string_literal: true

input = ARGF.readlines

map = {}

input.each do |line|
  next unless line =~ /(\d+)[^\d]+([\d, ]+)/
  reachable = map[$1.to_i] ||= Set.new
  $2.split(',').map(&:to_i).each { |t| reachable.add t }
end

visited = Set.new
tovisit = [0]
while tovisit.any?
  current = tovisit.pop
  visited.add current
  reachable = map[current].reject { |n| visited.include? n }
  tovisit += reachable.to_a
end

puts visited.size

puts 1 + (map.keys.count { |start|
  if visited.include? start
    false
  else
    tovisit = [start]
    while tovisit.any?
      current = tovisit.pop
      visited.add current
      reachable = map[current].reject { |n| visited.include? n }
      tovisit += reachable.to_a
    end

    true
  end
})
