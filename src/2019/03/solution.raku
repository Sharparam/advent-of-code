#!/usr/bin/env raku

use v6.d;
use fatal;

class Vector {
  has Int $.x;
  has Int $.y;

  method new(Int $x, Int $y) {
    self.bless(x => $x, y => $y);
  }

  method Str {
    "Vector<x = $.x, y = $.y>"
  }

  method WHICH() {
    ValueObjAt.new("Vector|$!x|$!y")
  }
}

sub vec(Int $a, Int $b --> Vector) { Vector.new($a, $b) }
multi sub infix:<+>(Vector $a, Vector $b --> Vector) {
  vec($a.x + $b.x, $a.y + $b.y)
}

sub dist(Vector $v1, Vector $v2) {
  ($v1.x - $v2.x).abs + ($v1.y - $v2.y).abs
}

my @paths = (@*ARGS[0] || 'input.txt').IO.lines».trim».&{ .split(',').eager };

my Vector $origin = vec(0, 0);
my @visited = (SetHash.new, SetHash.new);
my %intersections{Vector};
my @first := @paths[0];
my @second := @paths[1];
my Vector $pos = $origin.clone();

enum Dir <L D U R>;

sub make-vel(Dir $dir --> Vector) {
  given $dir {
    when L { vec(-1, 0) }
    when D { vec(0, -1) }
    when U { vec(0, 1) }
    when R { vec(1, 0) }
  }
}

for @first -> $op {
  my Dir $dir = Dir::{$op.substr(0, 1)};
  my Int $steps = $op.substr(1).Int;
  my Vector $vel = make-vel $dir;

  for ^$steps -> $n {
    $pos += $vel;
    @visited[0]{$pos}++;
  }
}

$pos = $origin.clone();

my Int $second-steps = 0;
for @second -> $op {
  my Dir $dir = Dir::{$op.substr(0, 1)};
  my Int $steps = $op.substr(1).Int;
  my Vector $vel = make-vel $dir;

  for ^$steps -> $n {
    $second-steps++;
    $pos += $vel;
    @visited[1]{$pos}++;
    if @visited[0]{$pos} && !%intersections{$pos} {
      %intersections{$pos} = { second-steps => $second-steps };
    }
  }
}

$pos = $origin.clone();

my Int $first-steps = 0;
for @first -> $op {
  my $dir = Dir::{$op.substr(0, 1)};
  my $steps = $op.substr(1).Int;
  my $vel = make-vel $dir;

  for ^$steps -> $n {
    $first-steps++;
    $pos += $vel;
    if @visited[1]{$pos} {
      %intersections{$pos}<first-steps> ||= $first-steps;
      my $fs = %intersections{$pos}<first-steps>;
      my $ss = %intersections{$pos}<second-steps>;
      %intersections{$pos}<sum-steps> = $fs + $ss;
    }
  }
}

my @dists = %intersections.keys».&{ dist($origin, $_) };
my $part1 = @dists.min;

say "Part 1: $part1";

my $step-counts = %intersections.values»<sum-steps>;
my $part2 = $step-counts.min;

say "Part 2: $part2";
