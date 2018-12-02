#!/usr/bin/env perl6
use v6;

my @ids = 'input.txt'.IO.lines;

my $twos = 0;
my $threes = 0;

for @ids {
    my %counts = reduce({ $^a{$^b}++; $^a }, Hash.new, |$_.comb);
    $twos++ if 2 (elem) %counts.values;
    $threes++ if 3 (elem) %counts.values;
}

say "Part 1: {$twos * $threes}";
