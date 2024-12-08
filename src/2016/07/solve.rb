#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'address'

addresses = $stdin.readlines.map(&:strip).map { |line| Address.new line }

puts "(1) #{addresses.select(&:tls?).size}"
puts "(2) #{addresses.select(&:ssl?).size}"
