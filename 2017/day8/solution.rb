#!/usr/bin/env ruby

class CPU
    attr_reader :high, :regs

    def initialize; @regs = Hash.new(0) end
    def inc(value) value end
    def dec(value) -value end
    def run(text) eval text end

    def method_missing(sym, *args)
        (@regs[sym] += args[0].to_i).tap { |v| @high = v if @high.nil? || @high < v }
    end
end

cpu = CPU.new
cpu.run $<.read
puts cpu.regs.values.max
puts cpu.high
