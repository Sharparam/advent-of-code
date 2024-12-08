#!/usr/bin/env ruby
# frozen_string_literal: true

list = (0..255).to_a
index = 0
skip = 0

$<.readline.split(',').map(&:to_i).each do |length|
    stop = index + length - 1

    if stop < list.size
        list.insert index, *list.slice!(index..stop).reverse
    else
        end_index = list.size - 1
        stop %= list.size
        reversed = list.slice!(index, length).push(*list.slice!(0..stop)).reverse
        list.push *reversed[0..end_index - index]
        list.unshift *reversed[end_index - index + 1..-1]
    end

    index = (index + length + skip) % list.size
    skip += 1
end

p list.take(2).reduce(&:*)
