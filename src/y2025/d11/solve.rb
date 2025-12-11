#!/usr/bin/env ruby
# frozen_string_literal: true

DEVICES = ARGF.to_h { |line|
  device, outputs = line.split(':')
  outputs = outputs.split
  [device.strip.to_sym, outputs.map { _1.strip.to_sym }]
}

MEM = {} # rubocop:disable Style/MutableConstant

def count_paths(current, target)
  key = [current, target]
  return MEM[key] if MEM.key? key
  return 1 if current == target

  return 0 unless DEVICES.key? current
  sum = DEVICES[current].sum { count_paths(_1, target) }
  MEM[key] = sum
  sum
end

def count_paths2(current, target, flag = nil)
  key = [current, target, flag]
  return MEM[key] if MEM.key? key
  return flag == :both ? 1 : 0 if current == target

  if current == :dac
    flag = flag == :fft ? :both : :dac
  elsif current == :fft
    flag = flag == :dac ? :both : :fft
  end

  sum = DEVICES[current].sum { count_paths2(_1, target, flag) }
  MEM[key] = sum
  sum
end

puts count_paths(:you, :out) if DEVICES.key? :you
puts count_paths2(:svr, :out) if DEVICES.key? :svr
