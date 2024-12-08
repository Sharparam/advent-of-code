#!/usr/bin/env ruby
# frozen_string_literal: true

MULTIPLIERS = [0, 1, 0, -1]
DEBUG = ENV['DEBUG']

def mult(index, out_index)
  MULTIPLIERS[((index + 1) / (out_index + 1)) % 4]
end

def digit(n)
  n.abs % 10
end

def phase(data)
  data.size.times.map { |o| digit data.each_with_index.sum { |n, i| n * mult(i, o) } }
end

arg = ARGV.first
iterations = 100

case arg
when nil
  input = DATA.read
when '--'
  input = STDIN.readline
else
  input = File.read(arg)
end

data = input.scan(/\d/).map(&:to_i)
data2 = data * 10_000

def solve(data, iterations)
  root_start = Process.clock_gettime(Process::CLOCK_MONOTONIC)
  iterations.times do |i|
    start = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    data = phase data
    finish = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    puts "Phase #{i + 1} in #{finish - start}s" if DEBUG
  end
  root_finish = Process.clock_gettime(Process::CLOCK_MONOTONIC)
  puts "#{root_finish - root_start}s to solve"

  data
end

part1 = solve data, 100
puts "Part 1: #{part1.take(8).join}"

def solve2(data, iterations, offset)
  root_start = Process.clock_gettime(Process::CLOCK_MONOTONIC)
  iterations.times do |i|
    start = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    partial_sum = data[offset..-1].sum
    (offset...data.size).to_a.each do |e|
      number = partial_sum
      partial_sum -= data[e]
      data[e] = digit number
    end
    finish = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    puts "Phase #{i + 1} in #{finish - start}s" if DEBUG
  end
  root_finish = Process.clock_gettime(Process::CLOCK_MONOTONIC)
  puts "#{root_finish - root_start}s to solve"

  data
end

part2_offset = data2.take(7).join.to_i
puts "Part 2 has #{data2.size} digits"
puts "Offset for part 2: #{part2_offset}"
part2 = solve2 data2, 100, part2_offset
puts "Part 2: #{data2.drop(part2_offset).take(8).join}"

return unless DEBUG

require 'pry'
binding.pry

__END__
59766299734185935790261115703620877190381824215209853207763194576128635631359682876612079355215350473577604721555728904226669021629637829323357312523389374096761677612847270499668370808171197765497511969240451494864028712045794776711862275853405465401181390418728996646794501739600928008413106803610665694684578514524327181348469613507611935604098625200707607292339397162640547668982092343405011530889030486280541249694798815457170337648425355693137656149891119757374882957464941514691345812606515925579852852837849497598111512841599959586200247265784368476772959711497363250758706490540128635133116613480058848821257395084976935351858829607105310340
