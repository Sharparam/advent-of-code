#!/usr/bin/env raku
use v6.d;

my @pairs = lines()».&{ .chomp.split(',')».&{ Range.new(|.split('-')».Int) } }

sub intersects(Range $a, Range $b --> Bool) { $a.min <= $b.max && $b.min <= $a.max }

say [+] @pairs.map: {
  my ($a, $b) = $_[0], $_[1];
  $a ~~ $b || $b ~~ $a
};
say [+] @pairs.map: { intersects(|$_) };
