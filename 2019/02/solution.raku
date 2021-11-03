#!/usr/bin/env raku
use v6.d;

my @program = slurp('input.txt').split(',')».Int;

sub run(@program is copy, Int $noun, Int $verb) {
  @program[1] = $noun;
  @program[2] = $verb;

  my Int $pc = 0;

  loop {
    my $opcode = @program[$pc];
    given $opcode {
      when 1 {
        my $a = @program[$pc + 1];
        my $b = @program[$pc + 2];
        my $c = @program[$pc + 3];
        @program[$c] = @program[$a] + @program[$b];
        $pc += 4;
      }

      when 2 {
        my $a = @program[$pc + 1];
        my $b = @program[$pc + 2];
        my $c = @program[$pc + 3];
        @program[$c] = @program[$a] * @program[$b];
        $pc += 4;
      }

      last when 99;
    }
  }

  return @program;
}

my @part1 = run @program, 12, 2;
say "Part 1: {@part1[0]}";

constant PART2_TARGET = 19690720;

my @part2 = ([X] (0...99) xx 2).first: -> ($n, $v) {
  (run @program, $n, $v)[0] == PART2_TARGET
};

say "Part 2: {100 * @part2[0] + @part2[1]}";
