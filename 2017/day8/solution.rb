#!/usr/bin/env ruby

class CPU
    attr_reader :highest, :regs

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
end

cpu = CPU.new
cpu.run $<.read
puts cpu.regs.values.max
puts cpu.highest
