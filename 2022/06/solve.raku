#!/usr/bin/env raku
use v6.d;

my @input = lines.head.chomp.comb;

for 4, 14 -> \n {
  say @input.rotor(::n => -n + 1).pairs.first({ +$_.value.unique == n }).key + n;
}
