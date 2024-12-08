#!/usr/bin/env ruby
# frozen_string_literal: true

groups = ARGF.read.split("\n\n")

fields = %w[byr iyr eyr hgt hcl ecl pid]

passports = groups.map do |g|
  Hash[*fields.filter_map { |f| [f, $1.strip] if g =~ %r{#{f}:(\S+)} }.flatten]
end

puts passports.count { |p| fields.all?(&p.method(:key?)) }

validators = {
  'byr' => ->v { v.to_i.between?(1920, 2002) },
  'iyr' => ->v { v.to_i.between?(2010, 2020) },
  'eyr' => ->v { v.to_i.between?(2020, 2030) },
  'hgt' => ->v {
    v =~ /^(\d+)(cm|in)$/ && $2 == 'cm' ? $1.to_i.between?(150, 193) : $1.to_i.between?(59, 76)
  },
  'hcl' => /^#[\da-f]{6}$/,
  'ecl' => /^amb|blu|brn|gry|grn|hzl|oth$/,
  'pid' => /^\d{9}$/
}

puts passports.count { |p| validators.all? { |k, v| v === p[k] } }
