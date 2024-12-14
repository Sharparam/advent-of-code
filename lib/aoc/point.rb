# frozen_string_literal: true

require_relative 'math'

module AoC
  class Point2
    attr_reader :x, :y, :hash

    private def initialize(x, y)
      @x = x
      @y = y
      @hash = AoC::Math.cantor2(x, y)
    end

    def self.[](x, y) = new x, y

    def +@ = self
    def -@ = self.class.new(-x, -y)
    def +(other) = self.class.new x + other.x, y + other.y
    def -(other) = self.class.new x - other.x, y - other.y
    def *(other) = self.class.new x * other, y * other

    def /(other)
      case other
      when Numeric
        self.class.new x / other, y / other
      when Point2
        raise 'Point2 cannot be divided by another Point2, only a number'
      else
        raise "Unsupported type in division: #{other.class}"
      end
    end

    def ==(other) = hash == other.hash
    def eql?(other) = hash.eql? other.hash

    def to_s = "(#{x}, #{y})"
    def inspect = "#{self.class.name}(#{x}, #{y})"
  end
end
