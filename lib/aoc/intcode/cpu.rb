# frozen_string_literal: true

module AoC
  module Intcode
    # An Intcode CPU.
    class CPU
      # @return [Hash<Integer, Symbol>]
      OPS = {
        1 => :add,
        2 => :mult,
        3 => :read,
        4 => :write,
        5 => :jnz,
        6 => :jz,
        7 => :lt,
        8 => :eq,
        9 => :modrel,
        99 => :halt
      }.freeze

      # @return [Hash<Symbol, Integer>]
      ARG_COUNTS = {
        add: 3,
        mult: 3,
        read: 1,
        write: 1,
        jnz: 2,
        jz: 2,
        lt: 3,
        eq: 3,
        modrel: 1
      }.tap { |h| h.default = 0 }.freeze

      # @return [Hash<Integer, Symbol>]
      MODES = {
        0 => :addr,
        1 => :immediate,
        2 => :relative
      }.freeze

      # @return [Array<Integer>]
      attr_reader :memory

      # @return [Array<Integer>]
      attr_reader :output

      # @return [Queue]
      attr_reader :input

      # @param program [Array<Integer>]
      # @param print_output [Boolean]
      # @param debug [Boolean]
      # @param memory [Array<Integer>]
      # @param ip [Integer] Instruction pointer
      # @param rb [Integer] Relative base
      def initialize(program = nil, print_output = true, debug = false, memory = nil, ip = 0, rb = 0) # rubocop:disable Style/OptionalBooleanParameter
        @ip = ip
        @input = Queue.new
        @output = []
        @debug = debug
        @program = program&.dup
        @memory = memory || @program&.dup
        @halted = false
        @relative_base = rb
        @print_output = print_output
      end

      # @param enabled [Boolean]
      # @return [self]
      def debug!(enabled)
        @debug = enabled
        self
      end

      # @param file [Array<Integer>, String]
      # @return [self]
      def load!(file)
        if file.is_a? Array # rubocop:disable Style/ConditionalAssignment
          @program = file
        else
          @program = File.read(file).split(',').map(&:to_i)
        end

        @memory = @program.dup
        self
      end

      # @param value [Integer, String, Array<Integer, String>]
      # @return [self]
      def input!(value)
        case value
        when Array
          value.each { |v| input! v }
        when String
          value.chars.map(&:ord).each { |v| input! v }
        else
          @input.enq value
        end
        self
      end

      # @param enabled [Boolean]
      # @return [self]
      def print_output!(enabled)
        @print_output = enabled
        self
      end

      # @return [void]
      def clear_output!
        @output.clear
      end

      # @return [self]
      def run!
        @running = true

        while @running
          opcode = OPS[get_opcode]
          print '%4d: [%05d] %6s ' % [@ip, read_mem(@ip), opcode.to_s.upcase] if @debug
          result = send(opcode)
          @ip += 1 + ARG_COUNTS[opcode] unless result == :jumped || result == :block
        end

        self
      end

      # @return [self]
      def reset!
        @memory = @program.dup
        @ip = 0
        @input = Queue.new
        @output = []
        self
      end

      # @return [Boolean]
      def running?
        @running == true
      end

      # @return [Boolean]
      def halted?
        @halted == true
      end

      # @return [CPU]
      def dup
        CPU.new @program.dup, @print_output, @debug, @memory.dup, @ip, @relative_base
      end

      private

      # @return [void]
      def add
        a = get_arg 1
        print ', ' if @debug
        b = get_arg 2
        print ', ' if @debug
        addr = get_addr 3
        puts if @debug
        @memory[addr] = a + b
      end

      # @return [void]
      def mult
        a = get_arg 1
        print ', ' if @debug
        b = get_arg 2
        print ', ' if @debug
        addr = get_addr 3
        puts if @debug
        @memory[addr] = a * b
      end

      # @return [void]
      def read
        if @input.empty?
          @running = false
          puts '(BLOCK)' if @debug
          return :block
        end
        val = @input.deq
        addr = get_addr 1
        puts if @debug
        @memory[addr] = val
      end

      # @return [void]
      def write
        val = get_arg 1
        puts if @debug
        output << val
        puts val if @print_output
      end

      # @return [void]
      def jnz
        a = get_arg 1
        print ', ' if @debug
        addr = get_arg 2
        puts if @debug

        return if a == 0
        @ip = addr
        :jumped
      end

      # @return [void]
      def jz
        a = get_arg 1
        print ', ' if @debug
        addr = get_arg 2
        puts if @debug

        return unless a == 0

        @ip = addr
        :jumped
      end

      # @return [void]
      def lt
        a = get_arg 1
        print ', ' if @debug
        b = get_arg 2
        print ', ' if @debug
        addr = get_addr 3
        puts if @debug

        @memory[addr] = a < b ? 1 : 0
      end

      # @return [void]
      def eq
        a = get_arg 1
        print ', ' if @debug
        b = get_arg 2
        print ', ' if @debug
        addr = get_addr 3
        puts if @debug

        @memory[addr] = a == b ? 1 : 0
      end

      # @return [void]
      def modrel
        amount = get_arg 1
        puts if @debug

        @relative_base += amount
      end

      # @return [void]
      def halt
        @running = false
        @halted = true
        puts if @debug
      end

      # @param addr [Integer]
      # @return [Integer]
      def read_mem(addr)
        @memory[addr] || 0
      end

      # @return [Integer]
      def get_opcode # rubocop:disable Naming/AccessorMethodName
        read_mem(@ip) % 100
      end

      # @param pos [Integer]
      # @return [Symbol]
      def get_mode(pos)
        MODES[(read_mem(@ip) / (10**(pos + 1))) % 10]
      end

      # @param pos [Integer]
      # @return [Integer]
      def get_addr(pos)
        val = read_mem(@ip + pos)
        mode = get_mode pos

        if mode == :relative
          print "R#{val}=" if @debug
          val += @relative_base
          mode = :addr
        end

        print "##{val}" if mode == :addr && @debug

        val
      end

      # @param pos [Integer]
      # @return [Integer]
      def get_arg(pos)
        val = read_mem(@ip + pos)
        mode = get_mode pos

        if mode != :immediate
          addr = get_addr pos
          print '=' if @debug
          val = read_mem addr
        end

        print val if @debug
        val
      end
    end
  end
end
