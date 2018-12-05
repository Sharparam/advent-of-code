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
  @a.splice: 1;
}

my @ords = 'input.txt'.IO.slurp.chomp.comb>>.ord;
my @part1 = react(@ords);
say "Part 1: {@part1.elems}";

my $part2 = ('A'.ord..'Z'.ord).map(-> $o { react(@part1.grep({ $_ != $o && $_ != ($o + 32) })).elems }).min;
say "Part 2: {$part2}"
