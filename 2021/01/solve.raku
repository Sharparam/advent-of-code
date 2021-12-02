#!/usr/bin/env raku

my @nums = 'input'.IO.lines».Int;
for 1, 3 { say [+] @nums Z< @nums[$_..*] };
