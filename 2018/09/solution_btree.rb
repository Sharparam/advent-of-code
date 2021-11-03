#!/usr/bin/env ruby

class Node
  attr_reader :value
  attr_accessor :left, :right

  def initialize(value); @value = value; end

  def add!(value)

  end

  def ==(other); self <=> other == 0; end
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

(player_count, last_marble) = (ARGV.empty? ? DATA.read : ARGV.first).scan(/\d+/).map(&:to_i)

btree = Node.new 0

__END__
423 players; last marble is worth 71944 points
