#!/usr/bin/env ruby
# encoding: utf-8
# frozen_string_literal: true

require_relative 'screen'

screen = Screen.new

STDIN.each_line { |l| screen.process l.strip }

puts "(1) #{screen.lit_count}"
puts "(2)\n#{screen}"
