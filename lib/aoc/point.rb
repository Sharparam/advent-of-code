# frozen_string_literal: true

require_relative 'math'

module AoC
  # A 2D point.
  class Point2
    # @return [Numeric]
    attr_reader :x

    # @return [Numeric]
    attr_reader :y

    # @return [Numeric]
    attr_reader :hash

    # Creates a new 2D point.
    # @param x [Numeric] The X position.
    # @param y [Numeric] The Y position.
    def initialize(x, y)
      @x = x
      @y = y
      @hash = AoC::Math.cantor2(x, y)
    end

    # Creates a new 2D point.
    # @param x [Numeric] The X position.
    # @param y [Numeric] The Y position.
    # @return [Point2]
    def self.[](x, y) = new x, y

    # @return [self]
    def +@ = self

    # @return [Point2]
    def -@ = self.class.new(-x, -y)

    # @param other [Point2]
    # @return [Point2]
    def +(other) = self.class.new x + other.x, y + other.y

    # @param other [Point2]
    # @return [Point2]
    def -(other) = self.class.new x - other.x, y - other.y

    # @param other [Point2]
    # @return [Point2]
    def *(other) = self.class.new x * other, y * other

    # Divides each component of the point with `other`.
    # Raises an error if the parameter is not a {Numeric}.
    # @param other [Numeric]
    # @return [Point2]
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

    # Checks for equality with another {Point2}.
    # @param other [Point2]
    # @return [Boolean]
    def ==(other) = hash == other.hash

    # Checks for equality with another {Point2}.
    # @param other [Point2]
    # @return [Boolean]
    def eql?(other) = hash.eql? other.hash

    # Gets a string representation of the object.
    # @return [String]
    def to_s = "(#{x}, #{y})"

    # Gets a debug-friendly string representation of the object.
    # @return [String]
    def inspect = "#{self.class.name}(#{x}, #{y})"
  end
end
