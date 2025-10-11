#!/usr/bin/env ruby
# frozen_string_literal: true

class Elf
  attr_reader :id

  attr_accessor :previous, :next

  def initialize(id)
    @id = id
  end

  def delete!
    @next.previous = @previous
    @previous.next = @next
  end
end

def make_elves(count)
  elves = count.times.map { |i| Elf.new(i + 1) }
  elves.each.with_index do |elf, i|
    elf.previous = elves[(i - 1) % count]
    elf.next = elves[(i + 1) % count]
  end
  elves
end

elves = make_elves $stdin.readline.strip.to_i

SIZE = elves.size

start = elves.first

while start.next != start
  start.next.delete!
  start = start.next
end

puts "(1) #{start.id}"

elves = make_elves SIZE

start = elves.first
mid = elves[SIZE / 2]

SIZE.times do |i|
  mid.delete!
  mid = mid.next
  mid = mid.next if (SIZE - i).odd?
  start = start.next
end

puts "(2) #{start.id}"
