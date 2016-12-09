#!/usr/bin/env ruby
# encoding: utf-8
# frozen_string_literal: true

require_relative 'address'

addresses = STDIN.readlines.map(&:strip).map { |line| Address.new line }

puts "(1) #{addresses.select { |a| a.tls? }.size}"
puts "(2) #{addresses.select { |a| a.ssl? }.size}"
