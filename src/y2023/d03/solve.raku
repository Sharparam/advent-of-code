#!/usr/bin/env raku

class Pos {
  has Int $.x;
  has Int $.y;

  method new(Int $x, Int $y) {
    self.bless(:$x, :$y);
  }

  method around(Pos $start, Pos $stop --> Bool) {
    $start.x - 1 <= $!x <= $stop.x + 1 && $start.y - 1 <= $!y <= $stop.y + 1
  }
}

my @numbers = [];
my @num = [];
my @symbols = [];

sub add-num(Int $startx, Int $stopx, Int $y) {
  @numbers.push: %(value => @num.join.Int, start => Pos.new($startx, $y), stop => Pos.new($stopx, $y));
  @num = [];
}

$*ARGFILES.chomp = False;

for lines.kv -> $row, $line {
  my $x = 0;
  for $line.comb.kv -> $col, $char {
    given $char {
      when '.' {
        add-num $x, $col - 1, $row if @num;
      }
      when /\d/ {
        $x = $col unless @num;
        @num.push: $char;
      }
      default {
        add-num $x, $col - 1, $row if @num;
        @symbols.push: %(value => $char, pos => Pos.new($col, $row)) unless $char eq "\n";
      }
    }
  }
}

my $part1 = 0;

for @numbers -> $number {
  if @symbols.grep(*<pos>.around($number<start>, $number<stop>)) {
    $part1 += $number<value>;
  }
}

say $part1;

my @gears = @symbols.grep: { $_<value> eq "*" }

my $part2 = 0;

for @gears -> $gear {
  my @nums = @numbers.grep: { $gear<pos>.around($_<start>, $_<stop>) }
  if @nums.elems == 2 {
    $part2 += @nums[0]<value> * @nums[1]<value>;
  }
}

say $part2;
