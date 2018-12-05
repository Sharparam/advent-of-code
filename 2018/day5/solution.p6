#!/usr/bin/env perl6
use v6;

sub react(@o) {
  my @a = [0];
  for @o {
    if (@a[*-1] - $_).abs == 32 {
      @a.pop;
    } else {
      @a.push: $_;
    }
  }
  @a.elems - 1;
}

my @ords = 'input.txt'.IO.slurp.chomp.comb>>.ord;
say "Part 1: {react(@ords)}";

my $part2 = ('A'.ord..'Z'.ord).map(-> $o { react(@ords.grep({ $_ != $o && $_ != ($o + 32) })) }).min;
say "Part 2: {$part2}"
