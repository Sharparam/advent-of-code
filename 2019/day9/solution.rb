#!/usr/bin/env ruby

require_relative '../intcode/cpu'

path = ARGV.first || 'input'
cpu = Intcode::CPU.new
cpu.load!(path)

cpu.debug!(true) if ENV['DEBUG']

cpu2 = cpu.dup

cpu.input!(1) if path == 'input'

cpu.run!

cpu2.input!(2).run! if path == 'input'

if ENV['DEBUG']
  require 'pry'
  binding.pry
end
