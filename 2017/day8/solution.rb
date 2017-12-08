#!/usr/bin/env ruby

class CPU
    attr_reader :highest

    def initialize
        @regs = Hash.new(0)
    end

    def inc(value) value end
    def dec(value) -value end
    def run(text) eval text end

    def method_missing(symbol, *args)
        (@regs[symbol] += args.first.to_i).tap do |val|
            @highest = val if @highest.nil? || @highest < val
        end
    end

    def max_value
        @regs.values.max
    end
end

cpu = CPU.new
cpu.run $<.read
puts cpu.max_value
puts cpu.highest
