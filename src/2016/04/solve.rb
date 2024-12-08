#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'room'

rooms = $stdin.readlines.map do |line|
  Room.new line
end

rooms = rooms.select(&:real?)

puts "(1) #{rooms.reduce(0) { |a, e| a + e.id }}"

decrypted = rooms.map { |r| [r.decrypt, r.id] }

decrypted.select { |d| d.first =~ /north.*pole.+object.+storage/ }.each do |d|
  puts "(2) #{d.last}"
end
