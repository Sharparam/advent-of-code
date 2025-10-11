#!/usr/bin/env raku

use v6.d;

my @lines = lines();

constant %outcomes =
  AX => 0, BY => 0, CZ => 0,
  AY => 1, AZ => -1,
  BX => -1, BZ => 1,
  CX => 1, CY => -1;

constant %scores := :{ -1 => 0, 0 => 3, 1 => 6 };

constant %resolves =
  A => :{ -1 => 'Z', 0 => 'X', 1 => 'Y' },
  B => :{ -1 => 'X', 0 => 'Y', 1 => 'Z' },
  C => :{ -1 => 'Y', 0 => 'Z', 1 => 'X' };

sub score { %scores{%outcomes{"$^a$^b"}} + ($b.ord - 87) }
sub resolve { score($^a, %resolves{$a}{$^b.ord - 89}) }

say [+] @lines».&{ score(|.split(' ')) }
say [+] @lines».&{ resolve(|.split(' ')) }
