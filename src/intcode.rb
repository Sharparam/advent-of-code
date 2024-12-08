#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../lib/aoc/intcode'

puts AoC::Intcode::CPU.new.print_output!(false).load!(ARGV[0]).run!.output.map(&:chr).join
