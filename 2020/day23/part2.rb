#!/usr/bin/env ruby

DEBUG = true

MAX_VALUE = 1_000_000
ITERATIONS = 10_000_000

class LinkedList
  attr_reader :head, :min, :max

  def initialize
    @head = nil # only used during initial construction
    @tail = nil # only used during initial construction
    @min = nil
    @max = nil
    @value_node_map = {}
  end

  def find(value)
    @value_node_map[value]
  end

  def append(value)
    if head
      node = Node.new value, head
      @min = node if @min.nil? || @min.value > node.value
      @max = node if @max.nil? || @max.value < node.value
      @value_node_map[value] = node
      @tail.next = node
      @tail = node
    else
      @head = Node.new value
      @tail = head
      head.next = head
      @min = head
      @max = head
      @value_node_map[value] = head
    end
  end

  def append_after(node, from)
    nxt = node.next
    node.next = from
    n = node
    while n = n.next
      @min = n if n.value < @min.value
      @max = n if n.value > @max.value
      @value_node_map[n.value] = n
      if n.next.nil?
        n.next = nxt
        break
      end
    end

    from
  end

  def slice!(from, count)
    slice_start = from.next

    n = from
    count.times do
      n = n.next
      if n.value == @min.value
        @min = @value_node_map[n.value + 1]
      elsif n.value == @max.value
        @max = @value_node_map[n.value - 1]
      end
      @value_node_map.delete n.value
    end

    from.next = n.next
    n.next = nil

    slice_start
  end
end

class Node
  attr_accessor :next
  attr_reader :value

  def initialize(value, nxt = nil)
    @value = value
    @next = nxt
  end
end

input = (ARGV[0] || '792845136')

cups = LinkedList.new

input.chars.map(&:to_i).each { cups.append _1 }

max_cup = cups.max.value
(max_cup + 1..MAX_VALUE).each { cups.append _1 }

current = cups.head

ITERATIONS.times do |t|
  threshold = t % 100_000 == 0
  puts t if DEBUG && threshold
  slice = cups.slice! current, 3

  dest_value = current.value - 1
  dest = cups.find dest_value
  while dest.nil?
    dest_value -= 1
    dest_value = cups.max.value if dest_value < cups.min.value
    dest = cups.find dest_value
  end

  cups.append_after dest, slice

  current = current.next
end

one = cups.find 1
first = one.next
second = first.next
result = first.value * second.value

puts result
