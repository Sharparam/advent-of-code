#!/usr/bin/env ruby

DEBUG = false

class LinkedList
  attr_reader :head, :min, :max

  def initialize
    @head = nil
    @min = nil
    @max = nil
    @value_node_map = {}
  end

  def find(value)
    @value_node_map[value]
  end

  def append(value)
    if head
      node = Node.new value, tail, head
      @min = node if @min.nil? || @min.value > node.value
      @max = node if @max.nil? || @max.value < node.value
      @value_node_map[value] = node
      tail.next = node
      head.prev = node
    else
      @head = Node.new value
      @min = @head
      @max = @head
      @value_node_map[value] = @head
      head.next = head
      head.prev = head
    end
  end

  def append_after(node, from, to)
    node = find node unless node.is_a? Node
    fail "Could not find node to append after" unless node
    from.prev = nil
    to.next = nil
    @min = from if from.value < @min.value
    @max = from if from.value > @max.value
    @value_node_map[from.value] = from
    n = from
    while n = n.next
      @min = n if n.value < @min.value
      @max = n if n.value > @max.value
      @value_node_map[n.value] = n
    end
    nxt = node.next
    node.next = from
    from.prev = node
    nxt.prev = to
    to.next = nxt
    from
  end

  def slice!(from, to)
    prev = from.prev
    nxt = to.next
    prev.next = nxt
    nxt.prev = prev
    from.prev = nil
    to.next = nil
    recalc_min = from.value <= @min.value
    recalc_max = from.value >= @max.value
    @value_node_map.delete from.value
    node = from
    while node = node.next
      recalc_min ||= node.value <= @min.value
      recalc_max ||= node.value >= @max.value
      @value_node_map.delete node.value
    end

    @min = @value_node_map.values.min_by(&:value) if recalc_min
    @max = @value_node_map.values.max_by(&:value) if recalc_max

    @head = nxt if from.value == head.value || to.value == head.value
    [from, to]
  end

  private

  def tail
    head&.prev
  end
end

class Node
  attr_writer :prev, :next
  attr_reader :value

  def initialize(value, prev = nil, nxt = nil)
    @value = value
    @next = nxt
    @prev = prev
  end

  def prev(count = 1)
    return self if count < 1
    return @prev if count == 1
    @prev.prev count - 1
  end

  def next(count = 1)
    return self if count < 1
    return @next if count == 1
    @next.next count - 1
  end
end

input = (ARGV[0] || '792845136')

cups = LinkedList.new

input.chars.map(&:to_i).each { cups.append _1 }

max_cup = cups.max.value
(max_cup + 1..1_000_000).each { cups.append _1 }

current = cups.head

10_000_000.times do |t|
  threshold = t % 100_000 == 0
  puts t if DEBUG && threshold
  slice_start, slice_stop = cups.slice! current.next, current.next(3)

  dest_value = current.value - 1
  dest = cups.find dest_value
  while dest.nil?
    dest_value -= 1
    dest_value = cups.max.value if dest_value < cups.min.value
    dest = cups.find dest_value
  end

  cups.append_after dest, slice_start, slice_stop

  current = current.next
end

one = cups.find 1
first = one.next
second = first.next
result = first.value * second.value

puts result
