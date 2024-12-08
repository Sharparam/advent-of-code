#!/usr/bin/env ruby
# frozen_string_literal: true

class CPU
    def initialize; @r = Hash.new(0) end
    def inc(v) v end
    def dec(v) -v end
    def run(text) eval text end
    def method_missing(s, *a) (@r[s] += a[0].to_i).tap { |v| @h = v if @h.nil? || @h < v } end
end

cpu = CPU.new
cpu.run $<.read
puts cpu.instance_variable_get('@r').values.max
puts cpu.instance_variable_get('@h')
