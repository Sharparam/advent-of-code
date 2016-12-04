#!/usr/bin/env ruby
# encoding: utf-8
# frozen_string_literal: true

require_relative 'room'

rooms = STDIN.readlines.map do |line|
  Room.new line
end

rooms = rooms.select { |r| r.real? }

puts "(1) #{rooms.reduce(0) { |a, e| a + e.id }}"

decrypted = rooms.map { |r| [r.decrypt, r.id] }

decrypted.select { |d| d.first =~ /north.*pole.+object.+storage/ }.each do |d|
  puts "(2) #{d.last}"
end
