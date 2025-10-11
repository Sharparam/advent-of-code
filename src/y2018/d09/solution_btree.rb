#!/usr/bin/env ruby
# frozen_string_literal: true

# rubocop:disable all

class Node
  attr_reader :value
  attr_accessor :left, :right

  def initialize(value); @value = value; end

  def add!(value)

  end

  def ==(other); (self <=> other) == 0; end
  def <(other); self <=> other < 0; end
  def <=(other); self <=> other <= 0; end
  def >(other); self <=> other > 0; end
  def >=(other); self <=> other >= 0; end

  def <=>(other)
    case other
    when Node
      @value <=> other&.value
    when Numeric
      @value <=> other
    end
  end
end

DEBUG = false

(_player_count, _last_marble) = (ARGV.empty? ? DATA.read : ARGV.first).scan(/\d+/).map(&:to_i)

_btree = Node.new 0

__END__
423 players; last marble is worth 71944 points
