#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../../../lib/aoc/intcode/cpu'

path = ARGV.first || 'input'
solve = ARGV.last || path == 'input'
cpu = AoC::Intcode::CPU.new
cpu.load!(path)

cpu.debug!(true) if ENV['DEBUG']

cpu2 = cpu.dup

cpu.input!(1) if solve

cpu.run!

cpu2.input!(2).run! if solve

if ENV['DEBUG']
  require 'pry'
  binding.pry
end
