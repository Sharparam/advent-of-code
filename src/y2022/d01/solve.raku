#!/usr/bin/env raku

use v6.d;

my @inventories = $*ARGFILES.slurp.split("\n\n")».&{ [+] .lines }.sort;

@inventories[*-1].say;
@inventories.tail(3).sum.say;
