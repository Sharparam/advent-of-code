#!/usr/bin/env perl6
use v6;

my @coords = 'input.txt'.IO.lines>>.&{ .split(', ')>>.Int };

my @xs = @coords>>[0];
my @ys = @coords>>[1];
my ($xmin, $xmax, $ymin, $ymax) = @xs.min, @xs.max, @ys.min, @ys.max;

my @counts = 0 xx +@coords;
my $invalids = False xx +@coords;

my $part2 = 0;

for $xmin..$xmax -> $x {
  for $ymin..$ymax -> $y {
    my $x_edge = $x == $xmin || $x == $xmax;
    my $y_edge = $y == $ymin || $y == $ymax;

    my $best_i = Nil;
    my $best_dist = Inf;
    my $dist_total = 0;

    for @coords.kv -> $i, ($cx, $cy) {
      my $dist = abs($x - $cx) + abs($y - $cy);
      if $dist < $best_dist {
        $best_dist = $dist;
        $best_i = $i;
      } elsif $dist == $best_dist {
        $best_i = Nil;
      }
      $dist_total += $dist;
    }

    $part2 += 1 if $dist_total < 10000;

    next unless $best_i;

    if $x_edge || $y_edge {
      @invalids[$best_i] = True;
    } else {
      @counts[$best_i] += 1;
    }
  }
}

say "Part 1: {(@counts Z @invalids).grep({! .[1] })>>[0].max}";
say "Part 2: {$part2}";
