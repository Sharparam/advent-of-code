#!/usr/bin/env perl6
use v6;

my %coords is default(Array);

grammar AoC::Input {
  token TOP { [ <entry> <.ws>? ]+ }
  token entry {
    '#' <id> <.ws> '@' <.ws> <position> ':' <.ws> <size>
    {
      for ^$<size><width>.made -> $xo {
        for ^$<size><height>.made -> $yo {
          my $x = $<position><x> + $xo;
          my $y = $<position><y> + $yo;
          %coords{"$x,$y"}.push: $<id>.made;
        }
      }
    }
  }
  token id { \d+ { make +$/ } }
  token position { $<x>=<num> ',' $<y>=<num> }
  token size { $<width>=<num> x $<height>=<num> }
  token num { \d+ { make +$/ } }
}

my $matches = AoC::Input.parsefile('input.txt');
say "Part 1: {%coords.values.grep({ $_ > 1 }).elems}";
