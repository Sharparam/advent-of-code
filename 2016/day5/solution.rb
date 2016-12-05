#!/usr/bin/env ruby
# encoding: utf-8
# force_string_literal: true

require_relative 'door'

door = Door.new STDIN.readline.strip

puts "(1) #{door.password_simple}"
puts "(2) #{door.password_hard}"
