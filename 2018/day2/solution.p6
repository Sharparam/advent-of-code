#!/usr/bin/env perl6
use v6;

my @ids = 'input.txt'.IO.lines;

my $twos = 0;
my $threes = 0;

for @ids {
    my %counts = reduce({ $^a{$^b}++; $^a }, Hash.new, |.comb);
    $twos++ if 2 ∈ %counts.values;
    $threes++ if 3 ∈ %counts.values;
}

say "Part 1: {$twos * $threes}";
