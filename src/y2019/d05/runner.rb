#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../../../lib/aoc/intcode/cpu'

path = ARGV.first || 'input.txt'
arg = ARGV.last&.to_i || 1

cpu = AoC::Intcode::CPU.new
cpu.load!(path).input!(arg).debug!(true).run!
