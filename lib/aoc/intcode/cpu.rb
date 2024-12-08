# frozen_string_literal: true

module AoC
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
        9 => :modrel,
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
        eq: 3,
        modrel: 1
      }.tap { |h| h.default = 0 }.freeze

      MODES = {
        0 => :addr,
        1 => :immediate,
        2 => :relative
      }.freeze

      attr_reader :memory, :output, :input

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

      def debug!(enabled)
        @debug = enabled
        self
      end

      def load!(file)
        if file.is_a? Array # rubocop:disable Style/ConditionalAssignment
          @program = file
        else
          @program = File.read(file).split(',').map(&:to_i)
        end

        @memory = @program.dup
        self
      end

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

      def print_output!(enabled)
        @print_output = enabled
        self
      end

      def clear_output!
        @output.clear
      end

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

      def reset!
        @memory = @program.dup
        @ip = 0
        @input = Queue.new
        @output = []
        self
      end

      def running?
        @running == true
      end

      def halted?
        @halted == true
      end

      def dup
        CPU.new @program.dup, @print_output, @debug, @memory.dup, @ip, @relative_base
      end

      private

      def add
        a = get_arg 1
        print ', ' if @debug
        b = get_arg 2
        print ', ' if @debug
        addr = get_addr 3
        puts if @debug
        @memory[addr] = a + b
      end

      def mult
        a = get_arg 1
        print ', ' if @debug
        b = get_arg 2
        print ', ' if @debug
        addr = get_addr 3
        puts if @debug
        @memory[addr] = a * b
      end

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

      def write
        val = get_arg 1
        puts if @debug
        output << val
        puts val if @print_output
      end

      def jnz
        a = get_arg 1
        print ', ' if @debug
        addr = get_arg 2
        puts if @debug

        return if a == 0
        @ip = addr
        :jumped
      end

      def jz
        a = get_arg 1
        print ', ' if @debug
        addr = get_arg 2
        puts if @debug

        return unless a == 0

        @ip = addr
        :jumped
      end

      def lt
        a = get_arg 1
        print ', ' if @debug
        b = get_arg 2
        print ', ' if @debug
        addr = get_addr 3
        puts if @debug

        @memory[addr] = a < b ? 1 : 0
      end

      def eq
        a = get_arg 1
        print ', ' if @debug
        b = get_arg 2
        print ', ' if @debug
        addr = get_addr 3
        puts if @debug

        @memory[addr] = a == b ? 1 : 0
      end

      def modrel
        amount = get_arg 1
        puts if @debug

        @relative_base += amount
      end

      def halt
        @running = false
        @halted = true
        puts if @debug
      end

      def read_mem(addr)
        @memory[addr] || 0
      end

      def get_opcode # rubocop:disable Naming/AccessorMethodName
        read_mem(@ip) % 100
      end

      def get_mode(pos)
        MODES[(read_mem(@ip) / (10**(pos + 1))) % 10]
      end

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
