#!/usr/bin/env raku

my (@left, @right) := [Z] lines.map(*.words».Int);
my %counts is default(0) = @right.Bag;

say [+] (@left.sort Z- @right.sort).map(*.abs);
say [+] @left.map: { $_ * %counts{$_} };
