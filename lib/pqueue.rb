# frozen_string_literal: true
class PriorityQueue
  include Enumerable

  class Element
    include Comparable

    attr_accessor :value, :priority

    def initialize(value, priority)
      @value, @priority = value, priority
    end

    def <=>(other)
      @priority <=> other.priority
    end
  end

  def initialize
    @elements = [nil]
  end

  def size
    @elements.size - 1
  end

  def each(&block)
    @elements.drop(1).each(&block)
  end

  def empty?
    size == 0
  end

  def <<(element)
    @elements << element
    bubble_up(@elements.size - 1)
  end

  def enqueue(value, priority = nil)
    value = Element.new(value, priority) if priority
    self << value
  end

  def dequeue
    exchange(1, @elements.size - 1)
    element = @elements.pop.tap { bubble_down(1) }
    return element.value if element.is_a? Element
    element
  end

  private

  def bubble_up(index)
    parent_index = index / 2
    return if index <= 1
    return if @elements[parent_index] <= @elements[index]
    exchange(index, parent_index)
    bubble_up(parent_index)
  end

  def bubble_down(index)
    child_index = index * 2
    max_index = @elements.size - 1
    return if child_index > max_index
    not_last_element = child_index < max_index
    left_element = @elements[child_index]
    right_element = @elements[child_index + 1]
    child_index += 1 if not_last_element && right_element < left_element
    return if @elements[index] <= @elements[child_index]
    exchange(index, child_index)
    bubble_down(child_index)
  end

  def exchange(source, target)
    @elements[source], @elements[target] = @elements[target], @elements[source]
  end
end
