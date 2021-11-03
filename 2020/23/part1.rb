#!/usr/bin/env ruby

DEBUG = false

def debug(str)
  puts str if DEBUG
end

input = (ARGV[0] || '792845136')

cups = input.chars.map(&:to_i)
current = cups.first

debug cups.join

100.times do |t|
  debug "-- move #{t + 1} --"
  if DEBUG
    print 'cups: '
    cups.each do |cup|
      if cup == current
        print "(#{cup}) "
      else
        print "#{cup} "
      end
    end
    puts
  end
  current_i = cups.index current
  picked_up = cups.slice! current_i + 1, 3
  picked_up += cups.shift 3 - picked_up.size if picked_up.size < 3
  debug "pick up: #{picked_up.join ', '}"
  dest_i = nil
  dest_v = current - 1
  while dest_i.nil?
    dest_i = cups.index dest_v
    dest_v -= 1
    dest_v = cups.max if dest_v < cups.min
  end
  debug "destination: #{cups[dest_i]}"
  cups.insert dest_i + 1, *picked_up
  current = cups[(cups.index(current) + 1) % cups.size]
  debug ''
  debug cups.join
end

debug '-' * 9

one_i = cups.index 1
after = cups[one_i + 1..-1]
before = cups[0...one_i]
combined = after + before

puts combined.join
