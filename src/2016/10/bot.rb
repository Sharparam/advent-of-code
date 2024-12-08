# frozen_string_literal: true

class Bot
  attr_accessor :high_target, :low_target

  def initialize
    @chips = []
    @known = []
  end

  def add(value)
    @chips << value
    @chips.sort!
    @known << value
  end

  def high
    @chips.pop
  end

  def low
    @chips.shift
  end

  def count
    @chips.size
  end

  def responsible?(low, high)
    @known.include?(low) && @known.include?(high)
  end
end
