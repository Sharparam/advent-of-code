#!/usr/bin/env ruby
# frozen_string_literal: true

puts ARGF.readlines.reduce([0, 0]) { |a, e|
  e =~ /(\d+)-(\d+) (.): (.+)/
  n, m = $1.to_i, $2.to_i
  a[0] += 1 if $4.count($3).between?(n, m)
  a[1] += 1 if ($4[n - 1] == $3) ^ ($4[m - 1] == $3)
  a
}
