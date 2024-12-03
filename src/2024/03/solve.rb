#!/usr/bin/env ruby
# frozen_string_literal: true

class Computer
  def initialize(advanced = false)
    @advanced = advanced
    @enabled = true
  end

  def MUL(x, y)
    @enabled ? x * y : 0
  end

  def DO()
    return 0 unless @advanced
    @enabled = true
    0
  end

  def DONT()
    return 0 unless @advanced
    @enabled = false
    0
  end
end

instrs = ARGF.read.upcase.delete(?').scan(/MUL\(\d+,\d+\)|DO(?:NT)?\(\)/)

puts Computer.new.then { |c| instrs.sum { c.instance_eval _1 } }
puts Computer.new(true).then { |c| instrs.sum { c.instance_eval _1 } }
