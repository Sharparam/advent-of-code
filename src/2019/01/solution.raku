#!/usr/bin/env raku
use v6.d;

sub calc(Int $mass) {
  my Int $fuel = $mass div 3 - 2;
  $fuel <= 0 ?? 0 !! $fuel + calc($fuel)
}

my Int @masses = 'input.txt'.IO.lines».Int;

say "Part 1: {@masses».&{ $_ div 3 - 2 }.sum}";
say "Part 2: {@masses».&calc.sum}";
