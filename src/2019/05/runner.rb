#!/usr/bin/env ruby

require_relative '../../intcode/cpu'

path = ARGV.first || 'input.txt'
arg = ARGV.last&.to_i || 1

cpu = Intcode::CPU.new
cpu.load!(path).input!(arg).debug!(true).run!
