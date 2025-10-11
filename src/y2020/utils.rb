# frozen_string_literal: true

module Utils
  class << self
    def crt(mods, remainders)
      max = mods.inject(:*) # product of all moduli
      series = remainders.zip(mods).map { |r, m| (r * max * invmod(max / m, m) / m) }
      series.inject(:+) % max
    end

    private

    def extended_gcd(a, b)
      last_remainder, remainder = a.abs, b.abs
      x, last_x, y, last_y = 0, 1, 1, 0
      while remainder != 0
        last_remainder, (quotient, remainder) = remainder, last_remainder.divmod(remainder)
        x, last_x = last_x - (quotient * x), x
        y, last_y = last_y - (quotient * y), y
      end
      [last_remainder, last_x * (a < 0 ? -1 : 1)]
    end

    def invmod(e, et)
      g, x = extended_gcd(e, et)
      raise 'Multiplicative inverse modulo does not exist!' if g != 1
      x % et
    end
  end
end

module Enumerable
  def mean
    sum.to_f / size
  end

  def median
    return self[size / 2] if size.odd?
    (self[(size / 2) - 1] + self[size / 2]) / 2.0
  end
end
