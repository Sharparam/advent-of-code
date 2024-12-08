#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../../intcode/cpu'

DEBUG = ENV['DEBUG']

PATH = ARGV.first || 'input'

queues = []
current_nat = nil
any_sent = false
part1 = false
part2 = nil
last_nat_y = nil

computers = 50.times.map do |i|
  Intcode::CPU.new.print_output!(false).load!(PATH).input!(i)
end

until part2
  if !any_sent && current_nat
    (queues[0] ||= Queue.new).enq current_nat
    nat_y = current_nat[1]
    part2 = nat_y if nat_y == last_nat_y
    last_nat_y = nat_y
    current_nat = nil
  end
  any_sent = false
  computers.each_with_index do |computer, address|
    queue = queues[address] ||= Queue.new
    if queue.empty?
      computer.input! -1
    else
      packet = queue.deq
      computer.input! packet[0]
      computer.input! packet[1]
    end
    computer.run!
    computer.output.each_slice(3) do |(target, x, y)|
      (queues[target] ||= Queue.new).enq [x, y]
      any_sent = true
      if target == 255
        unless part1
          puts "Part 1: #{y}"
          part1 = true
        end
        current_nat = [x, y]
      end
    end
    computer.clear_output!
  end
end

puts "Part 2: #{part2}"
