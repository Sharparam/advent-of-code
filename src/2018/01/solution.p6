#!/usr/bin/env perl6
use v6;

my @d = 'input.txt'.IO.lines>>.Int;
say "Part 1: {[+] @d}";
say "Part 2: {([\+] |@d xx *).repeated.first}";
