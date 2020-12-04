#!/usr/bin/env ruby

groups = ARGF.read.split("\n\n")

req_fields = %w(byr iyr eyr hgt hcl ecl pid cid)

passports = groups.map do |g|
  fields = req_fields.map do |rf|
    [rf, $1.strip] if g =~ %r{#{rf}:(\S+)}
  end

  Hash[*fields.compact.flatten]
end

p1_req_fields = %w(byr iyr eyr hgt hcl ecl pid)

part1 = passports.count { |passport|
  p1_req_fields.all? { |rf| passport.key? rf }
}

puts part1

validators = {
  'byr' => -> (v) { v.to_i.between?(1920, 2002) },
  'iyr' => -> (v) { v.to_i.between?(2010, 2020) },
  'eyr' => -> (v) { v.to_i.between?(2020, 2030) },
  'hgt' => -> (v) {
    v =~ /^(\d+)(cm|in)$/ && $2 == 'cm' ? $1.to_i.between?(150, 193) : $1.to_i.between?(59, 76)
  },
  'hcl' => -> (v) { v =~ /^#[\da-f]{6}$/ },
  'ecl' => -> (v) { v =~ /^amb|blu|brn|gry|grn|hzl|oth$/ },
  'pid' => -> (v) { v =~ /^\d{9}$/ }
}

part2 = passports.count { |passport|
  p1_req_fields.all? { |rf| passport.key? rf } && validators.all? { |k, validator|
    validator.call(passport[k])
  }
}

puts part2
