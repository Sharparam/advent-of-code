# frozen_string_literal: true

require 'set'

module Intcode
  class CPU
    OPS = {
      1 => :add,
      2 => :mult,
      3 => :read,
      4 => :write,
      5 => :jnz,
      6 => :jz,
      7 => :lt,
      8 => :eq,
      99 => :halt
    }.freeze

    ARG_COUNTS = {
      add: 3,
      mult: 3,
      read: 1,
      write: 1,
      jnz: 2,
      jz: 2,
      lt: 3,
      eq: 3
    }.tap { |h| h.default = 0 }.freeze

    MODES = {
      0 => :addr,
      1 => :immediate
    }.freeze

    attr_reader :memory
    attr_reader :output

    def initialize(program = nil, debug = false)
      @ip = 0
      @input = Queue.new
      @output = []
      @debug = debug
      @program = program&.dup
      @memory = @program&.dup
      @halted = false
    end

    def debug!(enabled)
      @debug = enabled
      self
    end

    def load!(file)
      @program = File.read(file).split(',').map(&:to_i)
      @memory = @program.dup
      self
    end

    def input!(value)
      @input.enq value
      self
    end

    def run!
      @running = true

      while @running do
        opcode = OPS[get_opcode]
        print "#{@memory[@ip]}: #{opcode.to_s.upcase} " if @debug
        result = send(opcode)
        @ip += 1 + ARG_COUNTS[opcode] unless result == :jumped || result == :block
      end

      self
    end

    def reset!
      @memory = @program.dup
      @ip = 0
      @input = Queue.new
      @output = []
      self
    end

    def halted?
      @halted == true
    end

    def dup
      CPU.new @program, @debug
    end

    private

    def add
      a = get_arg 1
      print ", " if @debug
      b = get_arg 2
      print ", " if @debug
      addr = @memory[@ip + 3]
      puts "##{addr}" if @debug
      @memory[addr] = a + b
    end

    def mult
      a = get_arg 1
      print ", " if @debug
      b = get_arg 2
      print ", " if @debug
      addr = @memory[@ip + 3]
      puts "##{addr}" if @debug
      @memory[addr] = a * b
    end

    def read
      if @input.empty?
        @running = false
        puts "(BLOCK)" if @debug
        return :block
      end
      val = @input.deq
      addr = @memory[@ip + 1]
      puts  "##{addr}" if @debug
      @memory[addr] = val
    end

    def write
      val = get_arg 1
      puts if @debug
      output << val
      puts val
    end

    def jnz
      a = get_arg 1
      print ", " if @debug
      addr = get_arg 2
      puts if @debug

      return if a == 0
      @ip = addr
      :jumped
    end

    def jz
      a = get_arg 1
      print ", " if @debug
      addr = get_arg 2
      puts if @debug

      return unless a == 0

      @ip = addr
      :jumped
    end

    def lt
      a = get_arg 1
      print ", " if @debug
      b = get_arg 2
      print ", " if @debug
      addr = @memory[@ip + 3]
      puts "##{addr}" if @debug

      @memory[addr] = (a < b) ? 1 : 0
    end

    def eq
      a = get_arg 1
      print ", " if @debug
      b = get_arg 2
      print ", " if @debug
      addr = @memory[@ip + 3]
      puts "##{addr}" if @debug

      @memory[addr] = (a == b) ? 1 : 0
    end

    def halt
      @running = false
      @halted = true
      puts
    end

    def get_opcode
      @memory[@ip] % 100
    end

    def get_mode(pos)
      MODES[(@memory[@ip] / (10 ** (pos + 1))) % 2]
    end

    def get_arg(pos)
      val = @memory[@ip + pos]
      mode = get_mode pos

      if mode == :addr
        print "##{val}=" if @debug
        val = @memory[val]
      end

      print val if @debug
      val
    end
  end
end
