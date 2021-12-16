#!/usr/bin/env ruby
# frozen_string_literal: true

require 'pry'

TYPES = {
  0 => :sum,
  1 => :product,
  2 => :min,
  3 => :max,
  4 => :literal,
  5 => :gt,
  6 => :lt,
  7 => :eq
}.freeze

MODES = {
  0 => :bits,
  1 => :packets
}

LITERAL_VALUE_SIZE = 4 * 5

class Packet
  attr_reader :version, :type
end

hex = ARGF.readline.strip
# puts hex
bin_width = hex.size * 4
data = hex.to_i(16).to_s(2).rjust(bin_width, '0').chars
# puts data.join

versions = []

def parse_packet(data, position, versions)
  final_value = 0
  version = data.shift(3).join.to_i(2)
  versions << version
  type = TYPES[data.shift(3).join.to_i(2)]
  position += 6
  # puts "V:#{version},T:#{type}"
  case type
  when :literal
    value_bits = []
    loop do
      order = data.shift(1)[0].to_i
      value_bits << data.shift(4).join
      position += 5
      break if order.zero?
    end
    value = value_bits.join.to_i(2)
    final_value = value
  else
    mode = MODES[data.shift(1)[0].to_i]
    position += 1
    # print " M:#{mode}"
    op_values = []
    case mode
    when :bits
      length_bits = data.shift(15).join
      bit_length = length_bits.to_i(2)
      # puts ":#{bit_length}"
      # puts " DBG:l_bits=#{length_bits}"
      position += 15
      bits_read = 0
      while bits_read < bit_length do
        old_pos = position
        position, value = parse_packet(data, position, versions)
        bits_read += position - old_pos
        op_values << value
      end
    when :packets
      packet_count = data.shift(11).join.to_i(2)
      # puts ":#{packet_count}"
      position += 11
      packet_count.times do
        position, value = parse_packet(data, position, versions)
        op_values << value
      end
    end
    case type
    when :sum
      final_value = op_values.sum
    when :product
      final_value = op_values.reduce(1, :*)
    when :min
      final_value = op_values.min
    when :max
      final_value = op_values.max
    when :gt
      final_value = op_values[0] > op_values[1] ? 1 : 0
    when :lt
      final_value = op_values[0] < op_values[1] ? 1 : 0
    when :eq
      final_value = op_values[0] == op_values[1] ? 1 : 0
    end
  end
  [position, final_value]
end

_, part2 = parse_packet(data, 0, versions)

puts versions.sum
puts part2
