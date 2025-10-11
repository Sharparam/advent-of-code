#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'screen'

screen = Screen.new

$stdin.each_line { |l| screen.process l.strip }

puts "(1) #{screen.lit_count}"
puts "(2)\n#{screen}"
