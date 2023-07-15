#!/usr/bin/env ruby

input = File.read('input.txt').chomp
ords = input.chars.map(&:ord)

def react(os)
  res = [0]

  os.each do |o|
    if res[-1] ^ o == 32
      res.pop
    else
      res << o
    end
  end

  res[1..-1]
end

part1 = react ords
puts "Part 1: #{part1.size}"

exit

part2 = (?a.ord..?z.ord).map { |l| react(part1.reject { |e| e == l || e == l + 32 }).size }.min
puts "Part 2: #{part2}"
