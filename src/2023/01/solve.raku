#!/usr/bin/env raku

my @lines = lines();

say [+] @lines».comb(/\d/).map({ $_[0] ~ $_[*-1] });

my %map = :1one, :2two, :3three, :4four, :5five, :6six, :7seven, :8eight, :9nine;
my @words = %map.keys;
my $re = /\d || @words/;

my @pairs = @lines.map({ .match($re, :overlap).map({ %map{$_} // $_ }) });

say [+] @pairs.map: { $_[0] ~ $_[*-1] };
