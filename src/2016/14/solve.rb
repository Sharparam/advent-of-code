#!/usr/bin/env ruby
# encoding: utf-8
# frozen_string_literal: true

require 'digest'
require 'ostruct'

input = STDIN.readline.strip

def gen(salt, count)
  Digest::MD5.hexdigest "#{salt}#{count}"
end

def gen_extra(value)
  2016.times { value = Digest::MD5.hexdigest value }
  value
end

counter = 0

keys = []
keys_2 = []

to_check = {}
to_check_2 = {}

def verify_keys!(to_check, count, key, keys)
  valid = to_check.select { |c, d| count - c <= 1000 && !d.finished && key =~ d.pattern }

  return unless valid.size > 0

  valid.each do |c, data|
    puts "#{data.key} from #{c} matches #{key} at #{count}"
    data.finished = true
    keys.push data.key
  end
end

def check_match!(key, to_check, count)
  match = key.match(/([a-z0-9])\1\1/)

  return unless match

  #puts "Found initial hash: #{key}"

  to_check[count] = OpenStruct.new(
    pattern: /(#{match[1]})\1\1\1\1/, key: key, finished: false
  )
end

loop do
  key = gen input, counter
  key_2 = gen_extra key

  verify_keys! to_check, counter, key, keys
  verify_keys! to_check_2, counter, key_2, keys_2

  break if keys.size >= 64 && keys_2.size >= 64

  check_match! key, to_check, counter
  check_match! key_2, to_check_2, counter

  counter += 1
end

puts "(1) #{to_check.select { |_, d| d.finished }.keys.first(64).sort.last}"
puts "(2) #{to_check_2.select { |_, d| d.finished }.keys.first(64).sort.last}"
