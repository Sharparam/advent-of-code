#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../../../lib/aoc/intcode/cpu'

path = ARGV.first || 'input.txt'

cpu = AoC::Intcode::CPU.new
cpu.load!(path).input!(5).debug!(true).run!
