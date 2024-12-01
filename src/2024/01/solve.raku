#!/usr/bin/env raku

my (@left, @right) := [Z] lines».words».Int;
my %counts is default(0) = @right.Bag;

say [+] (@left.sort Z- @right.sort)».abs;
say [+] @left Z* %counts{@left};
