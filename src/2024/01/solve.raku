#!/usr/bin/env raku

my @lines = [Z] lines.map(*.split(/\s+/)».Int);
my @left := @lines[0];
my @right := @lines[1];

my %counts is default(0);
%counts{$_}++ for @right;

say [+] (@left.sort Z- @right.sort).map(*.abs);
say [+] @left.map: { $_ * %counts{$_} };
