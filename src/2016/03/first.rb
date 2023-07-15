#!/usr/bin/env ruby
# encoding: utf-8
# frozen_string_literal: true

require_relative 'engine'

input = STDIN.readlines.map { |l| l.split.map(&:to_i) }

puts count_triangles input
