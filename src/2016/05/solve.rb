#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'door'

door = Door.new $stdin.readline.strip

puts "(1) #{door.password_simple}"
puts "(2) #{door.password_hard}"
