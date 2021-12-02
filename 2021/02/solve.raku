#!/usr/bin/env raku

my $position = 0;
my $aim = 0;
my $depth = 0;

my @instructions = 'input'.IO.lines».&{ .split: ' ' };

for @instructions -> ($dir, $n) {
  given $dir {
    when 'forward' {
      $position += $n;
      $depth += $aim * $n;
    }
    when 'down' { $aim += $n }
    when 'up' { $aim -= $n }
  }
}

say $position * $aim;
say $position * $depth;
