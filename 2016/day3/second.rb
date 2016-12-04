#!/usr/bin/env ruby
# encoding: utf-8
# frozen_string_literal: true

require_relative 'engine'

input = STDIN.readlines.map { |l| l.split.map(&:to_i) }

triangles = []

input.each_slice(3) do |rows|
  (0..2).each do |col|
    triangles << [rows[0][col], rows[1][col], rows[2][col]]
  end
end

puts count_triangles triangles
