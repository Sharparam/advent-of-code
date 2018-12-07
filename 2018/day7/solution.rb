#!/usr/bin/env ruby

require 'set'

class Node
  attr_accessor :value, :children, :parents

  def initialize(value, *parents)
    @value = value;
    @parents = Set.new(parents)
    @children = []
  end

  def root?; @parents.empty?; end
  def empty?; @children.empty?; end

  def depth
    c_depth
  end

  def to_s
    "#{@value}[#{@children.size}]"
  end

  def ==(other)
    @value == other&.value
  end

  def <=>(other)
    @value <=> other.value
  end

  private

  def c_depth(d = 0, parents = @parents)
    return d if parents.empty?
    parents.map { |p| c_depth d + 1, p.parents }.max
  end
end

nodes = Hash.new { |h, k| h[k] = Node.new k }

File.read('test.txt').scan(/^Step ([A-Z]).+step ([A-Z])/) do |s|
  parent = nodes[s[0]]
  child = nodes[s[1]]
  parent.children << child
  child.parents.add parent
end

alpha_nodes = nodes.sort_by { |(k, v)| k }.map(&:last)
part1_nodes = []

while alpha_nodes.any?
  alpha_nodes.each_with_index do |node, i|
    next if node.parents.any? { |p| alpha_nodes.include? p }
    part1_nodes << node
    alpha_nodes.delete_at i
    break
  end
end

puts "Part 1: #{part1_nodes.map(&:value).join}"

class Worker
  attr_reader :node

  def initialize(delay)
    @delay = delay
    @node = nil
    @started = -1
  end

  def done?(time)
    return true unless @node&.value
    time - @started >= @delay + @node.value.ord - '@'.ord
  end

  def set!(node, time)
    @node = node
    @started = time
  end

  def reset!
    @node = nil
    @started = -1
  end
end

class Processor
  attr_reader :new_order

  def initialize(todo, worker_count, delay)
    @todo = todo
    @worker_count = worker_count
    @workers = (1..@worker_count).map { Worker.new delay }
    @next_i = 0
    @new_order = []
    @time = 0
  end

  def run!
    while @todo.any? && @time < 10
      step!
      printf("%d %s %s\n", @time, @workers.map { |w| w.node&.value || '.' }.join, @new_order.map(&:value).join)
      @time += 1
    end
  end

  def step!
    @workers.each do |worker|
      next_node = get_next @next_i
      @next_i += 1
      worker.set!(next_node, @time) if next_node
      if worker.done? @time
        finish!(worker.node)
        worker.reset!
      end
    end
  end

  private

  def get_next(i)
    nxt = @todo[i]
    return nil if nxt.parents.any? { |p| @todo.include? p }
    nxt
  end

  def finish!(n)
    @todo.delete n
  end
end

processor = Processor.new(part1_nodes, 2, 0)
processor.run!

puts "Part 2: #{processor.new_order.map(&:value).join}"

# require 'pry'
# binding.pry
