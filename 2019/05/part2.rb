#!/usr/bin/env ruby

require_relative '../intcode/cpu'

path = ARGV.first || 'input.txt'

cpu = Intcode::CPU.new
cpu.load!(path).input!(5).debug!(true).run!
