#!/usr/bin/env perl6
use v6;

my @d = 'input.txt'.IO.lines>>.Int;
say "Part 1: {[+] @d}";

my $h = SetHash.new(0);

my $f = ([\+] (^Inf).map({ @d[$_ % @d.elems] })).first({ $h{$_}++ });
say "Part 2: $f";
