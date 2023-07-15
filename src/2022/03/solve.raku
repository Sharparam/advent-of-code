#!/usr/bin/env raku

use v6.d;

constant %prios = (|('a'..'z'), |('A'..'Z')).kv.map: { $^v => $^k + 1 };
my @contents = lines().map: { .chomp.comb.map: { %prios{$_} } }

@contents.map({ ([(&)] .rotor(.elems div 2)).keys[0] }).sum.say;
@contents.rotor(3).map({ .&[(&)].keys[0] }).sum.say;
