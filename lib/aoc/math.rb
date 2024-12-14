# frozen_string_literal: true

module AoC
  # Math helper stuff
  module Math
    class << self
      # @param x [Numeric]
      # @param y [Numeric]
      # @return [Numeric]
      def cantor2(x, y)
        (((x + y) * (x + y + 1)) / 2) + y
      end

      # @param x [Numeric]
      # @param y [Numeric]
      # @param z [Numeric]
      # @return [Numeric]
      def cantor3(x, y, z)
        cantor(cantor(x, y), z)
      end
    end
  end
end
